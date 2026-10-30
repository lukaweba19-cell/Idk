-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "collectiblesalegate",
	Description = "Inspect or drive the Open Cloud sale gate for a collectible. `status` with no item shows relay config and which credential slot is live; with an item it adds claim and live sale state. `off` takes the buy and gift products off sale; `on` puts them back and clears the claim so a later sellout can fire again. `on` is what you need after `wipecollectible` on MD [DEV] -- that resets supply but not Roblox's sale state.",
	Group = "Admin",
	Args = {
		{
			Type = "saleGateAction",
			Name = "action",
			Description = "status | on | off"
		},
		{
			Type = "collectibleKey",
			Name = "collectible",
			Description = "<Type>:<ItemId>, e.g. Knife:TestCollectible. Omit for `status` to see config only; required for on/off.",
			Optional = true
		}
	}
}
