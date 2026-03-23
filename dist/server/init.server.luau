-- ============================================================================
-- FRUIT ODYSSEY - SERVER SYSTEMS
-- ============================================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ============================================================================
-- CRÉER LES REMOTE EVENTS
-- ============================================================================

local attackEvent = Instance.new("RemoteEvent")
attackEvent.Name = "Attack"
attackEvent.Parent = ReplicatedStorage

local getDataEvent = Instance.new("RemoteFunction")
getDataEvent.Name = "GetData"
getDataEvent.Parent = ReplicatedStorage

local allocateStatEvent = Instance.new("RemoteFunction")
allocateStatEvent.Name = "AllocateStat"
allocateStatEvent.Parent = ReplicatedStorage

local rollRaceEvent = Instance.new("RemoteFunction")
rollRaceEvent.Name = "RollRace"
rollRaceEvent.Parent = ReplicatedStorage

local rollClanEvent = Instance.new("RemoteFunction")
rollClanEvent.Name = "RollClan"
rollClanEvent.Parent = ReplicatedStorage

local rollAttributeEvent = Instance.new("RemoteFunction")
rollAttributeEvent.Name = "RollAttribute"
rollAttributeEvent.Parent = ReplicatedStorage

local giveXPEvent = Instance.new("RemoteEvent")
giveXPEvent.Name = "GiveXP"
giveXPEvent.Parent = ReplicatedStorage

local giveCoinsEvent = Instance.new("RemoteEvent")
giveCoinsEvent.Name = "GiveCoins"
giveCoinsEvent.Parent = ReplicatedStorage

local giveGemsEvent = Instance.new("RemoteEvent")
giveGemsEvent.Name = "GiveGems"
giveGemsEvent.Parent = ReplicatedStorage

print("[Server] RemoteEvents créés")

-- ============================================================================
-- IMPORT SERVICES
-- ============================================================================

local ProfileService = require(script.ProfileService)
local GachaService = require(script:WaitForChild("Gacha.service"))

print("[Server] Services chargés")

-- ============================================================================
-- PLAYER HANDLERS
-- ============================================================================

Players.PlayerAdded:Connect(function(player)
	print("[Server] Joueur connecté: " .. player.Name)
	ProfileService.LoadProfile(player)
end)

Players.PlayerRemoving:Connect(function(player)
	print("[Server] Joueur déconnecté: " .. player.Name)
	ProfileService.SaveProfile(player)
end)

-- ============================================================================
-- COMBAT HANDLER
-- ============================================================================

attackEvent.OnServerEvent:Connect(function(player, targetUserId, damage)
	if typeof(damage) ~= "number" then return end
	
	local targetPlayer = Players:GetPlayerByUserId(targetUserId)
	if targetPlayer and targetPlayer.Character then
		local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
		if humanoid then
			humanoid:TakeDamage(math.clamp(damage, 0, 100))
		end
	end
end)

-- ============================================================================
-- DATA HANDLERS
-- ============================================================================

getDataEvent.OnServerInvoke = function(player, requestType)
	return ProfileService.GetPlayerData(player)
end

allocateStatEvent.OnServerInvoke = function(player, statName)
	return ProfileService.AllocateStatPoint(player, statName)
end

-- ============================================================================
-- GACHA HANDLERS
-- ============================================================================

rollRaceEvent.OnServerInvoke = function(player)
	return GachaService.RollRace(player)
end

rollClanEvent.OnServerInvoke = function(player)
	return GachaService.RollClan(player)
end

rollAttributeEvent.OnServerInvoke = function(player)
	return GachaService.RollAttribute(player)
end

-- ============================================================================
-- REWARD HANDLERS
-- ============================================================================

giveXPEvent.OnServerEvent:Connect(function(player, amount)
	ProfileService.AddXP(player, amount)
end)

giveCoinsEvent.OnServerEvent:Connect(function(player, amount)
	ProfileService.AddCoins(player, amount)
end)

giveGemsEvent.OnServerEvent:Connect(function(player, amount)
	ProfileService.AddGems(player, amount)
end)

print("[Server] Tout est prêt!")
