-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local proximityPromptService: ProximityPromptService = game:GetService("ProximityPromptService")
local userInputService: UserInputService = game:GetService("UserInputService")
local tweenService: TweenService = game:GetService("TweenService")
local marketplaceService: MarketplaceService = game:GetService("MarketplaceService")
local shared: Instance = replicatedStorage:WaitForChild("Shared")

if not require(shared:WaitForChild("TradingPlazaGate")).IsTradingPlaza() then
	return
end

local windowBlur = require(shared:WaitForChild("WindowBlur"))
local packCatalog = require(shared:WaitForChild("PackCatalog"))
local uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))
local sound = require(replicatedStorage:WaitForChild("Sound"))
local LocalPlayer: Player = players.LocalPlayer
local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui")
local hud: Instance = playerGui:WaitForChild("HUD")
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local signRequest: Instance = remotes:WaitForChild("SignRequest")
local currencyBuyRequest: Instance = remotes:WaitForChild("CurrencyBuyRequest")
local packRequest: Instance = remotes:WaitForChild("PackRequest")
local packPush: Instance = remotes:WaitForChild("PackPush")
local activeWindowChanged: Instance = bindables:WaitForChild("ActiveWindowChanged")
local t1: {[any]: any} = {
	Booth = "rbxassetid://96972324507895",
	Wanted = "rbxassetid://87668126073991",
	Text = "rbxassetid://109436773248580"
}
local t2: {[any]: any} = {
	{
		Key = "Booth",
		Pack = "BoothSign",
		Label = "Booth Sign",
		Glyph = "B",
		HotkeyText = "1",
		Blurb = "Shows your booth on a sign you carry.",
		Hotkey = Enum.KeyCode.One
	},
	{
		Key = "Wanted",
		Pack = "WantedSign",
		Label = "Looking For... Sign",
		Glyph = "?",
		HotkeyText = "2",
		Editor = "Picker",
		Blurb = "Pick any item from the index to show what you want.",
		Hotkey = Enum.KeyCode.Two
	},
	{
		Key = "Text",
		Pack = "TextSign",
		Label = "Custom Text Sign",
		Glyph = "T",
		HotkeyText = "3",
		Editor = "Text",
		Blurb = "Write your own message. Owners of both other signs only.",
		Hotkey = Enum.KeyCode.Three,
		Requires = { "Booth", "Wanted" }
	}
}
local uDim2 = UDim2.new(0.3, 0, 0.8, 0)
local v25: boolean = userInputService.TouchEnabled and not userInputService.MouseEnabled
local uDim22 = UDim2.new(0.3, 0, 1.15, 0)

local function notify(p1)
	local _GNotify = _G.Notify

	if typeof(_GNotify) == "function" then
		pcall(function()
			_GNotify(p1)
		end)
	end
end
local function fail(p2)
	local t10: {[any]: any} = { notifType = "FailNotification", errorMessage = p2 }
	local _GNotify = _G.Notify

	if typeof(_GNotify) == "function" then
		pcall(function()
			_GNotify(t10)
		end)
	end
end
local function click()
	pcall(function()
		sound:Play("UI.Click", workspace)
	end)
end
local function signDef(p3)
	for _, v in ipairs(t2) do
		if p3 == v.Key then
			return v
		end
	end

	return nil
end
local function owns(p4)
	local v142, v143, v144 = ipairs(t2)
	local v145: boolean = false
	local v146

	for iterFirst, iterSecond in v142, v143, v144 do
		if p4 == iterSecond.Key then
			v146 = iterSecond
			v145 = true

			break
		end
	end

	if not v145 then
		v146 = nil
	end

	return v146 ~= nil and LocalPlayer:GetAttribute("OwnsPack_" .. v146.Pack) == true
end
local function unlocked(p5)
	if typeof(p5.Requires) == "table" then
		for _, v in ipairs(p5.Requires) do
			local v152, v153, v154 = ipairs(t2)
			local v155: boolean = false
			local v156

			for iterFirst, iterSecond in v152, v153, v154 do
				if v == iterSecond.Key then
					v156 = iterSecond
					v155 = true

					break
				end
			end

			if not v155 then
				v156 = nil
			end

			if v156 == nil or LocalPlayer:GetAttribute("OwnsPack_" .. v156.Pack) ~= true then
				return false
			end
		end

		return true
	end

	return true
end

local u33 = Font.fromEnum(Enum.Font.GothamBold)
local lobbyTopButtons: Instance = hud:FindFirstChild("LobbyTopButtons")
local playBtn: Instance = lobbyTopButtons and lobbyTopButtons:FindFirstChild("PlayBtn")
local v36: Instance = playBtn

if v36 then
	v36 = playBtn:FindFirstChildWhichIsA("TextLabel")
end

if v36 then
	u33 = v36.FontFace
end

local function makeLabel(parent, name, text, p9, p10, textColor3)
	local textLabel: TextLabel = Instance.new("TextLabel")

	textLabel.Name = name
	textLabel.BackgroundTransparency = 1
	textLabel.AnchorPoint = Vector2.new(0.5, 0)
	textLabel.Size = p9
	textLabel.Position = p10
	textLabel.FontFace = u33
	textLabel.TextScaled = true
	textLabel.TextWrapped = true
	textLabel.TextColor3 = textColor3
	textLabel.Text = text
	textLabel.ZIndex = 3

	local uiStroke: UIStroke = Instance.new("UIStroke")

	uiStroke.Thickness = 1.5
	uiStroke.Color = Color3.new(0, 0, 0)
	uiStroke.Parent = textLabel
	textLabel.Parent = parent

	return textLabel
