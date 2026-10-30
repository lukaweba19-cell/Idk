-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "mmwarmup",
	Description = "Studio-only: simulate the matchmaking warmup on THIS server (warp present players onto the NEW warmup room pad with props placed -> wait until they're loaded in -> WarmupExtraSeconds countdown -> map vote; practice NPCs hide for the match and restore at its end). Lets you test the warmup without a reserved server or a second client.",
	Group = "Admin",
	Aliases = { "warmuptest" },
	Args = { {
		Type = "number",
		Name = "mode",
		Description = "Team size 1-4 (default 1). Sets the vote/match mode; present players are split across Red/Blue.",
		Optional = true
	} }
}
