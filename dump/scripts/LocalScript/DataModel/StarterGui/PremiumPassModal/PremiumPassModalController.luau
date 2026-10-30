-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local tweenService: TweenService = game:GetService("TweenService")
local runService: RunService = game:GetService("RunService")
local guiService: GuiService = game:GetService("GuiService")
local LocalPlayer: Player = players.LocalPlayer
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local windowBlur = require(shared:WaitForChild("WindowBlur"))
local goldenText = require(shared:WaitForChild("GoldenText"))
local sound = require(replicatedStorage:WaitForChild("Sound"))
local extensions: Instance = replicatedStorage:WaitForChild("Extensions")
local inputCategorizer = require(extensions:WaitForChild("InputCategorizer"))
local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local scriptParent: Instance = script.Parent
local window: Instance = scriptParent:WaitForChild("Window")
local backdrop: Instance = scriptParent:WaitForChild("Backdrop")
local rays: Instance = scriptParent:WaitForChild("Rays")
local glow: Instance = scriptParent:WaitForChild("Glow")
local headerTextLabel: Instance = window:WaitForChild("HeaderTextLabel")
local titleTextLabel: Instance = window:WaitForChild("TitleTextLabel")
local badge: Instance = window:WaitForChild("Badge")
local options: Instance = window:WaitForChild("Options")
local close: Instance = options:WaitForChild("Close")
local uiGradient: Instance = badge:FindFirstChildOfClass("UIGradient")
local textLabel: Instance = titleTextLabel:FindFirstChildOfClass("TextLabel")
local titleTextLabelText = titleTextLabel.Text
local badgePosition = badge.Position
local raysImageTransparency = rays.ImageTransparency
local glowImageTransparency = glow.ImageTransparency
local uiGradientRotation = uiGradient.Rotation
local tweenInfo = TweenInfo.new(0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local tweenInfo3 = TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local tweenInfo4 = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenInfo5 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo6 = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function ensureScale(parent)
	local uiScale = parent:FindFirstChildOfClass("UIScale")

	if not uiScale then
		uiScale = Instance.new("UIScale")
		uiScale.Parent = parent
	end

	return uiScale
end

local uiScale = window:FindFirstChildOfClass("UIScale")

if not uiScale then
	uiScale = Instance.new("UIScale")
	uiScale.Parent = window
end

local uiScale2 = badge:FindFirstChildOfClass("UIScale")

if not uiScale2 then
	uiScale2 = Instance.new("UIScale")
	uiScale2.Parent = badge
end

local uiScale3 = headerTextLabel:FindFirstChildOfClass("UIScale")

if not uiScale3 then
	uiScale3 = Instance.new("UIScale")
	uiScale3.Parent = headerTextLabel
end

local uiScale4 = titleTextLabel:FindFirstChildOfClass("UIScale")

if not uiScale4 then
	uiScale4 = Instance.new("UIScale")
	uiScale4.Parent = titleTextLabel
end

local uiScale5 = options:FindFirstChildOfClass("UIScale")

if not uiScale5 then
	uiScale5 = Instance.new("UIScale")
	uiScale5.Parent = options
end

local t1: {[any]: any} = {}

local function play(p2, p3, p4)
	local v63: Tween = tweenService:Create(p2, p3, p4)

	table.insert(t1, v63)
	v63:Play()

	return v63
end
local function cancelAll()
	for _, v in ipairs(t1) do
		v:Cancel()
	end

	table.clear(t1)
end

local u47: boolean = false
local connection = nil
local u49 = nil
local u50 = nil
local n1: number = 0

local function startIdle()
	if connection then
		connection:Disconnect()
	end

	n1 = 0
	connection = runService.Heartbeat:Connect(function(deltaTime: number)
		n1 += deltaTime

		local v79: Instance = rays

		v79.Rotation = v79.Rotation + deltaTime * 11
		v79 = uiGradient
		v79.Rotation = v79.Rotation + deltaTime * 26

		local uDim2FromScale = UDim2.fromScale
		local sine = math.sin(n1 * 1.9)
		local uDim2 = uDim2FromScale(0, sine * 0.012)

		badge.Position = badgePosition + uDim2
		badge.Rotation = math.sin(n1 * 1.35) * 2.5
	end)
end
local function stopIdle()
	if connection then
		connection:Disconnect()
		connection = nil
	end

	goldenText.unbind(textLabel)
end
local function show()
	if u47 then
		return
	end

	u47 = true

	for _, v in ipairs(t1) do
		v:Cancel()
	end

	table.clear(t1)
	badge.Position = badgePosition
	badge.Rotation = -540
	uiGradient.Rotation = uiGradientRotation
	rays.Rotation = 0
	rays.ImageTransparency = 1
	glow.ImageTransparency = 1
	uiScale.Scale = 0.55
	uiScale2.Scale = 0
	uiScale3.Scale = 0
	uiScale4.Scale = 0
	uiScale5.Scale = 0
	backdrop.BackgroundTransparency = 1
	backdrop.Visible = true
	options.Visible = false
	rays.Visible = true
	glow.Visible = true
	window.Visible = true
	scriptParent.Enabled = true

	local v68: Tween = tweenService:Create(backdrop, tweenInfo5, { BackgroundTransparency = 0.4 })

	table.insert(t1, v68)
	v68:Play()
	v68 = tweenService:Create(rays, tweenInfo5, { ImageTransparency = raysImageTransparency })
	table.insert(t1, v68)
	v68:Play()
	v68 = tweenService:Create(glow, tweenInfo5, { ImageTransparency = glowImageTransparency })
	table.insert(t1, v68)
	v68:Play()
	v68 = tweenService:Create(uiScale, tweenInfo, { Scale = 1 })
	table.insert(t1, v68)
	v68:Play()
	v68 = tweenService:Create(uiScale2, tweenInfo3, { Scale = 1 })
	table.insert(t1, v68)
	v68:Play()
	v68 = tweenService:Create(badge, tweenInfo3, { Rotation = 0 })
	table.insert(t1, v68)
	v68:Play()
	task.delay(0.18, function()
		if u47 then
			local v83: Tween = tweenService:Create(uiScale3, tweenInfo4, { Scale = 1 })

			table.insert(t1, v83)
			v83:Play()
		end
	end)
	task.delay(0.26, function()
		if u47 then
			local v84: Tween = tweenService:Create(uiScale4, tweenInfo4, { Scale = 1 })

			table.insert(t1, v84)
			v84:Play()
		end
	end)

	if connection then
		connection:Disconnect()
	end

	n1 = 0
	connection = runService.Heartbeat:Connect(function(deltaTime: number)
		n1 += deltaTime

		local v86: Instance = rays

		v86.Rotation = v86.Rotation + deltaTime * 11
		v86 = uiGradient
		v86.Rotation = v86.Rotation + deltaTime * 26

		local uDim2FromScale = UDim2.fromScale
		local sine = math.sin(n1 * 1.9)
		local uDim2 = uDim2FromScale(0, sine * 0.012)

		badge.Position = badgePosition + uDim2
		badge.Rotation = math.sin(n1 * 1.35) * 2.5
	end)
	goldenText.bind(textLabel, titleTextLabelText)
	sound:Play("Crate.Secret", workspace)
	task.delay(0.16, function()
		if u47 then
			sound:Play("Misc.BonusFX", workspace, nil, 1.15)
		end
	end)

	if u49 then
		task.cancel(u49)
	end

	u49 = task.delay(0.55, function()
		u49 = nil

		if not u47 then
			return
		end

		options.Visible = true

		local v90: Tween = tweenService:Create(uiScale5, tweenInfo4, { Scale = 1 })

		table.insert(t1, v90)
		v90:Play()

		if inputCategorizer.getLastInputCategory() == inputCategorizer.InputCategory.Gamepad then
			guiService.SelectedObject = close
		end
	end)

	local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

	LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) + 1)
	windowBlur.show("PremiumPassModal")
