-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "notifyallservers",
	Description = "Stage a notification to broadcast to every running server. Requires /conf to send.",
	Group = "Admin",
	Args = { {
		Type = "string",
		Name = "message",
		Description = "Message text (everything after the command name is taken as the message)."
	} }
}
