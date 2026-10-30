-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {}

module.__index = module

local color3 = Color3.fromRGB(255, 255, 255)
local color32 = Color3.fromRGB(255, 255, 255)

local function SetUpFolders(p1)
	if p1.WorkspaceFolder == nil then
		local distanceFade_SurfaceParts: Instance = game.Workspace:FindFirstChild("DistanceFade_SurfaceParts")

		if distanceFade_SurfaceParts == nil then
			p1.WorkspaceFolder = Instance.new("Folder")
			p1.WorkspaceFolder.Name = "DistanceFade_SurfaceParts"
			p1.WorkspaceFolder.Parent = workspace

			return
		end

		p1.WorkspaceFolder = distanceFade_SurfaceParts

		return
	end
end

local t2: {[any]: any} = {
	DistanceOuter = 16,
	DistanceInner = 4,
	EffectRadius = 16,
	EffectRadiusMin = 0,
	EdgeDistanceCalculations = false,
	Texture = "rbxassetid://18838056070",
	TextureTransparency = 0,
	TextureTransparencyMin = 1,
	BackgroundTransparency = 1,
	BackgroundTransparencyMin = 1,
	TextureColor = color3,
	BackgroundColor = color32,
	TextureSize = Vector2.new(8, 8),
	TextureOffset = Vector2.new(0, 0),
	ZOffset = 0,
	AlwaysOnTop = false,
	Brightness = 1,
	LightInfluence = 0,
	MaxDistance = 1000,
	PixelsPerStud = 100,
	SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
}

function module.new()
	local t4: {[any]: any} = {
		WorkspaceFolder = nil,
		Settings = {},
		FaceSettings = {},
		TargetParts = {}
	}

	setmetatable(t4, module)
	t4.Settings = {}

	for key, value in t2 do
		t4.Settings[key] = value
	end

	if t4.WorkspaceFolder == nil then
		local distanceFade_SurfaceParts: Instance = game.Workspace:FindFirstChild("DistanceFade_SurfaceParts")

		if distanceFade_SurfaceParts == nil then
			t4.WorkspaceFolder = Instance.new("Folder")
			t4.WorkspaceFolder.Name = "DistanceFade_SurfaceParts"
			t4.WorkspaceFolder.Parent = workspace

			return t4
		end

		t4.WorkspaceFolder = distanceFade_SurfaceParts

		return t4
	end

	return t4
end
function module.UpdateSettings(p2, p3)
	if p2.Settings == nil then
		p2.Settings = {}
	end

	if p3 == nil then
		for key, value in t2 do
			p2.Settings[key] = value
		end

		return
	end

	local typeName: string = type(p3)

	assert(typeName == "table", "Expected table as parameter")

	for key2, value2 in t2 do
		if p3[key2] ~= nil then
			p2.Settings[key2] = p3[key2]
		elseif p2.Settings[key2] == nil then
			p2.Settings[key2] = value2
		end
	end
end
function module.UpdateFaceSettings(p4, p5, p6, p7)
	if p4.FaceSettings[p5] == nil then
		p4.FaceSettings[p5] = {}
	end

	if p4.FaceSettings[p5][p6] == nil then
		p4.FaceSettings[p5][p6] = {}
	end

	if p7 == nil then
		p4.FaceSettings[p5][p6] = nil

		return
	end

	local typeName: string = type(p7)

	assert(typeName == "table", "Expected table as parameter")

	for k, v in pairs(p7) do
		p4.FaceSettings[p5][p6][k] = v
	end
end
local function GetNormalDirection(p8, p9)
	local v39 = nil

	if p8 == Enum.NormalId.Front then
		return p9.CFrame.LookVector
	end

	if p8 == Enum.NormalId.Back then
		return -p9.CFrame.LookVector
	end

	if p8 == Enum.NormalId.Left then
		return -p9.CFrame.RightVector
	end

	if p8 == Enum.NormalId.Right then
		return p9.CFrame.RightVector
	end

	if p8 == Enum.NormalId.Top then
		return p9.CFrame.UpVector
	end

	if p8 == Enum.NormalId.Bottom then
		v39 = -p9.CFrame.UpVector
	end

	return v39
end
local function GetNormalOffset(p10, p11)
	local vector3 = Vector3.new()
	local cFrame = CFrame.new()

	if p10 == Enum.NormalId.Front then
		local n1 = p11.Size.Z / 2 * p11.CFrame.LookVector
		local v45 = CFrame.Angles(0, 0, 0)

		return n1, v45
	end

	if p10 == Enum.NormalId.Back then
		local n2 = p11.Size.Z / 2 * -p11.CFrame.LookVector
		local v47 = CFrame.Angles(0, 3.141592653589793, 0)

		return n2, v47
	end

	if p10 == Enum.NormalId.Left then
		local n3 = p11.Size.X / 2 * -p11.CFrame.RightVector
		local v49 = CFrame.Angles(0, 1.5707963267948966, 0)

		return n3, v49
	end

	if p10 == Enum.NormalId.Right then
		local n4 = p11.Size.X / 2 * p11.CFrame.RightVector
		local v51 = CFrame.Angles(0, -1.5707963267948966, 0)

		return n4, v51
	end

	if p10 == Enum.NormalId.Top then
		local n5 = p11.Size.Y / 2 * p11.CFrame.UpVector
		local v53 = CFrame.Angles(1.5707963267948966, 0, 0)

		return n5, v53
	end

	if p10 == Enum.NormalId.Bottom then
		vector3 = p11.Size.Y / 2 * -p11.CFrame.UpVector
		cFrame = CFrame.Angles(-1.5707963267948966, 0, 0)
	end

	return vector3, cFrame
