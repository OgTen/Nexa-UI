<p align="center">
  <img src="https://i.ibb.co/pvWzYPYT/IMG-3374.png" alt="Nexa UI" width="180">
</p>

# Nexa UI Library

Nexa is a Drawing-based Roblox UI library designed for clean, modern
interfaces with tabs, sections, controls, themes, notifications,
configurable keybinds, manual configs, overlays, and a dynamic title
island.

This README covers the basics needed to load Nexa and start building
your own interface.

> **Documentation:** This guide targets the current `nexa-ui.lua`
> release.

------------------------------------------------------------------------

## Features

Nexa includes:

-   Modern Drawing-based interface
-   Tabs with icons
-   Sections and inline layouts
-   Toggles
-   Buttons
-   Sliders and range sliders
-   Dropdowns
-   Radio controls
-   Segmented controls
-   Keybinds
-   Color pickers
-   Progress bars
-   Status indicators
-   Labels and dividers
-   Tooltips and descriptions
-   Control accessories
-   Manual configuration saving/loading
-   Multiple built-in themes
-   Animated background effects
-   Notifications
-   Dynamic Island actions
-   Custom overlays / HUD boxes
-   Configurable menu key
-   Window show/hide animations
-   Startup splash support
-   Runtime theme switching
-   Custom window opacity
-   Window/sidebar logo images
-   Window background images
-   Clickable profile avatar with hideable profile names
-   Persistent Settings menu-key override
-   Dynamic overlay width modes (`false`, `true`, and `"expand"`)
-   Dynamic overlay height

------------------------------------------------------------------------

## Getting Started

# Creating a Window

Create the main Nexa window before adding your own tabs and controls.

``` lua
local Nexa = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/OgTen/Nexa-UI/refs/heads/main/nexa-ui.lua"
))()

Nexa:CreateWindow({
    Title = "Nexa",
    Subtitle = "Nexa Example",
    MenuKey = "p",
    Theme = "Obsidian",
    Opacity = 100,
})
```

Pressing `P` will toggle the interface.

A more customized window can look like this:

``` lua
Nexa:CreateWindow({
    Title = "Nexa",
    Subtitle = "Made with Nexa",

    Width = 760,
    Height = 520,

    MenuKey = "p",
    Theme = "Obsidian",
    Opacity = 100,
    Background = "particles",

    Logo = "https://example.com/logo.png",
    BackgroundImage = "https://example.com/background.png",

    NotificationPosition = "top_right",

    IslandExpanded = false,

    Splash = {
        Duration = 3,
        Title = "Nexa",
        Image = "https://example.com/logo.png",
    },
})
```

You do not need to specify every option. Nexa supplies defaults for
anything you leave out.

### Window appearance options

`CreateWindow` supports optional appearance properties such as:

``` lua
Nexa:CreateWindow({
    Title = "Nexa",

    -- 35-100. Omit this to use Nexa's normal/default opacity.
    Opacity = 100,

    -- Shown in Nexa's branded logo area.
    Logo = "https://example.com/logo.png",

    -- Drawn behind the window content.
    BackgroundImage = "https://example.com/background.png",

    Splash = {
        -- Optional image used by the startup/loading splash.
        Image = "https://example.com/logo.png",
    },
})
```

`Opacity` can be changed later from Nexa's built-in Settings page. The
Settings page also includes a **Menu key** keybind; changing it overrides
the `MenuKey` originally supplied by the script, and that key can be
stored in Nexa configs.

The profile area in the title bar displays the local player's avatar,
display name, and username. Clicking the avatar hides or shows the two
name lines.

------------------------------------------------------------------------

# Adding Tabs

Tabs are the main pages of your interface.

``` lua
local MainTab = Nexa:AddTab({
    Title = "Main",
    Icon = "home",
    Select = true,
})

local VisualTab = Nexa:AddTab({
    Title = "Visuals",
    Icon = "eye",
})

local SettingsTab = Nexa:AddTab({
    Title = "Settings",
    Icon = "gear",
})
```

`Select = true` makes that tab the initially selected tab.

Nexa includes a number of built-in icon names such as:

