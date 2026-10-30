-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local shared: Instance = replicatedStorage:WaitForChild("Shared")

if require(shared:WaitForChild("TradingPlazaGate")).IsTradingPlaza() then
	script.Parent.Visible = false

	return
end

local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local partyView = require(replicatedStorageShared:WaitForChild("PartyView"))
local isMatchServer: any = replicatedStorage:GetAttribute("IsMatchServer")

partyView.mount(script.Parent, {
	lockComposition = if isMatchServer == true then true else false
})
