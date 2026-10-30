-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "all",
	Description = "Grant every item in every catalog (knives, revolvers, crates, finishers) to one or more players. Collectibles are skipped -- their serials are supply-controlled.",
	Group = "Admin",
	Args = { {
		Type = "players",
		Name = "targets",
		Description = "Players to grant to. . = self, * = everyone."
	} }
}
