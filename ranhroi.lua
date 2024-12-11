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

local loopInterval = 1  -- Interval for checking and crafting (in seconds)

-- Remotes
local craftRemote = game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("SnowMachine_Activate")

-- Function to process Snowflakes
local function processSnowflakes()
    -- Get the player's inventory
    local playerInventory = Save.Get()["Inventory"]
    local Lootboxinv = playerInventory["Lootbox"] or {}
    local Eventinv = playerInventory["Misc"] or {}

    local SnowflakeCount = 0

    -- Function to calculate the counts
    local function calculateCounts()
        SnowflakeCount = 0

        -- Count the total Snowflakes in the Event section
        for _, item in pairs(Eventinv) do
            if item.id == "Snowflake" then
                SnowflakeCount = SnowflakeCount + (item._am or 0)  -- Ensure item._am exists
            end
        end
    end

    -- Function to craft Snowflake Gifts
    local function craftSnowflakeGifts(amount)
        while SnowflakeCount >= amount do
            local success, errorMessage = pcall(function()
                craftRemote:InvokeServer(amount)
            end)

            if success then
                print("Successfully crafted " .. amount .. " Snowflake Gifts.")
                SnowflakeCount = SnowflakeCount - amount
            else
                print("Failed to craft " .. amount .. " Snowflake Gifts. Error: " .. errorMessage)
                break
            end

            wait(1)  -- Wait for 1 second before crafting again
        end
    end

    -- Recalculate counts
    calculateCounts()

    -- Craft Snowflake Gifts if Snowflakes are available
    if SnowflakeCount > 0 then
        return true
    else
        print("Not enough Snowflakes available for crafting.")
        return false
    end
end

-- List of craft amounts in a looping order
local craftAmounts = {1000, 100, 10}
local index = 1

-- Main process loop
while true do
    if processSnowflakes() then
        -- Craft Snowflake Gifts using the current amount
        craftSnowflakeGifts(craftAmounts[index])

        -- Move to the next craft amount (1000 → 100 → 10 → repeat)
        index = index % #craftAmounts + 1
    end
    
    wait(loopInterval)  -- Wait for the next iteration
end
