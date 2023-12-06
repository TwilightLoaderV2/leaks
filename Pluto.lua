repeat
    wait()
until game:IsLoaded()
loadstring(game:HttpGet("https://raw.githubusercontent.com/PawsThePaw/Plutonium.Utilities/main/PlutoBypass.lua.txt"))()
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local AkaliNotif = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua"))();
local LookAt = nil
local Paws = false
local Debug = false
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = players.LocalPlayer
local LookAtMethod = "Player CFrame"
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 9e9)
local Balls = workspace:WaitForChild("Balls", 9e9)
local DeflectionMethod = "Remote"
local parryButtonPress = replicatedStorage.Remotes.ParryButtonPress
local DistanceToHit = 10
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Balls = game:GetService("Workspace").Balls
local IsTargeted = false
local CanHit = false
for i,v in next, getconnections(LogService.MessageOut) do
	v:Enable()
end
for i,v in next, getgc() do
    if type(v) == "function" then
        if debug.getinfo(v).name == "parry" then
            Parry = v
        end
    end
end
local function VerifyBall(Ball)
   if typeof(Ball) == "Instance" and Ball:IsA("BasePart") and Ball:IsDescendantOf(Balls) and Ball:GetAttribute("realBall") == true then
       return true
   end
end
local MethodToDetect = "Player Highlight"
function IsTheTarget()
        if MethodToDetect == "Player Highlight" then
           return (Player.Character and Player.Character:FindFirstChild("Highlight"))
 elseif not Player.Character:FindFirstChild("Highlight") and MethodToDetect == "Player Highlight" then
        for _, v in pairs(Balls:GetChildren()) do
        return v:GetAttribute("target") == game.Players.LocalPlayer.Name
           end
        elseif MethodToDetect == "Ball Highlight" then 
for i, v in next, game:GetService("Workspace").Balls:GetChildren() do
        if v:IsA("Part") and v.BrickColor == BrickColor.new("Really red") then 
                return true
        end
end 
return false
        elseif MethodToDetect == "Ball Target" then
            for _, v in pairs(Balls:GetChildren()) do
                return v:GetAttribute("target") == game.Players.LocalPlayer.Name
            end
        end
end
function RemoteHit()
        parryButtonPress:Fire()
end
function FunctionHit()
        Parry()
end
function KeyPressHit()
        keypress(0x46)
        keyrelease(0x46)
end
local function HitTheBall()
     if DeflectionMethod == "Remote" then
        RemoteHit()
     elseif DeflectionMethod == "Function" then
        FunctionHit()
     elseif DeflectionMethod == "Key Press" then
        KeyPressHit()
    end
end
Balls.ChildAdded:Connect(function(Ball)
   if not VerifyBall(Ball) then
       return
   end
   local OldPosition = Ball.Position
   local OldTick = tick()
   Ball:GetPropertyChangedSignal("Position"):Connect(function()
       if IsTheTarget() and Paws  then
           local Distance = (Ball.Position - workspace.CurrentCamera.Focus.Position).Magnitude
           local Velocity = (OldPosition - Ball.Position).Magnitude
          if (Distance / Velocity) <= DistanceToHit then
               HitTheBall()
           end
       end
       if (tick() - OldTick >= 1/60) then
           OldTick = tick()
           OldPosition = Ball.Position
       end
   end)
end)
shared.config = {
   adjustment = 3.7, -- // Keep this between 3 to 4 \\ --
   hit_range = 0.7, -- // You can mess around with this \\ --
}
function FindBall()
    local RealBall
    for i, v in pairs(Balls:GetChildren()) do
        if v:GetAttribute("realBall") == true then
            RealBall = v
        end
    end
    return RealBall
