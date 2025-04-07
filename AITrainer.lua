local npc = script.Parent
local humanoid = npc:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")

print("Hello Sara Pokemon Trainer")

local idleAnim = Instance.new("Animation")
idleAnim.AnimationId = "rbxassetid://507766388" -- Default Roblox Idle animation

local track = animator:LoadAnimation(idleAnim)
track.Looped = true
track.Priority = Enum.AnimationPriority.Idle
track:Play()
