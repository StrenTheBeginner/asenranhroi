loadstring(game:HttpGet("https://raw.githubusercontent.com/1201for/V.G-Hub/main/Extras/Global"))()
VG.DisableConnection(Error)
VG.DisableConnection(Idled)
local Hehe = {}
local Zones = {}
local Flags = {}
local Fruits = {}

local FishingGame = Player.PlayerGui._INSTANCES:WaitForChild("FishingGame")
local Network = ReplicatedStorage:WaitForChild("Network")
local Things = Workspace:WaitForChild("__THINGS")
local Active = Things.__INSTANCE_CONTAINER:WaitForChild("Active")
local I = Network:WaitForChild("Instancing_FireCustomFromClient")
local I2 = Network:WaitForChild("Instancing_InvokeCustomFromClient")
local Client = require(ReplicatedStorage:WaitForChild("Library"))
local rs = game.ReplicatedStorage
local Hatch = rs.Network.CustomEggs_Hatch

for i,v in next, getgc(true) do
    if type(v) == "function" then
        if getfenv(v).script == Player.PlayerScripts.Scripts.Game.Misc["Hidden Presents"] then
            if getinfo(v).name == "GetActive" then
                GetActive = v
            elseif getinfo(v).name == "Clicked" then
                Clicked = v
            end
        end
        if getfenv(v).script == Player.PlayerScripts.Scripts.Game.Misc["Shiny Relics"] then
            if getinfo(v).name == "RequestRelics" then
                RequestRelics = v
            elseif getinfo(v).name == "RelicClicked" then
                RelicClicked = v
            end
        end
    end
    if type(v) == "table" then
        if rawget(v, "FruitVendingMachine1") then
            VendingMachines = v
        end
    end
end

local GetPresentTable = function(Pre)
    if Pre then
        for i,v in next, getupvalue(GetActive, 1) do
            if v.Model == Pre then
                return v
            end
        end
    end
end

local getShiny = function(Shin)
    if Shin then
        for i,v in next, getupvalue(RequestRelics,1) do
            if v.Model == Shin then
                return v
            end
        end
    end
end

local GetRod = function()
    return Player.Character:FindFirstChild("Rod", true)
end

local RequestCast = function()
    if Method == "Fishing" and not GetRod():FindFirstChild("FishingLine") and wait(5) then
        I:FireServer("Fishing","RequestCast",Vector3.new(1139, 75, -3445))
    elseif Method == "AdvancedFishing"  and not GetRod():FindFirstChild("FishingLine") and wait(5) then
        I:FireServer("AdvancedFishing","RequestCast",Vector3.new(1460, 61, -4442))
    end
end

local RequestReel = function()
    local Nothing = nil
    if Method == "Fishing" and GetRod():FindFirstChild("FishingLine") then
        Nothing = GetRod().FishingLine.Attachment1.Parent
    elseif Method == "AdvancedFishing" and GetRod():FindFirstChild("FishingLine") then
        Nothing = GetRod().FishingLine.Attachment0.Parent
    end
    if Nothing then
        local Height = tonumber(Nothing.Position.Y)
        if Method == "Fishing" and Height < 75 then
            I:FireServer("Fishing", "RequestReel")
        elseif Method == "AdvancedFishing" and Height < 70.5 then
            I:FireServer("AdvancedFishing","RequestReel")
        end
    end
end

local Wait = function()
    if Method == "Fishing" and FishingGame.Enabled and wait(.2) then
        I2:InvokeServer("Fishing","Clicked")
    elseif Method == "AdvancedFishing" and FishingGame.Enabled and wait(.2) then
        I2:InvokeServer("AdvancedFishing","Clicked")
    end
end

local Walk = function()
    if Method == "Fishing" then
        VG.GetHumanoid():MoveTo(Vector3.new(1113 + math.random(10), 80, -3444 + math.random(10)))
    elseif Method == "AdvancedFishing" then
        VG.GetHumanoid():MoveTo(Vector3.new(1440 + math.random(10), 66, -4445 + math.random(10)))
    end
end

