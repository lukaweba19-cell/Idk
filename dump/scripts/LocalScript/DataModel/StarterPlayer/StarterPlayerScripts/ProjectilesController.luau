-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local runService: RunService = game:GetService("RunService")
local debris: Debris = game:GetService("Debris")
local util: Instance = replicatedStorage:WaitForChild("Util")
local misc = require(util:WaitForChild("Misc"))
local replicatedStorageUtil: Instance = replicatedStorage:WaitForChild("Util")
local fracture = require(replicatedStorageUtil:WaitForChild("Fracture"))
local effect = require(replicatedStorage:WaitForChild("Effect"))
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local destructibles = require(shared:WaitForChild("Destructibles"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local viewedPlayer = require(replicatedStorageShared:WaitForChild("ViewedPlayer"))
local v14: Instance = replicatedStorage:WaitForChild("Shared")
local playerState = require(v14:WaitForChild("PlayerState"))
local v16: Instance = replicatedStorage:WaitForChild("Shared")
local bulletTracer = require(v16:WaitForChild("BulletTracer"))
local abilities: Instance = replicatedStorage:WaitForChild("Abilities")
local explosiveKnifeClient = require(abilities:WaitForChild("ExplosiveKnifeClient"))
local explosiveKnifeClientParams = explosiveKnifeClient.PARAMS
local LocalPlayer: Player = players.LocalPlayer
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local replicatedStorageBindables: Instance = replicatedStorage:WaitForChild("Bindables")
local spawnKnife: Instance = replicatedStorageBindables:WaitForChild("SpawnKnife")
local spawnBullet: Instance = replicatedStorageBindables:WaitForChild("SpawnBullet")
local throwReplicate: Instance = remotes:WaitForChild("ThrowReplicate")
local shootReplicate: Instance = remotes:WaitForChild("ShootReplicate")
local reportHit: Instance = remotes:WaitForChild("ReportHit")
local hitReplicate: Instance = remotes:WaitForChild("HitReplicate")
local vector3 = Vector3.new(0, -workspace.Gravity * 0.75, 0)
local t1: {[any]: any} = {}
local t2: {[any]: any} = {}
local connection = nil

local function now()
	return workspace:GetServerTimeNow()
end
local function keyFor(p1, p2)
	local text: string = tostring(p1)
	local text2: string = tostring(p2)

	return text .. ":" .. text2
end
local function getRoot(p3)
	return p3:FindFirstChild("HumanoidRootPart") or p3:FindFirstChild("Torso") or p3:FindFirstChild("UpperTorso")
end
local function modelToPlayer(p4)
	return players:GetPlayerFromCharacter(p4)
end

local viewedPlayerGetSpecTargetUserId = viewedPlayer.GetSpecTargetUserId

local function isSpectatingUserId(p5)
	local v93 = viewedPlayerGetSpecTargetUserId()

	return v93 ~= nil and v93 == p5
end
local function fireHitFeedback(p6, p7, p8, p9, p10)
	if p10 == LocalPlayer.UserId then
		replicatedStorage.Bindables.Hit:Fire(p6, p7, p8, p9, false)

		return
	end

	local v99 = viewedPlayerGetSpecTargetUserId()

	if v99 ~= nil and v99 == p10 then
		replicatedStorage.Bindables.Hit:Fire(p6, p7, p8, p9, true)
	end
end
local function raycastWorld(p11, p12, filterDescendantsInstances)
	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = filterDescendantsInstances
	raycastParams.IgnoreWater = true

	return workspace:Raycast(p11, p12 - p11, raycastParams)
end
local function raycastEnemies(p14, p15)
	local filterDescendantsInstances: {[any]: any} = {}

	for iterFirst, iterSecond in workspace.Characters:GetChildren() do
		local humanoid = iterSecond:FindFirstChildOfClass("Humanoid")

		if humanoid and (humanoid:GetAttribute("PredictedHealth") or humanoid.Health) > 0 then
			table.insert(filterDescendantsInstances, iterSecond)
		end
	end

	if #filterDescendantsInstances == 0 then
		return nil
	end

	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Include
	raycastParams.FilterDescendantsInstances = filterDescendantsInstances
	raycastParams.IgnoreWater = true

	return workspace:Raycast(p14, p15 - p14, raycastParams)
end
local function getRightArm(p16)
	if not p16 then
		return nil
	end

	local foundChild = p16:FindFirstChild("Right Arm")

	return foundChild and foundChild:IsA("BasePart") and foundChild or nil
end
local function getRightHandTip(p17)
	local v114 = p17 and p17:FindFirstChild("RevolverRig") and p17.RevolverRig:FindFirstChild("RevolverMuzzle", true)

	if v114 and v114:IsA("Attachment") then
		return v114.WorldPosition
	end

	local v115

	if not p17 then
		v115 = nil
	else
		local foundChild = p17:FindFirstChild("Right Arm")

		v115 = foundChild and foundChild:IsA("BasePart") and foundChild or nil
	end

	if v115 then
		return v115.Position - v115.CFrame.UpVector / 2 + v115.CFrame.LookVector * 0.5
	end

	local humanoidRootPart = p17 and p17:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart and humanoidRootPart:IsA("BasePart") then
		return humanoidRootPart.Position + humanoidRootPart.CFrame.LookVector * 2
	end

	return Vector3.new(0, 0, 0)
end

local destructiblesRespawnSeconds = destructibles.RespawnSeconds
local t3: {[any]: any} = {}

local function setPartHidden(p18, p19, p20)
	if p19 then
		p18:SetAttribute("_OldTransparency", p18.Transparency)
		p18:SetAttribute("_OldCanCollide", p18.CanCollide)
		p18:SetAttribute("_OldCanQuery", p18.CanQuery)
		p18.Transparency = 1
		p18.CanCollide = false
		p18.CanQuery = false

		for _, v in ipairs(p18:GetDescendants()) do
			if v:IsA("Decal") or v:IsA("Texture") then
				v:SetAttribute("_OldTransparency", v.Transparency)
				v.Transparency = 1
			elseif v:IsA("ParticleEmitter") or v:IsA("Beam") or v:IsA("Trail") then
				v:SetAttribute("_OldEnabled", v.Enabled)
				v.Enabled = false
			end
		end

		return
	end

	local v123 = p20

	if v123 == nil then
		local _OldTransparency = p18:GetAttribute("_OldTransparency")

		v123 = if typeof(_OldTransparency) == "number" then _OldTransparency else 0
	end

	p18.Transparency = v123
	p18.CanCollide = p18:GetAttribute("_OldCanCollide")

	local _OldCanQuery = p18:GetAttribute("_OldCanQuery")

	p18.CanQuery = if typeof(_OldCanQuery) == "boolean" then _OldCanQuery else true

	for _, v in ipairs(p18:GetDescendants()) do
		if v:IsA("Decal") or v:IsA("Texture") then
			local _OldTransparency = v:GetAttribute("_OldTransparency")

			if typeof(_OldTransparency) == "number" then
				v.Transparency = _OldTransparency
			else
				v.Transparency = 0
			end
		elseif v:IsA("ParticleEmitter") or v:IsA("Beam") or v:IsA("Trail") then
			local _OldEnabled = v:GetAttribute("_OldEnabled")

			if typeof(_OldEnabled) == "boolean" then
				v.Enabled = _OldEnabled
			else
				v.Enabled = true
			end
		end
	end
end
local function collectEnablersUnder(p21)
	local t9: {[any]: any} = {}

	for _, v in ipairs(p21:GetDescendants()) do
		if v:IsA("BillboardGui") or v:IsA("RopeConstraint") and v.Visible then
			table.insert(t9, v)
		end
	end

	return t9
end
local function hidePartAndRespawn(p22, p23)
	local transparency = p22.Transparency
	local v137 = collectEnablersUnder(p22)

	setPartHidden(p22, true, transparency)

	for _, v in ipairs(v137) do
		if v:IsA("RopeConstraint") then
			v.Visible = false
		else
			v.Enabled = false
		end
	end

	task.delay(p23, function()
		if not p22 or not p22.Parent then
			return
		end

		setPartHidden(p22, false, transparency)

		for _, v in ipairs(v137) do
			if v and v.Parent then
				if v:IsA("RopeConstraint") then
					v.Visible = true
				else
					v.Enabled = true
				end
			end
		end
	end)
end
local function collectBaseParts(p24)
	local t10: {[any]: any} = {}

	for _, v in ipairs(p24:GetDescendants()) do
		if v:IsA("BasePart") then
			table.insert(t10, v)
		end
	end

	return t10
end
local function hideModelAndReschedule(p25, p26)
	local n1 = (t3[p25] or 0) + 1

	t3[p25] = n1

	local v147 = collectBaseParts(p25)
	local v148 = collectEnablersUnder(p25)

	for _, v in ipairs(v147) do
		setPartHidden(v, true, nil)
	end

	for _, v in ipairs(v148) do
		if v:IsA("RopeConstraint") then
			v.Visible = false
		else
			v.Enabled = false
		end
	end

	task.delay(p26, function()
		if t3[p25] ~= n1 then
			return
		end

		if not p25 or not p25.Parent then
			return
		end

		for _, v in ipairs(v147) do
			if v and v.Parent then
				setPartHidden(v, false, nil)
			end
		end

		for _, v in ipairs(v148) do
			if v and v.Parent then
				if v:IsA("RopeConstraint") then
					v.Visible = true
				else
					v.Enabled = true
				end
			end
		end
	end)
end

local t4: {[any]: any} = {
	RespawnSec = 8,
	SparkSec = 1,
	SoundId = "rbxassetid://75391734064914",
	SoundVolume = 0.7,
	PushSpeed = 22,
	LiftSpeed = 10,
	Spin = 6,
	FadeSec = 0.5,
	CollisionGroup = "Debris"
}
local t5: {[any]: any} = {}

local function breakMonitor(p27, p28)
	if t5[p27] then
		return
	end

	t5[p27] = true

	local clone = p27:Clone()

	clone.Name = "BrokenMonitor"

	local v156 = collectBaseParts(p27)

	for _, v in ipairs(v156) do
		setPartHidden(v, true, nil)
	end

	local v159 = collectBaseParts(clone)

	for _, v in ipairs(v159) do
		v.Anchored = false
		v.CanCollide = true
		v.CanQuery = false
		v.CanTouch = false
		pcall(function()
			v.CollisionGroup = "Debris"
		end)
	end

	local t11: {[any]: any} = {}
	local v163 = nil

	for _, v in ipairs(clone:GetDescendants()) do
		if v:IsA("Decal") or v:IsA("Texture") then
			v.Color3 = Color3.new(0, 0, 0)
		elseif v:IsA("ParticleEmitter") and v.Name == "MiniSparks" then
			table.insert(t11, v)

			local vParent = v.Parent

			if vParent and vParent:IsA("Attachment") then
				vParent = vParent.Parent
			end

			if vParent and vParent:IsA("BasePart") then
				v163 = vParent
			end
		end
	end

	clone.Parent = workspace:FindFirstChild("Bin") or workspace

	local normal = p28.Normal
	local vector32 = Vector3.new(-normal.X, 0, -normal.Z)

	if vector32.Magnitude < 0.2 then
		local n1 = math.random() * 3.141592653589793 * 2
		local cosine = math.cos(n1)
		local sine = math.sin(n1)

		vector32 = Vector3.new(cosine, 0, sine)
	end

	local v172 = v159[1]

	if v172 then
		v172.AssemblyLinearVelocity = vector32.Unit * 22 + Vector3.new(0, 10, 0)

		local randomNumber = math.random()
		local randomNumber2 = math.random()
		local randomNumber3 = math.random()

		v172.AssemblyAngularVelocity = Vector3.new(randomNumber * 2 - 1, randomNumber2 * 2 - 1, randomNumber3 * 2 - 1) * 6
	end

	for _, v in ipairs(t11) do
		v.Enabled = true
	end

	task.delay(1, function()
		for _, v in ipairs(t11) do
			if v.Parent then
				v.Enabled = false
			end
		end
	end)

	local parent = v163 or v172

	if parent then
		local sound: Sound = Instance.new("Sound")

		sound.SoundId = "rbxassetid://75391734064914"
		sound.Volume = 0.7
		sound.RollOffMaxDistance = 120
		sound.Parent = parent
		sound:Play()
	end

	task.delay(8, function()
		local t14: {[any]: any} = {}

		for _, v in ipairs(clone:GetDescendants()) do
			if v:IsA("BasePart") or v:IsA("Decal") or v:IsA("Texture") then
				table.insert(t14, v)
			end
		end

		for i = 1, 10 do
			for _, v in ipairs(t14) do
				if v.Parent then
					v.LocalTransparencyModifier = i / 10
				end
			end

			task.wait(0.05)
		end

		clone:Destroy()

		for _, v in ipairs(v156) do
			if v.Parent then
				setPartHidden(v, false, nil)
			end
		end

		t5[p27] = nil
	end)
end

local color3 = Color3.fromRGB(240, 120, 25)
local color32 = Color3.fromRGB(255, 176, 70)
local color33 = Color3.fromRGB(71, 50, 26)
local sound = require(replicatedStorage:WaitForChild("Sound"))
local t6: {[any]: any} = {
	PuffTexture = "rbxassetid://105823939247007",
	Puffs = 16,
	Chunks = 7,
	ChunkLife = 1.4,
	Sound = "Misc.PumpkinSplat",
	CollisionGroup = "Debris",
	Orange = color3,
	Pulp = color32,
	Stem = color33
}

local function splatPumpkin(p29, p30)
	local v182, v183 = p29:GetBoundingBox()
	local v184 = v182.Position
	local parent = workspace:FindFirstChild("Bin") or workspace
	local pumpkinSplat: Part = Instance.new("Part")

	pumpkinSplat.Name = "PumpkinSplat"
	pumpkinSplat.Anchored = true
	pumpkinSplat.CanCollide = false
	pumpkinSplat.CanQuery = false
	pumpkinSplat.CanTouch = false
	pumpkinSplat.Transparency = 1
	pumpkinSplat.Size = Vector3.new(0.2, 0.2, 0.2)
	pumpkinSplat.CFrame = CFrame.new(v184)

	local particleEmitter: ParticleEmitter = Instance.new("ParticleEmitter")

	particleEmitter.Texture = t6.PuffTexture
	particleEmitter.Color = ColorSequence.new(t6.Pulp, t6.Orange)
	particleEmitter.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1.4), NumberSequenceKeypoint.new(1, 0) })
	particleEmitter.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
	particleEmitter.Lifetime = NumberRange.new(0.5, 0.9)
	particleEmitter.Speed = NumberRange.new(10, 24)
	particleEmitter.SpreadAngle = Vector2.new(180, 180)
	particleEmitter.Drag = 5
	particleEmitter.Acceleration = Vector3.new(0, -25, 0)
	particleEmitter.Rotation = NumberRange.new(0, 360)
	particleEmitter.RotSpeed = NumberRange.new(-200, 200)
	particleEmitter.Enabled = false
	particleEmitter.Parent = pumpkinSplat
	pumpkinSplat.Parent = parent
	particleEmitter:Emit(t6.Puffs)
	debris:AddItem(pumpkinSplat, 1.5)

	local n1 = -p30.Normal
	local v189 = math.max(v183.X, v183.Z)

	for i = 1, t6.Chunks + 1 do
		local u191: boolean = i == t6.Chunks + 1
		local pumpkinChunk: Part = Instance.new("Part")

		pumpkinChunk.Name = "PumpkinChunk"
		pumpkinChunk.Size = if u191 then Vector3.new(0.45, 1.1, 0.45) else Vector3.new(1, 1, 1) * (0.35 + math.random() * 0.55)
		pumpkinChunk.Color = if u191 then t6.Stem else t6.Orange:Lerp(t6.Pulp, math.random() * 0.5)
		pumpkinChunk.Material = if u191 then Enum.Material.Wood else Enum.Material.SmoothPlastic
		pumpkinChunk.CanQuery = false
		pumpkinChunk.CanTouch = false
		pumpkinChunk.CanCollide = true
		pcall(function()
			pumpkinChunk.CollisionGroup = t6.CollisionGroup
		end)

		local randomNumber = math.random()
		local randomNumber4 = math.random()
		local randomNumber5 = math.random()
		local vector33 = Vector3.new(randomNumber - 0.5, randomNumber4 - 0.5, randomNumber5 - 0.5)
		local cFrame = CFrame.new(v184 + vector33 * (v189 * 0.35))
		local cFrameAngles = CFrame.Angles
		local randomNumber6 = math.random()
		local randomNumber7 = math.random()
		local randomNumber8 = math.random()
		local v202 = cFrameAngles(randomNumber6 * 6, randomNumber7 * 6, randomNumber8 * 6)

		pumpkinChunk.CFrame = cFrame * v202
		pumpkinChunk.Parent = parent

		local randomNumber9 = math.random()
		local randomNumber10 = math.random()
		local randomNumber11 = math.random()
		local unit = (Vector3.new(randomNumber9 - 0.5, 0.4 + randomNumber10 * 0.8, randomNumber11 - 0.5).Unit * 0.7 + n1 * 0.3).Unit
		local randomNumber12 = math.random()

		pumpkinChunk.AssemblyLinearVelocity = unit * (14 + randomNumber12 * 12) + (if u191 then Vector3.new(0, 16, 0) else Vector3.new(0, 0, 0))

		local randomNumber13 = math.random()
		local randomNumber14 = math.random()
		local randomNumber15 = math.random()

		pumpkinChunk.AssemblyAngularVelocity = Vector3.new(randomNumber13 - 0.5, randomNumber14 - 0.5, randomNumber15 - 0.5) * 20
		task.delay(t6.ChunkLife, function()
			for i = 1, 8 do
				if not pumpkinChunk.Parent then
					return
				end

				pumpkinChunk.Transparency = i / 8
				task.wait(0.04)
			end

			pumpkinChunk:Destroy()
		end)
	end

	sound:Play(t6.Sound, v184)
