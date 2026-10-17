-- CAT_HUB_Library.lua
-- CAT HUB | CATJack.gg
-- Fluent-inspired, black-and-yellow adaptive Roblox UI components.
-- Use as a ModuleScript in Roblox Studio. This is a UI library only:
-- connect callbacks to your own legitimate game features.

local CAT = {}
CAT.__index = CAT

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local COLORS = {
    Background = Color3.fromRGB(8, 10, 13),
    Panel = Color3.fromRGB(15, 18, 23),
    Panel2 = Color3.fromRGB(21, 25, 31),
    Border = Color3.fromRGB(48, 54, 63),
    Yellow = Color3.fromRGB(255, 214, 0),
    YellowDark = Color3.fromRGB(201, 163, 0),
    Text = Color3.fromRGB(245, 247, 250),
    Muted = Color3.fromRGB(160, 168, 179),
    Green = Color3.fromRGB(42, 220, 125),
    Red = Color3.fromRGB(255, 91, 91),
}

local function create(className, props, parent)
    local obj = Instance.new(className)
    for key, value in pairs(props or {}) do
        obj[key] = value
    end
    obj.Parent = parent
    return obj
end

local function corner(parent, radius)
    return create("UICorner", {CornerRadius = UDim.new(0, radius or 8)}, parent)
end

local function stroke(parent, color, thickness, transparency)
    return create("UIStroke", {
        Color = color or COLORS.Border,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
    }, parent)
end

local function label(parent, text, size, color, font)
    return create("TextLabel", {
        BackgroundTransparency = 1,
        Text = text or "",
        TextColor3 = color or COLORS.Text,
        TextSize = size or 14,
        Font = font or Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        Size = UDim2.new(1, 0, 0, 22),
    }, parent)
end

local function button(parent, text, size)
    local b = create("TextButton", {
        AutoButtonColor = false,
        Text = text or "",
        TextColor3 = COLORS.Text,
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        BackgroundColor3 = COLORS.Panel2,
        Size = size or UDim2.new(1, 0, 0, 36),
    }, parent)
    corner(b, 8)
    stroke(b)
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(31, 36, 43)}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = COLORS.Panel2}):Play()
    end)
    return b
end

function CAT:Notify(title, message, duration)
    duration = duration or 3
    local toast = create("Frame", {
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -16, 1, -16),
        Size = UDim2.new(0, 270, 0, 76),
        BackgroundColor3 = COLORS.Panel,
        ZIndex = 20,
    }, self.ToastLayer)
    corner(toast, 10)
    stroke(toast, COLORS.Yellow, 1, 0.15)
    local bar = create("Frame", {
        BackgroundColor3 = COLORS.Yellow,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 4, 1, -16),
        Position = UDim2.new(0, 8, 0, 8),
        ZIndex = 21,
    }, toast)
    corner(bar, 2)
    local t = label(toast, title or "CAT HUB", 14, COLORS.Yellow, Enum.Font.GothamBold)
    t.Position = UDim2.new(0, 22, 0, 9)
    t.Size = UDim2.new(1, -32, 0, 20)
    t.ZIndex = 21
    local m = label(toast, message or "", 12, COLORS.Muted)
    m.Position = UDim2.new(0, 22, 0, 32)
    m.Size = UDim2.new(1, -32, 0, 32)
    m.TextWrapped = true
    m.ZIndex = 21
    toast.Position = UDim2.new(1, 300, 1, -16)
    TweenService:Create(toast, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {
        Position = UDim2.new(1, -16, 1, -16)
    }):Play()
    task.delay(duration, function()
        if toast.Parent then
            local tween = TweenService:Create(toast, TweenInfo.new(0.18), {
                Position = UDim2.new(1, 300, 1, -16),
                BackgroundTransparency = 1
            })
            tween:Play()
            tween.Completed:Wait()
            toast:Destroy()
        end
    end)
end

