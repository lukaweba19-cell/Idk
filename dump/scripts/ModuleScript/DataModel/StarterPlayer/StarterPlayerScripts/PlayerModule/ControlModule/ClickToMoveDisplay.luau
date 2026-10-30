-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local s1 = "rbxasset://textures/ui/traildot.png"
local s2 = "rbxasset://textures/ui/waypoint.png"
local u3 = false
local uDim2 = UDim2.new(0, 42, 0, 50)
local vector2 = Vector2.new(0, 0.5)
local vector22 = Vector2.new(0, 1)
local vector23 = Vector2.new(0, 0.5)
local vector24 = Vector2.new(0.1, 0.5)
local vector25 = Vector2.new(-0.1, 0.5)
local vector26 = Vector2.new(1.5, 1.5)
local raycastParams = RaycastParams.new()

raycastParams.FilterType = Enum.RaycastFilterType.Exclude

local players: Players = game:GetService("Players")
local tweenService: TweenService = game:GetService("TweenService")
local runService: RunService = game:GetService("RunService")
local workspace: Workspace = game:GetService("Workspace")
local commonUtils: Instance = script.Parent.Parent:WaitForChild("CommonUtils")
local v17 = require(commonUtils:WaitForChild("FlagUtil")).getUserFlag("UserRaycastUpdateAPI2")
local LocalPlayer: Player = players.LocalPlayer

local function CreateWaypointTemplates()
	local trailDot: Part = Instance.new("Part")

	trailDot.Size = Vector3.new(1, 1, 1)
	trailDot.Anchored = true
	trailDot.CanCollide = false
	trailDot.Name = "TrailDot"
	trailDot.Transparency = 1

	local trailDotImage: ImageHandleAdornment = Instance.new("ImageHandleAdornment")

	trailDotImage.Name = "TrailDotImage"
	trailDotImage.Size = vector26
	trailDotImage.SizeRelativeOffset = Vector3.new(0, 0, -0.1)
	trailDotImage.AlwaysOnTop = u3
	trailDotImage.Image = s1
	trailDotImage.Adornee = trailDot
	trailDotImage.Parent = trailDot

	local endWaypoint: Part = Instance.new("Part")

	endWaypoint.Size = Vector3.new(2, 2, 2)
	endWaypoint.Anchored = true
	endWaypoint.CanCollide = false
	endWaypoint.Name = "EndWaypoint"
	endWaypoint.Transparency = 1

	local imageHandleAdornment: ImageHandleAdornment = Instance.new("ImageHandleAdornment")

	imageHandleAdornment.Name = "TrailDotImage"
	imageHandleAdornment.Size = vector26
	imageHandleAdornment.SizeRelativeOffset = Vector3.new(0, 0, -0.1)
	imageHandleAdornment.AlwaysOnTop = u3
	imageHandleAdornment.Image = s1
	imageHandleAdornment.Adornee = endWaypoint
	imageHandleAdornment.Parent = endWaypoint

	local endWaypointBillboard: BillboardGui = Instance.new("BillboardGui")

	endWaypointBillboard.Name = "EndWaypointBillboard"
	endWaypointBillboard.Size = uDim2
	endWaypointBillboard.LightInfluence = 0
	endWaypointBillboard.SizeOffset = vector2
	endWaypointBillboard.AlwaysOnTop = true
	endWaypointBillboard.Adornee = endWaypoint
	endWaypointBillboard.Parent = endWaypoint

	local imageLabel: ImageLabel = Instance.new("ImageLabel")

	imageLabel.Image = s2
	imageLabel.BackgroundTransparency = 1
	imageLabel.Size = UDim2.new(1, 0, 1, 0)
	imageLabel.Parent = endWaypointBillboard

	local failureWaypoint: Part = Instance.new("Part")

	failureWaypoint.Size = Vector3.new(2, 2, 2)
	failureWaypoint.Anchored = true
	failureWaypoint.CanCollide = false
	failureWaypoint.Name = "FailureWaypoint"
	failureWaypoint.Transparency = 1

	local imageHandleAdornment2: ImageHandleAdornment = Instance.new("ImageHandleAdornment")

	imageHandleAdornment2.Name = "TrailDotImage"
	imageHandleAdornment2.Size = vector26
	imageHandleAdornment2.SizeRelativeOffset = Vector3.new(0, 0, -0.1)
	imageHandleAdornment2.AlwaysOnTop = u3
	imageHandleAdornment2.Image = s1
	imageHandleAdornment2.Adornee = failureWaypoint
	imageHandleAdornment2.Parent = failureWaypoint

	local failureWaypointBillboard: BillboardGui = Instance.new("BillboardGui")

	failureWaypointBillboard.Name = "FailureWaypointBillboard"
	failureWaypointBillboard.Size = uDim2
	failureWaypointBillboard.LightInfluence = 0
	failureWaypointBillboard.SizeOffset = vector23
	failureWaypointBillboard.AlwaysOnTop = true
	failureWaypointBillboard.Adornee = failureWaypoint
	failureWaypointBillboard.Parent = failureWaypoint

	local frame: Frame = Instance.new("Frame")

	frame.BackgroundTransparency = 1
	frame.Size = UDim2.new(0, 0, 0, 0)
	frame.Position = UDim2.new(0.5, 0, 1, 0)
	frame.Parent = failureWaypointBillboard

	local imageLabel2: ImageLabel = Instance.new("ImageLabel")

	imageLabel2.Image = s2
	imageLabel2.BackgroundTransparency = 1
	imageLabel2.Position = UDim2.new(0, -uDim2.X.Offset / 2, 0, -uDim2.Y.Offset)
	imageLabel2.Size = uDim2
	imageLabel2.Parent = frame

	return trailDot, endWaypoint, failureWaypoint
