-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "hitboxdebug",
	Description = "Toggle on-screen hitbox debug drawing FOR YOURSELF. After each shot you fire, draws where the server tested the target: WHITE = live position, RED = legacy rewind (ping + flat 0.10s), GREEN = timestamp rewind. Only ever draws targets your own shot resolved against, only for you, and only while WEAPON_AUTH_DEBUG_DRAW_ENABLED is published. Auto-clears when you leave.",
	Group = "Admin",
	Aliases = { "hbdebug", "drawhitbox" },
	Args = { {
		Type = "boolean",
		Name = "enabled",
		Description = "true to start drawing, false to stop. Omit to report current state.",
		Optional = true
	} }
}
