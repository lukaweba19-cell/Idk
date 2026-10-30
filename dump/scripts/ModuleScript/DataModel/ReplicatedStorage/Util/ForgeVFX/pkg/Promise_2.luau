-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local t1: {[any]: any} = { __mode = "k" }

local function isCallable(p1)
	if type(p1) == "function" then
		return true
	end

	local v15 = type(p1) == "table" and getmetatable(p1)

	if v15 and type((rawget(v15, "__call"))) == "function" then
		return true
	end

	return false
end
local function makeEnum(p2, p3)
	local t4: {[any]: any} = {}

	for _, v in ipairs(p3) do
		t4[v] = v
	end

	return (setmetatable(t4, {
		__index = function(_, p5)
			local formattedText = string.format("%s is not in %s!", p5, p2)

			error(formattedText, 2)
		end,
		__newindex = function()
			local formattedText = string.format("Creating new members in %s is not allowed!", p2)

			error(formattedText, 2)
		end
	}))
end

local t2: {[any]: any} = {
	Kind = makeEnum("Promise.Error.Kind", {
		"ExecutionError",
		"AlreadyCancelled",
		"NotResolvedInTime",
		"TimedOut"
	})
}

t2.__index = t2

function t2.new(p6, p7)
	local t5 = p6 or {}
	local text: string = tostring(t5.error)
	local trace = t5.trace
	local context = t5.context
	local kind = t5.kind
	local v28 = os.clock()
	local v29 = debug.traceback()

	return (setmetatable({
		error = text or "[This error has no error text.]",
		trace = trace,
		context = context,
		kind = kind,
		parent = p7,
		createdTick = v28,
		createdTrace = v29
	}, t2))
end
function t2.is(p8)
	if type(p8) == "table" then
		local v31 = getmetatable(p8)

		if type(v31) == "table" then
			local u32: boolean = false

			if rawget(p8, "error") ~= nil then
				local v33 = rawget(v31, "extend")

				u32 = type(v33) == "function"
			end

			return u32
		end

		return false
	end

	return false
end
function t2.isKind(p9, p10)
	assert(p10 ~= nil, "Argument #2 to Promise.Error.isKind must not be nil")

	return t2.is(p9) and p10 == p9.kind
end
function t2.extend(p11, p12)
	local t6 = p12 or {}

	t6.kind = t6.kind or p11.kind

	return t2.new(t6, p11)