end
local function makeButton(name, p13, parent, p15, p16)
	local textButton: TextButton = Instance.new("TextButton")

	textButton.Name = name
	textButton.AutoButtonColor = true
	textButton.AnchorPoint = Vector2.new(0.5, 0)
	textButton.Size = p15
	textButton.Position = p16
	textButton.BackgroundColor3 = Color3.new(1, 1, 1)
	textButton.Text = ""
	textButton.ZIndex = 3

	local uiCorner: UICorner = Instance.new("UICorner")

	uiCorner.CornerRadius = UDim.new(0.25, 0)
	uiCorner.Parent = textButton

	local uiGradient: UIGradient = Instance.new("UIGradient")
	local colorSequenceNew = ColorSequence.new

	uiGradient.Color = colorSequenceNew({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 201, 255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(24, 143, 237)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 45))
	})
	uiGradient.Rotation = 90
	uiGradient.Parent = textButton

	local uiStroke: UIStroke = Instance.new("UIStroke")

	uiStroke.Thickness = 2
	uiStroke.Color = Color3.new(0, 0, 0)
	uiStroke.Parent = textButton

	local v177 = UDim2.fromScale(0.9, 0.7)
	local v178 = UDim2.fromScale(0.5, 0.15)

	makeLabel(textButton, "Label", p13, v177, v178, Color3.new(1, 1, 1)).ZIndex = 4
	textButton.Parent = parent

	return textButton
end

makeButton = function(p17, text)
	local label = p17:FindFirstChild("Label")

	if label and label:IsA("TextLabel") then
		label.Text = text
	end
end

local color3 = Color3.fromRGB(204, 118, 74)
local color32 = Color3.fromRGB(228, 146, 96)
local color33 = Color3.fromRGB(128, 66, 34)
local color34 = Color3.fromRGB(150, 150, 155)

local function makeWoodButton(name, p20, image, parent, p23, p24)
	local textButton: TextButton = Instance.new("TextButton")

	textButton.Name = name
	textButton.AutoButtonColor = true
	textButton.AnchorPoint = Vector2.new(0.5, 0)
	textButton.Size = p23
	textButton.Position = p24
	textButton.BackgroundColor3 = color3
	textButton.BorderSizePixel = 0
	textButton.Text = ""
	textButton.ZIndex = 3
	textButton.ClipsDescendants = false

	local uiCorner: UICorner = Instance.new("UICorner")

	uiCorner.CornerRadius = UDim.new(0.14, 0)
	uiCorner.Parent = textButton

	local uiGradient: UIGradient = Instance.new("UIGradient")
	local colorSequenceNew = ColorSequence.new

	uiGradient.Color = colorSequenceNew({
		ColorSequenceKeypoint.new(0, color32),
		ColorSequenceKeypoint.new(0.45, color3),
		ColorSequenceKeypoint.new(1, color33)
	})
	uiGradient.Rotation = 90
	uiGradient.Parent = textButton

	local uiStroke: UIStroke = Instance.new("UIStroke")

	uiStroke.Thickness = 2.5
	uiStroke.Color = color33
	uiStroke.Parent = textButton

	for _, v in ipairs({
		{ 0.025, 0.14 },
		{ 0.975, 0.14 },
		{ 0.025, 0.86 },
		{ 0.975, 0.86 }
	}) do
		local bolt: Frame = Instance.new("Frame")

		bolt.Name = "Bolt"
		bolt.AnchorPoint = Vector2.new(0.5, 0.5)
		bolt.Position = UDim2.fromScale(v[1], v[2])
		bolt.Size = UDim2.fromScale(0.1, 0.1)
		bolt.SizeConstraint = Enum.SizeConstraint.RelativeYY
		bolt.BackgroundColor3 = color34
		bolt.BorderSizePixel = 0
		bolt.ZIndex = 5

		local uiCorner2: UICorner = Instance.new("UICorner")

		uiCorner2.CornerRadius = UDim.new(0.5, 0)
		uiCorner2.Parent = bolt

		local uiStroke2: UIStroke = Instance.new("UIStroke")

		uiStroke2.Thickness = 1.5
		uiStroke2.Color = Color3.fromRGB(60, 60, 64)
		uiStroke2.Parent = bolt
		bolt.Parent = textButton
	end

	if image and image ~= "" then
		local icon: ImageLabel = Instance.new("ImageLabel")

		icon.Name = "Icon"
		icon.BackgroundTransparency = 1
		icon.Image = image
		icon.ScaleType = Enum.ScaleType.Fit
		icon.AnchorPoint = Vector2.new(0.5, 0.5)
		icon.Position = UDim2.fromScale(0.06, 0.5)
		icon.Size = UDim2.fromScale(1.5, 1.5)
		icon.SizeConstraint = Enum.SizeConstraint.RelativeYY
		icon.ZIndex = 6
		icon.Parent = textButton
	end

	local v199 = UDim2.fromScale(0.62, 0.5)
	local v200 = UDim2.fromScale(if image and image ~= "" then 0.5 else 0.5, 0.1)
	local v201 = makeLabel(textButton, "Label", p20, v199, v200, Color3.new(1, 1, 1))

	v201.AnchorPoint = Vector2.new(0, 0)
	v201.Position = UDim2.fromScale(if image and image ~= "" then 0.19 else 0.19, 0.1)
	v201.TextXAlignment = if image and image ~= "" then Enum.TextXAlignment.Left else Enum.TextXAlignment.Center

	if not image or image == "" then
		v201.AnchorPoint = Vector2.new(0.5, 0)
		v201.Position = UDim2.fromScale(0.5, 0.1)
	end

	v201.ZIndex = 4
	v199 = UDim2.fromScale(0.4, 0.3)
	v200 = UDim2.fromScale(0.74, 0.62)
	v201 = makeLabel(textButton, "Price", "", v199, v200, Color3.fromRGB(80, 230, 110))
	v201.TextXAlignment = Enum.TextXAlignment.Right
	v201.ZIndex = 4
	textButton.Parent = parent

	return textButton
end
local function setButtonPrice(p25, text)
	local price = p25:FindFirstChild("Price")

	if price and price:IsA("TextLabel") then
		price.Text = text
	end
