local GetGlobal = getgenv and getgenv()
if not game.Loaded then
    game.Loaded:Wait()
end
for i,v in next, game.GetChildren(game) do
    GetGlobal[v.ClassName] = v
end

GetGlobal.wait = task.wait
GetGlobal.spawn = task.spawn
GetGlobal.Player = Players.LocalPlayer
GetGlobal.Kick = Player.Kick
GetGlobal.Error = ScriptContext.Error
GetGlobal.Idled = Player.Idled
GetGlobal.MessageOut = LogService.MessageOut
GetGlobal.Stepped = RunService.Stepped
GetGlobal.RenderStepped = RunService.RenderStepped
GetGlobal.Heartbeat = RunService.Heartbeat
GetGlobal.PreRender = RunService.PreRender
GetGlobal.PreSimulation = RunService.PreSimulation
GetGlobal.PostSimulation = RunService.PostSimulation
GetGlobal.Settings = {}
GetGlobal.Verison = "v1"
GetGlobal.VG = {}
GetGlobal.IsVG = false
GetGlobal.Owner = "AsenRanhRoi"
GetGlobal.Helper = "Bluwu"
GetGlobal.User = Instance.new("VirtualInputManager")
GetGlobal.AFK = false
GetGlobal.Character = Player.Character or Player.CharacterAdded:Wait()
GetGlobal.Protecter = Instance.new("Model", CoreGui)
GetGlobal.GameId = game.GameId
GetGlobal.AllPlayers = {}
GetGlobal.print = print
GetGlobal.warn = warn
GetGlobal.error = error
Protecter.RobloxLocked = true

VG.Mag = function(Pos1, Pos2)
    return (Pos1.Position - Pos2.Position).Magnitude
end
-- VG.Mag(Player.Character:GetModelCFrame(), Workspace.Part1) < 50 -- true
VG.Teleport = function(Pos)
    Player.Character:PivotTo(CFrame.new(Pos))
end
-- VG.Teleport(Vector3.new(0,0,0), nil)
VG.GetNearestPlayerToBasePart = function(BasePart)
    for i,v in next, Players:GetPlayers() do
        local Radius = gethiddenproperty(v, "SimulationRadius")
        if (v.Character:GetModelCFrame().Position - BasePart.Position).Magnitude > Radius and v ~= Player then
            return true
        else
            return false
        end
    end
    return false
end
-- VG.GetNearestPlayerToBasePart(Workspace.Part1) -- true
VG.isnetworkowner = isnetworkowner or function(BasePart)
    if BasePart:IsA("BasePart") then
        local Radius = gethiddenproperty(Player, "SimulationRadius")
        if (BasePart:IsDescendantOf(Player.Character) or VG.Mag(Player.Character:GetModelCFrame(), BasePart) <= Radius) and not VG.GetNearestPlayerToBasePart(BasePart) then
            return true
        else
            return false
        end
    end
    return false
end
--VG.isnetworkowner(Player.Character.HumanoidRootPart) -- true
VG.FireConnection = function(Signal)
    if not getconnections then
        error("No getconnections detected sorry")
    else
        for i,v in next, getconnections(Signal) do
            v:Fire()
        end
    end
end
--VG.FireConnection(Player.PlayerGui.Button.MouseButton1Click)
VG.DisableConnection = function(Signal)
    if not getconnections then
        error("No getconnections Detected wth")
    else
        for i,v in next, getconnections(Signal) do
            v:Disable()
        end
    end
end

-- VG.DisableConnection(ScriptContext.Error)

VG.Tween = function(Object1, Object2, Speed, Offset, Wait)
    if Object1 and Object2 then
        local Timing = VG.Mag(Object1, Object2) / Speed
        local TweenInfo = TweenInfo.new(Timing, Enum.EasingStyle.Linear)
        local TweenSystem = TweenService:Create(Object1, TweenInfo, {CFrame = CFrame.new(Object2.Position + Offset)})
        TweenSystem:Play()
        if Wait then
            TweenSystem.Completed:Wait()
        end
    end
end
--VG.Tween(Player.Character:GetModelCFrame(), CFrame.new(0,0,0), 12, Vector3.new(0,0,0), true)

VG.ServerHop = function()
    spawn(function()
        while wait() do
            pcall(function()
                local Gay = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))
                for i,v in next, Gay.data do
                    if v.playing < v.maxPlayers then

                        TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id)
                        break
                    end
                end
            end)
            wait(4)
        end
    end)
