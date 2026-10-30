-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "matchhistory",
	Description = "Show a player's recent match history (last N matches).",
	Group = "Admin",
	Aliases = { "mh" },
	Args = {
		{ Type = "player", Name = "player", Description = "Player to inspect" },
		{
			Type = "integer",
			Name = "count",
			Description = "How many matches to show (default 10, max 50)",
			Default = 10
		}
	}
}
