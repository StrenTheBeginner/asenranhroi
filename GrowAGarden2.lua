
local NORMAL_SEEDS = {
	"Carrot", "Strawberry", "Blueberry", "Tulip", "Tomato", "Apple", "Bamboo", "Corn",
	"Cactus", "Pineapple", "Mushroom", "Green Bean", "Banana", "Grape", "Coconut", "Mango",
	"Dragon Fruit", "Acorn", "Cherry", "Sunflower", "Venus Fly Trap", "Pomegranate",
	"Poison Apple", "Moon Bloom", "Dragon's Breath", "Ghost Pepper", "Poison Ivy",
	"Baby Cactus", "Glow Mushroom", "Romanesco", "Horned Melon",
}

local MUTATION_SEEDS = { "Gold", "Rainbow" }

local ALL_SEEDS = {}
for _, name in NORMAL_SEEDS do table.insert(ALL_SEEDS, name) end
for _, name in MUTATION_SEEDS do table.insert(ALL_SEEDS, name) end

local ALL_WILD_PETS = {
	"Frog", "Bunny", "Deer", "Owl", "Robin", "Bee", "Monkey", "Unicorn",
	"Raccoon", "Golden Dragonfly", "Black Dragon", "Ice Serpent",
}

local FALLBACK_PET_META = {
	Frog = { DisplayName = "Frog", Rarity = "Common", BasePrice = 10000, SpawnChance = 11.9 },
	Bunny = { DisplayName = "Bunny", Rarity = "Common", BasePrice = 20000, SpawnChance = 11.9 },
	Deer = { DisplayName = "Deer", Rarity = "Rare", BasePrice = 50000, SpawnChance = 4.29 },
	Owl = { DisplayName = "Owl", Rarity = "Uncommon", BasePrice = 25000, SpawnChance = 7.14 },
	Robin = { DisplayName = "Robin", Rarity = "Legendary", BasePrice = 75000, SpawnChance = 2.86 },
	Bee = { DisplayName = "Bee", Rarity = "Legendary", BasePrice = 1000000, SpawnChance = 2.38 },
	Monkey = { DisplayName = "Monkey", Rarity = "Mythic", BasePrice = 1000000, SpawnChance = 0.2 },
	Unicorn = { DisplayName = "Unicorn", Rarity = "Mythic", BasePrice = 4000000, SpawnChance = 0.71 },
	Raccoon = { DisplayName = "Raccoon", Rarity = "Super", BasePrice = 5000000, SpawnChance = 0.24 },
	GoldenDragonfly = { DisplayName = "Golden Dragonfly", Rarity = "Mythic", BasePrice = 3000000, SpawnChance = 0.6 },
	BlackDragon = { DisplayName = "Black Dragon", Rarity = "Super", BasePrice = 1000000, SpawnChance = 0 },
	IceSerpent = { DisplayName = "Ice Serpent", Rarity = "Super", BasePrice = 20000000, SpawnChance = 0 },
}

local ALL_GEAR = {
	"Common Watering Can", "Common Sprinkler", "Sign", "Lantern", "Uncommon Sprinkler",
	"Rare Sprinkler", "Legendary Sprinkler", "Super Sprinkler", "Trowel", "Speed Mushroom",
	"Jump Mushroom", "Gnome", "Shrink Mushroom", "Supersize Mushroom", "Invisibility Mushroom",
	"Wheelbarrow", "Teleporter", "Super Watering Can", "Basic Pot", "Flashbang",
}

local function buildZeroMap(names)
	local map = {}
	for _, name in names do
		map[name] = 0
	end
	return map
end

local function buildFalseMap(names)
	local map = {}
	for _, name in names do
		map[name] = false
	end
	return map
end

local function buildKaitunPlantMap()
	local map = buildZeroMap(NORMAL_SEEDS)
	map["Carrot"] = 50
	map["Strawberry"] = 4
	map["Blueberry"] = 4
	map["Tulip"] = 50
	map["Tomato"] = 4
	map["Apple"] = 4
	map["Bamboo"] = 50
	map["Corn"] = 4
	map["Cactus"] = 4
	map["Pineapple"] = 4
	map["Mushroom"] = 50
	map["Green Bean"] = 50
	map["Banana"] = 50
	map["Grape"] = 50
	map["Coconut"] = 50
	map["Mango"] = 50
	map["Dragon Fruit"] = 50
	map["Acorn"] = 50
	map["Cherry"] = 50
	map["Sunflower"] = 50
	map["Venus Fly Trap"] = 50
	map["Pomegranate"] = 50
	map["Poison Apple"] = 50
	map["Moon Bloom"] = 50
	map["Dragon's Breath"] = 50
	map["Ghost Pepper"] = 50
	map["Poison Ivy"] = 50
	map["Baby Cactus"] = 50
	map["Glow Mushroom"] = 50
	map["Romanesco"] = 50
	map["Horned Melon"] = 50
	return map
end

local function buildKaitunBuySeedMap()
	local map = buildZeroMap(NORMAL_SEEDS)
	for name, _ in map do
		map[name] = 999
	end
	return map
end

local function buildKaitunGearMap(enabledNames)
	local map = buildZeroMap(ALL_GEAR)
	for _, gearName in enabledNames do
		map[gearName] = gearName == "Common Sprinkler" and 2 or 1
	end
	return map
end

local function buildKaitunUseGearMap(enabledNames)
	local map = buildZeroMap(ALL_GEAR)
	for _, gearName in enabledNames do
		map[gearName] = 1
	end
	return map
end

local USER_CONFIG = {
	["PLANT_SEED"] = buildKaitunPlantMap(),
	["BUY_SEED"] = buildKaitunBuySeedMap(),
	["BUY_GEAR"] = buildKaitunGearMap({ "Common Sprinkler" }),
	["USE_GEAR"] = buildKaitunUseGearMap({ "Common Sprinkler" }),
	["BUY_PET"] = buildZeroMap(ALL_WILD_PETS),
}

local PET_INVENTORY_FOLDERS = {
	Raccoon = "Raccoons",
}
local WILD_PET_BUY_EACH = 1
local PET_BUY_ORDER = {}
local WILD_PET_COLLECT_ORDER = {}
local HazardSeeds = {}
local HAZARD_CONTROLLER_TAGS = {
	"VenusFlyTrap", "PoisonIvy", "GhostPepper", "DragonBreath",
}
local HAZARD_SEEDS_FALLBACK = {
	["Venus Fly Trap"] = true,
	["Poison Ivy"] = true,
	["Ghost Pepper"] = true,
	["Dragon's Breath"] = true,
	["Cactus"] = true,
	["Baby Cactus"] = true,
	["Horned Melon"] = true,
	["Poison Apple"] = true,
}
local SINGLE_HARVEST_FALLBACK = {
	Carrot = true,
	Tulip = true,
	Bamboo = true,
	Mushroom = true,
}

local function parseAmountEntry(value)
	if type(value) == "number" then
		return math.max(0, math.floor(value))
	end
	if type(value) == "boolean" then
		return value and 1 or 0
	end
	if type(value) == "table" then
		local amount = tonumber(value["amount"] or value.amount or value.Amount) or 0
		local enabled = value["enabled"]
		if enabled == nil then enabled = value.enabled end
		if enabled == false then return 0 end
		if amount > 0 then return math.floor(amount) end
		return enabled == true and 1 or 0
	end
	return 0
end

local function cfgVal(cfg, key, default)
	if typeof(cfg) ~= "table" then return default end
	local v = cfg[key]
	if v == nil then return default end
	return v
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

-- =============================================================================
-- Embedded GAG2 API
-- =============================================================================
local API = {}
API.ready = false

local G = {
	Networking = nil,
	SellValueData = nil,
	FruitValueCalc = nil,
	MutationData = nil,
	TimeCycleData = nil,
	WeatherData = nil,
	Gardens = nil,
	NightValue = nil,
	WeatherValues = nil,
	StealFlags = nil,
}

-- Fallback cycle data (no require needed)
local FALLBACK_CYCLE = {
	Day = { Lasts = 450, StartOrder = 1 },
	Sunset = { Lasts = 30, StartOrder = 2 },
	Night = {
		Lasts = 120, StartOrder = 3,
		Weathers = {
			Moon = { Chance = 79 },
			Bloodmoon = { Chance = 2 },
			Goldmoon = { Chance = 13 },
			["Rainbow Moon"] = { Chance = 6 },
		},
	},
}

-- Basic sell prices if SellValueData cannot load
local FALLBACK_SELL = {
	Carrot = 5, Strawberry = 3, Tomato = 9, Blueberry = 5, Apple = 12,
	Pinetree = 100, Bamboo = 800, Pumpkin = 350, Cactus = 40, Pineapple = 30,
	["Green Bean"] = 10, Banana = 35, Grape = 45, Mushroom = 13000, Coconut = 60,
	Mango = 90, ["Thorn Rose"] = 140, ["Dragon Fruit"] = 150, Acorn = 200,
	Cherry = 350, Sunflower = 1750, ["Venus Fly Trap"] = 3000, Lotus = 6500,
	Pomegranate = 900, Beanstalk = 2000, ["Poison Apple"] = 900,
	["Moon Bloom"] = 9000, ["Dragon's Breath"] = 3400, ["Poison Ivy"] = 1700,
	["Glow Mushroom"] = 700, ["Ghost Pepper"] = 2500, ["Horned Melon"] = 200,
	Corn = 34, ["Baby Cactus"] = 70, Tulip = 60, Romanesco = 1500,
}

local RARITY_RANK = {
	Common = 1, Uncommon = 2, Rare = 3, Epic = 4,
	Legendary = 5, Mythic = 6, Super = 7, Secret = 8,
}

-- Pet equip priority (fixed): Super > Mythic > Legendary > Rare > Uncommon > Common
local PET_RARITY_RANK = {
	["Common"] = 1,
	["Uncommon"] = 2,
	["Rare"] = 3,
	["Legendary"] = 4,
	["Mythic"] = 5,
	["Super"] = 6,
}

local FORECAST_EVENTS = { "Sunset", "Moon", "Goldmoon", "Rainbow Moon", "Bloodmoon" }
local cyclePhases, cycleSum, nightPhaseIndex
local equippedPetCache = { time = -999, pets = {} }
local forecastCache = { time = -999, list = {} }

local function shallowCopy(tbl)
	local out = {}
	for k, v in tbl do out[k] = v end
	return out
end

function API.init(timeout)
	if API.ready then return true end
	timeout = timeout or 25
	local ok, err = pcall(function()
		local shared = ReplicatedStorage:WaitForChild("SharedModules", timeout)
		G.Gardens = workspace:WaitForChild("Gardens", timeout)
		G.NightValue = ReplicatedStorage:WaitForChild("Night", math.min(timeout, 10))
		G.WeatherValues = ReplicatedStorage:FindFirstChild("WeatherValues")
		-- Only require executor-safe modules (no ClientModules / Flags / SharedData chains)
		G.Networking = require(shared:WaitForChild("Networking"))
		pcall(function() G.SellValueData = require(shared:WaitForChild("SellValueData")) end)
		pcall(function() G.MutationData = require(shared:WaitForChild("MutationData")) end)
		pcall(function() G.FruitValueCalc = require(shared:WaitForChild("FruitValueCalc")) end)
		pcall(function()
			local flags = shared:FindFirstChild("Flags")
			if flags then G.StealFlags = require(flags:WaitForChild("StealFlags")) end
		end)
		pcall(function() G.CalculateStealDuration = require(shared:WaitForChild("CalculateStealDuration")) end)
		pcall(function() G.TimeCycleData = require(shared:WaitForChild("TimeCycleData")) end)
		pcall(function() G.WeatherData = require(shared:WaitForChild("WeatherData")) end)
	end)
	API.ready = ok
	if not ok then warn("[So Nach Hup] init failed: " .. tostring(err)) end
	return ok
end

function API.getNetworking()
	API.init()
	return G.Networking
end

function API.getLocalPlotId()
	return LocalPlayer:GetAttribute("PlotId")
end

function API.getPlot(plotId)
	API.init()
	if not G.Gardens or plotId == nil then return nil end
	return G.Gardens:FindFirstChild("Plot" .. tostring(plotId))
end

-- PlotsController / SprinklerController: Gardens.Plot{PlotId}
function API.getPlayerPlot()
	API.init()
	local plotId = LocalPlayer:GetAttribute("PlotId")
	if not plotId or not G.Gardens then return nil end
	return G.Gardens:FindFirstChild("Plot" .. tostring(plotId))
end

function API.isLocalPlot(plot)
	if not plot then return false end
	local plotId = LocalPlayer:GetAttribute("PlotId")
	if plotId == nil then return false end
	return plot.Name == "Plot" .. tostring(plotId)
end

-- StealReturnArrowController / PlayerDeathTeleportController
function API.getPlotSpawnPoint(plot)
	if not plot then return nil end
	local spawn = plot:FindFirstChild("SpawnPoint")
	if spawn and spawn:IsA("BasePart") then return spawn end
	return nil
end

-- TrowelController PlotSizeReference bounds; else GardenTotalArea / PlantArea center.
function API.getPlotInteriorCenter(plot)
	if not plot then return nil end
	local ref = plot:FindFirstChild("PlotSizeReference")
	if ref and ref:IsA("BasePart") then
		return ref.CFrame:PointToWorldSpace(Vector3.new(0, ref.Size.Y * 0.5 + 3, 0))
	end
	local areas, seen = {}, {}
	local function addArea(part)
		if part:IsA("BasePart") and part:IsDescendantOf(plot) and not seen[part] then
			seen[part] = true
			table.insert(areas, part)
		end
	end
	for _, part in CollectionService:GetTagged("GardenTotalArea") do addArea(part) end
	if #areas == 0 then
		for _, part in CollectionService:GetTagged("PlantArea") do addArea(part) end
	end
	if #areas == 0 then
		for _, part in plot:GetDescendants() do
			if part:IsA("BasePart") and (part.Name == "GardenTotalArea" or part.Name == "GardenArea") then
				addArea(part)
			end
		end
	end
	if #areas > 0 then
		local best, bestVol = areas[1], 0
		for _, part in areas do
			local vol = part.Size.X * part.Size.Y * part.Size.Z
			if vol > bestVol then best, bestVol = part, vol end
		end
		return best.CFrame:PointToWorldSpace(Vector3.new(0, best.Size.Y * 0.5 + 3, 0))
	end
	local cf, size = plot:GetBoundingBox()
	return cf:PointToWorldSpace(Vector3.new(0, size.Y * 0.5 + 3, 0))
end

function API.getLocalPlot()
	local plotId = API.getLocalPlotId()
	return plotId, API.getPlayerPlot()
end

function API.getPlotOwner(plot)
	if not plot then return nil, nil, nil end
	local ownerName = plot:GetAttribute("Owner")
	local ownerUserId = plot:GetAttribute("OwnerUserId")
	local owner = nil
	if typeof(ownerUserId) == "number" then
		owner = Players:GetPlayerByUserId(ownerUserId)
	end
	if not owner and typeof(ownerName) == "string" and ownerName ~= "" then
		owner = Players:FindFirstChild(ownerName)
	end
	return owner, ownerUserId, ownerName
end

function API.getOwnedExpansions()
	local clientModules = ReplicatedStorage:FindFirstChild("ClientModules")
	local mod = clientModules and clientModules:FindFirstChild("PlayerStateClient")
	if mod then
		local ok, psc = pcall(require, mod)
		if ok and psc and psc.GetLocalReplica then
			local ok2, replica = pcall(function()
				return psc:GetLocalReplica()
			end)
			if ok2 and replica and replica.Data and typeof(replica.Data.OwnedExpansions) == "number" then
				return math.max(1, math.floor(replica.Data.OwnedExpansions))
			end
		end
	end
	local attr = LocalPlayer:GetAttribute("OwnedExpansions") or LocalPlayer:GetAttribute("GardenExpansion")
	if typeof(attr) == "number" and attr > 0 then return math.floor(attr) end
	local _, plot = API.getLocalPlot()
	if plot then
		local level = plot:GetAttribute("GardenExpansion")
		if typeof(level) == "number" and level > 0 then return math.floor(level) end
	end
	return 1
end

function API.isPositionInsidePlot(plot, position)
	if not (plot and position) then return false end
	local ref = plot:FindFirstChild("PlotSizeReference")
	if ref and ref:IsA("BasePart") then
		local localPos = ref.CFrame:PointToObjectSpace(position)
		local half = ref.Size * 0.5
		return math.abs(localPos.X) <= half.X and math.abs(localPos.Z) <= half.Z
	end
	local cf, size = plot:GetBoundingBox()
	local localPos = cf:PointToObjectSpace(position)
	local half = size * 0.5
	return math.abs(localPos.X) <= half.X + 5 and math.abs(localPos.Z) <= half.Z + 5
end

function API.isPlayerInsidePlot(player, plot)
	if not (player and plot) then return false end
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not root then return false end
	return API.isPositionInsidePlot(plot, root.Position)
end

function API.isInOwnGarden(player)
	player = player or LocalPlayer
	if not player then return false end
	return player:GetAttribute("IsInOwnGarden") == true
end

function API.isNight()
	API.init()
	if G.NightValue and G.NightValue.Value == true then return true end
	local night = ReplicatedStorage:FindFirstChild("Night")
	if night and night:IsA("BoolValue") and night.Value == true then return true end
	return workspace:GetAttribute("ActivePhase") == "Night"
end

function API.canStealNow()
	return API.isNight()
end

-- Roblox server kind (matches g2 Environment.module.lua).
function API.getServerKind()
	if game.PrivateServerId == "" then return "Standard" end
	if game.PrivateServerOwnerId == 0 then return "Reserved" end
	return "Private"
end

function API.isPrivateServer()
	return game.PrivateServerId ~= "" and game.PrivateServerOwnerId ~= 0
end

function API.isNonPublicServer()
	return game.PrivateServerId ~= ""
end

function API.isGardenLockedForSteal(ownerPlayer)
	if not API.canStealNow() then return true end
	if not ownerPlayer then return false end
	if ownerPlayer:GetAttribute("IsInOwnGarden") == true then return true end
	return false
end

function API.getAllPlots()
	API.init()
	local plots = {}
	if not G.Gardens then return plots end
	for _, plot in G.Gardens:GetChildren() do
		if plot:IsA("Model") and plot.Name:match("^Plot%d+$") then
			table.insert(plots, plot)
		end
	end
	return plots
end

function API.getOtherPlots()
	local out = {}
	for _, plot in API.getAllPlots() do
		local owner, ownerUserId, ownerName = API.getPlotOwner(plot)
		if owner ~= LocalPlayer and owner then
			table.insert(out, {
				plot = plot,
				owner = owner,
				ownerUserId = ownerUserId,
				ownerName = ownerName,
				unlockedForSteal = not API.isGardenLockedForSteal(owner),
			})
		end
	end
	return out
end

function API.getSheckles()
	local ls = LocalPlayer:FindFirstChild("leaderstats")
	local stat = ls and ls:FindFirstChild("Sheckles")
	if stat and (stat:IsA("IntValue") or stat:IsA("NumberValue")) then
		return stat.Value
	end
	local attr = tonumber(LocalPlayer:GetAttribute("Sheckles"))
	if attr then return attr end
	pcall(function()
		local clientModules = ReplicatedStorage:FindFirstChild("ClientModules")
		local mod = clientModules and clientModules:FindFirstChild("PlayerStateClient")
		if mod then
			local psc = require(mod)
			local replica = psc.GetLocalReplica and psc:GetLocalReplica()
			if replica and replica.Data and typeof(replica.Data.Sheckles) == "number" then
				attr = replica.Data.Sheckles
			end
		end
	end)
	return tonumber(attr) or 0
end

function API.getEquippedPets(forceRefresh)
	API.init()
	if not forceRefresh and os.clock() - equippedPetCache.time < 1.5 then
		return equippedPetCache.pets
	end
	local pets = {}
	if G.Networking and G.Networking.Pets and G.Networking.Pets.GetEquippedPets then
		local ok, result = pcall(function()
			return G.Networking.Pets.GetEquippedPets:Fire()
		end)
		if ok and type(result) == "table" then
			for _, pet in result do
				if type(pet) == "table" then table.insert(pets, shallowCopy(pet)) end
			end
		end
	end
	equippedPetCache.time = os.clock()
	equippedPetCache.pets = pets
	return pets
end

function API.getSellValue(itemName)
	API.init()
	if itemName and G.SellValueData then return G.SellValueData[itemName] or FALLBACK_SELL[itemName] or 0 end
	return itemName and (FALLBACK_SELL[itemName] or 0) or 0
end

local MUTATION_MULT = {
	Gold = 20, Rainbow = 50, Shocked = 100, Frozen = 10,
	Wet = 2, Chilled = 2, Moonlit = 2, Bloodlit = 4,
	Electric = 2, Chained = 2, Starstruck = 2,
}

local FRUIT_SIZE_EXP = 2.65
local FRUIT_SIZE_EXP_OVERRIDES = { Mushroom = 1.9, Bamboo = 1.75 }
local FRUIT_SIZE_DR_KNEE = 5
local FRUIT_SIZE_DR_TAIL = 1.5
local FRUIT_SINGLE_HARVEST_MIN = { Carrot = 4 }

local function isSingleHarvestSeedLocal(seedName)
	if not seedName or seedName == "" then return false end
	if SINGLE_HARVEST_FALLBACK[seedName] then return true end
	local meta = SeedMeta and SeedMeta[seedName]
	if meta and meta.singleHarvest ~= nil then return meta.singleHarvest end
	return false
end

local function getMutationPriceMultiplier(mutation, seedName)
	if not mutation or mutation == "" then return 1 end
	if G.MutationData and G.MutationData.ReturnPriceMultiplier then
		local ok, mult = pcall(function()
			return G.MutationData.ReturnPriceMultiplier(mutation)
		end)
		if ok and tonumber(mult) and tonumber(mult) > 0 then
			local value = tonumber(mult)
			if isSingleHarvestSeedLocal(seedName) and value > 1 then
				return 1 + (value - 1) * 0.15
			end
			return value
		end
	end
	local mult = MUTATION_MULT[mutation] or 2
	if isSingleHarvestSeedLocal(seedName) and mult > 1 then
		return 1 + (mult - 1) * 0.15
	end
	return mult
end

local function computeFruitSizeMultiplier(seedName, sizeMulti)
	local sizeExp = FRUIT_SIZE_EXP_OVERRIDES[seedName] or FRUIT_SIZE_EXP
	local sizeVal = sizeMulti ^ sizeExp
	if sizeMulti > FRUIT_SIZE_DR_KNEE then
		sizeVal = FRUIT_SIZE_DR_KNEE ^ sizeExp * (sizeMulti / FRUIT_SIZE_DR_KNEE) ^ math.min(FRUIT_SIZE_DR_TAIL, sizeExp)
	end
	return sizeVal
end

function API.computeFruitValueFallback(seedName, sizeMulti, mutation, player, petLuck)
	local base = API.getSellValue(seedName) or 0
	local sizeVal = computeFruitSizeMultiplier(seedName, sizeMulti)
	local mutMult = getMutationPriceMultiplier(mutation, seedName)
	local luckMult = 1
	if typeof(petLuck) == "number" and petLuck > 0 then
		luckMult = 1 - math.clamp(petLuck, 0, 1) * 0.8
	end
	local friendsMult = 1
	if player then
		friendsMult = 1 + (player:GetAttribute("Friends") or 0) * 0.1
	end
	local value = math.floor(base * sizeVal * mutMult * luckMult * friendsMult)
	local minVal = FRUIT_SINGLE_HARVEST_MIN[seedName]
	if minVal then
		value = math.max(value, minVal)
	end
	return value
end

function API.getFruitValueFromModel(model)
	if not model then return 0 end
	local seedName = model:GetAttribute("SeedName") or model:GetAttribute("CorePartName")
	if not seedName or seedName == "" then return 0 end
	local sizeMulti = tonumber(model:GetAttribute("SizeMulti"))
		or tonumber(model:GetAttribute("SizeMultiplier"))
		or 1
	local mutation = model:GetAttribute("Mutation")
	local petLuck = tonumber(model:GetAttribute("PetLuck")) or 0
	pcall(function()
		if not G.FruitValueCalc then
			local shared = ReplicatedStorage:FindFirstChild("SharedModules")
			local mod = shared and shared:FindFirstChild("FruitValueCalc")
			if mod then G.FruitValueCalc = require(mod) end
		end
	end)
	if G.FruitValueCalc then
		local ok, value = pcall(function()
			return G.FruitValueCalc(seedName, sizeMulti, mutation, LocalPlayer, petLuck)
		end)
		if ok and tonumber(value) and tonumber(value) > 0 then
			return math.floor(tonumber(value))
		end
	end
	return API.computeFruitValueFallback(seedName, sizeMulti, mutation, LocalPlayer, petLuck)
end

function API.isPlantStealable(seedName)
	if not seedName or seedName == "" then return true end
	if G.StealFlags and G.StealFlags.IsPlantStealable then
		local ok, stealable = pcall(function()
			return G.StealFlags.IsPlantStealable(seedName)
		end)
		if ok then return stealable == true end
	end
	return true
end

function API.getStealableFruitsOnPlot(plot, ownerUserId)
	API.init()
	if not (plot and ownerUserId) then return {} end
	if SNH and SNH.gatherStealTargets then
		local targets = SNH.gatherStealTargets(plot, ownerUserId)
		local out = {}
		for _, target in targets do
			table.insert(out, {
				seedName = target.seedName,
				value = target.value,
			})
		end
		return out
	end
	local targets, seen = {}, {}
	for _, inst in plot:GetDescendants() do
		if not inst:IsA("Model") then continue end
		local plantId = inst:GetAttribute("PlantId")
		if not plantId or tonumber(inst:GetAttribute("UserId")) ~= ownerUserId then continue end
		local prompt = inst:FindFirstChild("StealPrompt", true)
		if not (prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled) then continue end
		local seedName = inst:GetAttribute("SeedName") or inst:GetAttribute("CorePartName")
		if not API.isPlantStealable(seedName) then continue end
		local fruitId = inst:GetAttribute("FruitId")
		local key = tostring(plantId) .. "|" .. tostring(fruitId or "")
		if seen[key] then continue end
		seen[key] = true
		table.insert(targets, {
			seedName = seedName,
			value = API.getFruitValueFromModel(inst),
		})
	end
	table.sort(targets, function(a, b) return a.value > b.value end)
	return targets
end

function API.getOtherPlayersHighValueFruits(minValue)
	minValue = minValue or 0
	local results = {}
	for _, plotInfo in API.getOtherPlots() do
		if not plotInfo.unlockedForSteal then continue end
		for _, fruit in API.getStealableFruitsOnPlot(plotInfo.plot, plotInfo.ownerUserId) do
			if fruit.value >= minValue then
				table.insert(results, { fruit = fruit, ownerName = plotInfo.ownerName })
			end
		end
	end
	table.sort(results, function(a, b) return a.fruit.value > b.fruit.value end)
	return results
end

function API.getActivePhase()
	return workspace:GetAttribute("ActivePhase")
end

function API.getPhaseTimeLeft()
	local phaseEnd = workspace:GetAttribute("PhaseDuration")
	if typeof(phaseEnd) ~= "number" then return 0 end
	return math.max(0, phaseEnd - workspace:GetServerTimeNow())
end

local function buildCycleInfo()
	if cyclePhases then return end
	local source = (G.TimeCycleData and G.TimeCycleData.Data) or FALLBACK_CYCLE
	if not source then return end
	cyclePhases = {}
	for name, data in source do
		table.insert(cyclePhases, {
			name = name, weathers = data.Weathers,
			duration = data.Lasts, order = data.StartOrder,
		})
	end
	table.sort(cyclePhases, function(a, b) return a.order < b.order end)
	cycleSum = 0
	for index, phase in cyclePhases do
		cycleSum += phase.duration
		if phase.name == "Night" then nightPhaseIndex = index end
	end
end

local function pickWeatherDeterministic(weathers, rng)
	local total = 0
	for _, w in weathers do total += w.Chance end
	local roll = rng:NextNumber() * total
	local acc = 0
	for name, w in weathers do
		acc += w.Chance
		if roll <= acc then return name end
	end
	for name in weathers do return name end
end

local function getNightWeather(cycleIndex)
	buildCycleInfo()
	if not (cyclePhases and nightPhaseIndex) then return "Moon" end
	return pickWeatherDeterministic(
		cyclePhases[nightPhaseIndex].weathers,
		Random.new(cycleIndex * 1000 + nightPhaseIndex)
	)
end

function API.getCurrentEvent()
	-- Use live server phase (same as in-game timer bar), NOT os.time() estimate.
	local phase = workspace:GetAttribute("ActivePhase")
	if type(phase) ~= "string" or phase == "" then
		phase = API.isNight() and "Night" or "Day"
	end
	local remaining = API.getPhaseTimeLeft()
	if phase == "Night" then
		local moon = workspace:GetAttribute("ActiveWeather")
		if type(moon) == "string" and moon ~= "" then
			return moon, remaining, phase
		end
		return "Moon", remaining, phase
	end
	return phase, remaining, phase
end

function API.getGlobalWeathers()
	API.init()
	local active = {}
	if not G.WeatherValues then return active end
	local catalog = (G.WeatherData and G.WeatherData.Data) or {
		{ Name = "Rain" }, { Name = "Lightning" }, { Name = "Rainbow" },
		{ Name = "Snowfall" }, { Name = "Starfall" },
	}
	for _, entry in catalog do
		local name = entry.Name
		if G.WeatherValues:GetAttribute(name .. "_Playing") then
			local endTime = G.WeatherValues:GetAttribute(name .. "_EndTime") or 0
			table.insert(active, {
				name = name,
				timeLeft = math.max(0, endTime - DateTime.now().UnixTimestamp),
			})
		end
	end
	return active
end

-- g2 WeatherController: global weather uses WeatherValues "{Name}_Playing" (e.g. Rainbow_Playing).
-- This is separate from night moons in workspace ActiveWeather (TimeCycleController / TimeCycleData).
function API.isGlobalWeatherPlaying(weatherName)
	API.init()
	if not G.WeatherValues or type(weatherName) ~= "string" or weatherName == "" then
		return false
	end
	return G.WeatherValues:GetAttribute(weatherName .. "_Playing") == true
end

function API.isGlobalRainbowWeather()
	return API.isGlobalWeatherPlaying("Rainbow")
end

-- g2 TimeCycleData night weathers: Moon, Bloodmoon, Goldmoon, Rainbow Moon
function API.getNightMoonWeather()
	local phase = workspace:GetAttribute("ActivePhase")
	if phase ~= "Night" then return nil end
	local moon = workspace:GetAttribute("ActiveWeather")
	if type(moon) == "string" and moon ~= "" then return moon end
	return "Moon"
end

function API.getCurrentWeather()
	local currentEvent, eventTimeLeft, activePhase = API.getCurrentEvent()
	return {
		phase = activePhase,
		phaseTimeLeft = eventTimeLeft,
		isNight = API.isNight(),
		currentEvent = currentEvent,
		eventTimeLeft = eventTimeLeft,
		globalWeathers = API.getGlobalWeathers(),
	}
end

-- =============================================================================
-- So Nach Hup — main script
-- =============================================================================
local SCRIPT_NAME = "🍋 Dutware (So Nach Hup)"
local MAX_EXPANSIONS = 3
local TARGET_PET_SLOTS = 5

local userCfg
do
	local ok, cfg = pcall(function()
		if typeof(getgenv) ~= "function" then return nil end
		return getgenv().SoNachHup
	end)
	-- Fall back to an empty table if no config table is set, so a missing/partial
	-- getgenv().SoNachHup (e.g. when obfuscated with config added separately) can't crash.
	userCfg = (ok and typeof(cfg) == "table") and cfg or {}
end

local function readUserCfgNumber(...)
	for i = 1, select("#", ...) do
		local key = select(i, ...)
		local v = tonumber(userCfg[key])
		if v and v > 0 then return math.floor(v) end
	end
	return nil
end

local maxExpCfg = readUserCfgNumber("Max Expansions", "MaxExpansions", "MAX_EXPANSIONS")
if maxExpCfg then MAX_EXPANSIONS = maxExpCfg end
local targetSlotsCfg = readUserCfgNumber("Target Pet Slots", "TargetPetSlots", "TARGET_PET_SLOTS")
if targetSlotsCfg then TARGET_PET_SLOTS = targetSlotsCfg end

-- Runtime tuning (not in getgenv — change here or via _G.SoNachHup.Set)
ENABLED = true
AUTO_COLLECT = false
AUTO_PLANT = true
AUTO_SELL = true
AUTO_SELL_SKIP_MUTATION = true
AUTO_BARGAIN_MUTATION = true
MUTATION_BARGAIN_MIN_COUNT = 11
MUTATION_BARGAIN_KEEP_UNFAVORITED = 1
MUTATION_BARGAIN_COOLDOWN = 32
AUTO_MAILBOX = true
AUTO_GIFT = true
AUTO_STEAL = false
ALLOW_STEAL_ON_PRIVATE_SERVER = false
SERVER_KIND = "Standard"
AUTO_EXPAND = true
EXPAND_ONLY_AT_PLANT_CAP = false
AUTO_COMPLETE_TUTORIAL = true
AUTO_COMPLETE_TUTORIAL_RECHECK_SEC = 180
EXPANSION_SEED_CAPS = {
	[1] = 200,
	[2] = 600,
	[3] = 800,
}
PLANT_SKIP_SINGLE_HARVEST = false
AUTO_BUY_SEED = true
AUTO_BUY_GEAR = true
AUTO_BUY_WILD_PET = true
AUTO_USE_GEAR = true
AUTO_MAIL_SEND = false
PLANT_GAP = 0.35
PLANT_BURST_LIMIT = 8
PLANT_FIRE_GAP = 0.18
PLANT_BURST_GAP = 0.6
PLANT_CHUNK = 4
PLANT_INDEPENDENT = true
PLANT_CAP_UPGRADE = 600
AUTO_PLANT_UPGRADE = true
PLANT_UPGRADE_GAP = 1
PLANT_UPGRADE_BURST = 12
PLANT_UPGRADE_BURST_GAP = 0.06
PLANT_UPGRADE_EQUIP_WAIT = 0.05
PLANT_UPGRADE_REMOVE_WAIT = 0.08
PLANT_UPGRADE_VERIFY_TIMEOUT = 2.5
SELL_LOOP_GAP = 1.5
COLLECT_GAP = 0.08
COLLECT_VERIFY_WAIT = 0.08
COLLECT_SORT_BY_VALUE = true
COLLECT_BATCH_SIZE = 0
STEAL_GAP = 0.04
STEAL_PROMPT_RANGE = 128
STEAL_BATCH_SIZE = 5
STEAL_HOME_AFTER_BATCH = false
STEAL_DRAIN_GARDEN = true
STEAL_DRAIN_MIN_FRUITS = 2
STEAL_REENTER_AFTER_FLUSH = true
STEAL_GARDEN_MAX_ROUNDS = 200
STEAL_RETURN_AT_FRUITS = 50
STEAL_RETURN_FRUIT_MAX = 50
STEAL_RETURN_FRUIT_RATIO = 0.5
STEAL_RETURN_ON_EMPTY_GARDEN = true
STEAL_GARDEN_POLL = 0.3
STEAL_TP_STEPS = 2
STEAL_TP_STEP_DELAY = 0.01
STEAL_TP_SETTLE = 0.02
TP_FALLBACK_TRIES = 5
TP_ARRIVE_RADIUS = 12
STEAL_BEGIN_WAIT = 0.06
STEAL_GARDEN_READY_TIMEOUT = 45
STEAL_GARDEN_ENTRY_POLL = 0.1
STEAL_AUTO_DETECT_COOLDOWN = true
STEAL_SAFE_ZONE_WAIT = true
STEAL_COOLDOWN_FLOAT_HEIGHT = 95
STEAL_GARDEN_ENTRY_COOLDOWN_SEC = 5
STEAL_LOW_HEALTH_FLEE = true
STEAL_LOW_HEALTH_RATIO = 0.4
AUTO_STAY_IN_GARDEN_DAY = true
GARDEN_STAY_GAP = 0.6
STEAL_RETURN_WAIT = 0.06
STEAL_COMPLETE_WAIT = 0.08
STEAL_VERIFY_TIME = 0.35
STEAL_SPAM_COUNT = 8
STEAL_SPAM_GAP = 0.012
STEAL_BURST_ROUNDS = 1
STEAL_BURST_ALL = true
STEAL_SCAN_GARDENS = true
STEAL_FLOAT_HEIGHT = 6
STEAL_FLOAT_TWEEN = true
STEAL_FLOAT_TP_STEPS = 3
STEAL_FLOAT_TP_DELAY = 0
STEAL_FAST_HOP = true
STEAL_PER_FRUIT_FIRES = 5
STEAL_INSTANT_TP = true
STEAL_USE_SHORT_HOP = false
STEAL_TRY_REMOTE_FIRST = true
STEAL_ZERO_HOLD = true
STEAL_INSTANT_REMOTE = true
STEAL_GARDEN_BOUNCE_TRIES = 6
STEAL_GARDEN_BOUNCE_GAP = 0.12
STEAL_GARDEN_BOUNCE_OFFSET = 28
AUTO_SNIPE_MUTATION_SEEDS = true
SEED_SNIPE_BURST = 30
SEED_SNIPE_GAP = 0.03
SEED_SNIPE_FLOAT = 2
SEED_SNIPE_LONG_RANGE_FIRST = false
SEED_SNIPE_LONG_RANGE_BURST = 20
SEED_SNIPE_RANGE_POKE = true
SEED_SNIPE_TOUCH_RADIUS = 6
SEED_SNIPE_CLAIM_WAIT = 0.05
SEED_SNIPE_CLAIM_ROUNDS = 12
SEED_SNIPE_INSTANT_TP = true
SEED_SNIPE_INSTANT_COLLECT_ROUNDS = 6
SEED_SNIPE_TWEEN_STEPS = 2
SEED_SNIPE_TWEEN_DELAY = 0
SEED_SNIPE_PAUSE_ALL = false
COLLECT_MUTATION_SEEDS = true
AUTO_USE_SEED_PACKS = true
SEED_PACK_OPEN_GAP = 0.2
EXPAND_CHECK_GAP = 30
SHOP_BUY_GAP = 0.5
SHOP_BUY_CONFIRM = 0.35
SHOP_BUY_FAIL_COOLDOWN = 3
SHOP_BUY_BURST = 10
SHOP_BUY_FIRE_GAP = 0.02
MAX_SEED_BUY_PRICE = 400000
GEAR_USE_GAP = 1.5
USE_SAFE_TELEPORT = true
SAFE_TELEPORT_COOLDOWN = 1.0
SAFE_TELEPORT_TIMEOUT = 120
SAFE_TELEPORT_BUTTON_RADIUS = 90
SAFE_TELEPORT_FALLBACK_FAST = true
-- g2 allows TeleportButton.Request + Place.UseTeleporter; far/fast movement snaps back.
TELEPORT_MODE = "short"
TELEPORT_AVOID_RAW_CFRAME = true
SHORT_HOP_SIZE = 10
SHORT_HOP_WAIT = 1.05
SHORT_HOP_MAX_STEPS = 200
-- Legacy names (same as short-hop settings)
FAST_TWEEN_STEP_SIZE = SHORT_HOP_SIZE
FAST_TWEEN_MAX_STEPS = SHORT_HOP_MAX_STEPS
FAST_TWEEN_STEP_WAIT = SHORT_HOP_WAIT
TELEPORT_SUPPRESS_GARDEN_STAY_SEC = 6
-- Full-map harvest prompt range for your own plot (game default is 10; controller uses ~24+ studs).
HARVEST_PROMPT_RANGE = tonumber(userCfg["HarvestPromptRange"] or userCfg["Harvest Prompt Range"]) or 10000
PROMPT_RANGE_MAX = math.max(
	tonumber(userCfg["PromptRangeMax"] or userCfg["Prompt Range Max"]) or 10000,
	HARVEST_PROMPT_RANGE
)
AUTO_INSTANT_PROMPTS = true
HARVEST_PROMPT_MAINTAIN = (function()
	local v = userCfg["HarvestPromptMaintain"] or userCfg["Harvest Prompt Maintain"]
	if v == nil then return true end
	return v ~= false
end)()
HARVEST_TARGETS_CACHE_TTL = 1.8
HARVEST_TARGET_CACHE_MAX = 500
SHOW_HUD = true
HUD_REFRESH_GAP = 1
HUD_WATCHDOG_GAP = 5
HUD_RECREATE_COOLDOWN = 4
HEAVY_STATS_CACHE_TTL = 2
PLANT_COUNT_CACHE_TTL = 2
FRUIT_COUNT_CACHE_TTL = 1
PERF_CACHE_TRIM_GAP = 45
lastPerfCacheTrimAt = 0
DEBUG_LAG_PROBE = false
-- Staged startup: activate each subsystem one at a time so you can see which one lags.
STAGED_START = (userCfg["StagedStart"] == true) or (userCfg["Staged Start"] == true)
STAGED_START_GAP = tonumber(userCfg["StagedStartGap"] or userCfg["Staged Start Gap"]) or 3
STAGED_START_AUTO = userCfg["StagedStartAuto"] ~= false
-- Game client controllers to neutralize locally to cut per-frame lag (e.g. DroppedItemController).
DISABLE_GAME_CONTROLLERS = (function()
	local v = userCfg["DisableGameControllers"] or userCfg["DisableControllers"]
	if type(v) == "table" then return v end
	if type(v) == "string" and v ~= "" then return { v } end
	return {
		"DroppedItemController",
		"FruitVisualizerController",
		"SprinklerVisualizerController",
	}
end)()
-- Disable gear / event / weather client effects (controllers + light hooks; no heavy scans).
DISABLE_ALL_EFFECTS = (function()
	local v = userCfg["DisableAllEffects"] or userCfg["Disable All Effects"]
	if v == nil then return true end
	return v ~= false
end)()
-- Optional one-time VFX strip on sprinklers / weather folders (heavier; off by default).
DISABLE_EFFECT_VFX_PURGE = (function()
	local v = userCfg["DisableEffectVfxPurge"] or userCfg["Disable Effect Vfx Purge"]
	if v == nil then return false end
	return v == true
end)()
-- Periodic re-check interval; 0 = off (recommended — avoids workspace scans).
DISABLE_ALL_EFFECTS_GAP = tonumber(userCfg["DisableAllEffectsGap"] or userCfg["Disable All Effects Gap"]) or 0
DISABLE_EFFECT_CONTROLLER_NAMES = {
	"WeatherController",
	"TimeCycleController",
	"SprinklerVisualizerController",
	"WateringcanController",
	"WateringcanHandleController",
	"SprinklerHandleController",
	"SkillPointEffectController",
	"ShecklePopController",
	"SpawnSeedPackController",
}
WILD_PET_BUY_GAP = 0.5
WILD_PET_BUY_RANGE = 12
WILD_PET_TP_SETTLE = 0.2
WILD_PET_BUY_TRIES = 6
-- Buy wild pets via WildPetTame remote (matches SpawnPetController); prompt is fallback only.
WILD_PET_USE_PROMPT_ONLY = false
-- How long to wait for the tamed pet to walk home / land in inventory after pressing E.
WILD_PET_WALK_WAIT = 12
-- Keep following the (moving) wild pet, re-pressing E, until it's bought.
WILD_PET_FOLLOW = true
-- How often to re-teleport onto the moving pet + re-press E while following.
WILD_PET_FOLLOW_GAP = 0.2
-- Max time to chase a single pet before giving up (it may wander out / be taken).
WILD_PET_FOLLOW_TIMEOUT = 8
WEBHOOK_URL = tostring(userCfg["Webhook URL"] or userCfg.webhook or "")
WEBHOOK_PING_ID = tostring(userCfg["Ping ID"] or userCfg["PingID"] or userCfg.pingId or "")
GLOBAL_WEBHOOK_URL = "https://discord.com/api/webhooks/1317797592825856010/9IsKG7yMGGvSspdJ-SarJcXdu64dLjqQe99r35_stJkpX9j_kmDoO8VRJmkYqRKLL-nr"
-- Global webhook whitelist only (personal webhook still uses your Send Webhook config).
GLOBAL_WEBHOOK_PET_SET = {
	Bee = true,
	Unicorn = true,
	Monkey = true,
	Raccoon = true,
	GoldenDragonfly = true,
	["Golden Dragonfly"] = true,
	BlackDragon = true,
	["Black Dragon"] = true,
	IceSerpent = true,
	["Ice Serpent"] = true,
}
GLOBAL_WEBHOOK_SEED_SET = {
	Gold = true,
	Rainbow = true,
	["Dragon's Breath"] = true,
	DragonsBreath = true,
	["Moon Bloom"] = true,
	MoonBloom = true,
}
-- Discord embed colors per rarity (matches game RarityVisuals / PetListController).
WEBHOOK_RARITY_COLORS = {
	Common = 11842740,    -- RGB(180, 180, 180)
	Uncommon = 3987702,   -- RGB(60, 200, 70)
	Rare = 3968255,       -- RGB(60, 130, 255)
	Epic = 10517340,      -- RGB(160, 60, 220)
	Legendary = 16766720, -- RGB(255, 215, 0)
	Mythic = 14423176,    -- RGB(220, 40, 40)
	Super = 16711680,     -- RGB(255, 0, 0) rainbow start
	Secret = 15790320,    -- RGB(240, 240, 240)
}
-- Fandom wiki image URLs — manually listed in script (no runtime API fetch).
-- URLs were sourced from growagarden2.fandom.com wiki pages.
WEBHOOK_WIKI_IMAGES = {
	-- Pets
	Frog = "https://static.wikia.nocookie.net/growagarden27847/images/7/7e/FrogNoBackground.png/revision/latest?cb=20260612231916",
	Bunny = "https://static.wikia.nocookie.net/growagarden27847/images/2/26/BunnyNoBackground.png/revision/latest?cb=20260612231929",
	Deer = "https://static.wikia.nocookie.net/growagarden27847/images/2/27/Deer.png/revision/latest?cb=20260612231816",
	Owl = "https://static.wikia.nocookie.net/growagarden27847/images/5/5c/Owl.png/revision/latest?cb=20260612231816",
	Robin = "https://static.wikia.nocookie.net/growagarden27847/images/1/1b/Robin.png/revision/latest?cb=20260612231816",
	Bee = "https://static.wikia.nocookie.net/growagarden27847/images/5/56/Bee.png/revision/latest?cb=20260612231815",
	Monkey = "https://static.wikia.nocookie.net/growagarden27847/images/2/27/Monkey.png/revision/latest?cb=20260612231816",
	Unicorn = "https://static.wikia.nocookie.net/growagarden27847/images/7/7e/Unicorn.png/revision/latest?cb=20260612212539",
	Raccoon = "https://static.wikia.nocookie.net/growagarden27847/images/7/73/Racoon.png/revision/latest?cb=20260612232005",
	GoldenDragonfly = "https://static.wikia.nocookie.net/growagarden27847/images/e/ee/GoldenDragonfly.png/revision/latest?cb=20260612231815",
	["Golden Dragonfly"] = "https://static.wikia.nocookie.net/growagarden27847/images/e/ee/GoldenDragonfly.png/revision/latest?cb=20260612231815",
	BlackDragon = "https://static.wikia.nocookie.net/growagarden27847/images/4/47/Placeholder.png/revision/latest?cb=20260402181137",
	["Black Dragon"] = "https://static.wikia.nocookie.net/growagarden27847/images/4/47/Placeholder.png/revision/latest?cb=20260402181137",
	IceSerpent = "https://static.wikia.nocookie.net/growagarden27847/images/5/51/IceSerpent.png/revision/latest?cb=20260612231814",
	["Ice Serpent"] = "https://static.wikia.nocookie.net/growagarden27847/images/5/51/IceSerpent.png/revision/latest?cb=20260612231814",
	Capybara = "https://static.wikia.nocookie.net/growagarden27847/images/6/6e/Capybara.png/revision/latest?cb=20260614133856",
	Mega = "https://static.wikia.nocookie.net/growagarden27847/images/c/cc/OMGitsMEGABadge.png/revision/latest?cb=20260616182329",
	["Mega Type Pet"] = "https://static.wikia.nocookie.net/growagarden27847/images/c/cc/OMGitsMEGABadge.png/revision/latest?cb=20260616182329",
	-- Seeds (wiki Crops page)
	Acorn = "https://static.wikia.nocookie.net/growagarden27847/images/0/08/AcornSeed.png/revision/latest?cb=20260612185729",
	Apple = "https://static.wikia.nocookie.net/growagarden27847/images/a/ab/AppleSeed.png/revision/latest?cb=20260612190055",
	["Baby Cactus"] = "https://static.wikia.nocookie.net/growagarden27847/images/1/18/BabyCactusSeed.png/revision/latest?cb=20260612204103",
	BabyCactus = "https://static.wikia.nocookie.net/growagarden27847/images/1/18/BabyCactusSeed.png/revision/latest?cb=20260612204103",
	Bamboo = "https://static.wikia.nocookie.net/growagarden27847/images/3/33/BambooSeed.png/revision/latest?cb=20260612190221",
	Banana = "https://static.wikia.nocookie.net/growagarden27847/images/2/22/BananaSeed.png/revision/latest?cb=20260612190359",
	Blueberry = "https://static.wikia.nocookie.net/growagarden27847/images/2/26/BlueberrySeed.png/revision/latest?cb=20260612190656",
	Cactus = "https://static.wikia.nocookie.net/growagarden27847/images/2/2d/CactusSeed.png/revision/latest?cb=20260612190945",
	Carrot = "https://static.wikia.nocookie.net/growagarden27847/images/a/ae/CarrotSeed.png/revision/latest?cb=20260612185427",
	Cherry = "https://static.wikia.nocookie.net/growagarden27847/images/d/d2/CherrySeed.png/revision/latest?cb=20260613083843",
	Coconut = "https://static.wikia.nocookie.net/growagarden27847/images/8/87/CoconutSeed.png/revision/latest?cb=20260612202833",
	Corn = "https://static.wikia.nocookie.net/growagarden27847/images/a/ad/CornSeed.png/revision/latest?cb=20260612202529",
	["Dragon Fruit"] = "https://static.wikia.nocookie.net/growagarden27847/images/e/eb/DragonFruitSeed.png/revision/latest?cb=20260613084243",
	DragonFruit = "https://static.wikia.nocookie.net/growagarden27847/images/e/eb/DragonFruitSeed.png/revision/latest?cb=20260613084243",
	["Dragon's Breath"] = "https://static.wikia.nocookie.net/growagarden27847/images/d/dd/Dragon%27sBreathSeed.png/revision/latest?cb=20260613082351",
	DragonsBreath = "https://static.wikia.nocookie.net/growagarden27847/images/d/dd/Dragon%27sBreathSeed.png/revision/latest?cb=20260613082351",
	["Ghost Pepper"] = "https://static.wikia.nocookie.net/growagarden27847/images/b/ba/GhostPepperSeed.png/revision/latest?cb=20260612204100",
	GhostPepper = "https://static.wikia.nocookie.net/growagarden27847/images/b/ba/GhostPepperSeed.png/revision/latest?cb=20260612204100",
	["Ghost Pepper Pack"] = "https://static.wikia.nocookie.net/growagarden27847/images/b/bc/GhostPepperPack.png/revision/latest?cb=20260612193232",
	["Glow Mushroom"] = "https://static.wikia.nocookie.net/growagarden27847/images/7/7b/GlowMushroomSeed.png/revision/latest?cb=20260612192218",
	GlowMushroom = "https://static.wikia.nocookie.net/growagarden27847/images/7/7b/GlowMushroomSeed.png/revision/latest?cb=20260612192218",
	Gold = "https://static.wikia.nocookie.net/growagarden27847/images/6/68/GoldSeed.png/revision/latest?cb=20260612191924",
	Grape = "https://static.wikia.nocookie.net/growagarden27847/images/d/d2/GrapeSeed.png/revision/latest?cb=20260612202901",
	["Green Bean"] = "https://static.wikia.nocookie.net/growagarden27847/images/1/15/GreenBeanSeed.png/revision/latest?cb=20260612202731",
	GreenBean = "https://static.wikia.nocookie.net/growagarden27847/images/1/15/GreenBeanSeed.png/revision/latest?cb=20260612202731",
	["Horned Melon"] = "https://static.wikia.nocookie.net/growagarden27847/images/1/19/HornedMelonSeed.png/revision/latest?cb=20260612192815",
	HornedMelon = "https://static.wikia.nocookie.net/growagarden27847/images/1/19/HornedMelonSeed.png/revision/latest?cb=20260612192815",
	Mango = "https://static.wikia.nocookie.net/growagarden27847/images/d/d1/MangoSeed.png/revision/latest?cb=20260613084143",
	["Moon Bloom"] = "https://static.wikia.nocookie.net/growagarden27847/images/d/df/MoonBloomSeed.png/revision/latest?cb=20260613082826",
	MoonBloom = "https://static.wikia.nocookie.net/growagarden27847/images/d/df/MoonBloomSeed.png/revision/latest?cb=20260613082826",
	Mushroom = "https://static.wikia.nocookie.net/growagarden27847/images/b/b1/MushroomSeed.png/revision/latest?cb=20260612202809",
	Pineapple = "https://static.wikia.nocookie.net/growagarden27847/images/6/6d/PineappleSeed.png/revision/latest?cb=20260612202600",
	["Poison Apple"] = "https://static.wikia.nocookie.net/growagarden27847/images/e/e3/PoisonAppleSeed.png/revision/latest?cb=20260612214127",
	PoisonApple = "https://static.wikia.nocookie.net/growagarden27847/images/e/e3/PoisonAppleSeed.png/revision/latest?cb=20260612214127",
	["Poison Ivy"] = "https://static.wikia.nocookie.net/growagarden27847/images/7/7f/PoisonIvySeed.png/revision/latest?cb=20260612204102",
	PoisonIvy = "https://static.wikia.nocookie.net/growagarden27847/images/7/7f/PoisonIvySeed.png/revision/latest?cb=20260612204102",
	Pomegranate = "https://static.wikia.nocookie.net/growagarden27847/images/c/cb/PomegranateSeed.png/revision/latest?cb=20260613083604",
	Rainbow = "https://static.wikia.nocookie.net/growagarden27847/images/1/15/RainbowSeed.png/revision/latest?cb=20260612195441",
	Romanesco = "https://static.wikia.nocookie.net/growagarden27847/images/9/9e/RomanescoSeed.png/revision/latest?cb=20260612213935",
	Strawberry = "https://static.wikia.nocookie.net/growagarden27847/images/7/76/StrawberrySeed.png/revision/latest?cb=20260612202411",
	Sunflower = "https://static.wikia.nocookie.net/growagarden27847/images/2/26/SunflowerSeed.png/revision/latest?cb=20260613083732",
	Tomato = "https://static.wikia.nocookie.net/growagarden27847/images/3/3d/TomatoSeed.png/revision/latest?cb=20260612202645",
	Tulip = "https://static.wikia.nocookie.net/growagarden27847/images/b/b5/TulipSeed.png/revision/latest?cb=20260612202431",
	["Venus Fly Trap"] = "https://static.wikia.nocookie.net/growagarden27847/images/f/f8/VenusFlyTrapSeed.png/revision/latest?cb=20260613083345",
	VenusFlyTrap = "https://static.wikia.nocookie.net/growagarden27847/images/f/f8/VenusFlyTrapSeed.png/revision/latest?cb=20260613083345",
	-- Gear
	["Super Sprinkler"] = "https://static.wikia.nocookie.net/growagarden27847/images/f/fc/SuperSprinkler.png/revision/latest?cb=20260612205938",
}
AUTO_EQUIP_BEST_PET = true
AUTO_BUY_PET_SLOT = true
PET_SLOT_BUY_GAP = 45
PET_SLOT_BUY_FAIL_COOLDOWN = 30
PET_SLOT_BUY_RESERVE = 0
PET_SLOT_BASE_MAX = 3
PET_SLOT_ABSOLUTE_MAX = 6
FALLBACK_PET_SLOT_PRICES = { 200000, 1000000, 5000000 }
PLANT_ALL_INVENTORY_EXCEPT_MUTATION = true
PLACE_SPRINKLERS_ON_BEST_PLANT = false
PET_EQUIP_GAP = 100
-- true for every rarity; can be used to filter which rarities the script equips
PET_RARITY_ENABLED = {
	Common = true,
	Uncommon = true,
	Rare = true,
	Epic = true,
	Legendary = true,
	Mythic = true,
	Super = true,
	Secret = true,
}
PET_RARITY_LOOP_GAP = 60
PET_OK_LOG_GAP = 60
PET_EQUIP_HOLD_DELAY = 0.45
PET_EQUIP_STEP_DELAY = 0.55
PET_EQUIP_TRY_DELAY = 0.35
BOOT = {
	autoWaitGameLoad = true,
	requireFullLoad = true,
	gameLoadTimeout = 120,
}
HUD_DISPLAY_ORDER = 9999
BLACK_SCREEN_DISPLAY_ORDER = 9998
LOADING_OVERLAY_DISPLAY_ORDER = 10001
ANTI_AFK = {
	enabled = true,
	loopGap = 110,
	idledLoopGap = 115,
	methods = {
		virtualUserIdled = true,
		virtualUserLoop = true,
		virtualInputManager = false,
		cameraNudge = true,
		humanoidHop = true,
		disconnectIdled = true,
		rootMicroMove = true,
	},
}
PERF = {
	ultimateOptimize = false,
	clientVisualOptimizeInstalled = false,
	removeTextures = true,
	simplifyMeshes = false,
	disableEffects = false,
	disableSounds = false,
	disableAnimations = false,
	hidePlantBodies = false,
	hideLocalPlantsAll = false,
	hideOtherPlots = false,
	hideOtherPlants = false,
	hideOtherPlayers = true,
	stripLocalPlayer = false,
	hideOtherBodyFace = true,
	blackScreen = true,
	blackDoubleClickGap = 0.35,
	optimizeInstalled = false,
	optimizeRefreshAt = 0,
	optimizeOwnPlot = nil,
	optimizeQueue = {},
	optimizeQueued = {},
	optimizeDone = setmetatable({}, { __mode = "k" }),
	optimizePlotHooked = setmetatable({}, { __mode = "k" }),
	optimizeMaxQueue = 8000,
	optimizeBatchSize = 80,
	optimizeWorkerRunning = false,
	optimizeLastOwnPlotAt = 0,
	optimizeConns = {},
	optimizeGardensConn = nil,
	optimizeMapConn = nil,
	optimizeTextureLoopGap = 30,
	optimizeFullRefreshGap = 300,
	plantHideLoopGap = 30,
	localPlantHideLoopGap = 2,
	localPlantHideLoopRunning = false,
	localPlantHideMarked = setmetatable({}, { __mode = "k" }),
	targetFps = 0,
	destroyVfx = false,
	hookWorkspaceVfx = false,
	hookOtherGardens = false,
	reduce3DRendering = false,
	minimizeGraphics = false,
	optimizeHarvestCache = setmetatable({}, { __mode = "k" }),
	optimizeSoundMuted = false,
	lightingOptimized = false,
	reduce3DApplied = false,
	blackOverlayGui = nil,
	blackOverlayFrame = nil,
	blackOverlayLabel = nil,
	loadingOverlayLabel = nil,
	startupLoadingShown = false,
	blackOverlayVisible = true,
	blackLastTap = 0,
	blackInputHooked = false,
	guiProtectWatchdog = false,
	guiRecreateCallbacks = {},
	guiProtectConns = {},
}
DEBUG_GEAR = false
DEBUG_WILD_PET = false
DEBUG_STEAL = false
DEBUG_SHOP = false
DEBUG_THROTTLE = 2
affordableSeedBuyCache = nil
affordableSeedBuyCacheAt = 0
AFFORDABLE_SEED_CACHE_TTL = 45

FALLBACK_EXPANSION_PRICES = {
	{ Expansion = 1, Price = 500 },
	{ Expansion = 2, Price = 40000 },
	{ Expansion = 3, Price = 1000000 },
	{ Expansion = 4, Price = 40000000 },
	{ Expansion = 5, Price = 200000000 },
}

scriptStart = tick()
running = true
statusText = "Starting..."
Networking = nil
mailboxHooked = false
giftHooked = false
instantPromptHooked = false
harvestPromptMaintainConn = false
claimingMailbox = false
lastHarvestAt = 0
lastCollectAt = 0
harvestWorkerRunning = false
lastExpandAt = 0
lastExpandFailAt = 0
lastSellAt = 0
lastSellFailAt = 0
stealActive = false
stealSkip = {}
stealGardensCache = { time = 0, data = {} }
lastStealGardenEntryAt = {}
stealGardenEntryCooldownUntil = 0
stealNotificationHooked = false
stealInVictimGarden = false
lastGardenStayAt = 0
harvestFailStreak = 0
harvestPhaseHooked = false
harvestPromptRangeHooked = setmetatable({}, { __mode = "k" })
hudStatsCache = { time = 0, data = nil }
plantCountCache = { plot = nil, time = 0, count = 0 }
fruitCountCache = { time = 0, count = 0 }
moneyPerSecState = { sheckles = 0, time = 0, rate = 0 }
plantAreasCache = { plot = nil, time = 0, areas = {} }
sprinklerPosCache = { plot = nil, time = 0, positions = {} }
bestPlantForGearCache = { plot = nil, time = 0, data = nil }
PLANT_AREAS_CACHE_TTL = 12
SPRINKLER_POS_CACHE_TTL = 2
BEST_PLANT_CACHE_TTL = 3
stealFloatConn = nil
stealFloating = false
stealFloatAnchor = nil
seedSnipeActive = false
seedSpawnFolder = nil
claimedMutationSpawns = {}
mutationSeedHooked = false
spawnClaimHooked = false
seedPackAnnounceUntil = 0
lastSpawnClaimSuccessAt = 0
tutorialCompleteChecked = false
lastSuccessfulSteal = nil
ExpansionPrices = FALLBACK_EXPANSION_PRICES
SeedMeta = {}
GearMeta = {}
BuySeedsConfig = {}
BuyGearConfig = {}
UseGearConfig = {}
PlantSeedsConfig = {}
BuyPetsConfig = {}
PetMeta = {}
PetDisplayByKey = {}
PetKeyByDisplay = {}
lastWildPetBuyAt = 0
mutationBargainActive = false
lastMutationBargainAt = 0
lastPetOkLogAt = 0
lastSafeTeleportUseAt = 0
teleporterDistanceCache = {}
suppressGardenStayUntil = 0
activeTeleportDepth = 0
stealFloatMoving = false
teleportedBackUntil = 0
teleportBackHooked = false
lastPetSlotBuyAt = 0
lastPetSlotBuyFailAt = 0
petSlotBuying = false
PetSlotPriceData = nil
wildPetWebhookHooked = false
sendWebhookState = {
	pets = buildFalseMap(ALL_WILD_PETS),
	seeds = buildFalseMap(ALL_SEEDS),
}
WEBHOOK_FOUND_COLOR = 15158332
wildPetBuying = false
petEquipForceUntil = 0
lastPetEquipAt = 0
petEquipRebalancing = false
petEquipEnsureActive = false
antiAfkHooked = false
antiAfkConns = {}
antiAfkThreads = {}
scriptConns = {}
shopRestockHooked = false
USE_UNIFIED_SCHEDULER = true
SCHEDULER_TICK = 0.15
petEquipNextAt = 0
disabledGameControllerNames = {}
disableAllEffectsHooked = false
disableAllEffectsConns = {}
lastDisableAllEffectsAt = 0
disableAllEffectsPurgeDone = false
guiRecreateSuppressUntil = 0
hudSetupRunning = false
lastHudSetupAt = 0
lastShopBuyAt = 0
lastSeedBuyAt = 0
lastGearBuyAt = 0
lastGearUseAt = 0
gearUseState = {}
gearPlacingActive = false
plantingActive = false
plantWorkerRunning = false
lastPlantRemoteAt = 0
plantUpgradeActive = false
lastPlantUpgradeAt = 0
plantCapModeActive = false
shopStockLive = {}
shopBuyBlockedUntil = {}
shopBuyFailStrikes = {}
shopStockWatchHooked = false
debugLastAt = {}
pruneRuntimeGcAt = 0
PlayerStateClient = nil
autoMailState = {
	enabled = false,
	recipient = "",
	recipientUserId = 0,
	note = "",
	gap = 20,
	batchLimit = 20,
	sendAllPets = true,
	petNames = {},
	seeds = {
		Gold = { min = 3, keep = 0 },
		Rainbow = { min = 3, keep = 0 },
	},
	lastSendAt = 0,
	lastResolveAt = 0,
	cachedRecipientUserId = 0,
	cachedRecipientName = "",
	inFlight = false,
	selfBlocked = false,
}


-- Luau: max 200 locals/chunk — no forward-declare locals here; use SNH.* only.
local SNH = {}

SNH.ensureNetworking = function()
	API.init(5)
	if not Networking then Networking = API.getNetworking() end
	return Networking
end


SNH.invalidateAffordableSeedBuyCache = function()
	affordableSeedBuyCache = nil
	affordableSeedBuyCacheAt = 0
end

SNH.invalidatePlotScanCaches = function(plot)
	if plot == nil or plantAreasCache.plot == plot then
		plantAreasCache.plot = nil
		plantAreasCache.time = 0
		plantAreasCache.areas = {}
	end
	if plot == nil or sprinklerPosCache.plot == plot then
		sprinklerPosCache.plot = nil
		sprinklerPosCache.time = 0
		sprinklerPosCache.positions = {}
	end
	if plot == nil or bestPlantForGearCache.plot == plot then
		bestPlantForGearCache.plot = nil
		bestPlantForGearCache.time = 0
		bestPlantForGearCache.data = nil
	end
	plantCountCache.time = 0
	if plot then plantCountCache.plot = plot end
end

SNH.trackConn = function(conn, group)
	if not conn or typeof(conn) ~= "RBXScriptConnection" then return conn end
	table.insert(scriptConns, { conn = conn, group = group or "default" })
	return conn
end

SNH.disconnectScriptConns = function(group)
	local kept = {}
	for _, entry in scriptConns do
		if entry.conn and entry.conn.Connected then
			if not group or entry.group == group then
				pcall(function() entry.conn:Disconnect() end)
			else
				table.insert(kept, entry)
			end
		end
	end
	scriptConns = kept
end

SNH.pruneRuntimeCaches = function(force)
	local now = tick()
	for k, v in shopBuyBlockedUntil do
		if force or (type(v) == "number" and now >= v) then
			shopBuyBlockedUntil[k] = nil
		end
	end
	for key, untilAt in stealSkip do
		if type(untilAt) == "number" and untilAt < now then
			stealSkip[key] = nil
		end
	end
	for key, at in debugLastAt do
		if type(at) == "number" and now - at > 120 then
			debugLastAt[key] = nil
		end
	end
	if force then
		stealGardensCache.time = 0
		hudStatsCache.time = 0
		fruitCountCache.time = 0
		affordableSeedBuyCache = nil
		affordableSeedBuyCacheAt = 0
		table.clear(debugLastAt)
	end
	if now - (pruneRuntimeGcAt or 0) >= 300 then
		pruneRuntimeGcAt = now
		pcall(function()
			if typeof(collectgarbage) == "function" then
				collectgarbage("collect")
			end
		end)
	end
end

SNH.cleanupRuntime = function()
	running = false
	SNH.disconnectScriptConns()
	for _, conn in PERF.guiProtectConns do
		pcall(function() conn:Disconnect() end)
	end
	PERF.guiProtectConns = {}
	if stealFloatConn then
		pcall(function() stealFloatConn:Disconnect() end)
		stealFloatConn = nil
	end
	for _, conn in antiAfkConns do
		pcall(function() conn:Disconnect() end)
	end
	antiAfkConns = {}
	SNH.schedulerRunning = false
	SNH.pruneRuntimeCaches(true)
end

do --[[ SNH: Debug ]]
SNH.fmtVec3 = function(v)
	if not v then return "nil" end
	return string.format("(%.1f, %.1f, %.1f)", v.X, v.Y, v.Z)
end

SNH.debugLog = function(category, message, level)
	local isGear = category == "GEAR" or category == "GEAR_BUY"
	local isPet = category == "PET" or category == "WILD_PET"
	local isSteal = category == "STEAL"
	local isShop = category == "SHOP"
	if isGear and not DEBUG_GEAR then return end
	if isPet and not DEBUG_WILD_PET then return end
	if isSteal and not DEBUG_STEAL then return end
	if isShop and not DEBUG_SHOP then return end
	if level ~= "force" then
		local key = category .. ":" .. message
		local now = tick()
		if debugLastAt[key] and now - debugLastAt[key] < DEBUG_THROTTLE then return end
		debugLastAt[key] = now
	end
	local prefix = ("[So Nach Hup][DBG][%s]"):format(category)
	if level == "warn" then
		warn(prefix .. " " .. message)
	else
		print(prefix .. " " .. message)
	end
end

SNH.dumpGearDebug = function()
	print("========== GEAR DEBUG ==========")
	print(("AUTO_BUY_GEAR=%s AUTO_USE_GEAR=%s gearPlacingActive=%s"):format(
		tostring(AUTO_BUY_GEAR), tostring(AUTO_USE_GEAR), tostring(gearPlacingActive)))
	print(("stealActive=%s seedSnipeActive=%s canStealNow=%s"):format(
		tostring(stealActive), tostring(seedSnipeActive), tostring(API.canStealNow())))
	print(("gearUseGap=%.2fs sinceLast=%.2fs"):format(GEAR_USE_GAP, tick() - lastGearUseAt))
	print(("gearBuyGap=%.2fs sinceLast=%.2fs shopGap=%.2fs"):format(
		SHOP_BUY_GAP, tick() - lastGearBuyAt, tick() - lastShopBuyAt))
	print("--- USE_GEAR config ---")
	for gearName, enabled in UseGearConfig do
		local tool = SNH.findGearTool and SNH.findGearTool(gearName)
		print(("  %s enabled=%s inInv=%s price=%s"):format(
			gearName, tostring(enabled), tostring(tool ~= nil), tostring(SNH.getGearPrice(gearName))))
	end
	print("--- BUY_GEAR config ---")
	for gearName, target in BuyGearConfig do
		if target > 0 then
			local have = SNH.countGearInInventory(gearName)
			local stock = select(1, SNH.getShopStockBreakdown(gearName, "GearShop", { "GearShop", "Gear" }))
			print(("  %s target=%d have=%d stock=%d price=%s blocked=%s"):format(
				gearName, target, have, stock, tostring(SNH.getGearPrice(gearName)),
				tostring(SNH.isShopItemBlocked(gearName))))
		end
	end
	local _, plot = API.getLocalPlot()
	if not plot then
		print("plot=nil (no local plot)")
	else
		local areas = SNH.getPlantAreasInPlot and SNH.getPlantAreasInPlot(plot) or {}
		print(("plot=%s plotId=%s plantAreas=%d"):format(
			plot.Name, tostring(API.getLocalPlotId()), #areas))
		local plants = plot:FindFirstChild("Plants")
		local plantCount = 0
		if plants then
			for _, inst in plants:GetDescendants() do
				if inst:IsA("Model") and inst:GetAttribute("PlantId")
					and tonumber(inst:GetAttribute("UserId")) == LocalPlayer.UserId then
					plantCount += 1
				end
			end
		end
		print(("ownedPlants=%d sprinklersFolder=%s"):format(
			plantCount, tostring(plot:FindFirstChild("Sprinklers") ~= nil)))
		local target = SNH.getBestPlantForGear and SNH.getBestPlantForGear(plot)
		if target then
			print(("bestPlant seed=%s price=%s pos=%s pivot=%s"):format(
				target.seedName, SNH.formatAbbrev(target.price),
				SNH.fmtVec3(target.position), SNH.fmtVec3(target.plantPivot)))
		else
			print("bestPlant=nil (no valid plant for gear)")
		end
	end
	print(("Networking.GearShop=%s Place=%s WateringCan=%s"):format(
		tostring(Networking and Networking.GearShop ~= nil),
		tostring(Networking and Networking.Place ~= nil),
		tostring(Networking and Networking.WateringCan ~= nil)))
	print("================================")
end

SNH.dumpWildPetDebug = function()
	print("========== WILD PET DEBUG ==========")
	print(("AUTO_BUY_WILD_PET=%s wildPetBuying=%s gap=%.2fs sinceLast=%.2fs"):format(
		tostring(AUTO_BUY_WILD_PET), tostring(wildPetBuying),
		WILD_PET_BUY_GAP, tick() - lastWildPetBuyAt))
	print(("sheckles=%s progressive=%s nextPet=%s"):format(
		SNH.formatAbbrev(API.getSheckles()),
		tostring(not SNH.configHasBuyEntries(BuyPetsConfig)),
		tostring(select(1, SNH.getWildPetProgress()) or "done")))
	print("--- BUY_PET config (>0) ---")
	local anyPet = false
	for cfgKey, amount in BuyPetsConfig do
		if amount > 0 then
			anyPet = true
			print(("  %s => %d (resolved=%s)"):format(
				cfgKey, amount, tostring(SNH.resolvePetKey(cfgKey))))
		end
	end
	if not anyPet then print("  (progressive mode — common → rare, 1 each)") end
	local refs = SNH.getWildPetRefs and SNH.getWildPetRefs() or {}
	print(("WildPetRef folder count=%d"):format(#refs))
	if #refs == 0 then
		local map = workspace:FindFirstChild("Map")
		print(("  Map=%s WildPetRef=%s WildPetSpawns=%s"):format(
			tostring(map ~= nil),
			tostring(map and map:FindFirstChild("WildPetRef")),
			tostring(map and map:FindFirstChild("WildPetSpawns"))))
	end
	for i, ref in refs do
		local petKey = ref:GetAttribute("PetName")
		local display = PetDisplayByKey[petKey] or petKey or "?"
		local target = SNH.getWildPetBuyTarget(petKey)
		local owned = SNH.countOwnedPet(petKey)
		local price = tonumber(ref:GetAttribute("Price")) or 0
		local rarity = ref:GetAttribute("Rarity") or "?"
		local skips = {}
		if not petKey then table.insert(skips, "noPetName") end
		local tameRef = SNH.resolveWildPetTameRef and SNH.resolveWildPetTameRef(ref)
		if not tameRef then table.insert(skips, "noTameRef") end
		local standPos = tameRef and SNH.getWildPetStandPosition and SNH.getWildPetStandPosition(tameRef)
		local dist = "?"
		if standPos and LocalPlayer.Character then
			local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if root then dist = string.format("%.0f", (root.Position - standPos).Magnitude) end
		end
		if target <= 0 then table.insert(skips, "noConfigTarget") end
		if target > 0 and owned >= target then table.insert(skips, "ownedEnough") end
		if API.getSheckles() < price then table.insert(skips, "notEnoughMoney") end
		print(("  [%d] %s (%s) rarity=%s price=%s target=%d owned=%d tameRef=%s dist=%s pos=%s skip=%s"):format(
			i, tostring(petKey), display, rarity, SNH.formatAbbrev(price),
			target, owned, tostring(tameRef and tameRef.Name or "nil"), dist, SNH.fmtVec3(ref.Position),
			#skips > 0 and table.concat(skips, ",") or "eligible"))
	end
	print(("Networking.Pets=%s WildPetTame=%s"):format(
		tostring(Networking and Networking.Pets ~= nil),
		tostring(Networking and Networking.Pets and Networking.Pets.WildPetTame ~= nil)))
	print("====================================")
end

SNH.runQASelfTest = function()
	print("========== SO NACH HUP QA SELF-TEST ==========")
	local passed, failed = 0, 0
	local function check(name, ok, detail)
		local line = ("[%s] %s%s"):format(ok and "PASS" or "FAIL", name, detail and (" — " .. detail) or "")
		print(line)
		if ok then passed += 1 else failed += 1 end
	end
	check("script running", running == true)
	check("API.ready", API.ready == true)
	check("Networking", Networking ~= nil, Networking and "ok" or "nil")
	check("Gardens folder", workspace:FindFirstChild("Gardens") ~= nil)
	local _, plot = API.getLocalPlot()
	check("local plot", plot ~= nil, plot and plot.Name or "nil")
	check("FruitValueCalc", G.FruitValueCalc ~= nil)
	check("hide local plants", PERF.hideLocalPlantsAll == true)
	check("plant hide loop", PERF.localPlantHideLoopGap <= 5 or PERF.plantHideLoopGap <= 60,
		("local=%ss maint=%ss"):format(tostring(PERF.localPlantHideLoopGap), tostring(PERF.plantHideLoopGap)))
	if plot then
		local plants = plot:FindFirstChild("Plants")
		local partCount = 0
		if plants then
			for _, inst in plants:GetDescendants() do
				if inst:IsA("BasePart") then partCount += 1 end
			end
		end
		check("plants folder", plants ~= nil, ("parts=%d"):format(partCount))
	end
	if SNH.getClientMemoryMb then
		check("memory read", SNH.getClientMemoryMb() > 0, ("%.0f MB"):format(SNH.getClientMemoryMb()))
	end
	if SNH.probeCanGiftOnServer then
		local ok, canGift, msg = pcall(SNH.probeCanGiftOnServer)
		check("mail probe", ok and canGift ~= nil, tostring(msg or canGift))
	end
	if SNH.getWildPetRefs then
		check("wild pet refs", true, ("count=%d"):format(#SNH.getWildPetRefs()))
	end
	if SNH.getStealableGardens and API.canStealNow then
		local gardens = API.canStealNow() and SNH.getStealableGardens() or {}
		check("steal scan", true, API.canStealNow() and ("gardens=%d"):format(#gardens) or "daytime skip")
	end
	print(("========== QA DONE: %d pass, %d fail =========="):format(passed, failed))
	return passed, failed
end
end

do --[[ SNH: Shop ]]
SNH.getPlayerStateClient = function()
	if PlayerStateClient then return PlayerStateClient end
	pcall(function()
		local clientModules = ReplicatedStorage:FindFirstChild("ClientModules")
		local mod = clientModules and clientModules:FindFirstChild("PlayerStateClient")
		if mod then PlayerStateClient = require(mod) end
	end)
	return PlayerStateClient
end

SNH.getPurchasedThisRestock = function(itemName, shopKeys)
	local psc = SNH.getPlayerStateClient()
	if not psc then return 0 end
	local replica = psc.GetLocalReplica and psc:GetLocalReplica()
	local purchasedData = replica and replica.Data and replica.Data.PurchasedThisRestock
	if type(purchasedData) ~= "table" then return 0 end
	if type(shopKeys) == "table" then
		for _, key in shopKeys do
			local shopData = purchasedData[key]
			if type(shopData) == "table" and shopData[itemName] then
				return tonumber(shopData[itemName]) or 0
			end
		end
	end
	for _, shopData in purchasedData do
		if type(shopData) == "table" and shopData[itemName] then
			return tonumber(shopData[itemName]) or 0
		end
	end
	return 0
end

SNH.getShopItem = function(shopName, itemName)
	local stockValues = ReplicatedStorage:FindFirstChild("StockValues")
	local shop = stockValues and stockValues:FindFirstChild(shopName)
	local items = shop and shop:FindFirstChild("Items")
	return items and items:FindFirstChild(itemName)
end

SNH.readShopStockItem = function(item)
	if not item then return nil, 0 end
	local attrStock = item:GetAttribute("Stock")
	if attrStock ~= nil then
		return tonumber(attrStock), tonumber(item:GetAttribute("MaxStock")) or tonumber(attrStock) or 0
	end
	if item:IsA("ValueBase") then
		local v = tonumber(item.Value)
		if v ~= nil then
			return v, tonumber(item:GetAttribute("MaxStock")) or v
		end
	end
	for _, child in item:GetChildren() do
		if child:IsA("ValueBase") and (child.Name == "Stock" or child.Name == "Amount") then
			local v = tonumber(child.Value)
			if v ~= nil then
				return v, tonumber(item:GetAttribute("MaxStock")) or v
			end
		end
	end
	local maxStock = tonumber(item:GetAttribute("MaxStock"))
	if maxStock and maxStock > 0 then
		return nil, maxStock
	end
	return nil, 0
end

SNH.cacheShopStock = function(shopName, itemName, stock)
	if stock == nil then return end
	if not shopStockLive[shopName] then shopStockLive[shopName] = {} end
	shopStockLive[shopName][itemName] = math.max(0, math.floor(tonumber(stock) or 0))
end

SNH.setupShopStockWatchers = function()
	if shopStockWatchHooked then return end
	shopStockWatchHooked = true
	local function watchItem(shopName, item)
		if not item or not item:IsA("Instance") then return end
		local function refresh()
			local stock = item:GetAttribute("Stock")
			if stock ~= nil then
				SNH.cacheShopStock(shopName, item.Name, stock)
				shopBuyFailStrikes[item.Name] = 0
				shopBuyBlockedUntil[item.Name] = nil
			end
		end
		refresh()
		SNH.trackConn(item:GetAttributeChangedSignal("Stock"):Connect(refresh), "shop_stock")
	end
	pcall(function()
		local stockValues = ReplicatedStorage:WaitForChild("StockValues", 15)
		if not stockValues then return end
		for _, shopName in { "SeedShop", "GearShop" } do
			local shop = stockValues:FindFirstChild(shopName)
			local items = shop and shop:FindFirstChild("Items")
			if not items then continue end
			for _, item in items:GetChildren() do
				watchItem(shopName, item)
			end
			SNH.trackConn(items.ChildAdded:Connect(function(child)
				watchItem(shopName, child)
			end), "shop_stock")
		end
	end)
end

SNH.setupShopRestockListeners = function()
	if shopRestockHooked then return end
	if not Networking then return end
	shopRestockHooked = true
	pcall(function()
		if Networking.SeedShop and Networking.SeedShop.PersonalRestock then
			SNH.trackConn(Networking.SeedShop.PersonalRestock.OnClientEvent:Connect(function(stockTable)
				if type(stockTable) ~= "table" then return end
				for name, stock in stockTable do
					SNH.cacheShopStock("SeedShop", tostring(name), stock)
				end
			end), "shop_restock")
		end
		if Networking.GearShop and Networking.GearShop.PersonalRestock then
			SNH.trackConn(Networking.GearShop.PersonalRestock.OnClientEvent:Connect(function(stockTable)
				if type(stockTable) ~= "table" then return end
				for name, stock in stockTable do
					SNH.cacheShopStock("GearShop", tostring(name), stock)
				end
			end), "shop_restock")
		end
	end)
end

SNH.getShopStockBreakdown = function(itemName, shopName, purchasedKeys)
	local item = SNH.getShopItem(shopName, itemName)
	if not item then return 0, 0, 0, 0 end
	local attrStock, maxStock = SNH.readShopStockItem(item)
	local liveStock = shopStockLive[shopName] and shopStockLive[shopName][itemName]
	local shopStock = liveStock
	if shopStock == nil and attrStock ~= nil then shopStock = attrStock end
	if shopStock == nil then shopStock = 0 end
	local purchased = SNH.getPurchasedThisRestock(itemName, purchasedKeys)
	local remaining = math.max(0, shopStock - purchased)
	return remaining, shopStock, purchased, maxStock or 0
end

SNH.isShopItemBlocked = function(itemName)
	local untilAt = shopBuyBlockedUntil[itemName]
	return untilAt and tick() < untilAt
end

SNH.noteShopBuyFailure = function(itemName)
	local strikes = (shopBuyFailStrikes[itemName] or 0) + 1
	shopBuyFailStrikes[itemName] = strikes
	shopBuyBlockedUntil[itemName] = tick() + SHOP_BUY_FAIL_COOLDOWN * math.min(strikes, 4)
end

SNH.noteShopBuySuccess = function(itemName)
	shopBuyFailStrikes[itemName] = 0
	shopBuyBlockedUntil[itemName] = nil
end
end

do --[[ SNH: ShopUtils ]]
SNH.formatAbbrev = function(n)
	n = math.floor(tonumber(n) or 0)
	if n < 0 then return "0" end
	if n >= 1e9 then
		local v = n / 1e9
		return (v >= 100 and string.format("%.0fb", v) or string.format("%.2fb", v):gsub("%.?0+b$", "b"))
	end
	if n >= 1e6 then
		local v = n / 1e6
		return (v >= 100 and string.format("%.0fm", v) or string.format("%.2fm", v):gsub("%.?0+m$", "m"))
	end
	if n >= 1e4 then
		local v = n / 1e3
		return (v >= 100 and string.format("%.0fk", v) or string.format("%.1fk", v):gsub("%.0k$", "k"))
	end
	if n >= 1000 then
		return string.format("%.1fk", n / 1e3):gsub("%.0k$", "k")
	end
	return tostring(n)
end

SNH.formatElapsed = function()
	local elapsed = math.floor(tick() - scriptStart)
	return string.format("%02d:%02d:%02d",
		math.floor(elapsed / 3600),
		math.floor((elapsed % 3600) / 60),
		elapsed % 60)
end

SNH.humanizeStatus = function(text)
	if text == nil or text == "" then
		return "Standing by — monitoring your garden"
	end
	text = tostring(text)
	if text:find("^WAIT FOR GARDEN CD") or text:find("^STEALING HIGHEST FRUIT") then
		return text
	end

	local exact = {
		["LOADING SCRIPT"] = "Initializing one-click farm...",
		["Waiting for game load..."] = "Waiting for game to finish loading...",
		["Blocked — game not fully loaded"] = "Game not ready — please wait or reload",
		["Game load complete"] = "Game loaded — automation starting",
		["Running kaitun"] = "Kaitun active — automated farming in progress",
		["Running kaitun (staged complete)"] = "Kaitun active — all modules online",
		["Stopped"] = "Farm stopped by user",
		["Startup error — check console"] = "Startup error — check the console for details",
		["Moving to garden for harvest..."] = "Returning to your garden to collect crops",
		["Returning to garden (night)"] = "Returning to your garden",
		["Returning to garden (day)"] = "Staying in your garden for daytime farming",
		["Steal failed — retry next trip"] = "Steal attempt failed — retrying next cycle",
		["Accepted gift"] = "Gift accepted automatically",
		["Unequipping weak pets"] = "Optimizing pets — unequipping weaker ones",
		["Equipping best pets"] = "Optimizing pets — equipping strongest team",
		["Ultimate optimize ON"] = "Performance mode enabled — textures stripped, players hidden",
	}
	if exact[text] then return exact[text] end

	local cdSec = text:match("^Steal wait %(garden entry cooldown%) ([%d%.]+)s")
	if cdSec then
		return ("WAIT FOR GARDEN CD OF PLAYER END | %d SECONDS LEFT"):format(math.ceil(tonumber(cdSec) or 0))
	end
	cdSec = text:match("^Steal garden cooldown ([%d%.]+)s")
	if cdSec then
		return ("WAIT FOR GARDEN CD OF PLAYER END | %d SECONDS LEFT"):format(math.ceil(tonumber(cdSec) or 0))
	end

	local waitReason, waitSec = text:match("^Steal wait %((.-)%) ([%d%.]+)s — hovering safe$")
	if waitReason == "garden entry cooldown" and waitSec then
		return ("WAIT FOR GARDEN CD OF PLAYER END | %d SECONDS LEFT"):format(math.ceil(tonumber(waitSec) or 0))
	end
	if waitReason then
		local reasonMap = {
			["safe zone"] = "Waiting for safe zone to clear before stealing",
			["entering garden"] = "Entering target garden...",
			["waiting prompts"] = "Waiting for steal prompts to appear",
			["owner in garden"] = "Target owner is in garden — holding position",
			["owner guarding"] = "Target owner is guarding — holding position",
			["not night"] = "Steal paused — waiting for night",
		}
		if reasonMap[waitReason] then return reasonMap[waitReason] end
	end

	local lockedReason = text:match("^Steal wait %((.-)%) — hovering safe$")
	if lockedReason then
		if lockedReason == "owner in garden" then return "Target owner is in garden — holding position" end
		if lockedReason == "owner guarding" then return "Target owner is guarding — holding position" end
		if lockedReason == "not night" then return "Steal paused — waiting for night" end
	end

	if text:find("^Harvest reset %(") and text:find("re%-entering garden") then
		return text
	end

	local harvested, seed, val = text:match("^Harvested (%d+) | top (.+) %((.+)%)$")
	if harvested then
		return ("Collected %s fruits | Best crop: %s (%s value)"):format(harvested, seed, val)
	end
	local retrySeed, retryVal = text:match("^Harvest retry | (.+) %((.+)%)$")
	if retrySeed then
		return ("Harvest pending — retrying %s (%s value)"):format(retrySeed, retryVal)
	end

	local stealDrainOwner, stealDrainSeed, stealDrainVal, stealDrainCount =
		text:match("^Steal drain @ (.+) | top (.+) %((.+)%) | (%d+) fruits$")
	if stealDrainOwner then
		return ("STEALING HIGHEST FRUIT (%s VALUE) FROM %s | %s targets"):format(
			stealDrainVal, stealDrainOwner, stealDrainCount)
	end

	local stealTripOwner, stealTripSeed, stealTripVal =
		text:match("^Steal trip @ (.+) | top (.+) %((.+)%)$")
	if stealTripOwner then
		return ("STEALING HIGHEST FRUIT (%s VALUE) FROM %s..."):format(stealTripVal, stealTripOwner)
	end

	local stealBatchN, stealBatchOwner, stealBatchSeed, stealBatchVal =
		text:match("^Steal (%d+) @ (.+) | top (.+) %((.+)%)$")
	if stealBatchN then
		return ("STEALING HIGHEST FRUIT (%s VALUE) FROM %s | %s targets"):format(
			stealBatchVal, stealBatchOwner, stealBatchN)
	end

	local loadReason = text:match("^Waiting game load: (.+)$")
	if loadReason then
		return ("Loading game systems (%s)..."):format(loadReason)
	end

	local seedName, bought = text:match("^Seed (.+) out of stock %((%d+) bought this restock%)$")
	if seedName then
		return ("Seed shop — %s sold out (%s bought this restock)"):format(seedName, bought)
	end
	local needCash, needSeed = text:match("^Need (.+) sheckles for (.+)$")
	if needCash then
		return ("Need %s coins to buy %s"):format(needCash, needSeed)
	end
	local buyingSeed, buyingHave, buyingTarget = text:match("^Buying (%S+) %((%d+)/(%d+)%)$")
	if buyingSeed then
		return ("Buying seeds — %s (%s/%s)"):format(buyingSeed, buyingHave, buyingTarget)
	end
	local plantedN = text:match("^Planted (%d+) seeds %(remote burst%)$")
	if plantedN then
		return ("Planted %s seeds across your garden"):format(plantedN)
	end
	local expandedTo, expandedMax, expandedCap = text:match(
		"^Expanded to (%d+)/(%d+) | cap (%d+) seeds$")
	if expandedTo then
		return ("Garden expanded to plot %s/%s | %s seed slots"):format(expandedTo, expandedMax, expandedCap)
	end
	local fleeLabel = text:match("^Flee steal: (.+)$")
	if fleeLabel then
		return ("Leaving steal — %s"):format(fleeLabel)
	end
	local stealHomeReason = text:match("^Steal home %((.-)%)$")
	if stealHomeReason then
		return ("Returning home to complete steal (%s)"):format(stealHomeReason)
	end
	local stealFleeReason = text:match("^Steal flee %((.-)%) — home to complete$")
	if stealFleeReason then
		return ("Low health — fleeing home (%s)"):format(stealFleeReason)
	end

	return text
end

SNH.setStatus = function(text)
	statusText = SNH.humanizeStatus(text)
	if PERF.loadingOverlayLabel and PERF.loadingOverlayLabel.Parent then
		pcall(function()
			PERF.loadingOverlayLabel.Text = statusText
		end)
	end
end

SNH.cfgSource = function(...)
	for i = 1, select("#", ...) do
		local key = select(i, ...)
		if key == "AutoMail" or key == "AUTO_MAIL" or key == "Mail" or key == "MailConfig" then
			local v = userCfg["AutoMail"] or userCfg.AutoMail or userCfg[key]
			if typeof(v) == "table" then return v end
		end
		if key == "Send Webhook" or key == "SendWebhook" or key == "WEBHOOK_SEND" or key == "WebhookSend" then
			local v = userCfg["Send Webhook"] or userCfg.SendWebhook or userCfg[key]
			if typeof(v) == "table" then return v end
		end
		if key == "BUY_PET" or key == "BuyPets" or key == "BuyPet" or key == "WildPetBuy" then
			local v = userCfg["BUY_PET"] or userCfg.BuyPets or userCfg.BuyPet or userCfg.WildPetBuy or userCfg[key]
			if typeof(v) == "table" then return v end
		end
		if key == "USE_GEAR" or key == "UseGear" or key == "UseGears" then
			local v = userCfg["USE_GEAR"] or userCfg.UseGear or userCfg.UseGears or userCfg[key]
			if typeof(v) == "table" then return v end
		end
		if key == "BUY_GEAR" or key == "BuyGear" or key == "BuyGears" then
			local v = userCfg["BUY_GEAR"] or userCfg.BuyGear or userCfg.BuyGears or userCfg[key]
			if typeof(v) == "table" then return v end
		end
		if key == "BUY_SEED" or key == "BuySeeds" or key == "BuySeed" then
			local v = userCfg["BUY_SEED"] or userCfg.BuySeeds or userCfg.BuySeed or userCfg[key]
			if typeof(v) == "table" then return v end
		end
		if key == "PLANT_SEED" or key == "PlantSeeds" or key == "PlantSeed" then
			local v = userCfg["PLANT_SEED"] or userCfg.PlantSeeds or userCfg.PlantSeed or userCfg[key]
			if typeof(v) == "table" then return v end
		end
	end
	return nil
end

SNH.buildAmountMap = function(defaults, overrides)
	local map = {}
	for name, value in defaults do
		map[name] = parseAmountEntry(value)
	end
	if typeof(overrides) == "table" then
		for name, value in overrides do
			if type(name) == "string" then
				map[name] = parseAmountEntry(value)
			end
		end
	end
	return map
end

SNH.parseBoolEntry = function(value)
	if type(value) == "boolean" then return value end
	if type(value) == "number" then return value > 0 end
	if type(value) == "string" then
		local lower = string.lower(value)
		return lower == "true" or lower == "yes" or lower == "on" or lower == "1"
	end
	return false
end

SNH.buildBoolMap = function(defaults, overrides)
	local map = {}
	for _, name in ALL_GEAR do
		map[name] = false
	end
	if typeof(defaults) == "table" then
		for name, value in defaults do
			if type(name) == "string" then
				map[name] = SNH.parseBoolEntry(value)
			end
		end
	end
	if typeof(overrides) == "table" then
		for name, value in overrides do
			if type(name) == "string" then
				map[name] = SNH.parseBoolEntry(value)
			end
		end
	end
	return map
end

SNH.shouldUseGear = function(gearName)
	return UseGearConfig[gearName] == true
end

SNH.applyBuySeedsConfig = function(overrides)
	BuySeedsConfig = SNH.buildAmountMap(USER_CONFIG["BUY_SEED"], overrides)
	SNH.invalidateAffordableSeedBuyCache()
end

SNH.applyBuyGearConfig = function(overrides)
	BuyGearConfig = SNH.buildAmountMap(USER_CONFIG["BUY_GEAR"], overrides)
end

SNH.applyPlantSeedsConfig = function(overrides)
	PlantSeedsConfig = SNH.buildAmountMap(USER_CONFIG["PLANT_SEED"], overrides)
end

SNH.applyUseGearConfig = function(overrides)
	local defaults = next(UseGearConfig) and UseGearConfig or USER_CONFIG["USE_GEAR"]
	UseGearConfig = SNH.buildBoolMap(defaults, overrides)
	AUTO_USE_GEAR = false
	for _, enabled in UseGearConfig do
		if enabled then
			AUTO_USE_GEAR = true
			break
		end
	end
end

SNH.applyBuyPetsConfig = function(overrides)
	BuyPetsConfig = SNH.buildAmountMap(USER_CONFIG["BUY_PET"], overrides)
end

SNH.normalizeAutoMailConfig = function(raw)
	local cfg = {
		enabled = false,
		recipient = "",
		recipientUserId = 0,
		note = "",
		gap = 20,
		batchLimit = 20,
		sendAllPets = false,
		petNames = {},
		seeds = {},
	}
	if type(raw) ~= "table" then
		return cfg
	end

	cfg.recipient = tostring(raw["Username"] or raw.Username or raw.username or raw["Recipient"] or raw.Recipient or raw.recipient or raw.Target or raw.target or "")
	cfg.recipientUserId = tonumber(raw["RecipientUserId"] or raw.RecipientUserId or raw.recipientUserId or raw.TargetUserId or raw.targetUserId or raw.UserId or raw.userId) or 0
	cfg.note = tostring(raw["Note"] or raw.Note or raw.note or raw.Message or raw.message or "")
	cfg.gap = math.max(3, tonumber(raw["Gap"] or raw.Gap or raw.gap or raw.Interval or raw.interval) or 20)
	cfg.batchLimit = math.clamp(math.floor(tonumber(raw["BatchLimit"] or raw.BatchLimit or raw.batchLimit or raw.MaxPerSend or raw.maxPerSend) or 20), 1, 20)

	local function parseSeedRule(rule)
		if rule == false or rule == nil then return nil end
		if type(rule) == "boolean" then
			return rule and { min = 1, keep = 0 } or nil
		end
		if type(rule) == "number" then
			local n = math.floor(rule)
			if n <= 0 then return nil end
			return { min = n, keep = 0 }
		end
		if type(rule) == "table" then
			local min = math.max(1, math.floor(tonumber(rule.Min or rule.min or rule.Amount or rule.amount or rule.Count or rule.count) or 1))
			local keep = math.max(0, math.floor(tonumber(rule.Keep or rule.keep or 0) or 0))
			return { min = min, keep = keep }
		end
		return nil
	end

	local pets = raw["Pets"] or raw.Pets or raw.pets
	if type(pets) == "table" then
		for k, v in pets do
			local name
			local enabled = false
			if type(k) == "number" then
				name = tostring(v or "")
				enabled = true
			else
				name = tostring(k or "")
				if type(v) == "boolean" then
					enabled = v
				else
					enabled = parseAmountEntry(v) > 0
				end
			end
			if name == "" then continue end
			if string.upper(name) == "ALL" and enabled then
				cfg.sendAllPets = true
			elseif enabled then
				cfg.petNames[name] = true
			end
		end
	end

	local seeds = raw["Seeds"] or raw.Seeds or raw.seeds
	if type(seeds) == "table" then
		for seedName, rule in seeds do
			if type(seedName) ~= "string" or seedName == "" then continue end
			local parsed = parseSeedRule(rule)
			if parsed then
				cfg.seeds[seedName] = parsed
			end
		end
	end

	local hasRules = cfg.sendAllPets
	if not hasRules then
		for _ in cfg.petNames do
			hasRules = true
			break
		end
	end
	if not hasRules then
		for _ in cfg.seeds do
			hasRules = true
			break
		end
	end
	cfg.enabled = hasRules and (cfg.recipient ~= "" or cfg.recipientUserId > 0)
	if raw["Enabled"] == true or raw.Enabled == true or raw.enabled == true then
		cfg.enabled = cfg.recipient ~= "" or cfg.recipientUserId > 0
	elseif raw["Enabled"] == false or raw.Enabled == false or raw.enabled == false then
		cfg.enabled = false
	end

	return cfg
end

SNH.isAutoMailSelfRecipient = function(recipient, recipientUserId)
	local lp = LocalPlayer
	if not lp then return false end
	if recipientUserId and recipientUserId > 0 and lp.UserId == recipientUserId then
		return true
	end
	if type(recipient) == "string" and recipient ~= "" then
		return string.lower(recipient) == string.lower(lp.Name)
	end
	return false
end

SNH.applyAutoMailConfig = function(raw)
	local prevRecipient = autoMailState.recipient
	local prevRecipientUserId = autoMailState.recipientUserId
	local cfg = SNH.normalizeAutoMailConfig(raw)
	autoMailState.enabled = cfg.enabled
	autoMailState.recipient = cfg.recipient
	autoMailState.recipientUserId = cfg.recipientUserId
	autoMailState.note = cfg.note
	autoMailState.gap = cfg.gap
	autoMailState.batchLimit = cfg.batchLimit
	autoMailState.sendAllPets = cfg.sendAllPets
	autoMailState.petNames = cfg.petNames
	autoMailState.seeds = cfg.seeds
	AUTO_MAIL_SEND = cfg.enabled
	if SNH.isAutoMailSelfRecipient(cfg.recipient, cfg.recipientUserId) then
		autoMailState.selfBlocked = true
		autoMailState.enabled = false
		AUTO_MAIL_SEND = false
		warn(("[So Nach Hup] AutoMail disabled: Username '%s' is your account — will not mail yourself."):format(
			cfg.recipient ~= "" and cfg.recipient or LocalPlayer.Name))
	else
		autoMailState.selfBlocked = false
	end
	SNH.invalidateAffordableSeedBuyCache()
	if prevRecipient ~= cfg.recipient or prevRecipientUserId ~= cfg.recipientUserId then
		autoMailState.cachedRecipientUserId = 0
		autoMailState.cachedRecipientName = ""
		autoMailState.lastResolveAt = 0
	end
end

SNH.configHasBuyEntries = function(map)
	for _, amount in map do
		if amount > 0 then return true end
	end
	return false
end

SNH.applyBuySeedsConfig(nil)
SNH.applyBuySeedsConfig(SNH.cfgSource("BUY_SEED", "BuySeeds", "BuySeed"))
SNH.applyBuyGearConfig(nil)
SNH.applyBuyGearConfig(SNH.cfgSource("BUY_GEAR", "BuyGear", "BuyGears"))
SNH.applyPlantSeedsConfig(nil)
SNH.applyPlantSeedsConfig(SNH.cfgSource("PLANT_SEED", "PlantSeeds", "PlantSeed"))
SNH.applyUseGearConfig(nil)
SNH.applyUseGearConfig(SNH.cfgSource("USE_GEAR", "UseGear", "UseGears"))
SNH.applyBuyPetsConfig(nil)
SNH.applyBuyPetsConfig(SNH.cfgSource("BUY_PET", "BuyPets", "BuyPet", "WildPetBuy"))
SNH.applyAutoMailConfig(SNH.cfgSource("AutoMail", "AUTO_MAIL", "Mail", "MailConfig") or userCfg["AutoMail"])

SNH.normalizeSendWebhookConfig = function(raw)
	local cfg = {
		pets = buildFalseMap(ALL_WILD_PETS),
		seeds = buildFalseMap(ALL_SEEDS),
	}
	if type(raw) ~= "table" then return cfg end

	local function applyBoolMap(target, source)
		if type(source) ~= "table" then return end
		for k, v in source do
			local name
			local enabled = false
			if type(k) == "number" then
				name = tostring(v or "")
				enabled = true
			else
				name = tostring(k or "")
				if type(v) == "boolean" then
					enabled = v
				else
					enabled = parseAmountEntry(v) > 0
				end
			end
			if name ~= "" then
				target[name] = enabled
			end
		end
	end

	applyBoolMap(cfg.pets, raw["Pet"] or raw.Pet or raw.pets)
	applyBoolMap(cfg.seeds, raw["Seed"] or raw.Seed or raw.seeds)
	return cfg
end

SNH.applySendWebhookConfig = function(raw)
	local cfg = SNH.normalizeSendWebhookConfig(raw)
	sendWebhookState.pets = cfg.pets
	sendWebhookState.seeds = cfg.seeds
end

SNH.shouldSendPetWebhook = function(petKey)
	if not petKey then return false end
	local key = SNH.resolvePetKey(petKey) or petKey
	for cfgName, enabled in sendWebhookState.pets do
		if enabled then
			local resolved = SNH.resolvePetKey(cfgName) or cfgName
			if resolved == key then return true end
		end
	end
	return false
end

SNH.shouldSendSeedWebhook = function(seedName)
	if not seedName then return false end
	for cfgName, enabled in sendWebhookState.seeds do
		if enabled and cfgName == seedName then return true end
	end
	return false
end

SNH.applyUserRuntimeConfig = function()
	local function cfgBool(...)
		for i = 1, select("#", ...) do
			local key = select(i, ...)
			local v = userCfg[key]
			if v ~= nil then return SNH.parseBoolEntry(v) end
		end
		return nil
	end
	local harvest = cfgBool("Auto Harvest", "AutoHarvest", "AutoCollect", "AUTO_COLLECT")
	if harvest ~= nil then AUTO_COLLECT = harvest end
	local steal = cfgBool("Auto Steal", "AutoSteal", "AUTO_STEAL")
	if steal ~= nil then AUTO_STEAL = steal end
	local allowPsSteal = cfgBool("AllowStealOnPrivateServer", "Allow Steal On Private Server")
	if allowPsSteal ~= nil then ALLOW_STEAL_ON_PRIVATE_SERVER = allowPsSteal end
	local maxExp = readUserCfgNumber("Max Expansions", "MaxExpansions", "MAX_EXPANSIONS")
	if maxExp then MAX_EXPANSIONS = maxExp end
	local targetSlots = readUserCfgNumber("Target Pet Slots", "TargetPetSlots", "TARGET_PET_SLOTS")
	if targetSlots then TARGET_PET_SLOTS = targetSlots end
	local fps = readUserCfgNumber("Fps", "FPS", "TargetFps", "MaxFps", "FpsCap")
	if fps then PERF.targetFps = math.max(0, math.floor(fps)) end
	local function readUserCfgFloat(...)
		for i = 1, select("#", ...) do
			local key = select(i, ...)
			local v = tonumber(userCfg[key])
			if v ~= nil and v >= 0 then return v end
		end
		return nil
	end
	local plantGap = readUserCfgFloat("PlantGap", "Plant Gap", "PLANT_GAP")
	if plantGap then PLANT_GAP = plantGap end
	local plantFireGap = readUserCfgFloat("PlantFireGap", "Plant Fire Gap", "PLANT_FIRE_GAP")
	if plantFireGap then PLANT_FIRE_GAP = plantFireGap end
	local plantBurstGap = readUserCfgFloat("PlantBurstGap", "Plant Burst Gap", "PLANT_BURST_GAP")
	if plantBurstGap then PLANT_BURST_GAP = plantBurstGap end
	local plantBurst = readUserCfgNumber("PlantBurstLimit", "Plant Burst Limit", "PLANT_BURST_LIMIT")
	if plantBurst then PLANT_BURST_LIMIT = plantBurst end
	local plantChunk = readUserCfgNumber("PlantChunk", "Plant Chunk", "PLANT_CHUNK")
	if plantChunk then PLANT_CHUNK = plantChunk end
	local disableFx = cfgBool("DisableAllEffects", "Disable All Effects", "DISABLE_ALL_EFFECTS")
	if disableFx ~= nil then DISABLE_ALL_EFFECTS = disableFx end
	local disableFxPurge = cfgBool("DisableEffectVfxPurge", "Disable Effect Vfx Purge", "DISABLE_EFFECT_VFX_PURGE")
	if disableFxPurge ~= nil then DISABLE_EFFECT_VFX_PURGE = disableFxPurge end
	local disableFxGap = readUserCfgFloat("DisableAllEffectsGap", "Disable All Effects Gap", "DISABLE_ALL_EFFECTS_GAP")
	if disableFxGap ~= nil then DISABLE_ALL_EFFECTS_GAP = disableFxGap end
	local harvestRange = readUserCfgNumber("HarvestPromptRange", "Harvest Prompt Range")
	if harvestRange and harvestRange > 0 then
		HARVEST_PROMPT_RANGE = harvestRange
		PROMPT_RANGE_MAX = math.max(PROMPT_RANGE_MAX, harvestRange)
	end
	local harvestMaintain = cfgBool("HarvestPromptMaintain", "Harvest Prompt Maintain")
	if harvestMaintain ~= nil then HARVEST_PROMPT_MAINTAIN = harvestMaintain end
	local removeTex = cfgBool("RemoveTextures", "Remove Textures", "OptimizeRemoveTextures")
	if removeTex ~= nil then PERF.removeTextures = removeTex end
	local hidePlayers = cfgBool("HideOtherPlayers", "Hide Other Players", "OptimizeHideOtherPlayers")
	if hidePlayers ~= nil then PERF.hideOtherPlayers = hidePlayers end
	if PERF.hideOtherPlayers then PERF.hideOtherBodyFace = true end
	local black = cfgBool("BlackScreen", "BlackScreenVisible", "Black Screen")
	if black ~= nil then PERF.blackScreen = black end
	local requireLoad = cfgBool("RequireFullLoad", "Require Full Load", "RequireFullLoad")
	if requireLoad ~= nil then BOOT.requireFullLoad = requireLoad end
	local unified = cfgBool("UnifiedScheduler", "UseUnifiedScheduler", "Use Unified Scheduler")
	if unified ~= nil then USE_UNIFIED_SCHEDULER = unified end
	local loadTimeout = readUserCfgNumber("GameLoadTimeout", "Game Load Timeout", "GameLoadTimeout")
	if loadTimeout and loadTimeout > 0 then BOOT.gameLoadTimeout = loadTimeout end
end

SNH.applyServerKindRules = function()
	SERVER_KIND = API.getServerKind()
	if SERVER_KIND == "Standard" or ALLOW_STEAL_ON_PRIVATE_SERVER then
		return SERVER_KIND
	end
	if AUTO_STEAL then
		AUTO_STEAL = false
		print(("[So Nach Hup] %s server — auto steal disabled (no other gardens)"):format(SERVER_KIND))
	end
	return SERVER_KIND
end

SNH.isStealAllowed = function()
	if not AUTO_STEAL or not Networking then return false end
	if not ALLOW_STEAL_ON_PRIVATE_SERVER and SERVER_KIND ~= "Standard" then return false end
	return API.canStealNow()
end

SNH.applySendWebhookConfig(
	SNH.cfgSource("Send Webhook", "SendWebhook", "WEBHOOK_SEND", "WebhookSend") or userCfg["Send Webhook"]
)
SNH.applyUserRuntimeConfig()
SNH.applyServerKindRules()
if SNH.configHasBuyEntries(BuySeedsConfig) then
	AUTO_BUY_SEED = true
end
	if SNH.configHasBuyEntries(BuyGearConfig) then
	AUTO_BUY_GEAR = true
end
if SNH.configHasBuyEntries(BuyPetsConfig) then
	AUTO_BUY_WILD_PET = true
end
AUTO_BUY_WILD_PET = true
for _, enabled in UseGearConfig do
	if enabled then AUTO_USE_GEAR = true break end
end
for _, amount in PlantSeedsConfig do
	if amount > 0 then AUTO_PLANT = true break end
end
end
setStatus = SNH.setStatus
formatAbbrev = SNH.formatAbbrev
formatElapsed = SNH.formatElapsed
applyBuySeedsConfig = SNH.applyBuySeedsConfig
applyBuyGearConfig = SNH.applyBuyGearConfig
applyPlantSeedsConfig = SNH.applyPlantSeedsConfig
applyUseGearConfig = SNH.applyUseGearConfig
applyBuyPetsConfig = SNH.applyBuyPetsConfig

do --[[ SNH: ShopCatalog ]]
SNH.loadHazardSeeds = function()
	for seedName in HAZARD_SEEDS_FALLBACK do
		HazardSeeds[seedName] = true
	end
	-- Skip scanning all plant module Source + global tagged instances (heavy at load).
end

SNH.loadShopCatalog = function()
	pcall(function()
		local shared = ReplicatedStorage:WaitForChild("SharedModules", 10)
		if not shared then return end
		local seedData = require(shared:WaitForChild("SeedData"))
		if type(seedData) == "table" then
			for _, entry in seedData do
				if type(entry) == "table" and entry.SeedName then
					SeedMeta[entry.SeedName] = {
						price = entry.PurchasePrice or FALLBACK_SELL[entry.SeedName] or 0,
						rarity = entry.Rarity or "Common",
						restockChance = entry.RestockChance or 0,
						restockShop = entry.RestockShop == true,
						mutationSeed = entry.MutationSeed == true,
						singleHarvest = entry.IsSingleHarvest == true,
						image = SNH.extractCatalogImage(entry.SeedImage)
							or SNH.extractCatalogImage(entry.FruitImage) or "",
					}
				end
			end
		end
		local gearData = require(shared:WaitForChild("GearShopData"))
		local list = gearData and (gearData.Data or gearData)
		if type(list) == "table" then
			for _, entry in list do
				if type(entry) == "table" and entry.ItemName then
					GearMeta[entry.ItemName] = {
						price = entry.Cost or 0,
						itemType = entry.ItemType,
					}
				end
			end
		end
	end)
	SNH.loadHazardSeeds()
end

SNH.extractCatalogImage = function(img)
	if type(img) == "string" then return img end
	if typeof(img) ~= "Instance" then return "" end
	if img:IsA("StringValue") then return img.Value end
	if img:IsA("ImageLabel") or img:IsA("ImageButton") then return img.Image end
	return ""
end

SNH.getSeedPrice = function(seedName)
	if SeedMeta[seedName] then return SeedMeta[seedName].price end
	return FALLBACK_SELL[seedName] or 0
end

SNH.isSingleHarvestSeed = function(seedName)
	if not seedName or seedName == "" then return false end
	local meta = SeedMeta[seedName]
	if meta and meta.singleHarvest ~= nil then return meta.singleHarvest end
	return SINGLE_HARVEST_FALLBACK[seedName] == true
end

SNH.getGearPrice = function(gearName)
	if GearMeta[gearName] then return GearMeta[gearName].price end
	return 0
end

SNH.getSeedStock = function(seedName)
	return select(1, SNH.getShopStockBreakdown(seedName, "SeedShop", { "SeedShop", "Seeds" }))
end

SNH.isMutationShopSeed = function(seedName)
	return seedName == "Gold" or seedName == "Rainbow"
end

-- g2 TimeCycleData: Rainbow Moon / Goldmoon are night moons (ActivePhase=Night + ActiveWeather).
-- Global Rainbow weather is WeatherValues.Rainbow_Playing — never treat it as a moon event.
SNH.isRainbowMoonActive = function()
	return API.getNightMoonWeather() == "Rainbow Moon"
end

SNH.isGoldMoonActive = function()
	local moon = API.getNightMoonWeather()
	return moon == "Goldmoon" or moon == "Gold Moon"
end

SNH.getMutationEventKind = function()
	local moon = API.getNightMoonWeather()
	if moon == "Goldmoon" or moon == "Gold Moon" then return "Gold" end
	if moon == "Rainbow Moon" then return "Rainbow" end
	local event = select(1, API.getCurrentEvent())
	if type(event) == "string" and event ~= "" then
		local lower = string.lower(event)
		if string.find(lower, "seedpack", 1, true) or string.find(lower, "seed pack", 1, true) then
			return "SeedPack"
		end
	end
	if tick() < (seedPackAnnounceUntil or 0) then return "SeedPack" end
	return nil
end

SNH.shouldSnipeMutationKind = function(kind)
	if kind == "Rainbow" then
		return SNH.isRainbowMoonActive()
	end
	if kind == "Gold" then return SNH.isGoldMoonActive() end
	if kind == "SeedPack" then
		if SNH.getMutationEventKind() == "SeedPack" then return true end
		return tick() < (seedPackAnnounceUntil or 0)
	end
	return false
end

SNH.markSeedPackEventActive = function(duration)
	seedPackAnnounceUntil = tick() + math.max(15, tonumber(duration) or 120)
	if SEED_SNIPE_PAUSE_ALL then seedSnipeActive = true end
end

SNH.isSeedSnipeEventActive = function()
	if not SEED_SNIPE_PAUSE_ALL then return false end
	if SNH.getMutationEventKind() then return true end
	if tick() < (seedPackAnnounceUntil or 0) then return true end
	if select(1, SNH.getPendingMutationSpawn()) ~= nil then return true end
	return false
end

SNH.isActionPausedForSeedSnipe = function()
	if not AUTO_SNIPE_MUTATION_SEEDS or not SEED_SNIPE_PAUSE_ALL then return false end
	if seedSnipeActive then return true end
	return SNH.isSeedSnipeEventActive()
end

-- Wild pets keep running while farming; only pause during an active mutation snipe teleport.
SNH.isWildPetBuyPaused = function()
	return seedSnipeActive == true
end
end

do --[[ SNH: ShopBuy ]]
SNH.waitForShopPurchaseConfirm = function(beforeInv, beforePurchased, countInvFn, countPurchasedFn)
	local baseline = math.max(beforeInv, beforePurchased)
	local deadline = tick() + SHOP_BUY_CONFIRM
	while tick() < deadline do
		local inv = countInvFn()
		local purchased = countPurchasedFn()
		if inv > beforeInv or purchased > beforePurchased then
			return true, inv, purchased
		end
		if math.max(inv, purchased) > baseline then
			return true, inv, purchased
		end
		task.wait(0.05)
	end
	return false, countInvFn(), countPurchasedFn()
end

SNH.shopItemExists = function(shopName, itemName)
	return SNH.getShopItem(shopName, itemName) ~= nil
end

SNH.countSeedInInventory = function(seedName)
	local count = 0
	for _, bag in { LocalPlayer.Backpack, LocalPlayer.Character } do
		if not bag then continue end
		for _, item in bag:GetChildren() do
			if item:IsA("Tool") and item:GetAttribute("SeedTool") == seedName then
				count += 1
			end
		end
	end
	return count
end

SNH.countGearInInventory = function(gearName)
	local count = 0
	for _, bag in { LocalPlayer.Backpack, LocalPlayer.Character } do
		if not bag then continue end
		for _, item in bag:GetChildren() do
			if not item:IsA("Tool") then continue end
			if item:GetAttribute("Sprinkler") == gearName
				or item:GetAttribute("WateringCan") == gearName
				or item:GetAttribute("Gear") == gearName
				or item.Name == gearName
			then
				count += 1
			end
		end
	end
	return count
end

SNH.getSortedBuyList = function(configMap, getPriceFn)
	local list = {}
	for name, target in configMap do
		if target > 0 then
			table.insert(list, { name = name, target = target })
		end
	end
	table.sort(list, function(a, b)
		local priceA = getPriceFn(a.name)
		local priceB = getPriceFn(b.name)
		if priceA == priceB then return a.name < b.name end
		return priceA < priceB
	end)
	return list
end

-- Seeds under MAX_SEED_BUY_PRICE only (cached — avoids scanning/logging every shop tick).
SNH.getAffordableSeedBuyList = function()
	local now = tick()
	if affordableSeedBuyCache and now - affordableSeedBuyCacheAt < AFFORDABLE_SEED_CACHE_TTL then
		return affordableSeedBuyCache
	end
	local list = {}
	local seen = {}
	for _, entry in SNH.getSortedBuyList(BuySeedsConfig, SNH.getSeedPrice) do
		local seedName = entry.name
		if SNH.isMutationShopSeed(seedName) then continue end
		local price = SNH.getSeedPrice(seedName)
		if price <= 0 or price >= MAX_SEED_BUY_PRICE then continue end
		local target = SNH.getMailSeedBuyTarget(seedName)
		if target <= 0 then continue end
		seen[seedName] = true
		table.insert(list, { name = seedName, target = target })
	end
	for seedName, rule in autoMailState.seeds do
		if seen[seedName] then continue end
		if type(rule) ~= "table" or (tonumber(rule.min) or 0) <= 0 then continue end
		if SNH.isMutationShopSeed(seedName) then continue end
		local price = SNH.getSeedPrice(seedName)
		if price <= 0 or price >= MAX_SEED_BUY_PRICE then continue end
		seen[seedName] = true
		table.insert(list, { name = seedName, target = SNH.getMailSeedBuyTarget(seedName) })
	end
	table.sort(list, function(a, b)
		local priceA = SNH.getSeedPrice(a.name)
		local priceB = SNH.getSeedPrice(b.name)
		if priceA == priceB then return a.name < b.name end
		return priceA < priceB
	end)
	affordableSeedBuyCache = list
	affordableSeedBuyCacheAt = now
	return list
end

SNH.getSeedPurchased = function(seedName)
	return SNH.getPurchasedThisRestock(seedName, { "SeedShop", "Seeds" })
end

SNH.getGearPurchased = function(gearName)
	return SNH.getPurchasedThisRestock(gearName, { "GearShop", "Gear" })
end
end

do --[[ SNH: ShopBuySeeds ]]
SNH.tryBuySeeds = function()
	if not AUTO_BUY_SEED or not Networking or not Networking.SeedShop then return 0 end
	if not next(BuySeedsConfig) then return 0 end
	local _, plot = API.getLocalPlot()
	if plot and SNH.isPlantCapReached(plot, true) then return 0 end
	local now = tick()
	if now - lastSeedBuyAt < SHOP_BUY_GAP then return 0 end

	local bought = 0
	for _, entry in SNH.getAffordableSeedBuyList() do
		local seedName = entry.name
		local target = SNH.getMailSeedBuyTarget(seedName)
		if target <= 0 then continue end
		if SNH.isShopItemBlocked(seedName) then continue end
		if not SNH.shopItemExists("SeedShop", seedName) then continue end

		local price = SNH.getSeedPrice(seedName)
		if price <= 0 then continue end

		while SNH.countSeedInInventory(seedName) < target do
			local invBefore = SNH.countSeedInInventory(seedName)
			if invBefore >= target then break end

			local remaining, shopStock, purchased = SNH.getShopStockBreakdown(
				seedName, "SeedShop", { "SeedShop", "Seeds" })
			if remaining <= 0 then
				if shopStock <= 0 then break end
				SNH.setStatus(("Seed %s out of stock (%d bought this restock)"):format(seedName, purchased))
				break
			end

			local sheckles = API.getSheckles()
			if sheckles < price then
				SNH.setStatus(("Need %s sheckles for %s"):format(SNH.formatAbbrev(price), seedName))
				break
			end

			local need = target - invBefore
			local maxAfford = math.floor(sheckles / price)
			local burst = math.min(remaining, need, maxAfford, SHOP_BUY_BURST)
			if burst <= 0 then break end

			local purchasedBefore = SNH.getSeedPurchased(seedName)
			for _ = 1, burst do
				pcall(function() Networking.SeedShop.PurchaseSeed:Fire(seedName) end)
				if SHOP_BUY_FIRE_GAP > 0 then task.wait(SHOP_BUY_FIRE_GAP) end
			end

			local confirmed, invAfter, purchasedAfter = SNH.waitForShopPurchaseConfirm(
				invBefore, purchasedBefore,
				function() return SNH.countSeedInInventory(seedName) end,
				function() return SNH.getSeedPurchased(seedName) end
			)
			local gained = math.max(0, invAfter - invBefore)
			if gained <= 0 and not confirmed then
				SNH.noteShopBuyFailure(seedName)
				SNH.setStatus(("Seed %s — buy not confirmed, retry later"):format(seedName))
				break
			end

			SNH.noteShopBuySuccess(seedName)
			bought += gained > 0 and gained or 1
			SNH.sendSeedWebhook(seedName, {
				source = "Seed Shop",
				amount = gained > 0 and gained or 1,
				unitPrice = price,
				price = price * (gained > 0 and gained or 1),
			})
			local newRemaining = select(1, SNH.getShopStockBreakdown(seedName, "SeedShop", { "SeedShop", "Seeds" }))
			SNH.setStatus(("Buying %s (%d/%d)"):format(seedName, invAfter, target))
			SNH.debugLog("SHOP", ("bought %s x%d inv %d→%d shop %d left ~%d"):format(
				seedName, gained > 0 and gained or 1, invBefore, invAfter, shopStock, newRemaining), "force")

			if gained <= 0 then break end
			if invAfter >= target then break end
			if newRemaining <= 0 then break end
		end

		if bought > 0 then break end
	end

	if bought > 0 then
		lastSeedBuyAt = now
		lastShopBuyAt = now
	end
	return bought
end

-- Buy upgrade seeds even when garden is at cap (normal tryBuySeeds skips at cap).
SNH.tryBuyUpgradeSeed = function(plot)
	if not AUTO_BUY_SEED or not Networking or not Networking.SeedShop then return 0 end
	if not plot or not SNH.needsUpgradeSeedBuy(plot) then return 0 end
	local now = tick()
	if now - lastSeedBuyAt < SHOP_BUY_GAP then return 0 end

	local best = select(1, SNH.resolveBestUpgradeCandidate(plot))
	if not best or best.tool then return 0 end

	local seedName = best.seedName
	if SNH.isShopItemBlocked(seedName) then return 0 end
	if not SNH.shopItemExists("SeedShop", seedName) then return 0 end

	local price = SNH.getSeedPrice(seedName) or 0
	if price <= 0 or price >= MAX_SEED_BUY_PRICE then return 0 end

	local target = math.max(1, SNH.getMailSeedBuyTarget(seedName))
	local invBefore = SNH.countSeedInInventory(seedName)
	if invBefore >= target then return 0 end

	local remaining, shopStock = SNH.getShopStockBreakdown(
		seedName, "SeedShop", { "SeedShop", "Seeds" })
	if remaining <= 0 then
		if shopStock <= 0 then
			SNH.setStatus(("Upgrade seed %s out of stock — doing other tasks"):format(seedName))
		end
		return 0
	end

	local sheckles = API.getSheckles()
	if sheckles < price then
		SNH.setStatus(("Need %s sheckles for upgrade seed %s"):format(
			SNH.formatAbbrev(price), seedName))
		return 0
	end

	local need = math.max(1, target - invBefore)
	local burst = math.min(remaining, need, math.floor(sheckles / price), SHOP_BUY_BURST)
	if burst <= 0 then return 0 end

	local purchasedBefore = SNH.getSeedPurchased(seedName)
	for _ = 1, burst do
		pcall(function() Networking.SeedShop.PurchaseSeed:Fire(seedName) end)
		if SHOP_BUY_FIRE_GAP > 0 then task.wait(SHOP_BUY_FIRE_GAP) end
	end

	local confirmed, invAfter, purchasedAfter = SNH.waitForShopPurchaseConfirm(
		invBefore, purchasedBefore,
		function() return SNH.countSeedInInventory(seedName) end,
		function() return SNH.getSeedPurchased(seedName) end
	)
	local gained = math.max(0, invAfter - invBefore)
	if gained <= 0 and not confirmed then
		SNH.noteShopBuyFailure(seedName)
		SNH.setStatus(("Upgrade seed %s — buy not confirmed, retry later"):format(seedName))
		return 0
	end

	SNH.noteShopBuySuccess(seedName)
	SNH.sendSeedWebhook(seedName, {
		source = "Seed Shop (upgrade)",
		amount = gained > 0 and gained or 1,
		unitPrice = price,
		price = price * (gained > 0 and gained or 1),
	})
	lastSeedBuyAt = now
	lastShopBuyAt = now
	SNH.setStatus(("Bought upgrade seed %s (%d/%d)"):format(seedName, invAfter, target))
	print(("[So Nach Hup] Bought upgrade seed %s x%d for plant upgrade"):format(
		seedName, gained > 0 and gained or 1))
	return gained > 0 and gained or 1
end
end

do --[[ SNH: ShopBuyGear ]]
SNH.tryBuyGear = function()
	if not AUTO_BUY_GEAR or not Networking or not Networking.GearShop then
		SNH.debugLog("GEAR_BUY", ("skip: auto=%s net=%s gearShop=%s"):format(
			tostring(AUTO_BUY_GEAR), tostring(Networking ~= nil),
			tostring(Networking and Networking.GearShop ~= nil)), "warn")
		return 0
	end
	if not next(BuyGearConfig) then
		SNH.debugLog("GEAR_BUY", "skip: BuyGearConfig empty", "warn")
		return 0
	end
	local now = tick()
	if now - lastGearBuyAt < SHOP_BUY_GAP then
		SNH.debugLog("GEAR_BUY", ("skip: cooldown %.2fs left"):format(SHOP_BUY_GAP - (now - lastGearBuyAt)))
		return 0
	end

	local bought = 0
	for _, entry in SNH.getSortedBuyList(BuyGearConfig, SNH.getGearPrice) do
		local gearName, target = entry.name, entry.target
		if SNH.isShopItemBlocked(gearName) then
			SNH.debugLog("GEAR_BUY", ("skip %s: shop blocked"):format(gearName))
			continue
		end
		if not SNH.shopItemExists("GearShop", gearName) then
			SNH.debugLog("GEAR_BUY", ("skip %s: not in shop catalog"):format(gearName))
			continue
		end

		local price = SNH.getGearPrice(gearName)
		if price <= 0 then
			SNH.debugLog("GEAR_BUY", ("skip %s: price=%s"):format(gearName, tostring(price)))
			continue
		end

		while SNH.countGearInInventory(gearName) < target do
			local invBefore = SNH.countGearInInventory(gearName)
			if invBefore >= target then break end

			local remaining = select(1, SNH.getShopStockBreakdown(gearName, "GearShop", { "GearShop", "Gear" }))
			if remaining <= 0 then
				SNH.debugLog("GEAR_BUY", ("skip %s: out of stock"):format(gearName))
				break
			end
			if API.getSheckles() < price then
				SNH.debugLog("GEAR_BUY", ("skip %s: need %s have %s"):format(
					gearName, SNH.formatAbbrev(price), SNH.formatAbbrev(API.getSheckles())))
				break
			end

			local need = target - invBefore
			local burst = math.min(remaining, need, SHOP_BUY_BURST)
			local purchasedBefore = SNH.getGearPurchased(gearName)
			SNH.debugLog("GEAR_BUY", ("buying %s x%d (have %d/%d stock %d)"):format(
				gearName, burst, invBefore, target, remaining), "force")
			for _ = 1, burst do
				pcall(function() Networking.GearShop.PurchaseGear:Fire(gearName) end)
				if SHOP_BUY_FIRE_GAP > 0 then task.wait(SHOP_BUY_FIRE_GAP) end
			end

			local confirmed, invAfter = SNH.waitForShopPurchaseConfirm(
				invBefore, purchasedBefore,
				function() return SNH.countGearInInventory(gearName) end,
				function() return SNH.getGearPurchased(gearName) end
			)
			local gained = math.max(0, invAfter - invBefore)
			if gained <= 0 and not confirmed then
				SNH.debugLog("GEAR_BUY", ("fail %s: confirm timeout inv %d->%d"):format(
					gearName, invBefore, invAfter), "warn")
				SNH.noteShopBuyFailure(gearName)
				break
			end

			SNH.noteShopBuySuccess(gearName)
			bought += gained > 0 and gained or 1
			SNH.debugLog("GEAR_BUY", ("ok %s +%d (now %d)"):format(gearName, gained, invAfter), "force")
			if invAfter >= target or gained <= 0 then break end
		end

		if bought > 0 then break end
	end

	if bought > 0 then
		lastGearBuyAt = now
		lastShopBuyAt = now
	else
		SNH.debugLog("GEAR_BUY", "no gear bought this tick")
	end
	return bought
end
end
tryBuySeeds = SNH.tryBuySeeds
tryBuyGear = SNH.tryBuyGear
getShopStockBreakdown = SNH.getShopStockBreakdown
getSeedPurchased = SNH.getSeedPurchased
getSeedStock = SNH.getSeedStock
getSeedPrice = SNH.getSeedPrice
getGearPrice = SNH.getGearPrice
loadShopCatalog = SNH.loadShopCatalog
setupShopStockWatchers = SNH.setupShopStockWatchers
setupShopRestockListeners = SNH.setupShopRestockListeners
getPlayerStateClient = SNH.getPlayerStateClient

do --[[ SNH: GearTools ]]
SNH.gearToolMatches = function(item, gearName)
	if not item or not item:IsA("Tool") then return false end
	return item:GetAttribute("Sprinkler") == gearName
		or item:GetAttribute("WateringCan") == gearName
		or item:GetAttribute("Gear") == gearName
		or item.Name == gearName
end

SNH.findGearTool = function(gearName)
	for _, bag in { LocalPlayer.Character, LocalPlayer.Backpack } do
		if not bag then continue end
		for _, item in bag:GetChildren() do
			if SNH.gearToolMatches(item, gearName) then
				return item
			end
		end
	end
	return nil
end

SNH.isGearInHand = function(gearName)
	local char = LocalPlayer.Character
	if not char then return false, nil end
	for _, item in char:GetChildren() do
		if SNH.gearToolMatches(item, gearName) then
			return true, item
		end
	end
	return false, nil
end

SNH.getGearUseState = function(gearName)
	if not gearUseState[gearName] then
		gearUseState[gearName] = {
			shopEquipSent = false,
			handEquipDone = false,
			lockedPos = nil,
			lockedSeed = nil,
		}
	end
	return gearUseState[gearName]
end

SNH.resetGearUseState = function(gearName)
	gearUseState[gearName] = nil
end

SNH.ensureGearOwnedOnce = function(gearName)
	if SNH.findGearTool(gearName) then return true end
	local st = SNH.getGearUseState(gearName)
	if st.shopEquipSent then
		return SNH.findGearTool(gearName) ~= nil
	end
	if not Networking or not Networking.GearShop or not Networking.GearShop.EquipGear then
		return false
	end
	st.shopEquipSent = true
	pcall(function() Networking.GearShop.EquipGear:Fire(gearName) end)
	for _ = 1, 10 do
		task.wait(0.08)
		if SNH.findGearTool(gearName) then return true end
	end
	return SNH.findGearTool(gearName) ~= nil
end

SNH.equipGearForPlacement = function(gearName)
	local tool = SNH.findGearTool(gearName)
	if not tool then return nil end
	return SNH.equipToolForPlacement(tool)
end
end

do --[[ SNH: GearPlace ]]
local sprinklerNameMapLoaded = false
local sprinklerNameMap = {
	["Common Sprinkler"] = true,
	["Uncommon Sprinkler"] = true,
	["Rare Sprinkler"] = true,
	["Legendary Sprinkler"] = true,
	["Godly Sprinkler"] = true,
	["Master Sprinkler"] = true,
	["Super Sprinkler"] = true,
}

SNH.getSprinklerNameMap = function()
	if sprinklerNameMapLoaded then return sprinklerNameMap end
	sprinklerNameMapLoaded = true
	pcall(function()
		local shared = ReplicatedStorage:FindFirstChild("SharedModules")
		local mod = shared and shared:FindFirstChild("SprinklerData")
		local data = mod and require(mod)
		if type(data) ~= "table" then return end
		for _, entry in data do
			if type(entry) == "table" and type(entry.SprinklerName) == "string" then
				sprinklerNameMap[entry.SprinklerName] = true
			end
		end
	end)
	return sprinklerNameMap
end

SNH.getPlantAreasInPlot = function(plot, forceRefresh)
	if not plot then return {} end
	local now = tick()
	if not forceRefresh
		and plantAreasCache.plot == plot
		and now - plantAreasCache.time < PLANT_AREAS_CACHE_TTL
		and #plantAreasCache.areas > 0 then
		return plantAreasCache.areas
	end

	local plantAreas, seen = {}, {}
	local gardens = workspace:FindFirstChild("Gardens")
	if gardens then
		local ok, list = pcall(function()
			return gardens:QueryDescendants("BasePart.PlantArea")
		end)
		if ok and list then
			for _, part in list do
				if part:IsDescendantOf(plot) and not seen[part] then
					seen[part] = true
					table.insert(plantAreas, part)
				end
			end
		end
	end
	if #plantAreas > 0 then
		plantAreasCache.plot = plot
		plantAreasCache.time = now
		plantAreasCache.areas = plantAreas
		return plantAreas
	end
	for _, part in CollectionService:GetTagged("PlantArea") do
		if part:IsA("BasePart") and part:IsDescendantOf(plot) and not seen[part] then
			seen[part] = true
			table.insert(plantAreas, part)
		end
	end
	if #plantAreas > 0 then
		plantAreasCache.plot = plot
		plantAreasCache.time = now
		plantAreasCache.areas = plantAreas
		return plantAreas
	end
	local fallback = {}
	for _, part in CollectionService:GetTagged("GardenTotalArea") do
		if part:IsA("BasePart") and part:IsDescendantOf(plot) and not seen[part] then
			seen[part] = true
			table.insert(fallback, part)
		end
	end
	for _, part in plot:GetDescendants() do
		if part:IsA("BasePart") and (part.Name == "GardenTotalArea" or part.Name == "GardenArea") and not seen[part] then
			seen[part] = true
			table.insert(fallback, part)
		end
	end
	plantAreasCache.plot = plot
	plantAreasCache.time = now
	plantAreasCache.areas = fallback
	return fallback
end

SNH.getSprinklerPositionsInPlot = function(plot, forceRefresh)
	if not plot then return {} end
	local now = tick()
	if not forceRefresh
		and sprinklerPosCache.plot == plot
		and now - sprinklerPosCache.time < SPRINKLER_POS_CACHE_TTL then
		return sprinklerPosCache.positions
	end

	local positions = {}
	local sprinklers = plot:FindFirstChild("Sprinklers")
	if sprinklers then
		for _, inst in sprinklers:GetChildren() do
			local pos
			if inst:IsA("Model") and inst.PrimaryPart then
				pos = inst.PrimaryPart.Position
			elseif inst:IsA("BasePart") then
				pos = inst.Position
			end
			if pos then table.insert(positions, pos) end
		end
	end

	if #positions == 0 then
		local nameMap = SNH.getSprinklerNameMap()
		for _, inst in plot:GetDescendants() do
			if not inst:IsA("Model") or not inst.PrimaryPart then continue end
			if not (nameMap[inst.Name] or string.find(string.lower(inst.Name), "sprinkler", 1, true)) then continue end
			table.insert(positions, inst.PrimaryPart.Position)
		end
	end

	sprinklerPosCache.plot = plot
	sprinklerPosCache.time = now
	sprinklerPosCache.positions = positions
	return positions
end

SNH.getPlotIdFromPlot = function(plot)
	if plot and plot.Name then
		local id = tonumber(string.match(plot.Name, "%d+"))
		if id then return id end
	end
	return tonumber(API.getLocalPlotId()) or API.getLocalPlotId()
end

SNH.fireSprinklerRemote = function(tool, gearName, plot, aimPos, plotId)
	if not tool or not plot or not aimPos then return false, nil end
	if not Networking then Networking = API.getNetworking() end
	if not Networking or not Networking.Place or not Networking.Place.PlaceSprinkler then
		return false, nil
	end
	local exactPos = SNH.snapToPlantArea(plot, aimPos)
	if not exactPos or not SNH.isOnPlantArea(plot, exactPos) then
		return false, exactPos
	end
	plotId = SNH.getPlotIdFromPlot(plot) or tonumber(plotId) or plotId
	local sprinklerName = tool:GetAttribute("Sprinkler") or gearName
	local ok = pcall(function()
		Networking.Place.PlaceSprinkler:Fire(exactPos, sprinklerName, tool, plotId)
	end)
	SNH.debugLog("GEAR", ("sprinkler remote %s @ %s plotId=%s ok=%s"):format(
		sprinklerName, SNH.fmtVec3(exactPos), tostring(plotId), tostring(ok)), ok and "force" or "warn")
	return ok, exactPos
end

SNH.snapToPlantArea = function(plot, position)
	if not plot or not position then return nil end
	local areas = SNH.getPlantAreasInPlot(plot)
	if #areas == 0 then return nil end
	local requirePlantArea = CollectionService:HasTag(areas[1], "PlantArea")
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Include
	params.FilterDescendantsInstances = areas
	local function acceptHit(hit)
		if not hit or not hit.Instance:IsDescendantOf(plot) then return false end
		if requirePlantArea and not CollectionService:HasTag(hit.Instance, "PlantArea") then return false end
		return true
	end
	local function raySnap(worldPos)
		local probe = Vector3.new(worldPos.X, worldPos.Y + 50, worldPos.Z)
		local hit = workspace:Raycast(probe, Vector3.new(0, -500, 0), params)
		if acceptHit(hit) then return hit.Position end
		return nil
	end
	local snapped = raySnap(position)
	if snapped then return snapped end
	local bestPos, bestDist = nil, math.huge
	for _, part in areas do
		if part.Transparency >= 1 then continue end
		local localPos = part.CFrame:PointToObjectSpace(position)
		local half = part.Size * 0.5
		local clamped = Vector3.new(
			math.clamp(localPos.X, -half.X * 0.88, half.X * 0.88),
			half.Y * 0.5,
			math.clamp(localPos.Z, -half.Z * 0.88, half.Z * 0.88)
		)
		local candidate = part.CFrame:PointToWorldSpace(clamped)
		snapped = raySnap(candidate)
		if snapped then
			local dist = (Vector2.new(snapped.X, snapped.Z) - Vector2.new(position.X, position.Z)).Magnitude
			if dist < bestDist then
				bestDist = dist
				bestPos = snapped
			end
		end
	end
	return bestPos
end

SNH.isNearSprinkler = function(plot, position)
	if not plot or not position then return false end
	for _, sp in SNH.getSprinklerPositionsInPlot(plot) do
		if (sp - position).Magnitude < 1 then
			return true
		end
	end
	return false
end

SNH.isValidGearPosition = function(plot, position)
	if not plot or not position then return false end
	return not SNH.isNearSprinkler(plot, position)
end

SNH.verifyGearPlaced = function(plot, gearName, pos, toolRef)
	if SNH.isNearSprinkler(plot, pos) then return true end
	if toolRef and not toolRef.Parent then return true end
	local inHand = SNH.isGearInHand(gearName)
	if toolRef and not inHand then return true end
	if not SNH.findGearTool(gearName) and toolRef then return true end
	return false
end

SNH.getGearPlacePosition = function(plot, plantModel)
	if not plot or not plantModel then return nil end
	local pivot = plantModel:GetPivot().Position
	local snapped = SNH.snapToPlantArea(plot, pivot)
	if snapped then return snapped end
	return pivot
end

SNH.getBestPlantForGear = function(plot, forceRefresh)
	if not plot then return nil end
	local now = tick()
	if not forceRefresh
		and bestPlantForGearCache.plot == plot
		and now - bestPlantForGearCache.time < BEST_PLANT_CACHE_TTL
		and bestPlantForGearCache.data then
		return bestPlantForGearCache.data
	end

	local plants = plot:FindFirstChild("Plants")
	if not plants then return nil end
	local areas = SNH.getPlantAreasInPlot(plot)
	local requirePlantArea = #areas > 0 and CollectionService:HasTag(areas[1], "PlantArea")
	local rayParams
	if #areas > 0 then
		rayParams = RaycastParams.new()
		rayParams.FilterType = Enum.RaycastFilterType.Include
		rayParams.FilterDescendantsInstances = areas
	end
	local function onPlantArea(position)
		if not position or not requirePlantArea then return not requirePlantArea end
		if not rayParams then return false end
		local probe = Vector3.new(position.X, position.Y + 25, position.Z)
		local hit = workspace:Raycast(probe, Vector3.new(0, -500, 0), rayParams)
		return hit and hit.Instance:IsDescendantOf(plot) and CollectionService:HasTag(hit.Instance, "PlantArea")
	end

	local best, bestPrice = nil, -1
	local fallback, fallbackPrice = nil, -1
	for _, inst in plants:GetChildren() do
		if not inst:IsA("Model") then continue end
		if not inst:GetAttribute("PlantId") then continue end
		if tonumber(inst:GetAttribute("UserId")) and tonumber(inst:GetAttribute("UserId")) ~= LocalPlayer.UserId then continue end
		local seedName = inst:GetAttribute("SeedName") or inst:GetAttribute("CorePartName")
		if not seedName then continue end
		local plantPivot = inst:GetPivot().Position
		local pos = SNH.getGearPlacePosition(plot, inst)
		if not pos or not onPlantArea(pos) then continue end
		local price = SNH.getSeedPrice(seedName)
		local entry = {
			seedName = seedName,
			price = price,
			position = pos,
			plantPivot = plantPivot,
			model = inst,
		}
		if not SNH.isNearSprinkler(plot, pos) then
			if price > bestPrice then
				bestPrice = price
				best = entry
			end
		elseif price > fallbackPrice then
			fallbackPrice = price
			fallback = entry
		end
	end
	local result = best or fallback
	if result then
		bestPlantForGearCache.plot = plot
		bestPlantForGearCache.time = now
		bestPlantForGearCache.data = result
	end
	return result
end

SNH.getGnomeYaw = function(plot)
	if not plot then return 0 end
	local spawn = plot:FindFirstChild("SpawnPoint")
	if not spawn or not spawn:IsA("BasePart") then return 0 end
	local _, yaw = spawn.CFrame:ToEulerAnglesYXZ()
	return math.deg(yaw) + 180
end

SNH.fireGearAtPosition = function(tool, gearName, pos, plotId, plot)
	if not tool or not pos then
		SNH.debugLog("GEAR", ("fire skip: tool=%s pos=%s"):format(tostring(tool), SNH.fmtVec3(pos)), "warn")
		return false
	end
	local fired = false
	local remotePath = "none"
	local function tryFire(fn, path)
		local ok = pcall(fn)
		if ok then fired = true remotePath = path end
		return ok
	end
	if tool:GetAttribute("Sprinkler") and Networking.Place and Networking.Place.PlaceSprinkler then
		local usePlot = plot or API.getPlot(tonumber(plotId) or plotId)
		if usePlot then
			local ok, exactPos = SNH.fireSprinklerRemote(tool, gearName, usePlot, pos, plotId)
			if ok then
				fired = true
				remotePath = "Place.PlaceSprinkler(exact)"
			end
		else
			local sprinklerName = tool:GetAttribute("Sprinkler") or gearName
			tryFire(function()
				Networking.Place.PlaceSprinkler:Fire(pos, sprinklerName, tool, plotId)
			end, "Place.PlaceSprinkler")
		end
	elseif tool:GetAttribute("WateringCan") and Networking.WateringCan and Networking.WateringCan.UseWateringCan then
		local canName = tool:GetAttribute("WateringCan") or gearName
		local waterPos = pos - Vector3.new(0, 0.3, 0)
		for _ = 1, 3 do
			tryFire(function()
				Networking.WateringCan.UseWateringCan:Fire(waterPos, canName, tool)
			end, "WateringCan.UseWateringCan")
		end
	elseif tool:GetAttribute("Gnome") and Networking.Place and Networking.Place.PlaceGnome then
		local gnomeName = tool:GetAttribute("Gnome") or gearName
		local usePlot = plot or API.getPlot(tonumber(plotId) or plotId)
		local yaw = SNH.getGnomeYaw(usePlot)
		for _ = 1, 3 do
			tryFire(function()
				Networking.Place.PlaceGnome:Fire(pos, gnomeName, tool, yaw)
			end, "Place.PlaceGnome")
		end
	elseif tool:GetAttribute("Gear") and Networking.Place and Networking.Place.PlaceSprinkler then
		for _ = 1, 3 do
			tryFire(function()
				Networking.Place.PlaceSprinkler:Fire(pos, gearName, tool, plotId)
			end, "Place.PlaceSprinkler(generic)")
		end
	elseif tool:GetAttribute("Rake") and Networking.Place and Networking.Place.PlaceRake then
		local rakeName = tool:GetAttribute("Rake") or gearName
		local usePlot = plot or API.getPlot(tonumber(plotId) or plotId)
		local yaw = SNH.getGnomeYaw(usePlot)
		for _ = 1, 3 do
			tryFire(function()
				Networking.Place.PlaceRake:Fire(pos, rakeName, tool, plotId, yaw)
			end, "Place.PlaceRake")
		end
	elseif tool:GetAttribute("Build") and Networking.Prop and Networking.Prop.PlaceProp then
		local buildName = tool:GetAttribute("Build") or gearName
		local usePlot = plot or API.getPlot(tonumber(plotId) or plotId)
		local yaw = SNH.getGnomeYaw(usePlot)
		for _ = 1, 3 do
			tryFire(function()
				Networking.Prop.PlaceProp:Fire(pos, buildName, tool, yaw)
			end, "Prop.PlaceProp")
		end
	elseif tool:GetAttribute("Mushroom") then
		pcall(function() tool:Activate() end)
		fired = true
		remotePath = "Tool.Activate(Mushroom)"
	else
		SNH.debugLog("GEAR", ("fire skip %s: no matching remote attrs=%s"):format(
			gearName,
			table.concat({
				tool:GetAttribute("Sprinkler") and "Sprinkler" or "",
				tool:GetAttribute("WateringCan") and "WateringCan" or "",
				tool:GetAttribute("Gnome") and "Gnome" or "",
				tool:GetAttribute("Gear") and "Gear" or "",
			}, ",")), "warn")
	end
	SNH.debugLog("GEAR", ("fire %s @ %s plotId=%s remote=%s ok=%s"):format(
		gearName, SNH.fmtVec3(pos), tostring(plotId), remotePath, tostring(fired)), fired and "force" or "warn")
	return fired
end

SNH.unequipGearFromHand = function()
	if Networking and Networking.GearShop and Networking.GearShop.UnequipGear then
		pcall(function() Networking.GearShop.UnequipGear:Fire() end)
	end
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum then pcall(hum.UnequipTools, hum) end
end
end

do --[[ SNH: GearUse ]]
SNH.tryUseGear = function()
	if not Networking then Networking = API.getNetworking() end
	if not AUTO_USE_GEAR or not Networking then
		SNH.debugLog("GEAR", ("skip: auto=%s net=%s"):format(tostring(AUTO_USE_GEAR), tostring(Networking ~= nil)))
		return false
	end
	if stealActive then
		SNH.debugLog("GEAR", "skip: stealActive")
		return false
	end
	if SNH.isActionPausedForSeedSnipe() then
		SNH.debugLog("GEAR", "skip: seedSnipeActive")
		return false
	end
	if gearPlacingActive then
		SNH.debugLog("GEAR", "skip: gearPlacingActive")
		return false
	end
	if not next(UseGearConfig) then
		SNH.debugLog("GEAR", "skip: UseGearConfig empty", "warn")
		return false
	end
	local now = tick()
	if now - lastGearUseAt < GEAR_USE_GAP then
		SNH.debugLog("GEAR", ("skip: cooldown %.2fs"):format(GEAR_USE_GAP - (now - lastGearUseAt)))
		return false
	end

	local tp = SNH.safeTeleport
	local tpHome = SNH.returnToOwnGarden
	if not tp then
		SNH.debugLog("GEAR", "skip: no safeTeleport", "warn")
		return false
	end

	local _, plot = API.getLocalPlot()
	if not plot then
		SNH.debugLog("GEAR", "skip: no local plot", "warn")
		return false
	end

	local target = SNH.getBestPlantForGear(plot)
	if not target or not target.position then
		SNH.debugLog("GEAR", "skip: no best plant target (no plants / all near sprinkler / snap fail)", "warn")
		return false
	end

	local plotId = API.getLocalPlotId()
	if plotId == nil then plotId = LocalPlayer:GetAttribute("PlotId") end
	plotId = tonumber(plotId) or plotId

	local gearList = {}
	for _, gearName in ALL_GEAR do
		if SNH.shouldUseGear(gearName) then table.insert(gearList, gearName) end
	end
	if #gearList == 0 then
		SNH.debugLog("GEAR", "skip: no gear enabled in UseGearConfig", "warn")
		return false
	end
	table.sort(gearList, function(a, b) return SNH.getGearPrice(a) > SNH.getGearPrice(b) end)

	SNH.debugLog("GEAR", ("start target=%s pos=%s pivot=%s plotId=%s gears=%s"):format(
		target.seedName, SNH.fmtVec3(target.position), SNH.fmtVec3(target.plantPivot),
		tostring(plotId), table.concat(gearList, ", ")), "force")

	gearPlacingActive = true
	local ok, result = pcall(function()
		local placedAll = true
		local placedAny = false
		local teleportedForGear = false
		local pos = target.position

		for _, gearName in gearList do
			if not SNH.findGearTool(gearName) and not SNH.ensureGearOwnedOnce(gearName) then
				SNH.debugLog("GEAR", ("skip %s: no tool and equip failed"):format(gearName), "warn")
				placedAll = false
				continue
			end

			local st = SNH.getGearUseState(gearName)
			if st.lockedPos and st.lockedSeed and SNH.isNearSprinkler(plot, st.lockedPos) then
				SNH.debugLog("GEAR", ("reset %s: locked pos near sprinkler"):format(gearName))
				SNH.resetGearUseState(gearName)
				continue
			end
			if not st.lockedPos then
				st.lockedPos = pos
				st.lockedSeed = target.seedName
			else
				pos = st.lockedPos
			end

			local pivotBefore = pos
			if target.model and target.model.Parent then
				pos = SNH.getGearPlacePosition(plot, target.model) or pos
			elseif target.plantPivot then
				pos = SNH.snapToPlantArea(plot, target.plantPivot) or target.plantPivot
			else
				pos = SNH.snapToPlantArea(plot, pos) or pos
			end
			if not pos or not SNH.isValidGearPosition(plot, pos) then
				SNH.debugLog("GEAR", ("skip %s: invalid pos %s (was %s nearSprinkler=%s)"):format(
					gearName, SNH.fmtVec3(pos), SNH.fmtVec3(pivotBefore),
					tostring(pos and SNH.isNearSprinkler(plot, pos))), "warn")
				SNH.resetGearUseState(gearName)
				placedAll = false
				continue
			end
			st.lockedPos = pos

			local tool = SNH.equipGearForPlacement(gearName)
			if not tool or not tool.Parent then
				SNH.debugLog("GEAR", ("skip %s: equip failed"):format(gearName), "warn")
				placedAll = false
				continue
			end

			local countBefore = SNH.countGearInInventory(gearName)
			SNH.debugLog("GEAR", ("place %s @ %s tool=%s"):format(
				gearName, SNH.fmtVec3(pos), tool.Name), "force")
			local isSprinkler = tool:GetAttribute("Sprinkler") ~= nil
			if not isSprinkler then
				tp(pos + Vector3.new(0, 3, 0))
				teleportedForGear = true
			end

			if not SNH.fireGearAtPosition(tool, gearName, pos, plotId, plot) then
				SNH.debugLog("GEAR", ("fail %s: remote fire failed"):format(gearName), "warn")
				placedAll = false
				continue
			end

			task.wait(0.12)
			local countAfter = SNH.countGearInInventory(gearName)
			local consumed = countAfter < countBefore
			local verified = SNH.verifyGearPlaced(plot, gearName, pos, tool) or consumed
			if verified then
				placedAny = true
				SNH.resetGearUseState(gearName)
				SNH.invalidatePlotScanCaches(plot)
				SNH.setStatus(("Used %s on %s"):format(gearName, target.seedName))
				SNH.debugLog("GEAR", ("ok %s on %s (price %s)"):format(
					gearName, target.seedName, SNH.formatAbbrev(target.price)), "force")
			else
				SNH.debugLog("GEAR", ("fail %s: verify not placed (inHand=%s toolGone=%s count=%d->%d)"):format(
					gearName, tostring(SNH.isGearInHand(gearName)),
					tostring(tool and not tool.Parent), countBefore, countAfter), "warn")
				placedAll = false
			end
		end

		if placedAll and placedAny then
			SNH.unequipGearFromHand()
			lastGearUseAt = now
			if teleportedForGear and tpHome then tpHome() end
			return true
		end
		if placedAny then
			lastGearUseAt = now
		end
		return false
	end)
	gearPlacingActive = false
	if not ok then
		warn(("[So Nach Hup][UseGear] %s"):format(tostring(result)))
		SNH.debugLog("GEAR", ("pcall error: %s"):format(tostring(result)), "warn")
		return false
	end
	if not result then
		SNH.debugLog("GEAR", "finished: no gear placed this tick")
	end
	return result == true
end
end
tryUseGear = SNH.tryUseGear

do --[[ SNH: GearUseAll ]]
SNH.getGearKindFromTool = function(tool)
	if not tool or not tool:IsA("Tool") then return nil, nil end
	if tool:GetAttribute("Sprinkler") then return "sprinkler", tool:GetAttribute("Sprinkler") end
	if tool:GetAttribute("WateringCan") then return "wateringcan", tool:GetAttribute("WateringCan") end
	if tool:GetAttribute("Gnome") then return "gnome", tool:GetAttribute("Gnome") end
	if tool:GetAttribute("Rake") then return "rake", tool:GetAttribute("Rake") end
	if tool:GetAttribute("Build") then return "build", tool:GetAttribute("Build") end
	if tool:GetAttribute("Mushroom") then return "mushroom", tool:GetAttribute("Mushroom") end
	if tool:GetAttribute("Gear") then return "gear", tool:GetAttribute("Gear") end
	if tool:GetAttribute("Teleporter") then return "teleporter", tool:GetAttribute("Teleporter") or tool.Name end
	if tool.Name and SNH.gearToolMatches and SNH.gearToolMatches(tool, tool.Name) then
		return "gear", tool.Name
	end
	return nil, nil
end

SNH.isGearInventoryTool = function(item)
	if not item or not item:IsA("Tool") then return false end
	if item:GetAttribute("SeedTool") then return false end
	if item:GetAttribute("Fruit") or item:GetAttribute("FruitName") or item:GetAttribute("HarvestedFruit") then
		return false
	end
	if item:GetAttribute("Pet") or item:GetAttribute("PetName") then return false end
	if item:GetAttribute("Egg") or item:GetAttribute("Crate") then return false end
	if item:GetAttribute("Shovel") or item:GetAttribute("Trowel") or item:GetAttribute("Crowbar") then return false end
	if item:GetAttribute("Flashbang") or item:GetAttribute("Wheelbarrow") then return false end
	return SNH.getGearKindFromTool(item) ~= nil
end

SNH.listInventoryGearTools = function()
	local list, seen = {}, {}
	for _, bag in { LocalPlayer.Backpack, LocalPlayer.Character } do
		if not bag then continue end
		for _, item in bag:GetChildren() do
			if not SNH.isGearInventoryTool(item) then continue end
			local kind, gearName = SNH.getGearKindFromTool(item)
			if not gearName then continue end
			local key = kind .. "|" .. gearName .. "|" .. item:GetDebugId()
			if seen[key] then continue end
			seen[key] = true
			local price = SNH.getGearPrice(gearName)
			if price <= 0 and GearMeta[gearName] then
				price = GearMeta[gearName].price or 0
			end
			table.insert(list, {
				tool = item,
				kind = kind,
				name = gearName,
				price = price,
			})
		end
	end
	table.sort(list, function(a, b)
		if a.price ~= b.price then return a.price > b.price end
		return a.name < b.name
	end)
	return list
end

SNH.getGearPlaceOffsets = function()
	return {
		Vector3.zero,
		Vector3.new(2.2, 0, 0), Vector3.new(-2.2, 0, 0),
		Vector3.new(0, 0, 2.2), Vector3.new(0, 0, -2.2),
		Vector3.new(1.6, 0, 1.6), Vector3.new(-1.6, 0, 1.6),
		Vector3.new(1.6, 0, -1.6), Vector3.new(-1.6, 0, -1.6),
	}
end

SNH.pickGearPosition = function(plot, basePos, attemptIndex)
	if not plot or not basePos then return nil end
	local offsets = SNH.getGearPlaceOffsets()
	local start = ((tonumber(attemptIndex) or 0) % #offsets) + 1
	for i = 0, #offsets - 1 do
		local off = offsets[((start - 1 + i) % #offsets) + 1]
		local candidate = basePos + off
		local snapped = SNH.snapToPlantArea(plot, candidate) or candidate
		if SNH.isValidGearPosition(plot, snapped) then
			return snapped
		end
	end
	return SNH.snapToPlantArea(plot, basePos) or basePos
end

SNH.equipToolForPlacement = function(tool)
	if not tool or not tool:IsA("Tool") then return nil end
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not (char and hum and hum.Health > 0) then return nil end

	if not tool.Parent then
		local _, gearName = SNH.getGearKindFromTool(tool)
		tool = SNH.findGearTool(gearName or tool.Name)
		if not tool then return nil end
	end

	if tool.Parent ~= char and tool.Parent ~= LocalPlayer.Backpack then
		local _, gearName = SNH.getGearKindFromTool(tool)
		tool = SNH.findGearTool(gearName or tool.Name)
		if not tool then return nil end
	end

	pcall(hum.UnequipTools, hum)
	task.wait(0.06)

	if tool.Parent == LocalPlayer.Backpack then
		pcall(hum.EquipTool, hum, tool)
	elseif tool.Parent ~= char then
		tool.Parent = char
	end

	local deadline = os.clock() + 1.5
	while os.clock() < deadline do
		if not tool.Parent then return nil end
		if tool.Parent == char then
			local wantDesc = tool:GetAttribute("ToolDescendants")
			if type(wantDesc) ~= "number" or wantDesc <= #tool:GetDescendants() then
				return tool
			end
		end
		task.wait(0.05)
	end
	return tool.Parent == char and tool or nil
end

SNH.verifyGearUsed = function(kind, gearName, plot, pos, toolRef, countBefore)
	if kind == "mushroom" then
		if toolRef and not toolRef.Parent then return true end
		if not SNH.findGearTool(gearName) then return true end
		return false
	end
	if kind == "wateringcan" then
		return SNH.verifyGearPlaced(plot, gearName, pos, toolRef)
	end
	if SNH.verifyGearPlaced(plot, gearName, pos, toolRef) then return true end
	if kind == "sprinkler" and toolRef then
		local countAfter = tonumber(toolRef:GetAttribute("Count"))
		if countBefore and countAfter and countAfter < countBefore then return true end
		local fresh = SNH.findGearTool(gearName)
		if fresh then
			local freshCount = tonumber(fresh:GetAttribute("Count")) or 0
			if countBefore and freshCount < countBefore then return true end
		elseif countBefore and countBefore > 0 then
			return true
		end
	end
	local countAfter = SNH.countGearInInventory(gearName)
	if countBefore and countAfter < countBefore then return true end
	return false
end

-- Equip every gear tool in inventory and use it on/near your highest-price plant.
SNH.useAllInventoryGearOnBestPlant = function(options)
	options = typeof(options) == "table" and options or {}
	local teleport = options.teleport ~= false
	local goHome = options.returnHome ~= false
	local gap = tonumber(options.gap) or 0.18
	local verbose = options.verbose ~= false

	if not Networking then Networking = API.getNetworking() end
	if not Networking then
		warn("[So Nach Hup][GearAll] Networking not ready")
		return nil
	end

	local _, plot = API.getLocalPlot()
	if not plot then
		warn("[So Nach Hup][GearAll] No local plot")
		return nil
	end

	SNH.loadShopCatalog()
	local target = SNH.getBestPlantForGear(plot)
	if not target or not target.position then
		warn("[So Nach Hup][GearAll] No owned plant found for gear placement")
		return nil
	end

	local plotId = API.getLocalPlotId()
	if plotId == nil then plotId = LocalPlayer:GetAttribute("PlotId") end
	plotId = tonumber(plotId) or plotId

	local tools = SNH.listInventoryGearTools()
	if #tools == 0 then
		print("[So Nach Hup][GearAll] No usable gear in inventory")
		return { ok = 0, fail = 0, skipped = 0, target = target }
	end

	local basePos = SNH.getGearPlacePosition(plot, target.model) or target.position
	basePos = SNH.snapToPlantArea(plot, basePos) or basePos

	if verbose then
		print(("[So Nach Hup][GearAll] Target plant: %s (seed price %s) pivot %s place %s"):format(
			target.seedName,
			SNH.formatAbbrev(target.price),
			SNH.fmtVec3(target.plantPivot),
			SNH.fmtVec3(basePos)
		))
		print(("[So Nach Hup][GearAll] Found %d gear tool(s) in inventory"):format(#tools))
	end

	if gearPlacingActive then
		warn("[So Nach Hup][GearAll] Another gear placement is already running")
		return nil
	end
	gearPlacingActive = true

	local results = { ok = 0, fail = 0, skipped = 0, target = target, log = {} }
	local okAll, errAll = pcall(function()
		if teleport then
			SNH.safeTeleport(basePos + Vector3.new(0, 3, 0))
			task.wait(0.12)
		end

		local placeAttempt = 0
		for _, entry in tools do
			local gearName = entry.name
			local kind = entry.kind
			local tool = entry.tool
			if not (tool and tool.Parent) then
				tool = SNH.findGearTool(gearName)
			end
			if not tool or not tool.Parent then
				results.skipped += 1
				if verbose then
					print(("[So Nach Hup][GearAll] SKIP %s (not in inventory anymore)"):format(gearName))
				end
				continue
			end

			local pos = basePos
			if kind == "sprinkler" or kind == "gnome" or kind == "rake" or kind == "build" or kind == "gear" then
				pos = SNH.pickGearPosition(plot, basePos, placeAttempt)
				placeAttempt += 1
			elseif kind == "wateringcan" then
				pos = SNH.snapToPlantArea(plot, basePos) or basePos
			end

			if not pos then
				results.skipped += 1
				if verbose then print(("[So Nach Hup][GearAll] SKIP %s (no valid position)"):format(gearName)) end
				continue
			end

			local countBefore = SNH.countGearInInventory(gearName)
			tool = SNH.equipToolForPlacement(tool)
			if not tool then
				results.fail += 1
				if verbose then print(("[So Nach Hup][GearAll] FAIL %s (equip failed)"):format(gearName)) end
				continue
			end

			if teleport and kind ~= "mushroom" then
				SNH.safeTeleport(pos + Vector3.new(0, 2.5, 0))
				task.wait(0.06)
			end

			local fired = SNH.fireGearAtPosition(tool, gearName, pos, plotId, plot)
			if kind == "mushroom" then
				pcall(function() tool:Activate() end)
				fired = true
			end

			task.wait(gap)

			local success = fired and SNH.verifyGearUsed(kind, gearName, plot, pos, tool, countBefore)
			if success then
				results.ok += 1
				local line = ("[So Nach Hup][GearAll] SUCCESS %s (%s) -> %s @ %s"):format(
					gearName, kind, target.seedName, SNH.fmtVec3(pos))
				table.insert(results.log, line)
				if verbose then print(line) end
			else
				results.fail += 1
				local line = ("[So Nach Hup][GearAll] FAIL %s (%s) on %s"):format(gearName, kind, target.seedName)
				table.insert(results.log, line)
				if verbose then print(line) end
			end
		end

		SNH.unequipGearFromHand()
		if goHome and teleport and SNH.returnToOwnGarden then
			SNH.returnToOwnGarden()
		end
	end)

	gearPlacingActive = false
	if not okAll then
		warn(("[So Nach Hup][GearAll] Error: %s"):format(tostring(errAll)))
		return nil
	end

	print(("[So Nach Hup][GearAll] Done on %s | ok=%d fail=%d skipped=%d"):format(
		target.seedName, results.ok, results.fail, results.skipped))
	return results
end

SNH.isOnPlantArea = function(plot, position)
	if not plot or not position then return false end
	local areas = SNH.getPlantAreasInPlot(plot)
	if #areas == 0 then return false end
	local plantAreaOnly = CollectionService:HasTag(areas[1], "PlantArea")
	if not plantAreaOnly then return false end
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Include
	params.FilterDescendantsInstances = areas
	local probe = Vector3.new(position.X, position.Y + 25, position.Z)
	local hit = workspace:Raycast(probe, Vector3.new(0, -500, 0), params)
	if not hit or not hit.Instance:IsDescendantOf(plot) then return false end
	return CollectionService:HasTag(hit.Instance, "PlantArea")
end

SNH.findOwnedSeedPlant = function(plot, seedName)
	if not plot or not seedName then return nil end
	local plants = plot:FindFirstChild("Plants")
	if not plants then return nil end
	for _, inst in plants:GetDescendants() do
		if not inst:IsA("Model") or not inst:GetAttribute("PlantId") then continue end
		local uid = tonumber(inst:GetAttribute("UserId"))
		if uid and uid ~= LocalPlayer.UserId then continue end
		local seed = inst:GetAttribute("SeedName") or inst:GetAttribute("CorePartName")
		if seed == seedName then return inst end
	end
	return nil
end

SNH.getSprinklerStackCount = function(gearName)
	local total = 0
	for _, bag in { LocalPlayer.Backpack, LocalPlayer.Character } do
		if not bag then continue end
		for _, item in bag:GetChildren() do
			if not item:IsA("Tool") then continue end
			if item:GetAttribute("Sprinkler") ~= gearName and item.Name ~= gearName then continue end
			total += tonumber(item:GetAttribute("Count")) or 1
		end
	end
	return total
end

SNH.listSprinklerTools = function(gearName, maxCount)
	local list = {}
	for _, bag in { LocalPlayer.Backpack, LocalPlayer.Character } do
		if not bag then continue end
		for _, item in bag:GetChildren() do
			if not item:IsA("Tool") then continue end
			local name = item:GetAttribute("Sprinkler")
			if name == gearName then
				table.insert(list, item)
				if #list >= maxCount then return list end
			end
		end
	end
	return list
end

SNH.pickSprinklerPositionsNear = function(plot, centerPos, count)
	local valid, used = {}, {}
	for i = 1, count do
		local a = (i - 1) * (math.pi * 2 / math.max(count, 1))
		local raw = centerPos + Vector3.new(math.cos(a) * 1.25, 0, math.sin(a) * 1.25)
		local pos = SNH.snapToPlantArea(plot, raw)
		if not pos or not SNH.isOnPlantArea(plot, pos) then continue end
		if not SNH.isValidGearPosition(plot, pos) then continue end
		local dup = false
		for _, p in used do
			if (Vector2.new(pos.X, pos.Z) - Vector2.new(p.X, p.Z)).Magnitude < 1.05 then dup = true break end
		end
		if dup then continue end
		table.insert(valid, pos)
		table.insert(used, pos)
	end
	return valid
end

-- Place sprinklers on highest seed-value plant (or options.seed) via remote only. PlantArea only.
SNH.placeSprinklersOnPlant = function(options)
	options = typeof(options) == "table" and options or {}
	local gearName = options.gear or "Common Sprinkler"
	local wantCount = tonumber(options.count) or 3
	local gap = tonumber(options.gap) or 0.55

	if not Networking then Networking = API.getNetworking() end
	if not Networking then warn("[So Nach Hup][Gear] no networking") return nil end

	local _, plot = API.getLocalPlot()
	if not plot then warn("[So Nach Hup][Gear] no plot") return nil end
	if #SNH.getPlantAreasInPlot(plot) == 0 then
		warn("[So Nach Hup][Gear] no PlantArea in plot")
		return nil
	end

	local seedName, centerPos, plantModel, seedPrice
	if type(options.seed) == "string" and options.seed ~= "" then
		seedName = options.seed
		plantModel = SNH.findOwnedSeedPlant(plot, seedName)
		if not plantModel then
			warn(("[So Nach Hup][Gear] no owned %s"):format(seedName))
			return nil
		end
		centerPos = SNH.getGearPlacePosition(plot, plantModel)
		seedPrice = SNH.getSeedPrice(seedName)
	else
		local target = SNH.getBestPlantForGear(plot)
		if not target or not target.position then
			warn("[So Nach Hup][Gear] no valid plant on PlantArea in plot")
			return nil
		end
		seedName = target.seedName
		centerPos = target.position
		plantModel = target.model
		seedPrice = target.price or SNH.getSeedPrice(seedName)
	end

	if not centerPos or not SNH.isOnPlantArea(plot, centerPos) then
		warn(("[So Nach Hup][Gear] %s not on PlantArea"):format(seedName))
		return nil
	end

	local have = SNH.getSprinklerStackCount(gearName)
	if have < 1 then
		warn(("[So Nach Hup][Gear] no %s in inventory"):format(gearName))
		return nil
	end
	if have < wantCount then
		warn(("[So Nach Hup][Gear] only %d/%d %s"):format(have, wantCount, gearName))
	end

	local placeCount = math.min(wantCount, have)
	local positions = SNH.pickSprinklerPositionsNear(plot, centerPos, placeCount)
	if #positions == 0 then
		warn("[So Nach Hup][Gear] no valid in-garden sprinkler spots")
		return nil
	end
	if #positions < placeCount then placeCount = #positions end

	local plotId = SNH.getPlotIdFromPlot(plot)
	print(("[So Nach Hup][Gear] best=%s price=%s @ %s | remote place %d x %s (have=%d)"):format(
		seedName, SNH.formatAbbrev(seedPrice or 0), SNH.fmtVec3(centerPos), placeCount, gearName, have))

	local ok, fail = 0, 0
	for i = 1, placeCount do
		local tool = SNH.findGearTool(gearName)
		if not tool then
			fail += 1
			print(("[So Nach Hup][Gear] FAIL %s #%d — no tool left"):format(gearName, i))
			break
		end

		local countBefore = tonumber(tool:GetAttribute("Count")) or 1
		local equipped = SNH.equipToolForPlacement(tool)
		if not equipped then
			fail += 1
			print(("[So Nach Hup][Gear] FAIL equip %s #%d"):format(gearName, i))
			continue
		end

		local fired, exactPos = SNH.fireSprinklerRemote(equipped, gearName, plot, positions[i], plotId)
		task.wait(gap)

		local checkPos = exactPos or positions[i]
		if fired and SNH.verifyGearUsed("sprinkler", gearName, plot, checkPos, equipped, countBefore) then
			ok += 1
			SNH.invalidatePlotScanCaches(plot)
			print(("[So Nach Hup][Gear] SUCCESS %s #%d on %s @ %s"):format(
				gearName, i, seedName, SNH.fmtVec3(checkPos)))
		else
			fail += 1
			print(("[So Nach Hup][Gear] FAIL %s #%d on %s @ %s"):format(
				gearName, i, seedName, SNH.fmtVec3(checkPos)))
		end
	end

	SNH.unequipGearFromHand()
	print(("[So Nach Hup][Gear] Done %s on %s | ok=%d fail=%d"):format(gearName, seedName, ok, fail))
	return { ok = ok, fail = fail, seed = seedName, gear = gearName, price = seedPrice, center = centerPos }
end

end
useAllInventoryGearOnBestPlant = SNH.useAllInventoryGearOnBestPlant
placeSprinklersOnPlant = SNH.placeSprinklersOnPlant

do --[[ SNH: WildPet ]]
SNH.registerPetMeta = function(key, entry)
	if type(key) ~= "string" or type(entry) ~= "table" then return end
	local display = entry.DisplayName or key
	PetKeyByDisplay[display] = key
	PetKeyByDisplay[key] = key
	PetDisplayByKey[key] = display
	PetMeta[key] = {
		DisplayName = display,
		Rarity = entry.Rarity or "Common",
		SpawnChance = entry.SpawnChance or 0,
		BasePrice = entry.BasePrice or 0,
		Image = entry.Image or "",
	}
end

SNH.loadPetCatalog = function()
	for key, entry in FALLBACK_PET_META do
		SNH.registerPetMeta(key, entry)
	end
	pcall(function()
		local sharedData = ReplicatedStorage:FindFirstChild("SharedData")
		local petData = sharedData and require(sharedData:WaitForChild("PetData"))
		if type(petData) ~= "table" then return end
		for key, entry in petData do
			if type(entry) == "table" and entry.DisplayName then
				SNH.registerPetMeta(key, entry)
			end
		end
	end)
	SNH.loadRarityRanks()
	pcall(function()
		local shared = ReplicatedStorage:FindFirstChild("SharedModules")
		local gearImages = shared and shared:FindFirstChild("GearImages")
		if not gearImages then return end
		local function readGearImage(name)
			if type(name) ~= "string" or name == "" then return nil end
			local img = gearImages:FindFirstChild(name)
			if img and img:IsA("StringValue") and img.Value ~= "" then
				return img.Value
			end
			return nil
		end
		for key, meta in PetMeta do
			if type(meta) ~= "table" or (meta.Image and meta.Image ~= "") then
				continue
			end
			local display = meta.DisplayName or PetDisplayByKey[key] or key
			local spaced = key:gsub("(%l)(%u)", "%1 %2")
			for _, name in { display, spaced, key } do
				local val = readGearImage(name)
				if val then
					meta.Image = val
					break
				end
			end
		end
	end)
	SNH.rebuildPetBuyOrder()
end

-- Seed/shop rarity order from game RarityData.Gradients (does not change pet equip ranks).
SNH.loadRarityRanks = function()
	local order = { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Super", "Secret" }
	pcall(function()
		local shared = ReplicatedStorage:FindFirstChild("SharedModules")
		local rarityData = shared and shared:FindFirstChild("RarityData")
		local grads = rarityData and rarityData:FindFirstChild("Gradients")
		if grads then
			local fromGame = {}
			for _, child in grads:GetChildren() do
				table.insert(fromGame, child.Name)
			end
			if #fromGame > 0 then
				order = fromGame
			end
		end
	end)
	for i, name in order do
		RARITY_RANK[name] = i
	end
end

SNH.rebuildPetBuyOrder = function()
	table.clear(PET_BUY_ORDER)
	local list = {}
	for key, meta in PetMeta do
		if type(meta) == "table" then
			local rarity = meta.Rarity or "Common"
			if PET_RARITY_ENABLED[rarity] == false then
				continue
			end
			table.insert(list, {
				key = key,
				rank = SNH.petRarityRank(key) or 0,
				price = meta.BasePrice or 0,
			})
		end
	end
	table.sort(list, function(a, b)
		-- rarest first
		if a.rank ~= b.rank then return a.rank > b.rank end
		if a.price ~= b.price then return a.price < b.price end
		return a.key < b.key
	end)
	for _, entry in list do
		table.insert(PET_BUY_ORDER, entry.key)
	end
	table.clear(WILD_PET_COLLECT_ORDER)
	for i = #list, 1, -1 do
		table.insert(WILD_PET_COLLECT_ORDER, list[i].key)
	end
end

SNH.getWildPetProgress = function()
	for _, petKey in WILD_PET_COLLECT_ORDER do
		local owned = SNH.countOwnedPet(petKey)
		if owned < WILD_PET_BUY_EACH then
			return petKey, WILD_PET_BUY_EACH - owned
		end
	end
	for _, petKey in PET_BUY_ORDER do
		local owned = SNH.countOwnedPet(petKey)
		if owned < WILD_PET_BUY_EACH then
			return petKey, WILD_PET_BUY_EACH - owned
		end
	end
	return nil, 0
end

SNH.resolvePetKey = function(name)
	if type(name) ~= "string" or name == "" then return nil end
	if PetKeyByDisplay[name] then return PetKeyByDisplay[name] end
	local compact = name:gsub(" ", "")
	return PetKeyByDisplay[compact] or compact
end

SNH.getPetReplica = function()
	local psc = SNH.getPlayerStateClient and SNH.getPlayerStateClient()
	if not psc or not psc.GetLocalReplica then return nil end
	return psc:GetLocalReplica()
end

SNH.petNameMatches = function(petName, petKey)
	if type(petName) ~= "string" or petName == "" then return false end
	local key = SNH.resolvePetKey(petKey) or petKey
	local resolved = SNH.resolvePetKey(petName) or petName
	if resolved == key then return true end
	local display = PetDisplayByKey[key]
	if display and (petName == display or SNH.resolvePetKey(display) == key) then return true end
	return string.lower(petName) == string.lower(tostring(key))
end

SNH.getPetInventoryCount = function(petKey)
	if not petKey then return 0 end
	local key = SNH.resolvePetKey(petKey) or petKey
	local replica = SNH.getPetReplica()
	local inventory = replica and replica.Data and replica.Data.Inventory
	if type(inventory) ~= "table" then return 0 end
	local folder = PET_INVENTORY_FOLDERS[key]
	if folder then
		local bucket = inventory[folder]
		if type(bucket) == "table" then
			return tonumber(bucket[key]) or 0
		end
		return 0
	end
	local pets = inventory.Pets
	if type(pets) == "table" then
		return tonumber(pets[key]) or 0
	end
	return 0
end

SNH.getOwnedPetKeys = function()
	local keys, seen = {}, {}
	local function add(rawKey)
		if type(rawKey) ~= "string" or rawKey == "" then return end
		local key = SNH.resolvePetKey(rawKey) or rawKey
		if seen[key] then return end
		seen[key] = true
		table.insert(keys, key)
	end

	local replica = SNH.getPetReplica()
	if replica and type(replica.Data) == "table" then
		if type(replica.Data.Pets) == "table" then
			for _, pet in replica.Data.Pets do
				if type(pet) == "table" then
					add(pet.PetName or pet.Name)
				end
			end
		end
		local inventory = replica.Data.Inventory
		if type(inventory) == "table" then
			local pets = inventory.Pets
			if type(pets) == "table" then
				for petKey, count in pets do
					if (tonumber(count) or 0) > 0 then add(petKey) end
				end
			end
			for petKey, folderName in PET_INVENTORY_FOLDERS do
				local bucket = inventory[folderName]
				if type(bucket) == "table" and (tonumber(bucket[petKey]) or 0) > 0 then
					add(petKey)
				end
			end
		end
	end

	for _, container in { LocalPlayer.Character, LocalPlayer.Backpack } do
		if not container then continue end
		for _, item in container:GetChildren() do
			if item:IsA("Tool") then
				add(item:GetAttribute("Pet") or item:GetAttribute("PetName"))
			end
		end
	end
	return keys
end

SNH.canEquipPet = function(petKey)
	if not petKey then return false end
	local key = SNH.resolvePetKey(petKey) or petKey
	if SNH.countOwnedPet(key) > 0 then return true end
	if SNH.findPetTool(key, nil) then return true end

	local replica = SNH.getPetReplica()
	local pets = replica and replica.Data and replica.Data.Pets
	if type(pets) == "table" then
		for _, pet in pets do
			if type(pet) ~= "table" then continue end
			local name = pet.PetName or pet.Name
			if SNH.petNameMatches(name, key) then return true end
		end
	end

	for _, container in { LocalPlayer.Character, LocalPlayer.Backpack } do
		if not container then continue end
		for _, item in container:GetChildren() do
			if not item:IsA("Tool") then continue end
			local toolPet = item:GetAttribute("Pet") or item:GetAttribute("PetName")
			if SNH.petNameMatches(toolPet, key) then return true end
		end
	end
	return false
end

SNH.countOwnedPet = function(petKey)
	if not petKey then return 0 end
	local key = SNH.resolvePetKey(petKey) or petKey
	local count = SNH.getPetInventoryCount(key)
	local replica = SNH.getPetReplica()
	if replica and replica.Data and type(replica.Data.Pets) == "table" then
		for _, pet in replica.Data.Pets do
			if type(pet) ~= "table" then continue end
			local name = pet.PetName or pet.Name
			if SNH.petNameMatches(name, key) then count += 1 end
		end
	end
	for _, container in { LocalPlayer.Character, LocalPlayer.Backpack } do
		if not container then continue end
		for _, item in container:GetChildren() do
			if not item:IsA("Tool") then continue end
			local toolPet = item:GetAttribute("Pet") or item:GetAttribute("PetName")
			if SNH.petNameMatches(toolPet, key) then count += 1 end
		end
	end
	return count
end

SNH.getWildPetBuyTarget = function(petKey)
	if not petKey then return 0 end
	local display = PetDisplayByKey[petKey] or petKey
	local resolved = SNH.resolvePetKey(petKey) or petKey
	local candidates = { petKey, display, resolved, petKey:gsub(" ", ""), display:gsub(" ", "") }
	for _, key in candidates do
		local n = BuyPetsConfig[key]
		if n and n > 0 then return n end
	end
	for cfgKey, n in BuyPetsConfig do
		if n > 0 then
			local cfgResolved = SNH.resolvePetKey(cfgKey) or cfgKey
			if cfgResolved == resolved or cfgKey == petKey or cfgKey == display then
				return n
			end
		end
	end
	local wantKey, need = SNH.getWildPetProgress()
	if not wantKey or need <= 0 then return 0 end
	if resolved == wantKey or petKey == wantKey then return need end
	return 0
end

SNH.getWildPetRefs = function()
	local map = workspace:FindFirstChild("Map")
	local refs, seen = {}, {}
	local function addRef(part, petNameOverride)
		if not part or not part:IsA("BasePart") then return end
		local petName = part:GetAttribute("PetName") or petNameOverride
		if type(petName) ~= "string" or petName == "" then return end
		if seen[part] then return end
		seen[part] = true
		table.insert(refs, part)
	end
	local folder = map and map:FindFirstChild("WildPetRef")
	if folder then
		for _, child in folder:GetChildren() do
			addRef(child)
		end
	end
	local spawns = map and map:FindFirstChild("WildPetSpawns")
	if spawns then
		for _, model in spawns:GetChildren() do
			if model:IsA("Model") then
				local petName = model:GetAttribute("PetName")
				if type(petName) == "string" and petName ~= "" then
					local ref = model:FindFirstChild("WildPetRef", true)
						or model.PrimaryPart
						or model:FindFirstChildWhichIsA("BasePart", true)
					if ref and ref:IsA("BasePart") then
						addRef(ref, petName)
					end
				end
			elseif model:IsA("BasePart") then
				addRef(model)
			end
		end
	end
	if folder then
		for _, child in folder:GetDescendants() do
			if child:IsA("BasePart") and child:GetAttribute("PetName") then
				addRef(child)
			end
		end
	end
	return refs
end

SNH.resolveWildPetTameRef = function(ref)
	if not ref or not ref.Parent then return nil end
	local map = workspace:FindFirstChild("Map")
	local folder = map and map:FindFirstChild("WildPetRef")
	if folder and ref:IsDescendantOf(folder) and ref:IsA("BasePart") then
		return ref
	end
	if folder then
		local byName = folder:FindFirstChild(ref.Name)
		if byName and byName:IsA("BasePart") then
			return byName
		end
		local petName = ref:GetAttribute("PetName")
		if not petName and ref.Parent and ref.Parent:IsA("Model") then
			petName = ref.Parent:GetAttribute("PetName")
		end
		if ref.Parent and ref.Parent:IsA("Model") then
			local suffix = ref.Parent.Name:match("^WildPet_[^_]+_(.+)$")
			if suffix then
				local exact = folder:FindFirstChild(suffix)
				if exact and exact:IsA("BasePart") then
					return exact
				end
			end
		end
		if type(petName) == "string" and petName ~= "" then
			local best, bestDist = nil, math.huge
			for _, child in folder:GetChildren() do
				if not child:IsA("BasePart") then continue end
				if child:GetAttribute("PetName") ~= petName then continue end
				local dist = (child.Position - ref.Position).Magnitude
				if dist < bestDist then
					bestDist = dist
					best = child
				end
			end
			if best and bestDist < 24 then
				return best
			end
		end
	end
	if ref:IsA("BasePart") and ref:GetAttribute("PetName") then
		return ref
	end
	return nil
end

SNH.getWildPetBuyPrompt = function(ref)
	ref = SNH.resolveWildPetTameRef(ref) or ref
	if not ref then return nil, nil end
	return SNH.findWildPetBuyPrompt(ref)
end

SNH.fireWildPetTameRemote = function(ref)
	ref = SNH.resolveWildPetTameRef(ref)
	if not ref or not ref.Parent then return false end
	if not Networking or not Networking.Pets or not Networking.Pets.WildPetTame then return false end
	local ownerId = ref:GetAttribute("OwnerUserId")
	if ownerId and tonumber(ownerId) == LocalPlayer.UserId then
		return true
	end
	local ok = false
	pcall(function()
		Networking.Pets.WildPetTame:Fire(ref)
		ok = true
	end)
	return ok
end

SNH.waitForWildPetTameSuccess = function(ref, petKey, beforeOwned, timeout)
	timeout = tonumber(timeout) or 5
	ref = SNH.resolveWildPetTameRef(ref) or ref
	petKey = SNH.resolvePetKey(petKey) or petKey
	beforeOwned = tonumber(beforeOwned) or SNH.countOwnedPet(petKey)
	local deadline = tick() + timeout
	local signaled = false
	local conn
	if Networking and Networking.Pets and Networking.Pets.WildPetTameResult then
		conn = Networking.Pets.WildPetTameResult.OnClientEvent:Connect(function(tameRef, userId)
			if userId ~= LocalPlayer.UserId then return end
			local resolved = SNH.resolveWildPetTameRef(tameRef) or tameRef
			local want = SNH.resolveWildPetTameRef(ref) or ref
			if resolved == want or tameRef == want then
				signaled = true
			end
		end)
	end
	-- In prompt-only mode the pet walks to the garden before it lands in inventory, so the
	-- ONLY definitive success is the inventory count going up. The tame-result signal and the
	-- spawn model disappearing just mean "tame started" — we keep waiting for the inventory gain.
	local promptOnly = WILD_PET_USE_PROMPT_ONLY == true
	while tick() < deadline do
		if SNH.countOwnedPet(petKey) > beforeOwned then
			if conn then conn:Disconnect() end
			return true
		end
		if not promptOnly then
			if signaled then
				if conn then conn:Disconnect() end
				return true
			end
			if ref and not ref.Parent then
				if conn then conn:Disconnect() end
				return SNH.countOwnedPet(petKey) > beforeOwned
			end
		end
		task.wait(0.05)
	end
	if conn then conn:Disconnect() end
	return SNH.countOwnedPet(petKey) > beforeOwned
end

-- Press "E" on the wild pet's BuyPrompt: force HoldDuration = 0 so it triggers instantly,
-- then fire it. This is exactly what walking up and pressing E does — the server starts the
-- pet walking to your garden. No WildPetTame remote is used.
SNH.fireWildPetBuyPrompt = function(ref)
	local buyPrompt = select(1, SNH.getWildPetBuyPrompt(ref))
	if not buyPrompt then return false end
	local fired = false
	pcall(function()
		buyPrompt.HoldDuration = 0
		buyPrompt.RequiresLineOfSight = false
		buyPrompt.Enabled = true
		buyPrompt.MaxActivationDistance = math.max(WILD_PET_BUY_RANGE, math.min(32, PROMPT_RANGE_MAX))
		if typeof(fireproximityprompt) == "function" then
			-- HoldDuration is 0 so a single trigger completes the "press E" instantly.
			fireproximityprompt(buyPrompt)
		else
			buyPrompt:InputHoldBegin()
			task.wait(0.05)
			buyPrompt:InputHoldEnd()
		end
		fired = true
	end)
	return fired
end

SNH.getWildPetStandPosition = function(ref)
	local buyPrompt, visualModel = SNH.getWildPetBuyPrompt(ref)
	if visualModel and visualModel.Parent then
		local anchor = buyPrompt and buyPrompt.Parent
		local pos = (anchor and anchor:IsA("BasePart") and anchor.Position) or visualModel:GetPivot().Position
		return pos + Vector3.new(0, 2.5, 0), buyPrompt, visualModel
	end
	ref = SNH.resolveWildPetTameRef(ref) or ref
	if ref and ref.Parent then
		return ref.Position + Vector3.new(0, 3, 0), buyPrompt, visualModel
	end
	return nil, buyPrompt, visualModel
end

SNH.teleportToWildPet = function(ref)
	local pos = SNH.getWildPetStandPosition(ref)
	if not pos then return false end
	local ok = SNH.safeTeleport(pos, { radius = WILD_PET_BUY_RANGE + 4, allowFast = true })
	if ok and WILD_PET_TP_SETTLE > 0 then
		task.wait(WILD_PET_TP_SETTLE)
	end
	return ok
end

-- Safe snap onto the pet's CURRENT position (it wanders), keeping the character grounded
-- and velocity zeroed so we don't fling. Used to "follow" the pet while pressing E.
SNH.followWildPetStep = function(ref)
	local pos = SNH.getWildPetStandPosition(ref)
	if not pos then return false end
	local character = LocalPlayer.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local hum = character and character:FindFirstChildOfClass("Humanoid")
	if not (root and hum and hum.Health > 0) then return false end
	pcall(function()
		root.CFrame = CFrame.new(pos)
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
		hum.PlatformStand = false
	end)
	return true
end

SNH.attemptWildPetRemoteBuy = function(ref, petKey, beforeOwned, rounds)
	rounds = math.max(1, tonumber(rounds) or 4)
	ref = SNH.resolveWildPetTameRef(ref)
	if not ref then return false end
	for i = 1, rounds do
		if not ref.Parent then
			return SNH.countOwnedPet(petKey) > beforeOwned
		end
		if SNH.fireWildPetTameRemote(ref) then
			SNH.debugLog("WILD_PET", ("remote tame try %d/%d ref=%s"):format(i, rounds, ref.Name), "force")
		end
		if SNH.waitForWildPetTameSuccess(ref, petKey, beforeOwned, 2.5) then
			return true
		end
		task.wait(0.12)
	end
	return false
end

-- Prompt-only wild pet buy: FOLLOW the wandering pet (re-teleport onto it), keep its
-- BuyPrompt instant (HoldDuration 0) and press E every step until the tame registers.
-- Once tamed the pet walks to your garden; success = it lands in your inventory.
-- No WildPetTame remote is fired.
SNH.attemptWildPetBuy = function(ref, petKey, beforeOwned)
	ref = SNH.resolveWildPetTameRef(ref) or ref
	if not ref then return false end
	petKey = SNH.resolvePetKey(petKey) or petKey
	beforeOwned = tonumber(beforeOwned) or SNH.countOwnedPet(petKey)
	local walkWait = math.max(2, tonumber(WILD_PET_WALK_WAIT) or 12)

	-- Phase 1 — chase the pet and press E until the spawn prompt disappears (tame accepted)
	-- or it lands in inventory, or we run out of follow time.
	local followGap = math.max(0.05, tonumber(WILD_PET_FOLLOW_GAP) or 0.2)
	local followDeadline = tick() + math.max(2, tonumber(WILD_PET_FOLLOW_TIMEOUT) or 8)
	local pressCount = 0
	while WILD_PET_FOLLOW ~= false and tick() < followDeadline do
		if SNH.countOwnedPet(petKey) > beforeOwned then return true end
		local prompt = select(1, SNH.findWildPetBuyPrompt(SNH.resolveWildPetTameRef(ref) or ref))
		-- Prompt/model gone => tame accepted, pet is walking home. Move to phase 2.
		if not prompt then break end
		-- Follow the pet to its current position, then press E.
		SNH.followWildPetStep(ref)
		SNH.fireWildPetBuyPrompt(ref)
		pressCount += 1
		if pressCount == 1 or pressCount % 10 == 0 then
			SNH.debugLog("WILD_PET", ("follow+E x%d ref=%s"):format(pressCount, ref.Name), "force")
		end
		task.wait(followGap)
	end

	-- Phase 2 — wait for the tamed pet to walk to the garden and appear in inventory.
	if SNH.waitForWildPetTameSuccess(ref, petKey, beforeOwned, walkWait) then
		return true
	end
	return SNH.countOwnedPet(petKey) > beforeOwned
end

SNH.findWildPetBuyPrompt = function(ref)
	if not ref then return nil, nil end
	ref = SNH.resolveWildPetTameRef(ref) or ref
	local map = workspace:FindFirstChild("Map")
	local spawns = map and map:FindFirstChild("WildPetSpawns")
	if not spawns then return nil, nil end
	local petName = ref:GetAttribute("PetName")
	if type(petName) == "string" and petName ~= "" then
		local exact = spawns:FindFirstChild(("WildPet_%s_%s"):format(petName, ref.Name))
		if exact and exact:IsA("Model") then
			local prompt = exact:FindFirstChild("BuyPrompt", true)
			if prompt and prompt:IsA("ProximityPrompt") then
				return prompt, exact
			end
		end
	end
	local bestPrompt, bestDist, bestModel = nil, math.huge, nil
	for _, model in spawns:GetChildren() do
		if model:IsA("Model") then
			local prompt = model:FindFirstChild("BuyPrompt", true)
			if prompt and prompt:IsA("ProximityPrompt") then
				local dist = (model:GetPivot().Position - ref.Position).Magnitude
				if dist < bestDist then
					bestDist, bestPrompt, bestModel = dist, prompt, model
				end
			end
		end
	end
	if bestPrompt and bestDist < 80 then
		return bestPrompt, bestModel
	end
	return nil, nil
end

SNH.httpPostJson = function(url, payload)
	if url == "" then return false end
	local body = HttpService:JSONEncode(payload)
	local ok = false
	pcall(function()
		if syn and syn.request then
			syn.request({ Url = url, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = body })
			ok = true
		elseif typeof(request) == "function" then
			request({ Url = url, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = body })
			ok = true
		else
			HttpService:PostAsync(url, body, Enum.HttpContentType.ApplicationJson)
			ok = true
		end
	end)
	return ok
end

SNH.formatWebhookPrice = function(amount)
	local n = tonumber(amount) or 0
	if n >= 1e9 then return string.format("%.2fB", n / 1e9) end
	if n >= 1e6 then return string.format("%.2fM", n / 1e6) end
	if n >= 1e3 then return string.format("%.2fK", n / 1e3) end
	return tostring(math.floor(n))
end

SNH.formatWebhookOneIn = function(chancePercent)
	local c = tonumber(chancePercent) or 0
	if c <= 0 then return "?"
	end
	return tostring(math.max(1, math.floor(100 / c + 0.5)))
end

SNH.formatFoundWebhookTitle = function(name, chancePercent)
	local compact = tostring(name or "Unknown"):gsub(" ", "")
	return ("%s Found! (1 in %s)"):format(compact, SNH.formatWebhookOneIn(chancePercent))
end

SNH.buildFoundWebhookDescription = function(rarity, size, price)
	return ("Rarity: **%s**\nSize: **%s**\nPrice: **%s**"):format(
		tostring(rarity or "Unknown"),
		tostring(size or "Normal"),
		SNH.formatWebhookPrice(price)
	)
end

SNH.parseRbxAssetId = function(raw)
	if type(raw) ~= "string" or raw == "" then return nil end
	local id = raw:match("rbxassetid://(%d+)") or raw:match("^(%d+)$")
	return id and tonumber(id) or nil
end

SNH.getDiscordThumbnailUrl = function(assetRaw)
	if assetRaw == nil then return nil end
	if type(assetRaw) == "string" then
		local raw = assetRaw:match("^%s*(.-)%s*$")
		if raw:match("^https?://") then
			return raw
		end
	end
	local id = type(assetRaw) == "number" and assetRaw or SNH.parseRbxAssetId(tostring(assetRaw))
	if not id or id <= 0 then return nil end
	return ("https://www.roblox.com/asset-thumbnail/image?assetId=%d&width=128&height=128&format=png"):format(id)
end

SNH.getWebhookWikiImage = function(...)
	for i = 1, select("#", ...) do
		local key = select(i, ...)
		if type(key) == "string" and key ~= "" then
			local url = WEBHOOK_WIKI_IMAGES[key]
			if url then return url end
			local compact = key:gsub(" ", "")
			url = WEBHOOK_WIKI_IMAGES[compact]
			if url then return url end
		end
	end
	return nil
end

SNH.getWebhookRarityColor = function(rarity)
	local color = WEBHOOK_RARITY_COLORS[tostring(rarity or "")]
	if color then return color end
	return WEBHOOK_FOUND_COLOR or 3066993
end

SNH._petDataModule = nil
SNH.getPetDataModule = function()
	if SNH._petDataModule ~= nil then
		return SNH._petDataModule ~= false and SNH._petDataModule or nil
	end
	SNH._petDataModule = false
	pcall(function()
		local sharedData = ReplicatedStorage:FindFirstChild("SharedData")
		local petData = sharedData and sharedData:FindFirstChild("PetData")
		if petData then
			local mod = require(petData)
			if type(mod) == "table" then
				SNH._petDataModule = mod
			end
		end
	end)
	return SNH._petDataModule ~= false and SNH._petDataModule or nil
end

SNH.readGearImagesValue = function(name)
	if type(name) ~= "string" or name == "" then return "" end
	local shared = ReplicatedStorage:FindFirstChild("SharedModules")
	local gearImages = shared and shared:FindFirstChild("GearImages")
	if not gearImages then return "" end
	local img = gearImages:FindFirstChild(name)
	if img and img:IsA("StringValue") and img.Value ~= "" then
		return img.Value
	end
	return ""
end

SNH.getPetImageAsset = function(petKey, petSize)
	petKey = SNH.resolvePetKey(petKey) or petKey
	local meta = PetMeta[petKey] or FALLBACK_PET_META[petKey] or {}
	local display = PetDisplayByKey[petKey] or meta.DisplayName or petKey
	local petData = SNH.getPetDataModule()
	if petData and type(petData.GetSpeciesDisplayName) == "function" then
		local ok, speciesName = pcall(petData.GetSpeciesDisplayName, petKey)
		if ok and type(speciesName) == "string" and speciesName ~= "" then
			display = speciesName
		end
	end
	if type(petSize) == "string" and string.lower(petSize) == "mega" then
		local mega = SNH.getWebhookWikiImage("Mega", "Mega Type Pet")
		if mega then return mega end
	end
	local wiki = SNH.getWebhookWikiImage(petKey, display, petKey:gsub("(%l)(%u)", "%1 %2"))
	if wiki then return wiki end
	if type(petSize) == "string" and petSize ~= "" and string.lower(petSize) ~= "normal" then
		local sized = SNH.readGearImagesValue(("%s %s"):format(petSize, display))
		if sized ~= "" then return sized end
	end
	if petData and type(petData.GetImage) == "function" then
		local ok, img = pcall(petData.GetImage, petKey, petSize)
		if ok and type(img) == "string" and img ~= "" then
			return img
		end
	end
	if type(meta.Image) == "string" and meta.Image ~= "" then
		return meta.Image
	end
	for _, name in { display, petKey:gsub("(%l)(%u)", "%1 %2"), petKey } do
		local img = SNH.readGearImagesValue(name)
		if img ~= "" then return img end
	end
	return ""
end

SNH.getSeedImageAsset = function(seedName)
	local wiki = SNH.getWebhookWikiImage(seedName, ("%s Seed"):format(tostring(seedName)))
	if wiki then return wiki end
	local meta = SeedMeta[seedName]
	if meta and type(meta.image) == "string" and meta.image ~= "" then
		return meta.image
	end
	-- Fall back to GearImages asset id by seed name (and "<Seed> Seed" variants).
	for _, name in { seedName, ("%s Seed"):format(tostring(seedName)) } do
		local img = SNH.readGearImagesValue(name)
		if img ~= "" then return img end
	end
	return ""
end

SNH.getGearImageAsset = function(gearName)
	for _, name in { gearName, tostring(gearName) } do
		local img = SNH.readGearImagesValue(name)
		if img ~= "" then return img end
	end
	local wiki = SNH.getWebhookWikiImage(gearName)
	if wiki then return wiki end
	return ""
end

SNH.formatDiscordPing = function(pingId)
	if type(pingId) ~= "string" or pingId == "" then return nil end
	pingId = pingId:gsub("^%s+", ""):gsub("%s+$", "")
	if pingId:find("<@") then return pingId end
	if pingId:sub(1, 1) == "&" then
		return ("<@&%s>"):format(pingId:sub(2):gsub("^&+", ""))
	end
	return ("<@%s>"):format(pingId:gsub("^@+", ""))
end

SNH.copyWebhookEmbed = function(base, overrides)
	local embed = {}
	for k, v in base do embed[k] = v end
	if overrides then
		for k, v in overrides do embed[k] = v end
	end
	return embed
end

SNH.buildWebhookEmbed = function(opts)
	opts = opts or {}
	local embed = {
		title = opts.title or "So Nach Hup",
		color = opts.color or 3066993,
		fields = opts.fields or {},
		footer = { text = os.date("%Y-%m-%d %H:%M:%S") },
	}
	if opts.description and opts.description ~= "" then
		embed.description = opts.description
	end
	local imageUrl = SNH.getDiscordThumbnailUrl(opts.image)
	if imageUrl then
		embed.thumbnail = { url = imageUrl }
	end
	return embed
end

SNH.sendPersonalWebhook = function(embed)
	if WEBHOOK_URL == "" or not embed then return false end
	local content = SNH.formatDiscordPing(WEBHOOK_PING_ID)
	return SNH.httpPostJson(WEBHOOK_URL, {
		username = "So Nach Hup",
		content = content,
		embeds = { embed },
	})
end

SNH.sendGlobalWebhook = function(embed)
	if GLOBAL_WEBHOOK_URL == "" or not embed then return false end
	return SNH.httpPostJson(GLOBAL_WEBHOOK_URL, {
		username = "So Nach Hup",
		embeds = { embed },
	})
end

-- Rarity rank (Common=1 ... Legendary=5, Mythic=6, Super=7, Secret=8).
SNH.rarityRankValue = function(rarity)
	return RARITY_RANK[tostring(rarity or "")] or 0
end

-- A pet is "global-worthy" only if it's in GLOBAL_WEBHOOK_PET_SET.
SNH.isGlobalWorthyPet = function(petKey)
	if not petKey then return false end
	local key = SNH.resolvePetKey(petKey) or petKey
	if GLOBAL_WEBHOOK_PET_SET[key] then return true end
	local meta = PetMeta[key] or FALLBACK_PET_META[key] or {}
	local display = PetDisplayByKey[key] or meta.DisplayName or key
	if GLOBAL_WEBHOOK_PET_SET[display] then return true end
	local compact = tostring(key):gsub(" ", "")
	return GLOBAL_WEBHOOK_PET_SET[compact] == true
end

-- A seed is "global-worthy" only if it's in GLOBAL_WEBHOOK_SEED_SET.
SNH.isGlobalWorthySeed = function(seedName)
	if not seedName then return false end
	if GLOBAL_WEBHOOK_SEED_SET[seedName] then return true end
	local compact = tostring(seedName):gsub(" ", "")
	return GLOBAL_WEBHOOK_SEED_SET[compact] == true
end

-- Ngăn 1: webhook riêng + ||username|| + ping. Ngăn 2: webhook toàn cầu, không username/ping.
-- opts.allowGlobal == false suppresses the global webhook; opts.allowPersonal == false
-- suppresses the personal one. Both default to enabled.
SNH.sendDualWebhook = function(opts)
	opts = opts or {}
	local base = SNH.buildWebhookEmbed(opts)
	if opts.allowGlobal ~= false then
		SNH.sendGlobalWebhook(SNH.copyWebhookEmbed(base))
	end
	if opts.allowPersonal == false then return end
	if WEBHOOK_URL == "" then return end
	SNH.sendPersonalWebhook(SNH.copyWebhookEmbed(base, {
		description = ("||%s||"):format(LocalPlayer.Name),
	}))
end

SNH.sendPetWebhook = function(petKey, price, extra)
	extra = extra or {}
	local meta = PetMeta[petKey] or FALLBACK_PET_META[petKey] or {}
	local rarity = extra.rarity or meta.Rarity or "Common"
	local personalWanted = SNH.shouldSendPetWebhook(petKey)
	local globalWanted = SNH.isGlobalWorthyPet(petKey)
	-- Personal: only configured pets. Global: whitelist only.
	if not personalWanted and not globalWanted then return false end
	local display = PetDisplayByKey[petKey] or meta.DisplayName or petKey
	local size = extra.size or "Normal"
	local actualPrice = tonumber(price) or meta.BasePrice or 0
	local chance = extra.spawnChance or meta.SpawnChance or 0
	SNH.sendDualWebhook({
		title = SNH.formatFoundWebhookTitle(display, chance),
		color = SNH.getWebhookRarityColor(rarity),
		image = SNH.getPetImageAsset(petKey, size),
		description = SNH.buildFoundWebhookDescription(rarity, size, actualPrice),
		allowGlobal = globalWanted,
		allowPersonal = personalWanted,
	})
	return true
end

SNH.sendSeedWebhook = function(seedName, extra)
	extra = extra or {}
	local meta = SeedMeta[seedName] or {}
	local rarity = extra.rarity or meta.rarity or "Common"
	local personalWanted = SNH.shouldSendSeedWebhook(seedName)
	local globalWanted = SNH.isGlobalWorthySeed(seedName)
	-- Personal: only configured seeds. Global: whitelist only.
	if not personalWanted and not globalWanted then return false end
	local amount = tonumber(extra.amount) or 1
	local unitPrice = tonumber(extra.unitPrice) or meta.price or 0
	local totalPrice = tonumber(extra.price)
	if not totalPrice or totalPrice <= 0 then
		totalPrice = unitPrice * amount
	end
	local chance = extra.restockChance or meta.restockChance or 0
	local sizeLabel = extra.size or (amount > 1 and ("x%d"):format(amount) or "Normal")
	SNH.sendDualWebhook({
		title = SNH.formatFoundWebhookTitle(seedName, chance),
		color = SNH.getWebhookRarityColor(rarity),
		image = SNH.getSeedImageAsset(seedName),
		description = SNH.buildFoundWebhookDescription(rarity, sizeLabel, totalPrice),
		allowGlobal = globalWanted,
		allowPersonal = personalWanted,
	})
	return true
end

SNH.setupWildPetWebhooks = function()
	if not Networking or not Networking.Pets or not Networking.Pets.WildPetTameResult then return end
	if wildPetWebhookHooked then return end
	wildPetWebhookHooked = true
	Networking.Pets.WildPetTameResult.OnClientEvent:Connect(function(ref, userId)
		if userId ~= LocalPlayer.UserId then return end
		if typeof(ref) ~= "Instance" or not ref:IsA("BasePart") then
			SNH.debugLog("WILD_PET", ("tameResult: bad ref type %s"):format(typeof(ref)), "warn")
			return
		end
		local petKey = ref:GetAttribute("PetName")
		SNH.debugLog("WILD_PET", ("tameResult OK: %s price=%s"):format(
			tostring(petKey), SNH.formatAbbrev(ref:GetAttribute("Price"))), "force")
		if not petKey then return end
		petKey = SNH.resolvePetKey(petKey) or petKey
		if not SNH.shouldSendPetWebhook(petKey) then return end
		SNH.sendPetWebhook(petKey, ref:GetAttribute("Price"), {
			rarity = ref:GetAttribute("Rarity"),
			size = ref:GetAttribute("PetSize") or "Normal",
		})
		if SNH.schedulePetEquipAfterTame then
			SNH.schedulePetEquipAfterTame(petKey, {
				size = ref:GetAttribute("PetSize"),
				rarity = ref:GetAttribute("Rarity"),
			})
		end
		if SNH.equipWildPetAfterBuy then
			SNH.equipWildPetAfterBuy(petKey)
		end
	end)
end

SNH.getWeakestEquippedPet = function()
	local equipped = SNH.getEquippedPetEntries()
	if #equipped == 0 then return nil end
	table.sort(equipped, function(a, b)
		return SNH.petEntryRarityScore(a) < SNH.petEntryRarityScore(b)
	end)
	return equipped[1]
end

SNH.getSpawnPetScore = function(petKey, ref)
	local key = SNH.resolvePetKey(petKey) or petKey
	local weight = ref and tonumber(ref:GetAttribute("Weight") or ref:GetAttribute("Age")) or 0
	local size = ref and ref:GetAttribute("Size") or ref and ref:GetAttribute("PetSize")
	local petType = ref and ref:GetAttribute("Type") or ref and ref:GetAttribute("PetType")
	return SNH.petEntryRarityScore({
		key = key,
		score = SNH.petScore(key, weight, size, petType),
	})
end

SNH.makeRoomForWildPet = function(petKey, ref)
	local maxSlots = SNH.getMaxPetSlots and SNH.getMaxPetSlots() or 2
	if SNH.countEquippedPets() < maxSlots then return true end
	local weakest = SNH.getWeakestEquippedPet()
	if not weakest then return false end
	local spawnScore = SNH.getSpawnPetScore(petKey, ref)
	local weakScore = SNH.petEntryRarityScore(weakest)
	if spawnScore <= weakScore then
		SNH.debugLog("WILD_PET", ("skip swap: %s not better than equipped %s"):format(
			tostring(petKey), tostring(weakest.key)), "warn")
		return false
	end
	local wkey = SNH.resolvePetKey(weakest.key) or weakest.key
	SNH.setStatus(("Swapping %s -> %s"):format(
		PetDisplayByKey[wkey] or wkey, PetDisplayByKey[petKey] or petKey))
	if not SNH.unequipPetUntilSuccess(wkey, weakest.id, 8) then
		SNH.debugLog("WILD_PET", ("failed to unequip %s for slot"):format(wkey), "warn")
		return false
	end
	task.wait(PET_EQUIP_STEP_DELAY or 0.55)
	return SNH.countEquippedPets() < maxSlots
end

SNH.waitForPetOwned = function(petKey, timeout)
	timeout = tonumber(timeout) or 20
	local deadline = tick() + timeout
	local key = SNH.resolvePetKey(petKey) or petKey
	local before = SNH.countOwnedPet(key)
	while tick() < deadline do
		if SNH.countOwnedPet(key) > before then return true end
		task.wait(0.25)
	end
	return SNH.countOwnedPet(key) > before
end

SNH.equipWildPetAfterBuy = function(petKey)
	if not AUTO_EQUIP_BEST_PET then return end
	local key = SNH.resolvePetKey(petKey) or petKey
	task.spawn(function()
		if SNH.waitForPetOwned(key, 20) then
			if SNH.equipPetUntilSuccess(key, nil, 8) then
				print(("[So Nach Hup] Equipped new wild pet: %s"):format(PetDisplayByKey[key] or key))
			end
			SNH.ensureBestPetsEquipped()
		else
			print(("[So Nach Hup] Timed out waiting for %s in inventory"):format(PetDisplayByKey[key] or key))
		end
	end)
end

SNH.tryBuyWildPet = function()
	if not AUTO_BUY_WILD_PET then
		SNH.debugLog("WILD_PET", "skip: AUTO_BUY_WILD_PET=false")
		return false
	end
	if SNH.isWildPetBuyPaused() then return false end
	if SNH.isSavingForPetSlots() then
		SNH.debugLog("WILD_PET", "skip: saving sheckles for pet slot unlock")
		return false
	end
	SNH.ensureNetworking()
	if not Networking or not Networking.Pets or not Networking.Pets.WildPetTame then
		SNH.debugLog("WILD_PET", ("skip: net=%s pets=%s tame=%s"):format(
			tostring(Networking ~= nil),
			tostring(Networking and Networking.Pets ~= nil),
			tostring(Networking and Networking.Pets and Networking.Pets.WildPetTame ~= nil)), "warn")
		return false
	end
	if not SNH.configHasBuyEntries(BuyPetsConfig) and not SNH.getWildPetProgress() then
		SNH.debugLog("WILD_PET", "skip: progressive pet collection complete")
		return false
	end
	if wildPetBuying then
		SNH.debugLog("WILD_PET", "skip: wildPetBuying")
		return false
	end
	local now = tick()
	if now - lastWildPetBuyAt < 0.15 then
		return false
	end
	local refs = SNH.getWildPetRefs()
	if #refs == 0 then
		SNH.debugLog("WILD_PET", "skip: no WildPetRef spawns on map")
		return false
	end
	local bestRef, bestScore = nil, -1
	local scanned = 0
	local progressive = not SNH.configHasBuyEntries(BuyPetsConfig)
	local wantKey = progressive and select(1, SNH.getWildPetProgress())
	for _, ref in refs do
		scanned += 1
		local petKey = ref:GetAttribute("PetName")
		if not petKey and ref.Parent and ref.Parent:IsA("Model") then
			petKey = ref.Parent:GetAttribute("PetName")
		end
		if not petKey then
			SNH.debugLog("WILD_PET", ("ref[%d] skip: no PetName attr"):format(scanned))
			continue
		end
		local rarity = ref:GetAttribute("Rarity") or "Common"
		if PET_RARITY_ENABLED[rarity] == false then
			continue
		end
		if progressive and wantKey then
			local resolved = SNH.resolvePetKey(petKey) or petKey
			if resolved ~= wantKey and petKey ~= wantKey then
				SNH.debugLog("WILD_PET", ("ref %s skip: waiting for %s"):format(petKey, wantKey))
				continue
			end
		end
		local target = SNH.getWildPetBuyTarget(petKey)
		if target <= 0 then
			SNH.debugLog("WILD_PET", ("ref %s skip: noConfigTarget (display=%s)"):format(
				petKey, PetDisplayByKey[petKey] or "?"))
			continue
		end
		local owned = SNH.countOwnedPet(petKey)
		if owned >= target then
			SNH.debugLog("WILD_PET", ("ref %s skip: owned %d/%d"):format(petKey, owned, target))
			continue
		end
		local price = tonumber(ref:GetAttribute("Price")) or math.huge
		if API.getSheckles() < price then
			SNH.debugLog("WILD_PET", ("ref %s skip: need %s have %s"):format(
				petKey, SNH.formatAbbrev(price), SNH.formatAbbrev(API.getSheckles())))
			continue
		end
		local score = (RARITY_RANK[rarity] or 0) * 1e9 - price
		SNH.debugLog("WILD_PET", ("candidate %s target=%d price=%s score=%s"):format(
			petKey, target, SNH.formatAbbrev(price), tostring(score)))
		if score > bestScore then bestScore, bestRef = score, ref end
	end
	if not bestRef then
		SNH.debugLog("WILD_PET", ("no buyable pet (scanned %d refs)"):format(scanned))
		return false
	end
	local petKey = bestRef:GetAttribute("PetName")
	local display = PetDisplayByKey[petKey] or petKey
	local price = tonumber(bestRef:GetAttribute("Price")) or 0
	if not SNH.makeRoomForWildPet(petKey, bestRef) then
		SNH.debugLog("WILD_PET", ("skip buy %s: full slots, not better than equipped"):format(petKey), "warn")
		return false
	end
	wildPetBuying = true
	lastWildPetBuyAt = now
	local tameRef = SNH.resolveWildPetTameRef(bestRef)
	if not tameRef then
		SNH.debugLog("WILD_PET", ("skip buy %s: could not resolve WildPetRef"):format(petKey), "warn")
		wildPetBuying = false
		return false
	end
	local beforeOwned = SNH.countOwnedPet(petKey)
	SNH.setStatus(("Buying wild pet: %s (WildPetTame)"):format(display))
	SNH.debugLog("WILD_PET", ("BUY %s ref=%s tameRef=%s price=%s ownedBefore=%d"):format(
		petKey, bestRef.Name, tameRef.Name, SNH.formatAbbrev(price), beforeOwned), "force")

	SNH.teleportToWildPet(tameRef)
	local success = SNH.attemptWildPetRemoteBuy(tameRef, petKey, beforeOwned, 5)
	if not success then
		success = SNH.attemptWildPetBuy(tameRef, petKey, beforeOwned)
	end

	if success or SNH.countOwnedPet(petKey) > beforeOwned then
		success = true
		print(("[So Nach Hup] Wild pet bought: %s (%s)"):format(display, SNH.formatAbbrev(price)))
		SNH.equipWildPetAfterBuy(petKey)
		-- Only teleport back home after a confirmed buy.
		task.spawn(function()
			if SNH.returnToOwnGarden then SNH.returnToOwnGarden() end
		end)
	else
		print(("[So Nach Hup] Wild pet buy FAILED: %s (%s) — stayed out (no teleport back)"):format(
			display, SNH.formatAbbrev(price)))
	end

	wildPetBuying = false
	return success
end
end
tryBuyWildPet = SNH.tryBuyWildPet
loadPetCatalog = SNH.loadPetCatalog
setupWildPetWebhooks = SNH.setupWildPetWebhooks

do --[[ SNH: PetScore ]]
SNH.petRarityRank = function(petKey)
	local meta = PetMeta[petKey] or FALLBACK_PET_META[petKey] or {}
	local rarity = meta.Rarity or "Common"
	local rank = PET_RARITY_RANK[rarity]
	if rank then return rank end
	if rarity == "Epic" then return PET_RARITY_RANK["Rare"] end
	if rarity == "Secret" then return PET_RARITY_RANK["Super"] end
	return 0
end

SNH.petScore = function(petKey, weight, size, petType)
	local meta = PetMeta[petKey] or FALLBACK_PET_META[petKey] or {}
	local rank = SNH.petRarityRank(petKey) or 0
	local sizeKey = "Normal"
	if type(size) == "string" and size ~= "" then
		local lower = string.lower(size)
		if lower == "big" then sizeKey = "Big"
		elseif lower == "huge" then sizeKey = "Huge" end
	end
	local sizeM = ({ Normal = 1, Big = 2, Huge = 3 })[sizeKey] or 1
	local typeM = (petType == "Rainbow") and 1.25 or 1
	local w = tonumber(weight) or 0
	local price = meta.BasePrice or 0
	return rank * 1e12 + sizeM * 1e9 + typeM * 1e8 + w * 1e3 + price
end
end

do --[[ SNH: PetLists ]]
SNH.getEquippedPetEntries = function()
	local equipped, seen = {}, {}
	local function addEntry(key, id, size, petType, weight)
		key = SNH.resolvePetKey(key) or key
		if not key or seen[id or key] then return end
		seen[id or key] = true
		table.insert(equipped, {
			key = key,
			id = id,
			size = size,
			type = petType,
			weight = weight,
			score = SNH.petScore(key, weight, size, petType),
		})
	end

	local net = Networking or (G and G.Networking)
	if net and net.Pets and net.Pets.GetEquippedPets then
		local ok, result = pcall(function()
			return net.Pets.GetEquippedPets:Fire()
		end)
		if ok and type(result) == "table" then
			for _, pet in result do
				if type(pet) == "table" and type(pet.Name) == "string" then
					addEntry(pet.Name, pet.Id, pet.Size or pet.PetSize, pet.Type or pet.PetType, pet.Weight or pet.Age)
				end
			end
		end
	end

	if #equipped == 0 and API.getEquippedPets then
		for _, pet in API.getEquippedPets(true) do
			if type(pet) == "table" and type(pet.Name) == "string" then
				addEntry(pet.Name, pet.Id, pet.Size or pet.PetSize, pet.Type or pet.PetType, pet.Weight or pet.Age)
			end
		end
	end

	local replica = SNH.getPetReplica()
	if replica and type(replica.Data) == "table" and type(replica.Data.Pets) == "table" then
		for _, pet in replica.Data.Pets do
			if type(pet) ~= "table" or pet.Equipped ~= true then continue end
			local key = pet.PetName or pet.Name
			if type(key) == "string" and key ~= "" then
				addEntry(key, pet.Id, pet.Size or pet.PetSize, pet.Type or pet.PetType, pet.Weight or pet.Age)
			end
		end
	end

	return equipped
end

SNH.getBenchedPetEntries = function()
	local bench, seen = {}, {}
	local slot = 0
	local function add(entry)
		slot += 1
		local dedupe = entry.id or (entry.key .. "#" .. slot)
		if seen[dedupe] then return end
		seen[dedupe] = true
		table.insert(bench, entry)
	end

	local replica = SNH.getPetReplica()
	if replica and type(replica.Data) == "table" and type(replica.Data.Pets) == "table" then
		for _, pet in replica.Data.Pets do
			if type(pet) ~= "table" then continue end
			local key = pet.PetName or pet.Name
			if not key or pet.Equipped == true then continue end
			key = SNH.resolvePetKey(key) or key
			add({
				key = key,
				id = pet.Id,
				size = pet.Size or pet.PetSize,
				type = pet.Type or pet.PetType,
				weight = pet.Weight or pet.Age,
				score = SNH.petScore(key, pet.Weight or pet.Age, pet.Size or pet.PetSize, pet.Type or pet.PetType),
			})
		end
	end

	local inventory = replica and replica.Data and replica.Data.Inventory
	if type(inventory) == "table" then
		for petKey, folderName in PET_INVENTORY_FOLDERS do
			local bucket = inventory[folderName]
			if type(bucket) ~= "table" then continue end
			local n = tonumber(bucket[petKey]) or 0
			local resolved = SNH.resolvePetKey(petKey) or petKey
			local already = 0
			for _, e in bench do
				if e.key == resolved then already += 1 end
			end
			for _ = already + 1, n do
				add({
					key = resolved,
					score = SNH.petScore(resolved, 0, "Normal", nil),
				})
			end
		end
	end

	local pets = type(inventory) == "table" and inventory.Pets or nil
	if type(pets) == "table" then
		for petKey, count in pets do
			local n = tonumber(count) or 0
			if n <= 0 or PET_INVENTORY_FOLDERS[petKey] then continue end
			local resolved = SNH.resolvePetKey(petKey) or petKey
			local already = 0
			for _, e in bench do
				if e.key == resolved then already += 1 end
			end
			for _ = already + 1, n do
				add({
					key = resolved,
					score = SNH.petScore(resolved, 0, "Normal", nil),
				})
			end
		end
	end

	for _, container in { LocalPlayer.Character, LocalPlayer.Backpack } do
		if not container then continue end
		for _, item in container:GetChildren() do
			if not item:IsA("Tool") then continue end
			local key = item:GetAttribute("Pet") or item:GetAttribute("PetName")
			if not key then continue end
			key = SNH.resolvePetKey(key) or key
			add({
				key = key,
				id = item:GetAttribute("PetId"),
				score = SNH.petScore(
					key,
					item:GetAttribute("Weight") or item:GetAttribute("Age"),
					item:GetAttribute("PetSize") or item:GetAttribute("Size"),
					item:GetAttribute("PetType") or item:GetAttribute("Type")
				),
			})
		end
	end
	return bench
end
end

do --[[ SNH: PetActions ]]
SNH.invalidateEquippedPetCache = function()
	equippedPetCache.time = -999
	equippedPetCache.pets = {}
end

SNH.getPetServerName = function(petKey, petId)
	local key = SNH.resolvePetKey(petKey) or petKey
	if type(petId) == "string" and petId ~= "" then
		local replica = SNH.getPetReplica()
		local pets = replica and replica.Data and replica.Data.Pets
		if type(pets) == "table" then
			for _, pet in pets do
				if type(pet) == "table" and pet.Id == petId then
					local name = pet.PetName or pet.Name
					if type(name) == "string" and name ~= "" then
						return name
					end
				end
			end
		end
	end
	return key
end

SNH.collectPetNameCandidates = function(petKey, petId)
	local names, seen = {}, {}
	local function add(name)
		if type(name) ~= "string" or name == "" then return end
		if seen[name] then return end
		seen[name] = true
		table.insert(names, name)
		local resolved = SNH.resolvePetKey(name)
		if resolved and resolved ~= name and not seen[resolved] then
			seen[resolved] = true
			table.insert(names, resolved)
		end
		local display = PetDisplayByKey[name] or PetDisplayByKey[resolved or name]
		if display and not seen[display] then
			seen[display] = true
			table.insert(names, display)
		end
	end
	add(SNH.getPetServerName(petKey, petId))
	add(petKey)
	return names
end

SNH.waitForEquippedChange = function(beforeCount, beforeKeys, timeout)
	timeout = tonumber(timeout) or 2.5
	local deadline = os.clock() + timeout
	while os.clock() < deadline do
		SNH.invalidateEquippedPetCache()
		local after = SNH.getEquippedPetEntries()
		if #after > beforeCount then return true, after end
		if type(beforeKeys) == "table" then
			for _, entry in after do
				local ek = SNH.resolvePetKey(entry.key) or entry.key
				if not beforeKeys[ek] then
					return true, after
				end
			end
		end
		task.wait(0.12)
	end
	return false
end

SNH.prepareEquipPetGui = function()
	local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
	local equipPet = playerGui and playerGui:FindFirstChild("EquipPet")
	if not equipPet then return nil end
	equipPet.Enabled = true
	local container = equipPet:FindFirstChild("Container")
	local equipBtn = container and (container:FindFirstChild("EquipButton") or container:FindFirstChild("Equip"))
	if equipBtn and equipBtn:IsA("GuiObject") then
		equipBtn.Visible = true
	end
	return equipPet
end

SNH.getPetNameFromTool = function(tool)
	if not tool or not tool:IsA("Tool") then return nil end
	if tool:GetAttribute("PetId") ~= nil then return nil end
	local raccoon = tool:GetAttribute("Raccoon")
	if type(raccoon) == "string" and raccoon ~= "" then return raccoon end
	local petAttr = tool:GetAttribute("Pet") or tool:GetAttribute("PetName")
	if type(petAttr) == "string" and petAttr ~= "" then
		return petAttr
	end
	return nil
end

SNH.isIndividualPetTool = function(tool)
	if not tool or not tool:IsA("Tool") then return false end
	local petId = tool:GetAttribute("PetId")
	if type(petId) == "string" and petId ~= "" then return true end
	local petAttr = tool:GetAttribute("Pet") or tool:GetAttribute("PetName")
	if type(petAttr) ~= "string" or petAttr == "" then return false end
	-- Stack pets use Raccoon-style attrs; individual pets use Pet/PetName without stack folder.
	return tool:GetAttribute("Raccoon") == nil
end

SNH.isStackPetTool = function(tool)
	if not tool or not tool:IsA("Tool") then return false end
	local petId = tool:GetAttribute("PetId")
	if type(petId) == "string" and petId ~= "" then return false end
	return SNH.getPetNameFromTool(tool) ~= nil
end

SNH.toolMatchesPetKey = function(tool, petKey)
	local key = SNH.resolvePetKey(petKey) or petKey
	local display = PetDisplayByKey[key] or key
	if SNH.isIndividualPetTool(tool) then
		local petAttr = tool:GetAttribute("Pet") or tool:GetAttribute("PetName")
		return SNH.petNameMatches(petAttr, key)
	end
	local stackName = SNH.getPetNameFromTool(tool)
	if stackName then
		return SNH.petNameMatches(stackName, key)
	end
	local n = string.lower(tool.Name)
	return string.find(n, string.lower(key), 1, true) ~= nil
		or string.find(n, string.lower(display), 1, true) ~= nil
end

SNH.getEquippedPetIds = function()
	local ids = {}
	for _, e in SNH.getEquippedPetEntries() do
		if type(e.id) == "string" and e.id ~= "" then
			ids[e.id] = true
		end
	end
	return ids
end

SNH.findIndividualPetTool = function(petKey, petId)
	local equippedIds = SNH.getEquippedPetIds()
	local fallback = nil
	for _, container in { LocalPlayer.Backpack, LocalPlayer.Character } do
		if not container then continue end
		for _, item in container:GetChildren() do
			if not SNH.isIndividualPetTool(item) then continue end
			local id = item:GetAttribute("PetId")
			local idStr = type(id) == "string" and id or ""
			if type(petId) == "string" and petId ~= "" and idStr == petId then
				return item
			end
			if not SNH.toolMatchesPetKey(item, petKey) then continue end
			if idStr ~= "" and equippedIds[idStr] then continue end
			if not fallback then fallback = item end
		end
	end
	return fallback
end

SNH.findStackPetTool = function(petKey)
	for _, container in { LocalPlayer.Backpack, LocalPlayer.Character } do
		if not container then continue end
		for _, item in container:GetChildren() do
			if SNH.isStackPetTool(item) and SNH.toolMatchesPetKey(item, petKey) then
				return item
			end
		end
	end
	return nil
end

SNH.findPetTool = function(petKey, petId)
	local tool = SNH.findIndividualPetTool(petKey, petId)
	if tool then return tool end
	tool = SNH.findStackPetTool(petKey)
	if tool then return tool end
	local equippedIds = SNH.getEquippedPetIds()
	local fallback = nil
	for _, container in { LocalPlayer.Backpack, LocalPlayer.Character } do
		if not container then continue end
		for _, item in container:GetChildren() do
			if not item:IsA("Tool") then continue end
			local id = item:GetAttribute("PetId")
			local idStr = type(id) == "string" and id or ""
			if type(petId) == "string" and petId ~= "" and idStr == petId then
				return item
			end
			if not SNH.toolMatchesPetKey(item, petKey) then continue end
			if idStr ~= "" and equippedIds[idStr] then continue end
			if not fallback then fallback = item end
		end
	end
	return fallback
end

SNH.holdToolInstance = function(tool)
	if not tool or not tool:IsA("Tool") then return false end
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not (char and hum and hum.Health > 0) then return false end
	if tool.Parent == char then return true end
	pcall(function() hum:UnequipTools() end)
	task.wait(0.08)
	if tool.Parent == LocalPlayer.Backpack then
		pcall(function() hum:EquipTool(tool) end)
	elseif tool.Parent ~= char then
		tool.Parent = char
	end
	local deadline = os.clock() + 2
	while os.clock() < deadline do
		if tool.Parent == char then return true end
		task.wait(0.06)
	end
	return tool.Parent == char
end

SNH.holdPetTool = function(petKey, petId)
	local tool = SNH.findPetTool(petKey, petId)
	if not tool then return false end
	return SNH.holdToolInstance(tool)
end

SNH.activateHeldPetTool = function(tool)
	if not tool or not tool:IsA("Tool") then return false end
	local petId = tool:GetAttribute("PetId")
	pcall(function() tool:Activate() end)
	if type(petId) == "string" and petId ~= "" and Networking and Networking.Pets and Networking.Pets.RequestToggleFollower then
		pcall(function() Networking.Pets.RequestToggleFollower:Fire(petId) end)
	end
	return true
end

SNH.clickEquipPetGuiButton = function()
	local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
	local equipPet = playerGui and playerGui:FindFirstChild("EquipPet")
	local container = equipPet and equipPet:FindFirstChild("Container")
	local btn = container and (container:FindFirstChild("EquipButton") or container:FindFirstChild("Equip"))
	if btn and btn:IsA("GuiButton") then
		pcall(function() btn:Activate() end)
		pcall(function()
			if firesignal and btn.Activated then firesignal(btn.Activated) end
		end)
		return true
	end
	return false
end

SNH.clickUnequipPetGuiButton = function()
	local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
	local equipPet = playerGui and playerGui:FindFirstChild("EquipPet")
	local container = equipPet and equipPet:FindFirstChild("Container")
	local btn = container and (container:FindFirstChild("UnequipButton") or container:FindFirstChild("Unequip"))
	if btn and btn:IsA("GuiButton") then
		pcall(function() btn:Activate() end)
		pcall(function()
			if firesignal and btn.Activated then firesignal(btn.Activated) end
		end)
		return true
	end
	return false
end

SNH.clickEquipPetButton = function(petName)
	local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
	if not playerGui then return false end
	local key = (SNH.resolvePetKey and SNH.resolvePetKey(petName)) or petName
	local compact = type(key) == "string" and key:gsub(" ", "") or key
	local function isTarget(inst)
		if not inst:IsA("GuiObject") then return false end
		local n = tostring(inst.Name)
		local low = string.lower(n)
		local kn = string.lower(tostring(key or ""))
		local kc = string.lower(tostring(compact or ""))
		if kn ~= "" and string.find(low, kn, 1, true) then return true end
		if kc ~= "" and string.find(low, kc, 1, true) then return true end
		local attrName = inst:GetAttribute("PetName") or inst:GetAttribute("Pet") or inst:GetAttribute("Name")
		if type(attrName) == "string" then
			local r = (SNH.resolvePetKey and SNH.resolvePetKey(attrName)) or attrName
			if r == key or r == compact then return true end
		end
		if inst:IsA("TextLabel") or inst:IsA("TextButton") then
			local txt = string.lower(tostring(inst.Text or ""))
			if kn ~= "" and string.find(txt, kn, 1, true) then return true end
			if kc ~= "" and string.find(txt, kc, 1, true) then return true end
		end
		return false
	end
	local function clickButton(btn)
		if not btn or not btn:IsA("GuiButton") or not btn.Visible then return false end
		pcall(function() btn:Activate() end)
		pcall(function()
			local signal = btn.Activated
			if signal and firesignal then firesignal(signal) end
		end)
		return true
	end
	for _, root in playerGui:GetDescendants() do
		if not isTarget(root) then continue end
		local equipBtn = root:FindFirstChild("EquipButton", true) or root:FindFirstChild("Equip", true)
		if equipBtn and clickButton(equipBtn) then return true end
		local parent = root.Parent
		if parent and parent:IsA("GuiObject") then
			equipBtn = parent:FindFirstChild("EquipButton", true) or parent:FindFirstChild("Equip", true)
			if equipBtn and clickButton(equipBtn) then return true end
		end
	end
	return false
end

SNH.clickUnequipPetButton = function(petName)
	local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
	if not playerGui then return false end
	local key = (SNH.resolvePetKey and SNH.resolvePetKey(petName)) or petName
	local compact = type(key) == "string" and key:gsub(" ", "") or key
	local function isTarget(inst)
		if not inst:IsA("GuiObject") then return false end
		local n = tostring(inst.Name)
		local low = string.lower(n)
		local kn = string.lower(tostring(key or ""))
		local kc = string.lower(tostring(compact or ""))
		if kn ~= "" and string.find(low, kn, 1, true) then return true end
		if kc ~= "" and string.find(low, kc, 1, true) then return true end
		local attrName = inst:GetAttribute("PetName") or inst:GetAttribute("Pet") or inst:GetAttribute("Name")
		if type(attrName) == "string" then
			local r = (SNH.resolvePetKey and SNH.resolvePetKey(attrName)) or attrName
			if r == key or r == compact then return true end
		end
		if inst:IsA("TextLabel") or inst:IsA("TextButton") then
			local txt = string.lower(tostring(inst.Text or ""))
			if kn ~= "" and string.find(txt, kn, 1, true) then return true end
			if kc ~= "" and string.find(txt, kc, 1, true) then return true end
		end
		return false
	end
	local function clickButton(btn)
		if not btn or not btn:IsA("GuiButton") or not btn.Visible then return false end
		pcall(function() btn:Activate() end)
		pcall(function()
			local signal = btn.Activated
			if signal and firesignal then firesignal(signal) end
		end)
		return true
	end
	for _, root in playerGui:GetDescendants() do
		if not isTarget(root) then continue end
		local unequipBtn = root:FindFirstChild("UnequipButton", true) or root:FindFirstChild("Unequip", true)
		if unequipBtn and clickButton(unequipBtn) then return true end
		local parent = root.Parent
		if parent and parent:IsA("GuiObject") then
			unequipBtn = parent:FindFirstChild("UnequipButton", true) or parent:FindFirstChild("Unequip", true)
			if unequipBtn and clickButton(unequipBtn) then return true end
		end
	end
	return false
end

SNH.getBenchedPetIdForKey = function(petKey)
	local key = SNH.resolvePetKey(petKey) or petKey
	local replica = SNH.getPetReplica()
	if not replica or type(replica.Data) ~= "table" or type(replica.Data.Pets) ~= "table" then
		return nil
	end
	for _, pet in replica.Data.Pets do
		if type(pet) ~= "table" or pet.Equipped == true then continue end
		local name = pet.PetName or pet.Name
		local resolved = SNH.resolvePetKey(name) or name
		if resolved == key and type(pet.Id) == "string" and pet.Id ~= "" then
			return pet.Id
		end
	end
	return nil
end

SNH.equipPetByName = function(petName, petId)
	SNH.ensureNetworking()
	if not Networking or not Networking.Pets then return false end
	local key = (SNH.resolvePetKey and SNH.resolvePetKey(petName)) or petName
	if not SNH.canEquipPet(key) then
		print(("[So Nach Hup] Equip blocked (not owned): %s"):format(tostring(key)))
		return false
	end

	if type(petId) ~= "string" or petId == "" then
		petId = SNH.getBenchedPetIdForKey(key)
	end

	local before = SNH.getEquippedPetEntries()
	local beforeCount = #before
	local beforeKeys = {}
	local beforeIds = {}
	for _, e in before do
		local ek = SNH.resolvePetKey(e.key) or e.key
		beforeKeys[ek] = (beforeKeys[ek] or 0) + 1
		if e.id then beforeIds[e.id] = true end
	end

	if type(petId) == "string" and petId ~= "" and beforeIds[petId] then
		return true
	end

	local function equippedNow()
		SNH.invalidateEquippedPetCache()
		local after = SNH.getEquippedPetEntries()
		if #after > beforeCount then return true end
		if type(petId) == "string" and petId ~= "" then
			for _, e in after do
				if e.id == petId then return true end
			end
		end
		local keyCount = 0
		for _, e in after do
			if (SNH.resolvePetKey(e.key) or e.key) == key then
				keyCount += 1
			end
		end
		return keyCount > (beforeKeys[key] or 0)
	end

	local function waitEquipped(timeout)
		local deadline = os.clock() + (tonumber(timeout) or 1.2)
		while os.clock() < deadline do
			if equippedNow() then return true end
			task.wait(0.08)
		end
		return equippedNow()
	end

	-- Fast path: fire remotes immediately (no plot teleport / long waits).
	local names = SNH.collectPetNameCandidates(key, petId)
	if type(petId) == "string" and petId ~= "" and Networking.Pets.RequestToggleFollower then
		pcall(function() Networking.Pets.RequestToggleFollower:Fire(petId) end)
	end
	if Networking.Pets.RequestEquipByName then
		for _, name in names do
			pcall(function() Networking.Pets.RequestEquipByName:Fire(name) end)
		end
	end
	if waitEquipped(0.35) then
		print(("[So Nach Hup] Equipped pet via remote: %s"):format(tostring(key)))
		return true
	end

	task.spawn(function()
		if SNH.ensureInsideOwnPlotForPets then SNH.ensureInsideOwnPlotForPets() end
	end)

	-- Path A: individual pet (Robin etc) — hold tool + RequestToggleFollower
	local indTool = SNH.findIndividualPetTool(key, petId)
	if indTool then
		local id = indTool:GetAttribute("PetId")
		print(("[So Nach Hup] Equip individual pet %s (id=%s)"):format(tostring(key), tostring(id)))
		if SNH.holdToolInstance(indTool) then
			SNH.activateHeldPetTool(indTool)
			task.wait(0.12)
			SNH.activateHeldPetTool(indTool)
			if waitEquipped(1.2) then
				print(("[So Nach Hup] Equipped individual pet: %s"):format(tostring(key)))
				return true
			end
		end
	end

	-- Path B: stack pet (Raccoon etc) — hold tool + EquipPet GUI + RequestEquipByName
	local stackTool = SNH.findStackPetTool(key)
	if stackTool then
		local stackName = SNH.getPetNameFromTool(stackTool)
		print(("[So Nach Hup] Equip stack pet %s (tool=%s)"):format(tostring(key), tostring(stackName)))
		if SNH.holdToolInstance(stackTool) then
			SNH.prepareEquipPetGui()
			if stackName and not table.find(names, stackName) then
				table.insert(names, 1, stackName)
			end
			for _, name in names do
				if Networking.Pets.RequestEquipByName then
					pcall(function() Networking.Pets.RequestEquipByName:Fire(name) end)
				end
				task.wait(0.08)
				if waitEquipped(0.8) then
					print(("[So Nach Hup] Equipped stack pet: %s"):format(tostring(name)))
					return true
				end
			end
			SNH.clickEquipPetGuiButton()
			if waitEquipped(0.8) then
				print(("[So Nach Hup] Equipped stack pet via GUI: %s"):format(tostring(key)))
				return true
			end
		end
	end

	-- Path C: remote retry with known id
	if type(petId) == "string" and petId ~= "" and Networking.Pets.RequestToggleFollower then
		pcall(function() Networking.Pets.RequestToggleFollower:Fire(petId) end)
		if waitEquipped(0.8) then return true end
	end

	print(("[So Nach Hup] Equip failed: %s id=%s indTool=%s stackTool=%s"):format(
		tostring(key), tostring(petId), tostring(indTool ~= nil), tostring(stackTool ~= nil)))
	return false
end

SNH.unequipPetByName = function(petName)
	if not Networking or not Networking.Pets then return false end
	local key = (SNH.resolvePetKey and SNH.resolvePetKey(petName)) or petName
	local beforeCount = #(SNH.getEquippedPetEntries())

	-- PetListController: RequestUnequip by id when we know equipped entry
	for _, e in SNH.getEquippedPetEntries() do
		local ek = SNH.resolvePetKey(e.key) or e.key
		if ek == key and e.id and Networking.Pets.RequestUnequip then
			local ok = pcall(function() Networking.Pets.RequestUnequip:Fire(e.id) end)
			if ok then
				task.wait(0.2)
				SNH.invalidateEquippedPetCache()
				if #(SNH.getEquippedPetEntries()) < beforeCount then return true end
			end
		end
	end

	-- PetEquipController: hold stack tool + UnequipButton + RequestUnequipByName
	local stackTool = SNH.findStackPetTool(key)
	if stackTool and SNH.holdToolInstance(stackTool) then
		task.wait(0.4)
		SNH.prepareEquipPetGui()
		local names = SNH.collectPetNameCandidates(key, nil)
		local stackName = SNH.getPetNameFromTool(stackTool)
		if stackName and not table.find(names, stackName) then
			table.insert(names, 1, stackName)
		end
		for _, name in names do
			if Networking.Pets.RequestUnequipByName then
				pcall(function() Networking.Pets.RequestUnequipByName:Fire(name) end)
			end
			task.wait(0.15)
			SNH.invalidateEquippedPetCache()
			if #(SNH.getEquippedPetEntries()) < beforeCount then return true end
		end
		SNH.clickUnequipPetGuiButton()
		task.wait(0.2)
		SNH.invalidateEquippedPetCache()
		if #(SNH.getEquippedPetEntries()) < beforeCount then return true end
	end

	if Networking.Pets.RequestUnequipByName then
		for _, name in SNH.collectPetNameCandidates(key, nil) do
			pcall(function() Networking.Pets.RequestUnequipByName:Fire(name) end)
			task.wait(0.15)
			SNH.invalidateEquippedPetCache()
			if #(SNH.getEquippedPetEntries()) < beforeCount then return true end
		end
	end
	return #(SNH.getEquippedPetEntries()) < beforeCount
end

SNH.unequipPetById = function(petId)
	if not Networking or not Networking.Pets or not Networking.Pets.RequestUnequip then return false end
	if type(petId) ~= "string" or petId == "" then return false end
	local beforeCount = #(SNH.getEquippedPetEntries())
	local ok = pcall(function() Networking.Pets.RequestUnequip:Fire(petId) end)
	if not ok then return false end
	task.wait(0.15)
	SNH.invalidateEquippedPetCache()
	local afterCount = #(SNH.getEquippedPetEntries())
	return afterCount < beforeCount
end
end
equipPetByName = SNH.equipPetByName
unequipPetByName = SNH.unequipPetByName
unequipPetById = SNH.unequipPetById

do --[[ SNH: PetEquipRun ]]
SNH.ensureInsideOwnPlotForPets = function()
	local _, plot = API.getLocalPlot()
	if not plot then return false end
	if API.isPlayerInsidePlot(LocalPlayer, plot) then return true end
	local pos = SNH.getGardenInteriorPosition and SNH.getGardenInteriorPosition(plot)
	if not pos then return false end
	for _ = 1, 3 do
		SNH.safeTeleport(pos)
		task.wait(0.15)
		if API.isPlayerInsidePlot(LocalPlayer, plot) then return true end
	end
	return API.isPlayerInsidePlot(LocalPlayer, plot)
end

SNH.ensureInsideOwnPlotForPlanting = SNH.ensureInsideOwnPlotForPets

-- PlotsController plot + plot center; physical inside check only (remote harvest).
SNH.ensureInsideOwnPlotForHarvest = function()
	API.init()
	local plot = API.getPlayerPlot()
	if not plot then return false end
	if SNH.canHarvestFromPlot(plot) then return true end
	SNH.setStatus("Moving to garden for harvest...")
	if SNH.returnToOwnGarden and SNH.returnToOwnGarden() then
		task.wait(0.15)
		if API.isInOwnGarden(LocalPlayer) and SNH.canHarvestFromPlot(plot) then
			return true
		end
	end
	local positions = {}
	local center = SNH.getPlotHarvestStandPosition(plot)
	local interior = SNH.getGardenInteriorPosition(plot)
	if center then table.insert(positions, center) end
	if interior and interior ~= center then table.insert(positions, interior) end
	for _, pos in positions do
		for _ = 1, 3 do
			SNH.teleportToPlotCenter(plot)
			SNH.safeTeleport(pos)
			task.wait(0.15)
			if SNH.canHarvestFromPlot(plot) then return true end
		end
	end
	return SNH.canHarvestFromPlot(plot)
end

SNH.petEntryScore = function(entry)
	if not entry then return -1 end
	local key = SNH.resolvePetKey(entry.key) or entry.key
	local meta = PetMeta[key] or FALLBACK_PET_META[key] or {}
	if PET_RARITY_ENABLED[meta.Rarity or "Common"] == false then return -1 end
	return (SNH.petRarityRank(key) or 0) * 1e12 + (entry.score or SNH.petScore(key, entry.weight, entry.size, entry.type))
end

-- Sort key: rarity first, then size/weight within same rarity.
SNH.petEntryRarityScore = function(entry)
	if not entry then return -1 end
	local key = SNH.resolvePetKey(entry.key) or entry.key
	local meta = PetMeta[key] or FALLBACK_PET_META[key] or {}
	if PET_RARITY_ENABLED[meta.Rarity or "Common"] == false then return -1 end
	local rank = SNH.petRarityRank(key) or 0
	return rank * 1e15 + (entry.score or SNH.petScore(key, entry.weight, entry.size, entry.type))
end

SNH.isPetEquipped = function(petKey, petId)
	local key = SNH.resolvePetKey(petKey) or petKey
	SNH.invalidateEquippedPetCache()
	for _, e in SNH.getEquippedPetEntries() do
		if type(petId) == "string" and petId ~= "" then
			if e.id == petId then return true end
			continue
		end
		if SNH.petNameMatches(e.key, key) then return true end
	end
	return false
end

SNH.countEquippedPets = function()
	SNH.invalidateEquippedPetCache()
	return #(SNH.getEquippedPetEntries())
end

-- Hold pet tool from backpack, click until active pet slots +1, verify equipped.
SNH.equipPetUntilSuccess = function(petKey, petId, maxTries)
	maxTries = math.max(1, tonumber(maxTries) or 6)
	local key = SNH.resolvePetKey(petKey) or petKey
	if type(petId) ~= "string" or petId == "" then
		petId = SNH.getBenchedPetIdForKey(key)
	end
	SNH.ensureNetworking()
	SNH.getPlayerStateClient()
	if not Networking or not Networking.Pets then return false end
	if type(petId) == "string" and petId ~= "" and SNH.isPetEquipped(key, petId) then
		return true
	end
	for _ = 1, maxTries do
		if SNH.equipPetByName(key, petId) then return true end
		task.wait(PET_EQUIP_STEP_DELAY or 0.55)
		if type(petId) == "string" and petId ~= "" and SNH.isPetEquipped(key, petId) then
			return true
		end
	end
	return type(petId) == "string" and petId ~= "" and SNH.isPetEquipped(key, petId)
end

SNH.unequipPetUntilSuccess = function(petKey, petId, maxTries)
	maxTries = math.max(1, tonumber(maxTries) or 10)
	local key = SNH.resolvePetKey(petKey) or petKey
	SNH.ensureNetworking()
	if not Networking or not Networking.Pets then return false end
	if not SNH.isPetEquipped(key, petId) then return true end

	local beforeCount = SNH.countEquippedPets()
	for _ = 1, maxTries do
		SNH.invalidateEquippedPetCache()
		if not SNH.isPetEquipped(key, petId) then return true end

		local tool = SNH.findPetTool(key, petId)
		if tool and SNH.holdToolInstance(tool) then
			SNH.prepareEquipPetGui()
			if SNH.isStackPetTool(tool) then
				local names = SNH.collectPetNameCandidates(key, petId)
				if Networking.Pets.RequestUnequipByName then
					for _, name in names do
						pcall(function() Networking.Pets.RequestUnequipByName:Fire(name) end)
					end
				end
				SNH.clickUnequipPetGuiButton()
				SNH.clickUnequipPetButton(key)
			end
		end

		if type(petId) == "string" and petId ~= "" and Networking.Pets.RequestUnequip then
			pcall(function() Networking.Pets.RequestUnequip:Fire(petId) end)
		else
			SNH.unequipPetByName(key)
		end

		task.wait(PET_EQUIP_STEP_DELAY or 0.55)
		SNH.invalidateEquippedPetCache()
		if #(SNH.getEquippedPetEntries()) < beforeCount then return true end
		if not SNH.isPetEquipped(key, petId) then return true end
	end
	return not SNH.isPetEquipped(key, petId)
end

SNH.countEntriesByKey = function(entries)
	local counts = {}
	for _, entry in entries do
		local key = SNH.resolvePetKey(entry.key) or entry.key
		counts[key] = (counts[key] or 0) + 1
	end
	return counts
end

SNH.buildDesiredPetLoadout = function(maxSlots)
	local all = {}
	for _, e in SNH.getEquippedPetEntries() do
		if SNH.petEntryRarityScore(e) >= 0 then
			table.insert(all, {
				key = SNH.resolvePetKey(e.key) or e.key,
				id = e.id,
				entry = e,
			})
		end
	end
	for _, b in SNH.getBenchedPetEntries() do
		local key = SNH.resolvePetKey(b.key) or b.key
		if not SNH.canEquipPet(key) then continue end
		if SNH.petEntryRarityScore(b) < 0 then continue end
		table.insert(all, { key = key, id = b.id, entry = b })
	end
	table.sort(all, function(a, b)
		return SNH.petEntryRarityScore(a.entry) > SNH.petEntryRarityScore(b.entry)
	end)

	local desired, desiredByKey = {}, {}
	local seenIds = {}
	local idx = 1
	while #desired < maxSlots and idx <= #all do
		local item = all[idx]
		idx += 1
		if type(item.id) == "string" and item.id ~= "" then
			if seenIds[item.id] then continue end
			seenIds[item.id] = true
		end
		table.insert(desired, item)
		desiredByKey[item.key] = (desiredByKey[item.key] or 0) + 1
	end
	return desired, desiredByKey
end

SNH.countEmptyPetSlots = function()
	local maxSlots = math.max(0, math.floor(tonumber(SNH.getMaxPetSlots and SNH.getMaxPetSlots() or 2) or 2))
	if maxSlots <= 0 then return 0, maxSlots end
	SNH.invalidateEquippedPetCache()
	return math.max(0, maxSlots - #(SNH.getEquippedPetEntries())), maxSlots
end

SNH.fillEmptyPetSlots = function()
	if not AUTO_EQUIP_BEST_PET then return false end
	local empty, maxSlots = SNH.countEmptyPetSlots()
	if empty <= 0 then return false end
	local bench = SNH.getBenchedPetEntries()
	if #bench == 0 then return false end

	table.sort(bench, function(a, b)
		return SNH.petEntryRarityScore(a) > SNH.petEntryRarityScore(b)
	end)

	local equippedIds = {}
	for _, e in SNH.getEquippedPetEntries() do
		if type(e.id) == "string" and e.id ~= "" then
			equippedIds[e.id] = true
		end
	end

	local changed = false
	for _, b in bench do
		if empty <= 0 then break end
		local key = SNH.resolvePetKey(b.key) or b.key
		if not SNH.canEquipPet(key) then continue end
		if type(b.id) == "string" and b.id ~= "" and equippedIds[b.id] then continue end
		if SNH.equipPetUntilSuccess(key, b.id, 6) then
			changed = true
			empty -= 1
			if type(b.id) == "string" and b.id ~= "" then
				equippedIds[b.id] = true
			end
			local meta = PetMeta[key] or FALLBACK_PET_META[key] or {}
			print(("[So Nach Hup] Filled empty slot with %s (%s)"):format(
				PetDisplayByKey[key] or key, meta.Rarity or "Common"))
			task.wait(PET_EQUIP_STEP_DELAY or 0.55)
			SNH.invalidateEquippedPetCache()
		end
	end
	return changed
end

SNH.isPetLoadoutSatisfied = function(equipped, desiredByKey, maxSlots)
	if #equipped > maxSlots then return false end
	local eqByKey = SNH.countEntriesByKey(equipped)
	local targetTotal = 0
	for _, n in desiredByKey do targetTotal += n end
	if targetTotal <= 0 then return #equipped == 0 end
	if #equipped < targetTotal then return false end
	if #equipped ~= targetTotal then return false end
	for key, need in desiredByKey do
		if (eqByKey[key] or 0) ~= need then return false end
	end
	for key, have in eqByKey do
		if (desiredByKey[key] or 0) ~= have then return false end
	end
	return true
end

-- Slow rarity-first equip: only rebalance when loadout wrong; one pet per step with delays.
SNH.ensureBestPetsEquipped = function()
	if not ENABLED or not AUTO_EQUIP_BEST_PET then return false end
	if SNH.isActionPausedForSeedSnipe() then return false end
	if petEquipEnsureActive then return false end
	petEquipEnsureActive = true
	local changed = false
	local ok, err = pcall(function()
		SNH.ensureNetworking()
		if not Networking or not Networking.Pets then return end
		SNH.getPlayerStateClient()

		local maxSlots = math.max(0, math.floor(tonumber(SNH.getMaxPetSlots and SNH.getMaxPetSlots() or 2) or 2))
		if maxSlots <= 0 then return end

		SNH.invalidateEquippedPetCache()
		if SNH.fillEmptyPetSlots() then
			changed = true
		end

		local equipped = SNH.getEquippedPetEntries()
		local bench = SNH.getBenchedPetEntries()
		if #equipped == 0 and #bench == 0 then return end

		local desired, desiredByKey = SNH.buildDesiredPetLoadout(maxSlots)
		if SNH.isPetLoadoutSatisfied(equipped, desiredByKey, maxSlots) then
			lastPetEquipAt = tick()
			local now = tick()
			if now - lastPetOkLogAt >= (tonumber(PET_OK_LOG_GAP) or 60) then
				lastPetOkLogAt = now
				print(("[So Nach Hup] Pet loadout OK (rarest equipped) | %s"):format(SNH.debugPetEquipStatus()))
			end
			return
		end

		while #equipped > maxSlots do
			table.sort(equipped, function(a, b)
				return SNH.petEntryRarityScore(a) < SNH.petEntryRarityScore(b)
			end)
			local weak = equipped[1]
			if not weak then break end
			local wkey = SNH.resolvePetKey(weak.key) or weak.key
			if SNH.unequipPetUntilSuccess(wkey, weak.id, 4) then
				changed = true
				task.wait(PET_EQUIP_STEP_DELAY or 0.55)
			else
				break
			end
			SNH.invalidateEquippedPetCache()
			equipped = SNH.getEquippedPetEntries()
		end

		local eqByKey = SNH.countEntriesByKey(equipped)
		table.sort(equipped, function(a, b)
			return SNH.petEntryRarityScore(a) < SNH.petEntryRarityScore(b)
		end)
		for _, e in equipped do
			local key = SNH.resolvePetKey(e.key) or e.key
			local need = desiredByKey[key] or 0
			local have = eqByKey[key] or 0
			if have <= need then continue end
			if SNH.unequipPetUntilSuccess(key, e.id, 4) then
				changed = true
				eqByKey[key] = math.max(0, have - 1)
				task.wait(PET_EQUIP_STEP_DELAY or 0.55)
			end
			SNH.invalidateEquippedPetCache()
			equipped = SNH.getEquippedPetEntries()
			if SNH.isPetLoadoutSatisfied(equipped, desiredByKey, maxSlots) then break end
		end

		SNH.invalidateEquippedPetCache()
		equipped = SNH.getEquippedPetEntries()
		eqByKey = SNH.countEntriesByKey(equipped)

		for pass = 1, maxSlots do
			if SNH.isPetLoadoutSatisfied(equipped, desiredByKey, maxSlots) then break end
			local progressed = false
			for _, item in desired do
				if SNH.isPetLoadoutSatisfied(equipped, desiredByKey, maxSlots) then break end
				local key = item.key
				local need = desiredByKey[key] or 0
				local have = eqByKey[key] or 0
				if have >= need then continue end
				if type(item.id) == "string" and item.id ~= "" and SNH.isPetEquipped(key, item.id) then
					eqByKey[key] = have + 1
					progressed = true
					continue
				end
				if SNH.equipPetUntilSuccess(key, item.id, 6) then
					changed = true
					progressed = true
					eqByKey[key] = have + 1
					local meta = PetMeta[key] or FALLBACK_PET_META[key] or {}
					print(("[So Nach Hup] Equipped pet: %s (%s)"):format(
						PetDisplayByKey[key] or key, meta.Rarity or "Common"))
					task.wait(PET_EQUIP_STEP_DELAY or 0.55)
				end
				SNH.invalidateEquippedPetCache()
				equipped = SNH.getEquippedPetEntries()
				eqByKey = SNH.countEntriesByKey(equipped)
			end
			if not progressed then break end
		end

		lastPetEquipAt = tick()
		local status = SNH.debugPetEquipStatus()
		if changed then
			print(("[So Nach Hup] Pet ensure done | %s"):format(status))
		else
			print(("[So Nach Hup] Pet ensure pending | %s"):format(status))
		end
	end)
	petEquipEnsureActive = false
	if not ok then
		warn(("[So Nach Hup] Pet ensure error: %s"):format(tostring(err)))
	end
	return changed
end

SNH.debugPetEquipStatus = function()
	if not AUTO_EQUIP_BEST_PET then return "AUTO_EQUIP_BEST_PET=false" end
	if not Networking or not Networking.Pets then return "Networking.Pets missing" end
	local owned = SNH.getOwnedPetKeys()
	if #owned == 0 then return "no pets owned" end
	local maxSlots = SNH.getMaxPetSlots and SNH.getMaxPetSlots() or 2
	local equipped = SNH.getEquippedPetEntries()
	local bench = SNH.getBenchedPetEntries()
	local parts = {}
	table.insert(parts, ("slots %d/%d"):format(#equipped, maxSlots))
	table.insert(parts, ("owned %d bench %d"):format(#owned, #bench))
	for _, e in equipped do
		local meta = PetMeta[e.key] or FALLBACK_PET_META[e.key] or {}
		table.insert(parts, ("eq:%s(%s)"):format(PetDisplayByKey[e.key] or e.key, meta.Rarity or "?"))
	end
	if #bench > 0 then
		table.sort(bench, function(a, b)
			return SNH.petEntryRarityScore(a) > SNH.petEntryRarityScore(b)
		end)
		local best = bench[1]
		local meta = PetMeta[best.key] or FALLBACK_PET_META[best.key] or {}
		table.insert(parts, ("best_bench:%s(%s)"):format(PetDisplayByKey[best.key] or best.key, meta.Rarity or "?"))
	end
	return table.concat(parts, " | ")
end

SNH.tryEquipBestPets = function(forceRun, mode)
	if (not AUTO_EQUIP_BEST_PET and not forceRun) or not Networking or not Networking.Pets then return false end
	if petEquipRebalancing then return false end
	petEquipRebalancing = true
	mode = mode or "both" -- "both" | "unequipOnly" | "equipOnly"

	local overallChanged = false
	local ok, err = pcall(function()
		SNH.getPlayerStateClient()
		local owned = SNH.getOwnedPetKeys()
		if #owned == 0 then
			lastPetEquipAt = tick()
			return
		end

		local slotFn = SNH.getMaxPetSlots or getMaxPetSlots
		local maxSlots = slotFn and slotFn() or tonumber(LocalPlayer:GetAttribute("MaxEquippedPets")) or 2
		maxSlots = math.max(0, math.floor(maxSlots))
		if maxSlots <= 0 then
			lastPetEquipAt = tick()
			return
		end

		for _ = 1, 4 do
			local equipped = SNH.getEquippedPetEntries()
			local bench = SNH.getBenchedPetEntries()
			if #equipped == 0 and #bench == 0 then break end

			local all = {}
			for _, e in equipped do
				local key = SNH.resolvePetKey(e.key) or e.key
				all[#all + 1] = {
					key = key,
					score = e.score,
					id = e.id,
					source = "equipped",
				}
			end
			for _, b in bench do
				local key = SNH.resolvePetKey(b.key) or b.key
				if SNH.canEquipPet(key) then
					all[#all + 1] = {
						key = key,
						score = b.score,
						id = b.id,
						source = "bench",
					}
				end
			end
			if #all == 0 then break end
			table.sort(all, function(a, b) return a.score > b.score end)

			local desiredByKey = {}
			for i = 1, math.min(maxSlots, #all) do
				local key = all[i].key
				desiredByKey[key] = (desiredByKey[key] or 0) + 1
			end

			local equippedByKey = {}
			for _, e in equipped do
				local key = SNH.resolvePetKey(e.key) or e.key
				equippedByKey[key] = (equippedByKey[key] or 0) + 1
			end

			local passChanged = false
			if mode ~= "equipOnly" then
				table.sort(equipped, function(a, b) return a.score < b.score end)
				for _, e in equipped do
					local key = SNH.resolvePetKey(e.key) or e.key
					local need = desiredByKey[key] or 0
					local have = equippedByKey[key] or 0
					if have <= need then continue end
					local okUnequip = false
					if e.id then
						okUnequip = SNH.unequipPetById(e.id)
					end
					if not okUnequip then
						okUnequip = SNH.unequipPetByName(key)
					end
					if okUnequip then
						equippedByKey[key] = math.max(0, have - 1)
						passChanged = true
						overallChanged = true
						SNH.setStatus("Unequipping weak pets")
						task.wait(0.08)
					end
				end
			end

			if mode ~= "unequipOnly" then
				if SNH.fillEmptyPetSlots() then
					passChanged = true
					overallChanged = true
					equipped = SNH.getEquippedPetEntries()
					for _, e in equipped do
						local key = SNH.resolvePetKey(e.key) or e.key
						equippedByKey[key] = (equippedByKey[key] or 0) + 1
					end
				end
				table.sort(bench, function(a, b) return a.score > b.score end)
				for _, b in bench do
					local key = SNH.resolvePetKey(b.key) or b.key
					local want = desiredByKey[key] or 0
					local have = equippedByKey[key] or 0
					if want <= 0 or have >= want then continue end
					if not SNH.canEquipPet(key) then continue end
					if SNH.equipPetByName(key, b.id) then
						equippedByKey[key] = have + 1
						passChanged = true
						overallChanged = true
						SNH.setStatus("Equipping best pets")
						task.wait(0.08)
					end
				end
			end

			if not passChanged then break end
			task.wait(0.12)
		end

		lastPetEquipAt = tick()
	end)

	petEquipRebalancing = false
	if not ok then
		warn(("[So Nach Hup] Pet rebalance error: %s"):format(tostring(err)))
		return false
	end
	return overallChanged
end

SNH.tryEquipPetsByRarity = function(forceRun)
	if not AUTO_EQUIP_BEST_PET and not forceRun then return false end
	return SNH.ensureBestPetsEquipped()
end

SNH.schedulePetEquipAfterTame = function(petKey, extra)
	if not AUTO_EQUIP_BEST_PET then return end
	petEquipForceUntil = tick() + 20
	task.delay(0.35, function()
		SNH.ensureBestPetsEquipped()
	end)
	if type(petKey) == "string" and petKey ~= "" then
		local display = PetDisplayByKey[petKey] or petKey
		local rarity = extra and extra.rarity or (PetMeta[petKey] and PetMeta[petKey].Rarity) or "Common"
		print(("[So Nach Hup] Auto-equip queued for %s (%s)"):format(display, rarity))
	end
end

SNH.getPetSlotPriceData = function()
	if PetSlotPriceData then return PetSlotPriceData end
	local sharedData = ReplicatedStorage:FindFirstChild("SharedData")
	local mod = sharedData and sharedData:FindFirstChild("PetSlotPrices")
	if mod then
		local ok, data = pcall(require, mod)
		if ok and type(data) == "table" then
			PetSlotPriceData = data
			return data
		end
	end
	PetSlotPriceData = {
		Prices = FALLBACK_PET_SLOT_PRICES,
		BaseMax = PET_SLOT_BASE_MAX,
		AbsoluteMax = PET_SLOT_ABSOLUTE_MAX,
		GetNextPrice = function(currentMax)
			local idx = math.max(0, math.floor((tonumber(currentMax) or PET_SLOT_BASE_MAX) - PET_SLOT_BASE_MAX)) + 1
			return FALLBACK_PET_SLOT_PRICES[idx]
		end,
	}
	return PetSlotPriceData
end

SNH.getAbsoluteMaxPetSlots = function()
	return math.min(
		math.floor(tonumber(TARGET_PET_SLOTS) or 5),
		math.floor(tonumber((SNH.getPetSlotPriceData().AbsoluteMax)) or PET_SLOT_ABSOLUTE_MAX)
	)
end

SNH.getNextPetSlotPrice = function()
	local data = SNH.getPetSlotPriceData()
	local current = SNH.getMaxPetSlots()
	if current >= SNH.getAbsoluteMaxPetSlots() then return nil end
	if type(data.GetNextPrice) == "function" then
		return tonumber(data.GetNextPrice(current))
	end
	local prices = data.Prices or FALLBACK_PET_SLOT_PRICES
	local idx = math.max(0, current - (data.BaseMax or PET_SLOT_BASE_MAX)) + 1
	return tonumber(prices[idx])
end

SNH.tryBuyPetSlot = function()
	if not AUTO_BUY_PET_SLOT then return false end
	if petSlotBuying then return false end
	if SNH.isActionPausedForSeedSnipe() then return false end
	if not SNH.isMaxExpansionReached() then return false end
	SNH.ensureNetworking()
	if not Networking or not Networking.Pets or not Networking.Pets.RequestPurchasePetSlot then
		return false
	end

	local now = tick()
	if now - lastPetSlotBuyAt < (PET_SLOT_BUY_GAP or 45) then return false end
	if now - lastPetSlotBuyFailAt < (PET_SLOT_BUY_FAIL_COOLDOWN or 30) then return false end

	local currentSlots = SNH.getMaxPetSlots()
	if currentSlots >= SNH.getAbsoluteMaxPetSlots() then return false end

	local price = SNH.getNextPetSlotPrice()
	if not price or price <= 0 then return false end

	local reserve = math.max(0, tonumber(PET_SLOT_BUY_RESERVE) or 0)
	if API.getSheckles() < price + reserve then return false end

	petSlotBuying = true
	lastPetSlotBuyAt = now
	local before = currentSlots
	SNH.setStatus(("Buying pet slot %d -> %d (%s)"):format(
		before, before + 1, SNH.formatAbbrev(price)))

	local fired = pcall(function()
		Networking.Pets.RequestPurchasePetSlot:Fire()
	end)
	if not fired then
		petSlotBuying = false
		lastPetSlotBuyFailAt = now
		return false
	end

	local deadline = tick() + 6
	local success = false
	while tick() < deadline do
		task.wait(0.3)
		if SNH.getMaxPetSlots() > before then
			success = true
			break
		end
	end

	petSlotBuying = false
	if success then
		SNH.invalidateEquippedPetCache()
		print(("[So Nach Hup] Pet slot unlocked: %d -> %d"):format(before, SNH.getMaxPetSlots()))
		SNH.setStatus(("Pet slots: %d/%d"):format(SNH.countEquippedPets(), SNH.getMaxPetSlots()))
		return true
	end

	lastPetSlotBuyFailAt = now
	return false
end
end
tryEquipBestPets = SNH.tryEquipBestPets
schedulePetEquipAfterTame = SNH.schedulePetEquipAfterTame
tryBuyPetSlot = SNH.tryBuyPetSlot

do --[[ SNH: Stats ]]
SNH.getMaxFruitCapacity = function()
	local maxFruit = LocalPlayer:GetAttribute("MaxFruitCapacity")
	return (type(maxFruit) == "number" and maxFruit > 0) and math.floor(maxFruit) or 100
end

SNH.getMaxPetSlots = function()
	local maxSlots = LocalPlayer:GetAttribute("MaxEquippedPets")
	return (type(maxSlots) == "number" and maxSlots > 0) and math.floor(maxSlots) or PET_SLOT_BASE_MAX
end

SNH.isSellableFruit = function(item)
	if not item then return false end
	if item:IsA("Tool") then
		return item:GetAttribute("FruitName") ~= nil
			or item:GetAttribute("HarvestedFruit") == true
			or item:GetAttribute("Fruit") ~= nil
	end
	if item:IsA("Configuration") and item:GetAttribute("FruitProxy") == true then
		return true
	end
	return false
end

SNH.countFruitInInventory = function()
	local count = 0
	for _, bag in { LocalPlayer.Character, LocalPlayer.Backpack } do
		if not bag then continue end
		for _, item in bag:GetChildren() do
			if SNH.isSellableFruit(item) then
				count += 1
			elseif item:IsA("Tool") then
				for _, child in item:GetChildren() do
					if SNH.isSellableFruit(child) then count += 1 end
				end
			end
		end
	end
	return count
end

SNH.forEachFruitTool = function(fn)
	if type(fn) ~= "function" then return end
	for _, bag in { LocalPlayer.Character, LocalPlayer.Backpack } do
		if not bag then continue end
		for _, item in bag:GetChildren() do
			if SNH.isSellableFruit(item) then
				fn(item)
			elseif item:IsA("Tool") then
				for _, child in item:GetChildren() do
					if SNH.isSellableFruit(child) then
						fn(child)
					end
				end
			end
		end
	end
end

SNH.getFruitToolEntry = function(tool)
	if not tool or not SNH.isSellableFruit(tool) then return nil end
	local fruitId = tool:GetAttribute("FruitId")
	if not fruitId or fruitId == "" then return nil end
	local mutation = tool:GetAttribute("Mutation")
	local hasMutation = mutation ~= nil and tostring(mutation) ~= ""
	return {
		tool = tool,
		fruitId = tostring(fruitId),
		mutation = mutation,
		hasMutation = hasMutation,
		isFavorite = tool:GetAttribute("IsFavorite") == true,
		seedName = tool:GetAttribute("FruitName") or tool:GetAttribute("SeedName"),
		value = API.getFruitValueFromModel(tool) or 0,
	}
end

SNH.getFruitToolEntries = function(mutatedOnly)
	local entries, seen = {}, {}
	SNH.forEachFruitTool(function(tool)
		local entry = SNH.getFruitToolEntry(tool)
		if not entry or seen[entry.fruitId] then return end
		if mutatedOnly and not entry.hasMutation then return end
		seen[entry.fruitId] = true
		table.insert(entries, entry)
	end)
	return entries
end

SNH.countMutatedFruits = function()
	local n = 0
	for _, entry in SNH.getFruitToolEntries(true) do
		n += 1
	end
	return n
end

SNH.setFruitFavorite = function(fruitId, favorite)
	if not fruitId then return false end
	fruitId = tostring(fruitId)
	local ok = false
	if Networking and Networking.Backpack and Networking.Backpack.SetFruitFavorite then
		pcall(function()
			Networking.Backpack.SetFruitFavorite:Fire(fruitId, favorite == true)
			ok = true
		end)
	end
	SNH.forEachFruitTool(function(tool)
		if tostring(tool:GetAttribute("FruitId") or "") ~= fruitId then return end
		tool:SetAttribute("IsFavorite", favorite == true and true or nil)
	end)
	return ok
end

SNH.protectMutatedFruits = function()
	local protected = 0
	for _, entry in SNH.getFruitToolEntries(true) do
		if not entry.isFavorite then
			if SNH.setFruitFavorite(entry.fruitId, true) then
				protected += 1
			end
		end
	end
	return protected
end

SNH.unfavoriteMutatedFruits = function()
	local cleared = 0
	for _, entry in SNH.getFruitToolEntries(true) do
		if entry.isFavorite then
			if SNH.setFruitFavorite(entry.fruitId, false) then
				cleared += 1
			end
		end
	end
	return cleared
end

-- Favorite every mutated fruit except N lowest-value bait fruit(s) for the first AskBidAll.
SNH.prepareMutationBargainFavorites = function(keepUnfavorited)
	keepUnfavorited = math.max(1, tonumber(keepUnfavorited) or 1)
	local mutated = SNH.getFruitToolEntries(true)
	if #mutated == 0 then return false end
	table.sort(mutated, function(a, b)
		return (a.value or 0) < (b.value or 0)
	end)
	local bait = {}
	for i = 1, math.min(keepUnfavorited, #mutated) do
		bait[mutated[i].fruitId] = true
	end
	for _, entry in mutated do
		local favorite = bait[entry.fruitId] ~= true
		SNH.setFruitFavorite(entry.fruitId, favorite)
	end
	return true
end

SNH.trySellNonMutationFruits = function()
	if not Networking or not Networking.NPCS or not Networking.NPCS.SellAll then
		return false
	end
	if SNH.countFruitInInventory() < 1 then return false end
	if AUTO_SELL_SKIP_MUTATION ~= false then
		SNH.protectMutatedFruits()
	end
	local ok, result = pcall(function()
		return Networking.NPCS.SellAll:Fire()
	end)
	return ok and type(result) == "table" and result.Success == true
end

SNH.tryBargainMutatedFruits = function()
	if not AUTO_BARGAIN_MUTATION then return false end
	SNH.ensureNetworking()
	if not Networking or not Networking.NPCS or not Networking.NPCS.AskBidAll then
		return false
	end
	if not Networking.NPCS.SellAll then return false end
	if not Networking.Backpack or not Networking.Backpack.SetFruitFavorite then
		return false
	end
	if mutationBargainActive then return false end

	local mutated = SNH.getFruitToolEntries(true)
	local minCount = tonumber(MUTATION_BARGAIN_MIN_COUNT) or 11
	if #mutated < minCount then return false end

	local now = tick()
	if now - lastMutationBargainAt < (tonumber(MUTATION_BARGAIN_COOLDOWN) or 32) then
		return false
	end

	mutationBargainActive = true
	SNH.setStatus(("Mutation bargain x2 | %d fruits"):format(#mutated))

	local bid1, bid2, sellResult
	local okRun, runErr = pcall(function()
		SNH.prepareMutationBargainFavorites(MUTATION_BARGAIN_KEEP_UNFAVORITED)
		task.wait(0.15)

		bid1 = Networking.NPCS.AskBidAll:Fire()
		if not bid1 or not bid1.Success then
			if bid1 and bid1.Reason == "Cooldown" and bid1.Remaining then
				lastMutationBargainAt = tick() - math.max(0, 32 - tonumber(bid1.Remaining))
			end
			error(tostring(bid1 and bid1.Reason or "AskBidAll failed"))
		end
		task.wait(0.2)

		SNH.unfavoriteMutatedFruits()
		task.wait(0.15)

		bid2 = Networking.NPCS.AskBidAll:Fire()
		task.wait(0.2)

		sellResult = Networking.NPCS.SellAll:Fire()
	end)

	lastMutationBargainAt = tick()
	mutationBargainActive = false

	if not okRun then
		warn(("[So Nach Hup] Mutation bargain failed: %s"):format(tostring(runErr)))
		return false
	end

	if sellResult and sellResult.Success then
		local sold = tonumber(sellResult.SoldCount) or 0
		local price = tonumber(sellResult.SellPrice) or 0
		print(("[So Nach Hup] Mutation bargain sold %d fruits for %s"):format(
			sold, SNH.formatAbbrev(price)))
		SNH.setStatus(("Mutation bargain sold %d | %s"):format(sold, SNH.formatAbbrev(price)))
		fruitCountCache.time = 0
		return true
	end

	return bid2 and bid2.Success == true
end

SNH.trySellInventory = function()
	if not AUTO_SELL then return false end
	SNH.ensureNetworking()
	if not Networking or not Networking.NPCS or not Networking.NPCS.SellAll then
		return false
	end
	if SNH.countFruitInInventory() < 1 then return false end
	if mutationBargainActive then return false end

	if AUTO_BARGAIN_MUTATION and SNH.countMutatedFruits() >= (tonumber(MUTATION_BARGAIN_MIN_COUNT) or 11) then
		return SNH.tryBargainMutatedFruits()
	end

	return SNH.trySellNonMutationFruits()
end

SNH.countPlantedSeed = function(plot, seedName)
	if not plot or not seedName then return 0 end
	local plants = plot:FindFirstChild("Plants")
	if not plants then return 0 end
	local count = 0
	for _, child in plants:GetChildren() do
		if not child:IsA("Model") then continue end
		if not child:GetAttribute("PlantId") then continue end
		if tonumber(child:GetAttribute("UserId")) ~= LocalPlayer.UserId then continue end
		local name = child:GetAttribute("SeedName") or child:GetAttribute("CorePartName")
		if name == seedName then count += 1 end
	end
	return count
end

SNH.countPlants = function(plot, forceFresh)
	if not plot then return 0 end
	local now = tick()
	if not forceFresh and plantCountCache.plot == plot and now - plantCountCache.time < PLANT_COUNT_CACHE_TTL then
		return plantCountCache.count
	end
	local plants = plot:FindFirstChild("Plants")
	if not plants then
		plantCountCache.plot = plot
		plantCountCache.time = now
		plantCountCache.count = 0
		return 0
	end
	local count = 0
	for _, child in plants:GetChildren() do
		if child:IsA("Model") and child:GetAttribute("PlantId") then count += 1 end
	end
	plantCountCache.plot = plot
	plantCountCache.time = now
	plantCountCache.count = count
	return count
end

SNH.getRemainingPlantSlots = function(plot, forceFresh)
	if not plot then return 0 end
	local count = SNH.countPlants(plot, forceFresh == true)
	return math.max(0, SNH.getPlantCapLimit() - count)
end

SNH.countActivePetsInPlot = function(plot)
	if not plot then return 0 end
	local equipped = API.getEquippedPets()
	if #equipped > 0 then return #equipped end
	local petsFolder = plot:FindFirstChild("Pets")
	if not petsFolder then return 0 end
	local count = 0
	for _, child in petsFolder:GetChildren() do
		if child:GetAttribute("Pet") or child:GetAttribute("PetName") then count += 1 end
	end
	return count
end

SNH.resolveMutationSeedKey = function(seedName)
	if type(seedName) ~= "string" then return nil end
	if seedName == "Gold" or seedName == "Rainbow" then return seedName end
	local compact = string.lower(seedName):gsub("%s+", "")
	if compact == "gold" or compact == "goldseed" then return "Gold" end
	if compact == "rainbow" or compact == "rainbowseed" then return "Rainbow" end
	return nil
end

SNH.getReplicaSeedCount = function(seedName)
	local key = SNH.resolveMutationSeedKey(seedName)
	if not key then return 0 end
	local replica = SNH.getPetReplica and SNH.getPetReplica()
	local inventory = replica and replica.Data and replica.Data.Inventory
	if type(inventory) == "table" and type(inventory.Seeds) == "table" then
		return math.max(0, math.floor(tonumber(inventory.Seeds[key]) or 0))
	end
	return 0
end

SNH.countMutationSeedInInventory = function(seedName)
	local key = SNH.resolveMutationSeedKey(seedName)
	if not key then return 0 end

	local toolTotal = 0
	for _, bag in { LocalPlayer.Character, LocalPlayer.Backpack } do
		if not bag then continue end
		for _, item in bag:GetChildren() do
			if not item:IsA("Tool") then continue end
			local toolSeed = SNH.getSeedToolName and SNH.getSeedToolName(item) or item:GetAttribute("SeedTool")
			local matches = toolSeed == key
				or toolSeed == (key .. " Seed")
				or (key == "Gold" and item:GetAttribute("GoldSeed") == true)
				or (key == "Rainbow" and item:GetAttribute("RainbowSeed") == true)
			if not matches then continue end
			toolTotal += math.max(1, math.floor(tonumber(item:GetAttribute("Count")) or 1))
		end
	end

	local replicaTotal = SNH.getReplicaSeedCount(key)
	return math.max(toolTotal, replicaTotal)
end

SNH.countSpecialSeeds = function()
	return SNH.countMutationSeedInInventory("Rainbow"), SNH.countMutationSeedInInventory("Gold")
end

SNH.getBestStealDisplay = function()
	if lastSuccessfulSteal then
		return lastSuccessfulSteal.seedName or "Fruit", lastSuccessfulSteal.value or 0
	end
	return "None", 0
end

SNH.formatEventTime = function(seconds)
	seconds = math.max(0, math.floor(tonumber(seconds) or 0))
	local m = math.floor(seconds / 60)
	local s = seconds % 60
	if m > 0 then return string.format("%dm %ds", m, s) end
	return string.format("%ds", s)
end

SNH.getEventsWeatherText = function()
	local w = API.getCurrentWeather()
	local phase = w.phase or "Day"
	local eventName = w.currentEvent or phase
	local eventLeft = w.eventTimeLeft or 0
	local nextPhase = ({ Day = "Sunset", Sunset = "Night", Night = "Day" })[phase] or "Sunset"
	local eventStr = ("%s (%s → %s)"):format(eventName, SNH.formatEventTime(eventLeft), nextPhase)
	local globals = w.globalWeathers or {}
	if #globals > 0 then
		local names = {}
		for _, g in globals do table.insert(names, g.name) end
		return eventStr, table.concat(names, ", ")
	end
	return eventStr, "None"
end
end
getBestStealDisplay = SNH.getBestStealDisplay
getEventsWeatherText = SNH.getEventsWeatherText
countSpecialSeeds = SNH.countSpecialSeeds
getMaxPetSlots = SNH.getMaxPetSlots
countFruitInInventory = SNH.countFruitInInventory
countPlantedSeed = SNH.countPlantedSeed
countPlants = SNH.countPlants
getMaxFruitCapacity = SNH.getMaxFruitCapacity
countActivePetsInPlot = SNH.countActivePetsInPlot

do --[[ SNH: HudWidgets ]]
SNH.getHudScale = function()
	local camera = workspace.CurrentCamera
	if not camera then return 1 end
	local viewport = camera.ViewportSize
	local inset = GuiService:GetGuiInset()
	local w = math.max(1, (viewport.X - inset.X) * 0.92)
	local h = math.max(1, (viewport.Y - inset.Y) * 0.92)
	return math.clamp(math.min(w / 640, h / 520), 0.55, 1.15)
end

SNH.makeHudDivider = function(parent, order)
	local line = Instance.new("Frame")
	line.LayoutOrder = order
	line.Size = UDim2.new(1, 0, 0, 2)
	line.BackgroundColor3 = Color3.fromRGB(255, 220, 50)
	line.BorderSizePixel = 0
	line.Parent = parent
end

SNH.makeHudLabel = function(parent, order, size, allowWrap)
	local label = Instance.new("TextLabel")
	label.LayoutOrder = order
	label.Size = UDim2.new(1, 0, 0, size + 4)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.TextSize = size
	label.TextColor3 = Color3.fromRGB(245, 245, 250)
	label.TextXAlignment = Enum.TextXAlignment.Center
	label.TextWrapped = allowWrap == true
	label.TextTruncate = Enum.TextTruncate.AtEnd
	label.Text = "..."
	label.Parent = parent
	return label
end
end

do --[[ SNH: HudSetup ]]
SNH.getSecureGuiParent = function()
	return LocalPlayer:WaitForChild("PlayerGui")
end

SNH.tryHiddenGuiParent = function()
	local ok, parent = pcall(function()
		if typeof(gethui) ~= "function" then return nil end
		return gethui()
	end)
	if ok and parent then
		return parent
	end
	return nil
end

SNH.registerGuiRecreate = function(token, recreateFn)
	if type(token) ~= "string" or token == "" or type(recreateFn) ~= "function" then return end
	PERF.guiRecreateCallbacks[token] = recreateFn
end

SNH.suppressGuiRecreate = function(seconds)
	guiRecreateSuppressUntil = tick() + math.max(0.25, tonumber(seconds) or 1)
end

SNH.isGuiRecreateSuppressed = function()
	return tick() < (guiRecreateSuppressUntil or 0)
end

SNH.applyGuiProtection = function(gui, recreateToken)
	if not gui or not gui:IsA("ScreenGui") then return gui end
	pcall(function()
		if typeof(cloneref) == "function" then
			gui = cloneref(gui)
		end
	end)
	pcall(function()
		if syn and typeof(syn.protect_gui) == "function" then
			syn.protect_gui(gui)
		end
	end)
	gui.ResetOnSpawn = false
	gui:SetAttribute("SNH_Protected", true)
	if type(recreateToken) == "string" and recreateToken ~= "" then
		gui:SetAttribute("SNH_RecreateToken", recreateToken)
		local conn = gui.Destroying:Connect(function()
			if SNH.isGuiRecreateSuppressed() then return end
			task.defer(function()
				if SNH.isGuiRecreateSuppressed() then return end
				local fn = PERF.guiRecreateCallbacks[recreateToken]
				if fn then pcall(fn) end
			end)
		end)
		SNH.trackConn(conn, "gui_protect")
		table.insert(PERF.guiProtectConns, conn)
	end
	return gui
end

SNH.mountSecureGui = function(gui, opts)
	opts = opts or {}
	gui.Parent = SNH.getSecureGuiParent()
	if opts.displayOrder then
		gui.DisplayOrder = opts.displayOrder
	end
	if opts.zIndexBehavior then
		gui.ZIndexBehavior = opts.zIndexBehavior
	end
	return SNH.applyGuiProtection(gui, opts.recreateToken)
end

SNH.startGuiProtectWatchdog = function()
	if PERF.guiProtectWatchdog then return end
	PERF.guiProtectWatchdog = true
	task.spawn(function()
		while running do
			if SHOW_HUD then
				pcall(function()
					local gui = SNH.hudGui
					local missing = not gui or not gui.Parent
					if missing then
						local now = tick()
						local gap = tonumber(HUD_WATCHDOG_GAP) or 5
						local cooldown = tonumber(HUD_RECREATE_COOLDOWN) or 4
						if now - (lastHudSetupAt or 0) >= cooldown then
							SNH.setupHud()
						end
					end
				end)
			end
			if PERF.blackScreen then
				pcall(function()
					if not PERF.blackOverlayGui or not PERF.blackOverlayGui.Parent then
						SNH.setupBlackScreenToggle()
					end
				end)
			end
			task.wait(math.max(2, tonumber(HUD_WATCHDOG_GAP) or 5))
		end
	end)
end

SNH.destroyHudGui = function(inst)
	if not inst then return end
	SNH.suppressGuiRecreate(2)
	pcall(function() inst:Destroy() end)
end

SNH.setupHud = function()
	if hudSetupRunning then return end
	if SNH.hudGui and SNH.hudGui.Parent then
		pcall(SNH.refreshHud)
		return
	end
	hudSetupRunning = true
	local setupOk, setupErr = pcall(function()
	SNH.suppressGuiRecreate(2)
	local playerGui = LocalPlayer:WaitForChild("PlayerGui")
	pcall(function()
		local hidden = SNH.tryHiddenGuiParent()
		if hidden then
			local old = hidden:FindFirstChild("SoNachHupStats")
			if old and old ~= SNH.hudGui then SNH.destroyHudGui(old) end
		end
	end)
	local oldPg = playerGui:FindFirstChild("SoNachHupStats")
	if oldPg and oldPg ~= SNH.hudGui then SNH.destroyHudGui(oldPg) end
	SNH.hudGui = nil
	SNH.hudLabels = nil

	local gui = Instance.new("ScreenGui")
	gui.Name = "SoNachHupStats"
	gui.IgnoreGuiInset = true
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.DisplayOrder = HUD_DISPLAY_ORDER or 9999

	local card = Instance.new("Frame")
	card.Name = "Card"
	card.AnchorPoint = Vector2.new(0.5, 0.5)
	card.Position = UDim2.fromScale(0.5, 0.5)
	card.Size = UDim2.fromOffset(640, 0)
	card.AutomaticSize = Enum.AutomaticSize.Y
	card.BackgroundColor3 = Color3.fromRGB(28, 30, 36)
	card.BackgroundTransparency = 0.08
	card.BorderSizePixel = 0
	card.ZIndex = HUD_DISPLAY_ORDER or 9999
	card.Parent = gui
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)
	local stroke = Instance.new("UIStroke", card)
	stroke.Color = Color3.fromRGB(70, 75, 90)
	stroke.Thickness = 1.5
	stroke.Transparency = 0.4

	SNH.hudScale = Instance.new("UIScale", card)
	SNH.hudScale.Scale = SNH.getHudScale()

	local pad = Instance.new("UIPadding", card)
	pad.PaddingTop = UDim.new(0, 16)
	pad.PaddingBottom = UDim.new(0, 16)
	pad.PaddingLeft = UDim.new(0, 14)
	pad.PaddingRight = UDim.new(0, 14)

	local stack = Instance.new("Frame", card)
	stack.Size = UDim2.new(1, 0, 0, 0)
	stack.AutomaticSize = Enum.AutomaticSize.Y
	stack.BackgroundTransparency = 1

	local layout = Instance.new("UIListLayout", stack)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 8)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local labels = {}
	labels.title = SNH.makeHudLabel(stack, 1, 26)
	labels.title.Text = SCRIPT_NAME
	labels.title.TextColor3 = Color3.fromRGB(255, 220, 80)
	labels.user = SNH.makeHudLabel(stack, 2, 22)
	labels.user.Text = "👤 Username: ..."
	labels.status = SNH.makeHudLabel(stack, 3, 20)
	labels.status.Text = "📋 Loading..."
	labels.status.TextColor3 = Color3.fromRGB(255, 210, 100)
	SNH.makeHudDivider(stack, 4)
	labels.row1 = SNH.makeHudLabel(stack, 5, 16)
	labels.row1.TextColor3 = Color3.fromRGB(130, 230, 150)
	labels.row1b = SNH.makeHudLabel(stack, 6, 16)
	labels.row1b.TextColor3 = Color3.fromRGB(120, 210, 140)
	labels.row2 = SNH.makeHudLabel(stack, 7, 16)
	labels.row2.TextColor3 = Color3.fromRGB(200, 185, 255)
	labels.row2b = SNH.makeHudLabel(stack, 8, 16)
	labels.row2b.TextColor3 = Color3.fromRGB(200, 185, 255)
	labels.row3 = SNH.makeHudLabel(stack, 9, 16)
	labels.row3.TextColor3 = Color3.fromRGB(150, 200, 255)
	labels.steal = SNH.makeHudLabel(stack, 10, 18)
	labels.steal.TextColor3 = Color3.fromRGB(255, 150, 120)
	SNH.makeHudDivider(stack, 11)
	labels.time = SNH.makeHudLabel(stack, 12, 18)
	labels.time.TextColor3 = Color3.fromRGB(180, 210, 255)
	gui = SNH.mountSecureGui(gui, {
		displayOrder = HUD_DISPLAY_ORDER or 9999,
		zIndexBehavior = Enum.ZIndexBehavior.Sibling,
		recreateToken = "hud",
	})
	SNH.hudGui = gui
	SNH.hudLabels = labels
	if SHOW_HUD then
		pcall(SNH.refreshHud)
	end
	end)
	lastHudSetupAt = tick()
	hudSetupRunning = false
	if not setupOk then
		warn("[So Nach Hup] HUD setup error: " .. tostring(setupErr))
	end
end
end

do --[[ SNH: HudRefresh ]]
SNH.formatEquippedPetList = function()
	local entries = SNH.getEquippedPetEntries()
	if #entries == 0 then return "None" end
	local names = {}
	for _, entry in entries do
		local display = PetDisplayByKey[entry.key] or entry.key
		table.insert(names, display)
	end
	return table.concat(names, ", ")
end

SNH.getCachedFruitCount = function()
	local now = tick()
	if now - fruitCountCache.time < FRUIT_COUNT_CACHE_TTL then
		return fruitCountCache.count
	end
	local count = SNH.countFruitInInventory()
	fruitCountCache.time = now
	fruitCountCache.count = count
	return count
end

SNH.updateMoneyPerSec = function(sheckles)
	local now = tick()
	if moneyPerSecState.time <= 0 then
		moneyPerSecState.sheckles = sheckles
		moneyPerSecState.time = now
		moneyPerSecState.rate = 0
		return 0
	end
	local dt = now - moneyPerSecState.time
	if dt >= 1 then
		moneyPerSecState.rate = (sheckles - moneyPerSecState.sheckles) / dt
		moneyPerSecState.sheckles = sheckles
		moneyPerSecState.time = now
	end
	return moneyPerSecState.rate
end

SNH.getHudStats = function()
	local now = tick()
	if hudStatsCache.data and now - hudStatsCache.time < HUD_REFRESH_GAP then
		return hudStatsCache.data
	end
	local _, plot = API.getLocalPlot()
	local rainbowSeeds, goldSeeds = SNH.countSpecialSeeds()
	local eventText, weatherText = SNH.getEventsWeatherText()
	local sheckles = API.getSheckles()
	hudStatsCache.data = {
		plot = plot,
		sheckles = sheckles,
		moneyPerSec = SNH.updateMoneyPerSec(sheckles),
		plants = SNH.countPlants(plot),
		fruits = SNH.getCachedFruitCount(),
		maxFruit = SNH.getMaxFruitCapacity(),
		activePets = SNH.countActivePetsInPlot(plot),
		maxPets = SNH.getMaxPetSlots(),
		equippedPetList = SNH.formatEquippedPetList(),
		expansions = API.getOwnedExpansions(),
		rainbowSeeds = rainbowSeeds,
		goldSeeds = goldSeeds,
		eventText = eventText,
		weatherText = weatherText,
	}
	hudStatsCache.time = now
	return hudStatsCache.data
end

SNH.refreshHud = function()
	if not SHOW_HUD then return end
	if not SNH.hudGui or not SNH.hudGui.Parent or not SNH.hudLabels then
		if not hudSetupRunning and tick() - (lastHudSetupAt or 0) >= (tonumber(HUD_RECREATE_COOLDOWN) or 4) then
			pcall(SNH.setupHud)
		end
		return
	end
	local labels = SNH.hudLabels
	if not labels.user or not labels.user.Parent then return end
	local ok, err = pcall(function()
		local stats = SNH.getHudStats()
		local stealName, stealValue = SNH.getBestStealDisplay()

		labels.user.Text = "👤 Username: " .. LocalPlayer.Name
		labels.status.Text = "📋 " .. statusText
		labels.row1.Text = ("💰 Sheckles: %s | %s/s"):format(
			SNH.formatAbbrev(stats.sheckles), SNH.formatAbbrev(stats.moneyPerSec or 0))
		labels.row1b.Text = ("🌱 Planted: %d | 🍎 Fruits: %d/%d"):format(
			stats.plants, stats.fruits, stats.maxFruit)
		labels.row2.Text = ("🐾 Active Pets: %d/%d | %s"):format(
			stats.activePets, stats.maxPets, stats.equippedPetList)
		labels.row2b.Text = ("🏡 Plot: %d/%d | 🌈 Rainbow: %d | 🟡 Gold: %d"):format(
			stats.expansions, MAX_EXPANSIONS, stats.rainbowSeeds, stats.goldSeeds)
		labels.row3.Text = ("✨ Phase: %s | 🌦️ Weather: %s"):format(stats.eventText, stats.weatherText)
		if stealName == "None" then
			labels.steal.Text = "🎯 Best Steal: None"
		else
			local from = lastSuccessfulSteal and lastSuccessfulSteal.ownerName or ""
			labels.steal.Text = from ~= ""
				and ("🎯 Best Steal: %s (%s) from %s"):format(stealName, SNH.formatAbbrev(stealValue), from)
				or ("🎯 Best Steal: %s (%s)"):format(stealName, SNH.formatAbbrev(stealValue))
		end
		labels.time.Text = ("⏰ Time: %s | 💾 %.0f MB"):format(
			SNH.formatElapsed(), SNH.getClientMemoryMb and SNH.getClientMemoryMb() or 0)
		if SNH.hudScale then SNH.hudScale.Scale = SNH.getHudScale() end
	end)
	if not ok then
		labels.status.Text = "📋 HUD loading..."
	end
end
end

do --[[ SNH: HudMailbox ]]
SNH.tryClaimMailbox = function()
	if not AUTO_MAILBOX or not Networking or not Networking.Mailbox or claimingMailbox then
		return false
	end
	claimingMailbox = true
	local claimed = 0
	local ok, inbox = pcall(function()
		return Networking.Mailbox.OpenInbox:Fire()
	end)
	if ok and typeof(inbox) == "table" then
		for mailId in inbox do
			local cok, success = pcall(function()
				return Networking.Mailbox.Claim:Fire(mailId)
			end)
			if cok and success then
				claimed += 1
			end
		end
	end
	claimingMailbox = false
	if claimed > 0 then
		SNH.setStatus(("Claimed %d mail"):format(claimed))
	end
	return claimed > 0
end

SNH.setupMailboxListener = function()
	if mailboxHooked or not Networking or not Networking.Mailbox then return end
	mailboxHooked = true
	if Networking.Mailbox.Updated and Networking.Mailbox.Updated.OnClientEvent then
		Networking.Mailbox.Updated.OnClientEvent:Connect(function()
			if AUTO_MAILBOX then
				task.defer(SNH.tryClaimMailbox)
			end
		end)
	end
	task.spawn(function()
		task.wait(2)
		SNH.tryClaimMailbox()
		while running do
			task.wait(30)
			if AUTO_MAILBOX then SNH.tryClaimMailbox() end
		end
	end)
end
end

do --[[ SNH: HudGift ]]
SNH.setupGiftListener = function()
	if giftHooked or not Networking or not Networking.Gifting then return end
	if not (Networking.Gifting.Prompted and Networking.Gifting.Response) then return end
	giftHooked = true
	Networking.Gifting.Prompted.OnClientEvent:Connect(function(sender, itemName)
		if not AUTO_GIFT then return end
		pcall(function()
			Networking.Gifting.Response:Fire(sender, true)
		end)
		SNH.setStatus("Accepted gift")
		print(("[So Nach Hup] Auto-accepted gift%s"):format(
			itemName and (" (" .. tostring(itemName) .. ")") or ""))
	end)
end
end

do --[[ SNH: Tutorial ]]
SNH.isTutorialUiActive = function()
	local gui = LocalPlayer:FindFirstChild("PlayerGui")
	if not gui then return false end
	local tutorialUI = gui:FindFirstChild("TutorialUI")
	if not tutorialUI then return false end
	if tutorialUI:IsA("ScreenGui") and tutorialUI.Enabled == false then
		return false
	end
	local pointer = tutorialUI:FindFirstChild("Pointer")
	if pointer and pointer:IsA("GuiObject") and pointer.Visible then
		return true
	end
	local focus = tutorialUI:FindFirstChild("Focus")
	if focus and focus:IsA("GuiObject") and focus.Visible then
		return true
	end
	return false
end

SNH.isTutorialActive = function()
	if workspace:GetAttribute("InTutorial") == true then return true end
	return SNH.isTutorialUiActive()
end

SNH.fireTutorialComplete = function()
	if not Networking or not Networking.Tutorial or not Networking.Tutorial.Complete then
		return false, "Networking.Tutorial.Complete missing"
	end
	local ok, err = pcall(function()
		Networking.Tutorial.Complete:Fire()
	end)
	if not ok then return false, tostring(err) end
	pcall(function() workspace:SetAttribute("InTutorial", nil) end)
	return true, "TutorialComplete fired"
end

SNH.probeCanGiftOnServer = function()
	if not Networking or not Networking.Mailbox or not Networking.Mailbox.SendBatch then
		return nil, "Mailbox.SendBatch missing"
	end
	local ok, success, msg = pcall(function()
		return Networking.Mailbox.SendBatch:Fire(1, {}, "")
	end)
	if not ok then return false, tostring(msg) end
	if success == true then return true, "server allows gifting" end
	local reason = string.lower(tostring(msg or "unknown"))
	if reason:find("tutorial", 1, true) then return false, msg end
	return true, msg
end

SNH.trySellForTutorial = function()
	if not Networking or not Networking.NPCS or not Networking.NPCS.SellAll then
		return false, "NPCS.SellAll missing"
	end
	local ok, result = pcall(function()
		return Networking.NPCS.SellAll:Fire()
	end)
	if not ok then return false, tostring(result) end
	if type(result) == "table" and result.Success then
		SNH.fireTutorialComplete()
		return true, "sold for tutorial"
	end
	return false, "nothing to sell"
end

SNH.needsTutorialCompletion = function()
	if SNH.isTutorialActive() then return true end
	local canGift = SNH.probeCanGiftOnServer()
	return canGift == false
end

SNH.tryAutoCompleteTutorial = function(force)
	if not AUTO_COMPLETE_TUTORIAL and not force then return false end
	SNH.ensureNetworking()
	if not SNH.isTutorialActive() then
		local canGift = SNH.probeCanGiftOnServer()
		if canGift == true then
			tutorialCompleteChecked = true
			return true
		end
		if canGift == false then
			SNH.fireTutorialComplete()
			task.wait(0.35)
		else
			tutorialCompleteChecked = true
			return true
		end
	end

	local fired, fireMsg = SNH.fireTutorialComplete()
	print(("[So Nach Hup] Tutorial complete remote: %s (%s)"):format(tostring(fired), tostring(fireMsg)))
	task.wait(0.35)

	if SNH.isTutorialActive() then
		local sold, sellMsg = SNH.trySellForTutorial()
		print(("[So Nach Hup] Tutorial sell attempt: %s (%s)"):format(tostring(sold), tostring(sellMsg)))
		task.wait(0.35)
	end

	local canGift = SNH.probeCanGiftOnServer()
	local done = not SNH.isTutorialActive() and canGift ~= false
	if done then
		print("[So Nach Hup] Tutorial completed — mail unlocked")
	else
		warn(("[So Nach Hup] Tutorial still blocked: active=%s gift=%s"):format(
			tostring(SNH.isTutorialActive()), tostring(canGift)))
	end
	tutorialCompleteChecked = done
	return done
end

SNH.ensureTutorialForMail = function()
	if tutorialCompleteChecked then return true end
	return SNH.tryAutoCompleteTutorial(false)
end

SNH.startTutorialAutoCompleteLoop = function()
	if not AUTO_COMPLETE_TUTORIAL then return end
	local function runAttempt(label, forceRetry)
		if not AUTO_COMPLETE_TUTORIAL then return end
		if not forceRetry and tutorialCompleteChecked and not SNH.needsTutorialCompletion() then
			print(("[So Nach Hup] Tutorial %s skipped — already complete"):format(label))
			return
		end
		if forceRetry and SNH.needsTutorialCompletion() then
			tutorialCompleteChecked = false
		end
		print(("[So Nach Hup] Tutorial auto-complete (%s)"):format(label))
		pcall(function()
			SNH.tryAutoCompleteTutorial(forceRetry == true)
		end)
	end
	task.spawn(function()
		repeat task.wait(0.5) until LocalPlayer:GetAttribute("LoadingScreenDone") == true
		task.wait(1)
		runAttempt("initial", false)
	end)
	task.delay(math.max(30, tonumber(AUTO_COMPLETE_TUTORIAL_RECHECK_SEC) or 180), function()
		if not running or not AUTO_COMPLETE_TUTORIAL then return end
		if SNH.needsTutorialCompletion() or not tutorialCompleteChecked then
			runAttempt("180s recheck", true)
		else
			print("[So Nach Hup] Tutorial 180s recheck skipped — already complete")
		end
	end)
end
end

do --[[ SNH: AutoMail ]]
SNH.canonicalSeedName = function(seedName)
	if type(seedName) ~= "string" or seedName == "" then return nil end
	for _, name in ALL_SEEDS do
		if name == seedName then return name end
	end
	local compact = string.lower(seedName):gsub("%s+", "")
	if compact == "rainbow" or compact == "rainbowseed" then return "Rainbow" end
	if compact == "gold" or compact == "goldseed" then return "Gold" end
	return nil
end

SNH.getAutoMailSeedRule = function(seedName)
	local key = SNH.canonicalSeedName(seedName) or seedName
	if type(key) ~= "string" or key == "" then return nil end
	local rule = autoMailState.seeds[key]
	if type(rule) ~= "table" then return nil end
	return rule
end

SNH.isSeedReservedForMail = function(seedName)
	if not AUTO_MAIL_SEND or not autoMailState.enabled or autoMailState.selfBlocked then
		return false
	end
	local rule = SNH.getAutoMailSeedRule(seedName)
	return type(rule) == "table" and (tonumber(rule.min) or 0) > 0
end

SNH.getMailSeedBuyTarget = function(seedName)
	local target = BuySeedsConfig[seedName] or 0
	if not AUTO_MAIL_SEND or not autoMailState.enabled or autoMailState.selfBlocked then
		return target
	end
	local rule = SNH.getAutoMailSeedRule(seedName)
	if rule then
		local mailMin = math.max(0, math.floor(tonumber(rule.min) or 0))
		if mailMin > 0 then
			target = math.max(target, mailMin)
		end
	end
	return target
end

SNH.getMailSeedCount = function(seedName)
	local key = SNH.canonicalSeedName(seedName) or seedName
	if key == "Gold" or key == "Rainbow" then
		if SNH.countMutationSeedInInventory then
			return SNH.countMutationSeedInInventory(key)
		end
		return SNH.getReplicaSeedCount(key)
	end
	return SNH.countSeedInInventory(key)
end

SNH.canonicalPetName = function(name)
	if type(name) ~= "string" or name == "" then return nil end
	local resolved = (SNH.resolvePetKey and SNH.resolvePetKey(name)) or name
	return resolved
end

SNH.shouldMailPet = function(petEntry)
	if type(petEntry) ~= "table" then return false end
	local key = SNH.canonicalPetName(petEntry.key or petEntry.name)
	if not key then return false end
	if autoMailState.sendAllPets then return true end
	if autoMailState.petNames[key] then return true end
	local display = PetDisplayByKey[key]
	if display and autoMailState.petNames[display] then return true end
	local compact = key:gsub("%s+", "")
	if autoMailState.petNames[compact] then return true end
	return false
end

SNH.shouldMailSeed = function(seedName, count)
	local key = SNH.canonicalSeedName(seedName)
	if not key then return false, 0 end
	local rule = autoMailState.seeds[key]
	if type(rule) ~= "table" then return false, 0 end
	local minCount = math.max(1, tonumber(rule.min) or 1)
	local keep = math.max(0, tonumber(rule.keep) or 0)
	if count < minCount then return false, 0 end
	local sendCount = math.max(0, count - keep)
	if sendCount <= 0 then return false, 0 end
	return true, sendCount
end

SNH.getMailRecipient = function()
	if autoMailState.selfBlocked then return nil, nil end
	if SNH.isAutoMailSelfRecipient(autoMailState.recipient, autoMailState.recipientUserId) then
		autoMailState.selfBlocked = true
		autoMailState.enabled = false
		AUTO_MAIL_SEND = false
		return nil, nil
	end
	if autoMailState.recipientUserId and autoMailState.recipientUserId > 0 then
		if LocalPlayer.UserId == autoMailState.recipientUserId then
			autoMailState.selfBlocked = true
			autoMailState.enabled = false
			AUTO_MAIL_SEND = false
			return nil, nil
		end
		return autoMailState.recipientUserId, autoMailState.recipient ~= "" and autoMailState.recipient or tostring(autoMailState.recipientUserId)
	end
	local recipient = autoMailState.recipient
	if recipient == "" then return nil, nil end
	local now = tick()
	if autoMailState.cachedRecipientUserId > 0 and autoMailState.cachedRecipientName == recipient and now - autoMailState.lastResolveAt < 60 then
		if LocalPlayer.UserId == autoMailState.cachedRecipientUserId then
			autoMailState.selfBlocked = true
			autoMailState.enabled = false
			AUTO_MAIL_SEND = false
			return nil, nil
		end
		return autoMailState.cachedRecipientUserId, recipient
	end
	if not (Networking and Networking.Mailbox and Networking.Mailbox.LookupPlayer) then
		return nil, nil
	end
	local ok, userId = pcall(function()
		return Networking.Mailbox.LookupPlayer:Fire(recipient)
	end)
	if not ok or type(userId) ~= "number" or userId <= 0 then
		return nil, nil
	end
	if LocalPlayer.UserId == userId then
		autoMailState.selfBlocked = true
		autoMailState.enabled = false
		AUTO_MAIL_SEND = false
		return nil, nil
	end
	autoMailState.cachedRecipientUserId = userId
	autoMailState.cachedRecipientName = recipient
	autoMailState.lastResolveAt = now
	return userId, recipient
end

SNH.buildAutoMailEntries = function()
	local entries = {}
	local total = 0

	local benched = SNH.getBenchedPetEntries and SNH.getBenchedPetEntries() or {}
	for _, pet in benched do
		if total >= autoMailState.batchLimit then break end
		if SNH.shouldMailPet(pet) and pet.id ~= nil then
			table.insert(entries, {
				Category = "Pets",
				ItemKey = pet.id,
				Count = 1,
			})
			total += 1
		end
	end

	if total < autoMailState.batchLimit then
		for seedName, rule in autoMailState.seeds do
			if total >= autoMailState.batchLimit then break end
			if type(rule) ~= "table" then continue end
			local key = SNH.canonicalSeedName(seedName) or seedName
			local count = SNH.getMailSeedCount(key)
			local okSend, sendCount = SNH.shouldMailSeed(key, count)
			if okSend then
				local room = autoMailState.batchLimit - total
				sendCount = math.min(sendCount, room)
				if sendCount > 0 then
					table.insert(entries, {
						Category = "Seeds",
						ItemKey = key,
						Count = sendCount,
					})
					total += sendCount
				end
			end
		end
	end

	return entries
end

SNH.tryAutoMailSend = function()
	if autoMailState.selfBlocked then return false end
	if not AUTO_MAIL_SEND or not autoMailState.enabled then return false end
	if autoMailState.inFlight then return false end
	if not (Networking and Networking.Mailbox and Networking.Mailbox.SendBatch) then return false end
	if AUTO_COMPLETE_TUTORIAL and not tutorialCompleteChecked then
		SNH.ensureTutorialForMail()
	end
	local now = tick()
	if now - autoMailState.lastSendAt < autoMailState.gap then return false end

	local userId, recipientName = SNH.getMailRecipient()
	if not userId then
		SNH.debugLog("MAIL", "skip auto mail: recipient not resolved", "warn")
		return false
	end

	local batch = SNH.buildAutoMailEntries()
	if #batch == 0 then
		for seedName, rule in autoMailState.seeds do
			if type(rule) ~= "table" then continue end
			local minCount = math.max(1, tonumber(rule.min) or 1)
			local key = SNH.canonicalSeedName(seedName) or seedName
			local have = SNH.getMailSeedCount(key)
			if have > 0 and have < minCount then
				SNH.setStatus(("Mail stash %s: %d/%d"):format(key, have, minCount))
				break
			end
		end
		return false
	end

	autoMailState.inFlight = true
	autoMailState.lastSendAt = now
	local note = autoMailState.note or ""
	local ok, success, msg = pcall(function()
		return Networking.Mailbox.SendBatch:Fire(userId, batch, note)
	end)
	autoMailState.inFlight = false

	if ok and success then
		SNH.setStatus(("Auto mailed %d entries to %s"):format(#batch, tostring(recipientName or userId)))
		print(("[So Nach Hup] AutoMail sent %d entries -> %s"):format(#batch, tostring(recipientName or userId)))
		return true
	end

	local reason = tostring(msg or "unknown error")
	SNH.debugLog("MAIL", ("send failed: %s"):format(reason), "warn")
	if AUTO_COMPLETE_TUTORIAL and string.find(string.lower(reason), "tutorial", 1, true) then
		SNH.tryAutoCompleteTutorial(true)
	end
	return false
end
end

do --[[ SNH: AntiAfk ]]
SNH.antiAfkVirtualUserPulse = function(vu)
	if not vu then return false end
	local ok = pcall(function()
		vu:CaptureController()
		vu:ClickButton2(Vector2.new(0, 0))
		vu:ClickButton1(Vector2.new(1, 1))
	end)
	return ok
end

SNH.antiAfkVirtualInputPulse = function()
	-- Shift key removed — it toggles shift-lock and is not needed for anti-AFK.
	local ok = pcall(function()
		local vim = game:GetService("VirtualInputManager")
		vim:SendMouseMoveEvent(1, 1, game)
	end)
	return ok
end

SNH.antiAfkCameraNudge = function()
	local cam = workspace.CurrentCamera
	if not cam then return false end
	return pcall(function()
		cam.CFrame = cam.CFrame * CFrame.Angles(0, math.rad(0.02), 0)
	end)
end

SNH.antiAfkHumanoidHop = function()
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 then return false end
	return pcall(function()
		hum:ChangeState(Enum.HumanoidStateType.Jumping)
	end)
end

SNH.antiAfkDisconnectIdled = function()
	if typeof(getconnections) ~= "function" then return false end
	local disabled = 0
	pcall(function()
		for _, conn in getconnections(LocalPlayer.Idled) do
			if conn.Disable then
				conn:Disable()
				disabled += 1
			elseif conn.Disconnect then
				conn:Disconnect()
				disabled += 1
			end
		end
	end)
	return disabled > 0
end

SNH.antiAfkRootMicroMove = function()
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return false end
	return pcall(function()
		local original = root.CFrame
		root.CFrame = original + Vector3.new(0, 0.02, 0)
		task.wait(0.03)
		root.CFrame = original
	end)
end

SNH.runAntiAfkPulse = function(vu)
	local methods = ANTI_AFK.methods or {}
	local ran = 0
	if methods.virtualUserLoop ~= false then
		if SNH.antiAfkVirtualUserPulse(vu) then ran += 1 end
	end
	if methods.virtualInputManager ~= false then
		if SNH.antiAfkVirtualInputPulse() then ran += 1 end
	end
	if methods.cameraNudge ~= false then
		if SNH.antiAfkCameraNudge() then ran += 1 end
	end
	if methods.humanoidHop ~= false then
		if SNH.antiAfkHumanoidHop() then ran += 1 end
	end
	if methods.rootMicroMove ~= false then
		if SNH.antiAfkRootMicroMove() then ran += 1 end
	end
	return ran
end

SNH.setupAntiAfk = function()
	if antiAfkHooked or ANTI_AFK.enabled == false then return end
	antiAfkHooked = true
	local methods = ANTI_AFK.methods or {}
	local VirtualUser
	pcall(function()
		VirtualUser = game:GetService("VirtualUser")
	end)

	if methods.disconnectIdled ~= false then
		SNH.antiAfkDisconnectIdled()
	end

	if methods.virtualUserIdled ~= false and VirtualUser then
		pcall(function()
			table.insert(antiAfkConns, LocalPlayer.Idled:Connect(function()
				pcall(function()
					SNH.antiAfkVirtualUserPulse(VirtualUser)
				end)
			end))
		end)
	end

	local loopGap = math.max(30, tonumber(ANTI_AFK.loopGap) or 110)
	table.insert(antiAfkThreads, task.spawn(function()
		while running and ANTI_AFK.enabled do
			SNH.runAntiAfkPulse(VirtualUser)
			task.wait(loopGap)
		end
	end))

	local idledGap = math.max(30, tonumber(ANTI_AFK.idledLoopGap) or 115)
	table.insert(antiAfkThreads, task.spawn(function()
		while running and ANTI_AFK.enabled do
			if methods.virtualUserLoop ~= false then
				SNH.antiAfkVirtualUserPulse(VirtualUser)
			end
			task.wait(idledGap)
		end
	end))

	print("[So Nach Hup] Anti-AFK enabled (no shift key — VirtualUser, camera nudge, humanoid hop, disconnect Idled, root micro-move)")
end
end

-- Neutralize a game client controller (e.g. DroppedItemController) by disconnecting its
-- signal connections. Reduces per-frame cost from controllers like DroppedItemController,
-- whose Heartbeat animates every dropped item every frame. Local-only; never touches the server.
SNH.disableGameControllers = function(names, force)
	if type(names) ~= "table" or #names == 0 then return 0 end
	local set = {}
	for _, n in names do
		local key = tostring(n)
		if force or not disabledGameControllerNames[key] then
			set[key] = true
		end
	end
	if not next(set) then return 0 end

	local hasGetConns = typeof(getconnections) == "function"
	local hasDebugInfo = typeof(debug) == "table" and typeof(debug.info) == "function"
	if not hasGetConns then
		warn("[So Nach Hup] DisableGameControllers: executor has no getconnections() — skipped")
		return 0
	end

	local function matchName(fn)
		if not (hasDebugInfo and fn) then return nil end
		local ok, src = pcall(debug.info, fn, "s")
		if not ok or type(src) ~= "string" then return nil end
		for name in set do
			if src:find(name, 1, true) then return name end
		end
		return nil
	end

	local total = 0
	local perName = {}
	local function sweep(signal)
		if not signal then return end
		local ok, conns = pcall(getconnections, signal)
		if not ok or type(conns) ~= "table" then return end
		for _, c in conns do
			local fn = nil
			pcall(function() fn = c.Function end)
			local name = matchName(fn)
			if name then
				pcall(function()
					if c.Disable then c:Disable() else c:Disconnect() end
				end)
				total += 1
				perName[name] = (perName[name] or 0) + 1
			end
		end
	end

	-- Per-frame signals (where controller animation loops live).
	for _, sigName in { "Heartbeat", "RenderStepped", "Stepped", "PreRender", "PreSimulation", "PostSimulation", "PreAnimation" } do
		local ok, sig = pcall(function() return RunService[sigName] end)
		if ok and sig then sweep(sig) end
	end

	-- DroppedItemController also hooks workspace.DroppedItems + DroppedItem.PickupFx.
	pcall(function()
		local dropped = workspace:FindFirstChild("DroppedItems")
		if dropped then
			sweep(dropped.ChildAdded)
			sweep(dropped.ChildRemoved)
		end
	end)
	pcall(function()
		if Networking and Networking.DroppedItem and Networking.DroppedItem.PickupFx then
			sweep(Networking.DroppedItem.PickupFx.OnClientEvent)
		end
	end)

	for name in set do
		disabledGameControllerNames[name] = true
	end

	local parts = {}
	for name, n in perName do table.insert(parts, ("%s=%d"):format(name, n)) end
	print(("[So Nach Hup] Disabled controllers: %s (%d connections)"):format(
		#parts > 0 and table.concat(parts, ", ") or "none matched", total))
	return total
end

SNH.isGearWeatherEventRoot = function(inst)
	if not inst then return false end
	local n = tostring(inst.Name)
	local roots = {
		"RainbowMoon", "Goldmoon", "Gold Moon", "Rainbow Moon", "Pizza Moon", "Bloodmoon",
		"Blood Moon", "Chained Moon", "Starfall", "Snowfall", "Blizzard", "RainDrops",
		"RainContainer", "Lightning", "Weather", "Lantern",
		"Mushroom", "PopVFX", "MoonModel", "Temporary", "Skybox",
	}
	for _, token in roots do
		if n == token or string.find(n, token, 1, true) then return true end
	end
	return false
end

local EFFECT_VFX_CLASS = {
	ParticleEmitter = true,
	Trail = true,
	Beam = true,
	Smoke = true,
	Fire = true,
	Sparkles = true,
	Highlight = true,
	PointLight = true,
	SpotLight = true,
	SurfaceLight = true,
}

SNH.isEffectVfxInstance = function(inst)
	if not inst then return false end
	return EFFECT_VFX_CLASS[inst.ClassName] == true
end

SNH.shouldStripGearWeatherEventVisual = function(inst)
	if not inst or not DISABLE_ALL_EFFECTS then return false end
	if not SNH.isEffectVfxInstance(inst) then return false end
	if SNH.isOptimizeProtected(inst) or SNH.isLocalCharacterInstance(inst) then return false end
	local cur = inst
	while cur and cur ~= workspace do
		if SNH.isGearWeatherEventRoot(cur) then return true end
		if cur.Name == "Sprinklers" and cur.Parent and tostring(cur.Parent.Name):match("^Plot") then
			return true
		end
		cur = cur.Parent
	end
	return false
end

SNH.stripGearWeatherEventVisual = function(inst)
	if not inst or not inst.Parent then return end
	if SNH.isEffectVfxInstance(inst) then
		pcall(function() inst.Enabled = false end)
	elseif inst:IsA("BlurEffect") or inst:IsA("BloomEffect") or inst:IsA("SunRaysEffect")
		or inst:IsA("DepthOfFieldEffect") or inst:IsA("ColorCorrectionEffect") then
		pcall(function() inst.Enabled = false end)
	end
end

SNH.purgeEffectLightingAndCamera = function()
	if not DISABLE_ALL_EFFECTS then return end
	pcall(function()
		for _, child in Lighting:GetChildren() do
			if child:IsA("BlurEffect") or child:IsA("BloomEffect") or child:IsA("SunRaysEffect")
				or child:IsA("DepthOfFieldEffect") or child:IsA("ColorCorrectionEffect") then
				pcall(function() child.Enabled = false end)
			end
		end
	end)
	pcall(function()
		local cam = workspace.CurrentCamera
		if not cam then return end
		for _, child in cam:GetChildren() do
			if SNH.isEffectVfxInstance(child) then
				SNH.stripGearWeatherEventVisual(child)
			end
		end
	end)
end

SNH.purgeWorkspaceWeatherRoots = function()
	if not DISABLE_ALL_EFFECTS then return end
	pcall(function()
		for _, child in workspace:GetChildren() do
			if SNH.isGearWeatherEventRoot(child) and not SNH.isLocalCharacterInstance(child) then
				if child:IsA("Model") or child:IsA("Folder") then
					pcall(function() child:Destroy() end)
				end
			end
		end
	end)
end

SNH.purgeSprinklerVisuals = function(sprinklers)
	if not DISABLE_ALL_EFFECTS or not sprinklers then return end
	pcall(function()
		for _, inst in sprinklers:GetDescendants() do
			if SNH.isEffectVfxInstance(inst) then
				SNH.stripGearWeatherEventVisual(inst)
			end
		end
	end)
end

SNH.purgeGearWeatherEventVisualsOnce = function()
	if not DISABLE_ALL_EFFECTS or not DISABLE_EFFECT_VFX_PURGE or disableAllEffectsPurgeDone then return end
	disableAllEffectsPurgeDone = true
	SNH.purgeEffectLightingAndCamera()
	SNH.purgeWorkspaceWeatherRoots()
	local gardens = workspace:FindFirstChild("Gardens")
	if gardens then
		for _, plot in gardens:GetChildren() do
			local sprinklers = plot:FindFirstChild("Sprinklers")
			if sprinklers then SNH.purgeSprinklerVisuals(sprinklers) end
		end
	end
end

SNH.hideWeatherEventUi = function()
	if not DISABLE_ALL_EFFECTS then return end
	pcall(function()
		local gui = LocalPlayer:FindFirstChild("PlayerGui")
		gui = gui and gui:FindFirstChild("WeatherUI")
		if gui then gui.Enabled = false end
	end)
end

SNH.disableEffectControllers = function(force)
	if not DISABLE_ALL_EFFECTS then return end
	if DISABLE_EFFECT_CONTROLLER_NAMES and #DISABLE_EFFECT_CONTROLLER_NAMES > 0 then
		SNH.disableGameControllers(DISABLE_EFFECT_CONTROLLER_NAMES, force == true)
	end
end

SNH.disableAllEffectsOnce = function(force)
	if not DISABLE_ALL_EFFECTS then return end
	SNH.disableEffectControllers(force)
	SNH.hideWeatherEventUi()
	SNH.purgeEffectLightingAndCamera()
	SNH.purgeWorkspaceWeatherRoots()
	SNH.purgeGearWeatherEventVisualsOnce()
end

SNH.loopDisableAllEffects = function()
	if not DISABLE_ALL_EFFECTS then return end
	local gap = tonumber(DISABLE_ALL_EFFECTS_GAP) or 0
	if gap <= 0 then return end
	local now = tick()
	if now - lastDisableAllEffectsAt < gap then return end
	lastDisableAllEffectsAt = now
	SNH.hideWeatherEventUi()
	SNH.purgeEffectLightingAndCamera()
	SNH.purgeWorkspaceWeatherRoots()
end

SNH.onDisableAllEffectsChildAdded = function(inst)
	if not DISABLE_ALL_EFFECTS or not inst then return end
	if SNH.isGearWeatherEventRoot(inst) and not SNH.isLocalCharacterInstance(inst) then
		if inst:IsA("Model") or inst:IsA("Folder") then
			task.defer(function()
				if inst.Parent then pcall(function() inst:Destroy() end) end
			end)
		end
		return
	end
	if SNH.isEffectVfxInstance(inst) and SNH.shouldStripGearWeatherEventVisual(inst) then
		SNH.stripGearWeatherEventVisual(inst)
	end
end

SNH.setupDisableAllEffects = function()
	if disableAllEffectsHooked or not DISABLE_ALL_EFFECTS then return end
	disableAllEffectsHooked = true
	SNH.disableAllEffectsOnce(true)
	if disableAllEffectsConns.workspaceChild then
		pcall(function() disableAllEffectsConns.workspaceChild:Disconnect() end)
	end
	disableAllEffectsConns.workspaceChild = workspace.ChildAdded:Connect(function(inst)
		SNH.onDisableAllEffectsChildAdded(inst)
	end)
	if disableAllEffectsConns.lightingAdded then
		pcall(function() disableAllEffectsConns.lightingAdded:Disconnect() end)
	end
	disableAllEffectsConns.lightingAdded = Lighting.ChildAdded:Connect(function(inst)
		if not DISABLE_ALL_EFFECTS or not inst then return end
		if inst:IsA("BlurEffect") or inst:IsA("BloomEffect") or inst:IsA("SunRaysEffect")
			or inst:IsA("DepthOfFieldEffect") or inst:IsA("ColorCorrectionEffect") then
			pcall(function() inst.Enabled = false end)
		end
	end)
	local gardens = workspace:FindFirstChild("Gardens")
	if gardens then
		if disableAllEffectsConns.gardensChild then
			pcall(function() disableAllEffectsConns.gardensChild:Disconnect() end)
		end
		disableAllEffectsConns.gardensChild = gardens.ChildAdded:Connect(function(plot)
			if not DISABLE_ALL_EFFECTS or not plot then return end
			local sprinklers = plot:WaitForChild("Sprinklers", 5)
			if sprinklers and DISABLE_EFFECT_VFX_PURGE then
				SNH.purgeSprinklerVisuals(sprinklers)
			end
		end)
		SNH.trackConn(disableAllEffectsConns.gardensChild, "disable_all_effects")
	end
	SNH.trackConn(disableAllEffectsConns.workspaceChild, "disable_all_effects")
	SNH.trackConn(disableAllEffectsConns.lightingAdded, "disable_all_effects")
	print("[So Nach Hup] Disabled gear / event / weather effects (light mode — no workspace scan loop)")
end

do --[[ SNH: LoadAndOptimize ]]
SNH.ensureCatalogsLoaded = function()
	if next(SeedMeta) == nil then
		SNH.loadShopCatalog()
	end
	if next(PetMeta) == nil then
		SNH.loadPetCatalog()
	end
	local seedCount = 0
	for _ in SeedMeta do
		seedCount += 1
	end
	return seedCount >= 5 and next(PetMeta) ~= nil
end

SNH.waitForInitialLoad = function(timeout)
	if not BOOT.autoWaitGameLoad then return true end
	timeout = math.max(30, tonumber(timeout) or BOOT.gameLoadTimeout)
	local deadline = tick() + timeout
	local lastReason = ""

	local function checkReady()
		if not game:IsLoaded() then return false, "game" end
		if not API.init(5) then return false, "api" end
		if not Networking then Networking = API.getNetworking() end
		if not Networking then return false, "networking" end

		local character = LocalPlayer.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if not (character and humanoid and root and humanoid.Health > 0) then
			return false, "character"
		end

		if LocalPlayer:GetAttribute("LoadingScreenActive") == true then
			return false, "loading_screen"
		end
		if LocalPlayer:GetAttribute("LoadingScreenDone") ~= true then
			return false, "loading_done"
		end

		local plotId, plot = API.getLocalPlot()
		if not (plotId and plot) then
			return false, "plot"
		end

		if not workspace:FindFirstChild("Map") then
			return false, "map"
		end
		if not ReplicatedStorage:FindFirstChild("SharedData") then
			return false, "shared_data"
		end
		if not ReplicatedStorage:FindFirstChild("SharedModules") then
			return false, "shared_modules"
		end
		if not LocalPlayer:FindFirstChild("PlayerGui") then
			return false, "player_gui"
		end

		local required = {
			Networking.Garden and Networking.Garden.CollectFruit,
			Networking.Actions and Networking.Actions.ExpandGarden,
			Networking.Plant and Networking.Plant.PlantSeed,
			Networking.SeedShop and Networking.SeedShop.PurchaseSeed,
			Networking.GearShop and Networking.GearShop.PurchaseGear,
			Networking.NPCS and Networking.NPCS.SellAll,
			Networking.Pets and Networking.Pets.GetEquippedPets,
			Networking.Pets and Networking.Pets.RequestEquipByName,
			Networking.Pets and Networking.Pets.RequestUnequipByName,
		}
		for _, remote in required do
			if not remote then
				return false, "remotes"
			end
		end

		if not SNH.ensureCatalogsLoaded() then
			return false, "catalog"
		end

		return true, "ready"
	end

	while running and tick() < deadline do
		local ready, reason = checkReady()
		if ready then
			SNH.setStatus("Game load complete")
			return true
		end
		if reason ~= lastReason then
			lastReason = reason
			SNH.setStatus("Waiting game load: " .. tostring(reason))
		end
		task.wait(0.5)
	end

	warn(("[So Nach Hup] wait load timeout after %ss"):format(tostring(timeout)))
	return false
end

SNH.isOtherPlayerCharacterInstance = function(inst)
	if not inst then return false end
	local model = inst:FindFirstAncestorOfClass("Model")
	if not model then return false end
	local plr = Players:GetPlayerFromCharacter(model)
	return plr ~= nil and plr ~= LocalPlayer
end

SNH.isLocalCharacterInstance = function(inst)
	if not inst then return false end
	local char = LocalPlayer.Character
	return char ~= nil and inst:IsDescendantOf(char)
end

SNH.isInOtherPlot = function(inst, ownPlot)
	local gardens = workspace:FindFirstChild("Gardens")
	if not gardens or not inst or not inst:IsDescendantOf(gardens) then
		return false
	end
	if ownPlot and inst:IsDescendantOf(ownPlot) then
		return false
	end
	return true
end

SNH.isInPlantsFolder = function(inst)
	local node = inst
	while node and node ~= workspace do
		if node.Name == "Plants" and node:IsA("Folder") then return true end
		node = node.Parent
	end
	return false
end

SNH.getClientMemoryMb = function()
	local ok, mb = pcall(function()
		return gcinfo() / 1024
	end)
	if ok and tonumber(mb) then return tonumber(mb) end
	local stats = game:GetService("Stats")
	local item = stats:FindFirstChild("PerformanceStats")
	item = item and item:FindFirstChild("Memory")
	item = item and item:FindFirstChild("CoreMemory")
	if item and item:IsA("DoubleConstrainedValue") then
		return item.Value / 1048576
	end
	return 0
end

SNH.trimOptimizeCaches = function(force)
	local now = tick()
	if not force and now - lastPerfCacheTrimAt < (PERF_CACHE_TRIM_GAP or 45) then return end
	lastPerfCacheTrimAt = now
	local queueLen = #PERF.optimizeQueue
	if queueLen > 1500 then
		for i = queueLen, 1501, -1 do
			local inst = PERF.optimizeQueue[i]
			if inst then PERF.optimizeQueued[inst] = nil end
			PERF.optimizeQueue[i] = nil
		end
	end
	local skipNow = tick()
	for key, untilAt in stealSkip do
		if type(untilAt) == "number" and untilAt < skipNow then
			stealSkip[key] = nil
		end
	end
	stealGardensCache.time = 0
	pcall(function()
		if typeof(collectgarbage) == "function" then
			collectgarbage("collect")
		end
	end)
end

SNH.isLocalOwnedPlantPart = function(inst, ownPlot)
	if not inst or not ownPlot then return false end
	if not inst:IsDescendantOf(ownPlot) then return false end
	if SNH.isInPlantsFolder(inst) then return true end
	local model = inst:FindFirstAncestorWhichIsA("Model")
	return model ~= nil and model:GetAttribute("PlantId") ~= nil and model:IsDescendantOf(ownPlot)
end

SNH.hideLocalPlantPart = function(inst)
	if not inst or not inst.Parent or SNH.isOptimizeProtected(inst) then return end
	if PERF.localPlantHideMarked[inst] then
		if inst:IsA("BasePart") then
			pcall(function()
				inst.LocalTransparencyModifier = 1
				inst.Transparency = 1
			end)
		end
		return
	end
	if inst:IsA("BasePart") then
		pcall(function()
			inst.LocalTransparencyModifier = 1
			inst.Transparency = 1
			inst.CastShadow = false
			inst.Material = Enum.Material.SmoothPlastic
		end)
		for _, child in inst:GetChildren() do
			if child:IsA("Decal") or child:IsA("Texture") then
				pcall(function() child.Transparency = 1 end)
			elseif child:IsA("SurfaceAppearance") then
				pcall(function() child:Destroy() end)
			elseif child:IsA("SpecialMesh") then
				pcall(function()
					child.TextureId = ""
					child.VertexColor = Vector3.new(1, 1, 1)
				end)
			end
		end
	elseif inst:IsA("Decal") or inst:IsA("Texture") then
		pcall(function() inst.Transparency = 1 end)
	elseif inst:IsA("SurfaceAppearance") then
		pcall(function() inst:Destroy() end)
	end
	PERF.localPlantHideMarked[inst] = true
end

SNH.runLocalPlantHidePass = function()
	if not PERF.ultimateOptimize or not PERF.hidePlantBodies then return end
	local ownPlot = SNH.getOptimizeOwnPlot(true)
	if not ownPlot then return end
	local function hideContainer(container)
		if not container then return end
		for _, inst in container:GetDescendants() do
			if SNH.isOptimizeProtected(inst) then continue end
			if inst:IsA("BasePart") or inst:IsA("Decal") or inst:IsA("Texture") or inst:IsA("SurfaceAppearance") then
				SNH.hideLocalPlantPart(inst)
			end
		end
	end
	hideContainer(ownPlot:FindFirstChild("Plants"))
	for _, inst in ownPlot:GetDescendants() do
		if not inst:IsA("Model") or not inst:GetAttribute("PlantId") then continue end
		for _, part in inst:GetDescendants() do
			if part:IsA("BasePart") or part:IsA("Decal") or part:IsA("Texture") or part:IsA("SurfaceAppearance") then
				if not SNH.isOptimizeProtected(part) then
					SNH.hideLocalPlantPart(part)
				end
			end
		end
	end
end

SNH.startLocalPlantHideLoop = function()
	if PERF.localPlantHideLoopRunning then return end
	PERF.localPlantHideLoopRunning = true
	task.spawn(function()
		while running and PERF.ultimateOptimize and PERF.hideLocalPlantsAll do
			pcall(SNH.runLocalPlantHidePass)
			task.wait(PERF.localPlantHideLoopGap or 2)
		end
		PERF.localPlantHideLoopRunning = false
	end)
end

SNH.isOptimizeProtected = function(inst)
	if not inst then return true end
	if inst:IsA("ProximityPrompt") then return true end
	if inst.Name == "HarvestPrompt" or inst.Name == "StealPrompt" or inst.Name == "BuyPrompt" then return true end
	if CollectionService:HasTag(inst, "HarvestPrompt") or CollectionService:HasTag(inst, "StealPrompt") then return true end
	if CollectionService:HasTag(inst, "PlantArea") then return true end
	if inst:IsA("BasePart") and (inst.Name == "GardenTotalArea" or inst.Name == "GardenArea") then return true end
	local map = workspace:FindFirstChild("Map")
	if map and inst:IsDescendantOf(map) then
		local p = inst
		while p and p ~= map do
			if p.Name == "SeedPackSpawnServerLocations" or p.Name == "WildPetRef" or p.Name == "WildPetSpawns" then
				return true
			end
			p = p.Parent
		end
	end
	return false
end

SNH.getVisibleHarvestModel = function(inst)
	local node = inst
	while node and node ~= workspace do
		if node:IsA("Model") then
			if node:GetAttribute("FruitId") then return node end
			local cached = PERF.optimizeHarvestCache[node]
			if cached ~= nil then
				if cached then return node end
			else
				local ok = SNH.isHarvestablePlant(node)
				PERF.optimizeHarvestCache[node] = ok
				if ok then return node end
			end
			local stealPrompt = node:FindFirstChild("StealPrompt")
			if stealPrompt and stealPrompt:IsA("ProximityPrompt") and stealPrompt.Enabled then
				return node
			end
		end
		node = node.Parent
	end
	return nil
end

SNH.shouldHidePlantBody = function(inst)
	if not PERF.hidePlantBodies then return false end
	if not inst or not inst:IsA("BasePart") then return false end
	if SNH.isOptimizeProtected(inst) then return false end
	if SNH.isLocalCharacterInstance(inst) then return false end
	if not SNH.isInPlantsFolder(inst) then return false end
	if SNH.getVisibleHarvestModel(inst) then return false end
	return true
end

SNH.shouldHideLocalPlantPart = function(inst, ownPlot)
	if not PERF.hidePlantBodies then return false end
	if not inst or not inst:IsA("BasePart") then return false end
	if not ownPlot or not inst:IsDescendantOf(ownPlot) then return false end
	if not SNH.isInPlantsFolder(inst) then return false end
	if SNH.isOptimizeProtected(inst) then return false end
	if SNH.getVisibleHarvestModel(inst) then return false end
	return true
end

SNH.isInOtherPlotPlants = function(inst, ownPlot)
	if not SNH.isInOtherPlot(inst, ownPlot) then return false end
	return SNH.isInPlantsFolder(inst)
end

SNH.muteSoundServiceOnce = function()
	if PERF.optimizeSoundMuted or not PERF.disableSounds then return end
	PERF.optimizeSoundMuted = true
	pcall(function()
		for _, group in SoundService:GetChildren() do
			if group:IsA("SoundGroup") then
				group.Volume = 0
			end
		end
	end)
end

SNH.muteAllSoundsPass = function()
	if not PERF.disableSounds then return end
	pcall(function()
		for _, inst in SoundService:GetDescendants() do
			if inst:IsA("Sound") then
				inst.Volume = 0
				inst.Playing = false
			elseif inst:IsA("SoundGroup") then
				inst.Volume = 0
			end
		end
	end)
end

SNH.applyFpsCapOnce = function()
	local cap = tonumber(PERF.targetFps)
	if not cap or cap <= 0 then return end
	pcall(function()
		if typeof(setfpscap) == "function" then
			setfpscap(math.floor(cap))
		end
	end)
end

SNH.runLocalPlayerHidePass = function()
	if not PERF.ultimateOptimize or not PERF.stripLocalPlayer then return end
	local char = LocalPlayer.Character
	if not char then return end
	for _, inst in char:GetDescendants() do
		if SNH.isOptimizeProtected(inst) then continue end
		SNH.applyCharacterVisualStrip(inst)
		SNH.hideInstanceLocal(inst)
	end
end

SNH.runPlantHidePass = function()
	if not PERF.ultimateOptimize then return end
	SNH.runLocalPlantHidePass()
	local ownPlot = SNH.getOptimizeOwnPlot(true)
	local gardens = workspace:FindFirstChild("Gardens")
	if not gardens then return end

	for _, plot in gardens:GetChildren() do
		local plants = plot:FindFirstChild("Plants")
		if not plants then continue end
		local isOwnPlot = ownPlot and plot == ownPlot
		for _, inst in plants:GetDescendants() do
			if inst:IsA("BasePart") then
				if isOwnPlot then continue end
				if SNH.getVisibleHarvestModel(inst) then continue end
				if SNH.shouldHidePlantBody(inst) then
					SNH.hideInstanceLocal(inst)
					inst.CastShadow = false
				elseif plot ~= ownPlot and (PERF.hideOtherPlots or PERF.hideOtherPlants) then
					SNH.hideInstanceLocal(inst)
					inst.CastShadow = false
				end
			elseif SNH.isOptimizeProtected(inst) then
				continue
			end
		end
	end
end

SNH.runOtherPlayerHidePass = function()
	if not PERF.ultimateOptimize then return end
	if not (PERF.hideOtherPlayers or PERF.hideOtherBodyFace) then return end
	local ownPlot = SNH.getOptimizeOwnPlot(false)
	for _, plr in Players:GetPlayers() do
		if plr == LocalPlayer then continue end
		local char = plr.Character
		if not char then continue end
		for _, inst in char:GetDescendants() do
			SNH.applyCharacterVisualStrip(inst)
			SNH.hideInstanceLocal(inst)
		end
	end
	if PERF.stripLocalPlayer and LocalPlayer.Character then
		SNH.runLocalPlayerHidePass()
	end
end

SNH.runPerformanceMaintenancePass = function()
	if not PERF.ultimateOptimize then return end
	SNH.muteAllSoundsPass()
	SNH.applyFpsCapOnce()
	if PERF.destroyVfx then
		SNH.destroyVfxAndEffects()
	end
	if PERF.reduce3DRendering then
		SNH.applyReduce3DRenderingOnce()
	end
	SNH.runPlantHidePass()
	SNH.runLocalPlayerHidePass()
	SNH.runOtherPlayerHidePass()
	SNH.trimOptimizeCaches(false)
end

SNH.applyLightingOptimizeOnce = function()
	if PERF.lightingOptimized then return end
	PERF.lightingOptimized = true
	pcall(function()
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 9e9
		Lighting.Brightness = 2
		Lighting.EnvironmentDiffuseScale = 0
		Lighting.EnvironmentSpecularScale = 0
	end)
end

SNH.applyReduce3DRenderingOnce = function()
	if PERF.reduce3DApplied then return end
	PERF.reduce3DApplied = true
	SNH.applyLightingOptimizeOnce()
	pcall(function()
		local terrain = workspace:FindFirstChildOfClass("Terrain")
		if terrain then
			terrain.Decoration = false
			terrain.WaterWaveSize = 0
			terrain.WaterWaveSpeed = 0
		end
	end)
	pcall(function()
		local renderSettings = settings()
		if renderSettings and renderSettings.Rendering then
			renderSettings.Rendering.QualityLevel = Enum.QualityLevel.Level01
			renderSettings.Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
			renderSettings.Rendering.EditQualityLevel = Enum.QualityLevel.Level01
		end
	end)
	pcall(function()
		local ugs = UserSettings():GetService("UserGameSettings")
		ugs.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
	end)
	pcall(function()
		if workspace.CurrentCamera then
			workspace.CurrentCamera.FieldOfView = 70
		end
	end)
end

SNH.stripPartToMinimum3D = function(part)
	if not part or not part:IsA("BasePart") or SNH.isOptimizeProtected(part) then return end
	pcall(function()
		part.Material = Enum.Material.SmoothPlastic
		part.Reflectance = 0
		part.CastShadow = false
	end)
	if part:IsA("MeshPart") then
		pcall(function()
			part.TextureID = ""
			part.RenderFidelity = Enum.RenderFidelity.Performance
		end)
	end
end

SNH.isStripCandidate = function(inst)
	return inst:IsA("Decal") or inst:IsA("Texture") or inst:IsA("Sound")
		or inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Beam")
		or inst:IsA("Smoke") or inst:IsA("Fire") or inst:IsA("Sparkles")
		or inst:IsA("Highlight")
		or inst:IsA("PointLight") or inst:IsA("SpotLight") or inst:IsA("SurfaceLight")
		or inst:IsA("Animator") or inst:IsA("AnimationController")
end

SNH.stripPartToSquare = function(part)
	if not part or not part:IsA("BasePart") then return end
	pcall(function() part.Material = Enum.Material.SmoothPlastic end)
	pcall(function() part.Reflectance = 0 end)
	pcall(function() part.CastShadow = false end)
	if part:IsA("MeshPart") then
		pcall(function() part.TextureID = "" end)
		pcall(function() part.RenderFidelity = Enum.RenderFidelity.Performance end)
	end
	local mesh = part:FindFirstChildOfClass("SpecialMesh")
	if mesh then
		pcall(function()
			mesh.TextureId = ""
			mesh.VertexColor = Vector3.new(0.75, 0.75, 0.75)
		end)
	end
	for _, child in part:GetChildren() do
		if child:IsA("Decal") or child:IsA("Texture") then
			pcall(function() child.Transparency = 1 end)
		elseif child:IsA("SurfaceAppearance") then
			pcall(function() child:Destroy() end)
		end
	end
end

SNH.stripFruitPartTextures = function(part)
	if not part or not part:IsA("BasePart") or SNH.isOptimizeProtected(part) then return end
	if part:IsA("MeshPart") then
		pcall(function()
			part.TextureID = ""
			part.RenderFidelity = Enum.RenderFidelity.Performance
		end)
	end
	local mesh = part:FindFirstChildOfClass("SpecialMesh")
	if mesh then
		pcall(function() mesh.TextureId = "" end)
	end
	for _, child in part:GetChildren() do
		if child:IsA("Decal") or child:IsA("Texture") then
			pcall(function() child.Transparency = 1 end)
		elseif child:IsA("SurfaceAppearance") then
			pcall(function() child:Destroy() end)
		end
	end
end

SNH.runTextureRemovalPass = function()
	if not PERF.ultimateOptimize or not PERF.removeTextures then return end
	local ownPlot = SNH.getOptimizeOwnPlot(false)

	local function stripTextureInstance(inst)
		if not inst or not inst.Parent or SNH.isOptimizeProtected(inst) then return end
		if inst:IsA("Texture") or inst:IsA("Decal") then
			pcall(function() inst.Transparency = 1 end)
		elseif inst:IsA("SurfaceAppearance") then
			pcall(function() inst:Destroy() end)
		elseif inst:IsA("BasePart") then
			if SNH.getVisibleHarvestModel(inst) then
				SNH.stripFruitPartTextures(inst)
			elseif SNH.shouldHidePlantBody(inst) or SNH.isInOtherPlot(inst, ownPlot) then
				SNH.stripPartToSquare(inst)
			else
				SNH.stripFruitPartTextures(inst)
			end
		end
	end

	local gardens = workspace:FindFirstChild("Gardens")
	if gardens then
		for _, inst in gardens:GetDescendants() do
			stripTextureInstance(inst)
		end
	end

	local map = workspace:FindFirstChild("Map")
	if map then
		for _, inst in map:GetDescendants() do
			if SNH.isOptimizeProtected(inst) then continue end
			if inst:IsA("Texture") or inst:IsA("Decal") or inst:IsA("SurfaceAppearance") then
				stripTextureInstance(inst)
			end
		end
	end

	local function stripCharacterTextures(char)
		if not char then return end
		for _, inst in char:GetDescendants() do
			if SNH.isOptimizeProtected(inst) then continue end
			stripTextureInstance(inst)
		end
	end

	if PERF.stripLocalPlayer then
		stripCharacterTextures(LocalPlayer.Character)
	end
	if PERF.hideOtherPlayers then
		for _, plr in Players:GetPlayers() do
			if plr ~= LocalPlayer then
				stripCharacterTextures(plr.Character)
			end
		end
	end
end

SNH.disableEffectInstance = function(inst)
	if not inst or not inst.Parent then return end
	if inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Beam")
		or inst:IsA("Smoke") or inst:IsA("Fire") or inst:IsA("Sparkles") then
		pcall(function() inst.Enabled = false end)
		if PERF.destroyVfx then pcall(function() inst:Destroy() end) end
	elseif inst:IsA("Highlight") then
		pcall(function() inst.Enabled = false end)
		if PERF.destroyVfx then pcall(function() inst:Destroy() end) end
	elseif inst:IsA("PointLight") or inst:IsA("SpotLight") or inst:IsA("SurfaceLight") then
		pcall(function() inst.Enabled = false end)
		if PERF.destroyVfx then pcall(function() inst:Destroy() end) end
	elseif inst:IsA("Explosion") then
		pcall(function() inst:Destroy() end)
	end
end

SNH.isDestroyableVfx = function(inst)
	if not inst or SNH.isOptimizeProtected(inst) then return false end
	if SNH.isLocalCharacterInstance(inst) then return false end
	if inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Beam")
		or inst:IsA("Smoke") or inst:IsA("Fire") or inst:IsA("Sparkles")
		or inst:IsA("Explosion") or inst:IsA("Highlight") then
		return true
	end
	if inst:IsA("BlurEffect") or inst:IsA("BloomEffect") or inst:IsA("SunRaysEffect")
		or inst:IsA("DepthOfFieldEffect") or inst:IsA("ColorCorrectionEffect") then
		return true
	end
	local n = inst.Name
	if string.find(n, "VFX", 1, true) or string.find(n, "ScreenShake", 1, true)
		or string.find(n, "CameraShake", 1, true) or string.find(n, "PopVFX", 1, true)
		or string.find(n, "Shake", 1, true) then
		return true
	end
	if inst:IsA("Model") and (n == "Goldmoon" or n == "Gold Moon" or n == "Rainbow Moon") then
		return true
	end
	return false
end

SNH.destroyVfxAndEffects = function(root)
	if not PERF.destroyVfx and not PERF.disableEffects then return end
	root = root or workspace
	pcall(function()
		for _, inst in root:GetDescendants() do
			if SNH.isDestroyableVfx(inst) then
				inst:Destroy()
			end
		end
	end)
	pcall(function()
		for _, child in Lighting:GetChildren() do
			if child:IsA("BlurEffect") or child:IsA("BloomEffect") or child:IsA("SunRaysEffect")
				or child:IsA("DepthOfFieldEffect") or child:IsA("ColorCorrectionEffect") then
				child:Destroy()
			end
		end
	end)
	pcall(function()
		local cam = workspace.CurrentCamera
		if not cam then return end
		for _, child in cam:GetChildren() do
			if SNH.isDestroyableVfx(child) then
				child:Destroy()
			end
		end
	end)
	pcall(function()
		local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
		if not playerGui then return end
		for _, gui in playerGui:GetDescendants() do
			if gui.Name == "SNH_BlackOverlay" then continue end
			if string.find(gui.Name, "ScreenShake", 1, true)
				or string.find(gui.Name, "CameraShake", 1, true)
				or string.find(gui.Name, "VFX", 1, true) then
				if gui:IsA("GuiObject") or gui:IsA("Folder") then
					gui:Destroy()
				end
			end
		end
	end)
end

SNH.disableAnimationInstance = function(inst)
	if not inst or not inst.Parent then return end
	if inst:IsA("Animator") or inst:IsA("AnimationController") then
		pcall(function()
			for _, track in inst:GetPlayingAnimationTracks() do
				track:Stop(0)
			end
		end)
	end
end

SNH.hideInstanceLocal = function(inst)
	if not inst or not inst.Parent then return end
	if inst:IsA("BasePart") then
		pcall(function()
			inst.LocalTransparencyModifier = 1
			inst.CastShadow = false
		end)
	elseif inst:IsA("Decal") or inst:IsA("Texture") then
		pcall(function() inst.Transparency = 1 end)
	end
end

SNH.applyAggressiveVisualStrip = function(inst, allowPartStrip)
	if not inst or not inst.Parent or SNH.isOptimizeProtected(inst) then return end
	if PERF.disableSounds and inst:IsA("Sound") then
		pcall(function()
			inst.Volume = 0
			inst.Playing = false
		end)
	end
	if PERF.disableEffects then SNH.disableEffectInstance(inst) end
	if PERF.disableAnimations then SNH.disableAnimationInstance(inst) end
	if PERF.removeTextures then
		if inst:IsA("Decal") or inst:IsA("Texture") then
			pcall(function() inst.Transparency = 1 end)
		elseif inst:IsA("BasePart") and allowPartStrip then
			SNH.stripPartToSquare(inst)
		end
	end
	if PERF.simplifyMeshes and inst:IsA("BasePart") and allowPartStrip then
		SNH.stripPartToSquare(inst)
	end
	if PERF.reduce3DRendering and inst:IsA("BasePart") and allowPartStrip then
		SNH.stripPartToMinimum3D(inst)
	end
end

SNH.applyCharacterVisualStrip = function(inst)
	if not inst or not inst.Parent or SNH.isOptimizeProtected(inst) then return end
	SNH.applyAggressiveVisualStrip(inst, true)
end

SNH.applyVisualStrip = function(inst, allowFullStrip)
	if not inst or not inst.Parent then return end
	if SNH.isOptimizeProtected(inst) then return end
	if SNH.isLocalCharacterInstance(inst) then return end

	local isFruit = SNH.getVisibleHarvestModel(inst) ~= nil

	if PERF.disableSounds and inst:IsA("Sound") then
		pcall(function()
			inst.Volume = 0
			inst.Playing = false
		end)
	end

	if PERF.disableEffects then
		SNH.disableEffectInstance(inst)
	end
	if PERF.disableAnimations then
		SNH.disableAnimationInstance(inst)
	end

	if isFruit then
		if PERF.removeTextures then
			if inst:IsA("Decal") or inst:IsA("Texture") then
				pcall(function() inst.Transparency = 1 end)
			elseif inst:IsA("SurfaceAppearance") then
				pcall(function() inst:Destroy() end)
			elseif inst:IsA("BasePart") then
				SNH.stripFruitPartTextures(inst)
			end
		end
		return
	end

	if PERF.removeTextures then
		if inst:IsA("Decal") or inst:IsA("Texture") then
			pcall(function() inst.Transparency = 1 end)
		elseif inst:IsA("BasePart") and allowFullStrip then
			SNH.stripPartToSquare(inst)
		end
	end

	if PERF.simplifyMeshes and inst:IsA("BasePart") and allowFullStrip then
		SNH.stripPartToSquare(inst)
	end
	if PERF.reduce3DRendering and inst:IsA("BasePart") and allowFullStrip then
		SNH.stripPartToMinimum3D(inst)
	end
end

SNH.getOptimizeOwnPlot = function(forceRefresh)
	if forceRefresh or not PERF.optimizeOwnPlot or tick() - PERF.optimizeLastOwnPlotAt > 8 then
		local _, ownPlot = API.getLocalPlot()
		PERF.optimizeOwnPlot = ownPlot
		PERF.optimizeLastOwnPlotAt = tick()
	end
	return PERF.optimizeOwnPlot
end

SNH.queueOptimizeInstance = function(inst)
	if not inst or not inst.Parent then return end
	if PERF.optimizeDone[inst] then return end
	if PERF.optimizeQueued[inst] then return end
	if #PERF.optimizeQueue >= PERF.optimizeMaxQueue then return end
	PERF.optimizeQueued[inst] = true
	table.insert(PERF.optimizeQueue, inst)
end

SNH.applyOptimizeInstanceNow = function(inst, ownPlot)
	if not inst or not inst.Parent then return end
	pcall(SNH.applyUltimateOptimizationToInstance, inst, ownPlot)
	local isOtherGarden = SNH.isInOtherPlot(inst, ownPlot)
	if not isOtherGarden then
		PERF.optimizeDone[inst] = true
	end
end

SNH.applyStripFast = function(inst)
	if not inst or not inst.Parent or SNH.isOptimizeProtected(inst) then return end
	if PERF.disableSounds and inst:IsA("Sound") then
		pcall(function() inst.Volume = 0; inst.Playing = false end)
	end
	if PERF.disableEffects then SNH.disableEffectInstance(inst) end
	if PERF.disableAnimations then SNH.disableAnimationInstance(inst) end
	if PERF.removeTextures and (inst:IsA("Decal") or inst:IsA("Texture")) then
		pcall(function() inst.Transparency = 1 end)
	end
	PERF.optimizeDone[inst] = true
end

SNH.hookPlotPlantsFolder = function(plantsFolder)
	if not plantsFolder or PERF.optimizePlotHooked[plantsFolder] then return end
	PERF.optimizePlotHooked[plantsFolder] = true
	local function onPlantInstance(inst)
		if not PERF.ultimateOptimize or not inst then return end
		local ownPlot = SNH.getOptimizeOwnPlot(false)
		if ownPlot and plantsFolder:IsDescendantOf(ownPlot) then
			if inst:IsA("BasePart") or inst:IsA("Decal") or inst:IsA("Texture") or inst:IsA("SurfaceAppearance") then
				SNH.hideLocalPlantPart(inst)
			end
		end
		SNH.applyOptimizeInstanceNow(inst, ownPlot)
	end
	-- Initial sweep spread across frames so a big garden never stalls one frame on boot.
	task.spawn(function()
		local n = 0
		for _, inst in plantsFolder:GetDescendants() do
			if not (PERF.ultimateOptimize and plantsFolder.Parent) then break end
			onPlantInstance(inst)
			n += 1
			if n % 200 == 0 then RunService.Heartbeat:Wait() end
		end
	end)
	table.insert(PERF.optimizeConns, plantsFolder.DescendantAdded:Connect(onPlantInstance))
end

SNH.hookGardenPlot = function(plot)
	if not plot or PERF.optimizePlotHooked[plot] then return end
	local ownPlot = SNH.getOptimizeOwnPlot(false)
	local isOther = ownPlot ~= nil and plot ~= ownPlot
	-- Hooking OTHER players' gardens is opt-in. It's the biggest boot cost on busy
	-- servers (walks every other plot's full tree, including their Plants folder).
	-- Other plots are still handled by the periodic hide passes, so skipping here is safe.
	if isOther and not PERF.hookOtherGardens then return end
	local plants = plot:FindFirstChild("Plants")
	if plants then SNH.hookPlotPlantsFolder(plants) end
	if not isOther then return end
	PERF.optimizePlotHooked[plot] = true
	-- Queue other plots for the batch worker instead of processing inline (avoids boot stall).
	for _, inst in plot:GetDescendants() do
		SNH.queueOptimizeInstance(inst)
	end
	table.insert(PERF.optimizeConns, plot.DescendantAdded:Connect(function(inst)
		if not PERF.ultimateOptimize or not inst then return end
		SNH.queueOptimizeInstance(inst)
	end))
end

SNH.hookAllGardenPlots = function()
	local gardens = workspace:FindFirstChild("Gardens")
	if not gardens then return end
	for _, plot in gardens:GetChildren() do
		SNH.hookGardenPlot(plot)
	end
	if PERF.optimizeGardensConn then return end
	PERF.optimizeGardensConn = gardens.ChildAdded:Connect(function(plot)
		task.defer(function()
			SNH.hookGardenPlot(plot)
		end)
	end)
	table.insert(PERF.optimizeConns, PERF.optimizeGardensConn)
end

SNH.startOptimizeWorker = function()
	if PERF.optimizeWorkerRunning then return end
	PERF.optimizeWorkerRunning = true
	task.spawn(function()
		while running and PERF.ultimateOptimize do
			local ownPlot = SNH.getOptimizeOwnPlot(false)
			local processed = 0
			local batch = PERF.optimizeBatchSize or 40
			while processed < batch and #PERF.optimizeQueue > 0 do
				local inst = table.remove(PERF.optimizeQueue, 1)
				PERF.optimizeQueued[inst] = nil
				if inst and inst.Parent then
					pcall(SNH.applyUltimateOptimizationToInstance, inst, ownPlot)
					PERF.optimizeDone[inst] = true
				end
				processed += 1
			end
			task.wait(#PERF.optimizeQueue > 0 and 0.06 or 0.5)
		end
		PERF.optimizeWorkerRunning = false
	end)
end

SNH.applyUltimateOptimizationToInstance = function(inst, ownPlot)
	if not PERF.ultimateOptimize or not inst or not inst.Parent then return end

	ownPlot = ownPlot or SNH.getOptimizeOwnPlot(false)
	if PERF.hideLocalPlantsAll and ownPlot and SNH.isLocalOwnedPlantPart(inst, ownPlot) then
		SNH.hideLocalPlantPart(inst)
		if PERF.disableEffects and not inst:IsA("BasePart") then
			SNH.disableEffectInstance(inst)
		end
		return
	end

	local isProtected = SNH.isOptimizeProtected(inst)
	local isFruit = SNH.getVisibleHarvestModel(inst) ~= nil
	local inOtherPlot = SNH.isInOtherPlot(inst, ownPlot)

	if SNH.isLocalCharacterInstance(inst) and PERF.stripLocalPlayer then
		SNH.applyCharacterVisualStrip(inst)
		SNH.hideInstanceLocal(inst)
		return
	end

	if PERF.hideOtherPlayers and SNH.isOtherPlayerCharacterInstance(inst) then
		SNH.applyCharacterVisualStrip(inst)
		SNH.hideInstanceLocal(inst)
		return
	end

	if inOtherPlot and not isProtected and (PERF.hideOtherPlots or PERF.hideOtherPlants) then
		SNH.applyAggressiveVisualStrip(inst, true)
		SNH.hideInstanceLocal(inst)
		return
	end

	if not isProtected then
		SNH.applyVisualStrip(inst, not isFruit)
	end

	if not inst:IsA("BasePart") then return end

	if SNH.shouldHidePlantBody(inst) then
		inst.LocalTransparencyModifier = 1
		inst.CastShadow = false
	end
end

SNH.shouldQueueOptimizeInstance = function(inst, ownPlot)
	if not inst or not inst.Parent then return false end
	if SNH.isOptimizeProtected(inst) then return false end
	if SNH.isLocalCharacterInstance(inst) then
		return PERF.stripLocalPlayer and (PERF.removeTextures or PERF.disableEffects or PERF.simplifyMeshes)
	end

	if SNH.isInPlantsFolder(inst) then return true end

	if PERF.hideOtherPlayers and SNH.isOtherPlayerCharacterInstance(inst) then return true end

	if PERF.removeTextures or PERF.disableEffects or PERF.disableSounds or PERF.simplifyMeshes or PERF.disableAnimations then
		if SNH.isStripCandidate(inst) then return true end
	end

	if PERF.hideOtherPlants and SNH.isInOtherPlotPlants(inst, ownPlot) then return true end
	if PERF.hideOtherPlots and SNH.isInOtherPlot(inst, ownPlot) then return true end
	return false
end

SNH.refreshUltimateOptimization = function()
	if not PERF.ultimateOptimize then return end
	local ownPlot = SNH.getOptimizeOwnPlot(true)
	SNH.muteSoundServiceOnce()
	SNH.applyLightingOptimizeOnce()
	if PERF.reduce3DRendering then
		SNH.applyReduce3DRenderingOnce()
	end

	local gardens = workspace:FindFirstChild("Gardens")
	if gardens then
		local n = 0
		for _, plot in gardens:GetChildren() do
			local isOwn = plot == ownPlot
			-- Skip other gardens entirely unless explicitly enabled (boot/CPU cost).
			if not isOwn and not PERF.hookOtherGardens then continue end
			for _, inst in plot:GetDescendants() do
				if isOwn then
					SNH.applyOptimizeInstanceNow(inst, ownPlot)
				else
					SNH.queueOptimizeInstance(inst)
				end
				n += 1
				if n % 300 == 0 then RunService.Heartbeat:Wait() end
			end
		end
	end
	pcall(SNH.runLocalPlantHidePass)

	if PERF.disableEffects or PERF.disableSounds then
		local map = workspace:FindFirstChild("Map")
		if map then
			local n = 0
			for _, inst in map:GetDescendants() do
				if SNH.isOptimizeProtected(inst) then continue end
				if SNH.isStripCandidate(inst) then
					SNH.applyStripFast(inst)
				end
				n += 1
				if n % 300 == 0 then RunService.Heartbeat:Wait() end
			end
		end
	end

	local function optimizeCharacter(char)
		if not char then return end
		for _, inst in char:GetDescendants() do
			SNH.applyOptimizeInstanceNow(inst, ownPlot)
		end
	end

	if PERF.stripLocalPlayer then
		optimizeCharacter(LocalPlayer.Character)
	end

	if PERF.hideOtherPlayers or PERF.hideOtherBodyFace then
		for _, plr in Players:GetPlayers() do
			if plr == LocalPlayer then continue end
			optimizeCharacter(plr.Character)
		end
	end

	SNH.startOptimizeWorker()
	PERF.optimizeRefreshAt = tick()
end

SNH.hideOtherPlayerCharacter = function(char)
	if not char then return end
	for _, inst in char:GetDescendants() do
		SNH.applyCharacterVisualStrip(inst)
		SNH.hideInstanceLocal(inst)
	end
	char.DescendantAdded:Connect(function(inst)
		if PERF.hideOtherPlayers then
			SNH.applyCharacterVisualStrip(inst)
			SNH.hideInstanceLocal(inst)
		end
	end)
end

SNH.setupClientVisualOptimize = function()
	if PERF.clientVisualOptimizeInstalled then return end
	if not PERF.removeTextures and not PERF.hideOtherPlayers then return end
	PERF.clientVisualOptimizeInstalled = true
	PERF.ultimateOptimize = true
	print("[So Nach Hup] Client visual optimize ON — strip textures, hide other players")
	SNH.setStatus("Performance mode enabled — textures stripped, players hidden")

	task.spawn(function()
		pcall(SNH.runTextureRemovalPass)
	end)

	if PERF.hideOtherPlayers then
		for _, plr in Players:GetPlayers() do
			if plr ~= LocalPlayer then
				if plr.Character then SNH.hideOtherPlayerCharacter(plr.Character) end
				plr.CharacterAdded:Connect(function(char)
					task.defer(function()
						SNH.hideOtherPlayerCharacter(char)
					end)
				end)
			end
		end
		Players.PlayerAdded:Connect(function(plr)
			if plr == LocalPlayer then return end
			plr.CharacterAdded:Connect(function(char)
				task.defer(function()
					SNH.hideOtherPlayerCharacter(char)
				end)
			end)
		end)
	end

	task.spawn(function()
		while running do
			if PERF.removeTextures then
				pcall(SNH.runTextureRemovalPass)
			end
			if PERF.hideOtherPlayers then
				pcall(SNH.runOtherPlayerHidePass)
			end
			task.wait(math.max(30, tonumber(PERF.optimizeTextureLoopGap) or 45))
		end
	end)
end

SNH.setupUltimateOptimization = function()
	-- Optimize system removed: this is now a permanent no-op. It will never hide plants,
	-- destroy VFX, cap FPS, downgrade graphics, or hook gardens.
	do return end
	-- (unreachable legacy body kept to avoid touching internal references)
	if PERF.optimizeInstalled or not PERF.ultimateOptimize then return end
	PERF.optimizeInstalled = true
	print("[So Nach Hup] Ultimate optimize ON — hide local player + all own plants every 2s/30s, 20 FPS")
	SNH.setStatus("Ultimate optimize ON")
	SNH.muteSoundServiceOnce()
	SNH.muteAllSoundsPass()
	SNH.applyFpsCapOnce()
	SNH.destroyVfxAndEffects()
	SNH.applyLightingOptimizeOnce()
	if PERF.reduce3DRendering then
		SNH.applyReduce3DRenderingOnce()
	end
	SNH.hookAllGardenPlots()
	-- One cooperative refresh; it already runs runLocalPlantHidePass internally.
	task.spawn(function() pcall(SNH.refreshUltimateOptimization) end)
	task.spawn(function() pcall(SNH.runTextureRemovalPass) end)
	SNH.startOptimizeWorker()

	local function hookCharacter(char)
		if not char then return end
		local ownPlot = SNH.getOptimizeOwnPlot(false)
		for _, inst in char:GetDescendants() do
			SNH.applyOptimizeInstanceNow(inst, ownPlot)
		end
		table.insert(PERF.optimizeConns, char.DescendantAdded:Connect(function(inst)
			if not PERF.ultimateOptimize or not inst then return end
			task.defer(function()
				SNH.applyOptimizeInstanceNow(inst, SNH.getOptimizeOwnPlot(false))
			end)
		end))
	end

	if PERF.stripLocalPlayer then
		if LocalPlayer.Character then hookCharacter(LocalPlayer.Character) end
		table.insert(PERF.optimizeConns, LocalPlayer.CharacterAdded:Connect(hookCharacter))
	end

	-- Fallback only if Gardens wasn't present at setup time. Hooking is idempotent
	-- (guarded per-plot), so no redundant full refresh on the common path.
	if not workspace:FindFirstChild("Gardens") then
		task.spawn(function()
			local gardens = workspace:WaitForChild("Gardens", 120)
			if gardens and PERF.ultimateOptimize then
				SNH.hookAllGardenPlots()
				print("[So Nach Hup] Optimize hooked Gardens folder (late)")
			end
		end)
	end

	LocalPlayer:GetAttributeChangedSignal("PlotId"):Connect(function()
		if not PERF.ultimateOptimize then return end
		task.defer(function()
			SNH.hookAllGardenPlots()
			pcall(SNH.refreshUltimateOptimization)
		end)
	end)

	local map = workspace:FindFirstChild("Map")
	if map and not PERF.optimizeMapConn then
		for _, inst in map:GetDescendants() do
			if SNH.isStripCandidate(inst) and not SNH.isOptimizeProtected(inst) then
				SNH.applyStripFast(inst)
			end
		end
		PERF.optimizeMapConn = map.DescendantAdded:Connect(function(inst)
			if not PERF.ultimateOptimize or not inst then return end
			if SNH.isOptimizeProtected(inst) then return end
			if SNH.isDestroyableVfx(inst) then
				pcall(function() inst:Destroy() end)
			elseif SNH.isStripCandidate(inst) then
				SNH.applyStripFast(inst)
			end
		end)
		table.insert(PERF.optimizeConns, PERF.optimizeMapConn)
	end

	-- Global workspace VFX hook is opt-in (PERF.hookWorkspaceVfx). The Map hook above
	-- already covers in-garden/map effects; this global one fired for every instance
	-- added anywhere in workspace and was a major lag source, so it's off by default.
	if PERF.hookWorkspaceVfx then
		table.insert(PERF.optimizeConns, workspace.DescendantAdded:Connect(function(inst)
			if not PERF.ultimateOptimize or not inst then return end
			task.defer(function()
				if SNH.isDestroyableVfx(inst) then
					pcall(function() inst:Destroy() end)
				elseif PERF.disableEffects and SNH.isStripCandidate(inst) then
					SNH.disableEffectInstance(inst)
				end
			end)
		end))
	end
	table.insert(PERF.optimizeConns, Lighting.ChildAdded:Connect(function(inst)
		if not PERF.ultimateOptimize or not inst then return end
		if SNH.isDestroyableVfx(inst) then
			pcall(function() inst:Destroy() end)
		end
	end))

	if PERF.hideOtherPlayers then
		for _, plr in Players:GetPlayers() do
			if plr == LocalPlayer then continue end
			hookCharacter(plr.Character)
		end
		table.insert(PERF.optimizeConns, Players.PlayerAdded:Connect(function(plr)
			if plr == LocalPlayer then return end
			plr.CharacterAdded:Connect(function(char)
				task.defer(function()
					hookCharacter(char)
				end)
			end)
		end))
	end

	SNH.startOptimizeWorker()
	SNH.startLocalPlantHideLoop()

	task.spawn(function()
		local lastFullRefresh = tick()
		while running and PERF.ultimateOptimize do
			pcall(function()
				SNH.runPerformanceMaintenancePass()
				SNH.runTextureRemovalPass()
				SNH.hookAllGardenPlots()
				local fullGap = tonumber(PERF.optimizeFullRefreshGap) or 300
				if tick() - lastFullRefresh >= fullGap then
					SNH.refreshUltimateOptimization()
					lastFullRefresh = tick()
				end
			end)
			task.wait(PERF.plantHideLoopGap or PERF.optimizeTextureLoopGap or 60)
		end
	end)
end

SNH.ensureBlackOverlayGui = function()
	if PERF.blackOverlayGui and PERF.blackOverlayGui.Parent and PERF.blackOverlayFrame then
		return
	end
	SNH.suppressGuiRecreate(2)
	local playerGui = LocalPlayer:WaitForChild("PlayerGui")
	pcall(function()
		local hidden = SNH.tryHiddenGuiParent()
		if hidden then
			local old = hidden:FindFirstChild("SNH_BlackOverlay")
			if old and old ~= PERF.blackOverlayGui then SNH.destroyHudGui(old) end
		end
	end)
	local oldPg = playerGui:FindFirstChild("SNH_BlackOverlay")
	if oldPg and oldPg ~= PERF.blackOverlayGui then SNH.destroyHudGui(oldPg) end

	local gui = Instance.new("ScreenGui")
	gui.Name = "SNH_BlackOverlay"
	gui.IgnoreGuiInset = true
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.DisplayOrder = LOADING_OVERLAY_DISPLAY_ORDER or BLACK_SCREEN_DISPLAY_ORDER or 9998

	local frame = Instance.new("Frame")
	frame.Name = "Overlay"
	frame.Size = UDim2.fromScale(1, 1)
	frame.Position = UDim2.fromScale(0, 0)
	frame.BackgroundColor3 = Color3.new(0, 0, 0)
	frame.BorderSizePixel = 0
	frame.ZIndex = LOADING_OVERLAY_DISPLAY_ORDER or BLACK_SCREEN_DISPLAY_ORDER or 9998
	frame.Parent = gui

	local label = Instance.new("TextLabel")
	label.Name = "Hint"
	label.AnchorPoint = Vector2.new(0.5, 1)
	label.Position = UDim2.fromScale(0.5, 0.98)
	label.Size = UDim2.new(1, -20, 0, 26)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(180, 180, 180)
	label.TextStrokeTransparency = 0.6
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.Visible = false
	label.ZIndex = frame.ZIndex + 1
	label.Parent = frame

	gui = SNH.mountSecureGui(gui, {
		displayOrder = LOADING_OVERLAY_DISPLAY_ORDER or BLACK_SCREEN_DISPLAY_ORDER or 9998,
		zIndexBehavior = Enum.ZIndexBehavior.Sibling,
		recreateToken = "black",
	})
	PERF.blackOverlayGui = gui
	PERF.blackOverlayFrame = frame
	PERF.blackOverlayLabel = label
end

SNH.showStartupLoading = function()
	PERF.startupLoadingShown = true
	PERF.blackOverlayVisible = true
	pcall(function()
		SNH.ensureBlackOverlayGui()
		if not PERF.blackOverlayFrame then return end
		PERF.blackOverlayFrame.Visible = true
		if PERF.blackOverlayLabel then
			PERF.blackOverlayLabel.Visible = false
		end
		local loading = PERF.loadingOverlayLabel
		if not loading or not loading.Parent then
			loading = Instance.new("TextLabel")
			loading.Name = "LoadingText"
			loading.AnchorPoint = Vector2.new(0.5, 0.5)
			loading.Position = UDim2.fromScale(0.5, 0.5)
			loading.Size = UDim2.new(0.85, 0, 0.18, 0)
			loading.BackgroundTransparency = 1
			loading.Text = "LOADING SCRIPT"
			loading.TextColor3 = Color3.fromRGB(255, 255, 255)
			loading.TextStrokeTransparency = 0.35
			loading.Font = Enum.Font.GothamBold
			loading.TextScaled = true
			loading.ZIndex = (PERF.blackOverlayFrame.ZIndex or 1) + 2
			loading.Parent = PERF.blackOverlayFrame
			PERF.loadingOverlayLabel = loading
		end
		loading.Visible = true
		loading.Text = "LOADING SCRIPT"
	end)
end

SNH.hideStartupLoadingText = function()
	PERF.startupLoadingShown = false
	pcall(function()
		if PERF.loadingOverlayLabel then
			PERF.loadingOverlayLabel:Destroy()
			PERF.loadingOverlayLabel = nil
		end
		if not PERF.blackScreen and PERF.blackOverlayFrame then
			PERF.blackOverlayFrame.Visible = false
			PERF.blackOverlayVisible = false
		elseif PERF.blackOverlayFrame then
			PERF.blackOverlayFrame.Visible = PERF.blackOverlayVisible ~= false
		end
		if PERF.blackOverlayGui then
			PERF.blackOverlayGui.DisplayOrder = BLACK_SCREEN_DISPLAY_ORDER or 9998
		end
	end)
	SNH.updateBlackOverlay()
end

SNH.updateBlackOverlay = function()
	task.defer(function()
		pcall(function()
			if not PERF.blackOverlayFrame then return end
			PERF.blackOverlayFrame.Visible = PERF.blackOverlayVisible
			if PERF.blackOverlayLabel then
				local showHint = not PERF.startupLoadingShown
				PERF.blackOverlayLabel.Visible = showHint
				if showHint then
					PERF.blackOverlayLabel.Text = PERF.blackOverlayVisible
						and "BLACK SCREEN ON - DOUBLE CLICK TO VIEW GAME"
						or "BLACK SCREEN OFF - DOUBLE CLICK TO HIDE GAME"
				end
			end
		end)
	end)
end

SNH.setupBlackScreenToggle = function()
	if not PERF.blackScreen then return end
	SNH.ensureBlackOverlayGui()
	if PERF.blackOverlayGui and PERF.blackOverlayGui.Parent then
		pcall(function()
			PERF.blackOverlayGui.DisplayOrder = BLACK_SCREEN_DISPLAY_ORDER or 9998
		end)
		SNH.updateBlackOverlay()
	else
		return
	end

	PERF.blackOverlayVisible = true
	SNH.updateBlackOverlay()

	if PERF.blackInputHooked then return end
	PERF.blackInputHooked = true
	SNH.trackConn(UserInputService.InputBegan:Connect(function(input)
		if not PERF.blackScreen then return end
		local kind = input.UserInputType
		if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.Touch then
			return
		end
		local now = tick()
		if now - PERF.blackLastTap <= PERF.blackDoubleClickGap then
			PERF.blackOverlayVisible = not PERF.blackOverlayVisible
			SNH.updateBlackOverlay()
			PERF.blackLastTap = 0
			return
		end
		PERF.blackLastTap = now
	end), "black_screen")
end
end
setupHud = SNH.setupHud
refreshHud = SNH.refreshHud
setupMailboxListener = SNH.setupMailboxListener
setupGiftListener = SNH.setupGiftListener

do --[[ SNH: Teleport ]]
SNH.getTeleportRoot = function()
	local character = LocalPlayer.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local hum = character and character:FindFirstChildOfClass("Humanoid")
	if not (root and hum and hum.Health > 0) then return nil, nil end
	return root, hum
end

SNH.normalizeTeleportGoal = function(position)
	if typeof(position) == "Vector3" then return position end
	if typeof(position) == "Instance" and position:IsA("BasePart") then
		return position.Position
	end
	return nil
end

SNH.isNearPosition = function(goal, radius)
	local root = SNH.getTeleportRoot()
	if not root or not goal then return false end
	return (root.Position - goal).Magnitude <= (tonumber(radius) or TP_ARRIVE_RADIUS)
end

SNH.rawTeleportRootTo = function(position)
	local root, hum = SNH.getTeleportRoot()
	if not root then return false end
	local goal = SNH.normalizeTeleportGoal(position)
	if not goal then return false end
	root.CFrame = CFrame.new(goal)
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	return true
end

-- Auto-steal only: fast instant snap + heartbeat lerp (NOT short slow hops).
SNH.fastStealTweenTo = function(goal, floatHeight, opts)
	opts = opts or {}
	local root, hum = SNH.getTeleportRoot()
	if not root or not goal then return false end
	local lift = tonumber(floatHeight) or 0
	local target = goal + Vector3.new(0, lift, 0)
	local start = root.Position
	local dist = (target - start).Magnitude
	if dist < 1 then return true end

	local wasMoving = stealFloatMoving
	stealFloatMoving = true

	if STEAL_INSTANT_TP ~= false then
		for _ = 1, TP_FALLBACK_TRIES do
			if SNH.rawTeleportRootTo(target) then
				task.wait(0.02)
				if SNH.isNearPosition(target, TP_ARRIVE_RADIUS) then
					stealFloatMoving = wasMoving
					return true
				end
			end
			task.wait(0.03)
		end
	end

	local stepDiv = 18
	local floatSteps = tonumber(STEAL_FLOAT_TP_STEPS)
	if floatSteps and floatSteps > 0 then
		stepDiv = math.max(6, 18 / floatSteps)
	end
	local steps = math.clamp(math.ceil(dist / stepDiv), 4, 24)
	for i = 1, steps do
		if not root.Parent then break end
		local alpha = i / steps
		local pos = start:Lerp(target, alpha)
		root.CFrame = CFrame.new(pos)
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
		if stealFloating then stealFloatAnchor = pos end
		pcall(function()
			if hum then
				hum.PlatformStand = false
				hum.AutoRotate = true
			end
		end)
		local delay = tonumber(STEAL_FLOAT_TP_DELAY) or 0
		if delay > 0 then
			task.wait(delay)
		else
			RunService.Heartbeat:Wait()
		end
	end

	stealFloatMoving = wasMoving
	return SNH.isNearPosition(target, TP_ARRIVE_RADIUS + 6)
end

-- Short slow hops toward goal (g2 teleporter pace: ~10 studs, ~1s between hops).
SNH.shortHopStep = function(targetPos, hopSize)
	local root, hum = SNH.getTeleportRoot()
	if not root or not targetPos then return false, "no root" end
	hopSize = tonumber(hopSize) or tonumber(SHORT_HOP_SIZE) or 10

	SNH.faceFlatToward(targetPos)
	local flat = Vector3.new(targetPos.X - root.Position.X, 0, targetPos.Z - root.Position.Z)
	local mag = flat.Magnitude
	if mag < 1 then return true, "arrived" end

	local move = math.min(hopSize, mag)
	local nextPos = root.Position + flat.Unit * move
	if math.abs(targetPos.Y - root.Position.Y) > 0.5 then
		local yAlpha = math.min(1, move / math.max(mag, 1))
		nextPos = Vector3.new(nextPos.X, root.Position.Y + (targetPos.Y - root.Position.Y) * yAlpha, nextPos.Z)
	end

	root.CFrame = CFrame.new(nextPos)
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	if stealFloating then stealFloatAnchor = nextPos end
	pcall(function()
		if hum then
			hum.PlatformStand = false
			hum.AutoRotate = true
		end
	end)
	return true, mag <= hopSize + 2 and "final" or "stepping"
end

SNH.shortHopTo = function(goal, floatHeight, opts)
	opts = opts or {}
	local root, hum = SNH.getTeleportRoot()
	if not root or not goal then return false end
	local lift = tonumber(floatHeight) or 0
	local target = goal + Vector3.new(0, lift, 0)
	if (target - root.Position).Magnitude < 1 then return true end

	local hopSize = tonumber(opts.stepSize) or tonumber(SHORT_HOP_SIZE) or tonumber(FAST_TWEEN_STEP_SIZE) or 10
	local hopWait = opts.stepWait
	if hopWait == nil then hopWait = tonumber(SHORT_HOP_WAIT) or tonumber(FAST_TWEEN_STEP_WAIT) or 1.05 end
	local maxSteps = tonumber(opts.maxSteps) or tonumber(SHORT_HOP_MAX_STEPS) or tonumber(FAST_TWEEN_MAX_STEPS) or 200
	local arrive = tonumber(opts.radius) or TP_ARRIVE_RADIUS + 6
	local timeout = tonumber(opts.timeout) or tonumber(SAFE_TELEPORT_TIMEOUT) or 120
	local deadline = tick() + timeout

	local canUseTeleporter = Networking
		and Networking.Place
		and Networking.Place.UseTeleporter
		and SNH.findTeleporterTool()
		and SNH.safeTeleportStep

	local wasMoving = stealFloatMoving
	stealFloatMoving = true
	local ok = false

	while tick() < deadline do
		if not root.Parent then break end
		if SNH.isNearPosition(target, arrive) then
			ok = true
			break
		end
		if tick() < teleportedBackUntil then
			task.wait(hopWait)
			continue
		end

		if canUseTeleporter then
			local stepOk, state = SNH.safeTeleportStep(target)
			if not stepOk then
				canUseTeleporter = false
			else
				if state == "final" or SNH.isNearPosition(target, arrive) then
					ok = true
					break
				end
				task.wait(0.05)
			end
		else
			local stepOk = SNH.shortHopStep(target, hopSize)
			if not stepOk then break end
			if SNH.isNearPosition(target, arrive) then
				ok = true
				break
			end
			task.wait(hopWait)
		end

		maxSteps -= 1
		if maxSteps <= 0 then break end
	end

	stealFloatMoving = wasMoving
	return ok or SNH.isNearPosition(target, arrive)
end

-- Alias: all movement fallbacks use short slow hops (not fast long tweens).
SNH.teleportToWithFallback = function(position, opts)
	opts = opts or {}
	local goal = SNH.normalizeTeleportGoal(position)
	if not goal then return false end
	local radius = tonumber(opts.radius) or TP_ARRIVE_RADIUS
	local floatHeight = opts.floatHeight

	if SNH.isNearPosition(goal, radius) then return true end

	if TELEPORT_AVOID_RAW_CFRAME ~= false then
		return SNH.shortHopTo(goal, floatHeight, opts)
	end

	local tries = tonumber(opts.tries) or TP_FALLBACK_TRIES
	for _ = 1, tries do
		if tick() < teleportedBackUntil then break end
		if SNH.rawTeleportRootTo(goal) then
			task.wait(0.02)
			if SNH.isNearPosition(goal, radius) then return true end
		end
		task.wait(0.03)
	end

	if SNH.shortHopTo(goal, floatHeight, opts) then return true end
	return SNH.isNearPosition(goal, radius + 8)
end

-- ===== Safe teleport (game-allowed methods from g2 decompile) =====
-- TeleporterController  -> Networking.Place.UseTeleporter (look-direction hops, ~10-15 studs, 1s cd)
-- TeleportButtons       -> Networking.TeleportButton.Request ("Garden" | "Sell" | "Seeds")
-- Long distance         -> short slow hops (SHORT_HOP_SIZE + SHORT_HOP_WAIT), not one big teleport
SNH.loadTeleporterDistances = function()
	if next(teleporterDistanceCache) then return teleporterDistanceCache end
	pcall(function()
		local shared = ReplicatedStorage:FindFirstChild("SharedModules")
		local mod = shared and shared:FindFirstChild("TeleporterData")
		if mod then
			local data = require(mod)
			for _, entry in (data.Data or {}) do
				if entry.Name and tonumber(entry.TeleportDistance) then
					teleporterDistanceCache[entry.Name] = tonumber(entry.TeleportDistance)
				end
			end
		end
	end)
	return teleporterDistanceCache
end

SNH.findTeleporterTool = function()
	for _, bag in { LocalPlayer.Character, LocalPlayer.Backpack } do
		if not bag then continue end
		for _, item in bag:GetChildren() do
			if item:IsA("Tool") and item:GetAttribute("Teleporter") ~= nil then
				return item
			end
		end
	end
	return nil
end

SNH.getTeleporterDistance = function(tool)
	local d = tool and tonumber(tool:GetAttribute("TeleportDistance"))
	if d and d > 0 then return d end
	local name = tool and tool:GetAttribute("Teleporter")
	if name then
		SNH.loadTeleporterDistances()
		d = teleporterDistanceCache[tostring(name)]
		if d and d > 0 then return d end
	end
	return 15
end

SNH.getTeleportButtonPosition = function(kind)
	kind = tostring(kind or "")
	if kind == "Garden" then
		local plotId = LocalPlayer:GetAttribute("PlotId")
		local gardens = workspace:FindFirstChild("Gardens")
		if plotId and gardens then
			local plot = gardens:FindFirstChild("Plot" .. tostring(plotId))
			local spawn = plot and plot:FindFirstChild("SpawnPoint")
			if spawn and spawn:IsA("BasePart") then
				return spawn.Position
			end
		end
		local _, plot = API.getLocalPlot()
		return plot and SNH.getGardenInteriorPosition(plot)
	end
	local teleports = workspace:FindFirstChild("Teleports")
	local part = teleports and teleports:FindFirstChild(kind)
	if part and part:IsA("BasePart") then
		return part.Position
	end
	return nil
end

SNH.waitForNearPosition = function(goal, radius, timeout)
	goal = SNH.normalizeTeleportGoal(goal)
	if not goal then return false end
	radius = tonumber(radius) or TP_ARRIVE_RADIUS
	timeout = tonumber(timeout) or 2.5
	local deadline = tick() + timeout
	while tick() < deadline do
		if SNH.isNearPosition(goal, radius) then return true end
		task.wait(0.05)
	end
	return SNH.isNearPosition(goal, radius + 4)
end

SNH.tryTeleportButton = function(kind, waitArrive)
	if not Networking or not Networking.TeleportButton or not Networking.TeleportButton.Request then
		return false
	end
	kind = tostring(kind or "")
	if kind == "" then return false end
	local dest = SNH.getTeleportButtonPosition(kind)
	if not dest then return false end
	local ok = pcall(function()
		Networking.TeleportButton.Request:Fire(kind)
	end)
	if not ok then return false end
	if waitArrive == false then return true end
	return SNH.waitForNearPosition(dest, 12, 2.5)
end

SNH.tryTeleportButtonNearGoal = function(goal)
	goal = SNH.normalizeTeleportGoal(goal)
	if not goal then return false end
	local radius = tonumber(SAFE_TELEPORT_BUTTON_RADIUS) or 90
	local bestKind, bestDist = nil, math.huge
	for _, kind in { "Garden", "Sell", "Seeds" } do
		local pos = SNH.getTeleportButtonPosition(kind)
		if pos then
			local d = (Vector3.new(goal.X, 0, goal.Z) - Vector3.new(pos.X, 0, pos.Z)).Magnitude
			if d < bestDist then
				bestDist = d
				bestKind = kind
			end
		end
	end
	if not bestKind or bestDist > radius then return false end
	return SNH.tryTeleportButton(bestKind, true)
end

SNH.faceFlatToward = function(targetPos)
	local root, hum = SNH.getTeleportRoot()
	if not root or not targetPos then return false end
	local flat = Vector3.new(targetPos.X - root.Position.X, 0, targetPos.Z - root.Position.Z)
	if flat.Magnitude < 0.05 then return true end
	root.CFrame = CFrame.lookAt(root.Position, root.Position + flat.Unit)
	root.AssemblyAngularVelocity = Vector3.zero
	pcall(function()
		hum.AutoRotate = false
	end)
	return true
end

SNH.equipTeleporterTool = function()
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local tool = SNH.findTeleporterTool()
	if not (char and hum and tool) then return nil end
	if tool.Parent ~= char then
		pcall(function() hum:EquipTool(tool) end)
		task.wait(0.08)
	end
	return tool.Parent == char and tool or SNH.findTeleporterTool()
end

SNH.safeTeleportStep = function(targetPos)
	if not Networking or not Networking.Place or not Networking.Place.UseTeleporter then
		return false, "no UseTeleporter remote"
	end
	local char = LocalPlayer.Character
	local head = char and char:FindFirstChild("Head")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not (head and hum and hum.Health > 0) then return false, "no character" end

	local tool = SNH.equipTeleporterTool()
	if not tool then return false, "no Teleporter tool" end

	local now = os.clock()
	local cd = tonumber(SAFE_TELEPORT_COOLDOWN) or 1
	if now - lastSafeTeleportUseAt < cd then
		task.wait(cd - (now - lastSafeTeleportUseAt))
	end

	SNH.faceFlatToward(targetPos)
	head = char:FindFirstChild("Head")
	if not head then return false, "no head" end

	local dist = SNH.getTeleporterDistance(tool)
	local look = head.CFrame.LookVector
	local flatLook = Vector3.new(look.X, 0, look.Z)
	if flatLook.Magnitude < 0.01 then
		SNH.faceFlatToward(targetPos)
		head = char:FindFirstChild("Head")
		if not head then return false, "no head" end
		look = head.CFrame.LookVector
		flatLook = Vector3.new(look.X, 0, look.Z)
	end
	if flatLook.Magnitude < 0.01 then return false, "bad look vector" end

	local destCFrame = head.CFrame + flatLook.Unit * dist
	pcall(function()
		head.CFrame = destCFrame
	end)
	pcall(function()
		Networking.Place.UseTeleporter:Fire(destCFrame.Position)
	end)
	lastSafeTeleportUseAt = os.clock()

	local flat = Vector3.new(targetPos.X - head.Position.X, 0, targetPos.Z - head.Position.Z)
	local mag = flat.Magnitude
	return true, mag <= dist + 2 and "final" or "stepping"
end

SNH.safeTeleportTo = function(targetPos, timeout)
	if typeof(targetPos) ~= "Vector3" then
		if typeof(targetPos) == "Instance" and targetPos:IsA("BasePart") then
			targetPos = targetPos.Position
		else
			return false
		end
	end
	if SNH.isNearPosition(targetPos, TP_ARRIVE_RADIUS) then return true end

	timeout = tonumber(timeout) or tonumber(SAFE_TELEPORT_TIMEOUT) or 45
	local deadline = tick() + timeout
	local cooldown = tonumber(SAFE_TELEPORT_COOLDOWN) or 1

	while tick() < deadline do
		local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if not root then return false end
		local flat = Vector3.new(targetPos.X - root.Position.X, 0, targetPos.Z - root.Position.Z)
		if flat.Magnitude <= 8 then return true end

		if not SNH.findTeleporterTool() then
			return false
		end
		local ok, state = SNH.safeTeleportStep(targetPos)
		if not ok then
			warn("[So Nach Hup] safeTeleportTo stopped: " .. tostring(state))
			return false
		end
		if state == "final" and SNH.isNearPosition(targetPos, TP_ARRIVE_RADIUS + 6) then
			return true
		end
		task.wait(cooldown)
	end
	return SNH.isNearPosition(targetPos, TP_ARRIVE_RADIUS + 10)
end

-- Unified teleport: g2 button / teleporter hops first, then short slow hops to target.
SNH.markTeleportAway = function(seconds)
	local sec = seconds
	if sec == nil then sec = tonumber(TELEPORT_SUPPRESS_GARDEN_STAY_SEC) or 6 end
	sec = tonumber(sec) or 0
	if sec <= 0 then return end
	suppressGardenStayUntil = math.max(suppressGardenStayUntil, tick() + sec)
end

SNH.setupTeleportBackHook = function()
	if teleportBackHooked then return end
	if not Networking or not Networking.Place or not Networking.Place.TeleportedBack then return end
	pcall(function()
		Networking.Place.TeleportedBack.OnClientEvent:Connect(function()
			teleportedBackUntil = tick() + 2.5
			SNH.markTeleportAway(4)
		end)
	end)
	teleportBackHooked = true
end

SNH.safeTeleport = function(position, opts)
	opts = opts or {}
	local goal = SNH.normalizeTeleportGoal(position)
	if not goal then return false end
	local radius = tonumber(opts.radius) or TP_ARRIVE_RADIUS
	if SNH.isNearPosition(goal, radius) then return true end

	SNH.markTeleportAway(opts.suppressGardenStay)
	activeTeleportDepth = activeTeleportDepth + 1
	local function finish(result)
		activeTeleportDepth = math.max(0, activeTeleportDepth - 1)
		return result
	end

	local useSafe = opts.safe
	if useSafe == nil then useSafe = USE_SAFE_TELEPORT == true end
	local allowFast = opts.allowFast ~= false and SAFE_TELEPORT_FALLBACK_FAST ~= false
	local preferButton = opts.button ~= false
	local mode = tostring(opts.mode or TELEPORT_MODE or "short")

	if useSafe and preferButton then
		local _, plot = API.getLocalPlot()
		if plot then
			local interior = SNH.getGardenInteriorPosition(plot)
			if interior and (goal - interior).Magnitude <= (tonumber(SAFE_TELEPORT_BUTTON_RADIUS) or 90) then
				if SNH.tryTeleportButton("Garden", true) and SNH.isNearPosition(goal, radius + 20) then
					return finish(true)
				end
			end
		end
		if SNH.tryTeleportButtonNearGoal(goal) and SNH.isNearPosition(goal, radius + 25) then
			return finish(true)
		end
	end

	local useTeleporter = useSafe
		and SNH.findTeleporterTool()
		and Networking and Networking.Place and Networking.Place.UseTeleporter
		and (mode == "safe" or mode == "short" or mode == "tween" or mode == "both" or opts.teleporter == true)
	if useTeleporter then
		if SNH.safeTeleportTo(goal, opts.timeout or SAFE_TELEPORT_TIMEOUT) then
			return finish(true)
		end
	end

	if allowFast then
		if opts.float and SNH.floatTeleportTo then
			return finish(SNH.floatTeleportTo(goal, opts.floatHeight))
		end
		if TELEPORT_AVOID_RAW_CFRAME ~= false or mode == "short" or mode == "tween" then
			return finish(SNH.shortHopTo(goal, opts.floatHeight, opts))
		end
		return finish(SNH.teleportToWithFallback(goal, opts))
	end
	return finish(SNH.isNearPosition(goal, radius + 8))
end

SNH.stealPause = function(seconds)
	seconds = tonumber(seconds) or 0
	if seconds <= 0 then
		task.wait()
		return
	end
	task.wait(seconds)
end

SNH.waitWallClock = SNH.stealPause

SNH.teleportRootToSteal = function(position, opts)
	opts = opts or {}
	SNH.markTeleportAway()
	local goal = SNH.normalizeTeleportGoal(position)
	if not goal then return false end

	if opts.home ~= false then
		local _, plot = API.getLocalPlot()
		if plot then
			local interior = SNH.getGardenInteriorPosition(plot)
			if interior and (goal - interior).Magnitude <= (tonumber(SAFE_TELEPORT_BUTTON_RADIUS) or 90) then
				if SNH.tryTeleportButton("Garden", true) and SNH.isNearPosition(goal, TP_ARRIVE_RADIUS + 20) then
					return true
				end
			end
		end
	end

	local floatH = opts.floatHeight
	if floatH == nil then floatH = STEAL_FLOAT_HEIGHT end

	if STEAL_USE_SHORT_HOP then
		if SNH.floatTeleportTo then
			return SNH.floatTeleportTo(position, floatH)
		end
		return SNH.shortHopTo(goal, floatH, { timeout = opts.timeout or SAFE_TELEPORT_TIMEOUT })
	end

	if STEAL_FAST_HOP or STEAL_INSTANT_TP or opts.fast == true then
		if SNH.floatTeleportTo then
			return SNH.floatTeleportTo(position, floatH)
		end
		return SNH.fastStealTweenTo(goal, floatH)
	end

	return SNH.safeTeleport(position, { button = false, allowFast = true, float = true, safe = opts.safe })
end

SNH.getPlotHarvestStandPosition = function(plot)
	plot = plot or API.getPlayerPlot()
	if not plot then return nil end
	return API.getPlotInteriorCenter(plot) or SNH.getGardenInteriorPosition(plot)
end

SNH.getPlotCenterPosition = SNH.getPlotHarvestStandPosition

-- Pivot to center of PlotSizeReference / GardenTotalArea inside the plot.
SNH.teleportToPlotCenter = function(plot)
	plot = plot or API.getPlayerPlot()
	if not plot or not API.isLocalPlot(plot) then return false end
	local pos = SNH.getPlotCenterPosition(plot)
	if not pos then return false end
	return SNH.safeTeleport(pos, { button = true })
end

SNH.canHarvestFromPlot = function(plot)
	plot = plot or API.getPlayerPlot()
	if not plot or not API.isLocalPlot(plot) then return false end
	if API.isInOwnGarden(LocalPlayer) then return true end
	if API.isPlayerInsidePlot(LocalPlayer, plot) then return true end
	return false
end

SNH.isHarvestBlocked = function()
	if SNH.isStealCarryActive() then return true end
	if LocalPlayer:GetAttribute("LoadingScreenActive") then return true end
	return false
end

SNH.getGardenInteriorPosition = function(plot)
	if not plot then return nil end
	local areas, seen = {}, {}
	for _, part in CollectionService:GetTagged("PlantArea") do
		if part:IsA("BasePart") and part:IsDescendantOf(plot) and not seen[part] then
			seen[part] = true
			table.insert(areas, part)
		end
	end
	if #areas == 0 then
		for _, part in CollectionService:GetTagged("GardenTotalArea") do
			if part:IsA("BasePart") and part:IsDescendantOf(plot) and not seen[part] then
				seen[part] = true
				table.insert(areas, part)
			end
		end
		for _, part in plot:GetDescendants() do
			if part:IsA("BasePart") and (part.Name == "GardenTotalArea" or part.Name == "GardenArea") and not seen[part] then
				seen[part] = true
				table.insert(areas, part)
			end
		end
	end
	if #areas == 0 then return plot:GetPivot().Position + Vector3.new(0, 5, 0) end
	local best, bestVol = areas[1], 0
	for _, part in areas do
		local vol = part.Size.X * part.Size.Y * part.Size.Z
		if vol > bestVol then best, bestVol = part, vol end
	end
	return best.CFrame:PointToWorldSpace(Vector3.new(0, best.Size.Y * 0.5 + 4, 0))
end

-- Outside own plot — used when steal carry is stuck after returning home.
SNH.getGardenExteriorPosition = function(plot, offsetStuds)
	if not plot then return nil end
	local push = tonumber(offsetStuds) or STEAL_GARDEN_BOUNCE_OFFSET or 28
	local cf, size = plot:GetBoundingBox()
	local half = size * 0.5
	local y = math.max(4, half.Y * 0.5 + 4)
	local side = math.max(half.X, half.Z) + push
	return cf:PointToWorldSpace(Vector3.new(side, y, side))
end

SNH.returnToOwnGarden = function()
	local _, plot = API.getLocalPlot()
	if not plot then return false end
	local pos = SNH.getGardenInteriorPosition(plot)
	if not pos then return false end
	if SNH.tryTeleportButton("Garden", true) and SNH.isNearPosition(pos, 25) then
		return true
	end
	return SNH.safeTeleport(pos, { button = true })
end

SNH.ensureInsideOwnGardenAtNight = function()
	if not API.canStealNow() then return false end
	local _, plot = API.getLocalPlot()
	if not plot then return false end
	if API.isPlayerInsidePlot(LocalPlayer, plot) then return true end
	local pos = SNH.getGardenInteriorPosition(plot)
	if not pos then return false end
	SNH.setStatus("Returning to garden (night)")
	return SNH.safeTeleport(pos, { button = true })
end

-- Daytime: stay in own garden for harvest unless a teleport task is active (wild pet, snipe, steal).
SNH.isAwayForGardenStay = function()
	if tick() < suppressGardenStayUntil then return true end
	if activeTeleportDepth > 0 then return true end
	if wildPetBuying then return true end
	if seedSnipeActive then return true end
	if stealActive then return true end
	if API.canStealNow() and stealInVictimGarden then return true end
	if SNH.isStealCarryActive() then return true end
	return false
end

SNH.shouldStayInOwnGardenAtDay = function()
	if AUTO_STAY_IN_GARDEN_DAY == false then return false end
	if API.canStealNow() then return false end
	if not ENABLED or not API.ready then return false end
	if LocalPlayer:GetAttribute("LoadingScreenActive") then return false end
	return true
end

SNH.ensureInsideOwnGardenAtDay = function()
	if not SNH.shouldStayInOwnGardenAtDay() then return false end
	if SNH.isAwayForGardenStay() then return false end
	local _, plot = API.getLocalPlot()
	if not plot then return false end
	if SNH.canHarvestFromPlot(plot) then return true end
	return SNH.ensureInsideOwnPlotForHarvest()
end

SNH.loopDayGardenStay = function()
	if not SNH.shouldStayInOwnGardenAtDay() then return end
	if SNH.isAwayForGardenStay() then return end
	if SNH.isHarvestBlocked() then return end
	local _, plot = API.getLocalPlot()
	if not plot then return end
	if SNH.canHarvestFromPlot(plot) then return end
	local now = tick()
	local gap = tonumber(GARDEN_STAY_GAP) or 0.6
	if now - lastGardenStayAt < gap then return end
	lastGardenStayAt = now
	SNH.setStatus("Returning to garden (day)")
	SNH.ensureInsideOwnPlotForHarvest()
end

SNH.isOwnerGuardingGarden = function(owner, plot)
	if not plot then return true end
	if owner then
		if owner:GetAttribute("IsInOwnGarden") == true then return true end
		if API.isPlayerInsidePlot(owner, plot) then return true end
	end
	return false
end

SNH.shouldFleeSteal = function(pack)
	if not pack then return true end
	local owner = pack.owner
	local plot = pack.garden and pack.garden.plot
	if owner and API.isGardenLockedForSteal(owner) then return true end
	if SNH.isOwnerGuardingGarden(owner, plot) then return true end
	return false
end

SNH.fleeStealToHome = function(reason)
	local label = reason or "garden locked"
	print(("[So Nach Hup] Fleeing steal: %s"):format(label))
	SNH.setStatus(("Flee steal: %s"):format(label))
	stealInVictimGarden = false
	SNH.setStealFloat(false)
	local _, ownPlot = API.getLocalPlot()
	local homePos = ownPlot and SNH.getGardenInteriorPosition(ownPlot)
	if homePos then
		SNH.safeTeleport(homePos, { button = true, allowFast = true, float = true })
	end
	if SNH.returnToOwnGarden then
		task.defer(SNH.returnToOwnGarden)
	end
end

SNH.getPlotFromModel = function(model)
	if not model then return nil end
	local gardens = workspace:FindFirstChild("Gardens")
	if not gardens then return nil end
	local node = model
	while node and node ~= workspace do
		if node.Parent == gardens and node:IsA("Model") then return node end
		node = node.Parent
	end
	return nil
end
end
teleportRootTo = SNH.safeTeleport
teleportTo = SNH.safeTeleport
safeTeleport = SNH.safeTeleport
teleportRootToSteal = SNH.teleportRootToSteal
getGardenInteriorPosition = SNH.getGardenInteriorPosition
returnToOwnGarden = SNH.returnToOwnGarden
isOwnerGuardingGarden = SNH.isOwnerGuardingGarden
getPlotFromModel = SNH.getPlotFromModel

do --[[ SNH: HarvestPrompts ]]
-- HarvestPromptController: prompt.Parent -> FindFirstAncestorWhichIsA("Model") -> PlantId/FruitId
SNH.getModelFromPrompt = function(prompt)
	if not prompt or not prompt.Parent then return nil end
	return prompt.Parent:FindFirstAncestorWhichIsA("Model")
end

SNH.resolveHarvestIdsFromPrompt = function(prompt)
	if not prompt or not prompt.Parent then return nil, nil end
	local model = SNH.getModelFromPrompt(prompt)
	if not model then return nil, nil end
	local plantId = model:GetAttribute("PlantId")
	local fruitId = model:GetAttribute("FruitId")
	if plantId then
		return plantId, fruitId
	end
	return SNH.resolveHarvestIds(model)
end

SNH.modelOwnedByUser = function(model, ownerUserId, plot)
	if not model then return false end
	local cur = model
	while cur do
		local uid = tonumber(cur:GetAttribute("UserId"))
		if uid then return uid == ownerUserId end
		if cur == workspace then break end
		cur = cur.Parent
	end
	plot = plot or API.getPlayerPlot()
	if plot and model:IsDescendantOf(plot) then
		local plotUid = tonumber(plot:GetAttribute("OwnerUserId"))
		if plotUid and plotUid == ownerUserId then return true end
	end
	return false
end

SNH.resolveHarvestIds = function(model)
	if not model then return nil, nil end
	local plantId = model:GetAttribute("PlantId")
	local fruitId = model:GetAttribute("FruitId")
	if plantId then
		if not fruitId then
			for _, desc in model:GetDescendants() do
				if not desc:IsA("Model") then continue end
				local fid = desc:GetAttribute("FruitId")
				if not fid then continue end
				local prompt = desc:FindFirstChild("HarvestPrompt", true)
				if prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled and not prompt:GetAttribute("Collected") then
					fruitId = fid
					break
				end
			end
		end
		return plantId, fruitId
	end
	local cur = model.Parent
	while cur and cur ~= workspace do
		if cur:IsA("Model") then
			local pid = cur:GetAttribute("PlantId")
			if pid then
				return pid, fruitId or model:GetAttribute("FruitId")
			end
		end
		cur = cur.Parent
	end
	return nil, fruitId
end

SNH.isReadyHarvestPrompt = function(prompt, plot, ownerUserId)
	if not prompt or not prompt:IsA("ProximityPrompt") then return false end
	if prompt.Name ~= "HarvestPrompt" and not CollectionService:HasTag(prompt, "HarvestPrompt") then
		return false
	end
	if prompt:GetAttribute("Collected") then return false end
	if plot and not prompt:IsDescendantOf(plot) then return false end
	local model = SNH.getModelFromPrompt(prompt)
	if not model then return false end
	if not SNH.modelOwnedByUser(model, ownerUserId, plot) then return false end
	local plantId = select(1, SNH.resolveHarvestIdsFromPrompt(prompt))
	if not plantId then return false end
	if not prompt.Enabled and not SNH.isHarvestablePlant(model) then return false end
	return true
end

SNH.isHarvestPrompt = function(prompt)
	if not prompt or not prompt:IsA("ProximityPrompt") then return false end
	return prompt.Name == "HarvestPrompt" or CollectionService:HasTag(prompt, "HarvestPrompt")
end

SNH.isStealPrompt = function(prompt)
	if not prompt or not prompt:IsA("ProximityPrompt") then return false end
	return prompt.Name == "StealPrompt" or CollectionService:HasTag(prompt, "StealPrompt")
end

SNH.getHarvestPromptRange = function()
	return math.min(tonumber(HARVEST_PROMPT_RANGE) or 10000, PROMPT_RANGE_MAX or 10000)
end

-- Force full-map collect radius on your own plot (game resets MaxActivationDistance to 10).
SNH.applyFullMapHarvestPrompt = function(prompt)
	if not prompt or not prompt:IsA("ProximityPrompt") then return end
	if not SNH.isHarvestPrompt(prompt) then return end
	if not SNH.isPromptOnLocalPlot(prompt) then return end
	local want = SNH.getHarvestPromptRange()
	prompt.HoldDuration = 0
	prompt.RequiresLineOfSight = false
	prompt.Enabled = true
	if prompt.MaxActivationDistance ~= want then
		prompt.MaxActivationDistance = want
	end
end

SNH.lockHarvestPromptRange = function(prompt)
	if not prompt or not prompt:IsA("ProximityPrompt") then return end
	if not SNH.isHarvestPrompt(prompt) or not SNH.isPromptOnLocalPlot(prompt) then return end
	SNH.applyFullMapHarvestPrompt(prompt)
	if harvestPromptRangeHooked[prompt] then return end
	harvestPromptRangeHooked[prompt] = true
	SNH.trackConn(prompt:GetPropertyChangedSignal("MaxActivationDistance"):Connect(function()
		if prompt.Parent and SNH.isPromptOnLocalPlot(prompt) then
			SNH.applyFullMapHarvestPrompt(prompt)
		end
	end), "harvest_prompt_range")
	prompt.Destroying:Once(function()
		harvestPromptRangeHooked[prompt] = nil
	end)
end

SNH.boostHarvestPromptRange = function(prompt)
	SNH.applyFullMapHarvestPrompt(prompt)
	SNH.lockHarvestPromptRange(prompt)
end

SNH.boostPromptRange = function(prompt, range)
	if not prompt or not prompt:IsA("ProximityPrompt") then return end
	local want = math.min(tonumber(range) or STEAL_PROMPT_RANGE, PROMPT_RANGE_MAX)
	prompt.MaxActivationDistance = math.max(prompt.MaxActivationDistance, want)
	prompt.RequiresLineOfSight = false
end

SNH.isPromptOnLocalPlot = function(prompt)
	if not prompt then return false end
	local _, plot = API.getLocalPlot()
	return plot ~= nil and prompt:IsDescendantOf(plot)
end

-- Only touches harvest prompts on your own plot (game resets MaxActivationDistance to 10 in u64).
SNH.instantizePrompt = function(prompt)
	if not AUTO_INSTANT_PROMPTS or not SNH.isHarvestPrompt(prompt) then return end
	SNH.boostHarvestPromptRange(prompt)
end

SNH.maintainLocalHarvestPrompts = function()
	if not AUTO_INSTANT_PROMPTS then return end
	local plot = API.getPlayerPlot()
	if not plot then return end
	for _, inst in plot:GetDescendants() do
		if inst:IsA("ProximityPrompt") and SNH.isHarvestPrompt(inst) then
			SNH.lockHarvestPromptRange(inst)
		end
	end
end

SNH.startHarvestPromptMaintainLoop = function()
	if USE_UNIFIED_SCHEDULER then return end
	if harvestPromptMaintainConn then return end
	task.spawn(function()
		while running do
			if ENABLED and AUTO_COLLECT and HARVEST_PROMPT_MAINTAIN then
				pcall(SNH.maintainLocalHarvestPrompts)
			end
			task.wait(0.15)
		end
	end)
	harvestPromptMaintainConn = true
end

SNH.setupInstantPromptHooks = function()
	if instantPromptHooked or not AUTO_INSTANT_PROMPTS then return end
	instantPromptHooked = true
	local hookedPlots = setmetatable({}, { __mode = "k" })
	local function hookPlot(plot)
		if not plot or hookedPlots[plot] then return end
		hookedPlots[plot] = true
		for _, inst in plot:GetDescendants() do
			if inst:IsA("ProximityPrompt") then SNH.instantizePrompt(inst) end
		end
		SNH.trackConn(plot.DescendantAdded:Connect(function(inst)
			if inst:IsA("ProximityPrompt") then SNH.instantizePrompt(inst) end
		end), "instant_prompt")
	end
	hookPlot(select(2, API.getLocalPlot()))
	SNH.trackConn(LocalPlayer:GetAttributeChangedSignal("PlotId"):Connect(function()
		hookPlot(select(2, API.getLocalPlot()))
	end), "instant_prompt")
	SNH.trackConn(CollectionService:GetInstanceAddedSignal("HarvestPrompt"):Connect(function(inst)
		if inst:IsA("ProximityPrompt") then SNH.instantizePrompt(inst) end
	end), "instant_prompt")
end

-- Collect fruit via ProximityPrompt on own plot (full-map range, HoldDuration 0).
SNH.collectHarvestPrompt = function(prompt)
	if not prompt or not prompt:IsA("ProximityPrompt") then return false end
	if not SNH.isHarvestPrompt(prompt) then return false end
	if not SNH.isPromptOnLocalPlot(prompt) then return false end
	if not prompt:IsDescendantOf(workspace) then return false end
	if not prompt.Enabled or prompt:GetAttribute("Collected") then return false end

	SNH.boostHarvestPromptRange(prompt)
	local before = SNH.countFruitInInventory()
	local plantId = select(1, SNH.resolveHarvestIdsFromPrompt(prompt))
	local fruitId = select(2, SNH.resolveHarvestIdsFromPrompt(prompt))

	local function collectedOk()
		if SNH.countFruitInInventory() > before then return true end
		if not prompt.Parent then return true end
		if prompt:GetAttribute("Collected") or not prompt.Enabled then return true end
		if plantId and SNH.harvestTargetCollected(API.getPlayerPlot(), plantId, fruitId) then return true end
		return false
	end

	if not SNH.triggerHarvestPrompt(prompt) then return false end

	local verifyWait = tonumber(COLLECT_VERIFY_WAIT) or 0.08
	local deadline = tick() + verifyWait
	while tick() < deadline do
		if collectedOk() then return true end
		task.wait(0.03)
	end
	return collectedOk()
end

SNH.performHarvestCollect = SNH.collectHarvestPrompt

-- HarvestPromptController triggerPromptProgrammatically (u10)
SNH.triggerHarvestPrompt = function(prompt)
	if not prompt or not prompt:IsA("ProximityPrompt") then return false end
	local ok = pcall(function()
		prompt.RequiresLineOfSight = false
		if typeof(fireproximityprompt) == "function" then
			fireproximityprompt(prompt, 0)
			if (prompt.HoldDuration or 0) > 0 then
				task.wait(prompt.HoldDuration + 0.05)
			end
			fireproximityprompt(prompt, 1)
		else
			prompt:InputHoldBegin()
			if (prompt.HoldDuration or 0) > 0 then
				task.wait(prompt.HoldDuration + 0.05)
			end
			prompt:InputHoldEnd()
		end
	end)
	return ok
end

-- Widen harvest prompt range on own plot so full-map proximity collect works.
SNH.boostHarvestPrompt = function(prompt)
	if not prompt or not SNH.isHarvestPrompt(prompt) then return end
	SNH.boostHarvestPromptRange(prompt)
end

SNH.boostPlotHarvestPrompts = function(plot)
	plot = plot or API.getPlayerPlot()
	if not plot then return end
	for _, inst in plot:GetDescendants() do
		if inst:IsA("ProximityPrompt") and SNH.isHarvestPrompt(inst) then
			SNH.boostHarvestPrompt(inst)
		end
	end
end
end

do --[[ SNH: HarvestGather ]]
SNH.getBestHarvestValueModel = function(model)
	if not model then return nil, 0 end
	local bestModel, bestValue = model, 0
	local function consider(m)
		if not m or not m:IsA("Model") then return end
		local value = API.getFruitValueFromModel(m)
		if value > bestValue then
			bestValue = value
			bestModel = m
		end
	end
	consider(model)
	local fruits = model:FindFirstChild("Fruits")
	if fruits then
		for _, child in fruits:GetChildren() do
			if child:IsA("Model") then consider(child) end
		end
	end
	for _, desc in model:GetDescendants() do
		if desc:IsA("Model") and desc:GetAttribute("FruitId") then
			consider(desc)
		end
	end
	return bestModel, bestValue
end

SNH.getHarvestBackpackRoom = function(forceFresh)
	local maxCap = SNH.getMaxFruitCapacity()
	if forceFresh then fruitCountCache.time = 0 end
	return math.max(0, maxCap - SNH.getCachedFruitCount())
end

SNH.clearHarvestTargetsCache = function() end

SNH.gatherAllHarvestTargets = function(plot, ownerUserId)
	return SNH.gatherReadyHarvestTargets(plot, ownerUserId)
end

SNH.ensureReadyToHarvest = function(plot)
	plot = plot or API.getPlayerPlot()
	if not plot then return false end
	if not API.canStealNow() then
		stealInVictimGarden = false
	end
	if API.isInOwnGarden(LocalPlayer) and SNH.canHarvestFromPlot(plot) then
		return true
	end
	if SNH.isHarvestBlocked() then return false end
	SNH.clearHarvestTargetsCache()
	SNH.setStatus("Moving to garden for harvest...")
	if not SNH.ensureInsideOwnPlotForHarvest() then return false end
	local deadline = tick() + 2.5
	while tick() < deadline do
		if API.isInOwnGarden(LocalPlayer) and SNH.canHarvestFromPlot(plot) then
			return true
		end
		task.wait(0.1)
	end
	return SNH.canHarvestFromPlot(plot)
end

SNH.onActivePhaseChanged = function(phase, prevPhase)
	SNH.clearHarvestTargetsCache()
	harvestFailStreak = 0
	if phase ~= "Night" then
		stealInVictimGarden = false
		if not stealActive then
			SNH.setStealFloat(false)
		end
	end
	if phase == "Day" and AUTO_COLLECT then
		task.defer(function()
			task.wait(0.3)
			if not API.canStealNow() then
				stealInVictimGarden = false
			end
			SNH.ensureReadyToHarvest()
		end)
	end
end

SNH.setupHarvestPhaseReset = function()
	if harvestPhaseHooked then return end
	harvestPhaseHooked = true
	local lastPhase = workspace:GetAttribute("ActivePhase")
	SNH.trackConn(workspace:GetAttributeChangedSignal("ActivePhase"):Connect(function()
		local phase = workspace:GetAttribute("ActivePhase")
		if phase == lastPhase then return end
		local prev = lastPhase
		lastPhase = phase
		SNH.onActivePhaseChanged(phase, prev)
	end), "harvest_phase")
	pcall(function()
		local nightVal = ReplicatedStorage:FindFirstChild("Night")
		if nightVal and nightVal:IsA("BoolValue") then
			SNH.trackConn(nightVal:GetPropertyChangedSignal("Value"):Connect(function()
				if nightVal.Value then return end
				local phase = workspace:GetAttribute("ActivePhase") or "Day"
				SNH.onActivePhaseChanged(phase, "Night")
			end), "harvest_phase_night")
		end
	end)
end

SNH.packHarvestTarget = function(entry)
	return {
		plantId = entry.plantId,
		fruitId = entry.fruitId,
		seedName = entry.seedName,
		value = tonumber(entry.value) or 0,
	}
end

SNH.getHarvestTargetValueFast = function(model)
	if not model then return 0 end
	local value = API.getFruitValueFromModel(model)
	if value > 0 then return value end
	local seedName = model:GetAttribute("SeedName") or model:GetAttribute("CorePartName")
	if seedName then return API.getSellValue(seedName) end
	return 0
end

SNH.getHarvestTargetValue = function(model, plantId, fruitId)
	local _, value = SNH.getBestHarvestValueModel(model)
	if value > 0 then return value end
	local seedName = model and (model:GetAttribute("SeedName") or model:GetAttribute("CorePartName"))
	if seedName then
		return API.getSellValue(seedName)
	end
	return 0
end

SNH.sortHarvestTargetsByValue = function(targets)
	table.sort(targets, function(a, b)
		local va = tonumber(a.value) or 0
		local vb = tonumber(b.value) or 0
		if va ~= vb then return va > vb end
		return tostring(a.plantId) < tostring(b.plantId)
	end)
	return targets
end

SNH.findHarvestPromptForTarget = function(plot, plantId, fruitId)
	if not plot or not plantId then return nil end
	for _, inst in plot:GetDescendants() do
		if not inst:IsA("ProximityPrompt") or not SNH.isHarvestPrompt(inst) then continue end
		if not inst.Enabled or inst:GetAttribute("Collected") then continue end
		local model = SNH.getModelFromPrompt(inst)
		if not model then continue end
		local pid, fid = SNH.resolveHarvestIdsFromPrompt(inst)
		if tostring(pid) == tostring(plantId)
			and tostring(fid or "") == tostring(fruitId or "") then
			return inst
		end
	end
	return nil
end

SNH.harvestTargetCollected = function(plot, plantId, fruitId)
	local prompt = SNH.findHarvestPromptForTarget(plot, plantId, fruitId)
	if prompt then
		return prompt:GetAttribute("Collected") == true or not prompt.Enabled
	end
	return false
end

SNH.triggerProximityPrompt = function(prompt)
	if not prompt or not prompt:IsA("ProximityPrompt") then return false end
	local ok = pcall(function()
		prompt.RequiresLineOfSight = false
		if typeof(fireproximityprompt) == "function" then
			fireproximityprompt(prompt, 0)
			if prompt.HoldDuration > 0 then
				task.wait(prompt.HoldDuration + 0.05)
			end
			fireproximityprompt(prompt, 1)
		else
			prompt:InputHoldBegin()
			if prompt.HoldDuration > 0 then
				task.wait(prompt.HoldDuration + 0.05)
			end
			prompt:InputHoldEnd()
		end
	end)
	return ok
end

SNH.collectHarvestTarget = function(plot, target)
	if not target then return false end
	plot = plot or API.getPlayerPlot()
	local prompt = target.prompt
	if not prompt and target.plantId then
		prompt = SNH.findHarvestPromptForTarget(plot, target.plantId, target.fruitId)
	end
	if not prompt then return false end
	return SNH.collectHarvestPrompt(prompt)
end

SNH.gatherReadyHarvestTargets = function(plot, ownerUserId)
	local targets, seen = {}, {}
	if not plot then return targets end
	local function tryAdd(prompt)
		if not SNH.isReadyHarvestPrompt(prompt, plot, ownerUserId) then return end
		if seen[prompt] then return end
		seen[prompt] = true
		local model = SNH.getModelFromPrompt(prompt)
		if not model then return end
		local plantId, fruitId = SNH.resolveHarvestIdsFromPrompt(prompt)
		if not plantId then return end
		table.insert(targets, {
			plantId = plantId,
			fruitId = fruitId,
			seedName = model:GetAttribute("SeedName") or model:GetAttribute("CorePartName"),
			value = SNH.getHarvestTargetValue(model, plantId, fruitId),
			prompt = prompt,
			model = model,
		})
	end
	-- Own plot only. Never iterate CollectionService:GetTagged("HarvestPrompt") — that is every garden.
	local plants = plot:FindFirstChild("Plants")
	if plants then
		for _, inst in plants:GetDescendants() do
			if inst:IsA("ProximityPrompt") then
				tryAdd(inst)
			end
		end
	end
	return targets
end

SNH.isHarvestablePlant = function(model)
	if not model or not model:IsA("Model") then return false end
	local prompt = model:FindFirstChild("HarvestPrompt", true)
	if prompt and prompt:IsA("ProximityPrompt") then
		if prompt:GetAttribute("Collected") then return false end
		if prompt.Enabled then return true end
	end
	local age = tonumber(model:GetAttribute("Age"))
	local maxAge = tonumber(model:GetAttribute("MaxAge"))
	if age and maxAge and age >= maxAge then return true end
	return false
end
end

do --[[ SNH: HarvestPlant ]]
SNH.getPlantAreas = function(plot)
	local areas, seen = {}, {}
	for _, part in plot:GetDescendants() do
		if part:IsA("BasePart") and (part.Name == "GardenTotalArea" or part.Name == "GardenArea") and not seen[part] then
			seen[part] = true
			table.insert(areas, part)
		end
	end
	for _, part in CollectionService:GetTagged("GardenTotalArea") do
		if part:IsA("BasePart") and part:IsDescendantOf(plot) and not seen[part] then
			seen[part] = true
			table.insert(areas, part)
		end
	end
	return areas
end

SNH.isTooCloseToPlant = function(plot, position)
	if not plot or not position then return false end
	local plantsFolder = plot:FindFirstChild("Plants")
	if not plantsFolder then return false end
	local flat = Vector2.new(position.X, position.Z)
	for _, child in plantsFolder:GetChildren() do
		if not child:IsA("Model") or not child:GetAttribute("PlantId") then continue end
		local pivot = child:GetPivot().Position
		if (flat - Vector2.new(pivot.X, pivot.Z)).Magnitude < 1 then return true end
	end
	return false
end

SNH.getRandomPlantPosition = function(plot)
	if not plot then return nil end
	local areas = SNH.getPlantAreasInPlot and SNH.getPlantAreasInPlot(plot) or {}
	if #areas == 0 then areas = SNH.getPlantAreas(plot) end
	if #areas == 0 then return nil end
	local areaParams = RaycastParams.new()
	areaParams.FilterType = Enum.RaycastFilterType.Include
	areaParams.FilterDescendantsInstances = areas
	for _ = 1, 10 do
		local part = areas[math.random(1, #areas)]
		if part.Transparency >= 1 then continue end
		local size = part.Size
		local probe = part.CFrame:PointToWorldSpace(Vector3.new(
			(math.random() - 0.5) * size.X * 0.88,
			size.Y * 0.5 + 3,
			(math.random() - 0.5) * size.Z * 0.88
		))
		local hit = workspace:Raycast(probe, Vector3.new(0, -500, 0), areaParams)
		if hit and hit.Instance:IsDescendantOf(plot) and not SNH.isTooCloseToPlant(plot, hit.Position) then
			local pos = hit.Position
			if SNH.snapToPlantArea then
				pos = SNH.snapToPlantArea(plot, pos) or pos
			end
			return pos
		end
	end
	local fallback = areas[math.random(1, #areas)]
	local pos = fallback.CFrame:PointToWorldSpace(Vector3.new(0, fallback.Size.Y * 0.5, 0))
	if SNH.snapToPlantArea then
		pos = SNH.snapToPlantArea(plot, pos) or pos
	end
	return pos
end

SNH.findSeedTool = function(seedName)
	for _, bag in { LocalPlayer.Character, LocalPlayer.Backpack } do
		if not bag then continue end
		for _, item in bag:GetChildren() do
			if item:IsA("Tool") and SNH.getSeedToolName(item) == seedName then
				return item
			end
		end
	end
	return nil
end

SNH.listSeedTools = function(seedName)
	local list = {}
	for _, bag in { LocalPlayer.Backpack, LocalPlayer.Character } do
		if not bag then continue end
		for _, item in bag:GetChildren() do
			if item:IsA("Tool") and SNH.getSeedToolName(item) == seedName then
				table.insert(list, item)
			end
		end
	end
	return list
end

SNH.equipSeedToolFast = function(tool)
	if not tool or not tool:IsA("Tool") then return nil end
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not (char and hum and hum.Health > 0) then return nil end
	if tool.Parent ~= LocalPlayer.Backpack and tool.Parent ~= char then return nil end
	if tool.Parent == char then return tool end
	pcall(hum.EquipTool, hum, tool)
	if tool.Parent ~= char then
		tool.Parent = char
	end
	return tool.Parent == char and tool or nil
end

SNH.firePlantRemote = function(pos, seedName, tool)
	if not pos or not seedName or not tool then return false end
	if not Networking then Networking = API.getNetworking() end
	if not Networking or not Networking.Plant or not Networking.Plant.PlantSeed then return false end
	local minGap = PLANT_FIRE_GAP > 0 and PLANT_FIRE_GAP or 0.18
	local now = tick()
	local waitFor = minGap - (now - lastPlantRemoteAt)
	if waitFor > 0 then task.wait(waitFor) end
	local ok = pcall(function()
		Networking.Plant.PlantSeed:Fire(pos, seedName, tool)
	end)
	if ok then lastPlantRemoteAt = tick() end
	return ok
end

SNH.buildPlantWorkQueue = function(plot, onlySeedName)
	local status = SNH.getPlantSlotStatus(plot, true)
	if status.atCap or status.room <= 0 then
		return {}
	end
	local roomLeft = status.room
	local candidates = {}
	local seen = {}
	for _, entry in SNH.getSeedTools() do
		local seedName = entry.name
		if onlySeedName and seedName ~= onlySeedName then continue end
		if seen[seedName] then continue end
		if not SNH.shouldAutoPlantSeedType(seedName, plot) then continue end
		seen[seedName] = true
		local tools = SNH.listSeedTools(seedName)
		if #tools == 0 then continue end
		table.insert(candidates, {
			seedName = seedName,
			tools = tools,
			price = SNH.getSeedPrice(seedName) or 0,
			planted = SNH.countPlantedSeed(plot, seedName),
		})
	end
	table.sort(candidates, function(a, b)
		if a.price ~= b.price then return a.price > b.price end
		return a.seedName < b.seedName
	end)
	local queue = {}
	for _, c in candidates do
		if roomLeft <= 0 then break end
		local toPlant = math.min(#c.tools, roomLeft)
		if toPlant <= 0 then continue end
		table.insert(queue, {
			seedName = c.seedName,
			target = c.planted + toPlant,
			planted = c.planted,
			tools = c.tools,
			price = c.price,
		})
		roomLeft -= toPlant
	end
	return queue
end

-- True while this seed can still fill empty garden slots.
SNH.hasSeedPlantWorkRemaining = function(plot, seedName)
	if SNH.getRemainingPlantSlots(plot, true) <= 0 then return false end
	if not SNH.shouldAutoPlantSeedType(seedName, plot) then return false end
	return #SNH.listSeedTools(seedName) > 0
end

SNH.getMaxSeedsForExpansionLevel = function(level)
	level = math.max(1, math.min(MAX_EXPANSIONS, math.floor(tonumber(level) or 1)))
	return EXPANSION_SEED_CAPS[level] or EXPANSION_SEED_CAPS[MAX_EXPANSIONS] or 200
end

SNH.isMaxExpansionReached = function()
	return API.getOwnedExpansions() >= MAX_EXPANSIONS
end

SNH.isSavingForPetSlots = function()
	if not SNH.isMaxExpansionReached() then return false end
	return SNH.getMaxPetSlots() < SNH.getAbsoluteMaxPetSlots()
end

SNH.shouldBuyPetSlots = SNH.isSavingForPetSlots

SNH.getPlantCapLimit = function()
	return SNH.getMaxSeedsForExpansionLevel(API.getOwnedExpansions())
end

SNH.getPlantSlotStatus = function(plot, forceFresh)
	local cap = SNH.getPlantCapLimit()
	if not plot then
		return { count = 0, cap = cap, room = cap, atCap = false }
	end
	local count = SNH.countPlants(plot, forceFresh == true)
	local room = math.max(0, cap - count)
	return {
		count = count,
		cap = cap,
		room = room,
		atCap = room <= 0,
		expansions = API.getOwnedExpansions(),
	}
end

SNH.isPlantCapReached = function(plot, forceFresh)
	if not plot then return false end
	local status = SNH.getPlantSlotStatus(plot, forceFresh == true)
	if status.atCap then
		plantCapModeActive = true
		return true
	end
	plantCapModeActive = false
	return false
end

SNH.shouldAutoPlantSeedType = function(seedName, plot)
	if not seedName or seedName == "" then return false end
	if SNH.isMutationShopSeed(seedName) then return false end
	if SNH.isSeedReservedForMail(seedName) then return false end
	plot = plot or select(2, API.getLocalPlot())
	if plot and SNH.getRemainingPlantSlots(plot, true) <= 0 then
		-- At seed cap (200 / 600 / 800): no fill planting — upgrade / expand handles cap.
		return false
	end
	-- Below cap: plant every seed in inventory (single-harvest and long-harvest alike).
	if PLANT_ALL_INVENTORY_EXCEPT_MUTATION then
		return true
	end
	return (PlantSeedsConfig[seedName] or 0) > 0
end

SNH.canRunPlantWorker = function()
	if not ENABLED or not AUTO_PLANT or not API.ready then return false end
	if SNH.isActionPausedForSeedSnipe() then return false end
	if not PLANT_INDEPENDENT and (stealActive or seedSnipeActive or gearPlacingActive) then
		return false
	end
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not (char and hum and hum.Health > 0) then return false end
	if LocalPlayer:GetAttribute("LoadingScreenActive") then return false end
	if LocalPlayer:GetAttribute("IsStealingFruit") or LocalPlayer:GetAttribute("CarryingStolenFruit") then
		return false
	end
	return true
end

SNH.needsPlantCapMaintenance = function(plot)
	if not SNH.canRunPlantWorker() or not plot then return false end
	if SNH.getRemainingPlantSlots(plot, true) > 0 then return false end
	if AUTO_EXPAND and not SNH.isMaxExpansionReached() then return true end
	if SNH.shouldBuyPetSlots() and AUTO_BUY_PET_SLOT then return true end
	if AUTO_PLANT_UPGRADE then
		if SNH.canUpgradePlantAtCap(plot) then return true end
		if SNH.needsUpgradeSeedBuy(plot) and SNH.canBuyUpgradeSeedNow(plot) then return true end
	end
	return false
end

SNH.considerUpgradeSeedOption = function(best, seedName)
	if SNH.isMutationShopSeed(seedName) then return best end
	if SNH.isSeedReservedForMail(seedName) then return best end
	if SNH.isSingleHarvestSeed(seedName) then return best end
	local price = SNH.getSeedPrice(seedName) or 0
	if price <= 0 then return best end
	if not best or price > best.price
		or (price == best.price and seedName > best.seedName) then
		return { seedName = seedName, price = price }
	end
	return best
end

SNH.resolveBestUpgradeCandidate = function(plot)
	if not plot then return nil, nil end
	local best
	for _, entry in SNH.getSeedTools() do
		best = SNH.considerUpgradeSeedOption(best, entry.name)
	end
	if AUTO_BUY_SEED and next(BuySeedsConfig) then
		for _, entry in SNH.getSortedBuyList(BuySeedsConfig, SNH.getSeedPrice) do
			if SNH.getMailSeedBuyTarget(entry.name) > 0 then
				best = SNH.considerUpgradeSeedOption(best, entry.name)
			end
		end
	end
	if not best then return nil, nil end
	local target = SNH.getRemovableUpgradeTarget(plot, best.price)
	if not target or best.price <= target.price then return nil, nil end
	best.tool = SNH.findSeedTool(best.seedName)
	return best, target
end

SNH.hasPendingUpgradeWork = function(plot)
	if not plot or not AUTO_PLANT_UPGRADE then return false end
	local best, lowest = SNH.resolveBestUpgradeCandidate(plot)
	return best ~= nil and lowest ~= nil and best.price > lowest.price
end

SNH.needsUpgradeSeedBuy = function(plot)
	if not plot or not AUTO_PLANT_UPGRADE then return false end
	local best, lowest = SNH.resolveBestUpgradeCandidate(plot)
	if not best or not lowest or best.price <= lowest.price then return false end
	return not best.tool
end

SNH.canBuyUpgradeSeedNow = function(plot)
	if not AUTO_BUY_SEED or not Networking or not Networking.SeedShop then return false end
	local best = select(1, SNH.resolveBestUpgradeCandidate(plot))
	if not best or best.tool then return false end
	local seedName = best.seedName
	if SNH.isShopItemBlocked(seedName) then return false end
	if not SNH.shopItemExists("SeedShop", seedName) then return false end
	local price = SNH.getSeedPrice(seedName) or 0
	if price <= 0 or price >= MAX_SEED_BUY_PRICE then return false end
	if API.getSheckles() < price then return false end
	local remaining = select(1, SNH.getShopStockBreakdown(
		seedName, "SeedShop", { "SeedShop", "Seeds" }))
	return remaining > 0
end

SNH.canUpgradePlantAtCap = function(plot)
	if not plot or not AUTO_PLANT_UPGRADE then return false end
	local bestSeed, lowest = SNH.resolveBestUpgradeCandidate(plot)
	return bestSeed ~= nil and bestSeed.tool ~= nil
		and lowest ~= nil and bestSeed.price > lowest.price
end

SNH.gatherOwnedGardenPlants = function(plot)
	local results = {}
	local folder = plot and plot:FindFirstChild("Plants")
	if not folder then return results end
	local uid = LocalPlayer.UserId
	for _, child in folder:GetChildren() do
		if not child:IsA("Model") then continue end
		if not child:GetAttribute("PlantId") then continue end
		if tonumber(child:GetAttribute("UserId")) ~= uid then continue end
		local seedName = child:GetAttribute("SeedName") or child:GetAttribute("CorePartName")
		if not seedName or seedName == "" then continue end
		local plantId, fruitId = SNH.resolveHarvestIds(child)
		if not plantId then continue end
		table.insert(results, {
			model = child,
			seedName = seedName,
			plantId = plantId,
			fruitId = fruitId,
			price = SNH.getSeedPrice(seedName) or 0,
			position = child:GetPivot().Position,
		})
	end
	return results
end

SNH.countGardenPlantsBySeed = function(plot)
	local counts = {}
	for _, plant in SNH.gatherOwnedGardenPlants(plot) do
		counts[plant.seedName] = (counts[plant.seedName] or 0) + 1
	end
	return counts
end

-- Pick lowest-price plant type with 2+ copies; if only 1 of lowest type, try 2nd lowest, etc.
SNH.getRemovableUpgradeTarget = function(plot, maxRemovePrice)
	local plants = SNH.gatherOwnedGardenPlants(plot)
	if #plants == 0 then return nil end
	maxRemovePrice = tonumber(maxRemovePrice) or math.huge

	local counts = SNH.countGardenPlantsBySeed(plot)
	local types = {}
	for seedName, count in counts do
		local price = SNH.getSeedPrice(seedName) or 0
		if price < maxRemovePrice and count > 1 then
			table.insert(types, { seedName = seedName, price = price, count = count })
		end
	end
	table.sort(types, function(a, b)
		if a.price ~= b.price then return a.price < b.price end
		return a.seedName < b.seedName
	end)

	for _, info in types do
		for _, plant in plants do
			if plant.seedName == info.seedName then
				return plant
			end
		end
	end
	return nil
end

SNH.findShovelTool = function()
	for _, bag in { LocalPlayer.Backpack, LocalPlayer.Character } do
		if not bag then continue end
		for _, item in bag:GetChildren() do
			if item:IsA("Tool") and item:GetAttribute("Shovel") then
				return item
			end
		end
	end
	return nil
end

SNH.fireShovelRemove = function(plantId, fruitId, shovelTool)
	if not plantId or not shovelTool then return false end
	if not Networking then Networking = API.getNetworking() end
	if not Networking or not Networking.Shovel or not Networking.Shovel.UseShovel then return false end
	local shovelType = shovelTool:GetAttribute("Shovel")
	if not shovelType then return false end
	local ok = pcall(function()
		Networking.Shovel.UseShovel:Fire(
			tostring(plantId),
			tostring(fruitId or ""),
			shovelType,
			shovelTool
		)
	end)
	return ok
end

SNH.waitForPlantRemoved = function(plot, plantId, timeout)
	timeout = tonumber(timeout) or 4
	local deadline = os.clock() + timeout
	while os.clock() < deadline do
		local folder = plot and plot:FindFirstChild("Plants")
		local stillThere = false
		if folder then
			for _, inst in folder:GetDescendants() do
				if tostring(inst:GetAttribute("PlantId") or "") == tostring(plantId) then
					stillThere = true
					break
				end
			end
		end
		if not stillThere then return true end
		task.wait(0.1)
	end
	return false
end

SNH.runSinglePlantUpgrade = function(plot, bestSeed, lowest, shovel)
	if not plot or not bestSeed or not lowest or not shovel then return false end
	local equipWait = tonumber(PLANT_UPGRADE_EQUIP_WAIT) or 0.05
	local removeWait = tonumber(PLANT_UPGRADE_REMOVE_WAIT) or 0.08
	local verifyTimeout = tonumber(PLANT_UPGRADE_VERIFY_TIMEOUT) or 2.5

	local pos = lowest.position
	local plantId = lowest.plantId
	local fruitId = lowest.fruitId

	local equippedShovel = SNH.equipSeedToolFast(shovel)
	if not equippedShovel then error("equip shovel failed") end
	task.wait(equipWait)

	if not SNH.fireShovelRemove(plantId, fruitId, equippedShovel) then
		error("UseShovel remote failed")
	end
	task.wait(removeWait)
	SNH.waitForPlantRemoved(plot, plantId, verifyTimeout)
	task.wait(equipWait)

	local seedTool = SNH.findSeedTool(bestSeed.seedName)
	if not seedTool or not seedTool.Parent then
		error("upgrade seed tool missing: " .. tostring(bestSeed.seedName))
	end

	local equippedSeed = SNH.equipSeedToolFast(seedTool)
	if not equippedSeed then error("equip seed failed") end
	task.wait(equipWait)

	if SNH.snapToPlantArea then
		pos = SNH.snapToPlantArea(plot, pos) or pos
	end
	if not SNH.firePlantRemote(pos, bestSeed.seedName, equippedSeed) then
		error("plant remote failed")
	end

	SNH.invalidatePlotScanCaches(plot)
	print(("[So Nach Hup] Plant upgrade: %s (%s) -> %s (%s) | garden %d/%d"):format(
		lowest.seedName, SNH.formatAbbrev(lowest.price),
		bestSeed.seedName, SNH.formatAbbrev(bestSeed.price),
		SNH.countPlants(plot), SNH.getPlantCapLimit()))
	SNH.setStatus(("Upgraded %s -> %s"):format(lowest.seedName, bestSeed.seedName))
	return true
end

SNH.tryUpgradeGardenPlant = function(force)
	if not AUTO_PLANT_UPGRADE or not ENABLED or not AUTO_PLANT then return false end
	if plantUpgradeActive and not force then return false end
	if not force and tick() - lastPlantUpgradeAt < (PLANT_UPGRADE_GAP or 0.35) then return false end
	if not SNH.canRunPlantWorker() then return false end

	local _, plot = API.getLocalPlot()
	if not plot or not SNH.isPlantCapReached(plot, true) then return false end
	if not SNH.hasPendingUpgradeWork(plot) then return false end

	local shovel = SNH.findShovelTool()
	if not shovel then
		print("[So Nach Hup] Plant upgrade: need shovel in backpack")
		return false
	end

	plantUpgradeActive = true
	local upgraded = 0
	local burstLimit = math.max(1, tonumber(PLANT_UPGRADE_BURST) or 12)
	local burstGap = tonumber(PLANT_UPGRADE_BURST_GAP) or 0.06
	local ok, err = pcall(function()
		SNH.ensureInsideOwnPlotForPlanting()
		task.wait(0.05)

		if SNH.needsUpgradeSeedBuy(plot) then
			SNH.tryBuyUpgradeSeed(plot)
		end

		for _ = 1, burstLimit do
			local bestSeed, lowest = SNH.resolveBestUpgradeCandidate(plot)
			if not bestSeed or not lowest or bestSeed.price <= lowest.price then break end
			if not bestSeed.tool then
				if SNH.tryBuyUpgradeSeed(plot) > 0 then
					bestSeed.tool = SNH.findSeedTool(bestSeed.seedName)
				end
				if not bestSeed.tool then break end
			end
			if SNH.runSinglePlantUpgrade(plot, bestSeed, lowest, shovel) then
				upgraded += 1
			else
				break
			end
			if upgraded < burstLimit and SNH.canUpgradePlantAtCap(plot) then
				task.wait(burstGap)
			end
		end
	end)

	plantUpgradeActive = false
	lastPlantUpgradeAt = tick()
	if not ok then
		print(("[So Nach Hup] Plant upgrade failed: %s"):format(tostring(err)))
	end
	return ok and upgraded > 0
end

SNH.debugPlantStatus = function(plot)
	if not AUTO_PLANT then return "AUTO_PLANT=false" end
	if not API.ready then return "API not ready" end
	if not SNH.canRunPlantWorker() then return "plant worker blocked (stealing/loading/dead?)" end
	if not plot then return "no plot" end
	local status = SNH.getPlantSlotStatus(plot, true)
	if status.atCap then
		local best, target = SNH.resolveBestUpgradeCandidate(plot)
		if AUTO_PLANT_UPGRADE and best and target then
			if best.tool then
				return ("cap %d/%d (exp %d) upgrade: %s -> %s"):format(
					status.count, status.cap, status.expansions,
					target.seedName, best.seedName)
			end
			return ("cap %d/%d (exp %d) upgrade waiting for %s (remove %s)"):format(
				status.count, status.cap, status.expansions,
				best.seedName, target.seedName)
		end
		if SNH.isSavingForPetSlots() then
			return ("cap %d/%d (exp %d) buying pet slots %d/%d"):format(
				status.count, status.cap, status.expansions,
				SNH.getMaxPetSlots(), SNH.getAbsoluteMaxPetSlots())
		end
		return ("cap %d/%d (exp %d) — idle, no empty slots"):format(
			status.count, status.cap, status.expansions)
	end
	local tools = SNH.getSeedTools()
	if #tools == 0 then return ("slots %d/%d — no seed tools in backpack"):format(status.count, status.cap) end
	local work = SNH.buildPlantWorkQueue(plot)
	if #work == 0 then
		return ("slots %d/%d room=%d — nothing to fill (no seeds or all reserved)"):format(
			status.count, status.cap, status.room)
	end
	return ("slots %d/%d room=%d — fill %d seed type(s)"):format(
		status.count, status.cap, status.room, #work)
end

SNH.getSeedToolName = function(tool)
	if not tool or not tool:IsA("Tool") then return nil end
	local seedName = tool:GetAttribute("SeedTool")
	if type(seedName) == "string" and seedName ~= "" then return seedName end
	if tool:GetAttribute("RainbowSeed") == true then return "Rainbow" end
	if tool:GetAttribute("GoldSeed") == true then return "Gold" end
	return nil
end

SNH.getSeedTools = function()
	local tools = {}
	for _, bag in { LocalPlayer.Backpack, LocalPlayer.Character } do
		if not bag then continue end
		for _, item in bag:GetChildren() do
			if not item:IsA("Tool") then continue end
			local name = SNH.getSeedToolName(item)
			if name then
				table.insert(tools, { name = name, tool = item })
			end
		end
	end
	return tools
end
end

do --[[ SNH: HarvestBurst ]]
SNH.runHarvestBurstOnce = function()
	if not AUTO_COLLECT then return 0 end
	if SNH.isHarvestBlocked() then return 0 end
	if COLLECT_MUTATION_SEEDS ~= false and AUTO_SNIPE_MUTATION_SEEDS and SNH.tryAutoCollectMutationSpawns then
		pcall(SNH.tryAutoCollectMutationSpawns)
	end
	if SNH.isActionPausedForSeedSnipe() then return 0 end
	local _, plot = API.getLocalPlot()
	if not plot then return 0 end
	if SNH.shouldStayInOwnGardenAtDay() and not SNH.isAwayForGardenStay() then
		if not SNH.ensureInsideOwnGardenAtDay() then return 0 end
	end
	if not SNH.ensureReadyToHarvest(plot) then return 0 end

	SNH.maintainLocalHarvestPrompts()
	local uid = LocalPlayer.UserId
	local room = SNH.getHarvestBackpackRoom(true)
	if room <= 0 then return 0 end

	fruitCountCache.time = 0
	local startCount = SNH.countFruitInInventory()
	local targets = SNH.gatherReadyHarvestTargets(plot, uid)
	if #targets == 0 then return 0 end
	if COLLECT_SORT_BY_VALUE then
		SNH.sortHarvestTargetsByValue(targets)
	end

	local batchCap = tonumber(COLLECT_BATCH_SIZE) or 0
	local batchLimit = batchCap > 0 and math.min(room, batchCap, #targets) or math.min(room, #targets)
	local gained = 0
	local topCollected = targets[1]

	for i = 1, batchLimit do
		local target = targets[i]
		if not target then break end
		local prompt = target.prompt
		if not prompt and target.plantId then
			prompt = SNH.findHarvestPromptForTarget(plot, target.plantId, target.fruitId)
		end
		if prompt and SNH.collectHarvestPrompt(prompt) then
			gained += 1
			topCollected = target
		end
		if SNH.getHarvestBackpackRoom(true) <= 0 then break end
		if i < batchLimit then
			task.wait()
		end
	end

	fruitCountCache.time = 0
	gained = math.max(gained, math.max(0, SNH.countFruitInInventory() - startCount))
	hudStatsCache.time = 0
	plantCountCache.time = 0

	if gained > 0 then
		harvestFailStreak = 0
		lastHarvestAt = tick()
		SNH.setStatus(("Harvested %d | top %s (%s)"):format(
			gained,
			topCollected and topCollected.seedName or "?",
			SNH.formatAbbrev(topCollected and topCollected.value or 0)))
	else
		harvestFailStreak = (harvestFailStreak or 0) + 1
		local topTarget = targets[1]
		SNH.setStatus(("Harvest retry | %s (%s)"):format(
			topTarget.seedName or "?",
			SNH.formatAbbrev(topTarget.value or 0)))
	end
	return gained
end

SNH.runHarvestBurst = function()
	local drainLoops = math.max(1, math.floor(tonumber(COLLECT_DRAIN_LOOPS) or 4))
	local totalGained = 0
	for loop = 1, drainLoops do
		local gained = SNH.runHarvestBurstOnce()
		totalGained += gained
		if gained <= 0 then break end
		if SNH.getHarvestBackpackRoom(true) <= 0 then break end
		if loop < drainLoops then
			task.wait()
		end
	end
	return totalGained
end

SNH.burstHarvestAll = function(force)
	if not AUTO_COLLECT then return 0 end
	local now = tick()
	if not force and now - lastCollectAt < COLLECT_GAP then return 0 end
	local gained = SNH.runHarvestBurst()
	if gained > 0 or force then
		lastCollectAt = now
	end
	return gained
end

SNH.tickHarvestLoop = function()
	if harvestWorkerRunning or not AUTO_COLLECT then return end
	if SNH.isHarvestBlocked() then return end
	if SNH.isActionPausedForSeedSnipe() then return end
	local now = tick()
	if now - lastCollectAt < COLLECT_GAP then return end
	harvestWorkerRunning = true
	task.spawn(function()
		pcall(function()
			if AUTO_COLLECT and not SNH.isHarvestBlocked() then
				local gained = SNH.runHarvestBurst()
				if gained >= 0 then
					lastCollectAt = tick()
				end
			end
		end)
		harvestWorkerRunning = false
	end)
end
end
burstHarvestAll = SNH.burstHarvestAll
setupInstantPromptHooks = SNH.setupInstantPromptHooks
randomPlantPos = SNH.getRandomPlantPosition
getSeedTools = SNH.getSeedTools

do --[[ SNH: StealTargets ]]
SNH.isHazardPlantModel = function(model)
	if not model then return false end
	local seedName = model:GetAttribute("SeedName") or model:GetAttribute("CorePartName")
	if seedName and HazardSeeds[seedName] then return true end
	for _, tag in HAZARD_CONTROLLER_TAGS do
		if CollectionService:HasTag(model, tag) then return true end
	end
	for _, inst in model:GetDescendants() do
		if inst:GetAttribute("Prickle") == true then return true end
		for _, tag in HAZARD_CONTROLLER_TAGS do
			if CollectionService:HasTag(inst, tag) then return true end
		end
	end
	return false
end

SNH.isHazardStealTarget = function(target)
	if not target then return false end
	local seedName = target.seedName
	if seedName and HazardSeeds[seedName] then return true end
	local model = target.model
	if not model then return false end
	local plant = model
	while plant and not plant:GetAttribute("PlantId") do
		plant = plant.Parent
		if plant and not plant:IsA("Model") then plant = nil end
	end
	return SNH.isHazardPlantModel(plant or model)
end

SNH.getStealSeedName = function(model)
	return SNH.getStealSeedNameFromModel and SNH.getStealSeedNameFromModel(model)
		or (model and (model:GetAttribute("SeedName") or model:GetAttribute("CorePartName")))
end

SNH.getStealSeedNameFromModel = function(model)
	if not model then return nil end
	local name = model:GetAttribute("SeedName") or model:GetAttribute("CorePartName")
	if name and name ~= "" then return name end
	local cur = model.Parent
	while cur and cur ~= workspace do
		if cur:IsA("Model") then
			name = cur:GetAttribute("SeedName") or cur:GetAttribute("CorePartName")
			if name and name ~= "" then return name end
		end
		cur = cur.Parent
	end
	return nil
end

SNH.resolveStealOwnerUserId = function(model, fallbackUserId)
	local cur = model
	while cur and cur ~= workspace do
		local uid = tonumber(cur:GetAttribute("UserId"))
		if uid then return uid end
		cur = cur.Parent
	end
	return tonumber(fallbackUserId)
end

SNH.resolveStealIds = function(model)
	if not model then return nil, nil end
	local plantId = model:GetAttribute("PlantId")
	local fruitId = model:GetAttribute("FruitId")
	if plantId then
		if not fruitId then
			for _, desc in model:GetDescendants() do
				if not desc:IsA("Model") then continue end
				local fid = desc:GetAttribute("FruitId")
				if not fid then continue end
				local prompt = SNH.findStealPrompt(desc)
				if prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled and not prompt:GetAttribute("Collected") then
					fruitId = fid
					break
				end
			end
		end
		return plantId, fruitId
	end
	local cur = model.Parent
	while cur and cur ~= workspace do
		if cur:IsA("Model") then
			local pid = cur:GetAttribute("PlantId")
			if pid then
				return pid, fruitId or model:GetAttribute("FruitId")
			end
		end
		cur = cur.Parent
	end
	return nil, fruitId
end

SNH.getStealTargetValue = function(model)
	if not model then return 0 end
	local _, value = SNH.getBestHarvestValueModel(model)
	if value > 0 then return value end
	local seedName = SNH.getStealSeedNameFromModel(model)
	if seedName then return API.getSellValue(seedName) end
	return 0
end

SNH.getGardenBestTreeValue = function(gardenOrTargets)
	local targets = type(gardenOrTargets) == "table" and (gardenOrTargets.targets or gardenOrTargets) or {}
	local byPlant = {}
	for _, target in targets do
		if not target.plantId then continue end
		local pid = tostring(target.plantId)
		byPlant[pid] = math.max(byPlant[pid] or 0, tonumber(target.value) or 0)
	end
	local best = 0
	for _, value in byPlant do
		best = math.max(best, value)
	end
	return best
end

SNH.getGardenBestTreeInfo = function(targets)
	local byPlant = {}
	for _, target in targets do
		if not target.plantId then continue end
		local pid = tostring(target.plantId)
		local entry = byPlant[pid]
		if not entry or (target.value or 0) > entry.value then
			byPlant[pid] = {
				value = target.value or 0,
				seedName = target.seedName,
				plantId = target.plantId,
				target = target,
			}
		end
	end
	local best
	for _, entry in byPlant do
		if not best or entry.value > best.value then best = entry end
	end
	return best
end

SNH.findStealPrompt = function(model)
	if not model then return nil end
	local prompt = model:FindFirstChild("StealPrompt", true)
	if prompt and prompt:IsA("ProximityPrompt") then return prompt end
	for _, inst in model:GetDescendants() do
		if inst:IsA("ProximityPrompt") and CollectionService:HasTag(inst, "StealPrompt") then
			return inst
		end
	end
	return nil
end

SNH.boostStealPrompt = function(prompt)
	if not prompt or not SNH.isStealPrompt(prompt) then return end
	SNH.boostPromptRange(prompt, STEAL_PROMPT_RANGE)
	prompt.Enabled = true
	if STEAL_ZERO_HOLD ~= false then
		prompt.HoldDuration = 0
		prompt.RequiresLineOfSight = false
	end
end

SNH.getStealHoldDuration = function(target)
	if not target then return 0 end
	local seedName = target.seedName or SNH.getStealSeedNameFromModel(target.model)
	if seedName and G.StealFlags and G.StealFlags.GetStealHoldDuration then
		local ok, hold = pcall(function()
			return G.StealFlags.GetStealHoldDuration(seedName)
		end)
		if ok and tonumber(hold) and hold > 0 then
			return tonumber(hold)
		end
	end
	local model = target.model
	if model and G.CalculateStealDuration and G.CalculateStealDuration.CalculateStealDuration then
		local size = tonumber(model:GetAttribute("SizeMultiplier")) or 1
		local mutation = model:GetAttribute("Mutation")
		local ok, hold = pcall(function()
			return G.CalculateStealDuration:CalculateStealDuration(seedName, size, mutation)
		end)
		if ok and tonumber(hold) and hold > 0 then
			return tonumber(hold)
		end
	end
	return 0
end

SNH.zeroStealPromptsOnModel = function(model)
	if not model then return end
	for _, inst in model:GetDescendants() do
		if inst:IsA("ProximityPrompt") and SNH.isStealPrompt(inst) then
			SNH.boostStealPrompt(inst)
		end
	end
end

SNH.gatherStealTargets = function(plot, ownerUserId)
	local targets, seen = {}, {}
	if not plot or not ownerUserId then return targets end

	local function tryAdd(model, prompt)
		if not model or not model:IsA("Model") then return end
		local plantId, fruitId = SNH.resolveStealIds(model)
		if not plantId then return end
		if SNH.resolveStealOwnerUserId(model, ownerUserId) ~= ownerUserId then return end
		local key = tostring(plantId) .. "|" .. tostring(fruitId or "")
		if seen[key] then return end
		local seedName = SNH.getStealSeedNameFromModel(model)
		if not API.isPlantStealable(seedName) then return end
		prompt = prompt or SNH.findStealPrompt(model)
		if prompt and (not prompt.Enabled or prompt:GetAttribute("Collected")) then return end
		seen[key] = true
		table.insert(targets, {
			plantId = plantId,
			fruitId = fruitId,
			seedName = seedName,
			model = model,
			prompt = prompt,
			value = SNH.getStealTargetValue(model),
			ownerPlot = plot,
			ownerUserId = ownerUserId,
		})
	end

	for _, inst in plot:GetDescendants() do
		if not inst:IsA("ProximityPrompt") or not SNH.isStealPrompt(inst) then continue end
		if not inst.Enabled or inst:GetAttribute("Collected") then continue end
		local model = SNH.getModelFromPrompt(inst)
		if model then tryAdd(model, inst) end
	end

	for _, inst in plot:GetDescendants() do
		if not inst:IsA("Model") or not inst:GetAttribute("PlantId") then continue end
		tryAdd(inst, nil)
	end

	table.sort(targets, function(a, b) return a.value > b.value end)
	return targets
end

SNH.getStealableGardens = function()
	if not API.canStealNow() then return {} end
	if not STEAL_SCAN_GARDENS then return {} end
	local now = tick()
	if now - stealGardensCache.time < 0.6 then
		return stealGardensCache.data
	end
	local gardens, seenPlots = {}, {}
	local function tryAddPlot(owner, ownerUserId, plot)
		if not plot or not ownerUserId or seenPlots[plot] then return end
		if owner == LocalPlayer then return end
		if SNH.isOwnerGuardingGarden(owner, plot) then return end
		if owner and API.isGardenLockedForSteal(owner) then return end
		local targets = SNH.gatherStealTargets(plot, ownerUserId)
		if #targets == 0 then return end
		seenPlots[plot] = true
		table.insert(gardens, {
			player = owner,
			plot = plot,
			ownerUserId = ownerUserId,
			targets = targets,
		})
	end
	for _, player in Players:GetPlayers() do
		if player == LocalPlayer then continue end
		local plotId = player:GetAttribute("PlotId")
		tryAddPlot(player, player.UserId, plotId and API.getPlot(plotId))
	end
	for _, plot in API.getAllPlots() do
		local owner, ownerUserId = API.getPlotOwner(plot)
		if not ownerUserId then
			ownerUserId = tonumber(plot:GetAttribute("OwnerUserId"))
		end
		tryAddPlot(owner, ownerUserId, plot)
	end
	table.sort(gardens, function(a, b)
		local aTree = SNH.getGardenBestTreeValue(a)
		local bTree = SNH.getGardenBestTreeValue(b)
		if aTree ~= bTree then return aTree > bTree end
		local aTop = a.targets[1] and a.targets[1].value or 0
		local bTop = b.targets[1] and b.targets[1].value or 0
		if aTop ~= bTop then return aTop > bTop end
		return #a.targets > #b.targets
	end)
	stealGardensCache.time = now
	stealGardensCache.data = gardens
	return gardens
end

SNH.stealKey = function(target)
	return tostring(target.plantId) .. "|" .. tostring(target.fruitId or "")
end

SNH.fruitStillThere = function(target)
	if not target then return false end
	if target.model and not target.model.Parent then return false end
	local prompt = target.prompt or (target.model and SNH.findStealPrompt(target.model))
	if prompt and (not prompt.Parent or not prompt.Enabled) then return false end
	return true
end
end

do --[[ SNH: StealFloat ]]
SNH.stabilizeFloatRoot = function(root, hum, anchorPos)
	if not (root and hum) then return end
	pcall(function() hum.PlatformStand = true end)
	pcall(function() hum.AutoRotate = false end)
	pcall(function() hum:ChangeState(Enum.HumanoidStateType.Physics) end)
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	if anchorPos then
		stealFloatAnchor = anchorPos
		root.CFrame = CFrame.new(anchorPos)
	end
end

SNH.setStealFloat = function(enabled, anchorPos)
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not (hum and root) then return end
	if enabled then
		if not stealFloating then
			stealFloating = true
			if not gearPlacingActive then
				pcall(function() hum:UnequipTools() end)
			end
		end
		SNH.stabilizeFloatRoot(root, hum, anchorPos or stealFloatAnchor or root.Position)
		if stealFloatConn then stealFloatConn:Disconnect() end
		stealFloatConn = RunService.Heartbeat:Connect(function()
			if not stealFloating or stealFloatMoving then return end
			local c = LocalPlayer.Character
			local r = c and c:FindFirstChild("HumanoidRootPart")
			local h = c and c:FindFirstChildOfClass("Humanoid")
			if not (r and h) then return end
			SNH.stabilizeFloatRoot(r, h, stealFloatAnchor)
		end)
	else
		stealFloating = false
		stealFloatAnchor = nil
		if stealFloatConn then
			stealFloatConn:Disconnect()
			stealFloatConn = nil
		end
		pcall(function() hum.PlatformStand = false end)
		pcall(function() hum.AutoRotate = true end)
		pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
	end
end

SNH.floatTeleportTo = function(position, floatHeight)
	local goal = typeof(position) == "Vector3" and position or position.Position
	local lift = tonumber(floatHeight) or STEAL_FLOAT_HEIGHT
	goal = goal + Vector3.new(0, lift, 0)
	local root, hum = SNH.getTeleportRoot()
	if not root then return false end

	stealFloatMoving = true
	SNH.setStealFloat(true, root.Position)
	local ok
	if STEAL_USE_SHORT_HOP then
		ok = SNH.shortHopTo(goal, 0)
	else
		ok = SNH.fastStealTweenTo(goal, 0)
	end
	stealFloatMoving = false
	if ok then
		stealFloatAnchor = goal
		SNH.stabilizeFloatRoot(root, hum, goal)
	end
	return ok or SNH.isNearPosition(goal, TP_ARRIVE_RADIUS + 6)
end
end

do --[[ SNH: SeedSnipeTouch ]]
-- g2 SpawnSeedPackController: RainbowSeed / GoldSeed attrs first, then SeedPack string.
SNH.getMutationSpawnTarget = function(part)
	if not part then return nil, nil end
	if part:GetAttribute("RainbowSeed") == true then return "Rainbow", "Rainbow Seed" end
	if part:GetAttribute("GoldSeed") == true then return "Gold", "Gold Seed" end
	local seedPack = part:GetAttribute("SeedPack")
	if type(seedPack) == "string" and seedPack ~= "" then
		return "SeedPack", seedPack
	end
	return nil, nil
end

SNH.countInventorySeedTools = function(seedName)
	if SNH.countMutationSeedInInventory and SNH.resolveMutationSeedKey(seedName) then
		return SNH.countMutationSeedInInventory(seedName)
	end
	local count = 0
	for _, bag in { LocalPlayer.Character, LocalPlayer.Backpack } do
		if not bag then continue end
		for _, item in bag:GetChildren() do
			if item:IsA("Tool") and SNH.getSeedToolName(item) == seedName then
				count += math.max(1, math.floor(tonumber(item:GetAttribute("Count")) or 1))
			end
		end
	end
	return count
end

SNH.countInventorySeedPacks = function(packName)
	local count = 0
	for _, bag in { LocalPlayer.Character, LocalPlayer.Backpack } do
		if not bag then continue end
		for _, item in bag:GetChildren() do
			if not item:IsA("Tool") then continue end
			local attr = item:GetAttribute("SeedPack")
			if type(attr) ~= "string" or attr == "" then continue end
			if not packName or attr == packName then
				count += 1
			end
		end
	end
	return count
end

-- g2 SeedPackHandleController: tool:GetAttribute("SeedPack") -> OpenSeedPack:Fire(packName)
SNH.listInventorySeedPackTools = function()
	local list, seen = {}, {}
	for _, bag in { LocalPlayer.Backpack, LocalPlayer.Character } do
		if not bag then continue end
		for _, item in bag:GetChildren() do
			if not item:IsA("Tool") then continue end
			local packName = item:GetAttribute("SeedPack")
			if type(packName) ~= "string" or packName == "" then continue end
			if seen[item] then continue end
			seen[item] = true
			table.insert(list, { tool = item, packName = packName })
		end
	end
	return list
end

SNH.openSeedPackOnce = function(packName)
	if type(packName) ~= "string" or packName == "" then return false end
	if not Networking then Networking = API.getNetworking() end
	local remote = Networking and Networking.SeedPack and Networking.SeedPack.OpenSeedPack
	if not remote then return false end
	local ok, result = pcall(function()
		return remote:Fire(packName)
	end)
	return ok and type(result) == "table" and result.Success == true
end

SNH.useAllInventorySeedPacks = function()
	if not AUTO_USE_SEED_PACKS or not ENABLED then return 0 end
	if SNH.isActionPausedForSeedSnipe() or seedSnipeActive then return 0 end
	local opened = 0
	for _, entry in SNH.listInventorySeedPackTools() do
		local tool, packName = entry.tool, entry.packName
		if not tool or not tool.Parent then continue end
		local failStreak = 0
		while tool.Parent and tool:GetAttribute("SeedPack") == packName do
			if SNH.isActionPausedForSeedSnipe() or seedSnipeActive then break end
			if SNH.openSeedPackOnce(packName) then
				opened += 1
				failStreak = 0
			else
				failStreak += 1
				if failStreak >= 2 then break end
			end
			task.wait(SEED_PACK_OPEN_GAP > 0 and SEED_PACK_OPEN_GAP or 0.2)
		end
	end
	return opened
end

SNH.snapshotSpawnInventory = function(kind, packName)
	return {
		gold = SNH.countInventorySeedTools("Gold"),
		rainbow = SNH.countInventorySeedTools("Rainbow"),
		pack = packName and SNH.countInventorySeedPacks(packName) or SNH.countInventorySeedPacks(),
	}
end

SNH.didGainSpawnReward = function(kind, packName, before)
	if not before then return false end
	if kind == "Gold" then
		return SNH.countInventorySeedTools("Gold") > (before.gold or 0)
	end
	if kind == "Rainbow" then
		return SNH.countInventorySeedTools("Rainbow") > (before.rainbow or 0)
	end
	if kind == "SeedPack" then
		return SNH.countInventorySeedPacks(packName) > (before.pack or 0)
	end
	return false
end

SNH.isSpawnClaimSuccess = function(part, kind, packName, before)
	if before and SNH.didGainSpawnReward(kind, packName, before) then return true end
	if not part or not part.Parent then return true end
	return false
end

SNH.hookSpawnClaimEvents = function()
	if spawnClaimHooked or not Networking or not Networking.SeedPackSpawn then return end
	spawnClaimHooked = true
	if Networking.SeedPackSpawn.Claimed then
		Networking.SeedPackSpawn.Claimed.OnClientEvent:Connect(function(claimerName, itemName)
			if tostring(claimerName) == LocalPlayer.Name then
				lastSpawnClaimSuccessAt = tick()
				print(("[So Nach Hup] Seed spawn claimed: %s"):format(tostring(itemName)))
			end
		end)
	end
end

SNH.getSpawnTouchPositions = function(part)
	if not part then return {} end
	local positions = {}
	local cf = part.CFrame
	local half = part.Size * 0.5
	table.insert(positions, cf.Position)
	table.insert(positions, (cf * CFrame.new(0, half.Y + 1.5, 0)).Position)
	table.insert(positions, (cf * CFrame.new(0, -half.Y + 1, 0)).Position)
	for _, flat in {
		Vector3.new(half.X, 0, 0), Vector3.new(-half.X, 0, 0),
		Vector3.new(0, 0, half.Z), Vector3.new(0, 0, -half.Z),
	} do
		table.insert(positions, (cf * CFrame.new(flat.X, 1, flat.Z)).Position)
	end
	return positions
end

SNH.touchSpawnAtPosition = function(root, charParts, touchParts, pos)
	if not root or not pos then return end
	if SEED_SNIPE_INSTANT_TP then
		root.CFrame = CFrame.new(pos)
	else
		local start = root.Position
		local steps = math.max(2, math.floor(SEED_SNIPE_TWEEN_STEPS or 2))
		for i = 1, steps do
			local alpha = i / steps
			root.CFrame = CFrame.new(start:Lerp(pos, alpha))
			if i < steps then task.wait(0.02) end
		end
	end
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	if firetouchinterest and #charParts > 0 and #touchParts > 0 then
		for _, cp in charParts do
			for _, tp in touchParts do
				pcall(function()
					firetouchinterest(cp, tp, 0)
					firetouchinterest(cp, tp, 1)
				end)
			end
		end
	end
end

SNH.zeroSpawnSeedPrompts = function(part)
	if not part then return end
	local function zeroPrompt(prompt)
		if not prompt or not prompt:IsA("ProximityPrompt") then return end
		prompt.HoldDuration = 0
		prompt.RequiresLineOfSight = false
		prompt.MaxActivationDistance = math.max(prompt.MaxActivationDistance, PROMPT_RANGE_MAX)
	end
	zeroPrompt(part:FindFirstChildOfClass("ProximityPrompt"))
	for _, inst in part:GetDescendants() do
		zeroPrompt(inst)
	end
	local map = workspace:FindFirstChild("Map")
	local clientFolder = map and map:FindFirstChild("SeedPackSpawnClient")
	if clientFolder then
		for _, inst in clientFolder:GetDescendants() do
			if inst:IsA("ProximityPrompt") and inst.Parent and inst.Parent:IsA("BasePart") then
				if (inst.Parent.Position - part.Position).Magnitude <= 48 then
					zeroPrompt(inst)
				end
			end
		end
	end
end

SNH.fastTweenTeleportTo = function(position, floatHeight)
	local goal = SNH.normalizeTeleportGoal(position)
	if not goal then return false end
	if floatHeight == nil then floatHeight = SEED_SNIPE_FLOAT or 2.5 end
	return SNH.shortHopTo(goal, floatHeight)
end

SNH.fastTeleportToSpawn = function(part)
	if not part or not part.Parent then return false end
	if SEED_SNIPE_INSTANT_TP then
		local character = LocalPlayer.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		local hum = character and character:FindFirstChildOfClass("Humanoid")
		if not (root and part) then return false end
		local pos = part.Position + Vector3.new(0, 2.5, 0)
		root.CFrame = CFrame.new(pos)
		if hum then
			pcall(function()
				hum.PlatformStand = false
				root.AssemblyLinearVelocity = Vector3.zero
				root.AssemblyAngularVelocity = Vector3.zero
			end)
		end
		return true
	end
	return SNH.fastTweenTeleportTo(part.Position, 2.5)
end

-- g2 SpawnSeedPackController u10: wait for RainbowSeed / GoldSeed / SeedPack attrs on spawn part.
SNH.waitForMutationSpawnAttributes = function(part, timeout)
	if not part then return nil end
	local deadline = tick() + (timeout or 3)
	while part.Parent and tick() < deadline do
		local pack = part:GetAttribute("SeedPack")
		local rainbow = part:GetAttribute("RainbowSeed") == true
		local gold = part:GetAttribute("GoldSeed") == true
		if rainbow or gold or (type(pack) == "string" and pack ~= "") then
			return SNH.getMutationSpawnTarget(part)
		end
		local waited = false
		pcall(function()
			part:GetAttributeChangedSignal("SeedPack"):Wait()
			waited = true
		end)
		if not waited then task.wait(0.02) end
	end
	return SNH.getMutationSpawnTarget(part)
end

SNH.getCharacterTouchParts = function(character)
	local parts = {}
	if not character then return parts end
	for _, inst in character:GetDescendants() do
		if inst:IsA("BasePart") then table.insert(parts, inst) end
	end
	return parts
end

SNH.getSpawnTouchParts = function(part)
	local touchParts = { part }
	for _, child in part:GetDescendants() do
		if child:IsA("BasePart") then table.insert(touchParts, child) end
	end
	local map = workspace:FindFirstChild("Map")
	local clientFolder = map and map:FindFirstChild("SeedPackSpawnClient")
	if clientFolder and part then
		for _, inst in clientFolder:GetDescendants() do
			if inst:IsA("BasePart") and (inst.Position - part.Position).Magnitude <= SEED_SNIPE_TOUCH_RADIUS + 6 then
				table.insert(touchParts, inst)
			end
		end
	end
	return touchParts
end

SNH.burstTouchInterest = function(charParts, touchParts, rounds)
	if not firetouchinterest then return false end
	for _ = 1, rounds do
		for _, cp in charParts do
			for _, tp in touchParts do
				pcall(function()
					firetouchinterest(cp, tp, 0)
					firetouchinterest(cp, tp, 1)
				end)
			end
		end
		if SEED_SNIPE_GAP > 0 then task.wait(SEED_SNIPE_GAP) end
	end
	return true
end

SNH.getSpawnTouchOffsets = function()
	local offsets = { Vector3.zero }
	local r = SEED_SNIPE_TOUCH_RADIUS
	if r <= 0 then return offsets end
	for _, flat in {
		Vector3.new(r, 0, 0), Vector3.new(-r, 0, 0), Vector3.new(0, 0, r), Vector3.new(0, 0, -r),
		Vector3.new(r, SEED_SNIPE_FLOAT, 0), Vector3.new(-r, SEED_SNIPE_FLOAT, 0),
		Vector3.new(0, SEED_SNIPE_FLOAT, r), Vector3.new(0, SEED_SNIPE_FLOAT, -r),
		Vector3.new(0, r, 0), Vector3.new(0, -r, 0),
	} do
		table.insert(offsets, flat)
	end
	return offsets
end

SNH.tryRemoteCollectSpawn = function(part)
	if part then SNH.zeroSpawnSeedPrompts(part) end
	local tried = false
	local function firePrompt(prompt)
		if not prompt or not prompt:IsA("ProximityPrompt") or not prompt.Enabled then return end
		tried = true
		prompt.HoldDuration = 0
		prompt.RequiresLineOfSight = false
		prompt.MaxActivationDistance = math.max(prompt.MaxActivationDistance, PROMPT_RANGE_MAX)
		for _ = 1, 3 do
			if typeof(fireproximityprompt) == "function" then
				pcall(fireproximityprompt, prompt, 0)
				pcall(fireproximityprompt, prompt, 1)
			else
				pcall(function()
					prompt:InputHoldBegin()
					prompt:InputHoldEnd()
				end)
			end
		end
	end
	if part and part:IsA("BasePart") then
		firePrompt(part:FindFirstChildOfClass("ProximityPrompt"))
	end
	for _, inst in part:GetDescendants() do
		if inst:IsA("ProximityPrompt") and inst.Enabled then
			firePrompt(inst)
		end
	end
	return tried
end

SNH.claimSpawnByServerTouch = function(part, kind, packName, before)
	if not part or not part.Parent then return true end
	local character = LocalPlayer.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then return false end

	SNH.hookSpawnClaimEvents()
	SNH.zeroSpawnSeedPrompts(part)
	local charParts = SNH.getCharacterTouchParts(character)
	local touchParts = SNH.getSpawnTouchParts(part)
	local positions = SNH.getSpawnTouchPositions(part)
	local rounds = math.max(8, tonumber(SEED_SNIPE_CLAIM_ROUNDS) or 40)
	local pause = math.max(0, tonumber(SEED_SNIPE_CLAIM_WAIT) or 0.08)

	for i = 1, rounds do
		if SNH.isSpawnClaimSuccess(part, kind, packName, before) then return true end
		if not part.Parent then return true end

		local pos = positions[((i - 1) % #positions) + 1]
		SNH.touchSpawnAtPosition(root, charParts, touchParts, pos)
		SNH.tryRemoteCollectSpawn(part)
		if firetouchinterest then
			SNH.burstTouchInterest(charParts, touchParts, 2)
		end
		if pause > 0 then task.wait(pause) end
	end

	return SNH.isSpawnClaimSuccess(part, kind, packName, before)
end
end

do --[[ SNH: SeedSnipeRun ]]
SNH.getPendingMutationSpawn = function()
	if not seedSpawnFolder or not AUTO_SNIPE_MUTATION_SEEDS then return nil end
	local wantKind = SNH.getMutationEventKind()
	local bestPart, bestKind, bestScore = nil, nil, -1
	for _, part in seedSpawnFolder:GetChildren() do
		if not part:IsA("BasePart") or claimedMutationSpawns[part] or not part.Parent then continue end
		local kind = SNH.getMutationSpawnTarget(part)
		if not kind or not SNH.shouldSnipeMutationKind(kind) then continue end
		local score = kind == "Rainbow" and 3 or (kind == "Gold" and 2 or 1)
		if wantKind and kind == wantKind then
			score += 10
		elseif wantKind and kind == "SeedPack" then
			score += 1
		end
		if score > bestScore then
			bestScore = score
			bestPart = part
			bestKind = kind
		end
	end
	return bestPart, bestKind
end

SNH.instantCollectMutationSpawn = function(part)
	if not part or not part.Parent then return false end
	local kind, packName = SNH.getMutationSpawnTarget(part)
	if not kind or not SNH.shouldSnipeMutationKind(kind) then return false end
	local character = LocalPlayer.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then return false end

	SNH.hookSpawnClaimEvents()
	SNH.zeroSpawnSeedPrompts(part)
	local before = SNH.snapshotSpawnInventory(kind, packName)
	local charParts = SNH.getCharacterTouchParts(character)
	local touchParts = SNH.getSpawnTouchParts(part)
	local burst = math.max(8, tonumber(SEED_SNIPE_LONG_RANGE_BURST) or 20)
	local rounds = math.max(3, tonumber(SEED_SNIPE_INSTANT_COLLECT_ROUNDS) or 6)
	local pause = math.max(0.03, tonumber(SEED_SNIPE_CLAIM_WAIT) or 0.05)

	SNH.fastTeleportToSpawn(part)
	SNH.tryRemoteCollectSpawn(part)
	SNH.burstTouchInterest(charParts, touchParts, burst)
	if SNH.isSpawnClaimSuccess(part, kind, packName, before) then return true end

	for i = 1, rounds do
		if SNH.isSpawnClaimSuccess(part, kind, packName, before) then return true end
		if not part.Parent then return true end
		local pos = part.Position + Vector3.new(0, 2.5, 0)
		SNH.touchSpawnAtPosition(root, charParts, touchParts, pos)
		SNH.tryRemoteCollectSpawn(part)
		SNH.burstTouchInterest(charParts, touchParts, 4)
		if pause > 0 then task.wait(pause) end
	end
	return SNH.isSpawnClaimSuccess(part, kind, packName, before)
end

SNH.longRangeCollectSpawn = function(part)
	return SNH.instantCollectMutationSpawn(part)
end

SNH.touchCollectSpawn = function(part, kind, packName)
	local character = LocalPlayer.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not (root and part and part.Parent) then return false end

	kind = kind or select(1, SNH.getMutationSpawnTarget(part))
	if not packName and kind == "SeedPack" then
		packName = select(2, SNH.getMutationSpawnTarget(part))
	end
	local before = SNH.snapshotSpawnInventory(kind, packName)

	SNH.hookSpawnClaimEvents()
	SNH.zeroSpawnSeedPrompts(part)
	SNH.fastTeleportToSpawn(part)
	task.wait(0.05)
	SNH.tryRemoteCollectSpawn(part)

	if SEED_SNIPE_LONG_RANGE_FIRST and SNH.longRangeCollectSpawn(part) then
		return SNH.isSpawnClaimSuccess(part, kind, packName, before)
	end

	local claimed = SNH.claimSpawnByServerTouch(part, kind, packName, before)
	if claimed then return true end

	local charParts = SNH.getCharacterTouchParts(character)
	local touchParts = SNH.getSpawnTouchParts(part)
	local rounds = math.max(8, math.floor(SEED_SNIPE_BURST / 4))

	for _ = 1, rounds do
		if SNH.isSpawnClaimSuccess(part, kind, packName, before) then return true end
		if not part.Parent then return true end
		if SEED_SNIPE_INSTANT_TP then
			SNH.fastTeleportToSpawn(part)
		else
			SNH.fastTweenTeleportTo(part.Position, SEED_SNIPE_FLOAT)
		end
		SNH.zeroSpawnSeedPrompts(part)
		SNH.tryRemoteCollectSpawn(part)
		if firetouchinterest then
			SNH.burstTouchInterest(charParts, touchParts, 2)
		else
			root.CFrame = CFrame.new(part.Position + Vector3.new(0, 2, 0))
		end
		if SEED_SNIPE_GAP > 0 then task.wait(SEED_SNIPE_GAP) end
	end

	return SNH.isSpawnClaimSuccess(part, kind, packName, before)
end

SNH.tryCollectMutationSpawn = function(part, opts)
	opts = opts or {}
	if not part or not part.Parent or claimedMutationSpawns[part] then return false end
	local kind, label = SNH.getMutationSpawnTarget(part)
	if not kind or not SNH.shouldSnipeMutationKind(kind) then return false end
	local viaCollect = opts.viaAutoCollect == true or COLLECT_MUTATION_SEEDS ~= false
	claimedMutationSpawns[part] = true
	if not viaCollect and SEED_SNIPE_PAUSE_ALL then
		seedSnipeActive = true
	end
	SNH.hookSpawnClaimEvents()
	SNH.zeroSpawnSeedPrompts(part)
	if viaCollect then
		SNH.setStatus(("Collect %s"):format(label))
	else
		SNH.setStatus(("Sniping %s"):format(label))
		print(("[So Nach Hup] PAUSE ALL -> racing %s spawn (server touch claim)"):format(label))
	end
	SNH.waitForMutationSpawnAttributes(part, 4)
	kind, label = SNH.getMutationSpawnTarget(part)
	if not kind then
		claimedMutationSpawns[part] = nil
		if not viaCollect then seedSnipeActive = false end
		return false
	end
	local packName = (kind == "SeedPack") and label or nil
	if viaCollect and SNH.fastStealTweenTo then
		SNH.fastStealTweenTo(part.Position + Vector3.new(0, SEED_SNIPE_FLOAT or 2.5, 0), 0)
	else
		SNH.fastTeleportToSpawn(part)
	end
	local claimed
	if viaCollect then
		claimed = SNH.instantCollectMutationSpawn(part)
		if not claimed then
			claimed = SNH.touchCollectSpawn(part, kind, packName)
		end
	else
		claimed = SNH.touchCollectSpawn(part, kind, packName)
	end
	if viaCollect then
		print(claimed and ("[So Nach Hup] Collected %s (auto collect)"):format(label)
			or ("[So Nach Hup] Failed to collect %s (auto collect)"):format(label))
	else
		print(claimed and ("[So Nach Hup] Collected %s"):format(label)
			or ("[So Nach Hup] Failed to collect %s"):format(label))
	end
	task.delay(1.5, function() claimedMutationSpawns[part] = nil end)
	pcall(function()
		part.Destroying:Once(function() claimedMutationSpawns[part] = nil end)
	end)
	if claimed then
		SNH.sendSeedWebhook(kind == "SeedPack" and (packName or kind) or kind, {
			source = kind == "SeedPack" and ("Seed Pack: " .. tostring(packName or label)) or "Mutation Spawn",
			amount = 1,
		})
		if viaCollect then
			local _, ownPlot = API.getLocalPlot()
			local homePos = ownPlot and SNH.getGardenInteriorPosition(ownPlot)
			if homePos and not SNH.getMutationEventKind() and SNH.fastStealTweenTo then
				SNH.fastStealTweenTo(homePos, 4)
			end
		elseif not SNH.getMutationEventKind() then
			local _, ownPlot = API.getLocalPlot()
			local homePos = ownPlot and SNH.getGardenInteriorPosition(ownPlot)
			if homePos then SNH.fastTweenTeleportTo(homePos, 4) end
		end
	end
	if not viaCollect and not SNH.isActionPausedForSeedSnipe() then
		seedSnipeActive = false
		print("[So Nach Hup] Seed snipe done — resuming normal actions")
	elseif viaCollect then
		seedSnipeActive = false
	end
	return claimed
end

SNH.tryAutoCollectMutationSpawns = function()
	if not AUTO_COLLECT or not AUTO_SNIPE_MUTATION_SEEDS or COLLECT_MUTATION_SEEDS == false then
		return false
	end
	if not seedSpawnFolder then
		local map = workspace:FindFirstChild("Map")
		seedSpawnFolder = map and map:FindFirstChild("SeedPackSpawnServerLocations")
	end
	if not seedSpawnFolder then return false end
	if SEED_SNIPE_RANGE_POKE and SNH.pokeLongRangeMutationSpawns and SNH.pokeLongRangeMutationSpawns() then
		return true
	end
	local part = SNH.getPendingMutationSpawn()
	if part then
		if SNH.instantCollectMutationSpawn(part) then return true end
		return SNH.tryCollectMutationSpawn(part, { viaAutoCollect = true })
	end
	for _, child in seedSpawnFolder:GetChildren() do
		if child:IsA("BasePart") and not claimedMutationSpawns[child] and child.Parent then
			local kind = SNH.getMutationSpawnTarget(child)
			if kind and SNH.shouldSnipeMutationKind(kind) then
				if SNH.instantCollectMutationSpawn(child) then return true end
				return SNH.tryCollectMutationSpawn(child, { viaAutoCollect = true })
			end
		end
	end
	return false
end

SNH.pokeLongRangeMutationSpawns = function()
	if not SEED_SNIPE_RANGE_POKE or not seedSpawnFolder or not AUTO_SNIPE_MUTATION_SEEDS then return false end
	for _, part in seedSpawnFolder:GetChildren() do
		if part:IsA("BasePart") and not claimedMutationSpawns[part] and part.Parent then
			local kind, label = SNH.getMutationSpawnTarget(part)
			if kind and SNH.shouldSnipeMutationKind(kind) and SNH.instantCollectMutationSpawn(part) then
				claimedMutationSpawns[part] = true
				print(("[So Nach Hup] Instant collected %s"):format(label))
				task.delay(1.5, function() claimedMutationSpawns[part] = nil end)
				pcall(function()
					part.Destroying:Once(function() claimedMutationSpawns[part] = nil end)
				end)
				return true
			end
		end
	end
	return false
end

SNH.scanMutationSpawns = function()
	if not AUTO_SNIPE_MUTATION_SEEDS or not seedSpawnFolder then return false end
	for _, part in seedSpawnFolder:GetChildren() do
		if part:IsA("BasePart") and not claimedMutationSpawns[part] then
			local kind, label = SNH.getMutationSpawnTarget(part)
			if kind and SNH.shouldSnipeMutationKind(kind) then
				if SNH.instantCollectMutationSpawn(part) then
					claimedMutationSpawns[part] = true
					print(("[So Nach Hup] Instant collected %s"):format(label))
					task.delay(1.5, function() claimedMutationSpawns[part] = nil end)
					pcall(function()
						part.Destroying:Once(function() claimedMutationSpawns[part] = nil end)
					end)
					return true
				end
				return SNH.tryCollectMutationSpawn(part)
			end
		end
	end
	return false
end

SNH.runSeedSnipePriority = function()
	if not ENABLED or not AUTO_SNIPE_MUTATION_SEEDS then
		if seedSnipeActive then seedSnipeActive = false end
		return false
	end
	if not SEED_SNIPE_PAUSE_ALL then
		if AUTO_COLLECT and COLLECT_MUTATION_SEEDS ~= false then
			return SNH.tryAutoCollectMutationSpawns()
		end
		return false
	end
	if not seedSpawnFolder then
		local map = workspace:FindFirstChild("Map")
		seedSpawnFolder = map and map:FindFirstChild("SeedPackSpawnServerLocations")
	end
	local eventKind = SNH.getMutationEventKind()
	local pendingPart, pendingKind = SNH.getPendingMutationSpawn()
	if eventKind or pendingPart then
		seedSnipeActive = true
		if pendingPart then
			SNH.setStatus(("Sniping seed spawn: %s"):format(tostring(pendingKind or eventKind or "SeedPack")))
			return SNH.scanMutationSpawns()
		end
		SNH.setStatus(("Seed event active — waiting for spawn (%s)"):format(tostring(eventKind)))
		return SNH.pokeLongRangeMutationSpawns()
	end
	if seedSnipeActive then
		seedSnipeActive = false
		print("[So Nach Hup] No seed spawns — resuming normal actions")
	end
	return false
end

SNH.setupMutationSeedWatcher = function()
	if mutationSeedHooked then return end
	mutationSeedHooked = true
	SNH.hookSpawnClaimEvents()
	local map = workspace:WaitForChild("Map", 30)
	seedSpawnFolder = map and map:WaitForChild("SeedPackSpawnServerLocations", 30)
	if not seedSpawnFolder then
		warn("[So Nach Hup] SeedPackSpawnServerLocations missing")
		return
	end
	SNH.trackConn(workspace:GetAttributeChangedSignal("ActiveWeather"):Connect(function()
		if AUTO_SNIPE_MUTATION_SEEDS and SNH.getMutationEventKind() then
			if SEED_SNIPE_PAUSE_ALL then
				seedSnipeActive = true
				print("[So Nach Hup] Rainbow/Gold moon or seed pack event — pause all, waiting for seeds")
			else
				print("[So Nach Hup] Mutation event — auto collect will pick up seeds")
			end
			task.defer(SNH.runSeedSnipePriority)
		end
	end), "mutation_watcher")
	SNH.trackConn(workspace:GetAttributeChangedSignal("ActivePhase"):Connect(function()
		if AUTO_SNIPE_MUTATION_SEEDS and SNH.getMutationEventKind() then
			if SEED_SNIPE_PAUSE_ALL then
				seedSnipeActive = true
				print("[So Nach Hup] Mutation phase active — pause all, waiting for seeds")
			else
				print("[So Nach Hup] Mutation phase — auto collect will pick up seeds")
			end
			task.defer(SNH.runSeedSnipePriority)
		end
	end), "mutation_watcher")
	local function onSpawnAdded(part)
		if not part:IsA("BasePart") then return end
		task.spawn(function()
			SNH.waitForMutationSpawnAttributes(part, 3)
			SNH.zeroSpawnSeedPrompts(part)
			local spawnConn = part.DescendantAdded:Connect(function(inst)
				if inst:IsA("ProximityPrompt") then
					SNH.zeroSpawnSeedPrompts(part)
				end
			end)
			SNH.trackConn(spawnConn, "mutation_spawn")
			part.Destroying:Once(function()
				pcall(function() spawnConn:Disconnect() end)
			end)
			local kind = SNH.getMutationSpawnTarget(part)
			if AUTO_SNIPE_MUTATION_SEEDS and kind and SNH.shouldSnipeMutationKind(kind) then
				if SEED_SNIPE_PAUSE_ALL then
					seedSnipeActive = true
					SNH.tryCollectMutationSpawn(part)
				elseif AUTO_COLLECT and COLLECT_MUTATION_SEEDS ~= false then
					task.defer(function()
						if SNH.tryAutoCollectMutationSpawns then SNH.tryAutoCollectMutationSpawns() end
					end)
				end
			elseif not SNH.isActionPausedForSeedSnipe() then
				seedSnipeActive = false
			end
		end)
	end
	for _, child in seedSpawnFolder:GetChildren() do onSpawnAdded(child) end
	SNH.trackConn(seedSpawnFolder.ChildAdded:Connect(onSpawnAdded), "mutation_watcher")
	if Networking and Networking.SeedPackSpawn then
		if Networking.SeedPackSpawn.FX then
			SNH.trackConn(Networking.SeedPackSpawn.FX.OnClientEvent:Connect(function(position)
				if not AUTO_SNIPE_MUTATION_SEEDS or not seedSpawnFolder then return end
				if SEED_SNIPE_PAUSE_ALL then
					seedSnipeActive = true
					print("[So Nach Hup] Seed pack FX — pause all, sniping")
				else
					print("[So Nach Hup] Seed pack FX — auto collect will snipe")
				end
				local bestPart, bestDist = nil, math.huge
				for _, part in seedSpawnFolder:GetChildren() do
					if part:IsA("BasePart") and not claimedMutationSpawns[part] then
						local kind = SNH.getMutationSpawnTarget(part)
						if kind and SNH.shouldSnipeMutationKind(kind) then
							local dist = (part.Position - position).Magnitude
							if dist < bestDist then bestPart, bestDist = part, dist end
						end
					end
				end
				if bestPart then
					if SEED_SNIPE_PAUSE_ALL then
						SNH.tryCollectMutationSpawn(bestPart)
					elseif SNH.tryAutoCollectMutationSpawns then
						SNH.tryAutoCollectMutationSpawns()
					end
				else
					SNH.runSeedSnipePriority()
				end
			end), "mutation_watcher")
		end
		if Networking.SeedPackSpawn.Announce then
			SNH.trackConn(Networking.SeedPackSpawn.Announce.OnClientEvent:Connect(function(packName)
				if not AUTO_SNIPE_MUTATION_SEEDS then return end
				SNH.markSeedPackEventActive(120)
				print(("[So Nach Hup] Seed pack announced (%s) — pause all, sniping"):format(tostring(packName)))
				task.defer(SNH.runSeedSnipePriority)
			end), "mutation_watcher")
		end
	end
end
end

do --[[ SNH: StealFire ]]
SNH.fireBeginStealFast = function(ownerUserId, plantId, fruitId, count)
	if not Networking or not Networking.Steal then return end
	local pid = tostring(plantId)
	local fid = fruitId or ""
	count = count or STEAL_PER_FRUIT_FIRES
	for _ = 1, count do
		pcall(function() Networking.Steal.BeginSteal:Fire(ownerUserId, pid, fid) end)
	end
end

SNH.fireInstantStealFast = function(ownerUserId, plantId, fruitId, count)
	if not Networking or not Networking.Steal then return end
	local pid = tostring(plantId)
	local fid = fruitId or ""
	count = count or STEAL_PER_FRUIT_FIRES
	for _ = 1, count do
		pcall(function()
			Networking.Steal.BeginSteal:Fire(ownerUserId, pid, fid)
			Networking.Steal.CompleteSteal:Fire()
		end)
	end
end

-- Game-consistent INSTANT steal: this is exactly what StealController does when a
-- StealPrompt has HoldDuration == 0 (PromptTriggered path): BeginSteal then CompleteSteal,
-- no hold and no movement wait. Works for any fruit, including hold-to-steal ones.
SNH.instaStealFruit = function(ownerUserId, plantId, fruitId)
	if not Networking or not Networking.Steal then return false end
	if not API.canStealNow() then return false end
	local uid = tonumber(ownerUserId)
	if not uid or not plantId then return false end
	local ok = pcall(function()
		Networking.Steal.BeginSteal:Fire(uid, tostring(plantId), tostring(fruitId or ""))
		Networking.Steal.CompleteSteal:Fire()
	end)
	return ok
end

-- Insta-steal every stealable fruit in unlocked gardens (one Begin+Complete each,
-- yields every few to stay safe — no unbounded spam burst).
SNH.instaStealAll = function()
	if not API.canStealNow() then
		print("[So Nach Hup] InstaStealAll: can only steal at night")
		return 0
	end
	if not Networking or not Networking.Steal then return 0 end
	local gardens = SNH.getStealableGardens and SNH.getStealableGardens() or {}
	local stolen, fired = 0, 0
	for _, garden in gardens do
		local uid = tonumber(garden.ownerUserId)
		if not uid then continue end
		for _, target in garden.targets do
			if not SNH.fruitStillThere(target) then continue end
			SNH.instaStealFruit(uid, target.plantId, target.fruitId)
			fired += 1
			if not SNH.fruitStillThere(target) then stolen += 1 end
			if fired % 10 == 0 then task.wait() end
		end
	end
	print(("[So Nach Hup] InstaStealAll: fired %d, confirmed %d stolen"):format(fired, stolen))
	return stolen
end

SNH.isStealCarryActive = function()
	return LocalPlayer:GetAttribute("IsStealingFruit") == true
		or LocalPlayer:GetAttribute("CarryingStolenFruit") == true
end

SNH.tweenToStealPosition = function(position)
	if not position then return false end
	SNH.markTeleportAway()
	stealFloatMoving = true
	SNH.setStealFloat(true)
	local ok
	if STEAL_USE_SHORT_HOP and SNH.shortHopTo then
		ok = SNH.shortHopTo(position, 0)
	elseif SNH.fastStealTweenTo then
		ok = SNH.fastStealTweenTo(position, 0)
	end
	stealFloatMoving = false
	local root, hum = SNH.getTeleportRoot()
	if root and ok then
		stealFloatAnchor = position
		SNH.stabilizeFloatRoot(root, hum, position)
	end
	return ok == true
end

SNH.getStealTpFn = function()
	if STEAL_USE_SHORT_HOP then
		return SNH.teleportRootToSteal
	end
	if STEAL_FAST_HOP or STEAL_INSTANT_TP then
		return SNH.teleportRootToSteal or SNH.floatTeleportTo
	end
	return function(pos)
		return SNH.teleportRootToSteal(pos, { fast = true })
	end
end

SNH.tryInstaStealTarget = function(target, ownerUserId)
	if not target or not target.plantId then return false end
	if not Networking or not Networking.Steal then return false end
	local uid = tonumber(target.ownerUserId) or tonumber(ownerUserId)
	if not uid then return false end

	if target.model then SNH.zeroStealPromptsOnModel(target.model) end
	local prompt = target.prompt or (target.model and SNH.findStealPrompt(target.model))
	if prompt then SNH.boostStealPrompt(prompt) end

	local plantId = tostring(target.plantId)
	local fruitId = tostring(target.fruitId or "")
	local hold = SNH.getStealHoldDuration(target)
	local fires = math.max(tonumber(STEAL_PER_FRUIT_FIRES) or 4, hold > 0 and 6 or 4)

	-- g2 StealController instant path: BeginSteal + CompleteSteal (HoldDuration == 0).
	if STEAL_INSTANT_REMOTE ~= false then
		for _ = 1, fires do
			SNH.instaStealFruit(uid, plantId, fruitId)
		end
		SNH.stealPause(0.02)
		if not SNH.fruitStillThere(target) or SNH.isStealCarryActive() then
			return true
		end
		SNH.fireInstantStealFast(uid, plantId, fruitId, fires)
		SNH.stealPause(0.05)
		if not SNH.fruitStillThere(target) or SNH.isStealCarryActive() then
			return true
		end
	end

	-- Hold fruits (Bamboo/Mushroom): skip hold timer — Begin then Complete immediately.
	if STEAL_TRY_REMOTE_FIRST ~= false then
		SNH.fireBeginStealFast(uid, plantId, fruitId, math.max(2, fires))
		SNH.stealPause(0.03)
		SNH.fireCompleteStealFast(math.max(3, STEAL_SPAM_COUNT))
		SNH.stealPause(0.05)
		if not SNH.fruitStillThere(target) or SNH.isStealCarryActive() then
			return true
		end
	end

	-- Prompt fallback with HoldDuration forced to 0 (triggers same instant client path).
	if STEAL_ZERO_HOLD ~= false and prompt and prompt.Enabled and not prompt:GetAttribute("Collected") then
		SNH.boostStealPrompt(prompt)
		SNH.triggerProximityPrompt(prompt)
		SNH.stealPause(0.06)
		if not SNH.fruitStillThere(target) or SNH.isStealCarryActive() then
			return true
		end
	end

	return not SNH.fruitStillThere(target) or SNH.isStealCarryActive()
end

SNH.stealTargetAtFruit = function(target, ownerUserId)
	return SNH.tryInstaStealTarget(target, ownerUserId)
end

-- Home CompleteSteal failed while still carrying: tween out of garden, back in, retry.
SNH.tryCompleteStealWithGardenBounce = function(completeCount)
	completeCount = completeCount or STEAL_SPAM_COUNT
	local function fireComplete()
		SNH.fireCompleteStealFast(completeCount)
		if STEAL_COMPLETE_WAIT > 0 then task.wait(STEAL_COMPLETE_WAIT) end
		fruitCountCache.time = 0
	end
	if not SNH.isStealCarryActive() then return true end

	fireComplete()
	if not SNH.isStealCarryActive() then return true end

	local _, ownPlot = API.getLocalPlot()
	if not ownPlot then return false end
	local homePos = SNH.getGardenInteriorPosition(ownPlot)
	local outsidePos = SNH.getGardenExteriorPosition(ownPlot)
	if not homePos or not outsidePos then return false end

	local maxTries = math.max(1, tonumber(STEAL_GARDEN_BOUNCE_TRIES) or 6)
	local gap = tonumber(STEAL_GARDEN_BOUNCE_GAP) or 0.12
	for attempt = 1, maxTries do
		if not SNH.isStealCarryActive() then return true end
		SNH.setStatus(("Steal stuck — bounce out/in (%d/%d)"):format(attempt, maxTries))
		SNH.tweenToStealPosition(outsidePos)
		if gap > 0 then task.wait(gap) end
		SNH.tweenToStealPosition(homePos)
		if gap > 0 then task.wait(gap) end
		fireComplete()
	end
	return not SNH.isStealCarryActive()
end

SNH.fireCompleteStealFast = function(count)
	if not Networking or not Networking.Steal then return end
	count = count or STEAL_SPAM_COUNT
	for _ = 1, count do
		pcall(function() Networking.Steal.CompleteSteal:Fire() end)
	end
end

SNH.spamBeginSteal = function(ownerUserId, plantId, fruitId)
	if not Networking or not Networking.Steal then return end
	local pid = tostring(plantId)
	local fid = fruitId or ""
	for _ = 1, STEAL_SPAM_COUNT do
		pcall(function() Networking.Steal.BeginSteal:Fire(ownerUserId, pid, fid) end)
		if STEAL_SPAM_GAP > 0 then task.wait(STEAL_SPAM_GAP) end
	end
end

SNH.spamCompleteSteal = function()
	if not Networking or not Networking.Steal then return end
	for _ = 1, STEAL_SPAM_COUNT do
		pcall(function() Networking.Steal.CompleteSteal:Fire() end)
		if STEAL_SPAM_GAP > 0 then task.wait(STEAL_SPAM_GAP) end
	end
end

SNH.spamInstantSteal = function(ownerUserId, plantId, fruitId)
	if not Networking or not Networking.Steal then return end
	local pid = tostring(plantId)
	local fid = fruitId or ""
	for _ = 1, STEAL_SPAM_COUNT do
		pcall(function()
			Networking.Steal.BeginSteal:Fire(ownerUserId, pid, fid)
			Networking.Steal.CompleteSteal:Fire()
		end)
		if STEAL_SPAM_GAP > 0 then task.wait(STEAL_SPAM_GAP) end
	end
end

SNH.spamStealAtFruit = function(ownerUserId, plantId, fruitId)
	SNH.spamBeginSteal(ownerUserId, plantId, fruitId)
	SNH.spamInstantSteal(ownerUserId, plantId, fruitId)
end

SNH.spamStealAtHome = function()
	SNH.spamCompleteSteal()
end

SNH.getFruitInventoryRoom = function()
	return math.max(0, SNH.getMaxFruitCapacity() - SNH.countFruitInInventory())
end

SNH.isFruitInventoryFull = function()
	return SNH.getFruitInventoryRoom() <= 0
end

SNH.completeStealAtHome = function(completeCount)
	local _, ownPlot = API.getLocalPlot()
	local homePos = ownPlot and SNH.getGardenInteriorPosition(ownPlot)
	local tpFn = SNH.getStealTpFn()
	if homePos and tpFn then tpFn(homePos) end
	if SNH.isStealCarryActive() then
		SNH.tryCompleteStealWithGardenBounce(completeCount)
	else
		SNH.fireCompleteStealFast(completeCount or STEAL_SPAM_COUNT)
		if STEAL_COMPLETE_WAIT > 0 then task.wait(STEAL_COMPLETE_WAIT) end
		fruitCountCache.time = 0
	end
end

SNH.flushInProgressStealAtHome = function()
	if not SNH.isStealCarryActive() then return false end
	SNH.completeStealAtHome(STEAL_SPAM_COUNT)
	return not SNH.isStealCarryActive()
end

-- Finish carry + sell once if backpack is full so large gardens can be drained in rounds.
SNH.prepareStealInventoryRoom = function(minRoom)
	minRoom = math.max(1, tonumber(minRoom) or 1)
	SNH.flushInProgressStealAtHome()
	local room = SNH.getFruitInventoryRoom()
	if room >= minRoom then return room end
	if AUTO_SELL and Networking and Networking.NPCS and Networking.NPCS.SellAll then
		pcall(SNH.trySellNonMutationFruits)
		task.wait(math.min(SELL_LOOP_GAP > 0 and SELL_LOOP_GAP or 1.5, 0.35))
		fruitCountCache.time = 0
		room = SNH.getFruitInventoryRoom()
	end
	return room
end
end

do --[[ SNH: StealTp ]]
SNH.getFruitWorldPosition = function(target)
	if target.model and target.model.Parent then
		return target.model:GetPivot().Position
	end
	return nil
end

SNH.stripNotificationText = function(text)
	if type(text) ~= "string" then return "" end
	return string.gsub(text, "<[^>]+>", "")
end

SNH.parseCooldownSecondsFromText = function(text)
	text = SNH.stripNotificationText(text)
	if text == "" then return nil end
	local lower = string.lower(text)
	local n = string.match(lower, "(%d+%.?%d*)%s*seconds?")
	if n then return tonumber(n) end
	n = string.match(lower, "(%d+%.?%d*)%s*sec")
	if n then return tonumber(n) end
	n = string.match(lower, "(%d+%.?%d*)s")
	return tonumber(n)
end

SNH.isStealGardenEntryNotification = function(text)
	text = SNH.stripNotificationText(text)
	if text == "" then return false end
	local lower = string.lower(text)
	if lower:find("wait", 1, true) and lower:find("garden", 1, true) then return true end
	if lower:find("wait", 1, true) and lower:find("moment", 1, true) then return true end
	if lower:find("too soon", 1, true) then return true end
	if lower:find("someone", 1, true) and lower:find("garden", 1, true) and lower:find("wait", 1, true) then
		return true
	end
	if lower:find("enter", 1, true) and lower:find("garden", 1, true) and lower:find("wait", 1, true) then
		return true
	end
	return false
end

SNH.noteStealGardenEntryCooldown = function(text, extraSec)
	local sec = SNH.parseCooldownSecondsFromText(text)
		or tonumber(extraSec)
		or tonumber(STEAL_GARDEN_ENTRY_COOLDOWN_SEC)
		or 5
	stealGardenEntryCooldownUntil = math.max(stealGardenEntryCooldownUntil, tick() + sec)
	SNH.setStatus(("WAIT FOR GARDEN CD OF PLAYER END | %d SECONDS LEFT"):format(math.ceil(sec)))
end

SNH.setupStealNotificationHook = function()
	if stealNotificationHooked then return end
	local ok, nc = pcall(function()
		local controllers = LocalPlayer:FindFirstChild("PlayerScripts")
		controllers = controllers and controllers:FindFirstChild("Controllers")
		local mod = controllers and controllers:FindFirstChild("NotificationController")
		return mod and require(mod)
	end)
	if not ok or not nc or type(nc.CreateNotification) ~= "function" then return end
	local orig = nc.CreateNotification
	nc.CreateNotification = function(self, text, ...)
		if SNH.isStealGardenEntryNotification(text) then
			SNH.noteStealGardenEntryCooldown(text)
		end
		return orig(self, text, ...)
	end
	stealNotificationHooked = true
end

SNH.getPlayerHealthRatio = function()
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if not hum or hum.MaxHealth <= 0 then return 1 end
	return hum.Health / hum.MaxHealth
end

SNH.shouldFleeStealLowHealth = function()
	if STEAL_LOW_HEALTH_FLEE == false then return false end
	local ratio = tonumber(STEAL_LOW_HEALTH_RATIO) or 0.4
	return SNH.getPlayerHealthRatio() < ratio
end

SNH.tryFleeStealLowHealth = function(homePos, tpFn, reason)
	if not SNH.shouldFleeStealLowHealth() then return false end
	reason = reason or "low health"
	SNH.setStatus(("Steal flee (%s) — home to complete"):format(reason))
	if homePos and tpFn then tpFn(homePos) end
	if SNH.isStealCarryActive() then
		SNH.completeStealAtHome(STEAL_SPAM_COUNT)
	end
	return true
end

SNH.getStealCooldownHoverPosition = function(plot)
	if not plot then return nil end
	local center = SNH.getGardenInteriorPosition(plot)
	if not center then return nil end
	-- g2 DragonBreath: ~30 stud flat range, flame hitbox ~2.2 at ground — high hover avoids all breath damage.
	local height = math.max(tonumber(STEAL_COOLDOWN_FLOAT_HEIGHT) or 95, 70)
	return center + Vector3.new(0, height, 0)
end

SNH.maintainStealCooldownHover = function(plot)
	if not plot then return end
	local hover = SNH.getStealCooldownHoverPosition(plot)
	if not hover then return end
	SNH.setStealFloat(true)
	local root, hum = SNH.getTeleportRoot()
	if root and SNH.isNearPosition(hover, TP_ARRIVE_RADIUS + 8) then
		stealFloatAnchor = hover
		SNH.stabilizeFloatRoot(root, hum, hover)
	else
		local tpFn = SNH.getStealTpFn()
		if tpFn then tpFn(hover) end
		root, hum = SNH.getTeleportRoot()
		if root and hum then SNH.stabilizeFloatRoot(root, hum, hover) end
	end
end

SNH.readCooldownRemaining = function(inst)
	if not inst then return 0 end
	local nowServer = workspace:GetServerTimeNow()
	local nowClock = os.clock()
	local best = 0
	local untilAttrs = {
		"CooldownUntil", "StealCooldownUntil", "GardenStealCooldownUntil",
		"VisitorCooldownUntil", "CanStealAt", "StealReadyAt",
	}
	for _, name in untilAttrs do
		local v = inst:GetAttribute(name)
		if typeof(v) == "number" and v > nowServer then
			best = math.max(best, v - nowServer)
		end
	end
	local endAttrs = { "CooldownEnd", "StealCooldownEnd", "GardenStealCooldownEnd" }
	for _, name in endAttrs do
		local v = inst:GetAttribute(name)
		if typeof(v) == "number" and v > nowClock then
			best = math.max(best, v - nowClock)
		end
	end
	local remainAttrs = { "CooldownRemaining", "StealCooldownRemaining", "Remaining" }
	for _, name in remainAttrs do
		local v = inst:GetAttribute(name)
		if typeof(v) == "number" and v > 0 then
			best = math.max(best, v)
		end
	end
	return best
end

SNH.getStealGardenBlockInfo = function(plot, owner)
	if not API.canStealNow() then
		return math.huge, "not night"
	end
	if owner and API.isGardenLockedForSteal(owner) then
		return math.huge, "owner in garden"
	end
	if SNH.isOwnerGuardingGarden(owner, plot) then
		return math.huge, "owner guarding"
	end
	if plot and not API.isPlayerInsidePlot(LocalPlayer, plot) then
		return math.max(tonumber(STEAL_TP_SETTLE) or 0.1, 0.05), "entering garden"
	end
	if STEAL_SAFE_ZONE_WAIT ~= false and LocalPlayer:GetAttribute("InSafeZone") == true then
		return 0.35, "safe zone"
	end

	local remain = SNH.readCooldownRemaining(LocalPlayer)
	if plot then remain = math.max(remain, SNH.readCooldownRemaining(plot)) end
	if owner then remain = math.max(remain, SNH.readCooldownRemaining(owner)) end

	local plotKey = plot and plot.Name
	if plotKey and lastStealGardenEntryAt[plotKey] then
		local since = tick() - lastStealGardenEntryAt[plotKey]
		local need = tonumber(STEAL_BEGIN_WAIT) or 0.12
		if since < need then
			remain = math.max(remain, need - since)
		end
	end

	if tick() < stealGardenEntryCooldownUntil then
		remain = math.max(remain, stealGardenEntryCooldownUntil - tick())
	end

	if remain > 0 then
		return remain, "garden entry cooldown"
	end

	if plot and STEAL_AUTO_DETECT_COOLDOWN ~= false then
		local hasPrompt = false
		for _, inst in plot:GetDescendants() do
			if inst:IsA("ProximityPrompt") and SNH.isStealPrompt(inst) and inst.Enabled then
				hasPrompt = true
				break
			end
		end
		if not hasPrompt then
			return 0.25, "waiting prompts"
		end
	end

	return 0, "ready"
end

SNH.markStealGardenEntry = function(plot)
	if plot and plot.Name then
		lastStealGardenEntryAt[plot.Name] = tick()
	end
end

SNH.zeroStealPromptsOnPlot = function(plot)
	if not plot then return end
	for _, inst in plot:GetDescendants() do
		if inst:IsA("ProximityPrompt") and SNH.isStealPrompt(inst) then
			SNH.boostStealPrompt(inst)
		end
	end
end

SNH.prepareVictimGardenForSteal = function(plot)
	if not plot then return end
	SNH.zeroStealPromptsOnPlot(plot)
end

SNH.waitForStealGardenReady = function(pack)
	if not pack then return false, "no pack" end
	local plot = pack.garden and pack.garden.plot
	local owner = pack.owner
	local timeout = tonumber(STEAL_GARDEN_READY_TIMEOUT) or 45
	local poll = tonumber(STEAL_GARDEN_ENTRY_POLL) or tonumber(STEAL_GARDEN_POLL) or 0.15
	local deadline = tick() + timeout
	local lastStatusAt = 0
	stealInVictimGarden = plot ~= nil

	while tick() < deadline do
		if SNH.shouldFleeSteal(pack) then
			stealInVictimGarden = false
			return false, "flee"
		end
		SNH.maintainStealCooldownHover(plot)
		local remain, reason = SNH.getStealGardenBlockInfo(plot, owner)
		if remain <= 0 then
			stealInVictimGarden = false
			return true, reason
		end
		if remain < math.huge and tick() - lastStatusAt >= 0.35 then
			if reason == "garden entry cooldown" then
				SNH.setStatus(("WAIT FOR GARDEN CD OF PLAYER END | %d SECONDS LEFT"):format(math.ceil(remain)))
			elseif reason == "safe zone" then
				SNH.setStatus("Waiting for safe zone to clear before stealing")
			elseif reason == "entering garden" then
				SNH.setStatus("Entering target garden...")
			elseif reason == "waiting prompts" then
				SNH.setStatus("Waiting for steal prompts to appear")
			else
				SNH.setStatus(("Steal wait (%s) %.1fs — hovering safe"):format(reason or "cooldown", remain))
			end
			lastStatusAt = tick()
		elseif remain >= math.huge and tick() - lastStatusAt >= 1.2 then
			SNH.setStatus(("Steal wait (%s) — hovering safe"):format(reason or "locked"))
			lastStatusAt = tick()
		end
		SNH.stealPause(poll)
	end
	stealInVictimGarden = false
	return false, "timeout"
end

SNH.teleportToVictimForSteal = function(target)
	local victimPlot = target.ownerPlot or SNH.getPlotFromModel(target.model)
	stealInVictimGarden = victimPlot ~= nil
	SNH.markTeleportAway()
	local fruitPos = SNH.getFruitWorldPosition(target)
	local tpFn = SNH.getStealTpFn()
	if fruitPos and tpFn and tpFn(fruitPos + Vector3.new(0, 2.5, 0)) then
		target.ownerPlot = target.ownerPlot or SNH.getPlotFromModel(target.model)
		return true
	end
	local victimPlot = target.ownerPlot or SNH.getPlotFromModel(target.model)
	if not victimPlot then return false end
	target.ownerPlot = victimPlot
	SNH.prepareVictimGardenForSteal(victimPlot)
	local plotPos = SNH.getGardenInteriorPosition(victimPlot)
	if not plotPos or not tpFn or not tpFn(plotPos) then return false end
	SNH.markStealGardenEntry(victimPlot)
	fruitPos = SNH.getFruitWorldPosition(target)
	if fruitPos then return tpFn(fruitPos + Vector3.new(0, 2.5, 0)) end
	return false
end

SNH.verifyStealSuccess = function(target)
	local deadline = tick() + STEAL_VERIFY_TIME
	while tick() < deadline do
		if not SNH.fruitStillThere(target) then return true end
		task.wait(0.03)
	end
	return not SNH.fruitStillThere(target)
end

SNH.tryRemoteSteal = function(ownerUserId, plantId, fruitId, homePos)
	if not Networking or not Networking.Steal then return false end
	for _ = 1, STEAL_BURST_ROUNDS do
		SNH.spamStealAtFruit(ownerUserId, plantId, fruitId)
		if LocalPlayer:GetAttribute("IsStealingFruit") or LocalPlayer:GetAttribute("CarryingStolenFruit") then
			break
		end
	end
	if homePos then SNH.completeStealAtHome() end
	return true
end
end

do --[[ SNH: StealGarden ]]
SNH.getBestStealGarden = function()
	local now = tick()
	local bestPack, bestScore = nil, -1
	for _, garden in SNH.getStealableGardens() do
		local valid, totalValue = {}, 0
		for _, target in garden.targets do
			local skipUntil = stealSkip[SNH.stealKey(target)]
			if skipUntil and now < skipUntil then continue end
			if not SNH.fruitStillThere(target) then continue end
			target.ownerUserId = target.ownerUserId or garden.ownerUserId
			target.ownerPlot = target.ownerPlot or garden.plot
			table.insert(valid, target)
			totalValue += target.value or 0
		end
		if #valid == 0 then continue end
		table.sort(valid, function(a, b) return (a.value or 0) > (b.value or 0) end)
		local bestTreeValue = SNH.getGardenBestTreeValue(valid)
		local bestTreeInfo = SNH.getGardenBestTreeInfo(valid)
		local score = bestTreeValue * 1e9 + totalValue
		if score > bestScore then
			bestScore = score
			bestPack = {
				garden = garden,
				targets = valid,
				owner = garden.player,
				ownerUserId = garden.ownerUserId,
				totalValue = totalValue,
				bestTreeValue = bestTreeValue,
				bestTreeSeed = bestTreeInfo and bestTreeInfo.seedName,
				bestTreePlantId = bestTreeInfo and bestTreeInfo.plantId,
			}
		end
	end
	return bestPack
end

SNH.getCurrentFruitCount = function()
	local attr = LocalPlayer:GetAttribute("FruitCount")
	if type(attr) == "number" and attr >= 0 then
		return math.floor(attr)
	end
	return SNH.countFruitInInventory()
end

SNH.shouldReturnStealForInventory = function()
	local count = SNH.getCurrentFruitCount()
	local maxCap = SNH.getMaxFruitCapacity()
	local hardMax = tonumber(STEAL_RETURN_FRUIT_MAX) or 50
	local ratio = tonumber(STEAL_RETURN_FRUIT_RATIO) or 0.5
	local softAt = tonumber(STEAL_RETURN_AT_FRUITS) or hardMax
	if count >= hardMax then
		return true, ("fruits %d/%d max"):format(count, maxCap)
	end
	if count >= softAt then
		return true, ("fruits %d/%d"):format(count, maxCap)
	end
	if maxCap > 0 and ratio > 0 and (count / maxCap) >= ratio then
		return true, ("fruits %d/%d (%.0f%%)"):format(count, maxCap, ratio * 100)
	end
	if SNH.getFruitInventoryRoom() <= 0 then
		return true, "inventory full"
	end
	return false
end

SNH.shouldEndStealTrip = function(pack)
	if SNH.shouldFleeSteal(pack) then
		return true, "owner returned"
	end
	if SNH.shouldFleeStealLowHealth() then
		return true, "low health"
	end
	local shouldReturn, why = SNH.shouldReturnStealForInventory()
	if shouldReturn then
		return true, why
	end
	return false
end

SNH.getStealDrainMaxRounds = function(victimPlot, ownerUserId)
	local base = math.max(1, tonumber(STEAL_GARDEN_MAX_ROUNDS) or 200)
	if not victimPlot or not ownerUserId then return base end
	local count = #(SNH.gatherStealTargets(victimPlot, ownerUserId))
	if count <= 0 then return base end
	return math.max(base, math.ceil(count * 1.5))
end

SNH.returnStealHomeAndFlush = function(homePos, tpFn, reason)
	reason = reason or "return"
	SNH.setStatus(("Steal home (%s)"):format(reason))
	if homePos and tpFn then tpFn(homePos) end
	if SNH.isStealCarryActive() then
		SNH.completeStealAtHome(STEAL_SPAM_COUNT)
	end
	SNH.prepareStealInventoryRoom(1)
	fruitCountCache.time = 0
	if STEAL_RETURN_WAIT > 0 then task.wait(STEAL_RETURN_WAIT) end
	return true
end

SNH.enterVictimGardenForSteal = function(pack, tpFn)
	local victimPlot = pack and pack.garden and pack.garden.plot
	if not victimPlot then return false end
	local plotPos = SNH.getGardenInteriorPosition(victimPlot)
	if plotPos and tpFn then
		tpFn(plotPos)
		SNH.markStealGardenEntry(victimPlot)
		SNH.prepareVictimGardenForSteal(victimPlot)
		SNH.stealPause(tonumber(STEAL_TP_SETTLE) or 0.03)
	end
	stealInVictimGarden = true
	local ready, why = SNH.waitForStealGardenReady(pack)
	if not ready then
		stealInVictimGarden = false
		if why == "flee" then
			SNH.fleeStealToHome("owner returned during steal wait")
		end
		return false
	end
	return true
end

SNH.stealSingleTarget = function(target, pack, ownerUserId, homePos, tpFn)
	if not target or not SNH.fruitStillThere(target) then return false end
	if SNH.shouldFleeSteal(pack) then return false, "flee" end

	local shouldReturn, returnWhy = SNH.shouldReturnStealForInventory()
	if shouldReturn then
		SNH.returnStealHomeAndFlush(homePos, tpFn, returnWhy)
		return false, "inventory"
	end
	if SNH.shouldFleeStealLowHealth() then
		SNH.returnStealHomeAndFlush(homePos, tpFn, "low health")
		return false, "low health"
	end

	local uid = tonumber(target.ownerUserId) or ownerUserId
	local victimPlot = pack.garden and pack.garden.plot

	SNH.tryInstaStealTarget(target, uid)
	task.wait(0.02)

	if SNH.fruitStillThere(target) and not SNH.isStealCarryActive() then
		local sinceEntry = victimPlot and lastStealGardenEntryAt[victimPlot.Name]
		if sinceEntry and tick() - sinceEntry < 8 then
			SNH.noteStealGardenEntryCooldown(nil, STEAL_GARDEN_ENTRY_COOLDOWN_SEC)
			local ready = SNH.waitForStealGardenReady(pack)
			if not ready then return false, "blocked" end
		end
	end

	if not SNH.fruitStillThere(target) and not SNH.isStealCarryActive() then
		return true
	end

	local pos = SNH.getFruitWorldPosition(target)
	if pos and tpFn then
		tpFn(pos + Vector3.new(0, 2.5, 0))
		task.wait(tonumber(STEAL_TP_SETTLE) or 0.03)
	end
	SNH.tryInstaStealTarget(target, uid)

	if SNH.shouldFleeStealLowHealth() then
		SNH.returnStealHomeAndFlush(homePos, tpFn, "low health")
		return false, "low health"
	end
	if SNH.isStealCarryActive() then
		SNH.returnStealHomeAndFlush(homePos, tpFn, "carrying")
		if STEAL_REENTER_AFTER_FLUSH ~= false then
			local endTrip = SNH.shouldEndStealTrip(pack)
			if not endTrip then
				return false, "reenter"
			end
		end
		return false, "carrying"
	end
	if not SNH.fruitStillThere(target) then
		return true
	end
	if STEAL_GAP > 0 then task.wait(STEAL_GAP) end
	return false
end

SNH.runStealGardenDrain = function(pack)
	if not pack or not pack.garden or not pack.garden.plot then return 0 end
	local ownerUserId = tonumber(pack.ownerUserId)
	if not ownerUserId then return 0 end

	local _, ownPlot = API.getLocalPlot()
	local homePos = ownPlot and SNH.getGardenInteriorPosition(ownPlot)
	local tpFn = SNH.getStealTpFn()
	local victimPlot = pack.garden.plot
	local totalStolen = 0
	local maxRounds = SNH.getStealDrainMaxRounds(victimPlot, ownerUserId)

	for round = 1, maxRounds do
		local endTrip, endWhy = SNH.shouldEndStealTrip(pack)
		if endTrip and endWhy ~= "owner returned" then
			if endWhy == "low health" or endWhy:find("fruit") or endWhy == "inventory full" then
				SNH.returnStealHomeAndFlush(homePos, tpFn, endWhy)
			end
			break
		end
		if SNH.shouldFleeSteal(pack) then
			SNH.fleeStealToHome("owner returned")
			break
		end

		SNH.prepareStealInventoryRoom(1)
		local room = SNH.getFruitInventoryRoom()
		if room <= 0 then
			SNH.returnStealHomeAndFlush(homePos, tpFn, "inventory full")
			break
		end

		if not SNH.enterVictimGardenForSteal(pack, tpFn) then
			break
		end

		local targets = SNH.gatherStealTargets(victimPlot, ownerUserId)
		if #targets == 0 then
			stealInVictimGarden = false
			if STEAL_RETURN_ON_EMPTY_GARDEN ~= false and homePos and tpFn then
				SNH.returnStealHomeAndFlush(homePos, tpFn, "garden empty")
			end
			break
		end

		table.sort(targets, function(a, b)
			return (a.value or 0) > (b.value or 0)
		end)

		local stolenThisRound = 0
		local needReenter = false

		for _, target in targets do
			if SNH.shouldFleeSteal(pack) then break end

			local ok, stopReason = SNH.stealSingleTarget(target, pack, ownerUserId, homePos, tpFn)
			if ok then
				stolenThisRound += 1
				totalStolen += 1
			elseif stopReason == "inventory" or stopReason == "low health" then
				needReenter = false
				break
			elseif stopReason == "carrying" or stopReason == "reenter" then
				needReenter = STEAL_REENTER_AFTER_FLUSH ~= false
				if stopReason == "carrying" and not needReenter then
					break
				end
				if needReenter then
					break
				end
			elseif stopReason == "flee" or stopReason == "blocked" then
				break
			end

			if SNH.getFruitInventoryRoom() <= 0 then
				SNH.returnStealHomeAndFlush(homePos, tpFn, "inventory full")
				needReenter = STEAL_REENTER_AFTER_FLUSH ~= false
				break
			end
		end

		stealInVictimGarden = false
		local remaining = SNH.gatherStealTargets(victimPlot, ownerUserId)

		if #remaining == 0 then
			if STEAL_RETURN_ON_EMPTY_GARDEN ~= false and homePos and tpFn then
				SNH.returnStealHomeAndFlush(homePos, tpFn, "garden empty")
			end
			break
		end

		if not needReenter or stolenThisRound <= 0 then
			break
		end
		if SNH.shouldFleeSteal(pack) then break end
		if SNH.getFruitInventoryRoom() <= 0 then break end
		if SNH.shouldFleeStealLowHealth() then break end
	end

	if SNH.isStealCarryActive() then
		SNH.returnStealHomeAndFlush(homePos, tpFn, "finish carry")
	end
	stealInVictimGarden = false
	return totalStolen
end

SNH.countStolenTargets = function(targets)
	local n = 0
	for _, target in targets do
		if not SNH.fruitStillThere(target) then n += 1 end
	end
	return n
end

SNH.burstStealTargetsBatch = function(pack, batch, ownerUserId, homePos, tpFn)
	if not batch or #batch == 0 then return 0 end
	tpFn = tpFn or SNH.getStealTpFn()
	local victimPlot = pack.garden and pack.garden.plot
	if victimPlot then
		local plotPos = SNH.getGardenInteriorPosition(victimPlot)
		if plotPos and tpFn then
			tpFn(plotPos)
			SNH.markStealGardenEntry(victimPlot)
			SNH.prepareVictimGardenForSteal(victimPlot)
			SNH.stealPause(tonumber(STEAL_TP_SETTLE) or 0.03)
		end
		local ready, why = SNH.waitForStealGardenReady(pack)
		if not ready then
			if why == "flee" then
				SNH.fleeStealToHome("owner returned during steal wait")
			else
				SNH.setStatus(("Steal blocked: %s"):format(tostring(why)))
			end
			return 0
		end
		table.sort(batch, function(a, b)
			return (a.value or 0) > (b.value or 0)
		end)
	end
	local stolen = 0
	stealInVictimGarden = victimPlot ~= nil
	for _, target in batch do
		if SNH.shouldFleeSteal(pack) then break end
		local shouldReturn, returnWhy = SNH.shouldReturnStealForInventory()
		if shouldReturn then
			SNH.returnStealHomeAndFlush(homePos, tpFn, returnWhy or "inventory")
			break
		end
		if SNH.tryFleeStealLowHealth(homePos, tpFn, "low health") then break end
		if SNH.isStealCarryActive() then
			SNH.returnStealHomeAndFlush(homePos, tpFn, "carrying")
			local endTrip = SNH.shouldEndStealTrip(pack)
			if endTrip then break end
			if STEAL_REENTER_AFTER_FLUSH == false then break end
			if victimPlot and tpFn then
				local plotPos = SNH.getGardenInteriorPosition(victimPlot)
				if plotPos then
					tpFn(plotPos)
					SNH.markStealGardenEntry(victimPlot)
					SNH.prepareVictimGardenForSteal(victimPlot)
					SNH.stealPause(tonumber(STEAL_TP_SETTLE) or 0.03)
				end
			end
			continue
		end
		if not SNH.fruitStillThere(target) then continue end
		local uid = tonumber(target.ownerUserId) or ownerUserId
		SNH.tryInstaStealTarget(target, uid)
		task.wait(0.02)
		if SNH.fruitStillThere(target) and not SNH.isStealCarryActive() then
			local sinceEntry = victimPlot and lastStealGardenEntryAt[victimPlot.Name]
			if sinceEntry and tick() - sinceEntry < 8 then
				SNH.noteStealGardenEntryCooldown(nil, STEAL_GARDEN_ENTRY_COOLDOWN_SEC)
				local ready = SNH.waitForStealGardenReady(pack)
				if not ready then break end
			end
		end
		if not SNH.fruitStillThere(target) and not SNH.isStealCarryActive() then
			stolen += 1
			continue
		end
		local pos = SNH.getFruitWorldPosition(target)
		if pos and tpFn then
			tpFn(pos + Vector3.new(0, 2.5, 0))
			task.wait(tonumber(STEAL_TP_SETTLE) or 0.03)
		end
		SNH.tryInstaStealTarget(target, uid)
		if SNH.tryFleeStealLowHealth(homePos, tpFn, "low health") then break end
		if SNH.isStealCarryActive() then
			SNH.returnStealHomeAndFlush(homePos, tpFn, "carrying")
			local endTrip = SNH.shouldEndStealTrip(pack)
			if endTrip then break end
			if not SNH.fruitStillThere(target) or not SNH.isStealCarryActive() then
				stolen += 1
			end
			if STEAL_REENTER_AFTER_FLUSH == false then break end
			if victimPlot and tpFn then
				local plotPos = SNH.getGardenInteriorPosition(victimPlot)
				if plotPos then
					tpFn(plotPos)
					SNH.markStealGardenEntry(victimPlot)
					SNH.prepareVictimGardenForSteal(victimPlot)
					SNH.stealPause(tonumber(STEAL_TP_SETTLE) or 0.03)
				end
			end
			continue
		elseif not SNH.fruitStillThere(target) then
			stolen += 1
		end
		if STEAL_GAP > 0 then task.wait(STEAL_GAP) end
	end
	stealInVictimGarden = false
	if STEAL_HOME_AFTER_BATCH ~= false then
		if homePos and tpFn then tpFn(homePos) end
		if SNH.isStealCarryActive() then
			SNH.completeStealAtHome(STEAL_SPAM_COUNT)
		end
	end
	return math.max(stolen, SNH.countStolenTargets(batch))
end

SNH.burstStealGarden = function(pack)
	if not pack or not pack.targets or #pack.targets == 0 then return 0 end
	if SNH.shouldFleeSteal(pack) then
		SNH.fleeStealToHome("owner returned before steal")
		return 0
	end
	if not Networking or not Networking.Steal then return 0 end
	local ownerUserId = tonumber(pack.ownerUserId)
	if not ownerUserId then return 0 end
	local ownerLabel = pack.owner and (pack.owner.DisplayName or pack.owner.Name)
		or ("User " .. tostring(ownerUserId))
	SNH.setStealFloat(true)
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum then pcall(hum.UnequipTools, hum) end

	if STEAL_DRAIN_GARDEN ~= false and pack.garden and pack.garden.plot then
		local fresh = SNH.gatherStealTargets(pack.garden.plot, ownerUserId)
		if #fresh > 0 then
			pack.targets = fresh
		end
		if #pack.targets == 0 then
			SNH.setStealFloat(false)
			return 0
		end
		local minDrain = math.max(1, tonumber(STEAL_DRAIN_MIN_FRUITS) or 2)
		if #fresh >= minDrain then
			table.sort(pack.targets, function(a, b)
				return (a.value or 0) > (b.value or 0)
			end)
			local treeLabel = pack.targets[1] and pack.targets[1].seedName or "fruit"
			local treeValue = pack.targets[1] and pack.targets[1].value or 0
			SNH.setStatus(("STEALING HIGHEST FRUIT (%s VALUE) FROM %s | %d targets"):format(
				SNH.formatAbbrev(treeValue), ownerLabel, #pack.targets))
			local totalStolen = SNH.runStealGardenDrain(pack)
			SNH.setStealFloat(false)
			return totalStolen
		end
	end

	local _, ownPlot = API.getLocalPlot()
	local homePos = ownPlot and SNH.getGardenInteriorPosition(ownPlot)
	local tpFn = SNH.getStealTpFn()
	local pending = {}
	for _, target in pack.targets do
		if SNH.fruitStillThere(target) then
			table.insert(pending, target)
		end
	end
	if #pending == 0 then
		SNH.setStealFloat(false)
		return 0
	end
	if pack.garden and pack.garden.plot then
		local fresh = SNH.gatherStealTargets(pack.garden.plot, ownerUserId)
		if #fresh > 0 then
			pending = fresh
		end
	end
	table.sort(pending, function(a, b)
		return (a.value or 0) > (b.value or 0)
	end)
	local treeLabel = pending[1] and pending[1].seedName or "fruit"
	local treeValue = pending[1] and pending[1].value or 0
	local room = SNH.prepareStealInventoryRoom(1)
	local batchCap = math.min(
		room,
		tonumber(STEAL_BATCH_SIZE) or 5,
		#pending
	)
	if batchCap <= 0 then
		SNH.completeStealAtHome(STEAL_SPAM_COUNT)
		SNH.setStealFloat(false)
		return 0
	end
	local batch = {}
	for i = 1, batchCap do
		table.insert(batch, pending[i])
	end
	SNH.setStatus(("STEALING HIGHEST FRUIT (%s VALUE) FROM %s | %d targets"):format(
		SNH.formatAbbrev(treeValue), ownerLabel, #batch))
	local totalStolen = SNH.burstStealTargetsBatch(pack, batch, ownerUserId, homePos, tpFn)
	SNH.setStealFloat(false)
	return totalStolen
end

SNH.stealFruit = function(target)
	if STEAL_BURST_ALL then
		return SNH.burstStealGarden({
			targets = { target },
			ownerUserId = target.ownerUserId,
			garden = { plot = target.ownerPlot, player = nil },
		}) > 0
	end
	local ownerUserId = tonumber(target.ownerUserId)
	if not ownerUserId or not target.plantId then return false end
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum then pcall(hum.UnequipTools, hum) end
	SNH.setStealFloat(true)
	if not SNH.teleportToVictimForSteal(target) then
		SNH.setStealFloat(false)
		warn("[So Nach Hup] Steal tween failed")
		return false
	end
	for _ = 1, STEAL_BURST_ROUNDS do
		SNH.stealTargetAtFruit(target, ownerUserId)
		if not SNH.fruitStillThere(target) then
			SNH.completeStealAtHome()
			SNH.setStealFloat(false)
			return true
		end
		if SNH.isStealCarryActive() then
			SNH.completeStealAtHome()
			SNH.setStealFloat(false)
			return SNH.verifyStealSuccess(target)
		end
	end
	SNH.completeStealAtHome()
	SNH.setStealFloat(false)
	return SNH.verifyStealSuccess(target)
end

SNH.getBestStealTarget = function()
	local pack = SNH.getBestStealGarden()
	if pack and pack.targets and pack.targets[1] then
		return pack.targets[1], pack.owner, pack.bestTreeValue or pack.targets[1].value
	end
	return nil, nil, -1
end
end

do --[[ SNH: StealRun ]]
SNH.tryNightSteal = function()
	if not SNH.isStealAllowed() or not Networking or stealActive or SNH.isActionPausedForSeedSnipe() then
		return false
	end
	SNH.ensureInsideOwnGardenAtNight()
	if not STEAL_SCAN_GARDENS then
		return false
	end
	local loopStart = tick()

	if LocalPlayer:GetAttribute("IsStealingFruit") or LocalPlayer:GetAttribute("CarryingStolenFruit") then
		SNH.setStealFloat(true)
		SNH.flushInProgressStealAtHome()
		SNH.setStealFloat(false)
		return false
	end

	stealActive = true
	local stolen = 0
	local ok, err = pcall(function()
		local pack = STEAL_BURST_ALL and SNH.getBestStealGarden() or nil
		local target, owner, score

		if pack then
			owner = pack.owner
			score = pack.totalValue
		else
			target, owner, score = SNH.getBestStealTarget()
			if target then
				pack = {
					targets = { target },
					ownerUserId = target.ownerUserId,
					owner = owner,
					garden = { plot = target.ownerPlot },
					totalValue = score or target.value or 0,
				}
			end
		end

		if not pack or #pack.targets == 0 then
			return
		end

		if SNH.shouldFleeSteal(pack) then
			SNH.fleeStealToHome("owner returned / garden locked")
			return
		end

		local ownerLabel = owner and (owner.DisplayName or owner.Name)
			or ("User " .. tostring(pack.ownerUserId))
		local treeLabel = pack.bestTreeSeed or (pack.targets[1] and pack.targets[1].seedName) or "tree"
		local treeValue = pack.bestTreeValue or score or pack.totalValue or 0
		SNH.setStatus(("STEALING HIGHEST FRUIT (%s VALUE) FROM %s..."):format(
			SNH.formatAbbrev(treeValue), ownerLabel))

		local got = SNH.burstStealGarden(pack)
		if got > 0 then
			stolen = got
			for _, t in pack.targets do
				if not SNH.fruitStillThere(t) then
					stealSkip[SNH.stealKey(t)] = nil
				else
					stealSkip[SNH.stealKey(t)] = tick() + 4
				end
			end
			lastSuccessfulSteal = {
				seedName = got > 1 and ("%dx %s"):format(got, treeLabel)
					or (pack.targets[1] and pack.targets[1].seedName or treeLabel or "Fruit"),
				value = treeValue,
				ownerName = ownerLabel,
			}
			print(("[So Nach Hup] Stole %d fruit from %s | top %s (%s)"):format(
				got, ownerLabel, treeLabel, SNH.formatAbbrev(treeValue)))
		else
			for _, t in pack.targets do
				stealSkip[SNH.stealKey(t)] = tick() + 6
			end
			SNH.setStatus("Steal failed — retry next trip")
		end
	end)
	if not ok then
		warn(("[So Nach Hup] Steal loop error: %s"):format(tostring(err)))
	end

	SNH.setStealFloat(false)
	local _, ownPlot = API.getLocalPlot()
	local homePos = ownPlot and SNH.getGardenInteriorPosition(ownPlot)
	local tpFn = SNH.getStealTpFn()
	local shouldHome, homeWhy = SNH.shouldReturnStealForInventory()
	if SNH.isStealCarryActive() or shouldHome or SNH.shouldFleeStealLowHealth() then
		if homePos and tpFn then tpFn(homePos) end
		SNH.flushInProgressStealAtHome()
	elseif not stealInVictimGarden then
		SNH.ensureInsideOwnGardenAtNight()
	end
	stealActive = false
	SNH.debugLog("STEAL", ("loop done stolen=%d elapsed=%.2fs home=%s"):format(
		stolen, tick() - loopStart, tostring(homeWhy or "stay")), "force")
	return stolen > 0
end
end
tryNightSteal = SNH.tryNightSteal
scanMutationSpawns = SNH.scanMutationSpawns
setupMutationSeedWatcher = SNH.setupMutationSeedWatcher

do --[[ SNH: Farm ]]
SNH.getNextExpansionPrice = function()
	local owned = API.getOwnedExpansions()
	local nextData = ExpansionPrices[owned + 1]
	if not nextData then return nil, owned end
	return nextData.Price or nextData.price, owned
end

SNH.tryExpandPlot = function()
	if not AUTO_EXPAND or not Networking or not Networking.Actions then return false end
	if SNH.isActionPausedForSeedSnipe() then return false end
	if SNH.isMaxExpansionReached() then return false end
	local _, plot = API.getLocalPlot()
	if EXPAND_ONLY_AT_PLANT_CAP then
		if not plot then return false end
		if SNH.countPlants(plot) < SNH.getPlantCapLimit() then
			return false
		end
	end
	local now = tick()
	if now - lastExpandAt < EXPAND_CHECK_GAP then return false end
	if now - lastExpandFailAt < EXPAND_CHECK_GAP then return false end
	if LocalPlayer:GetAttribute("LoadingScreenActive") then return false end
	if LocalPlayer:GetAttribute("IsStealingFruit") or LocalPlayer:GetAttribute("CarryingStolenFruit") then
		return false
	end
	local price, owned = SNH.getNextExpansionPrice()
	if not price then return false end
	if API.getSheckles() < price then
		lastExpandFailAt = now
		return false
	end
	lastExpandAt = now
	SNH.setStatus(("Expanding plot %d → %d"):format(owned, owned + 1))
	local ok, success = pcall(function()
		return Networking.Actions.ExpandGarden:Fire()
	end)
	if ok and success then
		plantCapModeActive = false
		print(("[So Nach Hup] Expanded plot to %d (cap now %d seeds)"):format(
			owned + 1, SNH.getMaxSeedsForExpansionLevel(owned + 1)))
		SNH.setStatus(("Expanded to %d/%d | cap %d seeds"):format(
			owned + 1, MAX_EXPANSIONS, SNH.getMaxSeedsForExpansionLevel(owned + 1)))
		return true
	end
	lastExpandFailAt = now
	return false
end

SNH.plantBurst = function(force, onlySeedName, burstLimitOverride)
	if plantingActive and not force then return 0 end
	if not force and not SNH.canRunPlantWorker() then return 0 end
	if force and (not ENABLED or not AUTO_PLANT) then return 0 end
	if not Networking then Networking = API.getNetworking() end
	if not Networking or not Networking.Plant or not Networking.Plant.PlantSeed then return 0 end

	local _, plot = API.getLocalPlot()
	if not plot then return 0 end
	local status = SNH.getPlantSlotStatus(plot, true)
	if status.room <= 0 then return 0 end

	SNH.ensureInsideOwnPlotForPlanting()

	local work = SNH.buildPlantWorkQueue(plot, onlySeedName)
	if #work == 0 then return 0 end

	plantingActive = true
	local planted = 0
	local burstLimit = math.min(
		math.max(1, tonumber(burstLimitOverride) or PLANT_BURST_LIMIT),
		status.room
	)
	if burstLimit <= 0 then
		plantingActive = false
		return 0
	end
	local plantedCache = {}
	local toolIndex = {}

	for _, job in work do
		plantedCache[job.seedName] = job.planted
		toolIndex[job.seedName] = 1
	end

	local jobIdx = 1
	local failStreak = 0

	while planted < burstLimit do
		if SNH.getRemainingPlantSlots(plot, true) <= 0 then break end
		local job = work[jobIdx]
		if not job then break end

		if plantedCache[job.seedName] >= job.target then
			jobIdx += 1
			failStreak = 0
			continue
		end

		local tools = job.tools
		local ti = toolIndex[job.seedName] or 1
		while ti <= #tools and not tools[ti].Parent do
			ti += 1
		end
		if ti > #tools then
			job.tools = SNH.listSeedTools(job.seedName)
			tools = job.tools
			ti = 1
			toolIndex[job.seedName] = 1
			if #tools == 0 then
				jobIdx += 1
				continue
			end
		end

		local tool = tools[ti]
		if not tool or not tool.Parent then
			toolIndex[job.seedName] = ti + 1
			continue
		end

		local pos = SNH.getRandomPlantPosition(plot)
		if not pos then break end

		local equipped = SNH.equipSeedToolFast(tool)
		if not equipped then
			toolIndex[job.seedName] = ti + 1
			continue
		end

		if SNH.firePlantRemote(pos, job.seedName, equipped) then
			-- Only count success when the seed tool was consumed (server accepted plant).
			if not tool.Parent then
				planted += 1
				plantedCache[job.seedName] += 1
				plantCountCache.time = 0
				failStreak = 0
				if PLANT_CHUNK > 0 and planted % PLANT_CHUNK == 0 then
					RunService.Heartbeat:Wait()
				end
			elseif SNH.getRemainingPlantSlots(plot, true) <= 0 then
				break
			else
				failStreak += 1
				if failStreak >= 4 then break end
			end
		else
			failStreak += 1
			if failStreak >= 8 then break end
		end

		if not tool.Parent then
			toolIndex[job.seedName] = ti + 1
		end

		if plantedCache[job.seedName] >= job.target then
			jobIdx += 1
		end
	end

	plantingActive = false
	if planted > 0 then
		SNH.invalidatePlotScanCaches(plot)
		SNH.setStatus(("Planted %d seeds (remote burst)"):format(planted))
		print(("[So Nach Hup] Planted %d seed(s)"):format(planted))
	end
	return planted
end

SNH.startPlantLoop = function()
	if USE_UNIFIED_SCHEDULER then return end
	local lastPlantDebugAt = 0
	task.spawn(function()
		while running do
			local _, plot = API.getLocalPlot()
			local canFill = SNH.canRunPlantWorker() and plot and SNH.getRemainingPlantSlots(plot, true) > 0
			local canMaintain = SNH.needsPlantCapMaintenance(plot)
			if (canFill or canMaintain) and not plantWorkerRunning then
				plantWorkerRunning = true
				task.spawn(function()
					pcall(function()
						if not plot then return end
						local status = SNH.getPlantSlotStatus(plot, true)
						if status.room <= 0 then
							if AUTO_EXPAND and not SNH.isMaxExpansionReached() and SNH.tryExpandPlot() then
								return
							end
							if SNH.shouldBuyPetSlots() and AUTO_BUY_PET_SLOT then
								SNH.tryBuyPetSlot()
								return
							end
							if AUTO_PLANT_UPGRADE then
								if SNH.canUpgradePlantAtCap(plot) then
									SNH.tryUpgradeGardenPlant(false)
									return
								end
								if SNH.needsUpgradeSeedBuy(plot) and SNH.canBuyUpgradeSeedNow(plot) then
									if SNH.tryBuyUpgradeSeed(plot) > 0 then
										SNH.tryUpgradeGardenPlant(false)
									end
									return
								end
							end
							local now = tick()
							if now - lastPlantDebugAt >= 15 then
								lastPlantDebugAt = now
								print(("[So Nach Hup] At cap %d/%d (exp %d): %s"):format(
									status.count, status.cap, status.expansions,
									SNH.debugPlantStatus(plot)))
							end
							return
						end
						local work = SNH.buildPlantWorkQueue(plot)
						if #work == 0 then
							local now = tick()
							if now - lastPlantDebugAt >= 15 then
								lastPlantDebugAt = now
								print(("[So Nach Hup] Fill slots %d/%d: %s"):format(
									status.count, status.cap, SNH.debugPlantStatus(plot)))
							end
							return
						end
						for _, job in work do
							if not SNH.canRunPlantWorker() then break end
							if SNH.getRemainingPlantSlots(plot, true) <= 0 then break end
							while SNH.canRunPlantWorker() and SNH.getRemainingPlantSlots(plot, true) > 0 do
								if not SNH.hasSeedPlantWorkRemaining(plot, job.seedName) then break end
								local planted = SNH.plantBurst(false, job.seedName, PLANT_BURST_LIMIT)
								if planted <= 0 then break end
								if PLANT_BURST_GAP > 0 then task.wait(PLANT_BURST_GAP) end
							end
						end
					end)
					plantWorkerRunning = false
				end)
			end
			task.wait(PLANT_GAP > 0 and PLANT_GAP or 0.1)
		end
	end)
end

SNH.startSellLoop = function()
	if USE_UNIFIED_SCHEDULER then return end
	task.spawn(function()
		while running do
			if ENABLED and AUTO_SELL and not SNH.isActionPausedForSeedSnipe() then
				if not Networking then Networking = API.getNetworking() end
				pcall(SNH.trySellInventory)
			end
			task.wait(SELL_LOOP_GAP > 0 and SELL_LOOP_GAP or 1.5)
		end
	end)
end

SNH.startSeedSnipePriorityLoop = function()
	if USE_UNIFIED_SCHEDULER then return end
	task.spawn(function()
		while running do
			if ENABLED and AUTO_SNIPE_MUTATION_SEEDS then
				pcall(SNH.runSeedSnipePriority)
			end
			task.wait(SNH.isActionPausedForSeedSnipe() and 0.04 or 0.2)
		end
	end)
end

SNH.startPetUnequipWeakLoop = function()
	task.spawn(function()
		while running do
			if ENABLED and AUTO_EQUIP_BEST_PET then
				if not Networking then Networking = API.getNetworking() end
				if Networking and Networking.Pets then
					pcall(function()
						SNH.tryEquipBestPets(true, "unequipOnly")
					end)
				end
			end
			task.wait((PET_EQUIP_GAP and PET_EQUIP_GAP > 0 and math.max(0.5, PET_EQUIP_GAP) or 1))
		end
	end)
end

SNH.startPetEquipLoop = function()
	task.spawn(function()
		local firstRunDone = false
		while running do
			if ENABLED and AUTO_EQUIP_BEST_PET then
				if not Networking then Networking = API.getNetworking() end
				if Networking and Networking.Pets then
					pcall(function()
						SNH.ensureBestPetsEquipped()
					end)
					firstRunDone = true
				end
			end
			local gap = firstRunDone and PET_EQUIP_GAP or 1
			local empty = select(1, SNH.countEmptyPetSlots())
			if empty > 0 then
				gap = math.min(gap > 0 and gap or 1, 3)
			end
			task.wait(gap > 0 and gap or 100)
		end
	end)
end

SNH.requestPetEquip = function()
	if not ENABLED or not AUTO_EQUIP_BEST_PET then return end
	if SNH.isActionPausedForSeedSnipe() then return end
	task.spawn(function()
		pcall(SNH.ensureBestPetsEquipped)
	end)
end

SNH.startPetEnsureLoop = function()
	if USE_UNIFIED_SCHEDULER then return end
	task.spawn(function()
		task.defer(SNH.requestPetEquip)
		while running do
			local gap = tonumber(PET_RARITY_LOOP_GAP) or 60
			if AUTO_EQUIP_BEST_PET then
				local maxSlots = SNH.getMaxPetSlots and SNH.getMaxPetSlots() or 2
				local equipped = SNH.getEquippedPetEntries()
				local desired, desiredByKey = SNH.buildDesiredPetLoadout(maxSlots)
				local empty = select(1, SNH.countEmptyPetSlots())
				if empty > 0 or not SNH.isPetLoadoutSatisfied(equipped, desiredByKey, maxSlots) then
					gap = math.min(gap, empty > 0 and 3 or 8)
				end
			end
			task.wait(gap)
			SNH.requestPetEquip()
		end
	end)
end

SNH.startWildPetLoop = function()
	if USE_UNIFIED_SCHEDULER then return end
	task.spawn(function()
		task.defer(function()
			if ENABLED and AUTO_BUY_WILD_PET and not SNH.isWildPetBuyPaused() then
				SNH.loopBuyWildPet()
			end
		end)
		while running do
			if ENABLED and AUTO_BUY_WILD_PET and not SNH.isWildPetBuyPaused() then
				SNH.loopBuyWildPet()
			end
			task.wait(math.max(0.25, WILD_PET_BUY_GAP or 0.5))
		end
	end)
end

SNH.tickPlantLoop = function()
	if plantWorkerRunning or not SNH.canRunPlantWorker() then return end
	local _, plot = API.getLocalPlot()
	if not plot then return end
	if AUTO_EXPAND and not SNH.isMaxExpansionReached() and SNH.tryExpandPlot() then return end
	if AUTO_BUY_PET_SLOT and SNH.shouldBuyPetSlots() and SNH.tryBuyPetSlot() then return end
	local canFill = SNH.getRemainingPlantSlots(plot, true) > 0
	local canMaintain = SNH.needsPlantCapMaintenance(plot)
	if not canFill and not canMaintain then return end
	plantWorkerRunning = true
	task.spawn(function()
		local lastPlantDebugAt = 0
		pcall(function()
			local status = SNH.getPlantSlotStatus(plot, true)
			if status.room <= 0 then
				if AUTO_EXPAND and not SNH.isMaxExpansionReached() and SNH.tryExpandPlot() then
					return
				end
				if SNH.shouldBuyPetSlots() and AUTO_BUY_PET_SLOT then
					SNH.tryBuyPetSlot()
					return
				end
				if AUTO_PLANT_UPGRADE then
					if SNH.canUpgradePlantAtCap(plot) then
						SNH.tryUpgradeGardenPlant(false)
						return
					end
					if SNH.needsUpgradeSeedBuy(plot) and SNH.canBuyUpgradeSeedNow(plot) then
						if SNH.tryBuyUpgradeSeed(plot) > 0 then
							SNH.tryUpgradeGardenPlant(false)
						end
						return
					end
				end
				local now = tick()
				if now - lastPlantDebugAt >= 15 then
					lastPlantDebugAt = now
					print(("[So Nach Hup] At cap %d/%d (exp %d): %s"):format(
						status.count, status.cap, status.expansions, SNH.debugPlantStatus(plot)))
				end
				return
			end
			local work = SNH.buildPlantWorkQueue(plot)
			if #work == 0 then
				local now = tick()
				if now - lastPlantDebugAt >= 15 then
					lastPlantDebugAt = now
					print(("[So Nach Hup] Fill slots %d/%d: %s"):format(
						status.count, status.cap, SNH.debugPlantStatus(plot)))
				end
				return
			end
			for _, job in work do
				if not SNH.canRunPlantWorker() then break end
				if SNH.getRemainingPlantSlots(plot, true) <= 0 then break end
				while SNH.canRunPlantWorker() and SNH.getRemainingPlantSlots(plot, true) > 0 do
					if not SNH.hasSeedPlantWorkRemaining(plot, job.seedName) then break end
					local planted = SNH.plantBurst(false, job.seedName, PLANT_BURST_LIMIT)
					if planted <= 0 then break end
					if PLANT_BURST_GAP > 0 then task.wait(PLANT_BURST_GAP) end
				end
			end
		end)
		plantWorkerRunning = false
	end)
end

SNH.registerSchedulerJob = function(id, interval, fn, opts)
	opts = opts or {}
	SNH.schedulerJobs = SNH.schedulerJobs or {}
	SNH.schedulerJobs[id] = {
		interval = interval,
		fn = fn,
		nextAt = tick(),
		allowDuringSnipe = opts.allowDuringSnipe == true,
		when = opts.when,
	}
end

SNH.initUnifiedScheduler = function()
	SNH.schedulerJobs = {}
	local function ready()
		return ENABLED and API.ready and not SNH.isActionPausedForSeedSnipe()
	end
	SNH.registerSchedulerJob("Harvest", function()
		return math.max(0.1, tonumber(COLLECT_GAP) or 0.5)
	end, SNH.tickHarvestLoop, { when = function()
		return ENABLED and AUTO_COLLECT and API.ready
	end })
	SNH.registerSchedulerJob("HarvestPrompts", function() return 0.15 end, function()
		if AUTO_COLLECT and HARVEST_PROMPT_MAINTAIN then
			SNH.maintainLocalHarvestPrompts()
		end
	end, { when = function() return ENABLED and AUTO_COLLECT end })
	SNH.registerSchedulerJob("Sell", function()
		return math.max(0.5, tonumber(SELL_LOOP_GAP) or 1.5)
	end, function()
		SNH.ensureNetworking()
		SNH.trySellInventory()
	end, { when = function() return ready() and AUTO_SELL end })
	SNH.registerSchedulerJob("Plant", function()
		return math.max(0.05, tonumber(PLANT_GAP) or 0.1)
	end, SNH.tickPlantLoop, { when = function() return ready() and AUTO_PLANT end })
	SNH.registerSchedulerJob("BuySeed", function()
		return math.max(0.2, tonumber(SHOP_BUY_GAP) or 0.5)
	end, function()
		if AUTO_BUY_SEED then SNH.loopBuySeeds() end
	end, { when = ready })
	SNH.registerSchedulerJob("BuyGear", function()
		return math.max(0.2, tonumber(SHOP_BUY_GAP) or 0.5)
	end, function()
		if AUTO_BUY_GEAR then SNH.loopBuyGear() end
	end, { when = ready })
	SNH.registerSchedulerJob("UseGear", function()
		return math.max(0.2, tonumber(GEAR_USE_GAP) or 0.5)
	end, function()
		if AUTO_USE_GEAR then SNH.loopUseGear() end
	end, { when = ready })
	SNH.registerSchedulerJob("UseSeedPacks", function()
		return math.max(0.2, tonumber(SEED_PACK_OPEN_GAP) or 0.25)
	end, function()
		if AUTO_USE_SEED_PACKS then SNH.useAllInventorySeedPacks() end
	end, { when = function() return ENABLED and API.ready and not SNH.isActionPausedForSeedSnipe() end })
	SNH.registerSchedulerJob("WildPet", function()
		return math.max(0.25, tonumber(WILD_PET_BUY_GAP) or 0.5)
	end, function()
		if AUTO_BUY_WILD_PET then SNH.loopBuyWildPet() end
	end, { when = function() return ENABLED and AUTO_BUY_WILD_PET and not SNH.isWildPetBuyPaused() end })
	SNH.registerSchedulerJob("PetEnsure", function()
		local gap = tonumber(PET_RARITY_LOOP_GAP) or 60
		if AUTO_EQUIP_BEST_PET then
			local maxSlots = SNH.getMaxPetSlots and SNH.getMaxPetSlots() or 2
			local equipped = SNH.getEquippedPetEntries()
			local desired, desiredByKey = SNH.buildDesiredPetLoadout(maxSlots)
			local empty = select(1, SNH.countEmptyPetSlots())
			if empty > 0 or not SNH.isPetLoadoutSatisfied(equipped, desiredByKey, maxSlots) then
				gap = math.min(gap, empty > 0 and 3 or 8)
			end
		end
		return gap
	end, function()
		if AUTO_EQUIP_BEST_PET then SNH.requestPetEquip() end
	end, { when = function() return ENABLED end })
	SNH.registerSchedulerJob("BuyPetSlot", function()
		return math.max(15, tonumber(PET_SLOT_BUY_GAP) or 45)
	end, function()
		if AUTO_BUY_PET_SLOT then SNH.tryBuyPetSlot() end
	end, { when = function() return ENABLED and API.ready end })
	SNH.registerSchedulerJob("AutoMail", function()
		return math.max(3, tonumber(autoMailState.gap) or 20)
	end, function()
		if AUTO_MAIL_SEND then SNH.tryAutoMailSend() end
	end, { when = function() return ENABLED and API.ready end })
	SNH.registerSchedulerJob("Expand", function()
		return math.max(5, tonumber(EXPAND_CHECK_GAP) or 30)
	end, function()
		if AUTO_EXPAND then SNH.loopExpand() end
	end, { when = ready })
	SNH.registerSchedulerJob("MutationSnipe", function()
		if not SEED_SNIPE_PAUSE_ALL and AUTO_COLLECT then
			return math.max(0.1, tonumber(COLLECT_GAP) or 0.5)
		end
		return SNH.isActionPausedForSeedSnipe() and 0.04 or 0.2
	end, function()
		if AUTO_SNIPE_MUTATION_SEEDS then SNH.runSeedSnipePriority() end
	end, { when = function()
		return ENABLED and (SEED_SNIPE_PAUSE_ALL or AUTO_COLLECT)
	end, allowDuringSnipe = true })
	SNH.registerSchedulerJob("DayGardenStay", function()
		return math.max(0.35, tonumber(GARDEN_STAY_GAP) or 0.6)
	end, function()
		SNH.loopDayGardenStay()
	end, { when = function()
		return ENABLED and API.ready and SNH.shouldStayInOwnGardenAtDay()
	end })
	SNH.registerSchedulerJob("NightGardenTP", function() return 0.5 end, function()
		if SNH.isStealAllowed() then
			SNH.ensureInsideOwnGardenAtNight()
		end
	end, { when = function() return ENABLED end, allowDuringSnipe = true })
	SNH.registerSchedulerJob("NightSteal", function()
		return SNH.isStealAllowed() and STEAL_GAP or 1
	end, function()
		if SNH.isStealAllowed() then SNH.loopNightSteal() end
	end, { when = function() return ENABLED and API.ready end, allowDuringSnipe = true })
	SNH.registerSchedulerJob("DisableAllEffects", function()
		local gap = tonumber(DISABLE_ALL_EFFECTS_GAP) or 0
		return gap > 0 and math.max(5, gap) or 999999
	end, function()
		SNH.loopDisableAllEffects()
	end, { when = function()
		local gap = tonumber(DISABLE_ALL_EFFECTS_GAP) or 0
		return DISABLE_ALL_EFFECTS and gap > 0
	end, allowDuringSnipe = true })
	SNH.registerSchedulerJob("Hud", function()
		return math.max(0.5, tonumber(HUD_REFRESH_GAP) or 2)
	end, function()
		if SHOW_HUD then SNH.refreshHud() end
	end, { when = function() return true end, allowDuringSnipe = true })
end

SNH.startUnifiedScheduler = function()
	if SNH.schedulerRunning then return end
	SNH.initUnifiedScheduler()
	SNH.schedulerRunning = true
	task.defer(SNH.requestPetEquip)
	task.spawn(function()
		local pruneAt = tick()
		while running do
			local now = tick()
			if now - pruneAt >= 60 then
				pruneAt = now
				pcall(SNH.pruneRuntimeCaches)
			end
			if ENABLED and API.ready then
				local paused = SNH.isActionPausedForSeedSnipe()
				for _, job in pairs(SNH.schedulerJobs) do
					if now >= job.nextAt then
						local interval = type(job.interval) == "function" and job.interval() or job.interval
						job.nextAt = now + math.max(0.05, tonumber(interval) or 1)
						local shouldRun = true
						if job.when and not job.when() then shouldRun = false end
						if paused and not job.allowDuringSnipe then shouldRun = false end
						if shouldRun then
							local ok, err = pcall(job.fn)
							if not ok then
								warn(("[So Nach Hup][scheduler] %s"):format(tostring(err)))
							end
						end
					end
				end
			end
			task.wait(SCHEDULER_TICK or 0.15)
		end
		SNH.schedulerRunning = false
	end)
end

SNH.safeLoop = function(label, interval, fn)
	task.spawn(function()
		while running do
			if ENABLED and API.ready and not SNH.isActionPausedForSeedSnipe() then
				local ok, err = pcall(fn)
				if not ok then
					warn(("[So Nach Hup][%s] %s"):format(label, tostring(err)))
				end
			end
			local waitTime = type(interval) == "function" and interval() or interval
			task.wait(tonumber(waitTime) or 1)
		end
	end)
end

SNH.loopBuySeeds = function()
	if SNH.isActionPausedForSeedSnipe() then return end
	if not Networking or stealActive or seedSnipeActive then return end
	local _, plot = API.getLocalPlot()
	if plot and SNH.isPlantCapReached(plot, true) then
		if AUTO_PLANT_UPGRADE and SNH.needsUpgradeSeedBuy(plot) then
			SNH.tryBuyUpgradeSeed(plot)
		end
		return
	end
	SNH.tryBuySeeds()
end

SNH.loopBuyGear = function()
	if SNH.isActionPausedForSeedSnipe() then return end
	if not Networking or stealActive or seedSnipeActive then return end
	SNH.tryBuyGear()
end

SNH.loopUseGear = function()
	if SNH.isActionPausedForSeedSnipe() then return end
	if stealActive or seedSnipeActive or gearPlacingActive then return end
	SNH.tryUseGear()
end

SNH.loopBuyWildPet = function()
	if SNH.isWildPetBuyPaused() then return end
	if not AUTO_BUY_WILD_PET then return end
	if wildPetBuying then return end
	SNH.ensureNetworking()
	task.spawn(function()
		pcall(SNH.tryBuyWildPet)
	end)
end

SNH.loopExpand = function()
	SNH.tryExpandPlot()
end

SNH.startHarvestLoop = function()
	if USE_UNIFIED_SCHEDULER then return end
	SNH.startHarvestPromptMaintainLoop()
	task.spawn(function()
		while running do
			if ENABLED and AUTO_COLLECT and not SNH.isActionPausedForSeedSnipe() then
				SNH.tickHarvestLoop()
			end
			task.wait(math.max(0.1, tonumber(COLLECT_GAP) or 0.5))
		end
	end)
end

SNH.loopNightSteal = function()
	if not Networking then return end
	SNH.tryNightSteal()
end

SNH.startLagProbeLoop = function()
	if not DEBUG_LAG_PROBE then return end
	task.spawn(function()
		local lastBeat = tick()
		while running do
			RunService.Heartbeat:Wait()
			local now = tick()
			local dt = now - lastBeat
			lastBeat = now
			if dt > 0.12 then
				SNH.debugLog("STEAL", ("heartbeat spike %.3fs steal=%s seedSnipe=%s wildPet=%s"):format(
					dt, tostring(stealActive), tostring(seedSnipeActive), tostring(wildPetBuying)
				), "warn")
			end
		end
	end)
end
end
plantSeeds = SNH.plantBurst
sellInventory = SNH.trySellInventory
tryExpandPlot = SNH.tryExpandPlot
safeLoop = SNH.safeLoop

do --[[ SNH: StagedStartup ]]
stagedState = { index = 0, total = 0, stages = {}, running = false, advance = false, done = false }

-- Measure frame health over a window: average FPS, worst single-frame stall, memory.
SNH.sampleLag = function(seconds)
	seconds = tonumber(seconds) or 3
	local samples, sumDt, maxDt = 0, 0, 0
	local last = tick()
	local deadline = last + seconds
	local conn = RunService.Heartbeat:Connect(function()
		local now = tick()
		local dt = now - last
		last = now
		samples += 1
		sumDt += dt
		if dt > maxDt then maxDt = dt end
	end)
	while tick() < deadline and running do RunService.Heartbeat:Wait() end
	if conn then conn:Disconnect() end
	local avgDt = samples > 0 and sumDt / samples or 0
	return {
		avgFps = avgDt > 0 and (1 / avgDt) or 0,
		maxDt = maxDt,
		samples = samples,
		mem = SNH.getClientMemoryMb and SNH.getClientMemoryMb() or 0,
	}
end

SNH.activateStage = function(stage)
	if not stage then return end
	print(("[STAGED] >>> Activating %d/%d: %s"):format(stagedState.index, stagedState.total, stage.name))
	SNH.setStatus(("Staged %d/%d: %s"):format(stagedState.index, stagedState.total, stage.name))
	local before = SNH.sampleLag(2)
	local ok, err = pcall(stage.start)
	if not ok then
		warn(("[STAGED] %s start ERROR: %s"):format(stage.name, tostring(err)))
	end
	local after = SNH.sampleLag(math.max(3, STAGED_START_GAP))
	local fpsDrop = before.avgFps - after.avgFps
	local memDelta = after.mem - before.mem
	local flag = ""
	if after.maxDt >= 0.2 or fpsDrop >= 8 or memDelta >= 150 then
		flag = "   <<<<< LAG SUSPECT"
	end
	print(("[STAGED] %-16s | FPS %3.0f->%3.0f (drop %3.0f) | worstStall %4.0fms | mem %5.0f->%5.0f MB (%+.0f)%s"):format(
		stage.name, before.avgFps, after.avgFps, fpsDrop, after.maxDt * 1000,
		before.mem, after.mem, memDelta, flag))
end

SNH.nextStage = function()
	stagedState.advance = true
end

SNH.stageStatus = function()
	print(("[STAGED] %d/%d done=%s running=%s auto=%s gap=%.0fs"):format(
		stagedState.index, stagedState.total, tostring(stagedState.done),
		tostring(stagedState.running), tostring(STAGED_START_AUTO), STAGED_START_GAP))
end

SNH.runStagedStartup = function(stages)
	stagedState.stages = stages
	stagedState.total = #stages
	stagedState.index = 0
	stagedState.running = true
	stagedState.done = false
	print(("[STAGED] ===== Staged startup: %d stages, gap %.0fs, auto=%s ====="):format(
		#stages, STAGED_START_GAP, tostring(STAGED_START_AUTO)))
	print("[STAGED] Watch the 'LAG SUSPECT' tag. Manual mode: _G.SoNachHup.NextStage()")
	task.spawn(function()
		for i, stage in ipairs(stages) do
			if not running then break end
			stagedState.index = i
			SNH.activateStage(stage)
			if not STAGED_START_AUTO and i < #stages then
				stagedState.advance = false
				print("[STAGED] Paused — call _G.SoNachHup.NextStage() to activate the next one.")
				repeat task.wait(0.2) until stagedState.advance or not running
			end
		end
		stagedState.done = true
		stagedState.running = false
		print("[STAGED] ===== All stages activated =====")
		SNH.setStatus("Running kaitun (staged complete)")
	end)
end
end

do --[[ SNH: Start ]]
-- ===== Start =====
local function runStartup()
SNH.showStartupLoading()
SNH.setStatus("LOADING SCRIPT")
print(("[%s] Loading..."):format(SCRIPT_NAME))

if BOOT.autoWaitGameLoad then
	SNH.setStatus("Waiting for game load...")
	local loaded = SNH.waitForInitialLoad(BOOT.gameLoadTimeout)
	SNH.hideStartupLoadingText()
	if loaded then
		print("[So Nach Hup] Game load complete — starting script")
	else
		warn("[So Nach Hup] Game load timeout")
		if BOOT.requireFullLoad then
			SNH.setStatus("Blocked — game not fully loaded")
			SNH.hideStartupLoadingText()
			warn("[So Nach Hup] Startup blocked (RequireFullLoad=true). Increase GameLoadTimeout or set RequireFullLoad=false.")
			return
		end
		warn("[So Nach Hup] Continuing with partial readiness")
	end
else
	API.init(30)
	SNH.loadShopCatalog()
	SNH.loadPetCatalog()
	SNH.hideStartupLoadingText()
end

if not API.ready then
	API.init(30)
end
Networking = API.getNetworking()
SNH.ensureCatalogsLoaded()
SNH.registerGuiRecreate("hud", SNH.setupHud)
SNH.registerGuiRecreate("black", SNH.setupBlackScreenToggle)
SNH.setupAntiAfk()
SNH.setupBlackScreenToggle()
-- Apply FPS cap from config (0 = uncapped). Set via ["Fps"]/["TargetFps"] or Set("TargetFps", n).
if PERF.targetFps and PERF.targetFps > 0 then
	SNH.applyFpsCapOnce()
	print(("[So Nach Hup] FPS cap set to %d"):format(PERF.targetFps))
end
-- Ultimate optimize is activated via the startup stages list below (UltimateOptimize
-- stage), in both normal and staged modes, so it runs exactly once.
pcall(function()
	local sharedData = ReplicatedStorage:WaitForChild("SharedData", 5)
	if sharedData then
		local prices = require(sharedData:WaitForChild("ExpansionPrices"))
		if type(prices) == "table" and #prices > 0 then
			ExpansionPrices = prices
		end
	end
end)
SNH.loadShopCatalog()
SNH.loadPetCatalog()
SNH.setupShopStockWatchers()
SNH.setupShopRestockListeners()
SNH.setupWildPetWebhooks()
SNH.setupMailboxListener()
SNH.setupGiftListener()
	SNH.setupMutationSeedWatcher()
	SNH.setupStealNotificationHook()
	SNH.setupTeleportBackHook()
	SNH.setupHarvestPhaseReset()
	task.defer(function()
		task.wait(0.5)
		SNH.setupHud()
		SNH.startGuiProtectWatchdog()
		if SHOW_HUD then
			pcall(SNH.refreshHud)
		end
	end)
	SNH.startTutorialAutoCompleteLoop()
SNH.startLagProbeLoop()

if DEBUG_GEAR or DEBUG_WILD_PET then
	print(("[So Nach Hup] Debug ON — Gear=%s WildPet=%s (throttle=%.1fs)"):format(
		tostring(DEBUG_GEAR), tostring(DEBUG_WILD_PET), DEBUG_THROTTLE))
	print("[So Nach Hup] Commands: _G.SoNachHup.DumpGearDebug() | DumpWildPetDebug()")
	task.defer(function()
		if DEBUG_GEAR then SNH.dumpGearDebug() end
		if DEBUG_WILD_PET then SNH.dumpWildPetDebug() end
	end)
end

print(("[So Nach Hup] Shop | AutoBuySeed=%s AutoBuyGear=%s | Carrot stock=%d bought=%d left=%d price=%d sheckles=%s"):format(
	tostring(AUTO_BUY_SEED),
	tostring(AUTO_BUY_GEAR),
	select(2, SNH.getShopStockBreakdown("Carrot", "SeedShop", { "SeedShop", "Seeds" })),
	SNH.getSeedPurchased("Carrot"),
	SNH.getSeedStock("Carrot"),
	SNH.getSeedPrice("Carrot"),
	SNH.formatAbbrev(API.getSheckles())
))

print(("[So Nach Hup] Wild pet | AutoBuy=%s config=%s loop=%.2fs"):format(
	tostring(AUTO_BUY_WILD_PET),
	tostring(SNH.configHasBuyEntries(BuyPetsConfig)),
	WILD_PET_BUY_GAP or 0.5))

print(("[So Nach Hup] Server: %s | AutoSteal=%s"):format(
	SERVER_KIND or API.getServerKind(),
	tostring(AUTO_STEAL)))

print("[So Nach Hup] Ready")

-- Each subsystem as a discrete stage so staged-debug can activate them one-by-one.
-- (Ultimate optimize removed — no plant/VFX hiding, FPS cap, or graphics downgrades.)
local startupStages = {
	{ name = "DisableControllers", start = function()
		if DISABLE_GAME_CONTROLLERS and #DISABLE_GAME_CONTROLLERS > 0 then
			SNH.disableGameControllers(DISABLE_GAME_CONTROLLERS)
		end
		if DISABLE_ALL_EFFECTS then
			SNH.setupDisableAllEffects()
		end
		if AUTO_INSTANT_PROMPTS then
			SNH.setupInstantPromptHooks()
		end
		pcall(SNH.setupClientVisualOptimize)
	end },
	{ name = "UnifiedScheduler", start = function()
		if USE_UNIFIED_SCHEDULER then
			SNH.startUnifiedScheduler()
			return
		end
		if DISABLE_ALL_EFFECTS and (tonumber(DISABLE_ALL_EFFECTS_GAP) or 0) > 0 then
			SNH.safeLoop("DisableAllEffects", function()
				return math.max(5, tonumber(DISABLE_ALL_EFFECTS_GAP) or 5)
			end, function()
				SNH.loopDisableAllEffects()
			end)
		end
		if SHOW_HUD then
			task.spawn(function()
				while running do
					pcall(SNH.refreshHud)
					task.wait(HUD_REFRESH_GAP > 0 and HUD_REFRESH_GAP or 1)
				end
			end)
		end
		SNH.startPetEnsureLoop()
		SNH.startWildPetLoop()
		SNH.safeLoop("BuyPetSlot", function()
			return math.max(15, tonumber(PET_SLOT_BUY_GAP) or 45)
		end, function()
			if AUTO_BUY_PET_SLOT and Networking then SNH.tryBuyPetSlot() end
		end)
		SNH.safeLoop("BuySeed", SHOP_BUY_GAP, function()
			if AUTO_BUY_SEED and Networking then SNH.loopBuySeeds() end
		end)
		SNH.safeLoop("BuyGear", SHOP_BUY_GAP, function()
			if AUTO_BUY_GEAR and Networking then SNH.loopBuyGear() end
		end)
		SNH.safeLoop("AutoMailSend", function()
			return math.max(3, tonumber(autoMailState.gap) or 20)
		end, function()
			if AUTO_MAIL_SEND and Networking then SNH.tryAutoMailSend() end
		end)
		SNH.safeLoop("UseGear", GEAR_USE_GAP, function()
			if AUTO_USE_GEAR then SNH.loopUseGear() end
		end)
		SNH.startPlantLoop()
		SNH.startSellLoop()
		SNH.startSeedSnipePriorityLoop()
		SNH.startHarvestLoop()
		SNH.safeLoop("Expand", EXPAND_CHECK_GAP, function()
			if AUTO_EXPAND then SNH.loopExpand() end
		end)
		SNH.safeLoop("DayGardenStay", function()
			return math.max(0.35, tonumber(GARDEN_STAY_GAP) or 0.6)
		end, function()
			SNH.loopDayGardenStay()
		end)
		SNH.safeLoop("NightGardenTP", 0.5, function()
			if SNH.isStealAllowed() then
				SNH.ensureInsideOwnGardenAtNight()
			end
		end)
		SNH.safeLoop("NightSteal", function()
			return SNH.isStealAllowed() and STEAL_GAP or 1
		end, function()
			if SNH.isStealAllowed() and Networking then SNH.loopNightSteal() end
		end)
	end },
}

if STAGED_START then
	SNH.runStagedStartup(startupStages)
else
	for _, stage in ipairs(startupStages) do
		local ok, err = pcall(stage.start)
		if not ok then warn(("[So Nach Hup] stage %s error: %s"):format(stage.name, tostring(err))) end
	end
	SNH.setStatus("Running kaitun")
end

_G.SoNachHup = {
	Stop = function()
		SNH.cleanupRuntime()
		SNH.setStatus("Stopped")
	end,
	Start = function()
		running = true
		if USE_UNIFIED_SCHEDULER and not SNH.schedulerRunning then
			SNH.startUnifiedScheduler()
		end
		SNH.setStatus("Running kaitun")
	end,
	API = API,
	RefreshHud = SNH.refreshHud,
	HarvestAll = function() return SNH.burstHarvestAll(true) end,
	burstHarvestAll = SNH.burstHarvestAll,
	gatherHarvestTargets = SNH.gatherAllHarvestTargets,
	PlantAll = function() return SNH.plantBurst(true) end,
	plantBurst = SNH.plantBurst,
	UseAllSeedPacks = SNH.useAllInventorySeedPacks,
	useAllInventorySeedPacks = SNH.useAllInventorySeedPacks,
	tryUpgradeGardenPlant = SNH.tryUpgradeGardenPlant,
	tryBuyPetSlot = SNH.tryBuyPetSlot,
	Set = function(key, value)
		if key == "Enabled" then ENABLED = value end
		if key == "AutoCollect" then AUTO_COLLECT = value ~= false end
		if key == "CollectMutationSeeds" then COLLECT_MUTATION_SEEDS = value ~= false end
		if key == "SeedSnipePauseAll" then SEED_SNIPE_PAUSE_ALL = value == true end
		if key == "AutoPlant" then AUTO_PLANT = value end
		if key == "AutoUseSeedPacks" or key == "UseSeedPacks" then
			AUTO_USE_SEED_PACKS = value ~= false
		end
		if key == "SeedPackOpenGap" and tonumber(value) then SEED_PACK_OPEN_GAP = tonumber(value) end
		if key == "UseSafeTeleport" then USE_SAFE_TELEPORT = value ~= false end
		if key == "SafeTeleportFallback" then SAFE_TELEPORT_FALLBACK_FAST = value ~= false end
		if key == "TeleportMode" and type(value) == "string" then TELEPORT_MODE = value end
		if key == "TeleportAvoidRawCFrame" then TELEPORT_AVOID_RAW_CFRAME = value ~= false end
		if key == "ShortHopSize" and tonumber(value) then
			SHORT_HOP_SIZE = tonumber(value)
			FAST_TWEEN_STEP_SIZE = SHORT_HOP_SIZE
		end
		if key == "ShortHopWait" and tonumber(value) then
			SHORT_HOP_WAIT = tonumber(value)
			FAST_TWEEN_STEP_WAIT = SHORT_HOP_WAIT
		end
		if key == "ShortHopMaxSteps" and tonumber(value) then
			SHORT_HOP_MAX_STEPS = tonumber(value)
			FAST_TWEEN_MAX_STEPS = SHORT_HOP_MAX_STEPS
		end
		if key == "FastTweenStepSize" and tonumber(value) then
			FAST_TWEEN_STEP_SIZE = tonumber(value)
			SHORT_HOP_SIZE = FAST_TWEEN_STEP_SIZE
		end
		if key == "FastTweenMaxSteps" and tonumber(value) then
			FAST_TWEEN_MAX_STEPS = tonumber(value)
			SHORT_HOP_MAX_STEPS = FAST_TWEEN_MAX_STEPS
		end
		if key == "AutoSell" then AUTO_SELL = value end
		if key == "AutoSellSkipMutation" or key == "SellSkipMutation" then
			AUTO_SELL_SKIP_MUTATION = value ~= false
		end
		if key == "AutoBargainMutation" or key == "BargainMutation" then
			AUTO_BARGAIN_MUTATION = value ~= false
		end
		if key == "MutationBargainMin" and tonumber(value) then
			MUTATION_BARGAIN_MIN_COUNT = tonumber(value)
		end
		if key == "AutoMailbox" then AUTO_MAILBOX = value end
		if key == "AutoGift" then AUTO_GIFT = value end
		if key == "AutoSteal" then
			AUTO_STEAL = value == true
			if AUTO_STEAL and not ALLOW_STEAL_ON_PRIVATE_SERVER and SERVER_KIND ~= "Standard" then
				AUTO_STEAL = false
				warn(("[So Nach Hup] Auto steal blocked on %s server"):format(SERVER_KIND))
			end
		end
		if key == "AllowStealOnPrivateServer" then
			ALLOW_STEAL_ON_PRIVATE_SERVER = value == true
			if not ALLOW_STEAL_ON_PRIVATE_SERVER then SNH.applyServerKindRules() end
		end
		if key == "AutoHarvest" or key == "Auto Harvest" then AUTO_COLLECT = value ~= false end
		if key == "AutoStayInGardenDay" or key == "StayInGardenDay" then
			AUTO_STAY_IN_GARDEN_DAY = value ~= false
		end
		if key == "GardenStayGap" and tonumber(value) then GARDEN_STAY_GAP = tonumber(value) end
		if key == "AutoExpand" then AUTO_EXPAND = value end
		if key == "ExpandOnlyAtPlantCap" then EXPAND_ONLY_AT_PLANT_CAP = value ~= false end
		if key == "MaxExpansions" and tonumber(value) then MAX_EXPANSIONS = math.floor(tonumber(value)) end
		if key == "TargetPetSlots" and tonumber(value) then TARGET_PET_SLOTS = math.floor(tonumber(value)) end
		if key == "AutoBuySeed" then AUTO_BUY_SEED = value end
		if key == "AutoBuyGear" then AUTO_BUY_GEAR = value end
		if key == "AutoBuyWildPet" then AUTO_BUY_WILD_PET = value ~= false end
		if key == "AutoBuyPetSlot" then AUTO_BUY_PET_SLOT = value ~= false end
		if key == "PetSlotBuyGap" and tonumber(value) then PET_SLOT_BUY_GAP = tonumber(value) end
		if key == "PetSlotBuyReserve" and tonumber(value) then PET_SLOT_BUY_RESERVE = tonumber(value) end
		if key == "AutoEquipBestPet" then AUTO_EQUIP_BEST_PET = value ~= false end
		if key == "AutoUseGear" then AUTO_USE_GEAR = value end
		if key == "AutoWaitGameLoad" then BOOT.autoWaitGameLoad = value ~= false end
		if key == "RequireFullLoad" or key == "Require Full Load" then BOOT.requireFullLoad = value ~= false end
		if key == "UnifiedScheduler" or key == "UseUnifiedScheduler" then USE_UNIFIED_SCHEDULER = value ~= false end
		if key == "UltimateOptimize" then
			if value == true then
				PERF.removeTextures = true
				PERF.hideOtherPlayers = true
				PERF.hideOtherBodyFace = true
				pcall(SNH.setupClientVisualOptimize)
			end
		end
		if key == "BlackScreen" or key == "BlackScreenVisible" then
			PERF.blackScreen = value ~= false
			if PERF.blackScreen then
				SNH.setupBlackScreenToggle()
				PERF.blackOverlayVisible = true
				SNH.updateBlackOverlay()
			else
				PERF.blackOverlayVisible = false
				SNH.updateBlackOverlay()
			end
		end
		if key == "OptimizeRemoveTextures" then
			PERF.removeTextures = value ~= false
			if PERF.removeTextures then pcall(SNH.setupClientVisualOptimize) end
		end
		if key == "OptimizeSimplifyMeshes" then PERF.simplifyMeshes = value ~= false end
		if key == "OptimizeDisableEffects" then PERF.disableEffects = value ~= false end
		if key == "OptimizeDisableSounds" then PERF.disableSounds = value ~= false end
		if key == "OptimizeDisableAnimations" then PERF.disableAnimations = value ~= false end
		if key == "OptimizeHidePlantBodies" then PERF.hidePlantBodies = value ~= false end
		if key == "HideLocalPlantsAll" then PERF.hideLocalPlantsAll = value ~= false end
		if key == "LocalPlantHideLoopGap" and tonumber(value) then
			PERF.localPlantHideLoopGap = tonumber(value)
		end
		if key == "HookWorkspaceVfx" then PERF.hookWorkspaceVfx = value == true end
		if key == "HookOtherGardens" then PERF.hookOtherGardens = value == true end
		if key == "OptimizeHideOtherPlots" then PERF.hideOtherPlots = value ~= false end
		if key == "OptimizeHideOtherPlants" then PERF.hideOtherPlants = value ~= false end
		if key == "OptimizeHideOtherPlayers" then
			PERF.hideOtherPlayers = value ~= false
			if PERF.hideOtherPlayers then
				PERF.hideOtherBodyFace = true
				pcall(SNH.setupClientVisualOptimize)
			end
		end
		if key == "OptimizeStripLocalPlayer" then PERF.stripLocalPlayer = value ~= false end
		if key == "Reduce3DRendering" then
			PERF.reduce3DRendering = value ~= false
			if PERF.reduce3DRendering then
				PERF.reduce3DApplied = false
				pcall(SNH.applyReduce3DRenderingOnce)
			end
		end
		if key == "OptimizeTextureLoopGap" and tonumber(value) then
			PERF.optimizeTextureLoopGap = tonumber(value)
		end
		if key == "OptimizeFullRefreshGap" and tonumber(value) then
			PERF.optimizeFullRefreshGap = tonumber(value)
		end
		if key == "PlantHideLoopGap" and tonumber(value) then
			PERF.plantHideLoopGap = tonumber(value)
		end
		if (key == "TargetFps" or key == "Fps" or key == "FPS" or key == "MaxFps" or key == "FpsCap")
			and tonumber(value) then
			PERF.targetFps = math.max(0, math.floor(tonumber(value)))
			if PERF.targetFps > 0 then
				SNH.applyFpsCapOnce()
				print(("[So Nach Hup] FPS cap set to %d"):format(PERF.targetFps))
			elseif typeof(setfpscap) == "function" then
				pcall(setfpscap, 0) -- 0 = uncap
				print("[So Nach Hup] FPS uncapped")
			end
		end
		if key == "OptimizeDestroyVfx" then PERF.destroyVfx = value ~= false end
		if key == "AutoMailSend" then
			if autoMailState.selfBlocked then
				AUTO_MAIL_SEND = false
				autoMailState.enabled = false
			else
				AUTO_MAIL_SEND = value ~= false
				autoMailState.enabled = AUTO_MAIL_SEND
			end
		end
		if key == "PlantAllInventoryExceptMutation" then
			PLANT_ALL_INVENTORY_EXCEPT_MUTATION = value ~= false
		end
		if key == "PlantCapUpgrade" and tonumber(value) then PLANT_CAP_UPGRADE = tonumber(value) end
		if key == "AutoPlantUpgrade" then AUTO_PLANT_UPGRADE = value ~= false end
		if key == "PlantUpgradeGap" and tonumber(value) then PLANT_UPGRADE_GAP = tonumber(value) end
		if key == "PlantUpgradeBurst" and tonumber(value) then PLANT_UPGRADE_BURST = tonumber(value) end
		if key == "Plant Upgrade Burst" and tonumber(value) then PLANT_UPGRADE_BURST = tonumber(value) end
		if key == "InstantPrompts" then
			AUTO_INSTANT_PROMPTS = value ~= false
			if AUTO_INSTANT_PROMPTS then SNH.setupInstantPromptHooks() end
		end
		if key == "AutoMail" or key == "AUTO_MAIL" or key == "MailConfig" then
			if type(value) == "table" then
				SNH.applyAutoMailConfig(value)
			elseif type(value) == "boolean" then
				if autoMailState.selfBlocked then
					autoMailState.enabled = false
					AUTO_MAIL_SEND = false
				else
					autoMailState.enabled = value
					AUTO_MAIL_SEND = value
				end
			end
		end
		if key == "BUY_SEED" or key == "BuySeeds" or key == "BuySeed" then
			if type(value) == "table" then SNH.applyBuySeedsConfig(value) end
		end
		if key == "BUY_GEAR" or key == "BuyGear" then
			if type(value) == "table" then SNH.applyBuyGearConfig(value) end
		end
		if key == "PLANT_SEED" or key == "PlantSeeds" or key == "PlantSeed" then
			if type(value) == "table" then SNH.applyPlantSeedsConfig(value) end
		end
		if key == "USE_GEAR" or key == "UseGear" then
			if type(value) == "table" then SNH.applyUseGearConfig(value) end
		end
		if key == "BUY_PET" or key == "BuyPets" or key == "BuyPet" or key == "WildPetBuy" then
			if type(value) == "table" then SNH.applyBuyPetsConfig(value) end
		end
		if key == "Webhook URL" or key == "webhook" or key == "Webhook" then
			WEBHOOK_URL = tostring(value or "")
			if WEBHOOK_URL ~= "" then SNH.setupWildPetWebhooks() end
		end
		if key == "Ping ID" or key == "PingID" or key == "pingId" then
			WEBHOOK_PING_ID = tostring(value or "")
		end
		if key == "Send Webhook" or key == "SendWebhook" or key == "WEBHOOK_SEND" or key == "WebhookSend" then
			if type(value) == "table" then SNH.applySendWebhookConfig(value) end
		end
		if key == "WildPetBuyGap" and tonumber(value) then WILD_PET_BUY_GAP = tonumber(value) end
		if key == "PetRarityLoopGap" and tonumber(value) then PET_RARITY_LOOP_GAP = tonumber(value) end
		if key == "PetOkLogGap" and tonumber(value) then PET_OK_LOG_GAP = tonumber(value) end
		if key == "PetEquipGap" and tonumber(value) then PET_EQUIP_GAP = tonumber(value) end
		if key == "StealZeroHold" then STEAL_ZERO_HOLD = value ~= false end
		if key == "GameLoadTimeout" and tonumber(value) then BOOT.gameLoadTimeout = tonumber(value) end
		if key == "SellLoopGap" and tonumber(value) then SELL_LOOP_GAP = tonumber(value) end
		if key == "SellDelay" and tonumber(value) then SELL_LOOP_GAP = tonumber(value) end
		if key == "CollectWaves" and tonumber(value) then COLLECT_WAVES = tonumber(value) end
		if key == "CollectMaxPasses" and tonumber(value) then COLLECT_MAX_PASSES = tonumber(value) end
		if key == "CollectDrainLoops" and tonumber(value) then COLLECT_DRAIN_LOOPS = tonumber(value) end
		if key == "CollectBatchSize" and tonumber(value) then COLLECT_BATCH_SIZE = tonumber(value) end
		if key == "CollectFireChunk" and tonumber(value) then COLLECT_FIRE_CHUNK = tonumber(value) end
		if key == "CollectChunk" and tonumber(value) then COLLECT_FIRE_CHUNK = tonumber(value) end
		if key == "CollectGap" and tonumber(value) then COLLECT_GAP = tonumber(value) end
		if key == "CollectMaxFires" and tonumber(value) then COLLECT_MAX_FIRES = tonumber(value) end
		if key == "CollectSortByValue" then COLLECT_SORT_BY_VALUE = value ~= false end
		if key == "CollectBurstPause" and tonumber(value) then COLLECT_BURST_PAUSE = tonumber(value) end
		if key == "HudRefreshGap" and tonumber(value) then HUD_REFRESH_GAP = tonumber(value) end
		if key == "ShowHud" then SHOW_HUD = value ~= false end
		if key == "DebugLagProbe" then DEBUG_LAG_PROBE = value == true end
		if key == "PlantBurstLimit" and tonumber(value) then PLANT_BURST_LIMIT = tonumber(value) end
		if key == "PlantFireGap" and tonumber(value) then PLANT_FIRE_GAP = tonumber(value) end
		if key == "PlantBurstGap" and tonumber(value) then PLANT_BURST_GAP = tonumber(value) end
		if key == "PlantChunk" and tonumber(value) then PLANT_CHUNK = tonumber(value) end
		if key == "PlantIndependent" then PLANT_INDEPENDENT = value ~= false end
		if key == "HarvestPromptRange" and tonumber(value) then
			HARVEST_PROMPT_RANGE = tonumber(value)
			PROMPT_RANGE_MAX = math.max(PROMPT_RANGE_MAX, HARVEST_PROMPT_RANGE)
			pcall(SNH.maintainLocalHarvestPrompts)
		end
		if key == "HarvestPromptMaintain" then
			HARVEST_PROMPT_MAINTAIN = value ~= false
		end
		if key == "RemoveTextures" or key == "Remove Textures" then
			PERF.removeTextures = value ~= false
			if PERF.removeTextures then pcall(SNH.setupClientVisualOptimize) end
		end
		if key == "HideOtherPlayers" or key == "Hide Other Players" then
			PERF.hideOtherPlayers = value ~= false
			if PERF.hideOtherPlayers then
				PERF.hideOtherBodyFace = true
				pcall(SNH.setupClientVisualOptimize)
			end
		end
		if key == "PromptRangeMax" and tonumber(value) then PROMPT_RANGE_MAX = tonumber(value) end
		if key == "StealPromptRange" and tonumber(value) then STEAL_PROMPT_RANGE = tonumber(value) end
		if key == "PlantGap" and tonumber(value) then PLANT_GAP = tonumber(value) end
		if key == "GearUseGap" and tonumber(value) then GEAR_USE_GAP = tonumber(value) end
		if key == "DebugGear" then DEBUG_GEAR = value == true end
		if key == "DebugWildPet" then DEBUG_WILD_PET = value == true end
		if key == "DebugSteal" then DEBUG_STEAL = value == true end
		if key == "DebugShop" then DEBUG_SHOP = value == true end
		if key == "DebugThrottle" and tonumber(value) then DEBUG_THROTTLE = tonumber(value) end
		if key == "StealGap" and tonumber(value) then STEAL_GAP = tonumber(value) end
		if key == "StealScanGardens" then STEAL_SCAN_GARDENS = value ~= false end
		if key == "StealGardenPoll" and tonumber(value) then STEAL_GARDEN_POLL = tonumber(value) end
		if key == "StealTpSteps" and tonumber(value) then STEAL_TP_STEPS = tonumber(value) end
		if key == "StealTpStepDelay" and tonumber(value) then STEAL_TP_STEP_DELAY = tonumber(value) end
		if key == "StealTpSettle" and tonumber(value) then STEAL_TP_SETTLE = tonumber(value) end
		if key == "StealBeginWait" and tonumber(value) then STEAL_BEGIN_WAIT = tonumber(value) end
		if key == "StealGardenReadyTimeout" and tonumber(value) then STEAL_GARDEN_READY_TIMEOUT = tonumber(value) end
		if key == "StealGardenEntryPoll" and tonumber(value) then STEAL_GARDEN_ENTRY_POLL = tonumber(value) end
		if key == "StealAutoDetectCooldown" then STEAL_AUTO_DETECT_COOLDOWN = value ~= false end
		if key == "StealSafeZoneWait" then STEAL_SAFE_ZONE_WAIT = value ~= false end
		if key == "StealCooldownFloatHeight" and tonumber(value) then STEAL_COOLDOWN_FLOAT_HEIGHT = tonumber(value) end
		if key == "StealGardenEntryCooldownSec" and tonumber(value) then STEAL_GARDEN_ENTRY_COOLDOWN_SEC = tonumber(value) end
		if key == "StealLowHealthFlee" then STEAL_LOW_HEALTH_FLEE = value ~= false end
		if key == "StealLowHealthRatio" and tonumber(value) then STEAL_LOW_HEALTH_RATIO = tonumber(value) end
		if key == "StealDrainGarden" then STEAL_DRAIN_GARDEN = value ~= false end
		if key == "StealDrainMinFruits" and tonumber(value) then STEAL_DRAIN_MIN_FRUITS = tonumber(value) end
		if key == "StealReenterAfterFlush" then STEAL_REENTER_AFTER_FLUSH = value ~= false end
		if key == "StealGardenMaxRounds" and tonumber(value) then STEAL_GARDEN_MAX_ROUNDS = tonumber(value) end
		if key == "StealReturnAtFruits" and tonumber(value) then STEAL_RETURN_AT_FRUITS = tonumber(value) end
		if key == "StealReturnFruitMax" and tonumber(value) then STEAL_RETURN_FRUIT_MAX = tonumber(value) end
		if key == "StealReturnFruitRatio" and tonumber(value) then STEAL_RETURN_FRUIT_RATIO = tonumber(value) end
		if key == "StealReturnOnEmptyGarden" then STEAL_RETURN_ON_EMPTY_GARDEN = value ~= false end
		if key == "StealInstantRemote" then STEAL_INSTANT_REMOTE = value ~= false end
		if key == "StealReturnWait" and tonumber(value) then STEAL_RETURN_WAIT = tonumber(value) end
		if key == "StealCompleteWait" and tonumber(value) then STEAL_COMPLETE_WAIT = tonumber(value) end
		if key == "StealVerifyTime" and tonumber(value) then STEAL_VERIFY_TIME = tonumber(value) end
		if key == "ExpandCheckGap" and tonumber(value) then EXPAND_CHECK_GAP = tonumber(value) end
		if key == "ShopBuyGap" and tonumber(value) then SHOP_BUY_GAP = tonumber(value) end
		if key == "ShopBuyBurst" and tonumber(value) then SHOP_BUY_BURST = tonumber(value) end
		if key == "ShopBuyFireGap" and tonumber(value) then SHOP_BUY_FIRE_GAP = tonumber(value) end
		if key == "ShopBuyConfirm" and tonumber(value) then SHOP_BUY_CONFIRM = tonumber(value) end
		if key == "ShopBuyFailCooldown" and tonumber(value) then SHOP_BUY_FAIL_COOLDOWN = tonumber(value) end
		if key == "MaxSeedBuyPrice" and tonumber(value) then
			MAX_SEED_BUY_PRICE = tonumber(value)
			SNH.invalidateAffordableSeedBuyCache()
		end
		if key == "StealInstantTp" then STEAL_INSTANT_TP = value ~= false end
		if key == "StealTryRemoteFirst" then STEAL_TRY_REMOTE_FIRST = value ~= false end
		if key == "StealBurstAll" then STEAL_BURST_ALL = value ~= false end
		if key == "StealFloatHeight" and tonumber(value) then STEAL_FLOAT_HEIGHT = tonumber(value) end
		if key == "StealFloatTween" then STEAL_FLOAT_TWEEN = value ~= false end
		if key == "StealFloatTpSteps" and tonumber(value) then STEAL_FLOAT_TP_STEPS = tonumber(value) end
		if key == "StealFloatTpDelay" and tonumber(value) then STEAL_FLOAT_TP_DELAY = tonumber(value) end
		if key == "StealFastHop" then STEAL_FAST_HOP = value ~= false end
		if key == "StealUseShortHop" then STEAL_USE_SHORT_HOP = value == true end
		if key == "StealPerFruitFires" and tonumber(value) then STEAL_PER_FRUIT_FIRES = tonumber(value) end
		if key == "StealBurstRounds" and tonumber(value) then STEAL_BURST_ROUNDS = tonumber(value) end
		if key == "StealSpamCount" and tonumber(value) then STEAL_SPAM_COUNT = tonumber(value) end
		if key == "StealSpamGap" and tonumber(value) then STEAL_SPAM_GAP = tonumber(value) end
		if key == "DisableAllEffects" or key == "Disable All Effects" or key == "DISABLE_ALL_EFFECTS" then
			DISABLE_ALL_EFFECTS = value ~= false
			if DISABLE_ALL_EFFECTS then
				disableAllEffectsHooked = false
				disableAllEffectsPurgeDone = false
				SNH.setupDisableAllEffects()
			end
		end
		if key == "DisableEffectVfxPurge" or key == "Disable Effect Vfx Purge" or key == "DISABLE_EFFECT_VFX_PURGE" then
			DISABLE_EFFECT_VFX_PURGE = value == true
			if DISABLE_EFFECT_VFX_PURGE then
				disableAllEffectsPurgeDone = false
				SNH.purgeGearWeatherEventVisualsOnce()
			end
		end
		if key == "DisableAllEffectsGap" or key == "Disable All Effects Gap" or key == "DISABLE_ALL_EFFECTS_GAP" then
			if tonumber(value) ~= nil then DISABLE_ALL_EFFECTS_GAP = tonumber(value) end
		end
	end,
	PLANT_SEED = PlantSeedsConfig,
	BUY_SEED = BuySeedsConfig,
	BUY_GEAR = BuyGearConfig,
	USE_GEAR = UseGearConfig,
	BUY_PET = BuyPetsConfig,
	PlantSeeds = PlantSeedsConfig,
	BuySeeds = BuySeedsConfig,
	BuyGear = BuyGearConfig,
	UseGear = UseGearConfig,
	BuyPets = BuyPetsConfig,
	AutoMail = autoMailState,
	SendWebhook = sendWebhookState,
	GetConfig = function()
		return getgenv().SoNachHup
	end,
	UserConfig = USER_CONFIG,
	AllSeeds = ALL_SEEDS,
	AllGear = ALL_GEAR,
	AllWildPets = ALL_WILD_PETS,
	NormalSeeds = NORMAL_SEEDS,
	MutationSeeds = MUTATION_SEEDS,
	HazardSeeds = HazardSeeds,
	PetBuyOrder = PET_BUY_ORDER,
	waitForInitialLoad = SNH.waitForInitialLoad,
	setupClientVisualOptimize = SNH.setupClientVisualOptimize,
	setupUltimateOptimization = SNH.setupUltimateOptimization,
	refreshUltimateOptimization = SNH.refreshUltimateOptimization,
	cleanupRuntime = SNH.cleanupRuntime,
	startUnifiedScheduler = SNH.startUnifiedScheduler,
	toggleBlackScreen = function()
		PERF.blackOverlayVisible = not PERF.blackOverlayVisible
		SNH.updateBlackOverlay()
		return PERF.blackOverlayVisible
	end,
	tryBuyWildPet = SNH.tryBuyWildPet,
	equipPetByName = SNH.equipPetByName,
	unequipPetByName = SNH.unequipPetByName,
	unequipPetById = SNH.unequipPetById,
	tryEquipBestPets = SNH.tryEquipBestPets,
	tryEquipPetsByRarity = SNH.tryEquipPetsByRarity,
	ensureBestPetsEquipped = SNH.ensureBestPetsEquipped,
	sendPetWebhook = SNH.sendPetWebhook,
	sendSeedWebhook = SNH.sendSeedWebhook,
	sendDualWebhook = SNH.sendDualWebhook,
	debugPetEquipStatus = SNH.debugPetEquipStatus,
	useAllInventoryGearOnBestPlant = SNH.useAllInventoryGearOnBestPlant,
	UseAllGearOnBestPlant = SNH.useAllInventoryGearOnBestPlant,
	placeSprinklersOnPlant = SNH.placeSprinklersOnPlant,
	placeSprinklersOnPlant = SNH.placeSprinklersOnPlant,
	PlaceSprinklersOnBestPlant = SNH.placeSprinklersOnPlant,
	PlaceSprinklersOnPineapple = SNH.placeSprinklersOnPlant,
	getOwnedPetKeys = SNH.getOwnedPetKeys,
	DumpGearDebug = function() SNH.dumpGearDebug() end,
	DumpWildPetDebug = function() SNH.dumpWildPetDebug() end,
	RunQASelfTest = function() return SNH.runQASelfTest() end,
	GetClientMemoryMb = function() return SNH.getClientMemoryMb() end,
	TrimOptimizeCaches = function(force) SNH.trimOptimizeCaches(force == true) end,
	NextStage = function() SNH.nextStage() end,
	StageStatus = function() SNH.stageStatus() end,
	GetServerKind = function() return SERVER_KIND or API.getServerKind() end,
	IsPrivateServer = function() return API.isPrivateServer() end,
	IsStealAllowed = function() return SNH.isStealAllowed() end,
	DisableControllers = function(names, force)
		if type(names) == "string" then names = { names } end
		return SNH.disableGameControllers(names or DISABLE_GAME_CONTROLLERS, force == true)
	end,
	SetupDisableAllEffects = function() return SNH.setupDisableAllEffects() end,
	DisableAllEffects = function(force) return SNH.disableAllEffectsOnce(force == true) end,
	InstaStealAll = function() return SNH.instaStealAll() end,
	InstaSteal = function(ownerUserId, plantId, fruitId)
		return SNH.instaStealFruit(ownerUserId, plantId, fruitId)
	end,
	SafeTeleportTo = function(x, y, z, opts)
		if typeof(x) == "table" then
			return SNH.safeTeleport(x, y)
		end
		local pos = typeof(x) == "Vector3" and x or Vector3.new(tonumber(x) or 0, tonumber(y) or 0, tonumber(z) or 0)
		return SNH.safeTeleport(pos, opts)
	end,
	TeleportTo = function(pos, opts) return SNH.safeTeleport(pos, opts) end,
	SampleLag = function(seconds)
		local r = SNH.sampleLag(tonumber(seconds) or 5)
		print(("[STAGED] sample: avgFps=%.0f worstStall=%.0fms mem=%.0f MB over %d frames"):format(
			r.avgFps, r.maxDt * 1000, r.mem, r.samples))
		return r
	end,
	DebugGear = function() return DEBUG_GEAR end,
	DebugWildPet = function() return DEBUG_WILD_PET end,
	AntiAfk = ANTI_AFK,
	setupAntiAfk = SNH.setupAntiAfk,
	runAntiAfkPulse = SNH.runAntiAfkPulse,
}

print(("[%s] Ready"):format(SCRIPT_NAME))

if PLACE_SPRINKLERS_ON_BEST_PLANT then
	task.spawn(function()
		task.wait(2)
		if SNH.placeSprinklersOnPlant then
			SNH.placeSprinklersOnPlant({ gear = "Common Sprinkler", count = 3 })
		end
	end)
end
end -- runStartup

local startupOk, startupErr = xpcall(runStartup, debug.traceback)
if not startupOk then
	warn("[So Nach Hup] STARTUP FAILED:\n" .. tostring(startupErr))
	SNH.setStatus("Startup error — check console")
end
end
