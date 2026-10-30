-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "alias",
	Description = "Creates a new, single command out of a command and given arguments.",
	Group = "DefaultUtil",
	Aliases = {},
	Args = {
		{
			Type = "string",
			Name = "Alias name",
			Description = "The key or input type you'd like to bind the command to."
		},
		{
			Type = "string",
			Name = "Command string",
			Description = "The command text you want to run. Separate multiple commands with \"&&\". Accept arguments with $1, $2, $3, etc."
		}
	},
	ClientRun = function(p1, p2, p3)
		local registry = p1.Cmdr.Registry
		local v5 = p1.Cmdr.Util.MakeAliasCommand(p2, p3)

		registry:RegisterCommandObject(v5, true)

		return ("Created alias %q"):format(p2)
	end
}
