-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "mmboarding",
	Description = "Studio-only: simulate the matchmaking BOARDING hold on THIS server. Everyone present is warped onto the warmup pad as 'boarded' while the top-centre status line waits for phantom player(s) who never arrive ('Waiting for players (X/Y)'). After the boarding timeout (default Config.BoardingTimeout = 30s) the real failure path runs: warmup exit, 'Players failed to join. Retrying...' toast, and the client auto re-queue (cancel via the panel X). Complements mmwarmup, which tests the post-boarding countdown -> map vote -> match path.",
	Group = "Admin",
	Aliases = { "boardtest" },
	Args = {
		{
			Type = "number",
			Name = "missing",
			Description = "Phantom players to wait for that never arrive (default 1). Expected = present + missing.",
			Optional = true
		},
		{
			Type = "number",
			Name = "timeout",
			Description = "Boarding timeout in seconds (default Config.BoardingTimeout = 30; min 3 for fast iteration).",
			Optional = true
		}
	}
}
