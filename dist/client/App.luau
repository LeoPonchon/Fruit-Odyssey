-- Compiled with roblox-ts v3.0.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("Include"):WaitForChild("RuntimeLib"))
--/ <reference types="@rbxts/types" />
local _react = TS.import(script, game:GetService("ReplicatedStorage"), "node_modules", "@rbxts", "react")
local React = _react
local useState = _react.useState
-- ============================================================================
-- COULEURS RPG
-- ============================================================================
local COLORS = {
	Primary = Color3.new(0.8, 0.6, 0.2),
	Background = Color3.new(0.05, 0.05, 0.08),
	Panel = Color3.new(0.1, 0.1, 0.12),
	PanelLight = Color3.new(0.15, 0.15, 0.18),
	Text = Color3.new(0.9, 0.9, 0.9),
	TextSecondary = Color3.new(0.6, 0.6, 0.65),
	HP = Color3.new(0.9, 0.2, 0.2),
	HPBackground = Color3.new(0.2, 0.1, 0.1),
	Blue = Color3.new(0.2, 0.5, 0.9),
	Purple = Color3.new(0.6, 0.3, 0.9),
	Green = Color3.new(0.3, 0.7, 0.4),
}
-- ============================================================================
-- TYPES
-- ============================================================================
-- ============================================================================
-- COMPOSANTS
-- ============================================================================
local function ModernButton(props)
	local buttonColor = props.color or COLORS.PanelLight
	return React.createElement("textbutton", {
		key = props.name,
		Size = props.size,
		Position = props.position,
		Text = props.text,
		TextColor3 = COLORS.Text,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		BackgroundColor3 = buttonColor,
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0,
		AutoButtonColor = true,
		Event = {
			MouseButton1Click = props.onClick or (function() end),
		},
	})
