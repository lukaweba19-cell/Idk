-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local runService: RunService = game:GetService("RunService")
local t1: {[any]: any} = { 30, 60, 90, 120, 150 }
local v4 = (Vector3.new(-1, 0, 0)):Cross(Vector3.new(0, 1, 0))
local v5 = (Vector3.new(-1, 0, 0)):Dot(Vector3.new(0, 0, -1))
local v6

if v5 > 0.999 then
	v6 = CFrame.identity
elseif v5 < -0.999 then
	v6 = CFrame.Angles(0, 3.141592653589793, 0)
else
	local cFrameFromAxisAngle = CFrame.fromAxisAngle
	local unit = (Vector3.new(-1, 0, 0)):Cross(Vector3.new(0, 0, -1)).Unit
	local v9 = math.acos(v5)

	v6 = cFrameFromAxisAngle(unit, v9)
end

v5 = function(p1, p2)
	local randomNumber = math.random()

	return p1 + randomNumber * (p2 - p1)
end

local function rotateY(p3, p4)
	return CFrame.Angles(0, p4, 0):VectorToWorldSpace(p3)
end

local t2: {[any]: any} = {}
local t3: {[any]: any} = {}
local t4: {[any]: any} = {}
local t5: {[any]: any} = {}
local v15 = OverlapParams.new()

v15.FilterType = Enum.RaycastFilterType.Exclude

local function refreshFilter(p5)
	local filterDescendantsInstances: {[any]: any} = { p5.area }

	for key, value2 in t2 do
		table.insert(filterDescendantsInstances, value2.model)
	end

	for iterFirst, value in { "Characters", "Bin" }, nil, nil do
		local value: Instance = workspace:FindFirstChild(value)

		if value then
			table.insert(filterDescendantsInstances, value)
		end
	end

	for iterFirst2, iterSecond in players:GetPlayers() do
		if iterSecond.Character then
			table.insert(filterDescendantsInstances, iterSecond.Character)
		end
	end

	v15.FilterDescendantsInstances = filterDescendantsInstances

	for iterFirst3, iterSecond2 in workspace:GetPartBoundsInBox(p5.area.CFrame, p5.area.Size + Vector3.new(16, 60, 16), v15) do
		if iterSecond2.CanCollide and iterSecond2.Transparency >= 0.95 then
			table.insert(filterDescendantsInstances, iterSecond2)
		end
	end

	p5.params.FilterDescendantsInstances = filterDescendantsInstances
end
local function zoneFor(p6)
	local t9 = t3[p6]

	if not t9 then
		local raycastParams = RaycastParams.new()

		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams.RespectCanCollide = true

		local t10: {[any]: any} = { floorY = nil, area = p6, params = raycastParams }

		t3[p6] = t10
		t9 = t10
	end

	return t9
end
local function standsIn(p7, p8)
	local v64 = p7.CFrame:PointToObjectSpace(p8)
	local n1 = p7.Size / 2
	local u66: boolean = false

	if math.abs(v64.X) <= n1.X + 2 then
		u66 = false

		if math.abs(v64.Z) <= n1.Z + 2 then
			u66 = math.abs(v64.Y) <= n1.Y + 15
		end
	end

	return u66
end
local function findArea(p9)
	local v68 = p9:GetPivot().Position

	for iterValue in t4 do
		if iterValue:IsDescendantOf(workspace) and standsIn(iterValue, v68) then
			return iterValue
		end
	end

	v68 = p9.Parent

	while v68 and v68 ~= workspace and v68 ~= game do
		local spiderArea = v68:FindFirstChild("SpiderArea")

		if spiderArea and spiderArea:IsA("BasePart") then
			return spiderArea
		end

		v68 = v68.Parent
	end

	return nil
end
local function groundAt(p10, p11, p12)
	local vector3 = Vector3.new(p11.X, p12, p11.Z)

	return workspace:Raycast(vector3, Vector3.new(0, -16, 0), p10.params)
end
local function insideArea(p13, p14, p15)
	local v78 = p13.area.CFrame:PointToObjectSpace(p14)
	local n1 = p13.area.Size / 2
	local u80: boolean = false

	if math.abs(v78.X) <= n1.X - p15 then
		u80 = math.abs(v78.Z) <= n1.Z - p15
	end

	return u80
