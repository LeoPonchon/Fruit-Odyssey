-- ============================================================================
-- FRUIT ODYSSEY - CLANS SIMPLIFIÉS
-- Affecte uniquement HP et Dégâts
-- ============================================================================

local Clans = {}

Clans.List = {
	["Kure"] = {
		Rarity = "Common",
		HP_Multiplier = 1.05,
		Damage_Multiplier = 1.05
	},
	
	["Hyuga"] = {
		Rarity = "Common",
		HP_Multiplier = 1.0,
		Damage_Multiplier = 1.1
	},
	
	["Aburame"] = {
		Rarity = "Common",
		HP_Multiplier = 1.05,
		Damage_Multiplier = 1.05
	},
	
	["Uchiha"] = {
		Rarity = "Uncommon",
		HP_Multiplier = 1.1,
		Damage_Multiplier = 1.15
	},
	
	["Senju"] = {
		Rarity = "Uncommon",
		HP_Multiplier = 1.15,
		Damage_Multiplier = 1.1
	},
	
	["Kakashi"] = {
		Rarity = "Uncommon",
		HP_Multiplier = 1.1,
		Damage_Multiplier = 1.15
	},
	
	["Kuchiki"] = {
		Rarity = "Rare",
		HP_Multiplier = 1.15,
		Damage_Multiplier = 1.2
	},
	
	["Shihoin"] = {
		Rarity = "Rare",
		HP_Multiplier = 1.2,
		Damage_Multiplier = 1.15
	},
	
	["Uzumaki"] = {
		Rarity = "Rare",
		HP_Multiplier = 1.25,
		Damage_Multiplier = 1.1
	},
	
	["Zenin"] = {
		Rarity = "Rare",
		HP_Multiplier = 1.1,
		Damage_Multiplier = 1.25
	},
	
	["Hyakugan"] = {
		Rarity = "Epic",
		HP_Multiplier = 1.15,
		Damage_Multiplier = 1.35
	},
	
	["Tsukiyomi"] = {
		Rarity = "Epic",
		HP_Multiplier = 1.1,
		Damage_Multiplier = 1.4
	},
	
	["Kame"] = {
		Rarity = "Epic",
		HP_Multiplier = 1.2,
		Damage_Multiplier = 1.3
	},
	
	["Riyo"] = {
		Rarity = "Epic",
		HP_Multiplier = 1.25,
		Damage_Multiplier = 1.25
	},
	
	["Juubi"] = {
		Rarity = "Legendary",
		HP_Multiplier = 1.4,
		Damage_Multiplier = 1.4
	},
	
	["Otsutsuki"] = {
		Rarity = "Legendary",
		HP_Multiplier = 1.35,
		Damage_Multiplier = 1.5
	},
	
	["Kaguya"] = {
		Rarity = "Legendary",
		HP_Multiplier = 1.4,
		Damage_Multiplier = 1.45
	},
	
	["Celestial"] = {
		Rarity = "Mythic",
		HP_Multiplier = 1.6,
		Damage_Multiplier = 1.6
	},
	
	["Primordial"] = {
		Rarity = "Mythic",
		HP_Multiplier = 1.55,
		Damage_Multiplier = 1.7
	},
	
	["Void"] = {
		Rarity = "Mythic",
		HP_Multiplier = 1.5,
		Damage_Multiplier = 1.8
	}
}

-- Tirer un clan aléatoire
function Clans.GetRandomClan()
	local rarities = {
		{Name = "Common", Weight = 30},
		{Name = "Uncommon", Weight = 25},
		{Name = "Rare", Weight = 20},
		{Name = "Epic", Weight = 14},
		{Name = "Legendary", Weight = 8},
		{Name = "Mythic", Weight = 3}
	}
	
	local totalWeight = 0
	for _, r in ipairs(rarities) do
		totalWeight = totalWeight + r.Weight
	end
	
	local randomValue = math.random() * totalWeight
	local currentWeight = 0
	
	for _, r in ipairs(rarities) do
		currentWeight = currentWeight + r.Weight
		if randomValue <= currentWeight then
			local candidates = {}
			for clanName, clanData in pairs(Clans.List) do
				if clanData.Rarity == r.Name then
					table.insert(candidates, {Name = clanName, Data = clanData})
				end
			end
			
			if #candidates > 0 then
				local chosen = candidates[math.random(#candidates)]
				return chosen
			end
		end
	end
	
	return {Name = "Kure", Data = Clans.List["Kure"]}
end

return Clans
