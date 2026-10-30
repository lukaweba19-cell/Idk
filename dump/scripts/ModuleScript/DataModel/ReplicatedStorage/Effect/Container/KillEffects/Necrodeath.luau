-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local tweenService: TweenService = game:GetService("TweenService")
local lighting: Lighting = game:GetService("Lighting")
local sound = require(game.ReplicatedStorage.Sound)
local debris = require(game.ReplicatedStorage.Util.Debris)
local forgeVFX = require(game.ReplicatedStorage.Util.ForgeVFX)
local necrodeath = game.ReplicatedStorage.FX.KillEffects.Necrodeath
local t1: {[any]: any} = { "Torso", "Head", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }
local v9 = CFrame.Angles(-0.13962634015954636, 0, 0)
local v10 = CFrame.Angles(-0.3839724354387525, 0, 0)
local v11 = CFrame.Angles(-0.17453292519943295, 0, 1.2217304763960306)
local v12 = CFrame.Angles(-0.17453292519943295, 0, -1.2217304763960306)
local v13 = CFrame.Angles(0.13962634015954636, 0, 0.17453292519943295)
local v14 = CFrame.Angles(-0.10471975511965978, 0, -0.17453292519943295)
local color3 = Color3.fromRGB(58, 52, 70)
local color32 = Color3.fromRGB(26, 10, 44)
local glass = Enum.Material.Glass
local color33 = Color3.fromRGB(44, 16, 78)
local v19 = Enum.Material.Glass
local color34 = Color3.fromRGB(150, 80, 255)
local neon = Enum.Material.Neon
local color35 = Color3.fromRGB(205, 160, 255)

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
local function quadIn(p3)
	return p3 * p3
end
local function quadOut(p4)
	return 1 - (1 - p4) * (1 - p4)
end
local function cubicIn(p5)
	return p5 * p5 * p5
end
local function backOut(p6)
	return (p6 - 1) ^ 3 * 2.70158 + 1 + (p6 - 1) ^ 2 * 1.70158
end

backOut = function(p7)
	if not p7 then
		return
	end

	local ok, result = pcall(forgeVFX.emit, p7)

	if not ok then
		local v45 = p7.Name
		local text: string = tostring(result)

		warn("[Necrodeath] emit failed on " .. v45 .. ": " .. text)
	end
end

