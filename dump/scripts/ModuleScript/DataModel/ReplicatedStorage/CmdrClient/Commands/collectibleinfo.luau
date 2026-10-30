-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "collectibleinfo",
	Description = "Look up who owns a Collectible serial (or every issued serial of one item). Prints the current owner and the lineage id -- feed that to `itemhistory` for the full custody chain. Flags any duplicate-serial evidence.",
	Group = "Admin",
	Args = {
		{
			Type = "collectibleKey",
			Name = "collectible",
			Description = "<Type>:<ItemId>, e.g. Knife:TestCollectible."
		},
		{
			Type = "integer",
			Name = "serial",
			Description = "Serial number to look up, or 0 for every issued serial of this item.",
			Default = 0
		}
	}
}
