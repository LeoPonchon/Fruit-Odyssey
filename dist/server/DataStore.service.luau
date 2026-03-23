-- ============================================================================
-- FRUIT ODYSSEY - DATASTORE SERVICE
-- Système de sauvegarde des données joueurs
-- ============================================================================

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

-- ============================================================================
-- DATASTORES
-- ============================================================================

-- DataStore principal pour les données du joueur
local playerDataStore = DataStoreService:GetDataStore("PlayerData")

-- DataStore pour les objets/inventaire
local inventoryDataStore = DataStoreService:GetDataStore("PlayerInventory")

-- DataStore pour les personnages débloqués
local charactersDataStore = DataStoreService:GetDataStore("PlayerCharacters")

-- ============================================================================
-- CONFIGURATION PAR DÉFAUT
-- ============================================================================

local DEFAULT_PLAYER_DATA = {
	Level = 1,
	XP = 0,
	XPToNextLevel = 100,
	Coins = 0,
	Gems = 0,
	
	-- Stat points
	Strength = 1,
	Speed = 1,
	Stamina = 1,
	Vitality = 1,
	Precision = 1,
	Luck = 1,
	
	PointsToSpend = 0,
	
	-- Personnage actuel
	CurrentUniverse = "OnePiece",
	CurrentCharacter = "Luffy",
	
	-- Combat style
	CombatStyle = "Melee", -- "Melee" or "Power"
	
	-- Transformation level
	TransformationLevel = 0,
	
	-- Gamepasses
	Gamepasses = {
		DoubleLuck = false,
		DoubleMoney = false,
		DoubleDrops = false,
		DoubleGems = false,
		DoubleXP = false
	},
	
	-- Stats de jeu
	TotalPlayTime = 0,
	TotalMobsKilled = 0,
	TotalBossesKilled = 0,
	TotalQuestsCompleted = 0,
	
	-- Position de spawn
	SpawnIsland = 1,
	SpawnPosition = Vector3.new(0, 10, 0)
}

local DEFAULT_INVENTORY = {
	Weapons = {},
	Consumables = {},
	Materials = {},
	Cosmetics = {}
}

local DEFAULT_CHARACTERS = {
	UnlockedCharacters = {
		["Luffy"] = true,
		["Zoro"] = false,
		["Sanji"] = false,
		["Ace"] = false,
		["Shanks"] = false,
		
		["Ichigo"] = false,
		["Aizen"] = false,
		["Byakuya"] = false,
		["Hitsugaya"] = false,
		["Grimmjow"] = false,
		
		["Goku"] = false,
		["Gohan"] = false,
		["Vegeta"] = false,
		["Trunks"] = false,
		["Freezer"] = false
	},
	
	UnlockedRaces = {
		["Human"] = true
	},
	
	UnlockedClans = {},
	
	UnlockedAttributes = {
		["None"] = true
	},
	
	UnlockedPassives = {}
}

-- ============================================================================
-- FONCTIONS DE SAUVEGARDE
-- ============================================================================

local DataStoreServiceModule = {}

-- Sauvegarder les données d'un joueur
function DataStoreServiceModule.SavePlayerData(player, data)
	local success, err = pcall(function()
		playerDataStore:SetAsync(player.UserId, data)
	end)
	
	if not success then
		warn("[DataStore] Erreur lors de la sauvegarde: " .. tostring(err))
		return false
	end
	
	print("[DataStore] Données sauvegardées pour le joueur: " .. player.Name)
	return true
end

-- Charger les données d'un joueur
function DataStoreServiceModule.LoadPlayerData(player)
	local data
	
	local success, err = pcall(function()
		data = playerDataStore:GetAsync(player.UserId)
	end)
	
	if not success then
		warn("[DataStore] Erreur lors du chargement: " .. tostring(err))
		return DEFAULT_PLAYER_DATA
	end
	
	-- Fusionner avec les données par défaut
	if data then
		local mergedData = {}
		for key, value in pairs(DEFAULT_PLAYER_DATA) do
			mergedData[key] = data[key] or value
		end
		return mergedData
	end
	
	return DEFAULT_PLAYER_DATA
end

