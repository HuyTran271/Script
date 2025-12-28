-- UTD Hub v2.0 - Main Script
-- Loader: loadstring(game:HttpGet("YOUR_URL_HERE"))()

repeat task.wait() until game:IsLoaded()
if not game:GetService("Players").LocalPlayer then repeat task.wait() until game:GetService("Players").LocalPlayer end

local P,LP,H,R=game:GetService("Players"),game:GetService("Players").LocalPlayer,game:GetService("HttpService"),game:GetService("ReplicatedStorage")

-- Anti-Double Load
if getgenv().UTDLoaded then return warn("UTD Hub already loaded!") end
getgenv().UTDLoaded=true

-- Config
local C=getgenv().UTDConfig or{
    aj=false,ar=false,as=false,asp=false,ad=false,ab=true,hd=true,
    map="Easy",diff="Normal",dmin=5,dmax=20,
    wurl="",we=false,ww=true,wl=true,wr=true,
    rec=false,play=false,mal=true,smc="",
    macros={},racts={}
}
getgenv().UTDConfig=C

-- Utils
local function RW(n,x)task.wait(C.hd and math.random(n,x)/10 or .1)end
local function SW(t,d,c)
    if not C.we or C.wurl=="" then return end
    task.spawn(function()
        pcall(function()
            (syn and syn.request or http_request or request)({
                Url=C.wurl,Method="POST",
                Headers={["Content-Type"]="application/json"},
                Body=H:JSONEncode({embeds={{title=t,description=d,color=c or 3447003,
                footer={text=LP.Name.." | "..os.date("%X")}}}})
            })
        end)
    end)
end

-- Data
local FN="UTD_"..LP.UserId..".json"
local function LD()
    if not isfile or not readfile then return false end
    local s,d=pcall(function()return H:JSONDecode(readfile(FN))end)
    if s and d then C.macros,C.wurl,C.mal=d.m or{},d.w or"",d.a~=false return true end
    return false
end
local function SD()
    if not writefile then return end
    task.spawn(function()
        pcall(function()writefile(FN,H:JSONEncode({m=C.macros,w=C.wurl,a=C.mal,v=2}))end)
    end)
end
LD()

-- Anti-Ban
if C.ab then
    task.spawn(function()
        pcall(function()
            local m=getrawmetatable(game)
            local o=m.__namecall
            setreadonly(m,false)
            m.__namecall=newcclosure(function(s,...)
                local mt=getnamecallmethod()
                if mt=="Kick" or mt=="kick" then 
                    task.wait(9e9)
                    return 
                end
                return o(s,...)
            end)
            setreadonly(m,true)
        end)
    end)
end

-- Macro
local MC={
    new=function(n)if C.macros[n]then return false end C.macros[n]={a={},c=os.time(),d=0}SD()return true end,
    rec=function()C.rec=true C.racts={}end,
    stop=function(n)if not C.macros[n]then return false end C.macros[n].a=C.racts C.macros[n].d=#C.racts>0 and C.racts[#C.racts].ts-C.racts[1].ts or 0 SD()return true end,
    play=function(n)
        if not C.macros[n]or C.play then return end
        C.play=true
        task.spawn(function()
            local a,st=C.macros[n].a,tick()
            for i,v in ipairs(a)do
                if not C.play then break end
                local td,el=v.ts-(a[1].ts or 0),tick()-st
                if td>el then task.wait(td-el)end
                pcall(function()--Action exec end)
            end
            C.play=false
        end)
    end,
    del=function(n)C.macros[n]=nil SD()end,
    exp=function(n)return C.macros[n]and H:JSONEncode(C.macros[n])or nil end,
    imp=function(n,d)local s,m=pcall(function()return H:JSONDecode(d)end)if s then C.macros[n]=m SD()return true end return false end
}

-- GUI
local UI=loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local W=UI.CreateLib("UTD Hub v2.0","DarkTheme")