end

local t7: {[any]: any} = {}

local function breakPumpkinForGood(p31)
	t7[p31] = true
	t3[p31] = (t3[p31] or 0) + 1

	local v212 = collectBaseParts(p31)

	for _, v in ipairs(v212) do
		setPartHidden(v, true, nil)
	end
end
local function restoreBrokenPumpkins()
	for iterValue in t7 do
		if iterValue.Parent then
			t3[iterValue] = (t3[iterValue] or 0) + 1

			local v216 = collectBaseParts(iterValue)

			for _, v in ipairs(v216) do
				setPartHidden(v, false, nil)
			end
		end
	end

	table.clear(t7)
end

LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(restoreBrokenPumpkins)
LocalPlayer.CharacterRemoving:Connect(restoreBrokenPumpkins)

local function consumeHit(p32, p33, p34)
	local instance = p33.Instance

	if not instance then
		return
	end

	if (instance.Position - workspace.CurrentCamera.CFrame.Position).Magnitude > 2000 then
		return
	end

	local v223 = destructibles.GetHitKind(instance)

	if v223 == "glass" then
		fracture(instance, -p33.Normal * 50)
		hidePartAndRespawn(instance, destructiblesRespawnSeconds)
		table.insert(p32, instance)

		return true
	end

	if v223 == "targetPart" then
		fracture(instance, -p33.Normal * 50)
		hidePartAndRespawn(instance, destructiblesRespawnSeconds)

		if p34 then
			fireHitFeedback(instance, 50, nil, nil, p34)
		end

		table.insert(p32, instance)

		return true
	end

	if v223 == "balloon" then
		fracture(instance, -p33.Normal * 50)

		local instanceParent = instance.Parent

		if instanceParent and instanceParent:IsA("Model") then
			hideModelAndReschedule(instanceParent, destructiblesRespawnSeconds)
			table.insert(p32, instanceParent)
		else
			hidePartAndRespawn(instance, destructiblesRespawnSeconds)
			table.insert(p32, instance)
		end

		return true
	end

	if v223 == "targetModel" then
		fracture(instance, -p33.Normal * 50)

		local v225 = instance.Parent

		if v225 and v225:IsA("Model") then
			hideModelAndReschedule(v225, destructiblesRespawnSeconds)
			table.insert(p32, v225)
		else
			hidePartAndRespawn(instance, destructiblesRespawnSeconds)
			table.insert(p32, instance)
		end

		if p34 then
			fireHitFeedback(instance, 50, nil, nil, p34)
		end

		return true
	end

	if v223 == "monitor" then
		local v226 = instance.Parent

		if v226 and v226:IsA("Model") then
			breakMonitor(v226, p33)
			table.insert(p32, v226)
		else
			table.insert(p32, instance)
		end

		return true
	end

	if v223 == "pumpkin" then
		local v227 = instance.Parent

		if v227 and v227:IsA("Model") then
			if not t7[v227] then
				splatPumpkin(v227, p33)

				if p34 == LocalPlayer.UserId then
					breakPumpkinForGood(v227)
				else
					hideModelAndReschedule(v227, destructiblesRespawnSeconds)
				end
			end

			table.insert(p32, v227)
		else
			table.insert(p32, instance)
		end

		return true
	end

	if v223 == "playerBarrier" then
		table.insert(p32, instance)

		return true
	end

	return false
