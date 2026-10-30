-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local function parsePath(p1)
	local parts = string.split(p1, "/")

	for i = #parts, 1, -1 do
		if parts[i] == "" then
			table.remove(parts, i)
		end
	end

	return parts
end
local function isManifestResolved(p2, p3)
	local n1: number = 0

	for iterKey in pairs(p2) do
		n1 += 1
	end

	assert(p3 >= n1, n1)

	return n1 == p3
end
local function unbindNodeDescend(p4, p5)
	if p4.instance == nil then
		return
	end

	p4.instance = nil

	local connections = p4.connections

	if connections then
		for _, v in ipairs(connections) do
			v:Disconnect()
		end

		table.clear(connections)
	end

	if p5 and p4.alias then
		p5[p4.alias] = nil
	end

	local children = p4.children

	if children then
		for _, v in pairs(children) do
			unbindNodeDescend(v, p5)
		end
	end
end

local module: {[any]: any} = {}

module.__index = module

function module.new(p6, p7)
	local t2: {[any]: any} = {}
	local n1: number = 1

	for k, v in pairs(p6) do
		t2[k] = parsePath(v)
		n1 += 1
	end

	return (setmetatable({
		_boundFn = p7,
		_parsedManifest = t2,
		_manifestSizeTarget = n1,
		_dtorMap = {},
		_connections = {},
		_rootInstToRootNode = {},
		_rootInstToManifest = {}
	}, module))
end
function module._startBoundFn(p8, p9, p10)
	local _boundFn = p8._boundFn
	local _dtorMap = p8._dtorMap
	local v31 = _dtorMap[p9]

	if v31 then
		v31()
		_dtorMap[p9] = nil
	end

	v31 = _boundFn(p10)

	if v31 then
		_dtorMap[p9] = v31
	end
end
function module._stopBoundFn(p11, p12)
	local _dtorMap = p11._dtorMap
	local v35 = _dtorMap[p12]

	if v35 then
		v35()
		_dtorMap[p12] = nil
	end
end
function module.bindRoot(p13, p14)
	debug.profilebegin("AtomicBinding:BindRoot")

	local _parsedManifest = p13._parsedManifest
	local _rootInstToRootNode = p13._rootInstToRootNode
	local _rootInstToManifest = p13._rootInstToManifest
	local _manifestSizeTarget = p13._manifestSizeTarget

	assert(_rootInstToManifest[p14] == nil)

	local t3: {[any]: any} = {}

	_rootInstToManifest[p14] = t3
	debug.profilebegin("BuildTree")

	local t4: {[any]: any} = { alias = "root", instance = p14 }

	if next(_parsedManifest) then
		t4.children = {}
		t4.connections = {}
	end

	_rootInstToRootNode[p14] = t4

	for k, v in pairs(_parsedManifest) do
		local t5 = t4

		for i, iterValue in ipairs(v) do
			local t6 = t5.children[iterValue] or {}

			if i == #v then
				if t6.alias ~= nil then
					error("Multiple aliases assigned to one instance")
				end

				t6.alias = k
			else
				t6.children = t6.children or {}
				t6.connections = t6.connections or {}
			end

			t5.children[iterValue] = t6
			t5 = t6
		end
	end

	debug.profileend()

	local function processNode(p15)
		local v67 = assert(p15.instance)
		local children = p15.children
		local alias = p15.alias
		local u70: boolean = not children

		if alias then
			t3[alias] = v67
		end

		if not u70 then
			for _, v in ipairs(v67:GetChildren()) do
				local v73 = children[v.Name]

				if v73 and v73.instance == nil then
					v73.instance = v
					processNode(v73)
				end
			end

			table.insert(p15.connections, v67.ChildAdded:Connect(function(p16)
				local v78 = children[p16.Name]

				if v78 and v78.instance == nil then
					v78.instance = p16
					processNode(v78)

					return
				end
			end))
			table.insert(p15.connections, v67.ChildRemoved:Connect(function(p17)
				local v80 = p17.Name
				local v81 = children[v80]

				if not v81 then
					return
				end

				if p17 ~= v81.instance then
					return
				end

				p13:_stopBoundFn(p14)
				unbindNodeDescend(v81, t3)
				assert(v81.instance == nil)

				local foundChild = v67:FindFirstChild(v80)
				local v83 = foundChild and children[foundChild.Name]

				if not v83 then
				elseif v83.instance == nil then
					v83.instance = foundChild
					processNode(v83)

					return
				end
			end))
		end

		if u70 then
			local v74 = _manifestSizeTarget
			local n1: number = 0

			for iterKey in pairs(t3) do
				n1 += 1
			end

			assert(v74 >= n1, n1)

			if n1 == v74 then
				p13:_startBoundFn(p14, t3)
			end
		end
	end

	debug.profilebegin("ResolveTree")
	processNode(t4)
	debug.profileend()
	debug.profileend()
end
function module.unbindRoot(p18, p19)
	local _rootInstToRootNode = p18._rootInstToRootNode
	local _rootInstToManifest = p18._rootInstToManifest

	p18:_stopBoundFn(p19)

	local v55 = _rootInstToRootNode[p19]

	if v55 then
		local v56 = assert(_rootInstToManifest[p19])

		unbindNodeDescend(v55, v56)
		_rootInstToRootNode[p19] = nil
	end

	_rootInstToManifest[p19] = nil
end
function module.destroy(p20)
	debug.profilebegin("AtomicBinding:destroy")

	for _, v in pairs(p20._dtorMap) do
		v:destroy()
	end

	table.clear(p20._dtorMap)

	for _, v in ipairs(p20._connections) do
		v:Disconnect()
	end

	table.clear(p20._connections)

	local _rootInstToManifest = p20._rootInstToManifest

	for k, v in pairs(p20._rootInstToRootNode) do
		local v65 = assert(_rootInstToManifest[k])

		unbindNodeDescend(v, v65)
	end

	table.clear(p20._rootInstToManifest)
	table.clear(p20._rootInstToRootNode)
	debug.profileend()
end

return module