end

local u20, u21, u22 = CreateWaypointTemplates()

local function getTrailDotParent()
	local CurrentCamera: Camera = workspace.CurrentCamera
	local clickToMoveDisplay = CurrentCamera:FindFirstChild("ClickToMoveDisplay")

	if not clickToMoveDisplay then
		clickToMoveDisplay = Instance.new("Model")
		clickToMoveDisplay.Name = "ClickToMoveDisplay"
		clickToMoveDisplay.Parent = CurrentCamera
	end

	return clickToMoveDisplay
end
local function placePathWaypoint(p1, p2)
	if v17 then
		raycastParams.FilterDescendantsInstances = { workspace.CurrentCamera, LocalPlayer.Character }

		local v51 = workspace:Raycast(p2 + Vector3.new(0, 2.5, 0), Vector3.new(-0, -10, -0), raycastParams)

		if v51 then
			p1.CFrame = CFrame.lookAlong(v51.Position, v51.Normal)

			local CurrentCamera: Camera = workspace.CurrentCamera
			local clickToMoveDisplay = CurrentCamera:FindFirstChild("ClickToMoveDisplay")

			if not clickToMoveDisplay then
				clickToMoveDisplay = Instance.new("Model")
				clickToMoveDisplay.Name = "ClickToMoveDisplay"
				clickToMoveDisplay.Parent = CurrentCamera
			end

			p1.Parent = clickToMoveDisplay

			return
		end
	else
		local ray = Ray.new(p2 + Vector3.new(0, 2.5, 0), Vector3.new(0, -10, 0))
		local v55, v56, v57 = workspace:FindPartOnRayWithIgnoreList(ray, { workspace.CurrentCamera, LocalPlayer.Character })

		if v55 then
			p1.CFrame = CFrame.new(v56, v56 + v57)

			local CurrentCamera: Camera = workspace.CurrentCamera
			local clickToMoveDisplay = CurrentCamera:FindFirstChild("ClickToMoveDisplay")

			if not clickToMoveDisplay then
				clickToMoveDisplay = Instance.new("Model")
				clickToMoveDisplay.Name = "ClickToMoveDisplay"
				clickToMoveDisplay.Parent = CurrentCamera
			end

			p1.Parent = clickToMoveDisplay
		end
	end
end

local t1: {[any]: any} = {}

t1.__index = t1

function t1.Destroy(p3)
	p3.DisplayModel:Destroy()
end
function t1.NewDisplayModel(_, p5)
	local clone = u20:Clone()

	placePathWaypoint(clone, p5)

	return clone
end
function t1.new(p6, closestWayPoint)
	local object = setmetatable({}, t1)

	object.DisplayModel = object:NewDisplayModel(p6)
	object.ClosestWayPoint = closestWayPoint

	return object
end

local t2: {[any]: any} = {}

t2.__index = t2

function t2.Destroy(p8)
	p8.Destroyed = true
	p8.Tween:Cancel()
	p8.DisplayModel:Destroy()
end
function t2.NewDisplayModel(_, p10)
	local clone = u21:Clone()

	placePathWaypoint(clone, p10)

	return clone
end
function t2.CreateTween(p11)
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, -1, true)
	local v73: Tween = tweenService:Create(p11.DisplayModel.EndWaypointBillboard, tweenInfo, { SizeOffset = vector22 })

	v73:Play()

	return v73
end
function t2.TweenInFrom(p12, p13)
	p12.DisplayModel.EndWaypointBillboard.StudsOffset = Vector3.new(0, (p13 - p12.DisplayModel.Position).Y, 0)

	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local v77: Tween = tweenService:Create(p12.DisplayModel.EndWaypointBillboard, tweenInfo, { StudsOffset = Vector3.new(0, 0, 0) })

	v77:Play()

	return v77
