-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "weaponstats",
	Description = "Show persistent weapon/ability usage stats (accuracy, HS%, melee multi-stabs, per-ability uses/kills). Backend counters for cheat review; real matches only.",
	Group = "Admin",
	Aliases = { "wstats" },
	Args = { {
		Type = "player",
		Name = "player",
		Description = "Player to inspect (defaults to yourself)",
		Optional = true
	} }
}
