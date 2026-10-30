-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "makegood",
	Description = "Test the one-time grants and notices in Shared.MakegoodWaves. status = who is eligible / already claimed; preview = show the modal without granting or touching data; reset = clear the claim so the next join re-delivers; deliver = reset then grant (or notice) + show immediately.",
	Group = "Admin",
	Args = {
		{
			Type = "players",
			Name = "targets",
			Description = "Players to act on. . = self, * = everyone."
		},
		{
			Type = "string",
			Name = "action",
			Description = "status | preview | reset | deliver. Defaults to status.",
			Default = "status"
		},
		{
			Type = "string",
			Name = "wave",
			Description = "Wave id (e.g. ChromaKatanaLate, DupeCleanupAug2026). Omit to act on all waves the target is in; required for preview.",
			Default = ""
		}
	}
}
