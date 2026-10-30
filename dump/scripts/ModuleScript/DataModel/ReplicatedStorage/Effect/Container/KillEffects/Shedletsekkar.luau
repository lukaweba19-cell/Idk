-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local tweenService: TweenService = game:GetService("TweenService")
local lighting: Lighting = game:GetService("Lighting")
local sound = require(game.ReplicatedStorage.Sound)
local forgeVFX = require(game.ReplicatedStorage.Util.ForgeVFX)
local shedletsekkar = game.ReplicatedStorage.FX.KillEffects.Shedletsekkar
local color3 = Color3.fromRGB(238, 234, 228)
local color32 = Color3.fromRGB(22, 6, 6)
local color33 = Color3.fromRGB(255, 34, 34)

local function clamp01(p1)
	if p1 < 0 then
		return 0
	end

	if p1 > 1 then
		return 1
	end

	return p1
end
local function quadIn(p2)
	return p2 * p2
end
local function quadOut(p3)
	return 1 - (1 - p3) * (1 - p3)
end
local function backOut(p4)
	return (p4 - 1) ^ 3 * 2.70158 + 1 + (p4 - 1) ^ 2 * 1.70158
end
local function emit(p5)
	if not p5 then
		return
	end

	local ok, result = pcall(forgeVFX.emit, p5)

	if not ok then
		local v29 = p5.Name
		local text: string = tostring(result)

		warn("[Shedletsekkar] emit failed on " .. v29 .. ": " .. text)
	end
end
local function stopEmitters(p6)
	for _, v in ipairs(p6:GetDescendants()) do
		if v:IsA("ParticleEmitter") or v:IsA("Beam") then
			v.Enabled = false
		end
	end
end
local function scaleCF(p7, p8)
	return CFrame.new(p7.Position * p8) * p7.Rotation
end
local function setEmissive(p9, p10)
	local surfaceAppearance = p9:FindFirstChildWhichIsA("SurfaceAppearance")

	if surfaceAppearance then
		pcall(function()
			surfaceAppearance.EmissiveStrength = p10
		end)
	end
end
local function noPhys(p11)
	p11.Anchored = true
	p11.CanCollide = false
	p11.CanQuery = false
	p11.CanTouch = false
	p11.CastShadow = false
