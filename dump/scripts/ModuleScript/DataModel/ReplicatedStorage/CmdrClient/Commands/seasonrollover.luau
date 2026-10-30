-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "seasonrollover",
	Description = "Force a Season Pass rollover on one or more players. DESTRUCTIVE: wipes their seasonal XP, tier, premium and claims. Requires confirm=true.",
	Group = "Admin",
	Args = {
		{
			Type = "players",
			Name = "targets",
			Description = "Players to roll over. . = self, * = everyone."
		},
		{
			Type = "boolean",
			Name = "confirm",
			Description = "Must be true to actually run. Guards a mistyped rollover from wiping seasonal progress.",
			Optional = true
		}
	}
}
