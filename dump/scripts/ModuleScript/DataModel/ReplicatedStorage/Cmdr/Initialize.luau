-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local starterGui: StarterGui = game:GetService("StarterGui")
local createGui = require(script.Parent.CreateGui)

return function(p1)
	local CmdrClient = nil

	local function Create(className, name, p4)
		local v14 = Instance.new(className)

		v14.Name = name
		v14.Parent = p4 or CmdrClient

		return v14
	end

	CmdrClient = script.Parent.CmdrClient
	CmdrClient.Parent = replicatedStorage

	local cmdrFunction: RemoteFunction = Instance.new("RemoteFunction")

	cmdrFunction.Name = "CmdrFunction"
	cmdrFunction.Parent = CmdrClient

	local cmdrEvent: RemoteEvent = Instance.new("RemoteEvent")

	cmdrEvent.Name = "CmdrEvent"
	cmdrEvent.Parent = CmdrClient

	local commands: Folder = Instance.new("Folder")

	commands.Name = "Commands"
	commands.Parent = CmdrClient

	local types: Folder = Instance.new("Folder")

	types.Name = "Types"
	types.Parent = CmdrClient
	script.Parent.Shared.Parent = CmdrClient
	p1.ReplicatedRoot = CmdrClient
	p1.RemoteFunction = cmdrFunction
	p1.RemoteEvent = cmdrEvent
	p1:RegisterTypesIn(script.Parent.BuiltInTypes)
	script.Parent.BuiltInTypes:Destroy()
	script.Parent.BuiltInCommands.Name = "Server commands"

	if starterGui:FindFirstChild("Cmdr") == nil then
		createGui()
	end
end
