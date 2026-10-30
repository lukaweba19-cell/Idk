-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "history",
	Description = "Displays previous commands from history.",
	Group = "DefaultUtil",
	Aliases = {},
	AutoExec = {
		"alias \"!|Displays previous command from history.\" run ${history $1{number|Line Number}}",
		"alias \"^|Runs the previous command, replacing all occurrences of A with B.\" run ${run replace ${history -1} $1{string|A} $2{string|B}}",
		"alias \"!!|Reruns the last command.\" ! -1"
	},
	Args = { {
		Type = "integer",
		Name = "Line Number",
		Description = "Command line number (can be negative to go from end)"
	} },
	ClientRun = function(p1, p2)
		local v3 = p1.Dispatcher:GetHistory()

		if p2 <= 0 then
			p2 = #v3 + p2
		end

		return v3[p2] or ""
	end
}
