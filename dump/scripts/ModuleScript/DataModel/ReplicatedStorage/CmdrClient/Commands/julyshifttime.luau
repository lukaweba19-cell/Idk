-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "julyshifttime",
	Description = "Simulate clock movement by N seconds for the Fourth of July event (positive = forward / unlocks sooner, negative = backward / delays). SERVER-WIDE.",
	Group = "Admin",
	Args = { {
		Type = "integer",
		Name = "seconds",
		Description = "Seconds to skip. Positive=forward (unlocks sooner), negative=backward (delays)."
	} }
}
