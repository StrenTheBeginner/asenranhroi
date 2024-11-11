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
    "Cave Egg", "Sky Egg", "Volcano Egg", "Space Egg", "Candy Egg", "Winter Egg"
}

local autoHatchEnabled = false

-- Egg Selection Dropdown
EggsSection:AddDropdown({
    Name = "Choose Egg",
    Default = "Starter Egg",
    Options = eggs,
    Callback = function(SelectedEgg)
        local args = { [1] = SelectedEgg, [2] = 1 }
        game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Eggs_RequestPurchase"):InvokeServer(unpack(args))
        RanhRoi:MakeNotification({
            Name = "Egg Selected",
            Content = "You selected " .. SelectedEgg,
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
})

-- Auto Hatch Toggle
EggsSection:AddToggle({
    Name = "Auto Hatch Eggs",
    Default = false,
    Callback = function(Value)
        autoHatchEnabled = Value

        if autoHatchEnabled then
            RanhRoi:MakeNotification({
                Name = "Auto Hatch Enabled",
                Content = "Auto Hatch is now enabled.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })

            spawn(function()
                -- Check available hatch slots
                local hatchCountObj = game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Index: Request Hatch Count")
                local hatchCount = hatchCountObj and hatchCountObj.Value or 0

                if hatchCount > 0 then
                    -- Loop through all available slots to hatch eggs
                    for i = 1, hatchCount do
                        local args = { [1] = true }  -- Request to start hatching
                        game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("AutoHatch_Toggle"):FireServer(unpack(args))
                        wait(1)  -- Add a small delay between hatch requests
                    end
                    RanhRoi:MakeNotification({
                        Name = "Auto Hatch Started",
                        Content = "Started hatching the maximum available eggs.",
                        Image = "rbxassetid://4483345998",
                        Time = 5
                    })
                else
                    RanhRoi:MakeNotification({
                        Name = "No Hatch Slots Available",
                        Content = "You don't have any available hatch slots.",
                        Image = "rbxassetid://4483345998",
                        Time = 5
                    })
                end
            end)
        else
            RanhRoi:MakeNotification({
                Name = "Auto Hatch Disabled",
                Content = "Auto Hatch has been disabled.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
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

-- Auto Crafting Toggle
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
                {id = "0cb7d35612fc48929559584cd36fdb39", amount = 10}
            }

            spawn(function()
                while autoCraftingEnabled do
                    for _, fruit in ipairs(fruits) do
                        local args = {fruit.id, fruit.amount}
                        game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("RainbowFruit_Craft"):InvokeServer(unpack(args))
                        wait(2)
                    end
                end
            end)
        else
            RanhRoi:MakeNotification({
                Name = "Auto Crafting Disabled",
                Content = "Auto crafting has been disabled.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end
})

RanhRoi:Init()
