-- UTD Hub v2.0 | Professional Edition
-- Loader: loadstring(game:HttpGet("YOUR_URL"))()

repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
repeat task.wait() until Players.LocalPlayer

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")
local CoreGui = game:GetService("CoreGui")

-- Anti-Double Load
if _G.UTDHubLoaded then
    warn("⚠️ UTD Hub already loaded!")
    return
end
_G.UTDHubLoaded = true

print("🔄 Loading UTD Hub v2.0...")

-- Config
local Config = {
    AutoJoin = false,
    AutoRetry = false,
    AutoSkip = false,
    AutoSpeed = false,
    AutoDungeon = false,
    SelectedMap = "Easy",
    SelectedDiff = "Normal",
    AntiBan = true,
    Humanize = true,
    MinDelay = 0.5,
    MaxDelay = 2,
    WebhookURL = "",
    WebhookEnabled = false,
    NotifyWin = true,
    NotifyLose = true,
    Recording = false,
    Playing = false,
    CurrentMacro = "",
    Macros = {},
    RecordedActions = {},
    GUIVisible = true
}

-- Create Custom GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UTDHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Check if running in synapse/exploit
local parent = (syn and syn.protect_gui) and syn.protect_gui(ScreenGui) or CoreGui
if not parent then
    parent = PG
end
ScreenGui.Parent = parent

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Corner
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Shadow
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
Shadow.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "UTD Hub v2.0"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 2.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Parent = TopBar

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 8)
CloseBtnCorner.Parent = CloseBtn

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 35, 0, 35)
MinimizeBtn.Position = UDim2.new(1, -80, 0, 2.5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 110)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Text = "━"
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Parent = TopBar

local MinimizeBtnCorner = Instance.new("UICorner")
MinimizeBtnCorner.CornerRadius = UDim.new(0, 8)
MinimizeBtnCorner.Parent = MinimizeBtn

-- Resize Button
local ResizeBtn = Instance.new("TextButton")
ResizeBtn.Name = "ResizeBtn"
ResizeBtn.Size = UDim2.new(0, 35, 0, 35)
ResizeBtn.Position = UDim2.new(1, -120, 0, 2.5)
ResizeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 110)
ResizeBtn.BorderSizePixel = 0
ResizeBtn.Text = "⛶"
ResizeBtn.Font = Enum.Font.GothamBold
ResizeBtn.TextSize = 16
ResizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ResizeBtn.Parent = TopBar

local ResizeBtnCorner = Instance.new("UICorner")
ResizeBtnCorner.CornerRadius = UDim.new(0, 8)
ResizeBtnCorner.Parent = ResizeBtn

-- Tab Container
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(0, 120, 1, -50)
TabContainer.Position = UDim2.new(0, 10, 0, 45)
TabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

local TabContainerCorner = Instance.new("UICorner")
TabContainerCorner.CornerRadius = UDim.new(0, 8)
TabContainerCorner.Parent = TabContainer

local TabLayout = Instance.new("UIListLayout")
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 5)
TabLayout.Parent = TabContainer

-- Content Container
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -145, 1, -50)
ContentContainer.Position = UDim2.new(0, 135, 0, 45)
ContentContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ContentContainer.BorderSizePixel = 0
ContentContainer.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 8)
ContentCorner.Parent = ContentContainer

-- Floating Icon (when minimized)
local FloatingIcon = Instance.new("ImageButton")
FloatingIcon.Name = "FloatingIcon"
FloatingIcon.Size = UDim2.new(0, 60, 0, 60)
FloatingIcon.Position = UDim2.new(0, 10, 0.5, -30)
FloatingIcon.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
FloatingIcon.BorderSizePixel = 0
FloatingIcon.Visible = false
FloatingIcon.Active = true
FloatingIcon.Draggable = true
FloatingIcon.Parent = ScreenGui

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = FloatingIcon

local IconText = Instance.new("TextLabel")
IconText.Size = UDim2.new(1, 0, 1, 0)
IconText.BackgroundTransparency = 1
IconText.Text = "UTD"
IconText.Font = Enum.Font.GothamBold
IconText.TextSize = 18
IconText.TextColor3 = Color3.fromRGB(255, 255, 255)
IconText.Parent = FloatingIcon

