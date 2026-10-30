-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local u1 = nil
local cFrameNew = CFrame.new
local vector3New = Vector3.new

u1 = function(p1, p2, p3, p4)
	local v20 = p4 or 0
	local x = p1.X
	local y = p1.Y
	local z = p1.Z
	local v24 = p2.X
	local v25 = p2.Y
	local v26 = p2.Z
	local v27 = p3.X
	local v28 = p3.Y
	local v29 = p3.Z
	local v30 = x
	local v31 = y
	local v32 = z
	local v33 = v27
	local v34 = v28
	local v35 = v29
	local n1 = v24 - x
	local n2 = v25 - y
	local n3 = v26 - z
	local n4 = v27 - x
	local n5 = v28 - y
	local n6 = v29 - z
	local n7 = n1 * n4 + n2 * n5 + n3 * n6
	local n8 = n7 / (n1 * n1 + n2 * n2 + n3 * n3)

	if not (n8 > 0) then
		v30 = v27
		v31 = v28
		v32 = v29
		v33 = x
		v34 = y
		v35 = z
		n1 = v24 - v27
		n2 = v25 - v28
		n3 = v26 - v29
		n8 = (n1 * -n4 + n2 * -n5 + n3 * -n6) / (n1 * n1 + n2 * n2 + n3 * n3)
	elseif n8 > 1 then
		v33 = v24
		v34 = v25
		v35 = v26
		n1 = n4
		n2 = n5
		n3 = n6
		n8 = n7 / (n1 * n1 + n2 * n2 + n3 * n3)
	end

	local n9 = v33 - v30 - n8 * n1
	local n10 = v34 - v31 - n8 * n2
	local n11 = v35 - v32 - n8 * n3
	local n12 = (n1 * n1 + n2 * n2 + n3 * n3) ^ 0.5
	local n13 = (n9 * n9 + n10 * n10 + n11 * n11) ^ 0.5
	local n14 = n9 * 0.5
	local n15 = n10 * 0.5
	local n16 = n11 * 0.5
	local n17 = n8 * 0.5

	n7 = 0.5 + n17

	local n18 = n9 / n13
	local n19 = n10 / n13
	local n20 = n11 / n13
	local n21 = n1 / n12
	local n22 = n2 / n12
	local n23 = n3 / n12
	local n24 = n19 * n23 - n20 * n22
	local n25 = n20 * n21 - n18 * n23
	local n26 = n18 * n22 - n19 * n21
	local v62 = cFrameNew(n1 * n17 + n14 + v30, n2 * n17 + n15 + v31, n3 * n17 + n16 + v32, n24, n18, n21, n25, n19, n22, n26, n20, n23)
	local v63 = cFrameNew(n1 * n7 + n14 + v30, n2 * n7 + n15 + v31, n3 * n7 + n16 + v32, -n24, n18, -n21, -n25, n19, -n22, -n26, n20, -n23)
	local v64 = vector3New(v20, n13, n8 * n12)
	local v65 = vector3New(v20, n13, (1 - n8) * n12)

	return v62, v63, v64, v65
end
game:GetService("Debris")

local targetFragments = game.ReplicatedStorage:WaitForChild("FX"):WaitForChild("TargetFragments")
local glassParticles = game.ReplicatedStorage.FX.Debris:WaitForChild("GlassParticles")
local misc = require(game.ReplicatedStorage.Util.Misc)
local sound = require(game.ReplicatedStorage:WaitForChild("Sound"))
local brokenGlassStorage: Folder = Instance.new("Folder")

brokenGlassStorage.Name = "BrokenGlassStorage"
brokenGlassStorage.Parent = game.ReplicatedStorage

local t1: {[any]: any} = {
	ShatterSoundID = 144884907,
	SoundVolume = 2,
	Pitches = { 0.87, 0.95, 1, 1.05, 1.1 },
	Fragments = { Density = 1, SkipChance = 0 },
	Particles = { Enabled = true, EmitCount = 20, CleanupDelay = 2 },
	Velocity = {
		BulletInfluence = 1,
		RandomMin = 0.5,
		RandomMax = 1,
		OutwardForce = 5,
		UpwardForce = 3,
		MaxSpeed = 100,
		ConeAngle = 80
	},
	TargetVelocity = {
		LinearMultiplier = -0.6,
		AngularMultiplier = 0.2,
		RandomMin = 0.5,
		RandomMax = 1
	}
}

