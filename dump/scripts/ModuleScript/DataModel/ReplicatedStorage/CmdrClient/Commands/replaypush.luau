-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "replaypush",
	Description = "Push a replay blob to the local web viewer (http://localhost:8787).",
	Group = "Admin",
	Aliases = { "rpush" },
	Args = { {
		Type = "string",
		Name = "id",
		Description = "Replay id, or 'latest' for the most recent recording.",
		Default = "latest"
	} }
}
