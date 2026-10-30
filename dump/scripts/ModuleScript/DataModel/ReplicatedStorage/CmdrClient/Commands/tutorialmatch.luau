-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "tutorialmatch",
	Description = "Start a phase-1 tutorial bot match (bot-filled 2v2) for you, on THIS server (no reserved server/teleport needed - works in a solo Studio playtest). You're always on side A; optional real teammates join your team and bots fill the rest. Run /tutorialenter first if you want to be in phase 1 so the duel credits + funnel fire.",
	Aliases = { "tutmatch" },
	Args = { {
		Type = "players",
		Name = "teammates",
		Description = "Optional real player(s) to put on YOUR team (you're always included; capped at the 2v2 team size). Bots fill any remaining slots.",
		Optional = true
	} }
}