-- Tabs
local T1,T2,T3,T4,T5=W:NewTab("Main"),W:NewTab("Dungeon"),W:NewTab("Macro"),W:NewTab("Webhook"),W:NewTab("Settings")

-- Main
local M1=T1:NewSection("Auto Farm")
M1:NewDropdown("Select Map",{"Easy","Medium","Hard","Event"},function(v)C.map=v end)
M1:NewToggle("Auto Join","Join map automatically",function(v)C.aj=v end)
M1:NewToggle("Auto Retry","Retry on end",function(v)C.ar=v end)
M1:NewToggle("Auto Skip","Skip waves",function(v)C.as=v end)
M1:NewToggle("Auto Speed","Max speed",function(v)C.asp=v end)

-- Dungeon
local D1=T2:NewSection("Dungeon Farm")
D1:NewDropdown("Difficulty",{"Normal","Hard","Nightmare"},function(v)C.diff=v end)
D1:NewToggle("Auto Dungeon","Farm dungeons",function(v)C.ad=v end)

-- Macro
local MC1=T3:NewSection("Recorder")
MC1:NewTextBox("Macro Name","Enter name",function(v)C.smc=v end)
MC1:NewButton("Create New","Create macro",function()if C.smc~=""and MC.new(C.smc)then print("✓ Created")end end)
MC1:NewButton("Start Record","Begin recording",function()if C.smc~=""and C.macros[C.smc]then MC.rec()C.rec=true print("🔴 Recording...")end end)
MC1:NewButton("Stop & Save","Stop and save",function()if C.rec then C.rec=false MC.stop(C.smc)print("✓ Saved")end end)

local MC2=T3:NewSection("Playback")
MC2:NewButton("Play Macro","Execute macro",function()if C.smc~=""then MC.play(C.smc)print("▶️ Playing")end end)
MC2:NewButton("Stop Playback","Stop execution",function()C.play=false print("⏹️ Stopped")end end)
MC2:NewButton("Delete Macro","Remove macro",function()if C.smc~=""then MC.del(C.smc)print("🗑️ Deleted")end end)

local MC3=T3:NewSection("Share")
MC3:NewButton("Export","Copy to clipboard",function()local d=MC.exp(C.smc)if d then setclipboard(d)print("📋 Copied!")end end)
MC3:NewButton("Import","Paste from clipboard",function()if C.smc~=""and MC.imp(C.smc,getclipboard())then print("✓ Imported")end end)
MC3:NewToggle("Auto-Load","Load on teleport",function(v)C.mal=v SD()end)

