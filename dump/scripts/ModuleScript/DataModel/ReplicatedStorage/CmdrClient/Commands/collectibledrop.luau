-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "collectibledrop",
	Description = "MD [DEV] ONLY. Rehearse a drop: reveal a collectible NOW and open sales N seconds from now, instead of waiting for its authored DropAt and the real reveal window. Exercises the REAL gate -- Claim still refuses inside the window and every countdown on screen reads the same clock. Session-only; clears on restart or with `collectibledropreset`.",
	Group = "Admin",
	Args = {
		{
			Type = "collectibleKey",
			Name = "collectible",
			Description = "<Type>:<ItemId>, e.g. Knife:ChromaKatana."
		},
		{
			Type = "integer",
			Name = "seconds",
			Description = "Seconds until sales open. 0 opens immediately. Default 5.",
			Default = 5
		}
	}
}
