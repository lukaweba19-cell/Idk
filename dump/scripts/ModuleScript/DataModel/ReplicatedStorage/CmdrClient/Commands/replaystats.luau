-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "replaystats",
	Description = "Inspect the replay recorder (Phase 1). `status` lists live and recently finished recordings with sample counts, byte estimates, event and overlay-window totals. `verify` re-decodes the most recent finished blob and runs the never-desync assertion against it. `on`/`off` toggle recording server-wide -- the killswitch if capture ever misbehaves.",
	Group = "Admin",
	Aliases = { "rs" },
	Args = { {
		Type = "string",
		Name = "action",
		Description = "status | verify | on | off"
	} }
}