end
local function makeClose(parent)
	local boothWindow: Instance = hud:FindFirstChild("BoothWindow")

	boothWindow = boothWindow and boothWindow:FindFirstChild("CloseButton")

	if boothWindow and boothWindow:IsA("GuiButton") then
		local clone: Instance = boothWindow:Clone()

		clone.Visible = true
		clone.ZIndex = 5
		clone.Parent = parent

		return clone
	end

	local closeButton: TextButton = Instance.new("TextButton")

	closeButton.Name = "CloseButton"
	closeButton.AnchorPoint = Vector2.new(1, 0)
	closeButton.Position = UDim2.fromScale(0.985, 0.025)
	closeButton.Size = UDim2.fromScale(0.07, 0.1)
	closeButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
	closeButton.Text = "X"
	closeButton.TextScaled = true
	closeButton.FontFace = u33
	closeButton.TextColor3 = Color3.new(1, 1, 1)
	closeButton.ZIndex = 5

	local uiCorner: UICorner = Instance.new("UICorner")

	uiCorner.CornerRadius = UDim.new(0.25, 0)
	uiCorner.Parent = closeButton
	closeButton.Parent = parent

	return closeButton
end

local signBar: ScreenGui = Instance.new("ScreenGui")

signBar.Name = "SignBar"
signBar.ResetOnSpawn = false
signBar.DisplayOrder = 5
signBar.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
signBar.Parent = playerGui

local bar: Frame = Instance.new("Frame")

bar.Name = "Bar"
bar.BackgroundTransparency = 1
bar.AnchorPoint = Vector2.new(0, 1)
bar.Size = UDim2.fromScale(0.4, 0.1)
bar.Position = uDim2
bar.Parent = signBar

local slots: Frame = Instance.new("Frame")

slots.Name = "Slots"
slots.BackgroundTransparency = 1
slots.AnchorPoint = Vector2.new(0.5, 1)
slots.Position = UDim2.fromScale(0.5, 0.75)
slots.Size = UDim2.fromScale(1, 0.62)
slots.Parent = bar

local uiListLayout: UIListLayout = Instance.new("UIListLayout")

uiListLayout.FillDirection = Enum.FillDirection.Horizontal
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Padding = UDim.new(0, 8)
uiListLayout.Parent = slots

local t3: {[any]: any} = {}
local signHeld = nil
local u52 = nil
local u53 = nil
local u54 = nil

local function openEditorFor(p28)
	if p28.Editor == "Picker" then
		u52()
	elseif p28.Editor == "Text" then
		u53()
	end
end
local function buildSlot(p29, layoutOrder)
	local frame: Frame = Instance.new("Frame")

	frame.Name = p29.Key .. "Slot"
	frame.BackgroundTransparency = 1
	frame.Size = UDim2.fromScale(1, 1)
	frame.LayoutOrder = layoutOrder
	frame.SizeConstraint = Enum.SizeConstraint.RelativeYY
	frame.Parent = slots

	local parent, v215 = uiFramework.createItemCell("Common", {
		visible = true,
		active = true,
		interactable = true,
		selectable = true,
		icon = t1[p29.Key],
		name = p29.Key,
		keybind = p29.HotkeyText,
		parent = frame
	})

	parent.Size = UDim2.fromScale(1, 1)
	parent.Position = UDim2.new()

	local v216 = nil

	if t1[p29.Key] == "" then
		local glyph = p29.Glyph
		local v218 = UDim2.fromScale(0.7, 0.7)
		local v219 = UDim2.fromScale(0.5, 0.15)

		v216 = makeLabel(parent, "Glyph", glyph, v218, v219, Color3.new(1, 1, 1))
		v216.ZIndex = parent.ZIndex + 3
	end

	local v220 = nil

	if p29.Editor ~= nil then
		local textButton: TextButton = Instance.new("TextButton")

		textButton.Text = "⚙"
		textButton.TextScaled = true
		textButton.FontFace = u33
		textButton.TextColor3 = Color3.new(1, 1, 1)
		textButton.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
		textButton.BackgroundTransparency = 0.2

		local uiCorner: UICorner = Instance.new("UICorner")

		uiCorner.CornerRadius = UDim.new(0.5, 0)
		uiCorner.Parent = textButton

		local editCog: TextButton = textButton

		editCog.Name = "EditCog"
		editCog.AnchorPoint = Vector2.new(1, 0)
		editCog.Position = UDim2.fromScale(0.98, 0.02)
		editCog.Size = if v25 then UDim2.fromScale(0.44, 0.44) else UDim2.fromScale(0.34, 0.34)
		editCog.ZIndex = parent.ZIndex + 5
		editCog.Parent = parent
		editCog.MouseButton1Click:Connect(function()
			pcall(function()
				sound:Play("UI.Click", workspace)
			end)

			local v377 = p29

			if v377.Editor == "Picker" then
				u52()
			elseif v377.Editor == "Text" then
				u53()
			end
		end)
		v220 = editCog
	end

	local n1: number = 0
	local u225: boolean = false

	if p29.Editor ~= nil then
		parent.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			n1 += 1

			local v379: number = n1

			task.delay(0.45, function()
				if v379 ~= n1 then
					return
				end

				n1 += 1
				u225 = true
				pcall(function()
					sound:Play("UI.Click", workspace)
				end)

				local v399 = p29

				if v399.Editor == "Picker" then
					u52()
				elseif v399.Editor == "Text" then
					u53()
				end
			end)
		end)
		parent.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch then
				n1 += 1
			end
		end)
	end

	parent.MouseButton1Click:Connect(function()
		if u225 then
			u225 = false

			return
		end

		u54(p29.Key)
	end)

	return { host = frame, cell = parent, api = v215, cog = v220, glyph = v216 }
