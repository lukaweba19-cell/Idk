-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "replay",
	Description = "Watch a recorded match. Finished matches save to a persistent library automatically, so `replay latest` works after a Studio restart without playing again. `list` shows what is saved, `clear` empties the library, `stop` exits playback. Controls once in: Space play/pause, A/D frame step, ,/. speed, Q/E switch player, 1 third-person, 2 first-person, 3 freecam, R/F skip round, M exit.",
	Group = "Admin",
	Args = { {
		Type = "string",
		Name = "matchIdOrAction",
		Description = "match id (full or first few chars) | latest | list | stop | clear"
	} }
}
