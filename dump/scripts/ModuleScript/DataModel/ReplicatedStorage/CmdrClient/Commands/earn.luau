-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "earn",
	Description = "Add cash to one or more players.",
	Group = "Admin",
	Args = {
		{
			Type = "players",
			Name = "targets",
			Description = "Players to give to. . = self, * = everyone."
		},
		{
			Type = "number",
			Name = "amount",
			Description = "Amount of cash to add."
		}
	}
}
