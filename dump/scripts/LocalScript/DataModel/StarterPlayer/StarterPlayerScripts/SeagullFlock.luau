-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local runService: RunService = game:GetService("RunService")
local LocalPlayer: Player = players.LocalPlayer
local t1: {[any]: any} = { "Left", "Right" }
local seagulls: Instance = replicatedStorage:WaitForChild("FX"):WaitForChild("Seagulls")
local t2: {[any]: any} = { "Seagull1", "Seagull2", "Seagull3" }
local seagullArea: Instance = workspace:WaitForChild("Lobby"):WaitForChild("SeagullArea", 120)

if not seagullArea then
	return
end

local cFrameIdentity = CFrame.identity
local v10 = CFrame.Angles(3.141592653589793, 0, 0)
local v11 = CFrame.Angles(0, 3.141592653589793, 0)

local function rotationAngle(p1, p2)
	local v48, v49, v50, v51, v52, v53, v54, v55, v56, v57, v58, v59 = p1:ToObjectSpace(p2):GetComponents()
	local v60 = math.clamp((v51 + v55 + v59 - 1) / 2, -1, 1)

	return (math.acos(v60))
end

local t3: {[any]: any} = { cFrameIdentity, v10, v11, CFrame.Angles(0, 0, 3.141592653589793) }

local function canonicalise(p3, p4)
	local v63 = p3
	local n1 = math.huge

	for _, v in ipairs(t3) do
		local n2 = p3 * v
		local v68, v69, v70, v71, v72, v73, v74, v75, v76, v77, v78, v79 = p4:ToObjectSpace(n2):GetComponents()
		local v80 = math.clamp((v71 + v75 + v79 - 1) / 2, -1, 1)
		local v81 = math.acos(v80)

		if n1 > v81 then
			n1 = v81
			v63 = n2
		end
	end

	return v63
end

local t4: {[any]: any} = {
	Vector3.new(0.5, 0, 0),
	Vector3.new(-0.5, 0, 0),
	Vector3.new(0, 0.5, 0),
	Vector3.new(0, -0.5, 0),
	Vector3.new(0, 0, 0.5),
	Vector3.new(0, 0, -0.5)
}

local function detectHinge(p5, p6)
	local v84 = t4[1]
	local n1 = math.huge

	for _, v in ipairs(t4) do
		local t6: {[any]: any} = {}

		for i, iterValue in ipairs(p5) do
			local cFrame = CFrame.new(v * p6[i])

			t6[i] = (iterValue * cFrame).Position
		end

		local n2 = 0

		for i = 1, #t6 do
			for j = i + 1, #t6 do
				n2 = math.max(n2, (t6[i] - t6[j]).Magnitude)
			end
		end

		if n1 > n2 then
			n1 = n2
			v84 = v
		end
	end

	return v84
end
local function smoothstep(p7)
	return p7 * p7 * (3 - p7 * 2)
end
local function scaleCFrame(p8, p9)
	return CFrame.new(p8.Position * p9) * (p8 - p8.Position)
end
local function wingName(p10, p11)
	return "Wing" .. p10 .. p11
end
local function isWing(p12)
	return p12.Name:match("^Wing") ~= nil
end
local function findRoot(p13)
	local v102 = nil
	local n1 = -1

	for _, v in ipairs(p13:GetDescendants()) do
		if v:IsA("BasePart") and v.Name == "Block" then
			local n2 = v.Size.X * v.Size.Y * v.Size.Z

			if n1 < n2 then
				n1 = n2
				v102 = v
			end
		end
	end

	return v102
