-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "notifyserverrestart",
	Description = "Start a server-restart countdown that auto-broadcasts a restart notice to every running server every 5 minutes and at 1 minute remaining. Fire-and-forget from the calling server.",
	Group = "Admin",
	Args = { {
		Type = "number",
		Name = "minutes",
		Description = "Minutes until restart (1-720). The first notice is sent immediately."
	} }
}
