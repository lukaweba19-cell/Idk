-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local tweenService: TweenService = game:GetService("TweenService")
local userInputService: UserInputService = game:GetService("UserInputService")
local contextActionService: ContextActionService = game:GetService("ContextActionService")
local runService: RunService = game:GetService("RunService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local extensions: Instance = replicatedStorage:WaitForChild("Extensions")
local inputMap = require(extensions:WaitForChild("InputMap"))
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local emoteFlags = require(shared:WaitForChild("EmoteFlags"))
local emoteClient = require(shared:WaitForChild("EmoteClient"))
local emotePreview = require(shared:WaitForChild("EmotePreview"))
local emoteCatalog = require(shared:WaitForChild("EmoteCatalog"))
local playerState = require(shared:WaitForChild("PlayerState"))
local rarity = require(shared:WaitForChild("Rarity"))
local LocalPlayer: Player = players.LocalPlayer
local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui")
local bindables: Instance = replicatedStorage:WaitForChild("Bindables")

local function bindable(name)
	local foundChild: Instance = bindables:FindFirstChild(name)

	if foundChild and foundChild:IsA("BindableEvent") then
		return foundChild
	end

	local bindableEvent: BindableEvent = Instance.new("BindableEvent")

	bindableEvent.Name = name
	bindableEvent.Parent = bindables

	return bindableEvent
end

local emoteAssign: Instance = bindables:FindFirstChild("EmoteAssign")
local v21

if emoteAssign and emoteAssign:IsA("BindableEvent") then
	v21 = emoteAssign
else
	local emoteAssign: BindableEvent = Instance.new("BindableEvent")

	emoteAssign.Name = "EmoteAssign"
	emoteAssign.Parent = bindables
	v21 = emoteAssign
end

local emoteWheelToggle: Instance = bindables:FindFirstChild("EmoteWheelToggle")
local v24

if emoteWheelToggle and emoteWheelToggle:IsA("BindableEvent") then
	v24 = emoteWheelToggle
else
	local emoteWheelToggle: BindableEvent = Instance.new("BindableEvent")

	emoteWheelToggle.Name = "EmoteWheelToggle"
	emoteWheelToggle.Parent = bindables
	v24 = emoteWheelToggle
end

bindable = {
	"rbxassetid://82565431396608",
	"rbxassetid://98698182336605",
	"rbxassetid://99324846007938",
	"rbxassetid://99367612589338",
	"rbxassetid://117028696811634",
	"rbxassetid://111138426833089",
	"rbxassetid://95756466815595",
	"rbxassetid://73834599515376"
}
local v26 = math.min(emoteCatalog.SLOTS, #bindable)
local color3 = Color3.fromRGB(70, 70, 70)
local color32 = Color3.fromRGB(0, 170, 255)

local function rarityTint(p2)
	local v101 = p2 and rarity.Colors[p2]

	if not v101 then
		return color32
	end

	local v102, v103 = v101:ToHSV()
	local color3FromHSV = Color3.fromHSV
	local v105 = math.max(v103, 0.95)

	return color3FromHSV(v102, v105, 1)
end

local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
local active: boolean = userInputService.TouchEnabled and not userInputService.MouseEnabled
local u33: boolean = false

local function pushUnlock()
	if u33 then
		return
	end

	u33 = true

	local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

	LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) + 1)
end
local function popUnlock()
	if not u33 then
		return
	end

	u33 = false

	local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
	local v108 = math.max((mouseUnlocked or 0) - 1, 0)

	LocalPlayer:SetAttribute("MouseUnlocked", v108)
end

local emoteWheel: ScreenGui = Instance.new("ScreenGui")

emoteWheel.Name = "EmoteWheel"
emoteWheel.ResetOnSpawn = false
emoteWheel.IgnoreGuiInset = true
emoteWheel.DisplayOrder = 12
emoteWheel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
emoteWheel.Enabled = false
emoteWheel.Parent = playerGui

local dismiss: TextButton = Instance.new("TextButton")

dismiss.Name = "Dismiss"
dismiss.BackgroundTransparency = 1
dismiss.Text = ""
dismiss.Size = UDim2.fromScale(1, 1)
dismiss.ZIndex = 0
dismiss.Active = active
dismiss.Parent = emoteWheel

local backdrop: Frame = Instance.new("Frame")

