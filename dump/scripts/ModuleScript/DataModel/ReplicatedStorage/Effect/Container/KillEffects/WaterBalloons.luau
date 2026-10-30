-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")

require(game.ReplicatedStorage.Effect)

local sound = require(game.ReplicatedStorage.Sound)
local misc = require(game.ReplicatedStorage.Util.Misc)
local debris = require(game.ReplicatedStorage.Util.Debris)
local mesh = game.ReplicatedStorage.FX.KillEffects.WaterBalloon.Mesh

local function randRange(p1)
	local min = p1.Min
	local randomNumber = math.random()

	return min + randomNumber * (p1.Max - p1.Min)
end
local function randSigned(p2)
	return (math.random() * 2 - 1) * p2
end
local function makeInert(p3)
	p3.Anchored = true
	p3.CanCollide = false
	p3.CanQuery = false
	p3.CanTouch = false
	p3.Massless = true
	p3.CastShadow = false
	p3.CollisionGroup = "Debris"
end

local t1: {[any]: any} = {
	Throws = 15,
	ThrowInterval = 0.08,
	IntervalJitter = 0.045,
	AimSpread = 0.6,
	BalloonScale = 2.8,
	BurstLifetime = 1.4,
	BinLifetime = 6,
	MaxViewDistance = 1000,
	FlightTime = NumberRange.new(0.3, 0.4),
	SpawnDistance = NumberRange.new(32, 46),
	SpawnHeight = NumberRange.new(8, 22),
	ArcHeight = NumberRange.new(5, 12),
	SpinSpeed = NumberRange.new(8, 18),
	TargetParts = { "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" }
}

