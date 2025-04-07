local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local trigger = script.Parent
local npc = trigger.Parent
local npcName = npc.Name
local playersInZone = {}
local activeCheckConnections = {}

local humanoid = npc:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")
local root = npc:WaitForChild("HumanoidRootPart")

-- Load animations
local idleAnim = Instance.new("Animation")
idleAnim.AnimationId = "rbxassetid://507766388"
local idleTrack = animator:LoadAnimation(idleAnim)
idleTrack.Looped = true
idleTrack:Play()

local pointAnim = Instance.new("Animation")
pointAnim.AnimationId = "rbxassetid://507770239"
local pointTrack = animator:LoadAnimation(pointAnim)
pointTrack.Looped = true

-- Save initial rotation
local originalCFrame = npc:GetPivot()

trigger.Anchored = true;
trigger.Size = Vector3.new(20,20,20)
trigger.Orientation = Vector3.new(0,0,0)

-- Update Fun Every Frame --
RunService.Heartbeat:Connect(function()
	--trigger.Size = Vector3.new(30,30,30)
	--trigger.Anchored = true
	--trigger.CanCollide = false
end)

local function getValidPlayer(hit)
	local character = hit:FindFirstAncestorOfClass("Model")
	if not character then return nil end

	local player = game.Players:GetPlayerFromCharacter(character)
	if not player then return nil end

	if hit.Name ~= "HumanoidRootPart" then return nil end

	return player
end

local function smoothRotateTo(targetPos, duration)
	local fromCF = npc:GetPivot()
	local toCF = CFrame.new(fromCF.Position, Vector3.new(targetPos.X, fromCF.Position.Y, targetPos.Z))

	local t = 0
	local stepConn
	stepConn = RunService.Heartbeat:Connect(function(dt)
		t += dt / duration
		if t >= 1 then
			t = 1
			stepConn:Disconnect()
		end
		local newCF = fromCF:Lerp(toCF, t)
		npc:PivotTo(newCF)
	end)
end

-- Check if player is still inside the trigger
local function isStillTouching(player)
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if root then
		local touching = root:GetTouchingParts()
		for _, part in pairs(touching) do
			if part == trigger then
				return true
			end
		end
	end
	return false
end

local function exitInteraction(player)
	if activeCheckConnections[player] then
		activeCheckConnections[player]:Disconnect()
		activeCheckConnections[player] = nil
	end

	playersInZone[player] = nil
	ReplicatedStorage.StartDialog:FireClient(player, "HidePrompt")
	print("Exited zone due to distance or touch ended")

	pointTrack:Stop()
	idleTrack:Play()
	smoothRotateTo(originalCFrame.Position + originalCFrame.LookVector, 0.5)
end

local function monitorProximity(player)
	-- Always clear existing connection
	if activeCheckConnections[player] then
		activeCheckConnections[player]:Disconnect()
		activeCheckConnections[player] = nil
	end

	activeCheckConnections[player] = RunService.Heartbeat:Connect(function()
		local character = player.Character
		local hrp = character and character:FindFirstChild("HumanoidRootPart")
		if hrp then
			local distance = (hrp.Position - root.Position).Magnitude
			-- Debug output
			print("📏 Distance:", distance)

			if distance > 15 then
				exitInteraction(player)
			end
		else
			--exitInteraction(player)
		end
	end)
end

trigger.Touched:Connect(function(hit)
	local player = getValidPlayer(hit)
	if player then
		-- Force clean-up if re-entered without a proper exit
		--if playersInZone[player] then
		--	exitInteraction(player)
		--end
		--playersInZone[player] = true


		task.delay(0.1, function()
			if isStillTouching(player) then
				ReplicatedStorage.StartDialog:FireClient(player, "ShowPrompt", npcName)
				print("Trigger Touched")

				idleTrack:Stop()
				pointTrack:Play()

				local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
				if hrp then
					smoothRotateTo(hrp.Position, 0.5)
				end
				monitorProximity(player)
			end
		end)
	end
end)

trigger.TouchEnded:Connect(function(hit)
	local player = getValidPlayer(hit)
	if player and playersInZone[player] then
		--task.delay(0.1, function()
			--if not isStillTouching(player) then
			--	exitInteraction(player)
			--end
			
			
			--if not isStillTouching(player) then
			--	playersInZone[player] = nil
			--	ReplicatedStorage.StartDialog:FireClient(player, "HidePrompt")
			--	print("Trigger TouchEnded")

			--	-- Stop point, resume idle, and reset rotation
			--	pointTrack:Stop()
			--	idleTrack:Play()
			--	smoothRotateTo(originalCFrame.Position + originalCFrame.LookVector, 0.5)
			--end
		--end)
	end
end)