``` text
home
gear
eye
user
shield
bell
search
crosshair
star
heart
folder
file
play
pause
refresh
download
upload
trash
edit
info
warning
success
lock
unlock
power
layers
globe
zap
keyboard
sparkles
```

------------------------------------------------------------------------

# Adding Sections

Sections organize controls inside a tab.

``` lua
local PlayerSection = MainTab:AddSection(
    "Player",
    "Player-related options"
)
```

You can then add controls directly to the section:

``` lua
PlayerSection:AddToggle({
    Title = "Enabled",
    Default = false,
})
```

You can create multiple sections:

``` lua
local MovementSection = MainTab:AddSection(
    "Movement",
    "Movement settings"
)

local OtherSection = MainTab:AddSection(
    "Other",
    "Miscellaneous options"
)
```

Sections can also be collapsed initially:

``` lua
local Section = MainTab:AddSection(
    "Advanced",
    "Advanced settings",
    {
        Collapsed = true,
    }
)
```

------------------------------------------------------------------------

# Toggles

Use a toggle for an on/off option.

``` lua
local Toggle = PlayerSection:AddToggle({
    Title = "Enable Feature",
    Description = "Turns the feature on or off.",
    Default = false,

    Callback = function(value)
        print("Enabled:", value)
    end,
})
```

`value` will be either `true` or `false`.

You can also listen for changes after creating the control:

``` lua
Toggle:OnChanged(function(value)
    print("Toggle changed:", value)
end)
```

------------------------------------------------------------------------

# Buttons

Buttons run a function when pressed.

``` lua
PlayerSection:AddButton({
    Title = "Reset Character",
    Description = "Runs an example action.",
    ButtonText = "Reset",

    Callback = function()
        print("Button pressed")
    end,
})
```

Button variants can also be used:

``` lua
PlayerSection:AddButton({
    Title = "Delete",
    ButtonText = "Delete",
    Variant = "danger",

    Callback = function()
        print("Delete pressed")
    end,
})
```

Common variants include:

``` text
default
primary
accent
danger
ghost
```

------------------------------------------------------------------------

# Sliders

Sliders are useful for numeric values.

``` lua
local SpeedSlider = MovementSection:AddSlider({
    Title = "Speed",
    Min = 0,
    Max = 100,
    Step = 1,
    Default = 25,
    Suffix = "%",

    Callback = function(value)
        print("Speed:", value)
    end,
})
```

For decimal values:

``` lua
MovementSection:AddSlider({
    Title = "Multiplier",
    Min = 0,
    Max = 5,
    Step = 0.1,
    Default = 1,
})
```

------------------------------------------------------------------------

# Range Sliders

A range slider selects a minimum and maximum value.

``` lua
MovementSection:AddRangeSlider({
    Title = "Distance Range",

    Min = 0,
    Max = 1000,
    Step = 10,

    DefaultLow = 100,
    DefaultHigh = 500,

    Suffix = "m",

    Callback = function(value)
        print("Range changed:", value)
    end,
})
```

------------------------------------------------------------------------

# Dropdowns

Dropdowns allow the user to choose from a list.

``` lua
local ModeDropdown = PlayerSection:AddDropdown({
    Title = "Mode",

    Options = {
        "Normal",
        "Fast",
        "Extreme",
    },

    Default = "Normal",

    Callback = function(value)
        print("Selected:", value)
    end,
})
```

## Multi-select Dropdown

``` lua
PlayerSection:AddDropdown({
    Title = "Targets",

    Options = {
        "Players",
        "NPCs",
        "Items",
    },

    Multi = true,

    Callback = function(value)
        print("Selection changed")
    end,
})
```

------------------------------------------------------------------------

# Radio Controls

``` lua
PlayerSection:AddRadio({
    Title = "Mode",

    Options = {
        "Legit",
        "Rage",
        "Custom",
    },

    Default = "Legit",

    Callback = function(value)
        print("Mode:", value)
    end,
})
```

------------------------------------------------------------------------

# Segmented Controls

Segmented controls provide a compact choice between several options.

``` lua
PlayerSection:AddSegmented({
    Title = "Quality",

    Options = {
        "Low",
        "Medium",
        "High",
    },

    Default = "High",

    Callback = function(value)
        print("Quality:", value)
    end,
})
```

