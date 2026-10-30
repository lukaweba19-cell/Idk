-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local effectReload = require(script:WaitForChild("EffectReload"))
local util = game.ReplicatedStorage:WaitForChild("Util")
local encodeObj = require(util:WaitForChild("EncodeObj"))
local shared = game.ReplicatedStorage:WaitForChild("Shared")
local playerState = require(shared:WaitForChild("PlayerState"))
local effect: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Effect")
local v7: boolean = game:GetService("RunService"):IsClient()

local function DeepCopyTable(p1)
	local t2: {[any]: any} = {}

	for k, v in pairs(p1) do
		if type(v) == "table" then
			t2[k] = DeepCopyTable(v)
		else
			t2[k] = v
		end
	end

	return t2
end
local function FindFirstAncestorSatisfying(p2, p3)
	assert(p3, "A predicate function is required")

	local v26 = p2.Parent

	while v26 do
		if v26 == workspace or v26.Parent == game then
			return nil
		end

		if p3(v26) then
			return v26
		end

		v26 = v26.Parent
	end

	return nil
end
local function FindToolCallerFromStack(p4)
	local t3: {[any]: any} = {}
	local v29 = p4 or 3

	while true do
		local v30 = debug.info(v29, "f")

		if v30 == nil or v29 > 200 then
			break
		end

		if type(v30) == "function" then
			local v31 = getfenv(v30)
			local script = v31 and v31.script

			if typeof(script) == "Instance" and script:IsA("LuaSourceContainer") and not t3[script] then
				local scriptParent = script.Parent

				if scriptParent and scriptParent:IsA("Tool") then
					return script, scriptParent
				end

				t3[script] = true
			end
		end

		v29 += 1
	end

	return nil, nil
end
local function GetCaller()
	if game:GetService("RunService"):IsClient() then
		return
	end

	local v34, v35 = FindToolCallerFromStack(4)

	local v36 = v34 and FindFirstAncestorSatisfying(v34, function(p5)
		return p5.Parent ~= nil and p5.Parent == workspace:WaitForChild("Characters")
	end)

	local v37 = v36 and game:GetService("Players"):GetPlayerFromCharacter(v36)

	if v37 then
		return v37
	end
end
local function getLocation(p6)
	local foundChild = nil

	for iterValue in string.gmatch(p6, "([^.]+)") do
		foundChild = (foundChild or script.Container):FindFirstChild(iterValue)
	end

	return foundChild
end
function createStreamedObjects(p7)
	for k, v in pairs(p7) do
		if typeof(v) == "table" then
			createStreamedObjects(v)
		elseif typeof(v) == "Instance" then
			p7[k] = encodeObj(v)
		end
	end
end

local module: {[any]: any} = {}

module.__index = module

function module.new(name, p9)
	local v46 = getLocation(name)

	assert(v46, "Effect not found!: " .. name)

	local randomNumber = math.random(99999999)
	local v48 = GetCaller()

	return (setmetatable({
		Name = name,
		Module = v46,
		Id = randomNumber,
		Async = p9,
		Sender = v48
	}, { __index = module }))
end
function module.find(p10)
	return (getLocation(p10))
end
function module.preload(p11)
	local v51 = getLocation(p11)

	assert(v51, "Effect not found!: " .. p11)
end
local function recipientsExcept(p12)
	local t4: {[any]: any} = {}

	for _, v in pairs(game.Players:GetPlayers()) do
		if v ~= p12 then
			table.insert(t4, v)
		end
	end

	return t4
end
function module.replicateExcept(p13, p14, p15)
	p13:replicate(p14, recipientsExcept(p15))
end
function module.playExcept(p16, p17, p18)
	p16:play(p17, recipientsExcept(p18))
end

local u15 = nil

local function __replayCapture(p19, p20)
	if v7 then
		return
	end

	pcall(function()
		if u15 == nil then
			local replayRecorder: Instance = game:GetService("ServerStorage"):FindFirstChild("ReplayRecorder")

			u15 = replayRecorder and require(replayRecorder) or false
		end

		if u15 then
			u15.CaptureBroadcast("Effect", p20, { p19, p20 })
		end
	end)