return function(player)
	local Character = player.Character

	if not Character then
		return
	end

	if (workspace.CurrentCamera.CFrame.p - Character:GetPivot().Position).Magnitude >= t1.MaxViewDistance then
		return
	end

	local v17 = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

	if not v17 then
		return
	end

	local t2: {[any]: any} = {}

	for iterFirst, iterSecond in mesh:GetChildren() do
		if iterSecond:IsA("BasePart") then
			table.insert(t2, iterSecond)
		end
	end

	if #t2 == 0 then
		return
	end

	local t3: {[any]: any} = {}

	for iterFirst2, iterSecond2 in t1.TargetParts, nil, nil do
		local foundChild = Character:FindFirstChild(iterSecond2)

		if foundChild and foundChild:IsA("BasePart") then
			table.insert(t3, foundChild)
		end
	end

	if #t3 == 0 then
		t3 = { v17 }
	end

	local _fx_WaterBalloons: Folder = Instance.new("Folder")

	_fx_WaterBalloons.Name = "_FX_WaterBalloons"
	_fx_WaterBalloons.Parent = workspace.Bin

	local u26: boolean = true
	local t4: {[any]: any} = {}

	local function dropConnections()
		for key, value in t4 do
			if value.Connected then
				value:Disconnect()
			end
		end

		table.clear(t4)
	end
	local function teardown()
		if not u26 then
			return
		end

		u26 = false

		for key, value in t4 do
			if value.Connected then
				value:Disconnect()
			end
		end

		table.clear(t4)

		if _fx_WaterBalloons.Parent then
			_fx_WaterBalloons:Destroy()
		end
	end

	Character.AncestryChanged:Once(function()
		if Character:IsDescendantOf(game) then
			return
		end

		if not u26 then
			return
		end

		u26 = false

		for key, value in t4 do
			if value.Connected then
				value:Disconnect()
			end
		end

		table.clear(t4)

		if _fx_WaterBalloons.Parent then
			_fx_WaterBalloons:Destroy()
		end
	end)
	_fx_WaterBalloons.AncestryChanged:Once(function()
		if not _fx_WaterBalloons:IsDescendantOf(game) then
			u26 = false

			for key, value in t4 do
				if value.Connected then
					value:Disconnect()
				end
			end

			table.clear(t4)
		end
	end)
	v17.Anchored = false

	local function burst(p5, p6)
		if not p5.Parent then
			return
		end

		p5.CFrame = CFrame.new(p6)
		p5.Transparency = 1
		misc.EmitAll(p5)
		sound:Play("KillEffects.WaterBalloonImpact", p5, 80, nil, 0.9, 0.16)
		debris:AddItem(p5, t1.BurstLifetime)
	end
	local function throwOne()
		if not u26 then
			return
		end

		local randomNumber = math.random(1, #t2)
		local v43 = t2[randomNumber]
		local clone = v43:Clone()

		clone.Anchored = true
		clone.CanCollide = false
		clone.CanQuery = false
		clone.CanTouch = false
		clone.Massless = true
		clone.CastShadow = false
		clone.CollisionGroup = "Debris"
		clone.Size = v43.Size * t1.BalloonScale

		local v45: {[any]: any} = t3
		local randomNumber2 = math.random(1, #t3)
		local v47 = v45[randomNumber2]
		local aimSpread = t1.AimSpread
		local randomNumber3 = math.random()
		local v50 = t1.AimSpread
		local randomNumber4 = math.random()
		local v52 = t1.AimSpread
		local randomNumber5 = math.random()
		local vector3 = Vector3.new((randomNumber3 * 2 - 1) * aimSpread, (randomNumber4 * 2 - 1) * v50, (randomNumber5 * 2 - 1) * v52)
		local n1 = v47.Position + vector3

		local function currentTarget()
			if v47.Parent then
				n1 = v47.Position + vector3
			end

			return n1
		end

		local n2 = math.random() * 3.141592653589793 * 2
		local spawnDistance = t1.SpawnDistance
		local spawnDistanceMin = spawnDistance.Min
		local randomNumber6 = math.random()
		local n3 = spawnDistanceMin + randomNumber6 * (spawnDistance.Max - spawnDistance.Min)

		if v47.Parent then
			n1 = v47.Position + vector3
		end

		local n4 = n1
		local cosine = math.cos(n2)
		local spawnHeight = t1.SpawnHeight
		local spawnHeightMin = spawnHeight.Min
		local randomNumber7 = math.random()
		local n5 = spawnHeightMin + randomNumber7 * (spawnHeight.Max - spawnHeight.Min)
		local sine = math.sin(n2)
		local vector32 = Vector3.new(cosine * n3, n5, sine * n3)
		local n6 = n4 + vector32

		clone.CFrame = CFrame.new(n6)
		clone.Parent = _fx_WaterBalloons
		debris:AddItem(clone, t1.FlightTime.Max + t1.BurstLifetime + 0.5)
		sound:Play("KillEffects.WaterBalloonThrow", clone, 90, nil, 0.45, 0.12)

		local flightTime = t1.FlightTime
		local flightTimeMin = flightTime.Min
		local randomNumber8 = math.random()
		local n7 = flightTimeMin + randomNumber8 * (flightTime.Max - flightTime.Min)
		local arcHeight = t1.ArcHeight
		local arcHeightMin = arcHeight.Min
		local randomNumber9 = math.random()
		local n8 = arcHeightMin + randomNumber9 * (arcHeight.Max - arcHeight.Min)
		local spinSpeed = t1.SpinSpeed
		local spinSpeedMin = spinSpeed.Min
		local randomNumber10 = math.random()
		local n9 = spinSpeedMin + randomNumber10 * (spinSpeed.Max - spinSpeed.Min)
		local randomNumber11 = math.random()
		local randomNumber12 = math.random()
		local randomNumber13 = math.random()
		local vector33 = Vector3.new((randomNumber11 * 2 - 1) * 1, (randomNumber12 * 2 - 1) * 1, (randomNumber13 * 2 - 1) * 1)
		local u87 = vector33.Magnitude > 0.01 and vector33.Unit or Vector3.new(0, 1, 0)
		local v88 = os.clock()
		local connection = nil

		connection = runService.RenderStepped:Connect(function()
			if not u26 or not clone.Parent then
				connection:Disconnect()

				return
			end

			local n2 = os.clock() - v88
			local v97 = math.clamp(n2 / n7, 0, 1)

			if v47.Parent then
				n1 = v47.Position + vector3
			end

			local v98 = n1
			local v99 = misc.VertexTrajectory(v97, n6, v98, n8)
			local cFrame = CFrame.new(v99)
			local v101 = CFrame.fromAxisAngle(u87, n2 * n9)

			clone.CFrame = cFrame * v101

			if v97 >= 1 then
				connection:Disconnect()
				burst(clone, v98)
			end
		end)
		table.insert(t4, connection)
	end

	task.spawn(function()
		for i = 1, t1.Throws do
			if not u26 then
				return
			end

			throwOne()

			if i < t1.Throws then
				local taskWait = task.wait
				local throwInterval = t1.ThrowInterval
				local intervalJitter = t1.IntervalJitter
				local randomNumber = math.random()
				local v95 = math.max(0.03, throwInterval + (randomNumber * 2 - 1) * intervalJitter)

				taskWait(v95)
			end
		end
	end)
	debris:AddItem(_fx_WaterBalloons, t1.BinLifetime)
end