backdrop.Name = "Backdrop"
backdrop.Size = UDim2.fromScale(1, 1)
backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
backdrop.BackgroundTransparency = 0.55
backdrop.BorderSizePixel = 0
backdrop.ZIndex = 1
backdrop.Active = false
backdrop.Parent = emoteWheel

local wheel: Frame = Instance.new("Frame")

wheel.Name = "Wheel"
wheel.AnchorPoint = Vector2.new(0.5, 0.5)
wheel.Position = UDim2.fromScale(0.5, 0.5)
wheel.Size = UDim2.fromOffset(560, 560)
wheel.BackgroundTransparency = 1
wheel.ZIndex = 2
wheel.Parent = emoteWheel

local uiScale: UIScale = Instance.new("UIScale")

uiScale.Parent = wheel

local n1 = 1
local u42 = nil

local function fitScale()
	local CurrentCamera: Camera = workspace.CurrentCamera

	n1 = math.clamp((if CurrentCamera then CurrentCamera.ViewportSize.Y else 900) / 860, 0.55, 1.25)

	if not u42 then
		uiScale.Scale = n1
	end
end

local tweenInfo3 = TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenInfo4 = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

local function popIn()
	if u42 then
		u42:Cancel()
	end

	uiScale.Scale = n1 * 0.86

	local v110: Tween = tweenService:Create(uiScale, tweenInfo3, { Scale = n1 })

	u42 = v110
	v110.Completed:Once(function()
		if u42 == v110 then
			u42 = nil
		end
	end)
	v110:Play()
end
local function popOut(p3)
	if u42 then
		u42:Cancel()
	end

	local v112: Tween = tweenService:Create(uiScale, tweenInfo4, { Scale = n1 * 0.9 })

	u42 = v112
	v112.Completed:Once(function()
		if u42 == v112 then
			u42 = nil
			p3()
			uiScale.Scale = n1
		end
	end)
	v112:Play()
end

local CurrentCamera: Camera = workspace.CurrentCamera

n1 = math.clamp((if CurrentCamera then CurrentCamera.ViewportSize.Y else 900) / 860, 0.55, 1.25)
uiScale.Scale = n1

if workspace.CurrentCamera then
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitScale)
end

local t1: {[any]: any} = {}

