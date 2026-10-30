-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "replaystore",
	Description = "Inspect or exercise the replay upload path (Phase 2). `status` shows queue depth, upload/failure counts and the last error. `ping` pushes a 16-byte probe blob at the relay to prove the route exists and the token is accepted -- use this first when nothing is uploading. `on`/`off` toggle uploads without touching recording.",
	Group = "Admin",
	Args = { {
		Type = "string",
		Name = "action",
		Description = "status | ping | on | off"
	} }
}
