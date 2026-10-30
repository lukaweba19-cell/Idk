-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "seasonxp",
	Description = "Add Season Pass XP to one or more players. Seasonal only -- does not touch account EXP or level (use `exp` for that).",
	Group = "Admin",
	Args = {
		{
			Type = "players",
			Name = "targets",
			Description = "Players to give season XP. . = self, * = everyone."
		},
		{
			Type = "number",
			Name = "amount",
			Description = "Season XP to add. Negative subtracts."
		}
	}
}
