-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local tweenService: TweenService = game:GetService("TweenService")
local lighting: Lighting = game:GetService("Lighting")
local sound = require(game.ReplicatedStorage.Sound)
local debris = require(game.ReplicatedStorage.Util.Debris)
local forgeVFX = require(game.ReplicatedStorage.Util.ForgeVFX)
local pyrodeath = game.ReplicatedStorage.FX.KillEffects.Pyrodeath
local color3 = Color3.fromRGB(120, 34, 14)
local color32 = Color3.fromRGB(38, 24, 20)
local t1: {[any]: any} = { "Torso", "Head", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }

local function poseAgony()
	local v31 = CFrame.Angles(0.17453292519943295, 0, 0)
	local n1 = CFrame.new(0, 3, 0) * v31
	local v33 = CFrame.Angles(0.5235987755982988, 0, 0)
	local v34 = CFrame.Angles(0.2617993877991494, 0, 2.530727415391778)
	local v35 = CFrame.Angles(0.2617993877991494, 0, -2.530727415391778)
	local v36 = CFrame.Angles(-0.10471975511965978, 0, 0.08726646259971647)
	local v37 = CFrame.Angles(0.06981317007977318, 0, -0.08726646259971647)

	return {
		Torso = n1,
		Head = n1 * CFrame.new(0, 1.5, 0.15) * v33,
		["Right Arm"] = n1 * CFrame.new(1.5, 0.5, 0) * v34 * CFrame.new(0, -0.5, 0),
		["Left Arm"] = n1 * CFrame.new(-1.5, 0.5, 0) * v35 * CFrame.new(0, -0.5, 0),
		["Right Leg"] = n1 * CFrame.new(0.5, -1, 0) * v36 * CFrame.new(0, -1, 0),
		["Left Leg"] = n1 * CFrame.new(-0.5, -1, 0) * v37 * CFrame.new(0, -1, 0)
	}
end
local function poseKneel()
	local v38 = CFrame.Angles(-0.3839724354387525, 0, 0)
	local n1 = CFrame.new(0, 1.8, 0) * v38
	local v40 = CFrame.Angles(-0.4363323129985824, 0, 0)
	local v41 = CFrame.Angles(0.6981317007977318, 0, 0.10471975511965978)
	local v42 = CFrame.Angles(0.5934119456780721, 0, -0.10471975511965978)
	local v43 = CFrame.Angles(-1.1519173063162575, 0, 0)
	local v44 = CFrame.Angles(-1.2217304763960306, 0, 0)

	return {
		Torso = n1,
		Head = n1 * CFrame.new(0, 1.5, -0.1) * v40,
		["Right Arm"] = n1 * CFrame.new(1.5, 0.5, 0) * v41 * CFrame.new(0, -0.5, 0),
		["Left Arm"] = n1 * CFrame.new(-1.5, 0.5, 0) * v42 * CFrame.new(0, -0.5, 0),
		["Right Leg"] = CFrame.new(0.5, 0.87, 0.37) * v43 * CFrame.new(0, -1, 0),
		["Left Leg"] = CFrame.new(-0.5, 0.87, 0.37) * v44 * CFrame.new(0, -1, 0)
	}
end

local color33 = Color3.fromRGB(34, 28, 26)
local slate = Enum.Material.Slate
local color34 = Color3.fromRGB(58, 52, 48)
local v16 = Enum.Material.Slate
local color35 = Color3.fromRGB(86, 80, 74)
local sand = Enum.Material.Sand
local color36 = Color3.fromRGB(128, 120, 112)
local v20 = Enum.Material.Sand
local color37 = Color3.fromRGB(40, 24, 20)

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

quadOut = function(p4)
	return (p4 - 1) ^ 3 * 2.70158 + 1 + (p4 - 1) ^ 2 * 1.70158
end

local function emit(p5)
	if not p5 then
		return
	end

	local ok, result = pcall(forgeVFX.emit, p5)

	if not ok then
		local v52 = p5.Name
		local text: string = tostring(result)

		warn("[Pyrodeath] emit failed on " .. v52 .. ": " .. text)
	end
