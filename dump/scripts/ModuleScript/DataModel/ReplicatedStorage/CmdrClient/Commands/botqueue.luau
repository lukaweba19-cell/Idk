-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "botqueue",
	Description = "Queue YOURSELF into the hidden 1v1-vs-bot matchmaking mode (1v1bot): the FULL real pipeline - queue -> Coordinator -> reserved server teleport -> boarding -> warmup hold -> map vote -> match vs 1 bot -> post-match requeue panel - with no second human needed. PUBLISHED place only (teleports fail in Studio; use /bot or /tutmatch there). Requirements: solo (no party), not in a match, not already queued. Cancel via the normal matchmaking panel X. Tip: vote Office - bots are only validated there; on open maps a fallen bot can stall a round until the round timer.",
	Aliases = { "mmtest", "queuebot" },
	Args = {}
}