for i = 1, v26 do
	local imageLabel: ImageLabel = Instance.new("ImageLabel")

	imageLabel.Name = "Slice" .. i
	imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	imageLabel.Position = UDim2.fromScale(0.5, 0.5)
	imageLabel.Size = UDim2.fromScale(1, 1)
	imageLabel.BackgroundTransparency = 1
	imageLabel.Image = bindable[i]
	imageLabel.ImageColor3 = color3
	imageLabel.ImageTransparency = 0.1
	imageLabel.ScaleType = Enum.ScaleType.Fit
	imageLabel.ZIndex = 2
	imageLabel.Parent = wheel

	local n2 = (i - 0.5) * (6.283185307179586 / v26)
	local n3 = math.sin(n2) * 0.35 + 0.5
	local n4 = 0.5 - math.cos(n2) * 0.35
	local uiGradient: UIGradient = Instance.new("UIGradient")

	uiGradient.Rotation = math.deg(n2) - 90

	local colorSequenceNew = ColorSequence.new

	uiGradient.Color = colorSequenceNew({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
		ColorSequenceKeypoint.new(0.66, Color3.fromRGB(35, 35, 35)),
		ColorSequenceKeypoint.new(0.86, Color3.fromRGB(170, 170, 170)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
	})
	uiGradient.Parent = imageLabel

	local frame: Frame = Instance.new("Frame")

	frame.Name = "Rig" .. i
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.Position = UDim2.new(n3, 0, n4, -12)
	frame.Size = UDim2.fromOffset(112, 112)
	frame.BackgroundTransparency = 1
	frame.ZIndex = 6
	frame.Visible = false
	frame.Parent = wheel

	local textLabel: TextLabel = Instance.new("TextLabel")

	textLabel.Name = "Name" .. i
	textLabel.AnchorPoint = Vector2.new(0.5, 0)
	textLabel.Position = UDim2.new(n3, 0, n4, 30)
	textLabel.Size = UDim2.fromOffset(162, 26)
	textLabel.BackgroundTransparency = 1
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextScaled = true
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextTransparency = 0.35
	textLabel.Text = ""
	textLabel.ZIndex = 7
	textLabel.Visible = false
	textLabel.Parent = wheel

	local uiStroke: UIStroke = Instance.new("UIStroke")

	uiStroke.Thickness = 2.5
	uiStroke.Color = Color3.fromRGB(0, 0, 0)
	uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	uiStroke.LineJoinMode = Enum.LineJoinMode.Round
	uiStroke.Parent = textLabel

	local imageLabel2: ImageLabel = Instance.new("ImageLabel")

	imageLabel2.Name = "Plus" .. i
	imageLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
	imageLabel2.Position = UDim2.fromScale(n3, n4)
	imageLabel2.Size = UDim2.fromOffset(64, 64)
	imageLabel2.BackgroundTransparency = 1
	imageLabel2.Image = "rbxassetid://74537175036926"
	imageLabel2.ImageColor3 = Color3.fromRGB(255, 255, 255)
	imageLabel2.ImageTransparency = 0.25
	imageLabel2.ScaleType = Enum.ScaleType.Fit
	imageLabel2.ZIndex = 6
	imageLabel2.Visible = false
	imageLabel2.Parent = wheel
	t1[i] = {
		handle = nil,
		emoteId = nil,
		empty = true,
		label = "",
		img = imageLabel,
		rig = frame,
		name = textLabel,
		plus = imageLabel2
	}
end

local close: ImageButton = Instance.new("ImageButton")

close.Name = "Close"
close.AnchorPoint = Vector2.new(0.5, 0.5)
close.Position = UDim2.fromScale(0.93, 0.07)
close.Size = UDim2.fromOffset(56, 56)
close.BackgroundTransparency = 1
close.Image = "rbxassetid://121896102463775"
close.ScaleType = Enum.ScaleType.Fit
close.ZIndex = 8
close.Visible = false
close.Parent = wheel

local hub: TextLabel = Instance.new("TextLabel")

hub.Name = "Hub"
hub.AnchorPoint = Vector2.new(0.5, 0.5)
hub.Position = UDim2.fromScale(0.5, 0.5)
hub.Size = UDim2.fromScale(0.17, 0.17)
hub.BackgroundTransparency = 1
hub.Font = Enum.Font.GothamBold
hub.TextScaled = true
hub.TextColor3 = Color3.fromRGB(255, 255, 255)
hub.TextTransparency = 0.1
hub.Text = ""
hub.ZIndex = 5
hub.Parent = wheel

local uiStroke2: UIStroke = Instance.new("UIStroke")

uiStroke2.Thickness = 3
uiStroke2.Color = Color3.fromRGB(0, 0, 0)
uiStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
uiStroke2.LineJoinMode = Enum.LineJoinMode.Round
uiStroke2.Parent = hub

local sub: TextLabel = Instance.new("TextLabel")

sub.Name = "Sub"
sub.AnchorPoint = Vector2.new(0.5, 0)
sub.Position = UDim2.fromScale(0.5, 0.66)
sub.Size = UDim2.fromScale(0.6, 0.05)
sub.BackgroundTransparency = 1
sub.Font = Enum.Font.Gotham
sub.TextScaled = true
sub.TextColor3 = Color3.fromRGB(255, 255, 255)
sub.TextTransparency = 0.3
sub.Text = ""
sub.ZIndex = 5
sub.Parent = wheel

local uiStroke3: UIStroke = Instance.new("UIStroke")

uiStroke3.Thickness = 2
uiStroke3.Color = Color3.fromRGB(0, 0, 0)
uiStroke3.Parent = sub

local function refreshSlices()
	local v113

	for i, v in ipairs(t1) do
		local v116 = emoteClient.SlotEntry(i)
		local v117 = v116 and emoteCatalog.Get(v116.ItemId) or nil

		v.empty = v117 == nil
		v.label = if v117 then v117.Name else ""

		local v118

		if v117 then
			local rarity2 = v117.Rarity
			local v120 = rarity2 and rarity.Colors[rarity2]

			if not v120 then
				v118 = color32
			else
				local v121, v113 = v120:ToHSV()
				local color3FromHSV = Color3.fromHSV
				local v123 = math.max(v113, 0.95)

				v118 = color3FromHSV(v121, v123, 1)
			end
		else
			v118 = nil
		end

		v.color = v118

		local v124 = if v117 then v117.Id else nil

		if v124 ~= v.emoteId then
			if v.handle then
				v.handle:destroy()
				v.handle = nil
			end

			v.emoteId = v124

			if v124 then
				v113 = v124
				v.handle = emotePreview.new(v.rig, v113, { sound = false, autoplay = false, loop = true, zindex = 1 })
			end
		end

		v.rig.Visible = v117 ~= nil

		if v117 then
			v.plus.Visible = false
		end

		v.name.Text = v.label
		v.name.Visible = v117 ~= nil
		v.img.ImageTransparency = if v117 then 0.1 else 0.55
	end
end

refreshSlices()
emoteClient.Changed:Connect(refreshSlices)
emotePreview.AvatarChanged:Connect(function()
	for _, v in ipairs(t1) do
		if v.handle then
			v.handle:destroy()
			v.handle = nil
		end

		v.emoteId = nil
	end

	refreshSlices()
end)

local u67: boolean = false
local u68 = false
local u69 = nil
local u70 = nil
local u71: boolean = false
local connection2 = nil
local connection = nil

local function uiSound(name, soundId, volume)
	local foundChild: Instance = workspace:FindFirstChild(name)

	if foundChild and foundChild:IsA("Sound") then
		return foundChild
	end

	local sound: Sound = Instance.new("Sound")

	sound.Name = name
	sound.SoundId = soundId
	sound.Volume = volume
	sound.Parent = workspace

	return sound
end
local function playHoverSound()
	pcall(function()
		local uiHover: Instance = workspace:FindFirstChild("UIHover")
		local v192

		if uiHover and uiHover:IsA("Sound") then
			v192 = uiHover
		else
			local uiHover: Sound = Instance.new("Sound")

			uiHover.Name = "UIHover"
			uiHover.SoundId = "rbxassetid://138699902284184"
			uiHover.Volume = 4
			uiHover.Parent = workspace
			v192 = uiHover
		end

		v192:Play()
	end)
end
local function playClickSound()
	pcall(function()
		local uiClick: Instance = workspace:FindFirstChild("UIClick")
		local v195

		if uiClick and uiClick:IsA("Sound") then
			v195 = uiClick
		else
			local uiClick: Sound = Instance.new("Sound")

			uiClick.Name = "UIClick"
			uiClick.SoundId = "rbxassetid://6042053626"
			uiClick.Volume = 1
			uiClick.Parent = workspace
			v195 = uiClick
		end

		v195:Play()
	end)
end
local function setHover(p7)
	if p7 == u69 then
		return
	end

	if p7 then
		pcall(function()
			local uiHover: Instance = workspace:FindFirstChild("UIHover")
			local v192

			if uiHover and uiHover:IsA("Sound") then
				v192 = uiHover
			else
				local uiHover: Sound = Instance.new("Sound")

				uiHover.Name = "UIHover"
				uiHover.SoundId = "rbxassetid://138699902284184"
				uiHover.Volume = 4
				uiHover.Parent = workspace
				v192 = uiHover
			end

			v192:Play()
		end)
	end

	if u69 then
		local v133 = t1[u69]
		local img = v133.img
		local v135 = UDim2.fromScale(1, 1)

		tweenService:Create(img, tweenInfo, {
			Size = v135,
			ImageColor3 = color3,
			ImageTransparency = if v133.empty then 0.55 else 0.1
		}):Play()

		local rig = v133.rig

		v135 = UDim2.fromOffset(112, 112)
		tweenService:Create(rig, tweenInfo, { Size = v135 }):Play()
		tweenService:Create(v133.name, tweenInfo, { TextTransparency = 0.35 }):Play()

		if v133.handle then
			v133.handle:freeze()
		end

		v133.img.ZIndex = 2
	end

	u69 = p7

	if p7 then
		local v137 = t1[p7]

		v137.img.ZIndex = 4

		local v138 = v137.img
		local v139 = UDim2.fromScale(1.1, 1.1)

		tweenService:Create(v138, tweenInfo2, { Size = v139 }):Play()
		tweenService:Create(v137.img, tweenInfo, { ImageTransparency = 0.1, ImageColor3 = v137.color or color32 }):Play()

		local v140 = v137.rig

		v139 = UDim2.fromOffset(123.20000000000002, 123.20000000000002)
		tweenService:Create(v140, tweenInfo2, { Size = v139 }):Play()
		tweenService:Create(v137.name, tweenInfo, { TextTransparency = 0 }):Play()

		if v137.handle then
			v137.handle:play()
		end

		hub.Text = if u70 then "Pick a slot" else ""

		return
	end

	hub.Text = if u70 then "Pick a slot" else ""
end
local function sliceAt(p8)
	local n1 = p8 - (wheel.AbsolutePosition + wheel.AbsoluteSize / 2)

	if n1.Magnitude < wheel.AbsoluteSize.X * 0.18 then
		return nil
	end

	if n1.Magnitude > wheel.AbsoluteSize.X * 0.5 then
		return nil
	end

	local v143 = math.atan2(n1.X, -n1.Y)
	local v144 = math.deg(v143)

	return math.floor(v144 % 360 / (360 / v26)) % v26 + 1
end
local function sliceFromStick(p9)
	if p9.Magnitude < 0.35 then
		return nil
	end

	local v146 = math.atan2(p9.X, p9.Y)
	local v147 = math.deg(v146)

	return math.floor(v147 % 360 / (360 / v26)) % v26 + 1
end
local function sinkStick(p10)
	if p10 then
		contextActionService:BindActionAtPriority("EmoteWheelStickSink", function()
			return Enum.ContextActionResult.Sink
		end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.Thumbstick1)

		return
	end

	contextActionService:UnbindAction("EmoteWheelStickSink")
end

local u81 = nil
local u82 = nil
local uDim2 = UDim2.new(0.5, 0, 5, 0)

local function hideInventory()
	local hud: Instance = playerGui:FindFirstChild("HUD")
	local inventoryWindow: Instance = hud and hud:FindFirstChild("InventoryWindow")

	if inventoryWindow and inventoryWindow:IsA("GuiObject") and inventoryWindow.Visible then
		u81 = inventoryWindow
		u82 = inventoryWindow.Position
		inventoryWindow.Position = uDim2
	end
end
local function restoreInventory()
	local v151 = u81

	if v151 then
		u81 = nil

		if v151.Position == uDim2 and u82 then
			v151.Position = u82
		end

		u82 = nil
	end
end
local function open(visible)
	if u67 then
		return
	end

	u67 = true
	u68 = visible
	u69 = nil

	for _, v in ipairs(t1) do
		v.img.Size = UDim2.fromScale(1, 1)
		v.img.ImageColor3 = color3
		v.img.ImageTransparency = if v.empty then 0.55 else 0.1
		v.img.ZIndex = 2
		v.rig.Size = UDim2.fromOffset(112, 112)
		v.name.TextTransparency = 0.35

		local u155 = false

		if u70 ~= nil then
			u155 = v.empty
		end

		v.plus.Visible = u155
	end

	close.Visible = visible

	if u70 then
		local hud: Instance = playerGui:FindFirstChild("HUD")
		local inventoryWindow: Instance = hud and hud:FindFirstChild("InventoryWindow")

		if inventoryWindow and inventoryWindow:IsA("GuiObject") and inventoryWindow.Visible then
			u81 = inventoryWindow
			u82 = inventoryWindow.Position
			inventoryWindow.Position = uDim2
		end
	end

	hub.Text = if u70 then "Pick a slot" else ""
	sub.Text = ""

	if not u33 then
		u33 = true

		local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

		LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) + 1)
	end

	emoteWheel.Enabled = true
	popIn()
	connection = runService.RenderStepped:Connect(function()
		if active then
			return
		end

		if userInputService:GetLastInputType() == Enum.UserInputType.Gamepad1 then
			return
		end

		local v197: Vector2 = userInputService:GetMouseLocation()
		local v198 = sliceAt(Vector2.new(v197.X, v197.Y))

		setHover(v198)
	end)
	connection2 = userInputService.InputChanged:Connect(function(input: InputObject)
		if input.KeyCode == Enum.KeyCode.Thumbstick1 then
			local vector2 = Vector2.new(input.Position.X, input.Position.Y)
			local v201 = if vector2.Magnitude < 0.35 then nil else math.floor(math.deg((math.atan2(vector2.X, vector2.Y))) % 360 / (360 / v26)) % v26 + 1

			if v201 then
				setHover(v201)
			end
		end
	end)
	contextActionService:BindActionAtPriority("EmoteWheelStickSink", function()
		return Enum.ContextActionResult.Sink
	end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.Thumbstick1)
