-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "playtime",
	Description = "Show a player's presence record: first/last join, join count, recent joins, and lifetime playtime split by context.",
	Group = "Admin",
	Aliases = { "pt", "joins" },
	Args = {
		{ Type = "player", Name = "player", Description = "Player to inspect" },
		{
			Type = "integer",
			Name = "count",
			Description = "How many recent joins to list (default 10, max 30)",
			Default = 10
		}
	}
}
