-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "friendboost",
	Description = "Fake your in-server friend count for testing the Friend Boost (0-3, or -1 to clear and restore real detection).",
	Group = "Admin",
	Aliases = { "fb" },
	Args = { {
		Type = "integer",
		Name = "friends",
		Description = "Number of fake friends (0-3). Use -1 to clear the override."
	} }
}