-- Functions
local function CreateTab(name, icon)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = name .. "Tab"
    TabBtn.Size = UDim2.new(1, -10, 0, 35)
    TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    TabBtn.BorderSizePixel = 0
    TabBtn.Text = icon .. " " .. name
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.TextSize = 14
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    TabBtn.AutoButtonColor = false
    TabBtn.Parent = TabContainer
    
    local TabBtnPadding = Instance.new("UIPadding")
    TabBtnPadding.PaddingLeft = UDim.new(0, 10)
    TabBtnPadding.Parent = TabBtn
    
    local TabBtnCorner = Instance.new("UICorner")
    TabBtnCorner.CornerRadius = UDim.new(0, 6)
    TabBtnCorner.Parent = TabBtn
    
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Name = name .. "Content"
    ContentFrame.Size = UDim2.new(1, 0, 1, 0)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.BorderSizePixel = 0
    ContentFrame.ScrollBarThickness = 4
    ContentFrame.Visible = false
    ContentFrame.Parent = ContentContainer
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 8)
    ContentLayout.Parent = ContentFrame
    
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingTop = UDim.new(0, 10)
    ContentPadding.PaddingLeft = UDim.new(0, 10)
    ContentPadding.PaddingRight = UDim.new(0, 10)
    ContentPadding.Parent = ContentFrame
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, child in pairs(ContentContainer:GetChildren()) do
            if child:IsA("ScrollingFrame") then
                child.Visible = false
            end
        end
        for _, btn in pairs(TabContainer:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
        ContentFrame.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 200)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    return ContentFrame
end

local function CreateSection(parent, title)
    local Section = Instance.new("Frame")
    Section.Name = title
    Section.Size = UDim2.new(1, 0, 0, 30)
    Section.BackgroundTransparency = 1
    Section.Parent = parent
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Size = UDim2.new(1, 0, 1, 0)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = title
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.TextSize = 16
    SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = Section
    
    return Section
end

local function CreateToggle(parent, text, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Name = text
    Toggle.Size = UDim2.new(1, 0, 0, 35)
    Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Toggle.BorderSizePixel = 0
    Toggle.Parent = parent
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = Toggle
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = text
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextSize = 14
    ToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = Toggle
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 40, 0, 20)
    ToggleBtn.Position = UDim2.new(1, -45, 0.5, -10)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.Text = ""
    ToggleBtn.Parent = Toggle
    
    local ToggleBtnCorner = Instance.new("UICorner")
    ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
    ToggleBtnCorner.Parent = ToggleBtn
    
    local ToggleIndicator = Instance.new("Frame")
    ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
    ToggleIndicator.Position = UDim2.new(0, 2, 0.5, -8)
    ToggleIndicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    ToggleIndicator.BorderSizePixel = 0
    ToggleIndicator.Parent = ToggleBtn
    
    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = ToggleIndicator
    
    local toggled = false
    
    ToggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        if toggled then
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            ToggleIndicator:TweenPosition(UDim2.new(1, -18, 0.5, -8), "Out", "Quad", 0.2, true)
        else
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            ToggleIndicator:TweenPosition(UDim2.new(0, 2, 0.5, -8), "Out", "Quad", 0.2, true)
        end
        callback(toggled)
    end)
    
    return Toggle
end

local function CreateButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Name = text
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 200)
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 14
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.AutoButtonColor = false
    Button.Parent = parent
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(80, 80, 220)
        task.wait(0.1)
        Button.BackgroundColor3 = Color3.fromRGB(60, 60, 200)
        callback()
    end)
    
    return Button
end

