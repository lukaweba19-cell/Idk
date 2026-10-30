-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local userInputService: UserInputService = game:GetService("UserInputService")
local starterGui: StarterGui = game:GetService("StarterGui")
local runService: RunService = game:GetService("RunService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local controlLayout = require(shared:WaitForChild("ControlLayout"))

local function emoteToggleBindable()
	local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
	local emoteWheelToggle: Instance = bindables:FindFirstChild("EmoteWheelToggle")

	if emoteWheelToggle and emoteWheelToggle:IsA("BindableEvent") then
		return emoteWheelToggle
	end

	local emoteWheelToggle: BindableEvent = Instance.new("BindableEvent")

	emoteWheelToggle.Name = "EmoteWheelToggle"
	emoteWheelToggle.Parent = bindables

	return emoteWheelToggle
end

local uDim2 = UDim2.new(0, 70, 0, 110)
local LocalPlayer = nil
local u11 = nil
local t1: {[any]: any} = {
	"SettingsWindow",
	"ShopWindow",
	"PlayerCard",
	"InventoryWindow",
	"AbilitiesWindow",
	"GiftingMenu",
	"Trading",
	"EffectsWindow",
	"IndexBackground",
	"WarningBackground",
	"FilterBackground"
}
local t2: {[any]: any} = { "WinScreen", "Spinner", "MapVote", "InspectHUD" }
local t3: {[any]: any} = { "ReplayHUD" }
local t4: {[any]: any} = { "Knife", "Revolver" }
local u16: boolean = false
local u17 = nil
local u18 = nil
local u19: boolean = false
local n1 = 0
local u21: boolean = false
local u22 = nil
local u23 = nil
local t5: {[any]: any} = {}
local t6: {[any]: any} = {}
local t7 = {}
local t8 = {}
local t9: {[any]: any} = {}

local function isOverlayOpen()
	local mouseUnlocked = LocalPlayer:GetAttribute("MouseUnlocked")

	if typeof(mouseUnlocked) == "number" and mouseUnlocked > 0 then
		return true
	end

	local hud = u11:FindFirstChild("HUD")

	if hud then
		for key, value in t1 do
			local foundChild = hud:FindFirstChild(value)

			if foundChild and foundChild:IsA("GuiObject") and foundChild.Visible then
				return true
			end

			local effects = hud:FindFirstChild("Effects")

			if effects and effects:FindFirstChild(value) and effects:FindFirstChild(value):IsA("GuiObject") and effects:FindFirstChild(value).Visible then
				return true
			end
		end
	end

	for key2, value2 in t3 do
		local foundChild = u11:FindFirstChild(value2)

		if foundChild and foundChild:IsA("ScreenGui") and foundChild.Enabled then
			return true
		end
	end

	for key3, value3 in t2 do
		local v69 = u11:WaitForChild(value3, 10)

		if v69 and v69:IsA("ScreenGui") and v69.Enabled then
			if value3 == "WinScreen" then
				local winLossScreen = v69:FindFirstChild("WinLossScreen")

				if winLossScreen and winLossScreen:IsA("GuiObject") and winLossScreen.Visible then
					return true
				end
			else
				if value3 ~= "MapVote" then
					return true
				end

				local mapSelect = v69:FindFirstChild("MapSelect")

				if mapSelect and mapSelect:IsA("GuiObject") and mapSelect.Visible then
					return true
				end

				local loadingScreen = v69:FindFirstChild("LoadingScreen")

				if loadingScreen and loadingScreen:IsA("GuiObject") and loadingScreen.Visible then
					return true
				end
			end
		end
	end

	return false
end
local function isAlive()
	local Character = LocalPlayer.Character

	if not Character then
		return false
	end

	local humanoid = Character:FindFirstChildOfClass("Humanoid")

	return humanoid ~= nil and humanoid.Health > 0
end
local function getToolCount()
	local n1: number = 0
	local Character = LocalPlayer.Character
	local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")

	if backpack then
		for iterFirst, iterSecond in backpack:GetChildren() do
			if iterSecond:IsA("Tool") then
				n1 += 1
			end
		end
	end

	if Character then
		for iterFirst2, iterSecond2 in Character:GetChildren() do
			if iterSecond2:IsA("Tool") then
				n1 += 1
			end
		end
	end

	return n1
end
local function getEquippedToolName()
	local Character = LocalPlayer.Character

	if not Character then
		return nil
	end

	for iterFirst, iterSecond in Character:GetChildren() do
		if iterSecond:IsA("Tool") then
			return iterSecond.Name
		end
	end

	return nil
end
local function findTool(p1)
	local Character = LocalPlayer.Character
	local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")

	if backpack then
		for iterFirst, iterSecond in backpack:GetChildren() do
			if iterSecond:IsA("Tool") and p1 == iterSecond.Name then
				return iterSecond
			end
		end
	end

	if Character then
		for iterFirst2, iterSecond2 in Character:GetChildren() do
			if iterSecond2:IsA("Tool") and p1 == iterSecond2.Name then
				return iterSecond2
			end
		end

		return nil
	end

	return nil
end
local function canSwap()
	if workspace:GetAttribute("LoadingScreenCompleted") == true then
		if not LocalPlayer:GetAttribute("BackpackEnabled") then
			return false
		end

		local matchId = LocalPlayer:GetAttribute("MatchId")

		return matchId ~= nil and matchId ~= ""
	end

	return false
end
local function setJumpButtonVisible(visible)
	pcall(function()
		starterGui:SetCore("SetJumpButtonVisible", visible)
	end)

	local touchGui = u11:FindFirstChild("TouchGui")
	local touchControlFrame = touchGui and touchGui:FindFirstChild("TouchControlFrame")
	local jumpButton = touchControlFrame and touchControlFrame:FindFirstChild("JumpButton")

	if jumpButton then
		jumpButton.Active = false
		jumpButton.Visible = visible
	end
end
local function refreshVisibility()
	local v97 = isOverlayOpen()
	local Character = LocalPlayer.Character
	local u99

	if not Character then
		u99 = false
	else
		local humanoid = Character:FindFirstChildOfClass("Humanoid")

		u99 = false

		if humanoid ~= nil then
			u99 = humanoid.Health > 0
		end
	end

	if u17 then
		u17.Enabled = u99 and not v97

		local buttons = u17:FindFirstChild("Buttons")
		local swapButton = buttons and buttons:FindFirstChild("SwapButton")

		if swapButton then
			swapButton.Visible = getToolCount() >= 2
		end

		local uiScale = u17:FindFirstChildOfClass("UIScale")

		if uiScale then
			uiScale.Scale = 0.6
		end
	end

	if u18 then
		u18.Enabled = u99 and (u21 or not v97)

		local uiScale = u18:FindFirstChildOfClass("UIScale")

		if uiScale then
			uiScale.Scale = 0.6
		end
	end

	setJumpButtonVisible(not v97)
end
local function makeButton(name, parent, p5)
	local clone

	if script:FindFirstChild(name) then
		clone = script[name]:Clone()
	else
		clone = Instance.new("TextButton")

		local uiCorner: UICorner = Instance.new("UICorner")

		uiCorner.CornerRadius = UDim.new(1, 0)
		uiCorner.Parent = clone
	end

	clone.Name = name
	clone.AnchorPoint = Vector2.new(0.5, 0.5)
	clone.Position = p5.position
	clone.Size = UDim2.fromOffset(p5.size, p5.size)
	clone.BackgroundColor3 = p5.color or Color3.new(0, 0, 0)
	clone.BackgroundTransparency = p5.transparency or 0.5
	clone.Text = ""
	clone.Active = false
	clone.AutoButtonColor = false
	clone.Parent = parent

	if p5.label then
		local label: TextLabel = Instance.new("TextLabel")

		label.Name = "Label"
		label.AnchorPoint = Vector2.new(0.5, 0.5)
		label.Position = UDim2.fromScale(0.5, 0.5)
		label.Size = UDim2.fromOffset(p5.labelSize or p5.size * 0.6, p5.labelSize or p5.size * 0.6)
		label.BackgroundTransparency = 1
		label.Text = p5.label
		label.TextColor3 = Color3.new(1, 1, 1)
		label.TextScaled = true
		label.Font = Enum.Font.GothamBold
		label.Active = false
		label.Parent = clone
	end

	if p5.icon then
		local iconLabel: ImageLabel = Instance.new("ImageLabel")

		iconLabel.Name = "IconLabel"
		iconLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		iconLabel.Position = UDim2.fromScale(0.5, 0.5)
		iconLabel.Size = UDim2.fromOffset(p5.iconSize or 64, p5.iconSize or 64)
		iconLabel.BackgroundTransparency = 1
		iconLabel.Image = p5.icon
		iconLabel.Active = false
		iconLabel.Parent = clone
	end

	return clone
end
local function buildPersistentGui()
	local mobilePersistentHUD: ScreenGui = Instance.new("ScreenGui")

	mobilePersistentHUD.Name = "MobilePersistentHUD"
	mobilePersistentHUD.ResetOnSpawn = false
	mobilePersistentHUD.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	mobilePersistentHUD.DisplayOrder = 9
	mobilePersistentHUD.Enabled = false
	mobilePersistentHUD.Parent = u11

	local uiScale: UIScale = Instance.new("UIScale")

	uiScale.Scale = 1
	uiScale.Parent = mobilePersistentHUD

	local buttons: Frame = Instance.new("Frame")

	buttons.Name = "Buttons"
	buttons.AnchorPoint = Vector2.new(1, 1)
	buttons.Position = UDim2.new(1, 0, 1, 0)
	buttons.Size = UDim2.fromOffset(280, 290)
	buttons.BackgroundTransparency = 1
	buttons.BorderSizePixel = 0
	buttons.Parent = mobilePersistentHUD
	makeButton("SlideButton", buttons, {
		size = 75,
		icon = "rbxassetid://106034700566994",
		iconSize = 32,
		position = UDim2.new(1, -210, 1, -60)
	})
	makeButton("SwapButton", buttons, { size = 75, position = UDim2.new(0, 60, 0.4, -130) })

	local buttonsTL: Frame = Instance.new("Frame")

	buttonsTL.Name = "ButtonsTL"
	buttonsTL.Size = UDim2.fromScale(1, 1)
	buttonsTL.BackgroundTransparency = 1
	buttonsTL.BorderSizePixel = 0
	buttonsTL.Parent = mobilePersistentHUD

	local v116 = makeButton("EmoteButton", buttonsTL, {
		size = 70,
		icon = "rbxassetid://124920256145531",
		iconSize = 48,
		position = uDim2
	})

	v116.Active = true
	v116.Activated:Connect(function()
		local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
		local emoteWheelToggle: Instance = bindables:FindFirstChild("EmoteWheelToggle")
		local v258

		if emoteWheelToggle and emoteWheelToggle:IsA("BindableEvent") then
			v258 = emoteWheelToggle
		else
			local emoteWheelToggle: BindableEvent = Instance.new("BindableEvent")

			emoteWheelToggle.Name = "EmoteWheelToggle"
			emoteWheelToggle.Parent = bindables
			v258 = emoteWheelToggle
		end

		v258:Fire()
	end)
	v116 = function(name, p7)
		local textButton: TextButton = Instance.new("TextButton")

		textButton.Name = name
		textButton.AnchorPoint = Vector2.new(0.5, 0.5)
		textButton.Position = p7
		textButton.Size = UDim2.fromOffset(75, 75)
		textButton.BackgroundColor3 = Color3.new(0, 0, 0)
		textButton.BackgroundTransparency = 0.5
		textButton.Text = ""
		textButton.Active = false
		textButton.AutoButtonColor = false
		textButton.Parent = buttons

		local uiCorner: UICorner = Instance.new("UICorner")

		uiCorner.CornerRadius = UDim.new(1, 0)
		uiCorner.Parent = textButton

		local abilityIcon: ImageLabel = Instance.new("ImageLabel")

		abilityIcon.Name = "AbilityIcon"
		abilityIcon.AnchorPoint = Vector2.new(0.5, 0.5)
		abilityIcon.Position = UDim2.fromScale(0.5, 0.5)
		abilityIcon.Size = UDim2.fromScale(0.65, 0.65)
		abilityIcon.BackgroundTransparency = 1
		abilityIcon.Image = ""
		abilityIcon.ScaleType = Enum.ScaleType.Fit
		abilityIcon.Parent = textButton

		local cooldownOverlay: Frame = Instance.new("Frame")

		cooldownOverlay.Name = "CooldownOverlay"
		cooldownOverlay.AnchorPoint = Vector2.new(0.5, 0.5)
		cooldownOverlay.Position = UDim2.fromScale(0.5, 0.5)
		cooldownOverlay.Size = UDim2.fromScale(1, 1)
		cooldownOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
		cooldownOverlay.BackgroundTransparency = 0.3
		cooldownOverlay.Visible = false
		cooldownOverlay.ZIndex = 2
		cooldownOverlay.Parent = textButton

		local uiCorner2: UICorner = Instance.new("UICorner")

		uiCorner2.CornerRadius = UDim.new(1, 0)
		uiCorner2.Parent = cooldownOverlay

		local uiGradient: UIGradient = Instance.new("UIGradient")

		uiGradient.Rotation = -90
		uiGradient.Parent = cooldownOverlay

		local cooldownText: TextLabel = Instance.new("TextLabel")

		cooldownText.Name = "CooldownText"
		cooldownText.AnchorPoint = Vector2.new(0.5, 0.5)
		cooldownText.Position = UDim2.fromScale(0.5, 0.5)
		cooldownText.Size = UDim2.fromScale(0.8, 0.5)
		cooldownText.BackgroundTransparency = 1
		cooldownText.Text = ""
		cooldownText.TextColor3 = Color3.new(1, 1, 1)
		cooldownText.TextScaled = true
		cooldownText.Font = Enum.Font.GothamBold
		cooldownText.ZIndex = 3
		cooldownText.Parent = textButton

		return textButton
	end
	v116("Ability1Button", UDim2.new(0.6, -80, 0, -100))
	v116("Ability2Button", UDim2.new(0.6, 10, 0, -100))

	return mobilePersistentHUD
end
local function buildWeaponGui(p8)
	local mobileWeaponHUD: ScreenGui = Instance.new("ScreenGui")

	mobileWeaponHUD.Name = "MobileWeaponHUD"
	mobileWeaponHUD.ResetOnSpawn = false
	mobileWeaponHUD.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	mobileWeaponHUD.DisplayOrder = 10
	mobileWeaponHUD.Enabled = false
	mobileWeaponHUD.Parent = u11

	local uiScale: UIScale = Instance.new("UIScale")

	uiScale.Scale = 1
	uiScale.Parent = mobileWeaponHUD

	local buttons: Frame = Instance.new("Frame")

	buttons.Name = "Buttons"
	buttons.AnchorPoint = Vector2.new(1, 1)
	buttons.Position = UDim2.new(1, 0, 1, 0)
	buttons.Size = UDim2.fromOffset(280, 290)
	buttons.BackgroundTransparency = 1
	buttons.BorderSizePixel = 0
	buttons.Parent = mobileWeaponHUD
	makeButton("FireButton", buttons, {
		size = 160,
		iconSize = 96,
		position = UDim2.new(0, 0, 0.4, 0),
		icon = if p8 then "rbxassetid://133938021699613" else "rbxassetid://93017761063406"
	})

	if p8 then
		makeButton("ADSButton", buttons, {
			size = 100,
			icon = "rbxassetid://92798512435516",
			iconSize = 64,
			position = UDim2.new(0.6, 0, 0, 0)
		})
	end

	makeButton("InspectButton", buttons, {
		size = 60,
		icon = "rbxassetid://91947797011988",
		iconSize = 36,
		position = UDim2.new(0.6, 20, 0, -180)
	})

	return mobileWeaponHUD
end

local httpService: HttpService = game:GetService("HttpService")

local function getControlOffsets()
	return t7
end
local function getControlScales()
	return t8
end
local function getScaleInstance(parent)
	local controlLayoutSCALE_INSTANCE_NAME = parent:FindFirstChild(controlLayout.SCALE_INSTANCE_NAME)

	if controlLayoutSCALE_INSTANCE_NAME and controlLayoutSCALE_INSTANCE_NAME:IsA("UIScale") then
		return controlLayoutSCALE_INSTANCE_NAME
	end

	local uiScale: UIScale = Instance.new("UIScale")

	uiScale.Name = controlLayout.SCALE_INSTANCE_NAME
	uiScale.Scale = 1
	uiScale.Parent = parent

	return uiScale
end
local function setButtonScale(parent, p11)
	local scale = math.clamp(p11, controlLayout.MIN_SCALE, controlLayout.MAX_SCALE)
	local controlLayoutSCALE_INSTANCE_NAME = parent:FindFirstChild(controlLayout.SCALE_INSTANCE_NAME)
	local v128

	if controlLayoutSCALE_INSTANCE_NAME and controlLayoutSCALE_INSTANCE_NAME:IsA("UIScale") then
		v128 = controlLayoutSCALE_INSTANCE_NAME
	else
		local uiScale: UIScale = Instance.new("UIScale")

		uiScale.Name = controlLayout.SCALE_INSTANCE_NAME
		uiScale.Scale = 1
		uiScale.Parent = parent
		v128 = uiScale
	end

	v128.Scale = scale

	local controlLayoutRESIZE_HANDLE_NAME = parent:FindFirstChild(controlLayout.RESIZE_HANDLE_NAME)
	local controlLayoutRESIZE_HANDLE_NAMEUiScale = controlLayoutRESIZE_HANDLE_NAME and controlLayoutRESIZE_HANDLE_NAME:FindFirstChildOfClass("UIScale")

	if controlLayoutRESIZE_HANDLE_NAMEUiScale then
		controlLayoutRESIZE_HANDLE_NAMEUiScale.Scale = 1 / scale
	end
end
local function applyButtonScale(parent, p13, p14)
	local v135 = p14[p13]

	if v135 then
		local scale = math.clamp(v135, controlLayout.MIN_SCALE, controlLayout.MAX_SCALE)
		local controlLayoutSCALE_INSTANCE_NAME = parent:FindFirstChild(controlLayout.SCALE_INSTANCE_NAME)
		local v138

		if controlLayoutSCALE_INSTANCE_NAME and controlLayoutSCALE_INSTANCE_NAME:IsA("UIScale") then
			v138 = controlLayoutSCALE_INSTANCE_NAME
		else
			local uiScale: UIScale = Instance.new("UIScale")

			uiScale.Name = controlLayout.SCALE_INSTANCE_NAME
			uiScale.Scale = 1
			uiScale.Parent = parent
			v138 = uiScale
		end

		v138.Scale = scale

		local controlLayoutRESIZE_HANDLE_NAME = parent:FindFirstChild(controlLayout.RESIZE_HANDLE_NAME)
		local controlLayoutRESIZE_HANDLE_NAMEUiScale = controlLayoutRESIZE_HANDLE_NAME and controlLayoutRESIZE_HANDLE_NAME:FindFirstChildOfClass("UIScale")

		if controlLayoutRESIZE_HANDLE_NAMEUiScale then
			controlLayoutRESIZE_HANDLE_NAMEUiScale.Scale = 1 / scale
		end

		return
	end

	local controlLayoutSCALE_INSTANCE_NAME = parent:FindFirstChild(controlLayout.SCALE_INSTANCE_NAME)

	if controlLayoutSCALE_INSTANCE_NAME and controlLayoutSCALE_INSTANCE_NAME:IsA("UIScale") then
		controlLayoutSCALE_INSTANCE_NAME.Scale = 1
	end
end
local function applyButtonOffset(p15, p16, p17)
	local v146 = p17[p16]

	if not v146 then
		return
	end

	local v147 = p15.Position

	p15.Position = UDim2.new(v147.X.Scale + v146.X, v147.X.Offset, v147.Y.Scale + v146.Y, v147.Y.Offset)
end

local t10: {[any]: any} = { FireButton = true, InspectButton = true }
local t11: {[any]: any} = {
	FireButton = UDim2.new(0, 0, 0.4, 0),
	ADSButton = UDim2.new(0.6, 0, 0, 0),
	InspectButton = UDim2.new(0.6, 20, 0, -180),
	SlideButton = UDim2.new(1, -210, 1, -60),
	SwapButton = UDim2.new(0, 60, 0.4, -130),
	Ability1Button = UDim2.new(0.6, -80, 0, -100),
	Ability2Button = UDim2.new(0.6, 10, 0, -100),
	EmoteButton = uDim2
}

local function applyLayoutToGui(p18, p19)
	local v150: {[any]: any} = t7
	local v151: {[any]: any} = t8

	local function walk(p20)
		if not p20 then
			return
		end

		for iterFirst, iterSecond in p20:GetChildren() do
			if iterSecond:IsA("TextButton") then
				local v272 = iterSecond.Name
				local v273 = t11[v272]

				if v273 then
					iterSecond.Position = v273
				end

				if p19 and t10[v272] or not p19 then
					local v274 = v150[v272]

					if v274 then
						local v275 = iterSecond.Position

						iterSecond.Position = UDim2.new(v275.X.Scale + v274.X, v275.X.Offset, v275.Y.Scale + v274.Y, v275.Y.Offset)
					end

					local v276 = v151[v272]

					if v276 then
						local scale = math.clamp(v276, controlLayout.MIN_SCALE, controlLayout.MAX_SCALE)
						local controlLayoutSCALE_INSTANCE_NAME = iterSecond:FindFirstChild(controlLayout.SCALE_INSTANCE_NAME)
						local v279

						if controlLayoutSCALE_INSTANCE_NAME and controlLayoutSCALE_INSTANCE_NAME:IsA("UIScale") then
							v279 = controlLayoutSCALE_INSTANCE_NAME
						else
							local uiScale: UIScale = Instance.new("UIScale")

							uiScale.Name = controlLayout.SCALE_INSTANCE_NAME
							uiScale.Scale = 1
							uiScale.Parent = iterSecond
							v279 = uiScale
						end

						v279.Scale = scale

						local controlLayoutRESIZE_HANDLE_NAME = iterSecond:FindFirstChild(controlLayout.RESIZE_HANDLE_NAME)

						if controlLayoutRESIZE_HANDLE_NAME then
							local uiScale = controlLayoutRESIZE_HANDLE_NAME:FindFirstChildOfClass("UIScale")

							if uiScale then
								uiScale.Scale = 1 / scale
							end
						end
					else
						local controlLayoutSCALE_INSTANCE_NAME = iterSecond:FindFirstChild(controlLayout.SCALE_INSTANCE_NAME)

						if controlLayoutSCALE_INSTANCE_NAME and controlLayoutSCALE_INSTANCE_NAME:IsA("UIScale") then
							controlLayoutSCALE_INSTANCE_NAME.Scale = 1
						end
					end
				end
			end
		end
	end

	walk(p18:FindFirstChild("Buttons"))
	walk(p18:FindFirstChild("ButtonsTL"))
end
local function reapplyAllLayout()
	if u17 and u17.Parent then
		applyLayoutToGui(u17)
	end

	if u18 and u18.Parent then
		local buttons = u18:FindFirstChild("Buttons")
		local adsButton = buttons and buttons:FindFirstChild("ADSButton")

		applyLayoutToGui(u18, not adsButton)
	end
end
local function clearConnections(p21)
	for iterFirst, iterSecond in p21 do
		iterSecond:Disconnect()
	end

	table.clear(p21)
end
local function setupPersistent()
	if not u17 then
		return
	end

	local v158: {[any]: any} = t6

	for iterFirst, iterSecond in v158 do
		iterSecond:Disconnect()
	end

	table.clear(v158)

	local buttons = u17:FindFirstChild("Buttons")

	if not buttons then
		return
	end

	local slideButton = buttons:FindFirstChild("SlideButton")
	local swapButton = buttons:FindFirstChild("SwapButton")

	if slideButton then
		table.insert(t6, slideButton.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch and input.UserInputState ~= Enum.UserInputState.Change then
				local Character = LocalPlayer.Character
				local u286

				if not Character then
					u286 = false
				else
					local humanoid = Character:FindFirstChildOfClass("Humanoid")

					u286 = false

					if humanoid ~= nil then
						u286 = humanoid.Health > 0
					end
				end

				if not u286 then
				elseif u22 == nil then
					u22 = input
					slideButton.BackgroundTransparency = 0.15

					local Character2 = LocalPlayer.Character

					if Character2 then
						Character2:SetAttribute("MobileSlide", true)
					end

					return
				end

				return
			end
		end))
		table.insert(t6, userInputService.InputEnded:Connect(function(input: InputObject)
			if input == u22 then
				u22 = nil
				slideButton.BackgroundTransparency = 0.5

				local Character = LocalPlayer.Character

				if Character then
					Character:SetAttribute("MobileSlide", false)
				end
			end
		end))
	end

	if swapButton then
		local function refreshSwapIcon()
			local knifeIcon = swapButton:FindFirstChild("KnifeIcon")
			local revolverIcon = swapButton:FindFirstChild("RevolverIcon")

			if knifeIcon and revolverIcon then
				if getEquippedToolName() == "Knife" then
					knifeIcon.Visible = false
					revolverIcon.Visible = true

					return
				end

				knifeIcon.Visible = true
				revolverIcon.Visible = false

				return
			end
		end

		table.insert(t6, swapButton.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch and input.UserInputState ~= Enum.UserInputState.Change then
				local Character = LocalPlayer.Character
				local u295

				if not Character then
					u295 = false
				else
					local humanoid = Character:FindFirstChildOfClass("Humanoid")

					u295 = false

					if humanoid ~= nil then
						u295 = humanoid.Health > 0
					end
				end

				if u295 then
					local u297

					if workspace:GetAttribute("LoadingScreenCompleted") ~= true or not LocalPlayer:GetAttribute("BackpackEnabled") then
						u297 = false
					else
						local matchId = LocalPlayer:GetAttribute("MatchId")

						u297 = false

						if matchId ~= nil then
							u297 = matchId ~= ""
						end
					end

					if not u297 then
						return
					end

					local v299 = os.clock()

					if v299 - n1 < 0.2 then
						return
					end

					n1 = v299
					v299 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

					if not v299 then
						return
					end

					if not v299:IsDescendantOf(workspace) then
						warn("nice bug buddy, nice try")

						return
					end

					local v300 = getEquippedToolName()
					local n3 = 0

					for key, value in t4 do
						if value == v300 then
							n3 = key

							break
						end
					end

					local n2 = n3 + 1

					if n2 > #t4 then
						n2 = 1
					end

					n3 = findTool(t4[n2])

					if n3 and v300 ~= n3.Name then
						v299:EquipTool(n3)
					end

					return
				end

				return
			end
		end))

		local function watchCharForSwapIcon(p25)
			table.insert(t6, p25.ChildAdded:Connect(function(p26)
				if p26:IsA("Tool") then
					local knifeIcon = swapButton:FindFirstChild("KnifeIcon")
					local revolverIcon = swapButton:FindFirstChild("RevolverIcon")

					if not knifeIcon then
						return
					end

					if not revolverIcon then
						return
					end

					if getEquippedToolName() == "Knife" then
						knifeIcon.Visible = false
						revolverIcon.Visible = true

						return
					end

					knifeIcon.Visible = true
					revolverIcon.Visible = false

					return
				end
			end))
			table.insert(t6, p25.ChildRemoved:Connect(function(p27)
				if p27:IsA("Tool") then
					local knifeIcon = swapButton:FindFirstChild("KnifeIcon")
					local revolverIcon = swapButton:FindFirstChild("RevolverIcon")

					if not knifeIcon then
						return
					end

					if not revolverIcon then
						return
					end

					if getEquippedToolName() == "Knife" then
						knifeIcon.Visible = false
						revolverIcon.Visible = true

						return
					end

					knifeIcon.Visible = true
					revolverIcon.Visible = false

					return
				end
			end))

			local knifeIcon = swapButton:FindFirstChild("KnifeIcon")
			local revolverIcon = swapButton:FindFirstChild("RevolverIcon")

			if not knifeIcon then
				return
			end

			if not revolverIcon then
				return
			end

			if getEquippedToolName() == "Knife" then
				knifeIcon.Visible = false
				revolverIcon.Visible = true

				return
			end

			knifeIcon.Visible = true
			revolverIcon.Visible = false
		end

		if LocalPlayer.Character then
			watchCharForSwapIcon(LocalPlayer.Character)
		end

		table.insert(t6, LocalPlayer.CharacterAdded:Connect(function(p28)
			watchCharForSwapIcon(p28)
		end))
	end

	task.spawn(function()
		local v309 = LocalPlayer:GetAttributeChangedSignal("MouseUnlocked")

		table.insert(t6, v309:Connect(refreshVisibility))

		local function watchHudFrame(p29)
			local hud = u11:WaitForChild("HUD", 10)

			if not hud then
				return
			end

			local foundChild = hud:FindFirstChild(p29)

			if foundChild and foundChild:IsA("GuiObject") then
				local v373 = foundChild:GetPropertyChangedSignal("Visible")

				table.insert(t6, v373:Connect(refreshVisibility))

				return
			end

			local effects = hud:FindFirstChild("Effects")

			if effects then
				local foundChild2 = effects:FindFirstChild(p29)

				if foundChild2 and foundChild2:IsA("GuiObject") then
					local v376 = foundChild2:GetPropertyChangedSignal("Visible")

					table.insert(t6, v376:Connect(refreshVisibility))

					return
				end

				return
			end
		end

		for key, value2 in t1 do
			watchHudFrame(value2)
		end

		watchHudFrame = function(childName)
			local v378 = u11:WaitForChild(childName, 10)

			if v378 and v378:IsA("ScreenGui") then
				local v379 = v378:GetPropertyChangedSignal("Enabled")

				table.insert(t6, v379:Connect(refreshVisibility))
			end
		end

		for iterFirst, value in { "Spinner", "InspectHUD" }, nil, nil do
			local v315 = u11:WaitForChild(value, 10)

			if v315 and v315:IsA("ScreenGui") then
				local v316 = v315:GetPropertyChangedSignal("Enabled")

				table.insert(t6, v316:Connect(refreshVisibility))
			end
		end

		watchHudFrame = function(childName, p32)
			local v382 = u11:WaitForChild(childName, 10)

			if not v382 then
				return
			end

			local foundChild = v382:FindFirstChild(p32)

			if foundChild and foundChild:IsA("GuiObject") then
				local v384 = foundChild:GetPropertyChangedSignal("Visible")

				table.insert(t6, v384:Connect(refreshVisibility))
			end
		end
		watchHudFrame("WinScreen", "WinLossScreen")
		watchHudFrame("MapVote", "MapSelect")
		watchHudFrame("MapVote", "LoadingScreen")
	end)

	local function hookChar(p33)
		local humanoid = p33:WaitForChild("Humanoid", 5)

		if not humanoid then
			return
		end

		local v319 = humanoid:GetPropertyChangedSignal("Health")

		table.insert(t6, v319:Connect(refreshVisibility))
		table.insert(t6, humanoid.Died:Connect(refreshVisibility))

		local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")

		if backpack then
			table.insert(t6, backpack.ChildAdded:Connect(refreshVisibility))
			table.insert(t6, backpack.ChildRemoved:Connect(refreshVisibility))
		end

		table.insert(t6, p33.ChildAdded:Connect(refreshVisibility))
		table.insert(t6, p33.ChildRemoved:Connect(refreshVisibility))
		task.defer(refreshVisibility)
	end

	table.insert(t6, LocalPlayer.CharacterAdded:Connect(hookChar))

	if LocalPlayer.Character then
		task.spawn(hookChar, LocalPlayer.Character)
	end

	local v167 = u17 and u17:FindFirstChild("Buttons")

	if v167 then
		local castAbility1: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Bindables"):WaitForChild("CastAbility1")
		local castAbility2: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Bindables"):WaitForChild("CastAbility2")
		local ability1Button = v167:FindFirstChild("Ability1Button")
		local ability2Button = v167:FindFirstChild("Ability2Button")

		if ability1Button then
			table.insert(t6, ability1Button.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.Touch and input.UserInputState ~= Enum.UserInputState.Change then
					local Character = LocalPlayer.Character
					local u323

					if not Character then
						u323 = false
					else
						local humanoid = Character:FindFirstChildOfClass("Humanoid")

						u323 = false

						if humanoid ~= nil then
							u323 = humanoid.Health > 0
						end
					end

					if not u323 then
						return
					end

					castAbility1:Fire()

					return
				end
			end))
		end

		if ability2Button then
			table.insert(t6, ability2Button.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.Touch and input.UserInputState ~= Enum.UserInputState.Change then
					local Character = LocalPlayer.Character
					local u327

					if not Character then
						u327 = false
					else
						local humanoid = Character:FindFirstChildOfClass("Humanoid")

						u327 = false

						if humanoid ~= nil then
							u327 = humanoid.Health > 0
						end
					end

					if not u327 then
						return
					end

					castAbility2:Fire()

					return
				end
			end))
		end

		local function refreshAbilityIcons()
			if ability1Button then
				local ability1Icon = LocalPlayer:GetAttribute("Ability1Icon")
				local abilityIcon = ability1Button:FindFirstChild("AbilityIcon")

				if abilityIcon then
					abilityIcon.Image = typeof(ability1Icon) == "string" and ability1Icon ~= "" and ability1Icon or ""
				end

				local u331: boolean = false

				if typeof(ability1Icon) == "string" then
					u331 = ability1Icon ~= ""
				end

				ability1Button.Visible = u331
			end

			if ability2Button then
				local ability2Icon = LocalPlayer:GetAttribute("Ability2Icon")
				local abilityIcon = ability2Button:FindFirstChild("AbilityIcon")

				if abilityIcon then
					abilityIcon.Image = typeof(ability2Icon) == "string" and ability2Icon ~= "" and ability2Icon or ""
				end

				local u334: boolean = false

				if typeof(ability2Icon) == "string" then
					u334 = ability2Icon ~= ""
				end

				ability2Button.Visible = u334
			end
		end

		refreshAbilityIcons()

		local v173 = LocalPlayer:GetAttributeChangedSignal("Ability1Icon")

		table.insert(t6, v173:Connect(refreshAbilityIcons))
		v173 = LocalPlayer:GetAttributeChangedSignal("Ability2Icon")
		table.insert(t6, v173:Connect(refreshAbilityIcons))

		local t12: {[any]: any} = {}
		local t13: {[any]: any} = {}

		local function startCooldownVisual(p36, p37)
			local v337 = t13[p36]

			if v337 then
				v337:Disconnect()
				t13[p36] = nil
			end

			if p37 <= 0 then
				local cooldownOverlay = p36:FindFirstChild("CooldownOverlay")

				if cooldownOverlay then
					cooldownOverlay.Visible = false
				end

				local cooldownText = p36:FindFirstChild("CooldownText")

				if cooldownText then
					cooldownText.Text = ""
				end

				return
			end

			if p37 >= 9000000000 then
				local cooldownOverlay = p36:FindFirstChild("CooldownOverlay")

				if cooldownOverlay then
					cooldownOverlay.Visible = true

					local uiGradient = cooldownOverlay:FindFirstChildOfClass("UIGradient")

					if uiGradient then
						uiGradient.Transparency = NumberSequence.new(0)
					end
				end

				local cooldownText = p36:FindFirstChild("CooldownText")

				if cooldownText then
					cooldownText.Text = ""
				end

				return
			end

			local cooldownOverlay = p36:FindFirstChild("CooldownOverlay")
			local cooldownOverlayUiGradient = cooldownOverlay and cooldownOverlay:FindFirstChildOfClass("UIGradient")
			local cooldownText = p36:FindFirstChild("CooldownText")

			if cooldownOverlay and cooldownOverlayUiGradient then
				cooldownOverlay.Visible = true

				local n1 = os.clock() + p37
				local connection = nil

				connection = runService.Heartbeat:Connect(function()
					local v385 = os.clock()
					local n2 = n1 - v385

					if n2 <= 0 then
						if connection then
							connection:Disconnect()
						end

						t13[p36] = nil
						cooldownOverlay.Visible = false

						if cooldownText then
							cooldownText.Text = ""
						end

						return
					end

					v385 = n2 / p37

					local v387 = math.max(0.001, v385 - 0.003)
					local v388 = math.min(0.999, v385 + 0.003)

					if v387 >= v388 then
						v387 = v388 - 0.001
					end

					local numberSequenceNew = NumberSequence.new
					local numberSequenceKeypoint = NumberSequenceKeypoint.new(v387, 0)
					local numberSequenceKeypoint2 = NumberSequenceKeypoint.new(v388, 1)

					cooldownOverlayUiGradient.Transparency = numberSequenceNew({
						NumberSequenceKeypoint.new(0, 0),
						numberSequenceKeypoint,
						numberSequenceKeypoint2,
						NumberSequenceKeypoint.new(1, 1)
					})

					if cooldownText then
						local floored = math.floor(n2 * 10 + 0.5)

						cooldownText.Text = string.format("%.1fs", floored / 10)
					end
				end)
				table.insert(t12, connection)
				t13[p36] = connection

				return
			end
		end
		local function onCooldownChanged(p38)
			local v349 = if p38 == "1" then ability1Button else ability2Button

			if not v349 then
				return
			end

			local attributeValue = LocalPlayer:GetAttribute("Ability" .. p38 .. "CooldownDuration")
			local attributeValue2 = LocalPlayer:GetAttribute("Ability" .. p38 .. "CooldownStartedAt")

			if typeof(attributeValue) == "number" and typeof(attributeValue2) == "number" then
				local v352 = os.clock()
				local v353 = math.max(0, attributeValue - (v352 - attributeValue2))

				startCooldownVisual(v349, v353)

				return
			end
		end

		local v178 = LocalPlayer:GetAttributeChangedSignal("Ability1CooldownStartedAt")

		table.insert(t6, v178:Connect(function()
			onCooldownChanged("1")
		end))
		v178 = LocalPlayer:GetAttributeChangedSignal("Ability2CooldownStartedAt")
		table.insert(t6, v178:Connect(function()
			onCooldownChanged("2")
		end))
	end
