-- ============================================================================
-- FRUIT ODYSSEY - CLIENT SYSTEMS
-- Dash (F) + Combat Tool (Stance/Run/Attack animations)
-- ============================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Reference to Roblox's default Animate script
local animateScript = character:FindFirstChild("Animate")

-- ============================================================================
-- DASH SYSTEM
-- ============================================================================
local DASH_CONFIG = {
	Cooldown = 1.0,
	Speed = 50,
	Duration = 0.2
}

local canDash = true
local isDashing = false

local function createDashEffect()
	local debris = game:GetService("Debris")
	for i = 1, 5 do
		local part = Instance.new("Part")
		part.Size = Vector3.new(0.5, 0.5, 0.5)
		part.CanCollide = false
		part.Transparency = 0.5
		part.Color = Color3.fromRGB(0, 255, 255)
		part.Material = Enum.Material.Neon
		part.CFrame = rootPart.CFrame
		part.Parent = character
		debris:AddItem(part, 0.3)
	end
end

local function dash()
	if not canDash or isDashing then return end
	
	isDashing = true
	canDash = false
	
	local direction = humanoid.MoveDirection
	if direction.Magnitude == 0 then
		direction = rootPart.CFrame.LookVector
	else
		direction = direction.Unit
	end
	
	local velocity = Instance.new("BodyVelocity")
	velocity.MaxForce = Vector3.new(100000, 100000, 100000)
	velocity.Velocity = direction * DASH_CONFIG.Speed
	velocity.Parent = rootPart
	createDashEffect()
	
	task.delay(DASH_CONFIG.Duration, function()
		velocity:Destroy()
		isDashing = false
	end)
	
	task.delay(DASH_CONFIG.Cooldown, function()
		canDash = true
	end)
end

-- ============================================================================
-- COMBAT SYSTEM
-- ============================================================================
local DAMAGE = 25
local ATTACK_COOLDOWN = 0.5
local ATTACK_RANGE = 7

-- RemoteEvent for server damage
local attackEvent = Instance.new("RemoteEvent")
attackEvent.Name = "Attack"
attackEvent.Parent = ReplicatedStorage

-- State
local equippedTool = nil
local stanceAnim = nil
local runAnim = nil
local attackAnim = nil
local canAttack = true
local isMoving = false

-- Animation helpers
-- IMPORTANT: Use Enum.AnimationPriority.Action to override Roblox default animations
-- This is the KEY FIX: Without this, custom animations blend with default ones
local function loadToolAnimations(tool)
	local stanceId = tool:GetAttribute("StanceAnimId")
	local attackId = tool:GetAttribute("AttackAnimId")
	local runId = tool:GetAttribute("RunAnimId")
	
	if stanceId and stanceId ~= "" then
		local anim = Instance.new("Animation")
		anim.AnimationId = stanceId
		anim.Name = "CustomStance"
		stanceAnim = humanoid:LoadAnimation(anim)
		stanceAnim.Priority = Enum.AnimationPriority.Action  -- CRITICAL: Override default animations
	end
	
	if attackId and attackId ~= "" then
		local anim = Instance.new("Animation")
		anim.AnimationId = attackId
		anim.Name = "CustomAttack"
		attackAnim = humanoid:LoadAnimation(anim)
		attackAnim.Priority = Enum.AnimationPriority.Action  -- CRITICAL: Override default animations
	end
	
	if runId and runId ~= "" then
		local anim = Instance.new("Animation")
		anim.AnimationId = runId
		anim.Name = "CustomRun"
		runAnim = humanoid:LoadAnimation(anim)
		runAnim.Priority = Enum.AnimationPriority.Action  -- CRITICAL: Override default animations
	end
end

local animator = humanoid:FindFirstChild("Animator")

local function stopAllAnimations()
	if animator then
		for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
			track:Stop()
		end
	end
end

local function stopCustomAnimations()
	if stanceAnim and stanceAnim.IsPlaying then
		stanceAnim:Stop()
	end
	if runAnim and runAnim.IsPlaying then
		runAnim:Stop()
	end
	if attackAnim and attackAnim.IsPlaying then
		attackAnim:Stop()
	end
