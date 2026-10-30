-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "plagueshifttime",
	Description = "Plague event TEST: shift this server's event clock by N seconds (0 = reset). SERVER-WIDE, resets on restart.",
	Group = "Admin",
	Args = { {
		Type = "integer",
		Name = "seconds",
		Description = "Seconds forward (negative = back, 0 = reset)"
	} }
}
