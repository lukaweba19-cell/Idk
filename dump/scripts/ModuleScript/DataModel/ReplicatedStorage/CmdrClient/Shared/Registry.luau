-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local util = require(script.Parent.Util)
local v3 = util.MakeDictionary({
	"Transform",
	"Validate",
	"Autocomplete",
	"Parse",
	"DisplayName",
	"Listable",
	"ValidateOnce",
	"Prefixes",
	"Default",
	"ArgumentOperatorAliases"
})
local v4 = util.MakeDictionary({
	"Name",
	"Aliases",
	"AutoExec",
	"Description",
	"Args",
	"Run",
	"ClientRun",
	"Data",
	"Group"
})
local v5 = util.MakeDictionary({ "Name", "Type", "Description", "Optional", "Default" })

local object = setmetatable({}, {
	__index = function(p1, p2)
		p1[p2] = {}

		return p1[p2]
	end
})

local t1: {[any]: any} = {
	Cmdr = nil,
	TypeMethods = v3,
	CommandMethods = v4,
	CommandArgProps = v5,
	Types = {},
	TypeAliases = {},
	Commands = {},
	CommandsArray = {},
	Hooks = {
		BeforeRun = {},
		AfterRun = {}
	},
	Stores = object,
	AutoExecBuffer = {},
	RegisterType = function(p3, name, p5)
		if not name or typeof(name) ~= "string" then
			error("Invalid type name provided: nil")
		end

		if not name:find("^[%d%l]%w*$") then
			error(("Invalid type name provided: \"%s\", type names must be alphanumeric and start with a lower-case letter or a digit."):format(name))
		end

		for iterKey in pairs(p5) do
			if p3.TypeMethods[iterKey] == nil then
				error("Unknown key/method in type \"" .. name .. "\": " .. iterKey)
			end
		end

		if p3.Types[name] ~= nil then
			error(("Type \"%s\" has already been registered."):format(name))
		end

		p5.Name = name
		p5.DisplayName = p5.DisplayName or name
		p3.Types[name] = p5

		if p5.Prefixes then
			p3:RegisterTypePrefix(name, p5.Prefixes)
		end
	end,
	RegisterTypePrefix = function(p6, p7, p8)
		if not p6.TypeAliases[p7] then
			p6.TypeAliases[p7] = p7
		end

		p6.TypeAliases[p7] = ("%s %s"):format(p6.TypeAliases[p7], p8)
	end,
	RegisterTypeAlias = function(p9, p10, p11)
		assert(p9.TypeAliases[p10] == nil, ("Type alias %s already exists!"):format(p11))
		p9.TypeAliases[p10] = p11
	end,
	RegisterTypesIn = function(p12, p13)
		for _, v in pairs(p13:GetChildren()) do
			if v:IsA("ModuleScript") then
				v.Parent = p12.Cmdr.ReplicatedRoot.Types
				require(v)(p12)
			else
				p12:RegisterTypesIn(v)
			end
		end
	end
}

t1.RegisterHooksIn = t1.RegisterTypesIn

function t1.RegisterCommandObject(p14, p15, _)
	for iterKey in pairs(p15) do
		if p14.CommandMethods[iterKey] == nil then
			error("Unknown key/method in command " .. (p15.Name or "unknown command") .. ": " .. iterKey)
		end
	end

	if p15.Args then
		for k, v in pairs(p15.Args) do
			if type(v) == "table" then
				for iterKey2 in pairs(v) do
					if p14.CommandArgProps[iterKey2] == nil then
						error(("Unknown property in command \"%s\" argument #%d: %s"):format(p15.Name or "unknown", k, iterKey2))
					end
				end
			end
		end
	end

	if p15.AutoExec and runService:IsClient() then
		table.insert(p14.AutoExecBuffer, p15.AutoExec)
		p14:FlushAutoExecBufferDeferred()
	end

	local commands = p14.Commands
	local lowerText = p15.Name:lower()
	local v33 = commands[lowerText]

	if v33 and v33.Aliases then
		for _, v in pairs(v33.Aliases) do
			local v36 = p14.Commands
			local lowerText2 = v:lower()

			v36[lowerText2] = nil
		end
	elseif not v33 then
		table.insert(p14.CommandsArray, p15)
	end

	local v38 = p14.Commands
	local lowerText3 = p15.Name:lower()

	v38[lowerText3] = p15

	if p15.Aliases then
		for _, v in pairs(p15.Aliases) do
			local v42 = p14.Commands
			local lowerText4 = v:lower()

			v42[lowerText4] = p15
		end
	end
