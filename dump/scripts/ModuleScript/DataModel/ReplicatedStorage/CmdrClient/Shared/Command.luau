-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local players: Players = game:GetService("Players")
local argument = require(script.Parent.Argument)
local v4: boolean = runService:IsServer()
local module: {[any]: any} = {}

module.__index = module

function module.new(p1)
	local t2: {[any]: any} = {
		Response = nil,
		Dispatcher = p1.Dispatcher,
		Cmdr = p1.Dispatcher.Cmdr,
		Name = p1.CommandObject.Name,
		RawText = p1.Text,
		Object = p1.CommandObject,
		Group = p1.CommandObject.Group,
		State = {},
		Aliases = p1.CommandObject.Aliases,
		Alias = p1.Alias,
		Description = p1.CommandObject.Description,
		Executor = p1.Executor,
		ArgumentDefinitions = p1.CommandObject.Args,
		RawArguments = p1.Arguments,
		Arguments = {},
		Data = p1.Data
	}

	setmetatable(t2, module)

	return t2
end
function module.Parse(p2, p3)
	local u10: boolean = false

	for i, v in ipairs(p2.ArgumentDefinitions) do
		if type(v) == "function" then
			v = v(p2)

			if v == nil then
				break
			end
		end

		local u13: boolean = v.Default == nil and v.Optional ~= true

		if u13 and u10 then
			error(("Command %q: Required arguments cannot occur after optional arguments."):format(p2.Name))
		elseif not u13 then
			u10 = true
		end

		if p2.RawArguments[i] == nil and u13 and p3 ~= true then
			return false, ("Required argument #%d %s is missing."):format(i, v.Name)
		end

		if p2.RawArguments[i] or p3 then
			p2.Arguments[i] = argument.new(p2, v, p2.RawArguments[i] or "")
		end
	end

	return true
end
function module.Validate(p4, p5)
	p4._Validated = true

	local s1 = ""
	local u17: boolean = true

	for k, v in pairs(p4.Arguments) do
		local v20, v21 = v:Validate(p5)

		if not v20 then
			u17 = false
			s1 = ("%s; #%d %s: %s"):format(s1, k, v.Name, v21 or "error")
		end
	end

	return u17, s1:sub(3)
end
function module.GetLastArgument(p6)
	for i = #p6.Arguments, 1, -1 do
		if p6.Arguments[i].RawValue then
			return p6.Arguments[i]
		end
	end
end
function module.GatherArgumentValues(p7)
	local t3: {[any]: any} = {}

	for i = 1, #p7.ArgumentDefinitions do
		local v27 = p7.Arguments[i]

		if v27 then
			t3[i] = v27:GetValue()
		elseif type(p7.ArgumentDefinitions[i]) == "table" then
			t3[i] = p7.ArgumentDefinitions[i].Default
		end
	end

	return t3, #p7.ArgumentDefinitions
end
function module.Run(p8)
	if p8._Validated == nil then
		error("Must validate a command before running.")
	end

	local v29 = p8.Dispatcher:RunHooks("BeforeRun", p8)

	if v29 then
		return v29
	end

	if not v4 and p8.Object.Data and p8.Data == nil then
		local v30, v31 = p8:GatherArgumentValues()

		p8.Data = p8.Object.Data(p8, unpack(v30, 1, v31))
	end

	if not v4 and p8.Object.ClientRun then
		local v32, v33 = p8:GatherArgumentValues()

		p8.Response = p8.Object.ClientRun(p8, unpack(v32, 1, v33))
	end

	if p8.Response == nil then
		if p8.Object.Run then
			local v34, v35 = p8:GatherArgumentValues()

			p8.Response = p8.Object.Run(p8, unpack(v34, 1, v35))
		elseif v4 then
			if p8.Object.ClientRun then
				warn(p8.Name, "command fell back to the server because ClientRun returned nil, but there is no server implementation! Either return a string from ClientRun, or create a server implementation for this command.")
			else
				warn(p8.Name, "command has no implementation!")
			end

			p8.Response = "No implementation."
		else
			p8.Response = p8.Dispatcher:Send(p8.RawText, p8.Data)
		end
	end

	v29 = p8.Dispatcher:RunHooks("AfterRun", p8)

	if v29 then
		return v29
	end

	return p8.Response
end
function module.GetArgument(p9, p10)
	return p9.Arguments[p10]
end
function module.GetData(p11)
	if p11.Data then
		return p11.Data
	end

	if p11.Object.Data and not v4 then
		p11.Data = p11.Object.Data(p11)
	end

	return p11.Data
end
function module.SendEvent(p12, p13, p14, ...)
	local typeName: string = typeof(p13)

	assert(typeName == "Instance", "Argument #1 must be a Player")

	local v43 = p13:IsA("Player")

	assert(v43, "Argument #1 must be a Player")

	local typeName2: string = type(p14)

	assert(typeName2 == "string", "Argument #2 must be a string")

	if v4 then
		p12.Dispatcher.Cmdr.RemoteEvent:FireClient(p13, p14, ...)
	elseif p12.Dispatcher.Cmdr.Events[p14] then
		assert(p13 == players.LocalPlayer, "Event messages can only be sent to the local player on the client.")
		p12.Dispatcher.Cmdr.Events[p14](...)
	end
end
function module.BroadcastEvent(p15, ...)
	if not v4 then
		error("Can't broadcast event messages from the client.", 2)
	end

	p15.Dispatcher.Cmdr.RemoteEvent:FireAllClients(...)
end
function module.Reply(p16, ...)
	return p16:SendEvent(p16.Executor, "AddLine", ...)
end
function module.GetStore(p17, ...)
	return p17.Dispatcher.Cmdr.Registry:GetStore(...)
end
function module.HasImplementation(p18)
	if (not runService:IsClient() or not p18.Object.ClientRun) and not p18.Object.Run then
		return false
	end

	return true
end

return module
