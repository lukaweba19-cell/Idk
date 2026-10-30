-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "rolltest",
	Description = "Bulk-open crates server-side and print empirical distribution.",
	Group = "Admin",
	Args = {
		{ Type = "crateId", Name = "crate", Description = "Crate ID to roll." },
		{
			Type = "integer",
			Name = "count",
			Description = "Number to roll (1..50000, default 1000).",
			Optional = true
		}
	}
}
