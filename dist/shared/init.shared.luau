-- ============================================================================
-- FRUIT ODYSSEY - SHARED MODULES
-- Modules partagés entre client et serveur
-- ============================================================================

local Shared = {}

-- Configuration globale du jeu
Shared.GameConfig = {
	MaxLevel = 100,
	BaseXP = 100,
	XPIncreasePerLevel = 1.2,
	StatPointsPerLevel = 3,
	MaxStatValue = 100
}

-- Univers disponibles
Shared.Universes = {
	"OnePiece",
	"Bleach",
	"DBZ",
	"MHA",
	"Naruto",
	"JujutsuKaisen",
	"DemonSlayer"
}

-- Personnages par univers
Shared.Characters = {
	OnePiece = {"Luffy", "Zoro", "Sanji", "Ace", "Shanks"},
	Bleach = {"Ichigo", "Aizen", "Byakuya", "Hitsugaya", "Grimmjow"},
	DBZ = {"Goku", "Gohan", "Vegeta", "Trunks", "Freezer"},
	MHA = {" Deku", "Bakugo", "Todoroki", "AllMight", "Shoto"},
	Naruto = {"Naruto", "Sasuke", "Sakura", "Kakashi", "Itachi"},
	JujutsuKaisen = {"Yuji", "Megumi", "Nobara", "Sukuna", "Gojo"},
	DemonSlayer = {"Tanjiro", "Nezuko", "Zenitsu", "Inosuke", "Rengoku"}
}

-- Races disponibles
Shared.Races = {
	"Human",
	"Saiyan",
	"Shinigami",
	"Demon",
	"HumanPlus",
	"Hybrid"
}

-- Attributs disponibles
Shared.Attributes = {
	"None",
	"Fire",
	"Water",
	"Wind",
	"Earth",
	"Lightning",
	"Ice",
	"Light",
	"Darkness",
	"Poison"
}

-- Noms des statistiques
Shared.StatNames = {
	"Strength",
	"Speed",
	"Stamina",
	"Vitality",
	"Precision",
	"Luck"
}

-- Styles de combat
Shared.CombatStyles = {
	"Melee",
	"Power"
}

-- Types d'objets
Shared.ItemTypes = {
	"Weapon",
	"Consumable",
	"Material",
	"Cosmetic"
}

print("[Shared] Modules partagés chargés!")

return Shared