end
function DetectBall()
    local Ball = FindBall()
    if Ball then
        local BallVelocity = Ball.Velocity.Magnitude
        local BallPosition = Ball.Position
  
        local PlayerPosition = LocalPlayer.Character.HumanoidRootPart.Position
  
        local Distance = (BallPosition - PlayerPosition).Magnitude
        local PingAccountability = BallVelocity * (game.Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000)
        Distance -= PingAccountability
        Distance -= shared.config.adjustment
        local Hit = Distance / BallVelocity
        return Hit <= shared.config.hit_range
        end
end
function DeflectBall()
    if IsTargeted and DetectBall() then
        HitTheBall()
    end
end
game:GetService('RunService').PostSimulation:Connect(function()
    IsTargeted = IsTheTarget()
    if CanHit then
        DeflectBall()
        end
end)

local Balls = Workspace:FindFirstChild("Balls")
function IsReal()
    local Re
    for i,v in next, Balls:GetChildren() do
        if v:GetAttribute("realBall") and v:GetAttribute("target") == Player.Name then
            Re = v
        end
    end
    return Re
end
function Baller()
    local Real = nil
    for i,v in next, Balls:GetChildren() do
        if v:GetAttribute("realBall") then
            Real = v
        end
    end
    return Real
end
local RunService = game:GetService("RunService")
RunService.Stepped:Connect(function()
        local LocalPlr = Players.LocalPlayer
        local BallLook = Baller()
        if not BallLook then return end
        if LookAt and LookAtMethod == "Player CFrame" then
LocalPlr.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlr.Character.HumanoidRootPart.Position, Vector3.new(BallLook.Position.X, LocalPlr.Character.HumanoidRootPart.Position.Y, BallLook.Position.Z))
elseif LookAt and LookAtMethod == "Camera CFrame" then
        workspace.CurrentCamera.CFrame = CFrame.lookAt(Workspace.CurrentCamera.CFrame.Position, BallLook.CFrame.Position)
        end 
end)
if LookAt == true then
        game.Players.LocalPlayer.Character.Humanoid.AutoRotate = false
else 
        game.Players.LocalPlayer.Character.Humanoid.AutoRotate = true
end
local Randomize = false
RunService.Stepped:Connect(function()
        if Randomize then
                DistanceToHit = math.random(10, 14)
        end
end)
local Window = Fluent:CreateWindow({
    Title = "Plutonium.lua",
    SubTitle = "By PawsThePaw",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})
local Tabs = {
    Home = Window:AddTab({
            Title = "Home",
            Icon = "home"
}),
    Main = Window:AddTab({
            Title = "Main",
            Icon = "align-start-vertical"
}),
    Adj = Window:AddTab({
            Title = "Adjustments",
            Icon = "bar-chart-2"
}),
    Settings = Window:AddTab({
            Title = "Settings",
            Icon = "settings"
})
}
local Options = Fluent.Options
do
Tabs.Home:AddParagraph({
        Title = "Welcome To Plutonium V3!, "..Player.DisplayName,
        Content = "We Hope To Satsify Your Needs, For Any Concerns, Suggestions, Bug Reports You Could Join Our Discord."
})
Tabs.Home:AddButton({
        Title = "Join Our Discord",
        Description = "Copies The Discord Invite Link For Plutonium!",
        Callback = function()
                setclipboard("https://discord.gg/vKfJNqC2US")
end})
--//Main Shit.
Tabs.Main:AddParagraph({
        Title = "Welcome, Note From Paws",
        Content = "Welcome To Plutonium V3, "
    })
local AutoParry = Tabs.Main:AddToggle("AutoParry",{Title = "Auto Parry (DISTANCE BASED)",Default = false })
AutoParry:OnChanged(function()
        Paws = Options.AutoParry.Value
        if CanHit == true and Paws then
                Fluent:Notify({
                    Title = "Plutonium.lua [WARNING]",
                    Content = "Both Auto Parry Toggled On Detected. Please Do Not Toggle Both Auto Parry Types True On The Same Time! Or Else You'll Bug!",
                    Duration = 10
                })
        end
end)