local GoTo = function()
    if Method == "Fishing" and not Active:FindFirstChild("Fishing") then
        VG.Teleport(Things.Instances.Fishing.Teleports.Enter.Position)
    elseif Method == "AdvancedFishing" and not Active:FindFirstChild("AdvancedFishing") then
        VG.Teleport(Things.Instances.AdvancedFishing.Teleports.Enter.Position)
    end
end

local Activated = function()
    GoTo()
    RequestCast()
    RequestReel()
    Walk()
    Wait()
end

local CurrentActive = function()
    return Active:GetChildren()[1] -- idk how else to get a unnamed object feel free to teach me
end

local GetBlock = function()
    local IHateMakingNamesFortables = CurrentActive()
    local Distance = math.huge
    local Block = nil
    for i,v in next, IHateMakingNamesFortables.Important.ActiveBlocks:GetChildren() do
        if v:IsA("BasePart") then
            local Mag = VG.Mag(Player.Character.HumanoidRootPart, v)
            if Mag <=  Distance then
                Distance = Mag
                Block = v
            end
        end
    end
    return Block -- I Hate this part
end
 
local GetChest = function()
    local Table = CurrentActive()
    local Distance = math.huge -- KYS
    local Chest = nil
    for i,v in next, Table.Important.ActiveChests:GetChildren() do
        if v:IsA("Model") then
            local NewMag = VG.Mag(Player.Character.HumanoidRootPart, v:GetModelCFrame())
            if NewMag <= Distance then
                Distance = NewMag
                Chest = v
            end
        end
    end
    return Chest
end

local MakeTable = function(Table)
    local Temp = {}
    local IDs = {}
    for i,v in next, Client.Items.All.Globals.All() do
        if table.find(Table, v._data.id) then
            table.insert(Temp, v._uid)
        end
    end
    return Temp
end

local Fire = function(RemoteName, Args)
    setthreadidentity(2)
    Network[RemoteName]:FireServer(unpack(Args))
    setthreadidentity(8)
end

local Invoke = function(RemoteName, Args)
    setthreadidentity(2)
    Network[RemoteName]:InvokeServer(unpack(Args))
    setthreadidentity(8)
end


local Doobbystuff = function(Obby)
    local New = Workspace.__THINGS.__INSTANCE_CONTAINER.Active:GetChildren()[1]
    local Model = VG.FFD(New, "StartLine")
    local Model2 = VG.FFD(New, "Goal")
    if Model then
        if Model:IsA("Model") then
            VG.Teleport(VG.FFD(New, "StartLine"):GetModelCFrame().Position + Vector3.new(0,5,-5))
        elseif Model:IsA("BasePart") then
            VG.Teleport(VG.FFD(New, "StartLine").Position + Vector3.new(-5,5,0))
        end
    end
    wait(2)
    if Model2 then
        VG.Teleport(VG.FFD(New, "Goal").Pad.Position)
    end
end

local BuyVenders = function()
    local OldPos = Player.Character.HumanoidRootPart.CFrame
	for i,v in VendingMachines do
		local Skid = VG.FFD(Workspace.Map, i)
        if Skid and v.Stock and not Skid.VendingMachine.Screen.SurfaceGui.SoldOut.Visible then
            Player.Character.HumanoidRootPart.CFrame = Skid.Pad.CFrame * CFrame.new(0,0,10)
            wait(.5)
            for i2=1, v.Stock do
                Invoke("VendingMachines_Purchase", {i, 1})
            end
		end
	end
    Player.Character.HumanoidRootPart.CFrame = OldPos
end

function GoTo2()
    if Method2 == "Digsite" and not Active:FindFirstChild("Digsite") then
        VG.Teleport(Things.Instances.Digsite.Teleports.Enter.Position)
    elseif Method2 == "AdvancedDigsite" and not Active:FindFirstChild("AdvancedDigsite") then
        VG.Teleport(Things.Instances.AdvancedDigsite.Teleports.Enter.Position)
    end
end