end
local function cleanupKnifePart(p35)
	if not p35 or not p35.Parent then
		return
	end

	task.spawn(function()
		local t15: {[any]: any} = {}
		local t16: {[any]: any} = {}

		for _, v in ipairs(p35:GetDescendants()) do
			if v:IsA("BasePart") then
				table.insert(t15, v)
			elseif not v:IsA("ParticleEmitter") and not v:IsA("Beam") and not v:IsA("Trail") and not v:IsA("PointLight") and not v:IsA("SpotLight") and not v:IsA("SurfaceLight") then
				if v:IsA("Decal") or v:IsA("Texture") then
					table.insert(t16, v)
				end
			else
				table.insert(t16, v)
			end
		end

		for _, v in ipairs(t16) do
			if not v:IsA("Decal") and not v:IsA("Texture") then
				if v:IsA("Beam") or v:IsA("Trail") or v:IsA("ParticleEmitter") or v:IsA("Light") then
					v.Enabled = false
				end
			else
				v.Transparency = 1
			end
		end

		for i = 1, 10 do
			local transparency: number = i * 0.1

			for _, v in ipairs(t15) do
				if v and v.Parent and v.Transparency < 1 then
					v.Transparency = transparency
				end
			end

			task.wait(0.016666666666666666)
		end

		if p35 then
			p35:Destroy()
		end
	end)
end
local function weldToHitPartWithRel(parent, part1, p38)
	if p38 then
		parent.CFrame = part1.CFrame * p38
	end

	parent.Anchored = false
	parent.Massless = true
	parent.CanCollide = false
	parent.CanQuery = false
	parent.CanTouch = false

	local weldConstraint: WeldConstraint = Instance.new("WeldConstraint")

	weldConstraint.Part0 = parent
	weldConstraint.Part1 = part1
	weldConstraint.Parent = parent
	parent.Parent = part1:FindFirstAncestorOfClass("Model") or part1
end
local function selfKnockbackFromBlast(p39)
	local Character: Model = LocalPlayer.Character

	if not Character then
		return
	end

	local humanoid: Instance = Character:FindFirstChildOfClass("Humanoid")
	local humanoidRootPart: Instance = Character:FindFirstChild("HumanoidRootPart")

	if humanoid and humanoidRootPart and not (humanoid.Health <= 0) then
		local movementController: Instance = Character:FindFirstChild("MovementController")

		movementController = movementController and movementController:FindFirstChild("Knockback")

		if not movementController or not movementController:IsA("BindableEvent") then
			return
		end

		local v238 = explosiveKnifeClientParams
		local numberValue = tonumber(v238.radius) or 12.5
		local magnitude = (humanoidRootPart.Position - p39).Magnitude

		if numberValue < magnitude then
			return
		end

		local explosiveKnifeClientKnockbackVelocity = explosiveKnifeClient.KnockbackVelocity
		local humanoidRootPartPosition = humanoidRootPart.Position
		local numberValue2: number? = tonumber(v238.selfKnockback)
		local numberValue3: number? = tonumber(v238.selfKnockbackMin)

		movementController:Fire(explosiveKnifeClientKnockbackVelocity(v238, p39, humanoidRootPartPosition, magnitude / numberValue, numberValue2 or 85, numberValue3 or 40))

		return
	end
