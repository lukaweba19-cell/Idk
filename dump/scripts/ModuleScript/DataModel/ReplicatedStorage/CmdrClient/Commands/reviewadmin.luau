-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "reviewadmin",
	Description = "Replay review queue admin. `reviewadmin` = mode + top of the queue; `reviewadmin build` = rebuild cases now; `reviewadmin case <userId>` = one case with every vote; `reviewadmin decided` = recent decisions; `reviewadmin mod <userId>` = one moderator's totals.",
	Group = "Admin",
	Args = {
		{
			Type = "string",
			Name = "action",
			Description = "(blank) | build | case | decided | mod",
			Optional = true
		},
		{
			Type = "string",
			Name = "arg",
			Description = "userId",
			Optional = true
		}
	}
}
