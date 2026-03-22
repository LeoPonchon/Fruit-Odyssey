-- ============================================================================
-- FRUIT ODYSSEY - CLIENT SYSTEMS
-- Dash (F) + Combat Tool (Idle/Attack animations)
-- Run/Jump/Fall use GLOBAL animations - TOOL HAS ZERO INFLUENCE ON THEM
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
-- GLOBAL CUSTOM ANIMATIONS (used for Run/Jump/Fall - ALWAYS)
-- ============================================================================
local GLOBAL_IDLE_ANIM_ID = "rbxassetid://117407032872713"
local GLOBAL_RUN_ANIM_ID = "rbxassetid://132094209864309"
local GLOBAL_JUMP_ANIM_ID = "rbxassetid://81203994982566"
local GLOBAL_FALL_ANIM_ID = "rbxassetid://132090986344206"

local globalIdleAnim = nil
local globalRunAnim = nil
local globalJumpAnim = nil
local globalFallAnim = nil

local function loadGlobalAnimations()
	-- Idle animation
	if GLOBAL_IDLE_ANIM_ID and GLOBAL_IDLE_ANIM_ID ~= "" then
		local anim = Instance.new("Animation")
		anim.AnimationId = GLOBAL_IDLE_ANIM_ID
		anim.Name = "GlobalIdle"
		globalIdleAnim = humanoid:LoadAnimation(anim)
		globalIdleAnim.Priority = Enum.AnimationPriority.Action
		globalIdleAnim.Looped = true
	end
	
	-- Run animation
	if GLOBAL_RUN_ANIM_ID and GLOBAL_RUN_ANIM_ID ~= "" and GLOBAL_RUN_ANIM_ID ~= "rbxassetid://0" then
		local anim = Instance.new("Animation")
		anim.AnimationId = GLOBAL_RUN_ANIM_ID
		anim.Name = "GlobalRun"
		globalRunAnim = humanoid:LoadAnimation(anim)
		globalRunAnim.Priority = Enum.AnimationPriority.Action
		globalRunAnim.Looped = true
	end
	
	-- Jump animation
	if GLOBAL_JUMP_ANIM_ID and GLOBAL_JUMP_ANIM_ID ~= "" then
		local anim = Instance.new("Animation")
		anim.AnimationId = GLOBAL_JUMP_ANIM_ID
		anim.Name = "GlobalJump"
		globalJumpAnim = humanoid:LoadAnimation(anim)
		globalJumpAnim.Priority = Enum.AnimationPriority.Action
	end
	
	-- Fall animation
	if GLOBAL_FALL_ANIM_ID and GLOBAL_FALL_ANIM_ID ~= "" then
		local anim = Instance.new("Animation")
		anim.AnimationId = GLOBAL_FALL_ANIM_ID
		anim.Name = "GlobalFall"
		globalFallAnim = humanoid:LoadAnimation(anim)
		globalFallAnim.Priority = Enum.AnimationPriority.Action
	end
end

-- Load global animations at startup
loadGlobalAnimations()

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
local toolIdleAnim = nil
local toolAttackAnim = nil
local canAttack = true
local isMoving = false
local isJumping = false
local lastState = "idle"

-- Animation helpers
local function loadToolAnimations(tool)
	local idleId = tool:GetAttribute("IdleAnimId")
	local attackId = tool:GetAttribute("AttackAnimId")
	
	if idleId and idleId ~= "" then
		local anim = Instance.new("Animation")
		anim.AnimationId = idleId
		anim.Name = "ToolIdle"
		toolIdleAnim = humanoid:LoadAnimation(anim)
		toolIdleAnim.Priority = Enum.AnimationPriority.Action
	end
	
	if attackId and attackId ~= "" then
		local anim = Instance.new("Animation")
		anim.AnimationId = attackId
		anim.Name = "ToolAttack"
		toolAttackAnim = humanoid:LoadAnimation(anim)
		toolAttackAnim.Priority = Enum.AnimationPriority.Action
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

-- Global animation functions - FOR IDLE ONLY
local function playGlobalIdle()
	if globalIdleAnim and not globalIdleAnim.IsPlaying then
		stopAllAnimations()
		globalIdleAnim:Play()
	end
end

local function playGlobalRun()
	if globalRunAnim and not globalRunAnim.IsPlaying then
		stopAllAnimations()
		globalRunAnim:Play()
	end
end

local function playGlobalJump()
	if globalJumpAnim and not globalJumpAnim.IsPlaying then
		stopAllAnimations()
		globalJumpAnim:Play()
	end
end

local function playGlobalFall()
	if globalFallAnim and not globalFallAnim.IsPlaying then
		stopAllAnimations()
		globalFallAnim:Play()
	end
