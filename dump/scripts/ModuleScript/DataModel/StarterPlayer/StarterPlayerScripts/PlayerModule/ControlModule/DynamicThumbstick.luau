-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local HighValue = Enum.ContextActionPriority.High.Value
local t1: {[any]: any} = {
	0.10999999999999999,
	0.30000000000000004,
	0.4,
	0.5,
	0.6,
	0.7,
	0.75
}
local n1: number = #t1
local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local players: Players = game:GetService("Players")
local guiService: GuiService = game:GetService("GuiService")
local userInputService: UserInputService = game:GetService("UserInputService")
local contextActionService: ContextActionService = game:GetService("ContextActionService")
local runService: RunService = game:GetService("RunService")
local tweenService: TweenService = game:GetService("TweenService")
local commonUtils: Instance = script.Parent.Parent:WaitForChild("CommonUtils")
local v12 = require(commonUtils:WaitForChild("FlagUtil")).getUserFlag("UserPlayerScriptsCanUseLCC")

local ok, result = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickSafeAreaUpdate")
end)

local u15 = ok and result
local avatarAbilitiesInterface = nil

if v12 then
	avatarAbilitiesInterface = require(script.Parent:WaitForChild("AvatarAbilitiesInterface"))
end

local LocalPlayer: Player = players.LocalPlayer

if not LocalPlayer then
	players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = players.LocalPlayer
end

local baseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"))
local object = setmetatable({}, baseCharacterController)

object.__index = object

function object.new()
	local v20 = baseCharacterController.new()
	local object2 = setmetatable(v20, object)

	object2.moveTouchObject = nil
	object2.moveTouchLockedIn = false
	object2.moveTouchFirstChanged = false
	object2.moveTouchStartPosition = nil
	object2.startImage = nil
	object2.endImage = nil
	object2.middleImages = {}
	object2.startImageFadeTween = nil
	object2.endImageFadeTween = nil
	object2.middleImageFadeTweens = {}
	object2.isFirstTouch = true
	object2.thumbstickFrame = nil
	object2.onRenderSteppedConn = nil
	object2.fadeInAndOutBalance = 0.5
	object2.fadeInAndOutHalfDuration = 0.3
	object2.hasFadedBackgroundInPortrait = false
	object2.hasFadedBackgroundInLandscape = false
	object2.tweenInAlphaStart = nil
	object2.tweenOutAlphaStart = nil

	return object2
end
function object.GetIsJumping(p1)
	local isJumping = p1.isJumping

	p1.isJumping = false

	return isJumping
end
function object.Enable(p2, p3, p4)
	if p3 == nil then
		return false
	end

	local u27: boolean = if p3 then true else false

	if p2.enabled == u27 then
		return true
	end

	if u27 then
		if not p2.thumbstickFrame then
			p2:Create(p4)
		end

		p2:BindContextActions()
	else
		p2:UnbindContextActions()
		p2:OnInputEnded()
	end

	p2.enabled = u27
	p2.thumbstickFrame.Visible = u27

	return nil
end
function object.OnInputEnded(p5)
	p5.moveTouchObject = nil
	p5.moveVector = Vector3.new(0, 0, 0)
	p5:FadeThumbstick(false)
end
function object.FadeThumbstick(p6, p7)
	if not p7 and p6.moveTouchObject then
		return
	end

	if p6.isFirstTouch then
		return
	end

	if p6.startImageFadeTween then
		p6.startImageFadeTween:Cancel()
	end

	if p6.endImageFadeTween then
		p6.endImageFadeTween:Cancel()
	end

	for i = 1, #p6.middleImages do
		if p6.middleImageFadeTweens[i] then
			p6.middleImageFadeTweens[i]:Cancel()
		end
	end

	if p7 then
		p6.startImageFadeTween = tweenService:Create(p6.startImage, tweenInfo, { ImageTransparency = 0 })
		p6.startImageFadeTween:Play()
		p6.endImageFadeTween = tweenService:Create(p6.endImage, tweenInfo, { ImageTransparency = 0.2 })
		p6.endImageFadeTween:Play()

		for i = 1, #p6.middleImages do
			p6.middleImageFadeTweens[i] = tweenService:Create(p6.middleImages[i], tweenInfo, { ImageTransparency = t1[i] })
			p6.middleImageFadeTweens[i]:Play()
		end
	else
		p6.startImageFadeTween = tweenService:Create(p6.startImage, tweenInfo, { ImageTransparency = 1 })
		p6.startImageFadeTween:Play()
		p6.endImageFadeTween = tweenService:Create(p6.endImage, tweenInfo, { ImageTransparency = 1 })
		p6.endImageFadeTween:Play()

		for i = 1, #p6.middleImages do
			p6.middleImageFadeTweens[i] = tweenService:Create(p6.middleImages[i], tweenInfo, { ImageTransparency = 1 })
			p6.middleImageFadeTweens[i]:Play()
		end
	end
