-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local u1 = nil

local function acquireRunnerThreadAndCallEventHandler(p1, ...)
	local v7 = u1

	u1 = nil
	p1(...)
	u1 = v7
end
local function runEventHandlerInFreeThread()
	while true do
		acquireRunnerThreadAndCallEventHandler(coroutine.yield())
	end
end

local t1: {[any]: any} = {}

t1.__index = t1

function t1.new(p2, p3)
	return (setmetatable({ _connected = true, _next = false, _signal = p2, _fn = p3 }, t1))
end
function t1.Disconnect(p4)
	p4._connected = false

	if p4 == p4._signal._handlerListHead then
		p4._signal._handlerListHead = p4._next

		return
	end

	local v11 = p4._signal._handlerListHead

	while v11 and p4 ~= v11._next do
		v11 = v11._next
	end

	if v11 then
		v11._next = p4._next
	end
end

t1.Destroy = t1.Disconnect
setmetatable(t1, {
	__index = function(_, p6)
		local v14 = ("Attempt to get Connection::%s (not a valid member)"):format((tostring(p6)))

		error(v14, 2)
	end,
	__newindex = function(_, p8, _)
		local v18 = ("Attempt to set Connection::%s (not a valid member)"):format((tostring(p8)))

		error(v18, 2)
	end
})

local module: {[any]: any} = {}

module.__index = module

function module.new()
	return (setmetatable({ _handlerListHead = false }, module))
end
function module.Connect(p10, p11)
	local v21 = t1.new(p10, p11)

	if p10._handlerListHead then
		v21._next = p10._handlerListHead
		p10._handlerListHead = v21

		return v21
	end

	p10._handlerListHead = v21

	return v21
end
function module.DisconnectAll(p12)
	p12._handlerListHead = false
end

module.Destroy = module.DisconnectAll

function module.Fire(p13, ...)
	local v24 = p13._handlerListHead

	while v24 do
		if v24._connected then
			if not u1 then
				u1 = coroutine.create(runEventHandlerInFreeThread)
				coroutine.resume(u1)
			end

			task.spawn(u1, v24._fn, ...)
		end

		v24 = v24._next
	end
end
function module.Wait(p14)
	local v26 = coroutine.running()
	local connection = nil

	connection = p14:Connect(function(...)
		connection:Disconnect()
		task.spawn(v26, ...)
	end)

	return coroutine.yield()
end
function module.Once(p15, p16)
	local connection = nil

	connection = p15:Connect(function(...)
		if connection._connected then
			connection:Disconnect()
		end

		p16(...)
	end)

	return connection
end

setmetatable(module, {
	__index = function(_, p18)
		local v33 = ("Attempt to get Signal::%s (not a valid member)"):format((tostring(p18)))

		error(v33, 2)
	end,
	__newindex = function(_, p20, _)
		local v37 = ("Attempt to set Signal::%s (not a valid member)"):format((tostring(p20)))

		error(v37, 2)
	end
})

return module
