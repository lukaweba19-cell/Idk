-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "tradingoverride",
	Description = "[DEV / Team Test lobby ONLY] Force GameFlags.TradingEnabled on THIS server without touching the dashboard: on, off, or clear (back to dashboard / DEV default). Refuses on a real live server.",
	Group = "Admin",
	Args = { {
		Type = "string",
		Name = "mode",
		Description = "on | off | clear (default: on)",
		Optional = true
	} }
}