end
local function detectForward(p14, p15)
	local vectorValue = Vector3.new(1, 0, 0)
	local n1 = -1

	for _, v in ipairs(p15:GetDescendants()) do
		if v:IsA("BasePart") and v ~= p14 and v.Name:match("^Wing") == nil then
			local v113 = p14.CFrame:PointToObjectSpace(v.Position)

			for _, iterValue in ipairs({
				{ Vector3.new(1, 0, 0), v113.X },
				{ Vector3.new(0, 1, 0), v113.Y },
				{ Vector3.new(0, 0, 1), v113.Z }
			}) do
				local v116 = iterValue[1]
				local v117 = iterValue[2]
				local absoluteValue = math.abs(v117)

				if n1 < absoluteValue then
					n1 = math.abs(v117)
					vectorValue = if v117 >= 0 then v116 else -v116
				end
			end
		end
	end

	n1 = vectorValue:Dot(Vector3.new(0, 0, -1))

	if n1 > 0.999 then
		return CFrame.identity
	end

	if n1 < -0.999 then
		return CFrame.Angles(0, 3.141592653589793, 0)
	end

	local cFrameFromAxisAngle = CFrame.fromAxisAngle
	local unit = vectorValue:Cross(Vector3.new(0, 0, -1)).Unit
	local v121 = math.clamp(n1, -1, 1)
	local v122 = math.acos(v121)

	return cFrameFromAxisAngle(unit, v122)
end
local function findBatRoot(p16)
	local v124 = p16.PrimaryPart or p16:FindFirstChild("Body")

	if v124 and v124:IsA("BasePart") then
		return v124
	end

	return nil
end

local v24 = (function()
	local bat: Instance = seagulls:FindFirstChild("Bat")

	if not bat or not bat:IsA("Model") then
		warn("[SeagullFlock] no Bat model, flying seagulls instead")

		return nil
	end

	local v126 = bat.PrimaryPart or bat:FindFirstChild("Body")
	local v127 = if v126 and v126:IsA("BasePart") then v126 else nil

	if not v127 then
		warn("[SeagullFlock] Bat has no Body part, flying seagulls instead")

		return nil
	end

	v126 = detectForward(v127, bat)

	local v128 = v126:VectorToObjectSpace(Vector3.new(0, 0, -1))
	local v129 = v126:VectorToObjectSpace(Vector3.new(0, 1, 0))

	return { template = bat, forward = v126, axis = v128, up = v129 }
end)()

local v25 = if v24 then nil else (function()
	local foundChild: Instance = seagulls:FindFirstChild(t2[1])

	if not foundChild then
		warn("[SeagullFlock] missing pose model " .. t2[1])

		return nil
	end

	local v131 = findRoot(foundChild)

	if not v131 then
		warn("[SeagullFlock] no torso Block found in " .. foundChild.Name)

		return nil
	end

	local t7: {[any]: any} = {}

	for _, v in ipairs(t1) do
		local t8: {[any]: any} = {}
		local t9: {[any]: any} = {}
		local t10 = {}
		local t11: {[any]: any} = {}

		for i, iterValue in ipairs(t2) do
			local v4: Instance = seagulls:FindFirstChild(iterValue)
			local v142 = if v4 then findRoot(v4) else nil
			local v143 = if v4 then v4:FindFirstChild("Wing" .. v .. 1, true) else nil
			local v144 = if v4 then v4:FindFirstChild("Wing" .. v .. 2, true) else nil

			if not v142 or not v143 or not v143:IsA("BasePart") or not v144 or not v144:IsA("BasePart") then
				warn("[SeagullFlock] pose " .. iterValue .. " missing wing parts for " .. v)

				return nil
			end

			t8[i] = v142.CFrame:ToObjectSpace(v143.CFrame)
			t10[i] = v142.CFrame:ToObjectSpace(v144.CFrame)

			local v145 = v144.Size

			t9[i] = v143.Size
			t11[i] = v145
		end

		for i = 2, #t8 do
			t8[i] = canonicalise(t8[i], t8[1])
		end

		local t12: {[any]: any} = {}

		for i = 1, #t10 do
			t12[i] = t8[i]:ToObjectSpace(t10[i])
		end

		for i = 2, #t12 do
			t12[i] = canonicalise(t12[i], t12[1])
		end

		t10 = detectHinge(t8, t9)

		local v150 = detectHinge(t12, t11)
		local t13: {[any]: any} = {}
		local t14: {[any]: any} = {}

		for i = 1, #t8 do
			local v154 = t8[i]
			local cFrame = CFrame.new(t10 * t9[i])

			t13[i] = { pivot = v154 * cFrame, size = t9[i] }
			v154 = t12[i]

			local cFrame2 = CFrame.new(v150 * t11[i])

			t14[i] = { pivot = v154 * cFrame2, size = t11[i] }
		end

		t7[v] = { innerHinge = t10, outerHinge = v150, inner = t13, outer = t14 }
	end

	local v157 = detectForward(v131, foundChild)

	return { template = foundChild, forward = v157, sides = t7 }
end)()

