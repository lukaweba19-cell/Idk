-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "fakematchhistory",
	Description = "Inject fake match history entries for testing anti-farm + alt detection.",
	Group = "Admin",
	Aliases = { "fmh" },
	Args = {
		{
			Type = "player",
			Name = "player",
			Description = "Whose history to mutate"
		},
		{
			Type = "player",
			Name = "opponent",
			Description = "Fake opponent (must be in-server; their uid is what's stored)"
		},
		{
			Type = "integer",
			Name = "count",
			Description = "How many entries to inject (default 10)",
			Optional = true,
			Default = 10
		},
		{
			Type = "matchOutcome",
			Name = "outcome",
			Description = "win | loss | mixed (default loss)",
			Optional = true,
			Default = "loss"
		}
	}
}
