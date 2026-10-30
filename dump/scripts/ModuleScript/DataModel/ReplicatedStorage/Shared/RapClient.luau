-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local tradePublicFlags = require(shared:WaitForChild("TradePublicFlags"))
local bindableEvent: BindableEvent = Instance.new("BindableEvent")
local t1: {[any]: any} = {
	warming = false,
	available = nil,
	darkAt = -math.huge,
	lastAllAt = -math.huge,
	priming = false,
	primeGen = 0,
	polling = false,
	pumping = false,
	rf = nil,
	forceProjected = nil,
	cache = {},
	queue = {},
	queued = {}
}

local function stampForced(p1, p2)
	local forceProjected = t1.forceProjected

	if forceProjected ~= nil and (forceProjected == "*" or forceProjected == p1) and typeof(p2) == "table" then
		p2.Projected = true
	end
end

local t2: {[any]: any} = { Knife = true, Revolver = true, Finisher = true }

local function key(p3, p4)
	return p3 .. ":" .. p4
end
local function remote()
	if t1.rf == nil or t1.rf.Parent == nil then
		local v26: Instance = remotes:FindFirstChild("RAP") or remotes:WaitForChild("RAP", 20)

		if v26 ~= nil and v26:IsA("RemoteFunction") then
			t1.rf = v26

			return v26
		end

		return nil
	end

	return t1.rf
end
local function invoke(p6, p7, p8)
	local v30 = remote()

	if v30 == nil then
		return nil
	end

	local v31 = table.pack(pcall(v30.InvokeServer, v30, p6, p7, p8))

	if not v31[1] then
		return nil
	end

	return table.unpack(v31, 2, v31.n)
end

local module: {[any]: any} = {
	Changed = bindableEvent.Event,
	HasRap = function(p5)
		local u33: boolean = false

		if typeof(p5) == "string" then
			u33 = t2[p5] == true
		end

		return u33
	end,
	Unlocked = function()
		local LocalPlayer: Player = players.LocalPlayer

		if LocalPlayer == nil then
			return false
		end

		local v35 = tradePublicFlags.MinTradeLevel()

		if v35 <= 0 then
			return true
		end

		local numberValue: number? = tonumber(LocalPlayer:GetAttribute("Level"))

		return v35 <= (numberValue or 0)
	end
}

function module.Available()
	if not module.Unlocked() then
		return false
	end

	return t1.available == true
end
function module.Warming()
	return t1.warming
end
function module.Peek(p9, p10)
	if module.HasRap(p9) and typeof(p10) == "string" then
		if not module.Unlocked() then
			return nil
		end

		return t1.cache[p9 .. ":" .. p10]
	end

	return nil
end
local function mergeAll(p11)
	if typeof(p11) == "table" then
		for k, v in pairs(p11) do
			if typeof(k) == "string" and typeof(v) == "table" then
				local forceProjected = t1.forceProjected

				if forceProjected ~= nil and (forceProjected == "*" or forceProjected == k) and typeof(v) == "table" then
					v.Projected = true
				end

				t1.cache[k] = v
			end
		end

		return true
	end

	return false
end
local function startWarmPoll()
	if t1.polling then
		return
	end

	t1.polling = true
	task.spawn(function()
		local u76: boolean = false

		while not u76 and t1.available == true do
			task.wait(10.5)
			t1.lastAllAt = os.clock()

			local v77 = remote()
			local v78
			local v79

			if v77 == nil then
				v78 = nil
				v79 = nil
			else
				local v80 = table.pack(pcall(v77.InvokeServer, v77, "All", nil, nil))

				if not v80[1] then
					v78 = nil
					v79 = nil
				else
					local v81, v82 = table.unpack(v80, 2, v80.n)

					v78 = v81
					v79 = v82
				end
			end

			if mergeAll(v78) then
				t1.warming = v79 == true
				u76 = not t1.warming
				bindableEvent:Fire()
			end
		end

		t1.polling = false
	end)
end
local function probeGate()
	for i = 1, 2 do
		if typeof(invoke("MyValue")) == "number" then
			return true
		end

		if i == 1 then
			task.wait(0.25)
		end
	end

	return false
