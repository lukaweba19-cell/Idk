-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
--!native
function doTask(p1)
	local ok, result = pcall(function()
		if type(p1) == "function" then
			p1()
		elseif typeof(p1) == "RBXScriptConnection" then
			p1:Disconnect()
		elseif typeof(p1) == "Instance" then
			p1:Destroy()
		elseif typeof(p1) == "thread" then
			pcall(task.cancel, p1)
		elseif typeof(p1) ~= "table" then
		elseif p1.Destroy then
			p1.Destroy(p1)
		elseif p1.destroy then
			p1.destroy(p1)
		end
	end)

	if not ok then
		local v5 = debug.traceback(result)

		warn(v5, 2)
	end
end

local t1: {[any]: any} = { ClassName = "Maid" }

function t1.new()
	return (setmetatable({
		_tasks = {}
	}, t1))
end
function t1.isMaid(p2)
	if typeof(p2) == "table" then
		return p2.ClassName == "Maid"
	end

	return false
end
function t1.__index(p3, p4)
	if t1[p4] then
		return t1[p4]
	end

	return p3._tasks[p4]
end
function t1.__newindex(p5, p6, p7)
	if t1[p6] ~= nil then
		local v12 = ("'%s' is reserved"):format((tostring(p6)))

		error(v12, 2)
	end

	if p6 == "_hack" then
		rawset(p5, p6, p7)
	end

	local _tasks = p5._tasks
	local v14 = _tasks[p6]

	if p7 == v14 then
		return
	end

	_tasks[p6] = p7

	if v14 then
		doTask(v14)
	end
end
function t1.GiveTask(p8, p9)
	if not p9 then
		return p9
	end

	if type(p9) == "table" and not p9.Destroy and not p9.destroy then
		return p9
	end

	local n1: number = #p8._tasks + 1

	p8[n1] = p9

	return p9, n1
end

t1.Add = t1.GiveTask

function t1.array(...)
	local t2: {[any]: any} = { ... }

	return function()
		for _, v in ipairs(t2) do
			if v then
				doTask(v)
			end
		end
	end
end
function t1.delayedCleanup(p10, p11)
	local u21: boolean = false

	local function delayedTask()
		if u21 then
			return
		end

		u21 = true
		doTask(p11)
	end

	local array = t1.array
	local v24 = task.delay(p10, delayedTask)

	return array(v24, delayedTask)
end
function t1.GivePromise(p12, p13)
	if not p13:IsPending() then
		return p13
	end

	local v27 = p13.resolved(p13)
	local v28, v29 = p12:GiveTask(v27)

	v27:Finally(function()
		p12[v29] = nil
	end)

	return v27
end
function t1.DoCleaning(p14)
	local _tasks = p14._tasks

	for k, v in pairs(_tasks) do
		if typeof(v) == "RBXScriptConnection" then
			_tasks[k] = nil
			v:Disconnect()
		elseif typeof(v) == "thread" then
			_tasks[k] = nil
			pcall(task.cancel, v)
		end
	end

	local v34, v35 = next(_tasks)

	while v35 ~= nil do
		_tasks[v34] = nil
		doTask(v35)

		local v36, v37 = next(_tasks)

		v34 = v36
		v35 = v37
	end
end

t1.Destroy = t1.DoCleaning

return { new = t1.new, isMaid = t1.isMaid }