-- Sauvegarder l'inventaire
function DataStoreServiceModule.SaveInventory(player, inventory)
	local success, err = pcall(function()
		inventoryDataStore:SetAsync(player.UserId, inventory)
	end)
	
	if not success then
		warn("[DataStore] Erreur lors de la sauvegarde inventaire: " .. tostring(err))
		return false
	end
	
	return true
end

-- Charger l'inventaire
function DataStoreServiceModule.LoadInventory(player)
	local inventory
	
	local success, err = pcall(function()
		inventory = inventoryDataStore:GetAsync(player.UserId)
	end)
	
	if not success then
		warn("[DataStore] Erreur lors du chargement inventaire: " .. tostring(err))
		return DEFAULT_INVENTORY
	end
	
	if inventory then
		local mergedInventory = {}
		for key, value in pairs(DEFAULT_INVENTORY) do
			mergedInventory[key] = inventory[key] or value
		end
		return mergedInventory
	end
	
	return DEFAULT_INVENTORY
end

-- Sauvegarder les personnages débloqués
function DataStoreServiceModule.SaveCharacters(player, characters)
	local success, err = pcall(function()
		charactersDataStore:SetAsync(player.UserId, characters)
	end)
	
	if not success then
		warn("[DataStore] Erreur lors de la sauvegarde personnages: " .. tostring(err))
		return false
	end
	
	return true
end

-- Charger les personnages débloqués
function DataStoreServiceModule.LoadCharacters(player)
	local characters
	
	local success, err = pcall(function()
		characters = charactersDataStore:GetAsync(player.UserId)
	end)
	
	if not success then
		warn("[DataStore] Erreur lors du chargement personnages: " .. tostring(err))
		return DEFAULT_CHARACTERS
	end
	
	if characters then
		local mergedCharacters = {}
		for key, value in pairs(DEFAULT_CHARACTERS) do
			if type(value) == "table" then
				mergedCharacters[key] = {}
				for k, v in pairs(value) do
					mergedCharacters[key][k] = characters[key] and characters[key][k] or v
				end
			else
				mergedCharacters[key] = characters[key] or value
			end
		end
		return mergedCharacters
	end
	
	return DEFAULT_CHARACTERS
end

-- ============================================================================
-- GESTIONNAIRE DE DONNÉES EN JEU
-- ============================================================================

-- Table pour stocker les données en mémoire (pour un accès rapide)
local playerDataCache = {}
local playerInventoryCache = {}
local playerCharactersCache = {}

function DataStoreServiceModule.GetPlayerData(player)
	return playerDataCache[player.UserId]
end

function DataStoreServiceModule.GetPlayerInventory(player)
	return playerInventoryCache[player.UserId]
end

function DataStoreServiceModule.GetPlayerCharacters(player)
	return playerCharactersCache[player.UserId]
end

