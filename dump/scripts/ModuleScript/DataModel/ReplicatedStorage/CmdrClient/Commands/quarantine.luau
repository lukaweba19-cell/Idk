-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "quarantine",
	Description = "Set the record-only TrustFactor quarantine flag on a player -- the sticky Bottom-tier marker the derive-on-read TrustScore reads. INERT: changes only their /trust standing + the TrustEval analytics bucket; gates no gameplay or matchmaking. Target must be present on this server. Use /unquarantine to clear.",
	Group = "Admin",
	Aliases = { "quar" },
	Args = {
		{
			Type = "player",
			Name = "player",
			Description = "Player to quarantine (must be on this server)."
		},
		{
			Type = "string",
			Name = "reason",
			Description = "Optional reason (everything after the player name).",
			Optional = true
		}
	}
}
