-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "invdump",
	Description = "[DEV] Dump a player's tradeable item instances (Id / ItemId / Finisher / tradeable) and flag any duplicate instance Ids.",
	Group = "Admin",
	Args = { {
		Type = "players",
		Name = "target",
		Description = "Player to dump (default self).",
		Optional = true
	} }
}
