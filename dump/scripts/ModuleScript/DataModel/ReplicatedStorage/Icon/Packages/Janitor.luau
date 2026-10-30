-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local heartbeat = game:GetService("RunService").Heartbeat

local function getPromiseReference()
	return false
end

local v3 = newproxy(true)

getmetatable(v3).__tostring = function()
	return "IndicesReference"
end

local v4 = newproxy(true)

getmetatable(v4).__tostring = function()
	return "LinkToInstanceIndex"
end

local module: {[any]: any} = {
	IGNORE_MEMORY_DEBUG = true,
	ClassName = "Janitor",
	__index = { CurrentlyCleaning = true, [v3] = nil }
}

function module.new()
	return (setmetatable({ CurrentlyCleaning = false, [v3] = nil }, module))
end
function module.Is(p1)
	local u14: boolean = false

	if type(p1) == "table" then
		u14 = getmetatable(p1) == module
	end

	return u14
end

module.is = module.Is

local t2: {[any]: any} = {
	["function"] = true,
	Promise = "cancel",
	RBXScriptConnection = "Disconnect"
}

function module.__index.Add(p2, p3, p4, p5)
	if p5 then
		p2:Remove(p5)

		local t4 = p2[v3]

		if not t4 then
			t4 = {}
			p2[v3] = t4
		end

		t4[p5] = p3
	end

	local typeName: string = typeof(p3)

	if typeName == "table" and string.match(tostring(p3), "Promise") then
		typeName = "Promise"
	end

	local s1 = p4 or t2[typeName] or "Destroy"

	if type(p3) ~= "function" and not p3[s1] then
		local stringFormat = string.format
		local text: string = tostring(p3)
		local text2: string = tostring(s1)

		warn(stringFormat("Object %s doesn't have method %s, are you sure you want to add it? Traceback: %s", text, text2, debug.traceback(nil, 2)))
	end

	local v25 = debug.traceback("")

	p2[p3] = { s1, v25 }

	return p3
end

module.__index.Give = module.__index.Add

function module.__index.AddPromise(_, p7)
	return p7
end

module.__index.GivePromise = module.__index.AddPromise

function module.__index.AddObject(p11, p12)
	local v30 = newproxy(false)

	return p11:Add(p12, false, v30), v30
end

module.__index.GiveObject = module.__index.AddObject

function module.__index.Remove(p13, p14)
	local v33 = p13[v3]
	local v34 = v33 and v33[p14]

	if v34 then
		local v35 = p13[v34]
		local v36 = v35 and v35[1]

		if v36 then
			if v36 == true then
				v34()
			else
				local v37 = v34[v36]

				if v37 then
					v37(v34)
				end
			end

			p13[v34] = nil
		end

		v33[p14] = nil
	end

	return p13
end
function module.__index.Get(p15, p16)
	local v40 = p15[v3]

	if v40 then
		return v40[p16]
	end

	return nil
end
function module.__index.Cleanup(p17)
	if not p17.CurrentlyCleaning then
		p17.CurrentlyCleaning = nil

		for k, v in pairs(p17) do
			if k ~= v3 then
				local typeName: string = type(k)

				if typeName == "string" or typeName == "number" then
				else
					local v45 = v[1]
					local v46 = v[2]

					local function warnUser(p18)
						local v76 = debug.traceback("", 3)
						local v77 = v46
						local text: string = tostring(p18)

						warn("-------- Janitor Error --------" .. "\n" .. text .. "\n" .. v76 .. "" .. v77)
					end

					if v45 == true then
						local ok, result = pcall(k)

						if not ok then
							local v50 = debug.traceback("", 3)
							local text: string = tostring(result)

							warn("-------- Janitor Error --------" .. "\n" .. text .. "\n" .. v50 .. "" .. v46)
						end
					else
						local v52 = k[v45]

						if v52 then
							local ok, result = pcall(v52, k)
							local u55: boolean = false

							if typeof(k) == "Instance" then
								u55 = v52 == "Destroy"
							end

							if not ok and not u55 then
								local v56 = debug.traceback("", 3)
								local text: string = tostring(result)

								warn("-------- Janitor Error --------" .. "\n" .. text .. "\n" .. v56 .. "" .. v46)
							end
						end
					end
				end

				p17[k] = nil
			end
		end

		local v58 = p17[v3]

		if v58 then
			for iterKey in pairs(v58) do
				v58[iterKey] = nil
			end

			p17[v3] = {}
		end

		p17.CurrentlyCleaning = false
	end
end

module.__index.Clean = module.__index.Cleanup

function module.__index.Destroy(p19)
	p19:Cleanup()
end

module.__call = module.__index.Cleanup

local t3: {[any]: any} = { Connected = true }

t3.__index = t3

function t3.Disconnect(p20)
	if p20.Connected then
		p20.Connected = false
		p20.Connection:Disconnect()
	end
end
function t3.__tostring(p21)
	return "Disconnect<" .. tostring(p21.Connected) .. ">"
end
function module.__index.LinkToInstance(p22, p23, p24)
	local connection = nil
	local v67 = p24 and newproxy(false) or v4
	local u68: boolean = p23.Parent == nil
	local object = setmetatable({}, t3)

	connection = p23.AncestryChanged:Connect(function(_, p26)
		if object.Connected then
			u68 = p26 == nil

			if u68 then
				coroutine.wrap(function()
					heartbeat:Wait()

					if not object.Connected then
						return
					end

					if not connection.Connected then
						p22:Cleanup()

						return
					end

					while u68 and connection.Connected and object.Connected do
						heartbeat:Wait()
					end

					if object.Connected and u68 then
						p22:Cleanup()
					end
				end)()
			end
		end
	end)
	object.Connection = connection

	if u68 and object.Connected then
		u68 = p23.Parent == nil

		if u68 then
			coroutine.wrap(function()
				heartbeat:Wait()

				if not object.Connected then
					return
				end

				if not connection.Connected then
					p22:Cleanup()

					return
				end

				while u68 and connection.Connected and object.Connected do
					heartbeat:Wait()
				end

				if object.Connected and u68 then
					p22:Cleanup()
				end
			end)()
		end
	end

	return p22:Add(object, "Disconnect", v67)
end
function module.__index.LinkToInstances(p27, ...)
	local v71 = module.new()

	for _, v in ipairs({ ... }) do
		local v74 = p27:LinkToInstance(v, true)

		v71:Add(v74, "Disconnect")
	end

	return v71
end

for k, v in pairs(module.__index) do
	local lowerText = string.lower(k)
	local v11 = string.sub(lowerText, 1, 1)
	local v12 = string.sub(k, 2)

	module.__index[v11 .. v12] = v
end

return module
