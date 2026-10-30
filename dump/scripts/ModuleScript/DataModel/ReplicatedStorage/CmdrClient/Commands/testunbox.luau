-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "testunbox",
	Description = "Fake an unbox announcement. Rarity: legendary, secret (default: legendary).",
	Group = "Admin",
	Aliases = { "tu" },
	Args = { {
		Type = "unboxRarity",
		Name = "rarity",
		Description = "legendary | secret (or l | s).",
		Optional = true
	} }
}
