-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "givesign",
	Description = "MD [DEV] only: grant the Booth or Looking For sign to a player without buying it.",
	Group = "Admin",
	Args = {
		{
			Type = "string",
			Name = "sign",
			Description = "booth | wanted | text"
		},
		{
			Type = "player",
			Name = "player",
			Description = "Who gets it. Default: you.",
			Optional = true
		}
	}
}
