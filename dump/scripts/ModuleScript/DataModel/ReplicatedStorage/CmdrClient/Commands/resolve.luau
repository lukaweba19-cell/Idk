-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "resolve",
	Description = "Resolves Argument Value Operators into lists. E.g., resolve players * gives you a list of all players.",
	Group = "DefaultUtil",
	Aliases = {},
	AutoExec = { "alias \"me|Displays your username\" resolve players ." },
	Args = {
		{
			Type = "type",
			Name = "Type",
			Description = "The type for which to resolve"
		},
		function(p1)
			if p1:GetArgument(1):Validate() == false then
				return
			end

			return {
				Name = "Argument Value Operator",
				Description = "The value operator to resolve. One of: * ** . ? ?N",
				Optional = true,
				Type = p1:GetArgument(1):GetValue()
			}
		end
	},
	Run = function(p2)
		local tableConcat = table.concat
		local v4 = p2:GetArgument(2)

		return tableConcat(v4.RawSegments, ",")
	end
}
