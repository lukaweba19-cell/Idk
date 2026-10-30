-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "addcode",
	Description = "Add a gift code to the live DataStore catalog. Types: cash <amount>, knife <itemId>, revolver <itemId>, crate <crateId> [count].",
	Group = "Admin",
	Args = {
		{
			Type = "string",
			Name = "code",
			Description = "Code (uppercased server-side)."
		},
		{
			Type = "rewardType",
			Name = "type",
			Description = "cash | knife | revolver | crate | ke."
		},
		{
			Type = "string",
			Name = "value",
			Description = "Amount for cash, item ID for knife/revolver/crate."
		},
		{
			Type = "integer",
			Name = "count",
			Description = "Count (crate only, default 1).",
			Optional = true
		}
	}
}
