-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "plagueskip",
	Description = "Plague event TEST: grant one reward exactly as its Robux skip would (Knife, Finisher, Gun), with the normal purple roll. No purchase.",
	Group = "Admin",
	Args = {
		{
			Type = "string",
			Name = "rung",
			Description = "Knife | Finisher | Gun"
		},
		{
			Type = "player",
			Name = "player",
			Description = "Player (default you)",
			Optional = true
		}
	}
}