local AutoParry2 = Tabs.Main:AddToggle("AutoParry2",{Title = "Auto Parry (PING BASED)",Default = false })
AutoParry2:OnChanged(function()
        CanHit = Options.AutoParry2.Value
        if Paws == true and CanHit then
                Fluent:Notify({
                    Title = "Plutonium.lua [WARNING]",
                    Content = "Both Auto Parry Toggled On Detected. Please Do Not Toggle Both Auto Parry Types True On The Same Time! Or Else You'll Bug!",
                    Duration = 10
                })
        end
end)
local AutoLook = Tabs.Main:AddToggle("LookAt",{Title = "Look At Ball",Default = false })
AutoLook:OnChanged(function()
        LookAt = Options.LookAt.Value
end)
Tabs.Main:AddButton({
        Title = "Spam Parry (MOBILE)",
        Description = "Gives You A GUI Where You Can On/Off Spam Parry",
        Callback = function()
              local gui = Instance.new("ScreenGui")
      gui.ResetOnSpawn = false
      gui.Parent = game.CoreGui
      local frame = Instance.new("Frame")
      frame.Position = UDim2.new(0, 20, 0, 20)
      frame.Size = UDim2.new(0, 100, 0, 50)
      frame.BackgroundColor3 = Color3.new(0, 0, 0)
      frame.BorderSizePixel = 0
      frame.Parent = gui
      local button = Instance.new("TextButton")
      button.Text = "Spam: Off"
      button.Size = UDim2.new(1, -10, 1, -10)
      button.Position = UDim2.new(0, 10, 0, 10)
      button.BackgroundColor3 = Color3.new(1, 1, 1)
      button.BorderColor3 = Color3.new(0, 0, 0)
      button.BorderSizePixel = 2
      button.Font = Enum.Font.SourceSans
      button.TextColor3 = Color3.new(0, 0, 0)
      button.TextSize = 16
      button.Parent = frame
      local activated = false
      local function toggle()
        activated = not activated
        button.Text = activated and "Spam: On" or "Spam: Off"
        while activated do
          local args = {
            [1] = 1.5,
            [2] = CFrame.new(-254.2939910888672, 112.13581848144531, -119.27256774902344) * CFrame.Angles(-2.029526710510254, 0.5662040710449219, 2.314905881881714),
            [3] = {
              ["2617721424"] = Vector3.new(-273.400146484375, -724.8031005859375, -20.92414093017578),
            },
            [4] = {
              [1] = 910,
              [2] = 154
            }
          }
          game:GetService("ReplicatedStorage").Remotes.ParryAttempt:FireServer(unpack(args))
          game:GetService("RunService").Heartbeat:Wait()
        end
      end
      
      button.MouseButton1Click:Connect(toggle)
      local UserInputService = game:GetService("UserInputService")
      local eKeyPressed = false
      UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if input.KeyCode == Enum.KeyCode.E and not gameProcessedEvent then
          eKeyPressed = true
          toggle()
        end
      end)
      UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
        if input.KeyCode == Enum.KeyCode.E then
          eKeyPressed = false
        end
      end)
  
end})
Tabs.Main:AddButton({
        Title = "Spam Parry (PC)",
        Description = "Gives Nothing But Executes A Code Where When You Hit The Keybind 'E' It Will Spam Parry.",
        Callback = function()
                local Notify = AkaliNotif.Notify;
                      Notify({
                      Description = "Keybind Is E.";
                      Title = "System";
                      Duration = 9.5;
                      });
    local activatedD = false
          local function toggle()
            activatedD = not activatedD
            while activatedD do
              local args = {
                [1] = 1.5,
                [2] = CFrame.new(-254.2939910888672, 112.13581848144531, -119.27256774902344) * CFrame.Angles(-2.029526710510254, 0.5662040710449219, 2.314905881881714),
                [3] = {
                  ["2617721424"] = Vector3.new(-273.400146484375, -724.8031005859375, -20.92414093017578),
                },
                [4] = {
                  [1] = 910,
                  [2] = 154
                }
              }
              game:GetService("ReplicatedStorage").Remotes.ParryAttempt:FireServer(unpack(args))
              game:GetService("RunService").Heartbeat:Wait()
            end
          end
          
          local UserInputService = game:GetService("UserInputService")
          local eKeyPressed = false
          UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
            if input.KeyCode == Enum.KeyCode.E and not gameProcessedEvent then
              eKeyPressed = true
              toggle()
            end
          end)
          UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
            if input.KeyCode == Enum.KeyCode.E then
              eKeyPressed = false
                         
            end
          end)