local MC4=T3:NewSection("Saved Macros")
MC4:NewButton("Show List","Display all macros",function()
    print("━━━━━━━━━━━━━━━━━━━")
    print("SAVED MACROS:")
    for n,d in pairs(C.macros)do print(string.format("• %s (%d actions, %.1fs)",n,#d.a,d.d))end
    print("━━━━━━━━━━━━━━━━━━━")
end)

-- Webhook
local W1=T4:NewSection("Discord Webhook")
W1:NewTextBox("Webhook URL","Paste URL here",function(v)C.wurl=v SD()end)
W1:NewToggle("Enable Webhook","Toggle notifications",function(v)C.we=v end)
W1:NewToggle("Win Notify","Notify on win",function(v)C.ww=v end)
W1:NewToggle("Lose Notify","Notify on lose",function(v)C.wl=v end)
W1:NewButton("Test Webhook","Send test message",function()SW("Test 🧪","Hub is working!",3066993)print("📨 Sent")end)

-- Settings
local S1=T5:NewSection("Anti-Ban")
S1:NewToggle("Protection","Enable anti-ban",function(v)C.ab=v end)
S1:NewToggle("Humanize","Random delays",function(v)C.hd=v end)
S1:NewSlider("Min Delay","0.1-1s",10,1,function(v)C.dmin=v end)
S1:NewSlider("Max Delay","0.5-5s",50,5,function(v)C.dmax=v end)

local S2=T5:NewSection("Utilities")
S2:NewButton("Rejoin Server","Teleport to new server",function()
    game:GetService("TeleportService"):Teleport(game.PlaceId,LP)
end)
S2:NewButton("Server Hop","Find best server",function()
    local Http=game:GetService("HttpService")
    local TPS=game:GetService("TeleportService")
    local Api="https://games.roblox.com/v1/games/"
    local function Hop()
        local s,r=pcall(function()
            local servers=Http:JSONDecode(game:HttpGet(Api..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
            local server=servers.data[math.random(1,#servers.data)]
            TPS:TeleportToPlaceInstance(game.PlaceId,server.id,LP)
        end)
    end
    Hop()
end)

local S3=T5:NewSection("Info")
S3:NewLabel("UTD Hub v2.0")
S3:NewLabel("Status: ✓ Protected")
S3:NewLabel("User: "..LP.Name)

-- Auto Workers
local Workers={
    function()while task.wait(1)do if C.aj then RW(C.dmin,C.dmax)pcall(function()
        local ms=LP.PlayerGui:FindFirstChild("MapSelection")
        if ms and ms.Enabled then 
            local mb=ms:FindFirstChild(C.map,true)
            if mb then for _,v in pairs(getconnections(mb.MouseButton1Click))do v:Fire()end end 
        end
    end)end end end,
    
    function()while task.wait(2)do if C.ar then RW(C.dmin,C.dmax)pcall(function()
        local rg=LP.PlayerGui:FindFirstChild("Results")
        if rg and rg.Enabled then 
            local rb=rg:FindFirstChild("Retry",true)
            if rb then
                local win=rg:FindFirstChild("Victory",true)~=nil
                if C.we then
                    if win and C.ww then SW("Victory 🎉","Completed: "..C.map,65280)
                    elseif not win and C.wl then SW("Defeat 💀","Failed: "..C.map,16711680)end
                end
                task.wait(math.random(10,30)/10)
                for _,v in pairs(getconnections(rb.MouseButton1Click))do v:Fire()end
            end 
        end
    end)end end end,
    
    function()while task.wait(.5)do if C.as then RW(C.dmin*.5,C.dmax*.5)pcall(function()
        local gg=LP.PlayerGui:FindFirstChild("GameGui")
        if gg then 
            local sb=gg:FindFirstChild("SkipWave",true)
            if sb and sb.Visible then for _,v in pairs(getconnections(sb.MouseButton1Click))do v:Fire()end end 
        end
    end)end end end,
    
    function()while task.wait(1)do if C.asp then RW(C.dmin,C.dmax)pcall(function()
        local gg=LP.PlayerGui:FindFirstChild("GameGui")
        if gg then 
            local sp=gg:FindFirstChild("Speed",true)
            if sp and not sp.Text:match("[23]x")then
                for _,v in pairs(getconnections(sp.MouseButton1Click))do v:Fire()end 
            end
        end
    end)end end end,
    
    function()while task.wait(3)do if C.ad then RW(C.dmin*2,C.dmax*2)pcall(function()
        local dg=LP.PlayerGui:FindFirstChild("DungeonGui")
        if dg then
            local db=dg:FindFirstChild(C.diff,true)
            if db then for _,v in pairs(getconnections(db.MouseButton1Click))do v:Fire()end end
            local st=dg:FindFirstChild("Start",true)
            if st then task.wait(math.random(5,15)/10)for _,v in pairs(getconnections(st.MouseButton1Click))do v:Fire()end end
        end
    end)end end end
}

for _,w in ipairs(Workers)do task.spawn(w)end

-- Teleport Handler
LP.OnTeleport:Connect(function(s)
    if C.mal and s==Enum.TeleportState.Started then 
        SD()
        queue_on_teleport([[loadstring(game:HttpGet("YOUR_URL_HERE"))()]])
    end
end)

-- Notifications
if C.we then SW("Loaded 🚀","UTD Hub ready!",3447003)end
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("UTD HUB V2.0 | LOADED ✓")
print("Status: Protected & Ready")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━")