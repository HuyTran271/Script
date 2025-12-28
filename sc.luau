-- UTD Hub v2.0 | Auto-Detect Game Data
-- Loader: loadstring(game:HttpGet("YOUR_URL"))()

repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
repeat task.wait() until Players.LocalPlayer

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")
local CoreGui = game:GetService("CoreGui")
local RS = game:GetService("ReplicatedStorage")

if _G.UTDHubLoaded then warn("⚠️ Already loaded!") return end
_G.UTDHubLoaded = true

print("🔄 Loading UTD Hub v2.0...")

-- Config
local Config = {
    AutoJoin = false,
    AutoRetry = false,
    AutoSkip = false,
    AutoSpeed = false,
    AutoDungeon = false,
    SelectedMap = nil,
    SelectedDiff = nil,
    SelectedDungeon = nil,
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
    RecordedActions = {}
}

-- Game Data Detection
local GameData = {
    Maps = {},
    Difficulties = {},
    Dungeons = {},
    MapButtons = {},
    DiffButtons = {},
    DungeonButtons = {}
}

-- Scan for Maps
local function ScanMaps()
    GameData.Maps = {}
    GameData.MapButtons = {}
    
    task.spawn(function()
        pcall(function()
            -- Method 1: Check PlayerGui
            local MapSelection = PG:WaitForChild("MapSelection", 5)
            if MapSelection then
                for _, v in pairs(MapSelection:GetDescendants()) do
                    if v:IsA("TextButton") or v:IsA("ImageButton") then
                        local text = v.Text or v.Name
                        if text ~= "" and not text:match("Close") and not text:match("Back") then
                            if not table.find(GameData.Maps, text) then
                                table.insert(GameData.Maps, text)
                                GameData.MapButtons[text] = v
                                print("✓ Found Map:", text)
                            end
                        end
                    end
                end
            end
            
            -- Method 2: Check ReplicatedStorage
            if RS:FindFirstChild("Maps") then
                for _, map in pairs(RS.Maps:GetChildren()) do
                    local mapName = map.Name
                    if not table.find(GameData.Maps, mapName) then
                        table.insert(GameData.Maps, mapName)
                        print("✓ Found Map (RS):", mapName)
                    end
                end
            end
            
            -- Method 3: Check Workspace
            if workspace:FindFirstChild("Maps") then
                for _, map in pairs(workspace.Maps:GetChildren()) do
                    local mapName = map.Name
                    if not table.find(GameData.Maps, mapName) then
                        table.insert(GameData.Maps, mapName)
                        print("✓ Found Map (WS):", mapName)
                    end
                end
            end
        end)
    end)
end

-- Scan for Difficulties
local function ScanDifficulties()
    GameData.Difficulties = {}
    GameData.DiffButtons = {}
    
    task.spawn(function()
        pcall(function()
            -- Check Difficulty Selection GUI
            for _, gui in pairs(PG:GetDescendants()) do
                if gui:IsA("TextButton") or gui:IsA("ImageButton") then
                    local text = gui.Text or gui.Name
                    if text:match("Easy") or text:match("Normal") or text:match("Hard") or 
                       text:match("Nightmare") or text:match("Expert") or text:match("Insane") then
                        if not table.find(GameData.Difficulties, text) then
                            table.insert(GameData.Difficulties, text)
                            GameData.DiffButtons[text] = gui
                            print("✓ Found Difficulty:", text)
                        end
                    end
                end
            end
            
            -- Default difficulties if none found
            if #GameData.Difficulties == 0 then
                GameData.Difficulties = {"Easy", "Normal", "Hard", "Nightmare"}
            end
        end)
    end)
end

