-- ============================================================================
-- FRUIT ODYSSEY - PROFILE SERVICE SIMPLIFIÉ
-- Système de sauvegarde sans dépendance externe
-- ============================================================================

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local DATA_STORE_NAME = "FruitOdysseyData"

-- ============================================================================
-- DATASTORES
-- ============================================================================

local playerDataStore = DataStoreService:GetDataStore(DATA_STORE_NAME)

-- ============================================================================
-- TEMPLATE
-- ============================================================================

local DEFAULT_DATA = {
	Level = 1,
	XP = 0,
	XPToNextLevel = 100,
	Coins = 0,
	Gems = 0,
	Strength = 1,
	Speed = 1,
	Stamina = 1,
	Vitality = 1,
	Precision = 1,
	Luck = 1,
	PointsToSpend = 0,
	CombatStyle = "Melee",
	TransformationLevel = 0,
	Gamepasses = {},
	CurrentRace = "Human",
	CurrentClan = "Human",
	CurrentAttribute = "",
	TotalPlayTime = 0,
	TotalMobsKilled = 0,
	TotalBossesKilled = 0,
	TotalQuestsCompleted = 0
}

local UNLOCKS_TEMPLATE = {
	UnlockedRaces = {Human = true},
	UnlockedClans = {Human = true},
	UnlockedAttributes = {},
	UnlockedTransformations = {},
	UnlockedSkills = {},
	UnlockedWeapons = {}
}

-- ============================================================================
-- PROFILE SERVICE
-- ============================================================================

local ProfileServiceModule = {}
local Profiles = {}

-- Charger profil
function ProfileServiceModule.LoadProfile(player)
	local userId = player.UserId
	local data
	
	local success, err = pcall(function()
		data = playerDataStore:GetAsync("Player_" .. userId)
	end)
	
	if not success then
		warn("[ProfileService] Erreur chargement: " .. tostring(err))
	end
	
	local profileData = {}
	
	-- Fusionner avec defaults
	for key, value in pairs(DEFAULT_DATA) do
		profileData[key] = data and data[key] or value
	end
	
	-- Déblocages
	if not data or not data.Unlocks then
		profileData.Unlocks = UNLOCKS_TEMPLATE
	else
		profileData.Unlocks = {}
		for key, value in pairs(UNLOCKS_TEMPLATE) do
			if type(value) == "table" then
				profileData.Unlocks[key] = {}
				for k, v in pairs(value) do
					profileData.Unlocks[key][k] = data.Unlocks[key] and data.Unlocks[key][k] or v
				end
			end
		end
	end
	
	Profiles[player.UserId] = profileData
	ProfileServiceModule.CreateLeaderstats(player)
	
	print("[ProfileService] Profil chargé pour: " .. player.Name)
	return profileData
end

-- Sauvegarder profil
function ProfileServiceModule.SaveProfile(player)
	local userId = player.UserId
	local data = Profiles[userId]
	
	if data then
		pcall(function()
			playerDataStore:SetAsync("Player_" .. userId, data)
		end)
		print("[ProfileService] Profil sauvegardé pour: " .. player.Name)
	end
end

function ProfileServiceModule.GetPlayerData(player)
	return Profiles[player.UserId]
end

-- Ajouter XP
function ProfileServiceModule.AddXP(player, amount)
	local data = ProfileServiceModule.GetPlayerData(player)
	if not data then return false end
	
	local bonus = data.Gamepasses and data.Gamepasses.DoubleXP
	local final = bonus and amount * 2 or amount
	
	data.XP = data.XP + final
	
	while data.XP >= data.XPToNextLevel do
		data.XP = data.XP - data.XPToNextLevel
		data.Level = data.Level + 1
		data.XPToNextLevel = math.floor(data.XPToNextLevel * 1.2)
		data.PointsToSpend = data.PointsToSpend + 3
		
		if player:FindFirstChild("leaderstats") then
			player.leaderstats.Level.Value = data.Level
		end
	end
	
	if player:FindFirstChild("leaderstats") then
		player.leaderstats.XP.Value = data.XP
	end
	
	return true
end

-- Ajouter Coins
function ProfileServiceModule.AddCoins(player, amount)
	local data = ProfileServiceModule.GetPlayerData(player)
	if not data then return false end
	
	local bonus = data.Gamepasses and data.Gamepasses.DoubleMoney
	data.Coins = data.Coins + (bonus and amount * 2 or amount)
	
	if player:FindFirstChild("leaderstats") then
		player.leaderstats.Coins.Value = data.Coins
	end
	return true
end

