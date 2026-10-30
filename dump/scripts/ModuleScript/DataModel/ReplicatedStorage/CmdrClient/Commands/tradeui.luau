-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "tradeui",
	Description = "Open the trade window against a fake partner so the new UI can be tried solo. NOTHING IS TRADED -- there is no session on the server, the items and RAP figures are fabricated, and quick chat is answered client-side. Close it with the X. MD [DEV].",
	Group = "Admin",
	Aliases = { "tui" },
	Args = {
		{
			Type = "player",
			Name = "partner",
			Description = "Whose name and headshot the fake partner wears (default: the Roblox account)",
			Optional = true
		},
		{
			Type = "integer",
			Name = "yourItems",
			Description = "Fake items on your side (0-10, default 2)",
			Optional = true,
			Default = 2
		},
		{
			Type = "integer",
			Name = "theirItems",
			Description = "Fake items on their side (0-10, default 3)",
			Optional = true,
			Default = 3
		},
		{
			Type = "integer",
			Name = "yourRap",
			Description = "Fake RAP for your side (default 4048). Set this above/below theirRap to check the Receiving colour flip.",
			Optional = true,
			Default = 4048
		},
		{
			Type = "integer",
			Name = "theirRap",
			Description = "Fake RAP for their side (default 448)",
			Optional = true,
			Default = 448
		}
	}
}
