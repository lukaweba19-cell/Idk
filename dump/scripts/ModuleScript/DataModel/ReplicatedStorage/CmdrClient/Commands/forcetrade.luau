-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "forcetrade",
	Description = "[DEV / Team Test lobby] Force the real trade UI open between two players (defaults to the two players in the server). Runs the full normal trade flow from there; needs TradingEnabled (see tradingoverride).",
	Group = "Admin",
	Args = {
		{
			Type = "players",
			Name = "playerA",
			Description = "First player (default: auto from server).",
			Optional = true
		},
		{
			Type = "players",
			Name = "playerB",
			Description = "Second player (default: auto from server).",
			Optional = true
		}
	}
}
