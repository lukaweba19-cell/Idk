-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "rap",
	Description = "RAP inspector: get <Kind> <ItemId> (computed value + the sales it rests on) | sales <Kind> <ItemId> (raw index) | warm (walk the catalog) | all (cached values) | value [player] (inventory value).",
	Group = "Admin",
	Args = {
		{
			Type = "string",
			Name = "action",
			Description = "get | sales | warm | all | value"
		},
		{
			Type = "string",
			Name = "a",
			Description = "get/sales: Kind (Knife/Revolver/Finisher) | value: player name (default you)",
			Optional = true
		},
		{
			Type = "string",
			Name = "b",
			Description = "get/sales: ItemId",
			Optional = true
		}
	}
}
