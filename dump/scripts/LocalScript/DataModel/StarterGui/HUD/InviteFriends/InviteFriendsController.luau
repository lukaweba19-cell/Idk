-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local socialService: SocialService = game:GetService("SocialService")
local LocalPlayer: Player = players.LocalPlayer
local scriptParent: Instance = script.Parent
local inviteBtn: Instance = scriptParent:WaitForChild("InviteBtn")

scriptParent.Visible = LocalPlayer:GetAttribute("DuelStationQueued") == true
LocalPlayer:GetAttributeChangedSignal("DuelStationQueued"):Connect(function()
	scriptParent.Visible = LocalPlayer:GetAttribute("DuelStationQueued") == true
end)

local function canInvite()
	local ok, result = pcall(function()
		return socialService:CanSendGameInviteAsync(LocalPlayer)
	end)

	return ok and result
end

inviteBtn.Activated:Connect(function()
	local ok, result = pcall(function()
		return socialService:CanSendGameInviteAsync(LocalPlayer)
	end)

	if ok and result then
		pcall(function()
			socialService:PromptGameInvite(LocalPlayer)
		end)
	end
end)
