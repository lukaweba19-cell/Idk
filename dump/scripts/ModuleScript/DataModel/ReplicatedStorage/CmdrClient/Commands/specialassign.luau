-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "specialassign",
	Description = "Assign a single test SpecialTask (default statKey=Kills).",
	Group = "Admin",
	Aliases = { "sa" },
	Args = {
		{
			Type = "integer",
			Name = "required",
			Description = "Required progress to complete."
		},
		{
			Type = "string",
			Name = "statKey",
			Description = "Stat key to track (default: Kills).",
			Optional = true
		}
	}
}
