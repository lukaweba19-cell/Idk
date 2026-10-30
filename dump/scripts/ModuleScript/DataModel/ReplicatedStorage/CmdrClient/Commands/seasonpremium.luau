-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "seasonpremium",
	Description = "Grant or revoke Season Pass premium for one or more players (no Robux charged).",
	Group = "Admin",
	Args = {
		{
			Type = "players",
			Name = "targets",
			Description = "Players to change. . = self, * = everyone."
		},
		{
			Type = "boolean",
			Name = "premium",
			Description = "true grants premium, false revokes it."
		}
	}
}