end
local function close2()
	if not u67 then
		return
	end

	u67 = false
	u68 = false

	if connection then
		connection:Disconnect()
		connection = nil
	end

	if connection2 then
		connection2:Disconnect()
		connection2 = nil
	end

	contextActionService:UnbindAction("EmoteWheelStickSink")
	setHover(nil)
	popOut(function()
		emoteWheel.Enabled = false
	end)

	if u33 then
		u33 = false

		local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
		local v160 = math.max((mouseUnlocked or 0) - 1, 0)

		LocalPlayer:SetAttribute("MouseUnlocked", v160)
	end

	local v161 = u81

	if v161 then
		u81 = nil

		if v161.Position == uDim2 and u82 then
			v161.Position = u82
		end

		u82 = nil
	end
end
local function u88(p13)
	local v163 = if p13 then u69 else nil
	local v164 = u70

	u70 = nil
	close2()

	if not v163 then
		return
	end

	pcall(function()
		local uiClick: Instance = workspace:FindFirstChild("UIClick")
		local v195

		if uiClick and uiClick:IsA("Sound") then
			v195 = uiClick
		else
			local uiClick: Sound = Instance.new("Sound")

			uiClick.Name = "UIClick"
			uiClick.SoundId = "rbxassetid://6042053626"
			uiClick.Volume = 1
			uiClick.Parent = workspace
			v195 = uiClick
		end

		v195:Play()
	end)

	if v164 then
		task.spawn(function()
			local v202, v203 = emoteClient.Equip(v163, v164.InstanceId)

			if not v202 then
				warn("[EmoteWheel] equip failed:", v203)
			end
		end)

		return
	end

	if emoteClient.SlotEntry(v163) then
		task.spawn(function()
			local v204, v205 = emoteClient.RequestPlay(v163)

			if not v204 and v205 ~= "TooFast" then
				warn("[EmoteWheel] play refused:", v205)
			end
		end)
	end
