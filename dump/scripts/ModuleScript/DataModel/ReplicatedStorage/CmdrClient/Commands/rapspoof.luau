-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "rapspoof",
	Description = "MD [DEV] ONLY. Writes synthetic booth sales for an item so RAP and the item index's RAP graph can be tested without real trading. add <item> [days=14] [basePrice=300] [salesPerDay=3]: fills the past N days with eligible sales (distinct fake buyers, random walk around basePrice) and recomputes RAP. clear <item>: strips the synthetic sales again and resets the published anchor. Refuses outside the dev universe.",
	Group = "Admin",
	Args = {
		{ Type = "string", Name = "action", Description = "add | clear" },
		{
			Type = "itemKey",
			Name = "item",
			Description = "<Kind>:<ItemId>, e.g. Knife:Glass (weapons and finishers only -- crates carry no RAP)."
		},
		{
			Type = "integer",
			Name = "days",
			Description = "add: past days to fill (1-30).",
			Default = 14
		},
		{
			Type = "integer",
			Name = "basePrice",
			Description = "add: token price the walk centres on.",
			Default = 300
		},
		{
			Type = "integer",
			Name = "salesPerDay",
			Description = "add: sales per day (1-10).",
			Default = 3
		}
	}
}
