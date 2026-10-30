-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "matchgoal",
	Description = "Change the rounds-to-win of the match you're already in. `matchgoal 1` makes the round in progress the decider, which is the quickest way to reach a real final kill (and its killcam) with real players. Takes effect immediately; the HUD's FIRST TO N label updates on the spot.",
	Group = "Admin",
	Aliases = { "mg" },
	Args = { {
		Type = "integer",
		Name = "rounds",
		Description = "Rounds needed to win. Clamped to 1-10."
	} }
}