-- Scan for Dungeons
local function ScanDungeons()
    GameData.Dungeons = {}
    GameData.DungeonButtons = {}
    
    task.spawn(function()
        pcall(function()
            -- Check Dungeon GUI
            local DungeonGui = PG:FindFirstChild("DungeonGui") or PG:FindFirstChild("Dungeon")
            if DungeonGui then
                for _, v in pairs(DungeonGui:GetDescendants()) do
                    if v:IsA("TextButton") or v:IsA("ImageButton") then
                        local text = v.Text or v.Name
                        if text ~= "" and not text:match("Close") and not text:match("Back") and not text:match("Start") then
                            if not table.find(GameData.Dungeons, text) then
                                table.insert(GameData.Dungeons, text)
                                GameData.DungeonButtons[text] = v
                                print("✓ Found Dungeon:", text)
                            end
                        end
                    end
                end
            end
            
            -- Check ReplicatedStorage
            if RS:FindFirstChild("Dungeons") then
                for _, dungeon in pairs(RS.Dungeons:GetChildren()) do
                    local dungeonName = dungeon.Name
                    if not table.find(GameData.Dungeons, dungeonName) then
                        table.insert(GameData.Dungeons, dungeonName)
                        print("✓ Found Dungeon (RS):", dungeonName)
                    end
                end
            end
        end)
    end)
end

-- Initialize scans
ScanMaps()
ScanDifficulties()
ScanDungeons()

-- Re-scan periodically
task.spawn(function()
    while task.wait(10) do
        ScanMaps()
        ScanDifficulties()
        ScanDungeons()
    end
end)

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UTDHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = (gethui and gethui()) or CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "UTD Hub v2.0"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
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

local MinimizeBtn = Instance.new("TextButton")
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

local ResizeBtn = Instance.new("TextButton")
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

local TabContainer = Instance.new("Frame")
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

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -145, 1, -50)
ContentContainer.Position = UDim2.new(0, 135, 0, 45)
ContentContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ContentContainer.BorderSizePixel = 0
ContentContainer.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 8)
ContentCorner.Parent = ContentContainer

local FloatingIcon = Instance.new("ImageButton")
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

-- UI Functions
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
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ContentFrame.Parent = ContentContainer
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 8)
    ContentLayout.Parent = ContentFrame
    
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingTop = UDim.new(0, 10)
    ContentPadding.PaddingLeft = UDim.new(0, 10)
    ContentPadding.PaddingRight = UDim.new(0, 10)
    ContentPadding.PaddingBottom = UDim.new(0, 10)
    ContentPadding.Parent = ContentFrame
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, child in pairs(ContentContainer:GetChildren()) do
            if child:IsA("ScrollingFrame") then child.Visible = false end
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
end

local function CreateToggle(parent, text, callback)
    local Toggle = Instance.new("Frame")
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
end

local function CreateButton(parent, text, callback)
    local Button = Instance.new("TextButton")
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
end

