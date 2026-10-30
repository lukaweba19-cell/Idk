-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "tradeinfo",
	Description = "Dump the full TradeLedger record for one trade id: parties, items, lineage, instance ids, tokens.",
	Group = "Admin",
	Args = { {
		Type = "string",
		Name = "tradeId",
		Description = "Trade GUID (from tradehistory / itemhistory)."
	} }
}