end
function object.FadeThumbstickFrame(p8, p9, p10)
	p8.fadeInAndOutHalfDuration = p9 * 0.5
	p8.fadeInAndOutBalance = p10
	p8.tweenInAlphaStart = tick()
end
function object.InputInFrame(p11, p12)
	local absolutePosition = p11.thumbstickFrame.AbsolutePosition
	local n1 = absolutePosition + p11.thumbstickFrame.AbsoluteSize
	local v41 = p12.Position

	if v41.X >= absolutePosition.X and v41.Y >= absolutePosition.Y and v41.X <= n1.X and v41.Y <= n1.Y then
		return true
	end

	return false
end
function object.DoFadeInBackground(p13)
	local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local u44 = false

	if playerGui then
		if playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft or playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight then
			u44 = p13.hasFadedBackgroundInLandscape
			p13.hasFadedBackgroundInLandscape = true
		elseif playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait then
			u44 = p13.hasFadedBackgroundInPortrait
			p13.hasFadedBackgroundInPortrait = true
		end
	end

	if not u44 then
		p13.fadeInAndOutHalfDuration = 0.3
		p13.fadeInAndOutBalance = 0.5
		p13.tweenInAlphaStart = tick()
	end
end
function object.DoMove(p14, p15)
	local v47 = p15
	local vectorValue

	if v47.Magnitude < p14.radiusOfDeadZone then
		vectorValue = Vector3.new(0, 0, 0)
	else
		local unit = v47.Unit
		local v51 = math.max(0, (p14.radiusOfMaxSpeed - v47.Magnitude) / p14.radiusOfMaxSpeed)
		local n1 = unit * (1 - v51)

		vectorValue = Vector3.new(n1.X, 0, n1.Y)
	end

	p14.moveVector = vectorValue
end
function object.LayoutMiddleImages(p16, p17, p18)
	local n6 = p16.thumbstickSize / 2 + p16.middleSize
	local n2 = p18 - p17
	local n3 = n2.Magnitude - p16.thumbstickRingSize / 2 - p16.middleSize
	local unit = n2.Unit
	local v59 = p16.middleSpacing

	if p16.middleSpacing * n1 < n3 then
		v59 = n3 / n1
	end

	for i = 1, n1 do
		local v61 = p16.middleImages[i]
		local n4 = n6 + v59 * (i - 1)

		if n3 > n6 + v59 * (i - 2) then
			local n5 = p18 - unit * n4
			local v64 = math.clamp(1 - (n4 - n3) / v59, 0, 1)

			v61.Visible = true
			v61.Position = UDim2.new(0, n5.X, 0, n5.Y)
			v61.Size = UDim2.new(0, p16.middleSize * v64, 0, p16.middleSize * v64)
		else
			v61.Visible = false
		end
	end
end
function object.MoveStick(p19, p20)
	local n1 = Vector2.new(p19.moveTouchStartPosition.X, p19.moveTouchStartPosition.Y) - p19.thumbstickFrame.AbsolutePosition
	local n2 = Vector2.new(p20.X, p20.Y) - p19.thumbstickFrame.AbsolutePosition

	p19.endImage.Position = UDim2.new(0, n2.X, 0, n2.Y)
	p19:LayoutMiddleImages(n1, n2)
