-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "kbxskip",
	Description = "Robux-skip a Korblox tier (debug bypass; tier defaults to current).",
	Group = "Admin",
	Args = { {
		Type = "kbxTier",
		Name = "tier",
		Description = "Tier to skip (1..6). Defaults to current tier if omitted.",
		Optional = true
	} }
}
