-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "wipecollectible",
	Description = "MD [DEV] ONLY. Erase all supply data for a DevOnly test collectible -- serial ledger, sold-out state, compensation markers, and every copy held by players in this server -- so the drop can be re-tested from #1. Refuses any collectible that isn't DevOnly test content.",
	Group = "Admin",
	Args = { {
		Type = "devCollectible",
		Name = "collectible",
		Description = "\"all\", or a <Type>:<ItemId> key such as Knife:TestCollectible. Only DevOnly test collectibles are accepted."
	} }
}
