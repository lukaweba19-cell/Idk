-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {}

module.__index = module

local t2: {[any]: any} = { FillTransparency = 1, OutlineTransparency = 1, Enabled = false }
local color3 = Color3.fromRGB(255, 0, 0)
local color32 = Color3.fromRGB(255, 255, 255)
local alwaysOnTop = Enum.HighlightDepthMode.AlwaysOnTop

local function applyProps(p1, p2)
	for k, v in pairs(p2) do
		pcall(function()
			p1[k] = v
		end)
	end
end
function module.new(p3)
	local typeName: string = typeof(p3)

	assert(typeName == "table", "HighlightPool.new requires a config table")

	local u14: boolean = false

	if typeof(p3.size) == "number" then
		u14 = p3.size > 0
	end

	assert(u14, "config.size must be a positive number")

	local typeName2: string = typeof(p3.parent)

	assert(typeName2 == "Instance", "config.parent must be an Instance")

	local object = setmetatable({}, module)

	object._name = p3.name or "Pool"
	object._size = p3.size
	object._parent = p3.parent
	object._defaults = p3.defaults or {}
	object._free = {}
	object._active = {}
	object._created = 0
	object._nextGen = 0
	object._lastWarnAt = 0

	return object
end
function module._allocate(p4)
	if p4._created >= p4._size then
		return nil
	end

	p4._created = p4._created + 1

	local highlight: Highlight = Instance.new("Highlight")

	highlight.Name = string.format("__Pooled_%s_%d", p4._name, p4._created)
	highlight.Enabled = true
	highlight.FillTransparency = 1
	highlight.OutlineTransparency = 1
	highlight.Adornee = nil
	highlight.Parent = p4._parent

	local _name = p4._name
	local _active = p4._active
	local _parent = p4._parent

	highlight:GetPropertyChangedSignal("Parent"):Connect(function()
		local highlightParent: Instance = highlight.Parent

		if highlightParent ~= _parent then
			local u69: boolean = _active[highlight] ~= nil
			local stringFormat = string.format
			local highlightName: string = highlight.Name
			local v72 = highlightParent and highlightParent:GetFullName() or "nil"
			local text: string = tostring(v72)
			local text2: string = tostring(u69)
			local v75 = highlight.Adornee and highlight.Adornee:GetFullName() or "nil"
			local text3: string = tostring(v75)

			warn(stringFormat("[HighlightPool:%s] Parent changed externally: %s -> %s (active=%s, adornee=%s)\n%s", _name, highlightName, text, text2, text3, debug.traceback("", 2)))
		end
	end)

	return highlight
end

local t3: {[any]: any} = {
	FillTransparency = 0.5,
	OutlineTransparency = 0,
	Enabled = true,
	FillColor = color3,
	OutlineColor = color32,
	DepthMode = alwaysOnTop
}

function module.acquire(p5, adornee, p7)
	local v25 = table.remove(p5._free)

	if not v25 then
		v25 = p5:_allocate()
	end

	if not v25 then
		local v26 = os.clock()

		if v26 - p5._lastWarnAt > 1 then
			p5._lastWarnAt = v26
			warn(string.format("[HighlightPool:%s] exhausted (size=%d)", p5._name, p5._size))
		end

		return nil
	end

	if v25.Parent ~= p5._parent then
		v25.Parent = p5._parent
	end

	applyProps(v25, t3)
	applyProps(v25, p5._defaults)

	if p7 then
		applyProps(v25, p7)
	end

	v25.Adornee = adornee
	p5._nextGen = p5._nextGen + 1
	p5._active[v25] = {
		tweens = {},
		generation = p5._nextGen
	}

	return v25
end
function module.trackTween(p8, p9, p10)
	local v30 = p8._active[p9]

	if not v30 then
		pcall(function()
			p10:Cancel()
		end)

		return
	end

	table.insert(v30.tweens, p10)
end
function module.release(p11, p12)
	if not p12 then
		return
	end

	local v33 = p11._active[p12]

	if not v33 then
		return
	end

	for _, v in ipairs(v33.tweens) do
		pcall(function()
			v:Cancel()
		end)
	end

	applyProps(p12, t2)
	p12.Adornee = nil
	p11._active[p12] = nil
	table.insert(p11._free, p12)
end
function module.generationOf(p13, p14)
	if not p14 then
		return nil
	end

	local v38 = p13._active[p14]

	return v38 and v38.generation or nil
end
function module.releaseIfGeneration(p15, p16, p17)
	if p16 and typeof(p17) == "number" then
		local v42 = p15._active[p16]

		if v42 and p17 == v42.generation then
			p15:release(p16)

			return
		end

		return
	end
end
function module.releaseAfter(p18, p19, p20)
	if not p19 then
		return function()
		end
	end

	local v46 = p18._active[p19]

	if not v46 then
		return function()
		end
	end

	local generation = v46.generation
	local u48: boolean = false

	task.delay(p20, function()
		if u48 then
			return
		end

		local v77 = p18._active[p19]

		if v77 and v77.generation == generation then
			p18:release(p19)
		end
	end)

	return function()
		u48 = true
	end
end
function module.releaseAll(p21)
	local t4: {[any]: any} = {}

	for iterKey in pairs(p21._active) do
		table.insert(t4, iterKey)
	end

	for _, v in ipairs(t4) do
		p21:release(v)
	end
end
function module.active(p22)
	local n1: number = 0

	for iterKey in pairs(p22._active) do
		n1 += 1
	end

	return n1
end
function module.capacity(p23)
	return p23._size
end
function module.stats(p24)
	local _name = p24._name
	local v60 = p24:active()

	return {
		name = _name,
		active = v60,
		free = #p24._free,
		created = p24._created,
		capacity = p24._size
	}
end
function module.destroy(p25)
	for k, v in pairs(p25._active) do
		for _, iterValue in ipairs(v.tweens) do
			pcall(function()
				iterValue:Cancel()
			end)
		end

		pcall(function()
			k:Destroy()
		end)
	end

	for _, v in ipairs(p25._free) do
		pcall(function()
			v:Destroy()
		end)
	end

	p25._active = {}
	p25._free = {}
	p25._created = 0
end

return module
