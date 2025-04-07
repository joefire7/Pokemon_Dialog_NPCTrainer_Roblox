local textButton = script.Parent
local targetGui = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("BagGui")

textButton.MouseButton1Click:Connect(function()
	targetGui.Enabled = true
end)