-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "seasontier",
	Description = "Set a player's Season Pass tier directly. Snaps season XP to the tier's threshold.",
	Group = "Admin",
	Args = {
		{
			Type = "players",
			Name = "targets",
			Description = "Players to set. . = self, * = everyone."
		},
		{
			Type = "number",
			Name = "tier",
			Description = "Tier to set. Clamped to 1..SeasonPassConfig.TierCount."
		}
	}
}
