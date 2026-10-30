-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "unquarantine",
	Description = "Clear the record-only TrustFactor quarantine flag on a player (set via /quarantine); also wipes the stored quarantine metadata. Target must be present on this server.",
	Group = "Admin",
	Aliases = { "unquar" },
	Args = { {
		Type = "player",
		Name = "player",
		Description = "Player to un-quarantine (must be on this server)."
	} }
}
