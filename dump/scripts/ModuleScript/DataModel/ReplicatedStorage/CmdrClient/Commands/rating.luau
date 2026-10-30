-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "rating",
	Description = "Show the hidden Glicko-2 matchmaking rating (MMR). Omit the player to list everyone in-server, sorted by rating.",
	Group = "Admin",
	Aliases = { "mmr" },
	Args = { {
		Type = "player",
		Name = "player",
		Description = "Player to inspect (omit for everyone in-server)",
		Optional = true
	} }
}
