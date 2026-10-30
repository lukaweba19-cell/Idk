-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "unbind",
	Description = "Unbinds an input previously bound with Bind",
	Group = "DefaultUtil",
	Aliases = {},
	Args = { {
		Type = "userInput ! bindableResource @ player",
		Name = "Input/Key",
		Description = "The key or input type you'd like to unbind."
	} },
	ClientRun = function(p1, p2)
		local v3 = p1:GetStore("CMDR_Binds")

		if v3[p2] then
			v3[p2]:Disconnect()
			v3[p2] = nil

			return "Unbound command from input."
		end

		return "That input wasn't bound."
	end
}
