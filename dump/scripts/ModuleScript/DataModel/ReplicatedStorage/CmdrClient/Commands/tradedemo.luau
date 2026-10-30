-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "tradedemo",
	Description = "Fill the History tab with fabricated trades so the UI can be reviewed with busy rows. In memory only -- nothing is written to the profile or the ledger. MD [DEV] only.",
	Group = "Admin",
	Aliases = { "td" },
	Args = {
		{
			Type = "player",
			Name = "player",
			Description = "Whose History tab to fill"
		},
		{
			Type = "integer",
			Name = "rows",
			Description = "How many fake trades to show (1-20, default 6)",
			Optional = true,
			Default = 6
		},
		{
			Type = "integer",
			Name = "items",
			Description = "Max items per side (1-10, default 10). Row 1 is always full; the rest are random.",
			Optional = true,
			Default = 10
		},
		{
			Type = "integer",
			Name = "tokens",
			Description = "Max trade tokens per side (0 disables, default 5000)",
			Optional = true,
			Default = 5000
		},
		{
			Type = "integer",
			Name = "seed",
			Description = "RNG seed, to reproduce a particular set of rows",
			Optional = true
		}
	}
}
