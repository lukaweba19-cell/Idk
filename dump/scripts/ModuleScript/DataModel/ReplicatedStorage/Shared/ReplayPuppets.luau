-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local shared: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local replayFormat = require(shared:WaitForChild("ReplayFormat"))
local color3 = Color3.fromRGB(255, 80, 80)
local color32 = Color3.fromRGB(80, 150, 255)

local function strip(p1)
	for _, v in ipairs(p1:GetDescendants()) do
		if v:IsA("Humanoid") or v:IsA("LuaSourceContainer") or v:IsA("Sound") then
			v:Destroy()
		end
	end
end
local function prepParts(p2, p3)
	for _, v in ipairs(p2:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Anchored = true
			v.CanCollide = false
			v.CanQuery = false
			v.CanTouch = false
			v.Massless = true

			if v.Name ~= "Head" and v.Name ~= "HumanoidRootPart" then
				v.Color = p3
			end

			if v.Name == "HumanoidRootPart" then
				v.Transparency = 1
			end
		end
	end
end

local module: {[any]: any} = {}

function module.Build(p4, p5)
	local clone = p4:Clone()

	strip(clone)
	prepParts(clone, p5.side == 0 and color3 or color32)
	clone.Name = "ReplayPuppet_" .. tostring(p5.slot)

	local humanoidRootPart = clone:FindFirstChild("HumanoidRootPart")
	local torso = clone:FindFirstChild("Torso")

	if humanoidRootPart then
		clone.PrimaryPart = humanoidRootPart
	end

	local t2: {[any]: any} = {}

	if torso then
		for _, v in ipairs(torso:GetChildren()) do
			if v:IsA("Motor6D") then
				t2[v.Name] = { motor = v, c0 = v.C0 }
			end
		end
	end

	local v23 = module.MakeNameTag(p5)

	if v23 and clone:FindFirstChild("Head") then
		v23.Parent = clone:FindFirstChild("Head")
	end

	local head = clone:FindFirstChild("Head")

	return {
		lastPos = nil,
		phase = 0,
		model = clone,
		root = humanoidRootPart,
		torso = torso,
		head = head,
		joints = t2,
		slot = p5.slot,
		side = p5.side,
		name = p5.displayName
	}
end
function module.MakeNameTag(p6)
	local replayTag: BillboardGui = Instance.new("BillboardGui")

	replayTag.Name = "ReplayTag"
	replayTag.Size = UDim2.fromScale(4, 0.7)
	replayTag.StudsOffsetWorldSpace = Vector3.new(0, 2.2, 0)
	replayTag.AlwaysOnTop = true
	replayTag.MaxDistance = 250

	local textLabel: TextLabel = Instance.new("TextLabel")

	textLabel.Size = UDim2.fromScale(1, 1)
	textLabel.BackgroundTransparency = 1
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextScaled = true
	textLabel.Text = p6.displayName
	textLabel.TextColor3 = p6.side == 0 and color3 or color32
	textLabel.Parent = replayTag

	local uiStroke: UIStroke = Instance.new("UIStroke")

	uiStroke.Thickness = 2
	uiStroke.Color = Color3.new(0, 0, 0)
	uiStroke.Parent = textLabel

	return replayTag
end
function module.SetTagVisible(p7, enabled)
	local head = p7 and p7.head
	local replayTag = head and head:FindFirstChild("ReplayTag")

	if replayTag then
		replayTag.Enabled = enabled
	end
end
function module.Apply(p9, p10, p11, p12)
	if not p9.root then
		return
	end

	local v37 = bit32.band(p10.sflags, replayFormat.S_ALIVE)
	local vector3 = Vector3.new(p10.x, p10.y, p10.z)
	local n1 = p11 + vector3

	if v37 == 0 then
		for _, v in ipairs(p9.model:GetDescendants()) do
			if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
				v.Transparency = 1
			end
		end

		local v42 = p9.head and p9.head:FindFirstChild("ReplayTag")

		if v42 then
			v42.Enabled = false
		end

		p9.model:PivotTo(CFrame.new(n1))
		p9.lastPos = n1

		return
	end

	for _, v in ipairs(p9.model:GetDescendants()) do
		if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
			v.Transparency = 0
		end
	end

	local v45 = p9.head

	if v45 then
		v45 = p9.head:FindFirstChild("ReplayTag")
	end

	if v45 then
		v45.Enabled = true
	end

	local n2: number = 0

	if p10.state == replayFormat.STATE_CROUCHING then
		n2 = -1.1
	elseif p10.state == replayFormat.STATE_SLIDING then
		n2 = -1.6
	end

	local cFrameNew = CFrame.new
	local vector32 = Vector3.new(0, n2, 0)
	local v49 = cFrameNew(n1 + vector32)
	local v50 = CFrame.Angles(0, p10.yaw, 0)
	local n3 = v49 * v50

	if p10.state == replayFormat.STATE_SLIDING then
		local v52 = CFrame.Angles(-0.4363323129985824, 0, 0)

		n3 *= v52
	end

	p9.model:PivotTo(n3)
	n3 = 0

	if p9.lastPos and p12 > 0 then
		local n4 = n1 - p9.lastPos

		n3 = Vector3.new(n4.X, 0, n4.Z).Magnitude / p12
	end

	p9.lastPos = n1
	v49 = math.clamp(n3 / 24, 0, 1)

	local phase = p9.phase
	local v55 = math.clamp(n3 / 24, 0, 1)

	p9.phase = phase + p12 * 1.6 * 3.141592653589793 * 2 * (v55 + 0.4)
	n3 = math.sin(p9.phase) * (v49 * 0.9)
	n1 = function(p13, p14)
		local v102 = p9.joints[p13]

		if v102 then
			local motor = v102.motor
			local c0 = v102.c0
			local v105 = CFrame.Angles(p14, 0, 0)

			motor.C0 = c0 * v105
		end
	end
	v49 = p9.joints["Right Hip"]

	if v49 then
		local motor = v49.motor
		local c0 = v49.c0
		local v58 = CFrame.Angles(n3, 0, 0)

		motor.C0 = c0 * v58
	end

	v50 = p9.joints["Left Hip"]

	if v50 then
		local v59 = v50.motor
		local v60 = v50.c0
		local v61 = CFrame.Angles(-n3, 0, 0)

		v59.C0 = v60 * v61
	end

	v49 = math.clamp(p10.pitch, -1.2, 1.2)

	local v62 = bit32.band(p10.sflags, replayFormat.S_WEAPON_MASK)

	if bit32.rshift(v62, replayFormat.S_WEAPON_SHIFT) ~= replayFormat.WEAPON_NONE then
		local v63 = p9.joints["Right Shoulder"]

		if v63 then
			local v64 = v63.motor
			local v65 = v63.c0
			local v66 = CFrame.Angles(-1.5707963267948966 - v49, 0, 0)

			v64.C0 = v65 * v66
		end

		v63 = p9.joints["Left Shoulder"]

		if v63 then
			local v67 = v63.motor
			local v68 = v63.c0
			local v69 = CFrame.Angles(-n3 * 0.5, 0, 0)

			v67.C0 = v68 * v69

			return
		end
	else
		local v70 = p9.joints["Right Shoulder"]

		if v70 then
			local v71 = v70.motor
			local v72 = v70.c0
			local v73 = CFrame.Angles(-n3, 0, 0)

			v71.C0 = v72 * v73
		end

		local v74 = p9.joints["Left Shoulder"]

		if v74 then
			local v75 = v74.motor
			local v76 = v74.c0
			local v77 = CFrame.Angles(n3, 0, 0)

			v75.C0 = v76 * v77
		end
	end
end
function module.Destroy(p15)
	if p15 and p15.model then
		pcall(function()
			p15.model:Destroy()
		end)
	end
end
function module.SpawnTracer(parent, p17, p18, p19)
	local magnitude = (p18 - p17).Magnitude

	if magnitude < 0.5 or magnitude > 2000 then
		return nil
	end

	local replayTracer: Part = Instance.new("Part")

	replayTracer.Name = "ReplayTracer"
	replayTracer.Anchored = true
	replayTracer.CanCollide = false
	replayTracer.CanQuery = false
	replayTracer.CanTouch = false
	replayTracer.CastShadow = false
	replayTracer.Material = Enum.Material.Neon
	replayTracer.Color = p19 and Color3.fromRGB(255, 120, 120) or Color3.fromRGB(255, 240, 180)
	replayTracer.Size = Vector3.new(0.09, 0.09, magnitude)

	local cFrameLookAt = CFrame.lookAt
	local v86 = p17:Lerp(p18, 0.5)

	replayTracer.CFrame = cFrameLookAt(v86, p18)
	replayTracer.Transparency = 0.25
	replayTracer.Parent = parent

	return { life = 0.09, age = 0, kind = "tracer", inst = replayTracer }
end
function module.SpawnHitSpark(parent, p21, p22)
	local replayHit: Part = Instance.new("Part")

	replayHit.Name = "ReplayHit"
	replayHit.Anchored = true
	replayHit.CanCollide = false
	replayHit.CanQuery = false
	replayHit.CanTouch = false
	replayHit.CastShadow = false
	replayHit.Shape = Enum.PartType.Ball
	replayHit.Material = Enum.Material.Neon
	replayHit.Color = p22 and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(255, 210, 120)
	replayHit.Size = Vector3.new(0.7, 0.7, 0.7)
	replayHit.CFrame = CFrame.new(p21)
	replayHit.Transparency = 0.1
	replayHit.Parent = parent

	return { life = 0.35, age = 0, kind = "spark", inst = replayHit }
end
function module.StepEffects(p23, p24)
	local t3: {[any]: any} = {}

	for _, v in ipairs(p23) do
		v.age = v.age + p24

		if not (v.age >= v.life) and v.inst and v.inst.Parent then
			local n1 = v.age / v.life

			if v.kind == "spark" then
				v.inst.Size = Vector3.new(0.7 + n1 * 1.6, 0.7 + n1 * 1.6, 0.7 + n1 * 1.6)
			end

			v.inst.Transparency = 0.1 + n1 * 0.9
			table.insert(t3, v)
		elseif v.inst then
			pcall(function()
				v.inst:Destroy()
			end)
		end
	end

	return t3
end
function module.ClearEffects(p25)
	for _, v in ipairs(p25) do
		if v.inst then
			pcall(function()
				v.inst:Destroy()
			end)
		end
	end
end

return module
