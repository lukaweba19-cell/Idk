-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "position",
	Description = "Returns Vector3 position of you or other players. Empty string is the player has no character.",
	Group = "DefaultDebug",
	Aliases = { "pos" },
	Args = { {
		Type = "player",
		Name = "Player",
		Description = "The player to report the position of. Omit for your own position.",
		Default = game:GetService("Players").LocalPlayer
	} },
	ClientRun = function(_, player)
		local Character = player.Character

		if not Character or not Character:FindFirstChild("HumanoidRootPart") then
			return ""
		end

		return tostring(Character.HumanoidRootPart.Position):gsub("%s", "")
	end
}
