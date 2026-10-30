-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "json-array-decode",
	Description = "Decodes a JSON Array into a comma-separated list",
	Group = "DefaultUtil",
	Aliases = {},
	Args = { { Type = "json", Name = "JSON", Description = "The JSON array." } },
	ClientRun = function(_, p2: {[any]: any})
		if type(p2) ~= "table" then
			p2 = { p2 }
		end

		return table.concat(p2, ",")
	end
}