end
local function refreshBar()
	signHeld = LocalPlayer:GetAttribute("SignHeld")

	local u226: boolean = false

	for i, v in ipairs(t2) do
		local u229 = t3[v.Key]
		local vKey = v.Key
		local v231, v232, v233 = ipairs(t2)
		local v234: boolean = false
		local v235

		for iterFirst, iterSecond in v231, v232, v233 do
			if vKey == iterSecond.Key then
				v235 = iterSecond
				v234 = true

				break
			end
		end

		if not v234 then
			v235 = nil
		end

		local u238: boolean = v235 ~= nil and LocalPlayer:GetAttribute("OwnsPack_" .. v235.Pack) == true

		if u238 and u229 == nil then
			u229 = buildSlot(v, i)
			t3[v.Key] = u229
		end

		if u229 then
			u229.host.Visible = u238

			if u238 then
				u226 = true
				pcall(function()
					u229.api:setEquippedStyle(signHeld == v.Key)
				end)
				pcall(function()
					u229.api:setEquipped(signHeld == v.Key)
				end)
			end
		end
	end

	slots.Visible = u226
end

local u58 = nil
local u59 = false
local t4: {[any]: any} = { "Spinner", "InspectHUD" }
local u61 = false

local function anyOverlayOpen()
	local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")

	if playerGui == nil then
		return false
	end

	for _, v in ipairs(t4) do
		local v: Instance = playerGui:FindFirstChild(v)

		if v ~= nil and v:IsA("ScreenGui") and v.Enabled then
			return true
		end
	end

	return false
end
local function applyBar()
	local inMatch: any = LocalPlayer:GetAttribute("InMatch")
	local hideSignBar: any = LocalPlayer:GetAttribute("HideSignBar")

	bar.Visible = inMatch == nil and hideSignBar ~= true

	if u58 then
		u58:Cancel()
	end

	local v245: boolean = u59 or u61
	local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

	u58 = tweenService:Create(bar, tweenInfo, {
		Position = if v245 then uDim22 else uDim2
	})
	u58:Play()
end

task.spawn(function()
	local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui")

	for _, v in ipairs(t4) do
		task.spawn(function()
			local v381 = playerGui:WaitForChild(v, 30)

			if v381 == nil or not v381:IsA("ScreenGui") then
				return
			end

			v381:GetPropertyChangedSignal("Enabled"):Connect(function()
				local v400 = anyOverlayOpen()

				if v400 ~= u61 then
					u61 = v400
					applyBar()
				end
			end)
			v381 = anyOverlayOpen()

			if v381 ~= u61 then
				u61 = v381
				applyBar()
			end
		end)
	end
end)

local function makeWindow(text, image)
	local boothWindow: Instance = hud:FindFirstChild("BoothWindow")

	if boothWindow and boothWindow:IsA("ImageLabel") and boothWindow:FindFirstChild("Header") and boothWindow:FindFirstChild("CloseButton") then
		local clone: Instance = boothWindow:Clone()

		for _, v in ipairs(clone:GetChildren()) do
			if v.Name ~= "Header" and v.Name ~= "CloseButton" and not v:IsA("UIAspectRatioConstraint") then
				v:Destroy()
			end
		end

		for _, v in ipairs(clone.Header:GetDescendants()) do
			if v:IsA("TextLabel") then
				v.Text = text
			end

			if v:IsA("ImageLabel") and image and image ~= "" then
				v.Image = image
			end
		end

		clone.Visible = true

		return clone, clone.CloseButton
	end

	local imageLabel: ImageLabel = Instance.new("ImageLabel")

	imageLabel.Image = "rbxassetid://123485377870062"
	imageLabel.BackgroundTransparency = 1

	local v259 = UDim2.fromScale(0.8, 0.13)
	local v260 = UDim2.fromScale(0.5, 0.04)

	makeLabel(imageLabel, "Header", text, v259, v260, Color3.new(1, 1, 1))

	local v261 = makeClose(imageLabel)

	return imageLabel, v261
end

local shop, v66 = makeWindow("Sign Shop", "rbxassetid://113201942539768")

shop.Name = "Shop"
shop.AnchorPoint = Vector2.new(0.5, 0.5)
shop.Position = UDim2.fromScale(0.5, 0.5)
shop.Size = UDim2.fromScale(0.42, 0.42)
shop.Visible = false
shop.ZIndex = 2
shop.Parent = signBar

local t5: {[any]: any} = {}

for i, v in ipairs(t2) do
	local n1 = 0.17 + (i - 1) * 0.27
	local s1: string = v.Key .. "Blurb"
	local vBlurb = v.Blurb
	local v73 = UDim2.fromScale(0.86, 0.06)
	local v74 = UDim2.fromScale(0.5, n1)

	makeLabel(shop, s1, vBlurb, v73, v74, Color3.fromRGB(230, 230, 230))

	local vKey = v.Key

	s1 = v.Key .. "Buy"

	local vLabel = v.Label

	v73 = t1[v.Key]

	local v77 = UDim2.fromScale(0.74, 0.15)

	t5[vKey] = makeWoodButton(s1, vLabel, v73, shop, v77, UDim2.fromScale(0.54, n1 + 0.075))
end

local t6: {[any]: any} = {}

