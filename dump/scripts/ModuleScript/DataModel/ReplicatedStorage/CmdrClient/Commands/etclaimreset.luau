-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "etclaimreset",
	Description = "MD [DEV] only: clear a player's ET knife claim so the AlienSpawn pod can be claimed again.",
	Group = "Admin",
	Args = { {
		Type = "player",
		Name = "player",
		Description = "Whose claim to clear. Default: you.",
		Optional = true
	} }
}
