-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "tradecheck",
	Description = "Read-only durable state of a player's trade commits. Verifies crash/replay repair.",
	Group = "Admin",
	Args = {
		{
			Type = "players",
			Name = "target",
			Description = "Who to inspect. . = self."
		},
		{
			Type = "string",
			Name = "sessionId",
			Description = "Optional trade session id to resolve against the commit stores.",
			Optional = true
		}
	}
}
