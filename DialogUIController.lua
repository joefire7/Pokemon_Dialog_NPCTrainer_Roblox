local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local dialogGui = playerGui:WaitForChild("DialogGui")

-- UI Elements
local promptFrame = dialogGui:WaitForChild("PromptFrame")
local nextButton = promptFrame:WaitForChild("NextButton")
local dialogLabel = promptFrame:WaitForChild("DialogText")
local speakerLabel = promptFrame:WaitForChild("SpeakerName")

-- Tween setup
local promptScale = promptFrame:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", promptFrame)
promptScale.Scale = 0.8
promptFrame.BackgroundTransparency = 1
promptFrame.Visible = true

local promptTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Dialog state
local currentDialog = {}
local currentIndex = 1
local inZone = false
local currentNPC = nil
local lastNpcName = nil
local isTyping = false
local typingSpeed = 0.02

local CameraController = require(game.Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("CameraController"))

-- Show/Hide prompt
local function showPrompt()
	promptFrame.Visible = true
	local fadeIn = TweenService:Create(promptFrame, promptTweenInfo, {BackgroundTransparency = 0})
	local scaleUp = TweenService:Create(promptScale, promptTweenInfo, {Scale = 1})
	fadeIn:Play()
	scaleUp:Play()
end

local function hidePrompt()
	print("Hide Prompt");
	local fadeOut = TweenService:Create(promptFrame, promptTweenInfo, {BackgroundTransparency = 1})
	local scaleDown = TweenService:Create(promptScale, promptTweenInfo, {Scale = 0.8})
	fadeOut:Play()
	scaleDown:Play()
	scaleDown.Completed:Connect(function()
		promptFrame.Visible = false
	end)
end


-- Show a line of dialog
local function showLine()
	local line = currentDialog[currentIndex]
	if line then
		isTyping = true
		speakerLabel.Text = line.speaker or "???"
		dialogLabel.Text = ""

		local fullText = line.text or ""
		for i = 1, #fullText do
			dialogLabel.Text = string.sub(fullText, 1, i)
			wait(typingSpeed)
		end

		isTyping = false
	else
		local fadeOut = TweenService:Create(promptFrame, TweenInfo.new(0.25), {BackgroundTransparency = 1})
		fadeOut:Play()
		fadeOut.Completed:Connect(function()
			promptFrame.Visible = false
			promptFrame.BackgroundTransparency = 0
			currentNPC = nil
			CameraController.ReturnToPlayer()
			hidePrompt()
		end)
	end
end

-- When player presses E
local function onInteract(_, inputState)
	if inputState == Enum.UserInputState.Begin and inZone and lastNpcName then
		currentNPC = lastNpcName -- ✅ Set NPC first!
		print("📨 Client sent dialog request for:", currentNPC)
		promptFrame.Visible = false
		ReplicatedStorage:WaitForChild("StartDialog"):FireServer(currentNPC)
	end
end

-- Next button
nextButton.MouseButton1Click:Connect(function()
	if not isTyping then
		currentIndex += 1
		showLine()
	end
end)

-- Left-click anywhere
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 and promptFrame.Visible then
		if not isTyping then
			currentIndex += 1
			showLine()
		end
	end
end)

-- RemoteEvent listener
ReplicatedStorage:WaitForChild("StartDialog").OnClientEvent:Connect(function(action, npcName)
	if action == "ShowPrompt" then
		lastNpcName = npcName
		speakerLabel.Text = npcName
		inZone = true
		showPrompt()
		CameraController.FocusOnNPC(workspace:FindFirstChild(npcName))
		ContextActionService:BindAction("Interact", onInteract, false, Enum.KeyCode.E)

	elseif action == "HidePrompt" then
		lastNpcName = nil
		currentNPC = nil
		inZone = false
		hidePrompt()
		ContextActionService:UnbindAction("Interact")

	elseif typeof(action) == "table" then
		currentDialog = action
		currentIndex = 1

		promptFrame.BackgroundTransparency = 1
		promptFrame.Visible = true

		local fadeIn = TweenService:Create(promptFrame, TweenInfo.new(0.25), {BackgroundTransparency = 0})
		fadeIn:Play()

		showLine()
	end
end)


player.CharacterAdded:Connect(function()
	wait(0.5)
	hidePrompt()
end)
