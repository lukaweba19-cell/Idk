-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "mmshards",
	Description = "Inspect or test the matchmaking shard autoscaler. 'view' prints the live MM_Coord summary (queued depth, shard K per mode, fake overrides). 'fake <mode> <count> <seconds>' makes the publisher treat <mode> as having at least <count> queued players for <seconds>, so you can watch K ladder up (and later back down) without real load. 'clear' removes all fake depths.",
	Group = "Admin",
	Aliases = { "shards" },
	Args = {
		{
			Type = "string",
			Name = "action",
			Description = "view | fake | clear"
		},
		{
			Type = "string",
			Name = "mode",
			Description = "Mode key from Config.Modes (e.g. 1v1, 2v2). Required for 'fake'.",
			Optional = true
		},
		{
			Type = "number",
			Name = "count",
			Description = "Fake queued-player depth for the mode (fake only).",
			Optional = true
		},
		{
			Type = "number",
			Name = "seconds",
			Description = "How long the fake depth lasts (default 300).",
			Optional = true
		}
	}
}