end

close.MouseButton1Click:Connect(function()
	if not u47 then
		return
	end

	u47 = false

	if u49 then
		task.cancel(u49)
		u49 = nil
	end

	if connection then
		connection:Disconnect()
		connection = nil
	end

	goldenText.unbind(textLabel)

	for _, v in ipairs(t1) do
		v:Cancel()
	end

	table.clear(t1)

	local guiServiceSelectedObject: GuiObject = guiService.SelectedObject

	if guiServiceSelectedObject and guiServiceSelectedObject:IsDescendantOf(scriptParent) then
		guiService.SelectedObject = nil
	end

	local v73: Tween = tweenService:Create(backdrop, tweenInfo6, { BackgroundTransparency = 1 })

	table.insert(t1, v73)
	v73:Play()

	local v74: Tween = tweenService:Create(rays, tweenInfo6, { ImageTransparency = 1 })

	table.insert(t1, v74)
	v74:Play()
	v74 = tweenService:Create(glow, tweenInfo6, { ImageTransparency = 1 })
	table.insert(t1, v74)
	v74:Play()

	local v75: Tween = tweenService:Create(uiScale, tweenInfo2, { Scale = 0.9 })

	table.insert(t1, v75)
	v75:Play()
	v75.Completed:Once(function()
		if u47 then
			return
		end

		window.Visible = false
		backdrop.Visible = false
		rays.Visible = false
		glow.Visible = false
		uiScale.Scale = 1
		badge.Position = badgePosition
		badge.Rotation = 0
	end)

	local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
	local v77 = math.max((mouseUnlocked or 0) - 1, 0)

	LocalPlayer:SetAttribute("MouseUnlocked", v77)
	windowBlur.hide("PremiumPassModal")
end)

local showPremiumPass = bindables:FindFirstChild("ShowPremiumPass")

if not showPremiumPass then
	local showPremiumPass2: BindableEvent = Instance.new("BindableEvent")

	showPremiumPass2.Name = "ShowPremiumPass"
	showPremiumPass2.Parent = bindables
	showPremiumPass = showPremiumPass2
end

showPremiumPass.Event:Connect(show)

local seasonPassGranted: Instance = remotes:FindFirstChild("SeasonPassGranted")

if seasonPassGranted and seasonPassGranted:IsA("RemoteEvent") then
	seasonPassGranted.OnClientEvent:Connect(function()
		if u50 then
			task.cancel(u50)
		end

		u50 = task.delay(1.5, function()
			u50 = nil
			show()
		end)
	end)
else
	warn("[PremiumPassModal] Remotes.SeasonPassGranted missing -- purchase celebration will not fire")
end

window.Visible = false
backdrop.Visible = false
rays.Visible = false
glow.Visible = false
window.SelectionGroup = true
window.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
window.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
window.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
window.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
scriptParent.Enabled = true
