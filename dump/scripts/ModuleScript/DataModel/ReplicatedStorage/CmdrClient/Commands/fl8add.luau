-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "fl8add",
	Description = "fl8mey quests TEST: add games or kills (payouts and toasts run as normal, even outside the event window), or 'secret' to complete the Secret Quest.",
	Group = "Admin",
	Args = {
		{
			Type = "string",
			Name = "stat",
			Description = "games | kills | secret"
		},
		{
			Type = "integer",
			Name = "count",
			Description = "Amount to add (1-5000; ignored for secret)",
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
