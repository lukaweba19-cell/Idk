-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "noshowqueue",
	Description = "Queue YOURSELF into the hidden 1v1noshow matchmaking mode: the FULL real pipeline (queue -> Coordinator -> reserved server teleport -> boarding) with an opponent who never existed. The reserved server shows 'Waiting for players (1/2)', waits out the real boarding timeout (Config.BoardingTimeout = 30s), then runs the genuine failure path: warmup exit, 'Players failed to join. Retrying...' toast, auto re-queue into the real 1v1 (it will sit Searching if nobody else is queued - cancel via the panel X). PUBLISHED place only (teleports fail in Studio; use /mmboarding for a local Studio sim). Requirements: solo (no party), not in a match, not already queued.",
	Group = "Admin",
	Aliases = { "mmnoshow", "timeouttest" },
	Args = {}
}
