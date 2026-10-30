-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "reversal",
	Description = "Dupe-cleanup reversal queue (Main.ReversalQueue). status = the target's pending marker + what has already been applied to their profile; queue = add a Trade Token delta and/or ONE item op to the target's pending marker (same shape the bot writes); apply = online target: run the consumer now; OFFLINE target: load their profile with no Player and apply directly; applyall = the offline apply for every pending marker (run while the affected accounts are held offline); clear = delete the pending marker.",
	Group = "Admin",
	Args = {
		{
			Type = "string",
			Name = "action",
			Description = "status | queue | apply | applyall | clear"
		},
		{
			Type = "string",
			Name = "target",
			Description = ". = self, or a userId / username. Offline is fine for every action; applyall ignores it (pass .)."
		},
		{
			Type = "number",
			Name = "tokens",
			Description = "queue: signed Trade Token delta, e.g. -500. 0 = no token change.",
			Default = 0,
			Optional = true
		},
		{
			Type = "string",
			Name = "op",
			Description = "queue: Remove | Take | Give. Leave blank for a tokens-only marker.",
			Default = "",
			Optional = true
		},
		{
			Type = "string",
			Name = "kind",
			Description = "queue: Knife | Revolver | Finisher",
			Default = "",
			Optional = true
		},
		{
			Type = "string",
			Name = "itemId",
			Description = "queue: catalog id, e.g. ChromaKatana",
			Default = "",
			Optional = true
		},
		{
			Type = "string",
			Name = "lineage",
			Description = "queue: the item's lineage id (the sheet's UAID). Remove/Take find the copy by it; Give stamps it onto the new copy.",
			Default = "",
			Optional = true
		},
		{
			Type = "number",
			Name = "serial",
			Description = "queue Give: collectible serial to carry across. 0 = none.",
			Default = 0,
			Optional = true
		},
		{
			Type = "string",
			Name = "finisher",
			Description = "queue Give: finisher id to put on the returned copy (e.g. ChromaBlitz). Blank = a bare copy; nothing is defaulted.",
			Default = "",
			Optional = true
		}
	}
}