end
local function stickKnifeAt(p40, p41, p42, p43, p44, p45, _, part1, p48)
	p40.alive = false
	p40.stuck = true

	local part = p40.part

	part.Anchored = true
	part.CanQuery = false
	part:SetAttribute("Stuck", true)
	task.delay(7, function()
		local v452 = part and part.Parent and part

		if not v452 then
			return
		end

		if not v452.Parent then
			return
		end

		task.spawn(function()
			local t17: {[any]: any} = {}
			local t18: {[any]: any} = {}

			for _, v in ipairs(v452:GetDescendants()) do
				if v:IsA("BasePart") then
					table.insert(t17, v)
				elseif not v:IsA("ParticleEmitter") and not v:IsA("Beam") and not v:IsA("Trail") and not v:IsA("PointLight") and not v:IsA("SpotLight") and not v:IsA("SurfaceLight") then
					if v:IsA("Decal") or v:IsA("Texture") then
						table.insert(t18, v)
					end
				else
					table.insert(t18, v)
				end
			end

			for _, v in ipairs(t18) do
				if not v:IsA("Decal") and not v:IsA("Texture") then
					if v:IsA("Beam") or v:IsA("Trail") or v:IsA("ParticleEmitter") or v:IsA("Light") then
						v.Enabled = false
					end
				else
					v.Transparency = 1
				end
			end

			for i = 1, 10 do
				local transparency: number = i * 0.1

				for _, v in ipairs(t17) do
					if v and v.Parent and v.Transparency < 1 then
						v.Transparency = transparency
					end
				end

				task.wait(0.016666666666666666)
			end

			if v452 then
				v452:Destroy()
			end
		end)
	end)

	if (part.Position - workspace.CurrentCamera.CFrame.Position).Magnitude > 2000 then
		return
	end

	if part1 and p45 then
		if p48 then
			part.CFrame = part1.CFrame * p48
		end

		part.Anchored = false
		part.Massless = true
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false

		local weldConstraint: WeldConstraint = Instance.new("WeldConstraint")

		weldConstraint.Part0 = part
		weldConstraint.Part1 = part1
		weldConstraint.Parent = part
		part.Parent = part1:FindFirstAncestorOfClass("Model") or part1
	else
		local v256 = p44

		if v256.Magnitude < 0.001 then
			v256 = -p43
		end

		local v257 = CFrame.lookAt(p42, p42 + v256.Unit)
		local v258 = part:FindFirstChild("StickOffset") and part.StickOffset.Value or CFrame.identity
		local v259 = CFrame.Angles(1.5707963267948966, 0, 0)
		local v260 = CFrame.Angles(3.141592653589793, 0, 0)

		part:PivotTo(v257 * (v258 * v259 * v260))
		part.CanCollide = false
	end

	if p41 and p41.Parent and p41.Parent.Name ~= "Barriers" and p40.effects.Portal and p40.effects.Portal > 0 and not p40.explodedLocal then
		p40.explodedLocal = true

		local v261 = effect.new("Portal")
		local v262 = misc.RayToCFrame(p41, p42, p43)

		v261:replicate({ CFrame = v262, IsLocal = p40.isCaster })
		v261 = p40.isCaster and LocalPlayer.Character

		local humanoidRootPart = v261 and v261:FindFirstChild("HumanoidRootPart")

		if humanoidRootPart then
			local raycastParams = RaycastParams.new()

			raycastParams.FilterType = Enum.RaycastFilterType.Exclude
			raycastParams.IgnoreWater = true
			raycastParams.FilterDescendantsInstances = { workspace.Characters, workspace.Bin }

			local n1 = -p44.Unit * 4

			if n1 ~= n1 then
				n1 = Vector3.new(0, 1, 0)
			end

			local v266 = workspace:Raycast(p42, n1, raycastParams)

			if v266 then
				humanoidRootPart.CFrame = CFrame.new(v266.Position) * humanoidRootPart.CFrame.Rotation
			else
				humanoidRootPart.CFrame = CFrame.new(p42 + n1) * humanoidRootPart.CFrame.Rotation
			end
		end
	end

	if p40.isExplosive and not p40.explodedLocal then
		p40.explodedLocal = true
		effect.new("Explosion"):replicate({ Position = p42 })

		if p40.isCaster and not p40.visualOnly then
			selfKnockbackFromBlast(p42)
		end
	end

	if p45 then
		local characterHit = effect.new("CharacterHit")
		local v268 = misc.RayToCFrame(p41, p42, p43)

		characterHit:replicate({ CFrame = v268, Character = p41 and p41.Parent or nil, Limb = p41 })

		return
	end

	local s1: string = "ThrowEffects." .. p40.throwEffect .. ".WallHit"

	if not effect.find(s1) then
		s1 = "ThrowEffects.Default.WallHit"
	end

	local v270 = effect.new(s1)
	local v271 = misc.RayToCFrame(p41, p42, p43)

	v270:replicate({
		CFrame = v271,
		Color = Color3.new(1, 1, 1),
		ExtraColor = Color3.new(1, 1, 1),
		HitPart = p41,
		Knife = p40.part
	})
end
local function smootherstep(p49)
	local v273 = math.clamp(p49, 0, 1)

	return v273 * v273 * v273 * (v273 * (v273 * 6 - 15) + 10)
end
local function throwHasAbilityEffect(p50)
	for iterFirst, iterSecond in p50.effects, nil, nil do
		if iterSecond > 0 then
			return true
		end
	end

	return false
end
local function ensureHeartbeat()
	if connection then
		return
	end

	connection = runService.Heartbeat:Connect(function(p51)
		if playerState.ReplayActive then
			local playerStateReplayTimeScale = playerState.ReplayTimeScale

			if typeof(playerStateReplayTimeScale) == "number" and playerStateReplayTimeScale == playerStateReplayTimeScale and playerStateReplayTimeScale >= 0 then
				p51 *= playerStateReplayTimeScale
			end
		end

		for i = #t1, 1, -1 do
			local v456 = t1[i]

			if not v456 then
				table.remove(t1, i)
			else
				if v456.alive then
					local position = v456.position

					v456.travel = v456.travel + v456.velocity.Magnitude * p51

					local v458 = math.clamp((v456.travel - v456.powerScalar * 52.800000000000004) / (v456.powerScalar * 92.4), 0, 1)
					local n1 = v458 * v458 * v458 * (v458 * (v458 * 6 - 15) + 10)
					local velocity = v456.velocity
					local v461 = math.exp(-(n1 * 0.19 + 0.03) * p51)

					v456.velocity = velocity * v461
					v456.velocity = v456.velocity + vector3 * (n1 * 0.85 + 0.15) * p51

					local magnitude = v456.velocity.Magnitude

					if magnitude > 0.001 and magnitude < 15 then
						v456.velocity = v456.velocity.Unit * 15
					end

					local n2 = position + v456.velocity * p51

					v458 = false

					if v456.isCaster and not v456.visualOnly then
						local Character: Model = LocalPlayer.Character
						local v465 = raycastEnemies(position, n2)
						local v466 = nil

						if v465 and Character and not v465.Instance:IsDescendantOf(Character) then
							v466 = v465.Instance:FindFirstAncestorOfClass("Model")
						end

						local v467: Player = players:GetPlayerFromCharacter(v466)
						local player: Player = players:GetPlayerByUserId(v456.ownerUserId)
						local u469: boolean = false

						if v467 and player and v467.Team == player.Team then
							u469 = true
						elseif player and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
							if player.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
								u469 = true
							end

							if v466 and typeof((LocalPlayer:GetAttribute("MatchSide"))) == "string" and v466:GetAttribute("BotMatchBot") == true and LocalPlayer:GetAttribute("MatchSide") == v466:GetAttribute("MatchSide") then
								u469 = true
							end
						end

						if v466 and not u469 and not v456.hitSet[v466] then
							v456.hitSet[v466] = true

							local humanoidRootPart = v466:FindFirstChild("HumanoidRootPart")

							if not humanoidRootPart then
								humanoidRootPart = v466:FindFirstChild("Torso")

								if not humanoidRootPart then
									humanoidRootPart = v466:FindFirstChild("UpperTorso")
								end
							end

							local u471: boolean = v465.Instance.Name == "Head"

							if not v456.predictedConfirm then
								v456.predictedConfirm = true
								fireHitFeedback(v466, if u471 then 250 else 100, u471, true, v456.ownerUserId)
							end

							local instance = v465.Instance
							local v473 = v456.velocity.Magnitude > 0.001 and v456.velocity.Unit or instance.CFrame.LookVector
							local v474 = v465.Position
							local v475 = CFrame.lookAt(v474, v474 + v473)
							local throwOffset = v456.part:FindFirstChild("ThrowOffset")
							local n3 = v475 * (throwOffset and v456.part.ThrowOffset.Value or CFrame.identity)

							v475 = CFrame.Angles(1.5707963267948966, 0, 0)

							local v478 = CFrame.Angles(3.141592653589793, 0, 0)
							local v479 = v456.part.PivotOffset:Inverse()
							local v480 = instance.CFrame:ToObjectSpace(n3 * v475 * v478 * v479)

							stickKnifeAt(v456, instance, v474, -v473, v456.velocity, true, Color3.new(1, 0, 0), instance, v480)

							local v481 = humanoidRootPart and humanoidRootPart.Parent:FindFirstChild("Humanoid")

							if v481 then
								local predictedHealth = v481:GetAttribute("PredictedHealth")

								v481:SetAttribute("PredictedHealth", (predictedHealth or v481.Health) - 100)
								v481.HealthChanged:Once(function()
									v481:SetAttribute("PredictedHealth", nil)
								end)
								task.delay(0.6, function()
									if v481 and v481.Parent then
										v481:SetAttribute("PredictedHealth", nil)
									end
								end)
							end

							v478 = {
								kind = "throw",
								throwId = v456.id,
								ownerUserId = v456.ownerUserId,
								targetUserId = v467 and v467.UserId or 0,
								targetModel = v466,
								at = time(),
								origin = v456.origin,
								to = humanoidRootPart and humanoidRootPart.Position or n2,
								vel = v456.velocity,
								hitPart = v465.Instance,
								hitPos = v474,
								headshot = u471
							}
							reportHit:FireServer(v478)
							v458 = true
						end
					end

					if not v458 then
						local ignore = v456.ignore
						local raycastParams = RaycastParams.new()

						raycastParams.FilterType = Enum.RaycastFilterType.Exclude
						raycastParams.FilterDescendantsInstances = ignore
						raycastParams.IgnoreWater = true

						local v485 = workspace:Raycast(position, n2 - position, raycastParams)

						while v485 and not v456.visualOnly and consumeHit(v456.ignore, v485, v456.ownerUserId) do
							local filterDescendantsInstances = v456.ignore
							local raycastParams2 = RaycastParams.new()

							raycastParams2.FilterType = Enum.RaycastFilterType.Exclude
							raycastParams2.FilterDescendantsInstances = filterDescendantsInstances
							raycastParams2.IgnoreWater = true
							v485 = workspace:Raycast(position, n2 - position, raycastParams2)
						end

						if v485 then
							v456.position = v485.Position
							stickKnifeAt(v456, v485.Instance, v485.Position, v485.Normal, v456.velocity, false, Color3.new(1, 1, 1), nil, nil)

							if v456.isCaster and not v456.visualOnly then
								local v488: boolean = false
								local u489

								for iterFirst, iterSecond in v456.effects, nil, nil do
									if iterSecond > 0 then
										u489 = true
										v488 = true

										break
									end
								end

								if not v488 then
									u489 = false
								end

								if u489 then
									local id = v456.id
									local ownerUserId = v456.ownerUserId
									local v494 = time()

									reportHit:FireServer({
										kind = "throw",
										throwId = id,
										ownerUserId = ownerUserId,
										at = v494,
										origin = v456.origin,
										vel = v456.velocity,
										hitPos = v485.Position,
										hitNormal = v485.Normal,
										hitPart = v485.Instance
									})
								end
							end
						else
							v456.spinAngle = v456.spinAngle + v456.spinSpeed * p51

							local cFrame = CFrame.new(n2, n2 + (v456.velocity.Magnitude > 0.001 and v456.velocity.Unit or Vector3.new(0, 0, -1)))
							local throwOffset = v456.part:FindFirstChild("ThrowOffset")
							local n4 = cFrame * (throwOffset and v456.part.ThrowOffset.Value or CFrame.identity)
							local v498 = v456.part:FindFirstChild("SpinDirection") and CFrame.Angles(v456.part.SpinDirection.Value.X * v456.spinAngle, v456.part.SpinDirection.Value.Y * v456.spinAngle, v456.part.SpinDirection.Value.Z * v456.spinAngle)

							if not v498 then
								v498 = CFrame.Angles(-v456.spinAngle - 1.5707963267948966, 0, 0)
							end

							v456.part:PivotTo(n4 * v498)
							v456.position = n2

							if v456.effects.Portal and v456.effects.Portal > 0 and v456.travel >= 45 and not v456.explodedLocal then
								v456.explodedLocal = true

								local portal = effect.new("Portal")
								local v500 = misc.RayToCFrame(nil, n2, Vector3.new(0, 1, 0))

								portal:replicate({ CFrame = v500, IsLocal = v456.isCaster })

								local v501 = v456.isCaster and LocalPlayer.Character
								local v502 = v501 and v501:FindFirstChild("HumanoidRootPart")

								if v502 then
									v502.CFrame = CFrame.new(n2 + Vector3.new(0, 2, 0)) * v502.CFrame.Rotation
								end

								v456.alive = false

								local part = v456.part

								if not part then
									return
								end

								if not part.Parent then
									return
								end

								task.spawn(function()
									local t19: {[any]: any} = {}
									local t20: {[any]: any} = {}

									for _, v in ipairs(part:GetDescendants()) do
										if v:IsA("BasePart") then
											table.insert(t19, v)
										elseif not v:IsA("ParticleEmitter") and not v:IsA("Beam") and not v:IsA("Trail") and not v:IsA("PointLight") and not v:IsA("SpotLight") and not v:IsA("SurfaceLight") then
											if v:IsA("Decal") or v:IsA("Texture") then
												table.insert(t20, v)
											end
										else
											table.insert(t20, v)
										end
									end

									for _, v in ipairs(t20) do
										if not v:IsA("Decal") and not v:IsA("Texture") then
											if v:IsA("Beam") or v:IsA("Trail") or v:IsA("ParticleEmitter") or v:IsA("Light") then
												v.Enabled = false
											end
										else
											v.Transparency = 1
										end
									end

									for i = 1, 10 do
										local transparency: number = i * 0.1

										for _, v in ipairs(t19) do
											if v and v.Parent and v.Transparency < 1 then
												v.Transparency = transparency
											end
										end

										task.wait(0.016666666666666666)
									end

									if part then
										part:Destroy()
									end
								end)

								return
							end

							if time() - v456.startTime > 7 then
								v456.alive = false

								local v504 = v456.part

								if v504 and v504.Parent then
									task.spawn(function()
										local t21: {[any]: any} = {}
										local t22: {[any]: any} = {}

										for _, v in ipairs(v504:GetDescendants()) do
											if v:IsA("BasePart") then
												table.insert(t21, v)
											elseif not v:IsA("ParticleEmitter") and not v:IsA("Beam") and not v:IsA("Trail") and not v:IsA("PointLight") and not v:IsA("SpotLight") and not v:IsA("SurfaceLight") then
												if v:IsA("Decal") or v:IsA("Texture") then
													table.insert(t22, v)
												end
											else
												table.insert(t22, v)
											end
										end

										for _, v in ipairs(t22) do
											if not v:IsA("Decal") and not v:IsA("Texture") then
												if v:IsA("Beam") or v:IsA("Trail") or v:IsA("ParticleEmitter") or v:IsA("Light") then
													v.Enabled = false
												end
											else
												v.Transparency = 1
											end
										end

										for i = 1, 10 do
											local transparency: number = i * 0.1

											for _, v in ipairs(t21) do
												if v and v.Parent and v.Transparency < 1 then
													v.Transparency = transparency
												end
											end

											task.wait(0.016666666666666666)
										end

										if v504 then
											v504:Destroy()
										end
									end)
								end
							end
						end
					end
				end

				if not v456.alive and not v456.stuck then
					local v505 = v456.id
					local text: string = tostring(v456.ownerUserId)
					local text3: string = tostring(v505)

					t2[text .. ":" .. text3] = nil
					table.remove(t1, i)
				elseif v456.stuck then
					if not playerState.ReplayActive then
						local v508 = v456.id
						local text: string = tostring(v456.ownerUserId)
						local text4: string = tostring(v508)

						t2[text .. ":" .. text4] = nil
					end

					table.remove(t1, i)
				end
			end
		end

		if #t1 == 0 and connection then
			connection:Disconnect()
			connection = nil
		end
	end)