local function refreshShop()
	for _, v in ipairs(t2) do
		local v264 = t5[v.Key]
		local v265 = packCatalog.Get(v.Pack)
		local v266 = v265 and v265.BuyProductId or 0

		v265 = t6[v.Pack]

		local vKey = v.Key
		local v268, v269, v270 = ipairs(t2)
		local v271: boolean = false
		local v272

		for iterFirst, iterSecond in v268, v269, v270 do
			if vKey == iterSecond.Key then
				v272 = iterSecond
				v271 = true

				break
			end
		end

		if not v271 then
			v272 = nil
		end

		if v272 ~= nil and LocalPlayer:GetAttribute("OwnsPack_" .. v272.Pack) == true then
			local text: string = v.Label .. " (Owned)"
			local label = v264:FindFirstChild("Label")

			if label and label:IsA("TextLabel") then
				label.Text = text
			end

			local price = v264:FindFirstChild("Price")

			if price and price:IsA("TextLabel") then
				price.Text = ""
			end

			v264.BackgroundTransparency = 0.45
		elseif not unlocked(v) then
			local s2 = v.Label .. " (Locked)"
			local label = v264:FindFirstChild("Label")

			if label and label:IsA("TextLabel") then
				label.Text = s2
			end

			s2 = if v265 then ("%d"):format(v265) else ""

			local price = v264:FindFirstChild("Price")

			if price and price:IsA("TextLabel") then
				price.Text = s2
			end

			v264.BackgroundTransparency = 0.45
		elseif v266 == nil or v266 == 0 then
			local s3: string = v.Label .. " (Coming soon)"
			local label = v264:FindFirstChild("Label")

			if label and label:IsA("TextLabel") then
				label.Text = s3
			end

			local price = v264:FindFirstChild("Price")

			if price and price:IsA("TextLabel") then
				price.Text = ""
			end

			v264.BackgroundTransparency = 0.45
		else
			local vLabel = v.Label
			local label = v264:FindFirstChild("Label")

			if label and label:IsA("TextLabel") then
				label.Text = vLabel
			end

			local v286 = if v265 then ("%d"):format(v265) else ""
			local price = v264:FindFirstChild("Price")

			if price and price:IsA("TextLabel") then
				price.Text = v286
			end

			v264.BackgroundTransparency = 0
		end
	end
end

local u80: boolean = false

local function closeShop()
	if not u80 then
		return
	end

	u80 = false
	shop.Visible = false
	windowBlur.hide("SignShop")
end
local function openShop()
	if u80 then
		return
	end

	u80 = true
	activeWindowChanged:Fire("SignShop")
	windowBlur.show("SignShop")
	refreshShop()
	shop.Visible = true
	task.spawn(function()
		local ok, result = pcall(function()
			return packRequest:InvokeServer("GetState")
		end)

		if ok and typeof(result) == "table" and typeof(result.RobuxPrices) == "table" then
			for k, v in pairs(result.RobuxPrices) do
				if typeof(v) == "number" then
					t6[k] = v
				end
			end
		end

		for _, v in ipairs(t2) do
			if t6[v.Pack] == nil then
				local v388 = packCatalog.Get(v.Pack)

				if (v388 and v388.BuyProductId or 0) ~= 0 then
					local ok2, result2 = pcall(function()
						return marketplaceService:GetProductInfo(v401, Enum.InfoType.Product)
					end)

					if ok2 and typeof(result2) == "table" and typeof(result2.PriceInRobux) == "number" then
						t6[v.Pack] = result2.PriceInRobux
					end
				end
			end
		end

		if u80 then
			refreshShop()
		end
	end)
end

v66.MouseButton1Click:Connect(function()
	pcall(function()
		sound:Play("UI.Click", workspace)
	end)

	if not u80 then
		return
	end

	u80 = false
	shop.Visible = false
	windowBlur.hide("SignShop")
end)

for _, v in ipairs(t2) do
	t5[v.Key].MouseButton1Click:Connect(function()
		pcall(function()
			sound:Play("UI.Click", workspace)
		end)

		local v288 = v.Key
		local v289, v290, v291 = ipairs(t2)
		local v292: boolean = false
		local v293

		for iterFirst, iterSecond in v289, v290, v291 do
			if v288 == iterSecond.Key then
				v293 = iterSecond
				v292 = true

				break
			end
		end

		if not v292 then
			v293 = nil
		end

		if v293 ~= nil and LocalPlayer:GetAttribute("OwnsPack_" .. v293.Pack) == true then
			return
		end

		if not unlocked(v) then
			local t11: {[any]: any} = {
				notifType = "FailNotification",
				errorMessage = "Own the Booth Sign and Looking For sign first."
			}
			local _GNotify = _G.Notify

			if typeof(_GNotify) == "function" then
				pcall(function()
					_GNotify(t11)
				end)
			end

			return
		end

		local v298 = packCatalog.Get(v.Pack)

		v288 = v298 and v298.BuyProductId or 0

		if v288 == 0 then
			local t12: {[any]: any} = { notifType = "FailNotification", errorMessage = "Not on sale yet." }
			local notify = _G.Notify

			if typeof(notify) == "function" then
				pcall(function()
					notify(t12)
				end)
			end

			return
		end

		local showPurchaseModal: Instance = bindables:FindFirstChild("ShowPurchaseModal")

		if showPurchaseModal and showPurchaseModal:IsA("BindableEvent") then
			showPurchaseModal:Fire({
				ProductId = v288,
				Name = v298 and v298.DisplayName or v.Label,
				RobuxPrice = t6[v.Pack]
			})

			return
		end

		currencyBuyRequest:FireServer(v288)
	end)
end

local trading: Instance = hud:FindFirstChild("Trading")
local wantPicker: Instance = trading and trading:FindFirstChild("WantPicker")
local clone
local title
local sub
local scrollingFrame
local u91
local v92

if wantPicker and wantPicker:IsA("ImageLabel") and wantPicker:FindFirstChild("Items") and wantPicker:FindFirstChild("Empty") and wantPicker:FindFirstChild("CloseBtn") then
	clone = wantPicker:Clone()

	for _, v in ipairs(clone:GetDescendants()) do
		if v:IsA("LocalScript") or v:IsA("Script") then
			v:Destroy()
		end
	end

	title = clone:FindFirstChild("Title")
	sub = clone:FindFirstChild("Sub")
	scrollingFrame = clone.Items
	u91 = clone.Empty
	v92 = clone.CloseBtn
