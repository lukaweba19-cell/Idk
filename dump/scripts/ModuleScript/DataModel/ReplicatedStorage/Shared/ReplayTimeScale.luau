-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local function describe(p1)
	if p1:IsA("ParticleEmitter") then
		return "TimeScale", true
	end

	if p1:IsA("Sound") then
		return "PlaybackSpeed", true
	end

	if p1:IsA("Beam") then
		return "TextureSpeed", true
	end

	if p1:IsA("Trail") then
		return "Lifetime", false
	end

	return nil, true
end
local function newRegistry()
	return (setmetatable({}, { __mode = "k" }))
end

local object = setmetatable({}, { __mode = "k" })
local object2 = setmetatable({}, { __mode = "k" })
local t1: {[any]: any} = {}
local u6: boolean = false
local n1 = 1

local function applyOne(p2, p3, p4)
	if p3.prop ~= "PlaybackSpeed" then
		if p3.rate then
			p2[p3.prop] = p3.base * p4

			return
		end

		local prop = p3.prop
		local base = p3.base
		local v18 = math.max(p4, 0.01)

		p2[prop] = base / v18

		return
	end

	if p4 < 0.01 then
		p2.PlaybackSpeed = p3.base * 0.01

		if p2.IsPlaying then
			object2[p2] = true
			p2:Pause()
		end

		return
	end

	p2.PlaybackSpeed = p3.base * p4

	if object2[p2] then
		object2[p2] = nil
		p2:Resume()
	end
end

local module: {[any]: any} = {
	Track = function(p5)
		if not u6 then
			return
		end

		if typeof(p5) ~= "Instance" then
			return
		end

		if object[p5] then
			return
		end

		local s1
		local u21

		if p5:IsA("ParticleEmitter") then
			s1 = "TimeScale"
			u21 = true
		elseif p5:IsA("Sound") then
			s1 = "PlaybackSpeed"
			u21 = true
		elseif p5:IsA("Beam") then
			s1 = "TextureSpeed"
			u21 = true
		elseif p5:IsA("Trail") then
			s1 = "Lifetime"
			u21 = false
		else
			s1 = nil
			u21 = true
		end

		if not s1 then
			return
		end

		local _ReplayBaseRate = p5:GetAttribute("_ReplayBaseRate")
		local t3

		if typeof(_ReplayBaseRate) == "number" and _ReplayBaseRate == _ReplayBaseRate then
			t3 = { prop = s1, base = _ReplayBaseRate, rate = u21 }
			object[p5] = t3
			applyOne(p5, t3, n1)

			return
		end

		_ReplayBaseRate = p5[s1]

		if typeof(_ReplayBaseRate) == "number" then
			p5:SetAttribute("_ReplayBaseRate", _ReplayBaseRate)
			t3 = { prop = s1, base = _ReplayBaseRate, rate = u21 }
			object[p5] = t3
			applyOne(p5, t3, n1)

			return
		end
	end
}

local function trackDescendants(p6)
	module.Track(p6)

	for _, v in ipairs(p6:GetDescendants()) do
		module.Track(v)
	end
end
local function rootsFor(p7)
	local t4: {[any]: any} = {}

	local function add(p8)
		if p8 then
			table.insert(t4, p8)
		end
	end

	local bin: Instance = workspace:FindFirstChild("Bin")

	if bin then
		table.insert(t4, bin)
	end

	local characters: Instance = workspace:FindFirstChild("Characters")

	if characters then
		table.insert(t4, characters)
	end

	local terrain: Instance = workspace:FindFirstChild("Terrain")

	if terrain then
		table.insert(t4, terrain)
	end

	if p7 then
		table.insert(t4, p7)
	end

	return t4
end
function module.Begin(p9)
	module.End()
	u6 = true
	n1 = 1

	local v34 = rootsFor(p9)

	for _, v in ipairs(v34) do
		pcall(trackDescendants, v)
		table.insert(t1, v.DescendantAdded:Connect(function(p10)
			if not u6 then
				return
			end

			module.Track(p10)
		end))
	end
end
function module.Set(p11)
	if not u6 then
	elseif typeof(p11) == "number" and p11 == p11 then
		local v38 = math.clamp(p11, 0, 16)

		if math.abs(v38 - n1) < 0.005 then
			return
		end

		n1 = v38

		for k, v in pairs(object) do
			if k.Parent then
				applyOne(k, v, n1)
			end
		end

		return
	end
end
function module.Current()
	return u6 and n1 or 1
end
function module.End()
	if not u6 then
		for _, v in ipairs(t1) do
			pcall(function()
				v:Disconnect()
			end)
		end

		t1 = {}

		return
	end

	u6 = false

	for _, v in ipairs(t1) do
		pcall(function()
			v:Disconnect()
		end)
	end

	t1 = {}

	for iterKey in pairs(object2) do
		pcall(function()
			if iterKey.Parent then
				iterKey:Resume()
			end
		end)
	end

	object2 = setmetatable({}, { __mode = "k" })

	for k, v in pairs(object) do
		pcall(function()
			k[v.prop] = v.base
			k:SetAttribute("_ReplayBaseRate", nil)
		end)
	end

	object = setmetatable({}, { __mode = "k" })
	n1 = 1
end
function module.Stats()
	local t5: {[any]: any} = {}
	local n2: number = 0

	for iterKey in pairs(object) do
		local className = iterKey.ClassName

		t5[className] = (t5[className] or 0) + 1
		n2 += 1
	end

	local t6: {[any]: any} = {}

	for k, v in pairs(t5) do
		table.insert(t6, k .. "=" .. v)
	end

	table.sort(t6)

	return ("running=%s scale=%.3f tracked=%d %s"):format(tostring(u6), n1, n2, table.concat(t6, " "))
end

return module
