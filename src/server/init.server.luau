-- ============================================================================
-- FRUIT ODYSSEY - SERVER SYSTEMS
-- ============================================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEvent for combat damage
local attackEvent = Instance.new("RemoteEvent")
attackEvent.Name = "Attack"
attackEvent.Parent = ReplicatedStorage

-- Handle attack from client
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

print("[Server] Combat system ready!")