end

local function playToolIdle()
	if toolIdleAnim and not toolIdleAnim.IsPlaying then
		stopAllAnimations()
		toolIdleAnim.Looped = true
		toolIdleAnim:Play()
	end
end

local function attack()
	if not canAttack or not toolAttackAnim then return end
	canAttack = false
	
	stopAllAnimations()
	
	toolAttackAnim.Looped = false
	toolAttackAnim:Play()
	
	local animDuration = toolAttackAnim.Length / toolAttackAnim.Speed
	task.delay(animDuration, function()
		-- After attack, resume appropriate animation based on state
		if isJumping then
			playGlobalJump()
		elseif isMoving then
			playGlobalRun()
		elseif equippedTool then
			playToolIdle()
		else
			playGlobalIdle()
		end
	end)
	
	task.delay(ATTACK_COOLDOWN, function()
		canAttack = true
	end)
end

-- Tool events - ONLY affect idle, never touch run/jump/fall
local function onToolEquipped(tool)
	if equippedTool == tool then return end
	if tool.Name ~= "Combat" then return end
	
	equippedTool = tool
	
	-- Disable animate script
	if animateScript then
		animateScript.Disabled = true
	end
	
	loadToolAnimations(tool)
	
	-- ONLY affect idle - don't touch if moving
	if not isMoving and not isJumping then
		playToolIdle()
	end
end

local function onToolUnequipped(tool)
	if tool.Name ~= "Combat" then return end
	
	-- Stop ONLY tool idle animation - DON'T touch run/jump/fall
	if toolIdleAnim then
		toolIdleAnim:Stop()
	end
	
	equippedTool = nil
	
	-- ONLY play global idle if actually idle - don't touch movement
	if not isMoving and not isJumping then
		playGlobalIdle()
	end
	
	-- DON'T re-enable animate script - our custom animations handle everything
end

-- ============================================================================
-- INPUT HANDLING
-- ============================================================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == Enum.KeyCode.F then
		dash()
	end
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 and equippedTool then
		attack()
	end
end)

-- ============================================================================
-- CHARACTER EVENTS
-- ============================================================================
for _, child in ipairs(character:GetChildren()) do
	if child:IsA("Tool") and child.Name == "Combat" then
		onToolEquipped(child)
	end
end

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

-- Movement detection - HANDLES RUN/JUMP/FALL AUTOMATICALLY
local function updateMovementState()
	local velocityMagnitude = rootPart.Velocity.Magnitude
	isMoving = velocityMagnitude > 0.5
	
	-- Don't change if jumping/falling
	if isJumping then return end
	
	local targetState = nil
	
	if equippedTool then
		if isMoving then
			targetState = "globalRun"
		else
			targetState = "toolIdle"
		end
	else
		if isMoving then
			targetState = "globalRun"
		else
			targetState = "globalIdle"
		end
	end
	
	-- Only transition if state actually changed
	if targetState ~= lastState then
		lastState = targetState
		
		if targetState == "globalRun" then
			playGlobalRun()
		elseif targetState == "globalIdle" then
			playGlobalIdle()
		elseif targetState == "toolIdle" then
			playToolIdle()
		end
	end
end

-- Check movement every frame
game:GetService("RunService").Heartbeat:Connect(function()
	updateMovementState()
end)

-- Jump/Fall detection
humanoid.StateChanged:Connect(function(oldState, newState)
	if newState == Enum.HumanoidStateType.Jumping then
		isJumping = true
		lastState = "globalJump"
		playGlobalJump()
		
	elseif newState == Enum.HumanoidStateType.Freefall then
		isJumping = true
		lastState = "globalFall"
		playGlobalFall()
		
	elseif newState == Enum.HumanoidStateType.Running or newState == Enum.HumanoidStateType.RunningNoPhysics then
		if isJumping then
			isJumping = false
		end
	end
end)

-- Character respawn
player.CharacterAdded:Connect(function(newCharacter)
	task.wait(0.5)
	character = newCharacter
	humanoid = newCharacter:WaitForChild("Humanoid")
	rootPart = newCharacter:WaitForChild("HumanoidRootPart")
	animator = humanoid:FindFirstChild("Animator")
	animateScript = newCharacter:FindFirstChild("Animate")
	equippedTool = nil
	toolIdleAnim = nil
	toolAttackAnim = nil
	isMoving = false
	isJumping = false
	lastState = "idle"
	
	loadGlobalAnimations()
	
	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("Tool") and child.Name == "Combat" then
			task.wait(0.1)
			onToolEquipped(child)
		end
	end
	
	playGlobalIdle()
end)

print("[Client] Systems loaded!")