-- Ajouter Gems
function ProfileServiceModule.AddGems(player, amount)
	local data = ProfileServiceModule.GetPlayerData(player)
	if not data then return false end
	
	local bonus = data.Gamepasses and data.Gamepasses.DoubleGems
	data.Gems = data.Gems + (bonus and amount * 2 or amount)
	
	if player:FindFirstChild("leaderstats") then
		player.leaderstats.Gems.Value = data.Gems
	end
	return true
end

-- Dépenser Gems
function ProfileServiceModule.SpendGems(player, amount)
	local data = ProfileServiceModule.GetPlayerData(player)
	if not data or data.Gems < amount then return false end
	
	data.Gems = data.Gems - amount
	
	if player:FindFirstChild("leaderstats") then
		player.leaderstats.Gems.Value = data.Gems
	end
	return true
end

-- Dépenser Coins
function ProfileServiceModule.SpendCoins(player, amount)
	local data = ProfileServiceModule.GetPlayerData(player)
	if not data or data.Coins < amount then return false end
	
	data.Coins = data.Coins - amount
	
	if player:FindFirstChild("leaderstats") then
		player.leaderstats.Coins.Value = data.Coins
	end
	return true
end

-- Allouer point de stat
function ProfileServiceModule.AllocateStatPoint(player, statName)
	local data = ProfileServiceModule.GetPlayerData(player)
	if not data or data.PointsToSpend <= 0 then return false end
	
	if data[statName] then
		data[statName] = data[statName] + 1
		data.PointsToSpend = data.PointsToSpend - 1
		
		if player:FindFirstChild("Stats") and player.Stats:FindFirstChild(statName) then
			player.Stats[statName].Value = data[statName]
		end
		
		if player:FindFirstChild("Stats") and player.Stats:FindFirstChild("PointsToSpend") then
			player.Stats.PointsToSpend.Value = data.PointsToSpend
		end
		
		return true
	end
	return false
end

-- Débloquer race
function ProfileServiceModule.UnlockRace(player, raceName)
	local data = ProfileServiceModule.GetPlayerData(player)
	if not data or not data.Unlocks then return false end
	data.Unlocks.UnlockedRaces[raceName] = true
	return true
end

-- Débloquer clan
function ProfileServiceModule.UnlockClan(player, clanName)
	local data = ProfileServiceModule.GetPlayerData(player)
	if not data or not data.Unlocks then return false end
	data.Unlocks.UnlockedClans[clanName] = true
	return true
end

-- Débloquer attribut
function ProfileServiceModule.UnlockAttribute(player, attrName)
	local data = ProfileServiceModule.GetPlayerData(player)
	if not data or not data.Unlocks then return false end
	data.Unlocks.UnlockedAttributes[attrName] = true
	return true
end

function ProfileServiceModule.IsRaceUnlocked(player, raceName)
	local data = ProfileServiceModule.GetPlayerData(player)
	if not data or not data.Unlocks then return false end
	return data.Unlocks.UnlockedRaces[raceName] or false
end

function ProfileServiceModule.IsClanUnlocked(player, clanName)
	local data = ProfileServiceModule.GetPlayerData(player)
	if not data or not data.Unlocks then return false end
	return data.Unlocks.UnlockedClans[clanName] or false
end

function ProfileServiceModule.BuyGamepass(player, gamepassName)
	local data = ProfileServiceModule.GetPlayerData(player)
	if not data then return false end
	if not data.Gamepasses then data.Gamepasses = {} end
	data.Gamepasses[gamepassName] = true
	return true
end

-- Créer leaderstats
function ProfileServiceModule.CreateLeaderstats(player)
	local data = ProfileServiceModule.GetPlayerData(player)
	if not data then return end
	
	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"
	ls.Parent = player
	
	Instance.new("IntValue", ls).Name = "Level"
	ls.Level.Value = data.Level
	
	Instance.new("IntValue", ls).Name = "XP"
	ls.XP.Value = data.XP
	
	Instance.new("IntValue", ls).Name = "Coins"
	ls.Coins.Value = data.Coins
	
	Instance.new("IntValue", ls).Name = "Gems"
	ls.Gems.Value = data.Gems
	
	-- Stats privées
	local stats = Instance.new("Folder")
	stats.Name = "Stats"
	stats.Parent = player
	
	local statNames = {"Strength", "Speed", "Stamina", "Vitality", "Precision", "Luck", "PointsToSpend", "CombatStyle", "TransformationLevel"}
	for _, name in ipairs(statNames) do
		local v = Instance.new(typeof(data[name]) == "number" and "IntValue" or "StringValue", stats)
		v.Name = name
		v.Value = data[name]
	end
	
	print("[ProfileService] Leaderstats créés pour: " .. player.Name)
end

print("[ProfileService] Service prêt!")
return ProfileServiceModule
