-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "incidents",
	Description = "Persistent enforcement incidents + per-domain advisory trust. Actions: recent [verdict] [n] | worst [domain|inc] [n] | player <nameOrId> | trust <nameOrId> | watch <matchId>",
	Group = "Admin",
	Args = {
		{
			Type = "string",
			Name = "action",
			Description = "recent | player | trust | watch"
		},
		{
			Type = "string",
			Name = "arg",
			Description = "verdict (recent) / player nameOrId / full matchId (watch)",
			Optional = true
		},
		{
			Type = "integer",
			Name = "n",
			Description = "row cap for recent (default 25)",
			Optional = true
		}
	}
}
