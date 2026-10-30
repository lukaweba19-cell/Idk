-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "tokens",
	Description = "Set the Trade Tokens of one or more players.",
	Group = "Admin",
	Args = {
		{
			Type = "players",
			Name = "targets",
			Description = "Players to set. . = self, * = everyone."
		},
		{
			Type = "number",
			Name = "amount",
			Description = "New Trade Token value."
		}
	}
}