end
local function cancel()
	u70 = nil

	if u68 then
		u88(false)

		return
	end

	setHover(nil)
	inputMap.forceRelease("Emote")
end
local function winScreenUp()
	local winScreen: Instance = playerGui:FindFirstChild("WinScreen")

	if not winScreen or not winScreen:IsA("ScreenGui") or not winScreen.Enabled then
		return false
	end

	local winLossScreen: Instance = winScreen:FindFirstChild("WinLossScreen")
	local u167 = false

	if winLossScreen ~= nil then
		u167 = winLossScreen:IsA("GuiObject") and winLossScreen.Visible
	end

	return u167
end
local function wheelAllowed()
	if not playerState.ReplayActive and not playerState.FinisherPreviewActive and not playerState.WieldedPreviewActive then
		if LocalPlayer:GetAttribute("Spectating") == nil then
			if winScreenUp() then
				return false
			end

			local Character: Model = LocalPlayer.Character
			local humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

			return humanoid ~= nil and humanoid.Health > 0
		end

		return false
	end

	return false
end
local function handleAction(p14)
	if u68 and u67 then
	elseif p14 == Enum.UserInputState.Begin then
		if wheelAllowed() then
			open(false)

			return
		end
	elseif p14 == Enum.UserInputState.End then
		u88(true)
	end