end
local function hideCharacter(p12)
	for _, v in ipairs(p12:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Transparency = 1
			v.Anchored = true
		elseif not v:IsA("Decal") and not v:IsA("Texture") then
			if v:IsA("ParticleEmitter") or v:IsA("Beam") or v:IsA("Trail") or v:IsA("Light") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
				v.Enabled = false
			end
		else
			v.Transparency = 1
		end
	end
end
local function flashLight(p13, p14, range, p16, p17)
	p13.Range = range
	p13.Brightness = 0

	local tweenInfo = TweenInfo.new(p16, Enum.EasingStyle.Linear)
	local v49: Tween = tweenService:Create(p13, tweenInfo, { Brightness = p14 })

	v49.Completed:Once(function()
		local tweenInfo2 = TweenInfo.new(p17, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

		tweenService:Create(p13, tweenInfo2, { Brightness = 0 }):Play()
	end)
	v49:Play()
end

local t1: {[any]: any} = {
	MaxDistance = 1000,
	Hover = 3.4,
	Scale = 1.25,
	PopAt = 0.3,
	PopTime = 0.34,
	PopSpin = 5.235987755982989,
	IgniteAt = 0.62,
	SproutAt = 0.72,
	SproutTime = 0.42,
	SproutUnfurl = 0.6981317007977318,
	AntlerLag = 0.07,
	FaceEmissive = 1.9,
	AntlerEmissive = 4,
	PulseSwell = 0.09,
	ShatterAt = 2,
	FadeStart = 3.3,
	FadeTime = 0.8,
	CleanupAfter = 7,
	Gravity = 70,
	Shards = 18,
	Chips = 10,
	ShakeDistance = 70,
	PostDistance = 60,
	Pulses = { 1.05, 1.42, 1.7, 1.88 },
	White = color3,
	Black = color32,
	Red = color33
}

return function(player)
	local Character = player.Character

	if not Character or not Character.Parent then
		return
	end

	local CurrentCamera: Camera = workspace.CurrentCamera
	local CFramePosition = CurrentCamera.CFrame.Position
	local pivot = Character:GetPivot()

	if (CFramePosition - pivot.Position).Magnitude >= t1.MaxDistance then
		return
	end

	local v55 = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

	if not v55 or not v55:IsA("BasePart") then
		return
	end

	local _fx_Shedletsekkar: Folder = Instance.new("Folder")

	_fx_Shedletsekkar.Name = "_FX_Shedletsekkar"
	_fx_Shedletsekkar.Parent = workspace.Bin

	local u57: boolean = true
	local connection = nil
	local randomNew = Random.new
	local v60 = typeof(player.Seed) == "number" and player.Seed

	if not v60 then
		v60 = os.clock() * 1000
	end

	local v61 = randomNew(v60)
	local __FreezeAt = player.__FreezeAt
	local highlight = nil
	local t2: {[any]: any} = {}

	local function cleanup()
		if not u57 then
			return
		end

		u57 = false

		if connection then
			connection:Disconnect()
		end

		if highlight then
			pcall(game.Destroy, highlight)
		end

		for _, v in ipairs(t2) do
			pcall(game.Destroy, v)
		end

		_fx_Shedletsekkar:Destroy()
	end

	if not __FreezeAt then
		task.delay(t1.CleanupAfter, cleanup)
	end

	local function at(p19, p20)
		if __FreezeAt and p19 > __FreezeAt then
			return
		end

		local taskDelay = task.delay
		local v166 = math.max(p19, 0)

		taskDelay(v166, function()
			if u57 then
				p20()
			end
		end)
	end

	local v67 = v55.Position
	v55 = { Character, workspace.Bin }
	local characters: Instance = workspace:FindFirstChild("Characters")

	if characters then
		table.insert(v55, characters)
	end

	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = v55
	v55 = workspace:Raycast(v67 + Vector3.new(0, 2, 0), Vector3.new(-0, -18, -0), raycastParams)

	local v70 = if v55 then v55.Position.Y else v67.Y - 3
	local vector3 = Vector3.new(v67.X, v70 + t1.Hover, v67.Z)
	local n1 = CurrentCamera.CFrame.Position - vector3

	n1 = Vector3.new(n1.X, 0, n1.Z)
	n1 = if n1.Magnitude > 0.05 then n1.Unit else Vector3.new(0, 0, -1)

	local v73 = CFrame.lookAt(vector3, vector3 + n1)
	local v74 = CFrame.lookAt(v67, v67 + n1)
	local v75 = CFrame.Angles(1.5707963267948966, 0, 0)
	local n2 = v74 * v75
	local cFrameFromMatrix = CFrame.fromMatrix
	local vector32 = Vector3.new(v67.X, v70 + 0.05, v67.Z)
	local v79 = cFrameFromMatrix(vector32, Vector3.new(-0, -1, -0), n1)
	local anchor: Part = Instance.new("Part")

	anchor.Name = "Anchor"
	anchor.Size = Vector3.new(1, 1, 1)
	anchor.Transparency = 1
	anchor.Anchored = true
	anchor.CanCollide = false
	anchor.CanQuery = false
	anchor.CanTouch = false
	anchor.CastShadow = false
	anchor.CFrame = v73
	anchor.Parent = _fx_Shedletsekkar

	local clone = shedletsekkar.Haze:Clone()

	clone.Parent = anchor

	local clone2 = shedletsekkar.IgniteFlash:Clone()

	clone2.Position = Vector3.new(0, 0, -2.8)
	clone2.Parent = anchor

	local clone3 = shedletsekkar.Pulse:Clone()

	clone3.Parent = anchor

	local clone4 = shedletsekkar.Aura:Clone()

	clone4.CFrame = CFrame.new(vector3)

	local function shake(p21)
		if (CurrentCamera.CFrame.Position - vector3).Magnitude > t1.ShakeDistance then
			return
		end

		local _GShared = _G.Shared
		local _GSharedCamShaker = _GShared and _GShared.CamShaker

		if _GSharedCamShaker then
			pcall(function()
				_GSharedCamShaker:Shake(p21)
			end)
		end
	end
	local function postFlash(tintColor, contrast, brightness, p25)
		if (CurrentCamera.CFrame.Position - vector3).Magnitude > t1.PostDistance then
			return
		end

		local _ShedFlash: ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

		_ShedFlash.Name = "_ShedFlash"
		_ShedFlash.TintColor = tintColor
		_ShedFlash.Contrast = contrast
		_ShedFlash.Brightness = brightness
		_ShedFlash.Saturation = 0.15
		_ShedFlash.Parent = lighting
		table.insert(t2, _ShedFlash)

		local tweenInfo = TweenInfo.new(p25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		tweenService:Create(_ShedFlash, tweenInfo, {
			Contrast = 0,
			Brightness = 0,
			Saturation = 0,
			TintColor = Color3.new(1, 1, 1)
		}):Play()
		task.delay(p25 + 0.05, function()
			pcall(game.Destroy, _ShedFlash)
		end)
	end

	local clone5 = shedletsekkar.Shell:Clone()
	local clone5Pumpkin = clone5.Pumpkin
	local core = clone5Pumpkin:FindFirstChild("Core")
	local clone5PumpkinCFrame = clone5Pumpkin.CFrame
	local clone5PumpkinSize = clone5Pumpkin.Size
	local scale = t1.Scale
	local n3 = math.max(clone5PumpkinSize.X, clone5PumpkinSize.Z) / 2 * scale
	local surfaceAppearance = clone5Pumpkin:FindFirstChildWhichIsA("SurfaceAppearance")

	if surfaceAppearance then
		local n4: number = 0

		pcall(function()
			surfaceAppearance.EmissiveStrength = n4
		end)
	end

	clone5Pumpkin.Size = clone5PumpkinSize * 0.01
	clone5Pumpkin.CFrame = v73

	local u96: boolean = false
	local u97 = v73
	local n5 = 0.01
	local t3: {[any]: any} = {}

	for i, v in ipairs({ "RightAntler", "LeftAntler" }) do
		local v = clone5:FindFirstChild(v)

		if v and v:IsA("BasePart") then
			local root = v:FindFirstChild("Root")
			local v104 = v.CFrame:PointToWorldSpace(if root then root.Position else Vector3.new(0, 0, 0))
			local vSize = v.Size
			local cFrame = CFrame.new(v104)

			cFrame = cFrame:ToObjectSpace(v.CFrame)
			table.insert(t3, {
				grown = 0,
				part = v,
				size0 = vSize,
				root = v104,
				rel = cFrame,
				side = if v.Position.X >= 0 then 1 else -1,
				start = (i - 1) * t1.AntlerLag,
				rootW = v73.Position
			})
			v.Transparency = 1

			if v:FindFirstChildWhichIsA("SurfaceAppearance") then
				local n6: number = 0

				pcall(function()
					v176.EmissiveStrength = n6
				end)
			end
		end
	end

	local u108: boolean = true

	local function layoutAntlers(p26, p27)
		for _, v in ipairs(t3) do
			local n1 = (p26 - t1.SproutAt - v.start) / t1.SproutTime
			local n2 = if n1 < 0 then 0 else if n1 > 1 then 1 else n1

			n1 = (n2 - 1) ^ 3 * 2.70158 + 1 + (n2 - 1) ^ 2 * 1.70158
			v.grown = n1

			if n2 <= 0 then
				v.part.Transparency = 1
			else
				local n3 = (1 - (1 - (1 - n2) * (1 - n2))) * t1.SproutUnfurl * v.side
				local cFrame = CFrame.new(v.root)
				local v185 = CFrame.Angles(0, 0, n3)
				local cFrame2 = CFrame.new(v.rel.Position * n1)
				local n4 = cFrame * v185 * cFrame2 * v.rel.Rotation

				v.part.Transparency = 0

				local vPart = v.part
				local n5 = v.size0 * p27

				v185 = math.max(n1, 0.01)
				vPart.Size = n5 * v185

				local v190 = v.part

				n5 = u97

				local cFrame3 = CFrame.new(n4.Position * p27)

				v190.CFrame = n5 * (cFrame3 * n4.Rotation)
				v.rootW = u97:PointToWorldSpace(v.root * p27)
			end
		end
	end

	local t4: {[any]: any} = {}

	local function addFlyer(p28, p29, p30, p31)
		local v196 = v61:NextUnitVector()

		table.insert(t4, {
			born = nil,
			part = p28,
			vel = p29,
			axis = v196,
			spin = p30,
			life = p31,
			base = p28.Size
		})
	end

	local t5: {[any]: any} = {}
	local v113 = os.clock()
	local n7 = 0
	local n8 = 0
	local u116: boolean = false
	local u117: boolean = false

	local function v118()
		local clone6 = shedletsekkar.OpeningHit:Clone()

		clone6.CFrame = n2
		clone6.Parent = _fx_Shedletsekkar

		if clone6 then
			local ok, result = pcall(forgeVFX.emit, clone6)

			if not ok then
				local clone6Name = clone6.Name
				local text: string = tostring(result)

				warn("[Shedletsekkar] emit failed on " .. clone6Name .. ": " .. text)
			end
		end

		local pointLight = clone6:FindFirstChildWhichIsA("PointLight")

		if pointLight then
			flashLight(pointLight, 10, 26, 0.02, 0.5)
		end

		local clone7 = shedletsekkar.OpeningLines:Clone()

		clone7.CFrame = v74
		clone7.Parent = _fx_Shedletsekkar

		if clone7 then
			local ok, result = pcall(forgeVFX.emit, clone7)

			if not ok then
				local clone7Name = clone7.Name
				local text: string = tostring(result)

				warn("[Shedletsekkar] emit failed on " .. clone7Name .. ": " .. text)
			end
		end

		local clone8 = shedletsekkar.OpeningFloor:Clone()

		clone8.CFrame = v79
		clone8.Parent = _fx_Shedletsekkar

		if clone8 then
			local ok, result = pcall(forgeVFX.emit, clone8)

			if not ok then
				local clone8Name = clone8.Name
				local text: string = tostring(result)

				warn("[Shedletsekkar] emit failed on " .. clone8Name .. ": " .. text)
			end
		end

		local clone9 = shedletsekkar.Charge:Clone()

		clone9.CFrame = n2
		clone9.Parent = _fx_Shedletsekkar

		if clone9 then
			local ok, result = pcall(forgeVFX.emit, clone9)

			if not ok then
				local clone9Name = clone9.Name
				local text: string = tostring(result)

				warn("[Shedletsekkar] emit failed on " .. clone9Name .. ": " .. text)
			end
		end

		sound:Play("KillEffects.Shedletsekkar.Impact", vector3)
		sound:Play("KillEffects.Shedletsekkar.ImpactBass", vector3)

		if not ((CurrentCamera.CFrame.Position - vector3).Magnitude > t1.ShakeDistance) then
			local _GShared = _G.Shared
			local _GSharedCamShaker = _GShared and _GShared.CamShaker

			if _GSharedCamShaker then
				local s1: string = "Explosion"

				pcall(function()
					_GSharedCamShaker:Shake(s1)
				end)
			end
		end

		local color34 = Color3.fromRGB(255, 150, 150)

		postFlash(color34, 0.35, 0.12, 0.45)
		highlight = Instance.new("Highlight")
		highlight.Name = "_ShedFlush"
		highlight.FillColor = t1.Red
		highlight.OutlineColor = t1.Red
		highlight.FillTransparency = 1
		highlight.OutlineTransparency = 1
		highlight.DepthMode = Enum.HighlightDepthMode.Occluded
		highlight.Adornee = Character
		highlight.Parent = _fx_Shedletsekkar

		local v222 = highlight
		local tweenInfo = TweenInfo.new(t1.PopAt, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

		tweenService:Create(v222, tweenInfo, { FillTransparency = 0.1, OutlineTransparency = 0 }):Play()
	end

	if not __FreezeAt or not (__FreezeAt < 0) then
		task.delay(0, function()
			if u57 then
				v118()
			end
		end)
	end

	local function v119()
		sound:Play("KillEffects.Shedletsekkar.Riser", vector3)
	end

	if not __FreezeAt or not (__FreezeAt < 0.05) then
		task.delay(0.05, function()
			if u57 then
				v119()
			end
		end)
	end

	local function v120()
		sound:Play("KillEffects.Shedletsekkar.Gather", vector3)
	end

	if not __FreezeAt or not (__FreezeAt < 0.08) then
		task.delay(0.08, function()
			if u57 then
				v120()
			end
		end)
	end

	local popAt = t1.PopAt

	local function v122()
		if highlight then
			highlight:Destroy()
			highlight = nil
		end

		if Character.Parent then
			hideCharacter(Character)
		end

		clone5.Parent = _fx_Shedletsekkar
		u96 = true
		sound:Play("KillEffects.Shedletsekkar.Pop", vector3)

		local clone10 = shedletsekkar.Pop:Clone()

		clone10.CFrame = v73
		clone10.Parent = _fx_Shedletsekkar

		if clone10 then
			local ok, result = pcall(forgeVFX.emit, clone10)

			if not ok then
				local clone10Name = clone10.Name
				local text: string = tostring(result)

				warn("[Shedletsekkar] emit failed on " .. clone10Name .. ": " .. text)
			end
		end

		local pointLight = clone10:FindFirstChildWhichIsA("PointLight")

		if pointLight then
			flashLight(pointLight, 6, 22, 0.02, 0.35)
		end
	end

	if not __FreezeAt or not (__FreezeAt < popAt) then
		local taskDelay = task.delay
		local v124 = math.max(popAt, 0)

		taskDelay(v124, function()
			if u57 then
				v122()
			end
		end)
	end

	local igniteAt = t1.IgniteAt

	local function v126()
		sound:Play("KillEffects.Shedletsekkar.Ignite", vector3)

		for _, v in ipairs(clone:GetChildren()) do
			if v:IsA("ParticleEmitter") then
				v.Enabled = true
			end
		end

		local v232 = clone2

		if v232 then
			local ok, result = pcall(forgeVFX.emit, v232)

			if not ok then
				local v235 = v232.Name
				local text: string = tostring(result)

				warn("[Shedletsekkar] emit failed on " .. v235 .. ": " .. text)
			end
		end

		clone4.Parent = _fx_Shedletsekkar

		for _, v in ipairs(clone4:GetChildren()) do
			if v:IsA("ParticleEmitter") then
				v.Enabled = true
			end
		end
	end

	if not __FreezeAt or not (__FreezeAt < igniteAt) then
		local v127 = task.delay
		local v128 = math.max(igniteAt, 0)

		v127(v128, function()
			if u57 then
				v126()
			end
		end)
	end

	local sproutAt = t1.SproutAt

	local function v130()
		sound:Play("KillEffects.Shedletsekkar.Sprout", vector3, nil, nil, nil, 0.06)
	end

	if not __FreezeAt or not (__FreezeAt < sproutAt) then
		local v131 = task.delay
		local v132 = math.max(sproutAt, 0)

		v131(v132, function()
			if u57 then
				v130()
			end
		end)
	end

	local n9 = t1.SproutAt + 0.14

	local function v134()
		sound:Play("KillEffects.Shedletsekkar.Sprout", vector3, nil, 0.85, nil, 0.06)
	end

	if not __FreezeAt or not (__FreezeAt < n9) then
		local v135 = task.delay
		local v136 = math.max(n9, 0)

		v135(v136, function()
			if u57 then
				v134()
			end
		end)
	end

	for _, v in ipairs(t3) do
		local n10 = t1.SproutAt + v.start + 0.02

		local function v140()
			if u116 then
				return
			end

			local clone11 = shedletsekkar.RootSpark:Clone()

			clone11.Parent = anchor
			clone11.WorldPosition = u97:PointToWorldSpace(v.root * scale * n5)

			if not clone11 then
				return
			end

			local ok, result = pcall(forgeVFX.emit, clone11)

			if not ok then
				local clone11Name = clone11.Name
				local text: string = tostring(result)

				warn("[Shedletsekkar] emit failed on " .. clone11Name .. ": " .. text)
			end
		end

		if not __FreezeAt or not (__FreezeAt < n10) then
			local v141 = task.delay
			local v142 = math.max(n10, 0)

			v141(v142, function()
				if u57 then
					v140()
				end
			end)
		end
	end

	for i, v in ipairs(t1.Pulses) do
		local function v145()
			n8 = 1.2 + i * 0.35

			local v244 = clone3

			if v244 then
				local ok, result = pcall(forgeVFX.emit, v244)

				if not ok then
					local v247 = v244.Name
					local text: string = tostring(result)

					warn("[Shedletsekkar] emit failed on " .. v247 .. ": " .. text)
				end
			end

			sound:Play("KillEffects.Shedletsekkar.Crack", vector3, nil, nil, nil, 0.08)
		end

		if not __FreezeAt or not (__FreezeAt < v) then
			local v146 = task.delay
			local v147 = math.max(v, 0)

			v146(v147, function()
				if u57 then
					v145()
				end
			end)
		end
	end

	local shatterAt = t1.ShatterAt

	local function v149()
		u116 = true

		local v249 = u97
		local v250: number = n5

		for _, v in ipairs(t3) do
			v.part.Parent = _fx_Shedletsekkar
		end

		clone5:Destroy()

		for _, v in ipairs(clone:GetChildren()) do
			if v:IsA("ParticleEmitter") then
				v.Enabled = false
			end
		end

		stopEmitters(clone4)
		sound:Play("KillEffects.Shedletsekkar.Shatter", vector3)
		sound:Play("KillEffects.Shedletsekkar.Bass", vector3)
		sound:Play("KillEffects.Shedletsekkar.Roar", vector3)

		for _ = 1, t1.Shards do
			local unit = (v61:NextUnitVector() + Vector3.new(0, 0.35, 0)).Unit
			local n1 = v249.Position + unit * n3 * v250 * 0.85
			local shard: WedgePart = Instance.new("WedgePart")

			shard.Name = "Shard"
			shard.Material = Enum.Material.SmoothPlastic
			shard.Color = t1.White

			local v259 = v61:NextNumber(0.6, 1.3)

			shard.Size = Vector3.new(0.22, v259, v61:NextNumber(0.7, 1.5)) * v250 * scale
			shard.Anchored = true
			shard.CanCollide = false
			shard.CanQuery = false
			shard.CanTouch = false
			shard.CastShadow = false

			local v260 = CFrame.lookAt(n1, n1 + unit)
			local v261 = CFrame.Angles(0, 0, v61:NextNumber(0, 6.283185307179586))

			shard.CFrame = v260 * v261
			shard.Parent = _fx_Shedletsekkar
			v261 = v61:NextNumber(16, 30)
			v259 = v61:NextNumber(8, 16)
			v260 = v61:NextNumber(6, 14)

			local v262 = v61:NextNumber(0.9, 1.25)
			local v263 = v61:NextUnitVector()

			table.insert(t4, {
				born = nil,
				part = shard,
				vel = unit * v261 + Vector3.new(0, 1, 0) * v259,
				axis = v263,
				spin = v260,
				life = v262,
				base = shard.Size
			})
		end

		for _ = 1, t1.Chips do
			local v265 = (v61:NextUnitVector() + Vector3.new(0, 0.5, 0)).Unit
			local chip: WedgePart = Instance.new("WedgePart")

			chip.Name = "Chip"
			chip.Material = Enum.Material.Neon
			chip.Color = t1.Red

			local v267 = v61:NextNumber(0.15, 0.3)

			chip.Size = Vector3.new(0.08, v267, v61:NextNumber(0.35, 0.6)) * v250
			chip.Anchored = true
			chip.CanCollide = false
			chip.CanQuery = false
			chip.CanTouch = false
			chip.CastShadow = false
			chip.CFrame = CFrame.new(v249.Position + v265 * 0.6)
			chip.Parent = _fx_Shedletsekkar

			local v268 = v61:NextNumber(24, 40)
			local v269 = v61:NextNumber(6, 14)
			local v270 = v61:NextNumber(8, 16)
			local v271 = v61:NextNumber(0.6, 0.9)
			local v272 = v61:NextUnitVector()

			table.insert(t4, {
				born = nil,
				part = chip,
				vel = v265 * v268 + Vector3.new(0, 1, 0) * v269,
				axis = v272,
				spin = v270,
				life = v271,
				base = chip.Size
			})
		end

		u108 = false

		for _, v in ipairs(t3) do
			local vSide = v.side
			local n2 = CFrame.new(v.rootW) * v249.Rotation
			local t6: {[any]: any} = {}

			if v.grown > 0 then
				local vPart = v.part
				local v279 = n2:ToObjectSpace(v.part.CFrame)

				table.insert(t6, { part = vPart, rel = v279 })
			end

			local n6 = v249.RightVector * vSide
			local v281 = v61:NextNumber(12, 18)
			local v282 = v61:NextNumber(14, 20)
			local lookVector = v249.LookVector
			local v284 = v61:NextNumber(0, 4)
			local n4 = v249.LookVector * -vSide
			local v286 = v61:NextNumber(6, 9)

			table.insert(t5, {
				life = 1.1,
				pivot = n2,
				parts = t6,
				vel = n6 * v281 + Vector3.new(0, 1, 0) * v282 - lookVector * v284,
				axis = n4,
				spin = v286
			})
		end

		local clone12 = shedletsekkar.Burst:Clone()

		clone12.CFrame = CFrame.new(v249.Position)
		clone12.Parent = _fx_Shedletsekkar

		if clone12 then
			local ok, result = pcall(forgeVFX.emit, clone12)

			if not ok then
				local clone12Name = clone12.Name
				local text: string = tostring(result)

				warn("[Shedletsekkar] emit failed on " .. clone12Name .. ": " .. text)
			end
		end

		local pointLight = clone12:FindFirstChildWhichIsA("PointLight")

		if pointLight then
			flashLight(pointLight, 9, 40, 0.03, 0.7)
		end

		local clone13 = shedletsekkar.ShatterBlast:Clone()

		clone13.CFrame = CFrame.new(v249.Position) * v73.Rotation
		clone13.Parent = _fx_Shedletsekkar

		if clone13 then
			local ok, result = pcall(forgeVFX.emit, clone13)

			if not ok then
				local clone13Name = clone13.Name
				local text: string = tostring(result)

				warn("[Shedletsekkar] emit failed on " .. clone13Name .. ": " .. text)
			end
		end

		local clone14 = shedletsekkar.Pillar:Clone()

		clone14.CFrame = CFrame.new(v249.Position + Vector3.new(0, 1, 0) * (clone14.Size.Y / 2 - 1.5))
		clone14.Parent = _fx_Shedletsekkar

		if clone14 then
			local ok, result = pcall(forgeVFX.emit, clone14)

			if not ok then
				local clone14Name = clone14.Name
				local text: string = tostring(result)

				warn("[Shedletsekkar] emit failed on " .. clone14Name .. ": " .. text)
			end
		end

		local pointLight2 = clone14:FindFirstChildWhichIsA("PointLight")

		if pointLight2 then
			pointLight2.Brightness = 0
			tweenService:Create(pointLight2, TweenInfo.new(0.12), { Brightness = 3 }):Play()
			task.delay(1.4, function()
				if pointLight2.Parent then
					tweenService:Create(pointLight2, TweenInfo.new(0.6), { Brightness = 0 }):Play()
				end
			end)
		end

		if not ((CurrentCamera.CFrame.Position - vector3).Magnitude > t1.ShakeDistance) then
			local _GShared = _G.Shared
			local _GSharedCamShaker = _GShared and _GShared.CamShaker

			if _GSharedCamShaker then
				local s1: string = "Explosion"

				pcall(function()
					_GSharedCamShaker:Shake(s1)
				end)
			end
		end

		local color35 = Color3.fromRGB(255, 175, 175)

		postFlash(color35, 0.25, 0.05, 0.8)
	end

	if not __FreezeAt or not (__FreezeAt < shatterAt) then
		local v150 = task.delay
		local v151 = math.max(shatterAt, 0)

		v150(v151, function()
			if u57 then
				v149()
			end
		end)
	end

	local fadeStart = t1.FadeStart

	local function v153()
		u117 = true
		stopEmitters(_fx_Shedletsekkar)
	end

	if not __FreezeAt or not (__FreezeAt < fadeStart) then
		local v154 = task.delay
		local v155 = math.max(fadeStart, 0)

		v154(v155, function()
			if u57 then
				v153()
			end
		end)
	end

	local n11 = t1.FadeStart + t1.FadeTime + 0.8

	if not __FreezeAt or not (__FreezeAt < n11) then
		local v157 = task.delay
		local v158 = math.max(n11, 0)

		v157(v158, function()
			if u57 then
				cleanup()
			end
		end)
	end

	local n12 = 0

	connection = runService.Heartbeat:Connect(function()
		if not u57 then
			return
		end

		local n1 = os.clock() - v113

		if __FreezeAt then
			n1 = math.min(n1, __FreezeAt)
		end

		local v309 = math.clamp(n1 - n12, 0, 0.05)

		n12 = n1

		if n1 >= t1.IgniteAt then
			local n2 = n1 - t1.IgniteAt

			if n2 < 0.2 then
				n7 = if math.floor(n2 * 40) % 3 == 0 then 0.2 else 1.8
			else
				n7 = 2.1 + 0.35 * math.noise(n1 * 9, 3.1)
			end
		end

		n8 = math.max(n8 - v309 * 5, 0)

		if u96 and not u116 and clone5.Parent then
			local n3 = (n1 - t1.PopAt) / t1.PopTime
			local n4 = if n3 < 0 then 0 else if n3 > 1 then 1 else n3

			n3 = math.max((n4 - 1) ^ 3 * 2.70158 + 1 + (n4 - 1) ^ 2 * 1.70158, 0.01)

			local n19 = (1 - (1 - (1 - n4) * (1 - n4))) * -t1.PopSpin

			n4 = 0

			for i, v in ipairs(t1.Pulses) do
				local n6 = n1 - v

				if n6 >= 0 and n6 < 0.22 then
					local pulseSwell = t1.PulseSwell
					local sine = math.sin(n6 / 0.22 * 3.141592653589793)

					n4 += pulseSwell * sine * (1 + (i - 1) * 0.3)
				end
			end

			local n20 = 0

			if n1 > t1.IgniteAt then
				local n21 = (n1 - t1.IgniteAt) / (t1.ShatterAt - t1.IgniteAt)
				local n9 = if n21 < 0 then 0 else if n21 > 1 then 1 else n21

				n20 = n9 * n9
			end

			local v322 = math.rad(n20 * 9 + 1.5)
			local cFrameAngles = CFrame.Angles
			local v324 = math.noise(n1 * 30, 1.7)
			local v325 = math.noise(n1 * 30, 5.3)
			local v326 = math.noise(n1 * 30, 9.1)
			local v327 = cFrameAngles(v324 * v322, v325 * v322 * 0.6, v326 * v322)
			local sine = math.sin(n1 * 3.2)
			local v329 = math.noise(n1 * 40, 2.2)

			n5 = n3 * (n4 + 1)

			local n10 = scale * n5
			local n11 = CFrame.new(vector3 + Vector3.new(0, 1, 0) * (sine * 0.12 + v329 * 0.12 * n20)) * v73.Rotation

			v326 = CFrame.Angles(0, n19, 0)
			u97 = n11 * v326 * v327
			clone5Pumpkin.Size = clone5PumpkinSize * n10
			n11 = u97

			local v332 = clone5PumpkinCFrame
			local cFrame = CFrame.new(v332.Position * n10)

			clone5Pumpkin.CFrame = n11 * (cFrame * v332.Rotation)

			if clone4.Parent then
				clone4.CFrame = CFrame.new(u97.Position - Vector3.new(0, 1.4, 0) * n10)
			end

			v327 = n7 + n8

			local n22 = v327 * t1.FaceEmissive
			local surfaceAppearance2 = clone5Pumpkin:FindFirstChildWhichIsA("SurfaceAppearance")

			if surfaceAppearance2 then
				pcall(function()
					surfaceAppearance2.EmissiveStrength = n22
				end)
			end

			if core then
				core.Brightness = v327 * 0.55
				core.Range = 14
			end

			if u108 then
				layoutAntlers(n1, n10)

				for _, v in ipairs(t3) do
					local vGrown = v.grown
					local n13 = (if vGrown < 0 then 0 else if vGrown > 1 then 1 else vGrown) * t1.AntlerEmissive + n8
					local surfaceAppearance3 = v.part:FindFirstChildWhichIsA("SurfaceAppearance")

					if surfaceAppearance3 then
						pcall(function()
							surfaceAppearance3.EmissiveStrength = n13
						end)
					end
				end
			end
		end

		for _, v in ipairs(t5) do
			if not v.born then
				v.born = n1
			end

			local n14 = n1 - v.born

			v.vel = v.vel - Vector3.new(0, 1, 0) * t1.Gravity * v309

			local n15 = v.pivot + v.vel * v309
			local cFrameFromAxisAngle = CFrame.fromAxisAngle
			local v346 = v.pivot.Rotation:VectorToObjectSpace(v.axis)
			local v347 = cFrameFromAxisAngle(v346, v.spin * v309)

			v.pivot = n15 * v347
			n15 = (n14 - v.life * 0.6) / (v.life * 0.4)

			local n16 = if n15 < 0 then 0 else if n15 > 1 then 1 else n15

			for _, iterValue in ipairs(v.parts) do
				if iterValue.part.Parent then
					iterValue.part.CFrame = v.pivot * iterValue.rel
					iterValue.part.Transparency = n16
				end
			end

			if n16 >= 1 and not v.stopped then
				v.stopped = true

				for _, iterValue2 in ipairs(v.parts) do
					stopEmitters(iterValue2.part)
				end
			end
		end

		for _, v in ipairs(t4) do
			if not v.born then
				v.born = n1
			end

			local n17 = n1 - v.born
			local vPart = v.part

			if vPart.Parent then
				v.vel = v.vel - Vector3.new(0, 1, 0) * t1.Gravity * v309

				local n18 = vPart.CFrame + v.vel * v309
				local v358 = CFrame.fromAxisAngle(v.axis, v.spin * v309)

				vPart.CFrame = n18 * v358
				n18 = (n17 - v.life * 0.6) / (v.life * 0.4)

				local transparency = if n18 < 0 then 0 else if n18 > 1 then 1 else n18

				vPart.Transparency = transparency
				vPart.Size = v.base * (1 - transparency * 0.5)

				if transparency >= 1 then
					vPart:Destroy()
				end
			end
		end
	end)
end
