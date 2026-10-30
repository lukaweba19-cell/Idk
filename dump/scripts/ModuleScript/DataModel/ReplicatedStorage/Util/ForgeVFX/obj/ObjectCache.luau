-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local v1 = require("../mod/utility")
local module: {[any]: any} = {}

module.__index = module

local function reconcile(p1, p2)
	for iterFirst, iterSecond in p2 do
		if p1[iterFirst] == nil then
			p1[iterFirst] = iterSecond
		end
	end

	return p1
end

local v4 = table.create(10000)
local v5 = table.create(10000)
local u6: boolean = false

local v7 = coroutine.create(function()
	while true do
		workspace:BulkMoveTo(v4, v5, Enum.BulkMoveMode.FireCFrameChanged)
		table.clear(v4)
		table.clear(v5)
		u6 = false
		coroutine.yield()
	end
end)

function module.new(p3, p4, p5)
	local object = setmetatable({}, module)

	object.ref = p3
	object.parent = p4
	object.amount = 0
	object.restore_amount = 0

	local t2 = p5 or {}

	for iterFirst, iterSecond in { size = 100, excess_lifetime = 30 }, nil, nil do
		if t2[iterFirst] == nil then
			t2[iterFirst] = iterSecond
		end
	end

	object.params = t2
	object.scope = { p3, p4 }
	object.unused = table.create(object.params.size)
	object.item_map = {}
	object.part_mode = p3:IsA("BasePart")

	for _ = 1, object.params.size do
		object:_add()
	end

	table.insert(object.scope, task.spawn(function()
		while true do
			if not task.wait(15) then
				break
			end

			if object.restore_amount > 0 then
				for _ = 1, object.restore_amount do
					object:_add()

					local v42 = object

					v42.restore_amount = v42.restore_amount - 1
				end
			end

			if not (object.amount <= object.params.size) then
				local n1: number = 0

				for i = 1, #object.unused do
					if object.amount <= object.params.size then
						break
					end

					local n2: number = i - n1
					local v46 = object.unused[n2]

					if v46.dependents == 0 and not (os.clock() - v46.added > object.params.excess_lifetime) then
						v46:destroy()
						table.remove(object.unused, n2)
						object.item_map[v46.key] = nil

						local v47 = object

						v47.amount = v47.amount - 1
						n1 += 1
					end
				end
			end
		end
	end))

	return object
end
function module._add(p6, p7, p8)
	local clone = p6.ref:Clone()

	clone.Archivable = false
	clone.Parent = p6.parent

	local v24 = os.clock()
	local u25: boolean = false

	p6.amount = p6.amount + 1

	local t3: {[any]: any} = {
		dependents = 1,
		key = p7,
		value = clone,
		added = v24,
		destroy = function(_)
			u25 = true
			clone:Destroy()
		end
	}

	clone.Destroying:Connect(function()
		if u25 then
			return
		end

		local v49 = table.find(p6.unused, t3)

		if v49 then
			table.remove(p6.unused, v49)
		end

		if t3.key then
			p6.item_map[t3.key] = nil
		end

		local v50 = p6

		v50.amount = v50.amount - 1
		v50 = p6
		v50.restore_amount = v50.restore_amount + 1
	end)

	if p7 then
		p6.item_map[p7] = t3
	end

	if not p8 then
		table.insert(p6.unused, t3)
	end

	return t3
end
function module.has(p10, p11)
	if p10.item_map[p11] then
		return true
	end

	return false
end
function module.peek(p12, p13)
	return p12.item_map[p13]
end
function module.get(p14, p15)
	if p14:has(p15) then
		local v33 = p14:peek(p15)

		if v33 then
			v33.dependents = v33.dependents + 1
		end

		return v33.value
	end

	local u34 = table.remove(p14.unused)

	if u34 then
		u34.key = p15
		u34.added = os.clock()
		p14.item_map[p15] = u34
	else
		u34 = p14:_add(p15, true)
	end

	if p14.part_mode then
		return (setmetatable({
			_getReal = function()
				return u34.value
			end
		}, {
			__newindex = function(_, p17, p18)
				if p17 == "CFrame" then
					table.insert(v4, u34.value)
					table.insert(v5, p18)

					if not u6 then
						u6 = true
						task.defer(v7)

						return
					end
				else
					u34.value[p17] = p18
				end
			end,
			__index = function(_, p20)
				local v56 = u34.value[p20]

				if typeof(v56) == "function" then
					return function(_, ...)
						return v56(u34.value, ...)
					end
				end

				return v56
			end
		}))
	end

	return u34.value
end
function module.free(p22, p23)
	local v37 = p22.item_map[p23]

	if not v37 then
		return
	end

	v37.dependents = math.max(v37.dependents - 1, 0)

	if v37.dependents == 0 then
		v37.added = os.clock()

		if p22.params.on_free then
			p22.params.on_free(v37)
		end

		table.insert(p22.unused, v37)
	end
end
function module.destroy(p24)
	v1.cleanupScope(p24.scope)

	for iterFirst, iterSecond in p24.item_map, nil, nil do
		iterSecond.value:Destroy()
	end

	table.clear(p24.unused)
	table.clear(p24.item_map)
end

return module