end
local function cycleHover(p15)
	local n1: number = #t1

	for i = 1, n1 do
		local n2 = ((u69 or 0) - 1 + p15 * i) % n1 + 1

		if not t1[n2].empty then
			setHover(n2)

			return
		end
	end
end

userInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	if not u67 then
		return
	end

	local userInputType: Enum.UserInputType = input.UserInputType

	if input.KeyCode == Enum.KeyCode.ButtonR3 then
		cycleHover(1)
	elseif userInputType == Enum.UserInputType.MouseButton2 or input.KeyCode == Enum.KeyCode.ButtonB then
		u70 = nil

		if u68 then
			u88(false)

			return
		end

		setHover(nil)
		inputMap.forceRelease("Emote")
	elseif not u68 then
	elseif userInputType ~= Enum.UserInputType.MouseButton1 and input.KeyCode ~= Enum.KeyCode.ButtonA then
		if userInputType == Enum.UserInputType.Touch then
			local v178 = sliceAt(Vector2.new(input.Position.X, input.Position.Y))

			if v178 then
				setHover(v178)
				u88(true)

				return
			end

			u70 = nil

			if u68 then
				u88(false)

				return
			end

			setHover(nil)
			inputMap.forceRelease("Emote")
		end
	elseif u69 then
		u88(true)

		return
	end
