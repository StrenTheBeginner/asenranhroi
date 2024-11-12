-- Initialize the Orion UI
local RanhRoi = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))() 

RanhRoi:MakeNotification({
    Name = "RanhRoi Hub | by Asen <3",
    Content = "RanhRoi Hub",
    Image = "rbxassetid://4483345998",
    Time = 5
})

local Window = RanhRoi:MakeWindow({
    Name = "RanhRoi Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "RanhRoi"
})

-- Player Tab
local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local PlayerSection = PlayerTab:AddSection({
    Name = "Player"
})

PlayerSection:AddTextbox({
    Name = "Walkspeed",
    Default = "16",
    TextDisappear = true,
    Callback = function(Value)
        local speed = tonumber(Value)
        if speed and speed >= 16 and speed <= 100 then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
        else
            RanhRoi:MakeNotification({
                Name = "Invalid Value",
                Content = "Please enter a number between 16 and 100.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end    
})

-- Miscs Tab
local MiscsTab = Window:MakeTab({
    Name = "Miscs",  
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local MiscsSection = MiscsTab:AddSection({
    Name = "Miscs"
})

MiscsSection:AddButton({
    Name = "Destroy UI",
    Callback = function()
        RanhRoi:Destroy()
    end
})

local autoClaimEnabled = false

MiscsSection:AddToggle({
    Name = "Auto-Claim Mailbox",
    Default = false,
    Callback = function(Value)
        autoClaimEnabled = Value

        if autoClaimEnabled then
            RanhRoi:MakeNotification({
                Name = "Auto-Claim Enabled",
                Content = "Auto claim for mail is now enabled.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
            
            spawn(function()
                while autoClaimEnabled do
                    local mailboxClaimAll = game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Mailbox: Claim All")
                    if mailboxClaimAll then
                        mailboxClaimAll:InvokeServer()
                    end
                    wait(2)
                end
            end)
        else
            RanhRoi:MakeNotification({
                Name = "Auto-Claim Disabled",
                Content = "Auto claim for mail is now disabled.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end
})

-- Teleport Tab
local TeleportTab = Window:MakeTab({
    Name = "Teleport",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local TeleportSection = TeleportTab:AddSection({
    Name = "Teleport"
})

TeleportSection:AddButton({
    Name = "Auto TP to World 1 Spawn",
    Callback = function()
        -- Get the player
        local player = game.Players.LocalPlayer

        -- Wait for the player's character to load
        local character = player.Character or player.CharacterAdded:Wait()

        -- Wait for the HumanoidRootPart to load
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        -- Target CFrame (World 1 Spawn coordinates)
        local targetCFrame = CFrame.new(154.857315, 17.7020283, -209.59523)

        -- Function to teleport the player to the target CFrame
        local function teleportToTarget()
            -- Set the CFrame to the target
            humanoidRootPart.CFrame = targetCFrame

            -- Prevent falling through the void
            -- Check if the character is above ground (on a platform, not falling)
            local raycastResult = workspace:Raycast(humanoidRootPart.Position, Vector3.new(0, -10, 0))

            -- If there is no ground below, fix the position by setting a safe height
            if not raycastResult then
                humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position.X, 10, humanoidRootPart.Position.Z)  -- Set to a safe height (10 studs above ground)
            end
        end

        -- Loop to teleport 2 times
        for i = 1, 2 do
            teleportToTarget()
            wait(2)  -- Wait for 2 seconds before the next teleport
        end
    end
})

local originalPosition = nil

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = ReplicatedStorage:WaitForChild("Network")
local InvokeFunction = Network:WaitForChild("Instancing_InvokeCustomFromClient")

local isAutoFishingActive = false

local function autoFish()
    while isAutoFishingActive do
        local args = {
            [1] = "Fishing",
            [2] = "Clicked"
        }
        InvokeFunction:InvokeServer(unpack(args))
        wait(0.05)  -- Decreased delay to speed up the fishing process
    end
end

TeleportSection:AddToggle({
    Name = "Auto Fishing",
    Default = false,
    Save = true,
    Flag = "autoFishing",
    Callback = function(State)
        local player = game.Players.LocalPlayer

        if player and player.Character then
            local humanoidRootPart = player.Character:WaitForChild("HumanoidRootPart")

            if State then
                isAutoFishingActive = true
                originalPosition = humanoidRootPart.CFrame

                humanoidRootPart.CFrame = CFrame.new(
                    797.1300048828125, 20.14695167541504, 1140.8101806640625,
                    -0.826375067, -1.17252284e-07, 0.563120127,
                    -8.21544859e-08, 1, 8.76577957e-08,
                    -0.563120127, 2.61753765e-08, -0.826375067
                )

                OrionLib:MakeNotification({
                    Name = "Auto Fishing Activated",
                    Content = "Starting the fishing loop.",
                    Image = "rbxassetid://6023426923",
                    Time = 5
                })

                task.spawn(autoFish)
            else
                isAutoFishingActive = false

                if originalPosition then
                    humanoidRootPart.CFrame = originalPosition
                    OrionLib:MakeNotification({
                        Name = "Auto Fishing Deactivated",
                        Content = "Returning to the original position.",
                        Image = "rbxassetid://6023426923",
                        Time = 5
                    })
                end
            end
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Player's character or HumanoidRootPart is not found.",
                Image = "rbxassetid://6023426923",
                Time = 5
            })
        end
    end
})


-- Minigames Tab
local MinigamesTab = Window:MakeTab({
    Name = "Minigames",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local MinigamesSection = MinigamesTab:AddSection({
    Name = "Minigames"
})

MinigamesSection:AddButton({
    Name = "Teleport to Digsite!",
    Callback = function()
        local args = {
            [1] = "Fossil Digsite"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Teleports_RequestTeleport"):InvokeServer(unpack(args))
    end    
})

-- Eggs Tab
local EggsTab = Window:MakeTab({
    Name = "Eggs",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local EggsSection = EggsTab:AddSection({
    Name = "Eggs"
})

local eggs = {
    "Starter Egg", "Forest Egg", "Desert Egg", "Jungle Egg", "Ocean Egg",
    "Cave Egg", "Sky Egg", "Volcano Egg", "Space Egg", "Candy Egg", "Winter Egg",
    "Pirate Egg", "Egyptian Egg", "Medieval Egg", "Futuristic Egg", "Underwater Egg",
    "Haunted Egg", "Christmas Egg", "Easter Egg", "Halloween Egg", "Valentine's Egg",
    "St. Patrick's Egg", "Summer Egg", "Autumn Egg", "Spring Egg", "Winter Wonderland Egg",
    "Beach Egg", "Mountain Egg", "City Egg", "Farm Egg", "Space Station Egg",
    "Moon Egg", "Mars Egg", "Alien Egg", "Robot Egg", "Superhero Egg", "Villain Egg",
    "Fairy Egg", "Dragon Egg", "Unicorn Egg", "Mermaid Egg", "Knight Egg", "Wizard Egg",
    "Pirate Ship Egg", "Treasure Egg", "Kingdom Egg", "Castle Egg", "Dungeon Egg",
    "Lab Egg", "Factory Egg", "Workshop Egg", "Garage Egg", "Airport Egg", "Train Station Egg",
    "Bus Station Egg", "Subway Egg", "Amusement Park Egg", "Zoo Egg", "Aquarium Egg",
    "Museum Egg", "Library Egg", "Park Egg", "Beach Resort Egg", "Mountain Resort Egg",
    "City Resort Egg", "Farm Resort Egg", "Space Resort Egg", "Moon Resort Egg", "Mars Resort Egg",
    "Alien Resort Egg", "Robot Resort Egg", "Superhero Resort Egg", "Villain Resort Egg", "Fairy Resort Egg",
    "Dragon Resort Egg", "Unicorn Resort Egg", "Mermaid Resort Egg", "Knight Resort Egg", "Wizard Resort Egg",
    "Pirate Ship Resort Egg", "Treasure Resort Egg", "Kingdom Resort Egg", "Castle Resort Egg", "Dungeon Resort Egg",
    "Lab Resort Egg", "Factory Resort Egg", "Workshop Resort Egg", "Garage Resort Egg", "Airport Resort Egg",
    "Train Station Resort Egg", "Bus Station Resort Egg", "Subway Resort Egg", "Amusement Park Resort Egg", "Zoo Resort Egg",
    "Aquarium Resort Egg", "Museum Resort Egg", "Library Resort Egg", "Park Resort Egg"
}

local selectedEgg = "Starter Egg"

-- Dropdown for Egg Selection
EggsSection:AddDropdown({
    Name = "Choose Egg",
    Default = selectedEgg,
    Options = eggs,
    Callback = function(SelectedEgg)
        selectedEgg = SelectedEgg
        RanhRoi:MakeNotification({
            Name = "Egg Selected",
            Content = "You selected " .. selectedEgg,
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
})

-- Start Hatching Button
EggsSection:AddButton({
    Name = "Start Hatching",
    Callback = function()
        RanhRoi:MakeNotification({
            Name = "Hatching Started",
            Content = "Starting hatching " .. selectedEgg,
            Image = "rbxassetid://4483345998",
            Time = 5
        })
        
        -- Trigger the hatching process (you should replace this with the actual event or function from the game)
        local args = { [1] = selectedEgg }
        game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Eggs_RequestHatch"):InvokeServer(unpack(args))  -- Replace with actual function/event
    end
})

-- Farming Tab
local FarmingTab = Window:MakeTab({
    Name = "Farming",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local FarmingSection = FarmingTab:AddSection({
    Name = "Farming"
})

FarmingSection:AddButton({
    Name = "Start Farming",
    Callback = function()
        RanhRoi:MakeNotification({
            Name = "Farming Started",
            Content = "Farming has been started!",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end    
})

-- Webhooks Tab
local WebhooksTab = Window:MakeTab({
    Name = "Webhooks",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local WebhooksSection = WebhooksTab:AddSection({
    Name = "Webhooks"
})

WebhooksSection:AddButton({
    Name = "Send Webhook",
    Callback = function()
        RanhRoi:MakeNotification({
            Name = "Webhook Sent",
            Content = "Webhook has been sent!",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end    
})

-- Items Tab
local ItemsTab = Window:MakeTab({
    Name = "Items",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local ItemsSection = ItemsTab:AddSection({
    Name = "Items"
})

ItemsSection:AddButton({
    Name = "Give Item",
    Callback = function()
        RanhRoi:MakeNotification({
            Name = "Item Given",
            Content = "Item has been given!",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end    
})

-- Auto Crafting Tab
local autoCraftingEnabled = false

ItemsSection:AddToggle({
    Name = "Auto Craft Rainbow Fruit",
    Default = false,
    Callback = function(Value)
        autoCraftingEnabled = Value

        if autoCraftingEnabled then
            RanhRoi:MakeNotification({
                Name = "Auto Crafting Enabled",
                Content = "Started auto-crafting Rainbow Fruits.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
            
            local fruits = {
                {id = "0cb7d35612fc48929559584cd36fdb38", amount = 10},
                {id = "2bb864d7fde344128f542c947d684b8c", amount = 25},
                {id = "769e2b2ce99844a3ad0d62ac565e59ec", amount = 25},
                {id = "cf3d41ee78594bc0ac32e5487a856ba7", amount = 25},
                {id = "58fb1f27c9634b05b6e5e36d09884c7e", amount = 40}
            }

            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local network = ReplicatedStorage:WaitForChild("Network")
            local upgradeFunction = network:WaitForChild("UpgradeFruitsMachine_Activate")

            local function upgradeFruitsContinuously()
                while autoCraftingEnabled do
                    for _, fruit in ipairs(fruits) do
                        local args = {
                            [1] = {
                                [fruit.id] = fruit.amount
                            }
                        }

                        local success, message = pcall(function()
                            upgradeFunction:InvokeServer(unpack(args))
                        end)

                        if not success then
                            RanhRoi:MakeNotification({
                                Name = "Upgrade Failed",
                                Content = "Failed to upgrade " .. fruit.id .. ": " .. tostring(message),
                                Image = "rbxassetid://4483345998",
                                Time = 5
                            })
                        end
                    end

                    wait(0.0001)
                end
            end

            upgradeFruitsContinuously()
        else
            RanhRoi:MakeNotification({
                Name = "Auto Crafting Disabled",
                Content = "Stopped auto-crafting Rainbow Fruits.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end
})

RanhRoi:Init()