function CAT:CreateWindow(options)
    options = options or {}
    local player = Players.LocalPlayer
    assert(player, "CAT HUB must be started from a LocalScript.")

    local gui = create("ScreenGui", {
        Name = "CAT_HUB_UI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, player:WaitForChild("PlayerGui"))

    local root = create("Frame", {
        Name = "Window",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(0, 760, 0, 500),
        BackgroundColor3 = COLORS.Background,
        ClipsDescendants = true,
    }, gui)
    corner(root, 12)
    stroke(root, COLORS.Yellow, 1, 0.38)

    local scale = create("UIScale", {Scale = 1}, root)
    local function adapt()
        local camera = workspace.CurrentCamera
        if not camera then return end
        local vp = camera.ViewportSize
        if vp.X < 620 or vp.Y < 520 then
            scale.Scale = math.clamp(math.min((vp.X - 18) / 760, (vp.Y - 18) / 500), 0.48, 0.82)
        else
            scale.Scale = math.clamp(math.min((vp.X - 40) / 760, (vp.Y - 40) / 500), 0.78, 1)
        end
    end
    adapt()
    if workspace.CurrentCamera then
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(adapt)
    end

    local header = create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 62),
        BackgroundColor3 = Color3.fromRGB(5, 7, 9),
        BorderSizePixel = 0,
    }, root)
    local logo = create("Frame", {
        Position = UDim2.new(0, 14, 0, 10),
        Size = UDim2.new(0, 40, 0, 40),
        BackgroundColor3 = COLORS.Yellow,
    }, header)
    corner(logo, 10)
    local logoText = create("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Text = "CAT",
        TextColor3 = COLORS.Background,
        Font = Enum.Font.GothamBlack,
        TextSize = 12,
    }, logo)
    local title = create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 64, 0, 8),
        Size = UDim2.new(0, 240, 0, 27),
        Text = options.Title or "CAT HUB",
        TextColor3 = COLORS.Yellow,
        Font = Enum.Font.GothamBlack,
        TextSize = 22,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, header)
    local subtitle = create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 65, 0, 33),
        Size = UDim2.new(0, 240, 0, 18),
        Text = options.Subtitle or "by CATJack.gg",
        TextColor3 = COLORS.Muted,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, header)

    local minimize = button(header, "—", UDim2.new(0, 34, 0, 32))
    minimize.Position = UDim2.new(1, -80, 0, 15)
    minimize.BackgroundColor3 = COLORS.Panel
    local close = button(header, "×", UDim2.new(0, 34, 0, 32))
    close.Position = UDim2.new(1, -40, 0, 15)
    close.BackgroundColor3 = COLORS.Panel

    local sidebar = create("Frame", {
        Name = "Sidebar",
        Position = UDim2.new(0, 0, 0, 62),
        Size = UDim2.new(0, 176, 1, -62),
        BackgroundColor3 = Color3.fromRGB(10, 13, 16),
        BorderSizePixel = 0,
    }, root)
    create("UIPadding", {
        PaddingTop = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
    }, sidebar)
    create("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, sidebar)

    local content = create("ScrollingFrame", {
        Name = "Content",
        Position = UDim2.new(0, 188, 0, 74),
        Size = UDim2.new(1, -200, 1, -86),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = COLORS.Yellow,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, root)
    create("UIPadding", {
        PaddingTop = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
    }, content)
    local contentLayout = create("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, content)

    local toastLayer = create("Frame", {
        Name = "Notifications",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 20,
    }, gui)

    local self = setmetatable({
        Gui = gui,
        Root = root,
        Sidebar = sidebar,
        Content = content,
        ToastLayer = toastLayer,
        Tabs = {},
        ActiveTab = nil,
        _tabButtons = {},
        _minimized = false,
    }, CAT)

    local dragging, dragStart, startPosition
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = root.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            root.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X,
                startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    minimize.Activated:Connect(function()
        self._minimized = not self._minimized
        sidebar.Visible = not self._minimized
        content.Visible = not self._minimized
        root.Size = self._minimized and UDim2.new(0, 300, 0, 62) or UDim2.new(0, 760, 0, 500)
        minimize.Text = self._minimized and "□" or "—"
        adapt()
    end)
    close.Activated:Connect(function()
        gui:Destroy()
    end)

    function self:CreateTab(tabOptions)
        tabOptions = tabOptions or {}
        local tabName = tabOptions.Name or "Tab"
        local tabButton = button(sidebar, (tabOptions.Icon and (tabOptions.Icon .. "  ") or "") .. tabName,
            UDim2.new(1, 0, 0, 38))
        tabButton.TextXAlignment = Enum.TextXAlignment.Left
        tabButton.TextSize = 13
        local pad = create("UIPadding", {
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 6),
        }, tabButton)

        local page = create("Frame", {
            Name = tabName .. "Page",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Visible = false,
        }, content)
        create("UIListLayout", {
            Padding = UDim.new(0, 9),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, page)

        local tab = {Name = tabName, Button = tabButton, Page = page}
        table.insert(self.Tabs, tab)
        table.insert(self._tabButtons, tabButton)

        local function activate()
            for _, other in ipairs(self.Tabs) do
                other.Page.Visible = false
                other.Button.BackgroundColor3 = COLORS.Panel2
                other.Button.TextColor3 = COLORS.Text
                for _, child in ipairs(other.Button:GetChildren()) do
                    if child:IsA("UIStroke") then child.Color = COLORS.Border end
                end
            end
            page.Visible = true
            tabButton.BackgroundColor3 = COLORS.Yellow
            tabButton.TextColor3 = COLORS.Background
            for _, child in ipairs(tabButton:GetChildren()) do
                if child:IsA("UIStroke") then child.Color = COLORS.Yellow end
            end
            self.ActiveTab = tab
        end
        tabButton.Activated:Connect(activate)
        if #self.Tabs == 1 then activate() end

        local function addSection(titleText)
            local section = create("Frame", {
                BackgroundColor3 = COLORS.Panel,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
            }, page)
            corner(section, 9)
            stroke(section, COLORS.Border, 1, 0.25)
            create("UIPadding", {
                PaddingTop = UDim.new(0, 10),
                PaddingBottom = UDim.new(0, 10),
                PaddingLeft = UDim.new(0, 12),
                PaddingRight = UDim.new(0, 12),
            }, section)
            local layout = create("UIListLayout", {
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder,
            }, section)
            local heading = label(section, titleText or "Section", 14, COLORS.Yellow, Enum.Font.GothamBold)
            heading.LayoutOrder = 0
            heading.Size = UDim2.new(1, 0, 0, 22)

            local controls = {}

            function controls:CreateLabel(text)
                local l = label(section, text, 13, COLORS.Muted)
                l.Size = UDim2.new(1, 0, 0, 22)
                return l
            end

            function controls:CreateButton(opts)
                opts = opts or {}
                local b = button(section, opts.Name or "Button", UDim2.new(1, 0, 0, 36))
                b.Activated:Connect(function()
                    if opts.Callback then opts.Callback() end
                end)
                return b
            end

            function controls:CreateToggle(opts)
                opts = opts or {}
                local row = create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 34),
                }, section)
                local textLabel = label(row, opts.Name or "Toggle", 13, COLORS.Text)
                textLabel.Size = UDim2.new(1, -62, 1, 0)
                local switch = create("TextButton", {
                    AutoButtonColor = false,
                    Text = "",
                    Position = UDim2.new(1, -48, 0.5, -11),
                    Size = UDim2.new(0, 44, 0, 22),
                    BackgroundColor3 = COLORS.Panel2,
                }, row)
                corner(switch, 11)
                local knob = create("Frame", {
                    Position = UDim2.new(0, 3, 0, 3),
                    Size = UDim2.new(0, 16, 0, 16),
                    BackgroundColor3 = COLORS.Text,
                }, switch)
                corner(knob, 8)
                local value = opts.Default == true
                local function setValue(v, fire)
                    value = v == true
                    TweenService:Create(switch, TweenInfo.new(0.14), {
                        BackgroundColor3 = value and COLORS.Yellow or COLORS.Panel2
                    }):Play()
                    TweenService:Create(knob, TweenInfo.new(0.14), {
                        Position = value and UDim2.new(1, -19, 0, 3) or UDim2.new(0, 3, 0, 3),
                        BackgroundColor3 = value and COLORS.Background or COLORS.Text
                    }):Play()
                    if fire and opts.Callback then opts.Callback(value) end
                end
                switch.Activated:Connect(function() setValue(not value, true) end)
                setValue(value, false)
                return {Get = function() return value end, Set = function(_, v) setValue(v, true) end}
            end

            function controls:CreateSlider(opts)
                opts = opts or {}
                local min = opts.Min or 0
                local max = opts.Max or 100
                local value = math.clamp(opts.Default or min, min, max)
                local row = create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 58),
                }, section)
                local nameLabel = label(row, opts.Name or "Slider", 13, COLORS.Text)
                nameLabel.Size = UDim2.new(0.75, 0, 0, 20)
                local valueLabel = label(row, tostring(value), 12, COLORS.Muted)
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                valueLabel.Position = UDim2.new(0.75, 0, 0, 0)
                valueLabel.Size = UDim2.new(0.25, 0, 0, 20)
                local track = create("TextButton", {
                    AutoButtonColor = false,
                    Text = "",
                    Position = UDim2.new(0, 0, 0, 31),
                    Size = UDim2.new(1, 0, 0, 8),
                    BackgroundColor3 = COLORS.Panel2,
                }, row)
                corner(track, 4)
                local fill = create("Frame", {
                    BackgroundColor3 = COLORS.Yellow,
                    Size = UDim2.new((value - min) / math.max(1, max - min), 0, 1, 0),
                }, track)
                corner(fill, 4)
                local knob = create("Frame", {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new((value - min) / math.max(1, max - min), 0, 0.5, 0),
                    Size = UDim2.new(0, 14, 0, 14),
                    BackgroundColor3 = COLORS.Yellow,
                }, track)
                corner(knob, 7)
                local function update(input)
                    local pct = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    value = math.floor((min + (max - min) * pct) + 0.5)
                    fill.Size = UDim2.new(pct, 0, 1, 0)
                    knob.Position = UDim2.new(pct, 0, 0.5, 0)
                    valueLabel.Text = tostring(value)
                    if opts.Callback then opts.Callback(value) end
                end
                local sliding = false
                track.Activated:Connect(function(input)
                    if input and input.UserInputType == Enum.UserInputType.Touch then update(input) end
                end)
                track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = true
                        update(input)
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        update(input)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliding = false
                    end
                end)
                return {Get = function() return value end}
            end

            function controls:CreateDropdown(opts)
                opts = opts or {}
                local values = opts.Options or {"Option 1", "Option 2"}
                local current = opts.Default or values[1]
                local b = button(section, (opts.Name or "Dropdown") .. "  ·  " .. tostring(current) .. "  ▾",
                    UDim2.new(1, 0, 0, 36))
                b.TextXAlignment = Enum.TextXAlignment.Left
                create("UIPadding", {PaddingLeft = UDim.new(0, 10)}, b)
                local opened = false
                local menu
                b.Activated:Connect(function()
                    if opened then
                        if menu then menu:Destroy() end
                        opened = false
                        return
                    end
                    opened = true
                    menu = create("Frame", {
                        BackgroundColor3 = COLORS.Panel2,
                        Size = UDim2.new(1, 0, 0, math.min(#values * 30, 150)),
                    }, section)
                    corner(menu, 7)
                    stroke(menu)
                    local scroll = create("ScrollingFrame", {
                        BackgroundTransparency = 1,
                        Size = UDim2.fromScale(1, 1),
                        CanvasSize = UDim2.new(0, 0, 0, #values * 30),
                        ScrollBarThickness = 3,
                    }, menu)
                    create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder}, scroll)
                    for _, item in ipairs(values) do
                        local option = button(scroll, tostring(item), UDim2.new(1, -6, 0, 28))
                        option.BackgroundColor3 = COLORS.Panel2
                        option.Activated:Connect(function()
                            current = item
                            b.Text = (opts.Name or "Dropdown") .. "  ·  " .. tostring(current) .. "  ▾"
                            menu:Destroy()
                            opened = false
                            if opts.Callback then opts.Callback(current) end
                        end)
                    end
                end)
                return {Get = function() return current end}
            end

            return controls
        end

        function tab:CreateSection(titleText)
            return addSection(titleText)
        end
        return tab
    end

    return self
end

return CAT