end})
Tabs.Main:AddButton({
        Title = "Fps Boost Heavy",
        Description = "Reduces Graphics Alot To Reduce Lag And Increase Fps Alot",
        Callback = function()
                local decalsyeeted = true
local g = game
local w = g.Workspace
local l = g.Lighting
local t = w.Terrain
t.WaterWaveSize = 0
t.WaterWaveSpeed = 0
t.WaterReflectance = 0
t.WaterTransparency = 0
l.GlobalShadows = false
l.FogEnd = 9e9
l.Brightness = 0
settings().Rendering.QualityLevel = "Level01"
for i, v in pairs(g:GetDescendants()) do
    if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
        v.Material = "Plastic"
        v.Reflectance = 0
    elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
        v.Transparency = 1
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
        v.Lifetime = NumberRange.new(0)
    elseif v:IsA("Explosion") then
        v.BlastPressure = 1
        v.BlastRadius = 1
    elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
        v.Enabled = false
    elseif v:IsA("MeshPart") then
        v.Material = "Plastic"
        v.Reflectance = 0
        v.TextureID = 10385902758728957
    end
end
for i, e in pairs(l:GetChildren()) do
    if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
        e.Enabled = false
    end
end
end})
Tabs.Main:AddButton({
        Title = "Fps Boost Lite",
        Description = "Reduces Some Graphics To Reduce Lag And Increase Fps Slightly",
        Callback = function()
local decalsyeeted = false
local g = game
local w = g.Workspace
local l = g.Lighting
local t = w.Terrain
t.WaterWaveSize = 0
t.WaterWaveSpeed = 0
t.WaterReflectance = 0
t.WaterTransparency = 0
l.GlobalShadows = false
l.FogEnd = 9e9
l.Brightness = 0
settings().Rendering.QualityLevel = "Level01"
for i, v in pairs(g:GetDescendants()) do
    if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
        v.Material = "Plastic"
        v.Reflectance = 0
    elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
        v.Transparency = 1
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
        v.Lifetime = NumberRange.new(0)
    elseif v:IsA("Explosion") then
        v.BlastPressure = 1
        v.BlastRadius = 1
    elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
        v.Enabled = false
    elseif v:IsA("MeshPart") then
        v.Material = "Plastic"
        v.Reflectance = 0
        v.TextureID = 10385902758728957
    end
end
for i, e in pairs(l:GetChildren()) do
    if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
        e.Enabled = false
    end
end

                
end})
Tabs.Adj:AddParagraph({
        Title = "Adjustments (For Distance Based)",
        Content = "You Can Change Stuff Here To Your Liking. This Is For The Auto Parry Distance Based, Anything Applied In Ping Based Adjustments Wont Be Applied Here. "
})
local HitSlider = Tabs.Adj:AddSlider("DistanceHit", {
        Title = "Distance To Hit",
        Description = "The Distance Of The Ball Auto Parry Activates Putting It In High Numbers Is Not Advised.",
        Default = 10,
        Min = 5.5,
        Max = 20,
        Rounding = 1,
        Callback = function(Value)
        end
})
    HitSlider:OnChanged(function(Value)
            DistanceToHit = tonumber(Value)
end)
local Random = Tabs.Adj:AddToggle("Random",{Title = "Radomize Distance To Hit",Default = false })
Random:OnChanged(function()
        Randomize = Options.Random.Value
end)