------------------------------------------------------------------------

# Keybinds

A standalone keybind can be added to a section:

``` lua
PlayerSection:AddKeybind({
    Title = "Toggle Feature",
    Default = "f",
    Mode = "Toggle",

    Callback = function(value)
        print("Keybind state:", value)
    end,
})
```

Supported modes include:

``` text
Hold
Toggle
Always
```

A keybind can also be attached directly to another control.

``` lua
local FeatureToggle = PlayerSection:AddToggle({
    Title = "Feature",
    Default = false,
})

FeatureToggle:AddKeybind({
    Default = "f",
    Mode = "Toggle",
})
```

This keeps the keybind inline with the control instead of creating
another full row.

------------------------------------------------------------------------

# Color Pickers

``` lua
local ESPColor = VisualTab:AddColorPicker({
    Title = "ESP Color",
    Default = Color3.fromRGB(255, 80, 120),

    Callback = function(color)
        print("Color changed:", color)
    end,
})
```

Color pickers support alpha:

``` lua
VisualTab:AddColorPicker({
    Title = "Overlay Color",
    Default = Color3.fromRGB(255, 255, 255),
    DefaultAlpha = 0.8,
})
```

Like keybinds, a color picker can be attached to another control:

``` lua
local ESPToggle = VisualTab:AddToggle({
    Title = "ESP",
    Default = false,
})

ESPToggle:AddColorPicker({
    Default = Color3.fromRGB(255, 255, 255),
})
```

------------------------------------------------------------------------

# Labels and Dividers

Use labels for informational text:

``` lua
PlayerSection:AddLabel({
    Title = "Information",
    Description = "This is some information about the section.",
})
```

Use dividers to visually separate groups:

``` lua
PlayerSection:AddDivider()
```

------------------------------------------------------------------------

# Progress Bars

``` lua
PlayerSection:AddProgress({
    Title = "Loading",
    Min = 0,
    Max = 100,
    Default = 65,
    Suffix = "%",
})
```

You can keep the returned control and update it later:

``` lua
local Progress = PlayerSection:AddProgress({
    Title = "Progress",
    Min = 0,
    Max = 100,
    Default = 0,
})

Progress:SetValue(50)
```

------------------------------------------------------------------------

# Status Indicators

``` lua
PlayerSection:AddStatus({
    Title = "Server Status",
    Value = "Online",
    Tone = "success",
})
```

Available tones include:

``` text
accent
success
warning
danger
error
muted
```

------------------------------------------------------------------------

# Inline Controls

Nexa can place controls next to each other instead of giving each one a
full row.

``` lua
local Row = PlayerSection:AddInline({
    1,
    1,
})

Row:AddButton({
    Title = "Start",
    ButtonText = "Start",
})

Row:AddButton({
    Title = "Stop",
    ButtonText = "Stop",
    Variant = "danger",
})
```

The weights determine how much horizontal space each cell receives.

For example:

``` lua
local Row = PlayerSection:AddInline({
    2,
    1,
})
```

The first cell receives roughly twice the width of the second.

------------------------------------------------------------------------

# Control Values

Most interactive controls return an object that can be stored:

``` lua
local Toggle = PlayerSection:AddToggle({
    Title = "Example",
    Default = false,
})
```

Read its current value:

``` lua
local value = Toggle:GetValue()
```

Change it:

``` lua
Toggle:SetValue(true)
```

Listen for changes:

``` lua
Toggle:OnChanged(function(value)
    print(value)
end)
```

Reset it to its default:

``` lua
Toggle:Reset()
```

------------------------------------------------------------------------

# Common Control Options

Many Nexa controls support the same basic options:

``` lua
{
    Title = "Control Name",
    Description = "Optional description",
    Tooltip = "Optional tooltip",
    Default = false,
    ConfigKey = "my.control",
}
```

Controls can also be changed after creation:

``` lua
Control:SetVisible(false)
Control:SetEnabled(false)

Control:SetTitle("New Title")
Control:SetDescription("New description")
Control:SetTooltip("New tooltip")
```

Destroy a control:

``` lua
Control:Destroy()
```

------------------------------------------------------------------------

# Config Keys

