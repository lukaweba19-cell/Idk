-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "kbxshifttime",
	Description = "Simulate clock movement by N seconds (positive = forward / unlocks sooner, negative = backward / delays). SERVER-WIDE.",
	Group = "Admin",
	Args = { {
		Type = "integer",
		Name = "seconds",
		Description = "Seconds to skip. Positive=forward (unlocks sooner), negative=backward (delays)."
	} }
}