local Refrsh = function()
    if Method2 == "Digsite" and not Active:FindFirstChild("Digsite") then
        VG.Teleport(Workspace.__THINGS.Instances["Digsite"].Teleports.Leave.Position)
        wait(5)
        VG.Teleport(Workspace.__THINGS.Instances["Digsite"].Teleports.Enter.Position)
    end
    if Method2 == "AdvancedDigsite" and not Active:FindFirstChild("AdvancedDigsite") then
        VG.Teleport(Workspace.__THINGS.Instances["AdvancedDigsite"].Teleports.Leave.Position)
        wait(5)
        VG.Teleport(Workspace.__THINGS.Instances["AdvancedDigsite"].Teleports.Enter.Position)
    end
end

local Dig = function()
    GoTo2()
    if (GetBlock() == nil or GetChest() == nil) then
        print("no Blocks")
        Refrsh()
    end
    if CurrentActive() and CurrentActive().Name == "Digsite" then
        if Player.Character.HumanoidRootPart.Position.Y <= -1991 then
            VG.FireConnection(Player.PlayerGui._INSTANCES.Digsite.Return.Activated)
        end
    end
    if GetChest() then
        VG.Tween(Player.Character.HumanoidRootPart, GetChest():FindFirstChildWhichIsA("BasePart"), 50, Vector3.new(0,0,2), true)
        ReplicatedStorage:WaitForChild("Network"):WaitForChild("Instancing_FireCustomFromClient"):FireServer(CurrentActive().Name, "DigChest", GetChest():GetAttribute('Coord'))
        wait(2)
    else
        VG.Tween(Player.Character.HumanoidRootPart, GetBlock(), 50, Vector3.new(0,0,1), true)
        ReplicatedStorage:WaitForChild("Network"):WaitForChild("Instancing_FireCustomFromClient"):FireServer(CurrentActive().Name, "DigBlock", GetBlock():GetAttribute('Coord'))
        wait(.3)
    end
end
local DigAura = function() -- just Dig() without tweening
    if GetChest() then
        ReplicatedStorage:WaitForChild("Network"):WaitForChild("Instancing_FireCustomFromClient"):FireServer(CurrentActive().Name, "DigChest", GetChest():GetAttribute('Coord'))
    else
        ReplicatedStorage:WaitForChild("Network"):WaitForChild("Instancing_FireCustomFromClient"):FireServer(CurrentActive().Name, "DigBlock", GetBlock():GetAttribute('Coord'))
    end
end

local GetCoinInZone = function()
    local Target = nil
    local MaxDistance = math.huge
    for i,v in next, Workspace.__THINGS.Breakables:GetChildren() do
        if v:IsA("Model") and (v:GetAttribute("ParentID") == PickedZone) then
            local Mag = VG.Mag(v:GetModelCFrame(), Player.Character:GetModelCFrame())
            if Mag <= MaxDistance then
                MaxDistance = Mag
                Target = v 
            end
        end
    end
    return Target
end

local GetNearestCoin = function()
    local Target = nil
    local MaxDistance = math.huge
    for i,v in next, workspace.__THINGS.Breakables:GetChildren() do
        if v:IsA("Model") then
            local Mag = VG.Mag(v:GetModelCFrame(), Player.Character:GetModelCFrame())
            if Mag <= MaxDistance then
                MaxDistance = Mag
                Target = v 
            end
        end
    end
    return Target
end
 
for i,v in next, ReplicatedStorage.__DIRECTORY.Zones:GetChildren() do
    for i,v in next, v:GetChildren() do
        if v:IsA("ModuleScript") then
            local String = string.split(v.Name, "| ", "")[2]
            table.insert(Zones, String)
        end
    end
end
 
for i,v in next, ReplicatedStorage.Assets.Instancing:GetChildren() do
    table.insert(Hehe, v.Name)
end

for i,v in next, ReplicatedStorage.__DIRECTORY.Fruits:GetChildren() do
	local Name = v.Name:gsub("Fruit | ", "")
	table.insert(Fruits, Name)
end


local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
 
