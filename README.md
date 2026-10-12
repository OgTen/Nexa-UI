Nexa UI Library
Nexa is a Drawing-based Roblox UI library for Matcha-compatible environments. It provides a customizable window with sidebar tabs, sections, interactive controls, themes, notifications, keybinds, configurations, and overlays.
Files
`nexa-ui.lua` — full library
`nexa-showcase.lua` — runnable example demonstrating the library
`README.md` — setup and API reference
Getting started
```lua
local Nexa = loadstring(game:HttpGet("https://raw.githubusercontent.com/OgTen/Nexa-UI/main/nexa-ui.lua"))()

Nexa:CreateWindow({
    Title = "Nexa",
    Subtitle = "Example interface",
    Theme = "Midnight",
    Width = 760,
    Height = 520,
    MenuKey = "RightShift",
    Background = "none",
    Opacity = 100,
})

local main = Nexa:AddTab({ Title = "Main", Icon = "home", Select = true })
local section = main:AddSection("General", "Example controls")

section:AddToggle({
    Title = "Enabled",
    Default = false,
    ConfigKey = "general.enabled",
    Callback = function(value)
        print("Enabled:", value)
    end,
})

section:AddButton({
    Title = "Notify",
    ButtonText = "Show",
    Callback = function()
        Nexa:Notify({ Title = "Nexa", Content = "Hello!", Type = "success", Duration = 4 })
    end,
})
```
Showcase
Run the contents of `nexa-showcase.lua` in a supported environment. The showcase fetches the current `nexa-ui.lua` from this repository and demonstrates the available controls and panels. After uploading a new library version, GitHub's raw file must be updated before the remote showcase reflects the changes.
Window configuration
Option	Purpose
`Title`, `Subtitle`	Header text; longer text wraps onto additional lines
`Width`, `Height`	Initial window dimensions
`Theme`	Built-in theme name
`MenuKey`	Key used to show or hide the interface
`Opacity`	Window opacity setting
`Background`	Background effect (`none`, `dots`, `particles`, `aurora`, `snow`, `rainfall`)
`BackgroundImage`	Optional background image
`NotificationPosition`	`top_left`, `top_right`, `bottom_left`, or `bottom_right`
The window opens with a short fade-in rather than a startup splash. The main header logo is not displayed. The sidebar includes a Roblox profile footer with an avatar/name visibility toggle and a Settings control.
Tabs and sections
```lua
local visuals = Nexa:AddTab({ Title = "Visuals", Icon = "eye" })
local settings = visuals:AddSection("Display", "Visual settings")
```
`Select = true` chooses the initial tab. The built-in Settings area is separate from user-created tabs.
Controls
Use the following methods on a section:
Method	Purpose
`AddToggle`	Boolean setting
`AddButton`	Clickable action
`AddSlider`	Numeric value
`AddRangeSlider`	Minimum and maximum values
`AddDropdown`	Single or multiple choices
`AddRadio`	Radio selection
`AddSegmented`	Segmented selection
`AddKeybind`	Hold, Toggle, or Always binding
`AddColorPicker`	Color and optional alpha
`AddLabel`	Informational text
`AddDivider`	Visual separator
`AddProgress`	Progress display
`AddStatus`	Status indicator
`AddInline`	Controls arranged side by side
Common control fields include `Title`, `Description`, `Tooltip`, `Default`, `Callback`, and `ConfigKey`. Individual controls may also expose `GetValue()`, `SetValue(value)`, `OnChanged(callback)`, `Reset()`, and visibility or enabled setters, depending on control type.
Sliders and dropdowns
```lua
settings:AddSlider({ Title = "Distance", Min = 0, Max = 500, Step = 5, Default = 100 })
settings:AddDropdown({ Title = "Mode", Options = { "Normal", "Fast" }, Default = "Normal" })
settings:AddColorPicker({ Title = "Highlight", Default = Color3.fromRGB(163, 103, 250) })
```
Inline controls
```lua
local row = settings:AddInline({ 1, 1 })
row:AddButton({ Title = "Start", ButtonText = "Start" })
row:AddButton({ Title = "Stop", ButtonText = "Stop", Variant = "danger" })
```
Themes and backgrounds
Built-in themes: Midnight, Obsidian, Burgundy, Cyber, Bubblegum, Emerald, Crimson, Arctic, Sunset, and Royal.
```lua
Nexa:SetTheme("Obsidian")
Nexa:NextTheme()
Nexa:SetBackground("particles")
```
Notifications
```lua
Nexa:Notify({ Title = "Saved", Content = "Settings updated.", Type = "success", Duration = 4 })
```
Manual configuration
Give persistent controls unique `ConfigKey` values, then save or restore them explicitly:
```lua
Nexa:SaveConfig("default")
Nexa:LoadConfig("default")
Nexa:DeleteConfig("default")
```
Window and overlays
```lua
Nexa:Toggle()
Nexa:Show()
Nexa:Hide()
Nexa:OpenKeybinds()
Nexa:OpenPerformance()
```
The library also supports custom overlay creation through `CreateOverlay` and `CreateBox`. See `nexa-showcase.lua` for full demonstrations, including dynamic sizing and visibility controls.
Notes
Nexa depends on executor-specific Drawing functionality. Availability of image rendering, file operations, and HTTP requests depends on the environment. This repository does not bundle those capabilities.