end
function object.BindContextActions(p21)
	local function inputBegan(p22)
		if p21.moveTouchObject then
			return Enum.ContextActionResult.Pass
		end

		if not p21:InputInFrame(p22) then
			return Enum.ContextActionResult.Pass
		end

		if p21.isFirstTouch then
			p21.isFirstTouch = false

			local tweenInfo2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)

			tweenService:Create(p21.startImage, tweenInfo2, { Size = UDim2.new(0, 0, 0, 0) }):Play()

			local endImage = p21.endImage
			local uDim2 = UDim2.new(0, p21.thumbstickSize, 0, p21.thumbstickSize)

			tweenService:Create(endImage, tweenInfo2, { Size = uDim2, ImageColor3 = Color3.new(0, 0, 0) }):Play()
		end

		p21.moveTouchLockedIn = false
		p21.moveTouchObject = p22
		p21.moveTouchStartPosition = p22.Position
		p21.moveTouchFirstChanged = true
		p21:DoFadeInBackground()

		return Enum.ContextActionResult.Pass
	end
	local function inputChanged(p23)
		if p23 == p21.moveTouchObject then
			if p21.moveTouchFirstChanged then
				p21.moveTouchFirstChanged = false

				local vector2 = Vector2.new(p23.Position.X - p21.thumbstickFrame.AbsolutePosition.X, p23.Position.Y - p21.thumbstickFrame.AbsolutePosition.Y)

				p21.startImage.Visible = true
				p21.startImage.Position = UDim2.new(0, vector2.X, 0, vector2.Y)
				p21.endImage.Visible = true
				p21.endImage.Position = p21.startImage.Position
				p21:FadeThumbstick(true)
				p21:MoveStick(p23.Position)
			end

			p21.moveTouchLockedIn = true

			local vector2 = Vector2.new(p23.Position.X - p21.moveTouchStartPosition.X, p23.Position.Y - p21.moveTouchStartPosition.Y)

			if math.abs(vector2.X) > 0 or math.abs(vector2.Y) > 0 then
				p21:DoMove(vector2)
				p21:MoveStick(p23.Position)
			end

			return Enum.ContextActionResult.Sink
		end

		return Enum.ContextActionResult.Pass
	end
	local function inputEnded(p24)
		if p24 == p21.moveTouchObject then
			p21:OnInputEnded()

			if p21.moveTouchLockedIn then
				return Enum.ContextActionResult.Sink
			end

			return Enum.ContextActionResult.Pass
		end

		return Enum.ContextActionResult.Pass
	end

	contextActionService:BindActionAtPriority("DynamicThumbstickAction", function(_, p26, p27)
		if p26 == Enum.UserInputState.Begin then
			return (inputBegan(p27))
		end

		if p26 ~= Enum.UserInputState.Change then
			if p26 ~= Enum.UserInputState.End then
				if p26 == Enum.UserInputState.Cancel then
					p21:OnInputEnded()
				end

				return
			end

			if p27 == p21.moveTouchObject then
				p21:OnInputEnded()

				if p21.moveTouchLockedIn then
					return Enum.ContextActionResult.Sink
				end

				return Enum.ContextActionResult.Pass
			end

			return Enum.ContextActionResult.Pass
		end

		if p27 == p21.moveTouchObject then
			return Enum.ContextActionResult.Sink
		end

		return Enum.ContextActionResult.Pass
	end, false, HighValue, Enum.UserInputType.Touch)
	p21.TouchMovedCon = userInputService.TouchMoved:Connect(function(touch: InputObject, gameProcessedEvent: boolean)
		inputChanged(touch)
	end)
end
function object.UnbindContextActions(p30)
	contextActionService:UnbindAction("DynamicThumbstickAction")

	if p30.TouchMovedCon then
		p30.TouchMovedCon:Disconnect()
	end
