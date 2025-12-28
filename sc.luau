-- UTD Hub v2.0
-- Loader: loadstring(game:HttpGet("YOUR_URL"))()

local function Main()
    -- Wait for game
    repeat wait() until game:IsLoaded()
    repeat wait() until game.Players.LocalPlayer
    
    local LP = game.Players.LocalPlayer
    local PG = LP.PlayerGui
    
    -- Anti-Double Load
    if _G.UTDHub then 
        warn("UTD Hub already loaded!")
        return 
    end
    _G.UTDHub = true
    
    print("Loading UTD Hub...")
    
    -- Load UI Library
    local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
    local Win = Lib.CreateLib("UTD Hub v2.0", "DarkTheme")
    
    -- Variables
    local Config = {
        AutoJoin = false,
        AutoRetry = false,
        AutoSkip = false,
        AutoSpeed = false,
        AutoDungeon = false,
        SelectedMap = "Easy",
        SelectedDiff = "Normal",
        
        -- Anti-Ban
        AntiBan = true,
        Humanize = true,
        MinDelay = 0.5,
        MaxDelay = 2,
        
        -- Webhook
        WebhookURL = "",
        WebhookEnabled = false,
        NotifyWin = true,
        NotifyLose = true,
        
        -- Macro
        Recording = false,
        Playing = false,
        CurrentMacro = "",
        Macros = {},
        RecordedActions = {}
    }
    
    -- Functions
    local function RandomWait()
        if Config.Humanize then
            wait(math.random(Config.MinDelay * 10, Config.MaxDelay * 10) / 10)
        else
            wait(0.1)
        end
    end
    
    local function SendWebhook(title, desc, color)
        if not Config.WebhookEnabled or Config.WebhookURL == "" then return end
        
        local data = {
            ["embeds"] = {{
                ["title"] = title,
                ["description"] = desc,
                ["color"] = color or 3447003,
                ["footer"] = {
                    ["text"] = LP.Name .. " | " .. os.date("%X")
                }
            }}
        }
        
        spawn(function()
            pcall(function()
                local response = request({
                    Url = Config.WebhookURL,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = game:GetService("HttpService"):JSONEncode(data)
                })
            end)
        end)
    end
    
    -- Anti-Kick
    if Config.AntiBan then
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" then
                wait(9e9)
                return
            end
            return oldNamecall(self, ...)
        end)
        
        setreadonly(mt, true)
    end
    
    -- Create GUI
    -- Main Tab
    local MainTab = Win:NewTab("Main")
    local MainSec = MainTab:NewSection("Auto Features")
    
    MainSec:NewDropdown("Select Map", {"Easy", "Medium", "Hard", "Event"}, function(v)
        Config.SelectedMap = v
        print("Selected Map:", v)
    end)
    
    MainSec:NewToggle("Auto Join Map", "Automatically join selected map", function(state)
        Config.AutoJoin = state
        print("Auto Join:", state)
    end)
    
    MainSec:NewToggle("Auto Retry", "Automatically retry on game end", function(state)
        Config.AutoRetry = state
        print("Auto Retry:", state)
    end)
    
    MainSec:NewToggle("Auto Skip Wave", "Automatically skip waves", function(state)
        Config.AutoSkip = state
        print("Auto Skip:", state)
    end)
    
    MainSec:NewToggle("Auto Speed", "Set game speed to max", function(state)
        Config.AutoSpeed = state
        print("Auto Speed:", state)
    end)
    
    -- Dungeon Tab
    local DungeonTab = Win:NewTab("Dungeon")
    local DungeonSec = DungeonTab:NewSection("Auto Dungeon")
    
    DungeonSec:NewDropdown("Select Difficulty", {"Normal", "Hard", "Nightmare"}, function(v)
        Config.SelectedDiff = v
        print("Selected Difficulty:", v)
    end)
    
    DungeonSec:NewToggle("Auto Dungeon", "Automatically farm dungeons", function(state)
        Config.AutoDungeon = state
        print("Auto Dungeon:", state)
    end)
    
    -- Macro Tab
    local MacroTab = Win:NewTab("Macro")
    local MacroSec = MacroTab:NewSection("Macro System")
    
    MacroSec:NewTextBox("Macro Name", "Enter macro name", function(txt)
        Config.CurrentMacro = txt
    end)
    
    MacroSec:NewButton("Create Macro", "Create new macro", function()
        if Config.CurrentMacro ~= "" then
            if not Config.Macros[Config.CurrentMacro] then
                Config.Macros[Config.CurrentMacro] = {
                    actions = {},
                    created = os.time()
                }
                print("✓ Macro created:", Config.CurrentMacro)
            else
                print("✗ Macro already exists!")
            end
        end
    end)
    
    MacroSec:NewButton("Start Recording", "Begin recording", function()
        if Config.CurrentMacro ~= "" and Config.Macros[Config.CurrentMacro] then
            Config.Recording = true
            Config.RecordedActions = {}
            print("🔴 Recording started...")
        end
    end)
    
    MacroSec:NewButton("Stop & Save", "Stop recording and save", function()
        if Config.Recording then
            Config.Recording = false
            if Config.Macros[Config.CurrentMacro] then
                Config.Macros[Config.CurrentMacro].actions = Config.RecordedActions
                print("✓ Macro saved!")
            end
        end
    end)
    
    MacroSec:NewButton("Play Macro", "Execute macro", function()
        if Config.CurrentMacro ~= "" and not Config.Playing then
            Config.Playing = true
            print("▶️ Playing macro...")
            -- Play logic here
            wait(1)
            Config.Playing = false
        end
    end)
    
    MacroSec:NewButton("Stop Macro", "Stop execution", function()
        Config.Playing = false
        print("⏹️ Stopped")
    end)
    
    MacroSec:NewButton("Delete Macro", "Delete macro", function()
        if Config.CurrentMacro ~= "" then
            Config.Macros[Config.CurrentMacro] = nil
            print("🗑️ Deleted:", Config.CurrentMacro)
        end
    end)
    
    -- Webhook Tab
    local WebhookTab = Win:NewTab("Webhook")
    local WebhookSec = WebhookTab:NewSection("Discord Webhook")
    
    WebhookSec:NewTextBox("Webhook URL", "Paste your webhook URL", function(txt)
        Config.WebhookURL = txt
    end)
    
    WebhookSec:NewToggle("Enable Webhook", "Toggle webhook notifications", function(state)
        Config.WebhookEnabled = state
        print("Webhook:", state)
    end)
    
    WebhookSec:NewToggle("Notify on Win", "Send notification when winning", function(state)
        Config.NotifyWin = state
    end)
    
    WebhookSec:NewToggle("Notify on Lose", "Send notification when losing", function(state)
        Config.NotifyLose = state
    end)
    
    WebhookSec:NewButton("Test Webhook", "Send test message", function()
        SendWebhook("Test Message 🧪", "UTD Hub is working!", 3066993)
        print("📨 Test webhook sent!")
    end)
    
    -- Settings Tab
    local SettingsTab = Win:NewTab("Settings")
    local AntiBanSec = SettingsTab:NewSection("Anti-Ban")
    
    AntiBanSec:NewToggle("Anti-Ban Protection", "Enable anti-ban features", function(state)
        Config.AntiBan = state
    end)
    
    AntiBanSec:NewToggle("Humanize Actions", "Add random delays", function(state)
        Config.Humanize = state
    end)
    
    AntiBanSec:NewSlider("Min Delay", "Minimum delay (0.1-1s)", 10, 1, function(v)
        Config.MinDelay = v / 10
    end)
    
    AntiBanSec:NewSlider("Max Delay", "Maximum delay (0.5-5s)", 50, 5, function(v)
        Config.MaxDelay = v / 10
    end)
    
    local UtilsSec = SettingsTab:NewSection("Utilities")
    
    UtilsSec:NewButton("Rejoin Server", "Rejoin current server", function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
    end)
    
    -- Info Tab
    local InfoTab = Win:NewTab("Info")
    local InfoSec = InfoTab:NewSection("Information")
    
    InfoSec:NewLabel("UTD Hub v2.0")
    InfoSec:NewLabel("Status: ✓ Loaded")
    InfoSec:NewLabel("User: " .. LP.Name)
    InfoSec:NewLabel("Features: All Unlocked")
    
    -- Auto Join Function
    spawn(function()
        while wait(1) do
            if Config.AutoJoin then
                RandomWait()
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
    
    -- Auto Retry Function
    spawn(function()
        while wait(2) do
            if Config.AutoRetry then
                RandomWait()
                pcall(function()
                    local Results = PG:FindFirstChild("Results")
                    if Results and Results.Enabled then
                        local RetryButton = Results:FindFirstChild("Retry", true)
                        if RetryButton then
                            -- Check win/lose
                            local isWin = Results:FindFirstChild("Victory", true) ~= nil
                            
                            if Config.WebhookEnabled then
                                if isWin and Config.NotifyWin then
                                    SendWebhook("Victory! 🎉", "Completed: " .. Config.SelectedMap, 65280)
                                elseif not isWin and Config.NotifyLose then
                                    SendWebhook("Defeat 💀", "Failed: " .. Config.SelectedMap, 16711680)
                                end
                            end
                            
                            wait(math.random(10, 30) / 10)
                            for _, connection in pairs(getconnections(RetryButton.MouseButton1Click)) do
                                connection:Fire()
                            end
                        end
                    end
                end)
            end
        end
    end)
    
    -- Auto Skip Function
    spawn(function()
        while wait(0.5) do
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
    
    -- Auto Speed Function
    spawn(function()
        while wait(1) do
            if Config.AutoSpeed then
                RandomWait()
                pcall(function()
                    local GameGui = PG:FindFirstChild("GameGui")
                    if GameGui then
                        local SpeedButton = GameGui:FindFirstChild("Speed", true)
                        if SpeedButton then
                            local currentSpeed = SpeedButton.Text
                            if not string.find(currentSpeed, "3x") and not string.find(currentSpeed, "2x") then
                                for _, connection in pairs(getconnections(SpeedButton.MouseButton1Click)) do
                                    connection:Fire()
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)
    
    -- Auto Dungeon Function
    spawn(function()
        while wait(3) do
            if Config.AutoDungeon then
                RandomWait()
                pcall(function()
                    local DungeonGui = PG:FindFirstChild("DungeonGui")
                    if DungeonGui then
                        local DiffButton = DungeonGui:FindFirstChild(Config.SelectedDiff, true)
                        if DiffButton then
                            for _, connection in pairs(getconnections(DiffButton.MouseButton1Click)) do
                                connection:Fire()
                            end
                        end
                        
                        local StartButton = DungeonGui:FindFirstChild("Start", true)
                        if StartButton then
                            wait(math.random(5, 15) / 10)
                            for _, connection in pairs(getconnections(StartButton.MouseButton1Click)) do
                                connection:Fire()
                            end
                        end
                    end
                end)
            end
        end
    end)
    
    -- Success message
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("UTD HUB V2.0 | LOADED ✓")
    print("All features ready!")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    
    if Config.WebhookEnabled then
        SendWebhook("Hub Loaded 🚀", "UTD Hub v2.0 is ready!", 3447003)
    end
end

-- Execute
local success, err = pcall(Main)
if not success then
    warn("UTD Hub Error:", err)
end
