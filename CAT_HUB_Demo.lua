-- CAT_HUB_Demo.lua
-- Put CAT_HUB_Library.lua in a ModuleScript named CAT_HUB_Library.
-- Put this demo in a LocalScript under StarterPlayerScripts.
-- The example controls only demonstrate UI callbacks; they do not automate gameplay.

local CAT = require(game:GetService("ReplicatedStorage"):WaitForChild("CAT_HUB_Library"))

local Window = CAT:CreateWindow({
    Title = "CAT HUB",
    Subtitle = "by CATJack.gg",
})

local Home = Window:CreateTab({Name = "Home", Icon = "⌂"})
local Settings = Window:CreateTab({Name = "Settings", Icon = "⚙"})
local Info = Window:CreateTab({Name = "Info", Icon = "ⓘ"})

local welcome = Home:CreateSection("Welcome")
welcome:CreateLabel("Fluent-inspired layout • Black & neon yellow")
welcome:CreateLabel("Responsive demo controls for CAT HUB.")
welcome:CreateButton({
    Name = "Show Demo Notification",
    Callback = function()
        Window:Notify("CAT HUB", "Your demo notification is working!", 3)
    end,
})

local examples = Home:CreateSection("Example Controls")
examples:CreateToggle({
    Name = "Example Toggle",
    Default = false,
    Callback = function(value)
        print("Example Toggle:", value)
    end,
})
examples:CreateSlider({
    Name = "Example Speed",
    Min = 10,
    Max = 180,
    Default = 120,
    Callback = function(value)
        print("Example Speed:", value)
    end,
})
examples:CreateDropdown({
    Name = "Select Mode",
    Options = {"Melee", "Sword", "Gun", "Fruit"},
    Default = "Melee",
    Callback = function(value)
        print("Selected Mode:", value)
    end,
})

local settings = Settings:CreateSection("Preferences")
settings:CreateToggle({
    Name = "Show UI Hints",
    Default = true,
    Callback = function(value)
        print("Show UI Hints:", value)
    end,
})
settings:CreateDropdown({
    Name = "Accent Preset",
    Options = {"CAT Yellow", "White", "Cyan"},
    Default = "CAT Yellow",
    Callback = function(value)
        print("Accent preset selected:", value)
        Window:Notify("Appearance", "Selected " .. value .. " (demo only).", 3)
    end,
})

local about = Info:CreateSection("About CAT HUB")
about:CreateLabel("CAT HUB UI Library")
about:CreateLabel("Credits: CATJack.gg")
about:CreateLabel("This is a reusable UI demo, not a gameplay automation script.")

Window:Notify("Welcome!", "CAT HUB demo loaded successfully.", 4)
