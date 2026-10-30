-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "blink",
	Description = "Teleports you to where your mouse is hovering.",
	Group = "DefaultDebug",
	Aliases = { "b" },
	Args = {},
	ClientRun = function(p1)
		local mouse = p1.Executor:GetMouse()
		local Character = p1.Executor.Character

		if not Character then
			return "You don't have a character."
		end

		Character:MoveTo(mouse.Hit.p)

		return "Blinked!"
	end
}