end
function module.Prime(p12)
	local v45
	local v46
	local v47
	local v48
	local v49
	local v50

	if p12 then
		v45 = t1
		v45.primeGen = v45.primeGen + 1
		t1.priming = false

		if t1.available == false then
			t1.available = nil
			t1.darkAt = -math.huge
		end
	end

	if t1.priming then
	else
		v46 = module.Unlocked()

		if not v46 then
		else
			v47 = os.clock()

			if not p12 then
				if t1.available == true and v47 - t1.lastAllAt < 10.5 or t1.available == false and v47 - t1.darkAt < 120 then
				else
					t1.priming = true
					v48 = t1
					v48.primeGen = v48.primeGen + 1
					v49 = t1.primeGen
					v50 = function()
						local v83 = probeGate()

						if v49 ~= t1.primeGen then
							return
						end

						if not v83 then
							if t1.available ~= true then
								t1.available = false
								t1.darkAt = os.clock()
							end

							t1.priming = false
							bindableEvent:Fire()

							return
						end

						t1.available = true
						t1.lastAllAt = os.clock()
						v83 = remote()

						local v84
						local v85

						if v83 == nil then
							v84 = nil
							v85 = nil
						else
							local v86 = table.pack(pcall(v83.InvokeServer, v83, "All", nil, nil))

							if not v86[1] then
								v84 = nil
								v85 = nil
							else
								local v87, v88 = table.unpack(v86, 2, v86.n)

								v84 = v87
								v85 = v88
							end
						end

						if mergeAll(v84) then
							t1.warming = v85 == true
						end

						if v49 ~= t1.primeGen then
							return
						end

						t1.priming = false
						bindableEvent:Fire()

						if t1.polling then
							return
						end

						t1.polling = true
						task.spawn(function()
							local u114: boolean = false

							while not u114 and t1.available == true do
								task.wait(10.5)
								t1.lastAllAt = os.clock()

								local v115 = remote()
								local v116
								local v117

								if v115 == nil then
									v116 = nil
									v117 = nil
								else
									local v118 = table.pack(pcall(v115.InvokeServer, v115, "All", nil, nil))

									if not v118[1] then
										v116 = nil
										v117 = nil
									else
										local v119, v120 = table.unpack(v118, 2, v118.n)

										v116 = v119
										v117 = v120
									end
								end

								if mergeAll(v116) then
									t1.warming = v117 == true
									u114 = not t1.warming
									bindableEvent:Fire()
								end
							end

							t1.polling = false
						end)
					end
					task.spawn(v50)
				end
			else
				t1.priming = true
				v48 = t1
				v48.primeGen = v48.primeGen + 1
				v49 = t1.primeGen
				v50 = function()
					local v83 = probeGate()

					if v49 ~= t1.primeGen then
						return
					end

					if not v83 then
						if t1.available ~= true then
							t1.available = false
							t1.darkAt = os.clock()
						end

						t1.priming = false
						bindableEvent:Fire()

						return
					end

					t1.available = true
					t1.lastAllAt = os.clock()
					v83 = remote()

					local v84
					local v85

					if v83 == nil then
						v84 = nil
						v85 = nil
					else
						local v86 = table.pack(pcall(v83.InvokeServer, v83, "All", nil, nil))

						if not v86[1] then
							v84 = nil
							v85 = nil
						else
							local v87, v88 = table.unpack(v86, 2, v86.n)

							v84 = v87
							v85 = v88
						end
					end

					if mergeAll(v84) then
						t1.warming = v85 == true
					end

					if v49 ~= t1.primeGen then
						return
					end

					t1.priming = false
					bindableEvent:Fire()

					if t1.polling then
						return
					end

					t1.polling = true
					task.spawn(function()
						local u114: boolean = false

						while not u114 and t1.available == true do
							task.wait(10.5)
							t1.lastAllAt = os.clock()

							local v115 = remote()
							local v116
							local v117

							if v115 == nil then
								v116 = nil
								v117 = nil
							else
								local v118 = table.pack(pcall(v115.InvokeServer, v115, "All", nil, nil))

								if not v118[1] then
									v116 = nil
									v117 = nil
								else
									local v119, v120 = table.unpack(v118, 2, v118.n)

									v116 = v119
									v117 = v120
								end
							end

							if mergeAll(v116) then
								t1.warming = v117 == true
								u114 = not t1.warming
								bindableEvent:Fire()
							end
						end

						t1.polling = false
					end)
				end
				task.spawn(v50)
			end
		end
	end
end
local function pump()
	if t1.pumping then
		return
	end

	t1.pumping = true
	task.spawn(function()
		while #t1.queue > 0 do
			local v89 = table.remove(t1.queue, 1)
			local v90 = t1.queued[v89]

			t1.queued[v89] = nil

			if v90 ~= nil then
				local v91 = t1.cache[v89]

				if v91 == nil then
					for _ = 1, 2 do
						local kind = v90.kind
						local itemId = v90.itemId
						local v95 = remote()
						local v96

						if v95 == nil then
							v96 = nil
						else
							local v97 = table.pack(pcall(v95.InvokeServer, v95, "Get", kind, itemId))

							v96 = if not v97[1] then nil else table.unpack(v97, 2, v97.n)
						end

						if typeof(v96) == "table" then
							v91 = v96

							local forceProjected = t1.forceProjected

							if forceProjected ~= nil and (forceProjected == "*" or forceProjected == v89) and typeof(v91) == "table" then
								v91.Projected = true
							end

							t1.cache[v89] = v91
							t1.available = true

							break
						end

						task.wait(0.25)
					end
				end

				for _, v in ipairs(v90.cbs) do
					task.spawn(v, v91)
				end

				if v91 ~= nil then
					bindableEvent:Fire()
				end
			end
		end

		t1.pumping = false
	end)