end

local knives: Instance = replicatedStorage:WaitForChild("Knives")

local function resolveSkinName(p52, p53, p54)
	if not p54 then
		local v280 = p52 ~= 0 and players:GetPlayerByUserId(p52) or nil

		if v280 then
			local knifeSkin = v280:GetAttribute("KnifeSkin")

			if typeof(knifeSkin) == "string" and knifeSkin ~= "" then
				return knifeSkin
			end
		else
			for _, v in ipairs(workspace.Characters:GetChildren()) do
				local botUserId = v:GetAttribute("BotUserId")

				if p52 == botUserId then
					local knifeSkin = v:GetAttribute("KnifeSkin")

					if typeof(knifeSkin) ~= "string" or knifeSkin == "" then
						break
					end

					return knifeSkin
				end
			end
		end
	end

	if typeof(p53) == "string" and p53 ~= "" then
		return p53
	end

	return "Default"
end
local function getKnifeModelForSkin(p55)
	local foundChild: Instance = knives:FindFirstChild(p55)

	if foundChild and foundChild:IsA("Model") then
		return foundChild
	end

	local default: Instance = knives:FindFirstChild("Default")

	if default and default:IsA("Model") then
		return default
	end

	return nil
end
local function resolveThrowEffect(p56, p57, p58)
	if not p58 then
		local player: Player = players:GetPlayerByUserId(p56)

		if player then
			local throwEffect: any = player:GetAttribute("ThrowEffect")

			if typeof(throwEffect) == "string" and throwEffect ~= "" then
				return throwEffect
			end
		else
			for _, v in ipairs(workspace.Characters:GetChildren()) do
				local botUserId = v:GetAttribute("BotUserId")

				if p56 == botUserId then
					local throwEffect = v:GetAttribute("ThrowEffect")

					if typeof(throwEffect) ~= "string" or throwEffect == "" then
						break
					end

					return throwEffect
				end
			end
		end
	end

	if typeof(p57) == "string" and p57 ~= "" then
		return p57
	end

	return "Default"
end
local function findFirstBasePart(p59)
	local knifeRoot = p59:FindFirstChild("KnifeRoot")

	if knifeRoot and knifeRoot:IsA("BasePart") then
		return knifeRoot
	end

	if p59.PrimaryPart and p59.PrimaryPart:IsA("BasePart") then
		return p59.PrimaryPart
	end

	for _, v in ipairs(p59:GetDescendants()) do
		if v:IsA("BasePart") then
			return v
		end
	end

	return nil
