-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "previewtime",
	Description = "Set UpdateGate time offset directly (in seconds). Use for arbitrary preview testing.",
	Group = "Admin",
	Args = { {
		Type = "number",
		Name = "secondsOffset",
		Description = "Seconds to add to UpdateGate's current time. Negative values rewind."
	} }
}
