-- ============================================================================
-- FRUIT ODYSSEY - RACES SIMPLIFIÉES
-- Affecte uniquement HP et Dégâts
-- ============================================================================

local Races = {}

Races.List = {
	["Human"] = {
		Rarity = "Common",
		HP_Multiplier = 1.0,
		Damage_Multiplier = 1.0
	},
	
	["HumanPlus"] = {
		Rarity = "Uncommon",
		HP_Multiplier = 1.15,
		Damage_Multiplier = 1.15
	},
	
	["QuirkUser"] = {
		Rarity = "Uncommon",
		HP_Multiplier = 1.1,
		Damage_Multiplier = 1.2
	},
	
	["Shinigami"] = {
		Rarity = "Rare",
		HP_Multiplier = 1.2,
		Damage_Multiplier = 1.3
	},
	
	["Wizard"] = {
		Rarity = "Rare",
		HP_Multiplier = 1.1,
		Damage_Multiplier = 1.4
	},
	
	["Demon"] = {
		Rarity = "Rare",
		HP_Multiplier = 1.4,
		Damage_Multiplier = 1.25
	},
	
	["Saiyan"] = {
		Rarity = "Epic",
		HP_Multiplier = 1.3,
		Damage_Multiplier = 1.5
	},
	
	["Hollow"] = {
		Rarity = "Epic",
		HP_Multiplier = 1.25,
		Damage_Multiplier = 1.55
	},
	
	["Slayer"] = {
		Rarity = "Epic",
		HP_Multiplier = 1.35,
		Damage_Multiplier = 1.4
	},
	
	["Hybrid"] = {
		Rarity = "Legendary",
		HP_Multiplier = 1.5,
		Damage_Multiplier = 1.6
	},
	
	["Royal"] = {
		Rarity = "Legendary",
		HP_Multiplier = 1.45,
		Damage_Multiplier = 1.65
	},
	
	["Ancient"] = {
		Rarity = "Legendary",
		HP_Multiplier = 1.35,
		Damage_Multiplier = 1.8
	},
	
	["God"] = {
		Rarity = "Mythic",
		HP_Multiplier = 2.0,
		Damage_Multiplier = 2.0
	},
	
	["Dragon"] = {
		Rarity = "Mythic",
		HP_Multiplier = 2.2,
		Damage_Multiplier = 1.9
	},
	
	["Angel"] = {
		Rarity = "Mythic",
		HP_Multiplier = 1.8,
		Damage_Multiplier = 1.8
	}
}

-- Tirer une race aléatoire
function Races.GetRandomRace()
	local rarities = {
		{Name = "Common", Weight = 40},
		{Name = "Uncommon", Weight = 25},
		{Name = "Rare", Weight = 18},
		{Name = "Epic", Weight = 10},
		{Name = "Legendary", Weight = 5},
		{Name = "Mythic", Weight = 2}
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
			for raceName, raceData in pairs(Races.List) do
				if raceData.Rarity == r.Name then
					table.insert(candidates, {Name = raceName, Data = raceData})
				end
			end
			
			if #candidates > 0 then
				local chosen = candidates[math.random(#candidates)]
				return chosen
			end
		end
	end
	
	return {Name = "Human", Data = Races.List["Human"]}
end

return Races
