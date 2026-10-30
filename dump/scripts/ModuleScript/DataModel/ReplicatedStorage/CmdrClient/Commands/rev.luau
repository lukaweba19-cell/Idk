-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "rev",
	Description = "Grant a revolver skin to one or more players. Optional finisher attaches.",
	Group = "Admin",
	Args = {
		{
			Type = "players",
			Name = "targets",
			Description = "Players to grant to. . = self, * = everyone."
		},
		{
			Type = "revolverSkin",
			Name = "skin",
			Description = "Revolver skin ID (from RevolverCatalog)."
		},
		{
			Type = "finisher",
			Name = "finisher",
			Description = "Optional finisher ID.",
			Optional = true
		}
	}
}
