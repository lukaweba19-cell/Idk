-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "thru",
	Description = "Teleports you through whatever your mouse is hovering over, placing you equidistantly from the wall.",
	Group = "DefaultDebug",
	Aliases = { "t", "through" },
	Args = { {
		Type = "number",
		Name = "Extra distance",
		Description = "Go through the wall an additional X studs.",
		Default = 0
	} },
	ClientRun = function(p1, p2)
		local mouse = p1.Executor:GetMouse()
		local Character = p1.Executor.Character

		if not Character or not Character:FindFirstChild("HumanoidRootPart") then
			return "You don't have a character."
		end

		local HumanoidRootPartPosition = Character.HumanoidRootPart.Position
		local n1 = mouse.Hit.p - HumanoidRootPartPosition

		Character:MoveTo(n1 * 2 + n1.unit * p2 + HumanoidRootPartPosition)

		return "Blinked!"
	end
}
