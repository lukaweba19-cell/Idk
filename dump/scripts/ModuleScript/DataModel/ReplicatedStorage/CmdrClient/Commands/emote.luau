-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "emote",
	Description = "Grant emotes to one or more players' inventories. Use 'all' for one of every emote.",
	Group = "Admin",
	Aliases = { "giveemote" },
	Args = {
		{
			Type = "players",
			Name = "targets",
			Description = "Players to grant to. . = self, * = everyone."
		},
		{
			Type = "string",
			Name = "emote",
			Description = "Emote ID (from EmoteCatalog), or 'all'."
		},
		{
			Type = "integer",
			Name = "count",
			Description = "How many to grant per player (default 1).",
			Optional = true
		}
	}
}