end
function t2.new(p14, closestWayPoint, p16)
	local object = setmetatable({}, t2)

	object.DisplayModel = object:NewDisplayModel(p14)
	object.Destroyed = false

	if p16 and (p16 - p14).Magnitude > 5 then
		object.Tween = object:TweenInFrom(p16)
		coroutine.wrap(function()
			object.Tween.Completed:Wait()

			if not object.Destroyed then
				object.Tween = object:CreateTween()
			end
		end)()
	else
		object.Tween = object:CreateTween()
	end

	object.ClosestWayPoint = closestWayPoint

	return object
end

local t3: {[any]: any} = {}

t3.__index = t3

function t3.Hide(p17)
	p17.DisplayModel.Parent = nil
end
function t3.Destroy(p18)
	p18.DisplayModel:Destroy()
end
function t3.NewDisplayModel(_, p20)
	local clone = u22:Clone()

	placePathWaypoint(clone, p20)

	if v17 then
		raycastParams.FilterDescendantsInstances = { workspace.CurrentCamera, LocalPlayer.Character }

		local v87 = workspace:Raycast(p20 + Vector3.new(0, 2.5, 0), Vector3.new(-0, -10, -0), raycastParams)

		if v87 then
			clone.CFrame = CFrame.lookAlong(v87.Position, v87.Normal)

			local CurrentCamera: Camera = workspace.CurrentCamera
			local clickToMoveDisplay = CurrentCamera:FindFirstChild("ClickToMoveDisplay")

			if not clickToMoveDisplay then
				clickToMoveDisplay = Instance.new("Model")
				clickToMoveDisplay.Name = "ClickToMoveDisplay"
				clickToMoveDisplay.Parent = CurrentCamera
			end

			clone.Parent = clickToMoveDisplay

			return clone
		end
	else
		local ray = Ray.new(p20 + Vector3.new(0, 2.5, 0), Vector3.new(0, -10, 0))
		local v91, v92, v93 = workspace:FindPartOnRayWithIgnoreList(ray, { workspace.CurrentCamera, LocalPlayer.Character })

		if v91 then
			clone.CFrame = CFrame.new(v92, v92 + v93)

			local CurrentCamera: Camera = workspace.CurrentCamera
			local clickToMoveDisplay = CurrentCamera:FindFirstChild("ClickToMoveDisplay")

			if not clickToMoveDisplay then
				clickToMoveDisplay = Instance.new("Model")
				clickToMoveDisplay.Name = "ClickToMoveDisplay"
				clickToMoveDisplay.Parent = CurrentCamera
			end

			clone.Parent = clickToMoveDisplay
		end
	end

	return clone
