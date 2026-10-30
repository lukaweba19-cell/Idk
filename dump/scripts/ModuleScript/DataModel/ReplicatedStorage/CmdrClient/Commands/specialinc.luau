-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "specialinc",
	Description = "Increment a SpecialTasks stat (default statKey=Kills).",
	Group = "Admin",
	Aliases = { "si" },
	Args = {
		{ Type = "integer", Name = "amount", Description = "Amount to add." },
		{
			Type = "string",
			Name = "statKey",
			Description = "Stat key (default: Kills).",
			Optional = true
		}
	}
}
