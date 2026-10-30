-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local tweenService: TweenService = game:GetService("TweenService")
local lighting: Lighting = game:GetService("Lighting")
local sound = require(game.ReplicatedStorage.Sound)
local debris = require(game.ReplicatedStorage.Util.Debris)
local forgeVFX = require(game.ReplicatedStorage.Util.ForgeVFX)
local soulscourge = game.ReplicatedStorage.FX.KillEffects.Soulscourge
local color3 = Color3.fromRGB(150, 156, 166)
local t1 = { limb = "Torso", angle = 180, grab = CFrame.new(0, 0, 0) }
local t2: {[any]: any} = { limb = "Right Arm", angle = 70, grab = CFrame.new(0, -0.75, 0) }
local t3: {[any]: any} = { limb = "Left Arm", angle = -70, grab = CFrame.new(0, -0.75, 0) }
local t4: {[any]: any} = { limb = "Right Leg", angle = 135, grab = CFrame.new(0, -0.8, 0) }
local t5: {[any]: any} = { limb = "Left Leg", angle = -135, grab = CFrame.new(0, -0.8, 0) }
local color32 = Color3.fromRGB(130, 195, 255)
local color33 = Color3.fromRGB(208, 225, 255)
local t6: {[any]: any} = {
	MaxDistance = 1000,
	SeizeIn = 0.04,
	SeizeTime = 0.22,
	KneelTime = 0.32,
	ProneStart = 1.75,
	ProneTime = 0.36,
	DrainTime = 0.6,
	HuskColor = color3,
	ChainStart = 0.16,
	ChainStagger = 0.055,
	ChainTravel = 0.14,
	LinkPitch = 0.5,
	MaxLinks = 26,
	RimRadius = 3.4,
	TautTime = 0.55,
	Chains = { t1, t2, t3, t4, t5 },
	TearStart = 0.55,
	RipTime = 1.15,
	TearLift = 2.2,
	RipRise = 0.34,
	HoverHeight = 6.6,
	Tugs = { 1.6, 1.98 },
	TugDepth = 1.2,
	DragWindup = 2.25,
	DragStart = 2.37,
	DragTime = 0.26,
	SoulColor = color32,
	SoulAlpha = 0.6,
	HighlightFill = 0.8,
	HighlightOutline = 0,
	CloseTime = 3.3,
	RipFlash = { Brightness = 8, Range = 30, Up = 0.02, Down = 0.45 },
	ImpactFlash = { Brightness = 14, Range = 46, Up = 0.02, Down = 0.7 },
	ShakeDistance = 70,
	PostDistance = 80,
	Desat = {
		Saturation = -1,
		Contrast = 0.2,
		Brightness = -0.03,
		TintColor = color33
	},
	DesatIn = 0.25,
	DesatOutStart = 3.2,
	DesatOutTime = 1.4,
	SpiralCount = 14,
	SpiralTime = 1.1,
	SpiralHeight = 19,
	FadeStart = 3.9,
	FadeTime = 1,
	CleanupAfter = 8
}

t6.ImpactTime = t6.DragStart + t6.DragTime

local t7: {[any]: any} = { "Torso", "Head", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }

t1 = function(p1, p2, p3, p4, p5, p6)
	local cFrame = CFrame.new(p2, p3, 0)
	local cFrameAngles = CFrame.Angles
	local v45 = math.rad(p4)
	local v46 = math.rad(p5)
	local v47 = cFrameAngles(v45, 0, v46)
	local cFrame2 = CFrame.new(0, -p6, 0)

	return p1 * cFrame * v47 * cFrame2
end

local function poseSeize()
	local v49 = CFrame.Angles(0.4188790204786391, 0, 0)
	local n1 = CFrame.new(0, 3.4, 0.1) * v49
	local v51 = CFrame.Angles(0.6283185307179586, 0, 0)
	local v52 = CFrame.Angles(-0.5585053606381855, 0, 1.0122909661567112)
	local v53 = CFrame.Angles(-0.5585053606381855, 0, -1.0122909661567112)
	local v54 = CFrame.Angles(-0.3490658503988659, 0, 0.06981317007977318)
	local v55 = CFrame.Angles(-0.2792526803190927, 0, -0.06981317007977318)

	return {
		Torso = n1,
		Head = n1 * CFrame.new(0, 1.5, 0.15) * v51,
		["Right Arm"] = n1 * CFrame.new(1.5, 0.5, 0) * v52 * CFrame.new(0, -0.5, 0),
		["Left Arm"] = n1 * CFrame.new(-1.5, 0.5, 0) * v53 * CFrame.new(0, -0.5, 0),
		["Right Leg"] = n1 * CFrame.new(0.5, -1, 0) * v54 * CFrame.new(0, -1, 0),
		["Left Leg"] = n1 * CFrame.new(-0.5, -1, 0) * v55 * CFrame.new(0, -1, 0)
	}
end
local function poseKneel()
	local v56 = CFrame.Angles(-0.5235987755982988, 0, 0)
	local n1 = CFrame.new(0, 1.75, 0) * v56
	local v58 = CFrame.Angles(-0.8377580409572782, 0, 0.24434609527920614)
	local v59 = CFrame.Angles(0.4537856055185257, 0, 0.06981317007977318)
	local v60 = CFrame.Angles(0.3839724354387525, 0, -0.06981317007977318)
	local v61 = CFrame.Angles(-1.1519173063162575, 0, 0)
	local v62 = CFrame.Angles(-1.2217304763960306, 0, 0)

	return {
		Torso = n1,
		Head = n1 * CFrame.new(0, 1.45, -0.15) * v58,
		["Right Arm"] = n1 * CFrame.new(1.5, 0.5, 0) * v59 * CFrame.new(0, -0.5, 0),
		["Left Arm"] = n1 * CFrame.new(-1.5, 0.5, 0) * v60 * CFrame.new(0, -0.5, 0),
		["Right Leg"] = CFrame.new(0.5, 0.87, 0.37) * v61 * CFrame.new(0, -1, 0),
		["Left Leg"] = CFrame.new(-0.5, 0.87, 0.37) * v62 * CFrame.new(0, -1, 0)
	}
end
local function poseProne()
	local v63 = CFrame.Angles(-1.5707963267948966, 0, 0)
	local n1 = CFrame.new(0, 0.5, -1.3) * v63
	local v65 = CFrame.Angles(0, 1.3089969389957472, 0)
	local v66 = CFrame.Angles(0, 0, 0.13962634015954636)
	local v67 = CFrame.Angles(0, 0, -0.24434609527920614)
	local v68 = CFrame.Angles(0, 0, 0.06981317007977318)
	local v69 = CFrame.Angles(0, 0, -0.10471975511965978)

	return {
		Torso = n1,
		Head = n1 * CFrame.new(0, 1.5, 0) * v65,
		["Right Arm"] = n1 * CFrame.new(1.55, 0.1, 0) * v66,
		["Left Arm"] = n1 * CFrame.new(-1.55, 0.3, 0) * v67,
		["Right Leg"] = n1 * CFrame.new(0.55, -2, 0) * v68,
		["Left Leg"] = n1 * CFrame.new(-0.55, -2, 0) * v69
	}
end
local function poseReach()
	local v70 = CFrame.Angles(0.20943951023931956, 0, 0)
	local v71 = CFrame.Angles(0.5585053606381855, 0, 0)
	local v72 = CFrame.Angles(-0.2617993877991494, 0, 2.6179938779914944)
	local v73 = CFrame.Angles(-0.2617993877991494, 0, -2.6179938779914944)
	local v74 = CFrame.Angles(0.3141592653589793, 0, 0.13962634015954636)
	local v75 = CFrame.Angles(0.4188790204786391, 0, -0.12217304763960307)

	return {
		Torso = v70,
		Head = v70 * CFrame.new(0, 1.5, 0.15) * v71,
		["Right Arm"] = v70 * CFrame.new(1.5, 0.5, 0) * v72 * CFrame.new(0, -0.5, 0),
		["Left Arm"] = v70 * CFrame.new(-1.5, 0.5, 0) * v73 * CFrame.new(0, -0.5, 0),
		["Right Leg"] = v70 * CFrame.new(0.5, -1, 0) * v74 * CFrame.new(0, -1, 0),
		["Left Leg"] = v70 * CFrame.new(-0.5, -1, 0) * v75 * CFrame.new(0, -1, 0)
	}
