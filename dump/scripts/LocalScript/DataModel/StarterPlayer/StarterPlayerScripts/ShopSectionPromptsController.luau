-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local proximityPromptService: ProximityPromptService = game:GetService("ProximityPromptService")
local LocalPlayer: Player = players.LocalPlayer
local openShop: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Bindables"):WaitForChild("OpenShop")
local t1: {[any]: any} = {
	OpenTradeTokensPrompt = "Tokens",
	OpenCoinsPrompt = "Currency",
	OpenCasesShopPrompt = "Cases"
}

proximityPromptService.PromptTriggered:Connect(function(prompt: ProximityPrompt, playerWhoTriggered: Player)
	if playerWhoTriggered ~= LocalPlayer then
		return
	end

	local v8 = t1[prompt.Name]

	if not v8 then
		return
	end

	openShop:Fire(v8)
end)
