local RanhRoi = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))() 

RanhRoi:MakeNotification({
    Name = "RanhRoi Hub | by Asen <3",
    Content = "RanhRoi Hub",
    Image = "rbxassetid://4483345998",
    Time = 5
})

local Window = RanhRoi:MakeWindow({Name = "RanhRoi Hub", HidePremium = false, SaveConfig = true, ConfigFolder = "RanhRoi"})

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
        game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Eggs_RequestHatch"):InvokeServer(unpack(args))  -- Replace with the actual event to trigger hatching
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
                Name = "Auto Craft Enabled",
                Content = "Auto crafting for Rainbow Fruit is now enabled.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
            
            spawn(function()
                while autoCraftingEnabled do
                    local rainbowFruitCraft = game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Items_RequestCraft"):InvokeServer("Rainbow Fruit")
                    wait(2)
                end
            end)
        else
            RanhRoi:MakeNotification({
                Name = "Auto Craft Disabled",
                Content = "Auto crafting for Rainbow Fruit is now disabled.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end
})

-- Finalizing the Window
RanhRoi:Init()