end
local function poseDrag()
	local v76 = CFrame.Angles(-0.10471975511965978, 0, 0)
	local v77 = CFrame.Angles(0.7330382858376184, 0, 0)
	local v78 = CFrame.Angles(-0.13962634015954636, 0, 3.001966313430247)
	local v79 = CFrame.Angles(-0.13962634015954636, 0, -3.001966313430247)
	local v80 = CFrame.Angles(-0.06981317007977318, 0, 0.026179938779914945)
	local v81 = CFrame.Angles(-0.03490658503988659, 0, -0.026179938779914945)

	return {
		Torso = v76,
		Head = v76 * CFrame.new(0, 1.5, 0.2) * v77,
		["Right Arm"] = v76 * CFrame.new(1.5, 0.5, 0) * v78 * CFrame.new(0, -0.5, 0),
		["Left Arm"] = v76 * CFrame.new(-1.5, 0.5, 0) * v79 * CFrame.new(0, -0.5, 0),
		["Right Leg"] = v76 * CFrame.new(0.5, -1, 0) * v80 * CFrame.new(0, -1, 0),
		["Left Leg"] = v76 * CFrame.new(-0.5, -1, 0) * v81 * CFrame.new(0, -1, 0)
	}
end

local v23 = CFrame.Angles(1.5707963267948966, 0, 0)
local v24 = CFrame.Angles(0, 0, 1.5707963267948966)
local v25 = CFrame.Angles(1.5707963267948966, 0, 0)
local n1 = v24 * v25

v24 = function(p7)
	if p7 < 0 then
		return 0
	end

	if p7 > 1 then
		return 1
	end

	return p7
end
v25 = function(p8)
	return p8 * p8
end

local function quadOut(p9)
	return 1 - (1 - p9) * (1 - p9)
end
local function smooth(p10)
	return p10 * p10 * (3 - p10 * 2)
end
local function backOut(p11)
	return (p11 - 1) ^ 3 * 2.70158 + 1 + (p11 - 1) ^ 2 * 1.70158
end
local function bezier(p12, p13, p14, p15)
	local n1 = 1 - p15

	return p12 * (n1 * n1) + p13 * (n1 * 2 * p15) + p14 * (p15 * p15)
end
local function bezierTangent(p16, p17, p18, p19)
	return (p17 - p16) * ((1 - p19) * 2) + (p18 - p17) * (p19 * 2)
end
local function axisFrame(p20, p21)
	local v98 = p21:Dot(Vector3.new(0, 1, 0))
	local v99 = if math.abs(v98) > 0.95 then Vector3.new(1, 0, 0) else Vector3.new(0, 1, 0)
	local v100 = v99:Dot(p21)

	return CFrame.fromMatrix(p20, p21, (v99 - p21 * v100).Unit)
end
local function emit(p22)
	if not p22 then
		return
	end

	local ok, result = pcall(forgeVFX.emit, p22)

	if not ok then
		local v104 = p22.Name
		local text: string = tostring(result)

		warn("[Soulscourge] emit failed on " .. v104 .. ": " .. text)
	end