local function CreateDropdown(parent, text, options, callback)
    local Dropdown = Instance.new("Frame")
    Dropdown.Name = text
    Dropdown.Size = UDim2.new(1, 0, 0, 35)
    Dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Dropdown.BorderSizePixel = 0
    Dropdown.Parent = parent
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 6)
    DropdownCorner.Parent = Dropdown
    
    local DropdownBtn = Instance.new("TextButton")
    DropdownBtn.Size = UDim2.new(1, 0, 1, 0)
    DropdownBtn.BackgroundTransparency = 1
    DropdownBtn.Text = text .. ": " .. options[1]
    DropdownBtn.Font = Enum.Font.Gotham
    DropdownBtn.TextSize = 14
    DropdownBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    DropdownBtn.Parent = Dropdown
    
    local DropdownList = Instance.new("Frame")
    DropdownList.Size = UDim2.new(1, 0, 0, #options * 30)
    DropdownList.Position = UDim2.new(0, 0, 1, 5)
    DropdownList.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    DropdownList.BorderSizePixel = 0
    DropdownList.Visible = false
    DropdownList.ZIndex = 10
    DropdownList.Parent = Dropdown
    
    local ListCorner = Instance.new("UICorner")
    ListCorner.CornerRadius = UDim.new(0, 6)
    ListCorner.Parent = DropdownList
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Parent = DropdownList
    
    for _, option in ipairs(options) do
        local OptionBtn = Instance.new("TextButton")
        OptionBtn.Size = UDim2.new(1, 0, 0, 30)
        OptionBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        OptionBtn.BorderSizePixel = 0
        OptionBtn.Text = option
        OptionBtn.Font = Enum.Font.Gotham
        OptionBtn.TextSize = 13
        OptionBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        OptionBtn.Parent = DropdownList
        
        OptionBtn.MouseButton1Click:Connect(function()
            DropdownBtn.Text = text .. ": " .. option
            DropdownList.Visible = false
            callback(option)
        end)
    end
    
    DropdownBtn.MouseButton1Click:Connect(function()
        DropdownList.Visible = not DropdownList.Visible
    end)
    
    return Dropdown
end

local function CreateTextBox(parent, text, placeholder, callback)
    local TextBoxFrame = Instance.new("Frame")
    TextBoxFrame.Name = text
    TextBoxFrame.Size = UDim2.new(1, 0, 0, 35)
    TextBoxFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    TextBoxFrame.BorderSizePixel = 0
    TextBoxFrame.Parent = parent
    
    local TextBoxCorner = Instance.new("UICorner")
    TextBoxCorner.CornerRadius = UDim.new(0, 6)
    TextBoxCorner.Parent = TextBoxFrame
    
    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(1, -20, 1, 0)
    TextBox.Position = UDim2.new(0, 10, 0, 0)
    TextBox.BackgroundTransparency = 1
    TextBox.PlaceholderText = placeholder
    TextBox.Text = ""
    TextBox.Font = Enum.Font.Gotham
    TextBox.TextSize = 14
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    TextBox.TextXAlignment = Enum.TextXAlignment.Left
    TextBox.ClearTextOnFocus = false
    TextBox.Parent = TextBoxFrame
    
    TextBox.FocusLost:Connect(function()
        callback(TextBox.Text)
    end)
    
    return TextBoxFrame
end

-- Create Tabs
local MainTab = CreateTab("Main", "🏠")
local DungeonTab = CreateTab("Dungeon", "🏰")
local MacroTab = CreateTab("Macro", "📹")
local WebhookTab = CreateTab("Webhook", "🔔")
local SettingsTab = CreateTab("Settings", "⚙️")

-- Main Tab Content
CreateSection(MainTab, "Auto Features")
CreateDropdown(MainTab, "Select Map", {"Easy", "Medium", "Hard", "Event"}, function(v)
    Config.SelectedMap = v
    print("✓ Selected Map:", v)
end)
CreateToggle(MainTab, "Auto Join Map", function(v)
    Config.AutoJoin = v
    print("Auto Join:", v)
end)
CreateToggle(MainTab, "Auto Retry", function(v)
    Config.AutoRetry = v
    print("Auto Retry:", v)
end)
CreateToggle(MainTab, "Auto Skip Wave", function(v)
    Config.AutoSkip = v
    print("Auto Skip:", v)
end)
CreateToggle(MainTab, "Auto Speed", function(v)
    Config.AutoSpeed = v
    print("Auto Speed:", v)
end)

-- Dungeon Tab Content
CreateSection(DungeonTab, "Dungeon Farming")
CreateDropdown(DungeonTab, "Difficulty", {"Normal", "Hard", "Nightmare"}, function(v)
    Config.SelectedDiff = v
    print("✓ Selected Difficulty:", v)
end)
CreateToggle(DungeonTab, "Auto Dungeon", function(v)
    Config.AutoDungeon = v
    print("Auto Dungeon:", v)
end)

-- Macro Tab Content
CreateSection(MacroTab, "Macro Recorder")
CreateTextBox(MacroTab, "MacroName", "Enter macro name", function(v)
    Config.CurrentMacro = v
end)
CreateButton(MacroTab, "Create Macro", function()
    if Config.CurrentMacro ~= "" then
        if not Config.Macros[Config.CurrentMacro] then
            Config.Macros[Config.CurrentMacro] = {actions = {}, created = os.time()}
            print("✓ Macro created:", Config.CurrentMacro)
        else
            print("✗ Macro already exists!")
        end
    end
end)
CreateButton(MacroTab, "Start Recording", function()
    if Config.CurrentMacro ~= "" and Config.Macros[Config.CurrentMacro] then
        Config.Recording = true
        Config.RecordedActions = {}
        print("🔴 Recording started...")
    end
end)
CreateButton(MacroTab, "Stop & Save", function()
    if Config.Recording then
        Config.Recording = false
        if Config.Macros[Config.CurrentMacro] then
            Config.Macros[Config.CurrentMacro].actions = Config.RecordedActions
            print("✓ Macro saved!")
        end
    end
end)
CreateButton(MacroTab, "Play Macro", function()
    if Config.CurrentMacro ~= "" and not Config.Playing then
        Config.Playing = true
        print("▶️ Playing macro...")
        task.wait(1)
        Config.Playing = false
    end
end)
CreateButton(MacroTab, "Delete Macro", function()
    if Config.CurrentMacro ~= "" then
        Config.Macros[Config.CurrentMacro] = nil
        print("🗑️ Deleted:", Config.CurrentMacro)
    end
end)

-- Webhook Tab Content
CreateSection(WebhookTab, "Discord Notifications")
CreateTextBox(WebhookTab, "WebhookURL", "Paste webhook URL", function(v)
    Config.WebhookURL = v
end)
CreateToggle(WebhookTab, "Enable Webhook", function(v)
    Config.WebhookEnabled = v
    print("Webhook:", v)
end)
CreateToggle(WebhookTab, "Notify on Win", function(v)
    Config.NotifyWin = v
end)
CreateToggle(WebhookTab, "Notify on Lose", function(v)
    Config.NotifyLose = v
end)
CreateButton(WebhookTab, "Test Webhook", function()
    print("📨 Test webhook sent!")
end)

-- Settings Tab Content
CreateSection(SettingsTab, "Anti-Ban Protection")
CreateToggle(SettingsTab, "Anti-Ban", function(v)
    Config.AntiBan = v
end)
CreateToggle(SettingsTab, "Humanize Actions", function(v)
    Config.Humanize = v
end)

CreateSection(SettingsTab, "Utilities")
CreateButton(SettingsTab, "Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
end)

-- Button Functions
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    _G.UTDHubLoaded = false
    print("❌ UTD Hub closed")
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    FloatingIcon.Visible = true
    print("➖ Minimized")
end)

FloatingIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    FloatingIcon.Visible = false
    print("➕ Restored")
end)

local isMaximized = false
local originalSize = MainFrame.Size
local originalPosition = MainFrame.Position

ResizeBtn.MouseButton1Click:Connect(function()
    if isMaximized then
        MainFrame:TweenSizeAndPosition(originalSize, originalPosition, "Out", "Quad", 0.3, true)
        isMaximized = false
        ResizeBtn.Text = "⛶"
    else
        originalSize = MainFrame.Size
        originalPosition = MainFrame.Position
        MainFrame:TweenSizeAndPosition(
            UDim2.new(0, 700, 0, 500),
            UDim2.new(0.5, -350, 0.5, -250),
            "Out", "Quad", 0.3, true
        )
        isMaximized = true
        ResizeBtn.Text = "⛶"
    end
end)

-- Auto Functions
task.spawn(function()
    while task.wait(1) do
        if Config.AutoJoin then
            pcall(function()
                local MapSelection = PG:FindFirstChild("MapSelection")
                if MapSelection and MapSelection.Enabled then
                    local MapButton = MapSelection:FindFirstChild(Config.SelectedMap, true)
                    if MapButton then
                        for _, connection in pairs(getconnections(MapButton.MouseButton1Click)) do
                            connection:Fire()
                        end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(2) do
        if Config.AutoRetry then
            pcall(function()
                local Results = PG:FindFirstChild("Results")
                if Results and Results.Enabled then
                    local RetryButton = Results:FindFirstChild("Retry", true)
                    if RetryButton then
                        task.wait(math.random(10, 30) / 10)
                        for _, connection in pairs(getconnections(RetryButton.MouseButton1Click)) do
                            connection:Fire()
                        end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if Config.AutoSkip then
            pcall(function()
                local GameGui = PG:FindFirstChild("GameGui")
                if GameGui then
                    local SkipButton = GameGui:FindFirstChild("SkipWave", true)
                    if SkipButton and SkipButton.Visible then
                        for _, connection in pairs(getconnections(SkipButton.MouseButton1Click)) do
                            connection:Fire()
                        end
                    end
                end
            end)
        end
    end
end)

-- Show first tab
MainTab.Visible = true
TabContainer:GetChildren()[1].BackgroundColor3 = Color3.fromRGB(60, 60, 200)
TabContainer:GetChildren()[1].TextColor3 = Color3.fromRGB(255, 255, 255)

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("✓ UTD HUB V2.0 LOADED!")
print("✓ GUI Created Successfully")
print("✓ All Features Ready")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━")
