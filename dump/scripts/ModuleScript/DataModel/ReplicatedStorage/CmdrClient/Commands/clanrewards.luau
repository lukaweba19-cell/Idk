-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "clanrewards",
	Description = "Inspect or drive the clan reward weapons (Champion's Knife / Sniper). `status` shows the active period (All-Time until Sep 1 2026, Monthly after), the countdown to the next reset, the kill floor, and the top clans with their eligibility -- add a player to see their own entitlement and holdings. `sync` forces a flush + board refetch + reconcile of everyone, instead of waiting out the 120s/180s intervals. `grant` / `revoke` force the set on or off for a player, bypassing rank and the floor -- note the next reconcile undoes them. To preview the All-Time -> Monthly switch, use `previewupdate ClanRewardsMonthly`.",
	Group = "Admin",
	Args = {
		{
			Type = "clanRewardsAction",
			Name = "action",
			Description = "status | sync | grant | revoke"
		},
		{
			Type = "player",
			Name = "target",
			Description = "Optional for `status` (adds their entitlement); REQUIRED for grant/revoke. Ignored by `sync`.",
			Optional = true
		}
	}
}