end
local function makeKnifePartFromKnifeModel(p60)
	local v303 = findFirstBasePart(p60)

	assert(v303, "Knife model has no BasePart to use as projectile")

	local clone = v303:Clone()

	clone.Name = "ThrownKnife"
	clone.Anchored = true
	clone.CanCollide = false
	clone.CanQuery = false
	clone.CanTouch = false
	clone.Massless = false

	local boundingBox = p60:FindFirstChild("BoundingBox")

	if boundingBox and boundingBox:IsA("BasePart") and boundingBox ~= v303 then
		clone.PivotOffset = v303.CFrame:ToObjectSpace(boundingBox.CFrame)
	end

	for _, v in ipairs(clone:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Anchored = false
			v.CanCollide = false
			v.CanQuery = false
			v.CanTouch = false
			v.Massless = true
		elseif v:IsA("Bone") or v:IsA("AnimationController") then
			v:Destroy()
		end
	end

	return clone
end
local function spawnKnife2(p61)
	if typeof(p61) == "table" then
		local origin = p61.origin
		local target = p61.target
		local id = p61.id
		local u312 = p61.ownerUserId

		if typeof(origin) == "Vector3" and typeof(target) == "Vector3" then
			if typeof(id) == "number" then
				if typeof(u312) ~= "number" then
					u312 = 0
				end

				if (origin - workspace.CurrentCamera.CFrame.Position).Magnitude > 2000 then
					return
				end

				local text: string = tostring(u312)
				local text5: string = tostring(id)
				local v315 = t2[text .. ":" .. text5]

				if v315 == nil or v315.stuck then
					local u316: boolean = p61.visualOnly == true
					local v317 = resolveSkinName(u312, p61.skin, u316)
					local foundChild: Instance = knives:FindFirstChild(v317)
					local v319

					if foundChild and foundChild:IsA("Model") then
						v319 = foundChild
					else
						local default: Instance = knives:FindFirstChild("Default")

						v319 = if default and default:IsA("Model") then default else nil
					end

					if not v319 then
						warn("No knife models found in ReplicatedStorage.Knives (need at least Default)")

						return
					end

					local n1 = target - origin

					if n1.Magnitude < 0.001 then
						n1 = Vector3.new(0, 0, -1)
					end

					local v322 = makeKnifePartFromKnifeModel(v319)
					local cFrame = CFrame.new(origin, origin + n1.Unit)
					local throwOffset = v322:FindFirstChild("ThrowOffset")

					v322:PivotTo(cFrame * (throwOffset and v322.ThrowOffset.Value or CFrame.identity))
					v322.Parent = workspace.Bin
					v317 = players:GetPlayerByUserId(u312)

					local u325: boolean = v317 == players.LocalPlayer

					local function isEffectActiveAttr(p62, p63)
						if typeof(p63) == "number" then
							local v513: number = workspace:GetServerTimeNow()

							if p63 <= v513 then
								return nil, false
							end

							if not u325 then
								p62 = p62:gsub("^SERVER_", "")
							elseif p62:find("SERVER_", 1, true) then
								return nil, false
							end

							return p62:gsub("%.ExpiresAt$", ""), true
						end

						return nil, false
					end

					if v317 and not u316 then
						for iterFirst, iterSecond in v317:GetAttributes() do
							local v329, v330 = isEffectActiveAttr(iterFirst, iterSecond)

							if v330 and v329 and effect.find(v329) then
								local v331 = effect.new(v329)
								local boundingBox = v322:FindFirstChild("BoundingBox")

								v331:replicate({ Toggle = true, Throwing = true, Knife = boundingBox or v322 })
							end
						end
					end

					debris:AddItem(v322, 16)
					isEffectActiveAttr = 0.3333333333333333 + (p61.power or 1) * 2 / 3
					v317 = p61.effects or {}

					if v317.Portal and v317.Portal > 0 then
						isEffectActiveAttr *= 0.5
					end

					local n2 = 420 * isEffectActiveAttr
					local t12: {[any]: any} = {
						spinAngle = 0,
						alive = true,
						stuck = false,
						predictedConfirm = false,
						travel = 0,
						id = id,
						ownerUserId = u312,
						toolName = tostring(p61.toolName or "Knife"),
						part = v322,
						origin = origin,
						position = origin,
						velocity = n1.Unit * n2,
						startTime = time(),
						spinSpeed = 75.39822368615503 * isEffectActiveAttr,
						isCaster = u312 ~= 0 and u312 == LocalPlayer.UserId,
						startPos = origin,
						initialSpeed = n2,
						powerScalar = isEffectActiveAttr,
						hitSet = {},
						ignore = { v322, workspace.Characters, workspace.Bin },
						effects = v317,
						throwEffect = resolveThrowEffect(u312, p61.throwEffect, u316),
						visualOnly = u316,
						isExplosive = p61.isExplosive == true,
						explodedLocal = false
					}
					local throwEffect = t12.throwEffect

					local ok, result = pcall(function()
						effect.new("ThrowEffects." .. throwEffect):replicate({ Knife = v322, OwnerUserId = u312 })
					end)

					if not ok then
						local v338 = ("Couldn't run knife throw effect '%*': %*"):format(throwEffect, result)

						warn(v338, debug.traceback())
					end

					local spinSpeedOverride = v322:GetAttribute("SpinSpeedOverride")

					if typeof(spinSpeedOverride) == "number" then
						t12.spinSpeed = 6.283185307179586 * spinSpeedOverride
					end

					table.insert(t1, t12)

					local text6: string = tostring(u312)
					local text7: string = tostring(id)

					t2[text6 .. ":" .. text7] = t12

					if not connection then
						connection = runService.Heartbeat:Connect(function(p64)
							if playerState.ReplayActive then
								local playerStateReplayTimeScale = playerState.ReplayTimeScale

								if typeof(playerStateReplayTimeScale) == "number" and playerStateReplayTimeScale == playerStateReplayTimeScale and playerStateReplayTimeScale >= 0 then
									p64 *= playerStateReplayTimeScale
								end
							end

							for i = #t1, 1, -1 do
								local v517 = t1[i]

								if not v517 then
									table.remove(t1, i)
								else
									if v517.alive then
										local position = v517.position

										v517.travel = v517.travel + v517.velocity.Magnitude * p64

										local v519 = math.clamp((v517.travel - v517.powerScalar * 52.800000000000004) / (v517.powerScalar * 92.4), 0, 1)
										local n1 = v519 * v519 * v519 * (v519 * (v519 * 6 - 15) + 10)
										local velocity = v517.velocity
										local v522 = math.exp(-(n1 * 0.19 + 0.03) * p64)

										v517.velocity = velocity * v522
										v517.velocity = v517.velocity + vector3 * (n1 * 0.85 + 0.15) * p64

										local magnitude = v517.velocity.Magnitude

										if magnitude > 0.001 and magnitude < 15 then
											v517.velocity = v517.velocity.Unit * 15
										end

										local n2 = position + v517.velocity * p64

										v519 = false

										if v517.isCaster and not v517.visualOnly then
											local Character: Model = LocalPlayer.Character
											local v526 = raycastEnemies(position, n2)
											local v527 = nil

											if v526 and Character and not v526.Instance:IsDescendantOf(Character) then
												v527 = v526.Instance:FindFirstAncestorOfClass("Model")
											end

											local v528: Player = players:GetPlayerFromCharacter(v527)
											local player: Player = players:GetPlayerByUserId(v517.ownerUserId)
											local u530: boolean = false

											if v528 and player and v528.Team == player.Team then
												u530 = true
											elseif player and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
												if player.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
													u530 = true
												end

												if v527 and typeof((LocalPlayer:GetAttribute("MatchSide"))) == "string" and v527:GetAttribute("BotMatchBot") == true and LocalPlayer:GetAttribute("MatchSide") == v527:GetAttribute("MatchSide") then
													u530 = true
												end
											end

											if v527 and not u530 and not v517.hitSet[v527] then
												v517.hitSet[v527] = true

												local humanoidRootPart = v527:FindFirstChild("HumanoidRootPart")

												if not humanoidRootPart then
													humanoidRootPart = v527:FindFirstChild("Torso")

													if not humanoidRootPart then
														humanoidRootPart = v527:FindFirstChild("UpperTorso")
													end
												end

												local u532: boolean = v526.Instance.Name == "Head"

												if not v517.predictedConfirm then
													v517.predictedConfirm = true
													fireHitFeedback(v527, if u532 then 250 else 100, u532, true, v517.ownerUserId)
												end

												local instance = v526.Instance
												local v534 = v517.velocity.Magnitude > 0.001 and v517.velocity.Unit or instance.CFrame.LookVector
												local v535 = v526.Position
												local v536 = CFrame.lookAt(v535, v535 + v534)
												local throwOffset2 = v517.part:FindFirstChild("ThrowOffset")
												local n3 = v536 * (throwOffset2 and v517.part.ThrowOffset.Value or CFrame.identity)

												v536 = CFrame.Angles(1.5707963267948966, 0, 0)

												local v539 = CFrame.Angles(3.141592653589793, 0, 0)
												local v540 = v517.part.PivotOffset:Inverse()
												local v541 = instance.CFrame:ToObjectSpace(n3 * v536 * v539 * v540)

												stickKnifeAt(v517, instance, v535, -v534, v517.velocity, true, Color3.new(1, 0, 0), instance, v541)

												local v542 = humanoidRootPart and humanoidRootPart.Parent:FindFirstChild("Humanoid")

												if v542 then
													local predictedHealth = v542:GetAttribute("PredictedHealth")

													v542:SetAttribute("PredictedHealth", (predictedHealth or v542.Health) - 100)
													v542.HealthChanged:Once(function()
														v542:SetAttribute("PredictedHealth", nil)
													end)
													task.delay(0.6, function()
														if v542 and v542.Parent then
															v542:SetAttribute("PredictedHealth", nil)
														end
													end)
												end

												v539 = {
													kind = "throw",
													throwId = v517.id,
													ownerUserId = v517.ownerUserId,
													targetUserId = v528 and v528.UserId or 0,
													targetModel = v527,
													at = time(),
													origin = v517.origin,
													to = humanoidRootPart and humanoidRootPart.Position or n2,
													vel = v517.velocity,
													hitPart = v526.Instance,
													hitPos = v535,
													headshot = u532
												}
												reportHit:FireServer(v539)
												v519 = true
											end
										end

										if not v519 then
											local ignore = v517.ignore
											local raycastParams = RaycastParams.new()

											raycastParams.FilterType = Enum.RaycastFilterType.Exclude
											raycastParams.FilterDescendantsInstances = ignore
											raycastParams.IgnoreWater = true

											local v546 = workspace:Raycast(position, n2 - position, raycastParams)

											while v546 and not v517.visualOnly and consumeHit(v517.ignore, v546, v517.ownerUserId) do
												local filterDescendantsInstances = v517.ignore
												local raycastParams3 = RaycastParams.new()

												raycastParams3.FilterType = Enum.RaycastFilterType.Exclude
												raycastParams3.FilterDescendantsInstances = filterDescendantsInstances
												raycastParams3.IgnoreWater = true
												v546 = workspace:Raycast(position, n2 - position, raycastParams3)
											end

											if v546 then
												v517.position = v546.Position
												stickKnifeAt(v517, v546.Instance, v546.Position, v546.Normal, v517.velocity, false, Color3.new(1, 1, 1), nil, nil)

												if v517.isCaster and not v517.visualOnly then
													local v549: boolean = false
													local u550

													for iterFirst, iterSecond in v517.effects, nil, nil do
														if iterSecond > 0 then
															u550 = true
															v549 = true

															break
														end
													end

													if not v549 then
														u550 = false
													end

													if u550 then
														local id = v517.id
														local ownerUserId = v517.ownerUserId
														local v555 = time()

														reportHit:FireServer({
															kind = "throw",
															throwId = id,
															ownerUserId = ownerUserId,
															at = v555,
															origin = v517.origin,
															vel = v517.velocity,
															hitPos = v546.Position,
															hitNormal = v546.Normal,
															hitPart = v546.Instance
														})
													end
												end
											else
												v517.spinAngle = v517.spinAngle + v517.spinSpeed * p64

												local cFrame2 = CFrame.new(n2, n2 + (v517.velocity.Magnitude > 0.001 and v517.velocity.Unit or Vector3.new(0, 0, -1)))
												local throwOffset3 = v517.part:FindFirstChild("ThrowOffset")
												local n4 = cFrame2 * (throwOffset3 and v517.part.ThrowOffset.Value or CFrame.identity)
												local v559 = v517.part:FindFirstChild("SpinDirection") and CFrame.Angles(v517.part.SpinDirection.Value.X * v517.spinAngle, v517.part.SpinDirection.Value.Y * v517.spinAngle, v517.part.SpinDirection.Value.Z * v517.spinAngle)

												if not v559 then
													v559 = CFrame.Angles(-v517.spinAngle - 1.5707963267948966, 0, 0)
												end

												v517.part:PivotTo(n4 * v559)
												v517.position = n2

												if v517.effects.Portal and v517.effects.Portal > 0 and v517.travel >= 45 and not v517.explodedLocal then
													v517.explodedLocal = true

													local portal = effect.new("Portal")
													local v561 = misc.RayToCFrame(nil, n2, Vector3.new(0, 1, 0))

													portal:replicate({ CFrame = v561, IsLocal = v517.isCaster })

													local v562 = v517.isCaster and LocalPlayer.Character
													local v563 = v562 and v562:FindFirstChild("HumanoidRootPart")

													if v563 then
														v563.CFrame = CFrame.new(n2 + Vector3.new(0, 2, 0)) * v563.CFrame.Rotation
													end

													v517.alive = false

													local part = v517.part

													if not part then
														return
													end

													if not part.Parent then
														return
													end

													task.spawn(function()
														local t23: {[any]: any} = {}
														local t24: {[any]: any} = {}

														for _, v in ipairs(part:GetDescendants()) do
															if v:IsA("BasePart") then
																table.insert(t23, v)
															elseif not v:IsA("ParticleEmitter") and not v:IsA("Beam") and not v:IsA("Trail") and not v:IsA("PointLight") and not v:IsA("SpotLight") and not v:IsA("SurfaceLight") then
																if v:IsA("Decal") or v:IsA("Texture") then
																	table.insert(t24, v)
																end
															else
																table.insert(t24, v)
															end
														end

														for _, v in ipairs(t24) do
															if not v:IsA("Decal") and not v:IsA("Texture") then
																if v:IsA("Beam") or v:IsA("Trail") or v:IsA("ParticleEmitter") or v:IsA("Light") then
																	v.Enabled = false
																end
															else
																v.Transparency = 1
															end
														end

														for i = 1, 10 do
															local transparency: number = i * 0.1

															for _, v in ipairs(t23) do
																if v and v.Parent and v.Transparency < 1 then
																	v.Transparency = transparency
																end
															end

															task.wait(0.016666666666666666)
														end

														if part then
															part:Destroy()
														end
													end)

													return
												end

												if time() - v517.startTime > 7 then
													v517.alive = false

													local v565 = v517.part

													if v565 and v565.Parent then
														task.spawn(function()
															local t25: {[any]: any} = {}
															local t26: {[any]: any} = {}

															for _, v in ipairs(v565:GetDescendants()) do
																if v:IsA("BasePart") then
																	table.insert(t25, v)
																elseif not v:IsA("ParticleEmitter") and not v:IsA("Beam") and not v:IsA("Trail") and not v:IsA("PointLight") and not v:IsA("SpotLight") and not v:IsA("SurfaceLight") then
																	if v:IsA("Decal") or v:IsA("Texture") then
																		table.insert(t26, v)
																	end
																else
																	table.insert(t26, v)
																end
															end

															for _, v in ipairs(t26) do
																if not v:IsA("Decal") and not v:IsA("Texture") then
																	if v:IsA("Beam") or v:IsA("Trail") or v:IsA("ParticleEmitter") or v:IsA("Light") then
																		v.Enabled = false
																	end
																else
																	v.Transparency = 1
																end
															end

															for i = 1, 10 do
																local transparency: number = i * 0.1

																for _, v in ipairs(t25) do
																	if v and v.Parent and v.Transparency < 1 then
																		v.Transparency = transparency
																	end
																end

																task.wait(0.016666666666666666)
															end

															if v565 then
																v565:Destroy()
															end
														end)
													end
												end
											end
										end
									end

									if not v517.alive and not v517.stuck then
										local v566 = v517.id
										local text8: string = tostring(v517.ownerUserId)
										local text9: string = tostring(v566)

										t2[text8 .. ":" .. text9] = nil
										table.remove(t1, i)
									elseif v517.stuck then
										if not playerState.ReplayActive then
											local v569 = v517.id
											local text10: string = tostring(v517.ownerUserId)
											local text11: string = tostring(v569)

											t2[text10 .. ":" .. text11] = nil
										end

										table.remove(t1, i)
									end
								end
							end

							if #t1 == 0 and connection then
								connection:Disconnect()
								connection = nil
							end
						end)
					end

					return
				end

				return
			end

			return
		end

		return
	end
end

local bulletTracerFire = bulletTracer.Fire

local function consumeDestructiblesAlongSegment(p65, p66, filterDescendantsInstances, p68)
	local n1 = p66 - p65
	local magnitude = n1.Magnitude

	if magnitude <= 0.05 then
		return
	end

	local unit = n1.Unit

	n1 = p65

	local v349 = magnitude

	while v349 > 0.05 do
		local raycastParams = RaycastParams.new()

		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams.FilterDescendantsInstances = filterDescendantsInstances
		raycastParams.IgnoreWater = true

		local v351 = workspace:Raycast(n1, n1 + unit * (v349 + 0.05) - n1, raycastParams)

		if not v351 then
			return
		end

		if not consumeHit(filterDescendantsInstances, v351, p68) then
			return
		end

		n1 = v351.Position + unit * 0.05
		v349 = (p66 - n1).Magnitude
	end
end
local function spawnBullet2(p69, player)
	if not p69.isADS then
		task.wait()
		task.wait()
	end

	if typeof(p69) == "table" then
		local v354 = p69.ownerUserId

		if typeof(v354) ~= "number" then
			v354 = if player and player:IsA("Player") then player.UserId else 0
		end

		local player: Player = players:GetPlayerByUserId(v354)
		local Character = nil

		if player then
			Character = player.Character
		else
			for _, v in ipairs(workspace.Characters:GetChildren()) do
				local botUserId = v:GetAttribute("BotUserId")

				if v354 == botUserId then
					Character = v

					break
				end
			end
		end

		if not Character then
			return
		end

		if not Character:FindFirstChild("HumanoidRootPart") then
			return
		end

		local bulletFx = p69.bulletFx
		local v361 = if typeof(bulletFx) == "string" and bulletFx ~= "" then bulletFx else player and player:GetAttribute("ShotEffect") or Character and Character:GetAttribute("ShotEffect") or "Default"
		local filterDescendantsInstances: {[any]: any} = { workspace.Characters, workspace.Bin }
		local u363 = p69.origin

		if typeof(u363) ~= "Vector3" then
			u363 = getRightHandTip(Character)

			local raycastParams = RaycastParams.new()

			raycastParams.FilterType = Enum.RaycastFilterType.Exclude
			raycastParams.FilterDescendantsInstances = filterDescendantsInstances
			raycastParams.IgnoreWater = true

			local cFrame = Character.HumanoidRootPart.CFrame
			local vector34 = Vector3.new(Character.HumanoidRootPart.Size.X / 2 - 0.01, Character.HumanoidRootPart.Size.Y / 2 - 0.01, 0)
			local n1 = cFrame * vector34
			local n2 = u363 - n1

			if n2.Magnitude > 0.01 then
				local v369 = workspace:Raycast(n1, n2, raycastParams)

				if v369 then
					u363 = v369.Position - n2 * 0.01
				end
			end
		end

		if (u363 - workspace.CurrentCamera.CFrame.Position).Magnitude > 2000 then
			return
		end

		local humanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

		local function tracerOriginFor(p71)
			local v573 = getRightHandTip(Character)

			if v573 == Vector3.new(0, 0, 0) then
				return u363
			end

			if (v573 - humanoidRootPart.Position).Magnitude > 12 then
				return u363
			end

			local n1 = p71 - v573

			if n1.Magnitude < 3 then
				return u363
			end

			if (p71 - u363).Magnitude > 0.05 and n1.Unit:Dot((p71 - u363).Unit) < 0.2 then
				return u363
			end

			return v573
		end

		local segments = p69.segments

		if typeof(segments) == "table" and #segments > 0 then
			for i, v in ipairs(segments) do
				if typeof(v) == "table" then
					local v375 = v.from or u363
					local v376 = v.hitPos or v.to

					if typeof(v376) == "Vector3" then
						consumeDestructiblesAlongSegment(v375, v376, filterDescendantsInstances, v354)

						local n3

						if i == 1 then
							local v379 = getRightHandTip(Character)
							local n4 = v376 - v379
							local n5 = v376 - u363

							n3 = (if v379 == Vector3.new(0, 0, 0) then u363 else if (v379 - humanoidRootPart.Position).Magnitude > 12 then u363 else if n4.Magnitude < 3 then u363 else if n5.Magnitude > 0.05 and n4.Unit:Dot(n5.Unit) < 0.2 then u363 else v379) or v375
						else
							n3 = v375
						end

						bulletTracerFire(n3, v376, v361, Character)

						if i < #segments then
							effect.new("Misc.RicochetFlash"):replicate({ Position = v376 })
						end
					end
				end
			end
		else
			local v381 = p69.hitPos

			if typeof(v381) ~= "Vector3" then
				v381 = p69.target
			end

			if typeof(v381) ~= "Vector3" then
				v381 = p69.to
			end

			if typeof(v381) ~= "Vector3" then
				return
			end

			consumeDestructiblesAlongSegment(u363, v381, filterDescendantsInstances, v354)

			local v382 = getRightHandTip(Character)
			local n6 = v381 - v382
			local n7 = v381 - u363
			local n8 = if v382 == Vector3.new(0, 0, 0) then u363 else if (v382 - humanoidRootPart.Position).Magnitude > 12 then u363 else if n6.Magnitude < 3 then u363 else if n7.Magnitude > 0.05 and n6.Unit:Dot(n7.Unit) < 0.2 then u363 else v382

			bulletTracerFire(n8, v381, v361, Character)
		end

		local v386 = p69.hitPos

		if typeof(v386) ~= "Vector3" then
			v386 = p69.target
		end

		if typeof(v386) ~= "Vector3" then
			v386 = p69.to
		end

		if typeof(v386) == "Vector3" then
			local vectorValue = Vector3.new(0, 1, 0)

			if typeof(p69.hitNormal) == "Vector3" then
				vectorValue = p69.hitNormal
			end

			local hitInstance = nil

			if typeof(p69.hitInstance) == "Instance" then
				hitInstance = p69.hitInstance
			end

			if p69.isCharacterHit == true then
				local characterHit = effect.new("CharacterHit")
				local v390 = misc.RayToCFrame(hitInstance, v386, vectorValue)

				characterHit:replicate({
					CFrame = v390,
					Character = hitInstance and hitInstance.Parent or nil,
					Limb = hitInstance
				})
			else
				bulletTracer.WallHit(hitInstance, v386, vectorValue, v361)
			end

			return
		end

		return
	end
end
local function onHitReplicate(p72, player)
	if typeof(p72) == "table" then
		if tostring(p72.kind or "") == "throw" then
			if player and player:IsA("Player") then
				p72.ownerUserId = player.UserId
			end

			local ownerUserId = p72.ownerUserId

			if typeof(ownerUserId) == "number" then
				local throwId = p72.throwId

				if typeof(throwId) == "number" then
					local text: string = tostring(ownerUserId)
					local text12: string = tostring(throwId)
					local v397 = t2[text .. ":" .. text12]

					if not v397 then
						return
					end

					if v397.isCaster and v397.stuck then
						return
					end

					if v397.stuck and playerState.ReplayActive then
						local text13: string = tostring(ownerUserId)
						local text14: string = tostring(throwId)

						t2[text13 .. ":" .. text14] = nil
					end

					local attachPart = nil
					local relCFrame = nil

					if typeof(p72.attachPart) == "Instance" and p72.attachPart:IsA("BasePart") then
						attachPart = p72.attachPart
					end

					if typeof(p72.relCFrame) == "CFrame" then
						relCFrame = p72.relCFrame
					end

					local hitPos = nil
					local hitNormal = nil

					if typeof(p72.hitPos) == "Vector3" then
						hitPos = p72.hitPos
					end

					if typeof(p72.hitNormal) == "Vector3" then
						hitNormal = p72.hitNormal
					end

					local v404 = nil

					if typeof(p72.hitInstance) == "Instance" then
						v404 = p72.hitInstance
					end

					local u405: boolean = true

					if p72.isCharacterHit ~= true then
						u405 = attachPart ~= nil
					end

					if attachPart and relCFrame and attachPart.Parent then
						stickKnifeAt(v397, v404 or attachPart, hitPos or (attachPart.CFrame * relCFrame).Position, hitNormal or attachPart.CFrame.UpVector, v397.velocity, true, Color3.new(1, 0, 0), attachPart, relCFrame)

						return
					end

					if hitPos and hitNormal then
						stickKnifeAt(v397, v404, hitPos, hitNormal, v397.velocity, false, Color3.new(1, 0, 0), nil, nil)

						return
					end

					stickKnifeAt(v397, v404, v397.part.Position, Vector3.new(0, 1, 0), v397.velocity, u405, Color3.new(1, 0, 0), nil, nil)

					return
				end

				return
			end

			return
		end

		return
	end
end

spawnKnife.Event:Connect(spawnKnife2)
throwReplicate.OnClientEvent:Connect(spawnKnife2)
spawnBullet.Event:Connect(function(p74)
	spawnBullet2(p74, nil)
end)
shootReplicate.OnClientEvent:Connect(function(p75, p76)
	spawnBullet2(p75, p76)
end)
hitReplicate.OnClientEvent:Connect(onHitReplicate)

local replayHitReplicate: Instance = replicatedStorageBindables:FindFirstChild("ReplayHitReplicate")

if replayHitReplicate and replayHitReplicate:IsA("BindableEvent") then
	replayHitReplicate.Event:Connect(function(p77)
		onHitReplicate(p77, nil)
	end)
end

replicatedStorageBindables:WaitForChild("ConsumeHit").Event:Connect(function(p78, p79)
	consumeHit({}, p78, p79 or LocalPlayer.UserId)
end)
remotes:WaitForChild("ConsumeHit").OnClientEvent:Connect(function(p80, p81)
	consumeHit({}, p80, p81)
end)

local function doRoundCleanup()
	for i = #t1, 1, -1 do
		local v415 = t1[i]

		if v415.part and v415.part.Parent then
			v415.part:Destroy()
		end

		local id = v415.id
		local text: string = tostring(v415.ownerUserId)
		local text15: string = tostring(id)

		t2[text .. ":" .. text15] = nil
		table.remove(t1, i)
	end

	require(replicatedStorage:WaitForChild("AbilityEffectClient")).ClearAll()

	for _, v in ipairs(workspace.Bin:GetChildren()) do
		if v.Name == "SmokeSphere" or v:GetAttribute("FromAbilityCast") then
			v:Destroy()
		end
	end

	for _, v in ipairs(workspace.Terrain:GetChildren()) do
		if v:IsA("Attachment") then
			v:Destroy()
		end
	end

	for _, v in ipairs(workspace.Bin:GetDescendants()) do
		if v:GetAttribute("FromAbilityCast") then
			v:Destroy()
		end
	end
end

remotes:WaitForChild("RoundCleanup").OnClientEvent:Connect(doRoundCleanup)

local bindables: Instance = replicatedStorage:FindFirstChild("Bindables")

bindables = bindables and bindables:FindFirstChild("ReplayRoundCleanup")

if bindables and bindables:IsA("BindableEvent") then
	bindables.Event:Connect(doRoundCleanup)
end