end
local function stopEmitters(p23)
	for _, v in ipairs(p23:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v.Enabled = false
		end
	end
end
local function flashLight(p24, p25)
	p24.Range = p25.Range
	p24.Brightness = 0

	local tweenInfo = TweenInfo.new(p25.Up, Enum.EasingStyle.Linear)
	local v112: Tween = tweenService:Create(p24, tweenInfo, { Brightness = p25.Brightness })

	v112.Completed:Once(function()
		local tweenInfo2 = TweenInfo.new(p25.Down, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

		tweenService:Create(p24, tweenInfo2, { Brightness = 0 }):Play()
	end)
	v112:Play()
end
local function ghostCopy(p26)
	local v115

	if p26:IsA("MeshPart") then
		local ok, result = pcall(function()
			local archivable = p26.Archivable

			p26.Archivable = true

			local clone = p26:Clone()

			p26.Archivable = archivable

			return clone
		end)

		if not ok or not result then
			return nil
		end

		result:ClearAllChildren()
		pcall(function()
			result.TextureID = ""
		end)
		v115 = result
	else
		local part: Part = Instance.new("Part")

		part.Size = p26.Size

		if p26:IsA("Part") then
			part.Shape = p26.Shape
		end

		for _, v in ipairs(p26:GetChildren()) do
			if v:IsA("DataModelMesh") then
				local clone = v:Clone()

				if clone:IsA("SpecialMesh") then
					clone.TextureId = ""
				end

				clone.Parent = part
			end
		end

		v115 = part
	end

	local v122 = v115

	v122.Name = p26.Name
	v122.Anchored = true
	v122.CanCollide = false
	v122.CanQuery = false
	v122.CanTouch = false
	v122.CastShadow = false
	v122.Massless = true
	v122.Material = Enum.Material.Neon
	v122.Color = t6.SoulColor
	v122.Transparency = 1
	v122.Reflectance = 0

	return v122
end

return function(player)
	local Character = player.Character

	if not Character or not Character.Parent then
		return
	end

	local CurrentCamera: Camera = workspace.CurrentCamera
	local CFramePosition = CurrentCamera.CFrame.Position
	local pivot = Character:GetPivot()

	if (CFramePosition - pivot.Position).Magnitude > t6.MaxDistance then
		return
	end

	local torso = Character:FindFirstChild("Torso")

	if not torso or not torso:IsA("BasePart") then
		return
	end

	local _fx_Soulscourge: Folder = Instance.new("Folder")

	_fx_Soulscourge.Name = "_FX_Soulscourge"
	_fx_Soulscourge.Parent = workspace.Bin

	local u130: boolean = true
	local u131: boolean = false
	local connection4 = nil
	local connection = nil
	local t8: {[any]: any} = {}
	local t9: {[any]: any} = {}
	local t10: {[any]: any} = {}
	local randomNew = Random.new
	local typeName: string = typeof(player.Seed)
	local v139 = randomNew(typeName == "number" and player.Seed or 11)
	local __FreezeAt = player.__FreezeAt

	if typeof(player.__Config) == "table" then
		for k, v in pairs(player.__Config) do
			t6[k] = v
		end

		t6.ImpactTime = t6.DragStart + t6.DragTime
	end

	local function own(p28)
		table.insert(t8, p28)

		return p28
	end
	local function cleanup()
		if not u130 then
			return
		end

		u130 = false

		if connection4 then
			connection4:Disconnect()
		end

		if connection then
			connection:Disconnect()
		end

		for _, v in ipairs(t10) do
			pcall(game.Destroy, v)
		end

		for _, v in ipairs(t8) do
			pcall(game.Destroy, v)
		end

		table.clear(t8)
		_fx_Soulscourge:Destroy()
	end

	connection = Character.AncestryChanged:Connect(function()
		if not Character:IsDescendantOf(game) then
			u131 = true

			if connection then
				connection:Disconnect()
			end
		end
	end)
	task.delay(t6.CleanupAfter, cleanup)
	_fx_Soulscourge.AncestryChanged:Connect(function()
		if not _fx_Soulscourge.Parent then
			cleanup()
		end
	end)

	local function at(p29, p30)
		if __FreezeAt and p29 > __FreezeAt then
			return
		end

		local taskDelay = task.delay
		local v299 = math.max(p29, 0)

		taskDelay(v299, function()
			if u130 then
				p30()
			end
		end)
	end
	local function play(p31, p32, p33)
		local v303, v304 = sound:Play("KillEffects.Soulscourge." .. p31, p32, nil, nil, nil, p33)

		return v304
	end

	local lookVector = torso.CFrame.LookVector
	local vector3 = Vector3.new(lookVector.X, 0, lookVector.Z)
	local u149 = if vector3.Magnitude > 0.05 then vector3.Unit else Vector3.new(0, 0, -1)
	local torsoPosition = torso.Position
	local t11 = { Character, workspace.Bin }
	local characters: Instance = workspace:FindFirstChild("Characters")

	if characters then
		table.insert(t11, characters)
	end

	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = t11
	t11 = workspace:Raycast(torsoPosition + Vector3.new(0, 2, 0), Vector3.new(0, -18, 0), raycastParams)

	local vector32 = Vector3.new(torsoPosition.X, if t11 then t11.Position.Y else torsoPosition.Y - 3, torsoPosition.Z)
	local v155 = CFrame.lookAt(vector32, vector32 + u149)
	local n10 = vector32 + Vector3.new(0, 0.12, 0)
	local v157 = poseSeize()
	local v158 = poseKneel()
	local v159 = poseProne()
	local v160 = poseReach()
	local v161 = poseDrag()

	for i, v in ipairs(t7) do
		local v2 = Character:FindFirstChild(v)

		if v2 and v2:IsA("BasePart") then
			v2.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			v2.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			v2.Anchored = true
			t9[v] = {
				part = v2,
				name = v,
				from = v2.CFrame,
				seize = v155 * v157[v],
				kneel = v155 * v158[v],
				prone = v155 * v159[v],
				color = v2.Color,
				seed = i * 17,
				cf = v2.CFrame
			}
		end
	end

	local magnitude = (CurrentCamera.CFrame.Position - vector32).Magnitude
	local u166 = nil

	if magnitude < t6.PostDistance then
		local colorCorrectionEffect: ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

		table.insert(t8, colorCorrectionEffect)
		u166 = colorCorrectionEffect
		u166.Name = "_SoulDesat"
		u166.Parent = lighting

		local v168 = u166
		local tweenInfo = TweenInfo.new(t6.DesatIn, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		tweenService:Create(v168, tweenInfo, t6.Desat):Play()
	end

	local function shake()
		local _GShared = _G.Shared
		local _GSharedCamShaker = _GShared and _GShared.CamShaker

		if _GSharedCamShaker and magnitude < t6.ShakeDistance then
			pcall(function()
				_GSharedCamShaker:Shake("Explosion")
			end)
		end
	end
	local function blurPulse(p34, p35)
		if magnitude >= t6.PostDistance then
			return
		end

		local _SoulBlur: BlurEffect = Instance.new("BlurEffect")

		table.insert(t8, _SoulBlur)
		_SoulBlur.Name = "_SoulBlur"
		_SoulBlur.Size = p34
		_SoulBlur.Parent = lighting

		local tweenInfo = TweenInfo.new(p35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		tweenService:Create(_SoulBlur, tweenInfo, { Size = 0 }):Play()
		debris:AddItem(_SoulBlur, p35 + 0.05)
	end

	local clone = soulscourge.Ground:Clone()

	clone.CFrame = CFrame.new(vector32 + Vector3.new(0, 0.1, 0))
	clone.Parent = _fx_Soulscourge

	local cloneHold = clone.Hold

	if cloneHold then
		local ok, result = pcall(forgeVFX.emit, cloneHold)

		if not ok then
			local cloneHoldName = cloneHold.Name
			local text: string = tostring(result)

			warn("[Soulscourge] emit failed on " .. cloneHoldName .. ": " .. text)
		end
	end

	local cloneRise_Embers = clone.Rise_Embers

	if cloneRise_Embers then
		local ok, result = pcall(forgeVFX.emit, cloneRise_Embers)

		if not ok then
			local cloneRise_EmbersName = cloneRise_Embers.Name
			local text: string = tostring(result)

			warn("[Soulscourge] emit failed on " .. cloneRise_EmbersName .. ": " .. text)
		end
	end

	local cloneRise_Smoke = clone.Rise_Smoke

	if cloneRise_Smoke then
		local ok, result = pcall(forgeVFX.emit, cloneRise_Smoke)

		if not ok then
			local cloneRise_SmokeName = cloneRise_Smoke.Name
			local text: string = tostring(result)

			warn("[Soulscourge] emit failed on " .. cloneRise_SmokeName .. ": " .. text)
		end
	end

	local cloneLight = clone.Light
	local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Sine)

	tweenService:Create(cloneLight, tweenInfo, { Brightness = 1.4 }):Play()

	local v190, v191 = sound:Play("KillEffects.Soulscourge.Whisper", clone, nil, nil, nil, nil)
	local clone2 = soulscourge.Abyss:Clone()

	clone2.CFrame = CFrame.new(n10)
	clone2.Parent = _fx_Soulscourge

	local function v193()
		local clone2Hold = clone2.Hold

		if clone2Hold then
			local ok, result = pcall(forgeVFX.emit, clone2Hold)

			if not ok then
				local clone2HoldName = clone2Hold.Name
				local text: string = tostring(result)

				warn("[Soulscourge] emit failed on " .. clone2HoldName .. ": " .. text)
			end
		end

		local clone2Rise = clone2.Rise

		if clone2Rise then
			local ok, result = pcall(forgeVFX.emit, clone2Rise)

			if not ok then
				local clone2RiseName = clone2Rise.Name
				local text: string = tostring(result)

				warn("[Soulscourge] emit failed on " .. clone2RiseName .. ": " .. text)
			end
		end

		tweenService:Create(clone2.Light, TweenInfo.new(0.3), { Brightness = 2 }):Play()

		local v321, v322 = sound:Play("KillEffects.Soulscourge.Open", clone2, nil, nil, nil, nil)
	end

	if not __FreezeAt or not (__FreezeAt < 0.05) then
		task.delay(0.05, function()
			if u130 then
				v193()
			end
		end)
	end

	local t12: {[any]: any} = {
		model = nil,
		alpha = 1,
		shown = false,
		gone = false,
		highlight = nil,
		parts = {},
		extras = {},
		cf = {},
		ripFrom = {},
		trails = {},
		emitters = {}
	}

	local function buildSoul()
		local soul: Model = Instance.new("Model")

		soul.Name = "Soul"

		for _, v in ipairs(t7) do
			local v326 = t9[v]

			if v326 then
				local v327 = ghostCopy(v326.part)

				if v327 then
					v327.CFrame = v326.cf
					v327.Parent = soul
					t12.parts[v] = v327
					t12.cf[v] = v326.cf
				end
			end
		end

		local Head = t9.Head

		if Head then
			local n1: number = 0

			for _, v in ipairs(Character:GetChildren()) do
				if v:IsA("Accessory") and n1 < 8 then
					local handle = v:FindFirstChild("Handle")

					if handle and handle:IsA("BasePart") then
						local v333 = ghostCopy(handle)

						if v333 then
							n1 += 1
							v333.CFrame = handle.CFrame
							v333.Parent = soul

							local extras = t12.extras
							local v335 = Head.part.CFrame:ToObjectSpace(handle.CFrame)

							table.insert(extras, { part = v333, offset = v335 })
						end
					end
				end
			end
		end

		local clone3 = soulscourge.Soul.Highlight:Clone()

		clone3.Adornee = soul
		clone3.FillTransparency = 1
		clone3.OutlineTransparency = 1
		clone3.Enabled = true
		clone3.Parent = soul
		t12.highlight = clone3
		soul.Parent = _fx_Soulscourge
		t12.model = soul

		local Torso = t12.parts.Torso

		if Torso then
			for _, v in ipairs(soulscourge.Soul.Aura:GetChildren()) do
				local clone4 = v:Clone()

				clone4.Parent = Torso
				table.insert(t12.emitters, clone4)
			end
		end

		for _, v in ipairs({ "Left Arm", "Right Arm", "Left Leg", "Right Leg" }) do
			local parent = t12.parts[v]

			if parent then
				local n2 = parent.Size.Y * 0.5
				local attachment: Attachment = Instance.new("Attachment")

				attachment.Position = Vector3.new(0, -n2 * 0.45, 0)
				attachment.Parent = parent

				local attachment2: Attachment = Instance.new("Attachment")

				attachment2.Position = Vector3.new(0, -n2, 0)
				attachment2.Parent = parent

				local clone5 = soulscourge.Soul.Trail:Clone()

				clone5.Attachment0 = attachment
				clone5.Attachment1 = attachment2
				clone5.Parent = parent
				table.insert(t12.trails, clone5)
			end
		end

		local Head2 = t12.parts.Head

		if Head2 then
			for _, v in ipairs({ -0.22, 0.22 }) do
				local attachment: Attachment = Instance.new("Attachment")

				attachment.Position = Vector3.new(v, 0.12, -0.52)
				attachment.Parent = Head2

				local clone6 = soulscourge.Soul.Eye:Clone()

				clone6.Parent = attachment
				table.insert(t12.emitters, clone6)
			end
		end
	end
	local function setSoulEmitters(enabled)
		for _, v in ipairs(t12.emitters) do
			if v.Parent then
				v.Enabled = enabled
			end
		end
	end
	local function setSoulTrails(enabled)
		for _, v in ipairs(t12.trails) do
			if v.Parent then
				v.Enabled = enabled
			end
		end
	end

	local chainRoot: Part = Instance.new("Part")

	chainRoot.Name = "ChainRoot"
	chainRoot.Anchored = true
	chainRoot.CanCollide = false
	chainRoot.CanQuery = false
	chainRoot.CanTouch = false
	chainRoot.Transparency = 1
	chainRoot.Size = Vector3.new(0.2, 0.2, 0.2)
	chainRoot.CFrame = CFrame.new(vector32)
	chainRoot.Parent = _fx_Soulscourge

	local t13: {[any]: any} = {}

	for i, v in ipairs(t6.Chains) do
		if t9[v.limb] then
			local cFrameAngles = CFrame.Angles
			local v203 = math.rad(v.angle)
			local n2 = cFrameAngles(0, -v203, 0) * u149
			local n3 = vector32 + n2 * t6.RimRadius + Vector3.new(0, 0.15, 0)
			local n4 = t6.ChainStart + (i - 1) * t6.ChainStagger
			local v207 = table.create(t6.MaxLinks)

			for i = 1, t6.MaxLinks do
				local clone7 = soulscourge.Chain.Link:Clone()

				clone7.Transparency = 1
				clone7.CFrame = CFrame.new(n3)
				clone7.Parent = _fx_Soulscourge
				v207[i] = clone7
			end

			local attachment: Attachment = Instance.new("Attachment")

			attachment.Parent = chainRoot

			local attachment3: Attachment = Instance.new("Attachment")

			attachment3.Parent = chainRoot

			local t14: {[any]: any} = {}

			for _, iterValue in ipairs({ "Glow", "Crackle" }) do
				local clone8 = soulscourge.Chain[iterValue]:Clone()

				clone8.Attachment0 = attachment
				clone8.Attachment1 = attachment3
				clone8.Enabled = false
				clone8.Parent = _fx_Soulscourge
				table.insert(t14, clone8)
			end

			local v216 = n2:Cross(Vector3.new(0, 1, 0))
			local t15: {[any]: any} = {
				visible = 0,
				latched = false,
				retract = nil,
				hidden = false,
				def = v,
				start = n3,
				side = v216.Unit,
				fire = n4,
				latch = n4 + t6.ChainTravel,
				links = v207,
				a0 = attachment,
				a1 = attachment3,
				beams = t14,
				seed = i * 31
			}

			table.insert(t13, t15)
			v216 = n4 - 0.03

			local function v218()
				local clone9 = soulscourge.Chain.Tug:Clone()

				clone9.CFrame = CFrame.new(n3)
				clone9.Parent = _fx_Soulscourge

				if clone9 then
					local ok, result = pcall(forgeVFX.emit, clone9)

					if not ok then
						local clone9Name = clone9.Name
						local text: string = tostring(result)

						warn("[Soulscourge] emit failed on " .. clone9Name .. ": " .. text)
					end
				end

				debris:AddItem(clone9, 1)
			end

			if not __FreezeAt or not (__FreezeAt < v216) then
				local taskDelay = task.delay
				local v220 = math.max(v216, 0)

				taskDelay(v220, function()
					if u130 then
						v218()
					end
				end)
			end

			local latch = t15.latch

			local function v222()
				t15.latched = true

				for _, iterValue in ipairs(t14) do
					iterValue.Enabled = true
				end

				local clone10 = soulscourge.Chain.Latch:Clone()

				clone10.CFrame = CFrame.new(t15.tip or n3)
				clone10.Parent = _fx_Soulscourge

				if clone10 then
					local ok, result = pcall(forgeVFX.emit, clone10)

					if not ok then
						local clone10Name = clone10.Name
						local text: string = tostring(result)

						warn("[Soulscourge] emit failed on " .. clone10Name .. ": " .. text)
					end
				end

				debris:AddItem(clone10, 1.2)

				local v371, v372 = sound:Play("KillEffects.Soulscourge.Chain", clone10, nil, nil, nil, 0.15)
			end

			if not __FreezeAt or not (__FreezeAt < latch) then
				local v223 = task.delay
				local v224 = math.max(latch, 0)

				v223(v224, function()
					if u130 then
						v222()
					end
				end)
			end
		end
	end

	local function grabPoint(p38)
		local limb = p38.def.limb

		return ((t12.shown and t12.cf[limb] or t9[limb] and t9[limb].cf or CFrame.new(vector32 + Vector3.new(0, 3, 0))) * p38.def.grab).Position
	end

	local tautTime = t6.TautTime

	local function v227()
		local v375, v376 = sound:Play("KillEffects.Soulscourge.Rattle", torso, nil, nil, nil, nil)
	end

	if not __FreezeAt or not (__FreezeAt < tautTime) then
		local v228 = task.delay
		local v229 = math.max(tautTime, 0)

		v228(v229, function()
			if u130 then
				v227()
			end
		end)
	end

	local t16: {[any]: any} = {}
	local tearStart = t6.TearStart

	local function v232()
		if u131 then
			return
		end

		buildSoul()
		t12.shown = true

		local highlight = t12.highlight

		if highlight then
			local tweenInfo3 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

			tweenService:Create(highlight, tweenInfo3, {
				FillTransparency = t6.HighlightFill,
				OutlineTransparency = t6.HighlightOutline
			}):Play()
		end

		for _, v in ipairs(t12.emitters) do
			if v.Parent then
				v.Enabled = true
			end
		end

		for _, v in ipairs(t7) do
			local v383 = t9[v]
			local parent = t12.parts[v]

			if v383 and parent then
				local _SoulThread: Attachment = Instance.new("Attachment")

				table.insert(t8, _SoulThread)
				_SoulThread.Name = "_SoulThread"
				_SoulThread.Parent = v383.part

				local attachment: Attachment = Instance.new("Attachment")

				attachment.Parent = parent

				local clone11 = soulscourge.Soul.Thread:Clone()

				clone11.Attachment0 = _SoulThread
				clone11.Attachment1 = attachment
				clone11.Enabled = true
				clone11.Parent = _fx_Soulscourge

				local clone12 = soulscourge.Soul.Peel:Clone()

				table.insert(t8, clone12)
				clone12.Enabled = true
				clone12.Parent = v383.part
				table.insert(t16, { beam = clone11, peel = clone12, name = v })
			end
		end

		local v389, v390 = sound:Play("KillEffects.Soulscourge.Wail", torso, nil, nil, nil, nil)
		local v391 = v390

		if v391 then
			table.insert(t10, v391)
		end
	end

	if not __FreezeAt or not (__FreezeAt < tearStart) then
		local v233 = task.delay
		local v234 = math.max(tearStart, 0)

		v233(v234, function()
			if u130 then
				v232()
			end
		end)
	end

	local n5 = t6.TearStart + 0.08

	local function v236()
		local v392, v393 = sound:Play("KillEffects.Soulscourge.Riser", clone2, nil, nil, nil, nil)
		local v394 = v393

		if v394 then
			table.insert(t10, v394)
		end
	end

	if not __FreezeAt or not (__FreezeAt < n5) then
		local v237 = task.delay
		local v238 = math.max(n5, 0)

		v237(v238, function()
			if u130 then
				v236()
			end
		end)
	end

	local u239 = nil
	local ripTime = t6.RipTime

	local function v241()
		for k, v in pairs(t12.cf) do
			t12.ripFrom[k] = v
		end

		for _, v in ipairs(t16) do
			v.beam.Enabled = false
			v.peel.Enabled = false

			local v399 = t9[v.name]
			local v400 = t12.parts[v.name]

			if v399 and v400 then
				local clone13 = soulscourge.Soul.Snap:Clone()

				clone13.CFrame = CFrame.new(v399.part.Position:Lerp(v400.Position, 0.5))
				clone13.Parent = _fx_Soulscourge

				if clone13 then
					local ok, result = pcall(forgeVFX.emit, clone13)

					if not ok then
						local clone13Name = clone13.Name
						local text: string = tostring(result)

						warn("[Soulscourge] emit failed on " .. clone13Name .. ": " .. text)
					end
				end

				debris:AddItem(clone13, 1)
			end
		end

		local Torso = t12.parts.Torso
		local v407 = if Torso then Torso.Position else torsoPosition
		local clone14 = soulscourge.Rip:Clone()

		clone14.CFrame = CFrame.new(v407)
		clone14.Parent = _fx_Soulscourge

		if clone14 then
			local ok, result = pcall(forgeVFX.emit, clone14)

			if not ok then
				local clone14Name = clone14.Name
				local text: string = tostring(result)

				warn("[Soulscourge] emit failed on " .. clone14Name .. ": " .. text)
			end
		end

		flashLight(clone14.Light, t6.RipFlash)
		debris:AddItem(clone14, 2)

		for _, v in ipairs(t12.trails) do
			if v.Parent then
				v.Enabled = true
			end
		end

		if Torso then
			local pointLight: PointLight = Instance.new("PointLight")

			pointLight.Color = Color3.fromRGB(150, 215, 255)
			pointLight.Range = 14
			pointLight.Brightness = 0
			pointLight.Shadows = false
			pointLight.Parent = Torso
			tweenService:Create(pointLight, TweenInfo.new(0.3), { Brightness = 2.2 }):Play()
			u239 = pointLight
		end

		local v416, v417 = sound:Play("KillEffects.Soulscourge.Rip", torso, nil, nil, nil, nil)
		local v418, v419 = sound:Play("KillEffects.Soulscourge.RipBass", torso, nil, nil, nil, nil)
		local v420, v421 = sound:Play("KillEffects.Soulscourge.Scream", Torso or torso, nil, nil, nil, nil)

		v407 = v421

		if v407 then
			table.insert(t10, v407)
		end

		local v422, v423 = sound:Play("KillEffects.Soulscourge.Howl", clone, nil, nil, nil, nil)

		v407 = v423

		if v407 then
			table.insert(t10, v407)
		end

		local _GShared = _G.Shared
		local _GSharedCamShaker = _GShared and _GShared.CamShaker

		if _GSharedCamShaker and magnitude < t6.ShakeDistance then
			pcall(function()
				_GSharedCamShaker:Shake("Explosion")
			end)
		end

		blurPulse(10, 0.35)

		if not u131 then
			local tweenInfo4 = TweenInfo.new(t6.DrainTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

			for _, v in ipairs(Character:GetChildren()) do
				if v:IsA("Shirt") or v:IsA("Pants") then
					local color34 = Color3.fromRGB(120, 124, 132)

					tweenService:Create(v, tweenInfo4, { Color3 = color34 }):Play()
				end
			end

			local Head = t9.Head

			if Head then
				for _, v in ipairs(Head.part:GetChildren()) do
					if v:IsA("Decal") then
						local color35 = Color3.fromRGB(90, 95, 105)

						tweenService:Create(v, tweenInfo4, { Transparency = 0.55, Color3 = color35 }):Play()
					end
				end
			end
		end
	end

	if not __FreezeAt or not (__FreezeAt < ripTime) then
		local v242 = task.delay
		local v243 = math.max(ripTime, 0)

		v242(v243, function()
			if u130 then
				v241()
			end
		end)
	end

	local n6 = t6.RipTime + 0.45

	local function v245()
		for _, v in ipairs(t10) do
			if v.Name == "Wail" then
				pcall(function()
					sound.FadeOut(v, 0.5)
				end)
			end
		end
	end

	if not __FreezeAt or not (__FreezeAt < n6) then
		local v246 = task.delay
		local v247 = math.max(n6, 0)

		v246(v247, function()
			if u130 then
				v245()
			end
		end)
	end

	for _, v in ipairs(t6.Tugs) do
		local function v250()
			local v436, v437 = sound:Play("KillEffects.Soulscourge.Rattle", clone2, nil, nil, nil, 0.12)

			for _, iterValue in ipairs(t13) do
				if iterValue.latched and iterValue.tip then
					local clone15 = soulscourge.Chain.Tug:Clone()

					clone15.CFrame = CFrame.new(iterValue.tip)
					clone15.Parent = _fx_Soulscourge

					if clone15 then
						local ok, result = pcall(forgeVFX.emit, clone15)

						if not ok then
							local clone15Name = clone15.Name
							local text: string = tostring(result)

							warn("[Soulscourge] emit failed on " .. clone15Name .. ": " .. text)
						end
					end

					debris:AddItem(clone15, 1)
				end
			end

			if u239 then
				u239.Brightness = 4.5
				tweenService:Create(u239, TweenInfo.new(0.4), { Brightness = 2.2 }):Play()
			end
		end

		if not __FreezeAt or not (__FreezeAt < v) then
			local v251 = task.delay
			local v252 = math.max(v, 0)

			v251(v252, function()
				if u130 then
					v250()
				end
			end)
		end
	end

	local n7 = t6.RipTime + t6.KneelTime - 0.02

	local function v254()
		if u131 then
			return
		end

		local v445, v446 = sound:Play("KillEffects.Soulscourge.Thud", torso, nil, nil, nil, 0.1)
	end

	if not __FreezeAt or not (__FreezeAt < n7) then
		local v255 = task.delay
		local v256 = math.max(n7, 0)

		v255(v256, function()
			if u130 then
				v254()
			end
		end)
	end

	local n8 = t6.ProneStart + t6.ProneTime - 0.02

	local function v258()
		if u131 then
			return
		end

		local v447, v448 = sound:Play("KillEffects.Soulscourge.Thud", torso, nil, nil, nil, 0.1)
	end

	if not __FreezeAt or not (__FreezeAt < n8) then
		local v259 = task.delay
		local v260 = math.max(n8, 0)

		v259(v260, function()
			if u130 then
				v258()
			end
		end)
	end

	local n9 = t6.DragStart - 0.06

	local function v262()
		local v449, v450 = sound:Play("KillEffects.Soulscourge.Drag", clone2, nil, nil, nil, nil)
	end

	if not __FreezeAt or not (__FreezeAt < n9) then
		local v263 = task.delay
		local v264 = math.max(n9, 0)

		v263(v264, function()
			if u130 then
				v262()
			end
		end)
	end

	local t17: {[any]: any} = {}
	local impactTime = t6.ImpactTime

	local function v267()
		t12.gone = true

		if t12.model then
			for _, v in ipairs(t12.emitters) do
				if v.Parent then
					v.Enabled = false
				end
			end

			for _, v in ipairs(t12.trails) do
				if v.Parent then
					v.Enabled = false
				end
			end

			for _, v in pairs(t12.parts) do
				v.Transparency = 1
			end

			for _, v in ipairs(t12.extras) do
				v.part.Transparency = 1
			end

			if t12.highlight then
				t12.highlight.Enabled = false
			end
		end

		if u239 then
			u239.Brightness = 0
		end

		for _, v in ipairs(t13) do
			v.retract = t6.ImpactTime
		end

		local clone16 = soulscourge.Eruption:Clone()

		clone16.CFrame = CFrame.new(n10 + Vector3.new(0, 0.4, 0))
		clone16.Parent = _fx_Soulscourge

		if clone16 then
			local ok, result = pcall(forgeVFX.emit, clone16)

			if not ok then
				local clone16Name = clone16.Name
				local text: string = tostring(result)

				warn("[Soulscourge] emit failed on " .. clone16Name .. ": " .. text)
			end
		end

		flashLight(clone16.Light, t6.ImpactFlash)
		debris:AddItem(clone16, 3)

		local cloneBurst = clone.Burst

		if cloneBurst then
			local ok, result = pcall(forgeVFX.emit, cloneBurst)

			if not ok then
				local cloneBurstName = cloneBurst.Name
				local text: string = tostring(result)

				warn("[Soulscourge] emit failed on " .. cloneBurstName .. ": " .. text)
			end
		end

		local cloneRadial = clone.Radial

		if cloneRadial then
			local ok, result = pcall(forgeVFX.emit, cloneRadial)

			if not ok then
				local cloneRadialName = cloneRadial.Name
				local text: string = tostring(result)

				warn("[Soulscourge] emit failed on " .. cloneRadialName .. ": " .. text)
			end
		end

		local clone17 = soulscourge.Geyser:Clone()

		clone17.CFrame = CFrame.new(n10 + Vector3.new(0, 0.3, 0))
		clone17.Parent = _fx_Soulscourge

		if clone17 then
			local ok, result = pcall(forgeVFX.emit, clone17)

			if not ok then
				local clone17Name = clone17.Name
				local text: string = tostring(result)

				warn("[Soulscourge] emit failed on " .. clone17Name .. ": " .. text)
			end
		end

		clone17.Light.Brightness = 5

		local attachment: Attachment = Instance.new("Attachment")

		attachment.Position = Vector3.new(0, 40, 0)
		attachment.Parent = clone17

		local attachment4: Attachment = Instance.new("Attachment")

		attachment4.Parent = clone17

		for _, v in ipairs({ "Shaft", "ShaftCore" }) do
			if soulscourge.Geyser:FindFirstChild(v) then
				local v2 = clone17:FindFirstChild(v)

				v2.Attachment0 = attachment4
				v2.Attachment1 = attachment
				v2.Enabled = true

				local width0 = v2.Width0
				local width1 = v2.Width1
				local v488 = os.clock()
				local connection2 = nil

				connection2 = runService.Heartbeat:Connect(function()
					local n1 = (os.clock() - v488) / 0.75

					if n1 >= 1 or not v2.Parent then
						connection2:Disconnect()

						if v2.Parent then
							v2.Enabled = false
						end

						return
					end

					local n2 = if n1 < 0.08 then n1 / 0.08 else (1 - (n1 - 0.08) / 0.92) ^ 2

					v2.Width0 = width0 * n2
					v2.Width1 = width1 * n2
				end)
			end
		end

		local clone17Light = clone17.Light
		local tweenInfo5 = TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		tweenService:Create(clone17Light, tweenInfo5, { Brightness = 0 }):Play()

		for i = 1, t6.SpiralCount do
			local spiralSoul: Part = Instance.new("Part")

			spiralSoul.Name = "SpiralSoul"
			spiralSoul.Anchored = true
			spiralSoul.CanCollide = false
			spiralSoul.CanQuery = false
			spiralSoul.CanTouch = false
			spiralSoul.Transparency = 1
			spiralSoul.Size = Vector3.new(0.2, 0.2, 0.2)
			spiralSoul.CFrame = CFrame.new(n10)

			local attachment5: Attachment = Instance.new("Attachment")

			attachment5.Position = Vector3.new(0.35, 0, 0)
			attachment5.Parent = spiralSoul

			local attachment6: Attachment = Instance.new("Attachment")

			attachment6.Position = Vector3.new(-0.35, 0, 0)
			attachment6.Parent = spiralSoul

			local clone18 = soulscourge.Spiral.Trail:Clone()

			clone18.Attachment0 = attachment5
			clone18.Attachment1 = attachment6
			clone18.Parent = spiralSoul

			local clone19 = soulscourge.Spiral.Head:Clone()

			clone19.Enabled = true
			clone19.Parent = spiralSoul
			spiralSoul.Parent = _fx_Soulscourge

			local n1 = i / t6.SpiralCount * 3.141592653589793 * 2
			local v499 = v139:NextNumber(-0.2, 0.2)
			local v500 = v139:NextNumber(0, 0.18)
			local t20: {[any]: any} = {
				done = false,
				part = spiralSoul,
				trail = clone18,
				head = clone19,
				angle = n1 + v499,
				delay = v500,
				turns = v139:NextNumber(5.5, 8.5) * (if i % 2 == 0 then 1 else -1),
				radius = v139:NextNumber(2.2, 3.6)
			}
			local spiralHeight = t6.SpiralHeight

			v499 = v139:NextNumber(0.75, 1.1)
			t20.height = spiralHeight * v499
			table.insert(t17, t20)
		end

		local v503, v504 = sound:Play("KillEffects.Soulscourge.Impact", clone17, nil, nil, nil, nil)
		local v505, v506 = sound:Play("KillEffects.Soulscourge.ImpactBass", clone17, nil, nil, nil, nil)
		local v507, v508 = sound:Play("KillEffects.Soulscourge.Damned", clone17, nil, nil, nil, nil)
		local v509 = v508

		if v509 then
			table.insert(t10, v509)
		end

		for _, v in ipairs(t10) do
			if v.Name == "Howl" or v.Name == "Scream" or v.Name == "Riser" then
				pcall(function()
					sound.FadeOut(v, 0.3)
				end)
			end
		end

		local _GShared = _G.Shared
		local _GSharedCamShaker = _GShared and _GShared.CamShaker

		if _GSharedCamShaker and magnitude < t6.ShakeDistance then
			pcall(function()
				_GSharedCamShaker:Shake("Explosion")
			end)
		end

		blurPulse(14, 0.45)

		if u166 then
			u166.Brightness = 0.28

			local v514 = u166
			local tweenInfo6 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

			tweenService:Create(v514, tweenInfo6, { Brightness = t6.Desat.Brightness }):Play()
		end

		local v516 = not u131 and t9.Torso

		if v516 then
			local clone20 = soulscourge.Husk.Husk_Motes:Clone()

			table.insert(t8, clone20)
			clone20.Enabled = true
			clone20.Parent = v516.part
		end
	end

	if not __FreezeAt or not (__FreezeAt < impactTime) then
		local v268 = task.delay
		local v269 = math.max(impactTime, 0)

		v268(v269, function()
			if u130 then
				v267()
			end
		end)
	end

	local closeTime = t6.CloseTime

	local function v271()
		stopEmitters(clone2)

		local clone2Close = clone2.Close

		if clone2Close then
			local ok, result = pcall(forgeVFX.emit, clone2Close)

			if not ok then
				local clone2CloseName = clone2Close.Name
				local text: string = tostring(result)

				warn("[Soulscourge] emit failed on " .. clone2CloseName .. ": " .. text)
			end
		end

		tweenService:Create(clone2.Light, TweenInfo.new(0.4), { Brightness = 0 }):Play()
		stopEmitters(clone)

		local cloneResidue_Mist = clone.Residue_Mist

		if cloneResidue_Mist then
			local ok, result = pcall(forgeVFX.emit, cloneResidue_Mist)

			if not ok then
				local cloneResidue_MistName = cloneResidue_Mist.Name
				local text: string = tostring(result)

				warn("[Soulscourge] emit failed on " .. cloneResidue_MistName .. ": " .. text)
			end
		end

		local cloneResidue_Embers = clone.Residue_Embers

		if cloneResidue_Embers then
			local ok, result = pcall(forgeVFX.emit, cloneResidue_Embers)

			if not ok then
				local cloneResidue_EmbersName = cloneResidue_Embers.Name
				local text: string = tostring(result)

				warn("[Soulscourge] emit failed on " .. cloneResidue_EmbersName .. ": " .. text)
			end
		end

		tweenService:Create(clone.Light, TweenInfo.new(0.8), { Brightness = 0.4 }):Play()

		for _, v in ipairs(t10) do
			if v.Name == "Damned" then
				pcall(function()
					sound.FadeOut(v, 1.4)
				end)
			end
		end
	end

	if not __FreezeAt or not (__FreezeAt < closeTime) then
		local v272 = task.delay
		local v273 = math.max(closeTime, 0)

		v272(v273, function()
			if u130 then
				v271()
			end
		end)
	end

	local desatOutStart = t6.DesatOutStart

	local function v275()
		if u166 then
			local v535 = u166
			local tweenInfo7 = TweenInfo.new(t6.DesatOutTime, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

			tweenService:Create(v535, tweenInfo7, {
				Saturation = 0,
				Contrast = 0,
				Brightness = 0,
				TintColor = Color3.new(1, 1, 1)
			}):Play()
		end
	end

	if not __FreezeAt or not (__FreezeAt < desatOutStart) then
		local v276 = task.delay
		local v277 = math.max(desatOutStart, 0)

		v276(v277, function()
			if u130 then
				v275()
			end
		end)
	end

	local function fadedSequence(p39, p40)
		local t21: {[any]: any} = {}

		for _, v in ipairs(p39.Keypoints) do
			local n1 = v.Value + (1 - v.Value) * p40
			local v543 = math.min(v.Envelope * (1 - p40), n1, 1 - n1)
			local numberSequenceKeypointNew = NumberSequenceKeypoint.new
			local vTime = v.Time
			local v546 = math.max(v543, 0)

			table.insert(t21, numberSequenceKeypointNew(vTime, n1, v546))
		end

		return NumberSequence.new(t21)
	end

	local fadeStart = t6.FadeStart

	local function v280()
		local tweenInfo8 = TweenInfo.new(t6.FadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local t22: {[any]: any} = {}

		local function wind(p41)
			if p41:IsA("ParticleEmitter") then
				p41.Enabled = false
				table.insert(t22, { e = p41, seq = p41.Transparency })

				return
			end

			if not p41:IsA("Beam") and not p41:IsA("Trail") then
				if p41:IsA("Light") then
					tweenService:Create(p41, tweenInfo8, { Brightness = 0 }):Play()

					return
				end

				if p41:IsA("Sound") then
					local tweenInfo9 = TweenInfo.new(t6.FadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

					tweenService:Create(p41, tweenInfo9, { Volume = 0 }):Play()

					return
				end

				if p41:IsA("BasePart") and p41.Transparency < 1 then
					tweenService:Create(p41, tweenInfo8, { Transparency = 1 }):Play()
				end

				return
			end

			p41.Enabled = false
		end

		for _, v in ipairs(_fx_Soulscourge:GetDescendants()) do
			wind(v)
		end

		for _, v in ipairs(t8) do
			if v.Parent and not v:IsA("PostEffect") then
				wind(v)

				for _, iterValue in ipairs(v:GetDescendants()) do
					wind(iterValue)
				end
			end
		end

		for _, v in ipairs(t10) do
			pcall(function()
				sound.FadeOut(v, t6.FadeTime)
			end)
		end

		local v558 = os.clock()
		local connection3 = nil

		connection3 = runService.Heartbeat:Connect(function()
			local v695 = os.clock()
			local v696 = math.clamp((v695 - v558) / t6.FadeTime, 0, 1)

			v696 = v696 * v696 * (3 - v696 * 2)

			for _, v in ipairs(t22) do
				if v.e.Parent then
					v.e.Transparency = fadedSequence(v.seq, v696)
				end
			end

			if v696 >= 1 or not u130 then
				connection3:Disconnect()
				cleanup()
			end
		end)
	end

	if not __FreezeAt or not (__FreezeAt < fadeStart) then
		local v281 = task.delay
		local v282 = math.max(fadeStart, 0)

		v281(v282, function()
			if u130 then
				v280()
			end
		end)
	end

	local v283 = os.clock()
	local t18: {[any]: any} = {}
	local t19: {[any]: any} = {}

	local function noise3(p42, p43)
		local v562 = math.noise(p42 * 17, p43)
		local v563 = math.noise(p42 * 13, p43 + 7)
		local vector33 = Vector3.new(v562, v563, math.noise(p42 * 15, p43 + 13))

		return vector33
	end
	local function soulFrame(p44)
		local sine = math.sin(p44 * 3.1)
		local n1 = math.sin(p44 * 1.7) * 0.20943951023931956
		local n2 = t6.HoverHeight + sine * 0.22

		for _, v in ipairs(t6.Tugs) do
			local n3 = p44 - v

			if n3 >= 0 then
				n2 -= t6.TugDepth * (if n3 < 0.07 then n3 / 0.07 else if n3 < 0.6 then (1 - (n3 - 0.07) / 0.53) ^ 2 else 0)
			end
		end

		local n4 = 0

		if p44 >= t6.DragWindup then
			local n5 = (p44 - t6.DragWindup) / (t6.DragStart - t6.DragWindup)
			local n6 = if n5 < 0 then 0 else if n5 > 1 then 1 else n5

			n2 += (1 - (1 - n6) * (1 - n6)) * 0.7
			n4 = n6 * n6 * (3 - n6 * 2)

			if p44 >= t6.DragStart then
				local n7 = (p44 - t6.DragStart) / t6.DragTime
				local n8 = if n7 < 0 then 0 else if n7 > 1 then 1 else n7

				n7 = t6.HoverHeight + 0.7
				n2 = n7 + (-4.5 - n7) * (n8 * n8)
				n4 = 1
				n1 *= 1 - n8
			end
		end

		local v577 = CFrame.lookAt(vector32, vector32 + u149)
		local v578 = CFrame.Angles(0, n1, 0)

		return v577 * v578 + Vector3.new(0, 1, 0) * n2, n4
	end

	connection4 = runService.Heartbeat:Connect(function()
		if not u130 then
			return
		end

		local n38 = os.clock() - v283

		if __FreezeAt then
			n38 = math.min(n38, __FreezeAt)
		end

		table.clear(t18)
		table.clear(t19)

		if not u131 then
			local n2 = (n38 - t6.SeizeIn) / t6.SeizeTime
			local n3 = if n2 < 0 then 0 else if n2 > 1 then 1 else n2
			local n4 = (n38 - t6.RipTime) / t6.KneelTime

			n2 = if n4 < 0 then 0 else if n4 > 1 then 1 else n4

			local n5 = n2 * n2
			local n6 = (n38 - t6.ProneStart) / t6.ProneTime

			n4 = if n6 < 0 then 0 else if n6 > 1 then 1 else n6
			n2 = n4 * n4
			n6 = (n38 - t6.TearStart) / (t6.RipTime - t6.TearStart)

			local n7

			if n38 < t6.RipTime then
				local n8 = (n38 - t6.SeizeIn) / 0.2

				n7 = (if n6 < 0 then 0 else if n6 > 1 then 1 else n6) * 0.1 * (if n8 < 0 then 0 else if n8 > 1 then 1 else n8) + 0.02
			else
				n7 = 0
			end

			n4 = n38 - t6.TautTime

			local n9 = if n4 >= 0 and n4 < 0.25 then math.sin(n4 / 0.25 * 3.141592653589793) * 0.35 else 0
			local n39 = (n38 - t6.RipTime) / t6.DrainTime

			n4 = if n39 < 0 then 0 else if n39 > 1 then 1 else n39

			for _, v in pairs(t9) do
				if v.part.Parent then
					local v591 = v.from:Lerp(v.seize, (n3 - 1) ^ 3 * 2.70158 + 1 + (n3 - 1) ^ 2 * 1.70158)

					if n5 > 0 then
						v591 = v591:Lerp(v.kneel, n5)
					end

					if n2 > 0 then
						v591 = v591:Lerp(v.prone, n2)
					end

					if n7 > 0 then
						local vSeed = v.seed
						local v593 = math.noise(n38 * 17, vSeed)
						local v594 = math.noise(n38 * 13, vSeed + 7)
						local vector34 = Vector3.new(v593, v594, math.noise(n38 * 15, vSeed + 13))

						v591 += vector34 * n7
					end

					if n9 > 0 then
						v591 -= Vector3.new(0, 1, 0) * n9
					end

					v.cf = v591

					if n4 > 0 then
						v.part.Color = v.color:Lerp(t6.HuskColor, n4)
					end

					table.insert(t18, v.part)
					table.insert(t19, v591)
				end
			end
		end

		if t12.shown and not t12.gone and t12.model then
			local n11 = (n38 - t6.TearStart) / 0.3

			n11 = 1 - (1 - t6.SoulAlpha) * (if n11 < 0 then 0 else if n11 > 1 then 1 else n11)

			if n38 < t6.RipTime then
				local n12 = (n38 - t6.TearStart) / (t6.RipTime - t6.TearStart)
				local n13 = if n12 < 0 then 0 else if n12 > 1 then 1 else n12

				n12 = t6.TearLift * (n13 * n13 * (3 - n13 * 2))

				local Torso = t9.Torso
				local v600 = if Torso then Torso.cf else CFrame.new(torsoPosition)
				local v601 = CFrame.lookAt(v600.Position, v600.Position + u149)

				for k, _ in pairs(t12.parts) do
					local v604 = t9[k]
					local v605 = ((if v604 then v604.cf else v600) + Vector3.new(0, 1, 0) * n12):Lerp((v601 + Vector3.new(0, 1, 0) * n12) * v160[k], n13 * 0.3)
					local n14 = n38 * 1.4
					local n15 = (v604 and v604.seed or 1) + 50
					local v608 = math.noise(n14 * 17, n15)
					local v609 = math.noise(n14 * 13, n15 + 7)
					local vector35 = Vector3.new(v608, v609, math.noise(n14 * 15, n15 + 13))

					t12.cf[k] = v605 + vector35 * (n13 * 0.06)
				end
			else
				local v611, v612 = soulFrame(n38)
				local n16 = (n38 - t6.RipTime) / t6.RipRise
				local n17 = if n16 < 0 then 0 else if n16 > 1 then 1 else n16
				local n18 = (n17 - 1) ^ 3 * 2.70158 + 1 + (n17 - 1) ^ 2 * 1.70158

				n17 = 1 - v612 * 0.6

				for k, _ in pairs(t12.parts) do
					local n19 = (t9[k] and t9[k].seed or 1) + 90
					local v619 = v160[k]:Lerp(v161[k], v612)
					local v620 = math.noise(n38 * 2.3, n19)
					local v621 = math.noise(n38 * 2.7, n19 + 3)
					local v622 = CFrame.Angles(v620 * 0.2792526803190927 * n17, 0, v621 * 0.2792526803190927 * n17)

					n19 = v611 * v619 * v622
					t12.cf[k] = if n18 < 1 then (t12.ripFrom[k] or n19):Lerp(n19, n18) else n19
				end

				local soulAlpha = t6.SoulAlpha
				local sine = math.sin(n38 * 9)

				n11 = soulAlpha + sine * 0.05
			end

			if math.abs(t12.alpha - n11) > 0.005 then
				t12.alpha = n11

				for _, v in pairs(t12.parts) do
					v.Transparency = n11
				end

				for _, v in ipairs(t12.extras) do
					v.part.Transparency = n11
				end
			end

			for k, v in pairs(t12.parts) do
				table.insert(t18, v)
				table.insert(t19, t12.cf[k])
			end

			local Head = t12.cf.Head

			if Head then
				for _, v in ipairs(t12.extras) do
					table.insert(t18, v.part)
					table.insert(t19, Head * v.offset)
				end
			end
		end

		for _, v in ipairs(t13) do
			local n20 = (n38 - v.fire) / t6.ChainTravel
			local n21 = if n20 < 0 then 0 else if n20 > 1 then 1 else n20

			if n21 > 0 and not v.hidden then
				local limb = v.def.limb
				local v639 = ((t12.shown and t12.cf[limb] or t9[limb] and t9[limb].cf or CFrame.new(vector32 + Vector3.new(0, 3, 0))) * v.def.grab).Position

				if v.retract then
					local n22 = (n38 - v.retract) / 0.22
					local n23 = if n22 < 0 then 0 else if n22 > 1 then 1 else n22

					v639 = v639:Lerp(n10 - Vector3.new(0, 3, 0), n23 * n23)

					if n23 >= 1 then
						v.hidden = true

						for _, iterValue in ipairs(v.links) do
							iterValue.Transparency = 1
						end

						for _, iterValue2 in ipairs(v.beams) do
							iterValue2.Enabled = false
						end
					end
				end

				local vStart = v.start
				local n24 = (vStart + v639) * 0.5
				local magnitude = (v639 - vStart).Magnitude
				local n25 = if n21 < 1 then n24 + Vector3.new(0, 1, 0) * ((1 - n21) * 2.6) + v.side * (math.sin(n21 * 3.141592653589793) * 1.2) else if n38 < t6.TautTime then n24 - Vector3.new(0, 0.5, 0) + v.side * (math.sin(n38 * 9 + v.seed) * 0.25) else n24 + v.side * ((if n38 < t6.DragStart then 0.12 else 0) * math.sin(n38 * 7 + v.seed))

				n24 = 1 - (1 - n21) * (1 - n21)

				local n26 = 1 - n24
				local n27 = vStart * (n26 * n26) + n25 * (n26 * 2 * n24) + v639 * (n24 * n24)

				v.tip = n27

				local maxLinks = t6.MaxLinks
				local floored = math.floor(magnitude * n24 / t6.LinkPitch)
				local v654 = math.min(maxLinks, floored + 1)

				if not v.hidden then
					for i = 1, t6.MaxLinks do
						local v656 = v.links[i]

						if v654 >= i then
							local n28 = (i - 0.5) * t6.LinkPitch
							local v658 = math.max(magnitude, 0.01)
							local v659 = math.min(n28 / v658, n24)
							local n29 = 1 - v659
							local n30 = vStart * (n29 * n29) + n25 * (n29 * 2 * v659) + v639 * (v659 * v659)

							n28 = (n25 - vStart) * ((1 - v659) * 2) + (v639 - n25) * (v659 * 2)

							if n28.Magnitude < 0.001 then
								n28 = Vector3.new(0, 1, 0)
							end

							local unit = n28.Unit
							local cFrameLookAt = CFrame.lookAt
							local absoluteValue = math.abs(unit.Y)

							v658 = cFrameLookAt(n30, n30 + unit, if absoluteValue > 0.98 then Vector3.new(1, 0, 0) else Vector3.new(0, 1, 0))

							if v656.Transparency >= 1 then
								v656.Transparency = 0.15
							end

							table.insert(t18, v656)
							table.insert(t19, v658 * (if i % 2 == 0 then v23 else n1))
						elseif v656.Transparency < 1 then
							v656.Transparency = 1
						end
					end

					local n31 = vStart + (n25 - vStart) * 0.6666666666666666 - vStart
					local n32 = n27 - (n27 + (n25 - n27) * 0.6666666666666666)

					if n31.Magnitude > 0.001 and n32.Magnitude > 0.001 then
						local vA0 = v.a0
						local v668 = n31.Unit
						local v669 = v668:Dot(Vector3.new(0, 1, 0))
						local v670 = if math.abs(v669) > 0.95 then Vector3.new(1, 0, 0) else Vector3.new(0, 1, 0)
						local v671 = v670:Dot(v668)

						vA0.WorldCFrame = CFrame.fromMatrix(vStart, v668, (v670 - v668 * v671).Unit)

						local vA1 = v.a1
						local v673 = n32.Unit

						v671 = v673:Dot(Vector3.new(0, 1, 0))

						local v674 = if math.abs(v671) > 0.95 then Vector3.new(1, 0, 0) else Vector3.new(0, 1, 0)
						local v675 = v674:Dot(v673)

						vA1.WorldCFrame = CFrame.fromMatrix(n27, v673, (v674 - v673 * v675).Unit)

						for _, iterValue3 in ipairs(v.beams) do
							iterValue3.CurveSize0 = n31.Magnitude
							iterValue3.CurveSize1 = n32.Magnitude
						end
					end
				end
			end
		end

		for _, v in ipairs(t17) do
			if not v.done then
				local n33 = (n38 - t6.ImpactTime - v.delay) / t6.SpiralTime
				local n34 = if n33 < 0 then 0 else if n33 > 1 then 1 else n33

				n33 = 1 - (1 - n34) * (1 - n34)

				local n35 = v.angle + v.turns * n33
				local vRadius = v.radius
				local v684 = math.min(1, n34 * 1.6)
				local sine = math.sin(v684 * 3.141592653589793 * 0.5)
				local n36 = 0.6 + vRadius * sine * (1 - n34 * 0.35)
				local cosine = math.cos(n35)
				local n37 = v.height * n33 ^ 0.85
				local sine2 = math.sin(n35)
				local vector36 = Vector3.new(cosine * n36, n37, sine2 * n36)

				table.insert(t18, v.part)
				table.insert(t19, CFrame.new(n10 + vector36))

				if n34 >= 1 then
					v.done = true
					v.trail.Enabled = false
					v.head.Enabled = false
				end
			end
		end

		if #t18 > 0 then
			workspace:BulkMoveTo(t18, t19, Enum.BulkMoveMode.FireCFrameChanged)
		end

		if n38 > 0.3 and n38 < t6.CloseTime and clone.Parent then
			clone.Light.Brightness = 1.4 + 0.4 * math.noise(n38 * 5, 2)
		end
	end)
end