If you want a control to participate in Nexa's manual configuration
system, give it a unique `ConfigKey`.

``` lua
local ESPToggle = VisualTab:AddToggle({
    Title = "ESP",
    Default = false,
    ConfigKey = "visuals.esp.enabled",
})
```

Another example:

``` lua
local Distance = VisualTab:AddSlider({
    Title = "ESP Distance",

    Min = 50,
    Max = 5000,
    Default = 1000,

    ConfigKey = "visuals.esp.distance",
})
```

Use unique keys for different controls.

A useful naming style is:

``` text
player.speed
player.fly
visuals.esp.enabled
visuals.esp.distance
visuals.esp.color
combat.mode
```

------------------------------------------------------------------------

# Saving and Loading Configs

Nexa uses manual configs. A config is only saved or loaded when you
request it.

``` lua
Nexa:SaveConfig("default")
```

Load it later:

``` lua
Nexa:LoadConfig("default")
```

Delete it:

``` lua
Nexa:DeleteConfig("default")
```

Controls with supported values and a `ConfigKey` can be restored from
the config.

You can also use the built-in Settings/config interface provided by
Nexa.

------------------------------------------------------------------------

# Themes

Change the theme when creating the window:

``` lua
Nexa:CreateWindow({
    Title = "Nexa",
    Theme = "Obsidian",
})
```

Or change it at runtime:

``` lua
Nexa:SetTheme("Emerald")
```

Current built-in theme identities include:

  Theme       Style
  ----------- ----------------
  Midnight    Purple
  Obsidian    Monochrome
  Burgundy    Wine / Magenta
  Cyber       Cyan
  Bubblegum   Pink
  Emerald     Green
  Crimson     Red
  Arctic      Blue
  Sunset      Orange
  Royal       Gold

Cycle to the next theme:

``` lua
Nexa:NextTheme()
```

------------------------------------------------------------------------

# Background Effects

A background effect can be selected when creating the window:

``` lua
Nexa:CreateWindow({
    Title = "Nexa",
    Background = "particles",
})
```

Or changed later:

``` lua
Nexa:SetBackground("aurora")
```

Available effects include:

``` text
none
dots
particles
aurora
snow
rainfall
```

A static image can also be placed behind the window content independently
of the animated effect:

``` lua
Nexa:CreateWindow({
    Title = "Nexa",
    Background = "particles",
    BackgroundImage = "https://example.com/background.png",
})
```

------------------------------------------------------------------------

# Notifications

Create a notification with:

``` lua
Nexa:Notify({
    Title = "Nexa",
    Content = "The script has loaded.",
    Type = "success",
    Duration = 4,
})
```

Another example:

``` lua
Nexa:Notify({
    Title = "Warning",
    Content = "Something needs your attention.",
    Type = "warning",
    Duration = 5,
})
```

The notification position can be configured in `CreateWindow`:

``` lua
NotificationPosition = "top_right"
```

Supported positions are:

``` text
top_left
top_right
bottom_left
bottom_right
```

------------------------------------------------------------------------

# Dynamic Island Actions

Nexa's title Island can contain custom actions.

``` lua
Nexa:AddIslandAction({
    Id = "example_action",
    Icon = "star",
    Side = "left",

    Callback = function()
        print("Star pressed")
    end,
})
```

Actions can be placed on either side:

``` lua
Side = "left"
```

or:

``` lua
Side = "right"
```

An action can expose an active state:

``` lua
local enabled = false

Nexa:AddIslandAction({
    Id = "esp",
    Icon = "eye",
    Side = "right",

    GetActive = function()
        return enabled
    end,

    Callback = function()
        enabled = not enabled
    end,
})
```

Remove an action:

``` lua
Nexa:RemoveIslandAction("esp")
```

Remove every Island action:

``` lua
Nexa:ClearIslandActions()
```

Open or close the Island:

``` lua
Nexa:SetIslandOpen(true)
Nexa:SetIslandOpen(false)
```

Or toggle it:

``` lua
Nexa:ToggleIsland()
```

------------------------------------------------------------------------

# Overlays / HUD Boxes

Nexa can create separate overlay boxes.