end
function t1.RegisterCommand(p17, p18, p19, p20)
	local v48 = require(p18)
	local typeName: string = typeof(v48)
	local v50 = p18.Name
	local typeName2: string = typeof(v48)
	local v52 = ("Invalid return value from command script \"%*\" (CommandDefinition expected, got %*)"):format(v50, typeName2)

	assert(typeName == "table", v52)

	if p19 then
		local v53: boolean = runService:IsServer()

		assert(v53, "The commandServerScript parameter is not valid for client usage.")
		v48.Run = require(p19)
	end

	if p20 and not p20(v48) then
		return
	end

	p17:RegisterCommandObject(v48)
	p18.Parent = p17.Cmdr.ReplicatedRoot.Commands
end
function t1.RegisterCommandsIn(p21, p22, p23)
	local t2: {[any]: any} = {}
	local t3: {[any]: any} = {}

	for _, v in pairs(p22:GetChildren()) do
		if not v:IsA("ModuleScript") then
			p21:RegisterCommandsIn(v, p23)
		elseif not v.Name:find("Server") then
			local foundChild = p22:FindFirstChild(v.Name .. "Server")

			if foundChild then
				t3[foundChild] = true
			end

			p21:RegisterCommand(v, foundChild, p23)
		else
			t2[v] = true
		end
	end

	for iterKey in pairs(t2) do
		if not t3[iterKey] then
			warn("Command script " .. iterKey.Name .. " was skipped because it has 'Server' in its name, and has no equivalent shared script.")
		end
	end
end
function t1.RegisterDefaultCommands(p24, p25)
	local v65: boolean = runService:IsServer()

	assert(v65, "RegisterDefaultCommands cannot be called from the client.")

	local u66: boolean = type(p25) == "table"

	if u66 then
		p25 = util.MakeDictionary(p25)
	end

	p24:RegisterCommandsIn(p24.Cmdr.DefaultCommandsFolder, if u66 then function(p26)
		return p25[p26.Group] or false
	end else p25)
end
function t1.GetCommand(p27, p28)
	local commands = p27.Commands
	local lowerText = (p28 or ""):lower()

	return commands[lowerText]
end
function t1.GetCommands(p29)
	return p29.CommandsArray
end
function t1.GetCommandNames(p30)
	local t4: {[any]: any} = {}

	for _, v in pairs(p30.CommandsArray) do
		table.insert(t4, v.Name)
	end

	return t4
end

t1.GetCommandsAsStrings = t1.GetCommandNames

function t1.GetTypeNames(p31)
	local t5: {[any]: any} = {}

	for iterKey in pairs(p31.Types) do
		table.insert(t5, iterKey)
	end

	return t5
end
function t1.GetType(p32, p33)
	return p32.Types[p33]
end
function t1.GetTypeName(p34, p35)
	return p34.TypeAliases[p35] or p35
end
function t1.RegisterHook(p36, p37, p38, p39)
	if not p36.Hooks[p37] then
		local v87 = ("Invalid hook name: %q"):format(p37)

		error(v87, 2)
	end

	table.insert(p36.Hooks[p37], { callback = p38, priority = p39 or 0 })
	table.sort(p36.Hooks[p37], function(p40, p41)
		return p40.priority < p41.priority
	end)
end

t1.AddHook = t1.RegisterHook

function t1.GetStore(p42, p43)
	return p42.Stores[p43]
end
function t1.FlushAutoExecBufferDeferred(p44)
	if p44.AutoExecFlushConnection then
		return
	end

	p44.AutoExecFlushConnection = runService.Heartbeat:Connect(function()
		p44.AutoExecFlushConnection:Disconnect()
		p44.AutoExecFlushConnection = nil
		p44:FlushAutoExecBuffer()
	end)
end
function t1.FlushAutoExecBuffer(p45)
	for _, v in ipairs(p45.AutoExecBuffer) do
		for _, iterValue in ipairs(v) do
			p45.Cmdr.Dispatcher:EvaluateAndRun(iterValue)
		end
	end

	p45.AutoExecBuffer = {}
end

return function(cmdr)
	t1.Cmdr = cmdr

	return t1
end