end
function t3.RunFailureTween(p21)
	wait(0.125)

	local tweenInfo = TweenInfo.new(0.0625, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local v98: Tween = tweenService:Create(p21.DisplayModel.FailureWaypointBillboard, tweenInfo, { SizeOffset = vector24 })

	v98:Play()
	tweenService:Create(p21.DisplayModel.FailureWaypointBillboard.Frame, tweenInfo, { Rotation = 10 }):Play()
	v98.Completed:wait()

	local tweenInfo2 = TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 3, true)
	local v100: Tween = tweenService:Create(p21.DisplayModel.FailureWaypointBillboard, tweenInfo2, { SizeOffset = vector25 })

	v100:Play()

	local tweenInfo3 = TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 3, true)

	tweenService:Create(p21.DisplayModel.FailureWaypointBillboard.Frame.ImageLabel, tweenInfo3, { ImageColor3 = Color3.new(0.75, 0.75, 0.75) }):Play()
	tweenService:Create(p21.DisplayModel.FailureWaypointBillboard.Frame, tweenInfo3, { Rotation = -10 }):Play()
	v100.Completed:wait()

	local tweenInfo4 = TweenInfo.new(0.0625, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

	v100 = tweenService:Create(p21.DisplayModel.FailureWaypointBillboard, tweenInfo4, { SizeOffset = vector23 })
	v100:Play()
	tweenService:Create(p21.DisplayModel.FailureWaypointBillboard.Frame, tweenInfo4, { Rotation = 0 }):Play()
	v100.Completed:wait()
	wait(0.125)
end
function t3.new(p22)
	local object = setmetatable({}, t3)

	object.DisplayModel = object:NewDisplayModel(p22)

	return object
end

local animation: Animation = Instance.new("Animation")

animation.AnimationId = "rbxassetid://2874840706"

local u29 = nil

local function getFailureAnimationTrack(p23)
	if p23 == nil then
		return u29
	end

	u29 = p23:LoadAnimation(animation)
	assert(u29, "")
	u29.Priority = Enum.AnimationPriority.Action
	u29.Looped = false

	return u29
end
local function findPlayerHumanoid()
	local Character: Model = LocalPlayer.Character

	if Character then
		return Character:FindFirstChildOfClass("Humanoid")
	end
end
local function createTrailDots(p24, p25)
	local t4: {[any]: any} = {}
	local n1: number = 1

	for i = 1, #p24 - 1 do
		if i % 2 == 0 and not ((p24[i].Position - p24[#p24].Position).Magnitude < 3) then
			t4[n1] = t1.new(p24[i].Position, i)
			n1 += 1
		end
	end

	local v112 = t2.new(p24[#p24].Position, #p24, p25)

	table.insert(t4, v112)
	v112 = {}
	n1 = 1

	for i = #t4, 1, -1 do
		v112[n1] = t4[i]
		n1 += 1
	end

	return v112
end
local function getTrailDotScale(p26, p27)
	local v116 = math.clamp(p26 - 10, 0, 90)

	return p27 * (v116 / 90 * 1.5 + 1)
end

local n1: number = 0

local function CreatePathDisplay(p28, p29)
	n1 += 1

	local v119 = createTrailDots(p28, p29)

	local function removePathBeforePoint(p30)
		for i = #v119, 1, -1 do
			local v146 = v119[i]

			if not (p30 >= v146.ClosestWayPoint) then
				break
			end

			v146:Destroy()
			v119[i] = nil
		end
	end

	local s1: string = "ClickToMoveResizeTrail" .. n1

	runService:BindToRenderStep(s1, Enum.RenderPriority.Camera.Value - 1, function()
		if #v119 == 0 then
			runService:UnbindFromRenderStep(s1)

			return
		end

		local p = workspace.CurrentCamera.CFrame.p

		for i = 1, #v119 do
			local trailDotImage = v119[i].DisplayModel:FindFirstChild("TrailDotImage")

			if trailDotImage then
				local v150 = vector26
				local v151 = math.clamp((v119[i].DisplayModel.Position - p).Magnitude - 10, 0, 90)

				trailDotImage.Size = v150 * (v151 / 90 * 1.5 + 1)
			end
		end
	end)

	return function()
		removePathBeforePoint(#p28)
	end, removePathBeforePoint
end

CreatePathDisplay = nil

return {
	CreatePathDisplay = CreatePathDisplay,
	DisplayFailureWaypoint = function(p31)
		if CreatePathDisplay then
			CreatePathDisplay:Hide()
		end

		local u123 = t3.new(p31)

		CreatePathDisplay = u123
		coroutine.wrap(function()
			u123:RunFailureTween()
			u123:Destroy()
			u123 = nil
		end)()
	end,
	CreateEndWaypoint = function(p32)
		return t2.new(p32)
	end,
	PlayFailureAnimation = function()
		local Character: Model = LocalPlayer.Character
		local humanoid = if Character then Character:FindFirstChildOfClass("Humanoid") else nil

		if humanoid then
			local v127

			if humanoid == nil then
			else
				u29 = humanoid:LoadAnimation(animation)
				assert(u29, "")
				u29.Priority = Enum.AnimationPriority.Action
				u29.Looped = false
			end

			v127 = u29
			v127:Play()
		end
	end,
	CancelFailureAnimation = function()
		if u29 ~= nil and u29.IsPlaying then
			u29:Stop()
		end
	end,
	SetWaypointTexture = function(p33)
		s1 = p33

		local v129, v130, v131 = CreateWaypointTemplates()

		u20 = v129
		u21 = v130
		u22 = v131
	end,
	GetWaypointTexture = function()
		return s1
	end,
	SetWaypointRadius = function(p34)
		vector26 = Vector2.new(p34, p34)

		local v133, v134, v135 = CreateWaypointTemplates()

		u20 = v133
		u21 = v134
		u22 = v135
	end,
	GetWaypointRadius = function()
		return vector26.X
	end,
	SetEndWaypointTexture = function(p35)
		s2 = p35

		local v137, v138, v139 = CreateWaypointTemplates()

		u20 = v137
		u21 = v138
		u22 = v139
	end,
	GetEndWaypointTexture = function()
		return s2
	end,
	SetWaypointsAlwaysOnTop = function(p36)
		u3 = p36

		local v141, v142, v143 = CreateWaypointTemplates()

		u20 = v141
		u21 = v142
		u22 = v143
	end,
	GetWaypointsAlwaysOnTop = function()
		return u3
	end
}