end
local function areaFrac(p16, p17)
	local v83 = p16.area.CFrame:PointToObjectSpace(p17)
	local n1 = p16.area.Size / 2
	local n2 = math.abs(v83.X) / n1.X
	local absoluteValue = math.abs(v83.Z)

	return (math.max(n2, absoluteValue / n1.Z))
end
local function walkable(p18, p19, p20, p21, p22, p23)
	local vector3 = Vector3.new(p19.X, p20 + 0.8, p19.Z)
	local v94 = workspace:Raycast(vector3, p22 * (p23 + 3), p18.params)

	if v94 and v94.Normal.Y < 0.6 then
		return false, p19, p20, p21
	end

	local v95 = p19
	local v96 = p20
	local v97 = p21

	v94 = p23

	while v94 > 0.0001 do
		local v98 = math.min(0.4, v94)
		local n1 = v95 + p22 * v98
		local vector32 = Vector3.new(n1.X, v96 + 2.2, n1.Z)
		local v101 = workspace:Raycast(vector32, Vector3.new(0, -16, 0), p18.params)

		if not v101 or v101.Normal.Y < 0.6 or v101.Position.Y - v96 > 0.6 or v96 - v101.Position.Y > 3 then
			return false, v95, v96, v97
		end

		local v102 = p18.area.CFrame:PointToObjectSpace(n1)
		local n2 = p18.area.Size / 2
		local u104: boolean = false

		if math.abs(v102.X) <= n2.X - 1 then
			u104 = math.abs(v102.Z) <= n2.Z - 1
		end

		if not u104 then
			local v105 = p18.area.CFrame:PointToObjectSpace(n1)
			local n3 = p18.area.Size / 2
			local n4 = math.abs(v105.X) / n3.X
			local absoluteValue = math.abs(v105.Z)
			local v109 = math.max(n4, absoluteValue / n3.Z)
			local v110 = p18.area.CFrame:PointToObjectSpace(v95)

			n4 = p18.area.Size / 2

			if v109 >= math.max(math.abs(v110.X) / n4.X, math.abs(v110.Z) / n4.Z) then
				return false, v95, v96, v97
			end
		end

		v95 = n1
		v96 = v101.Position.Y
		v97 = v101.Normal
		v94 -= v98
	end

	return true, v95, v96, v97
end
local function pickTarget(p24, p25)
	local zone = p24.zone
	local v114 = zone.floorY or p24.ground
	local n1 = zone.area.Size / 2 - Vector3.new(4, 0, 4)
	local vector3 = Vector3.new(p24.pos.X, 0, p24.pos.Z)
	local v117 = nil

	for i = 1, 16 do
		local v119 = zone.area.CFrame
		local cFrameNew = CFrame.new
		local n2 = -n1.X
		local x = n1.X
		local randomNumber = math.random()
		local n3 = -n1.Z
		local z = n1.Z
		local randomNumber2 = math.random()
		local cFrame = cFrameNew(n2 + randomNumber * (x - n2), 0, n3 + randomNumber2 * (z - n3))
		local v128 = (v119 * cFrame).Position
		local vector33 = Vector3.new(v128.X, v114 + 8, v128.Z)
		local v130 = workspace:Raycast(vector33, Vector3.new(0, -20, 0), zone.params)

		if v130 and v130.Normal.Y >= 0.6 and v130.Position.Y <= v114 + 5 then
			local vector34 = Vector3.new(v130.Position.X, 0, v130.Position.Z)
			local n4 = vector34 - vector3

			if not (n4.Magnitude > 3) then
				continue
			end

			local unit = n4.Unit
			local u134: boolean = true

			if p25 ~= nil then
				u134 = true

				if not (i > 10) then
					u134 = unit:Dot(p25) > 0.35
				end
			end

			if u134 and walkable(zone, p24.pos, p24.ground, p24.groundUp, unit, (math.min(6, n4.Magnitude))) then
				return vector34
			end

			v117 = v117 or vector34
		end
	end

	return v117 or vector3