end
-- VG.ServerHop()
VG.Rejoin = function()
    return TeleportService:Teleport(game.PlaceId, Player)
end

--VG.Rejoin()

VG.NoClip = function()
    for i,v in next, Player.Character:GetChildren() do
        if v:IsA("BasePart") then
            v.CanCollide = false
            v.Velocity = Vector3.new(0,0,0)
        end
    end
end

--VG.NoClip()

VG.GetTool = function(Name)
    if Player.Backpack:FindFirstChild(Name) then
        Player.Character.Humanoid:EquipTool(Player.Backpack:FindFirstChild(Name))
    end
end

-- VG.GetTool("Sword")

VG.FFD = function(Parent, Instance)
    return Parent:FindFirstChild(Instance, true)
end

-- if VG.FFD(Workspace, "Part") then print(true) end

VG.FFC = function(Parent, Instance)
    return Parent:FindFirstChild(Instance)
end

-- if VG.FFC(Workspace, "Part") then print("Found FirstChild Of Parent") end

VG.Wait = function(Parent, Instance)
    return Parent:WaitForChild(Instance)
end

--print(VG.Wait(Workspace))

VG.KeyPress = function(PressDown, Key, Repeated, Instance, TimesPressed)
    if User then
        User:SendKeyEvent(PressDown, Key, Repeated, Instance, TimesPressed)
    end
end
-- VG.KeyPress(true, "E", false, game, 0)

VG.GetProtecter = function()
    return Protecter
end
-- print(VG.Protecter()) -- Model, Parent CoreGui

VG.Protect = function(Gui)
    if type(Gui) == "userdata" then
        if sethiddenproperty then
            sethiddenproperty(Gui, "RobloxLocked", true)
        elseif not sethiddenproperty then
            Gui.RobloxLocked = true
        end
    end
    Gui.Parent = VG.GetProtecter()
end

VG.NoClip = function()
    for i,v in next, Player.Character:GetChildren() do
        if v:IsA("BasePart") then
            v.CanCollide = false
            v.Velocity = Vector3.new(0,0,0)
        end
    end
end

--VG.NoClip()

VG.GetPos = function(Instance)
    if Instance then
        if Instance:IsA("BasePart") then
            return Instance.Position
        elseif Instance:IsA("Model") then
            return Instance:GetModelCFrame().Position
        end
    end
end

-- VG.GetPos(Character) -- Character Position

VG.PlayersTable = function()
    local Ta = {}
    for i,v in next, Players:GetPlayers() do -- why the fuck do i have to do this for dropdowns
        if not table.find(Ta, v.Name) and v ~= Player then
            table.insert(Ta, v.Name)
        end
    end
    return Ta
end
--  VG.PlayersTable() -- Table of players names

VG.GetHumanoid = function()
    return Player.Character:FindFirstChildWhichIsA("Humanoid")
end
--VG.GetHumanoid() Grabs Humanoid of Player.Character

VG.GetRoot = function()
    return Player.Character.PrimaryPart
end
--VG.GetRoot() Grabs RootPart of Character

VG.IsA= function(Parent, Instance)
    return Parent:FindFirstChildWhichIsA(Instance, true)
end
VG.SendNotification = function(Title, Text, Icon, Duration)
    return StarterGui:SetCore("SendNotification", {Title = Title, Text = Text, Icon = Icon, Duration = Duration})
end

VG.GetScreenPosition = function(Model)
    if Model and Model.PrimaryPart then
        local ScreenPosition, OnScreen = CurrentCamera():WorldToViewportPoint(Model.PrimaryPart.Position)
        if OnScreen then
            return Vector2.new(ScreenPosition.X, ScreenPosition.Y)
        end
    end
    return Vector2.new(0,0)
end

VG.GetHealth = function(Model)
    local Humanoid = VG.IsA(Model, "Humanoid")
    if Humanoid then
        return Humanoid.Health
    end
    return 100
end

VG.GetPlayerFromCharacter = function(Model)
    return Players:GetPlayerFromCharacter(Model)
end

VG.GetTeam = function()
    return Player and Player.Team
end

VG.GetCharacter = function()
    return Player and Player.Character
end

VG.GetTeamColor = function()
    return Player and Player.TeamColor 
end

VG.IDC = function(Part, Parent)
    if Part and Part:IsDescendantOf(Parent) then
        return true
    end
    return false
end

