-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "simkill",
	Description = "Simulate a kill (mirrors WeaponsServer's stat-increment sequence; feeds DailyTasks + SpecialTasks).",
	Group = "Admin",
	Aliases = { "sk" },
	Args = {
		{
			Type = "integer",
			Name = "count",
			Description = "How many kills to simulate (default 1).",
			Optional = true
		},
		{
			Type = "killWeapon",
			Name = "weapon",
			Description = "Knife or Revolver (default Knife).",
			Optional = true
		},
		{
			Type = "string",
			Name = "flags",
			Description = "Combine letters: h=headshot l=longshot b=backstab (e.g. 'hl').",
			Optional = true
		}
	}
}
