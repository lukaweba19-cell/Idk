-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "questprogress",
	Description = "Simulate task progress (daily or beginner).",
	Group = "Admin",
	Aliases = { "qp" },
	Args = {
		{
			Type = "questIndex",
			Name = "index",
			Description = "Quest index: 1, 2, or 3."
		},
		{
			Type = "integer",
			Name = "amount",
			Description = "Amount of progress (default 1).",
			Optional = true
		}
	}
}
