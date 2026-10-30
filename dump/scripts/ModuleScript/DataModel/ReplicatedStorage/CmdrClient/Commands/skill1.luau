-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "skill1",
	Description = "Unlock and equip an ability into slot 1 (Q) for one or more players.",
	Group = "Admin",
	Args = {
		{
			Type = "players",
			Name = "targets",
			Description = "Players to equip. . = self, * = everyone."
		},
		{
			Type = "ability",
			Name = "ability",
			Description = "Ability ID (from AbilityCatalog)."
		}
	}
}