end
local function stopEmitters(p6)
	for _, v in ipairs(p6:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v.Enabled = false
		end
	end
end
local function flashLight(p7, p8)
	p7.Range = p8.Range
	p7.Brightness = 0

	local tweenInfo = TweenInfo.new(p8.Up, Enum.EasingStyle.Linear)
	local v60: Tween = tweenService:Create(p7, tweenInfo, { Brightness = p8.Brightness })

	v60.Completed:Once(function()
		local tweenInfo2 = TweenInfo.new(p8.Down, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

		tweenService:Create(p7, tweenInfo2, { Brightness = 0 }):Play()
	end)
	v60:Play()
end
local function setLocalTransparency(p9, localTransparencyModifier)
	if p9:IsA("BasePart") or p9:IsA("Decal") then
		p9.LocalTransparencyModifier = localTransparencyModifier
	end

	for _, v in ipairs(p9:GetDescendants()) do
		if v:IsA("BasePart") or v:IsA("Decal") then
			v.LocalTransparencyModifier = localTransparencyModifier
		end
	end
end

local t2: {[any]: any} = {
	MaxDistance = 1000,
	AgonyIn = 0.05,
	AgonyTime = 0.18,
	CollapseStart = 0.55,
	CollapseTime = 0.4,
	Flail = 0.12,
	HeatTime = 0.55,
	CharTime = 1.55,
	PillarStart = 0.9,
	PillarEnd = 1.7,
	CrumbleStart = 2.6,
	Gravity = 70,
	WindSpeed = 2.5,
	FireDie = 3.3,
	ShakeDistance = 70,
	PostDistance = 60,
	FadeStart = 3.9,
	FadeTime = 1,
	CleanupAfter = 8,
	Ignite = {
		["Left Leg"] = 0.1,
		["Right Leg"] = 0.13,
		Torso = 0.3,
		["Left Arm"] = 0.38,
		["Right Arm"] = 0.41,
		Head = 0.52
	},
	HotColor = color3,
	CharColor = color32,
	CrumbleOrder = {
		Head = 0,
		["Left Arm"] = 0.07,
		["Right Arm"] = 0.1,
		Torso = 0.2,
		["Left Leg"] = 0.3,
		["Right Leg"] = 0.33
	},
	Chunks = {
		Head = 12,
		Torso = 22,
		["Left Arm"] = 11,
		["Right Arm"] = 11,
		["Left Leg"] = 11,
		["Right Leg"] = 11
	},
	EruptFlash = { Brightness = 9, Range = 40, Up = 0.03, Down = 0.6 }
}
local t3: {[any]: any} = {
	{ color = color33, material = slate },
	{ color = color34, material = v16 },
	{ color = color35, material = sand },
	{ color = color36, material = v20 },
	{ color = color37, material = Enum.Material.CrackedLava }
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

	local _fx_Pyrodeath: Folder = Instance.new("Folder")

	_fx_Pyrodeath.Name = "_FX_Pyrodeath"
	_fx_Pyrodeath.Parent = workspace.Bin

	local u72: boolean = true
	local u73: boolean = false
	local connection3 = nil
	local connection = nil
	local t4: {[any]: any} = {}
	local t5: {[any]: any} = {}
	local u78 = nil
	local u79: boolean = false
	local randomNew = Random.new
	local typeName: string = typeof(player.Seed)
	local v82 = randomNew(typeName == "number" and player.Seed or 7)
	local __FreezeAt = player.__FreezeAt

	local function own(p12)
		table.insert(t4, p12)

		return p12
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

		if u78 then
			pcall(function()
				u78:Destroy()
			end)
		end

		for _, v in ipairs(t4) do
			pcall(game.Destroy, v)
		end

		table.clear(t4)
		_fx_Pyrodeath:Destroy()
	end

	connection = Character.AncestryChanged:Connect(function()
		if not Character:IsDescendantOf(game) then
			u73 = true

			for _, v in pairs(t5) do
				v.gone = true
			end

			if connection then
				connection:Disconnect()
			end
		end
	end)
	task.delay(t2.CleanupAfter, cleanup)

	local function at(p13, p14)
		if __FreezeAt and p13 > __FreezeAt then
			return
		end

		local taskDelay = task.delay
		local v191 = math.max(p13, 0)

		taskDelay(v191, function()
			if u72 then
				p14()
			end
		end)
	end

	local lookVector = torso.CFrame.LookVector
	local vector3 = Vector3.new(lookVector.X, 0, lookVector.Z)

	vector3 = if vector3.Magnitude > 0.05 then vector3.Unit else Vector3.new(0, 0, -1)

	local v89 = torso.Position
	local t6 = { Character, workspace.Bin }
	local characters: Instance = workspace:FindFirstChild("Characters")

	if characters then
		table.insert(t6, characters)
	end

	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = t6
	t6 = workspace:Raycast(v89 + Vector3.new(0, 2, 0), Vector3.new(0, -18, 0), raycastParams)

	local v93 = if t6 then t6.Position.Y else v89.Y - 3
	local vector32 = Vector3.new(v89.X, v93, v89.Z)

	v89 = CFrame.lookAt(vector32, vector32 + vector3)

	local v95 = v89:PointToWorldSpace(Vector3.new(0, 0, 0.3))
	local rightVector = v89.RightVector
	local v97 = v82:NextNumber()
	local unit = (rightVector * (if v97 < 0.5 then 1 else -1) + vector3 * 0.35).Unit
	local v99 = poseAgony()
	local v100 = poseKneel()

	for i, v in ipairs(t1) do
		local v2 = Character:FindFirstChild(v)

		if v2 and v2:IsA("BasePart") then
			v2.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			v2.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			v2.Anchored = true
			t5[v] = {
				fire = nil,
				gone = false,
				crumbled = false,
				part = v2,
				name = v,
				from = v2.CFrame,
				agony = v89 * v99[v],
				kneel = v89 * v100[v],
				color = v2.Color,
				seed = i * 19,
				ignite = t2.Ignite[v] or 0.3,
				crumble = t2.CrumbleStart + (t2.CrumbleOrder[v] or 0.2)
			}
		end
	end

	local clone = pyrodeath.Ground:Clone()

	clone.CFrame = CFrame.new(vector32 + Vector3.new(0, 0.15, 0))
	clone.Ring.CFrame = clone.CFrame
	clone.Parent = _fx_Pyrodeath

	local cloneHold = clone.Hold

	if cloneHold then
		local ok, result = pcall(forgeVFX.emit, cloneHold)

		if not ok then
			local cloneHoldName = cloneHold.Name
			local text: string = tostring(result)

			warn("[Pyrodeath] emit failed on " .. cloneHoldName .. ": " .. text)
		end
	end

	local cloneRise_Embers = clone.Rise_Embers

	if cloneRise_Embers then
		local ok, result = pcall(forgeVFX.emit, cloneRise_Embers)

		if not ok then
			local cloneRise_EmbersName = cloneRise_Embers.Name
			local text: string = tostring(result)

			warn("[Pyrodeath] emit failed on " .. cloneRise_EmbersName .. ": " .. text)
		end
	end

	local cloneRise_Smoke = clone.Rise_Smoke

	if cloneRise_Smoke then
		local ok, result = pcall(forgeVFX.emit, cloneRise_Smoke)

		if not ok then
			local cloneRise_SmokeName = cloneRise_Smoke.Name
			local text: string = tostring(result)

			warn("[Pyrodeath] emit failed on " .. cloneRise_SmokeName .. ": " .. text)
		end
	end

	local cloneLight = clone.Light
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine)

	tweenService:Create(cloneLight, tweenInfo, { Brightness = 1.6 }):Play()

	local function v122()
		local cloneRing = clone.Ring

		if not cloneRing then
			return
		end

		local ok, result = pcall(forgeVFX.emit, cloneRing)

		if not ok then
			local cloneRingName = cloneRing.Name
			local text: string = tostring(result)

			warn("[Pyrodeath] emit failed on " .. cloneRingName .. ": " .. text)
		end
	end

	if not __FreezeAt or not (__FreezeAt < 0.08) then
		task.delay(0.08, function()
			if u72 then
				v122()
			end
		end)
	end

	sound:Play("KillEffects.Pyrodeath.Rumble", clone)

	local function v123()
		sound:Play("KillEffects.Pyrodeath.Ignite", clone)

		local v197, v198 = sound:Play("KillEffects.Pyrodeath.Burn", clone)

		u78 = v198
	end

	if not __FreezeAt or not (__FreezeAt < 0.08) then
		task.delay(0.08, function()
			if u72 then
				v123()
			end
		end)
	end

	local function ignite(p15)
		if not not p15.gone or not p15.part.Parent then
			return
		end

		local t10: {[any]: any} = {}

		for _, v in ipairs(pyrodeath.Burn:GetChildren()) do
			if v:IsA("ParticleEmitter") then
				local clone2 = v:Clone()

				table.insert(t4, clone2)
				clone2.Enabled = true
				clone2.Parent = p15.part
				t10[v.Name] = clone2
			end
		end

		p15.fire = t10

		local clone3 = pyrodeath.Catch:Clone()

		clone3.CFrame = p15.part.CFrame
		clone3.Parent = _fx_Pyrodeath

		if clone3 then
			local ok, result = pcall(forgeVFX.emit, clone3)

			if not ok then
				local clone3Name = clone3.Name
				local text: string = tostring(result)

				warn("[Pyrodeath] emit failed on " .. clone3Name .. ": " .. text)
			end
		end

		debris:AddItem(clone3, 1.2)

		local part = p15.part
		local tweenInfo3 = TweenInfo.new(t2.HeatTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local v211 = p15.color:Lerp(t2.HotColor, 0.85)

		tweenService:Create(part, tweenInfo3, { Color = v211 }):Play()
	end

	for _, v in pairs(t5) do
		local vIgnite = v.ignite

		local function v128()
			ignite(v)
		end

		if not __FreezeAt or not (__FreezeAt < vIgnite) then
			local taskDelay = task.delay
			local v130 = math.max(vIgnite, 0)

			taskDelay(v130, function()
				if u72 then
					v128()
				end
			end)
		end
	end

	v99 = t2.Ignite.Head + 0.05

	local function v131()
		if u73 then
			return
		end

		local Head = t5.Head

		if Head then
			for _, v in ipairs(Head.part:GetChildren()) do
				if v:IsA("Decal") then
					tweenService:Create(v, TweenInfo.new(0.35), { Transparency = 1 }):Play()
				end
			end
		end

		for _, v in ipairs(Character:GetChildren()) do
			if v:IsA("Accessory") then
				local handle = v:FindFirstChild("Handle")

				if handle and handle:IsA("BasePart") then
					local clone4 = pyrodeath.Catch:Clone()

					clone4.CFrame = handle.CFrame
					clone4.Parent = _fx_Pyrodeath

					if clone4 then
						local ok, result = pcall(forgeVFX.emit, clone4)

						if not ok then
							local clone4Name = clone4.Name
							local text: string = tostring(result)

							warn("[Pyrodeath] emit failed on " .. clone4Name .. ": " .. text)
						end
					end

					debris:AddItem(clone4, 1.2)

					local tweenInfo4 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
					local color38 = Color3.fromRGB(30, 18, 14)

					tweenService:Create(handle, tweenInfo4, { Color = color38 }):Play()
					task.delay(0.3, function()
						if u72 then
							setLocalTransparency(v, 1)
						end
					end)
				end
			end
		end

		sound:Play("KillEffects.Pyrodeath.Flare", Head and Head.part or clone, nil, nil, nil, 0.1)
	end

	if not __FreezeAt or not (__FreezeAt < v99) then
		local v132 = task.delay
		local v133 = math.max(v99, 0)

		v132(v133, function()
			if u72 then
				v131()
			end
		end)
	end

	v99 = t2.CollapseStart + t2.CollapseTime - 0.03

	local function v134()
		if u73 then
			return
		end

		sound:Play("KillEffects.Pyrodeath.Knees", torso)
	end

	if not __FreezeAt or not (__FreezeAt < v99) then
		local v135 = task.delay
		local v136 = math.max(v99, 0)

		v135(v136, function()
			if u72 then
				v134()
			end
		end)
	end

	local clone5 = pyrodeath.Pillar:Clone()

	clone5.CFrame = CFrame.new(vector32 + Vector3.new(0, 1, 0) * (clone5.Size.Y / 2))

	local pillarStart = t2.PillarStart

	local function v139()
		clone5.Parent = _fx_Pyrodeath

		local v225 = clone5

		if v225 then
			local ok, result = pcall(forgeVFX.emit, v225)

			if not ok then
				local v228 = v225.Name
				local text: string = tostring(result)

				warn("[Pyrodeath] emit failed on " .. v228 .. ": " .. text)
			end
		end

		tweenService:Create(clone5.Light, TweenInfo.new(0.12), { Brightness = 3.5 }):Play()

		local clone6 = pyrodeath.Erupt:Clone()

		clone6.CFrame = CFrame.new(vector32 + Vector3.new(0, 1.5, 0))
		clone6.Parent = _fx_Pyrodeath

		if clone6 then
			local ok, result = pcall(forgeVFX.emit, clone6)

			if not ok then
				local clone6Name = clone6.Name
				local text: string = tostring(result)

				warn("[Pyrodeath] emit failed on " .. clone6Name .. ": " .. text)
			end
		end

		flashLight(clone6.Light, t2.EruptFlash)
		debris:AddItem(clone6, 3)

		local cloneBurst = clone.Burst

		if cloneBurst then
			local ok, result = pcall(forgeVFX.emit, cloneBurst)

			if not ok then
				local cloneBurstName = cloneBurst.Name
				local text: string = tostring(result)

				warn("[Pyrodeath] emit failed on " .. cloneBurstName .. ": " .. text)
			end
		end

		sound:Play("KillEffects.Pyrodeath.Erupt", clone6)
		sound:Play("KillEffects.Pyrodeath.Roar", clone5)

		local magnitude = (CurrentCamera.CFrame.Position - vector32).Magnitude
		local _GShared = _G.Shared
		local _GSharedCamShaker = _GShared and _GShared.CamShaker

		if _GSharedCamShaker and magnitude < t2.ShakeDistance then
			_GSharedCamShaker:Shake("Explosion")
		end

		if magnitude < t2.PostDistance then
			local _PyroHeat: ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

			table.insert(t4, _PyroHeat)
			_PyroHeat.Name = "_PyroHeat"
			_PyroHeat.TintColor = Color3.fromRGB(255, 200, 170)
			_PyroHeat.Contrast = 0.15
			_PyroHeat.Brightness = 0.05
			_PyroHeat.Parent = lighting

			local tweenInfo5 = TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

			tweenService:Create(_PyroHeat, tweenInfo5, { Contrast = 0, Brightness = 0, TintColor = Color3.new(1, 1, 1) }):Play()
			debris:AddItem(_PyroHeat, 1)
		end
	end

	if not __FreezeAt or not (__FreezeAt < pillarStart) then
		local v140 = task.delay
		local v141 = math.max(pillarStart, 0)

		v140(v141, function()
			if u72 then
				v139()
			end
		end)
	end

	local charTime = t2.CharTime

	local function v143()
		if u73 then
			return
		end

		u79 = true

		for _, v in pairs(t5) do
			if v.part.Parent then
				v.part.Material = Enum.Material.CrackedLava
				v.part.Color = t2.CharColor
			end
		end

		for _, v in ipairs(Character:GetChildren()) do
			if v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") or v:IsA("BodyColors") then
				v.Parent = nil
			end
		end
	end

	if not __FreezeAt or not (__FreezeAt < charTime) then
		local v144 = task.delay
		local v145 = math.max(charTime, 0)

		v144(v145, function()
			if u72 then
				v143()
			end
		end)
	end

	local pillarEnd = t2.PillarEnd

	local function v147()
		stopEmitters(clone5)

		local clone5Light = clone5.Light
		local tweenInfo6 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		tweenService:Create(clone5Light, tweenInfo6, { Brightness = 0 }):Play()

		local clone7 = pyrodeath.Snap:Clone()

		clone7.CFrame = CFrame.new(vector32 + Vector3.new(0, 3, 0))
		clone7.Parent = _fx_Pyrodeath

		if clone7 then
			local ok, result = pcall(forgeVFX.emit, clone7)

			if not ok then
				local clone7Name = clone7.Name
				local text: string = tostring(result)

				warn("[Pyrodeath] emit failed on " .. clone7Name .. ": " .. text)
			end
		end

		debris:AddItem(clone7, 2.5)
		sound:Play("KillEffects.Pyrodeath.Snap", clone7)

		for _, v in pairs(t5) do
			if v.fire then
				if v.fire.BodyFire then
					local bodyFire = v.fire.BodyFire

					bodyFire.Rate = bodyFire.Rate * 0.25
				end

				if v.fire.BodySmoke then
					local bodySmoke = v.fire.BodySmoke

					bodySmoke.Rate = bodySmoke.Rate * 2.2
				end
			end
		end
	end

	if not __FreezeAt or not (__FreezeAt < pillarEnd) then
		local v148 = task.delay
		local v149 = math.max(pillarEnd, 0)

		v148(v149, function()
			if u72 then
				v147()
			end
		end)
	end

	v99 = t2.PillarEnd + 0.3

	local function v150()
		if u73 then
			return
		end

		sound:Play("KillEffects.Pyrodeath.Crackle", torso)
	end

	if not __FreezeAt or not (__FreezeAt < v99) then
		local v151 = task.delay
		local v152 = math.max(v99, 0)

		v151(v152, function()
			if u72 then
				v150()
			end
		end)
	end

	local t7: {[any]: any} = {}

	local function crumble(p16)
		if p16.crumbled then
			return
		end

		p16.crumbled = true

		local part = p16.part
		local v262 = p16.cf or part.CFrame
		local partSize = part.Size

		for _ = 1, t2.Chunks[p16.name] or 8 do
			local v265 = v82:NextInteger(1, #t3)
			local v266 = t3[v265]
			local ash: Part = Instance.new("Part")

			ash.Name = "Ash"
			ash.Anchored = true
			ash.CanCollide = false
			ash.CanQuery = false
			ash.CanTouch = false
			ash.CastShadow = true
			ash.Color = v266.color
			ash.Material = v266.material
			v266 = v82:NextNumber(0.25, 0.6)

			local v268 = v82:NextNumber(0.6, 1.1)
			local v269 = v82:NextNumber(0.7, 1.2)

			ash.Size = Vector3.new(v266, v266 * v268, v266 * v269)

			local n1 = v82:NextNumber(-0.45, 0.45) * partSize.X
			local n2 = v82:NextNumber(-0.45, 0.45) * partSize.Y

			v269 = v82:NextNumber(-0.45, 0.45)

			local vector33 = Vector3.new(n1, n2, v269 * partSize.Z)
			local cFrame = CFrame.new(vector33)
			local cFrameAngles = CFrame.Angles

			v268 = v82:NextNumber(0, 6.28)
			v269 = v82:NextNumber(0, 6.28)
			n2 = cFrameAngles(v268, v269, v82:NextNumber(0, 6.28))
			v265 = v262 * cFrame * n2
			ash.CFrame = v265
			ash.Parent = _fx_Pyrodeath
			v266 = v265.Position - v95
			v266 = Vector3.new(v266.X, 0, v266.Z)
			v266 = if v266.Magnitude > 0.05 then v266.Unit else v82:NextUnitVector()
			v269 = v265.Position

			local rotation = v265.Rotation
			local v276 = v82:NextNumber(0.5, 3)
			local v277 = v82:NextNumber(0.5, 2)
			local v278 = v82:NextNumber(0, 3)
			local v279 = v82:NextUnitVector()
			local v280 = v82:NextNumber(3, 9)

			table.insert(t7, {
				resting = false,
				bounces = 0,
				part = ash,
				pos = v269,
				rot = rotation,
				vel = v266 * v276 + unit * v277 + Vector3.new(0, 1, 0) * v278,
				spin = v279 * v280,
				half = ash.Size.Y / 2
			})
		end

		local clone8 = pyrodeath.AshBurst:Clone()

		clone8.CFrame = CFrame.lookAt(v262.Position, v262.Position + unit)
		clone8.Parent = _fx_Pyrodeath

		if clone8 then
			local ok, result = pcall(forgeVFX.emit, clone8)

			if not ok then
				local clone8Name = clone8.Name
				local text: string = tostring(result)

				warn("[Pyrodeath] emit failed on " .. clone8Name .. ": " .. text)
			end
		end

		debris:AddItem(clone8, 3)

		if p16.fire then
			for _, v in pairs(p16.fire) do
				v.Enabled = false
			end
		end

		setLocalTransparency(part, 1)
		p16.gone = true
	end

	local n1 = t2.CrumbleStart - 0.12

	local function v156()
		sound:Play("KillEffects.Pyrodeath.Crumble", clone)
		sound:Play("KillEffects.Pyrodeath.Gust", clone)
	end

	if not __FreezeAt or not (__FreezeAt < n1) then
		local v157 = task.delay
		local v158 = math.max(n1, 0)

		v157(v158, function()
			if u72 then
				v156()
			end
		end)
	end

	for _, v in pairs(t5) do
		local vCrumble = v.crumble

		local function v162()
			if u73 then
				return
			end

			crumble(v)
		end

		if not __FreezeAt or not (__FreezeAt < vCrumble) then
			local v163 = task.delay
			local v164 = math.max(vCrumble, 0)

			v163(v164, function()
				if u72 then
					v162()
				end
			end)
		end
	end

	n1 = t2.CrumbleStart + 0.25

	local function v165()
		local clone9 = pyrodeath.Pile:Clone()

		clone9.CFrame = CFrame.new(v95 + Vector3.new(0, 0.1, 0))
		clone9.Parent = _fx_Pyrodeath

		if clone9 then
			local ok, result = pcall(forgeVFX.emit, clone9)

			if not ok then
				local clone9Name = clone9.Name
				local text: string = tostring(result)

				warn("[Pyrodeath] emit failed on " .. clone9Name .. ": " .. text)
			end
		end

		tweenService:Create(clone9.Light, TweenInfo.new(0.4), { Brightness = 1.4 }):Play()
	end

	if not __FreezeAt or not (__FreezeAt < n1) then
		local v166 = task.delay
		local v167 = math.max(n1, 0)

		v166(v167, function()
			if u72 then
				v165()
			end
		end)
	end

	local fireDie = t2.FireDie

	local function v169()
		stopEmitters(clone)
		stopEmitters(clone.Ring)

		local cloneResidue_Smoke = clone.Residue_Smoke

		if cloneResidue_Smoke then
			local ok, result = pcall(forgeVFX.emit, cloneResidue_Smoke)

			if not ok then
				local cloneResidue_SmokeName = cloneResidue_Smoke.Name
				local text: string = tostring(result)

				warn("[Pyrodeath] emit failed on " .. cloneResidue_SmokeName .. ": " .. text)
			end
		end

		local cloneResidue_Embers = clone.Residue_Embers

		if cloneResidue_Embers then
			local ok, result = pcall(forgeVFX.emit, cloneResidue_Embers)

			if not ok then
				local cloneResidue_EmbersName = cloneResidue_Embers.Name
				local text: string = tostring(result)

				warn("[Pyrodeath] emit failed on " .. cloneResidue_EmbersName .. ": " .. text)
			end
		end

		tweenService:Create(clone.Light, TweenInfo.new(0.6), { Brightness = 0.3 }):Play()

		if u78 then
			pcall(function()
				sound.FadeOut(u78, 0.6)
			end)
			u78 = nil
		end
	end

	if not __FreezeAt or not (__FreezeAt < fireDie) then
		local v170 = task.delay
		local v171 = math.max(fireDie, 0)

		v170(v171, function()
			if u72 then
				v169()
			end
		end)
	end

	local function fadedSequence(p17, p18)
		local t11: {[any]: any} = {}

		for _, v in ipairs(p17.Keypoints) do
			local n1 = v.Value + (1 - v.Value) * p18
			local v309 = math.min(v.Envelope * (1 - p18), n1, 1 - n1)
			local numberSequenceKeypointNew = NumberSequenceKeypoint.new
			local vTime = v.Time
			local v312 = math.max(v309, 0)

			table.insert(t11, numberSequenceKeypointNew(vTime, n1, v312))
		end

		return NumberSequence.new(t11)
	end

	local fadeStart = t2.FadeStart

	local function v174()
		local tweenInfo7 = TweenInfo.new(t2.FadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local t12: {[any]: any} = {}

		local function wind(p19)
			if p19:IsA("ParticleEmitter") then
				p19.Enabled = false
				table.insert(t12, { e = p19, seq = p19.Transparency })

				return
			end

			if not p19:IsA("Beam") and not p19:IsA("Trail") then
				if p19:IsA("Light") then
					tweenService:Create(p19, tweenInfo7, { Brightness = 0 }):Play()

					return
				end

				if p19:IsA("Sound") then
					local tweenInfo8 = TweenInfo.new(t2.FadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

					tweenService:Create(p19, tweenInfo8, { Volume = 0 }):Play()

					return
				end

				if p19:IsA("BasePart") and p19.Transparency < 1 then
					tweenService:Create(p19, tweenInfo7, {
						Transparency = 1,
						CFrame = p19.CFrame - Vector3.new(0, 1, 0) * (p19.Size.Y * 0.6)
					}):Play()
				end

				return
			end

			p19.Enabled = false
		end

		for _, v in ipairs(_fx_Pyrodeath:GetDescendants()) do
			wind(v)
		end

		for _, v in ipairs(t4) do
			if v.Parent then
				wind(v)

				for _, iterValue in ipairs(v:GetDescendants()) do
					wind(iterValue)
				end
			end
		end

		if u78 then
			pcall(function()
				sound.FadeOut(u78, t2.FadeTime)
			end)
			u78 = nil
		end

		for _, v in ipairs(t7) do
			v.resting = true
		end

		local v324 = os.clock()
		local connection2 = nil

		connection2 = runService.Heartbeat:Connect(function()
			local v360 = os.clock()
			local v361 = math.clamp((v360 - v324) / t2.FadeTime, 0, 1)

			v361 = v361 * v361 * (3 - v361 * 2)

			for _, v in ipairs(t12) do
				if v.e.Parent then
					v.e.Transparency = fadedSequence(v.seq, v361)
				end
			end

			if v361 >= 1 or not u72 then
				connection2:Disconnect()
				cleanup()
			end
		end)
	end

	if not __FreezeAt or not (__FreezeAt < fadeStart) then
		local v175 = task.delay
		local v176 = math.max(fadeStart, 0)

		v175(v176, function()
			if u72 then
				v174()
			end
		end)
	end

	local v177 = os.clock()
	local n2 = 0

	local function noise3(p20, p21)
		local v328 = math.noise(p20 * 17, p21)
		local v329 = math.noise(p20 * 13, p21 + 7)
		local vector34 = Vector3.new(v328, v329, math.noise(p20 * 15, p21 + 13))

		return vector34
	end

	local t8: {[any]: any} = {}
	local t9: {[any]: any} = {}

	connection3 = runService.Heartbeat:Connect(function()
		if not u72 then
			return
		end

		local n1 = os.clock() - v177

		if __FreezeAt then
			n1 = math.min(n1, __FreezeAt)
		end

		local v332 = math.max(n1 - n2, 0)
		local v333 = math.min(v332, 0.05)

		n2 = n1

		if not u73 then
			table.clear(t8)
			table.clear(t9)

			local n11 = (n1 - t2.AgonyIn) / t2.AgonyTime
			local n3 = if n11 < 0 then 0 else if n11 > 1 then 1 else n11
			local n4 = (n3 - 1) ^ 3 * 2.70158 + 1 + (n3 - 1) ^ 2 * 1.70158

			n11 = (n1 - t2.CollapseStart) / t2.CollapseTime
			n3 = if n11 < 0 then 0 else if n11 > 1 then 1 else n11
			n11 = n3 * n3

			local n5 = (n1 - (t2.CollapseStart + t2.CollapseTime)) / 0.18
			local n6 = if n5 < 0 then 0 else if n5 > 1 then 1 else n5
			local sine = math.sin(n6 * 3.141592653589793)

			for _, v in pairs(t5) do
				if not v.gone and v.part.Parent then
					local v342 = v.from:Lerp(v.agony, n4)

					if n3 > 0 then
						v342 = v342:Lerp(v.kneel, n11)
					end

					local n7 = if n3 < 1 then t2.Flail * (1 - n11) * (if n4 < 0 then 0 else if n4 > 1 then 1 else n4) else 0.015
					local vSeed = v.seed
					local v345 = math.noise(n1 * 17, vSeed)
					local v346 = math.noise(n1 * 13, vSeed + 7)
					local vector35 = Vector3.new(v345, v346, math.noise(n1 * 15, vSeed + 13))
					local n8 = v342 + vector35 * n7

					if n6 > 0 and n6 < 1 then
						n8 -= Vector3.new(0, 1, 0) * (sine * 0.12 * (1 - n6))
					end

					v.cf = n8

					if u79 then
						if v.part.Color ~= t2.CharColor then
							v.part.Color = t2.CharColor
						end

						if v.part.Material ~= Enum.Material.CrackedLava then
							v.part.Material = Enum.Material.CrackedLava
						end
					end

					table.insert(t8, v.part)
					table.insert(t9, n8)
				end
			end

			if #t8 > 0 then
				workspace:BulkMoveTo(t8, t9, Enum.BulkMoveMode.FireCFrameChanged)
			end
		end

		if #t7 > 0 then
			table.clear(t8)
			table.clear(t9)

			for _, v in ipairs(t7) do
				if not v.resting and v.part.Parent then
					local vVel = v.vel
					local vector36 = Vector3.new(0, -t2.Gravity * v333, 0)

					v.vel = vVel + (vector36 + unit * (t2.WindSpeed * v333))
					v.pos = v.pos + v.vel * v333

					local n9 = v.spin.Magnitude * v333

					if n9 > 0 then
						v.rot = CFrame.fromAxisAngle(v.spin.Unit, n9) * v.rot
					end

					n9 = v93 + v.half

					if n9 >= v.pos.Y then
						v.pos = Vector3.new(v.pos.X, n9, v.pos.Z)
						v.bounces = v.bounces + 1

						if v.bounces >= 3 or math.abs(v.vel.Y) < 3 then
							v.vel = Vector3.new(0, 0, 0)
							v.spin = Vector3.new(0, 0, 0)
							v.resting = true
						else
							v.vel = Vector3.new(v.vel.X * 0.45, -v.vel.Y * 0.28, v.vel.Z * 0.45)
							v.spin = v.spin * 0.5
						end
					end

					table.insert(t8, v.part)

					local cFrame = CFrame.new(v.pos)

					table.insert(t9, cFrame * v.rot)
				end
			end

			if #t8 > 0 then
				workspace:BulkMoveTo(t8, t9, Enum.BulkMoveMode.FireCFrameChanged)
			end
		end

		if clone.Parent and n1 > 0.3 and n1 < t2.FireDie then
			local n10: number = if n1 < t2.PillarStart then 1.6 else if n1 < t2.PillarEnd then 2.6 else 1.3
			local cloneLight = clone.Light
			local v357 = math.noise(n1 * 6, 3)

			cloneLight.Brightness = n10 + 0.5 * v357
		end
	end)
end
