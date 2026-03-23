-- ============================================================================
-- FRUIT ODYSSEY - ATTRIBUTS SIMPLIFIÉS
-- Affecte uniquement HP et Dégâts
-- ============================================================================

local Attributes = {}

Attributes.List = {
	["Wind"] = {
		Rarity = "Common",
		HP_Multiplier = 1.0,
		Damage_Multiplier = 1.0
	},
	
	["Earth"] = {
		Rarity = "Common",
		HP_Multiplier = 1.2,
		Damage_Multiplier = 1.0
	},
	
	["Water"] = {
		Rarity = "Uncommon",
		HP_Multiplier = 1.1,
		Damage_Multiplier = 1.1
	},
	
	["Fire"] = {
		Rarity = "Uncommon",
		HP_Multiplier = 1.0,
		Damage_Multiplier = 1.25
	},
	
	["Ice"] = {
		Rarity = "Uncommon",
		HP_Multiplier = 1.15,
		Damage_Multiplier = 1.1
	},
	
	["Lightning"] = {
		Rarity = "Rare",
		HP_Multiplier = 1.0,
		Damage_Multiplier = 1.35
	},
	
	["Poison"] = {
		Rarity = "Rare",
		HP_Multiplier = 1.1,
		Damage_Multiplier = 1.3
	},
	
	["Light"] = {
		Rarity = "Epic",
		HP_Multiplier = 1.25,
		Damage_Multiplier = 1.35
	},
	
	["Metal"] = {
		Rarity = "Epic",
		HP_Multiplier = 1.5,
		Damage_Multiplier = 1.2
	},
	
	["Darkness"] = {
		Rarity = "Legendary",
		HP_Multiplier = 1.3,
		Damage_Multiplier = 1.6
	},
	
	["Time"] = {
		Rarity = "Legendary",
		HP_Multiplier = 1.2,
		Damage_Multiplier = 1.5
	},
	
	["Space"] = {
		Rarity = "Legendary",
		HP_Multiplier = 1.35,
		Damage_Multiplier = 1.55
	},
	
	["Reality"] = {
		Rarity = "Mythic",
		HP_Multiplier = 1.5,
		Damage_Multiplier = 2.0
	},
	
	["Soul"] = {
		Rarity = "Mythic",
		HP_Multiplier = 1.8,
		Damage_Multiplier = 1.8
	},
	
	["Cosmic"] = {
		Rarity = "Mythic",
		HP_Multiplier = 1.6,
		Damage_Multiplier = 2.2
	},
	
	["Divine"] = {
		Rarity = "Mythic",
		HP_Multiplier = 2.0,
		Damage_Multiplier = 2.0
	}
}

-- Tirer un attribut aléatoire
function Attributes.GetRandomAttribute()
	local rarities = {
		{Name = "Common", Weight = 50},
		{Name = "Uncommon", Weight = 25},
		{Name = "Rare", Weight = 15},
		{Name = "Epic", Weight = 7},
		{Name = "Legendary", Weight = 2.5},
		{Name = "Mythic", Weight = 0.5}
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
			for attrName, attrData in pairs(Attributes.List) do
				if attrData.Rarity == r.Name then
					table.insert(candidates, {Name = attrName, Data = attrData})
				end
			end
			
			if #candidates > 0 then
				local chosen = candidates[math.random(#candidates)]
				return chosen
			end
		end
	end
	
	return {Name = "Wind", Data = Attributes.List["Wind"]}
end

return Attributes
