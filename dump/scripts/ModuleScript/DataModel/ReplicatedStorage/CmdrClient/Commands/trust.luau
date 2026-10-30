-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "trust",
	Description = "Show a player's record-only TrustScore standing (tier / score / confidence) plus a per-match breakdown of their recent behavioral window. Inert anti-cheat telemetry for tuning; real matches only.",
	Group = "Admin",
	Aliases = { "trustfactor" },
	Args = { {
		Type = "player",
		Name = "player",
		Description = "Player to inspect (defaults to yourself)",
		Optional = true
	} }
}