else
	clone = Instance.new("ImageLabel")
	clone.Image = "rbxassetid://123485377870062"
	clone.ScaleType = Enum.ScaleType.Slice
	clone.BackgroundTransparency = 1

	local v95 = clone
	local v96 = UDim2.fromScale(0.8, 0.12)
	local v97 = UDim2.fromScale(0.5, 0.03)

	title = makeLabel(v95, "Title", "", v96, v97, Color3.new(1, 1, 1))
	v95 = clone
	v96 = UDim2.fromScale(0.9, 0.07)
	v97 = UDim2.fromScale(0.5, 0.16)
	sub = makeLabel(v95, "Sub", "", v96, v97, Color3.fromRGB(220, 220, 220))
	scrollingFrame = Instance.new("ScrollingFrame")
	scrollingFrame.Name = "Items"
	scrollingFrame.BackgroundTransparency = 1
	scrollingFrame.Position = UDim2.fromScale(0.03, 0.26)
	scrollingFrame.Size = UDim2.fromScale(0.94, 0.71)
	scrollingFrame.CanvasSize = UDim2.new()
	scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scrollingFrame.ScrollBarThickness = 6

	local uiGridLayout: UIGridLayout = Instance.new("UIGridLayout")

	uiGridLayout.CellSize = UDim2.fromOffset(62, 62)
	uiGridLayout.CellPadding = UDim2.fromOffset(6, 6)
	uiGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiGridLayout.Parent = scrollingFrame
	scrollingFrame.Parent = clone
	v95 = clone
	v96 = UDim2.fromScale(0.9, 0.1)
	v97 = UDim2.fromScale(0.5, 0.5)
	u91 = makeLabel(v95, "Empty", "", v96, v97, Color3.new(1, 1, 1))
	v92 = makeClose(clone)
end

clone.Name = "Picker"
clone.Visible = false
clone.AnchorPoint = Vector2.new(0.5, 0.5)
clone.Position = UDim2.fromScale(0.5, 0.5)
clone.Size = UDim2.fromScale(0.5, 0.55)
clone.ZIndex = 10
clone.Parent = signBar

if title then
	title.Text = "LOOKING FOR..."
end

if sub then
	sub.Text = "Pick the item to show on your sign"
end

local u99: boolean = false
local t7: {[any]: any} = {}
local u101 = nil

local function clearPickerCells()
	for _, v in ipairs(t7) do
		pcall(function()
			v:destroy()
		end)
	end

	table.clear(t7)
end
local function closePicker()
	if not u99 then
		return
	end

	u99 = false
	clone.Visible = false
	clearPickerCells()
	windowBlur.hide("SignPicker")
end
local function choose(p35)
	if u99 then
		u99 = false
		clone.Visible = false
		clearPickerCells()
		windowBlur.hide("SignPicker")
	end

	local v305, v306 = signRequest:InvokeServer("SetWanted", p35.Kind, p35.ItemId)

	if v305 then
		local t13: {[any]: any} = {
			notifType = "SuccessNotification",
			topText = "Sign Updated",
			bottomText = ("Now looking for %s."):format((tostring(p35.Name)))
		}
		local _GNotify = _G.Notify

		if typeof(_GNotify) == "function" then
			pcall(function()
				_GNotify(t13)
			end)
		end

		refreshBar()

		return
	end

	local t14: {[any]: any} = {
		notifType = "FailNotification",
		errorMessage = tostring(v306 or "Couldn't update the sign.")
	}
	local notify = _G.Notify

	if typeof(notify) == "function" then
		pcall(function()
			notify(t14)
		end)
	end
end
local function renderPicker(p36)
	clearPickerCells()

	if not u99 then
		return
	end

	if #p36 == 0 then
		u91.Text = "Nothing to show."
		u91.Visible = true

		return
	end

	u91.Visible = false

	for i, v in ipairs(p36) do
		local uiFrameworkCreateItemCell = uiFramework.createItemCell
		local v315 = v.Rarity or "Common"
		local vIcon = v.Icon
		local v317 = ("Pick%d"):format(i)
		local v318, v319 = uiFrameworkCreateItemCell(v315, {
			visible = true,
			active = true,
			selectable = true,
			icon = vIcon,
			name = v317,
			parent = scrollingFrame,
			layoutOrder = i
		})

		v318.MouseButton1Click:Connect(function()
			pcall(function()
				sound:Play("UI.Click", workspace)
			end)
			choose(v)
		end)
		table.insert(t7, v319)
	end
end

u52 = function()
	if u99 then
		return
	end

	local v320, v321, v322 = ipairs(t2)
	local v323: boolean = false
	local v324

	for iterFirst, iterSecond in v320, v321, v322 do
		if iterSecond.Key == "Wanted" then
			v324 = iterSecond
			v323 = true

			break
		end
	end

	if not v323 then
		v324 = nil
	end

	if v324 == nil or LocalPlayer:GetAttribute("OwnsPack_" .. v324.Pack) ~= true then
		openShop()

		return
	end

	u99 = true
	activeWindowChanged:Fire("SignPicker")
	windowBlur.show("SignPicker")
	clone.Visible = true
	clearPickerCells()
	u91.Text = "Loading..."
	u91.Visible = true
	task.spawn(function()
		if u101 == nil then
			local itemIndex: Instance = remotes:WaitForChild("ItemIndex", 20)

			local ok, result = pcall(function()
				return itemIndex:InvokeServer("Catalog")
			end)

			if ok and typeof(result) == "table" then
				local t19: {[any]: any} = {}

				for _, v in ipairs(result) do
					if v.Kind ~= "Crate" then
						table.insert(t19, v)
					end
				end

				u101 = t19
			end
		end

		if not u99 then
			return
		end

		if u101 == nil then
			u91.Text = "The item index isn't available right now."
			u91.Visible = true

			return
		end

		renderPicker(u101)
	end)
end
v92.MouseButton1Click:Connect(function()
	pcall(function()
		sound:Play("UI.Click", workspace)
	end)

	if not u99 then
		return
	end

	u99 = false
	clone.Visible = false
	clearPickerCells()
	windowBlur.hide("SignPicker")
end)

