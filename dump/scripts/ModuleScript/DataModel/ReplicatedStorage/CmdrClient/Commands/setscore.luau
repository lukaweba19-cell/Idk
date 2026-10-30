-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "setscore",
	Description = "Set the match scores (your side, their side).",
	Group = "Admin",
	Args = {
		{
			Type = "number",
			Name = "myScore",
			Description = "Score for your side."
		},
		{
			Type = "number",
			Name = "theirScore",
			Description = "Score for the other side."
		}
	}
}