-- Initialiser les données d'un joueur (appelé lors du join)
function DataStoreServiceModule.InitPlayerData(player)
	-- Charger les données
	local data = DataStoreServiceModule.LoadPlayerData(player)
	local inventory = DataStoreServiceModule.LoadInventory(player)
	local characters = DataStoreServiceModule.LoadCharacters(player)
	
	-- Stocker en cache
	playerDataCache[player.UserId] = data
	playerInventoryCache[player.UserId] = inventory
	playerCharactersCache[player.UserId] = characters
	
	-- Créer un folder pour le leaderstats
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	
	-- Stats visibles
	local level = Instance.new("IntValue")
	level.Name = "Level"
	level.Value = data.Level
	level.Parent = leaderstats
	
	local xp = Instance.new("IntValue")
	xp.Name = "XP"
	xp.Value = data.XP
	xp.Parent = leaderstats
	
	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = data.Coins
	coins.Parent = leaderstats
	
	local gems = Instance.new("IntValue")
	gems.Name = "Gems"
	gems.Value = data.Gems
	gems.Parent = leaderstats
	
	-- Créer un folder pour les stats privées (pas visible sur le leaderboard)
	local stats = Instance.new("Folder")
	stats.Name = "Stats"
	stats.Parent = player
	
	-- Stats principales
	local strength = Instance.new("IntValue")
	strength.Name = "Strength"
	strength.Value = data.Strength
	strength.Parent = stats
	
	local speed = Instance.new("IntValue")
	speed.Name = "Speed"
	speed.Value = data.Speed
	speed.Parent = stats
	
	local stamina = Instance.new("IntValue")
	stamina.Name = "Stamina"
	stamina.Value = data.Stamina
	stamina.Parent = stats
	
	local vitality = Instance.new("IntValue")
	vitality.Name = "Vitality"
	vitality.Value = data.Vitality
	vitality.Parent = stats
	
	local precision = Instance.new("IntValue")
	precision.Name = "Precision"
	precision.Value = data.Precision
	precision.Parent = stats
	
	local luck = Instance.new("IntValue")
	luck.Name = "Luck"
	luck.Value = data.Luck
	luck.Parent = stats
	
	local pointsToSpend = Instance.new("IntValue")
	pointsToSpend.Name = "PointsToSpend"
	pointsToSpend.Value = data.PointsToSpend
	pointsToSpend.Parent = stats
	
	local currentUniverse = Instance.new("StringValue")
	currentUniverse.Name = "CurrentUniverse"
	currentUniverse.Value = data.CurrentUniverse
	currentUniverse.Parent = stats
	
	local currentCharacter = Instance.new("StringValue")
	currentCharacter.Name = "CurrentCharacter"
	currentCharacter.Value = data.CurrentCharacter
	currentCharacter.Parent = stats
	
	local combatStyle = Instance.new("StringValue")
	combatStyle.Name = "CombatStyle"
	combatStyle.Value = data.CombatStyle
	combatStyle.Parent = stats
	
	local transformationLevel = Instance.new("IntValue")
	transformationLevel.Name = "TransformationLevel"
	transformationLevel.Value = data.TransformationLevel
	transformationLevel.Parent = stats
	
	print("[DataStore] Données initialisées pour: " .. player.Name)
end

-- Sauvegarder et nettoyer lors du départ d'un joueur
function DataStoreServiceModule.CleanupPlayerData(player)
	local userId = player.UserId
	
	-- Sauvegarder les données avant le départ
	if playerDataCache[userId] then
		DataStoreServiceModule.SavePlayerData(player, playerDataCache[userId])
	end
	
	if playerInventoryCache[userId] then
		DataStoreServiceModule.SaveInventory(player, playerInventoryCache[userId])
	end
	
	if playerCharactersCache[userId] then
		DataStoreServiceModule.SaveCharacters(player, playerCharactersCache[userId])
	end
	
	-- Nettoyer le cache
	playerDataCache[userId] = nil
	playerInventoryCache[userId] = nil
	playerCharactersCache[userId] = nil
	
	print("[DataStore] Données sauvegardées et nettoyées pour: " .. player.Name)
end

-- ============================================================================
-- FONCTIONS DE MODIFICATION DES DONNÉES
-- ============================================================================

-- Ajouter de l'XP et gérer le level up
function DataStoreServiceModule.AddXP(player, amount)
	local data = playerDataCache[player.UserId]
	if not data then return false end
	
	-- Appliquer le bonus Gamepass Double XP
	local doubleXP = data.Gamepasses and data.Gamepasses.DoubleXP or false
	local finalAmount = doubleXP and amount * 2 or amount
	
	data.XP = data.XP + finalAmount
	
	-- Vérifier le level up
	while data.XP >= data.XPToNextLevel do
		data.XP = data.XP - data.XPToNextLevel
		data.Level = data.Level + 1
		data.XPToNextLevel = math.floor(data.XPToNextLevel * 1.2) -- 20% plus d XP pour le prochain niveau
		data.PointsToSpend = data.PointsToSpend + 3
		
		-- Mise à jour du leaderstats
		local leaderstats = player:FindFirstChild("leaderstats")
		if leaderstats then
			leaderstats.Level.Value = data.Level
			leaderstats.XP.Value = data.XP
		end
		
		-- Mise à jour des points à dépenser
		local stats = player:FindFirstChild("Stats")
		if stats then
			stats.PointsToSpend.Value = data.PointsToSpend
		end
		
		print("[DataStore] Level up! Nouveau niveau: " .. data.Level)
	end
	
	-- Mise à jour du leaderstats
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		leaderstats.XP.Value = data.XP
	end
	
	return true
end