local color35 = Color3.fromRGB(255, 72, 72)
local color36 = Color3.fromRGB(86, 156, 255)
local t8: {[any]: any} = { Name = "White", Color = Color3.new(1, 1, 1) }
local parent, v110 = makeWindow("Custom Text Sign", "rbxassetid://109436773248580")

parent.Name = "TextEditor"
parent.AnchorPoint = Vector2.new(0.5, 0.5)
parent.Position = UDim2.fromScale(0.5, 0.5)
parent.Size = UDim2.fromScale(0.4, 0.4)
parent.Visible = false
parent.ZIndex = 10
parent.Parent = signBar

local v111 = ("Up to %d characters. Filtered, and one change a minute."):format(40)
local v112 = UDim2.fromScale(0.86, 0.07)
local v113 = UDim2.fromScale(0.5, 0.2)

makeLabel(parent, "Hint", v111, v112, v113, Color3.fromRGB(220, 220, 220))

local input: TextBox = Instance.new("TextBox")

input.Name = "Input"
input.AnchorPoint = Vector2.new(0.5, 0)
input.Position = UDim2.fromScale(0.5, 0.3)
input.Size = UDim2.fromScale(0.86, 0.17)
input.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
input.BackgroundTransparency = 0.15
input.TextColor3 = Color3.new(1, 1, 1)
input.PlaceholderText = "Your sign text..."
input.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
input.FontFace = u33
input.TextScaled = true
input.ClearTextOnFocus = false
input.Text = ""
input.ZIndex = 12

local uiCorner: UICorner = Instance.new("UICorner")

uiCorner.CornerRadius = UDim.new(0.2, 0)
uiCorner.Parent = input

local uiStroke: UIStroke = Instance.new("UIStroke")

uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(70, 70, 80)
uiStroke.Parent = input

local uiPadding: UIPadding = Instance.new("UIPadding")

uiPadding.PaddingLeft = UDim.new(0, 10)
uiPadding.PaddingRight = UDim.new(0, 10)
uiPadding.Parent = input
input.Parent = parent
input:GetPropertyChangedSignal("Text"):Connect(function()
	if #input.Text > 40 then
		input.Text = input.Text:sub(1, 40)
	end
end)

local t9: {[any]: any} = {}
local colors: Frame = Instance.new("Frame")

colors.Name = "Colors"
colors.BackgroundTransparency = 1
colors.AnchorPoint = Vector2.new(0.5, 0)
colors.Position = UDim2.fromScale(0.5, 0.52)
colors.Size = UDim2.fromScale(0.5, 0.13)
colors.ZIndex = 12

local uiListLayout2: UIListLayout = Instance.new("UIListLayout")

uiListLayout2.FillDirection = Enum.FillDirection.Horizontal
uiListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
uiListLayout2.Padding = UDim.new(0, 14)
uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout2.Parent = colors
colors.Parent = parent

local function paintSwatches()
	local signTextColor: any = LocalPlayer:GetAttribute("SignTextColor")
	local text: string = tostring(signTextColor or "White")

	for k, v in pairs(t9) do
		local uiStroke3 = v:FindFirstChildOfClass("UIStroke")

		if uiStroke3 then
			uiStroke3.Thickness = if k == text then 4 else 1.5
			uiStroke3.Color = if k == text then Color3.fromRGB(190, 190, 195) else Color3.fromRGB(40, 40, 44)
		end
	end
end

for i, v in ipairs({
	{ Name = "Red", Color = color35 },
	t8,
	{ Name = "Blue", Color = color36 }
}) do
	local textButton: TextButton = Instance.new("TextButton")

	textButton.Name = v.Name
	textButton.Text = ""
	textButton.AutoButtonColor = true
	textButton.BackgroundColor3 = v.Color
	textButton.Size = UDim2.fromScale(1, 1)
	textButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
	textButton.LayoutOrder = i
	textButton.ZIndex = 13

	local uiCorner3: UICorner = Instance.new("UICorner")

	uiCorner3.CornerRadius = UDim.new(0.5, 0)
	uiCorner3.Parent = textButton

	local uiStroke4: UIStroke = Instance.new("UIStroke")

	uiStroke4.Thickness = 1.5
	uiStroke4.Color = Color3.fromRGB(40, 40, 44)
	uiStroke4.Parent = textButton
	textButton.Parent = colors
	t9[v.Name] = textButton
	textButton.MouseButton1Click:Connect(function()
		pcall(function()
			sound:Play("UI.Click", workspace)
		end)

		local v332, v333 = signRequest:InvokeServer("SetTextColor", v.Name)

		if not v332 then
			local t15: {[any]: any} = {
				notifType = "FailNotification",
				errorMessage = tostring(v333 or "Couldn't set the colour.")
			}

			if typeof(_G.Notify) == "function" then
				pcall(function()
					v397(t15)
				end)
			end
		end
	end)
end

LocalPlayer:GetAttributeChangedSignal("SignTextColor"):Connect(paintSwatches)

local v127 = UDim2.fromScale(0.5, 0.15)
local v128 = makeWoodButton("Save", "Save", nil, parent, v127, UDim2.fromScale(0.5, 0.72))

v128.ZIndex = 12

local label = v128:FindFirstChild("Label")

if label and label:IsA("TextLabel") then
	label.Size = UDim2.fromScale(0.9, 0.62)
	label.Position = UDim2.fromScale(0.5, 0.19)
end

local u130: boolean = false

makeWoodButton = function()
	if not u130 then
		return
	end

	u130 = false
	parent.Visible = false
	windowBlur.hide("SignTextEditor")
end
u53 = function()
	if u130 then
		return
	end

	local v335, v336, v337 = ipairs(t2)
	local v338: boolean = false
	local v339

	for iterFirst, iterSecond in v335, v336, v337 do
		if iterSecond.Key == "Text" then
			v339 = iterSecond
			v338 = true

			break
		end
	end

	if not v338 then
		v339 = nil
	end

	if v339 == nil or LocalPlayer:GetAttribute("OwnsPack_" .. v339.Pack) ~= true then
		openShop()

		return
	end

	u130 = true
	activeWindowChanged:Fire("SignTextEditor")
	windowBlur.show("SignTextEditor")

	local signText: any = LocalPlayer:GetAttribute("SignText")

	input.Text = tostring(signText or "")
	paintSwatches()
	parent.Visible = true
