-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "exp",
	Description = "Add EXP to one or more players and flush level-up rewards.",
	Group = "Admin",
	Args = {
		{
			Type = "players",
			Name = "targets",
			Description = "Players to give EXP. . = self, * = everyone."
		},
		{
			Type = "number",
			Name = "amount",
			Description = "Amount of EXP to add."
		}
	}
}
