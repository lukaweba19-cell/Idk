-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local tweenService: TweenService = game:GetService("TweenService")
local lighting: Lighting = game:GetService("Lighting")
local sound = require(game.ReplicatedStorage.Sound)
local debris = require(game.ReplicatedStorage.Util.Debris)
local forgeVFX = require(game.ReplicatedStorage.Util.ForgeVFX)
local cthulhu = game.ReplicatedStorage.FX.KillEffects.Cthulhu
local v8 = CFrame.Angles(-0.10471975511965978, 0, 0)
local v9 = CFrame.Angles(-0.20943951023931956, 0, 0)
local v10 = CFrame.Angles(0, 0, 1.8849555921538759)
local v11 = CFrame.Angles(0, 0, -1.8849555921538759)
local v12 = CFrame.Angles(0, 0, 0.4537856055185257)
local v13 = CFrame.Angles(0, 0, -0.4537856055185257)
local t1: {[any]: any} = { radius = 0.74, h0 = 0.6, h1 = -0.4, cf = CFrame.new(0, -0.55, 0) }
local t2: {[any]: any} = { radius = 0.74, h0 = 0.6, h1 = -0.4, cf = CFrame.new(0, -0.55, 0) }
local t3: {[any]: any} = { radius = 0.74, h0 = 0.6, h1 = -0.4, cf = CFrame.new(0, -0.55, 0) }
local t4: {[any]: any} = { radius = 0.74, h0 = 0.6, h1 = -0.4, cf = CFrame.new(0, -0.55, 0) }
local t5: {[any]: any} = { radius = 1.12, h0 = 0.35, h1 = -0.3, cf = CFrame.new(0, 0, 0) }
local t6: {[any]: any} = {
	"T01",
	"T02",
	"T03",
	"T04",
	"T05",
	"T06",
	"T07",
	"T08",
	"T09",
	"T10",
	"T11",
	"T12"
}
local n1: number = #t6

local function clamp01(p1)
	if p1 < 0 then
		return 0
	end

	if p1 > 1 then
		return 1
	end

	return p1
end
local function sineInOut(p2)
	return -(math.cos(3.141592653589793 * p2) - 1) / 2
end
local function quadOut(p3)
	return 1 - (1 - p3) * (1 - p3)
end
local function cubicOut(p4)
	return 1 - (1 - p4) ^ 3
end
local function backOut(p5)
	return (p5 - 1) ^ 3 * 2.70158 + 1 + (p5 - 1) ^ 2 * 1.70158
end
local function bezier(p6, p7, p8, p9, p10)
	local n1 = 1 - p10

	return p6 * (n1 * n1 * n1) + p7 * (n1 * 3 * n1 * p10) + p8 * (n1 * 3 * p10 * p10) + p9 * (p10 * p10 * p10)
end
local function emit(p11)
	local ok, result = pcall(forgeVFX.emit, p11)

	if not ok then
		local v53 = p11.Name
		local text: string = tostring(result)

		warn("[Cthulhu] emit failed on " .. v53 .. ": " .. text)
	end
