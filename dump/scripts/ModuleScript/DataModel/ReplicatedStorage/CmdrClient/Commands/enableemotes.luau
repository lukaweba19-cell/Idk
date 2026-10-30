-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "enableemotes",
	Description = "Force the emote gate on THIS server without touching the dashboard: on, off, or clear (back to the dashboard value). Server-local, in-memory, not persisted.",
	Group = "Admin",
	Aliases = { "emotes" },
	Args = { {
		Type = "string",
		Name = "mode",
		Description = "on | off | clear (default: on)",
		Optional = true
	} }
}
