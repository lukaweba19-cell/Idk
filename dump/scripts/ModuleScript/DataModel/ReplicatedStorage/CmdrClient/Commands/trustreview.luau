-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "trustreview",
	Description = "List a sample of userIds from a trust tier (default: quarantined), most-suspicious first, from the enumerable trust index. Outputs userId + tier + score; look up deeper detail (winrate / flags) with the offline-read tooling. Record-only; gates nothing.",
	Group = "Admin",
	Aliases = { "treview", "trev" },
	Args = {
		{
			Type = "string",
			Name = "tier",
			Description = "quarantined | low | mid | high | all (default quarantined).",
			Optional = true
		},
		{
			Type = "integer",
			Name = "limit",
			Description = "How many to list, 1-50 (default 10).",
			Optional = true
		}
	}
}
