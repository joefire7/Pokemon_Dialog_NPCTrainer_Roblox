local TweenService = game:GetService("TweenService")

local button = script.Parent
local uiScale = button:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", button)
uiScale.Scale = 1

-- Tween settings
local pulseTweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local scaleUp = TweenService:Create(uiScale, pulseTweenInfo, { Scale = 1.05 })
local scaleDown = TweenService:Create(uiScale, pulseTweenInfo, { Scale = 1 })

-- Dot animation loop
local dots = { ".", "..", "..." }
local dotIndex = 1

while true do
	-- Animate dots
	button.Text = dots[dotIndex]
	dotIndex = dotIndex % #dots + 1

	-- Animate scale pulse
	scaleUp:Play()
	scaleUp.Completed:Wait()
	scaleDown:Play()
	scaleDown.Completed:Wait()

	wait(0.2) -- slight pause between cycles
end