end
local function makeLeg(p26, p27)
	local v137 = p26.pivot0:ToObjectSpace(p27.CFrame)
	local v138 = v137.Position
	local hipOffset = p27:GetAttribute("HipOffset")
	local v140 = if typeof(hipOffset) == "Vector3" then p26.pivot0:PointToObjectSpace(p27.CFrame * hipOffset) else Vector3.new(v138.X * 0.55, v138.Y + 0.45, v138.Z * 0.42)
	local vector3 = Vector3.new(v138.X - v140.X, 0, v138.Z - v140.Z)

	v138 = if vector3.Magnitude > 0.001 then vector3.Unit else v4

	local v142 = (Vector3.new(0, 1, 0)):Cross(v138):Dot(Vector3.new(-1, 0, 0))
	local v143 = math.max(vector3.Magnitude * 1.9, 1)
	local v144 = v138:Cross(Vector3.new(0, 1, 0))
	local t11: {[any]: any} = {
		phase = 0,
		part = p27,
		offset = v137,
		hip = v140,
		liftAxis = v144,
		swingSign = if v142 >= 0 then 1 else -1
	}
	local absoluteValue = math.abs(v142)
	local v147 = math.max(absoluteValue, 0.3)

	t11.swingAmp = math.clamp(1.3 / (v143 * 2 * v147), 0.15, 0.38)
	t11.side = if v138:Dot(v4) >= 0 then 1 else -1
	t11.along = v140:Dot(Vector3.new(-1, 0, 0))

	return t11
end
local function assignGait(p28)
	p28.legsDirty = false

	for iterFirst, value in { -1, 1 }, nil, nil do
		local t12: {[any]: any} = {}

		for iterFirst2, iterSecond in p28.legs, nil, nil do
			if value == iterSecond.side then
				table.insert(t12, iterSecond)
			end
		end

		table.sort(t12, function(p29, p30)
			return p29.along > p30.along
		end)

		for key, value2 in t12 do
			value2.phase = (if key % 2 == 1 == (value == -1) then 0 else 0.5) + (key - 2.5) * 0.03
		end
	end
end
local function track(p31, p32)
	if p32:IsA("BasePart") and not p31.offsets[p32] and not p31.legs[p32] then
		p32.CanCollide = false
		p32.CanQuery = false
		p32.CanTouch = false

		if p32.Name == "Leg" then
			p31.legs[p32] = makeLeg(p31, p32)
			p31.legsDirty = true

			return
		end

		p31.offsets[p32] = p31.pivot0:ToObjectSpace(p32.CFrame)

		return
	end
end
local function unbind(p33)
	local v159 = table.find(t2, p33)

	if v159 then
		table.remove(t2, v159)
	end

	for iterFirst, iterSecond in p33.conns, nil, nil do
		iterSecond:Disconnect()
	end

	table.clear(p33.conns)
