-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "grantpack",
	Description = "MD [DEV] ONLY. Grant a pack through the real PackManager grant path (inventory grants, notifications, purchase count), no Robux. For packs whose products can't be bought from DEV, e.g. the off-sale Halloween bundles.",
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