VG.Flying = function(Toggle, Speed)
    getgenv().Flying = Toggle
    if Toggle then
        local Max = 0
        local LP = Players.LocalPlayer
        local Mouse = LP:GetMouse()
        Max = Max + 1
        if Toggle then
            local T = LP.Character:FindFirstChild("UpperTorso",true) or LP.Character:FindFirstChild("HumanoidRootPart",true)
            local S = {
                F = 0,
                B = 0,
                L = 0,
                R = 0
            }
            local S2 = {
                F = 0,
                B = 0,
                L = 0,
                R = 0
            }
            local SPEED = 5
            local function FLY()
                local BodyGyro = Instance.new("BodyGyro", T)
                local BodyVelocity = Instance.new("BodyVelocity", T)
                BodyGyro.P = 9e4
                BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                BodyGyro.cframe = T.CFrame
                BodyVelocity.velocity = Vector3.new(0, 0, 0)
                BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
                spawn(function()
                    repeat wait()
                        LP.Character.Humanoid.PlatformStand = true
                        if S.L + S.R ~= 0 or S.F + S.B ~= 0 then
                            SPEED = Speed
                        elseif not (S.L + S.R ~= 0 or S.F + S.B ~= 0) and SPEED ~= 0 then
                            SPEED = 0
                        end
                        if (S.L + S.R) ~= 0 or (S.F + S.B) ~= 0 then
                            BodyVelocity.velocity =
                                ((Workspace.CurrentCamera.CoordinateFrame.lookVector * (S.F + S.B)) +
                                ((Workspace.CurrentCamera.CoordinateFrame *
                                CFrame.new(S.L + S.R, (S.F + S.B) * 0.2, 0).p) -
                                Workspace.CurrentCamera.CoordinateFrame.p)) *
                                SPEED
                            S2 = {
                                F = S.F,
                                B = S.B,
                                L = S.L,
                                R = S.R
                            }
                        elseif (S.L + S.R) == 0 and (S.F + S.B) == 0 and SPEED ~= 0 then
                            BodyVelocity.velocity =
                                ((Workspace.CurrentCamera.CoordinateFrame.lookVector * (S2.F + S2.B)) +
                                ((Workspace.CurrentCamera.CoordinateFrame *
                                CFrame.new(S2.L + S2.R, (S2.F + S2.B) * 0.2, 0).p) -
                                Workspace.CurrentCamera.CoordinateFrame.p)) *
                                SPEED
                        else
                            BodyVelocity.velocity = Vector3.new(0, 0.1, 0)
                        end
                        BodyGyro.cframe = Workspace.CurrentCamera.CoordinateFrame
                    until not Toggle or not Flying
                    S = {
                        F = 0,
                        B = 0,
                        L = 0,
                        R = 0
                    }
                    S2 = {
                        F = 0,
                        B = 0,
                        L = 0,
                        R = 0
                    }
                    SPEED = 0
                    BodyGyro:destroy()
                    BodyVelocity:destroy()
                    LP.Character.Humanoid.PlatformStand = false
                end
                )
            end
            Mouse.KeyDown:connect(
                function(k)
                    if k:lower() == "w" then
                        S.F = 1
                    elseif k:lower() == "s" then
                        S.B = -1
                    elseif k:lower() == "a" then
                        S.L = -1
                    elseif k:lower() == "d" then
                        S.R = 1
                    end
                end
            )
            Mouse.KeyUp:connect(
                function(k)
                    if k:lower() == "w" then
                        S.F = 0
                    elseif k:lower() == "s" then
                        S.B = 0
                    elseif k:lower() == "a" then
                        S.L = 0
                    elseif k:lower() == "d" then
                        S.R = 0
                    end
                end
            )
            FLY()
            if Max == 2 then
                Max = 0
            end
        end
    end
end

VG.DoNothing = function()
    return {}
end

VG.WalkSpeed = function(Speed)
    VG.GetHumanoid().WalkSpeed = Speed
end

VG.SemiBypassedWalkSpeed = function(Speed)
    VG.DisableConnection(VG.GetHumanoid().Changed)
    sethiddenproperty(VG.GetHumanoid(), "WalkSpeed", Speed)
end

VG.BypassedWalkSpeed = function(Speed)
    local OldNameCall = nil
    OldNameCall = hookmetamethod(game, "__index", function(A, B, C)
        if A and B == "WalkSpeed" then
            return Speed
        end
        return OldNameCall(A, B, C)
    end)
    VG.GetHumanoid().WalkSpeed = Speed
