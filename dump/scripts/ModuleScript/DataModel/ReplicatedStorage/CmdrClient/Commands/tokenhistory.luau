-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "tokenhistory",
	Description = "Trade Token balance journal for a player: every credit/debit newest-first with reason and counterparty. Answers 'gifted, traded, or minted?'",
	Group = "Admin",
	Args = { {
		Type = "player",
		Name = "player",
		Description = "Target player (must be in this server -- the journal lives on the loaded profile)."
	} }
}
