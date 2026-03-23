-- ============================================================================
-- FRUIT ODYSSEY - GACHA SERVICE
-- ============================================================================

local Races = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Races"))
local Clans = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Clans"))
local Attributes = require(game.ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Attributes"))

local ROLL_COST = 10 -- Gems

local GachaService = {}

function GachaService.RollRace(player)
	local ProfileService = require(script.Parent.ProfileService)
	local data = ProfileService.GetPlayerData(player)
	
	if not data then return {Success = false, Message = "Erreur de données"} end
	
	if data.Gems < ROLL_COST then
		return {Success = false, Message = "Pas assez de gemmes! (10 requises)"}
	end
	
	data.Gems = data.Gems - ROLL_COST
	
	-- Update gems display
	if player:FindFirstChild("leaderstats") then
		player.leaderstats.Gems.Value = data.Gems
	end
	
	local result = Races.GetRandomRace()
	
	data.CurrentRace = result.Name
	
	if data.Unlocks and data.Unlocks.UnlockedRaces then
		data.Unlocks.UnlockedRaces[result.Name] = true
	end
	
	return {
		Success = true,
		Type = "Race",
		Name = result.Name,
		Rarity = result.Data.Rarity,
		HP_Multiplier = result.Data.HP_Multiplier,
		Damage_Multiplier = result.Data.Damage_Multiplier
	}
end

function GachaService.RollClan(player)
	local ProfileService = require(script.Parent.ProfileService)
	local data = ProfileService.GetPlayerData(player)
	
	if not data then return {Success = false, Message = "Erreur de données"} end
	
	if data.Gems < ROLL_COST then
		return {Success = false, Message = "Pas assez de gemmes! (10 requises)"}
	end
	
	data.Gems = data.Gems - ROLL_COST
	
	if player:FindFirstChild("leaderstats") then
		player.leaderstats.Gems.Value = data.Gems
	end
	
	local result = Clans.GetRandomClan()
	
	data.CurrentClan = result.Name
	
	if data.Unlocks and data.Unlocks.UnlockedClans then
		data.Unlocks.UnlockedClans[result.Name] = true
	end
	
	return {
		Success = true,
		Type = "Clan",
		Name = result.Name,
		Rarity = result.Data.Rarity,
		HP_Multiplier = result.Data.HP_Multiplier,
		Damage_Multiplier = result.Data.Damage_Multiplier
	}
end

function GachaService.RollAttribute(player)
	local ProfileService = require(script.Parent.ProfileService)
	local data = ProfileService.GetPlayerData(player)
	
	if not data then return {Success = false, Message = "Erreur de données"} end
	
	if data.Gems < ROLL_COST then
		return {Success = false, Message = "Pas assez de gemmes! (10 requises)"}
	end
	
	data.Gems = data.Gems - ROLL_COST
	
	if player:FindFirstChild("leaderstats") then
		player.leaderstats.Gems.Value = data.Gems
	end
	
	local result = Attributes.GetRandomAttribute()
	
	data.CurrentAttribute = result.Name
	
	if data.Unlocks and data.Unlocks.UnlockedAttributes then
		data.Unlocks.UnlockedAttributes[result.Name] = true
	end
	
	return {
		Success = true,
		Type = "Attribute",
		Name = result.Name,
		Rarity = result.Data.Rarity,
		HP_Multiplier = result.Data.HP_Multiplier,
		Damage_Multiplier = result.Data.Damage_Multiplier
	}
end

print("[Gacha] Service prêt!")
return GachaService