end

VG.SuperBypassedWalkSpeed = function(Speed)
    VG.DisableConnection(VG.GetHumanoid().Changed)
    local OldNameCall = nil
    OldNameCall = hookmetamethod(game, "__index", function(A, B, C)
        if A and B == "WalkSpeed" then
            return Speed
        end
        return OldNameCall(A, B, C)
    end)
    sethiddenproperty(VG.GetHumanoid(), "WalkSpeed", Speed)
end


VG.JumpPowerHeight = function()
    if VG.GetHumanoid().JumpHeight then
        return "JumpHeight"
    else
        return "JumpPower"
    end
end
VG.JumpPower = function(Height)
    VG.GetHumanoid().JumpPower = Height
end

VG.SemiBypassedJumpPower = function(Height)
    VG.DisableConnection(VG.GetHumanoid().Changed)
    sethiddenproperty(VG.GetHumanoid(), VG.JumpPowerHeight(), Height)
end

VG.BypassedJumpPower = function(Height)
    local I = VG.JumpPowerHeight()
    local OldNameCall = nil
    OldNameCall = hookmetamethod(game, "__index", function(A, B, C)
        if A and B == I then
            return Height
        end
        return OldNameCall(A, B, C)
    end)
    VG.GetHumanoid()[VG.JumpPowerHeight()] = Height
end

VG.SuperBypassedJumpPower = function(Height)
    VG.DisableConnection(VG.GetHumanoid().Changed)
    local I = VG.JumpPowerHeight()
    local OldNameCall = nil
    OldNameCall = hookmetamethod(game, "__index", function(A, B, C)
        if A and B == I then
            return Height
        end
        return OldNameCall(A, B, C)
    end)
    sethiddenproperty(VG.GetHumanoid(), VG.JumpPowerHeight(), Height)
end

VG.Adonis = function()
    for i,v in next, getgc(true) do
        if type(v) == "table" then
            local Raw = rawget(v, "Detected")
            if Raw and typeof(Raw) == "function" and getfenv(Raw).script then
                return true
            end
        end
    end
    return false
end

VG.AntiAdonis = function()
    if VG.Adonis() then
        local NewInstances = {}
        for _,v in next, getgc(true) do
            if type(v) == "table" then
                local Raw, Raw2, Raw3 = rawget(v, "Detected"), rawget(v, "Kill"), rawget(v, "Disconnect")
                if Raw and typeof(Raw) == "function" and getfenv(Raw).script then
                    for _,v in next, v do
                        if type(v) == "function" then
                            print(v)
                            table.insert(NewInstances, v)
                        end
                    end
                end
            end
        end
        for _,v in next, NewInstances do
            hookfunction(v, coroutine.yield())
            hookfunction(v, VG.DoNothing())
            ScriptContext.SetTimeout(0)
        end
    end
    return {{{{{{}}}}}}
end
VG.RigCheck = function()
    return VG.GetHumanoid().RigType
end

VG.FireTouch = function(BasePart)
    firetouchinterest(VG.GetRoot(), BasePart, 0)
    firetouchinterest(VG.GetRoot(), BasePart, 1)
end

VG.GetModelCFrame = function(Model)
    return Model:GetModelCFrame()
end

VG.GetCFrame = function(BasePart)
    return BasePart.CFrame
end

VG.WayPoints = function(RootPart ,Position, Table)
    local S = Table or {}
    local path = PathfindingService:CreatePath(S)
    path:ComputeAsync(RootPart.Position, Position)
    local WayPoints = path:GetWaypoints()
    return WayPoints
end

VG.IY = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end
--- Infinite Yeild for developing like dex and respy 

VG.FireFunction = function(Signal)
    if getconnections then
        for _, v in next, getconnections(Signal) do
            v.Function()
        end
    end
end
--- VG.FireFunction(Idled) yes
--Loops

for i,v in next, Players:GetPlayers() do
    if v ~= Player then
        table.insert(AllPlayers, v.Name)
    end
end

Players.PlayerAdded:Connect(function(v)
    if v ~= Player then
        table.insert(AllPlayers, v.Name)
    end
end)

Players.PlayerRemoving:Connect(function(v)
    if v ~= Player then 
        local String = table.find(AllPlayers, v.Name)
        table.remove(AllPlayers, String)
    end
end)

RenderStepped:Connect(function()
    VG.GetProtecter().Name = HttpService:GenerateGUID()
end)