end
local function stopEmitters(p12)
	for _, v in ipairs(p12:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v.Enabled = false
		end
	end
end
local function flashLight(p13, p14)
	p13.Range = p14.Range
	p13.Brightness = 0

	local tweenInfo = TweenInfo.new(p14.Up, Enum.EasingStyle.Linear)
	local v61: Tween = tweenService:Create(p13, tweenInfo, { Brightness = p14.Brightness })

	v61.Completed:Once(function()
		local tweenInfo2 = TweenInfo.new(p14.Down, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

		tweenService:Create(p13, tweenInfo2, { Brightness = 0 }):Play()
	end)
	v61:Play()
end
local function hidePart(p15, p16)
	p16.LocalTransparencyModifier = 1

	for _, v in ipairs(p16:GetDescendants()) do
		if v:IsA("BasePart") or v:IsA("Decal") then
			v.LocalTransparencyModifier = 1
		end
	end

	if p16.Name == "Head" then
		for _, v in ipairs(p15:GetChildren()) do
			if v:IsA("Accessory") then
				for _, iterValue in ipairs(v:GetDescendants()) do
					if iterValue:IsA("BasePart") or iterValue:IsA("Decal") then
						iterValue.LocalTransparencyModifier = 1
					end
				end
			end
		end
	end
end

local t7: {[any]: any} = {
	MaxDistance = 1000,
	FadeStart = 4.4,
	FadeTime = 1.1,
	CleanupAfter = 9,
	RetractTime = 0.35,
	Lift = 2.4,
	LiftTime = 0.6,
	Tremble = 0.09,
	ReachTime = 0.42,
	StrikeShare = 0.58,
	YankSize = 0.55,
	YankTime = 0.16,
	Underground = 16,
	MinSeg = 1,
	Grabs = {
		{
			limb = "Right Arm",
			base = Vector3.new(8.4, 0, -2),
			rip = Vector3.new(3, 2.4, -0.6),
			erupt = 0.28,
			spin = 1
		},
		{
			limb = "Left Arm",
			base = Vector3.new(-8.4, 0, 2),
			rip = Vector3.new(-3, 2.4, 0.6),
			erupt = 0.36,
			spin = -1
		},
		{
			limb = "Right Leg",
			base = Vector3.new(5.6, 0, 5.2),
			rip = Vector3.new(1.9, -1.1, 1.7),
			erupt = 0.44,
			spin = -1
		},
		{
			limb = "Left Leg",
			base = Vector3.new(-5.6, 0, -5.2),
			rip = Vector3.new(-1.9, -1.1, -1.7),
			erupt = 0.52,
			spin = 1
		},
		{
			limb = "Head",
			base = Vector3.new(0, 0, 8.6),
			rip = Vector3.new(0, 3.4, 1.2),
			erupt = 0.6,
			spin = 1
		}
	},
	TensionStart = 1,
	TensionPull = 0.6,
	RipTime = 1.75,
	PinchTime = 0.1,
	PinchKeep = 0.35,
	RipSnap = 0.17,
	Flail = 55,
	DragStart = 2,
	DragStagger = 0.06,
	DragTime = 0.55,
	TorsoSinkStart = 1.86,
	TorsoSinkTime = 0.8,
	EyeOpen = 2.15,
	EyeHeight = 4.2,
	EyeRise = 1.4,
	EyeRiseTime = 0.18,
	EyeBlinkAt = 0.84,
	EyeSinkTime = 0.12,
	EyeLight = { Brightness = 0.8, Range = 12 },
	CloseTime = 3.15,
	Flash = { Brightness = 7, Range = 34, Up = 0.02, Down = 0.4 },
	ShakeDistance = 70,
	TintDistance = 60
}

local function buildPath(p17, p18, p19, p20, p21, p22)
	local pts = p17.pts
	local len = p17.len

	table.clear(pts)
	table.clear(len)

	local w = (p19 * p20.cf).Position
	local upVector = p19.UpVector
	local n1 = p18 - w
	local v81 = n1:Dot(upVector)
	local n2 = n1 - upVector * v81

	n2 = if n2.Magnitude > 0.001 then n2.Unit else p19.RightVector
	n1 = upVector:Cross(n2)

	local n3 = w + upVector * p20.h0 + n2 * p20.radius

	v81 = math.max(2.6, (n3.Y - p18.Y) * 0.65)

	local n4 = p18 + Vector3.new(0, 1, 0) * v81

	v81 = n3 - n1 * (p21 * 2.3) + n2 * 1.1 + Vector3.new(0, 0.6, 0)

	if p22 then
		n4 += p22
		v81 += p22 * 0.5
	end

	pts[1] = p18 - Vector3.new(0, 1, 0) * t7.Underground
	pts[2] = p18

	for i = 1, 22 do
		local n5: number = i / 22
		local n6: number = 1 - n5

		pts[#pts + 1] = p18 * (n6 * n6 * n6) + n4 * (n6 * 3 * n6 * n5) + v81 * (n6 * 3 * n5 * n5) + n3 * (n5 * n5 * n5)
	end

	for i = 1, 8 do
		local n7: number = i / 8
		local n8 = n7 * (p21 * 5.759586531581287)
		local n9 = w + upVector * (p20.h0 + (p20.h1 - p20.h0) * n7)
		local cosine = math.cos(n8)
		local sine = math.sin(n8)

		pts[#pts + 1] = n9 + (n2 * cosine + n1 * sine) * p20.radius
	end

	v81 = 0
	len[1] = 0

	for i = 2, #pts do
		v81 += (pts[i] - pts[i - 1]).Magnitude
		len[i] = v81
	end

	p17.total = v81
	p17.coilStart = len[#pts]
	p17.W = w
	p17.axis = upVector
	p17.hint = 1
end
local function pointAt(p23, p24)
	local pts = p23.pts
	local len = p23.len

	if p24 <= 0 then
		return pts[1] + (pts[1] - pts[2]).Unit * -p24
	end

	local n1 = #pts

	if p24 >= len[n1] then
		return pts[n1]
	end

	local v100 = p23.hint

	if p24 < len[v100] then
		v100 = 1
	end

	while n1 > v100 and p24 > len[v100 + 1] do
		v100 += 1
	end

	p23.hint = v100
	n1 = len[v100 + 1] - len[v100]

	return pts[v100]:Lerp(pts[v100 + 1], if n1 > 0.000001 then (p24 - len[v100]) / n1 else 0)
end

local v34 = table.create(n1 + 1)

local function poseTentacle(p25, p26, p27, p28)
	for i = 1, n1 + 1 do
		v34[i] = pointAt(p26, p27 - (n1 + 1 - i) * p28)
	end

	local w = p26.W
	local axis = p26.axis
	local v108 = nil

	for i = 1, n1 do
		local v110 = v34[i]
		local n4 = v34[i + 1] - v110
		local v112 = if n4.Magnitude > 0.0001 then n4.Unit else Vector3.new(0, 1, 0)
		local v113 = (v110 - w):Dot(axis)
		local n2 = w + axis * v113 - v110
		local v115 = n2:Dot(v112)
		local n3 = n2 - v112 * v115
		local v117

		if n3.Magnitude > 0.001 then
			v117 = n3.Unit
		elseif v108 then
			local v118 = v108:Dot(v112)

			v117 = (v108 - v112 * v118).Unit
		else
			local v119 = v112:Cross(Vector3.new(1, 0, 0))

			v117 = if v119.Magnitude > 0.001 then v119.Unit else Vector3.new(0, 0, 1)
		end

		v108 = v117
		n3 = -v117
		v113 = v112:Cross(n3)
		p25.bones[i].WorldCFrame = CFrame.fromMatrix(v110, v113, v112, n3)
	end
end

local t8: {[any]: any} = {
	Torso = v8,
	Head = CFrame.new(0, 1.5, 0) * v9,
	["Right Arm"] = CFrame.new(1.25, 0.75, 0) * v10 * CFrame.new(0, -1, 0),
	["Left Arm"] = CFrame.new(-1.25, 0.75, 0) * v11 * CFrame.new(0, -1, 0),
	["Right Leg"] = CFrame.new(0.5, -1, 0) * v12 * CFrame.new(0, -1, 0),
	["Left Leg"] = CFrame.new(-0.5, -1, 0) * v13 * CFrame.new(0, -1, 0)
}
local t9: {[any]: any} = {
	["Right Arm"] = t1,
	["Left Arm"] = t2,
	["Right Leg"] = t3,
	["Left Leg"] = t4,
	Head = t5
}
local t10: {[any]: any} = {
	["Right Arm"] = Vector3.new(1, 0.75, 0),
	["Left Arm"] = Vector3.new(-1, 0.75, 0),
	["Right Leg"] = Vector3.new(0.5, -1, 0),
	["Left Leg"] = Vector3.new(-0.5, -1, 0),
	Head = Vector3.new(0, 1, 0)
}

return function(player)
	local Character = player.Character

	if not Character or not Character.Parent then
		return
	end

	local CurrentCamera: Camera = workspace.CurrentCamera
	local CFramePosition = CurrentCamera.CFrame.Position
	local pivot = Character:GetPivot()

	if (CFramePosition - pivot.Position).Magnitude > t7.MaxDistance then
		return
	end

	local torso = Character:FindFirstChild("Torso")

	if not torso or not torso:IsA("BasePart") then
		return
	end

	local _fx_Cthulhu: Folder = Instance.new("Folder")

	_fx_Cthulhu.Name = "_FX_Cthulhu"
	_fx_Cthulhu.Parent = workspace.Bin

	local u127: boolean = true
	local connection3 = nil
	local connection = nil
	local t11: {[any]: any} = {}
	local t12: {[any]: any} = {}
	local t13: {[any]: any} = {}
	local u133 = nil
	local u134: boolean = false
	local __FreezeAt = player.__FreezeAt

	local function own(p30)
		table.insert(t11, p30)

		return p30
	end
	local function cleanup()
		if not u127 then
			return
		end

		u127 = false

		if connection3 then
			connection3:Disconnect()
		end

		if connection then
			connection:Disconnect()
		end

		if u133 then
			pcall(function()
				u133:Destroy()
			end)
		end

		for _, v in ipairs(t11) do
			pcall(game.Destroy, v)
		end

		table.clear(t11)
		_fx_Cthulhu:Destroy()
	end

	connection = Character.AncestryChanged:Connect(function()
		if not Character:IsDescendantOf(game) then
			u134 = true

			for _, v in pairs(t12) do
				v.gone = true
			end

			if connection then
				connection:Disconnect()
			end
		end
	end)
	task.delay(t7.CleanupAfter, cleanup)

	local function at(p31, p32)
		if __FreezeAt and p31 > __FreezeAt then
			return
		end

		local taskDelay = task.delay
		local v261 = math.max(p31, 0)

		taskDelay(v261, function()
			if u127 then
				p32()
			end
		end)
	end

	local lookVector = torso.CFrame.LookVector
	local vector3 = Vector3.new(lookVector.X, 0, lookVector.Z)
	local u141 = if vector3.Magnitude > 0.05 then vector3.Unit else Vector3.new(0, 0, -1)
	local torsoPosition = torso.Position
	local t14 = { Character, workspace.Bin }
	local characters: Instance = workspace:FindFirstChild("Characters")

	if characters then
		table.insert(t14, characters)
	end

	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = t14
	t14 = workspace:Raycast(torsoPosition + Vector3.new(0, 2, 0), Vector3.new(0, -18, 0), raycastParams)

	local v146 = if t14 then t14.Position.Y else torsoPosition.Y - 3
	local v147 = math.max(torsoPosition.Y, v146 + 3)
	local vector32 = Vector3.new(torsoPosition.X, v147 + t7.Lift, torsoPosition.Z)

	t14 = CFrame.lookAt(vector32, vector32 + u141)

	for i, v in ipairs({ "Torso", "Head", "Right Arm", "Left Arm", "Right Leg", "Left Leg" }) do
		local v2 = Character:FindFirstChild(v)

		if v2 and v2:IsA("BasePart") then
			v2.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			v2.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			v2.Anchored = true
			t12[v] = {
				ripped = false,
				gone = false,
				part = v2,
				name = v,
				from = v2.CFrame,
				pose = t14 * t8[v],
				seed = i * 13
			}
		end
	end

	local clone = cthulhu.Ground:Clone()

	clone.CFrame = CFrame.new(vector32.X, v146 + 0.15, vector32.Z)
	clone.Parent = _fx_Cthulhu

	local cloneHold = clone.Hold
	local ok, result = pcall(forgeVFX.emit, cloneHold)

	if not ok then
		local cloneHoldName = cloneHold.Name
		local text: string = tostring(result)

		warn("[Cthulhu] emit failed on " .. cloneHoldName .. ": " .. text)
	end

	local cloneRise_Embers = clone.Rise_Embers
	local ok2, result2 = pcall(forgeVFX.emit, cloneRise_Embers)

	if not ok2 then
		local cloneRise_EmbersName = cloneRise_Embers.Name
		local text: string = tostring(result2)

		warn("[Cthulhu] emit failed on " .. cloneRise_EmbersName .. ": " .. text)
	end

	local cloneRise_Smoke = clone.Rise_Smoke
	local ok3, result3 = pcall(forgeVFX.emit, cloneRise_Smoke)

	if not ok3 then
		local cloneRise_SmokeName = cloneRise_Smoke.Name
		local text: string = tostring(result3)

		warn("[Cthulhu] emit failed on " .. cloneRise_SmokeName .. ": " .. text)
	end

	local cloneLight = clone.Light
	local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Sine)

	tweenService:Create(cloneLight, tweenInfo, { Brightness = 1.2 }):Play()
	sound:Play("KillEffects.Cthulhu.Open", clone)

	local v170, v171 = sound:Play("KillEffects.Cthulhu.Whispers", clone)

	u133 = v171

	local tentacles: Model = Instance.new("Model")

	tentacles.Name = "Tentacles"
	tentacles.Parent = _fx_Cthulhu

	local highlight: Highlight = Instance.new("Highlight")

	highlight.FillTransparency = 1
	highlight.OutlineColor = Color3.fromRGB(70, 255, 130)
	highlight.OutlineTransparency = 0.45
	highlight.DepthMode = Enum.HighlightDepthMode.Occluded
	highlight.Parent = tentacles

	for i, v in ipairs(t7.Grabs) do
		local v176 = t12[v.limb]

		if v176 then
			local v177 = t14:PointToWorldSpace(v.base)
			local vector33 = Vector3.new(v177.X, v146, v177.Z)

			v177 = t14:VectorToWorldSpace(v.rip)

			local v179 = t9[v.limb]
			local vSpin = v.spin
			local vErupt = v.erupt
			local n8 = v.erupt + t7.ReachTime * t7.StrikeShare
			local unit = v177.Unit
			local magnitude = v177.Magnitude
			local v185 = Random.new(i * 7):NextUnitVector()
			local n2 = t7.DragStart + (i - 1) * t7.DragStagger
			local minSeg = t7.MinSeg

			v177 = vector33 - v176.pose.Position

			local vector34 = Vector3.new(v177.X, v177.Y * 0.4, v177.Z)
			local t15: {[any]: any} = {
				tent = nil,
				hole = nil,
				done = false,
				def = v,
				limb = v176,
				base = vector33,
				grip = v179,
				spin = vSpin,
				erupt = vErupt,
				latch = n8,
				ripDir = unit,
				ripLen = magnitude,
				flailAxis = v185,
				dragAt = n2,
				path = {
					total = 0,
					coilStart = 0,
					hint = 1,
					pts = {},
					len = {}
				},
				seg = minSeg,
				yank = vector34.Unit
			}

			v176.grab = t15
			table.insert(t13, t15)
			n2 = v.erupt - 0.06

			local function v190()
				if u134 then
					return
				end

				local clone2 = cthulhu.Hole:Clone()

				clone2.CFrame = CFrame.new(vector33.X, v146 + 0.12, vector33.Z)
				clone2.Parent = _fx_Cthulhu
				t15.hole = clone2

				local clone2Hold = clone2.Hold
				local ok4, result4 = pcall(forgeVFX.emit, clone2Hold)

				if not ok4 then
					local clone2HoldName = clone2Hold.Name
					local text: string = tostring(result4)

					warn("[Cthulhu] emit failed on " .. clone2HoldName .. ": " .. text)
				end

				local clone2Rise = clone2.Rise
				local ok5, result5 = pcall(forgeVFX.emit, clone2Rise)

				if not ok5 then
					local clone2RiseName = clone2Rise.Name
					local text: string = tostring(result5)

					warn("[Cthulhu] emit failed on " .. clone2RiseName .. ": " .. text)
				end

				local clone2Erupt = clone2.Erupt
				local ok6, result6 = pcall(forgeVFX.emit, clone2Erupt)

				if not ok6 then
					local clone2EruptName = clone2Erupt.Name
					local text: string = tostring(result6)

					warn("[Cthulhu] emit failed on " .. clone2EruptName .. ": " .. text)
				end

				sound:Play("KillEffects.Cthulhu.Hole", clone2, nil, nil, nil, 0.12)
			end

			if not __FreezeAt or not (__FreezeAt < n2) then
				local taskDelay = task.delay
				local v192 = math.max(n2, 0)

				taskDelay(v192, function()
					if u127 then
						v190()
					end
				end)
			end

			local v193 = v.erupt

			local function v194()
				if u134 then
					return
				end

				local clone3 = cthulhu.Tentacle:Clone()

				clone3.CFrame = CFrame.new(vector33 + Vector3.new(0, 6, 0))

				local v279 = table.create(n1)

				for i2, iterValue in ipairs(t6) do
					v279[i2] = clone3:FindFirstChild(iterValue, true)
				end

				t15.tent = { mesh = clone3, bones = v279 }
				buildPath(t15.path, vector33, v176.part.CFrame, t15.grip, t15.spin)
				poseTentacle(t15.tent, t15.path, t7.Underground, t7.MinSeg)
				clone3.Parent = tentacles

				for _, iterValue2 in ipairs(clone3:GetDescendants()) do
					if iterValue2:IsA("ParticleEmitter") or iterValue2:IsA("PointLight") then
						iterValue2.Enabled = true
					end
				end

				sound:Play("KillEffects.Cthulhu.Whip", clone3, nil, nil, nil, 0.1)
			end

			if not __FreezeAt or not (__FreezeAt < v193) then
				local v195 = task.delay
				local v196 = math.max(v193, 0)

				v195(v196, function()
					if u127 then
						v194()
					end
				end)
			end

			local latch = t15.latch

			local function v198()
				local v284 = (v176.part.CFrame * t15.grip.cf).Position
				local clone4 = cthulhu.Latch:Clone()

				clone4.CFrame = CFrame.new(v284)
				clone4.Parent = _fx_Cthulhu

				local ok7, result7 = pcall(forgeVFX.emit, clone4)

				if not ok7 then
					local clone4Name = clone4.Name
					local text: string = tostring(result7)

					warn("[Cthulhu] emit failed on " .. clone4Name .. ": " .. text)
				end

				debris:AddItem(clone4, 1.5)
				sound:Play("KillEffects.Cthulhu.Latch", clone4, nil, nil, nil, 0.12)
				sound:Play("KillEffects.Cthulhu.LatchCrack", clone4, nil, nil, nil, 0.15)
			end

			if not __FreezeAt or not (__FreezeAt < latch) then
				local v199 = task.delay
				local v200 = math.max(latch, 0)

				v199(v200, function()
					if u127 then
						v198()
					end
				end)
			end
		end
	end

	local t16: {[any]: any} = {}
	local tensionStart = t7.TensionStart

	local function v203()
		if u134 then
			return
		end

		sound:Play("KillEffects.Cthulhu.Stretch", torso)

		for k, v in pairs(t10) do
			if t12[k] then
				local _CthulhuDrip: Attachment = Instance.new("Attachment")

				table.insert(t11, _CthulhuDrip)
				_CthulhuDrip.Name = "_CthulhuDrip"
				_CthulhuDrip.Position = v
				_CthulhuDrip.Parent = torso

				local clone5 = cthulhu.Drip:Clone()

				clone5.Parent = _CthulhuDrip
				clone5.Enabled = true
				table.insert(t16, clone5)
			end
		end
	end

	if not __FreezeAt or not (__FreezeAt < tensionStart) then
		local v204 = task.delay
		local v205 = math.max(tensionStart, 0)

		v204(v205, function()
			if u127 then
				v203()
			end
		end)
	end

	local ripTime = t7.RipTime

	local function v207()
		if u134 then
			return
		end

		local torsoCFrame = torso.CFrame
		local n1: number = 0

		for k, v in pairs(t10) do
			local v298 = t12[k]

			if v298 then
				v298.ripped = true

				local n2 = torsoCFrame * v
				local clone6 = cthulhu.Rip:Clone()

				clone6.CFrame = CFrame.lookAt(n2, n2 + (if v298.grab then v298.grab.ripDir else Vector3.new(0, 1, 0)))
				clone6.Parent = _fx_Cthulhu

				local ok8, result8 = pcall(forgeVFX.emit, clone6)

				if not ok8 then
					local clone6Name = clone6.Name
					local text: string = tostring(result8)

					warn("[Cthulhu] emit failed on " .. clone6Name .. ": " .. text)
				end

				debris:AddItem(clone6, 2)

				if n1 < 3 then
					task.delay(n1 * 0.035, function()
						if u127 then
							sound:Play("KillEffects.Cthulhu.Rip", clone6, nil, nil, nil, 0.1)
						end
					end)
				end

				n1 += 1

				for _, iterValue in ipairs(cthulhu.LimbTrail:GetChildren()) do
					local clone7 = iterValue:Clone()

					table.insert(t11, clone7)
					clone7.Parent = v298.part

					local ok9, result9 = pcall(forgeVFX.emit, clone7)

					if not ok9 then
						local clone7Name = clone7.Name
						local text: string = tostring(result9)

						warn("[Cthulhu] emit failed on " .. clone7Name .. ": " .. text)
					end

					debris:AddItem(clone7, 2.2)
				end
			end
		end

		local clone8 = cthulhu.RipCore:Clone()

		clone8.CFrame = CFrame.new(torsoCFrame.Position)
		clone8.Parent = _fx_Cthulhu

		local ok10, result10 = pcall(forgeVFX.emit, clone8)

		if not ok10 then
			local clone8Name = clone8.Name
			local text: string = tostring(result10)

			warn("[Cthulhu] emit failed on " .. clone8Name .. ": " .. text)
		end

		flashLight(clone8.Light, t7.Flash)
		debris:AddItem(clone8, 3)
		sound:Play("KillEffects.Cthulhu.Splat", clone8)
		sound:Play("KillEffects.Cthulhu.RipBoom", clone8)

		local magnitude = (CurrentCamera.CFrame.Position - vector32).Magnitude
		local _GShared = _G.Shared
		local _GSharedCamShaker = _GShared and _GShared.CamShaker

		if _GSharedCamShaker and magnitude < t7.ShakeDistance then
			_GSharedCamShaker:Shake("Explosion")
		end

		if magnitude < t7.TintDistance then
			local _CthulhuTint: ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

			table.insert(t11, _CthulhuTint)
			_CthulhuTint.Name = "_CthulhuTint"
			_CthulhuTint.TintColor = Color3.fromRGB(185, 255, 200)
			_CthulhuTint.Contrast = 0.12
			_CthulhuTint.Saturation = -0.1
			_CthulhuTint.Parent = lighting

			local tweenInfo3 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

			tweenService:Create(_CthulhuTint, tweenInfo3, { Contrast = 0, Saturation = 0, TintColor = Color3.new(1, 1, 1) }):Play()
			debris:AddItem(_CthulhuTint, 0.6)
		end
	end

	if not __FreezeAt or not (__FreezeAt < ripTime) then
		local v208 = task.delay
		local v209 = math.max(ripTime, 0)

		v208(v209, function()
			if u127 then
				v207()
			end
		end)
	end

	local n3 = t7.RipTime + 0.5

	local function v211()
		for _, v in ipairs(t16) do
			v.Enabled = false
		end
	end

	if not __FreezeAt or not (__FreezeAt < n3) then
		local v212 = task.delay
		local v213 = math.max(n3, 0)

		v212(v213, function()
			if u127 then
				v211()
			end
		end)
	end

	n3 = t7.DragStart - 0.05

	local function v214()
		sound:Play("KillEffects.Cthulhu.Drag", clone)
	end

	if not __FreezeAt or not (__FreezeAt < n3) then
		local v215 = task.delay
		local v216 = math.max(n3, 0)

		v215(v216, function()
			if u127 then
				v214()
			end
		end)
	end

	local clone9 = nil
	local n4 = t7.EyeOpen - 0.05

	local function v219()
		sound:Play("KillEffects.Cthulhu.Roar", clone)
	end

	if not __FreezeAt or not (__FreezeAt < n4) then
		local v220 = task.delay
		local v221 = math.max(n4, 0)

		v220(v221, function()
			if u127 then
				v219()
			end
		end)
	end

	local n5 = Vector3.new(vector32.X, v146 + t7.EyeHeight, vector32.Z) - u141 * 0.6
	local cFrame = CFrame.new(n5 - Vector3.new(0, 1, 0) * t7.EyeRise)
	local eyeOpen = t7.EyeOpen

	local function v225()
		clone9 = cthulhu.Eye:Clone()
		clone9.CFrame = cFrame
		clone9.Parent = _fx_Cthulhu

		local clone9Open = clone9.Open
		local ok11, result11 = pcall(forgeVFX.emit, clone9Open)

		if not ok11 then
			local clone9OpenName = clone9Open.Name
			local text: string = tostring(result11)

			warn("[Cthulhu] emit failed on " .. clone9OpenName .. ": " .. text)
		end

		local v329 = clone9
		local tweenInfo4 = TweenInfo.new(t7.EyeRiseTime, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		local cFrame2 = CFrame.new(n5)

		tweenService:Create(v329, tweenInfo4, { CFrame = cFrame2 }):Play()
		tweenService:Create(clone9.Light, TweenInfo.new(0.15), { Brightness = t7.EyeLight.Brightness, Range = t7.EyeLight.Range }):Play()
	end

	if not __FreezeAt or not (__FreezeAt < eyeOpen) then
		local v226 = task.delay
		local v227 = math.max(eyeOpen, 0)

		v226(v227, function()
			if u127 then
				v225()
			end
		end)
	end

	local n6 = t7.EyeOpen + t7.EyeBlinkAt

	local function v229()
		if not clone9 then
			return
		end

		local v332 = clone9
		local tweenInfo5 = TweenInfo.new(t7.EyeSinkTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

		tweenService:Create(v332, tweenInfo5, { CFrame = cFrame }):Play()

		local clone9Light = clone9.Light
		local tweenInfo6 = TweenInfo.new(t7.EyeSinkTime)

		tweenService:Create(clone9Light, tweenInfo6, { Brightness = 0 }):Play()
	end

	if not __FreezeAt or not (__FreezeAt < n6) then
		local v230 = task.delay
		local v231 = math.max(n6, 0)

		v230(v231, function()
			if u127 then
				v229()
			end
		end)
	end

	n6 = t7.CloseTime - 0.26

	local function v232()
		local clone10 = cthulhu.Close:Clone()

		clone10.CFrame = CFrame.new(vector32.X, v146 + 0.2, vector32.Z)
		clone10.Parent = _fx_Cthulhu

		local ok12, result12 = pcall(forgeVFX.emit, clone10)

		if not ok12 then
			local clone10Name = clone10.Name
			local text: string = tostring(result12)

			warn("[Cthulhu] emit failed on " .. clone10Name .. ": " .. text)
		end

		task.delay(0.26, function()
			if u127 then
				flashLight(clone10.Light, { Brightness = 8, Range = 30, Up = 0.02, Down = 0.5 })
			end
		end)
		sound:Play("KillEffects.Cthulhu.Implode", clone10)

		if u133 then
			pcall(function()
				sound.FadeOut(u133, 0.6)
			end)
			u133 = nil
		end
	end

	if not __FreezeAt or not (__FreezeAt < n6) then
		local v233 = task.delay
		local v234 = math.max(n6, 0)

		v233(v234, function()
			if u127 then
				v232()
			end
		end)
	end

	local closeTime = t7.CloseTime

	local function v236()
		stopEmitters(clone)

		local cloneBurst = clone.Burst
		local ok13, result13 = pcall(forgeVFX.emit, cloneBurst)

		if not ok13 then
			local cloneBurstName = cloneBurst.Name
			local text: string = tostring(result13)

			warn("[Cthulhu] emit failed on " .. cloneBurstName .. ": " .. text)
		end

		local cloneRadial = clone.Radial
		local ok14, result14 = pcall(forgeVFX.emit, cloneRadial)

		if not ok14 then
			local cloneRadialName = cloneRadial.Name
			local text: string = tostring(result14)

			warn("[Cthulhu] emit failed on " .. cloneRadialName .. ": " .. text)
		end

		local cloneResidue_Mist = clone.Residue_Mist
		local ok15, result15 = pcall(forgeVFX.emit, cloneResidue_Mist)

		if not ok15 then
			local cloneResidue_MistName = cloneResidue_Mist.Name
			local text: string = tostring(result15)

			warn("[Cthulhu] emit failed on " .. cloneResidue_MistName .. ": " .. text)
		end

		local cloneResidue_Embers = clone.Residue_Embers
		local ok16, result16 = pcall(forgeVFX.emit, cloneResidue_Embers)

		if not ok16 then
			local cloneResidue_EmbersName = cloneResidue_Embers.Name
			local text: string = tostring(result16)

			warn("[Cthulhu] emit failed on " .. cloneResidue_EmbersName .. ": " .. text)
		end

		tweenService:Create(clone.Light, TweenInfo.new(0.5), { Brightness = 0 }):Play()

		if clone9 then
			tweenService:Create(clone9.Light, TweenInfo.new(0.2), { Brightness = 0 }):Play()
		end

		for _, v in ipairs(t13) do
			if v.hole then
				stopEmitters(v.hole)
			end
		end
	end

	if not __FreezeAt or not (__FreezeAt < closeTime) then
		local v237 = task.delay
		local v238 = math.max(closeTime, 0)

		v237(v238, function()
			if u127 then
				v236()
			end
		end)
	end

	local function fadedSequence(p33, p34)
		local t19: {[any]: any} = {}

		for _, v in ipairs(p33.Keypoints) do
			local n1 = v.Value + (1 - v.Value) * p34
			local v369 = math.min(v.Envelope * (1 - p34), n1, 1 - n1)
			local numberSequenceKeypointNew = NumberSequenceKeypoint.new
			local vTime = v.Time
			local v372 = math.max(v369, 0)

			table.insert(t19, numberSequenceKeypointNew(vTime, n1, v372))
		end

		return NumberSequence.new(t19)
	end

	local fadeStart = t7.FadeStart

	local function v241()
		local tweenInfo7 = TweenInfo.new(t7.FadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local t20: {[any]: any} = {}

		local function wind(p35)
			if p35:IsA("ParticleEmitter") then
				p35.Enabled = false
				table.insert(t20, { e = p35, seq = p35.Transparency })

				return
			end

			if not p35:IsA("Beam") and not p35:IsA("Trail") then
				if p35:IsA("Light") then
					tweenService:Create(p35, tweenInfo7, { Brightness = 0 }):Play()

					return
				end

				if p35:IsA("Highlight") then
					tweenService:Create(p35, tweenInfo7, { OutlineTransparency = 1, FillTransparency = 1 }):Play()

					return
				end

				if p35:IsA("Sound") then
					local tweenInfo8 = TweenInfo.new(t7.FadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

					tweenService:Create(p35, tweenInfo8, { Volume = 0 }):Play()

					return
				end

				if p35:IsA("BasePart") and p35.Transparency < 1 then
					tweenService:Create(p35, tweenInfo7, { Transparency = 1 }):Play()
				end

				return
			end

			p35.Enabled = false
		end

		for _, v in ipairs(_fx_Cthulhu:GetDescendants()) do
			wind(v)
		end

		for _, v in ipairs(t11) do
			if v.Parent then
				wind(v)

				for _, iterValue in ipairs(v:GetDescendants()) do
					wind(iterValue)
				end
			end
		end

		if u133 then
			pcall(function()
				sound.FadeOut(u133, t7.FadeTime)
			end)
			u133 = nil
		end

		local v382 = os.clock()
		local connection2 = nil

		connection2 = runService.Heartbeat:Connect(function()
			local v469 = os.clock()
			local v470 = math.clamp((v469 - v382) / t7.FadeTime, 0, 1)

			v470 = v470 * v470 * (3 - v470 * 2)

			for _, v in ipairs(t20) do
				if v.e.Parent then
					v.e.Transparency = fadedSequence(v.seq, v470)
				end
			end

			if v470 >= 1 or not u127 then
				connection2:Disconnect()
				cleanup()
			end
		end)
	end

	if not __FreezeAt or not (__FreezeAt < fadeStart) then
		local v242 = task.delay
		local v243 = math.max(fadeStart, 0)

		v242(v243, function()
			if u127 then
				v241()
			end
		end)
	end

	local v244 = os.clock()
	local strikeShare = t7.StrikeShare
	local n7 = t7.RipTime - t7.PinchTime

	local function tensionPull(p36)
		if p36 < t7.TensionStart then
			return 0
		end

		if p36 < n7 then
			local n1 = (p36 - t7.TensionStart) / (n7 - t7.TensionStart)

			return t7.TensionPull * (if n1 < 0 then 0 else if n1 > 1 then 1 else n1) ^ 1.6
		end

		if p36 < t7.RipTime then
			local n2 = (p36 - n7) / t7.PinchTime
			local n3 = if n2 < 0 then 0 else if n2 > 1 then 1 else n2

			return t7.TensionPull * (1 - (1 - t7.PinchKeep) * (1 - (1 - n3) * (1 - n3)))
		end

		return t7.TensionPull * t7.PinchKeep
	end
	local function noise3(p37, p38)
		local v390 = math.noise(p37 * 23, p38)
		local v391 = math.noise(p37 * 19, p38 + 7)
		local vector35 = Vector3.new(v390, v391, math.noise(p37 * 21, p38 + 13))

		return vector35
	end
	local function partCF(p39, p40)
		local n1 = p40 / t7.LiftTime
		local cosine = math.cos(3.141592653589793 * (if n1 < 0 then 0 else if n1 > 1 then 1 else n1))
		local v397 = p39.from:Lerp(p39.pose, -(cosine - 1) / 2)
		local grab = p39.grab

		n1 = tensionPull(p40)

		local n2 = (p40 - t7.TensionStart) / (t7.RipTime - t7.TensionStart)
		local n3 = if n2 < 0 then 0 else if n2 > 1 then 1 else n2

		if p39.name ~= "Torso" then
			if not grab then
				return v397
			end

			if p40 > grab.latch then
				local n4 = (p40 - grab.latch) / t7.YankTime

				if n4 < 1 then
					local grabYank = grab.yank
					local yankSize = t7.YankSize
					local sine = math.sin(3.141592653589793 * n4)

					v397 += grabYank * (yankSize * sine)
				end
			end

			if p40 < t7.RipTime then
				local n5 = grab.ripDir * n1
				local seed = p39.seed
				local v407 = math.noise(p40 * 23, seed)
				local v408 = math.noise(p40 * 19, seed + 7)
				local vector36 = Vector3.new(v407, v408, math.noise(p40 * 21, seed + 13))

				return v397 + (n5 + vector36 * (t7.Tremble * n3))
			end

			local n6 = (p40 - t7.RipTime) / t7.RipSnap
			local n7 = if n6 < 0 then 0 else if n6 > 1 then 1 else n6
			local n8 = (n7 - 1) ^ 3 * 2.70158 + 1 + (n7 - 1) ^ 2 * 1.70158

			n7 = n1 + (grab.ripLen - n1) * n8

			local n9 = p40 * 0.4
			local n10 = p39.seed + 3
			local v415 = math.noise(n9 * 23, n10)
			local v416 = math.noise(n9 * 19, n10 + 7)
			local vector37 = Vector3.new(v415, v416, math.noise(n9 * 21, n10 + 13))

			n6 = v397 + grab.ripDir * n7 + vector37 * 0.25

			local cFrameFromAxisAngle = CFrame.fromAxisAngle
			local grabFlailAxis = grab.flailAxis

			v415 = math.rad(t7.Flail)
			n9 = cFrameFromAxisAngle(grabFlailAxis, v415 * n8)

			local n11 = n6 * n9

			n7 = (p40 - grab.dragAt) / t7.DragTime

			if n7 > 0 then
				if not grab.dragFrom then
					grab.dragFrom = n11
				end

				local v421 = grab.dragFrom.Position
				local vector38 = Vector3.new(v421.X - vector32.X, 0, v421.Z - vector32.Z)
				local n12 = (if n7 < 0 then 0 else if n7 > 1 then 1 else n7) ^ 1.7
				local n13 = 1 - n12
				local n14 = v421 * (n13 * n13 * n13) + (v421 + Vector3.new(0, 1.8, 0) + (if vector38.Magnitude > 0.1 then vector38.Unit else u141) * 1.2) * (n13 * 3 * n13 * n12) + (grab.base + Vector3.new(0, 3.2, 0)) * (n13 * 3 * n12 * n12) + (grab.base - Vector3.new(0, 3.6, 0)) * (n12 * n12 * n12)
				local rotation = grab.dragFrom.Rotation
				local v427 = CFrame.fromAxisAngle(grab.flailAxis, n12 * 9.42477796076938 * grab.spin)

				n11 = CFrame.new(n14) * (rotation * v427)
			end

			return n11
		end

		if p40 < t7.RipTime then
			local v428 = p39.seed
			local v429 = math.noise(p40 * 23, v428)
			local v430 = math.noise(p40 * 19, v428 + 7)
			local vector39 = Vector3.new(v429, v430, math.noise(p40 * 21, v428 + 13))

			return v397 + vector39 * (t7.Tremble * 0.6 * n3)
		end

		local n15 = (p40 - t7.RipTime) / 0.1
		local n16 = if n15 < 0 then 0 else if n15 > 1 then 1 else n15
		local n17 = v397 - Vector3.new(0, 1, 0) * ((1 - (1 - n16) * (1 - n16)) * 0.35)
		local n18 = (p40 - t7.TorsoSinkStart) / t7.TorsoSinkTime

		n2 = if n18 < 0 then 0 else if n18 > 1 then 1 else n18

		if n2 > 0 then
			local n19 = n17 - Vector3.new(0, 1, 0) * ((n17.Position.Y - (v146 - 3.5)) * (n2 * n2))
			local v437 = CFrame.Angles(n2 * 1.2217304763960306 * n2, 0, n2 * 0.4363323129985824)

			n17 = n19 * v437
		end

		return n17
	end

	local t17: {[any]: any} = {}
	local t18: {[any]: any} = {}

	connection3 = runService.Heartbeat:Connect(function()
		if not u127 then
			return
		end

		local n11 = os.clock() - v244

		if __FreezeAt then
			n11 = math.min(n11, __FreezeAt)
		end

		table.clear(t17)
		table.clear(t18)

		for _, v in pairs(t12) do
			if not v.gone and v.part.Parent then
				local v441 = partCF(v, n11)

				v.cf = v441
				table.insert(t17, v.part)
				table.insert(t18, v441)

				local vGrab = v.grab
				local u443

				if vGrab then
					u443 = true

					if not (n11 > vGrab.dragAt + t7.DragTime) then
						u443 = false

						if v.name == "Torso" then
							u443 = n11 > t7.TorsoSinkStart + t7.TorsoSinkTime
						end
					end
				else
					u443 = false

					if v.name == "Torso" then
						u443 = n11 > t7.TorsoSinkStart + t7.TorsoSinkTime
					end
				end

				if u443 then
					v.gone = true
					hidePart(Character, v.part)
				end
			end
		end

		if #t17 > 0 then
			workspace:BulkMoveTo(t17, t18, Enum.BulkMoveMode.FireCFrameChanged)
		end

		for _, v in ipairs(t13) do
			local vTent = v.tent

			if vTent and not v.done then
				local v447 = v.limb.cf or v.limb.part.CFrame
				local vector310 = Vector3.new(-(v.base.Z - vector32.Z), 0, v.base.X - vector32.X)

				vector310 = if vector310.Magnitude > 0.1 then vector310.Unit else Vector3.new(1, 0, 0)

				local n2 = (n11 - t7.TensionStart) / (t7.RipTime - t7.TensionStart)

				n2 = (if n2 < 0 then 0 else if n2 > 1 then 1 else n2) * 0.9 + 0.7

				local sine = math.sin(n11 * 5.3 + v.erupt * 20)
				local sine2 = math.sin(n11 * 4.1 + v.erupt * 9)

				buildPath(v.path, v.base, v447, v.grip, v.spin, vector310 * (sine * n2) + Vector3.new(0, 1, 0) * (sine2 * n2 * 0.5))

				local v452 = math.max(t7.MinSeg, (v.path.total - t7.Underground + 0.6) / n1)
				local n3 = (n11 - v.erupt) / t7.ReachTime
				local n4 = if n3 < 0 then 0 else if n3 > 1 then 1 else n3
				local n5 = v.path.coilStart - t7.Underground
				local n6 = (n4 - strikeShare) / (1 - strikeShare)
				local n7 = t7.Underground + (if n4 < strikeShare then n5 * (1 - (1 - n4 / strikeShare) ^ 3) else n5 + (v.path.total - v.path.coilStart) * (1 - (1 - n6) * (1 - n6)))

				if v.limb.gone and not v.retractFrom then
					v.retractFrom = n11
					v.retractTip = n7
					v.retractSeg = v452
				end

				local u458: boolean = false

				if v.retractFrom then
					local n8 = (n11 - v.retractFrom) / t7.RetractTime
					local n9 = if n8 < 0 then 0 else if n8 > 1 then 1 else n8

					v452 = v.retractSeg
					n7 = v.retractTip + (t7.Underground - 0.5 - v.retractTip) * (n9 * n9)
					u458 = n9 >= 1
				end

				poseTentacle(vTent, v.path, n7, v452)

				if u458 then
					v.done = true
					vTent.mesh:Destroy()

					if v.hole then
						stopEmitters(v.hole.Hold)
						stopEmitters(v.hole.Rise)

						local close = v.hole.Close
						local ok17, result17 = pcall(forgeVFX.emit, close)

						if not ok17 then
							local closeName = close.Name
							local text: string = tostring(result17)

							warn("[Cthulhu] emit failed on " .. closeName .. ": " .. text)
						end
					end
				end
			end
		end

		if clone.Parent and n11 > t7.TensionStart and n11 < t7.RipTime then
			local n10 = (n11 - t7.TensionStart) / 0.7

			clone.Light.Brightness = math.sin(n11 * 30) * 0.8 * (if n10 < 0 then 0 else if n10 > 1 then 1 else n10) + 1.2
		end
	end)
end
