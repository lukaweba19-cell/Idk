-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "collectibleexpire",
	Description = "MD [DEV] ONLY. Report every collectible as SOLD OUT with its display window about to END, so it ages out of the shop card, lobby bubble and case N seconds from now. Run it while `collectiblesoldout` is up to watch the clear. Display only -- nothing is written.",
	Group = "Admin",
	Args = { {
		Type = "integer",
		Name = "seconds",
		Description = "Seconds until the sold-out display clears. 0 clears on the next poll.",
		Default = 10
	} }
}
