-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "forcevariant",
	Description = "Grant a pack with its 1% variant roll forced to hit (e.g. Midnight -> Negative Midnight). Fires the real grant path, notifications and the PackVariantHit remote.",
	Group = "Admin",
	Args = {
		{
			Type = "players",
			Name = "targets",
			Description = "Players to grant to. . = self, * = everyone."
		},
		{
			Type = "packId",
			Name = "pack",
			Description = "Pack ID to grant (from PackCatalog)."
		}
	}
}
