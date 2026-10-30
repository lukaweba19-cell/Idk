-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")

return {
	Name = "hover",
	Description = "Returns the name of the player you are hovering over.",
	Group = "DefaultUtil",
	Args = {},
	ClientRun = function()
		local target: BasePart = players.LocalPlayer:GetMouse().Target

		if not target then
			return ""
		end

		local v3: Player = players:GetPlayerFromCharacter(target:FindFirstAncestorOfClass("Model"))

		return v3 and v3.Name or ""
	end
}