-- Ajouter des pièces
function DataStoreServiceModule.AddCoins(player, amount)
	local data = playerDataCache[player.UserId]
	if not data then return false end
	
	-- Appliquer le bonus Gamepass Double Money
	local doubleMoney = data.Gamepasses and data.Gamepasses.DoubleMoney or false
	local finalAmount = doubleMoney and amount * 2 or amount
	
	data.Coins = data.Coins + finalAmount
	
	-- Mise à jour du leaderstats
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		leaderstats.Coins.Value = data.Coins
	end
	
	return true
end

-- Ajouter des gemmes
function DataStoreServiceModule.AddGems(player, amount)
	local data = playerDataCache[player.UserId]
	if not data then return false end
	
	-- Appliquer le bonus Gamepass Double Gems
	local doubleGems = data.Gamepasses and data.Gamepasses.DoubleGems or false
	local finalAmount = doubleGems and amount * 2 or amount
	
	data.Gems = data.Gems + finalAmount
	
	-- Mise à jour du leaderstats
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		leaderstats.Gems.Value = data.Gems
	end
	
	return true
end

-- Dépenser des gemmes
function DataStoreServiceModule.SpendGems(player, amount)
	local data = playerDataCache[player.UserId]
	if not data then return false end
	if data.Gems < amount then return false end
	
	data.Gems = data.Gems - amount
	
	-- Mise à jour du leaderstats
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		leaderstats.Gems.Value = data.Gems
	end
	
	return true
end

-- Dépenser des pièces
function DataStoreServiceModule.SpendCoins(player, amount)
	local data = playerDataCache[player.UserId]
	if not data then return false end
	if data.Coins < amount then return false end
	
	data.Coins = data.Coins - amount
	
	-- Mise à jour du leaderstats
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		leaderstats.Coins.Value = data.Coins
	end
	
	return true
end

-- Allouer un point de statistique
function DataStoreServiceModule.AllocateStatPoint(player, statName)
	local data = playerDataCache[player.UserId]
	if not data then return false end
	if data.PointsToSpend <= 0 then return false end
	
	if data[statName] then
		data[statName] = data[statName] + 1
		data.PointsToSpend = data.PointsToSpend - 1
		
		-- Mise à jour des stats
		local stats = player:FindFirstChild("Stats")
		if stats and stats:FindFirstChild(statName) then
			stats[statName].Value = data[statName]
		end
		
		if stats and stats:FindFirstChild("PointsToSpend") then
			stats.PointsToSpend.Value = data.PointsToSpend
		end
		
		return true
	end
	
	return false
end

-- Débloquer un personnage
function DataStoreServiceModule.UnlockCharacter(player, characterName)
	local characters = playerCharactersCache[player.UserId]
	if not characters then return false end
	
	characters.UnlockedCharacters[characterName] = true
	
	return true
end

-- Vérifier si un personnage est débloqué
function DataStoreServiceModule.IsCharacterUnlocked(player, characterName)
	local characters = playerCharactersCache[player.UserId]
	if not characters then return false end
	
	return characters.UnlockedCharacters[characterName] or false
end

-- Acheter un Gamepass
function DataStoreServiceModule.BuyGamepass(player, gamepassName)
	local data = playerDataCache[player.UserId]
	if not data then return false end
	
	if not data.Gamepasses then
		data.Gamepasses = {}
	end
	
	data.Gamepasses[gamepassName] = true
	
	return true
end

-- ============================================================================
-- CONNEXION DES ÉVÉNEMENTS
-- ============================================================================

-- Sauvegarder automatiquement toutes les 60 secondes
task.spawn(function()
	while true do
		task.wait(60)
		
		-- Sauvegarder tous les joueurs connectés
		for _, player in ipairs(Players:GetPlayers()) do
			local userId = player.UserId
			if playerDataCache[userId] then
				DataStoreServiceModule.SavePlayerData(player, playerDataCache[userId])
				DataStoreServiceModule.SaveInventory(player, playerInventoryCache[userId])
				DataStoreServiceModule.SaveCharacters(player, playerCharactersCache[userId])
			end
		end
		
		print("[DataStore] Sauvegarde automatique terminée")
	end
end)

print("[DataStore] Service de sauvegarde prêt!")

return DataStoreServiceModule
