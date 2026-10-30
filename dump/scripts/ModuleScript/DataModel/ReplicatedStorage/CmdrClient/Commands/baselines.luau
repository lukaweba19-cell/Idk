-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "baselines",
	Description = "Fleet healthy-play distributions per input cohort (BaselineStats_v1). Metrics: melee_dist, throw_travel, shot_dist, aim_deg, hs",
	Group = "Admin",
	Args = {
		{
			Type = "string",
			Name = "metric",
			Description = "melee_dist | throw_travel | shot_dist | aim_deg | hs"
		},
		{
			Type = "string",
			Name = "week",
			Description = "ISO week like 2026-W35 (default: current)",
			Optional = true
		}
	}
}
