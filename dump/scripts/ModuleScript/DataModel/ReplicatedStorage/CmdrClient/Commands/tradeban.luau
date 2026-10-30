-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "tradeban",
	Description = "Trade / booth bans (ServerStorage.TradeBans) -- writes the same TradeBans_v1 record the Discord bot writes. status = the target's bans; trade / booth / market = ban for a duration (market = both); lift = remove trade | booth | market (default market). Offline targets work. The target's server enforces at once: open trade cancelled, booth closed, a toast.",
	Group = "Admin",
	Args = {
		{
			Type = "string",
			Name = "action",
			Description = "status | trade | booth | market | lift"
		},
		{
			Type = "string",
			Name = "target",
			Description = ". = self, or a userId / username. Offline is fine."
		},
		{
			Type = "string",
			Name = "value",
			Description = "trade / booth / market: duration -- 30m, 12h, 7d, 2w, 1d12h, or perm. lift: trade | booth | market (default market).",
			Default = "",
			Optional = true
		},
		{
			Type = "string",
			Name = "reason",
			Description = "Audit note, never shown to the player (quote it if it has spaces).",
			Default = "",
			Optional = true
		}
	}
}
