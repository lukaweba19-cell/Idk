-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "finisher",
	Description = "Grant standalone finishers (kill effects) to one or more players' inventories.",
	Group = "Admin",
	Aliases = { "givefinisher" },
	Args = {
		{
			Type = "players",
			Name = "targets",
			Description = "Players to grant to. . = self, * = everyone."
		},
		{
			Type = "finisher",
			Name = "finisher",
			Description = "Finisher ID (from KillEffectCatalog)."
		},
		{
			Type = "integer",
			Name = "count",
			Description = "How many to grant per player (default 1).",
			Optional = true
		}
	}
}
