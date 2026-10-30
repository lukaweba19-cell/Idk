-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "len",
	Description = "Returns the length of a comma-separated list",
	Group = "DefaultUtil",
	Aliases = {},
	Args = { {
		Type = "string",
		Name = "CSV",
		Description = "The comma-separated list"
	} },
	Run = function(_, p2)
		return #p2:split(",")
	end
}
