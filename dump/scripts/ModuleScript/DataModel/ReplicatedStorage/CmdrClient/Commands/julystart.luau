-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "julystart",
	Description = "Start the Fourth of July event NOW for testing, unlocking tiers 1..day. day is optional (1-6); omit it to unlock all 6. Idempotent (safe to re-run) and SERVER-WIDE; resets on server restart.",
	Group = "Admin",
	Args = { {
		Type = "integer",
		Name = "day",
		Description = "Unlock tiers 1 through this day (1-6). Omit to unlock all 6.",
		Optional = true
	} }
}