end
local function bind(p34, p35)
	for key, value in t2 do
		if p34 == value.model then
			return
		end
	end

	local v166 = zoneFor(p35)
	local pivot = p34:GetPivot()
	local v168 = pivot:VectorToWorldSpace(Vector3.new(-1, 0, 0))

	v168 = Vector3.new(v168.X, 0, v168.Z)
	v168 = if v168.Magnitude > 0.001 then v168.Unit else Vector3.new(0, 0, -1)

	local v169 = os.clock()
	local pivotPosition = pivot.Position
	local v171 = pivot.Position
	local n1 = pivot.Position.Y - 1.6
	local randomNumber = math.random()
	local randomNumber3 = math.random()
	local vector3 = Vector3.new(pivot.Position.X, 0, pivot.Position.Z)
	local randomNumber4 = math.random()
	local randomNumber5 = math.random()
	local vector35 = Vector3.new(pivot.Position.X, 0, pivot.Position.Z)
	local t13: {[any]: any} = {
		legsDirty = false,
		up = Vector3.new(0, 1, 0),
		groundUp = Vector3.new(0, 1, 0),
		hover = 1.6,
		walking = false,
		twitch = nil,
		amp = 0,
		tapLeg = nil,
		tapStart = 0,
		escapes = 0,
		detour = nil,
		detourUntil = 0,
		model = p34,
		zone = v166,
		pivot0 = pivot,
		offsets = {},
		legs = {},
		conns = {},
		home = pivotPosition,
		pos = v171,
		heading = v168,
		ground = n1,
		speed = 7 + randomNumber * 5,
		stateUntil = v169 + (0 + randomNumber3 * 2.2),
		target = vector3,
		gait = randomNumber4,
		nextTap = v169 + (0.5 + randomNumber5 * 1.3),
		windowPos = vector35,
		windowAt = v169
	}

	table.insert(t2, t13)
	refreshFilter(v166)
	n1 = pivot.Position

	local vector36 = Vector3.new(n1.X, pivot.Position.Y + 1, n1.Z)

	v169 = workspace:Raycast(vector36, Vector3.new(0, -16, 0), v166.params)

	if v169 then
		t13.ground = v169.Position.Y
		t13.hover = math.clamp(pivot.Position.Y - v169.Position.Y, 0.8, 3)
		t13.groundUp = v169.Normal
		t13.up = v169.Normal
		v166.floorY = if v166.floorY then math.min(v166.floorY, v169.Position.Y) else v169.Position.Y
	end

	for iterFirst, iterSecond in p34:GetDescendants() do
		track(t13, iterSecond)
	end

	table.insert(t13.conns, p34.DescendantAdded:Connect(function(p36)
		track(t13, p36)
	end))
	table.insert(t13.conns, p34.DescendantRemoving:Connect(function(p37)
		if p37:IsA("BasePart") then
			t13.offsets[p37] = nil

			if t13.legs[p37] then
				if t13.tapLeg == t13.legs[p37] then
					t13.tapLeg = nil
				end

				t13.legs[p37] = nil
				t13.legsDirty = true
			end
		end
	end))
	table.insert(t13.conns, p34.AncestryChanged:Connect(function()
		if not p34:IsDescendantOf(workspace) then
			unbind(t13)
		end
	end))
	t13.target = pickTarget(t13)
end
local function scan()
	for i = #t2, 1, -1 do
		local v184 = t2[i]

		if not v184.model:IsDescendantOf(workspace) or not v184.zone.area:IsDescendantOf(workspace) then
			unbind(v184)
		end
	end

	for iterValue in t4 do
		if not iterValue:IsDescendantOf(workspace) then
			t4[iterValue] = nil
		end
	end

	for iterValue2 in t3 do
		if not iterValue2:IsDescendantOf(workspace) then
			t3[iterValue2] = nil
		end
	end

	for iterValue3 in t5 do
		if not iterValue3:IsDescendantOf(workspace) then
			t5[iterValue3] = nil
		else
			local v188 = findArea(iterValue3)

			if v188 then
				t5[iterValue3] = nil
				bind(iterValue3, v188)
			end
		end
	end

	local t14: {[any]: any} = {}

	for key, value in t2 do
		t14[value.zone] = true
	end

	for iterValue4 in t14 do
		refreshFilter(iterValue4)
	end
end
local function startPause(p39, p40, p41, p42)
	p39.walking = false

	local v197 = p41 or 0.3
	local randomNumber = math.random()

	p39.stateUntil = p40 + (v197 + randomNumber * ((p42 or 2.2) - v197))

	local v199

	if math.random() < 0.5 then
		local heading = p39.heading
		local randomNumber6 = math.random()

		v199 = CFrame.Angles(0, -0.7 + randomNumber6 * 1.4, 0):VectorToWorldSpace(heading)
	else
		v199 = nil
	end

	p39.twitch = v199
end
local function deflect(p43)
	local target = p43.target
	local vector3 = Vector3.new(p43.pos.X, 0, p43.pos.Z)
	local n1 = target - vector3
	local n2: number = if n1.Magnitude > 0.001 and p43.heading:Cross(n1).Y > 0 then 1 else -1

	for key, value2 in t1 do
		for iterFirst, value in { n2, -n2 }, nil, nil do
			local heading = p43.heading
			local v212 = math.rad(value2)
			local v213 = CFrame.Angles(0, v212 * value, 0):VectorToWorldSpace(heading)

			if walkable(p43.zone, p43.pos, p43.ground, p43.groundUp, v213, 2) then
				return v213
			end
		end
	end

	return nil
