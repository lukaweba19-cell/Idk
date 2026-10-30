-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "itemowners",
	Description = "Who holds an item, and how many copies each -- for NON-serialized items (collectibleinfo covers serials). Newest acquirer first, 100 per page; each row says when they got their newest copy and whether they unboxed/bought it or traded for it. Reads the reverse owner index (ItemOwners_v1), which fills in as holders log in; the header shows how many copies it accounts for. Pass a userId as the third argument to check one player instead.",
	Group = "Admin",
	Args = {
		{
			Type = "itemKey",
			Name = "item",
			Description = "<Type>:<ItemId>, e.g. Knife:Voidreaver."
		},
		{
			Type = "integer",
			Name = "page",
			Description = "Page of holders to show (100 per page).",
			Default = 1
		},
		{
			Type = "integer",
			Name = "userId",
			Description = "Optional: a UserId to check on its own instead of listing.",
			Default = 0
		}
	}
}