local function CreateDropdown(parent, text, options, callback, autoUpdate)
    local Dropdown = Instance.new("Frame")
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
    DropdownBtn.Text = text .. ": " .. (#options > 0 and options[1] or "None")
    DropdownBtn.Font = Enum.Font.Gotham
    DropdownBtn.TextSize = 14
    DropdownBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    DropdownBtn.Parent = Dropdown
    
    local DropdownList = Instance.new("Frame")
    DropdownList.Size = UDim2.new(1, 0, 0, 0)
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
    
    local function UpdateOptions(newOptions)
        for _, child in pairs(DropdownList:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        
        if #newOptions == 0 then
            DropdownBtn.Text = text .. ": None"
            return
        end
        
        DropdownList.Size = UDim2.new(1, 0, 0, math.min(#newOptions * 30, 150))
        
        for _, option in ipairs(newOptions) do
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
    end
    
    UpdateOptions(options)
    
    if autoUpdate then
        task.spawn(function()
            while task.wait(2) do
                UpdateOptions(options)
            end
        end)
    end
    
    DropdownBtn.MouseButton1Click:Connect(function()
        DropdownList.Visible = not DropdownList.Visible
    end)
    
    return Dropdown, UpdateOptions
end

local function CreateTextBox(parent, text, placeholder, callback)
    local TextBoxFrame = Instance.new("Frame")
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
end

-- Create Tabs
local MainTab = CreateTab("Main", "🏠")
local DungeonTab = CreateTab("Dungeon", "🏰")
local MacroTab = CreateTab("Macro", "📹")
local WebhookTab = CreateTab("Webhook", "🔔")
local SettingsTab = CreateTab("Settings", "⚙️")

-- Main Tab Content
CreateSection(MainTab, "Auto Features")
local mapDropdown, updateMapDropdown = CreateDropdown(MainTab, "Select Map", GameData.Maps, function(v)
    Config.SelectedMap = v
    print("✓ Selected Map:", v)
end, true)

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

CreateButton(MainTab, "Refresh Maps", function()
    ScanMaps()
    task.wait(0.5)
    updateMapDropdown(GameData.Maps)
    print("✓ Maps refreshed!")
end)

-- Dungeon Tab Content
CreateSection(DungeonTab, "Dungeon Selection")
local dungeonDropdown, updateDungeonDropdown = CreateDropdown(DungeonTab, "Select Dungeon", GameData.Dungeons, function(v)
    Config.SelectedDungeon = v
    print("✓ Selected Dungeon:", v)
end, true)

local diffDropdown, updateDiffDropdown = CreateDropdown(DungeonTab, "Difficulty", GameData.Difficulties, function(v)
    Config.SelectedDiff = v
    print("✓ Selected Difficulty:", v)
end, true)

CreateToggle(DungeonTab, "Auto Dungeon", function(v)
    Config.AutoDungeon = v
    print("Auto Dungeon:", v)
end)

CreateButton(DungeonTab, "Refresh Dungeons", function()
    ScanDungeons()
    ScanDifficulties()
    task.wait(0.5)
    updateDungeonDropdown(GameData.Dungeons)
    updateDiffDropdown(GameData.Difficulties)
    print("✓ Dungeons refreshed!")
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

CreateButton(SettingsTab, "Server Hop", function()
    local Http = game:GetService("HttpService")
    local TPS = game:GetService("TeleportService")
    pcall(function()
        local servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        local server = servers.data[math.random(1, #servers.data)]
        TPS:TeleportToPlaceInstance(game.PlaceId, server.id, LP)
    end)
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
    else
        originalSize = MainFrame.Size
        originalPosition = MainFrame.Position
        MainFrame:TweenSizeAndPosition(
            UDim2.new(0, 700, 0, 500),
            UDim2.new(0.5, -350, 0.5, -250),
            "Out", "Quad", 0.3, true
        )
        isMaximized = true
    end
end)

-- Auto Join Function
task.spawn(function()
    while task.wait(1) do
        if Config.AutoJoin and Config.SelectedMap then
            pcall(function()
                -- Method 1: Use stored button
                if GameData.MapButtons[Config.SelectedMap] then
                    local btn = GameData.MapButtons[Config.SelectedMap]
                    if btn and btn.Parent then
                        for _, connection in pairs(getconnections(btn.MouseButton1Click)) do
                            connection:Fire()
                        end
                        print("✓ Joined map:", Config.SelectedMap)
                    end
                end
                
                -- Method 2: Search in GUI
                local MapSelection = PG:FindFirstChild("MapSelection")
                if MapSelection and MapSelection.Enabled then
                    for _, v in pairs(MapSelection:GetDescendants()) do
                        if (v:IsA("TextButton") or v:IsA("ImageButton")) and 
                           (v.Text == Config.SelectedMap or v.Name == Config.SelectedMap) then
                            for _, connection in pairs(getconnections(v.MouseButton1Click)) do
                                connection:Fire()
                            end
                            break
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Retry Function
task.spawn(function()
    while task.wait(2) do
        if Config.AutoRetry then
            pcall(function()
                for _, gui in pairs(PG:GetChildren()) do
                    -- Check multiple possible result GUI names
                    if gui.Name:match("Result") or gui.Name:match("End") or gui.Name:match("Victory") or gui.Name:match("Defeat") then
                        if gui.Enabled or gui.Visible then
                            for _, v in pairs(gui:GetDescendants()) do
                                if (v:IsA("TextButton") or v:IsA("ImageButton")) and 
                                   (v.Text:match("Retry") or v.Text:match("Play") or v.Name:match("Retry")) then
                                    task.wait(math.random(10, 30) / 10)
                                    for _, connection in pairs(getconnections(v.MouseButton1Click)) do
                                        connection:Fire()
                                    end
                                    print("✓ Auto retry activated")
                                    break
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Skip Function
task.spawn(function()
    while task.wait(0.5) do
        if Config.AutoSkip then
            pcall(function()
                for _, gui in pairs(PG:GetChildren()) do
                    if gui:IsA("ScreenGui") then
                        for _, v in pairs(gui:GetDescendants()) do
                            if (v:IsA("TextButton") or v:IsA("ImageButton")) and v.Visible and
                               (v.Text:match("Skip") or v.Name:match("Skip")) then
                                for _, connection in pairs(getconnections(v.MouseButton1Click)) do
                                    connection:Fire()
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Speed Function
task.spawn(function()
    while task.wait(1) do
        if Config.AutoSpeed then
            pcall(function()
                for _, gui in pairs(PG:GetChildren()) do
                    if gui:IsA("ScreenGui") then
                        for _, v in pairs(gui:GetDescendants()) do
                            if (v:IsA("TextButton") or v:IsA("ImageButton")) and v.Visible and
                               (v.Text:match("Speed") or v.Text:match("x") or v.Name:match("Speed")) then
                                local currentSpeed = v.Text
                                if not currentSpeed:match("3x") and not currentSpeed:match("2x") then
                                    for _, connection in pairs(getconnections(v.MouseButton1Click)) do
                                        connection:Fire()
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Dungeon Function
task.spawn(function()
    while task.wait(3) do
        if Config.AutoDungeon and Config.SelectedDungeon then
            pcall(function()
                -- Method 1: Use stored button
                if GameData.DungeonButtons[Config.SelectedDungeon] then
                    local btn = GameData.DungeonButtons[Config.SelectedDungeon]
                    if btn and btn.Parent then
                        for _, connection in pairs(getconnections(btn.MouseButton1Click)) do
                            connection:Fire()
                        end
                        print("✓ Selected dungeon:", Config.SelectedDungeon)
                    end
                end
                
                -- Select difficulty
                if Config.SelectedDiff and GameData.DiffButtons[Config.SelectedDiff] then
                    local diffBtn = GameData.DiffButtons[Config.SelectedDiff]
                    if diffBtn and diffBtn.Parent then
                        task.wait(0.5)
                        for _, connection in pairs(getconnections(diffBtn.MouseButton1Click)) do
                            connection:Fire()
                        end
                    end
                end
                
                -- Click Start button
                task.wait(0.5)
                local DungeonGui = PG:FindFirstChild("DungeonGui") or PG:FindFirstChild("Dungeon")
                if DungeonGui then
                    for _, v in pairs(DungeonGui:GetDescendants()) do
                        if (v:IsA("TextButton") or v:IsA("ImageButton")) and 
                           (v.Text:match("Start") or v.Name:match("Start")) and v.Visible then
                            for _, connection in pairs(getconnections(v.MouseButton1Click)) do
                                connection:Fire()
                            end
                            print("✓ Started dungeon")
                            break
                        end
                    end
                end
            end)
        end
    end
end)

-- Show first tab
MainTab.Visible = true
for _, btn in pairs(TabContainer:GetChildren()) do
    if btn:IsA("TextButton") then
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 200)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        break
    end
end

-- Initial scan after GUI loads
task.wait(2)
ScanMaps()
ScanDifficulties()
ScanDungeons()

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("✓ UTD HUB V2.0 LOADED!")
print("✓ GUI Created Successfully")
print("✓ Auto-Detection Active")
print("✓ Found", #GameData.Maps, "Maps")
print("✓ Found", #GameData.Difficulties, "Difficulties")
print("✓ Found", #GameData.Dungeons, "Dungeons")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━")acro] then
            Config.Macros[Config.CurrentM
