-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "simtrade",
	Description = "[DEV] Simulate a trade transfer of an item from giver to receiver (defaults to self round-trip). Runs the real trade validators + transfer path.",
	Group = "Admin",
	Args = {
		{
			Type = "players",
			Name = "giver",
			Description = "Who gives the item. . = self."
		},
		{
			Type = "string",
			Name = "kind",
			Description = "Knife | Revolver | Crate | Finisher"
		},
		{
			Type = "string",
			Name = "itemId",
			Description = "Catalog ID of an item the giver owns."
		},
		{
			Type = "integer",
			Name = "count",
			Description = "How many (default 1).",
			Optional = true
		},
		{
			Type = "players",
			Name = "receiver",
			Description = "Who receives (default = giver, self round-trip).",
			Optional = true
		},
		{
			Type = "finisher",
			Name = "finisher",
			Description = "Only target instances carrying this finisher.",
			Optional = true
		}
	}
}
