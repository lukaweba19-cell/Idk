-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local userInputService: UserInputService = game:GetService("UserInputService")

return {
	Name = "bind",
	Description = "Binds a command string to a key or mouse input.",
	Group = "DefaultUtil",
	Aliases = {},
	Args = {
		{
			Type = "userInput ! bindableResource @ player",
			Name = "Input",
			Description = "The key or input type you'd like to bind the command to."
		},
		{
			Type = "command",
			Name = "Command",
			Description = "The command you want to run on this input"
		},
		{
			Type = "string",
			Name = "Arguments",
			Description = "The arguments for the command",
			Default = ""
		}
	},
	ClientRun = function(p1, p2, p3, p4)
		local v6 = p1:GetStore("CMDR_Binds")
		local s1: string = p3 .. " " .. p4

		if v6[p2] then
			v6[p2]:Disconnect()
		end

		local v8 = p1:GetArgument(1).Type.Name

		if v8 == "userInput" then
			v6[p2] = userInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
				if gameProcessedEvent then
				elseif input.UserInputType == p2 or input.KeyCode == p2 then
					p1:Reply(p1.Dispatcher:EvaluateAndRun(p1.Cmdr.Util.RunEmbeddedCommands(p1.Dispatcher, s1)))
				end
			end)
		else
			if v8 == "bindableResource" then
				return "Unimplemented..."
			end

			if v8 == "player" then
				v6[p2] = p2.Chatted:Connect(function(p7)
					local v12 = p1.Cmdr.Util.RunEmbeddedCommands(p1.Dispatcher, p1.Cmdr.Util.SubstituteArgs(s1, { p7 }))
					local v13 = ("%s $ %s : %s"):format(p2.Name, v12, p1.Dispatcher:EvaluateAndRun(v12))

					p1:Reply(v13, Color3.fromRGB(244, 92, 66))
				end)
			end
		end

		return "Bound command to input."
	end
}
