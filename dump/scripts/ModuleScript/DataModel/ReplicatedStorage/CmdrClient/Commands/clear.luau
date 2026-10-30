-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")

return {
	Name = "clear",
	Description = "Clear all lines above the entry line of the Cmdr window.",
	Group = "DefaultUtil",
	Aliases = {},
	Args = {},
	ClientRun = function()
		local cmdr: Instance = players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Cmdr")
		local frame: Instance = cmdr:WaitForChild("Frame")

		if cmdr and frame then
			for _, v in pairs(frame:GetChildren()) do
				if v.Name == "Line" and v:IsA("TextBox") then
					v:Destroy()
				end
			end
		end

		return ""
	end
}
