-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local collectionService: CollectionService = game:GetService("CollectionService")
local v2 = require("../attributes")
local v3 = require("../shape")
local v4 = require("../tween")
local v5 = require("../utility")
local v6 = require("../color/Oklab")
local v7 = require("../../obj/Bezier")

local module: {[any]: any} = {
	drawFuncMap = {
		Box = { Volume = v3.getPointWithinBox, Surface = v3.getPointOnBox },
		Cylinder = {
			Volume = function(p1, p2, p3, p4, p5)
				return v3.getPointWithinCylinder(p1, 0, p5, p2, p3, p4)
			end,
			Surface = function(p6, p7, p8, p9, p10)
				return v3.getPointWithinCylinder(p6, 1, p10, p7, p8, p9)
			end
		},
		Sphere = {
			Volume = function(p11, p12, p13, p14, p15)
				return v3.getPointWithinSphere(p11, 0, p15, p12, p13, p14)
			end,
			Surface = function(p16, p17, p18, p19, p20)
				return v3.getPointWithinSphere(p16, 1, p20, p17, p18, p19)
			end
		},
		Disc = {
			Volume = function(p21, p22, p23, p24, p25)
				return v3.getPointWithinDisc(p21, 0, p25, p22, p23, p24)
			end,
			Surface = function(p26, p27, p28, p29, p30)
				return v3.getPointWithinDisc(p26, 1, p30, p27, p28, p29)
			end
		}
	},
	getColorAtTime = function(p31, p32)
		local keypoints = p31.Keypoints

		if p32 <= keypoints[1].Time then
			return keypoints[1].Value
		end

		if p32 >= keypoints[#keypoints].Time then
			return keypoints[#keypoints].Value
		end

		local v42 = nil
		local v43 = nil

		for i = 1, #keypoints do
			local v45 = keypoints[i]

			if p32 == v45.Time then
				return v45.Value
			end

			if p32 > v45.Time then
				v42 = v45
			elseif p32 < v45.Time then
				v43 = v45

				break
			end
		end

		if v42 and v43 then
			return v42.Value:Lerp(v43.Value, (p32 - v42.Time) / (v43.Time - v42.Time))
		end

		return keypoints[1].Value
	end,
	getColorAtTimeOklab = function(p33, p34)
		local keypoints = p33.Keypoints

		if p34 <= keypoints[1].Time then
			return keypoints[1].Value
		end

		if p34 >= keypoints[#keypoints].Time then
			return keypoints[#keypoints].Value
		end

		local v49 = nil
		local v50 = nil

		for i = 1, #keypoints do
			local v52 = keypoints[i]

			if p34 == v52.Time then
				return v52.Value
			end

			if p34 > v52.Time then
				v49 = v52
			elseif p34 < v52.Time then
				v50 = v52

				break
			end
		end

		if v49 and v50 then
			local n1 = (p34 - v49.Time) / (v50.Time - v49.Time)
			local v54 = v6.fromSRGB(v49.Value)
			local v55 = v6.fromSRGB(v50.Value)

			v55 = v54:Lerp(v55, n1)

			return v6.toSRGB(v55)
		end

		return keypoints[1].Value
	end
}

function module.getColorWithEasingOklab(p35, p36, p37)
	local v59 = math.clamp(p36, 0, 1)
	local v60 = p37:getEase(v59)
	local getColorAtTimeOklab = module.getColorAtTimeOklab

	v59 = math.clamp(1 - v60.y, 0, 1)

	return getColorAtTimeOklab(p35, v59)
end
function module.createHitboxParams(p38, p39, p40)
	local v65 = OverlapParams.new()

	v65.MaxParts = 1
	v65.FilterType = Enum.RaycastFilterType[p38.filterType]
	v65.CollisionGroup = p38.collisionGroup
	v65.RespectCanCollide = not p38.ignoreCanCollide
	v65:AddToFilter(collectionService:GetTagged(p38.filterTag))

	if p38.filterType == "Exclude" then
		local v66 = p40 and p40:FindFirstAncestorOfClass("Part")

		v65:AddToFilter({ workspace.Terrain, p39, v66 })
	end

	return v65
end
function module.calculateEmissionCFrame(p41, p42, p43, p44, p45, p46, p47)
	local n1 = if p47 then p41 * CFrame.new(Vector3.new(0, 0, 0), Vector3.FromNormalId(p43.emissionDirection)).Rotation else if p44 then p44(nil, p41, p42, p43.emissionDirection, p43.partial) else p41
	local v75 = Vector3.FromNormalId(p43.emissionDirection)
	local v76 = v75:Cross(p41.LookVector)

	if v76.Magnitude < 0.001 then
		v76 = v75:Cross(p41.UpVector)
	end

	local cFrameFromAxisAngle = CFrame.fromAxisAngle
	local v78 = p45:NextNumber(-p43.spreadAngle.X, p43.spreadAngle.X)
	local v79 = math.rad(v78)
	local v80 = cFrameFromAxisAngle(v75, v79)
	local v81 = CFrame.fromAxisAngle
	local v82 = p45:NextNumber(-p43.spreadAngle.Y, p43.spreadAngle.Y)

	v78 = math.rad(v82)

	local v83 = v81(v76, v78)
	local n2 = n1 * (v80 * v83)

	if p43.face == "Inward" or p43.face == "InAndOut" and p45:NextInteger(0, 1) == 1 then
		local v85 = CFrame.fromOrientation(0, 3.141592653589793, 0)

		n2 *= v85
	end

	if p46 and p43.mirror and (n2.Position - p46.WorldPosition).Unit:Dot(n2.RightVector) >= 0 then
		local n3 = p43.mirrorRot * v5.DEG_TO_RAD
		local v87 = CFrame.fromOrientation(n3.X, n3.Y, n3.Z)

		n2 *= v87
	end

	return n2
end
function module.createBezierWithEndpoint(list, p49, p50, p51)
	if not p50 then
		return v7.new(list)
	end

	local t2: {[any]: any} = {}

	for iterFirst, iterSecond in list do
		table.insert(t2, if iterFirst == #list - 1 then p51 and p51.WorldPosition or p50.WorldPosition else if iterFirst == #list then p50.WorldPosition else p49 * (iterSecond - list[1]))
	end

	return v7.new(t2)
end
function module.createPosGetter(p52, p53, p54, p55, p56)
	return function(p57)
		local v151 = if p56 == false then p52:getPosition(p57) else p52:getPositionArcSpace(p57)

		if p55 then
			return v151
		end

		return p54 * (v151 - p53[1])
	end
end
function module.readCommonAttributes(p58)
	local v101 = v2.get(p58, "EmitDelay", 0)
	local v102 = v2.get(p58, "EmitCount", 1)
	local v103 = v2.get(p58, "EmitDuration", 0)
	local v104 = v2.get(p58, "DestroyDelay", 0)
	local v105 = v2.getRange(p58, "Duration", NumberRange.new(1, 1), NumberRange.new(0, math.huge))
	local v106 = v2.getEnum(p58, "Shape", "Box", { "Box", "Cylinder", "Sphere", "Disc" })
	local v107 = v2.getEnum(p58, "ShapeStyle", "Volume", { "Volume", "Surface" })
	local enumNormalId = Enum.NormalId
	local v109 = v2.getEnum(p58, "EmissionDirection", "Top", { "Top", "Bottom", "Left", "Right", "Front", "Back" })
	local v110 = enumNormalId[v109]
	local v111 = v2.getEnum(p58, "ShapeFace", "Outward", { "InAndOut", "Inward", "Outward" })
	local v112 = v2.get(p58, "SpreadAngle", Vector3.new(0, 0, 0))
	local v113 = v2.get(p58, "ShapePartial", 1)
	local v114 = v2.get(p58, "SyncPosition", false)
	local v115 = v2.get(p58, "MirrorPaths", true)
	local v116 = v2.get(p58, "MirrorRotation", Vector3.new(0, 0, 180))
	local v117 = v2.get(p58, "ProjectileEnabled", false)
	local v118 = v2.get(p58, "MatchEndDirection", false)
	local v119 = v2.get(p58, "ProjectileSpeed", 30)
	local v120 = v2.getRange(p58, "ProjectileLifetime", NumberRange.new(1, 1), NumberRange.new(0, math.huge))
	local v121 = v2.get(p58, "HitboxEnabled", false)
	local v122 = v2.get(p58, "HitboxCollisionGroup", "Default")
	local v123 = v2.get(p58, "HitboxFilterTag", "")
	local v124 = v2.get(p58, "HitboxFilterType", "Exclude")
	local v125 = v2.get(p58, "HitboxIgnoreCanCollide", false)
	local v126 = v2.get(p58, "Speed_Start", 1)
	local v127 = v2.get(p58, "Speed_End", 1)

	return {
		emitDelay = v101,
		emitCount = v102,
		emitDuration = v103,
		destroyDelay = v104,
		duration = v105,
		shapeType = v106,
		shapeStyle = v107,
		emissionDirection = v110,
		face = v111,
		spreadAngle = v112,
		partial = v113,
		syncPosition = v114,
		mirror = v115,
		mirrorRot = v116,
		projectileEnabled = v117,
		projectileMatchEnd = v118,
		projectileSpeed = v119,
		projectileLifetime = v120,
		hitboxEnabled = v121,
		hitboxCollisionGroup = v122,
		hitboxFilterTag = v123,
		hitboxFilterType = v124,
		hitboxIgnoreCanCollide = v125,
		speedStart = v126,
		speedEnd = v127
	}
end
function module.getCurrentOriginCFrame(p59, p60)
	if p59:IsA("BasePart") then
		return p59.CFrame
	end

	if p59:IsA("Attachment") then
		return p59.WorldCFrame
	end

	return p60
end
function module.findEndAttachments(p61)
	local v131 = p61:FindFirstChild("End")
	local v132 = v131 and v131:FindFirstChild("T1")

	if v131 and not v131:IsA("Attachment") then
		v131 = nil
	end

	if v132 and not v132:IsA("Attachment") then
		v132 = nil
	end

	return v131, v132
end
function module.validateParent(p62)
	local v134 = p62.Parent

	if not v134 then
		return nil
	end

	if not v134:IsA("BasePart") and not v134:IsA("Attachment") then
		v134 = p62
	end

	return v134
end
function module.getPerpendicularVectors(p63)
	local v136 = p63:Cross(Vector3.new(0, 1, 0))

	if v136.Magnitude < 0.001 then
		v136 = p63:Cross(Vector3.new(0, 0, 1))
	end

	local unit = v136.Unit
	local v138 = p63:Cross(unit)

	return unit, v138.Unit
end
function module.createPropertyTween(p64, p65, p66, p67, p68, p69, p70, p71, p72)
	if p68 == p69 then
		return
	end

	local fromParams = v4.fromParams
	local v149 = v2.get(p65, p66 .. "_Curve", v5.default_bezier)

	table.insert(p64, fromParams(v149, p67, function(p73, p74)
		p70(v5.lerp(p68, p69, p73))

		local v154 = p71()

		return p74 * v154
	end, p72))
end

return module
