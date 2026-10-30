-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Shared.Types.Signal)

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
	local v19 = table.concat({ debug.info(2, "sln") }, " ")

	return (setmetatable({ _handlerListHead = false, src = v19 }, module))
end
function module.Connect(p10, p11)
	local v22 = t1.new(p10, p11)

	if p10._handlerListHead then
		v22._next = p10._handlerListHead
		p10._handlerListHead = v22

		return v22
	end

	p10._handlerListHead = v22

	return v22
end
function module.DisconnectAll(p12)
	p12._handlerListHead = false
end

module.Destroy = module.DisconnectAll

function module.Fire(p13, ...)
	local v25 = p13._handlerListHead

	while v25 do
		if v25._connected then
			if not u1 then
				u1 = coroutine.create(runEventHandlerInFreeThread)
				coroutine.resume(u1)
			end

			task.spawn(u1, v25._fn, ...)

			if not p13._handlerListHead then
				break
			end
		end

		v25 = v25._next
	end
end
function module.Wait(p14)
	local v27 = coroutine.running()
	local connection = nil

	connection = p14:Connect(function(...)
		connection:Disconnect()
		task.spawn(v27, ...)
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

return module