end)
dismiss.Activated:Connect(function()
	if u67 and u68 then
		u70 = nil

		if u68 then
			u88(false)

			return
		end

		setHover(nil)
		inputMap.forceRelease("Emote")

		return
	end
end)
close.Activated:Connect(function()
	if u67 and u68 then
		u70 = nil

		if u68 then
			u88(false)

			return
		end

		setHover(nil)
		inputMap.forceRelease("Emote")

		return
	end
end)
v24.Event:Connect(function()
	if u67 then
		u70 = nil

		if u68 then
			u88(false)

			return
		end

		setHover(nil)
		inputMap.forceRelease("Emote")

		return
	end

	if u71 and wheelAllowed() then
		open(true)
	end
end)
task.spawn(function()
	local winScreen: Instance = playerGui:WaitForChild("WinScreen", 30)
	local winLossScreen: Instance = winScreen and winScreen:WaitForChild("WinLossScreen", 30)

	if not winLossScreen or not winLossScreen:IsA("GuiObject") then
		return
	end

	winLossScreen:GetPropertyChangedSignal("Visible"):Connect(function()
		if winLossScreen.Visible and u67 then
			u70 = nil

			if u68 then
				u88(false)

				return
			end

			setHover(nil)
			inputMap.forceRelease("Emote")

			return
		end
	end)
end)
v21.Event:Connect(function(p18)
	if typeof(p18) == "table" and typeof(p18.InstanceId) == "string" then
		if u67 then
			u70 = nil

			if u68 then
				u88(false)
			else
				setHover(nil)
				inputMap.forceRelease("Emote")
			end
		end

		local instanceId = p18.InstanceId
		local text: string = tostring(p18.ItemId)
		u70 = {
			InstanceId = instanceId,
			ItemId = text,
			Name = tostring(p18.Name or p18.ItemId)
		}
		open(true)

		return
	end
end)

local function describeBinding()
	local ok, result = pcall(function()
		local tableConcat = table.concat
		local v207 = inputMap.getBindings("Emote")
		local v208 = tableConcat(v207, ",")
		local text: string = tostring(inputMap.isHydrated())

		return ("keys=[%s] hydrated=%s"):format(v208, text)
	end)

	if ok then
		return result
	end

	return "binding lookup failed: " .. tostring(result)
end

local sharedEmoteFlags: Instance = shared:WaitForChild("EmoteFlags")

local function applyGate()
	local emotesEnabled: any = sharedEmoteFlags:GetAttribute("EmotesEnabled")
	local u187: boolean = if emotesEnabled == nil then emoteFlags.EmotesEnabled == true else emotesEnabled == true

	if u187 == u71 then
		return
	end

	u71 = u187

	if u187 then
		local ok, result = pcall(inputMap.bind, "Emote", handleAction)

		if not ok then
			warn("[EmoteWheel] bind failed:", result)
		end
	else
		if u67 then
			u70 = nil

			if u68 then
				u88(false)
			else
				setHover(nil)
				inputMap.forceRelease("Emote")
			end
		end

		inputMap.unbind("Emote")
	end

	task.spawn(function()
		local hud: Instance = playerGui:FindFirstChild("HUD")
		local settingsWindow: Instance = hud and hud:FindFirstChild("SettingsWindow")
		local v212: Instance = settingsWindow

		if v212 then
			v212 = settingsWindow:FindFirstChild("ContentHotkeys")
		end

		local scrollingFrame: Instance = v212 and v212:FindFirstChild("ScrollingFrame")

		v212 = scrollingFrame

		if v212 then
			v212 = scrollingFrame:FindFirstChild("Emote")
		end

		if v212 and v212:IsA("GuiObject") then
			v212.Visible = u187
		end
	end)
end

applyGate()
inputMap.changed:Connect(function()
end)
sharedEmoteFlags.AttributeChanged:Connect(function(p19: string)
	if p19 == "EmotesEnabled" then
		applyGate()
	end
end)
userInputService.WindowFocusReleased:Connect(function()
	if u67 then
		u70 = nil

		if u68 then
			u88(false)

			return
		end

		setHover(nil)
		inputMap.forceRelease("Emote")

		return
	end
end)
LocalPlayer.CharacterAdded:Connect(function()
	if u67 then
		u70 = nil

		if u68 then
			u88(false)

			return
		end

		setHover(nil)
		inputMap.forceRelease("Emote")

		return
	end
end)
