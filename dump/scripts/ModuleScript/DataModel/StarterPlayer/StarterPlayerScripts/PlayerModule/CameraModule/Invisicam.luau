-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local commonUtils: Instance = script.Parent.Parent:WaitForChild("CommonUtils")
local v3 = require(commonUtils:WaitForChild("FlagUtil")).getUserFlag("UserRaycastUpdateAPI2")
local t1: {[any]: any} = {
	LIMBS = 2,
	MOVEMENT = 3,
	CORNERS = 4,
	CIRCLE1 = 5,
	CIRCLE2 = 6,
	LIMBMOVE = 7,
	SMART_CIRCLE = 8,
	CHAR_OUTLINE = 9
}
local t2: {[any]: any} = {
	Vector3.new(1, 1, -1),
	Vector3.new(1, -1, -1),
	Vector3.new(-1, -1, -1),
	Vector3.new(-1, 1, -1)
}
local raycastParams = RaycastParams.new()

raycastParams.FilterType = Enum.RaycastFilterType.Exclude

local raycastParams2 = RaycastParams.new()

raycastParams2.FilterType = Enum.RaycastFilterType.Include

local function AssertTypes(p1, ...)
	local t4: {[any]: any} = {}
	local s1: string = ""

	for _, v in pairs({ ... }) do
		t4[v] = true
		s1 = s1 .. (if s1 == "" then "" else " or ") .. v
	end

	local typeName: string = type(p1)

	assert(t4[typeName], s1 .. " type expected, got: " .. typeName)
end
local function Det3x3(p2, p3, p4, p5, p6, p7, p8, p9, p10)
	return p2 * (p6 * p10 - p7 * p9) - p3 * (p5 * p10 - p7 * p8) + p4 * (p5 * p9 - p6 * p8)
end
local function RayIntersection(p11, p12, p13, p14)
	local v33 = p12:Cross(p14)
	local n1 = p13.X - p11.X
	local n2 = p13.Y - p11.Y
	local n3 = p13.Z - p11.Z
	local y = p12.Y
	local n4 = -p14.Y
	local v39 = v33.Y
	local z = p12.Z
	local n5 = -p14.Z
	local v42 = v33.Z
	local n6 = p12.X * (n4 * v42 - v39 * n5) - -p14.X * (y * v42 - v39 * z) + v33.X * (y * n5 - n4 * z)

	if n6 == 0 then
		return Vector3.new(0, 0, 0)
	end

	n4 = -p14.Y

	local v44 = v33.Y
	local n7 = -p14.Z
	local v46 = v33.Z
	local v47 = p12.Y
	local v48 = v33.Y
	local v49 = p12.Z
	local v50 = v33.Z
	local n8 = p11 + (n1 * (n4 * v46 - v44 * n7) - -p14.X * (n2 * v46 - v44 * n3) + v33.X * (n2 * n7 - n4 * n3)) / n6 * p12
	local n9 = p13 + (p12.X * (n2 * v50 - v48 * n3) - n1 * (v47 * v50 - v48 * v49) + v33.X * (v47 * n3 - n2 * v49)) / n6 * p14

	if (n9 - n8).Magnitude < 0.25 then
		return n8 + (n9 - n8) * 0.5
	end

	return Vector3.new(0, 0, 0)
end

local baseOcclusion = require(script.Parent:WaitForChild("BaseOcclusion"))
local object = setmetatable({}, baseOcclusion)

object.__index = object

function object.new()
	local v53 = baseOcclusion.new()
	local object2 = setmetatable(v53, object)

	object2.char = nil
	object2.humanoidRootPart = nil
	object2.torsoPart = nil
	object2.headPart = nil
	object2.childAddedConn = nil
	object2.childRemovedConn = nil
	object2.behaviors = {}
	object2.behaviors[t1.LIMBS] = object2.LimbBehavior
	object2.behaviors[t1.MOVEMENT] = object2.MoveBehavior
	object2.behaviors[t1.CORNERS] = object2.CornerBehavior
	object2.behaviors[t1.CIRCLE1] = object2.CircleBehavior
	object2.behaviors[t1.CIRCLE2] = object2.CircleBehavior
	object2.behaviors[t1.LIMBMOVE] = object2.LimbMoveBehavior
	object2.behaviors[t1.SMART_CIRCLE] = object2.SmartCircleBehavior
	object2.behaviors[t1.CHAR_OUTLINE] = object2.CharacterOutlineBehavior
	object2.mode = t1.SMART_CIRCLE
	object2.behaviorFunction = object2.SmartCircleBehavior
	object2.savedHits = {}
	object2.trackedLimbs = {}
	object2.camera = game.Workspace.CurrentCamera
	object2.enabled = false

	return object2
