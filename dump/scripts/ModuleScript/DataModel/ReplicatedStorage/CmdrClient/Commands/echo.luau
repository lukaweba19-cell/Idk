-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "echo",
	Description = "Echoes your text back to you.",
	Group = "DefaultUtil",
	Aliases = { "=" },
	Args = { { Type = "string", Name = "Text", Description = "The text." } },
	Run = function(_, p2)
		return p2
	end
}