local Window = Fluent:CreateWindow({
    Title = "V.G Hub: Game " .. MarketplaceService:GetProductInfo(game.PlaceId).Name,
    SubTitle = "by DekuDimz",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.Delete -- Used when theres no MinimizeKeybind
})
 
 
local Tabs = {
    AutoFarm = Window:AddTab({ Title = "AutoFarm", Icon = "" }),
    Obbys = Window:AddTab({ Title = "Obbys etc", Icon = "" }),
    Eggs = Window:AddTab({ Title = "Eggs", Icon = "egg"}),
    AutoMinigame = Window:AddTab({ Title = "AutoMinigames", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
 
}
 
local Options = Fluent.Options
 
do
    Fluent:Notify({
        Title = "V.G Hub Loaded",
        Content = "Congrats your using V.G Hub " .. Verison,
        SubContent = "", -- Optional
        Duration = 10 -- Set to nil to make the notification not disappear
    })
    local Toggle = Tabs.AutoFarm:AddToggle("Rend", {Title = "Disable 3D Rendering", Default = false})
    Toggle:OnChanged(function()
        Norender = Options.Rend.Value
        if Norender then
            RunService:Set3dRenderingEnabled(false)
        else
            RunService:Set3dRenderingEnabled(true)
        end
    end)
    local Toggle = Tabs.AutoFarm:AddToggle("PetCoin", {Title = "Auto Break Nearest Coin", Default = false})
    Toggle:OnChanged(function()
        AutoFarm = Options.PetCoin.Value
        spawn(function()
            while wait() and AutoFarm do
                pcall(function()
                    ReplicatedStorage:WaitForChild("Network"):WaitForChild("Breakables_PlayerDealDamage"):FireServer(GetNearestCoin().Name)
                end)
            end
        end)
    end)
 
    local Toggle = Tabs.AutoFarm:AddToggle("PetCoin1", {Title = "Auto Break In Selected Zone", Default = false})
    Toggle:OnChanged(function()
        AutoFarm1 = Options.PetCoin1.Value
        spawn(function()
            while wait(1) and AutoFarm1 do
                pcall(function()
                    if GetCoinInZone() == nil then
                        ReplicatedStorage:WaitForChild("Network"):WaitForChild("Teleports_RequestTeleport"):InvokeServer(PickedZone)
                        wait(10)
                        for i,v in next, Workspace.Map:GetChildren() do
                            if v.Name:find(PickedZone) then
                                VG.Teleport(v.INTERACT.BREAK_ZONES.BREAK_ZONE.Position)
                                break
                            end
                        end
                    end
                    VG.Teleport(GetCoinInZone():GetModelCFrame().Position + Vector3.new(0,6,0))
                    ReplicatedStorage:WaitForChild("Network"):WaitForChild("Breakables_PlayerDealDamage"):FireServer(GetCoinInZone().Name)
                end)
            end
        end)
    end)
    local Dropdown = Tabs.AutoFarm:AddDropdown("Ds", {
        Title = "Zones",
        Values = Zones,
        Multi = false,
        Default = 1,
    })
 
    Dropdown:SetValue("nil")
 
    Dropdown:OnChanged(function(Value)
        PickedZone = Value
    end)
    local Toggle = Tabs.AutoFarm:AddToggle("Toyou", {Title = "Auto Eat Fruits", Default = false})
    Toggle:OnChanged(function()
        Frut = Options.Toyou.Value
        spawn(function()
            while Frut and wait() do
                pcall(function()
                    for i,v in MakeTable(Fruits) do
                        Fire("Fruits: Consume", {v,1})
                    end
                end)
            end
        end)
    end)
    local Toggle = Tabs.AutoFarm:AddToggle("Toyou2", {Title = "Auto Buy Venders", Default = false})
    Toggle:OnChanged(function()
        vut = Options.Toyou2.Value
        spawn(function()
            while vut and wait() do
                pcall(function()
                    BuyVenders()
                end)
            end
        end)
    end)
    local Toggle = Tabs.AutoFarm:AddToggle("Gifts", {Title = "Auto Find Hidden Presents", Default = false})
    Toggle:OnChanged(function()
        Yes = Options.Gifts.Value
        spawn(function()
            while wait() and Yes do
                pcall(function()    
                    for i,v in next, workspace.__THINGS.HiddenPresents:GetChildren() do
                        if v:IsA("BasePart") then
                            Clicked(GetPresentTable(v))
                        end
                    end
                end)
            end
        end)
    end)

    Tabs.Obbys:AddButton({Title = "Auto Grab All ShinyRelics",Description = "Grabs all relics Working",Callback = function()
        for i,v in next, Workspace.__THINGS.ShinyRelics:GetChildren() do
            if v:IsA("BasePart") and v.Transparency == 0 then
                RelicClicked(getShiny(v))
            end
        end
    end})
    local Toggle = Tabs.AutoMinigame:AddToggle("DigSite", {Title = "Auto DigSites", Default = false})
    Toggle:OnChanged(function()
        Toggle = Options.DigSite.Value
        Stepped:Connect(function()
            if Toggle then
                VG.NoClip()
            end
        end)
        spawn(function()
            while Toggle and wait() do
                pcall(function()
                    Dig()
                end)
            end
        end)
    end)
    local Dropdown = Tabs.AutoMinigame:AddDropdown("e234", {
        Title = "Dig Areas",
        Values = {"AdvancedDigsite", "Digsite"},
        Multi = false,
        Default = 2,
    })
 
    Dropdown:SetValue("")
    Dropdown:OnChanged(function(Value)
        Method2 = Value
    end)
    local Toggle = Tabs.AutoMinigame:AddToggle("DigSiteAura", {Title = "Dig Aura", Default = false})
    Toggle:OnChanged(function()
        Digaura = Options.DigSiteAura.Value
        spawn(function()
            while wait(.2) and Digaura do
                pcall(function()
                    DigAura()
                end)
            end
        end)
    end)
    local Toggle = Tabs.AutoMinigame:AddToggle("Fih", {Title = "Auto Fishing", Default = false})
    Toggle:OnChanged(function()
        Fishe = Options.Fih.Value
        spawn(function()
            while wait() and Fishe do
                pcall(function()
                    Activated()
                end)
            end
        end)
        spawn(function()
            while Fishe and wait(300) do
                pcall(function()
                    User:SendMouseButtonEvent(0,0, 0, true, game, 0)
                    User:SendMouseButtonEvent(0,0, 1, true, game, 0)
                    wait(1)
                    User:SendMouseButtonEvent(0,0, 0, false, game, 0)
                    User:SendMouseButtonEvent(0,0, 1, false, game, 0)
                end)
            end
        end)
    end)

    local Dropdown = Tabs.AutoMinigame:AddDropdown("e34", {
        Title = "Fishing Areas",
        Values = {"AdvancedFishing", "Fishing"},
        Multi = false,
        Default = 1,
    })
 
    Dropdown:SetValue("")
    Dropdown:OnChanged(function(Value)
        Method = Value
    end)
    Tabs.Obbys:AddButton({Title = "Auto Selected Obby",Description = "Automaticly does obby must be in obby to work",Callback = function()
        Doobbystuff()
    end})
end

    local Toggle = Tabs.Eggs:AddToggle("Egg", {Title = "Auto Hatch Nearest Egg", Default = false})
    Toggle:OnChanged(function()
        AutoHatch = Toggle.Value -- Cập nhật trạng thái AutoHatch theo toggle
        if AutoHatch then
            Fluent:Notify({
                Title = "Auto Hatch Nearest Egg | ON",
                Content = "",
                Duration = 7
            })
            task.spawn(function()
                while AutoHatch do -- Kiểm tra liên tục nếu AutoHatch bật
                    if getgenv().OpenLocation ~= nil then
                        if (hrp.Position - getgenv().OpenLocation).Magnitude > 100 then
                            getgenv().Egg_Args = nil
                        end
                    end
                    if getgenv().Egg_Args ~= nil and (hrp.Position - getgenv().OpenLocation).Magnitude <= 10 then
                        Hatch:InvokeServer(table.unpack(getgenv().Egg_Args), math.huge) -- Mở trứng nhanh
                    end
                    task.wait(0.5) -- Thời gian chờ ngắn để tăng tốc
                end
            end)
        else
            Fluent:Notify({
                Title = "Auto Hatch Nearest Egg | OFF",
                Content = "",
                Duration = 7
            })
        end
    end)

	local Toggle = Tabs.Eggs:AddToggle("HatchEgg", {Title = "Auto Hatch Egg | Skip Animation", Default = false})
	Toggle:OnChanged(function()
	    local Hatch = Options.HatchEgg.Value
	    -- Handle toggle state
	    if Hatch then
		-- When the toggle is ON, start hatching the selected egg
		Fluent:Notify({
		    Title = "Egg Hatch | ON",
		    Content = "Hatching process is active.",
		    Duration = 7
		})
	
		-- You can add more logic here if you want to automatically start hatching
		-- based on a previously selected egg or predefined settings
		if getgenv().Egg_Args ~= nil then
		    local rs = game.ReplicatedStorage
		    rs.Network.CustomEggs_Hatch:InvokeServer(table.unpack(getgenv().Egg_Args))
		end
	    else
		-- When the toggle is OFF, stop the hatching process or reset variables
		Fluent:Notify({
		    Title = "Egg Hatch | OFF",
		    Content = "Hatching process is stopped.",
		    Duration = 7
		})
	
		-- Reset or disable any related actions or states here if necessary
		getgenv().Egg_Args = nil
	    end
	end)

-- Dropdown for selecting the egg
local Dropdown = Tabs.Eggs:AddDropdown("Ds", {
    Title = "Select Eggs",
    Values = {"Pilgrim Egg", "Campfire Egg", "Scarecrow Egg", "Apple Egg", "Autumn Egg"},
    Multi = false,
    Default = 1,
})

Dropdown.OnChanged = function(selected)
    -- Check the selected egg and teleport accordingly
    if selected == "Pilgrim Egg" then
        teleportToEgg("f20eba89e7274e3a9235b6b76b7e8298")  -- Pilgrim Egg
    elseif selected == "Campfire Egg" then
        teleportToEgg("103e2cebc6f546488dfd4ae2d35b3bb4")  -- Campfire Egg
    elseif selected == "Scarecrow Egg" then
        teleportToEgg("ec9c0cbc5e1e43e1b452878435c5674b")  -- Scarecrow Egg
    elseif selected == "Apple Egg" then
        teleportToEgg("fd604af4794942bdbfcaa1a6deb2225b")  -- Apple Egg
    elseif selected == "Autumn Egg" then
        teleportToEgg("fd604af4794942bdbfcaa1a6deb2225b")  -- Autumn Egg (same location as Apple Egg)
    end

    -- Start hatching the selected egg with the appropriate remote
    startHatchingEgg(selected)
end

-- Function to teleport player to the selected egg
local function teleportToEgg(eggId)
    local eggPart = game:GetService("Workspace").__THINGS.CustomEggs[eggId].Egg
    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if eggPart and hrp then
        -- Teleport to the egg's position
        hrp.CFrame = eggPart.CFrame
    end
end

-- Function to start the hatching process for the selected egg
local function startHatchingEgg(selectedEgg)
    local Eggs = game.Players.LocalPlayer.PlayerScripts.Scripts.Game["Egg Opening Frontend"]
    getsenv(Eggs).PlayEggAnimation = function() return end
    getgenv().Egg_Args = nil
    getgenv().OpenLocation = nil
    local rs = game.ReplicatedStorage
    local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart

    task.spawn(function()
        while task.wait(2) do
            if getgenv().OpenLocation ~= nil then
                if (hrp.Position - getgenv().OpenLocation).Magnitude > 100 then
                    getgenv().Egg_Args = nil
                end
            end
            if getgenv().Egg_Args ~= nil then
                rs.Network.CustomEggs_Hatch:InvokeServer(table.unpack(getgenv().Egg_Args))
            end
        end
    end)

    local Hook
    Hook = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local CalledByExecutor = checkcaller()
        if not CalledByExecutor and tostring(self) == "CustomEggs_Hatch" then
            if getgenv().Egg_Args ~= {...} then
                getgenv().Egg_Args = {...}
                getgenv().OpenLocation = hrp.Position
            end
        end
        return Hook(self, ...)
    end))
end

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
 
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
 
 
Window:SelectTab(1)
 
Fluent:Notify({
    Title = "V.G Hub",
    Content = "The script has been loaded.",
    Duration = 8
})
 
SaveManager:LoadAutoloadConfig()
