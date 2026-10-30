-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "plagueadd",
	Description = "Plague event TEST: add N kills (runs every unlock on the way, even outside the event window). forcepurple=true makes every reward this unlocks roll purple.",
	Group = "Admin",
	Args = {
		{
			Type = "integer",
			Name = "count",
			Description = "Kills to add (1-5000)"
		},
		{
			Type = "boolean",
			Name = "forcepurple",
			Description = "Force the purple roll on rewards this unlocks",
			Optional = true
		},
		{
			Type = "player",
			Name = "player",
			Description = "Player (default you)",
			Optional = true
		}
	}
}
