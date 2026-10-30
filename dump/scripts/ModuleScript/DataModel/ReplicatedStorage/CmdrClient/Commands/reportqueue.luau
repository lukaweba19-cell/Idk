-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "reportqueue",
	Description = "Recently reported matches, newest first. `reportqueue` lists them; `reportqueue watch <id>` opens the replay; `reportqueue done <id>` removes one from the queue. Match ids accept the first 8 characters.",
	Group = "Admin",
	Args = { {
		Type = "string",
		Name = "action",
		Description = "(blank) | watch <id> | done <id>",
		Optional = true
	} }
}
