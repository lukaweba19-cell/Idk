-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "weaponauth",
	Description = "Inspect the weapon-authority SHADOW harness: how often the server's authoritative hit resolve disagrees with the client's claim, and why. Read-only, changes nothing. Requires WEAPON_AUTH_SHADOW_ENABLED on the dashboard. Views: summary (default) | recent | speed | cadence | total (cross-server accumulated, sliced by match source) | reset.",
	Group = "Admin",
	Aliases = { "wauth", "authshadow" },
	Args = {
		{
			Type = "string",
			Name = "view",
			Description = "summary | recent | speed | cadence | total (accumulated across every dev server, split Bots/Matchmaking/Pads) | aim | move | throws | player (per-player review sheet, all signals side by side) | reset.",
			Optional = true
		},
		{
			Type = "integer",
			Name = "limit",
			Description = "For 'recent': how many to list, 1-50 (default 12).",
			Optional = true
		},
		{
			Type = "player",
			Name = "target",
			Description = "For 'player': whose review sheet to show. Omit to list who is tracked.",
			Optional = true
		}
	}
}