end
function object.Create(p31, parent)
	if p31.thumbstickFrame then
		p31.thumbstickFrame:Destroy()
		p31.thumbstickFrame = nil

		if p31.onRenderSteppedConn then
			p31.onRenderSteppedConn:Disconnect()
			p31.onRenderSteppedConn = nil
		end

		if p31.absoluteSizeChangedConn then
			p31.absoluteSizeChangedConn:Disconnect()
			p31.absoluteSizeChangedConn = nil
		end

		if v12 and p31.avatarAbilitiesEnabledChangedConn then
			p31.avatarAbilitiesEnabledChangedConn:Disconnect()
			p31.avatarAbilitiesEnabledChangedConn = nil
		end
	end

	local n2: number = if u15 then 100 else 0

	local function layoutThumbstickFrame(p33)
		if p33 then
			p31.thumbstickFrame.Size = UDim2.new(1, n2, 0.4, n2)
			p31.thumbstickFrame.Position = UDim2.new(0, -n2, 0.6, 0)

			return
		end

		p31.thumbstickFrame.Size = UDim2.new(0.4, n2, 0.6666666666666666, n2)
		p31.thumbstickFrame.Position = UDim2.new(0, -n2, 0.3333333333333333, 0)
	end

	p31.thumbstickFrame = Instance.new("Frame")
	p31.thumbstickFrame.BorderSizePixel = 0
	p31.thumbstickFrame.Name = "DynamicThumbstickFrame"
	p31.thumbstickFrame.Visible = false
	p31.thumbstickFrame.BackgroundTransparency = 1
	p31.thumbstickFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	p31.thumbstickFrame.Active = false
	p31.thumbstickFrame.Size = UDim2.new(0.4, n2, 0.6666666666666666, n2)
	p31.thumbstickFrame.Position = UDim2.new(0, -n2, 0.3333333333333333, 0)
	p31.startImage = Instance.new("ImageLabel")
	p31.startImage.Name = "ThumbstickStart"
	p31.startImage.Visible = true
	p31.startImage.BackgroundTransparency = 1
	p31.startImage.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
	p31.startImage.ImageRectOffset = Vector2.new(1, 1)
	p31.startImage.ImageRectSize = Vector2.new(144, 144)
	p31.startImage.ImageColor3 = Color3.new(0, 0, 0)
	p31.startImage.AnchorPoint = Vector2.new(0.5, 0.5)
	p31.startImage.ZIndex = 10
	p31.startImage.Parent = p31.thumbstickFrame
	p31.endImage = Instance.new("ImageLabel")
	p31.endImage.Name = "ThumbstickEnd"
	p31.endImage.Visible = true
	p31.endImage.BackgroundTransparency = 1
	p31.endImage.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
	p31.endImage.ImageRectOffset = Vector2.new(1, 1)
	p31.endImage.ImageRectSize = Vector2.new(144, 144)
	p31.endImage.AnchorPoint = Vector2.new(0.5, 0.5)
	p31.endImage.ZIndex = 10
	p31.endImage.Parent = p31.thumbstickFrame

	for i = 1, n1 do
		p31.middleImages[i] = Instance.new("ImageLabel")
		p31.middleImages[i].Name = "ThumbstickMiddle"
		p31.middleImages[i].Visible = false
		p31.middleImages[i].BackgroundTransparency = 1
		p31.middleImages[i].Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
		p31.middleImages[i].ImageRectOffset = Vector2.new(1, 1)
		p31.middleImages[i].ImageRectSize = Vector2.new(144, 144)
		p31.middleImages[i].ImageTransparency = t1[i]
		p31.middleImages[i].AnchorPoint = Vector2.new(0.5, 0.5)
		p31.middleImages[i].ZIndex = 9
		p31.middleImages[i].Parent = p31.thumbstickFrame
	end

	local function ResizeThumbstick()
		local absoluteSize = parent.AbsoluteSize
		local u100: boolean = math.min(absoluteSize.X, absoluteSize.Y) > 500

		if v12 then
			local n1: number = if u100 then 2 else 1

			p31.thumbstickSize = 45 * n1
			p31.thumbstickRingSize = 20 * n1
			p31.middleSize = 10 * n1
			p31.middleSpacing = 14 * n1
			p31.radiusOfDeadZone = 2 * n1
			p31.radiusOfMaxSpeed = 20 * n1

			local n4: number = 74 * n1

			if avatarAbilitiesInterface:isEnabled() then
				local n3: number = if u100 then 88 else 64

				p31.startImage.Position = UDim2.new(0, n4 * 0.5 + n2 + n3, 1, -n4 * 0.5 - n2 - n3)
			else
				p31.startImage.Position = UDim2.new(0, p31.thumbstickRingSize * 3.3 + n2, 1, -p31.thumbstickRingSize * 2.8 - n2)
			end

			p31.startImage.Size = UDim2.new(0, n4, 0, n4)
		else
			if u100 then
				p31.thumbstickSize = 90
				p31.thumbstickRingSize = 40
				p31.middleSize = 20
				p31.middleSpacing = 28
				p31.radiusOfDeadZone = 4
				p31.radiusOfMaxSpeed = 40
			else
				p31.thumbstickSize = 45
				p31.thumbstickRingSize = 20
				p31.middleSize = 10
				p31.middleSpacing = 14
				p31.radiusOfDeadZone = 2
				p31.radiusOfMaxSpeed = 20
			end

			p31.startImage.Position = UDim2.new(0, p31.thumbstickRingSize * 3.3 + n2, 1, -p31.thumbstickRingSize * 2.8 - n2)
			p31.startImage.Size = UDim2.new(0, p31.thumbstickRingSize * 3.7, 0, p31.thumbstickRingSize * 3.7)
		end

		p31.endImage.Position = p31.startImage.Position
		p31.endImage.Size = UDim2.new(0, p31.thumbstickSize * 0.8, 0, p31.thumbstickSize * 0.8)
	end

	ResizeThumbstick()
	p31.absoluteSizeChangedConn = parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeThumbstick)

	if v12 then
		p31.avatarAbilitiesEnabledChangedConn = avatarAbilitiesInterface:GetEnabledChangedSignal():Connect(ResizeThumbstick)
	end

	local connection = nil

	ResizeThumbstick = function()
		if connection then
			connection:Disconnect()
			connection = nil
		end

		local CurrentCamera: Camera = workspace.CurrentCamera

		if CurrentCamera then
			connection = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
				local currentCameraViewportSize: Vector2 = CurrentCamera.ViewportSize

				layoutThumbstickFrame(currentCameraViewportSize.X < currentCameraViewportSize.Y)
			end)

			local currentCameraViewportSize: Vector2 = CurrentCamera.ViewportSize

			layoutThumbstickFrame(currentCameraViewportSize.X < currentCameraViewportSize.Y)
		end
	end
	workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(ResizeThumbstick)

	if workspace.CurrentCamera then
		ResizeThumbstick()
	end

	p31.moveTouchStartPosition = nil
	p31.startImageFadeTween = nil
	p31.endImageFadeTween = nil
	p31.middleImageFadeTweens = {}
	p31.onRenderSteppedConn = runService.RenderStepped:Connect(function()
		if p31.tweenInAlphaStart ~= nil then
			local n1 = tick() - p31.tweenInAlphaStart
			local n2 = p31.fadeInAndOutHalfDuration * 2 * p31.fadeInAndOutBalance

			p31.thumbstickFrame.BackgroundTransparency = 1 - math.min(n1 / n2, 1) * 0.35

			if n1 > n2 then
				p31.tweenOutAlphaStart = tick()
				p31.tweenInAlphaStart = nil

				return
			end
		elseif p31.tweenOutAlphaStart ~= nil then
			local n3 = tick() - p31.tweenOutAlphaStart
			local n4 = p31.fadeInAndOutHalfDuration * 2 - p31.fadeInAndOutHalfDuration * 2 * p31.fadeInAndOutBalance

			p31.thumbstickFrame.BackgroundTransparency = math.min(n3 / n4, 1) * 0.35 + 0.65

			if n3 > n4 then
				p31.tweenOutAlphaStart = nil
			end
		end
	end)
	p31.onTouchEndedConn = userInputService.TouchEnded:connect(function(p34)
		if p34 == p31.moveTouchObject then
			p31:OnInputEnded()
		end
	end)
	guiService.MenuOpened:connect(function()
		if p31.moveTouchObject then
			p31:OnInputEnded()
		end
	end)

	local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")

	while not playerGui do
		LocalPlayer.ChildAdded:wait()
		playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	end

	local connection = nil
	local u83: boolean = true

	if playerGui.CurrentScreenOrientation ~= Enum.ScreenOrientation.LandscapeLeft then
		u83 = playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight
	end

	local function longShowBackground()
		p31.fadeInAndOutHalfDuration = 2.5
		p31.fadeInAndOutBalance = 0.05
		p31.tweenInAlphaStart = tick()
	end

	connection = playerGui:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(function()
		if u83 and playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait or not u83 and playerGui.CurrentScreenOrientation ~= Enum.ScreenOrientation.Portrait then
			connection:disconnect()
			p31.fadeInAndOutHalfDuration = 2.5
			p31.fadeInAndOutBalance = 0.05
			p31.tweenInAlphaStart = tick()

			if u83 then
				p31.hasFadedBackgroundInPortrait = true

				return
			end

			p31.hasFadedBackgroundInLandscape = true

			return
		end
	end)
	p31.thumbstickFrame.Parent = parent

	if game:IsLoaded() then
		p31.fadeInAndOutHalfDuration = 2.5
		p31.fadeInAndOutBalance = 0.05
		p31.tweenInAlphaStart = tick()
	else
		coroutine.wrap(function()
			game.Loaded:Wait()
			p31.fadeInAndOutHalfDuration = 2.5
			p31.fadeInAndOutBalance = 0.05
			p31.tweenInAlphaStart = tick()
		end)()
	end
end

return object
