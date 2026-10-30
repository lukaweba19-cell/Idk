-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "tradehistory",
	Description = "Show a player's recorded trade history (TradeLedger). Works for offline players -- pass a username or UserId.",
	Group = "Admin",
	Aliases = { "trades" },
	Args = {
		{
			Type = "string",
			Name = "player",
			Description = "Username or UserId (offline OK)."
		},
		{
			Type = "integer",
			Name = "count",
			Description = "How many trades (default 10, max 25).",
			Optional = true
		}
	}
}
