-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local LocalPlayer: Player = game:GetService("Players").LocalPlayer
local scriptParent: Instance = script.Parent

local function isInMatch()
	return LocalPlayer:GetAttribute("InMatch") == true
end
local function isLobbySpectating()
	return LocalPlayer:GetAttribute("LobbySpectateMatchId") ~= nil
end
local function apply()
	local u7: boolean = LocalPlayer:GetAttribute("InMatch") == true

	if not u7 then
		u7 = LocalPlayer:GetAttribute("LobbySpectateMatchId") ~= nil
	end

	scriptParent.Visible = not u7
end

LocalPlayer:GetAttributeChangedSignal("InMatch"):Connect(apply)
LocalPlayer:GetAttributeChangedSignal("LobbySpectateMatchId"):Connect(apply)

local u6: boolean = LocalPlayer:GetAttribute("InMatch") == true

if not u6 then
	u6 = LocalPlayer:GetAttribute("LobbySpectateMatchId") ~= nil
end

scriptParent.Visible = not u6