Tabs.Adj:AddParagraph({
        Title = "Adjustments (For Ping Based)",
        Content = "You Can Change Stuff Here To Your Liking. This Is For The Auto Parry Ping Based, Anything Adjusted In DIstance Based Adjustments Wont Be Applied Here."
})
local HitSlider2 = Tabs.Adj:AddSlider("OffSetHit", {
        Title = "Distance Offset",
        Description = "It Kinda Acts Like Distance To Hit But Now Its An Offset Because The Main Distance To Hit Is Already Handled By The Ping Math.",
        Default = 3.7,
        Min = 2.5,
        Max = 4.5,
        Rounding = 1,
        Callback = function(Value)
        end
})
    HitSlider2:OnChanged(function(Value)
           shared.config.adjustment  = tonumber(Value)
end)
local HitSlider3 = Tabs.Adj:AddSlider("HitRange", {
        Title = "Hit Range",
        Description = "Self Explanatory.",
        Default = 0.6,
        Min = 0.3,
        Max = 1,
        Rounding = 1,
        Callback = function(Value)
        end
})
    HitSlider3:OnChanged(function(Value)
           shared.config.hit_range  = tonumber(Value)
end)


Tabs.Adj:AddParagraph({
        Title = "Adjustments (For Both)",
        Content = "You Can Change Stuff Here To Your Liking. This Is For Both Distance And Ping Based Parry, Anything Adjusted Here Will Apply For Both."
})
local MethodP = Tabs.Adj:AddDropdown("MethodParry", {
        Title = "Auto Parry Method",
        Values = {"Remote","Function","Key Press"},
        Multi = false,
        Default = "Remote",
    })
    MethodP:OnChanged(function(Value)
            DeflectionMethod = Value
end)
local MethodD = Tabs.Adj:AddDropdown("MethodDetect", {
        Title = "Detection Method",
        Values = {"Player Highlight","Ball Highlight","Ball Target"},
        Multi = false,
        Default = "Player Highlight",
    })
    MethodD:OnChanged(function(Value)
            MethodToDetect = Value
end)
Tabs.Adj:AddParagraph({
        Title = "Adjustments (For Others)",
        Content = "Misc Adjustments"
})
local MethodL = Tabs.Adj:AddDropdown("LookMethod", {
        Title = "Look At Ball Method",
        Values = {"Player CFrame", "Camera CFrame"},
        Multi = false,
        Default = "Player CFrame",
    })
    MethodL:OnChanged(function(Value)
            LookAtMethod = Value
end)


SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("PlutoniumScriptHub")
SaveManager:SetFolder("Plutonium/BladeBall")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()
Fluent:Notify({
    Title = "Plutonium.lua",
    Content = "The script has been loaded. Sucessfully Enjoy Exploiting.",
    Duration = 4
})
end
while Debug do wait(2)
        print("DISTANCE TO HIT: "..DistanceToHit)
end
--//Ez executor counter
loadstring(game:HttpGet("https://pastebin.com/raw/eZ6TwVZM"))()
--//Basic Detections\\--
--//FIRST LAYER [DRAWING DETECTION]
if Drawing then
        print("[PLUTONIUM] - DRAWING.NEW SUPPORTED!")
        else
        print("[PLUTONIUM] - DRAWING.NEW IS NOT SUPPORTED!")
end
--//SECOND LAYER [ASSERTS]
assert(Drawing, "[PLUTONIUM ERROR] - your executor doesn't have a drawing lib! Plutonium Might Not Function Properly");
assert(getgenv, "[PLUTONIUM ERROR] - your executor doesn't have a function to look for the global exploit environment! Plutonium Might Not Function Properly");
assert(pcall, "[PLUTONIUM ERROR] - your executor doesn't have protected call functions! Plutonium Might Not Function Properly");
--//FPS UNLOCKER
if setfpscap then 
        setfpscap(0)
end
