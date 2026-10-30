-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")
local lighting: Lighting = game:GetService("Lighting")
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local u5 = nil
local u6 = nil
local t1: {[any]: any} = {}
local object = setmetatable({}, { __mode = "k" })
local t2: {[any]: any} = {}
local u10: boolean = false

local function notifyActive()
	local u17: boolean = next(t1) ~= nil

	if u17 == u10 then
		return
	end

	u10 = u17

	for _, v in ipairs(t2) do
		task.spawn(v, u17)
	end
end
local function cancelTween()
	if u6 then
		u6:Cancel()
		u6 = nil
	end
end
local function getBlur()
	local v20 = u5

	if v20 and v20.Parent == lighting then
		return v20
	end

	if u6 then
		u6:Cancel()
		u6 = nil
	end

	local windowBlur: BlurEffect = Instance.new("BlurEffect")

	windowBlur.Name = "WindowBlur"
	windowBlur.Size = 0
	windowBlur.Parent = lighting
	u5 = windowBlur

	return windowBlur
end
local function tweenTo(p1)
	local v23 = u5
	local v24

	if v23 and v23.Parent == lighting then
		v24 = v23
	else
		if u6 then
			u6:Cancel()
			u6 = nil
		end

		local windowBlur: BlurEffect = Instance.new("BlurEffect")

		windowBlur.Name = "WindowBlur"
		windowBlur.Size = 0
		windowBlur.Parent = lighting
		u5 = windowBlur
		v24 = windowBlur
	end

	if u6 then
		u6:Cancel()
		u6 = nil
	end

	if p1 > 0 then
		v24.Enabled = true
	end

	local v26: Tween = tweenService:Create(v24, if p1 > 0 then tweenInfo else tweenInfo2, { Size = p1 })

	u6 = v26
	v26:Play()
	v26.Completed:Once(function(p2)
		if u6 ~= v26 then
			return
		end

		if p2 ~= Enum.PlaybackState.Completed then
			return
		end

		u6 = nil

		if p1 <= 0 then
			v24.Enabled = false
		end
	end)
end
local function refresh()
	if next(t1) == nil then
		local v27 = u5

		if v27 and v27.Parent == lighting and v27.Size > 0 then
			tweenTo(0)
		end
	else
		tweenTo(24)
	end

	notifyActive()
end

local module: {[any]: any} = {
	show = function(p3)
		t1[p3 or "_default"] = true

		if next(t1) == nil then
			local v29 = u5

			if v29 and v29.Parent == lighting and v29.Size > 0 then
				tweenTo(0)
			end
		else
			tweenTo(24)
		end

		notifyActive()
	end,
	hide = function(p4)
		local v31 = p4 or "_default"

		t1[v31] = nil

		for iterKey in pairs(object) do
			iterKey[v31] = nil
		end

		if next(t1) == nil then
			local v33 = u5

			if v33 and v33.Parent == lighting and v33.Size > 0 then
				tweenTo(0)
			end
		else
			tweenTo(24)
		end

		notifyActive()
	end,
	clear = function()
		table.clear(t1)

		for iterKey in pairs(object) do
			table.clear(iterKey)
		end

		if u6 then
			u6:Cancel()
			u6 = nil
		end

		local v35 = u5

		if v35 and v35.Parent == lighting then
			v35.Size = 0
			v35.Enabled = false
		end

		notifyActive()
	end,
	isActive = function()
		return next(t1) ~= nil
	end
}

function module.saveAndClear()
	local t4: {[any]: any} = {}

	for iterKey in pairs(t1) do
		t4[iterKey] = true
	end

	module.clear()
	object[t4] = true

	return t4
end
function module.restore(p5)
	object[p5] = nil

	for iterKey in pairs(p5) do
		t1[iterKey] = true
	end

	if next(t1) == nil then
		local v40 = u5

		if v40 and v40.Parent == lighting and v40.Size > 0 then
			tweenTo(0)
		end
	else
		tweenTo(24)
	end

	notifyActive()
end
function module.onActiveChanged(p6)
	table.insert(t2, p6)

	local taskSpawn = task.spawn
	local v43 = next(t1)

	taskSpawn(p6, v43 ~= nil)

	return function()
		local v45 = table.find(t2, p6)

		if v45 then
			table.remove(t2, v45)
		end
	end
end

return module