if not v24 and not v25 then
	return
end

local v26 = if v24 then v24.forward else v25.forward
local t5: {[any]: any} = {}
local u28 = nil
local connection = nil
local n1: number = 0

local function randomPointInArea(p17)
	local n1 = seagullArea.Size / 2
	local vector3 = Vector3.new(p17, p17, p17)
	local n2 = n1 - vector3
	local v162 = math.max(n2.X, 0)
	local v163 = math.max(n2.Y, 0)
	local v164 = math.max(n2.Z, 0)
	local vector32 = Vector3.new(v162, v163, v164)
	local seagullAreaCFrame = seagullArea.CFrame
	local cFrameNew = CFrame.new

	v164 = (math.random() * 2 - 1) * vector32.X

	local n3 = (math.random() * 2 - 1) * vector32.Y
	local randomNumber = math.random()

	v163 = cFrameNew(v164, n3, (randomNumber * 2 - 1) * vector32.Z)

	return (seagullAreaCFrame * v163).Position
end
local function clampToArea(p18)
	local v171 = seagullArea.CFrame:PointToObjectSpace(p18)
	local n1 = seagullArea.Size / 2
	local seagullAreaCFrame = seagullArea.CFrame
	local cFrameNew = CFrame.new
	local v175 = math.clamp(v171.X, -n1.X, n1.X)
	local v176 = math.clamp(v171.Y, -n1.Y, n1.Y)
	local v177 = math.clamp(v171.Z, -n1.Z, n1.Z)
	local cFrame = cFrameNew(v175, v176, v177)

	return (seagullAreaCFrame * cFrame).Position