end
local function escape(p44, p45)
	local v216 = nil
	local n1 = 0
	local randomNumber = math.random()

	for i = 0, 15 do
		local n2 = randomNumber * 3.141592653589793 * 2 + i / 16 * 3.141592653589793 * 2
		local cosine = math.cos(n2)
		local sine = math.sin(n2)
		local vector3 = Vector3.new(cosine, 0, sine)
		local v224, v225 = walkable(p44.zone, p44.pos, p44.ground, p44.groundUp, vector3, 5)
		local magnitude = Vector3.new(v225.X - p44.pos.X, 0, v225.Z - p44.pos.Z).Magnitude

		if magnitude > n1 + 0.01 then
			n1 = magnitude
			v216 = vector3
		end
	end

	if v216 and not (n1 < 1.5) then
		local v227 = v216

		p44.heading = v227
		p44.detour = v227
		p44.detourUntil = p45 + 1
		p44.walking = true
		p44.twitch = nil
		p44.speed = 12
		p44.stateUntil = p45 + 1
		p44.target = pickTarget(p44, v227)

		return true
	end

	return false
end
local function resetHome(p46, p47)
	local zone = p46.zone
	local home = p46.home
	local vector3 = Vector3.new(home.X, p46.home.Y + 1, home.Z)
	local v233 = workspace:Raycast(vector3, Vector3.new(0, -16, 0), zone.params)

	if v233 then
		p46.ground = v233.Position.Y
		p46.groundUp = v233.Normal
		p46.pos = Vector3.new(p46.home.X, v233.Position.Y + p46.hover, p46.home.Z)
	else
		p46.pos = p46.home
	end

	p46.escapes = 0
	p46.detour = nil
	p46.target = pickTarget(p46)
	p46.walking = false

	local randomNumber = math.random()

	p46.stateUntil = p47 + (0.3 + randomNumber * 1.9000000000000001)

	local v235

	if math.random() < 0.5 then
		local heading = p46.heading
		local randomNumber7 = math.random()

		v235 = CFrame.Angles(0, -0.7 + randomNumber7 * 1.4, 0):VectorToWorldSpace(heading)
	else
		v235 = nil
	end

	p46.twitch = v235
