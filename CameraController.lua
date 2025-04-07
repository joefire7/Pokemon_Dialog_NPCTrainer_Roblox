local Players = game:GetService("Players")
local RunServices = game:GetService("RunService")
local TweenServices = game:GetService("TweenService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local defaultCameraType = Enum.CameraType.Custom
local savedCFrame = nil

local CameraController = {}

-- Tween helper
local function tweenCamera(toCFrame, duration)
	local camTween = TweenServices:Create(camera, TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
		CFrame = toCFrame
	})
	camTween:Play()
end

-- Move camera to focus on NPC
function CameraController.FocusOnNPC(npc)
	if not npc or not npc:FindFirstChild("Head") then return end

	local head = npc.Head
	savedCFrame = camera.CFrame
	camera.CameraType = Enum.CameraType.Scriptable

	local forwardDir = -head.CFrame.LookVector
	local upDir = head.CFrame.UpVector

	local distanceInFront = 5
	local verticalOffset = -2.5

	local cameraPosition = head.Position - forwardDir * distanceInFront + upDir * verticalOffset
	local lookAtTarget = head.Position + forwardDir * 0.1 -- ✅ toward the face

	local cameraCFrame = CFrame.lookAt(cameraPosition, lookAtTarget)
	tweenCamera(cameraCFrame, 0.5)

end

-- Return to player control
function CameraController.ReturnToPlayer()
	print("Return To player");
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

	-- Optional: smooth tween back to behind player
	local targetPosition = humanoidRootPart.Position - humanoidRootPart.CFrame.LookVector * 6 + Vector3.new(0, 3, 0)
	local lookAt = humanoidRootPart.Position + Vector3.new(0, 2, 0)

	local returnCFrame = CFrame.lookAt(targetPosition, lookAt)
	tweenCamera(returnCFrame, 0.5)

	-- After tween, switch back to normal camera mode
	task.delay(0.5, function()
		camera.CameraType = Enum.CameraType.Custom
	end)
end

return CameraController