end

local function playStance()
	if stanceAnim and not isMoving and not stanceAnim.IsPlaying then
		stopAllAnimations()
		stanceAnim.Looped = true
		stanceAnim:Play()
	end
end

local function stopStance()
	if stanceAnim and stanceAnim.IsPlaying then
		stanceAnim:Stop()
	end
end

local function playRun()
	if runAnim and isMoving and not runAnim.IsPlaying then
		stopAllAnimations()
		runAnim.Looped = true
		runAnim:Play()
	end
end

local function stopRun()
	if runAnim and runAnim.IsPlaying then
		runAnim:Stop()
	end
end

local function attack()
	if not canAttack or not attackAnim then return end
	canAttack = false
	
	stopStance()
	attackAnim.Looped = false
	attackAnim:Play()
	
	local animDuration = attackAnim.Length / attackAnim.Speed
	task.delay(animDuration, function()
		if equippedTool and not isMoving then
			playStance()
		end
	end)
	
	task.delay(ATTACK_COOLDOWN, function()
		canAttack = true
	end)
end

-- Tool events
-- IMPROVED: Proper handling of equip/unequip to avoid animation conflicts
local function onToolEquipped(tool)
	if equippedTool == tool then return end
	if tool.Name ~= "Combat" then return end
	
	-- Stop any currently playing custom animations first
	stopCustomAnimations()
	
	equippedTool = tool
	
	-- Disable Roblox's default Animate script completely
	if animateScript then
		animateScript.Disabled = true
	end
	
	-- Force stop ALL animation tracks to ensure clean slate
	if animator then
		for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
			track:Stop()
		end
	end
	
	loadToolAnimations(tool)
	playStance()
end

local function onToolUnequipped(tool)
	if tool.Name ~= "Combat" then return end
	
	-- Stop custom animations FIRST before re-enabling Animate
	stopCustomAnimations()
	
	equippedTool = nil
	
	-- Small delay to ensure custom animations are fully stopped
	task.wait(0.05)
	
	-- Re-enable Roblox's default Animate script
	if animateScript then
		animateScript.Disabled = false
	end
	
	-- Force restart of default animations by briefly toggling AutoRotate
	-- This ensures clean transition back to default animations
	local originalAutoRotate = humanoid.AutoRotate
	humanoid.AutoRotate = false
	task.wait(0.01)
	humanoid.AutoRotate = originalAutoRotate
end

-- ============================================================================
-- INPUT HANDLING
-- ============================================================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	-- Dash on F
	if input.KeyCode == Enum.KeyCode.F then
		dash()
	end
	
	-- Attack on left click
	if input.UserInputType == Enum.UserInputType.MouseButton1 and equippedTool then
		attack()
	end
end)

-- ============================================================================
-- CHARACTER EVENTS
-- ============================================================================

-- Check for existing tool
for _, child in ipairs(character:GetChildren()) do
	if child:IsA("Tool") and child.Name == "Combat" then
		onToolEquipped(child)
	end
end

-- Tool equipped/unequipped
character.ChildAdded:Connect(function(child)
	if child:IsA("Tool") and child.Name == "Combat" then
		task.wait(0.2)
		if child.Parent == character then
			onToolEquipped(child)
		end
	end
end)

character.ChildRemoved:Connect(function(child)
	if child:IsA("Tool") and child.Name == "Combat" then
		onToolUnequipped(child)
	end
end)

-- Movement detection
humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
	isMoving = humanoid.MoveDirection.Magnitude > 0
	
	if equippedTool then
		if isMoving then
			stopStance()
			playRun()
		else
			stopRun()
			playStance()
		end
	end
end)

-- Character respawn
player.CharacterAdded:Connect(function(newCharacter)
	task.wait(0.5)
	character = newCharacter
	humanoid = newCharacter:WaitForChild("Humanoid")
	rootPart = newCharacter:WaitForChild("HumanoidRootPart")
	animateScript = newCharacter:FindFirstChild("Animate")
	equippedTool = nil
end)

print("[Client] Systems loaded!")