end
local function update(p48, p49, p50)
	if p48.legsDirty then
		assignGait(p48)
	end

	if p50 >= p48.stateUntil then
		if p48.walking then
			p48.walking = false

			local randomNumber = math.random()

			p48.stateUntil = p50 + (0.3 + randomNumber * 1.9000000000000001)

			local v242

			if math.random() < 0.5 then
				local heading = p48.heading
				local randomNumber8 = math.random()

				v242 = CFrame.Angles(0, -0.7 + randomNumber8 * 1.4, 0):VectorToWorldSpace(heading)
			else
				v242 = nil
			end

			p48.twitch = v242
		else
			p48.walking = true
			p48.twitch = nil
			p48.speed = 7 + math.random() * 5

			local randomNumber = math.random()

			p48.stateUntil = p50 + (0.5 + randomNumber * 1.3)
		end
	end

	local vector3 = Vector3.new(p48.pos.X, 0, p48.pos.Z)
	local n1 = p48.target - vector3

	if n1.Magnitude < 3 then
		p48.target = pickTarget(p48)
		n1 = p48.target - vector3

		if p48.walking then
			p48.walking = false

			local randomNumber = math.random()

			p48.stateUntil = p50 + (0.3 + randomNumber * 1.9000000000000001)

			local v249

			if math.random() < 0.5 then
				local v250 = p48.heading
				local randomNumber9 = math.random()

				v249 = CFrame.Angles(0, -0.7 + randomNumber9 * 1.4, 0):VectorToWorldSpace(v250)
			else
				v249 = nil
			end

			p48.twitch = v249
		end
	end

	local pos = p48.pos
	local v253 = p48.heading
	local v254 = if p48.detour and p50 < p48.detourUntil then p48.detour else nil

	if not v254 then
		p48.detour = nil
	end

	local v255 = p48.heading
	local v256 = math.exp(-(if not p48.walking then 15 else if v254 then 12 else 6) * p49)
	local v257 = v255:Lerp(if not p48.walking then p48.twitch or p48.heading else if v254 then v254 else if n1.Magnitude > 0.001 then n1.Unit else p48.heading, 1 - v256)

	v257 = Vector3.new(v257.X, 0, v257.Z)

	if v257.Magnitude > 0.0001 then
		p48.heading = v257.Unit
	end

	if p48.walking then
		local v258, v259, v260, v261 = walkable(p48.zone, p48.pos, p48.ground, p48.groundUp, v254 or p48.heading, p48.speed * p49)

		if v259 ~= p48.pos then
			p48.pos = Vector3.new(v259.X, p48.pos.Y, v259.Z)
			p48.ground = v260
			p48.groundUp = v261
		end

		if not v258 then
			local v262 = if v254 then nil else deflect(p48)

			if v262 then
				p48.detour = v262
				p48.detourUntil = p50 + 0.5
			else
				p48.detour = nil
				p48.target = pickTarget(p48)
				p48.walking = false

				local randomNumber = math.random()

				p48.stateUntil = p50 + (0.15 + randomNumber * 0.35)
				p48.twitch = if math.random() < 0.5 then CFrame.Angles(0, -0.7 + math.random() * 1.4, 0):VectorToWorldSpace(p48.heading) else nil

				local target = p48.target
				local vector37 = Vector3.new(p48.pos.X, 0, p48.pos.Z)
				local n2 = target - vector37

				p48.twitch = if n2.Magnitude > 0.001 then n2.Unit else -p48.heading
			end
		end
	end

	local x = p48.pos.X
	local y = p48.pos.Y
	local n3 = p48.ground + p48.hover - p48.pos.Y
	local v270 = math.min(1, p49 * 12)

	p48.pos = Vector3.new(x, y + n3 * v270, p48.pos.Z)

	local up = p48.up
	local groundUp = p48.groundUp

	v256 = math.min(1, p49 * 8)

	local v273 = up:Lerp(groundUp, v256)

	p48.up = if v273.Magnitude > 0.0001 then v273.Unit else Vector3.new(0, 1, 0)

	local vector38 = Vector3.new(p48.pos.X - pos.X, 0, p48.pos.Z - pos.Z)

	v273 = math.min(vector38.Magnitude, p49 * 12 * 1.5)

	local v275 = v253:Dot(p48.heading)
	local v276 = math.clamp(v275, -1, 1)
	local v277 = math.acos(v276)

	p48.gait = p48.gait + (v273 / 2.6 + v277 * 0.9)

	local u278: boolean = true

	if not (v273 > p49 * 0.3) then
		u278 = v277 > p49 * 0.4
	end

	local amp = p48.amp

	v275 = (if u278 then 1 else 0) - p48.amp
	v256 = math.min(1, p49 * 14)
	p48.amp = amp + v275 * v256

	if p48.walking then
		p48.tapLeg = nil
	elseif p50 >= p48.nextTap then
		local randomNumber = math.random()

		p48.nextTap = p50 + (0.5 + randomNumber * 1.3)

		local t15: {[any]: any} = {}

		for iterFirst, iterSecond in p48.legs, nil, nil do
			table.insert(t15, iterSecond)
		end

		if #t15 > 0 then
			table.sort(t15, function(p51, p52)
				return p51.along > p52.along
			end)

			local v284

			if math.random() < 0.6 then
				local mathRandom = math.random
				local v286 = math.min(2, #t15)
				local v287 = mathRandom(1, v286)

				v284 = t15[v287]
			else
				local randomNumber10 = math.random(1, #t15)

				v284 = t15[randomNumber10]
			end

			p48.tapLeg = v284
			p48.tapStart = p50
		end
	end

	if p50 - p48.windowAt >= 7 then
		if (Vector3.new(p48.pos.X, 0, p48.pos.Z) - p48.windowPos).Magnitude < 4 then
			p48.escapes = p48.escapes + 1

			if p48.escapes > 2 or not escape(p48, p50) then
				resetHome(p48, p50)
			end
		else
			p48.escapes = 0
		end

		p48.windowAt = p50
		p48.windowPos = Vector3.new(p48.pos.X, 0, p48.pos.Z)
	end
end
local function legPose(p53, p54, p55)
	local n1 = 0
	local n2 = 0

	if p53.amp > 0.001 then
		local n3 = (p53.gait + p54.phase) % 1
		local n4

		if n3 < 0.5 then
			n4 = 1 - n3 * 4
		else
			local n5 = (n3 - 0.5) * 2

			n4 = n5 * n5 * (3 - n5 * 2) * 2 + -1
			n2 = math.sin(3.141592653589793 * n5)
		end

		n1 = n4 * p53.amp
		n2 *= p53.amp
	end

	local n6 = n2 * 0.32

	if p54 == p53.tapLeg then
		local n7 = (p55 - p53.tapStart) / 0.22

		if n7 < 1 then
			local sine = math.sin(3.141592653589793 * n7)

			n6 += sine * 0.45
		else
			p53.tapLeg = nil
		end
	end

	if n1 == 0 and n6 == 0 then
		return p54.offset
	end

	local v300 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), n1 * p54.swingAmp * p54.swingSign)
	local v301 = CFrame.fromAxisAngle(p54.liftAxis, n6)
	local cFrame = CFrame.new(p54.hip)
	local cFrame2 = CFrame.new(-p54.hip)

	return cFrame * (v300 * v301) * cFrame2 * p54.offset