``` lua
local Overlay = Nexa:CreateOverlay({
    Title = "Information",
    Width = 220,
    Height = 120,
    Visible = true,

    -- false = fixed width
    -- true = fully dynamic width
    -- "expand" = Width is the minimum/base width
    DynamicWidth = "expand",

    DynamicHeight = true,
    MaxChars = 50,
})
```

Add lines:

``` lua
Overlay:AddLine("Nexa Overlay")
Overlay:AddLine("Status: Online")
```

Or replace all lines:

``` lua
Overlay:SetLines({
    "Player: Example",
    "Status: Online",
    "Mode: Normal",
})
```

Toggle visibility:

``` lua
Overlay:SetVisible(false)
Overlay:SetVisible(true)
```

Other useful methods include:

``` lua
Overlay:Toggle()
Overlay:SetTitle("New Title")
Overlay:SetSize(250, 150)
Overlay:SetPosition(100, 100)
Overlay:SetDynamicWidth("expand")
Overlay:SetDynamicHeight(true)
Overlay:Clear()
```

With `DynamicWidth = "expand"`, the configured `Width` acts as the base
width. The overlay expands when its content needs more room and contracts
back to that base width when the longer content disappears. `MaxChars`
still caps automatic content width.

------------------------------------------------------------------------

# Showing and Hiding Nexa

Hide the interface:

``` lua
Nexa:Hide()
```

Show it:

``` lua
Nexa:Show()
```

Toggle it:

``` lua
Nexa:Toggle()
```

Change the menu key at runtime:

``` lua
Nexa:SetKeybind("p")
```

------------------------------------------------------------------------

# Complete Basic Example

The following is a small but complete Nexa interface:

``` lua
local Nexa = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/OgTen/Nexa-UI/refs/heads/main/nexa-ui.lua"
))()

Nexa:CreateWindow({
    Title = "Example Script",
    Subtitle = "Made with Nexa",
    MenuKey = "p",
    Theme = "Obsidian",
    Opacity = 100,
    Background = "particles",
})

local Main = Nexa:AddTab({
    Title = "Main",
    Icon = "home",
    Select = true,
})

local Visuals = Nexa:AddTab({
    Title = "Visuals",
    Icon = "eye",
})

local MainSection = Main:AddSection(
    "General",
    "Main script settings"
)

local Enabled = MainSection:AddToggle({
    Title = "Enabled",
    Description = "Enables the main feature.",
    Default = false,
    ConfigKey = "main.enabled",

    Callback = function(value)
        print("Enabled:", value)
    end,
})

MainSection:AddSlider({
    Title = "Amount",
    Min = 0,
    Max = 100,
    Step = 1,
    Default = 50,
    Suffix = "%",
    ConfigKey = "main.amount",

    Callback = function(value)
        print("Amount:", value)
    end,
})

MainSection:AddDropdown({
    Title = "Mode",

    Options = {
        "Normal",
        "Fast",
        "Extreme",
    },

    Default = "Normal",
    ConfigKey = "main.mode",

    Callback = function(value)
        print("Mode:", value)
    end,
})

MainSection:AddButton({
    Title = "Example Action",
    ButtonText = "Run",

    Callback = function()
        Nexa:Notify({
            Title = "Example",
            Content = "The button was pressed.",
            Type = "success",
            Duration = 3,
        })
    end,
})

local ESP = Visuals:AddSection(
    "ESP",
    "Visual settings"
)

local ESPToggle = ESP:AddToggle({
    Title = "ESP",
    Default = false,
    ConfigKey = "visuals.esp.enabled",
})

ESPToggle:AddColorPicker({
    Default = Color3.fromRGB(255, 255, 255),
    ConfigKey = "visuals.esp.color",
})

ESPToggle:AddKeybind({
    Default = "e",
    Mode = "Toggle",
})

Nexa:AddIslandAction({
    Id = "esp",
    Icon = "eye",
    Side = "right",

    GetActive = function()
        return ESPToggle:GetValue()
    end,

    Callback = function()
        ESPToggle:SetValue(not ESPToggle:GetValue())
    end,
})

Nexa:Notify({
    Title = "Example Script",
    Content = "Loaded successfully. Press P to toggle the menu.",
    Type = "success",
    Duration = 4,
})
```