end
local function GetSidePositionsOfPartAlongNormal(p12, p13, p14, p15)
	local v58 = nil
	local v59 = nil
	local RightVector = nil
	local UpVector = nil
	local v62 = nil

	if p14 == Enum.NormalId.Front or p14 == Enum.NormalId.Back then
		v58 = p15.X / 2
		v59 = p15.Y / 2

		local n1 = p15.Z / 2

		RightVector = p14 == Enum.NormalId.Front and p13.RightVector or -p13.RightVector
		UpVector = p13.UpVector
		v62 = p14 == Enum.NormalId.Front and p13.LookVector * n1 or -p13.LookVector * n1
	elseif p14 == Enum.NormalId.Left or p14 == Enum.NormalId.Right then
		v58 = p15.Z / 2
		v59 = p15.Y / 2

		local n2 = p15.X / 2

		RightVector = p14 == Enum.NormalId.Left and p13.LookVector or -p13.LookVector
		UpVector = p13.UpVector
		v62 = p14 == Enum.NormalId.Left and -p13.RightVector * n2 or p13.RightVector * n2
	elseif p14 == Enum.NormalId.Top or p14 == Enum.NormalId.Bottom then
		v58 = p15.X / 2
		v59 = p15.Z / 2

		local n3 = p15.Y / 2

		RightVector = p13.RightVector
		UpVector = p14 == Enum.NormalId.Top and -p13.LookVector or p13.LookVector
		v62 = p14 == Enum.NormalId.Top and p13.UpVector * n3 or -p13.UpVector * n3
	end

	local n4 = p12 + v62

	return {
		Left = n4 - RightVector * v58,
		Right = n4 + RightVector * v58,
		Top = n4 + UpVector * v59,
		Bottom = n4 - UpVector * v59
	}
end
local function ToNormalSpace(p16, p17, p18)
	local v70 = p16:PointToObjectSpace(p17)

	if p18 == Enum.NormalId.Front then
		return v70
	end

	if p18 == Enum.NormalId.Back then
		local vector3 = Vector3.new(-v70.X, v70.Y, v70.Z)

		return vector3
	end

	if p18 == Enum.NormalId.Left then
		local vector3 = Vector3.new(-v70.Z, v70.Y, v70.X)

		return vector3
	end

	if p18 == Enum.NormalId.Right then
		local vector3 = Vector3.new(v70.Z, v70.Y, v70.X)

		return vector3
	end

	if p18 == Enum.NormalId.Top then
		local vector3 = Vector3.new(v70.X, v70.Z, v70.Y)

		return vector3
	end

	local vector3 = Vector3.new(v70.X, -v70.Z, v70.Y)

	return vector3
end
local function NewTile()
	local frame: Frame = Instance.new("Frame")

	frame.BackgroundTransparency = 1

	local scaleFrame: Frame = Instance.new("Frame")

	scaleFrame.BackgroundTransparency = 1
	scaleFrame.ClipsDescendants = true
	scaleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	scaleFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	scaleFrame.Size = UDim2.new(1, 0, 1, 0)
	scaleFrame.Name = "ScaleFrame"
	scaleFrame.Parent = frame

	local imageLabel: ImageLabel = Instance.new("ImageLabel")

	imageLabel.BackgroundTransparency = 1
	imageLabel.Parent = scaleFrame
	imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	imageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	imageLabel.Size = UDim2.new(9, 0, 9, 0)
	imageLabel.ScaleType = Enum.ScaleType.Tile
	imageLabel.TileSize = UDim2.new(0.111, 0, 0.111, 0)

	return frame
