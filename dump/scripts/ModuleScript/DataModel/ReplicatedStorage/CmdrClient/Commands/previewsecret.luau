-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "previewsecret",
	Description = "Preview the Secret unbox reveal on your screen (nothing is granted). Optional item id or name; default: a random Secret.",
	Group = "Admin",
	Aliases = { "secretpreview" },
	Args = { {
		Type = "string",
		Name = "item",
		Description = "Item id or name (knife, gun or finisher). Default: a random Secret knife or gun.",
		Optional = true
	} }
}