end
function t2.getErrorChain(p13)
	local t7: {[any]: any} = { p13 }

	while t7[#t7].parent do
		table.insert(t7, t7[#t7].parent)
	end

	return t7
end
function t2.__tostring(p14)
	local t8: {[any]: any} = { string.format("-- Promise.Error(%s) --", p14.kind or "?") }

	for _, v in ipairs(p14:getErrorChain()) do
		table.insert(t8, table.concat({ v.trace or v.error, v.context }, "\n"))
	end

	return table.concat(t8, "\n")
end
local function pack(...)
	return select("#", ...), { ... }
end
local function packResult(p15, ...)
	local v46 = select("#", ...)

	return p15, v46, { ... }
end
local function makeErrorHandler(p16)
	assert(p16 ~= nil, "traceback is nil")

	return function(p17)
		if type(p17) == "table" then
			return p17
		end

		local new = t2.new
		local executionError = t2.Kind.ExecutionError
		local debugTraceback = debug.traceback
		local text: string = tostring(p17)
		local v274 = debugTraceback(text, 2)

		return new({
			error = p17,
			kind = executionError,
			trace = v274,
			context = "Promise created at:\n\n" .. p16
		})
	end
end
local function runExecutor(p18, p19, ...)
	assert(p18 ~= nil, "traceback is nil")

	return packResult(xpcall(p19, function(p20)
		if type(p20) == "table" then
			return p20
		end

		local new = t2.new
		local executionError = t2.Kind.ExecutionError
		local debugTraceback = debug.traceback
		local text: string = tostring(p20)
		local v280 = debugTraceback(text, 2)

		return new({
			error = p20,
			kind = executionError,
			trace = v280,
			context = "Promise created at:\n\n" .. p18
		})
	end, ...))
end
local function createAdvancer(p21, p22, p23, p24)
	return function(...)
		local v281, v282, v283 = runExecutor(p21, p22, ...)

		if v281 then
			p23(unpack(v283, 1, v282))

			return
		end

		p24(v283[1])
	end
end
local function isEmpty(p25)
	return next(p25) == nil
end

local module: {[any]: any} = {
	Error = t2,
	Status = makeEnum("Promise.Status", { "Started", "Resolved", "Rejected", "Cancelled" }),
	_getTime = os.clock,
	_timeEvent = game:GetService("RunService").Heartbeat,
	_unhandledRejectionCallbacks = {},
	prototype = {}
}

module.__index = module.prototype

function module._new(p26, p27, p28)
	if p28 ~= nil and not module.is(p28) then
		error("Argument #2 to Promise.new must be a promise or nil", 2)
	end

	local started = module.Status.Started
	local object = setmetatable({}, t1)
	local t9: {[any]: any} = {
		_thread = nil,
		_values = nil,
		_valuesLength = -1,
		_unhandledRejection = true,
		_cancellationHook = nil,
		_source = p26,
		_status = started,
		_queuedResolve = {},
		_queuedReject = {},
		_queuedFinally = {},
		_parent = p28,
		_consumers = object
	}

	if p28 and p28._status == module.Status.Started then
		p28._consumers[t9] = true
	end

	setmetatable(t9, module)

	local function resolve(...)
		t9:_resolve(...)
	end
	local function reject(...)
		t9:_reject(...)
	end
	local function onCancel(p29)
		if p29 then
			if t9._status == module.Status.Cancelled then
				p29()
			else
				t9._cancellationHook = p29
			end
		end

		return t9._status == module.Status.Cancelled
	end

	t9._thread = coroutine.create(function()
		local v285, v286, v287 = runExecutor(t9._source, p27, resolve, reject, onCancel)

		if not v285 then
			reject(v287[1])
		end
	end)
	task.spawn(t9._thread)

	return t9
end
function module.new(p30)
	local _new = module._new
	local v66 = debug.traceback(nil, 2)

	return _new(v66, p30)
end
function module.__tostring(p31)
	return string.format("Promise(%s)", p31._status)
end
function module.defer(p32)
	local v69 = debug.traceback(nil, 2)

	return (module._new(v69, function(p33, p34, p35)
		task.defer(function()
			local v393, v394, v395 = runExecutor(v69, p32, p33, p34, p35)

			if not v393 then
				p34(v395[1])
			end
		end)
	end))
end

module.async = module.defer

function module.resolve(...)
	local v70, v71 = pack(...)
	local _new = module._new
	local v73 = debug.traceback(nil, 2)

	return _new(v73, function(p36)
		p36(unpack(v71, 1, v70))
	end)
end
function module.reject(...)
	local v74, v75 = pack(...)
	local _new = module._new
	local v77 = debug.traceback(nil, 2)

	return _new(v77, function(_, p38)
		p38(unpack(v75, 1, v74))
	end)
end
function module._try(p39, p40, ...)
	local v80, v81 = pack(...)

	return module._new(p39, function(p41)
		p41(p40(unpack(v81, 1, v80)))
	end)
end
function module.try(p42, ...)
	local _try = module._try
	local v84 = debug.traceback(nil, 2)

	return _try(v84, p42, ...)
end
function module._all(p43, p44, p45)
	if type(p44) ~= "table" then
		local formattedText = string.format("Please pass a list of promises to %s", "Promise.all")

		error(formattedText, 3)
	end

	for k, v in pairs(p44) do
		if not module.is(v) then
			local stringFormat = string.format
			local text: string = tostring(k)
			local v93 = stringFormat("Non-promise value passed into %s at index %s", "Promise.all", text)

			error(v93, 3)
		end
	end

	if #p44 == 0 or p45 == 0 then
		return module.resolve({})
	end

	return module._new(p43, function(p46, p47, p48)
		local t12: {[any]: any} = {}
		local t13: {[any]: any} = {}
		local n1: number = 0
		local n2: number = 0
		local u302: boolean = false

		local function resolveOne(p49, ...)
			if u302 then
				return
			end

			n1 += 1

			if p45 == nil then
				t12[p49] = ...
			else
				t12[n1] = ...
			end

			if n1 >= (p45 or #p44) then
				u302 = true
				p46(t12)

				for _, v in ipairs(t13) do
					v:cancel()
				end
			end
		end

		p48(function()
			for _, v in ipairs(t13) do
				v:cancel()
			end
		end)

		for i, v in ipairs(p44) do
			t13[i] = v:andThen(function(...)
				resolveOne(i, ...)
			end, function(...)
				n2 += 1

				if p45 == nil or #p44 - n2 < p45 then
					for _, iterValue in ipairs(t13) do
						iterValue:cancel()
					end

					u302 = true
					p47(...)
				end
			end)
		end

		if u302 then
			for _, v in ipairs(t13) do
				v:cancel()
			end
		end
	end)
end
function module.all(p50)
	local _all = module._all
	local v96 = debug.traceback(nil, 2)

	return _all(v96, p50)
end
function module.fold(p51, p52, p53)
	local typeName: string = type(p51)

	assert(typeName == "table", "Bad argument #1 to Promise.fold: must be a table")

	local u101

	if type(p52) == "function" then
		u101 = true
	else
		local v102 = type(p52) == "table" and getmetatable(p52)

		u101 = if v102 and type((rawget(v102, "__call"))) == "function" then true else false
	end

	assert(u101, "Bad argument #2 to Promise.fold: must be a function")

	local u103 = module.resolve(p53)

	return module.each(p51, function(p54, p55)
		u103 = u103:andThen(function(p56)
			return p52(p56, p54, p55)
		end)
	end):andThen(function()
		return u103
	end)
end
function module.some(p57, p58)
	local typeName: string = type(p58)

	assert(typeName == "number", "Bad argument #2 to Promise.some: must be a number")

	local _all = module._all
	local v108 = debug.traceback(nil, 2)

	return _all(v108, p57, p58)
end
function module.any(p59)
	local _all = module._all
	local v111 = debug.traceback(nil, 2)

	return _all(v111, p59, 1):andThen(function(p60)
		return p60[1]
	end)
end
function module.allSettled(p61)
	if type(p61) ~= "table" then
		local formattedText = string.format("Please pass a list of promises to %s", "Promise.allSettled")

		error(formattedText, 2)
	end

	for k, v in pairs(p61) do
		if not module.is(v) then
			local stringFormat = string.format
			local text: string = tostring(k)
			local v118 = stringFormat("Non-promise value passed into %s at index %s", "Promise.allSettled", text)

			error(v118, 2)
		end
	end

	if #p61 == 0 then
		return module.resolve({})
	end

	local _new = module._new
	local v120 = debug.traceback(nil, 2)

	return _new(v120, function(p62, _, p64)
		local t14: {[any]: any} = {}
		local t15: {[any]: any} = {}
		local n1: number = 0

		local function resolveOne(p65, ...)
			n1 += 1
			t14[p65] = ...

			if n1 >= #p61 then
				p62(t14)
			end
		end

		p64(function()
			for _, v in ipairs(t15) do
				v:cancel()
			end
		end)

		for i, v in ipairs(p61) do
			t15[i] = v:finally(function(...)
				resolveOne(i, ...)
			end)
		end
	end)
end
function module.race(p66)
	local typeName: string = type(p66)

	assert(typeName == "table", string.format("Please pass a list of promises to %s", "Promise.race"))

	for k, v in pairs(p66) do
		local v125 = module.is(v)
		local stringFormat = string.format
		local text: string = tostring(k)

		assert(v125, stringFormat("Non-promise value passed into %s at index %s", "Promise.race", text))
	end

	local _new = module._new
	local v129 = debug.traceback(nil, 2)

	return _new(v129, function(p67, p68, p69)
		local t16: {[any]: any} = {}
		local u324: boolean = false

		local function cancel()
			for _, v in ipairs(t16) do
				v:cancel()
			end
		end
		local function finalize(p70)
			return function(...)
				for _, v in ipairs(t16) do
					v:cancel()
				end

				u324 = true

				return p70(...)
			end
		end

		if p69(function(...)
			for _, v in ipairs(t16) do
				v:cancel()
			end

			u324 = true

			return p68(...)
		end) then
			return
		end

		for i, v in ipairs(p66) do
			t16[i] = v:andThen(function(...)
				for _, iterValue in ipairs(t16) do
					iterValue:cancel()
				end

				u324 = true

				return p67(...)
			end, function(...)
				for _, v in ipairs(t16) do
					v:cancel()
				end

				u324 = true

				return p68(...)
			end)
		end

		if u324 then
			for _, v in ipairs(t16) do
				v:cancel()
			end
		end
	end)
end
function module.each(p71, p72)
	local typeName: string = type(p71)

	assert(typeName == "table", string.format("Please pass a list of promises to %s", "Promise.each"))

	local u133

	if type(p72) == "function" then
		u133 = true
	else
		local v134 = type(p72) == "table" and getmetatable(p72)

		u133 = if v134 and type((rawget(v134, "__call"))) == "function" then true else false
	end

	assert(u133, string.format("Please pass a handler function to %s!", "Promise.each"))

	local _new = module._new
	local v136 = debug.traceback(nil, 2)

	return _new(v136, function(p73, p74, p75)
		local t17: {[any]: any} = {}
		local t18: {[any]: any} = {}
		local u336: boolean = false

		local function cancel()
			for _, v in ipairs(t18) do
				v:cancel()
			end
		end

		p75(function()
			u336 = true

			for _, v in ipairs(t18) do
				v:cancel()
			end
		end)

		local t19: {[any]: any} = {}

		for i, v in ipairs(p71) do
			if module.is(v) then
				if v:getStatus() == module.Status.Cancelled then
					for _, iterValue in ipairs(t18) do
						iterValue:cancel()
					end

					local new = t2.new
					local alreadyCancelled = t2.Kind.AlreadyCancelled
					local formattedText = string.format("The Promise that was part of the array at index %d passed into Promise.each was already cancelled when Promise.each began.\n\nThat Promise was created at:\n\n%s", i, v._source)

					return p74(new({
						error = "Promise is cancelled",
						kind = alreadyCancelled,
						context = formattedText
					}))
				end

				if v:getStatus() == module.Status.Rejected then
					for _, iterValue2 in ipairs(t18) do
						iterValue2:cancel()
					end

					return p74(select(2, v:await()))
				end

				local v348 = v:andThen(function(...)
					return ...
				end)

				table.insert(t18, v348)
				t19[i] = v348
			else
				t19[i] = v
			end
		end

		for i, v in ipairs(t19) do
			if module.is(v) then
				local v351, v352 = v:await()

				v = v352

				if not v351 then
					for _, iterValue3 in ipairs(t18) do
						iterValue3:cancel()
					end

					return p74(v)
				end
			end

			if u336 then
				return
			end

			local v355 = module.resolve(p72(v, i))

			table.insert(t18, v355)

			local v356, v357 = v355:await()

			if not v356 then
				for _, iterValue4 in ipairs(t18) do
					iterValue4:cancel()
				end

				return p74(v357)
			end

			t17[i] = v357
		end

		p73(t17)
	end)
end
function module.is(p76)
	if type(p76) == "table" then
		local v138 = getmetatable(p76)

		if v138 == module then
			return true
		end

		if v138 == nil then
			local andThen = p76.andThen

			if type(andThen) == "function" then
				return true
			end

			local v140 = type(andThen) == "table" and getmetatable(andThen)

			if v140 and type((rawget(v140, "__call"))) == "function" then
				return true
			end
		elseif type(v138) == "table" and type((rawget(v138, "__index"))) == "table" then
			local v141 = rawget(v138, "__index")
			local v142 = rawget(v141, "andThen")
			local u143

			if type(v142) == "function" then
				u143 = true
			else
				local v144 = type(v142) == "table" and getmetatable(v142)

				u143 = if v144 and type((rawget(v144, "__call"))) == "function" then true else false
			end

			if u143 then
				return true
			end

			return false
		end

		return false
	end

	return false
end
function module.promisify(p77)
	return function(...)
		local _try = module._try
		local v361 = debug.traceback(nil, 2)

		return _try(v361, p77, ...)
	end
end
function module.delay(p78)
	local typeName: string = type(p78)

	assert(typeName == "number", "Bad argument #1 to Promise.delay, must be a number.")

	local v148 = module._getTime()
	local _new = module._new
	local v150 = debug.traceback(nil, 2)

	return _new(v150, function(p79)
		task.delay(p78, function()
			local v418 = module._getTime()

			p79(v418 - v148)
		end)
	end)
end
function module.prototype.timeout(p80, p81, p82)
	local v154 = debug.traceback(nil, 2)
	local race = module.race

	local v156 = module.delay(p81):andThen(function()
		local reject = module.reject
		local v364 = p82 == nil and t2.new({
			error = "Timed out",
			kind = t2.Kind.TimedOut,
			context = string.format("Timeout of %d seconds exceeded.\n:timeout() called at:\n\n%s", p81, v154)
		}) or p82

		return reject(v364)
	end)

	return race({ v156, p80 })
end
function module.prototype.getStatus(p83)
	return p83._status
end
function module.prototype._andThen(p84, p85, p86, p87)
	p84._unhandledRejection = false

	if p84._status == module.Status.Cancelled then
		local v162 = module.new(function()
		end)

		v162:cancel()

		return v162
	end

	return module._new(p85, function(p88, p89, p90)
		local u368 = p88

		if p86 then
			local v369 = p85
			local v370 = p86

			u368 = function(...)
				local v419, v420, v421 = runExecutor(v369, v370, ...)

				if v419 then
					p88(unpack(v421, 1, v420))

					return
				end

				p89(v421[1])
			end
		end

		local u371 = p89

		if p87 then
			local v372 = p85
			local v373 = p87

			u371 = function(...)
				local v422, v423, v424 = runExecutor(v372, v373, ...)

				if v422 then
					p88(unpack(v424, 1, v423))

					return
				end

				p89(v424[1])
			end
		end

		if p84._status == module.Status.Started then
			table.insert(p84._queuedResolve, u368)
			table.insert(p84._queuedReject, u371)
			p90(function()
				if p84._status == module.Status.Started then
					table.remove(p84._queuedResolve, table.find(p84._queuedResolve, u368))
					table.remove(p84._queuedReject, table.find(p84._queuedReject, u371))
				end
			end)
		elseif p84._status == module.Status.Resolved then
			u368(unpack(p84._values, 1, p84._valuesLength))
		elseif p84._status == module.Status.Rejected then
			u371(unpack(p84._values, 1, p84._valuesLength))
		end
	end, p84)
end
function module.prototype.andThen(p91, p92, p93)
	local u166: boolean = true

	if p92 ~= nil then
		if type(p92) == "function" then
			u166 = true
		else
			local v167 = type(p92) == "table" and getmetatable(p92)

			u166 = if v167 and type((rawget(v167, "__call"))) == "function" then true else false
		end
	end

	assert(u166, string.format("Please pass a handler function to %s!", "Promise:andThen"))
	u166 = true

	if p93 ~= nil then
		if type(p93) == "function" then
			u166 = true
		else
			local v168 = type(p93) == "table" and getmetatable(p93)

			u166 = if v168 and type((rawget(v168, "__call"))) == "function" then true else false
		end
	end

	assert(u166, string.format("Please pass a handler function to %s!", "Promise:andThen"))

	local v169 = debug.traceback(nil, 2)

	return p91:_andThen(v169, p92, p93)
end
function module.prototype.catch(p94, p95)
	local u172: boolean = true

	if p95 ~= nil then
		if type(p95) == "function" then
			u172 = true
		else
			local v173 = type(p95) == "table" and getmetatable(p95)

			u172 = if v173 and type((rawget(v173, "__call"))) == "function" then true else false
		end
	end

	assert(u172, string.format("Please pass a handler function to %s!", "Promise:catch"))

	local v174 = debug.traceback(nil, 2)

	return p94:_andThen(v174, nil, p95)
end
function module.prototype.tap(p96, p97)
	local u177

	if type(p97) == "function" then
		u177 = true
	else
		local v178 = type(p97) == "table" and getmetatable(p97)

		u177 = if v178 and type((rawget(v178, "__call"))) == "function" then true else false
	end

	assert(u177, string.format("Please pass a handler function to %s!", "Promise:tap"))

	local v179 = debug.traceback(nil, 2)

	return p96:_andThen(v179, function(...)
		local v374 = p97(...)

		if module.is(v374) then
			local v375, v376 = pack(...)

			return v374:andThen(function()
				return unpack(v376, 1, v375)
			end)
		end

		return ...
	end)
end
function module.prototype.andThenCall(p98, p99, ...)
	local u182

	if type(p99) == "function" then
		u182 = true
	else
		local v183 = type(p99) == "table" and getmetatable(p99)

		u182 = if v183 and type((rawget(v183, "__call"))) == "function" then true else false
	end

	assert(u182, string.format("Please pass a handler function to %s!", "Promise:andThenCall"))

	local v184, v185 = pack(...)
	local v186 = debug.traceback(nil, 2)

	return p98:_andThen(v186, function()
		return p99(unpack(v185, 1, v184))
	end)
end
function module.prototype.andThenReturn(p100, ...)
	local v188, v189 = pack(...)
	local v190 = debug.traceback(nil, 2)

	return p100:_andThen(v190, function()
		return unpack(v189, 1, v188)
	end)
end
function module.prototype.cancel(p101)
	if p101._status ~= module.Status.Started then
		return
	end

	p101._status = module.Status.Cancelled

	if p101._cancellationHook then
		p101._cancellationHook()
	end

	coroutine.close(p101._thread)

	if p101._parent then
		p101._parent:_consumerCancelled(p101)
	end

	for iterKey in pairs(p101._consumers) do
		iterKey:cancel()
	end

	p101:_finalize()
end
function module.prototype._consumerCancelled(p102, p103)
	if p102._status ~= module.Status.Started then
		return
	end

	p102._consumers[p103] = nil

	if next(p102._consumers) == nil then
		p102:cancel()
	end
end
function module.prototype._finally(p104, p105, p106)
	p104._unhandledRejection = false

	return (module._new(p105, function(p107, p108, p109)
		local u380 = nil

		p109(function()
			p104:_consumerCancelled(p104)

			if u380 then
				u380:cancel()
			end
		end)

		local v381 = p107

		if p106 then
			v381 = function(...)
				local v425, v426, v427 = runExecutor(p105, p106, ...)
				local v428 = v427[1]

				if not v425 then
					return p108(v428)
				end

				if module.is(v428) then
					u380 = v428
					v428:finally(function(p110)
						if p110 ~= module.Status.Rejected then
							p107(p104)
						end
					end):catch(function(...)
						p108(...)
					end)

					return
				end

				p107(p104)
			end
		end

		if p104._status == module.Status.Started then
			table.insert(p104._queuedFinally, v381)
		else
			v381(p104._status)
		end
	end))
end
function module.prototype.finally(p111, p112)
	local u200: boolean = true

	if p112 ~= nil then
		if type(p112) == "function" then
			u200 = true
		else
			local v201 = type(p112) == "table" and getmetatable(p112)

			u200 = if v201 and type((rawget(v201, "__call"))) == "function" then true else false
		end
	end

	assert(u200, string.format("Please pass a handler function to %s!", "Promise:finally"))

	local v202 = debug.traceback(nil, 2)

	return p111:_finally(v202, p112)
end
function module.prototype.finallyCall(p113, p114, ...)
	local u205

	if type(p114) == "function" then
		u205 = true
	else
		local v206 = type(p114) == "table" and getmetatable(p114)

		u205 = if v206 and type((rawget(v206, "__call"))) == "function" then true else false
	end

	assert(u205, string.format("Please pass a handler function to %s!", "Promise:finallyCall"))

	local v207, v208 = pack(...)
	local v209 = debug.traceback(nil, 2)

	return p113:_finally(v209, function()
		return p114(unpack(v208, 1, v207))
	end)
end
function module.prototype.finallyReturn(p115, ...)
	local v211, v212 = pack(...)
	local v213 = debug.traceback(nil, 2)

	return p115:_finally(v213, function()
		return unpack(v212, 1, v211)
	end)
end
function module.prototype.awaitStatus(p116)
	p116._unhandledRejection = false

	if p116._status == module.Status.Started then
		local v215 = coroutine.running()

		p116:finally(function()
			task.spawn(v215)
		end):catch(function()
		end)
		coroutine.yield()
	end

	if p116._status == module.Status.Resolved then
		return p116._status, unpack(p116._values, 1, p116._valuesLength)
	end

	if p116._status == module.Status.Rejected then
		return p116._status, unpack(p116._values, 1, p116._valuesLength)
	end

	return p116._status
end
local function awaitHelper(p117, ...)
	return p117 == module.Status.Resolved, ...
end
function module.prototype.await(p118)
	return awaitHelper(p118:awaitStatus())
end
local function expectHelper(p119, ...)
	if p119 ~= module.Status.Resolved then
		error(if ... == nil then "Expected Promise rejected with no value." else ..., 3)
	end

	return ...
end
function module.prototype.expect(p120)
	return expectHelper(p120:awaitStatus())
end

module.prototype.awaitValue = module.prototype.expect

function module.prototype._unwrap(p121)
	if p121._status == module.Status.Started then
		error("Promise has not resolved or rejected.", 2)
	end

	return p121._status == module.Status.Resolved, unpack(p121._values, 1, p121._valuesLength)
end
function module.prototype._resolve(p122, ...)
	if p122._status ~= module.Status.Started then
		if module.is(...) then
			(...):_consumerCancelled(p122)
		end

		return
	end

	if module.is(...) then
		if select("#", ...) > 1 then
			local formattedText = string.format("When returning a Promise from andThen, extra arguments are discarded! See:\n\n%s", p122._source)

			warn(formattedText)
		end

		local v223 = ...

		local v224 = v223:andThen(function(...)
			p122:_resolve(...)
		end, function(...)
			local v382 = v223._values[1]

			if v223._error then
				v382 = t2.new({
					context = "[No stack trace available as this Promise originated from an older version of the Promise library (< v2)]",
					error = v223._error,
					kind = t2.Kind.ExecutionError
				})
			end

			if t2.isKind(v382, t2.Kind.ExecutionError) then
				local formattedText = string.format("The Promise at:\n\n%s\n...Rejected because it was chained to the following Promise, which encountered an error:\n", p122._source)

				return p122:_reject(v382:extend({
					error = "This Promise was chained to a Promise that errored.",
					trace = "",
					context = formattedText
				}))
			end

			p122:_reject(...)
		end)

		if v224._status == module.Status.Cancelled then
			p122:cancel()
		elseif v224._status == module.Status.Started then
			p122._parent = v224
			v224._consumers[p122] = true
		end

		return
	end

	p122._status = module.Status.Resolved

	local v225, v226 = pack(...)

	p122._valuesLength = v225
	p122._values = v226

	for _, v in ipairs(p122._queuedResolve) do
		coroutine.wrap(v)(...)
	end

	p122:_finalize()
end
function module.prototype._reject(p123, ...)
	if p123._status ~= module.Status.Started then
		return
	end

	p123._status = module.Status.Rejected

	local v230, v231 = pack(...)

	p123._valuesLength = v230
	p123._values = v231

	if next(p123._queuedReject) ~= nil then
		for _, v in ipairs(p123._queuedReject) do
			coroutine.wrap(v)(...)
		end
	else
		local text: string = tostring(...)

		coroutine.wrap(function()
			module._timeEvent:Wait()

			if not p123._unhandledRejection then
				return
			end

			local formattedText = string.format("Unhandled Promise rejection:\n\n%s\n\n%s", text, p123._source)

			for _, v in ipairs(module._unhandledRejectionCallbacks) do
				task.spawn(v, p123, unpack(p123._values, 1, p123._valuesLength))
			end

			if module.TEST then
				return
			end

			warn(formattedText)
		end)()
	end

	p123:_finalize()
end
function module.prototype._finalize(p124)
	for _, v in ipairs(p124._queuedFinally) do
		coroutine.wrap(v)(p124._status)
	end

	p124._queuedFinally = nil
	p124._queuedReject = nil
	p124._queuedResolve = nil

	if not module.TEST then
		p124._parent = nil
		p124._consumers = nil
	end

	task.defer(coroutine.close, p124._thread)
end
function module.prototype.now(p125, p126)
	local v240 = debug.traceback(nil, 2)

	if p125._status == module.Status.Resolved then
		return p125:_andThen(v240, function(...)
			return ...
		end)
	end

	local reject = module.reject
	local v242 = p126 == nil and t2.new({
		error = "This Promise was not resolved in time for :now()",
		kind = t2.Kind.NotResolvedInTime,
		context = ":now() was called at:\n\n" .. v240
	}) or p126

	return reject(v242)
end
function module.retry(p127, p128, ...)
	local u245

	if type(p127) == "function" then
		u245 = true
	else
		local v246 = type(p127) == "table" and getmetatable(p127)

		u245 = if v246 and type((rawget(v246, "__call"))) == "function" then true else false
	end

	assert(u245, "Parameter #1 to Promise.retry must be a function")

	local typeName: string = type(p128)

	assert(typeName == "number", "Parameter #2 to Promise.retry must be a number")

	local v248 = select("#", ...)
	local t10: {[any]: any} = { ... }

	return module.resolve(p127(...)):catch(function(...)
		if p128 > 0 then
			return module.retry(p127, p128 - 1, unpack(t10, 1, v248))
		end

		return module.reject(...)
	end)
end
function module.retryWithDelay(p129, p130, p131, ...)
	local u253

	if type(p129) == "function" then
		u253 = true
	else
		local v254 = type(p129) == "table" and getmetatable(p129)

		u253 = if v254 and type((rawget(v254, "__call"))) == "function" then true else false
	end

	assert(u253, "Parameter #1 to Promise.retry must be a function")

	local typeName: string = type(p130)

	assert(typeName == "number", "Parameter #2 (times) to Promise.retry must be a number")

	local typeName2: string = type(p131)

	assert(typeName2 == "number", "Parameter #3 (seconds) to Promise.retry must be a number")

	local v257 = select("#", ...)
	local t11: {[any]: any} = { ... }

	return module.resolve(p129(...)):catch(function(...)
		if p130 > 0 then
			module.delay(p131):await()

			return module.retryWithDelay(p129, p130 - 1, p131, unpack(t11, 1, v257))
		end

		return module.reject(...)
	end)
end
function module.fromEvent(p132, p133)
	local u261 = p133 or function()
		return true
	end

	local _new = module._new
	local v263 = debug.traceback(nil, 2)

	return _new(v263, function(p134, _, p136)
		local connection = nil
		local u391: boolean = false

		connection = p132:Connect(function(...)
			local v429 = u261(...)

			if v429 == true then
				p134(...)

				if connection then
					connection:Disconnect()
					connection = nil

					return
				end

				u391 = true

				return
			end

			if type(v429) ~= "boolean" then
				error("Promise.fromEvent predicate should always return a boolean")
			end
		end)
		p136(function()
			connection:Disconnect()
			connection = nil
		end)
	end)
end
function module.onUnhandledRejection(p137)
	table.insert(module._unhandledRejectionCallbacks, p137)

	return function()
		local v392 = table.find(module._unhandledRejectionCallbacks, p137)

		if v392 then
			table.remove(module._unhandledRejectionCallbacks, v392)
		end
	end
end

return module