end
local function setupWeaponButtons()
	if not u18 then
		return
	end

	local v179: {[any]: any} = t5

	for iterFirst, iterSecond in v179 do
		iterSecond:Disconnect()
	end

	table.clear(v179)
	u19 = false

	local buttons = u18:FindFirstChild("Buttons")
	local fireButton = buttons and buttons:FindFirstChild("FireButton")
	local adsButton = buttons and buttons:FindFirstChild("ADSButton")
	local inspectButton = buttons and buttons:FindFirstChild("InspectButton")

	u23 = nil

	if fireButton then
		table.insert(t5, fireButton.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.Touch or input.UserInputState == Enum.UserInputState.Change then
			elseif u23 == nil then
				u23 = input

				if t9.onFire then
					t9.onFire()
				end

				return
			end
		end))
		table.insert(t5, userInputService.InputEnded:Connect(function(input: InputObject)
			if input == u23 then
				u23 = nil

				if t9.onFireRelease then
					t9.onFireRelease()
				end
			end
		end))
	end

	if adsButton then
		local function updateADSVisual()
			if u19 then
				adsButton.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
				adsButton.BackgroundTransparency = 0.15

				return
			end

			adsButton.BackgroundColor3 = Color3.fromRGB()
			adsButton.BackgroundTransparency = 0.5
		end

		table.insert(t5, adsButton.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch and input.UserInputState ~= Enum.UserInputState.Change then
				if u19 then
					u19 = false

					if u19 then
						adsButton.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
						adsButton.BackgroundTransparency = 0.15
					else
						adsButton.BackgroundColor3 = Color3.fromRGB()
						adsButton.BackgroundTransparency = 0.5
					end

					if t9.onADSExit then
						t9.onADSExit()
					end
				elseif t9.onADSEnter and t9.onADSEnter() then
					u19 = true

					if u19 then
						adsButton.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
						adsButton.BackgroundTransparency = 0.15

						return
					end

					adsButton.BackgroundColor3 = Color3.fromRGB()
					adsButton.BackgroundTransparency = 0.5

					return
				end

				return
			end
		end))
	end

	if inspectButton then
		table.insert(t5, inspectButton.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch and input.UserInputState ~= Enum.UserInputState.Change then
				if t9.onInspect then
					t9.onInspect()
				end

				return
			end
		end))
	end