end
local function PopupFrame(props)
	return React.createElement("frame", {
		key = props.keyName,
		Size = props.size,
		Position = props.position,
		BackgroundColor3 = COLORS.Background,
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0,
	}, React.createElement("textlabel", {
		key = "Title",
		Size = UDim2.new(1, 0, 0, 40),
		Text = props.title,
		TextColor3 = COLORS.Primary,
		TextSize = 24,
		Font = Enum.Font.GothamBold,
		BackgroundTransparency = 1,
	}), React.createElement("textbutton", {
		key = "Close",
		Size = UDim2.new(0, 30, 0, 30),
		Position = UDim2.new(1, -40, 0, 5),
		Text = "✕",
		TextColor3 = COLORS.Text,
		TextSize = 16,
		BackgroundColor3 = COLORS.HP,
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		AutoButtonColor = true,
		Event = {
			MouseButton1Click = props.onClose,
		},
	}), React.createElement("frame", {
		key = "Content",
		Size = UDim2.new(1, -20, 1, -50),
		Position = UDim2.new(0, 10, 0, 45),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, props.children))
end
-- ============================================================================
-- UI PRINCIPALE
-- ============================================================================
local function App()
	local playerData, setPlayerData = useState({
		Level = 1,
		XP = 0,
		XPToNextLevel = 100,
		Coins = 100,
		Gems = 50,
		Strength = 0,
		Speed = 0,
		Stamina = 0,
		Vitality = 0,
		Precision = 0,
		Luck = 0,
		PointsToSpend = 5,
		CurrentRace = "Humain",
		CurrentClan = "Aucun",
		CurrentAttribute = "Aucun",
		CombatStyle = "Melee",
		TransformationLevel = 0,
	})
	local inventory = useState({ {
		name = "Épée en fer",
		quantity = 1,
		rarity = "Commun",
	}, {
		name = "Potion de soin",
		quantity = 5,
		rarity = "Commun",
	}, {
		name = "Gemme mystique",
		quantity = 3,
		rarity = "Rare",
	} })
	local showStats, setShowStats = useState(false)
	local showWish, setShowWish = useState(false)
	local showInventory, setShowInventory = useState(false)
	local showSettings, setShowSettings = useState(false)
	local strPoints, setStrPoints = useState("1")
	local spdPoints, setSpdPoints = useState("1")
	local staPoints, setStaPoints = useState("1")
	local vitPoints, setVitPoints = useState("1")
	local prePoints, setPrePoints = useState("1")
	local lckPoints, setLckPoints = useState("1")
	local hp = 100
	local maxHp = 100
	local hpPercent = if maxHp > 0 then hp / maxHp else 0
	-- Fonctions pour ajouter des points de stats
	local addStat = function(statName)
		local pointsToAdd = 1
		if statName == "Strength" then
			local _condition = tonumber(strPoints)
			if not (_condition ~= 0 and _condition == _condition and _condition) then
				_condition = 1
			end
			pointsToAdd = _condition
		end
		if statName == "Speed" then
			local _condition = tonumber(spdPoints)
			if not (_condition ~= 0 and _condition == _condition and _condition) then
				_condition = 1
			end
			pointsToAdd = _condition
		end
		if statName == "Stamina" then
			local _condition = tonumber(staPoints)
			if not (_condition ~= 0 and _condition == _condition and _condition) then
				_condition = 1
			end
			pointsToAdd = _condition
		end
		if statName == "Vitality" then
			local _condition = tonumber(vitPoints)
			if not (_condition ~= 0 and _condition == _condition and _condition) then
				_condition = 1
			end
			pointsToAdd = _condition
		end
		if statName == "Precision" then
			local _condition = tonumber(prePoints)
			if not (_condition ~= 0 and _condition == _condition and _condition) then
				_condition = 1
			end
			pointsToAdd = _condition
		end
		if statName == "Luck" then
			local _condition = tonumber(lckPoints)
			if not (_condition ~= 0 and _condition == _condition and _condition) then
				_condition = 1
			end
			pointsToAdd = _condition
		end
		pointsToAdd = math.max(1, pointsToAdd)
		if playerData.PointsToSpend >= pointsToAdd then
			-- Mise à jour locale
			setPlayerData(function(prev)
				local _object = table.clone(prev)
				setmetatable(_object, nil)
				local newData = _object
				if statName == "Strength" then
					newData.Strength += pointsToAdd
				end
				if statName == "Speed" then
					newData.Speed += pointsToAdd
				end
				if statName == "Stamina" then
					newData.Stamina += pointsToAdd
				end
				if statName == "Vitality" then
					newData.Vitality += pointsToAdd
				end
				if statName == "Precision" then
					newData.Precision += pointsToAdd
				end
				if statName == "Luck" then
					newData.Luck += pointsToAdd
				end
				newData.PointsToSpend -= pointsToAdd
				return newData
			end)
			print("[UI] +" .. tostring(pointsToAdd) .. " à " .. statName)
		else
			print("[UI] Pas assez de points!")
		end
	end
	local handleWishRace = function()
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local rollEvent = ReplicatedStorage:FindFirstChild("RollRace")
		if rollEvent and playerData.Gems >= 10 then
			local result = rollEvent:InvokeServer()
			print("[Wish] Race result: " .. tostring(result))
		else
			print("[Wish] Pas assez de gemmes ou pas de serveur!")
		end
	end
	local handleWishClan = function()
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local rollEvent = ReplicatedStorage:FindFirstChild("RollClan")
		if rollEvent and playerData.Gems >= 10 then
			local result = rollEvent:InvokeServer()
			print("[Wish] Clan result: " .. tostring(result))
		else
			print("[Wish] Pas assez de gemmes ou pas de serveur!")
		end
	end
	local handleWishAttribute = function()
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local rollEvent = ReplicatedStorage:FindFirstChild("RollAttribute")
		if rollEvent and playerData.Gems >= 10 then
			local result = rollEvent:InvokeServer()
			print("[Wish] Attribute result: " .. tostring(result))
		else
			print("[Wish] Pas assez de gemmes ou pas de serveur!")
		end
	end
	local _exp = React.createElement("frame", {
		key = "HPBarContainer",
		Size = UDim2.new(0, 300, 0, 40),
		Position = UDim2.new(0.5, -150, 1, -120),
		BackgroundColor3 = COLORS.Background,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, React.createElement("frame", {
		key = "HPBackground",
		Size = UDim2.new(1, -10, 0, 20),
		Position = UDim2.new(0, 5, 0.5, -10),
		BackgroundColor3 = COLORS.HPBackground,
		BorderSizePixel = 0,
	}, React.createElement("frame", {
		key = "HPFill",
		Size = UDim2.new(hpPercent, 0, 1, 0),
		BackgroundColor3 = COLORS.HP,
		BorderSizePixel = 0,
	})), React.createElement("textlabel", {
		key = "HPText",
		Size = UDim2.new(1, 0, 0, 18),
		Text = `{hp} / {maxHp}`,
		TextColor3 = COLORS.Text,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0.5, -9),
	}))
	local _exp_1 = React.createElement("frame", {
		key = "ButtonsContainer",
		Size = UDim2.new(0, 200, 0, 180),
		Position = UDim2.new(0, 10, 1, -190),
		BackgroundColor3 = COLORS.Background,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, React.createElement(ModernButton, {
		name = "Stats",
		text = "📊 Stats",
		size = UDim2.new(0.9, 0, 0, 35),
		position = UDim2.new(0.05, 0, 0, 5),
		color = COLORS.Primary,
		onClick = function()
			return setShowStats(not showStats)
		end,
	}), React.createElement(ModernButton, {
		name = "Wish",
		text = "🎰 Wish",
		size = UDim2.new(0.9, 0, 0, 35),
		position = UDim2.new(0.05, 0, 0, 45),
		color = COLORS.Purple,
		onClick = function()
			return setShowWish(not showWish)
		end,
	}), React.createElement(ModernButton, {
		name = "Inventory",
		text = "🎒 Inventaire",
		size = UDim2.new(0.9, 0, 0, 35),
		position = UDim2.new(0.05, 0, 0, 85),
		color = COLORS.Blue,
		onClick = function()
			return setShowInventory(not showInventory)
		end,
	}), React.createElement(ModernButton, {
		name = "Settings",
		text = "⚙️ Paramètres",
		size = UDim2.new(0.9, 0, 0, 35),
		position = UDim2.new(0.05, 0, 0, 125),
		color = COLORS.PanelLight,
		onClick = function()
			return setShowSettings(not showSettings)
		end,
	}))
	local _exp_2 = showStats and (React.createElement(PopupFrame, {
		keyName = "StatsPopup",
		title = "📊 STATS",
		size = UDim2.new(0, 450, 0, 520),
		position = UDim2.new(0.5, -225, 0.5, -260),
		onClose = function()
			return setShowStats(false)
		end,
	}, React.createElement("textlabel", {
		key = "PointsAvailable",
		Size = UDim2.new(1, 0, 0, 30),
		Text = `Points disponibles: {playerData.PointsToSpend}`,
		TextColor3 = COLORS.Primary,
		TextSize = 18,
		Font = Enum.Font.GothamBold,
		BackgroundTransparency = 1,
	}), React.createElement("textlabel", {
		key = "LevelInfo",
		Size = UDim2.new(1, 0, 0, 25),
		Position = UDim2.new(0, 0, 0, 35),
		Text = `Niveau {playerData.Level} | XP: {playerData.XP}/{playerData.XPToNextLevel}`,
		TextColor3 = COLORS.TextSecondary,
		TextSize = 14,
		Font = Enum.Font.Gotham,
		BackgroundTransparency = 1,
	}), React.createElement("frame", {
		key = "CurrentChar",
		Size = UDim2.new(1, 0, 0, 35),
		Position = UDim2.new(0, 0, 0, 65),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, React.createElement("textlabel", {
		Size = UDim2.new(1, 0, 1, 0),
		Text = `Race: {playerData.CurrentRace} | Clan: {playerData.CurrentClan}`,
		TextColor3 = COLORS.Purple,
		TextSize = 12,
		BackgroundTransparency = 1,
	})), React.createElement("frame", {
		key = "CurrentAttr",
		Size = UDim2.new(1, 0, 0, 30),
		Position = UDim2.new(0, 0, 0, 95),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, React.createElement("textlabel", {
		Size = UDim2.new(1, 0, 1, 0),
		Text = `Attribut: {playerData.CurrentAttribute}`,
		TextColor3 = COLORS.Green,
		TextSize = 12,
		BackgroundTransparency = 1,
	})), React.createElement("frame", {
		key = "STR",
		Size = UDim2.new(1, 0, 0, 35),
		Position = UDim2.new(0, 0, 0, 130),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, React.createElement("textlabel", {
		Size = UDim2.new(0.4, 0, 1, 0),
		Text = `Force: {playerData.Strength}`,
		TextColor3 = COLORS.Text,
		TextSize = 14,
		BackgroundTransparency = 1,
	}), React.createElement("textbox", {
		Size = UDim2.new(0.2, 0, 0, 25),
		Position = UDim2.new(0.4, 0, 0, 5),
		Text = strPoints,
		TextColor3 = COLORS.Text,
		TextSize = 12,
		BackgroundColor3 = COLORS.Panel,
		BorderSizePixel = 0,
	}), React.createElement(ModernButton, {
		name = "STRAdd",
		text = "+",
		size = UDim2.new(0.15, 0, 0, 25),
		position = UDim2.new(0.65, 0, 0, 5),
		color = COLORS.Green,
		onClick = function()
			return addStat("Strength")
		end,
	})), React.createElement("frame", {
		key = "SPD",
		Size = UDim2.new(1, 0, 0, 35),
		Position = UDim2.new(0, 0, 0, 170),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, React.createElement("textlabel", {
		Size = UDim2.new(0.4, 0, 1, 0),
		Text = `Vitesse: {playerData.Speed}`,
		TextColor3 = COLORS.Text,
		TextSize = 14,
		BackgroundTransparency = 1,
	}), React.createElement("textbox", {
		Size = UDim2.new(0.2, 0, 0, 25),
		Position = UDim2.new(0.4, 0, 0, 5),
		Text = spdPoints,
		TextColor3 = COLORS.Text,
		TextSize = 12,
		BackgroundColor3 = COLORS.Panel,
		BorderSizePixel = 0,
	}), React.createElement(ModernButton, {
		name = "SPDAdd",
		text = "+",
		size = UDim2.new(0.15, 0, 0, 25),
		position = UDim2.new(0.65, 0, 0, 5),
		color = COLORS.Green,
		onClick = function()
			return addStat("Speed")
		end,
	})), React.createElement("frame", {
		key = "STA",
		Size = UDim2.new(1, 0, 0, 35),
		Position = UDim2.new(0, 0, 0, 210),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, React.createElement("textlabel", {
		Size = UDim2.new(0.4, 0, 1, 0),
		Text = `Endurance: {playerData.Stamina}`,
		TextColor3 = COLORS.Text,
		TextSize = 14,
		BackgroundTransparency = 1,
	}), React.createElement("textbox", {
		Size = UDim2.new(0.2, 0, 0, 25),
		Position = UDim2.new(0.4, 0, 0, 5),
		Text = staPoints,
		TextColor3 = COLORS.Text,
		TextSize = 12,
		BackgroundColor3 = COLORS.Panel,
		BorderSizePixel = 0,
	}), React.createElement(ModernButton, {
		name = "STAAdd",
		text = "+",
		size = UDim2.new(0.15, 0, 0, 25),
		position = UDim2.new(0.65, 0, 0, 5),
		color = COLORS.Green,
		onClick = function()
			return addStat("Stamina")
		end,
	})), React.createElement("frame", {
		key = "VIT",
		Size = UDim2.new(1, 0, 0, 35),
		Position = UDim2.new(0, 0, 0, 250),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, React.createElement("textlabel", {
		Size = UDim2.new(0.4, 0, 1, 0),
		Text = `Vitalité: {playerData.Vitality}`,
		TextColor3 = COLORS.Text,
		TextSize = 14,
		BackgroundTransparency = 1,
	}), React.createElement("textbox", {
		Size = UDim2.new(0.2, 0, 0, 25),
		Position = UDim2.new(0.4, 0, 0, 5),
		Text = vitPoints,
		TextColor3 = COLORS.Text,
		TextSize = 12,
		BackgroundColor3 = COLORS.Panel,
		BorderSizePixel = 0,
	}), React.createElement(ModernButton, {
		name = "VITAdd",
		text = "+",
		size = UDim2.new(0.15, 0, 0, 25),
		position = UDim2.new(0.65, 0, 0, 5),
		color = COLORS.Green,
		onClick = function()
			return addStat("Vitality")
		end,
	})), React.createElement("frame", {
		key = "PRE",
		Size = UDim2.new(1, 0, 0, 35),
		Position = UDim2.new(0, 0, 0, 290),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, React.createElement("textlabel", {
		Size = UDim2.new(0.4, 0, 1, 0),
		Text = `Précision: {playerData.Precision}`,
		TextColor3 = COLORS.Text,
		TextSize = 14,
		BackgroundTransparency = 1,
	}), React.createElement("textbox", {
		Size = UDim2.new(0.2, 0, 0, 25),
		Position = UDim2.new(0.4, 0, 0, 5),
		Text = prePoints,
		TextColor3 = COLORS.Text,
		TextSize = 12,
		BackgroundColor3 = COLORS.Panel,
		BorderSizePixel = 0,
	}), React.createElement(ModernButton, {
		name = "PREAdd",
		text = "+",
		size = UDim2.new(0.15, 0, 0, 25),
		position = UDim2.new(0.65, 0, 0, 5),
		color = COLORS.Green,
		onClick = function()
			return addStat("Precision")
		end,
	})), React.createElement("frame", {
		key = "LCK",
		Size = UDim2.new(1, 0, 0, 35),
		Position = UDim2.new(0, 0, 0, 330),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, React.createElement("textlabel", {
		Size = UDim2.new(0.4, 0, 1, 0),
		Text = `Chance: {playerData.Luck}`,
		TextColor3 = COLORS.Text,
		TextSize = 14,
		BackgroundTransparency = 1,
	}), React.createElement("textbox", {
		Size = UDim2.new(0.2, 0, 0, 25),
		Position = UDim2.new(0.4, 0, 0, 5),
		Text = lckPoints,
		TextColor3 = COLORS.Text,
		TextSize = 12,
		BackgroundColor3 = COLORS.Panel,
		BorderSizePixel = 0,
	}), React.createElement(ModernButton, {
		name = "LCKAdd",
		text = "+",
		size = UDim2.new(0.15, 0, 0, 25),
		position = UDim2.new(0.65, 0, 0, 5),
		color = COLORS.Green,
		onClick = function()
			return addStat("Luck")
		end,
	})), React.createElement("frame", {
		key = "Currency",
		Size = UDim2.new(1, 0, 0, 40),
		Position = UDim2.new(0, 0, 0, 380),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, React.createElement("textlabel", {
		Size = UDim2.new(0.5, 0, 0, 25),
		Text = `🪙 {playerData.Coins}`,
		TextColor3 = COLORS.Primary,
		TextSize = 16,
		Font = Enum.Font.GothamBold,
		BackgroundTransparency = 1,
	}), React.createElement("textlabel", {
		Size = UDim2.new(0.5, 0, 0, 25),
		Position = UDim2.new(0.5, 0, 0, 0),
		Text = `💎 {playerData.Gems}`,
		TextColor3 = COLORS.Blue,
		TextSize = 16,
		Font = Enum.Font.GothamBold,
		BackgroundTransparency = 1,
	}))))
	local _exp_3 = showWish and (React.createElement(PopupFrame, {
		keyName = "WishPopup",
		title = "🎰 WISH",
		size = UDim2.new(0, 350, 0, 300),
		position = UDim2.new(0.5, -175, 0.5, -150),
		onClose = function()
			return setShowWish(false)
		end,
	}, React.createElement("textlabel", {
		key = "Desc",
		Size = UDim2.new(1, 0, 0, 30),
		Text = `Vos gemmes: {playerData.Gems}`,
		TextColor3 = COLORS.Blue,
		TextSize = 14,
		BackgroundTransparency = 1,
	}), React.createElement("textlabel", {
		key = "Desc2",
		Size = UDim2.new(1, 0, 0, 30),
		Position = UDim2.new(0, 0, 0, 20),
		Text = "Choisissez votre type de wish",
		TextColor3 = COLORS.TextSecondary,
		TextSize = 14,
		BackgroundTransparency = 1,
	}), React.createElement(ModernButton, {
		name = "WishRace",
		text = "🏃 Race (10 💎)",
		size = UDim2.new(0.9, 0, 0, 40),
		position = UDim2.new(0.05, 0, 0, 55),
		color = COLORS.Blue,
		onClick = handleWishRace,
	}), React.createElement(ModernButton, {
		name = "WishClan",
		text = "👥 Clan (10 💎)",
		size = UDim2.new(0.9, 0, 0, 40),
		position = UDim2.new(0.05, 0, 0, 105),
		color = COLORS.Purple,
		onClick = handleWishClan,
	}), React.createElement(ModernButton, {
		name = "WishAttribute",
		text = "⚡ Attribut (10 💎)",
		size = UDim2.new(0.9, 0, 0, 40),
		position = UDim2.new(0.05, 0, 0, 155),
		color = COLORS.Green,
		onClick = handleWishAttribute,
	})))
	local _condition = showInventory
	if _condition then
		-- ▼ ReadonlyArray.map ▼
		local _newValue = table.create(#inventory)
		local _callback = function(item, index)
			return React.createElement("frame", {
				key = `Item{index}`,
				Size = UDim2.new(1, 0, 0, 40),
				Position = UDim2.new(0, 0, 0, index * 45),
				BackgroundColor3 = COLORS.PanelLight,
				BackgroundTransparency = 0.5,
				BorderSizePixel = 0,
			}, React.createElement("textlabel", {
				key = "ItemName",
				Size = UDim2.new(0.7, 0, 1, 0),
				Text = item.name,
				TextColor3 = COLORS.Text,
				TextSize = 14,
				Font = Enum.Font.Gotham,
				BackgroundTransparency = 1,
			}), React.createElement("textlabel", {
				key = "ItemQty",
				Size = UDim2.new(0.3, 0, 1, 0),
				Position = UDim2.new(0.7, 0, 0, 0),
				Text = `x{item.quantity}`,
				TextColor3 = COLORS.TextSecondary,
				TextSize = 14,
				BackgroundTransparency = 1,
			}))
		end
		for _k, _v in inventory do
			_newValue[_k] = _callback(_v, _k - 1, inventory)
		end
		-- ▲ ReadonlyArray.map ▲
		_condition = (React.createElement(PopupFrame, {
			keyName = "InventoryPopup",
			title = "🎒 INVENTAIRE",
			size = UDim2.new(0, 400, 0, 400),
			position = UDim2.new(0.5, -200, 0.5, -200),
			onClose = function()
				return setShowInventory(false)
			end,
		}, _newValue))
	end
	return React.createElement("screengui", {
		key = "FruitOdysseyUI",
		ResetOnSpawn = false,
	}, _exp, _exp_1, _exp_2, _exp_3, _condition, showSettings and (React.createElement(PopupFrame, {
		keyName = "SettingsPopup",
		title = "⚙️ PARAMÈTRES",
		size = UDim2.new(0, 350, 0, 350),
		position = UDim2.new(0.5, -175, 0.5, -175),
		onClose = function()
			return setShowSettings(false)
		end,
	}, React.createElement(ModernButton, {
		name = "Music",
		text = "🎵 Musique: ON",
		size = UDim2.new(0.9, 0, 0, 40),
		position = UDim2.new(0.05, 0, 0, 10),
		color = COLORS.Green,
		onClick = function()
			return print("[Settings] Musique!")
		end,
	}), React.createElement(ModernButton, {
		name = "SFX",
		text = "🔊 Effets sonores: ON",
		size = UDim2.new(0.9, 0, 0, 40),
		position = UDim2.new(0.05, 0, 0, 60),
		color = COLORS.Green,
		onClick = function()
			return print("[Settings] SFX!")
		end,
	}), React.createElement(ModernButton, {
		name = "Fullscreen",
		text = "🖥️ Plein écran",
		size = UDim2.new(0.9, 0, 0, 40),
		position = UDim2.new(0.05, 0, 0, 110),
		color = COLORS.Blue,
		onClick = function()
			return print("[Settings] Fullscreen!")
		end,
	}), React.createElement(ModernButton, {
		name = "Quit",
		text = "🚪 Quitter le jeu",
		size = UDim2.new(0.9, 0, 0, 40),
		position = UDim2.new(0.05, 0, 0, 160),
		color = COLORS.HP,
		onClick = function()
			return print("[Settings] Quit!")
		end,
	}))))
end
return {
	default = App,
}
