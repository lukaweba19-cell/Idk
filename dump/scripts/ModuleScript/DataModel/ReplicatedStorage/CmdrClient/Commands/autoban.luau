-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "autoban",
	Description = "AutoBan status and log. `autoban` = this server's mode and counts; `autoban recent [would|banned|signal]` = newest flagged players fleet-wide; `autoban player <userId>` = one player's record; `autoban unban <userId>` = lift the Roblox ban and log who did it; `autoban breaker` = circuit breaker state, `autoban breaker reset` = re-arm it; `autoban release` = run every held ban; `autoban recent held` = what's held.",
	Group = "Admin",
	Args = {
		{
			Type = "string",
			Name = "action",
			Description = "(blank) | recent | player | unban | breaker | release",
			Optional = true
		},
		{
			Type = "string",
			Name = "arg",
			Description = "scope (would | banned | held | signal), a userId, or reset (for breaker)",
			Optional = true
		}
	}
}
