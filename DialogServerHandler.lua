local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Dialog content per NPC
local dialogData = {
	Sara_Trainer = {
		{speaker = "Sara", text = "Yo! Didn't expect to see another Trainer jammin' through this route."},
		{speaker = "Sara", text = "Wanna vibe with a friendly battle? Don’t let the rhythm throw you off."},
		{speaker = "Sara", text = "I’ve got moves — and so do my Pokémon."}
	},
	Katsumi_Trainer = {
		{speaker = "Katsumi", text = "This path is protected. I can't let just anyone pass."},
		{speaker = "Katsumi", text = "If you want through, you'll have to prove your strength."},
		{speaker = "Katsumi", text = "Show me your resolve!"},
		{speaker = "Katsumi", text = "Come back anytime."}
	},
	Katsumi_Trainer_2 = {
		{speaker = "Katsumi", text = "Shhh... I saw this battle in a vision."},
		{speaker = "Katsumi", text = "Your aura is trembling... are you scared?"},
		{speaker = "Katsumi", text = "Let us begin. I’ll be gentle — if fate allows."},
		{speaker = "Katsumi", text = "Come back anytime."}
	},
	Katsumi_Trainer_3 = {
		{speaker = "Katsumi", text = "You're standing between me and victory."},
		{speaker = "Katsumi", text = "My flames don’t hold back — and neither do I!"},
		{speaker = "Katsumi", text = "Feel the burn!"},
		{speaker = "Katsumi", text = "Come back anytime."}
	},
	Ayane_Trainer = {
		{speaker = "Ayane", text = "Hmph. Another wannabe Trainer wandering through the forest..."},
		{speaker = "Ayane", text = "You think you’re ready to face a real challenge?"},
		{speaker = "Ayane", text = "Let’s see how long you last against me and my partner!"},
		{speaker = "Ayane", text = "Prepare yourself — this won’t be easy."}
	}
}

-- Listen to dialog request
ReplicatedStorage:WaitForChild("StartDialog").OnServerEvent:Connect(function(player, npcName)
	local dialog = dialogData[npcName]
	print("Start Dialog OnServer")

	if dialog then
		-- Create a fresh copy so the client always resets
		local freshDialog = {}
		for _, line in ipairs(dialog) do
			table.insert(freshDialog, {
				speaker = line.speaker,
				text = line.text
			})
		end

		ReplicatedStorage.StartDialog:FireClient(player, freshDialog)
	else
		warn("No dialog found for", npcName)
	end
end)