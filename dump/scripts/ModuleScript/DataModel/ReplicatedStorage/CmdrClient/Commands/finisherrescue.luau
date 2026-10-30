-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "finisherrescue",
	Description = "Inspect the clan-reward finisher rescue for a player. `scan` reads DeletionLog_V1 for revoke-destroyed Champion weapons and resolves, from the profile's DataStore version history, which finisher was applied to each -- WITHOUT granting anything. `rows` is the cheap version: eligible rows only, no version lookups. Neither action writes. Eligibility is by SOURCE TAG, not time: rows tagged 'ClanReward' came from the old revoke that destroyed the finisher and are repairable; 'ClanReward:v2' rows came from the fixed revoke that handed it back and are excluded. The restore itself runs once per profile on the player's next join, and only once ENABLED is flipped to true in ServerScriptService.Main.ClanFinisherRescue -- until then this reports without granting or stamping anyone.",
	Group = "Admin",
	Aliases = {},
	Args = {
		{
			Type = "finisherRescueAction",
			Name = "action",
			Description = "scan (resolve finishers) | rows (list eligible rows only)"
		},
		{
			Type = "player",
			Name = "player",
			Description = "The player to inspect."
		}
	}
}