end
function object.Enable(p15, p16)
	p15.enabled = p16

	if not p16 then
		p15:Cleanup()
	end
end
function object.GetOcclusionMode(_)
	return Enum.DevCameraOcclusionMode.Invisicam
end
function object.LimbBehavior(p18, p19)
	for k, _ in pairs(p18.trackedLimbs) do
		p19[#p19 + 1] = k.Position
	end
end
function object.MoveBehavior(p20, p21)
	for i = 1, 3 do
		local v65 = p20.humanoidRootPart.Position
		local velocity = p20.humanoidRootPart.Velocity
		local vector3 = Vector3.new(velocity.X, 0, velocity.Z)

		p21[#p21 + 1] = v65 + (i - 1) * p20.humanoidRootPart.CFrame.lookVector * (vector3.Magnitude / 2)
	end
end
function object.CornerBehavior(p22, p23)
	local cFrame = p22.humanoidRootPart.CFrame
	local cFramePosition = cFrame.Position
	local v72 = p22.char:GetExtentsSize()

	p23[#p23 + 1] = cFramePosition

	for i = 1, #t2 do
		p23[#p23 + 1] = cFramePosition + (cFrame - cFramePosition) * (v72 / 2 * t2[i])
	end
end
function object.CircleBehavior(p24, p25)
	local v76

	if p24.mode == t1.CIRCLE1 then
		v76 = p24.humanoidRootPart.CFrame
	else
		local CoordinateFrame = p24.camera.CoordinateFrame

		v76 = CoordinateFrame - CoordinateFrame.Position + p24.humanoidRootPart.Position
	end

	p25[#p25 + 1] = v76.Position

	for i = 0, 9 do
		local n1: number = 0.6283185307179586 * i
		local cosine = math.cos(n1)
		local sine = math.sin(n1)
		local vector3 = Vector3.new(cosine, sine, 0)

		p25[#p25 + 1] = v76 * (vector3 * 3)
	end
end
function object.LimbMoveBehavior(p26, p27)
	p26:LimbBehavior(p27)
	p26:MoveBehavior(p27)
end
function object.CharacterOutlineBehavior(p28, p29)
	local unit = p28.torsoPart.CFrame.upVector.unit
	local v88 = p28.torsoPart.CFrame.rightVector.unit

	p29[#p29 + 1] = p28.torsoPart.CFrame.p
	p29[#p29 + 1] = p28.torsoPart.CFrame.p + unit
	p29[#p29 + 1] = p28.torsoPart.CFrame.p - unit
	p29[#p29 + 1] = p28.torsoPart.CFrame.p + v88
	p29[#p29 + 1] = p28.torsoPart.CFrame.p - v88

	if p28.headPart then
		p29[#p29 + 1] = p28.headPart.CFrame.p
	end

	local cFrameNew = CFrame.new
	local vector3 = Vector3.new(p28.camera.CoordinateFrame.lookVector.X, 0, p28.camera.CoordinateFrame.lookVector.Z)
	local cFrame = cFrameNew(Vector3.new(0, 0, 0), vector3)
	local v92 = p28.torsoPart and p28.torsoPart.Position or p28.humanoidRootPart.Position
	local filterDescendantsInstances: {[any]: any} = { p28.torsoPart }

	if p28.headPart then
		filterDescendantsInstances[#filterDescendantsInstances + 1] = p28.headPart
	end

	for i = 1, 24 do
		local n1: number = 6.283185307179586 * i / 24
		local cosine = math.cos(n1)
		local sine = math.sin(n1)
		local vector32 = Vector3.new(cosine, sine, 0)
		local n2 = cFrame * (vector32 * 3)
		local x = n2.X
		local v101 = math.max(n2.Y, -2.25)
		local vector33 = Vector3.new(x, v101, n2.Z)

		if v3 then
			raycastParams2.FilterDescendantsInstances = filterDescendantsInstances

			local v103 = game.Workspace:Raycast(v92 + vector33, -3 * vector33, raycastParams2)

			if v103 then
				local v104 = v103.Position

				p29[#p29 + 1] = v104 + 0.2 * (v92 - v104).unit
			end
		else
			local ray = Ray.new(v92 + vector33, -3 * vector33)
			local v106, v107 = game.Workspace:FindPartOnRayWithWhitelist(ray, filterDescendantsInstances, false)

			if v106 then
				p29[#p29 + 1] = v107 + 0.2 * (v92 - v107).unit
			end
		end
	end
end
function object.SmartCircleBehavior(p30, p31)
	local unit = p30.torsoPart.CFrame.upVector.unit
	local v111 = p30.torsoPart.CFrame.rightVector.unit

	p31[#p31 + 1] = p30.torsoPart.CFrame.p
	p31[#p31 + 1] = p30.torsoPart.CFrame.p + unit
	p31[#p31 + 1] = p30.torsoPart.CFrame.p - unit
	p31[#p31 + 1] = p30.torsoPart.CFrame.p + v111
	p31[#p31 + 1] = p30.torsoPart.CFrame.p - v111

	if p30.headPart then
		p31[#p31 + 1] = p30.headPart.CFrame.p
	end

	local n1 = p30.camera.CFrame - p30.camera.CFrame.p
	local n2 = Vector3.new(0, 0.5, 0) + (p30.torsoPart and p30.torsoPart.Position or p30.humanoidRootPart.Position)

	for i = 1, 24 do
		local n3 = 0.2617993877991494 * i - 1.5707963267948966
		local cosine = math.cos(n3)
		local sine = math.sin(n3)
		local vector3 = Vector3.new(cosine, sine, 0)

		n3 = n2 + n1 * (vector3 * 2.5)

		local n4 = n3 - p30.camera.CFrame.p

		if v3 then
			raycastParams.FilterDescendantsInstances = { p30.char }

			local v120 = game.Workspace:Raycast(n2, n3 - n2, raycastParams)
			local n5 = n3

			if v120 then
				local normal = v120.Normal
				local n6 = v120.Position + 0.1 * normal.unit
				local n7 = n6 - n2
				local v125 = n7:Cross(n4).unit:Cross(normal).unit
				local v126 = (n6 - p30.camera.CFrame.p).unit
				local v127 = n7.unit:Dot(-v125)
				local v128 = n7.unit:Dot(v126)

				if v127 < v128 then
					n5 = RayIntersection(n6, v125, n3, n4)

					if n5.Magnitude > 0 then
						local v129 = game.Workspace:Raycast(n6, n5 - n6, raycastParams)

						if v129 then
							n5 = v129.Position + 0.1 * v129.Normal.Unit
						end
					else
						n5 = n6
					end
				else
					n5 = n6
				end

				local v130 = game.Workspace:Raycast(n2, n5 - n2, raycastParams)

				if v130 then
					n5 = v130.Position - 0.1 * (n5 - n2).unit
				end
			end

			p31[#p31 + 1] = n5
		else
			local ray = Ray.new(n2, n3 - n2)
			local v132, v133, v134 = game.Workspace:FindPartOnRayWithIgnoreList(ray, { p30.char }, false, false)
			local n8 = n3

			if v132 then
				local n9 = v133 + 0.1 * v134.unit
				local n10 = n9 - n2
				local v138 = n10:Cross(n4).unit:Cross(v134).unit
				local v139 = (n9 - p30.camera.CFrame.p).unit
				local v140 = n10.unit:Dot(-v138)
				local v141 = n10.unit:Dot(v139)

				if v140 < v141 then
					n8 = RayIntersection(n9, v138, n3, n4)

					if n8.Magnitude > 0 then
						local ray2 = Ray.new(n9, n8 - n9)
						local v143, v144, v145 = game.Workspace:FindPartOnRayWithIgnoreList(ray2, { p30.char }, false, false)

						if v143 then
							n8 = v144 + 0.1 * v145.unit
						end
					else
						n8 = n9
					end
				else
					n8 = n9
				end

				local ray3 = Ray.new(n2, n8 - n2)
				local v147, v148, v149 = game.Workspace:FindPartOnRayWithIgnoreList(ray3, { p30.char }, false, false)

				if v147 then
					n8 = v148 - 0.1 * (n8 - n2).unit
				end
			end

			p31[#p31 + 1] = n8
		end
	end
end
function object.CheckTorsoReference(p32)
	if p32.char then
		p32.torsoPart = p32.char:FindFirstChild("Torso")

		if not p32.torsoPart then
			p32.torsoPart = p32.char:FindFirstChild("UpperTorso")

			if not p32.torsoPart then
				p32.torsoPart = p32.char:FindFirstChild("HumanoidRootPart")
			end
		end

		p32.headPart = p32.char:FindFirstChild("Head")
	end
end

local t3: {[any]: any} = {
	Head = true,
	["Left Arm"] = true,
	["Right Arm"] = true,
	["Left Leg"] = true,
	["Right Leg"] = true,
	LeftLowerArm = true,
	RightLowerArm = true,
	LeftUpperLeg = true,
	RightUpperLeg = true
}

function object.CharacterAdded(p33, p34, p35)
	if p35 ~= players.LocalPlayer then
		return
	end

	if p33.childAddedConn then
		p33.childAddedConn:Disconnect()
		p33.childAddedConn = nil
	end

	if p33.childRemovedConn then
		p33.childRemovedConn:Disconnect()
		p33.childRemovedConn = nil
	end

	p33.char = p34
	p33.trackedLimbs = {}
	p33.childAddedConn = p34.ChildAdded:Connect(function(p36)
		if p36:IsA("BasePart") then
			if t3[p36.Name] then
				p33.trackedLimbs[p36] = true
			end

			if p36.Name == "Torso" or p36.Name == "UpperTorso" then
				p33.torsoPart = p36
			end

			if p36.Name == "Head" then
				p33.headPart = p36
			end
		end
	end)
	p33.childRemovedConn = p34.ChildRemoved:Connect(function(p37)
		p33.trackedLimbs[p37] = nil
		p33:CheckTorsoReference()
	end)

	for _, v in pairs(p33.char:GetChildren()) do
		if v:IsA("BasePart") then
			if t3[v.Name] then
				p33.trackedLimbs[v] = true
			end

			if v.Name == "Torso" or v.Name == "UpperTorso" then
				p33.torsoPart = v
			end

			if v.Name == "Head" then
				p33.headPart = v
			end
		end
	end
end
function object.SetMode(p38, p39)
	AssertTypes(p39, "number")

	for _, v in pairs(t1) do
		if v == p39 then
			p38.mode = p39
			p38.behaviorFunction = p38.behaviors[p38.mode]

			return
		end
	end

	error("Invalid mode number")
end
function object.GetObscuredParts(p40)
	return p40.savedHits
end
function object.Cleanup(p41)
	for k, v in pairs(p41.savedHits) do
		k.LocalTransparencyModifier = v
	end
end
function object.Update(p42, _, p44, p45)
	if not p42.enabled or not p42.char then
		return p44, p45
	end

	p42.camera = game.Workspace.CurrentCamera

	if not p42.humanoidRootPart then
		local humanoid = p42.char:FindFirstChildOfClass("Humanoid")

		if humanoid and humanoid.RootPart then
			p42.humanoidRootPart = humanoid.RootPart
		else
			p42.humanoidRootPart = p42.char:FindFirstChild("HumanoidRootPart")

			if not p42.humanoidRootPart then
				return p44, p45
			end
		end

		local connection = nil

		connection = p42.humanoidRootPart.AncestryChanged:Connect(function(p46, p47)
			if p46 == p42.humanoidRootPart and not p47 then
				p42.humanoidRootPart = nil

				if connection and connection.Connected then
					connection:Disconnect()
					connection = nil
				end
			end
		end)
	end

	if not p42.torsoPart then
		p42:CheckTorsoReference()

		if not p42.torsoPart then
			return p44, p45
		end
	end

	local t6: {[any]: any} = {}

	p42.behaviorFunction(p42, t6)

	local t7: {[any]: any} = {}
	local t8: {[any]: any} = { p42.char }

	local function add(p48)
		t7[p48] = true

		if not p42.savedHits[p48] then
			p42.savedHits[p48] = p48.LocalTransparencyModifier
		end
	end

	local n1 = 0
	local t9: {[any]: any} = {}
	local n2 = 0.75
	local n3 = 0.75
	local v178 = p42.camera:GetPartsObscuringTarget({
		p42.headPart and p42.headPart.CFrame.p or t6[1],
		p42.torsoPart and p42.torsoPart.CFrame.p or t6[2]
	}, t8)

	for i = 1, #v178 do
		local v180 = v178[i]

		n1 += 1
		t9[v180] = true

		for _, v in pairs(v180:GetChildren()) do
			if v:IsA("Decal") or v:IsA("Texture") then
				n1 += 1

				break
			end
		end
	end

	if n1 > 0 then
		n2 = math.pow(0.375 / n1 + 0.375, 1 / n1)
		n3 = math.pow(0.25 / n1 + 0.25, 1 / n1)
	end

	v178 = p42.camera:GetPartsObscuringTarget(t6, t8)
	n1 = {}

	for i = 1, #v178 do
		local v184 = v178[i]

		n1[v184] = t9[v184] and n2 or n3

		if v184.Transparency < n1[v184] then
			t7[v184] = true

			if not p42.savedHits[v184] then
				p42.savedHits[v184] = v184.LocalTransparencyModifier
			end
		end

		for _, v in pairs(v184:GetChildren()) do
			if (v:IsA("Decal") or v:IsA("Texture")) and v.Transparency < n1[v184] then
				n1[v] = n1[v184]
				t7[v] = true

				if not p42.savedHits[v] then
					p42.savedHits[v] = v.LocalTransparencyModifier
				end
			end
		end
	end

	for k, v in pairs(p42.savedHits) do
		if t7[k] then
			k.LocalTransparencyModifier = k.Transparency < 1 and (n1[k] - k.Transparency) / (1 - k.Transparency) or 0
		else
			k.LocalTransparencyModifier = v
			p42.savedHits[k] = nil
		end
	end

	return p44, p45
end

return object
