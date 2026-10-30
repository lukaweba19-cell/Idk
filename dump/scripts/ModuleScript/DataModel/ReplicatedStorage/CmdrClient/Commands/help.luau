-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Name = "help",
	Description = "Displays a list of all commands, or inspects one command.",
	Group = "Help",
	Args = { {
		Type = "command",
		Name = "Command",
		Description = "The command to view information on",
		Optional = true
	} },
	ClientRun = function(p1, p2)
		if p2 then
			local v3 = p1.Cmdr.Registry:GetCommand(p2)
			local v4 = ("Command: %*"):format(v3.Name)

			p1:Reply(v4, Color3.fromRGB(230, 126, 34))

			if v3.Aliases and #v3.Aliases > 0 then
				local v5 = ("Aliases: %*"):format((table.concat(v3.Aliases, ", ")))

				p1:Reply(v5, Color3.fromRGB(230, 230, 230))
			end

			p1:Reply(v3.Description, Color3.fromRGB(230, 230, 230))

			for i, v in ipairs(v3.Args) do
				local v8 = ("#%* %*%*: %* - %*"):format(i, v.Name, if v.Optional == true then "?" else "", v.Type, v.Description)

				p1:Reply(v8)
			end
		else
			p1:Reply("Argument Shorthands\n-------------------\n.   Me/Self\n*   All/Everyone\n**  Others\n?   Random\n?N  List of N random values\n")
			p1:Reply("Tips\n----\n• Utilize the Tab key to automatically complete commands\n• Easily select and copy command output\n")

			local v9 = p1.Cmdr.Registry:GetCommands()

			table.sort(v9, function(p3, p4)
				if p3.Group and p4.Group then
					return p3.Group < p4.Group
				end

				return p3.Group
			end)

			local Group = nil

			for _, v in ipairs(v9) do
				v.Group = v.Group or "No Group"

				if Group ~= v.Group then
					local vGroup = v.Group
					local v14 = string.rep("-", #v.Group)
					local v15 = ("\n%*\n%*"):format(vGroup, v14)

					p1:Reply(v15)
					Group = v.Group
				end

				local v16 = if v.Description then ("%* - %*"):format(v.Name, v.Description) else v.Name

				p1:Reply(v16)
			end
		end

		return ""
	end
}