local function stopEmitters(p8)
	for _, v in ipairs(p8:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v.Enabled = false
		end
	end
end
local function flashLight(p9, p10)
	p9.Range = p10.Range
	p9.Brightness = 0

	local tweenInfo = TweenInfo.new(p10.Up, Enum.EasingStyle.Linear)
	local v53: Tween = tweenService:Create(p9, tweenInfo, { Brightness = p10.Brightness })

	v53.Completed:Once(function()
		local tweenInfo2 = TweenInfo.new(p10.Down, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

		tweenService:Create(p9, tweenInfo2, { Brightness = 0 }):Play()
	end)
	v53:Play()
end
local function newPart(name, parent)
	local part: Part = Instance.new("Part")

	part.Name = name
	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	part.CastShadow = false
	part.Size = Vector3.new(0.2, 0.2, 0.2)
	part.Transparency = 1
	part.Parent = parent

	return part
end
local function hidePart(p13, p14)
	p14.LocalTransparencyModifier = 1

	for _, v in ipairs(p14:GetDescendants()) do
		if v:IsA("BasePart") or v:IsA("Decal") then
			v.LocalTransparencyModifier = 1
		end
	end

	if p14.Name == "Head" then
		for _, v in ipairs(p13:GetChildren()) do
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

local t2: {[any]: any} = {
	MaxDistance = 1000,
	Lift = 1.8,
	LiftTime = 0.5,
	DrainTime = 0.6,
	WringStart = 0.45,
	WringTurns = 1.35,
	SpinMax = 9,
	Crush = 0.32,
	Tremble = 0.06,
	BladeCount = 6,
	BladeIn = 0.1,
	BladeRadius0 = 7,
	BladeRadius1 = 2.4,
	BladeSpeed0 = 3.5,
	BladeSpeed1 = 15,
	BladeWidth = 2.2,
	BladeTilt = 22,
	CoreOpen = 1.3,
	CoreSize0 = 0.25,
	CoreSize1 = 1.1,
	CoreSizeFull = 1.6,
	PinchTime = 1.8,
	ShatterTime = 1.92,
	ShardCount = {
		Torso = 12,
		Head = 6,
		["Left Arm"] = 6,
		["Right Arm"] = 6,
		["Left Leg"] = 6,
		["Right Leg"] = 6
	},
	ShardBurst = 0.16,
	ShardBurstSpeed = 16,
	ShardSuck0 = 0.4,
	ShardSuck1 = 0.62,
	CollapseTime = 2.6,
	ImplodeTime = 2.7,
	ShatterFlash = { Brightness = 6, Range = 30, Up = 0.02, Down = 0.3 },
	ImplodeFlash = { Brightness = 10, Range = 44, Up = 0.02, Down = 0.5 },
	ShakeDistance = 70,
	PostDistance = 60,
	FadeStart = 3.7,
	FadeTime = 1,
	CleanupAfter = 8
}
local t3: {[any]: any} = {
	Torso = v9,
	Head = CFrame.new(0, 1.5, 0.1) * v10,
	["Right Arm"] = CFrame.new(1.25, 0.75, 0) * v11 * CFrame.new(0, -1, 0),
	["Left Arm"] = CFrame.new(-1.25, 0.75, 0) * v12 * CFrame.new(0, -1, 0),
	["Right Leg"] = CFrame.new(0.5, -1, 0) * v13 * CFrame.new(0, -1, 0),
	["Left Leg"] = CFrame.new(-0.5, -1, 0) * v14 * CFrame.new(0, -1, 0)
}
local t4: {[any]: any} = {
	{ reflect = 0.35, color = color32, material = glass },
	{ reflect = 0.25, color = color33, material = v19 },
	{ reflect = 0, color = color34, material = neon },
	{ reflect = 0, color = color35, material = Enum.Material.Neon }
}

return function(player)
	local Character = player.Character

	if not Character or not Character.Parent then
		return
	end

	local CurrentCamera: Camera = workspace.CurrentCamera
	local CFramePosition = CurrentCamera.CFrame.Position
	local pivot = Character:GetPivot()

	if (CFramePosition - pivot.Position).Magnitude > t2.MaxDistance then
		return
	end

	local torso = Character:FindFirstChild("Torso")

	if not torso or not torso:IsA("BasePart") then
		return
	end

	local _fx_Necrodeath: Folder = Instance.new("Folder")

	_fx_Necrodeath.Name = "_FX_Necrodeath"
	_fx_Necrodeath.Parent = workspace.Bin

	local u72: boolean = true
	local u73: boolean = false
	local connection3 = nil
	local connection = nil
	local t5: {[any]: any} = {}
	local t6: {[any]: any} = {}
	local t7: {[any]: any} = {}
	local u79 = nil
	local __FreezeAt = player.__FreezeAt

	local function own(p16)
		table.insert(t5, p16)

		return p16
	end
	local function cleanup()
		if not u72 then
			return
		end

		u72 = false

		if connection3 then
			connection3:Disconnect()
		end

		if connection then
			connection:Disconnect()
		end

		if u79 then
			pcall(function()
				u79:Destroy()
			end)
		end

		for _, v in ipairs(t5) do
			pcall(game.Destroy, v)
		end

		table.clear(t5)
		_fx_Necrodeath:Destroy()
	end

	connection = Character.AncestryChanged:Connect(function()
		if not Character:IsDescendantOf(game) then
			u73 = true

			for _, v in pairs(t7) do
				v.gone = true
			end

			if connection then
				connection:Disconnect()
			end
		end
	end)
	task.delay(t2.CleanupAfter, cleanup)

	local function at(p17, p18)
		if __FreezeAt and p17 > __FreezeAt then
			return
		end

		local taskDelay = task.delay
		local v209 = math.max(p17, 0)

		taskDelay(v209, function()
			if u72 then
				p18()
			end
		end)
	end

	local lookVector = torso.CFrame.LookVector
	local vector3 = Vector3.new(lookVector.X, 0, lookVector.Z)

	vector3 = if vector3.Magnitude > 0.05 then vector3.Unit else Vector3.new(0, 0, -1)

	local torsoPosition = torso.Position
	local t8 = { Character, workspace.Bin }
	local characters: Instance = workspace:FindFirstChild("Characters")

	if characters then
		table.insert(t8, characters)
	end

	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = t8
	t8 = workspace:Raycast(torsoPosition + Vector3.new(0, 2, 0), Vector3.new(0, -18, 0), raycastParams)

	local v90 = if t8 then t8.Position.Y else torsoPosition.Y - 3
	local v91 = math.max(torsoPosition.Y, v90 + 3)
	local vector32 = Vector3.new(torsoPosition.X, v91 + t2.Lift, torsoPosition.Z)
	local v93 = CFrame.lookAt(vector32, vector32 + vector3)
	local n1 = vector32 + Vector3.new(0, 0.3, 0)

	for i, v in ipairs(t1) do
		local v2 = Character:FindFirstChild(v)

		if v2 and v2:IsA("BasePart") then
			v2.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			v2.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			v2.Anchored = true

			local v98 = t3[v]

			t7[v] = {
				gone = false,
				part = v2,
				name = v,
				from = v2.CFrame,
				pose = v98,
				h = v98.Position.Y,
				seed = i * 17
			}
		end
	end

	local function v99()
		local tweenInfo = TweenInfo.new(t2.DrainTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		for _, v in pairs(t7) do
			t6[v.part] = v.part.Color

			local vPart = v.part
			local v214 = v.part.Color:Lerp(color3, 0.85)

			tweenService:Create(vPart, tweenInfo, { Color = v214 }):Play()
		end

		local shirt = Character:FindFirstChildOfClass("Shirt")
		local pants = Character:FindFirstChildOfClass("Pants")

		for _, v in ipairs({ shirt, pants }) do
			if v then
				local color36 = Color3.fromRGB(110, 100, 130)

				tweenService:Create(v, tweenInfo, { Color3 = color36 }):Play()
			end
		end

		local _NecroVoid: Highlight = Instance.new("Highlight")

		table.insert(t5, _NecroVoid)
		_NecroVoid.Name = "_NecroVoid"
		_NecroVoid.FillColor = Color3.fromRGB(30, 0, 60)
		_NecroVoid.FillTransparency = 1
		_NecroVoid.OutlineColor = Color3.fromRGB(170, 100, 255)
		_NecroVoid.OutlineTransparency = 1
		_NecroVoid.DepthMode = Enum.HighlightDepthMode.Occluded
		_NecroVoid.Parent = Character
		tweenService:Create(_NecroVoid, tweenInfo, { FillTransparency = 0.55, OutlineTransparency = 0.2 }):Play()
	end

	if not __FreezeAt or not (__FreezeAt < 0) then
		task.delay(0, function()
			if u72 then
				v99()
			end
		end)
	end

	local clone = necrodeath.Ground:Clone()

	clone.CFrame = CFrame.new(vector32.X, v90 + 0.15, vector32.Z)
	clone.Parent = _fx_Necrodeath

	local cloneHold = clone.Hold

	if cloneHold then
		local ok, result = pcall(forgeVFX.emit, cloneHold)

		if not ok then
			local cloneHoldName = cloneHold.Name
			local text: string = tostring(result)

			warn("[Necrodeath] emit failed on " .. cloneHoldName .. ": " .. text)
		end
	end

	local cloneRise_Embers = clone.Rise_Embers

	if cloneRise_Embers then
		local ok, result = pcall(forgeVFX.emit, cloneRise_Embers)

		if not ok then
			local cloneRise_EmbersName = cloneRise_Embers.Name
			local text: string = tostring(result)

			warn("[Necrodeath] emit failed on " .. cloneRise_EmbersName .. ": " .. text)
		end
	end

	local cloneRise_Smoke = clone.Rise_Smoke

	if cloneRise_Smoke then
		local ok, result = pcall(forgeVFX.emit, cloneRise_Smoke)

		if not ok then
			local cloneRise_SmokeName = cloneRise_Smoke.Name
			local text: string = tostring(result)

			warn("[Necrodeath] emit failed on " .. cloneRise_SmokeName .. ": " .. text)
		end
	end

	local cloneLight = clone.Light
	local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Sine)

	tweenService:Create(cloneLight, tweenInfo, { Brightness = 1.2 }):Play()
	sound:Play("KillEffects.Necrodeath.Open", clone)

	local v118, v119 = sound:Play("KillEffects.Necrodeath.Drone", clone)

	u79 = v119

	local clone2 = necrodeath.Gather:Clone()

	clone2.CFrame = CFrame.new(n1)
	clone2.Parent = _fx_Necrodeath

	local function v121()
		local v221 = clone2

		if not v221 then
			return
		end

		local ok, result = pcall(forgeVFX.emit, v221)

		if not ok then
			local v224 = v221.Name
			local text: string = tostring(result)

			warn("[Necrodeath] emit failed on " .. v224 .. ": " .. text)
		end
	end

	if not __FreezeAt or not (__FreezeAt < 0.15) then
		task.delay(0.15, function()
			if u72 then
				v121()
			end
		end)
	end

	local t9: {[any]: any} = {}
	local random = Random.new(1337)

	for i = 1, t2.BladeCount do
		local part: Part = Instance.new("Part")

		part.Name = "Blade" .. i
		part.Anchored = true
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false
		part.CastShadow = false
		part.Size = Vector3.new(0.2, 0.2, 0.2)
		part.Transparency = 1
		part.Parent = _fx_Necrodeath

		local inner: Attachment = Instance.new("Attachment")

		inner.Name = "Inner"
		inner.Position = Vector3.new(-t2.BladeWidth / 2, 0, 0)
		inner.Parent = part

		local outer: Attachment = Instance.new("Attachment")

		outer.Name = "Outer"
		outer.Position = Vector3.new(t2.BladeWidth / 2, 0, 0)
		outer.Parent = part

		local t10: {[any]: any} = {}

		for _, v in ipairs(necrodeath.Blade:GetChildren()) do
			if v:IsA("Trail") then
				local clone3 = v:Clone()

				clone3.Attachment0 = inner
				clone3.Attachment1 = outer
				clone3.Enabled = false
				clone3.Parent = part
				table.insert(t10, clone3)
			end
		end

		local edge = necrodeath.Blade:FindFirstChild("Edge")
		local clone4 = nil

		if edge then
			clone4 = edge:Clone()
			clone4.Enabled = false
			clone4.Parent = outer
		end

		local cosine = math.cos(i * 1.7)
		local sine = math.sin(i * 1.7)
		local vector33 = Vector3.new(cosine, 0, sine)
		local n2 = (i - 1) / t2.BladeCount * 3.141592653589793 * 2
		local v138 = random:NextNumber(-0.2, 0.2)
		local t11: {[any]: any} = {
			angle = 0,
			live = false,
			gone = false,
			carrier = part,
			trails = t10,
			edge = clone4,
			phase = n2,
			height = (i % 3 - 1) * 0.9 + v138
		}
		local cFrameFromAxisAngle = CFrame.fromAxisAngle
		local v141 = math.rad(t2.BladeTilt)

		t11.tilt = cFrameFromAxisAngle(vector33, v141 * (if i % 2 == 0 then 1 else -1))
		table.insert(t9, t11)
	end

	local bladeIn = t2.BladeIn

	local function v143()
		for _, v in ipairs(t9) do
			v.live = true

			for _, iterValue in ipairs(v.trails) do
				iterValue.Enabled = true
			end

			if v.edge then
				v.edge.Enabled = true
			end
		end

		sound:Play("KillEffects.Necrodeath.Blades", clone)
	end

	if not __FreezeAt or not (__FreezeAt < bladeIn) then
		local taskDelay = task.delay
		local v145 = math.max(bladeIn, 0)

		taskDelay(v145, function()
			if u72 then
				v143()
			end
		end)
	end

	local function v146()
		sound:Play("KillEffects.Necrodeath.Whoosh", clone, nil, nil, nil, 0.08)
	end

	if not __FreezeAt or not (__FreezeAt < 0.75) then
		task.delay(0.75, function()
			if u72 then
				v146()
			end
		end)
	end

	local function v147()
		sound:Play("KillEffects.Necrodeath.Whoosh", clone, nil, 1.15, nil, 0.08)
	end

	if not __FreezeAt or not (__FreezeAt < 1.3) then
		task.delay(1.3, function()
			if u72 then
				v147()
			end
		end)
	end

	local wringStart = t2.WringStart

	local function v149()
		if u73 then
			return
		end

		sound:Play("KillEffects.Necrodeath.Twist", torso)
	end

	if not __FreezeAt or not (__FreezeAt < wringStart) then
		local v150 = task.delay
		local v151 = math.max(wringStart, 0)

		v150(v151, function()
			if u72 then
				v149()
			end
		end)
	end

	local n3 = t2.WringStart + 0.55

	local function v153()
		if u73 then
			return
		end

		sound:Play("KillEffects.Necrodeath.Crack", torso, nil, nil, nil, 0.1)
	end

	if not __FreezeAt or not (__FreezeAt < n3) then
		local v154 = task.delay
		local v155 = math.max(n3, 0)

		v154(v155, function()
			if u72 then
				v153()
			end
		end)
	end

	local n4 = t2.WringStart + 0.95

	local function v157()
		if u73 then
			return
		end

		sound:Play("KillEffects.Necrodeath.Crack", torso, nil, 0.9, nil, 0.1)
	end

	if not __FreezeAt or not (__FreezeAt < n4) then
		local v158 = task.delay
		local v159 = math.max(n4, 0)

		v158(v159, function()
			if u72 then
				v157()
			end
		end)
	end

	local u160 = nil
	local coreOpen = t2.CoreOpen

	local function v162()
		local clone5 = necrodeath.Core:Clone()
		local clone5Horizon = clone5.Horizon
		local clone5Disk = clone5.Disk
		local cFrame = CFrame.new(n1)

		clone5Horizon.CFrame = cFrame

		local v234 = CFrame.Angles(0.24434609527920614, 0, -0.15707963267948966)

		clone5Disk.CFrame = cFrame * v234
		clone5Horizon.Size = Vector3.new(1, 1, 1) * t2.CoreSize0 * 2
		clone5.Parent = _fx_Necrodeath

		local rimGlow = clone5Horizon.Halo.RimGlow
		local outerGlow = clone5Horizon.Halo.OuterGlow

		rimGlow.Size = NumberSequence.new(t2.CoreSize0 * 4.4)
		outerGlow.Size = NumberSequence.new(t2.CoreSize0 * 7.5)

		local clone5HorizonOpen = clone5Horizon.Open

		if clone5HorizonOpen then
			local ok, result = pcall(forgeVFX.emit, clone5HorizonOpen)

			if not ok then
				local clone5HorizonOpenName = clone5HorizonOpen.Name
				local text: string = tostring(result)

				warn("[Necrodeath] emit failed on " .. clone5HorizonOpenName .. ": " .. text)
			end
		end

		local clone5HorizonCharge = clone5Horizon.Charge

		if clone5HorizonCharge then
			local ok, result = pcall(forgeVFX.emit, clone5HorizonCharge)

			if not ok then
				local clone5HorizonChargeName = clone5HorizonCharge.Name
				local text: string = tostring(result)

				warn("[Necrodeath] emit failed on " .. clone5HorizonChargeName .. ": " .. text)
			end
		end

		local clone5HorizonHalo = clone5Horizon.Halo

		if clone5HorizonHalo then
			local ok, result = pcall(forgeVFX.emit, clone5HorizonHalo)

			if not ok then
				local clone5HorizonHaloName = clone5HorizonHalo.Name
				local text: string = tostring(result)

				warn("[Necrodeath] emit failed on " .. clone5HorizonHaloName .. ": " .. text)
			end
		end

		local v252, v253 = sound:Play("KillEffects.Necrodeath.Core", clone5Horizon)
		u160 = {
			eaten = 0,
			done = false,
			folder = clone5,
			horizon = clone5Horizon,
			disk = clone5Disk,
			halo = rimGlow,
			outer = outerGlow,
			light = clone5Horizon.Light,
			hum = v253,
			size = t2.CoreSize0
		}
	end

	if not __FreezeAt or not (__FreezeAt < coreOpen) then
		local v163 = task.delay
		local v164 = math.max(coreOpen, 0)

		v163(v164, function()
			if u72 then
				v162()
			end
		end)
	end

	local t12: {[any]: any} = {}
	local n5 = 0

	for _, v in pairs(t2.ShardCount) do
		n5 += v
	end

	local function spawnShards(p19)
		local part = p19.part
		local v256 = p19.cf or part.CFrame
		local partSize = part.Size

		for _ = 1, t2.ShardCount[p19.name] or 4 do
			local v259 = random:NextInteger(1, #t4)
			local v260 = t4[v259]
			local shard: WedgePart = Instance.new("WedgePart")

			shard.Name = "Shard"
			shard.Anchored = true
			shard.CanCollide = false
			shard.CanQuery = false
			shard.CanTouch = false
			shard.CastShadow = false
			shard.Color = v260.color
			shard.Material = v260.material
			shard.Reflectance = v260.reflect

			local v262 = random:NextNumber(0.25, 0.55)
			local v263 = random:NextNumber(0.35, 0.9)
			local vector34 = Vector3.new(v262, v263, random:NextNumber(0.15, 0.35))

			shard.Size = vector34
			v263 = random:NextNumber(-0.45, 0.45) * partSize.X

			local n3 = random:NextNumber(-0.45, 0.45) * partSize.Y
			local v266 = random:NextNumber(-0.45, 0.45)
			local vector35 = Vector3.new(v263, n3, v266 * partSize.Z)
			local cFrame = CFrame.new(vector35)
			local cFrameAngles = CFrame.Angles

			v266 = random:NextNumber(0, 6.28)

			local v270 = random:NextNumber(0, 6.28)
			local v271 = cFrameAngles(v266, v270, random:NextNumber(0, 6.28))

			v263 = v256 * cFrame * v271
			shard.CFrame = v263
			shard.Parent = _fx_Necrodeath
			v262 = v263.Position - n1
			v262 = if v262.Magnitude > 0.05 then v262.Unit else random:NextUnitVector()

			if v260.material == Enum.Material.Neon or random:NextNumber() < 0.25 then
				local attachment: Attachment = Instance.new("Attachment")

				attachment.Position = Vector3.new(0, vector34.Y * 0.4, 0)
				attachment.Parent = shard

				local attachment2: Attachment = Instance.new("Attachment")

				attachment2.Position = Vector3.new(0, -vector34.Y * 0.4, 0)
				attachment2.Parent = shard

				local clone6 = necrodeath.ShardTrail:Clone()

				clone6.Attachment0 = attachment
				clone6.Attachment1 = attachment2
				clone6.Parent = shard
			end

			local v275 = random:NextUnitVector()
			local n2 = (v262 + v275 * 0.45).Unit * t2.ShardBurstSpeed
			local v277 = random:NextNumber(0.6, 1.2)
			local v278 = random:NextUnitVector()
			local v279 = random:NextNumber(8, 20)
			local shatterTime = t2.ShatterTime
			local v281 = random:NextNumber(t2.ShardSuck0, t2.ShardSuck1)
			v270 = {
				done = false,
				part = shard,
				size = vector34,
				start = v263,
				vel = n2 * v277,
				spin = v278 * v279,
				eatAt = shatterTime + v281,
				dir = if random:NextNumber() < 0.5 then 1 else -1
			}
			table.insert(t12, v270)
		end
	end

	local n6 = t2.PinchTime - 0.05

	local function v171()
		sound:Play("KillEffects.Necrodeath.Pinch", clone)
	end

	if not __FreezeAt or not (__FreezeAt < n6) then
		local v172 = task.delay
		local v173 = math.max(n6, 0)

		v172(v173, function()
			if u72 then
				v171()
			end
		end)
	end

	local shatterTime = t2.ShatterTime

	local function v175()
		if not u73 then
			for _, v in pairs(t7) do
				if v.part.Parent then
					spawnShards(v)
					hidePart(Character, v.part)
				end

				v.gone = true
			end

			for _, v in ipairs(t5) do
				if v:IsA("Highlight") then
					v.Enabled = false
				end
			end
		end

		local clone7 = necrodeath.Shatter:Clone()

		clone7.CFrame = CFrame.new(vector32)
		clone7.Parent = _fx_Necrodeath

		if clone7 then
			local ok, result = pcall(forgeVFX.emit, clone7)

			if not ok then
				local clone7Name = clone7.Name
				local text: string = tostring(result)

				warn("[Necrodeath] emit failed on " .. clone7Name .. ": " .. text)
			end
		end

		flashLight(clone7.Light, t2.ShatterFlash)
		debris:AddItem(clone7, 2.5)
		sound:Play("KillEffects.Necrodeath.Shatter", clone7)
		sound:Play("KillEffects.Necrodeath.Shatter2", clone7, nil, nil, nil, 0.06)

		local _GShared = _G.Shared
		local _GSharedCamShaker = _GShared and _GShared.CamShaker

		if _GSharedCamShaker and (CurrentCamera.CFrame.Position - vector32).Magnitude < t2.ShakeDistance then
			pcall(function()
				_GSharedCamShaker:Shake("Bump")
			end)
		end
	end

	if not __FreezeAt or not (__FreezeAt < shatterTime) then
		local v176 = task.delay
		local v177 = math.max(shatterTime, 0)

		v176(v177, function()
			if u72 then
				v175()
			end
		end)
	end

	n6 = t2.ShatterTime + t2.ShardBurst

	local function v178()
		sound:Play("KillEffects.Necrodeath.Suck", clone)
	end

	if not __FreezeAt or not (__FreezeAt < n6) then
		local v179 = task.delay
		local v180 = math.max(n6, 0)

		v179(v180, function()
			if u72 then
				v178()
			end
		end)
	end

	n6 = t2.CollapseTime - 0.08

	local function v181()
		sound:Play("KillEffects.Necrodeath.Collapse", clone)
	end

	if not __FreezeAt or not (__FreezeAt < n6) then
		local v182 = task.delay
		local v183 = math.max(n6, 0)

		v182(v183, function()
			if u72 then
				v181()
			end
		end)
	end

	local implodeTime = t2.ImplodeTime

	local function v185()
		if u160 then
			u160.done = true

			if u160.hum then
				pcall(function()
					u160.hum:Destroy()
				end)
			end

			stopEmitters(u160.folder)
			u160.halo:Clear()
			u160.outer:Clear()
			u160.horizon.Transparency = 1

			for _, v in ipairs(u160.disk:GetChildren()) do
				if v:IsA("Decal") then
					v.Transparency = 1
				end
			end

			debris:AddItem(u160.folder, 1.5)
		end

		for _, v in ipairs(t9) do
			for _, iterValue in ipairs(v.trails) do
				iterValue.Enabled = false
			end

			if v.edge then
				v.edge.Enabled = false
			end
		end

		local clone8 = necrodeath.Implode:Clone()

		clone8.CFrame = CFrame.new(n1)
		clone8.Parent = _fx_Necrodeath

		if clone8 then
			local ok, result = pcall(forgeVFX.emit, clone8)

			if not ok then
				local clone8Name = clone8.Name
				local text: string = tostring(result)

				warn("[Necrodeath] emit failed on " .. clone8Name .. ": " .. text)
			end
		end

		flashLight(clone8.Light, t2.ImplodeFlash)
		sound:Play("KillEffects.Necrodeath.Implode", clone8)
		sound:Play("KillEffects.Necrodeath.ImplodeBass", clone8)

		if u79 then
			pcall(function()
				sound.FadeOut(u79, 0.5)
			end)
			u79 = nil
		end

		stopEmitters(clone)

		local cloneBurst = clone.Burst

		if cloneBurst then
			local ok, result = pcall(forgeVFX.emit, cloneBurst)

			if not ok then
				local cloneBurstName = cloneBurst.Name
				local text: string = tostring(result)

				warn("[Necrodeath] emit failed on " .. cloneBurstName .. ": " .. text)
			end
		end

		local cloneRadial = clone.Radial

		if cloneRadial then
			local ok, result = pcall(forgeVFX.emit, cloneRadial)

			if not ok then
				local cloneRadialName = cloneRadial.Name
				local text: string = tostring(result)

				warn("[Necrodeath] emit failed on " .. cloneRadialName .. ": " .. text)
			end
		end

		local cloneResidue_Mist = clone.Residue_Mist

		if cloneResidue_Mist then
			local ok, result = pcall(forgeVFX.emit, cloneResidue_Mist)

			if not ok then
				local cloneResidue_MistName = cloneResidue_Mist.Name
				local text: string = tostring(result)

				warn("[Necrodeath] emit failed on " .. cloneResidue_MistName .. ": " .. text)
			end
		end

		local cloneResidue_Embers = clone.Residue_Embers

		if cloneResidue_Embers then
			local ok, result = pcall(forgeVFX.emit, cloneResidue_Embers)

			if not ok then
				local cloneResidue_EmbersName = cloneResidue_Embers.Name
				local text: string = tostring(result)

				warn("[Necrodeath] emit failed on " .. cloneResidue_EmbersName .. ": " .. text)
			end
		end

		tweenService:Create(clone.Light, TweenInfo.new(0.8), { Brightness = 0.4 }):Play()

		local magnitude = (CurrentCamera.CFrame.Position - n1).Magnitude
		local _GShared = _G.Shared
		local _GSharedCamShaker = _GShared and _GShared.CamShaker

		if _GSharedCamShaker and magnitude < t2.ShakeDistance then
			_GSharedCamShaker:Shake("Explosion")
		end

		if magnitude < t2.PostDistance then
			local _NecroBlur: BlurEffect = Instance.new("BlurEffect")

			table.insert(t5, _NecroBlur)
			_NecroBlur.Name = "_NecroBlur"
			_NecroBlur.Size = 14
			_NecroBlur.Parent = lighting

			local tweenInfo3 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

			tweenService:Create(_NecroBlur, tweenInfo3, { Size = 0 }):Play()
			debris:AddItem(_NecroBlur, 0.45)

			local _NecroTint: ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

			table.insert(t5, _NecroTint)
			_NecroTint.Name = "_NecroTint"
			_NecroTint.TintColor = Color3.fromRGB(210, 180, 255)
			_NecroTint.Contrast = 0.3
			_NecroTint.Saturation = -0.35
			_NecroTint.Brightness = 0.06
			_NecroTint.Parent = lighting

			local tweenInfo4 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

			tweenService:Create(_NecroTint, tweenInfo4, {
				Contrast = 0,
				Saturation = 0,
				Brightness = 0,
				TintColor = Color3.new(1, 1, 1)
			}):Play()
			debris:AddItem(_NecroTint, 0.55)
		end
	end

	if not __FreezeAt or not (__FreezeAt < implodeTime) then
		local v186 = task.delay
		local v187 = math.max(implodeTime, 0)

		v186(v187, function()
			if u72 then
				v185()
			end
		end)
	end

	local function fadedSequence(p20, p21)
		local t15: {[any]: any} = {}

		for _, v in ipairs(p20.Keypoints) do
			local n1 = v.Value + (1 - v.Value) * p21
			local v337 = math.min(v.Envelope * (1 - p21), n1, 1 - n1)
			local numberSequenceKeypointNew = NumberSequenceKeypoint.new
			local vTime = v.Time
			local v340 = math.max(v337, 0)

			table.insert(t15, numberSequenceKeypointNew(vTime, n1, v340))
		end

		return NumberSequence.new(t15)
	end

	local fadeStart = t2.FadeStart

	local function v190()
		local tweenInfo5 = TweenInfo.new(t2.FadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local t16: {[any]: any} = {}

		local function wind(p22)
			if p22:IsA("ParticleEmitter") then
				p22.Enabled = false
				table.insert(t16, { e = p22, seq = p22.Transparency })

				return
			end

			if not p22:IsA("Beam") and not p22:IsA("Trail") then
				if p22:IsA("Light") then
					tweenService:Create(p22, tweenInfo5, { Brightness = 0 }):Play()

					return
				end

				if p22:IsA("Highlight") then
					tweenService:Create(p22, tweenInfo5, { OutlineTransparency = 1, FillTransparency = 1 }):Play()

					return
				end

				if p22:IsA("Sound") then
					local tweenInfo6 = TweenInfo.new(t2.FadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

					tweenService:Create(p22, tweenInfo6, { Volume = 0 }):Play()

					return
				end

				if p22:IsA("BasePart") and p22.Transparency < 1 then
					tweenService:Create(p22, tweenInfo5, { Transparency = 1 }):Play()
				end

				return
			end

			p22.Enabled = false
		end

		for _, v in ipairs(_fx_Necrodeath:GetDescendants()) do
			wind(v)
		end

		for _, v in ipairs(t5) do
			if v.Parent then
				wind(v)

				for _, iterValue in ipairs(v:GetDescendants()) do
					wind(iterValue)
				end
			end
		end

		if u79 then
			pcall(function()
				sound.FadeOut(u79, t2.FadeTime)
			end)
			u79 = nil
		end

		local v350 = os.clock()
		local connection2 = nil

		connection2 = runService.Heartbeat:Connect(function()
			local v442 = os.clock()
			local v443 = math.clamp((v442 - v350) / t2.FadeTime, 0, 1)

			v443 = v443 * v443 * (3 - v443 * 2)

			for _, v in ipairs(t16) do
				if v.e.Parent then
					v.e.Transparency = fadedSequence(v.seq, v443)
				end
			end

			if v443 >= 1 or not u72 then
				connection2:Disconnect()
				cleanup()
			end
		end)
	end

	if not __FreezeAt or not (__FreezeAt < fadeStart) then
		local v191 = task.delay
		local v192 = math.max(fadeStart, 0)

		v191(v192, function()
			if u72 then
				v190()
			end
		end)
	end

	local v193 = os.clock()
	local n7 = 0
	local n8 = 0

	local function noise3(p23, p24)
		local v354 = math.noise(p23 * 23, p24)
		local v355 = math.noise(p23 * 19, p24 + 7)
		local vector36 = Vector3.new(v354, v355, math.noise(p23 * 21, p24 + 13))

		return vector36
	end
	local function wringAlpha(p25)
		local n1 = (p25 - t2.WringStart) / (t2.PinchTime - t2.WringStart)

		if n1 < 0 then
			return 0
		end

		if n1 > 1 then
			return 1
		end

		return n1
	end

	local t13: {[any]: any} = {}
	local t14: {[any]: any} = {}

	connection3 = runService.Heartbeat:Connect(function()
		if not u72 then
			return
		end

		local n37 = os.clock() - v193

		if __FreezeAt then
			n37 = math.min(n37, __FreezeAt)
		end

		local v360 = math.max(n37 - n7, 0)

		n7 = n37

		local n2 = (n37 - t2.WringStart) / (t2.PinchTime - t2.WringStart)
		local n3 = if n2 < 0 then 0 else if n2 > 1 then 1 else n2

		n8 += t2.SpinMax * (n3 * n3 * n3) * v360

		if not u73 then
			table.clear(t13)
			table.clear(t14)

			local n4 = n37 / t2.LiftTime
			local cosine2 = math.cos(3.141592653589793 * (if n4 < 0 then 0 else if n4 > 1 then 1 else n4))

			n4 = (n37 - (t2.PinchTime - 0.04)) / 0.12

			local n38 = if n4 < 0 then 0 else if n4 > 1 then 1 else n4

			for _, v in pairs(t7) do
				if not v.gone and v.part.Parent then
					local v368 = v.from:Lerp(v93 * v.pose, -(cosine2 - 1) / 2)

					if n3 > 0 then
						local n6 = (v.h + 2) / 3.5
						local n39 = 6.283185307179586 * t2.WringTurns
						local cosine3 = math.cos(3.141592653589793 * n3)
						local v372 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), n8 + n39 * (-(cosine3 - 1) / 2) * (if n6 < 0 then 0 else if n6 > 1 then 1 else n6))

						n6 = v93:ToObjectSpace(v368)

						local n40 = 1 - t2.Crush * (n3 * n3) - n38 * 0.25

						n39 = n6.Position

						local cFrame = CFrame.new(n39.X * n40, n39.Y * (n3 * 0.12 + 1) - n38 * 0.2, n39.Z * n40)
						local n9 = v93 * v372 * (cFrame * n6.Rotation)
						local vSeed = v.seed
						local v377 = math.noise(n37 * 23, vSeed)
						local v378 = math.noise(n37 * 19, vSeed + 7)
						local vector37 = Vector3.new(v377, v378, math.noise(n37 * 21, vSeed + 13))

						v368 = n9 + vector37 * (t2.Tremble * n3)
					end

					v.cf = v368
					table.insert(t13, v.part)
					table.insert(t14, v368)
				end
			end

			if #t13 > 0 then
				workspace:BulkMoveTo(t13, t14, Enum.BulkMoveMode.FireCFrameChanged)
			end
		end

		for _, v in ipairs(t9) do
			if v.live and not v.gone then
				local n10 = (n37 - t2.BladeIn) / (t2.PinchTime - t2.BladeIn)
				local n11 = if n10 < 0 then 0 else if n10 > 1 then 1 else n10

				v.angle = v.angle + (t2.BladeSpeed0 + (t2.BladeSpeed1 - t2.BladeSpeed0) * (n11 * n11)) * v360

				local bladeRadius1 = t2.BladeRadius1
				local n12 = t2.BladeRadius0 - t2.BladeRadius1
				local cosine4 = math.cos(3.141592653589793 * n11)
				local n13 = v.height * (1 - n11 * 0.6)
				local sine2 = math.sin(n37 * 4 + v.phase)
				local n14 = (n37 - t2.BladeIn) / 0.3
				local n15 = if n14 < 0 then 0 else if n14 > 1 then 1 else n14

				n11 = 1 - (1 - n15) * (1 - n15)
				n15 = (n37 - t2.PinchTime) / (t2.ShatterTime + 0.12 - t2.PinchTime)

				local n16 = if n15 < 0 then 0 else if n15 > 1 then 1 else n15

				n10 = (bladeRadius1 + n12 * (1 - -(cosine4 - 1) / 2)) * ((1 - n11) * 0.8 + 1) * (1 - n16 * n16)
				n15 = v.angle + v.phase

				local cosine5 = math.cos(n15)
				local sine3 = math.sin(n15)
				local vector38 = Vector3.new(cosine5 * n10, (n13 + sine2 * 0.35 + (1 - n11) * 3) * (1 - n16), sine3 * n10)
				local v395 = v.tilt:VectorToWorldSpace(vector38)
				local n17 = n1 + v395

				n14 = n17 - n1
				n14 = if n14.Magnitude > 0.05 then n14.Unit else Vector3.new(1, 0, 0)

				local vTilt = v.tilt
				local sine4 = math.sin(n15)
				local cosine6 = math.cos(n15)
				local vector39 = Vector3.new(-sine4, 0, cosine6)
				local v401 = vTilt:VectorToWorldSpace(vector39)

				n15 = n14:Cross(v401)

				if n15.Magnitude < 0.05 then
					n15 = Vector3.new(0, 1, 0)
				end

				v.carrier.CFrame = CFrame.fromMatrix(n17, n14, n15.Unit)

				if n16 >= 1 then
					v.gone = true

					for _, iterValue in ipairs(v.trails) do
						iterValue.Enabled = false
					end

					if v.edge then
						v.edge.Enabled = false
					end
				end
			end
		end

		if u160 and not u160.done then
			local n18

			if n37 < t2.ShatterTime then
				local n19 = (n37 - t2.CoreOpen) / (t2.ShatterTime - t2.CoreOpen)
				local n20 = if n19 < 0 then 0 else if n19 > 1 then 1 else n19
				local n21 = t2.CoreSize0 + (t2.CoreSize1 - t2.CoreSize0) * (n20 * n20)
				local sine5 = math.sin(n37 * 38)

				n18 = n21 * (sine5 * 0.06 * n20 + 1)
			elseif n37 < t2.CollapseTime then
				local eaten = u160.eaten
				local v410 = math.max(n5, 1)
				local n22 = t2.CoreSize1 + (t2.CoreSizeFull - t2.CoreSize1) * (eaten / v410)
				local sine6 = math.sin(n37 * 52)

				n18 = n22 * (sine6 * 0.08 + 1)
			else
				local n23 = (n37 - t2.CollapseTime) / (t2.ImplodeTime - t2.CollapseTime)
				local n24 = if n23 < 0 then 0 else if n23 > 1 then 1 else n23
				local n25

				if n24 < 0.3 then
					n25 = n24 / 0.3 * 0.15 + 1
				else
					local n26 = (n24 - 0.3) / 0.7

					n25 = (1 - n26 * n26 * n26) * 1.15
				end

				n18 = t2.CoreSizeFull * n25
			end

			local v415 = math.max(n18, 0.02)

			u160.size = v415
			u160.horizon.Size = Vector3.new(1, 1, 1) * v415 * 2
			u160.halo.Size = NumberSequence.new(v415 * 4.4)
			u160.outer.Size = NumberSequence.new(v415 * 7.5)
			u160.disk.Size = Vector3.new(v415 * 6.5, 0.05, v415 * 6.5)

			local disk = u160.disk
			local cFrame = CFrame.new(n1)
			local v418 = CFrame.Angles(0.24434609527920614, n37 * 6, -0.15707963267948966)

			disk.CFrame = cFrame * v418
			u160.light.Brightness = 1.5 + v415 * 2
			u160.light.Range = 8 + v415 * 10
		end

		if #t12 > 0 then
			table.clear(t13)
			table.clear(t14)

			for _, v in ipairs(t12) do
				if not v.done then
					local n27 = n37 - t2.ShatterTime
					local v422: boolean = true
					local n28

					if n27 < t2.ShardBurst then
						local n29 = n27 / t2.ShardBurst
						local n30 = v.start + v.vel * t2.ShardBurst * (1 - (1 - n29) * (1 - n29))
						local v426 = CFrame.fromAxisAngle(v.spin.Unit, v.spin.Magnitude * n27)

						n28 = n30 * v426
						v.turn = n28
					else
						local v427 = v.turn or v.start
						local n31 = n27 - t2.ShardBurst
						local v428 = math.max(v.eatAt - (t2.ShatterTime + t2.ShardBurst), 0.05)
						local n32 = n31 / v428
						local n33 = if n32 < 0 then 0 else if n32 > 1 then 1 else n32
						local n34 = v427.Position - n1
						local magnitude = n34.Magnitude
						local v433 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), v.dir * (n33 * n33) * 3.141592653589793 * 2.2):VectorToWorldSpace(n34)
						local n35 = CFrame.new(n1 + (if magnitude > 0.01 then v433.Unit * (magnitude * (1 - n33 * n33)) else Vector3.new(0, 0, 0)) - Vector3.new(0, 1, 0) * (n34.Y * (n33 * n33) * 0.2)) * v427.Rotation
						local v435 = CFrame.fromAxisAngle(v.spin.Unit, v.spin.Magnitude * n27 * (n33 * 2 + 1))

						n28 = n35 * v435

						local n36 = (n33 - 0.55) / 0.45

						v435 = if n36 < 0 then 0 else if n36 > 1 then 1 else n36
						v433 = 1 - v435 * v435
						v.part.Size = Vector3.new(v.size.X * v433, v.size.Y * (n33 * 0.8 + 1) * v433, v.size.Z * v433)

						if n33 >= 1 then
							v.done = true
							v.part:Destroy()

							if u160 then
								local v437 = u160

								v437.eaten = v437.eaten + 1
							end

							v422 = false
						end
					end

					if v422 then
						table.insert(t13, v.part)
						table.insert(t14, n28)
					end
				end
			end

			if #t13 > 0 then
				workspace:BulkMoveTo(t13, t14, Enum.BulkMoveMode.FireCFrameChanged)
			end
		end

		if clone.Parent and n37 > t2.WringStart and n37 < t2.ImplodeTime then
			local cloneLight = clone.Light
			local sine7 = math.sin(n37 * 24)

			cloneLight.Brightness = n3 * 0.7 + 1.2 + sine7 * 0.5 * n3
		end
	end)
end
