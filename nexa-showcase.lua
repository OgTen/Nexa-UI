local NEXA_SOURCE = "https://raw.githubusercontent.com/OgTen/Nexa-UI/refs/heads/main/nexa-ui.lua"

local function isNexaLibrary(value)
    return type(value) == "table"
        and type(value.CreateWindow) == "function"
        and type(value.AddTab) == "function"
        and type(value.Notify) == "function"
end

local function findExportedNexa()
    local env = type(getgenv) == "function" and getgenv() or nil

    local candidates = {}
    if env then
        candidates[#candidates + 1] = env.Nexa
        candidates[#candidates + 1] = env.UI
        candidates[#candidates + 1] = env.DrawingUI
    end

    candidates[#candidates + 1] = rawget(_G, "Nexa")
    candidates[#candidates + 1] = rawget(_G, "UI")
    candidates[#candidates + 1] = rawget(_G, "DrawingUI")

    if type(shared) == "table" then
        candidates[#candidates + 1] = shared.Nexa
        candidates[#candidates + 1] = shared.UI
        candidates[#candidates + 1] = shared.DrawingUI
    end

    for _, candidate in ipairs(candidates) do
        if isNexaLibrary(candidate) then
            return candidate
        end
    end

    return nil
end

local function getNexa()

    local existing = findExportedNexa()
    if existing then
        return existing
    end

    if NEXA_SOURCE == "" then
        error("[Nexa Showcase] Nexa is not loaded and NEXA_SOURCE is empty.")
    end

    if type(loadstring) ~= "function" then
        error("[Nexa Showcase] This environment does not provide loadstring.")
    end

    local okHttp, source = pcall(function()
        return game:HttpGet(NEXA_SOURCE)
    end)
    if not okHttp then
        error("[Nexa Showcase] Failed to download Nexa: " .. tostring(source))
    end

    if type(source) ~= "string" or #source < 100 then
        error("[Nexa Showcase] Nexa download returned invalid/empty source.")
    end

    local chunk, compileError = loadstring(source)
    if not chunk then
        error("[Nexa Showcase] Nexa failed to compile: " .. tostring(compileError))
    end

    local okRun, returned = pcall(chunk)
    if not okRun then
        error("[Nexa Showcase] Nexa failed while executing: " .. tostring(returned))
    end

    if isNexaLibrary(returned) then
        return returned
    end

    local exported = findExportedNexa()
    if exported then
        return exported
    end

    error("[Nexa Showcase] Nexa executed successfully, but no compatible Library API was exported.")
end

local Nexa = getNexa()
local C = Color3.fromRGB

local Window = Nexa:CreateWindow({
    Title = "Nexa",
    Subtitle = "Complete UI Library Showcase",
    GameName = "Component Gallery",
    Width = 860,
    Height = 610,
    Theme = "Obsidian",
    Background = "particles",
	Opacity = 100,
    MenuKey = "p",
    Logo = "https://i.ibb.co/pvWzYPYT/IMG-3374.png",
    BackgroundImage = "https://i.ibb.co/pvWzYPYT/IMG-3374.png",
    Splash = {
        Image = "https://i.ibb.co/pvWzYPYT/IMG-3374.png",
    },
    ShowLogo = true,
    ShowGameName = true,
    IslandExpanded = true,
})

local overview = Nexa:AddTab({ Title = "Overview", Icon = "home", Select = true })

local welcome = overview:AddSection("Nexa Showcase", "A reference gallery for the complete public library.", { Column = "left" })
welcome:AddLabel({
    Title = "Nexa UI Library",
    Description = "Every page focuses on a different part of the library.",
})
welcome:AddDivider({ Title = "QUICK ACTIONS" })

local quick = welcome:AddInline({ 1, 1 })
quick:AddButton({
    Title = "Notification",
    ButtonText = "Show",
    Variant = "primary",
    Expand = true,
    Callback = function()
        Nexa:Notify({ Title = "Nexa", Content = "The showcase is working.", Type = "success", Duration = 4 })
    end,
})
quick:AddButton({
    Title = "Theme",
    ButtonText = "Next theme",
    Expand = true,
    Callback = function() Nexa:NextTheme() end,
})

local status = welcome:AddStatus({ Title = "Library status", Default = "Ready", Tone = "success" })
welcome:AddProgress({ Title = "Showcase coverage", Min = 0, Max = 100, Default = 100, Suffix = "%" })

local navigation = overview:AddSection("Navigation", "Public window and tab helpers.", { Column = "right" })
navigation:AddButton({
    Title = "Controls page",
    ButtonText = "Open",
    Callback = function() Nexa:SelectTab("Controls") end,
})
navigation:AddButton({
    Title = "Settings page",
    ButtonText = "Open",
    Callback = function() Nexa:SelectTab("Settings") end,
})
navigation:AddButton({
    Title = "Keybind viewer",
    ButtonText = "Open",
    Callback = function() Nexa:OpenKeybinds() end,
})
navigation:AddButton({
    Title = "Performance viewer",
    ButtonText = "Open",
    Callback = function() Nexa:OpenPerformance() end,
})

local states = overview:AddSection("Runtime state", "Examples of controls updating other controls.", { Column = "right" })
local liveStatus = states:AddStatus({ Title = "Demo state", Default = "Idle", Tone = "muted" })
states:AddSegmented({
    Title = "State",
    Options = { "Idle", "Active", "Warning" },
    Default = "Idle",
    Callback = function(v)
        liveStatus:SetValue(v, v == "Active" and "success" or v == "Warning" and "warning" or "muted")
    end,
})

local controls = Nexa:AddTab({ Title = "Controls", Icon = "settings-sliders" })

local basics = controls:AddSection("Basic controls", "Labels, dividers, buttons and toggles.", { Column = "left" })
basics:AddLabel({ Title = "Simple label" })
basics:AddLabel({ Title = "Label with description", Description = "Secondary text can explain a setting." })
basics:AddDivider({ Title = "BUTTON VARIANTS" })
basics:AddButton({ Title = "Default button", ButtonText = "Run", Callback = function() status:SetValue("Button", "accent") end })
basics:AddButton({ Title = "Primary button", ButtonText = "Apply", Variant = "primary" })
basics:AddButton({ Title = "Ghost button", ButtonText = "Ghost", Variant = "ghost" })
basics:AddButton({ Title = "Danger button", ButtonText = "Delete", Variant = "danger" })
basics:AddButton({ Title = "Expanded button", ButtonText = "Full width action", Variant = "primary", Expand = true })

local toggles = controls:AddSection("Toggle states", "Standard, disabled and accessory examples.", { Column = "right" })
local enabledToggle = toggles:AddToggle({
    Title = "Enabled toggle",
    Description = "A normal interactive toggle.",
    Default = true,
    ConfigKey = "showcase.toggle.enabled",
})
enabledToggle:AddKeybind({
    Title = "Toggle bind",
    Default = "q",
    Mode = "Toggle",
    ConfigKey = "showcase.toggle.bind",
})
enabledToggle:AddColorPicker({
    Title = "Toggle color",
    Default = C(170, 100, 255),
    DefaultAlpha = 0.85,
    ConfigKey = "showcase.toggle.color",
})
local disabledToggle = toggles:AddToggle({ Title = "Disabled toggle", Default = false })
disabledToggle:SetEnabled(false)

local actionToggle = toggles:AddToggle({
    Title = "Dynamic description",
    Description = "Toggle me to update this text.",
    Default = false,
})
actionToggle:OnChanged(function(v)
    actionToggle:SetDescription(v and "The toggle is currently enabled." or "The toggle is currently disabled.")
end)

local selection = controls:AddSection("Selection", "Single-choice control styles.", { Column = "left" })
selection:AddRadio({
    Title = "Radio group",
    Options = { "Alpha", "Beta", "Gamma" },
    Default = "Beta",
    ConfigKey = "showcase.radio",
})
selection:AddSegmented({
    Title = "Segmented",
    Options = { "Low", "Medium", "High" },
    Default = "Medium",
    ConfigKey = "showcase.segmented",
})

local values = controls:AddSection("Numeric values", "Sliders, ranges and read-only progress.", { Column = "right" })
local slider = values:AddSlider({
    Title = "Slider",
    Description = "Stepped value with suffix.",
    Min = 0, Max = 100, Step = 5, Default = 65, Suffix = "%",
    ConfigKey = "showcase.slider",
})
values:AddRangeSlider({
    Title = "Range slider",
    Min = 0, Max = 250, Step = 5,
    DefaultLow = 45, DefaultHigh = 180, Suffix = "m",
    ConfigKey = "showcase.range",
})
local progress = values:AddProgress({ Title = "Progress", Min = 0, Max = 100, Default = 65, Suffix = "%" })
slider:OnChanged(function(v) progress:SetValue(v) end)

local inputs = Nexa:AddTab({ Title = "Inputs", Icon = "keyboard" })

local dropdowns = inputs:AddSection("Dropdowns", "Single-select, multi-select and popup sizing.", { Column = "left" })
dropdowns:AddDropdown({
    Title = "Single select",
    Options = { "One", "Two", "Three", "Four", "Five" },
    Default = "Two",
    VisibleRows = 5,
    ConfigKey = "showcase.dropdown.single",
})
dropdowns:AddDropdown({
    Title = "Multi select",
    Options = { "Players", "Vehicles", "Items", "NPCs", "Objectives", "Locations" },
    Default = { "Players", "Items" },
    Multi = true,
    VisibleRows = 4,
    PopupWidth = 250,
    ConfigKey = "showcase.dropdown.multi",
})

local binds = inputs:AddSection("Keybinds", "Hold, Toggle and Always modes.", { Column = "right" })
binds:AddKeybind({
    Title = "Hold bind",
    Default = "e",
    Mode = "Hold",
    ConfigKey = "showcase.bind.hold",
    OnPressed = function() liveStatus:SetValue("Held", "success") end,
    OnReleased = function() liveStatus:SetValue("Released", "muted") end,
})
binds:AddKeybind({ Title = "Toggle bind", Default = "r", Mode = "Toggle", ConfigKey = "showcase.bind.toggle" })
binds:AddKeybind({ Title = "Always bind", Default = "none", Mode = "Always", ConfigKey = "showcase.bind.always" })

local colors = inputs:AddSection("Color pickers", "Standalone and inline accessory pickers.", { Column = "left" })
colors:AddColorPicker({
    Title = "Standalone color",
    Default = C(255, 95, 184),
    DefaultAlpha = 1,
    ConfigKey = "showcase.color.standalone",
})
colors:AddColorPicker({
    Title = "Alpha color",
    Default = C(40, 220, 180),
    DefaultAlpha = 0.55,
    ConfigKey = "showcase.color.alpha",
})
local colorHost = colors:AddToggle({ Title = "Inline accessory", Default = true, ConfigKey = "showcase.color.host" })
colorHost:AddColorPicker({
    Default = C(79, 153, 255),
    DefaultAlpha = 0.9,
    ConfigKey = "showcase.color.inline",
})

local statuses = inputs:AddSection("Status tones", "Read-only badges for common states.", { Column = "right" })
statuses:AddStatus({ Title = "Accent", Default = "Running", Tone = "accent" })
statuses:AddStatus({ Title = "Success", Default = "Online", Tone = "success" })
statuses:AddStatus({ Title = "Warning", Default = "Caution", Tone = "warning" })
statuses:AddStatus({ Title = "Danger", Default = "Error", Tone = "danger" })
statuses:AddStatus({ Title = "Muted", Default = "Inactive", Tone = "muted" })

local layout = Nexa:AddTab({ Title = "Layout", Icon = "layers" })

local inline = layout:AddSection("Inline layouts", "Multiple controls sharing horizontal space.", { Column = "left" })
local rowA = inline:AddInline({ 1, 1 })
rowA:AddToggle({ Title = "Left", Default = true })
rowA:AddToggle({ Title = "Right", Default = false })

local rowB = inline:AddInline({ 2, 1, 1 })
rowB:AddButton({ Title = "Wide", ButtonText = "Wide", Expand = true })
rowB:AddButton({ Title = "B", ButtonText = "B", Expand = true })
rowB:AddButton({ Title = "C", ButtonText = "C", Expand = true })

local collapsed = layout:AddSection("Collapsible section", "This section starts collapsed.", { Column = "right", Collapsed = true })
collapsed:AddLabel({ Title = "Hidden until expanded", Description = "Section headers can collapse their contents." })
collapsed:AddSlider({ Title = "Nested slider", Min = 0, Max = 10, Default = 5 })

local columnsLeft = layout:AddSection("Forced left column", "Column = left", { Column = "left" })
columnsLeft:AddLabel({ Title = "Left placement" })
local columnsRight = layout:AddSection("Forced right column", "Column = right", { Column = "right" })
columnsRight:AddLabel({ Title = "Right placement" })

local apiStates = layout:AddSection("Control API", "Visibility, enabled state, reset and metadata setters.", { Column = "left" })
local apiTarget = apiStates:AddToggle({
    Title = "API target",
    Description = "Buttons below manipulate this control.",
    Tooltip = "This tooltip is set through the base control API.",
    Default = true,
})
local apiRow = apiStates:AddInline({ 1, 1, 1 })
apiRow:AddButton({ Title = "Enable", ButtonText = "Enable", Expand = true, Callback = function() apiTarget:SetEnabled(true) end })
apiRow:AddButton({ Title = "Disable", ButtonText = "Disable", Expand = true, Callback = function() apiTarget:SetEnabled(false) end })
apiRow:AddButton({ Title = "Reset", ButtonText = "Reset", Expand = true, Callback = function() apiTarget:Reset() end })
apiStates:AddButton({
    Title = "Change metadata",
    ButtonText = "Rename control",
    Callback = function()
        apiTarget:SetTitle("Renamed target")
        apiTarget:SetDescription("Title and description changed at runtime.")
        apiTarget:SetTooltip("Runtime tooltip.")
    end,
})

local appearance = Nexa:AddTab({ Title = "Appearance", Icon = "sparkles" })

local themes = appearance:AddSection("Themes", "All the built-in themes.", { Column = "left" })
local themeNames = { "Midnight", "Obsidian", "Burgundy", "Cyber", "Bubblegum", "Emerald", "Crimson", "Arctic", "Sunset", "Royal" }
themes:AddDropdown({
    Title = "Theme",
    Options = themeNames,
    Default = "Obsidian",
    VisibleRows = 6,
    Callback = function(v) Nexa:SetTheme(v) end,
})
themes:AddButton({ Title = "Cycle themes", ButtonText = "Next", Callback = function() Nexa:NextTheme() end })

local effects = appearance:AddSection("Background effects", "Smooth effects rendered inside the main window.", { Column = "right" })
effects:AddDropdown({
    Title = "Effect",
    Options = { "none", "dots", "particles", "aurora", "snow", "rainfall" },
    Default = "particles",
    Callback = function(v) Nexa:SetBackground(v) end,
})
effects:AddButton({
    Title = "Detailed particles",
    ButtonText = "Apply",
    Callback = function() Nexa:SetBackground({ Type = "particles", Count = 38, Intensity = 0.8 }) end,
})
effects:AddButton({
    Title = "Detailed aurora",
    ButtonText = "Apply",
    Callback = function() Nexa:SetBackground({ Type = "aurora", Bands = 5, Intensity = 0.85 }) end,
})

local notices = Nexa:AddTab({ Title = "Notifications", Icon = "bell" })
local noticeTypes = notices:AddSection("Notification types", "Built-in toast tones.", { Column = "left" })
for _, item in ipairs({
    { "Info", "info" }, { "Success", "success" }, { "Warning", "warning" }, { "Error", "error" }
}) do
    noticeTypes:AddButton({
        Title = item[1],
        ButtonText = "Show",
        Callback = function()
            Nexa:Notify({
                Title = item[1] .. " notification",
                Content = "This is the " .. string.lower(item[1]) .. " notification style.",
                Type = item[2],
                Duration = 4,
            })
        end,
    })
end

local noticeContent = notices:AddSection("Notification content", "Duration and longer body examples.", { Column = "right" })
noticeContent:AddButton({
    Title = "Short",
    ButtonText = "2 seconds",
    Callback = function() Nexa:Notify({ Title = "Short toast", Content = "Closes quickly.", Type = "info", Duration = 2 }) end,
})
noticeContent:AddButton({
    Title = "Long",
    ButtonText = "8 seconds",
    Callback = function()
        Nexa:Notify({
            Title = "Longer notification",
            Content = "Notifications can contain more descriptive content and remain visible for a custom duration.",
            Type = "success",
            Duration = 8,
        })
    end,
})

local overlays = Nexa:AddTab({ Title = "Overlays", Icon = "window" })

local demoOverlay = Nexa:CreateOverlay({
    Title = "Nexa Overlay",
    X = 35, Y = 100,
    Width = 225,
    Dynamic = true,
    Visible = false,
    MaxLines = 8,
    MaxChars = 42,
    FontSize = 10,
    HeaderSize = 12,
    LineSpacing = 5,
})
demoOverlay:Line("Simple text line")
demoOverlay:Line({ Text = "Styled line", Color = C(85, 220, 145), Font = "SystemBold" })
demoOverlay:Line({
    { Text = "STATUS  ", Color = C(190, 195, 205), Font = "UI" },
    { Text = "ONLINE", Color = C(85, 220, 145), Font = "SystemBold" },
})

local overlayControls = overlays:AddSection("Overlay API", "CreateOverlay/CreateBox and runtime methods.", { Column = "left" })
overlayControls:AddToggle({
    Title = "Overlay visible",
    Default = false,
    Callback = function(v) demoOverlay:SetVisible(v) end,
})
overlayControls:AddToggle({
    Title = "Dynamic sizing",
    Default = true,
    Callback = function(v) demoOverlay:SetDynamic(v) end,
})
overlayControls:AddButton({ Title = "Toggle", ButtonText = "Toggle overlay", Callback = function() demoOverlay:Toggle() end })
overlayControls:AddButton({ Title = "Rename", ButtonText = "SetTitle", Callback = function() demoOverlay:SetTitle("Updated Overlay") end })
overlayControls:AddButton({
    Title = "Replace lines",
    ButtonText = "SetLines",
    Callback = function()
        demoOverlay:SetLines({
            "First replacement line",
            { Text = "Second styled line", Color = C(255, 190, 75), Font = "SystemBold" },
            {
                { Text = "RICH  ", Color = C(180, 180, 190) },
                { Text = "SEGMENTS", Color = C(255, 95, 184), Font = "SystemBold" },
            },
        })
    end,
})
overlayControls:AddButton({ Title = "Clear", ButtonText = "Clear lines", Variant = "danger", Callback = function() demoOverlay:Clear() end })

local overlayInfo = overlays:AddSection("Overlay features", "The example overlay is draggable and independent of the main window.", { Column = "right" })
overlayInfo:AddLabel({ Title = "Dynamic / fixed sizing", Description = "SetDynamic and SetSize are both exposed." })
overlayInfo:AddLabel({ Title = "Position", Description = "SetPosition can move an overlay at runtime." })
overlayInfo:AddButton({
    Title = "Move overlay",
    ButtonText = "Move",
    Callback = function() demoOverlay:SetPosition(55, 155) end,
})
overlayInfo:AddButton({
    Title = "Resize overlay",
    ButtonText = "Resize",
    Callback = function() demoOverlay:SetSize(275, 180) end,
})

local island = Nexa:AddTab({ Title = "Island", Icon = "zap" })
local islandState = { star = false, eye = false }

Nexa:AddIslandAction({
    Id = "showcase_star",
    Icon = "star",
    Side = "left",
    GetActive = function() return islandState.star end,
    Callback = function()
        islandState.star = not islandState.star
        Nexa:Notify({ Title = "Island", Content = "Star action toggled.", Type = "info", Duration = 2 })
    end,
})
Nexa:AddIslandAction({
    Id = "showcase_eye",
    Icon = "eye",
    Side = "right",
    GetActive = function() return islandState.eye end,
    Callback = function() islandState.eye = not islandState.eye end,
})

local islandControls = island:AddSection("Dynamic island", "Actions can live on either side of the fixed title.", { Column = "left" })
islandControls:AddButton({ Title = "Open", ButtonText = "Open island", Callback = function() Nexa:SetIslandOpen(true) end })
islandControls:AddButton({ Title = "Close", ButtonText = "Close island", Callback = function() Nexa:SetIslandOpen(false) end })
islandControls:AddButton({ Title = "Toggle", ButtonText = "Toggle island", Callback = function() Nexa:ToggleIsland() end })
islandControls:AddButton({
    Title = "Remove eye action",
    ButtonText = "Remove",
    Variant = "danger",
    Callback = function() Nexa:RemoveIslandAction("showcase_eye") end,
})
islandControls:AddButton({
    Title = "Clear actions",
    ButtonText = "Clear all",
    Variant = "danger",
    Callback = function() Nexa:ClearIslandActions() end,
})

local icons = Nexa:AddTab({ Title = "Icons", Icon = "star" })
local iconSection = icons:AddSection("Built-in icon names", "The image-mask icon renderer used by tabs and island actions.", { Column = "left" })
iconSection:AddLabel({
    Title = "Navigation",
    Description = "home, menu, arrows, chevrons, window, folder, file",
})
iconSection:AddLabel({
    Title = "Interface",
    Description = "user, shield, bell, eye, search, crosshair, settings, sliders, keyboard",
})
iconSection:AddLabel({
    Title = "Actions",
    Description = "play, pause, stop, refresh, download, upload, trash, edit, power",
})
iconSection:AddLabel({
    Title = "Status & misc",
    Description = "info, warning, error, success, star, heart, lock, globe, zap, layers, sparkles",
})

local iconTabs = icons:AddSection("Icon tab examples", "This entire showcase uses different tab icons so they can be compared directly.", { Column = "right" })
iconTabs:AddLabel({ Title = "Selected state", Description = "Icons tint with the active theme accent." })
iconTabs:AddLabel({ Title = "Inactive state", Description = "Inactive icons use the sidebar's muted treatment." })
iconTabs:AddLabel({ Title = "24x24 masks", Description = "Icons are antialiased images rather than primitive line glyphs." })

local config = Nexa:AddTab({ Title = "Config API", Icon = "file" })
local configDemo = config:AddSection("Manual configuration", "ConfigKey values are included in SaveConfig/LoadConfig.", { Column = "left" })
configDemo:AddToggle({ Title = "Saved toggle", Default = true, ConfigKey = "showcase.config.toggle" })
configDemo:AddSlider({ Title = "Saved slider", Min = 0, Max = 100, Default = 40, ConfigKey = "showcase.config.slider" })
configDemo:AddColorPicker({ Title = "Saved color", Default = C(176,112,255), ConfigKey = "showcase.config.color" })
configDemo:AddDropdown({
    Title = "Saved dropdown",
    Options = { "Alpha", "Beta", "Gamma" },
    Default = "Alpha",
    ConfigKey = "showcase.config.dropdown",
})

local configActions = config:AddSection("Config methods", "The built-in Settings page provides the normal UI for these.", { Column = "right" })
configActions:AddButton({
    Title = "Save showcase",
    ButtonText = "Save",
    Variant = "primary",
    Callback = function()
        local ok, result = Nexa:SaveConfig("nexa_showcase")
        Nexa:Notify({ Title = "SaveConfig", Content = ok and "Saved nexa_showcase." or tostring(result), Type = ok and "success" or "error" })
    end,
})
configActions:AddButton({
    Title = "Load showcase",
    ButtonText = "Load",
    Callback = function()
        local ok, result = Nexa:LoadConfig("nexa_showcase")
        Nexa:Notify({ Title = "LoadConfig", Content = ok and "Loaded nexa_showcase." or tostring(result), Type = ok and "success" or "error" })
    end,
})
configActions:AddButton({
    Title = "Delete showcase",
    ButtonText = "Delete",
    Variant = "danger",
    Callback = function()
        local ok, result = Nexa:DeleteConfig("nexa_showcase")
        Nexa:Notify({ Title = "DeleteConfig", Content = ok and "Deleted nexa_showcase." or tostring(result), Type = ok and "success" or "error" })
    end,
})
configActions:AddButton({ Title = "Reset defaults", ButtonText = "Reset", Callback = function() Nexa:ResetDefaults() end })

local windowApi = Nexa:AddTab({ Title = "Window API", Icon = "window" })
local visibility = windowApi:AddSection("Visibility", "Public window lifecycle helpers.", { Column = "left" })
visibility:AddButton({ Title = "Hide UI", ButtonText = "Hide", Callback = function() Nexa:Hide() end })
visibility:AddLabel({ Title = "Show UI", Description = "Use the configured menu key (Right Shift here) after hiding." })
visibility:AddButton({ Title = "Toggle UI", ButtonText = "Toggle", Callback = function() Nexa:Toggle() end })

local utility = windowApi:AddSection("Utility windows", "Built-in auxiliary panels.", { Column = "right" })
utility:AddButton({ Title = "Open keybinds", ButtonText = "Open", Callback = function() Nexa:OpenKeybinds() end })
utility:AddButton({ Title = "Close keybinds", ButtonText = "Close", Callback = function() Nexa:CloseKeybinds() end })
utility:AddButton({ Title = "Open performance", ButtonText = "Open", Callback = function() Nexa:OpenPerformance() end })
utility:AddButton({ Title = "Close performance", ButtonText = "Close", Callback = function() Nexa:ClosePerformance() end })

local lifecycle = windowApi:AddSection("Lifecycle", "Destructive API is intentionally placed at the end.", { Column = "right" })
lifecycle:AddStatus({ Title = "IsAlive()", Default = tostring(Nexa:IsAlive()), Tone = "success" })
lifecycle:AddButton({
    Title = "Destroy Nexa",
    ButtonText = "Destroy",
    Variant = "danger",
    Callback = function() Nexa:Destroy() end,
})

Nexa:OnDestroy(function()
    print("[Nexa Showcase] Library destroyed.")
end)

Nexa:Notify({
    Title = "Nexa Showcase",
    Content = "Complete component showcase loaded. Use the tabs to explore the library.",
    Type = "success",
    Duration = 5,
})

return Nexa
