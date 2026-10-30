-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "restartsim",
	Description = "Simulate a scheduled server restart (banner + chat pings). Rehearsal only -- does NOT restart anything. Cosmetic unless sideEffects is set, which is dev-universe-only.",
	Group = "Admin",
	Args = {
		{
			Type = "number",
			Name = "seconds",
			Description = "Seconds until the simulated restart (1-3600)."
		},
		{
			Type = "string",
			Name = "reason",
			Description = "Optional reason text, as if typed into the Creator Hub payload box.",
			Optional = true
		},
		{
			Type = "boolean",
			Name = "maintenance",
			Description = "Render as Roblox maintenance instead of a developer update.",
			Optional = true
		},
		{
			Type = "boolean",
			Name = "sideEffects",
			Description = "DEV ONLY. Also run the real one-way side effects (streak protection + worker handoff). Off by default; refused outside the dev universe.",
			Optional = true
		}
	}
}
