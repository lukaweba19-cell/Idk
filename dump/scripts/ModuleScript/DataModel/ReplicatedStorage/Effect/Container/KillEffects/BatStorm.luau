-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local tweenService: TweenService = game:GetService("TweenService")
local sound = require(game.ReplicatedStorage.Sound)
local debris = require(game.ReplicatedStorage.Util.Debris)
local forgeVFX = require(game.ReplicatedStorage.Util.ForgeVFX)
local batStorm = game.ReplicatedStorage.FX.KillEffects.BatStorm

local function emit(p1)
	local ok, result = pcall(forgeVFX.emit, p1)

	if not ok then
		local v17 = p1.Name
		local text: string = tostring(result)

		warn("[BatStorm] emit failed on " .. v17 .. ": " .. text)
	end
end
local function stopEmitters(p2)
	for _, v in ipairs(p2:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v.Enabled = false
		end
	end
end

local t1: {[any]: any} = {
	MaxDistance = 1000,
	Tendrils = 8,
	TendrilRate = 26,
	HeroCount = 6,
	HeroRate = 5,
	HeroRadius = 6.2,
	SmokeCount = 6,
	SmokeRate = 10,
	RadiusStart = 5,
	RadiusMid = 2.8,
	RadiusTight = 0.9,
	Tilt = 0.3490658503988659,
	SpinStart = 3,
	SpinMid = 11,
	SpinTight = 22,
	HeroSpin = -1.8,
	FormTime = 1.7,
	ArcsFrom = 0.5,
	TightenAt = 1.75,
	BurstAt = 2,
	Cleanup = 4.8,
	Lift = 2.4,
	BlastBats = 90,
	ShakeNear = 20,
	ShakeFar = 110,
	Red = Color3.fromRGB(230, 25, 45)
}

local function shake(p3, p4, p5, p6, p7)
	local v27 = _G.Shared and _G.Shared.CamShaker

	if not v27 then
		return
	end

	local n1 = 1 - math.clamp(((workspace.CurrentCamera.CFrame.Position - p3).Magnitude - t1.ShakeNear) / (t1.ShakeFar - t1.ShakeNear), 0, 1)

	if n1 <= 0 then
		return
	end

	pcall(function()
		v27:ShakeOnce(p4 * n1, p5, p6, p7)
	end)
end
local function host(name, parent)
	local part: Part = Instance.new("Part")

	part.Name = name
	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	part.CastShadow = false
	part.Transparency = 1
	part.Size = Vector3.new(0.2, 0.2, 0.2)
	part.Parent = parent

	return part
end
local function lerp(p10, p11, p12)
	return p10 + (p11 - p10) * p12
end
local function smooth(p13)
	local v36 = math.clamp(p13, 0, 1)

	return v36 * v36 * (3 - 2 * v36)
end

return function(player)
	local Character = player.Character

	if not Character or not Character.Parent then
		return
	end

	if (workspace.CurrentCamera.CFrame.Position - Character:GetPivot().Position).Magnitude > t1.MaxDistance then
		return
	end

	local v39 = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

	if not v39 or not v39:IsA("BasePart") then
		return
	end

	local _fx_BatStorm: Folder = Instance.new("Folder")

	_fx_BatStorm.Name = "_FX_BatStorm"
	_fx_BatStorm.Parent = workspace.Bin
	debris:AddItem(_fx_BatStorm, t1.Cleanup + 1.5)

	local u41: boolean = true
	local t2: {[any]: any} = {}

	table.insert(t2, Character.AncestryChanged:Connect(function()
		if not Character:IsDescendantOf(game) then
			if u41 then
				u41 = false

				for _, v in ipairs(t2) do
					v:Disconnect()
				end
			end

			_fx_BatStorm:Destroy()
		end
	end))

	local function at(p15, p16)
		task.delay(p15, function()
			if u41 then
				p16()
			end
		end)
	end

	local t3: {[any]: any} = {}
	local cFrame = v39.CFrame

	for _, v in ipairs(Character:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Anchored = true

			local v48 = cFrame:ToObjectSpace(v.CFrame)

			table.insert(t3, { part = v, rel = v48, t0 = v.Transparency })
		end
	end

	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = { workspace.Characters, workspace.Bin, Character }

	local v50 = workspace:Raycast(v39.Position + Vector3.new(0, 1, 0), Vector3.new(0, -12, 0), raycastParams)
	local vector3 = Vector3.new(v39.Position.X, v50 and v50.Position.Y or v39.Position.Y - 3, v39.Position.Z)
	local highlight: Highlight = Instance.new("Highlight")

	highlight.FillColor = Color3.new(0, 0, 0)
	highlight.OutlineColor = t1.Red
	highlight.FillTransparency = 1
	highlight.OutlineTransparency = 1
	highlight.DepthMode = Enum.HighlightDepthMode.Occluded
	highlight.Adornee = Character
	highlight.Parent = _fx_BatStorm

	local tweenInfo = TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

	tweenService:Create(highlight, tweenInfo, { FillTransparency = 0.1, OutlineTransparency = 0.2 }):Play()

	local bodyHost: Part = Instance.new("Part")

	bodyHost.Name = "BodyHost"
	bodyHost.Anchored = true
	bodyHost.CanCollide = false
	bodyHost.CanQuery = false
	bodyHost.CanTouch = false
	bodyHost.CastShadow = false
	bodyHost.Transparency = 1
	bodyHost.Size = Vector3.new(0.2, 0.2, 0.2)
	bodyHost.Parent = _fx_BatStorm

	local v55, v56 = Character:GetBoundingBox()
	local v57 = math.min(v56.X, 3)
	local v58 = math.min(v56.Y, 5.5)
	local v59 = math.min(v56.Z, 1.6)

	bodyHost.Size = Vector3.new(v57, v58, v59)

	local clone = batStorm.PeelBat:Clone()

	clone.Parent = bodyHost
	clone.Rate = 8
	clone.Enabled = true
	sound:Play("KillEffects.BatStorm.Wind", v39)
	sound:Play("KillEffects.BatStorm.Wings", v39)

	local function v61()
		sound:Play("KillEffects.BatStorm.Wings2", v39)
	end

	task.delay(0.6, function()
		if u41 then
			v61()
		end
	end)

	local function v62()
		sound:Play("KillEffects.BatStorm.Riser", v39)
	end

	task.delay(0.35, function()
		if u41 then
			v62()
		end
	end)
	shake(vector3, 0.7, 3.5, 0.6, 1.6)

	local clone2 = batStorm.Ground:Clone()

	clone2.CFrame = CFrame.new(vector3 + Vector3.new(0, 0.15, 0))
	clone2.Parent = _fx_BatStorm

	local clone2Hold = clone2.Hold
	local ok, result = pcall(forgeVFX.emit, clone2Hold)

	if not ok then
		local clone2HoldName = clone2Hold.Name
		local text: string = tostring(result)

		warn("[BatStorm] emit failed on " .. clone2HoldName .. ": " .. text)
	end

	local clone2Rise_Smoke = clone2.Rise_Smoke
	local ok2, result2 = pcall(forgeVFX.emit, clone2Rise_Smoke)

	if not ok2 then
		local clone2Rise_SmokeName = clone2Rise_Smoke.Name
		local text: string = tostring(result2)

		warn("[BatStorm] emit failed on " .. clone2Rise_SmokeName .. ": " .. text)
	end

	local clone2Rise_Embers = clone2.Rise_Embers
	local ok3, result3 = pcall(forgeVFX.emit, clone2Rise_Embers)

	if not ok3 then
		local clone2Rise_EmbersName = clone2Rise_Embers.Name
		local text: string = tostring(result3)

		warn("[BatStorm] emit failed on " .. clone2Rise_EmbersName .. ": " .. text)
	end

	local gush: Part = Instance.new("Part")

	gush.Name = "Gush"
	gush.Anchored = true
	gush.CanCollide = false
	gush.CanQuery = false
	gush.CanTouch = false
	gush.CastShadow = false
	gush.Transparency = 1
	gush.Size = Vector3.new(0.2, 0.2, 0.2)
	gush.Parent = _fx_BatStorm
	gush.Size = Vector3.new(3, 0.2, 3)
	gush.CFrame = CFrame.new(vector3 + Vector3.new(0, 0.3, 0))

	local clone3 = batStorm.StragglerBat:Clone()

	clone3.Speed = NumberRange.new(14, 22)
	clone3.SpreadAngle = Vector2.new(25, 25)
	clone3.Lifetime = NumberRange.new(0.6, 1)
	clone3.Parent = gush
	clone3:Emit(28)

	local vortex: Part = Instance.new("Part")

	vortex.Name = "Vortex"
	vortex.Anchored = true
	vortex.CanCollide = false
	vortex.CanQuery = false
	vortex.CanTouch = false
	vortex.CastShadow = false
	vortex.Transparency = 1
	vortex.Size = Vector3.new(0.2, 0.2, 0.2)
	vortex.Parent = _fx_BatStorm
	vortex.CFrame = CFrame.new(vector3)

	local heroRing: Part = Instance.new("Part")

	heroRing.Name = "HeroRing"
	heroRing.Anchored = true
	heroRing.CanCollide = false
	heroRing.CanQuery = false
	heroRing.CanTouch = false
	heroRing.CastShadow = false
	heroRing.Transparency = 1
	heroRing.Size = Vector3.new(0.2, 0.2, 0.2)
	heroRing.Parent = _fx_BatStorm
	heroRing.CFrame = CFrame.new(vector3)

	local t4: {[any]: any} = {}

	for i = 1, t1.Tendrils do
		local attachment: Attachment = Instance.new("Attachment")

		attachment.Parent = vortex

		local clone4 = batStorm.SwarmBat:Clone()

		clone4.Parent = attachment

		local clone5 = batStorm.StormArc:Clone()

		clone5.Parent = attachment

		local n1 = (i - 1) / t1.Tendrils * 3.141592653589793 * 2
		local randomNumber = math.random()

		table.insert(t4, {
			att = attachment,
			bat = clone4,
			arc = clone5,
			phase = n1,
			h = (i - 1) % 3 * 0.7,
			wob = randomNumber * 6.28
		})
	end

	local t5: {[any]: any} = {}

	for i = 1, t1.SmokeCount do
		local attachment2: Attachment = Instance.new("Attachment")

		attachment2.Parent = vortex

		local clone6 = batStorm.FunnelSmoke:Clone()

		clone6.Parent = attachment2
		table.insert(t5, {
			att = attachment2,
			e = clone6,
			phase = (i - 0.5) / t1.SmokeCount * 3.141592653589793 * 2
		})
	end

	local t6: {[any]: any} = {}

	for i = 1, t1.HeroCount do
		local attachment3: Attachment = Instance.new("Attachment")
		local n2 = (i - 1) / t1.HeroCount * 3.141592653589793 * 2
		local cFrameNew = CFrame.new
		local n3 = math.cos(n2) * t1.HeroRadius
		local sine = math.sin(n2)

		attachment3.CFrame = cFrameNew(n3, i % 2 * 1.6 + 0.8, sine * t1.HeroRadius)
		attachment3.Parent = heroRing

		local clone7 = batStorm.HeroBat:Clone()

		clone7.Parent = attachment3
		table.insert(t6, clone7)
	end

	local attachment4: Attachment = Instance.new("Attachment")

	attachment4.Position = Vector3.new(0, 3.2, 0)
	attachment4.Parent = vortex

	local clone8 = batStorm.FunnelGlow:Clone()

	clone8.Parent = attachment4

	local pointLight: PointLight = Instance.new("PointLight")

	pointLight.Color = t1.Red
	pointLight.Range = 16
	pointLight.Brightness = 0
	pointLight.Shadows = false
	pointLight.Parent = attachment4
	tweenService:Create(pointLight, TweenInfo.new(1.6), { Brightness = 2.2 }):Play()

	local t7: {[any]: any} = {}
	local clone9 = batStorm.StormCrackle:Clone()

	clone9.Parent = vortex
	table.insert(t7, clone9)

	local clone10 = batStorm.StormCrackle:Clone()

	clone10.Parent = vortex
	table.insert(t7, clone10)

	local clone11 = batStorm.StormCrackle:Clone()

	clone11.Parent = vortex
	table.insert(t7, clone11)

	for i, v in ipairs(t4) do
		local function v111()
			v.bat.Rate = t1.TendrilRate
			v.bat.Enabled = true
		end

		task.delay(0.06 * i, function()
			if u41 then
				v111()
			end
		end)
	end

	local function v112()
		for _, v in ipairs(t5) do
			v.e.Rate = t1.SmokeRate
			v.e.Enabled = true
		end
	end

	task.delay(0.15, function()
		if u41 then
			v112()
		end
	end)

	local function v113()
		for _, v in ipairs(t6) do
			v.Rate = t1.HeroRate
			v.Enabled = true
		end
	end

	task.delay(0.25, function()
		if u41 then
			v113()
		end
	end)

	local n4 = 0
	local n5 = 0
	local v116 = os.clock()
	local arcsFrom = t1.ArcsFrom
	local u118 = t1.ArcsFrom
	local u119: boolean = false

	table.insert(t2, runService.Heartbeat:Connect(function(deltaTime: number)
		local n1 = os.clock() - v116

		if u119 then
			return
		end

		local v133 = math.clamp(n1 / t1.FormTime, 0, 1)
		local n2 = v133 * v133 * (3 - 2 * v133)
		local v135 = math.clamp((n1 - t1.TightenAt) / (t1.BurstAt - t1.TightenAt), 0, 1)

		v133 = v135 * v135 * (3 - 2 * v135)

		local spinStart = t1.SpinStart
		local n3 = spinStart + (t1.SpinMid - spinStart) * n2
		local radiusStart = t1.RadiusStart
		local n7 = radiusStart + (t1.RadiusMid - radiusStart) * n2
		local n8 = n7 + (t1.RadiusTight - n7) * v133

		n4 += (n3 + (t1.SpinTight - n3) * v133) * deltaTime
		n5 += t1.HeroSpin * deltaTime

		local cFrame3 = CFrame.new(vector3)
		local v142 = CFrame.Angles(0, n4, 0)

		vortex.CFrame = cFrame3 * v142

		local cFrame2 = CFrame.new(vector3)

		v142 = CFrame.Angles(0, n5, 0)
		heroRing.CFrame = cFrame2 * v142

		for _, v in ipairs(t4) do
			local sine2 = math.sin(n1 * 5 + v.wob)
			local cosine = math.cos(v.phase)
			local sine3 = math.sin(v.phase)
			local vector32 = Vector3.new(cosine, 0, sine3)
			local cosine2 = math.cos(t1.Tilt)
			local sine4 = math.sin(t1.Tilt)
			local unit = (Vector3.new(0, 1, 0) * cosine2 + vector32 * sine4).Unit
			local v153 = unit:Cross(vector32).Unit
			local vAtt = v.att
			local cFrameFromMatrix = CFrame.fromMatrix
			local vector33 = Vector3.new(0, v.h, 0)

			vAtt.CFrame = cFrameFromMatrix(vector32 * (n8 + sine2 * 0.25) + vector33, v153, unit)
		end

		for _, v in ipairs(t5) do
			local cosine3 = math.cos(v.phase)
			local sine5 = math.sin(v.phase)
			local vector34 = Vector3.new(cosine3, 0, sine5)
			local cosine4 = math.cos(t1.Tilt)
			local sine6 = math.sin(t1.Tilt)
			local v164 = (Vector3.new(0, 1, 0) * cosine4 + vector34 * sine6).Unit
			local v165 = v.att
			local v166 = CFrame.fromMatrix
			local v167 = v164:Cross(vector34)

			v165.CFrame = v166(vector34 * n8 * 0.85, v167.Unit, v164)
		end

		n7 = math.clamp(n1 / 1.6, 0, 1)
		n8 = n7 * n7 * (3 - 2 * n7)

		local cFrameNew = CFrame.new
		local n6 = t1.Lift * n8
		local sine7 = math.sin(n1 * 9)

		v142 = cFrameNew(0, n6 + sine7 * 0.05 * n8, 0)

		local v171 = CFrame.Angles(-0.20943951023931956 * n8, n1 * 1.4 * n8 + n1 * 6 * v133, 0)

		n7 = cFrame * v142 * v171

		for _, v in ipairs(t3) do
			if v.part.Parent then
				v.part.CFrame = n7 * v.rel
			end
		end

		bodyHost.CFrame = n7

		local v174 = math.clamp((n1 - 0.3) / 1.5, 0, 1)

		clone.Rate = 8 + 62 * (v174 * v174 * (3 - 2 * v174))

		local v175 = math.clamp((n1 - 1.2) / 0.75, 0, 1)

		n7 = v175 * v175 * (3 - 2 * v175)

		if n7 > 0 then
			for _, v in ipairs(t3) do
				if v.part.Parent and v.t0 < 1 then
					local vT0 = v.t0

					v.part.Transparency = vT0 + (1 - vT0) * n7
				end
			end
		end

		if n1 >= arcsFrom then
			local randomNumber2 = math.random(1, #t4)

			t4[randomNumber2].arc:Emit(1)

			local v180 = math.clamp((n1 - t1.ArcsFrom) / 1.4, 0, 1)

			arcsFrom = n1 + (0.16 + -0.11 * (v180 * v180 * (3 - 2 * v180)))
		end

		if n1 >= u118 then
			u118 = n1 + 0.06

			for _, v in ipairs(t7) do
				if math.random() < 0.25 + 0.44999999999999996 * n2 then
					local randomNumber3 = math.random(1, #t4)
					local att = t4[randomNumber3].att
					local randomNumber4 = math.random(1, #t4)
					local attachment1 = t4[randomNumber4].att

					if att ~= attachment1 then
						v.Attachment0 = att
						v.Attachment1 = attachment1
						v.CurveSize0 = math.random(-30, 30) / 10
						v.CurveSize1 = math.random(-30, 30) / 10
						v.Enabled = true
					end
				else
					v.Enabled = false
				end
			end
		end
	end))

	local function v120()
		for _, v in ipairs(t5) do
			v.e.Rate = t1.SmokeRate * 1.8
		end

		clone8:Emit(2)
		tweenService:Create(pointLight, TweenInfo.new(0.25), { Brightness = 5, Range = 20 }):Play()
		shake(vector3, 1, 8, 0.15, 0.3)
	end

	task.delay(t1.TightenAt, function()
		if u41 then
			v120()
		end
	end)

	local function v121()
		clone8:Emit(2)
	end

	task.delay(t1.TightenAt + 0.12, function()
		if u41 then
			v121()
		end
	end)

	local function v122()
		u119 = true

		local v189 = v39.Parent and v39.Position or vector3 + Vector3.new(0, 3, 0)

		for _, v in ipairs(t4) do
			v.bat.Enabled = false
			v.bat:Clear()
		end

		for _, v in ipairs(t5) do
			v.e.Enabled = false
		end

		for _, v in ipairs(t6) do
			v.Enabled = false
			v:Clear()
		end

		for _, v in ipairs(t7) do
			v.Enabled = false
		end

		clone.Enabled = false
		clone:Clear()
		highlight.Enabled = false

		for _, v in ipairs(t3) do
			if v.part.Parent then
				v.part.Transparency = 1
			end
		end

		for _, v in ipairs(Character:GetDescendants()) do
			if v:IsA("Decal") or v:IsA("Texture") then
				v.Transparency = 1
			elseif v:IsA("ParticleEmitter") or v:IsA("Beam") or v:IsA("Trail") or v:IsA("Light") or v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
				v.Enabled = false
			end
		end

		sound:Play("KillEffects.BatStorm.Explode", v39)
		sound:Play("KillEffects.BatStorm.Bass", v39)
		shake(v189, 2.8, 10, 0.03, 0.75)

		local blast: Part = Instance.new("Part")

		blast.Name = "Blast"
		blast.Anchored = true
		blast.CanCollide = false
		blast.CanQuery = false
		blast.CanTouch = false
		blast.CastShadow = false
		blast.Transparency = 1
		blast.Size = Vector3.new(0.2, 0.2, 0.2)
		blast.Parent = _fx_BatStorm
		blast.Size = Vector3.new(2.5, 5, 2.5)
		blast.CFrame = CFrame.new(v189)

		local clone12 = batStorm.BlastBat:Clone()

		clone12.Parent = blast
		clone12:Emit(t1.BlastBats)

		local clone13 = batStorm.Burst:Clone()

		clone13.CFrame = CFrame.new(v189)
		clone13.Parent = _fx_BatStorm

		local ok4, result4 = pcall(forgeVFX.emit, clone13)

		if not ok4 then
			local clone13Name = clone13.Name
			local text: string = tostring(result4)

			warn("[BatStorm] emit failed on " .. clone13Name .. ": " .. text)
		end

		local pointLight2 = clone13:FindFirstChildOfClass("PointLight")

		if pointLight2 then
			pointLight2.Range = 26
			pointLight2.Brightness = 7

			local tweenInfo2 = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

			tweenService:Create(pointLight2, tweenInfo2, { Brightness = 0 }):Play()
		end

		tweenService:Create(pointLight, TweenInfo.new(0.3), { Brightness = 0 }):Play()
		stopEmitters(clone2.Hold)

		local clone2Burst = clone2.Burst
		local ok5, result5 = pcall(forgeVFX.emit, clone2Burst)

		if not ok5 then
			local clone2BurstName = clone2Burst.Name
			local text: string = tostring(result5)

			warn("[BatStorm] emit failed on " .. clone2BurstName .. ": " .. text)
		end

		local clone2Radial = clone2.Radial
		local ok6, result6 = pcall(forgeVFX.emit, clone2Radial)

		if not ok6 then
			local clone2RadialName = clone2Radial.Name
			local text: string = tostring(result6)

			warn("[BatStorm] emit failed on " .. clone2RadialName .. ": " .. text)
		end

		local clone14 = batStorm.StragglerBat:Clone()

		clone14.Parent = blast
		clone14.Rate = 26
		clone14.Enabled = true
		task.delay(0.7, function()
			clone14.Enabled = false
		end)
		task.delay(0.15, function()
			if clone2.Parent then
				local clone2Residue_Mist = clone2.Residue_Mist
				local ok7, result7 = pcall(forgeVFX.emit, clone2Residue_Mist)

				if not ok7 then
					local clone2Residue_MistName = clone2Residue_Mist.Name
					local text: string = tostring(result7)

					warn("[BatStorm] emit failed on " .. clone2Residue_MistName .. ": " .. text)
				end

				local clone2Residue_Embers = clone2.Residue_Embers
				local ok8, result8 = pcall(forgeVFX.emit, clone2Residue_Embers)

				if not ok8 then
					local clone2Residue_EmbersName = clone2Residue_Embers.Name
					local text: string = tostring(result8)

					warn("[BatStorm] emit failed on " .. clone2Residue_EmbersName .. ": " .. text)
				end
			end
		end)
	end

	task.delay(t1.BurstAt, function()
		if u41 then
			v122()
		end
	end)
	task.delay(t1.Cleanup, function()
		if not u41 then
			return
		end

		u41 = false

		for _, v in ipairs(t2) do
			v:Disconnect()
		end
	end)
end