end
function module.Request(p13, p14, p15)
	local function answer(p16)
		if p15 ~= nil then
			task.spawn(p15, p16)
		end
	end

	if module.HasRap(p13) and typeof(p14) == "string" and p14 ~= "" then
		if not module.Unlocked() then
			if p15 ~= nil then
				task.spawn(p15, nil)
			end

			return
		end

		local s1: string = p13 .. ":" .. p14
		local v56 = t1.cache[s1]

		if v56 == nil then
			module.Prime()

			if t1.available == false then
				if p15 ~= nil then
					task.spawn(p15, nil)
				end

				return
			end

			local t4 = t1.queued[s1]

			if t4 == nil then
				t4 = {
					kind = p13,
					itemId = p14,
					cbs = {}
				}
				t1.queued[s1] = t4
				table.insert(t1.queue, s1)

				while #t1.queue > 16 do
					local v58 = table.remove(t1.queue, 1)
					local v59 = t1.queued[v58]

					t1.queued[v58] = nil

					if v59 ~= nil then
						for _, v in ipairs(v59.cbs) do
							task.spawn(v, nil)
						end
					end
				end
			end

			if p15 ~= nil then
				table.insert(t4.cbs, p15)
			end

			if t1.pumping then
				return
			end

			t1.pumping = true
			task.spawn(function()
				while #t1.queue > 0 do
					local v102 = table.remove(t1.queue, 1)
					local v103 = t1.queued[v102]

					t1.queued[v102] = nil

					if v103 ~= nil then
						local v104 = t1.cache[v102]

						if v104 == nil then
							for _ = 1, 2 do
								local kind = v103.kind
								local itemId = v103.itemId
								local v108 = remote()
								local v109

								if v108 == nil then
									v109 = nil
								else
									local v110 = table.pack(pcall(v108.InvokeServer, v108, "Get", kind, itemId))

									v109 = if not v110[1] then nil else table.unpack(v110, 2, v110.n)
								end

								if typeof(v109) == "table" then
									v104 = v109

									local forceProjected = t1.forceProjected

									if forceProjected ~= nil and (forceProjected == "*" or forceProjected == v102) and typeof(v104) == "table" then
										v104.Projected = true
									end

									t1.cache[v102] = v104
									t1.available = true

									break
								end

								task.wait(0.25)
							end
						end

						for _, v in ipairs(v103.cbs) do
							task.spawn(v, v104)
						end

						if v104 ~= nil then
							bindableEvent:Fire()
						end
					end
				end

				t1.pumping = false
			end)
		elseif p15 ~= nil then
			task.spawn(p15, v56)
		end
	elseif p15 ~= nil then
		task.spawn(p15, nil)
	end
end
function module.DebugForceProjected(p17, p18, p19)
	local shared: Instance = replicatedStorage:WaitForChild("Shared")

	if not require(shared:WaitForChild("Universe")).IsDev() then
		return 0
	end

	if not p17 then
		t1.forceProjected = nil
		module.Reset()
		module.Prime(true)
		bindableEvent:Fire()

		return 0
	end

	local s1 = if typeof(p18) == "string" and typeof(p19) == "string" then p18 .. ":" .. p19 else nil

	t1.forceProjected = s1 or "*"

	local n1: number = 0

	for k, v in pairs(t1.cache) do
		if s1 == nil or k == s1 then
			local forceProjected = t1.forceProjected

			if forceProjected ~= nil and (forceProjected == "*" or forceProjected == k) and typeof(v) == "table" then
				v.Projected = true
			end

			n1 += 1
		end
	end

	bindableEvent:Fire()

	return n1
end
function module.Reset()
	table.clear(t1.cache)
	table.clear(t1.queue)
	table.clear(t1.queued)
	t1.available = nil
	t1.darkAt = -math.huge
	t1.lastAllAt = -math.huge
	t1.warming = false
	bindableEvent:Fire()
end
function module.Put(p20, p21, p22)
	if module.HasRap(p20) and typeof(p21) == "string" then
		if typeof(p22) == "table" then
			local forceProjected = t1.forceProjected

			if forceProjected ~= nil and (forceProjected == "*" or forceProjected == p20 .. ":" .. p21) and typeof(p22) == "table" then
				p22.Projected = true
			end

			t1.cache[p20 .. ":" .. p21] = p22
			t1.available = true
			bindableEvent:Fire()

			return
		end

		return
	end
end

local LocalPlayer: Player = players.LocalPlayer
local u19 = nil

local function onGateMaybeChanged()
	local v75 = module.Unlocked()

	if v75 == u19 then
		return
	end

	u19 = v75
	bindableEvent:Fire()

	if v75 then
		module.Prime(true)
	end
end

u19 = module.Unlocked()

if LocalPlayer ~= nil then
	LocalPlayer:GetAttributeChangedSignal("Level"):Connect(onGateMaybeChanged)
end

tradePublicFlags.OnChanged("MinTradeLevel", onGateMaybeChanged)

return module
