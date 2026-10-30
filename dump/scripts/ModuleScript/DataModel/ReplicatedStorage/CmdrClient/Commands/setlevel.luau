-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "setlevel",
	Description = "Set one or more players to an exact level (works up or down). Resets EXP progress to 0; does not grant level-up coin rewards.",
	Group = "Admin",
	Aliases = { "lvl" },
	Args = {
		{
			Type = "players",
			Name = "targets",
			Description = "Players to set the level of. . = self, * = everyone."
		},
		{
			Type = "number",
			Name = "level",
			Description = "Level to set (minimum 1)."
		}
	}
}