------------------------------------------------------------------------

# Recommended Structure

For larger scripts, it helps to keep your Nexa setup organized:

``` lua
-- Load library
local Nexa = ...

-- Create window
Nexa:CreateWindow(...)

-- Create tabs
local Main = Nexa:AddTab(...)
local Visuals = Nexa:AddTab(...)
local Settings = Nexa:AddTab(...)

-- Create sections
local MainSection = Main:AddSection(...)
local ESPSection = Visuals:AddSection(...)

-- Create controls
local Enabled = MainSection:AddToggle(...)
local Speed = MainSection:AddSlider(...)
local ESP = ESPSection:AddToggle(...)

-- Connect callbacks / script logic
Enabled:OnChanged(function(value)
    -- logic
end)
```

Keeping the UI setup separate from the actual feature logic makes larger
scripts much easier to maintain.

------------------------------------------------------------------------

# Cleanup

If your script is being unloaded, destroy Nexa:

``` lua
Nexa:Destroy()
```

You can check whether the library is still alive with:

``` lua
if Nexa:IsAlive() then
    print("Nexa is running")
end
```

You can also register cleanup logic:

``` lua
Nexa:OnDestroy(function()
    print("Nexa was destroyed")

    -- Disconnect your own connections,
    -- stop loops, remove objects, etc.
end)
```

------------------------------------------------------------------------

# Quick Reference

``` lua
-- Window
Nexa:CreateWindow({
    Title = "Nexa",
    MenuKey = "p",
    Theme = "Obsidian",
    Opacity = 100,
    Logo = "https://example.com/logo.png",
    BackgroundImage = "https://example.com/background.png",
})

-- Tabs
local Tab = Nexa:AddTab({...})

-- Sections
local Section = Tab:AddSection("Title", "Description")

-- Controls
Section:AddLabel({...})
Section:AddDivider({...})
Section:AddButton({...})
Section:AddToggle({...})
Section:AddRadio({...})
Section:AddSegmented({...})
Section:AddProgress({...})
Section:AddStatus({...})
Section:AddSlider({...})
Section:AddRangeSlider({...})
Section:AddDropdown({...})
Section:AddKeybind({...})
Section:AddColorPicker({...})

-- Inline layout
local Row = Section:AddInline({1, 1})
Row:AddButton({...})
Row:AddToggle({...})

-- Control accessories
Control:AddKeybind({...})
Control:AddColorPicker({...})

-- Configs
Nexa:SaveConfig("default")
Nexa:LoadConfig("default")
Nexa:DeleteConfig("default")

-- Appearance
Nexa:SetTheme("Obsidian")
Nexa:NextTheme()
Nexa:SetBackground("particles")

-- Overlays
local Overlay = Nexa:CreateOverlay({
    Width = 150,
    DynamicWidth = "expand",
    DynamicHeight = true,
})

-- Notifications
Nexa:Notify({...})

-- Island
Nexa:AddIslandAction({...})
Nexa:RemoveIslandAction("id")
Nexa:ClearIslandActions()
Nexa:SetIslandOpen(true)
Nexa:ToggleIsland()

-- Window visibility
Nexa:Show()
Nexa:Hide()
Nexa:Toggle()

-- Cleanup
Nexa:Destroy()
```

------------------------------------------------------------------------

## Notes

-   Create the Nexa window before adding your own tabs.
-   Give configurable controls unique `ConfigKey` values.
-   Store returned controls if you need to read or change their values
    later.
-   Use sections to keep larger interfaces organized.
-   Use `AddInline` when several controls belong on the same row.
-   Attached keybinds and color pickers are useful when you want a
    compact layout.
-   Call `Nexa:Destroy()` when unloading your script.
-   The menu key can be configured with `MenuKey` in `CreateWindow`.
-   The built-in Settings **Menu key** control can override that key at runtime and save it in configs.
-   Use `Opacity` in `CreateWindow` when a script needs a specific starting window opacity.
-   `Logo`, `BackgroundImage`, and `Splash.Image` can use separate images or the same image.

------------------------------------------------------------------------

## Nexa

Built as a flexible UI library for scripts that need a clean interface
without requiring every project to build its GUI from scratch.