end
local function spawnBird()
	local clone = (if v24 then v24.template else v25.template):Clone()
	local n1 = if v24 then 0.32 + math.random() * 0.09999999999999998 else 0.7 + math.random() * 0.20000000000000007

	clone:ScaleTo(n1)

	local v181

	if v24 then
		local v182 = clone.PrimaryPart or clone:FindFirstChild("Body")

		v181 = if v182 and v182:IsA("BasePart") then v182 else nil
	else
		v181 = findRoot(clone)
	end

	if not v181 then
		clone:Destroy()

		return nil
	end

	local t15: {[any]: any} = {}
	local t16: {[any]: any} = {}

	for _, v in ipairs(clone:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Anchored = true
			v.CanCollide = false
			v.CanQuery = false
			v.CanTouch = false
			v.CastShadow = false
			v.Massless = true

			if v.Name:match("^Wing") == nil then
				local v187 = v181.CFrame:ToObjectSpace(v.CFrame)

				table.insert(t15, { part = v, offset = v187 })
			end
		end
	end

	for _, v in ipairs(t1) do
		local foundChild = clone:FindFirstChild("Wing" .. v .. 1, true)
		local foundChild2 = clone:FindFirstChild("Wing" .. v .. 2, true)

		if foundChild and foundChild:IsA("BasePart") and foundChild2 and foundChild2:IsA("BasePart") then
			t16[v] = { inner = foundChild, outer = foundChild2 }
		end
	end

	local t17: {[any]: any} = {}

	if v24 then
		local v193 = v24

		for _, v in ipairs(clone:GetDescendants()) do
			if v:IsA("BasePart") and v.Name:match("^Wing") ~= nil then
				local v196 = v181.CFrame:ToObjectSpace(v.CFrame)
				local v197 = v196.Position
				local n2 = math.huge

				for _, iterValue in ipairs(t4) do
					local cFrame = CFrame.new(iterValue * v.Size)
					local v202 = (v196 * cFrame).Position
					local axis = v193.axis
					local v204 = v202:Dot(v193.axis)
					local magnitude = (v202 - axis * v204).Magnitude

					if n2 > magnitude then
						n2 = magnitude
						v197 = v202
					end
				end

				local cFrame3 = CFrame.new(v197)
				local v207 = CFrame.fromAxisAngle(v193.axis, 0.3)
				local cFrame4 = CFrame.new(-v197)
				local v209 = ((cFrame3 * v207 * cFrame4 * v196).Position - v196.Position):Dot(v193.up)

				table.insert(t17, {
					part = v,
					rest = v196,
					hinge = v197,
					sign = if v209 >= 0 then 1 else -1
				})
			end
		end
	end

	local n3 = math.random() * 3.141592653589793 * 2
	local v211 = randomPointInArea(6)
	local cosine = math.cos(n3)
	local sine = math.sin(n3)
	local unit = Vector3.new(cosine, 0, sine).Unit
	local randomNumber = math.random()
	local v216 = randomPointInArea(6)
	local randomNumber2 = math.random()
	local t18: {[any]: any} = {
		flapping = false,
		flapBlend = 0,
		bank = 0,
		model = clone,
		body = t15,
		wings = t16,
		position = v211,
		heading = unit,
		speed = 11 + randomNumber * 6,
		target = v216,
		flapPhase = randomNumber2,
		flapHz = if v24 then 2.4 + math.random() * 0.8000000000000003 else 0.5661 + math.random() * 0.19979999999999998,
		stateUntil = math.random() * 7,
		scale = n1,
		batWings = t17
	}

	clone.Name = if v24 then "Bat" else "Seagull"
	clone.Parent = u28

	return t18
end
local function sampleFlap(p19)
	local n1 = p19 % 1

	if n1 < 0.42 then
		local n2 = n1 / 0.42

		return 3, 1, n2 * n2 * (3 - n2 * 2)
	end

	local n3 = (n1 - 0.42) / 0.5800000000000001

	return 1, 3, n3 * n3 * (3 - n3 * 2)
end
local function applyWings(p20, p21, p22)
	local n1 = p22 % 1
	local n2
	local n3
	local n4

	if n1 < 0.42 then
		n2 = 3
		n3 = 1

		local n5 = n1 / 0.42

		n4 = n5 * n5 * (3 - n5 * 2)
	else
		n2 = 1
		n3 = 3

		local n6 = (n1 - 0.42) / 0.5800000000000001

		n4 = n6 * n6 * (3 - n6 * 2)
	end

	n1 = 1 - p20.flapBlend

	for _, v in ipairs(t1) do
		local v235 = p20.wings[v]
		local v236 = v25.sides[v]

		if v235 and v236 then
			local scale = p20.scale
			local v238 = v236.inner[n2]
			local v239 = v236.inner[n3]
			local v240 = v236.inner[2]
			local n7 = v238.size:Lerp(v239.size, n4):Lerp(v240.size, n1) * scale
			local v242 = v238.pivot:Lerp(v239.pivot, n4):Lerp(v240.pivot, n1)
			local cFrame = CFrame.new(v242.Position * scale)
			local n8 = p21 * (cFrame * (v242 - v242.Position))
			local cFrame5 = CFrame.new(-v236.innerHinge * n7)

			v240 = n8 * cFrame5
			n8 = v236.outer[n2]

			local v246 = v236.outer[n3]
			local v247 = v236.outer[2]

			v239 = n8.size:Lerp(v246.size, n4):Lerp(v247.size, n1) * scale

			local v248 = n8.pivot:Lerp(v246.pivot, n4):Lerp(v247.pivot, n1)
			local cFrame6 = CFrame.new(v248.Position * scale)
			local n9 = v240 * (cFrame6 * (v248 - v248.Position))
			local cFrame7 = CFrame.new(-v236.outerHinge * v239)

			v235.inner.CFrame = v240
			v235.outer.CFrame = n9 * cFrame7

			if (v235.outer.Size - v239).Magnitude > 0.001 then
				v235.outer.Size = v239
			end

			if (v235.inner.Size - n7).Magnitude > 0.001 then
				v235.inner.Size = n7
			end
		end
	end
end
local function batWingAngle(p23)
	local n1 = p23 % 1

	if n1 < 0.42 then
		local n2 = n1 / 0.42

		return n2 * n2 * (3 - n2 * 2) * -1.4835298641951802 + 0.8726646259971648
	end

	local n3 = (n1 - 0.42) / 0.5800000000000001

	return n3 * n3 * (3 - n3 * 2) * 1.4835298641951802 + -0.6108652381980153
end
local function applyBatWings(p24, p25)
	local v258 = v24
	local n1 = p24.flapPhase % 1
	local n2

	if n1 < 0.42 then
		local n3 = n1 / 0.42

		n2 = n3 * n3 * (3 - n3 * 2) * -1.4835298641951802 + 0.8726646259971648
	else
		local n4 = (n1 - 0.42) / 0.5800000000000001

		n2 = n4 * n4 * (3 - n4 * 2) * 1.4835298641951802 + -0.6108652381980153
	end

	for _, v in ipairs(p24.batWings) do
		local vPart = v.part
		local cFrame = CFrame.new(v.hinge)
		local v266 = CFrame.fromAxisAngle(v258.axis, n2 * v.sign)
		local cFrame8 = CFrame.new(-v.hinge)

		vPart.CFrame = p25 * cFrame * v266 * cFrame8 * v.rest
	end
end
local function steer(p26, p27)
	local n1 = p26.target - p26.position

	if n1.Magnitude < 12 then
		p26.target = randomPointInArea(6)
		n1 = p26.target - p26.position
	end

	if n1.Magnitude < 0.0001 then
		return
	end

	local unit = n1.Unit
	local unitX = unit.X
	local v273 = math.clamp(unit.Y, -0.35, 0.35)
	local vector3 = Vector3.new(unitX, v273, unit.Z)
	local heading = p26.heading
	local v276 = math.exp(-(if v24 then 1.8 else 1) * p27)
	local v277 = heading:Lerp(if vector3.Magnitude < 0.0001 then p26.heading else vector3.Unit, 1 - v276)

	v277 = if v277.Magnitude < 0.0001 then p26.heading else v277.Unit

	local vector33 = Vector3.new(p26.heading.X, 0, p26.heading.Z)
	local vector34 = Vector3.new(v277.X, 0, v277.Z)
	local n2 = 0

	if vector33.Magnitude > 0.0001 and vector34.Magnitude > 0.0001 then
		local y = vector33.Unit:Cross(vector34.Unit).Y
		local v282 = math.max(p27, 0.001)

		n2 = math.clamp(y / v282 * 0.35, -1, 1) * 0.6108652381980153
	end

	local bank = p26.bank

	v276 = n2 - p26.bank

	local v284 = math.clamp(p27 * 3.5, 0, 1)

	p26.bank = bank + v276 * v284
	p26.heading = v277
	p26.position = clampToArea(p26.position + v277 * p26.speed * p27)
end
local function updateFlapState(p28, p29)
	if n1 >= p28.stateUntil then
		if p28.flapping then
			p28.flapping = false

			local n4: number = n1 + 3
			local randomNumber = math.random()

			p28.stateUntil = n4 + randomNumber * 4
		else
			p28.flapping = true
			p28.flapPhase = 0

			local n2: number = n1 + 0.8
			local randomNumber = math.random()

			p28.stateUntil = n2 + randomNumber * 1.0999999999999999
		end
	end

	local flapBlend = p28.flapBlend
	local n3 = (if not p28.flapping and not (p28.heading.Y > 0.12) then 0 else 1) - p28.flapBlend
	local v293 = math.clamp(p29 * 6, 0, 1)

	p28.flapBlend = flapBlend + n3 * v293

	if p28.flapBlend > 0.001 then
		p28.flapPhase = (p28.flapPhase + p29 * p28.flapHz) % 1
	end
end
local function updateBird(p30, p31)
	steer(p30, p31)

	local vectorValue = Vector3.new(0, 0, 0)

	if v24 then
		p30.flapPhase = (p30.flapPhase + p31 * p30.flapHz) % 1

		local sine = math.sin(p30.flapPhase * 3.141592653589793 * 2)

		vectorValue = Vector3.new(0, sine * 0.4, 0)
	else
		updateFlapState(p30, p31)
	end

	local v298 = CFrame.lookAt(p30.position, p30.position + p30.heading)
	local v299 = CFrame.Angles(0, 0, p30.bank)
	local n1 = v298 * v299 * v26 + vectorValue

	for _, v in ipairs(p30.body) do
		v.part.CFrame = n1 * v.offset
	end

	if v24 then
		applyBatWings(p30, n1)

		return
	end

	applyWings(p30, n1, p30.flapPhase)
end
local function despawn()
	if connection then
		connection:Disconnect()
		connection = nil
	end

	table.clear(t5)

	if u28 then
		u28:Destroy()
		u28 = nil
	end
end
local function spawnFlock()
	if u28 then
		return
	end

	local seagullFlock: Folder = Instance.new("Folder")

	seagullFlock.Name = "SeagullFlock"
	seagullFlock.Parent = workspace.Bin
	u28 = seagullFlock

	local v304 = spawnBird()

	if v304 then
		table.insert(t5, v304)
	end

	local v305 = spawnBird()

	if v305 then
		table.insert(t5, v305)
	end

	v305 = spawnBird()

	if v305 then
		table.insert(t5, v305)
	end

	v305 = spawnBird()

	if v305 then
		table.insert(t5, v305)
	end

	connection = runService.Heartbeat:Connect(function(deltaTime: number)
		n1 += deltaTime

		local v307 = math.min(deltaTime, 0.1)

		for _, v in ipairs(t5) do
			updateBird(v, v307)
		end
	end)
end
local function isInMatch()
	return LocalPlayer:GetAttribute("InMatch") == true
end
local function isLobbySpectating()
	return LocalPlayer:GetAttribute("LobbySpectateMatchId") ~= nil
end
local function apply()
	if LocalPlayer:GetAttribute("InMatch") ~= true and LocalPlayer:GetAttribute("LobbySpectateMatchId") == nil then
		spawnFlock()
	else
		if connection then
			connection:Disconnect()
			connection = nil
		end

		table.clear(t5)

		if u28 then
			u28:Destroy()
			u28 = nil

			return
		end
	end
end

LocalPlayer:GetAttributeChangedSignal("InMatch"):Connect(apply)
LocalPlayer:GetAttributeChangedSignal("LobbySpectateMatchId"):Connect(apply)

if LocalPlayer:GetAttribute("InMatch") ~= true and LocalPlayer:GetAttribute("LobbySpectateMatchId") == nil then
	spawnFlock()
else
	if connection then
		connection:Disconnect()
		connection = nil
	end

	table.clear(t5)

	if u28 then
		u28:Destroy()
		u28 = nil
	end
end
