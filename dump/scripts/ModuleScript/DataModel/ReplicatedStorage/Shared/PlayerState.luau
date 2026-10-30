-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {
	FinisherPreviewActive = false,
	ReplayActive = false,
	ReplayTimeScale = 1,
	ReplayPlayheadSeconds = nil,
	ReplayViewSide = nil,
	WieldedPreviewActive = false,
	CameraFirstPerson = nil
}

function module.InLobby()
	if module.FinisherPreviewActive then
		return false
	end

	if module.ReplayActive then
		return false
	end

	if module.WieldedPreviewActive then
		return false
	end

	local u2: boolean = false

	if game.Players.LocalPlayer:GetAttribute("MatchId") == nil then
		u2 = game.Players.LocalPlayer:GetAttribute("Spectating") == nil
	end

	return u2
end

return module