end
v110.MouseButton1Click:Connect(function()
	pcall(function()
		sound:Play("UI.Click", workspace)
	end)

	if not u130 then
		return
	end

	u130 = false
	parent.Visible = false
	windowBlur.hide("SignTextEditor")
end)
v128.MouseButton1Click:Connect(function()
	pcall(function()
		sound:Play("UI.Click", workspace)
	end)

	local v343, v344 = signRequest:InvokeServer("SetText", input.Text)

	if v343 then
		local t16: {[any]: any} = {
			notifType = "SuccessNotification",
			topText = "Sign Updated",
			bottomText = "Your sign now reads what you wrote."
		}
		local _GNotify = _G.Notify

		if typeof(_GNotify) == "function" then
			pcall(function()
				_GNotify(t16)
			end)
		end

		if u130 then
			u130 = false
			parent.Visible = false
			windowBlur.hide("SignTextEditor")
		end

		refreshBar()

		return
	end

	local t17: {[any]: any} = {
		notifType = "FailNotification",
		errorMessage = tostring(v344 or "Couldn't update the sign.")
	}
	local notify = _G.Notify

	if typeof(notify) == "function" then
		pcall(function()
			notify(t17)
		end)
	end
end)
u54 = function(p37)
	pcall(function()
		sound:Play("UI.Click", workspace)
	end)

	local v350, v351, v352 = ipairs(t2)
	local v353: boolean = false
	local v354

	for iterFirst, iterSecond in v350, v351, v352 do
		if p37 == iterSecond.Key then
			v354 = iterSecond
			v353 = true

			break
		end
	end

	if not v353 then
		v354 = nil
	end

	if v354 == nil or LocalPlayer:GetAttribute("OwnsPack_" .. v354.Pack) ~= true then
		openShop()

		return
	end

	local v357 = if p37 == signHeld then nil else p37

	if v357 == "Wanted" and LocalPlayer:GetAttribute("SignWantItem") == nil then
		u52()

		return
	end

	if v357 == "Text" and LocalPlayer:GetAttribute("SignText") == nil then
		u53()

		return
	end

	local v358, v359 = signRequest:InvokeServer("Hold", v357)

	if not v358 then
		local t18: {[any]: any} = {
			notifType = "FailNotification",
			errorMessage = tostring(v359 or "Couldn't do that.")
		}

		if typeof(_G.Notify) == "function" then
			pcall(function()
				v398(t18)
			end)
		end
	end
end
proximityPromptService.PromptTriggered:Connect(function(prompt: ProximityPrompt, playerWhoTriggered: Player)
	if playerWhoTriggered == LocalPlayer and prompt.Name == "SignShopPrompt" then
		openShop()

		return
	end
end)
userInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	if not gameProcessedEvent and input.UserInputType == Enum.UserInputType.Keyboard then
		if userInputService:GetFocusedTextBox() == nil then
			if LocalPlayer:GetAttribute("InMatch") == nil and not u59 and not u61 then
				for _, v in ipairs(t2) do
					if input.KeyCode == v.Hotkey then
						local vKey = v.Key
						local v368, v369, v370 = ipairs(t2)
						local v371: boolean = false
						local v372

						for iterFirst, iterSecond in v368, v369, v370 do
							if vKey == iterSecond.Key then
								v372 = iterSecond
								v371 = true

								break
							end
						end

						if not v371 then
							v372 = nil
						end

						if v372 ~= nil and LocalPlayer:GetAttribute("OwnsPack_" .. v372.Pack) == true then
							u54(v.Key)
						end

						return
					end
				end

				return
			end

			return
		end

		return
	end
end)
activeWindowChanged.Event:Connect(function(p42)
	if p42 ~= "SignShop" and u80 then
		u80 = false
		shop.Visible = false
		windowBlur.hide("SignShop")
	end

	if p42 ~= "SignPicker" and u99 then
		u99 = false
		clone.Visible = false
		clearPickerCells()
		windowBlur.hide("SignPicker")
	end

	if p42 == "SignTextEditor" then
		return
	end

	if not u130 then
		return
	end

	u130 = false
	parent.Visible = false
	windowBlur.hide("SignTextEditor")
end)
windowBlur.onActiveChanged(function(p43)
	u59 = p43
	applyBar()
end)
LocalPlayer:GetAttributeChangedSignal("InMatch"):Connect(function()
	applyBar()

	if LocalPlayer:GetAttribute("InMatch") == nil then
		return
	end

	if u80 then
		u80 = false
		shop.Visible = false
		windowBlur.hide("SignShop")
	end

	if u99 then
		u99 = false
		clone.Visible = false
		clearPickerCells()
		windowBlur.hide("SignPicker")
	end

	if not u130 then
		return
	end

	u130 = false
	parent.Visible = false
	windowBlur.hide("SignTextEditor")
end)
LocalPlayer:GetAttributeChangedSignal("SignHeld"):Connect(refreshBar)
LocalPlayer:GetAttributeChangedSignal("HideSignBar"):Connect(applyBar)
LocalPlayer:GetAttributeChangedSignal("SignWantItem"):Connect(refreshBar)
LocalPlayer:GetAttributeChangedSignal("SignText"):Connect(refreshBar)

for _, v in ipairs(t2) do
	LocalPlayer:GetAttributeChangedSignal("OwnsPack_" .. v.Pack):Connect(function()
		refreshBar()

		if u80 then
			refreshShop()
		end
	end)
end

packPush.OnClientEvent:Connect(function()
	refreshBar()

	if u80 then
		refreshShop()
	end
end)
refreshBar()
applyBar()