end
local function addResizeHandle(parent)
	local v188 = math.clamp(parent.Size.X.Offset * 0.34, 40, 52)
	local imageButton: ImageButton = Instance.new("ImageButton")

	imageButton.Name = controlLayout.RESIZE_HANDLE_NAME
	imageButton.AnchorPoint = Vector2.new(0.5, 0.5)
	imageButton.Position = UDim2.fromScale(0, 0)
	imageButton.Size = UDim2.fromOffset(v188, v188)
	imageButton.BackgroundColor3 = Color3.new(0, 0, 0)
	imageButton.BackgroundTransparency = 0.5
	imageButton.Image = ""
	imageButton.AutoButtonColor = false
	imageButton.Active = true
	imageButton.ZIndex = 5
	imageButton.Parent = parent

	local uiCorner: UICorner = Instance.new("UICorner")

	uiCorner.CornerRadius = UDim.new(1, 0)
	uiCorner.Parent = imageButton

	local iconLabel: ImageLabel = Instance.new("ImageLabel")

	iconLabel.Name = "IconLabel"
	iconLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	iconLabel.Position = UDim2.fromScale(0.5, 0.5)
	iconLabel.Size = UDim2.fromScale(0.6, 0.6)
	iconLabel.BackgroundTransparency = 1
	iconLabel.Image = "rbxassetid://90192937456122"
	iconLabel.ScaleType = Enum.ScaleType.Fit
	iconLabel.ZIndex = 6
	iconLabel.Parent = imageButton

	local uiShadow: UIShadow = Instance.new("UIShadow")

	uiShadow.Color = Color3.new(0, 0, 0)
	uiShadow.Offset = UDim2.fromScale(0, 0.05)
	uiShadow.Spread = UDim2.fromScale(0.08, 0.08)
	uiShadow.Transparency = 0.35
	uiShadow.Parent = imageButton

	local counterScale: UIScale = Instance.new("UIScale")

	counterScale.Name = "CounterScale"
	counterScale.Scale = 1
	counterScale.Parent = imageButton

	return imageButton
