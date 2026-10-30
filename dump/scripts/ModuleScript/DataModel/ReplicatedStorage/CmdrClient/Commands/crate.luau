-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "crate",
	Description = "Grant crates to one or more players.",
	Group = "Admin",
	Args = {
		{
			Type = "players",
			Name = "targets",
			Description = "Players to grant to. . = self, * = everyone."
		},
		{
			Type = "crateId",
			Name = "crate",
			Description = "Crate ID (from CrateCatalog)."
		},
		{
			Type = "integer",
			Name = "count",
			Description = "How many to grant per player (default 1).",
			Optional = true
		}
	}
}