end
local function CreateGrid(_, p20)
	local t5: {[any]: any} = {}

	for i = 1, 4 do
		for j = 1, 4 do
			local v84 = NewTile()

			v84.Parent = p20.ScaleFrame
			v84.Size = UDim2.new(0.25, 0, 0.25, 0)
			v84.Position = UDim2.new((j - 1) * 0.25, 0, (i - 1) * 0.25, 0)
			v84.BorderSizePixel = 0
			table.insert(t5, v84)
			v84.Name = tostring(#t5)
		end
	end

	return t5
end
local function ApplyCircularGradient(p21)
	local t6: {[any]: any} = { 45, [4] = 135, [13] = -45, [16] = -135 }
	local t7: {[any]: any} = {
		[2] = 75,
		[3] = 105,
		[5] = 15,
		[8] = 165,
		[9] = -15,
		[12] = -165,
		[14] = -75,
		[15] = -105
	}

	for i = 1, #p21 do
		local v89 = p21[i]
		local u90: boolean = false

		for key, value in t6 do
			if key == i then
				local uiGradient: UIGradient = Instance.new("UIGradient")

				uiGradient.Parent = v89.ScaleFrame.ImageLabel
				uiGradient.Rotation = value
				u90 = true

				break
			end
		end

		if not u90 then
			for key2, value2 in t7 do
				if key2 == i then
					local uiGradient: UIGradient = Instance.new("UIGradient")

					uiGradient.Parent = v89.ScaleFrame.ImageLabel
					uiGradient.Rotation = value2

					break
				end
			end
		end
	end
end
local function SetUpSurface(p22, p23, p24)
	local part: Part = Instance.new("Part")

	part.Transparency = 1
	part.Parent = p24.WorkspaceFolder
	part.Size = Vector3.new(0, 0, 0)
	part.Anchored = true
	part.CanCollide = false
	part.CanTouch = false
	part.CanQuery = false
	part.Locked = true

	local v101, v102 = GetNormalOffset(p23, p22)
	local v103 = p22.CFrame
	local cFrame = CFrame.new(v101)

	part.CFrame = v103 * cFrame * v102

	local surfaceGui: SurfaceGui = Instance.new("SurfaceGui")

	surfaceGui.ResetOnSpawn = false
	surfaceGui.ClipsDescendants = true
	surfaceGui.Parent = game.Players.LocalPlayer.PlayerGui
	surfaceGui.Adornee = part
	surfaceGui.Face = Enum.NormalId.Front
	surfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	surfaceGui.PixelsPerStud = 1000

	local scaleFrame: Frame = Instance.new("Frame")

	scaleFrame.Size = UDim2.new(1, 0, 1, 0)
	scaleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	scaleFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	scaleFrame.BackgroundTransparency = 1
	scaleFrame.Name = "ScaleFrame"
	scaleFrame.Parent = surfaceGui
	surfaceGui.Enabled = false

	local effectResolution = p24.Settings.EffectResolution
	local v108 = CreateGrid(effectResolution, surfaceGui)

	ApplyCircularGradient(v108, effectResolution)

	return part, surfaceGui
end
function module.AddFace(p25, p26, p27)
	if p27 == nil then
		p27 = Enum.NormalId.Front
	end

	local v112, v113 = SetUpSurface(p26, p27, p25)

	if p25.TargetParts[p26] == nil then
		p25.TargetParts[p26] = {}
	end

	p25.TargetParts[p26][p27] = { SurfaceNormal = p27, SurfacePart = v112, SurfaceGui = v113 }
end
function module.RemoveFace(p28, p29, p30)
	if p30 == nil then
		p30 = Enum.NormalId.Front
	end

	if p28.TargetParts[p29] == nil then
		return
	end

	local v117 = p28.TargetParts[p29][p30]

	if v117 == nil then
		return
	end

	v117.SurfacePart:Destroy()
	v117.SurfaceGui:Destroy()
	p28.TargetParts[p29][p30] = nil

	if next(p28.TargetParts[p29]) == nil then
		p28.TargetParts[p29] = nil

		if p28.WorkspaceFolder ~= nil and #p28.WorkspaceFolder:GetChildren() == 0 then
			p28.WorkspaceFolder:Destroy()
			p28.WorkspaceFolder = nil
		end
	end
end
function module.Clear(p31)
	for iterFirst, iterSecond in p31.TargetParts, nil, nil do
		for iterFirst2, iterSecond2 in iterSecond do
			iterSecond2.SurfacePart:Destroy()
			iterSecond2.SurfaceGui:Destroy()
		end
	end

	if p31.WorkspaceFolder ~= nil and #p31.WorkspaceFolder:GetChildren() == 0 then
		p31.WorkspaceFolder:Destroy()
		p31.WorkspaceFolder = nil
	end

	table.clear(p31.TargetParts)
end
local function UpdateTextureOffset(p32, p33, p34, p35)
	local function ConvertToRange(p36, p37)
		local n1 = math.abs(p36) / p37 % 1

		if p36 < 0 then
			return -n1
		end

		return n1
	end

	local n1 = math.abs(p32) / p34 % 1
	local n2 = math.abs(p33) / p35 % 1

	return UDim2.new(0.5 + (if p32 < 0 then -n1 else n1) * p34, 0, 0.5 + (if p33 < 0 then -n2 else n2) * p35, 0)
end
local function AdjustGradientOffset(p38, p39)
	local v132 = math.rad(p38.Rotation)
	local cosine = math.cos(v132)
	local sine = math.sin(v132)

	return Vector2.new(p39.X * cosine - p39.Y * sine, p39.X * sine + p39.Y * cosine)
end
function UpdateSideGradient(p40)
	local uiGradient = p40.ScaleFrame.ImageLabel.UIGradient
	local ScaleFrameSize = p40.ScaleFrame.Size

	ScaleFrameSize = p40.ScaleFrame.ImageLabel.Position

	local n1 = -(ScaleFrameSize.X.Scale + 0.5) / 200

	if p40.Name == "2" or p40.Name == "3" or p40.Name == "14" or p40.Name == "15" then
		n1 = 0
	end

	local n2 = -(ScaleFrameSize.Y.Scale + 0.5) / 200

	if p40.Name == "5" or p40.Name == "8" or p40.Name == "9" or p40.Name == "12" then
		n2 = 0
	end

	if p40.Name == "5" or p40.Name == "9" then
		n1 += 0.01
	end

	if p40.Name == "2" or p40.Name == "3" then
		n2 += 0.01
	end

	local n3 = (ScaleFrameSize.X.Scale - 0.5) / 9 + n1

	n1 = (ScaleFrameSize.Y.Scale - 0.5) / 9 + n2

	if p40.Name == "12" or p40.Name == "9" or p40.Name == "2" or p40.Name == "3" then
		n1 = -n1
	end

	if p40.Name == "5" or p40.Name == "9" or p40.Name == "15" or p40.Name == "3" then
		n3 = -n3
	end

	if p40.Name == "2" or p40.Name == "3" or p40.Name == "14" or p40.Name == "15" then
		local n4 = n3

		n3 = n1
		n1 = n4
	end

	local t8 = {}
	ScaleFrameSize = {
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.444, 1),
		NumberSequenceKeypoint.new(0.466, 1),
		NumberSequenceKeypoint.new(0.555, 0),
		NumberSequenceKeypoint.new(1, 0)
	}

	for i = 1, #ScaleFrameSize do
		local v144 = ScaleFrameSize[i]
		local numberSequenceKeypointNew = NumberSequenceKeypoint.new
		local v146 = math.clamp(v144.Time + n3, 0, 1)

		t8[i] = numberSequenceKeypointNew(v146, v144.Value)
	end

	if t8[1].Time > 0 then
		table.insert(t8, 1, NumberSequenceKeypoint.new(0, t8[1].Value))
	end

	if t8[#t8].Time < 1 then
		table.insert(t8, NumberSequenceKeypoint.new(1, t8[#t8].Value))
	end

	for key, value in t8 do
		if value.Time < 0 then
			value.Time = 0
		elseif value.Time > 1 then
			value.Time = 1
		end
	end

	uiGradient.Transparency = NumberSequence.new(t8)

	local vector2 = Vector2.new(-n1 / 4, 0)

	t8 = math.rad(uiGradient.Rotation)

	local cosine = math.cos(t8)
	local sine = math.sin(t8)

	uiGradient.Offset = Vector2.new(vector2.X * cosine - vector2.Y * sine, vector2.X * sine + vector2.Y * cosine)
end
function UpdateCornerGradient(p41)
	local uiGradient = p41.ScaleFrame.ImageLabel.UIGradient
	local v154 = p41.ScaleFrame.Size

	v154 = p41.ScaleFrame.ImageLabel.Position

	local n1 = (v154.X.Scale - 0.5) / 9 + -(v154.X.Scale + 0.5) / 75
	local n2 = (v154.Y.Scale - 0.5) / 9 + -(v154.Y.Scale + 0.5) / 75

	if p41.Name == "13" or p41.Name == "1" then
		n1 = -n1
	end

	if p41.Name == "1" or p41.Name == "4" then
		n2 = -n2
	end

	local n3: number = 0

	if p41.Name == "1" then
		n3 = -0.015
	elseif p41.Name == "4" then
		n3 = 0.0025
	elseif p41.Name == "16" then
		n3 = 0.02
	elseif p41.Name == "13" then
		n3 = 0.0025
	end

	local t9 = {}
	local t10: {[any]: any} = {
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.444, 1),
		NumberSequenceKeypoint.new(0.51, 1),
		NumberSequenceKeypoint.new(0.555, 0.2),
		NumberSequenceKeypoint.new(1, 0.2)
	}

	for i = 1, #t10 do
		local v161 = t10[i]
		local numberSequenceKeypointNew = NumberSequenceKeypoint.new
		local v163 = math.clamp(v161.Time + ((n1 + n2) / 1.4142135623730951 + n3), 0, 1)

		t9[i] = numberSequenceKeypointNew(v163, v161.Value)
	end

	if t9[1].Time > 0 then
		table.insert(t9, 1, NumberSequenceKeypoint.new(0, t9[1].Value))
	end

	if t9[#t9].Time < 1 then
		table.insert(t9, NumberSequenceKeypoint.new(1, t9[#t9].Value))
	end

	if p41.Name == "1" or p41.Name == "4" then
		local t11: {[any]: any} = {}

		for key, value in t9 do
			if value.Time == 1 then
				for i = 1, key do
					table.insert(t11, t9[i])
				end

				t9 = t11

				break
			end
		end
	end

	for key2, value2 in t9 do
		if value2.Time < 0 then
			value2.Time = 0
		elseif value2.Time > 1 then
			value2.Time = 1
		end
	end

	uiGradient.Transparency = NumberSequence.new(t9)

	local vector2 = Vector2.new(-((n1 + n2) / 1.4142135623730951 + n3) / 4, 0)

	t9 = math.rad(uiGradient.Rotation)

	local cosine = math.cos(t9)
	local sine = math.sin(t9)

	uiGradient.Offset = Vector2.new(vector2.X * cosine - vector2.Y * sine, vector2.X * sine + vector2.Y * cosine)
end

local t3: {[any]: any} = {
	{ OffsetX = 3, OffsetY = 3 },
	{ OffsetX = 2, OffsetY = 3 },
	{ OffsetX = 1, OffsetY = 3 },
	{ OffsetX = 0, OffsetY = 3 },
	{ OffsetX = 3, OffsetY = 2 },
	{ OffsetX = 2, OffsetY = 2 },
	{ OffsetX = 1, OffsetY = 2 },
	{ OffsetX = 0, OffsetY = 2 },
	{ OffsetX = 3, OffsetY = 1 },
	{ OffsetX = 2, OffsetY = 1 },
	{ OffsetX = 1, OffsetY = 1 },
	{ OffsetX = 0, OffsetY = 1 },
	{ OffsetX = 3, OffsetY = 0 },
	{ OffsetX = 2, OffsetY = 0 },
	{ OffsetX = 1, OffsetY = 0 },
	{ OffsetX = 0, OffsetY = 0 }
}

function module.Step(p42, p43)
	local n1

	if p42.WorkspaceFolder == nil then
		local distanceFade_SurfaceParts: Instance = game.Workspace:FindFirstChild("DistanceFade_SurfaceParts")

		if distanceFade_SurfaceParts == nil then
			p42.WorkspaceFolder = Instance.new("Folder")
			p42.WorkspaceFolder.Name = "DistanceFade_SurfaceParts"
			p42.WorkspaceFolder.Parent = workspace
		else
			p42.WorkspaceFolder = distanceFade_SurfaceParts
		end
	end

	local settings = p42.Settings

	if settings.EffectRadiusMin > settings.EffectRadius then
		settings.EffectRadiusMin = settings.EffectRadius
	end

	if settings.DistanceInner > settings.DistanceOuter then
		settings.DistanceInner = settings.DistanceOuter
	end

	if p43 == nil then
		local Character = game.Players.LocalPlayer.Character

		if Character == nil then
			return
		end

		p43 = Character:FindFirstChild("Head") and Character.Head.Position or workspace.CurrentCamera.CFrame.Position
	end

	for iterFirst, iterSecond in p42.TargetParts, nil, nil do
		for iterFirst2, iterSecond2 in iterSecond do
			local t12: {[any]: any} = {}

			if p42.FaceSettings[iterFirst] ~= nil and p42.FaceSettings[iterFirst][iterFirst2] ~= nil then
				for iterFirst3, iterSecond3 in settings do
					t12[iterFirst3] = iterSecond3

					if p42.FaceSettings[iterFirst][iterFirst2][iterFirst3] ~= nil then
						t12[iterFirst3] = p42.FaceSettings[iterFirst][iterFirst2][iterFirst3]
					end
				end
			end

			local t13 = settings

			if next(t12) ~= nil then
				t13 = t12
			end

			local surfacePart = iterSecond2.SurfacePart
			local surfaceGui = iterSecond2.SurfaceGui

			surfaceGui.ZOffset = t13.ZOffset
			surfaceGui.AlwaysOnTop = t13.AlwaysOnTop
			surfaceGui.Brightness = t13.Brightness
			surfaceGui.LightInfluence = t13.LightInfluence
			surfaceGui.MaxDistance = t13.MaxDistance
			surfaceGui.PixelsPerStud = t13.PixelsPerStud
			surfaceGui.SizingMode = t13.SizingMode

			local v189 = iterFirst.CFrame
			local v190, v191 = GetNormalOffset(iterSecond2.SurfaceNormal, iterFirst)
			local v192 = GetNormalDirection(iterSecond2.SurfaceNormal, iterFirst)
			local n2 = p43 - (iterFirst.Position + v190)
			local v194 = n2:Dot(v192)
			local n3 = iterFirst.Position + (n2 - v192 * v194) + v190
			local v196 = iterFirst.CFrame
			local cFrame = CFrame.new(v190)
			local n4 = v196 * cFrame * v191
			local cFrame2 = CFrame.new(n3)
			local v200 = CFrame.fromMatrix(Vector3.new(), n4.RightVector, n4.UpVector)

			surfacePart.CFrame = cFrame2 * v200

			local v201 = (p43 - surfacePart.Position).Magnitude

			n3 = GetSidePositionsOfPartAlongNormal(iterFirst.Position, iterFirst.CFrame, iterSecond2.SurfaceNormal, iterFirst.Size)

			if t13.EdgeDistanceCalculations then
				local n5 = math.huge
				local cFrame3 = CFrame.new(n3.Top)
				local v204 = ToNormalSpace(cFrame3 * (iterFirst.CFrame - iterFirst.CFrame.Position), p43, iterSecond2.SurfaceNormal)

				v204 = Vector3.new(0, v204.Y, v204.Z).Magnitude

				if v204 < n5 then
					n5 = v204
				end

				local cFrame4 = CFrame.new(n3.Bottom)

				v204 = ToNormalSpace(cFrame4 * (iterFirst.CFrame - iterFirst.CFrame.Position), p43, iterSecond2.SurfaceNormal)
				v204 = Vector3.new(0, v204.Y, v204.Z).Magnitude

				if v204 < n5 then
					n5 = v204
				end

				local cFrame5 = CFrame.new(n3.Left)

				v204 = ToNormalSpace(cFrame5 * (iterFirst.CFrame - iterFirst.CFrame.Position), p43, iterSecond2.SurfaceNormal)
				v204 = Vector3.new(v204.X, 0, v204.Z).Magnitude

				if v204 < n5 then
					n5 = v204
				end

				local cFrame6 = CFrame.new(n3.Right)

				v204 = ToNormalSpace(cFrame6 * (iterFirst.CFrame - iterFirst.CFrame.Position), p43, iterSecond2.SurfaceNormal)
				v204 = Vector3.new(v204.X, 0, v204.Z).Magnitude

				if v204 < n5 then
					n5 = v204
				end

				if n5 < v201 then
					v201 = n5
				end
			end

			local n6 = 1 / (t13.TextureSize.X * 2 / t13.EffectRadius)

			if v201 < t13.DistanceInner then
				surfaceGui.Enabled = true

				local n1 = n6
				local n7 = t13.EffectRadius / n6
				local n8 = (t13.EffectRadiusMin + (t13.EffectRadius - t13.EffectRadiusMin) * n1 * (t13.TextureSize.X * 2 / t13.EffectRadius)) * 2

				surfacePart.Size = Vector3.new(n8, n8, surfacePart.Size.Z)

				local v211 = GetSidePositionsOfPartAlongNormal(surfacePart.Position, surfacePart.CFrame, Enum.NormalId.Front, surfacePart.Size)
				local v212 = ToNormalSpace(iterFirst.CFrame, n3.Left, iterSecond2.SurfaceNormal)
				local v213 = ToNormalSpace(iterFirst.CFrame, n3.Right, iterSecond2.SurfaceNormal)
				local v214 = ToNormalSpace(iterFirst.CFrame, n3.Top, iterSecond2.SurfaceNormal)
				local v215 = ToNormalSpace(iterFirst.CFrame, n3.Bottom, iterSecond2.SurfaceNormal)
				local v216 = ToNormalSpace(iterFirst.CFrame, v211.Left, iterSecond2.SurfaceNormal)
				local v217 = ToNormalSpace(iterFirst.CFrame, v211.Right, iterSecond2.SurfaceNormal)
				local v218 = ToNormalSpace(iterFirst.CFrame, v211.Top, iterSecond2.SurfaceNormal)
				local v219 = ToNormalSpace(iterFirst.CFrame, v211.Bottom, iterSecond2.SurfaceNormal)
				local n9 = 1
				local n10 = 1
				local t14: {[any]: any} = { Left = v216, Right = v217, Top = v218, Bottom = v219 }
				local t15: {[any]: any} = { Left = v212, Right = v213, Top = v214, Bottom = v215 }

				if t14.Left.X < t15.Left.X then
					n9 = 1 - (t15.Left.X - t14.Left.X) / surfacePart.Size.X
				end

				if t14.Right.X > t15.Right.X then
					n10 = 1 - (t14.Right.X - t15.Right.X) / surfacePart.Size.X
				end

				local n11 = 1
				local n12 = 1

				if t14.Bottom.Y < t15.Bottom.Y then
					n12 = 1 - (t15.Bottom.Y - t14.Bottom.Y) / surfacePart.Size.Y
				end

				if t14.Top.Y > t15.Top.Y then
					n11 = 1 - (t14.Top.Y - t15.Top.Y) / surfacePart.Size.Y
				end

				if n11 < 0 or n12 < 0 or n9 < 0 or n10 < 0 then
					surfaceGui.Enabled = false
				else
					local n13 = 1 - (1 - n9 + (1 - n10))
					local n14 = 1 - (1 - n11 + (1 - n12))
					local n15 = if n9 <= n10 then 1 else -1
					local n16 = if n11 >= n12 then 1 else -1
					local surfacePartSize = surfacePart.Size
					local vector3 = Vector3.new(n13, n14, 1)
					local n17 = surfacePartSize * vector3
					local n18

					if n10 < 1 and n9 < 1 then
						local n19 = (n10 - n9) * 2
						local n20 = (surfacePart.Size.X - n17.X) / 2 * n19
						local n21 = (t14.Right.X + t14.Left.X) / 2
						local n22 = (t15.Right.X + t15.Left.X) / 2
						local absoluteValue = math.abs(t15.Right.X - t15.Left.X)

						n18 = n20 - (n21 + n20 + n17.X - (n22 + absoluteValue))
						n15 = n19 / ((1 - (n10 + n9 - 1)) * 2)
					else
						n18 = (surfacePart.Size.X - n17.X) / 2 * n15
					end

					local n23

					if n11 < 1 and n12 < 1 then
						local n24 = (n11 - n12) * 2
						local n25 = (surfacePart.Size.Y - n17.Y) / 2 * n24
						local n26 = (t14.Top.Y + t14.Bottom.Y) / 2
						local n27 = (t15.Top.Y + t15.Bottom.Y) / 2
						local absoluteValue = math.abs(t15.Top.Y - t15.Bottom.Y)

						n23 = n25 - (n26 + n25 + n17.Y - (n27 + absoluteValue))
						n16 = n24 / ((1 - (n11 + n12 - 1)) * 2)
					else
						n23 = (surfacePart.Size.Y - n17.Y) / 2 * n16
					end

					local surfacePartCFrame = surfacePart.CFrame
					local cFrame7 = CFrame.new(n18, n23, 0)

					surfacePart.CFrame = surfacePartCFrame * cFrame7
					surfacePart.Size = n17
					surfaceGui.ScaleFrame.Size = UDim2.new(1 / n13, 0, 1 / n14, 0)
					surfaceGui.ScaleFrame.Position = UDim2.new(0.5 - (1 - 1 / n13) / 2 * n15, 0, 0.5 - (1 - 1 / n14) / 2 * n16, 0)

					local n28 = 1

					if n6 > 1 then
						n28 = n6
					end

					local n29 = math.min((1 - (n1 + (1 - n6))) / (0.8 - (1 - n6)), 1) * n28

					if n29 < 0 then
						n29 = 1
					end

					local imageTransparency = t13.TextureTransparency + (t13.TextureTransparencyMin - t13.TextureTransparency) * n29
					local backgroundTransparency = t13.BackgroundTransparency + (t13.BackgroundTransparencyMin - t13.BackgroundTransparency) * n29
					local n32 = 1 / (n1 + (n6 - n1) * (t13.EffectRadiusMin / t13.EffectRadius))
					local surfacePartPosition = surfacePart.Position
					local v253 = surfacePartPosition:Dot(v192)
					local v254 = ToNormalSpace(iterFirst.CFrame, surfacePartPosition - v192 * v253, iterSecond2.SurfaceNormal)
					local n33 = (1 / n32 - 1) * 3 * n32
					local n34 = -(1 - n13) / 0.5 * n15
					local n35 = -(1 - n14) / 0.5 * n16
					local n36 = -t13.TextureOffset.X / t13.TextureSize.X * n32
					local n37 = t13.TextureSize.Y / t13.TextureSize.X
					local n38 = n37 - 1
					local n39 = -t13.TextureOffset.Y / t13.TextureSize.X * n32

					for iterFirst4, iterSecond4 in surfaceGui.ScaleFrame:GetChildren() do
						local imageLabel = iterSecond4.ScaleFrame.ImageLabel

						imageLabel.Image = t13.Texture
						imageLabel.ImageTransparency = imageTransparency
						imageLabel.ImageColor3 = t13.TextureColor
						imageLabel.BackgroundTransparency = backgroundTransparency
						imageLabel.BackgroundColor3 = t13.BackgroundColor

						local numberValue: number? = tonumber(iterSecond4.Name)
						local v266 = t3[numberValue]
						local n40 = n36 + (1 / n32 - 1) * n32 * v266.OffsetX + n34 + n33 + v254.X / (n7 / 2) * n32
						local n41 = n39 + (1 / n32 - 1) * n32 * v266.OffsetY + n35 + n33 + v254.Y / (n7 / 2) * n32
						local uDim2New = UDim2.new
						local v270 = math.max(0.111 * n32, 0.001)
						local v271 = math.max(0.111 * n32 * n37, 0.001)

						imageLabel.TileSize = uDim2New(v270, 0, v271, 0)

						if iterSecond4.Name == "1" or iterSecond4.Name == "2" or iterSecond4.Name == "3" or iterSecond4.Name == "4" then
							n41 -= n38 * n32
						elseif iterSecond4.Name == "9" or iterSecond4.Name == "10" or iterSecond4.Name == "11" or iterSecond4.Name == "12" then
							n41 += n38 * n32
						elseif iterSecond4.Name == "13" or iterSecond4.Name == "14" or iterSecond4.Name == "15" or iterSecond4.Name == "16" then
							n41 += n38 * n32 * 2
						end

						local v272 = UpdateTextureOffset(n40, n41, n32, n32 * n37)
						local n42 = 0
						local n43 = 0

						if v272.X.Scale > 4.5 then
							n42 = v272.X.Scale - 4.5
						elseif v272.X.Scale < -3.5 then
							n42 = v272.X.Scale + 3.5
						end

						if v272.Y.Scale > 4.5 then
							n43 = v272.Y.Scale - 4.5
						elseif v272.Y.Scale < -3.5 then
							n43 = v272.Y.Scale + 3.5
						end

						local vector2 = Vector2.new(-n42, -n43)

						if n43 < 0 then
							vector2 = if n1 < 0.125 then Vector2.new(vector2.X, -n43) else Vector2.new(vector2.X, 1 * n32)
						end

						if n42 < 0 then
							vector2 = if n1 < 0.125 then Vector2.new(-n42, vector2.Y) else Vector2.new(1 * n32, vector2.Y)
						end

						imageLabel.Position = UDim2.new(v272.X.Scale + vector2.X, 0, v272.Y.Scale + vector2.Y, 0)

						local t16: {[any]: any} = { 1, 4, 13, 16 }
						local tableFind = table.find
						local numberValue2: number? = tonumber(iterSecond4.Name)

						if tableFind({
							2,
							3,
							5,
							9,
							8,
							12,
							14,
							15
						}, numberValue2) then
							local ok, result = pcall(function()
								UpdateSideGradient(iterSecond4)
							end)
						elseif table.find(t16, (tonumber(iterSecond4.Name))) then
							local ok, result = pcall(function()
								UpdateCornerGradient(iterSecond4)
							end)
						end
					end
				end
			elseif v201 < t13.DistanceOuter then
				surfaceGui.Enabled = true

				local v283 = math.clamp((v201 - t13.DistanceInner) / (t13.DistanceOuter - t13.DistanceInner), 0, 1)

				n1 = n6 - v283

				do
					local n7 = t13.EffectRadius / n6
					local n8 = (t13.EffectRadiusMin + (t13.EffectRadius - t13.EffectRadiusMin) * n1 * (t13.TextureSize.X * 2 / t13.EffectRadius)) * 2

					surfacePart.Size = Vector3.new(n8, n8, surfacePart.Size.Z)

					local v211 = GetSidePositionsOfPartAlongNormal(surfacePart.Position, surfacePart.CFrame, Enum.NormalId.Front, surfacePart.Size)
					local v212 = ToNormalSpace(iterFirst.CFrame, n3.Left, iterSecond2.SurfaceNormal)
					local v213 = ToNormalSpace(iterFirst.CFrame, n3.Right, iterSecond2.SurfaceNormal)
					local v214 = ToNormalSpace(iterFirst.CFrame, n3.Top, iterSecond2.SurfaceNormal)
					local v215 = ToNormalSpace(iterFirst.CFrame, n3.Bottom, iterSecond2.SurfaceNormal)
					local v216 = ToNormalSpace(iterFirst.CFrame, v211.Left, iterSecond2.SurfaceNormal)
					local v217 = ToNormalSpace(iterFirst.CFrame, v211.Right, iterSecond2.SurfaceNormal)
					local v218 = ToNormalSpace(iterFirst.CFrame, v211.Top, iterSecond2.SurfaceNormal)
					local v219 = ToNormalSpace(iterFirst.CFrame, v211.Bottom, iterSecond2.SurfaceNormal)
					local n9 = 1
					local n10 = 1
					local t14: {[any]: any} = { Left = v216, Right = v217, Top = v218, Bottom = v219 }
					local t15: {[any]: any} = { Left = v212, Right = v213, Top = v214, Bottom = v215 }

					if t14.Left.X < t15.Left.X then
						n9 = 1 - (t15.Left.X - t14.Left.X) / surfacePart.Size.X
					end

					if t14.Right.X > t15.Right.X then
						n10 = 1 - (t14.Right.X - t15.Right.X) / surfacePart.Size.X
					end

					local n11 = 1
					local n12 = 1

					if t14.Bottom.Y < t15.Bottom.Y then
						n12 = 1 - (t15.Bottom.Y - t14.Bottom.Y) / surfacePart.Size.Y
					end

					if t14.Top.Y > t15.Top.Y then
						n11 = 1 - (t14.Top.Y - t15.Top.Y) / surfacePart.Size.Y
					end

					if n11 < 0 or n12 < 0 or n9 < 0 or n10 < 0 then
						surfaceGui.Enabled = false
					else
						local n13 = 1 - (1 - n9 + (1 - n10))
						local n14 = 1 - (1 - n11 + (1 - n12))
						local n15 = if n9 <= n10 then 1 else -1
						local n16 = if n11 >= n12 then 1 else -1
						local surfacePartSize = surfacePart.Size
						local vector3 = Vector3.new(n13, n14, 1)
						local n17 = surfacePartSize * vector3
						local n18

						if n10 < 1 and n9 < 1 then
							local n19 = (n10 - n9) * 2
							local n20 = (surfacePart.Size.X - n17.X) / 2 * n19
							local n21 = (t14.Right.X + t14.Left.X) / 2
							local n22 = (t15.Right.X + t15.Left.X) / 2
							local absoluteValue = math.abs(t15.Right.X - t15.Left.X)

							n18 = n20 - (n21 + n20 + n17.X - (n22 + absoluteValue))
							n15 = n19 / ((1 - (n10 + n9 - 1)) * 2)
						else
							n18 = (surfacePart.Size.X - n17.X) / 2 * n15
						end

						local n23

						if n11 < 1 and n12 < 1 then
							local n24 = (n11 - n12) * 2
							local n25 = (surfacePart.Size.Y - n17.Y) / 2 * n24
							local n26 = (t14.Top.Y + t14.Bottom.Y) / 2
							local n27 = (t15.Top.Y + t15.Bottom.Y) / 2
							local absoluteValue = math.abs(t15.Top.Y - t15.Bottom.Y)

							n23 = n25 - (n26 + n25 + n17.Y - (n27 + absoluteValue))
							n16 = n24 / ((1 - (n11 + n12 - 1)) * 2)
						else
							n23 = (surfacePart.Size.Y - n17.Y) / 2 * n16
						end

						local surfacePartCFrame = surfacePart.CFrame
						local cFrame7 = CFrame.new(n18, n23, 0)

						surfacePart.CFrame = surfacePartCFrame * cFrame7
						surfacePart.Size = n17
						surfaceGui.ScaleFrame.Size = UDim2.new(1 / n13, 0, 1 / n14, 0)
						surfaceGui.ScaleFrame.Position = UDim2.new(0.5 - (1 - 1 / n13) / 2 * n15, 0, 0.5 - (1 - 1 / n14) / 2 * n16, 0)

						local n28 = 1

						if n6 > 1 then
							n28 = n6
						end

						local n29 = math.min((1 - (n1 + (1 - n6))) / (0.8 - (1 - n6)), 1) * n28

						if n29 < 0 then
							n29 = 1
						end

						local imageTransparency = t13.TextureTransparency + (t13.TextureTransparencyMin - t13.TextureTransparency) * n29
						local backgroundTransparency = t13.BackgroundTransparency + (t13.BackgroundTransparencyMin - t13.BackgroundTransparency) * n29
						local n32 = 1 / (n1 + (n6 - n1) * (t13.EffectRadiusMin / t13.EffectRadius))
						local surfacePartPosition = surfacePart.Position
						local v253 = surfacePartPosition:Dot(v192)
						local v254 = ToNormalSpace(iterFirst.CFrame, surfacePartPosition - v192 * v253, iterSecond2.SurfaceNormal)
						local n33 = (1 / n32 - 1) * 3 * n32
						local n34 = -(1 - n13) / 0.5 * n15
						local n35 = -(1 - n14) / 0.5 * n16
						local n36 = -t13.TextureOffset.X / t13.TextureSize.X * n32
						local n37 = t13.TextureSize.Y / t13.TextureSize.X
						local n38 = n37 - 1
						local n39 = -t13.TextureOffset.Y / t13.TextureSize.X * n32

						for iterFirst4, iterSecond4 in surfaceGui.ScaleFrame:GetChildren() do
							local imageLabel = iterSecond4.ScaleFrame.ImageLabel

							imageLabel.Image = t13.Texture
							imageLabel.ImageTransparency = imageTransparency
							imageLabel.ImageColor3 = t13.TextureColor
							imageLabel.BackgroundTransparency = backgroundTransparency
							imageLabel.BackgroundColor3 = t13.BackgroundColor

							local numberValue: number? = tonumber(iterSecond4.Name)
							local v266 = t3[numberValue]
							local n40 = n36 + (1 / n32 - 1) * n32 * v266.OffsetX + n34 + n33 + v254.X / (n7 / 2) * n32
							local n41 = n39 + (1 / n32 - 1) * n32 * v266.OffsetY + n35 + n33 + v254.Y / (n7 / 2) * n32
							local uDim2New = UDim2.new
							local v270 = math.max(0.111 * n32, 0.001)
							local v271 = math.max(0.111 * n32 * n37, 0.001)

							imageLabel.TileSize = uDim2New(v270, 0, v271, 0)

							if iterSecond4.Name == "1" or iterSecond4.Name == "2" or iterSecond4.Name == "3" or iterSecond4.Name == "4" then
								n41 -= n38 * n32
							elseif iterSecond4.Name == "9" or iterSecond4.Name == "10" or iterSecond4.Name == "11" or iterSecond4.Name == "12" then
								n41 += n38 * n32
							elseif iterSecond4.Name == "13" or iterSecond4.Name == "14" or iterSecond4.Name == "15" or iterSecond4.Name == "16" then
								n41 += n38 * n32 * 2
							end

							local v272 = UpdateTextureOffset(n40, n41, n32, n32 * n37)
							local n42 = 0
							local n43 = 0

							if v272.X.Scale > 4.5 then
								n42 = v272.X.Scale - 4.5
							elseif v272.X.Scale < -3.5 then
								n42 = v272.X.Scale + 3.5
							end

							if v272.Y.Scale > 4.5 then
								n43 = v272.Y.Scale - 4.5
							elseif v272.Y.Scale < -3.5 then
								n43 = v272.Y.Scale + 3.5
							end

							local vector2 = Vector2.new(-n42, -n43)

							if n43 < 0 then
								vector2 = if n1 < 0.125 then Vector2.new(vector2.X, -n43) else Vector2.new(vector2.X, 1 * n32)
							end

							if n42 < 0 then
								vector2 = if n1 < 0.125 then Vector2.new(-n42, vector2.Y) else Vector2.new(1 * n32, vector2.Y)
							end

							imageLabel.Position = UDim2.new(v272.X.Scale + vector2.X, 0, v272.Y.Scale + vector2.Y, 0)

							local t16: {[any]: any} = { 1, 4, 13, 16 }
							local tableFind = table.find
							local numberValue2: number? = tonumber(iterSecond4.Name)

							if tableFind({
								2,
								3,
								5,
								9,
								8,
								12,
								14,
								15
							}, numberValue2) then
								local ok, result = pcall(function()
									UpdateSideGradient(iterSecond4)
								end)
							elseif table.find(t16, (tonumber(iterSecond4.Name))) then
								local ok, result = pcall(function()
									UpdateCornerGradient(iterSecond4)
								end)
							end
						end
					end
				end
			else
				surfaceGui.Enabled = false
			end
		end
	end
end

return module
