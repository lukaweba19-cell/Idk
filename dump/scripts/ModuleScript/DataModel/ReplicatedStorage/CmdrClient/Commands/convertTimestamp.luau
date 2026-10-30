-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "convertTimestamp",
	Description = "Convert a timestamp to a human-readable format.",
	Group = "DefaultUtil",
	Aliases = { "date" },
	Args = { {
		Type = "number",
		Name = "timestamp",
		Description = "A numerical representation of a specific moment in time.",
		Optional = true
	} },
	ClientRun = function(_, p2)
		local v3 = p2 or os.time()
		local dateText = os.date("%x", v3)
		local dateText2 = os.date("%X", v3)

		return (("%* %*"):format(dateText, dateText2))
	end
}
