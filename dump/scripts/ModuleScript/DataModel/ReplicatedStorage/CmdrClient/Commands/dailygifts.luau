-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "dailygifts",
	Description = "Debug daily gifts. Actions: show, open, fast, reset, ready [day], tick <secondsAgo>, claim.",
	Group = "Admin",
	Args = {
		{
			Type = "dailyGiftsAction",
			Name = "action",
			Description = "What to do."
		},
		{
			Type = "integer",
			Name = "value",
			Description = "For 'ready': day 1-7. For 'tick': seconds ago.",
			Optional = true
		}
	}
}
