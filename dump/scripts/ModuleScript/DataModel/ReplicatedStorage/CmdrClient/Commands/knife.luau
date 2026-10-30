-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "knife",
	Description = "Grant a knife skin to one or more players. Optional finisher attaches.",
	Group = "Admin",
	Args = {
		{
			Type = "players",
			Name = "targets",
			Description = "Players to grant to. . = self, * = everyone."
		},
		{
			Type = "knifeSkin",
			Name = "skin",
			Description = "Knife skin ID (from KnifeCatalog)."
		},
		{
			Type = "finisher",
			Name = "finisher",
			Description = "Optional finisher ID.",
			Optional = true
		}
	}
}
