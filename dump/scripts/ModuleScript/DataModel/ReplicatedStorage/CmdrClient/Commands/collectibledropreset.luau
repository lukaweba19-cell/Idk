-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "collectibledropreset",
	Description = "MD [DEV] ONLY. Drop a `collectibledrop` rehearsal and restore the collectible's authored DropAt and the real reveal window. A server restart does the same thing.",
	Group = "Admin",
	Args = { {
		Type = "collectibleKey",
		Name = "collectible",
		Description = "<Type>:<ItemId>, e.g. Knife:ChromaKatana."
	} }
}
