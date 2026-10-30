-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "quickbot",
	Description = "Start a 1v1 bot duel that ends after a single round, on the shortest map. Built for producing replays fast: no map vote, one-second countdown, and the match ends the moment the round resolves, which is what writes the recording to the library. Defaults to Cabin (127-stud spawn gap, the closest of any map); pass a map name to override, or a round count if you want more than one.",
	Group = "Admin",
	Aliases = { "qb" },
	Args = {
		{
			Type = "string",
			Name = "map",
			Description = "Map name. Defaults to Cabin.",
			Optional = true
		},
		{
			Type = "integer",
			Name = "rounds",
			Description = "Rounds to win. Defaults to 1.",
			Optional = true
		}
	}
}
