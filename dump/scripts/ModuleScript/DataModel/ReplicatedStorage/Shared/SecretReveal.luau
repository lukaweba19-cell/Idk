-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local runService: RunService = game:GetService("RunService")
local uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local rarity = require(shared:WaitForChild("Rarity"))
local sound = require(replicatedStorage:WaitForChild("Sound"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local hoverInfoModule = require(replicatedStorageShared:WaitForChild("HoverInfoModule"))
local color3 = Color3.fromRGB(2, 1, 8)
local color32 = Color3.fromRGB(38, 12, 72)
local color33 = Color3.fromRGB(28, 0, 2)
local color34 = Color3.fromRGB(210, 18, 26)
local color35 = Color3.fromRGB(255, 45, 45)
local color36 = Color3.new(1, 1, 1)
local color37 = Color3.new(0, 0, 0)

local function setTextAlpha(p2, p3)
	local function apply(p4)
		if p4:IsA("TextLabel") then
			p4.TextTransparency = p3

			return
		end

		if p4:IsA("UIStroke") then
			p4.Transparency = p3
		end
	end

	if p2:IsA("TextLabel") then
		p2.TextTransparency = p3
	elseif p2:IsA("UIStroke") then
		p2.Transparency = p3
	end

	for _, v in ipairs(p2:GetDescendants()) do
		if v:IsA("TextLabel") then
			v.TextTransparency = p3
		elseif v:IsA("UIStroke") then
			v.Transparency = p3
		end
	end
end
local function warpSpeed(p5, p6)
	if p5 < 0.45 then
		local n1 = p5 / 0.45

		return n1 * 38 * n1
	end

	local n2 = p6 - 0.8

	if p5 < n2 then
		return 38
	end

	local v36 = math.clamp((p5 - n2) / 0.8, 0, 1)

	return (1 - v36) ^ 3 * 38 + v36 * 0.4
end
local function travelLook(p7, p8)
	local n1 = (1 - p8) ^ 2
	local sine = math.sin(p7 * 1.6)
	local sine2 = math.sin(p7 * 2.1 + 1)

	return n1 * 0.035 * sine + 0.5, n1 * 0.025 * sine2 + 0.5
end
local function burstImage()
	local playerGui: Instance = players.LocalPlayer:FindFirstChild("PlayerGui")
	local gotItem: Instance = playerGui and playerGui:FindFirstChild("GotItem")
	local v44: Instance = gotItem

	if v44 then
		v44 = gotItem:FindFirstChild("Sunburst", true)
	end

	if v44 and v44:IsA("ImageLabel") and v44.Image ~= "" then
		return v44.Image
	end

	return "rbxassetid://6673021984"
end
local function easeOutBack(p9, p10)
	local v47 = p10 or 1.70158

	return 1 + (v47 + 1) * (p9 - 1) ^ 3 + v47 * (p9 - 1) ^ 2
end
local function centred(p11, zIndex)
	p11.AnchorPoint = Vector2.new(0.5, 0.5)
	p11.Position = UDim2.fromScale(0.5, 0.5)
	p11.ZIndex = zIndex
end
local function circle(zIndex)
	local frame: Frame = Instance.new("Frame")

	frame.BorderSizePixel = 0
	frame.BackgroundColor3 = Color3.new(1, 1, 1)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.Position = UDim2.fromScale(0.5, 0.5)
	frame.ZIndex = zIndex

	local uiCorner: UICorner = Instance.new("UICorner")

	uiCorner.CornerRadius = UDim.new(1, 0)
	uiCorner.Parent = frame

	return frame
end
local function ring(p14, p15)
	local parent = circle(p14)

	parent.BackgroundTransparency = 1

	local uiStroke: UIStroke = Instance.new("UIStroke")

	uiStroke.Color = p15
	uiStroke.Thickness = 8
	uiStroke.Transparency = 1
	uiStroke.Parent = parent

	return parent, uiStroke
end
local function image(zIndex, image)
	local imageLabel: ImageLabel = Instance.new("ImageLabel")

	imageLabel.BackgroundTransparency = 1
	imageLabel.Image = image
	imageLabel.ImageTransparency = 1
	imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	imageLabel.Position = UDim2.fromScale(0.5, 0.5)
	imageLabel.ZIndex = zIndex

	return imageLabel
end

local module: {[any]: any} = {
	MASK_ICON = "rbxassetid://130881513456514",
	MASK_NAME = "???",
	ShouldMask = function(p1)
		return p1 == "Secret"
	end
}

function module.Play(p18, p19)
	local t2 = p19 or {}
	local v64 = typeof(p18) == "table" and p18.Rarity or "Secret"
	local v65 = typeof(p18) == "table" and typeof(p18.Icon) == "string" and p18.Icon ~= "" and p18.Icon or module.MASK_ICON
	local v66 = typeof(p18) == "table" and (p18.Name or p18.ItemId) or "Secret"
	local v67 = rarity.Colors and rarity.Colors[v64] or Color3.new(1, 1, 1)
	local playerGui: Instance = players.LocalPlayer:WaitForChild("PlayerGui")
	local __SecretReveal: ScreenGui = Instance.new("ScreenGui")

	__SecretReveal.Name = "__SecretReveal"
	__SecretReveal.IgnoreGuiInset = true
	__SecretReveal.ScreenInsets = Enum.ScreenInsets.None
	__SecretReveal.ResetOnSpawn = false
	__SecretReveal.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	__SecretReveal.DisplayOrder = 200
	__SecretReveal.Parent = playerGui

	local textButton: TextButton = Instance.new("TextButton")

	textButton.Text = ""
	textButton.AutoButtonColor = false
	textButton.BackgroundTransparency = 1
	textButton.Size = UDim2.fromScale(1, 1)
	textButton.ZIndex = 10
	textButton.Parent = __SecretReveal

	local frame: Frame = Instance.new("Frame")

	frame.BorderSizePixel = 0
	frame.BackgroundColor3 = Color3.new(0, 0, 0)
	frame.BackgroundTransparency = 1
	frame.Size = UDim2.fromScale(1, 1)
	frame.ZIndex = 0
	frame.Parent = __SecretReveal

	local frame2: Frame = Instance.new("Frame")

	frame2.BorderSizePixel = 0
	frame2.BackgroundColor3 = Color3.new(1, 1, 1)
	frame2.BackgroundTransparency = 1
	frame2.Size = UDim2.fromScale(1, 1)
	frame2.ZIndex = 1

	local uiGradient: UIGradient = Instance.new("UIGradient")

	uiGradient.Color = ColorSequence.new(color3, color32)
	uiGradient.Rotation = 90
	uiGradient.Parent = frame2
	frame2.Parent = __SecretReveal

	local frame3: Frame = Instance.new("Frame")

	frame3.BackgroundTransparency = 1
	frame3.Size = UDim2.fromScale(1, 1)
	frame3.ZIndex = 2
	frame3.Parent = __SecretReveal

	local frame4: Frame = Instance.new("Frame")

	frame4.BackgroundTransparency = 1
	frame4.Size = UDim2.fromOffset(0, 0)
	frame4.AnchorPoint = Vector2.new(0.5, 0.5)
	frame4.Position = UDim2.fromScale(0.5, 0.5)
	frame4.ZIndex = 3
	frame4.Parent = __SecretReveal

	local t3: {[any]: any} = {}
	local t4: {[any]: any} = {}

	for i = 1, 28 do
		t4[i] = i
	end

	for i = 28, 2, -1 do
		local randomNumber = math.random(1, i)
		local v81 = t4[i]

		t4[i] = t4[randomNumber]
		t4[randomNumber] = v81
	end

	for i = 1, 28 do
		local frame5: Frame = Instance.new("Frame")

		frame5.BackgroundTransparency = 1
		frame5.AnchorPoint = Vector2.new(0.5, 0.5)
		frame5.Position = UDim2.fromScale(0.5, 0.5)
		frame5.ZIndex = 3
		frame5.Visible = false

		local randomNumber2 = math.random()
		local rotation = (i - 1) / 28 * 360 + (randomNumber2 - 0.5) * 8

		frame5.Rotation = rotation

		local u86: boolean = i % 2 == 1

		frame5.ZIndex = if u86 then 2 else 1

		local imageLabel: ImageLabel = Instance.new("ImageLabel")

		imageLabel.BackgroundTransparency = 1
		imageLabel.Image = if u86 then "rbxassetid://70450848337401" else "rbxassetid://136303766442266"
		imageLabel.ImageColor3 = Color3.fromRGB(255, 252, 235)
		imageLabel.ScaleType = Enum.ScaleType.Stretch
		imageLabel.AnchorPoint = Vector2.new(0.5, 1)
		imageLabel.Position = UDim2.fromScale(0.5, 0.5)
		imageLabel.Size = UDim2.fromScale(1, 0.5)
		imageLabel.ZIndex = frame5.ZIndex
		imageLabel.Parent = frame5
		frame5.Parent = frame4
		table.insert(t3, {
			bornT = nil,
			arm = frame5,
			beam = imageLabel,
			angle = rotation,
			width = if u86 then 0.09 + math.random() * 0.04 else 0.1 + math.random() * 0.03,
			len = if u86 then 0.3 + math.random() * 0.2 else 0.4 + math.random() * 0.22,
			at = (t4[i] - 1) / 28 * 0.95
		})
	end

	local imageLabel2: ImageLabel = Instance.new("ImageLabel")

	imageLabel2.BackgroundTransparency = 1
	imageLabel2.Image = "rbxassetid://6673021984"
	imageLabel2.ImageTransparency = 1
	imageLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
	imageLabel2.Position = UDim2.fromScale(0.5, 0.5)
	imageLabel2.ZIndex = 4
	imageLabel2.Parent = __SecretReveal

	local v89 = circle(5)

	v89.BackgroundTransparency = 1
	v89.Parent = __SecretReveal

	local imageLabel3: ImageLabel = Instance.new("ImageLabel")

	imageLabel3.BackgroundTransparency = 1
	imageLabel3.Image = "rbxassetid://6673021984"
	imageLabel3.ImageTransparency = 1
	imageLabel3.AnchorPoint = Vector2.new(0.5, 0.5)
	imageLabel3.Position = UDim2.fromScale(0.5, 0.5)
	imageLabel3.ZIndex = 6
	imageLabel3.ImageColor3 = Color3.fromRGB(255, 250, 225)
	imageLabel3.Parent = __SecretReveal

	local parent = circle(7)

	parent.BackgroundTransparency = 1

	local uiStroke: UIStroke = Instance.new("UIStroke")

	uiStroke.Color = Color3.new(1, 1, 1)
	uiStroke.Thickness = 8
	uiStroke.Transparency = 1
	uiStroke.Parent = parent

	local v93 = parent
	local v94: UIStroke = uiStroke

	v93.Parent = __SecretReveal

	local color38 = Color3.fromRGB(200, 220, 255)
	local v96 = circle(7)

	v96.BackgroundTransparency = 1

	local uiStroke2: UIStroke = Instance.new("UIStroke")

	uiStroke2.Color = color38
	uiStroke2.Thickness = 8
	uiStroke2.Transparency = 1
	uiStroke2.Parent = v96

	local v98 = v96
	local v99: UIStroke = uiStroke2

	v98.Parent = __SecretReveal

	local frame6: Frame = Instance.new("Frame")

	frame6.BorderSizePixel = 0
	frame6.BackgroundColor3 = Color3.new(1, 1, 1)
	frame6.BackgroundTransparency = 1
	frame6.Size = UDim2.fromScale(1, 1)
	frame6.ZIndex = 8
	frame6.Parent = __SecretReveal

	local image = burstImage()
	local imageLabel4: ImageLabel = Instance.new("ImageLabel")

	imageLabel4.BackgroundTransparency = 1
	imageLabel4.Image = image
	imageLabel4.ImageTransparency = 1
	imageLabel4.AnchorPoint = Vector2.new(0.5, 0.5)
	imageLabel4.Position = UDim2.fromScale(0.5, 0.5)
	imageLabel4.ZIndex = 9
	imageLabel4.ImageColor3 = Color3.new(0, 0, 0)
	imageLabel4.Parent = __SecretReveal

	local imageLabel5: ImageLabel = Instance.new("ImageLabel")

	imageLabel5.BackgroundTransparency = 1
	imageLabel5.Image = "rbxassetid://6673021984"
	imageLabel5.ImageTransparency = 1
	imageLabel5.AnchorPoint = Vector2.new(0.5, 0.5)
	imageLabel5.Position = UDim2.fromScale(0.5, 0.5)
	imageLabel5.ZIndex = 9
	imageLabel5.ImageColor3 = color35
	imageLabel5.Parent = __SecretReveal

	local v104 = circle(10)

	v104.BackgroundTransparency = 1

	local uiStroke3: UIStroke = Instance.new("UIStroke")

	uiStroke3.Color = v67
	uiStroke3.Thickness = 8
	uiStroke3.Transparency = 1
	uiStroke3.Parent = v104

	local v106 = v104
	local v107: UIStroke = uiStroke3

	v106.Parent = __SecretReveal

	local v108, v109 = uiFramework.createItemCell(v64, { selectable = false, icon = v65 })

	v108.AnchorPoint = Vector2.new(0.5, 0.5)
	v108.Position = UDim2.fromScale(0.5, 0.5)
	v108.ZIndex = 11

	local uiAspectRatioConstraint = v108:FindFirstChildOfClass("UIAspectRatioConstraint")

	if uiAspectRatioConstraint then
		uiAspectRatioConstraint:Destroy()
	end

	local uiScale = v108:FindFirstChildWhichIsA("UIScale")

	if not uiScale then
		uiScale = Instance.new("UIScale")
	end

	uiScale.Scale = 0
	uiScale.Parent = v108
	v108.Visible = false
	v108.Parent = __SecretReveal

	if typeof(p18) == "table" and p18.Finisher and p18.Finisher ~= "" then
		pcall(function()
			v109:setFinisher(p18.Finisher)
		end)
	end

	local textLabel: TextLabel = Instance.new("TextLabel")

	textLabel.BackgroundTransparency = 1
	textLabel.AnchorPoint = Vector2.new(0.5, 0)
	textLabel.Size = UDim2.fromScale(0.8, 0.09)
	textLabel.TextScaled = true
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.TextTransparency = 1
	textLabel.Text = tostring(v66)
	textLabel.ZIndex = 12

	local spinner: Instance = playerGui:FindFirstChild("Spinner")

	spinner = spinner and spinner:FindFirstChild("Title", true)
	textLabel.FontFace = if spinner and spinner:IsA("TextLabel") then spinner.FontFace else Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)

	local uiStroke4: UIStroke = Instance.new("UIStroke")

	uiStroke4.Thickness = 3
	uiStroke4.Transparency = 1
	uiStroke4.Parent = textLabel
	pcall(function()
		rarity.ApplyTextGradient(textLabel, v64)
	end)
	textLabel.Parent = __SecretReveal

	local clone: Instance = textLabel:Clone()

	clone.Size = UDim2.fromScale(0.5, 0.05)

	local stringUpper = string.upper
	local text: string = tostring(v64)

	clone.Text = stringUpper(text) .. "!"
	clone.Parent = __SecretReveal

	local uiStroke5: Instance = clone:FindFirstChildOfClass("UIStroke")
	local gotItem: Instance = playerGui:FindFirstChild("GotItem")
	local content: Instance = gotItem and gotItem:FindFirstChild("Content")
	local v121: Instance = content

	if v121 then
		v121 = content:FindFirstChild("Close")
	end

	local clone2

	if v121 and v121:IsA("TextLabel") then
		clone2 = v121:Clone()
	else
		local textLabel2: TextLabel = Instance.new("TextLabel")

		textLabel2.BackgroundTransparency = 1
		textLabel2.AnchorPoint = Vector2.new(0.5, 1)
		textLabel2.Position = UDim2.fromScale(0.5, 0.95)
		textLabel2.Size = UDim2.fromScale(0.6, 0.05)
		textLabel2.TextScaled = true
		textLabel2.TextColor3 = Color3.new(1, 1, 1)
		textLabel2.FontFace = textLabel.FontFace
		clone2 = textLabel2
	end

	for _, v in ipairs(clone2:GetDescendants()) do
		if v:IsA("TextLabel") then
			v.Text = "- Tap Anywhere to Continue -"
		end
	end

	if clone2:IsA("TextLabel") then
		clone2.Text = "- Tap Anywhere to Continue -"
	end

	clone2.Visible = true
	clone2.ZIndex = 13
	setTextAlpha(clone2, 1)
	clone2.Parent = __SecretReveal

	local t5: {[any]: any} = {}
	local n2 = 0
	local n3 = 0

	local function spawnStar(p20, p21, p22)
		local n1 = n3 + p21
		local randomNumber3 = math.random()

		p20.Z = n1 + randomNumber3 * (p22 - p21)
		p20.X = 0 + (math.random() * 2 - 1) * 13
		n1 = n2

		local randomNumber4 = math.random()

		p20.Y = n1 + (randomNumber4 * 2 - 1) * 13
		p20.alpha = 0.35 + math.random() * 0.6
		p20.base = 1.5 + math.random() * 2
		p20.px = nil
		p20.py = nil
	end

	for _ = 1, 160 do
		local frame7: Frame = Instance.new("Frame")

		frame7.BorderSizePixel = 0
		frame7.BackgroundColor3 = Color3.new(1, 1, 1)
		frame7.BackgroundTransparency = 1
		frame7.AnchorPoint = Vector2.new(0.5, 0.5)
		frame7.ZIndex = 2

		local uiCorner: UICorner = Instance.new("UICorner")

		uiCorner.CornerRadius = UDim.new(1, 0)
		uiCorner.Parent = frame7
		frame7.Parent = frame3

		local t6: {[any]: any} = {
			X = 0,
			Y = 0,
			Z = 1,
			px = nil,
			py = nil,
			alpha = 0,
			base = 2,
			f = frame7
		}

		spawnStar(t6, 1, 10)
		table.insert(t5, t6)
	end

	local u134 = nil
	local t7: {[any]: any} = {}

	local function once(p23, p24)
		if t7[p23] then
			return
		end

		t7[p23] = true
		pcall(p24)
	end

	local n4: number = 0
	local n5: number = 0
	local n6: number = 0
	local n7 = 0
	local u141: boolean = false
	local v142 = coroutine.running()

	textButton.MouseButton1Click:Connect(function()
		if u134 == nil and n4 >= 7.98 then
			u134 = n4
		end
	end)

	local v143 = hoverInfoModule.create(__SecretReveal)
	local t8 = if typeof(p18) == "table" then p18 else {}

	local v145 = hoverInfoModule.bind(v143, v108, function()
		if n4 < 6.78 or u134 ~= nil then
			return nil
		end

		return {
			Name = t8.Name or t8.ItemId or tostring(v66),
			Rarity = v64,
			GlobalCopies = t8.GlobalCopies,
			Serial = t8.Serial,
			MaxSupply = t8.MaxSupply,
			SourceButton = v108,
			FinisherName = t8.FinisherName,
			FinisherIcon = t8.FinisherIcon,
			FinisherRarity = t8.FinisherRarity,
			Kind = t8.ItemType,
			ItemId = t8.ItemId
		}
	end)

	v108.MouseButton1Click:Connect(function()
		if v145.tapConsumed() then
		elseif u134 == nil and n4 >= 7.98 then
			u134 = n4
		end
	end)

	local connection = game:GetService("UserInputService").InputBegan:Connect(function(input: InputObject)
		if (input.KeyCode == Enum.KeyCode.ButtonA or input.KeyCode == Enum.KeyCode.ButtonB or input.KeyCode == Enum.KeyCode.Return or input.KeyCode == Enum.KeyCode.Space) and u134 == nil and n4 >= 7.98 then
			u134 = n4
		end
	end)

	local connection2 = nil
	local n8: number = 0

	connection2 = runService.RenderStepped:Connect(function(deltaTime: number)
		if n8 < 0.6499999999999999 then
			n8 += deltaTime
			frame.BackgroundTransparency = 1 - math.clamp(n8 / 0.3, 0, 1)

			return
		end

		n4 += deltaTime

		local __SecretRevealAbsoluteSize: Vector2 = __SecretReveal.AbsoluteSize
		local v161 = math.min(__SecretRevealAbsoluteSize.X, __SecretRevealAbsoluteSize.Y)
		local v162 = math.max(__SecretRevealAbsoluteSize.X, __SecretRevealAbsoluteSize.Y)
		local backgroundTransparency = if n4 < 0.5 then 1 - n4 / 0.5 else if u134 then math.clamp((n4 - u134) / 0.35, 0, 1) else 0

		frame2.BackgroundTransparency = backgroundTransparency

		if u134 then
			frame.BackgroundTransparency = backgroundTransparency
		end

		local v164 = math.clamp((n4 - 6.4) / 0.35, 0, 1)

		if v164 > 0 then
			local colorSequenceNew = ColorSequence.new
			local v166 = color3:Lerp(color33, v164)

			uiGradient.Color = colorSequenceNew(v166, color32:Lerp(color34, v164))
		end

		local v167 = color36:Lerp(color37, v164)
		local n11: number = 0

		if n4 < 2.2 then
			n11 = 0
		elseif n4 < 4.800000000000001 then
			n11 = ((n4 - 2.2) / 2.6) ^ 1.6
		elseif n4 < 6.4 then
			n11 = 1
		elseif n4 < 6.58 then
			n11 = 1 - (n4 - 6.4) / 0.18
		end

		local n36 = 0
		local v170 = Vector2.zero

		if n4 < 2.2 then
			local v171 = math.clamp((n4 - 1.4000000000000001) / 0.8, 0, 1)

			n36 = v161 * 0.04 * (1 - (1 - v171) ^ 3)
		elseif n4 < 4.800000000000001 then
			local sine = math.sin(n4 * 6)

			n36 = v161 * (n11 * 0.14 + 0.04) * (sine * 0.04 + 1)
		elseif n4 < 6.4 then
			local n37: number = (n4 - 4.800000000000001) / 1.6
			local v174 = math.clamp(n37 / 0.3, 0, 1)
			local sine = math.sin(n4 * 34)

			n36 = v161 * 0.18 * (1 + 2.70158 * (v174 - 1) ^ 3 + 1.70158 * (v174 - 1) ^ 2 + 1) * ((n37 * 0.1 + 0.08) * sine + 1)
			n7 = n36

			local n38 = v161 * (n37 * 0.01 + 0.004)
			local vector2New = Vector2.new
			local randomNumber5 = math.random()
			local randomNumber6 = math.random()

			v170 = vector2New((randomNumber5 - 0.5) * 2 * n38, (randomNumber6 - 0.5) * 2 * n38)
		elseif n4 < 6.58 then
			local n39: number = (n4 - 6.4) / 0.18

			n36 = n7 * (1 - n39 * n39)
		end

		local uDim2 = UDim2.new(0.5, v170.X, 0.5, v170.Y)

		v89.Position = uDim2
		imageLabel3.Position = uDim2
		imageLabel2.Position = uDim2
		frame4.Position = uDim2
		v89.Size = UDim2.fromOffset(n36, n36)
		v89.BackgroundTransparency = if n36 > 0 then 0 else 1
		imageLabel3.Size = UDim2.fromOffset(n36 * 1.9, n36 * 1.9)
		imageLabel3.ImageTransparency = if n36 > 0 then 0.05 else 1
		imageLabel2.Size = UDim2.fromOffset(n36 * 4, n36 * 4)
		imageLabel2.ImageTransparency = if n36 > 0 then 0.55 - n11 * 0.35 else 1
		n5 += deltaTime * (n11 * 30 + 6)
		frame4.Rotation = n5

		for _, v in ipairs(t3) do
			local u184: boolean = false

			if n4 >= 2.2 then
				u184 = false

				if n4 < 6.58 then
					u184 = true

					if not (n11 >= v.at) then
						u184 = n4 >= 4.800000000000001
					end
				end
			end

			if u184 and not v.bornT then
				v.bornT = n4
			end

			if not u184 then
				v.arm.Visible = false
			else
				v.arm.Visible = true

				local v185 = math.clamp((n4 - v.bornT) / 0.18, 0, 1)
				local n40 = if n4 < 4.800000000000001 then n11 * 0.65 + 0.35 else if n4 < 6.4 then math.sin(n4 * 40 + v.angle) * 0.2 + 1.15 else 1 - (n4 - 6.4) / 0.18
				local n41 = v162 * v.len * n40
				local v188 = math.max(0, 1 + 2.70158 * (v185 - 1) ^ 3 + 1.70158 * (v185 - 1) ^ 2)
				local n9 = n36 * 0.5 + n41 * v188

				v.arm.Size = UDim2.fromOffset(n9 * v.width * ((1 - v185) * 0.4 + 1), n9 * 2)
				n9 = if n4 >= 4.800000000000001 and n4 < 6.4 then math.abs((math.sin(n4 * 37 + v.angle))) * 0.25 else math.sin(n4 * 9 + v.angle) * 0.08
				v.beam.ImageTransparency = if v185 < 1 then 0 else math.clamp(n9 + 0.05, 0, 1)
			end
		end

		n36 = 1

		if n4 >= 2.2 and n4 < 4.800000000000001 then
			n36 = 1 - n11 * 0.55 * n11
		elseif n4 < 6.4 and n4 >= 4.800000000000001 then
			local n10: number = 0.45 - (n4 - 4.800000000000001) / 1.6 * 0.2
			local sine = math.sin(n4 * 30)

			n36 = n10 + sine * 0.05
		elseif n4 < 6.58 and n4 >= 6.4 then
			n36 = (n4 - 6.4) / 0.18 * 0.75 + 0.25
		elseif n4 >= 6.78 and n4 < 7.28 then
			n36 = math.clamp((n4 - 6.78) / 0.5, 0, 1)
		end

		frame6.BackgroundTransparency = n36

		if n4 >= 4.800000000000001 and n4 < 5.500000000000001 then
			local transparency: number = (n4 - 4.800000000000001) / 0.7
			local n12 = v161 * 0.36 + v162 * 2.2 * (1 - (1 - transparency) ^ 2)

			v93.Size = UDim2.fromOffset(n12, n12)
			v94.Transparency = transparency
			v94.Thickness = (1 - transparency) * 14 + 2
		else
			v94.Transparency = 1
		end

		if n4 >= 6.4 and n4 < 6.58 then
			local n13: number = (n4 - 6.4) / 0.18
			local n14 = v162 * 1.2 * (1 - n13)

			v98.Size = UDim2.fromOffset(n14, n14)
			v99.Transparency = n13 * 0.8 + 0.2
			v99.Thickness = n13 * 8 + 3
		else
			v99.Transparency = 1
		end

		local n15: number = if n4 < 6.4 then n11 * 4 + 1 else if n4 < 6.58 then 6 else if n4 < 6.78 then 0.35 else 1
		local n16 = 0.5
		local n17 = 0.5
		local n18
		local n19

		if n4 < 2.2 then
			local v203 = math.clamp(n4 / 2.2, 0, 1)
			local v204: number = n4

			if v204 < 0.45 then
				local n20: number = v204 / 0.45

				n18 = n20 * 38 * n20
			elseif v204 < 1.4000000000000001 then
				n18 = 38
			else
				local v206 = math.clamp((v204 - 1.4000000000000001) / 0.8, 0, 1)

				n18 = (1 - v206) ^ 3 * 38 + v206 * 0.4
			end

			n19 = v203 * 0.25

			local v207: number = n4
			local n21 = (1 - v203) ^ 2
			local sine = math.sin(v207 * 1.6)
			local sine3 = math.sin(v207 * 2.1 + 1)

			n16 = n21 * 0.035 * sine + 0.5
			n17 = n21 * 0.025 * sine3 + 0.5
		else
			n18 = math.clamp(1 - (n4 - 2.2), 0, 1) * 0.4
			n19 = n15 * 0.25
		end

		n3 += n18 * deltaTime
		n2 += n19 * deltaTime

		local n22 = v162 * 0.55
		local n23 = __SecretRevealAbsoluteSize.X * n16
		local n24 = __SecretRevealAbsoluteSize.Y * n17
		local n25

		if u134 then
			n25 = 1 - backgroundTransparency
		else
			n25 = math.clamp(n4 / 0.25, 0, 1)
		end

		for _, v in ipairs(t5) do
			local n26 = v.Z - n3

			if n26 < 0.25 then
				spawnStar(v, 6, 10)
				n26 = v.Z - n3
			end

			local n27 = n23 + (v.X - 0) / n26 * n22
			local n28 = n24 + (v.Y - n2) / n26 * n22

			if n27 < -90 or n27 > __SecretRevealAbsoluteSize.X + 90 or n28 < -90 or n28 > __SecretRevealAbsoluteSize.Y + 90 then
				if n18 > 2 then
					spawnStar(v, 6, 10)
				else
					local n29 = n26 / n22

					if n28 < -90 then
						v.Y = n2 + (__SecretRevealAbsoluteSize.Y + 54 - n24) * n29
					elseif n28 > __SecretRevealAbsoluteSize.Y + 90 then
						v.Y = n2 + (-54 - n24) * n29
					elseif n27 < -90 then
						v.X = 0 + (__SecretRevealAbsoluteSize.X + 54 - n23) * n29
					else
						v.X = 0 + (-54 - n23) * n29
					end

					v.px = nil
					v.py = nil
				end

				n26 = v.Z - n3
				n27 = n23 + (v.X - 0) / n26 * n22
				n28 = n24 + (v.Y - n2) / n26 * n22
			end

			local v220 = math.clamp(v.base * 2.2 / n26, 1, 7)
			local n30 = 0
			local n31 = 0

			if v.px then
				n30 = n27 - v.px
				n31 = n28 - v.py
			end

			local squareRoot = math.sqrt(n30 * n30 + n31 * n31)
			local v224 = math.clamp(squareRoot * 1.6, v220, 160)

			v.f.Size = UDim2.fromOffset(v220, v224)

			if squareRoot > 0.01 then
				local vF = v.f
				local v226 = math.atan2(n31, n30)

				vF.Rotation = math.deg(v226) + 90
				v.f.Position = UDim2.fromOffset(n27 - n30 / squareRoot * v224 * 0.5, n28 - n31 / squareRoot * v224 * 0.5)
			else
				v.f.Position = UDim2.fromOffset(n27, n28)
			end

			v.px = n27
			v.py = n28
			v.f.BackgroundColor3 = v167
			v224 = math.clamp(2.5 / n26, 0.2, 1)
			v.f.BackgroundTransparency = 1 - math.min(1, v.alpha * v224 * (v164 * 0.8 + 1)) * n25
		end

		if t2.buildSound ~= false and n4 >= 2.9800000000000004 then
			local function v227()
				local v241, v242 = sound:Play("Misc.PreSecret", workspace)
				local timePosition: number = n4 - 2.9800000000000004

				if v242 and timePosition > 0.05 then
					v242.TimePosition = timePosition
				end
			end

			if not t7.pre then
				t7.pre = true
				pcall(v227)
			end
		end

		if n4 >= 4.800000000000001 then
			local function v228()
				sound:Play("Misc.RollSlash", workspace)
			end

			if not t7.surge then
				t7.surge = true
				pcall(v228)
			end
		end

		if n4 >= 6.4 then
			local function v229()
				sound:Play("Misc.CountdownGOBass", workspace)
			end

			if not t7.implode then
				t7.implode = true
				pcall(v229)
			end
		end

		if n4 >= 6.78 then
			local function v230()
				v108.Visible = true

				local text2: string = tostring(v64)

				sound:Play("Crate." .. text2, workspace)

				if t2.onReveal then
					t2.onReveal()
				end
			end

			if not t7.reveal then
				t7.reveal = true
				pcall(v230)
			end

			local v231 = math.clamp((n4 - 6.78) / 0.45, 0, 1)
			local n32 = v161 * 0.34

			v108.Size = UDim2.fromOffset(n32, n32)
			uiScale.Scale = math.max(0, 1 + 3.4 * (v231 - 1) ^ 3 + 2.4 * (v231 - 1) ^ 2)
			v108.Rotation = (1 - v231) * -25
			v231 = if u134 then math.clamp((n4 - u134) / 0.35, 0, 1) else 0

			local n33 = if n4 > 7.28 then math.sin((n4 - 7.28) * 2.2) * v161 * 0.008 else 0

			v108.Position = UDim2.new(0.5, 0, 0.5, n33)

			if n4 >= 7.98 then
				local v234 = math.clamp((n4 - 7.98) / 0.4, 0, 1)
				local sine = math.sin((n4 - 7.98) * 3)
				local v236 = clone2
				local v237 = math.clamp(1 - v234 + (sine * 0.5 + 0.5) * 0.15 + v231, 0, 1)

				setTextAlpha(v236, v237)
			end

			n6 += deltaTime * 25
			imageLabel4.Rotation = n6

			local v238 = math.clamp((n4 - 6.78) / 0.6, 0, 1)
			local n34 = v162 * (v238 * 1.1 + 0.4)

			imageLabel4.Size = UDim2.fromOffset(n34, n34)
			imageLabel4.ImageTransparency = v231 * 0.85 + 0.15
			imageLabel5.Size = UDim2.fromOffset(n32 * 2.6, n32 * 2.6)
			imageLabel5.ImageTransparency = v231 * 0.75 + 0.25
			n34 = math.clamp((n4 - 6.78) / 0.8, 0, 1)

			local n35 = n32 + v162 * 1.6 * (1 - (1 - n34) ^ 2)

			v106.Size = UDim2.fromOffset(n35, n35)
			v107.Transparency = n34
			v107.Thickness = (1 - n34) * 12 + 2
			n34 = math.clamp((n4 - 6.78 - 0.25) / 0.35, 0, 1)
			n35 = 1 - n34 + v231
			textLabel.Position = UDim2.new(0.5, 0, 0.5, n32 * 0.62 + (1 - n34) * 30)
			clone.Position = UDim2.new(0.5, 0, 0.5, -n32 * 0.62 - v161 * 0.06 - (1 - n34) * 30)
			textLabel.TextTransparency = n35
			clone.TextTransparency = n35
			uiStroke4.Transparency = n35

			if uiStroke5 then
				uiStroke5.Transparency = n35
			end

			v108.Visible = v231 < 0.98
			v230 = uiScale
			v230.Scale = v230.Scale * (1 - v231 * 0.3)
		end

		if u134 and n4 >= u134 + 0.35 and not u141 then
			u141 = true
			connection2:Disconnect()
			connection:Disconnect()
			pcall(function()
				v145.disconnect()
			end)
			pcall(function()
				hoverInfoModule.hide(v143)
			end)
			pcall(function()
				hoverInfoModule.destroy(v143)
			end)
			pcall(function()
				v109:destroy()
			end)
			__SecretReveal:Destroy()

			if coroutine.status(v142) == "suspended" then
				task.spawn(v142)
			end
		end
	end)
	coroutine.yield()
end

return module