end

return {
	init = function(_)
		if u16 then
			return
		end

		if not userInputService.TouchEnabled then
			return
		end

		LocalPlayer = players.LocalPlayer

		if not LocalPlayer then
			return
		end

		u11 = LocalPlayer:WaitForChild("PlayerGui")
		u16 = true

		local mobilePersistentHUD = u11:FindFirstChild("MobilePersistentHUD")

		if mobilePersistentHUD then
			mobilePersistentHUD:Destroy()
		end

		u17 = buildPersistentGui()
		applyLayoutToGui(u17)
		setupPersistent()
		refreshVisibility()

		local touchGui = u11:FindFirstChild("TouchGui")

		if touchGui then
			touchGui.DisplayOrder = 1
		else
			u11.ChildAdded:Connect(function(p44)
				if p44.Name == "TouchGui" and p44:IsA("ScreenGui") then
					p44.DisplayOrder = 1
				end
			end)
		end

		LocalPlayer:GetAttributeChangedSignal("ControlOffsetsJSON"):Connect(reapplyAllLayout)
		LocalPlayer:GetAttributeChangedSignal("ControlScalesJSON"):Connect(reapplyAllLayout)
		task.delay(3, function()
			if u17 and u17.Parent then
				applyLayoutToGui(u17)
			end
		end)
	end,
	equipWeapon = function(p45, p46)
		if not u16 then
			return
		end

		p45:unequipWeapon()
		t9.onFire = p46.onFire
		t9.onFireRelease = p46.onFireRelease
		t9.onADSEnter = p46.onADSEnter
		t9.onADSExit = p46.onADSExit
		t9.onInspect = p46.onInspect

		local mobileWeaponHUD = u11:FindFirstChild("MobileWeaponHUD")

		if mobileWeaponHUD then
			mobileWeaponHUD:Destroy()
		end

		u18 = buildWeaponGui(p46.hasADS == true)
		applyLayoutToGui(u18, p46.isKnife)
		setupWeaponButtons()
		refreshVisibility()
	end,
	unequipWeapon = function(_)
		if not u16 then
			return
		end

		if u23 ~= nil then
			u23 = nil

			if t9.onFireRelease then
				t9.onFireRelease()
			end
		end

		local v201: {[any]: any} = t5

		for iterFirst, iterSecond in v201 do
			iterSecond:Disconnect()
		end

		table.clear(v201)
		t9 = {}
		u19 = false

		if u18 then
			u18:Destroy()
			u18 = nil
		end
	end,
	setWeaponButtonsOverride = function(_, p49)
		local u206: boolean = p49 == true

		if u206 == u21 then
			return
		end

		u21 = u206

		if u16 then
			refreshVisibility()
		end
	end,
	forceADSOff = function(_)
		if u19 then
			u19 = false

			if u18 then
				local buttons = u18:FindFirstChild("Buttons")
				local adsButton = buttons and buttons:FindFirstChild("ADSButton")

				if adsButton then
					adsButton.BackgroundColor3 = Color3.fromRGB()
					adsButton.BackgroundTransparency = 0.5
				end
			end
		end
	end,
	setControlOffsets = function(_, p52)
		if p52 then
			t7 = p52
		else
			t7 = {}
		end

		local v212 = LocalPlayer

		if not v212 then
			v212 = game:GetService("Players").LocalPlayer
		end

		if v212 then
			local s1: string = ""

			if p52 then
				local u214: boolean = false

				for iterKey in pairs(p52) do
					u214 = true

					break
				end

				if u214 then
					s1 = httpService:JSONEncode(p52)
				end
			end

			v212:SetAttribute("ControlOffsetsJSON", s1)
		end

		if u16 then
			if u17 and u17.Parent then
				applyLayoutToGui(u17)
			end

			if u18 and u18.Parent then
				local buttons = u18:FindFirstChild("Buttons")
				local adsButton = buttons and buttons:FindFirstChild("ADSButton")

				applyLayoutToGui(u18, not adsButton)
			end
		end
	end,
	setControlScales = function(_, p54)
		if p54 then
			t8 = p54
		else
			t8 = {}
		end

		local v220 = LocalPlayer

		if not v220 then
			v220 = game:GetService("Players").LocalPlayer
		end

		if v220 then
			local s1: string = ""

			if p54 then
				local u222: boolean = false

				for iterKey in pairs(p54) do
					u222 = true

					break
				end

				if u222 then
					s1 = httpService:JSONEncode(p54)
				end
			end

			v220:SetAttribute("ControlScalesJSON", s1)
		end

		if u16 then
			if u17 and u17.Parent then
				applyLayoutToGui(u17)
			end

			if u18 and u18.Parent then
				local buttons = u18:FindFirstChild("Buttons")
				local adsButton = buttons and buttons:FindFirstChild("ADSButton")

				applyLayoutToGui(u18, not adsButton)
			end
		end
	end,
	setButtonScale = function(_, parent, p57)
		local scale = math.clamp(p57, controlLayout.MIN_SCALE, controlLayout.MAX_SCALE)
		local controlLayoutSCALE_INSTANCE_NAME = parent:FindFirstChild(controlLayout.SCALE_INSTANCE_NAME)
		local v231

		if controlLayoutSCALE_INSTANCE_NAME and controlLayoutSCALE_INSTANCE_NAME:IsA("UIScale") then
			v231 = controlLayoutSCALE_INSTANCE_NAME
		else
			local uiScale: UIScale = Instance.new("UIScale")

			uiScale.Name = controlLayout.SCALE_INSTANCE_NAME
			uiScale.Scale = 1
			uiScale.Parent = parent
			v231 = uiScale
		end

		v231.Scale = scale

		local controlLayoutRESIZE_HANDLE_NAME = parent:FindFirstChild(controlLayout.RESIZE_HANDLE_NAME)
		local controlLayoutRESIZE_HANDLE_NAMEUiScale = controlLayoutRESIZE_HANDLE_NAME and controlLayoutRESIZE_HANDLE_NAME:FindFirstChildOfClass("UIScale")

		if controlLayoutRESIZE_HANDLE_NAMEUiScale then
			controlLayoutRESIZE_HANDLE_NAMEUiScale.Scale = 1 / scale
		end
	end,
	buildEditPreview = function(_)
		local editPreview_Weapon: ScreenGui = Instance.new("ScreenGui")

		editPreview_Weapon.Name = "EditPreview_Weapon"
		editPreview_Weapon.ResetOnSpawn = false
		editPreview_Weapon.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		editPreview_Weapon.DisplayOrder = 10
		editPreview_Weapon.Enabled = true
		editPreview_Weapon.Parent = u11

		local uiScale: UIScale = Instance.new("UIScale")

		uiScale.Scale = 1
		uiScale.Parent = editPreview_Weapon

		local buttons: Frame = Instance.new("Frame")

		buttons.Name = "Buttons"
		buttons.AnchorPoint = Vector2.new(1, 1)
		buttons.Position = UDim2.new(1, 0, 1, 0)
		buttons.Size = UDim2.fromOffset(280, 290)
		buttons.BackgroundTransparency = 1
		buttons.BorderSizePixel = 0
		buttons.Parent = editPreview_Weapon

		local v239 = makeButton("FireButton", buttons, {
			size = 160,
			icon = "rbxassetid://133938021699613",
			iconSize = 96,
			position = UDim2.new(0, 0, 0.4, 0)
		})

		v239.Active = true

		local v240 = makeButton("ADSButton", buttons, {
			size = 100,
			icon = "rbxassetid://92798512435516",
			iconSize = 64,
			position = UDim2.new(0.6, 0, 0, 0)
		})

		v240.Active = true

		local v241 = makeButton("InspectButton", buttons, {
			size = 60,
			icon = "rbxassetid://91947797011988",
			iconSize = 36,
			position = UDim2.new(0.6, 20, 0, -180)
		})

		v241.Active = true
		uiScale.Scale = 0.6

		local editPreview_Persistent: ScreenGui = Instance.new("ScreenGui")

		editPreview_Persistent.Name = "EditPreview_Persistent"
		editPreview_Persistent.ResetOnSpawn = false
		editPreview_Persistent.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		editPreview_Persistent.DisplayOrder = 9
		editPreview_Persistent.Enabled = true
		editPreview_Persistent.Parent = u11

		local uiScale2: UIScale = Instance.new("UIScale")

		uiScale2.Scale = 0.6
		uiScale2.Parent = editPreview_Persistent

		local frame: Frame = Instance.new("Frame")

		frame.Name = "Buttons"
		frame.AnchorPoint = Vector2.new(1, 1)
		frame.Position = UDim2.new(1, 0, 1, 0)
		frame.Size = UDim2.fromOffset(280, 290)
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		frame.Parent = editPreview_Persistent

		local v245 = makeButton("SlideButton", frame, {
			size = 75,
			icon = "rbxassetid://106034700566994",
			iconSize = 32,
			position = UDim2.new(1, -210, 1, -60)
		})

		v245.Active = true

		local v246 = makeButton("SwapButton", frame, { size = 75, position = UDim2.new(0, 60, 0.4, -130) })

		v246.Active = true

		local buttonsTL: Frame = Instance.new("Frame")

		buttonsTL.Name = "ButtonsTL"
		buttonsTL.Size = UDim2.fromScale(1, 1)
		buttonsTL.BackgroundTransparency = 1
		buttonsTL.BorderSizePixel = 0
		buttonsTL.Parent = editPreview_Persistent

		local v248 = makeButton("EmoteButton", buttonsTL, {
			size = 70,
			icon = "rbxassetid://124920256145531",
			iconSize = 48,
			position = uDim2
		})

		v248.Active = true

		local function makeEditAbilityBtn(name, p61)
			local textButton: TextButton = Instance.new("TextButton")

			textButton.Name = name
			textButton.AnchorPoint = Vector2.new(0.5, 0.5)
			textButton.Position = p61
			textButton.Size = UDim2.fromOffset(75, 75)
			textButton.BackgroundColor3 = Color3.new(0, 0, 0)
			textButton.BackgroundTransparency = 0.5
			textButton.Text = ""
			textButton.Active = true
			textButton.AutoButtonColor = false
			textButton.Parent = frame

			local uiCorner: UICorner = Instance.new("UICorner")

			uiCorner.CornerRadius = UDim.new(1, 0)
			uiCorner.Parent = textButton

			local label: TextLabel = Instance.new("TextLabel")

			label.Name = "Label"
			label.AnchorPoint = Vector2.new(0.5, 0.5)
			label.Position = UDim2.fromScale(0.5, 0.5)
			label.Size = UDim2.fromScale(0.7, 0.35)
			label.BackgroundTransparency = 1
			label.Text = if name == "Ability1Button" then "Q" else "E"
			label.TextColor3 = Color3.new(1, 1, 1)
			label.TextScaled = true
			label.Font = Enum.Font.GothamBold
			label.Parent = textButton

			return textButton
		end

		local v250 = makeEditAbilityBtn("Ability1Button", UDim2.new(0.6, -80, 0, -100))
		local v251 = makeEditAbilityBtn("Ability2Button", UDim2.new(0.6, 10, 0, -100))
		local t14: {[any]: any} = {
			FireButton = v239,
			ADSButton = v240,
			InspectButton = v241,
			SlideButton = v245,
			SwapButton = v246,
			EmoteButton = v248,
			Ability1Button = v250,
			Ability2Button = v251
		}

		for _, v in pairs(t14) do
			addResizeHandle(v)
		end

		return {
			weaponGui = editPreview_Weapon,
			persistentGui = editPreview_Persistent,
			buttons = t14
		}
	end,
	getDefaultPositions = function(_)
		return {
			FireButton = UDim2.new(0, 0, 0.4, 0),
			ADSButton = UDim2.new(0.6, 0, 0, 0),
			InspectButton = UDim2.new(0.6, 20, 0, -180),
			SlideButton = UDim2.new(1, -210, 1, -60),
			SwapButton = UDim2.new(0, 60, 0.4, -130),
			Ability1Button = UDim2.new(0.6, -80, 0, -100),
			Ability2Button = UDim2.new(0.6, 10, 0, -100),
			EmoteButton = uDim2
		}
	end
}