end
local function place(p56, p57, p58, p59)
	local heading = p56.heading
	local up = p56.up
	local v310 = p56.heading:Dot(p56.up)
	local n1 = heading - up * v310
	local v312 = CFrame.lookAt(p56.pos, p56.pos + (if n1.Magnitude > 0.0001 then n1.Unit else p56.heading), p56.up)

	n1 = v312 * v6

	local n2 = math.sin(p56.gait * 3.141592653589793 * 4) * 0.07 * p56.amp
	local sine = math.sin(p56.gait * 3.141592653589793 * 2)
	local n3 = v312 + p56.up * n2
	local v316 = CFrame.Angles(0, 0, sine * 0.035 * p56.amp)

	v310 = n3 * v316 * v6

	for iterFirst, iterSecond in p56.offsets, nil, nil do
		if iterFirst.Parent then
			table.insert(p58, iterFirst)
			table.insert(p59, v310 * iterSecond)
		end
	end

	for iterFirst2, iterSecond2 in p56.legs, nil, nil do
		if iterFirst2.Parent then
			table.insert(p58, iterFirst2)

			local v321 = legPose(p56, iterSecond2, p57)

			table.insert(p59, n1 * v321)
		end
	end
end

for iterFirst, iterSecond in workspace:GetDescendants() do
	if iterSecond.Name == "MoveSpider" and iterSecond:IsA("Model") then
		t5[iterSecond] = true
	elseif iterSecond.Name == "SpiderArea" and iterSecond:IsA("BasePart") then
		t4[iterSecond] = true
	end
end

workspace.DescendantAdded:Connect(function(descendant: Instance)
	if descendant.Name == "MoveSpider" and descendant:IsA("Model") then
		t5[descendant] = true

		return
	end

	if descendant.Name == "SpiderArea" and descendant:IsA("BasePart") then
		t4[descendant] = true
	end
end)
task.spawn(function()
	while true do
		scan()
		task.wait(2)
	end
end)

local t6: {[any]: any} = {}
local t7: {[any]: any} = {}

runService.Heartbeat:Connect(function(deltaTime: number)
	if #t2 == 0 then
		return
	end

	local v324 = math.min(deltaTime, 0.1)
	local v325 = os.clock()
	local CurrentCamera: Camera = workspace.CurrentCamera
	local v327 = if CurrentCamera then CurrentCamera.CFrame.Position else Vector3.new(0, 0, 0)

	table.clear(t6)
	table.clear(t7)

	for key, value in t2 do
		if (next(value.offsets) ~= nil or next(value.legs) ~= nil) and (value.pos - v327).Magnitude <= 300 then
			update(value, v324, v325)
			place(value, v325, t6, t7)
		end
	end

	if #t6 > 0 then
		workspace:BulkMoveTo(t6, t7, Enum.BulkMoveMode.FireCFrameChanged)
	end
end)
