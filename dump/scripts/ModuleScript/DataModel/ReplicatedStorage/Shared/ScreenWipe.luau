-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local runService: RunService = game:GetService("RunService")
local tweenService: TweenService = game:GetService("TweenService")
local t1: {[any]: any} = {}

t1.__index = t1

local function buildCubes(parent, p2)
	local t3: {[any]: any} = {}
	local v15 = UDim2.fromScale(0.0675, 0.10500000000000001)
	local v16 = UDim2.fromScale(0, 0)
	local n1 = 0

	for i = 0, 9 do
		for j = 0, 15 do
			local frame: Frame = Instance.new("Frame")

			frame.BackgroundColor3 = Color3.new(0, 0, 0)
			frame.BorderSizePixel = 0
			frame.AnchorPoint = Vector2.new(0.5, 0.5)
			frame.Size = if p2 then v15 else v16
			frame.Position = UDim2.fromScale(j * 0.0625 + 0.03125, i * 0.1 + 0.05)
			frame.Parent = parent

			local n2: number = (j + 0.5) / 16 - 0.5
			local n3: number = (i + 0.5) / 10 - 0.5
			local squareRoot = math.sqrt(n2 * n2 + n3 * n3)

			if n1 < squareRoot then
				n1 = squareRoot
			end

			t3[#t3 + 1] = {
				bw = 0.0675,
				bh = 0.10500000000000001,
				inst = frame,
				dist = squareRoot
			}
		end
	end

	if n1 == 0 then
		n1 = 1
	end

	return t3, n1
end
function t1._animate(p5, p6, p7)
	p5._token = p5._token + 1

	local _token = p5._token
	local v28 = p7 or 0.5

	if v28 <= 0 then
		local n1: number = if p6 then 1 else 0

		for _, v in ipairs(p5._cubes) do
			v.inst.Size = UDim2.fromScale(v.bw * n1, v.bh * n1)
		end

		p5._covered = p6

		return true
	end

	local n2 = 0

	while true do
		local v33 = runService.Heartbeat:Wait()

		if _token ~= p5._token then
			break
		end

		n2 += v33
		v33 = true

		for _, v in ipairs(p5._cubes) do
			local n3 = v.dist / p5._maxDist

			n3 = math.clamp((n2 - (if p6 then 1 - n3 else n3) * v28 * 0.6) / (v28 * 0.4), 0, 1)

			if n3 < 1 then
				v33 = false
			end

			local v37 = if p6 then n3 else 1 - n3

			v.inst.Size = UDim2.fromScale(v.bw * v37, v.bh * v37)
		end

		if v33 then
			p5._covered = p6

			return true
		end
	end

	return false
end
function t1.cover(p8, p9)
	return p8:_animate(true, p9)
end
function t1.reveal(p10, p11)
	return p10:_animate(false, p11)
end
function t1.isCovered(p12)
	return p12._covered == true
end
function t1.destroy(p13)
	p13._token = p13._token + 1

	for _, v in ipairs(p13._cubes) do
		v.inst:Destroy()
	end

	table.clear(p13._cubes)

	if p13._ownsGui and p13._gui then
		p13._gui:Destroy()
		p13._gui = nil
		p13._frame = nil
		p13._label = nil
	end
end

local u6 = nil

local module: {[any]: any} = {
	attach = function(p3, p4)
		local u48: boolean = p4 == true
		local object = setmetatable({}, t1)
		local v50, v51 = buildCubes(p3, u48)

		object._cubes = v50
		object._maxDist = v51
		object._covered = u48
		object._token = 0
		object._ownsGui = false
		object._gui = nil
		object._frame = nil

		return object
	end
}

local function ensureShared()
	if u6 then
		return u6
	end

	local playerGui: Instance = players.LocalPlayer:WaitForChild("PlayerGui")
	local screenWipeOverlay: ScreenGui = Instance.new("ScreenGui")

	screenWipeOverlay.Name = "ScreenWipeOverlay"
	screenWipeOverlay.ResetOnSpawn = false
	screenWipeOverlay.IgnoreGuiInset = true
	screenWipeOverlay.ScreenInsets = Enum.ScreenInsets.None
	screenWipeOverlay.DisplayOrder = 1000
	screenWipeOverlay.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenWipeOverlay.Enabled = false
	screenWipeOverlay.Parent = playerGui

	local frame: Frame = Instance.new("Frame")

	frame.Name = "Frame"
	frame.BackgroundColor3 = Color3.new(0, 0, 0)
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.Active = false
	frame.Size = UDim2.fromScale(1, 1)
	frame.Position = UDim2.fromScale(0, 0)
	frame.Parent = screenWipeOverlay

	local clone = nil
	local statusText: Instance = script:FindFirstChild("StatusText")

	if statusText then
		clone = statusText:Clone()
		clone.ZIndex = 10
		clone.Visible = false
		clone.Text = ""
		clone.TextTransparency = 1
		clone.Parent = frame
	end

	u6 = module.attach(frame, false)
	u6._ownsGui = true
	u6._gui = screenWipeOverlay
	u6._frame = frame
	u6._label = clone

	return u6
end

local n1: number = 0

local function startStatusText(p14)
	local v58 = u6
	local _label = v58 and v58._label

	if not _label then
		return
	end

	n1 += 1

	local v60: number = n1

	_label.TextTransparency = 1
	_label.Visible = true

	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)

	tweenService:Create(_label, tweenInfo, { TextTransparency = 0 }):Play()
	task.spawn(function()
		local n2: number = 0

		while n1 == v60 do
			n2 = n2 % 3 + 1

			local v71 = p14
			local v72 = string.rep(".", n2)

			_label.Text = v71 .. v72
			task.wait(0.4)
		end
	end)
end
local function stopStatusText()
	n1 += 1

	local v62 = u6

	if v62 and v62._label then
		v62._label.Visible = false
		v62._label.Text = ""
	end
end
function module.cover(p15, p16)
	local v65 = ensureShared()

	v65._gui.Enabled = true
	v65._frame.Active = true
	task.spawn(function()
		if v65:cover(p15) and p16 then
			startStatusText(p16)
		end
	end)
end
function module.reveal(p17)
	if not u6 then
		return
	end

	n1 += 1

	local v67 = u6

	if v67 and v67._label then
		v67._label.Visible = false
		v67._label.Text = ""
	end

	local v68 = u6

	task.spawn(function()
		if v68:reveal(p17) then
			v68._frame.Active = false
			v68._gui.Enabled = false
		end
	end)
end
function module.isCovered()
	local u69 = false

	if u6 ~= nil then
		u69 = u6:isCovered()
	end

	return u69
end

return module
