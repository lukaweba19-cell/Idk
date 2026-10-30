-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "dupetest",
	Description = "[DEV ONLY] Arm a one-shot trade-rollback repro. Fires the instant a token debit lands on the target.",
	Group = "Admin",
	Args = {
		{
			Type = "players",
			Name = "target",
			Description = "Who to arm. . = self."
		},
		{
			Type = "string",
			Name = "mode",
			Description = "kick | steal | crash | off"
		},
		{
			Type = "integer",
			Name = "armFor",
			Description = "Seconds to stay armed (default 180).",
			Optional = true
		},
		{
			Type = "integer",
			Name = "crashDelay",
			Description = "crash mode only: seconds to let write queues drain before wedging. 0 = both sides die (clean rollback). ~3 = one side lands (the DUPE case). Default 3.",
			Optional = true
		}
	}
}
