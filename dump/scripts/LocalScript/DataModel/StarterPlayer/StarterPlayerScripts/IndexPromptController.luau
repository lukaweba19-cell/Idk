-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local proximityPromptService: ProximityPromptService = game:GetService("ProximityPromptService")
local LocalPlayer: Player = players.LocalPlayer
local bindables: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Bindables")

proximityPromptService.PromptTriggered:Connect(function(prompt: ProximityPrompt, playerWhoTriggered: Player)
	if playerWhoTriggered ~= LocalPlayer then
	elseif prompt.Name == "OpenItemIndexPrompt" then
		local openItemIndex: Instance = bindables:WaitForChild("OpenItemIndex", 10)

		if openItemIndex == nil or not openItemIndex:IsA("BindableEvent") then
			return
		end

		openItemIndex:Fire()

		return
	end
end)