local function playShatterSound(p5)
	if t1.ShatterSoundID == "None" then
		return
	end

	local part: Part = Instance.new("Part")

	part.Size = Vector3.new(1, 1, 1)
	part.Transparency = 1
	part.Anchored = true
	part.CanCollide = false
	part.Position = p5
	part.Parent = workspace.Bin

	local sound2: Sound = Instance.new("Sound", part)

	sound2.SoundId = "rbxassetid://" .. t1.ShatterSoundID
	sound2.Volume = t1.SoundVolume

	local pitches = t1.Pitches
	local randomNumber = math.random(1, #t1.Pitches)

	sound2.PlaybackSpeed = pitches[randomNumber]
	sound2:Play()
	sound2.Ended:Connect(function()
		part:Destroy()
	end)
end
local function emitGlassParticles(p6)
	if not t1.Particles.Enabled then
		return
	end

	local clone = glassParticles:Clone()

	clone.Position = p6
	clone.Parent = workspace.Bin
	clone.Shatter:Emit(t1.Particles.EmitCount)
	task.delay(t1.Particles.CleanupDelay, function()
		clone:Destroy()
	end)
end
local function randomDirectionInCone(p7, p8)
	if p7.Magnitude <= 0 then
		return Vector3.new(0, 0, 0)
	end

	local unit = p7.Unit
	local v76 = math.rad(p8)
	local n1 = math.random() * 3.141592653589793 * 2
	local randomNumber = math.random()
	local cosine = math.cos(v76)
	local n2 = 1 - randomNumber * (1 - cosine)
	local squareRoot = math.sqrt(1 - n2 * n2)
	local cosine2 = math.cos(n1)
	local sine = math.sin(n1)
	local vector3 = Vector3.new(squareRoot * cosine2, squareRoot * sine, -n2)

	return CFrame.lookAt(Vector3.new(0, 0, 0), unit):VectorToWorldSpace(vector3).Unit
end
local function calculateFragmentVelocity(p9, p10, p11)
	local velocity = t1.Velocity
	local n1 = p9 * velocity.BulletInfluence
	local n2 = p10 - p11

	if n2.Magnitude > 0 then
		local v91 = randomDirectionInCone(n2.Unit, velocity.ConeAngle)

		n1 += v91 * velocity.OutwardForce
	end

	local vector3 = Vector3.new(0, velocity.UpwardForce, 0)
	local velocityRandomMin = velocity.RandomMin
	local randomNumber = math.random()
	local n3 = (n1 + vector3) * (velocityRandomMin + randomNumber * (velocity.RandomMax - velocity.RandomMin))

	if n3.Magnitude > velocity.MaxSpeed then
		n3 = n3.Unit * velocity.MaxSpeed
	end

	return n3
end
local function createFragmentsFromQuadrant(p12, p13, p14, p15, parent, p17, p18)
	local t2: {[any]: any} = { X = 0, Y = 0 }
	local t3: {[any]: any} = { false, false, false }
	local v105 = math.min(p13.X, p13.Y, p13.Z)
	local t4

	if p13.X == v105 then
		t2.X = p13.Y
		t2.Y = p13.Z
		t4 = { false, true, true }
	elseif v105 == p13.Y then
		t2.X = p13.X
		t2.Y = p13.Z
		t4 = { true, false, true }
	else
		t2.X = p13.X
		t2.Y = p13.Y
		t4 = { true, true, false }
	end

	v105 = function(p19, p20)
		local vector3 = Vector3.new()
		local v184 = p19

		for k, v in pairs(t4) do
			if v then
				local vector32 = nil

				if k == 1 then
					vector32 = Vector3.new(v184, 0, 0)
				elseif k == 2 then
					vector32 = Vector3.new(0, v184, 0)
				elseif k == 3 then
					vector32 = Vector3.new(0, 0, v184)
				end

				vector3 += vector32
				v184 = p20
			end
		end

		return vector3
	end

	local density = t1.Fragments.Density
	local t5: {[any]: any} = {}

	for i = 0, t2.Y, t2.Y / density do
		table.insert(t5, {})

		for j = 0, t2.X, t2.X / density do
			local v112 = t5[#t5]
			local v113 = v105(j - t2.X / 2, i - t2.Y / 2)

			table.insert(v112, p12 * v113)
		end
	end

	for i = 1, #t5 - 1 do
		for j = 1, #t5[i] - 1 do
			if not (math.random() < t1.Fragments.SkipChance) then
				local v116 = t5[i][j]
				local v117 = t5[i][j + 1]
				local v118 = t5[i + 1][j]
				local v119 = t5[i + 1][j + 1]

				if not v116 or not v117 or not v118 or not v119 then
					continue
				end

				for k = 1, 2 do
					local v121, v122, v123, v124 = u1(k == 1 and v116 or v119, v117, v118, p17)

					for l = 1, 2 do
						local wedgePart: WedgePart = Instance.new("WedgePart")

						wedgePart.AssemblyLinearVelocity = calculateFragmentVelocity(p15, (l == 1 and v121 or v122).Position, p18)
						wedgePart.TopSurface = 0
						wedgePart.BottomSurface = 0
						wedgePart.Material = p14.Material
						wedgePart.Transparency = p14.Transparency
						wedgePart.Reflectance = p14.Reflectance
						wedgePart.Color = p14.Color
						wedgePart.CFrame = l == 1 and v121 or v122
						wedgePart.Size = l == 1 and v123 or v124
						wedgePart.CollisionGroup = "Debris2"
						wedgePart.Parent = parent
					end
				end
			end
		end
	end
end
local function divideIntoQuadrants(p21, p22)
	local t6: {[any]: any} = {}
	local v130 = p21.Size
	local v131 = p21.CFrame
	local v132 = v131:PointToObjectSpace(p22)
	local v133 = math.min(0.1, v130.X / 2 - 0.001)
	local v134 = math.min(0.1, v130.Y / 2 - 0.001)
	local v135 = math.clamp(v132.X, -v130.X / 2 + v133, v130.X / 2 - v133)
	local v136 = math.clamp(v132.Y, -v130.Y / 2 + v134, v130.Y / 2 - v134)
	local vector3 = Vector3.new(v135, v136, 0)
	local n1 = v130.X / 2

	v135 = v130.Y / 2

	local vector3X = vector3.X
	local vector3Y = vector3.Y
	local cFrame = CFrame.new((vector3X + n1) / 2, (vector3Y + v135) / 2, 0)
	local vector33 = Vector3.new(n1 - vector3X, v135 - vector3Y, v130.Z)
	local cFrame2 = CFrame.new((vector3X - n1) / 2, (vector3Y - v135) / 2, 0)
	local vector34 = Vector3.new(n1 + vector3X, v135 + vector3Y, v130.Z)
	local cFrame3 = CFrame.new((vector3X + n1) / 2, (vector3Y - v135) / 2, 0)
	local vector35 = Vector3.new(n1 - vector3X, v135 + vector3Y, v130.Z)
	local cFrame4 = CFrame.new((vector3X - n1) / 2, (vector3Y + v135) / 2, 0)
	local vector36 = Vector3.new(n1 + vector3X, v135 - vector3Y, v130.Z)

	return {
		{ cframe = v131 * cFrame, size = vector33 },
		{ cframe = v131 * cFrame2, size = vector34 },
		{ cframe = v131 * cFrame3, size = vector35 },
		{ cframe = v131 * cFrame4, size = vector36 }
	}
end
function fragment(p23, p24, p25)
	if not p23 then
		return
	end

	if not p23.Parent then
		return
	end

	local u152: boolean = false

	if game.Players.LocalPlayer:GetAttribute("MatchId") == nil and game.Players.LocalPlayer:GetAttribute("Spectating") == nil then
		u152 = true
	end

	if p23.Name == "Meshes/balloon" or p23.Parent and p23.Parent.Name == "Balloon" then
		if not u152 then
			local v153 = p23

			if not v153:FindFirstChild("Pop") and p23.Parent then
				for _, v in ipairs(p23.Parent:GetChildren()) do
					if v:IsA("BasePart") and v:FindFirstChild("Pop") then
						v153 = v

						break
					end
				end
			end

			local e = v153:FindFirstChild("E")
			local spiky = e and e:FindFirstChild("spiky")

			if spiky and spiky:IsA("ParticleEmitter") then
				spiky:Emit(1)
			end

			for _, v in ipairs({ "Pop", "Pop2" }) do
				local v = v153:FindFirstChild(v)

				if v and v:IsA("ParticleEmitter") then
					v:Emit(5)
				end
			end

			sound:Play("Misc.BalloonPop", v153.Position)
		end

		return
	end

	if p23.Name == "Target" or p23.Parent.Name == "Target" then
		if not u152 then
			local targetVelocity = t1.TargetVelocity
			local clone = targetFragments:Clone()

			clone:PivotTo(p23.CFrame)

			for iterFirst, iterSecond in clone:GetChildren() do
				local targetVelocityRandomMin = targetVelocity.RandomMin
				local randomNumber = math.random()
				local n1 = targetVelocityRandomMin + randomNumber * (targetVelocity.RandomMax - targetVelocity.RandomMin)

				iterSecond.AssemblyLinearVelocity = targetVelocity.LinearMultiplier * p24 * n1
				iterSecond.AssemblyAngularVelocity = targetVelocity.AngularMultiplier * p24 * n1
			end

			clone.Parent = workspace.Bin

			local clone2 = game.ReplicatedStorage.FX.Debris.TargetBreak:Clone()

			clone2.Parent = clone
			misc.EmitAll(clone2)
			task.delay(1.2, function()
				clone2:Destroy()
			end)
			sound:Play("Misc.TargetHit", clone2, nil, nil, nil, 0.3)
			task.delay(3, function()
				clone:Destroy()
			end)
		end

		return
	end

	local v169 = p25 or p23.Position

	if not u152 then
		playShatterSound(v169)
	end

	emitGlassParticles(v169)

	local model: Model = Instance.new("Model")

	model.Name = "Glass Debris"

	local v171 = math.min(p23.Size.X, p23.Size.Y, p23.Size.Z)
	local v172 = math.min(0.35, v171)
	local v173 = divideIntoQuadrants(p23, v169)
	local v174 = math.min(p23.Size.X, p23.Size.Y, p23.Size.Z)

	for _, v in ipairs(v173) do
		local x = v.size.X
		local y = v.size.Y
		local u179: boolean = true

		if not (x > 0.1) then
			u179 = x <= v174 + 0.01
		end

		local u180: boolean = true

		if not (y > 0.1) then
			u180 = y <= v174 + 0.01
		end

		if u179 and u180 then
			createFragmentsFromQuadrant(v.cframe, v.size, p23, p24, model, v172, v169)
		end
	end

	model.Parent = workspace.Bin
	task.delay(3, function()
		model:Destroy()
	end)
end

return fragment