end
local function __replicate(p21, p22, p23, p24)
	if v7 and p24 == nil then
		if playerState.InLobby() then
			return
		end

		if p22.Async then
			if typeof(effectReload.getEffectImpl(p22.Module)) == "function" then
				effectReload.getEffectImpl(p22.Module)(p23, p22)

				return
			end

			effectReload.getEffectImpl(p22.Module).new(p23):Run()

			return
		end

		script.Bindable:Fire("spawn", p22.Module, p23, p22)

		return
	end

	local v68: number = workspace:GetServerTimeNow()

	if p22.Module:FindFirstChild("Server") then
		task.spawn(function()
			require(p22.Module.Server)(p23, p22)
		end)
	end

	local typeName: string = typeof(p23)
	local u70

	if typeName == "table" then
		u70 = DeepCopyTable(p23)

		if not v7 then
			createStreamedObjects(u70)
		end
	else
		u70 = p23
	end

	__replayCapture(p22, p23)

	if p24 == nil then
		p21(function()
			effect:FireAllClients(v68, p22, u70)
		end)
	elseif typeof(p24) == "table" then
		p21(function()
			local n1: number = 0

			for _, v in pairs(p24) do
				effect:FireClient(v, v68, p22, u70)
				n1 += 1
			end
		end)
	elseif p24.ClassName == "Player" then
		p21(function()
			effect:FireClient(p24, v68, p22, u70)
		end)
	end
end
function module.replicate(p25, p26, p27)
	__replicate(task.spawn, p25, p26, p27)
end
function module.play(p28, p29, p30)
	__replicate(task.spawn, p28, p29, p30)
end
function getStreamedObjects(p31, p32)
	local u79: boolean = false

	for k, v in pairs(p31) do
		if typeof(v) == "table" and v[3] == "__StreamedObject" then
			p31[k] = encodeObj(v)

			if p31[k] == nil then
				u79 = true
				table.insert(p32, k)
			end
		elseif typeof(v) == "table" and getStreamedObjects(v, p32) == false then
			u79 = true
		end
	end

	return u79 == false
end

for _, v in pairs(script:GetDescendants()) do
	if v:IsA("ModuleScript") and v:GetAttribute("Preload") then
		task.spawn(require, v)
	end
end

if v7 then
	task.spawn(function()
		local t5 = {}

		local v83 = effect.OnClientEvent:connect(function(p33, p34, p35)
			table.insert(t5, { et = p33, obj = p34, data = p35 })
		end)

		while not _G.PersistentLoaded do
			task.wait()
		end

		v83:Disconnect()

		local function v84(p36, p37, p38)
			if playerState.InLobby() then
				return
			end

			local module = p37.Module

			assert(module, "Effect not found! " .. p37.Name)

			local timestamp = tick()
			local t6: {[any]: any} = {}
			local u102: boolean = false

			if typeof(p38) == "table" then
				if p38[3] == "__StreamedObject" then
					p38 = encodeObj(p38)

					if p38 == nil then
						u102 = true
					end
				elseif getStreamedObjects(p38, t6) == false then
					u102 = true
				end
			end

			if tick() - timestamp > 2.5 and _G.TestGame then
				print("Long Effect decoding time:", module:GetFullName())
			end

			if u102 then
				local v103 = module:GetFullName()
				local v104 = table.concat(t6, ", ")

				print("Didn't run effect ", v103, "because parameter(s) failed to replicate: " .. v104)

				return
			end

			local n1 = workspace:GetServerTimeNow() - p36

			if n1 > 10 and not module:FindFirstChild("IgnoreTimeout") and not module:GetAttribute("IgnoreTimeout") then
				print("Didn't run effect", p37.Name, "because it took", n1, "to reach the client.")

				return
			end

			if typeof(p37) == "table" and typeof(p37.Name) == "string" and string.find(p37.Name, "KillEffects", 1, true) and game:GetService("SoundService"):GetAttribute("DisableFinishers") == true then
				local u106: boolean = false

				if typeof(p38) == "table" and typeof(p38.Character) == "Instance" and p38.Character:IsA("Model") and typeof((p38.Character:GetAttribute("KillerUserId"))) == "number" and p38.Character:GetAttribute("KillerUserId") == game:GetService("Players").LocalPlayer.UserId then
					u106 = true
				end

				if not u106 then
					return
				end

				script.Bindable:Fire("spawn", module, p38, p37)

				return
			end

			script.Bindable:Fire("spawn", module, p38, p37)
		end

		effect.OnClientEvent:connect(v84)

		function module.__ReplayInvoke(p39, p40)
			if not p39 then
				return
			end

			local v109: number = workspace:GetServerTimeNow()

			v84(v109, p39, p40)
		end

		while #t5 > 0 do
			local v85 = table.remove(t5, 1)

			if v85 then
				local ok, result = pcall(function()
					local v110 = v85.obj and v85.obj.Module

					if v110 then
						if not v110:GetAttribute("IgnoreTimeout") and not v110:FindFirstChild("IgnoreTimeout") then
							if workspace:GetServerTimeNow() - v85.et < 10 then
								v84(v85.et, v85.obj, v85.data)

								return
							end

							return
						end

						v84(v85.et, v85.obj, v85.data)

						return
					end
				end)

				if not ok then
					warn(result)
				end
			end

			task.wait()
		end

		t5 = nil
	end)
end

return module
