-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

require(replicatedStorage:WaitForChild("UIFramework"))

local t1: {[any]: any} = {
	template = nil,
	tokenLabel = nil,
	greenButton = nil,
	tokenImage = nil
}

local function hud()
	local LocalPlayer: Player = players.LocalPlayer
	local playerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")

	return playerGui and playerGui:FindFirstChild("HUD") or nil
end
local function sourceLabel()
	if t1.template == nil or t1.template.Parent == nil then
		local LocalPlayer: Player = players.LocalPlayer
		local playerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
		local v11 = playerGui and playerGui:FindFirstChild("HUD") or nil
		local boothWindow = v11 and v11:FindFirstChild("BoothWindow")

		v11 = boothWindow

		if v11 then
			v11 = boothWindow:FindFirstChild("Header")
		end

		local textLabel = v11 and v11:FindFirstChild("TextLabel")

		if textLabel and textLabel:IsA("TextLabel") then
			t1.template = textLabel

			return textLabel
		end

		return nil
	end

	return t1.template
end

local module: {[any]: any} = {
	SIGN_ASPECT = 3.45,
	PLATE_ASPECT = 4.5,
	Fmt = function(p1)
		local floored = math.floor(p1)

		return (tostring(floored):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
	end
}

function module.StackNote(p2, p3)
	if typeof(p2) == "number" and not (p2 <= 1) then
		if typeof(p3) == "number" then
			local n1 = p3 / p2
			local floored = math.floor(n1)
			local fmt = module.Fmt
			local floored2 = math.floor(n1 + 0.5)

			return ("x%d listed  -  %s%s each"):format(p2, if floored ~= n1 then "~" else "", fmt(floored2))
		end

		return nil
	end

	return nil
end
function module.StackCount(p4, p5, p6)
	pcall(p4.setStackCount, p4, p6)

	local v25 = p4.getQuantityCounter and p4:getQuantityCounter() or nil

	if v25 and v25:IsA("GuiObject") then
		v25.AnchorPoint = Vector2.new(0, 0)
		v25.Position = UDim2.new(0.06, 0, 0.05, 0)
		v25.ZIndex = p5.ZIndex + 7
	end
end
function module.TokenIcon()
	if t1.tokenImage == nil then
		local LocalPlayer: Player = players.LocalPlayer
		local playerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
		local v28 = playerGui and playerGui:FindFirstChild("HUD") or nil
		local tradeTokens = v28 and v28:FindFirstChild("TradeTokens")

		v28 = tradeTokens

		if v28 then
			v28 = tradeTokens:FindFirstChild("Icon")
		end

		if v28 and v28:IsA("ImageLabel") and v28.Image ~= "" then
			t1.tokenImage = v28.Image

			return v28.Image
		end

		return ""
	end

	return t1.tokenImage
end
function module.TokenAmount(parent, p8, p9, p10)
	local v34 = t1.tokenLabel

	if v34 == nil or v34.Parent == nil then
		local LocalPlayer: Player = players.LocalPlayer
		local playerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
		local v37 = playerGui and playerGui:FindFirstChild("HUD") or nil
		local tradeTokens = v37 and v37:FindFirstChild("TradeTokens")

		v37 = tradeTokens

		if v37 then
			v37 = tradeTokens:FindFirstChild("Tokens")
		end

		if v37 and v37:IsA("TextLabel") then
			t1.tokenLabel = v37
			v34 = v37
		end
	end

	if v34 == nil then
		local label = module.Label
		local v40 = module.Fmt(p8)

		return label(parent, v40, p9, p10, Color3.fromRGB(255, 214, 92))
	end

	local clone = v34:Clone()

	clone.Name = "TokenAmount"
	clone.BackgroundTransparency = 1
	clone.AnchorPoint = Vector2.new(0, 0)
	clone.Size = p9
	clone.Position = p10
	clone.Visible = true
	clone.TextScaled = true
	clone.TextWrapped = true
	clone.TextXAlignment = Enum.TextXAlignment.Left
	clone.TextYAlignment = Enum.TextYAlignment.Center
	clone.Text = module.Fmt(p8)
	clone.Parent = parent

	return clone
end
function module.Label(parent, text, p13, p14, textColor3)
	local v47 = sourceLabel()
	local textLabel

	if v47 == nil then
		textLabel = Instance.new("TextLabel")
		textLabel.Font = Enum.Font.FredokaOne
	else
		textLabel = v47:Clone()
		textLabel.Name = "ThemeLabel"
	end

	textLabel.BackgroundTransparency = 1
	textLabel.AnchorPoint = Vector2.new(0, 0)
	textLabel.Size = p13
	textLabel.Position = p14
	textLabel.Rotation = 0
	textLabel.Visible = true
	textLabel.TextScaled = true
	textLabel.TextWrapped = true
	textLabel.TextXAlignment = Enum.TextXAlignment.Center
	textLabel.TextYAlignment = Enum.TextYAlignment.Center
	textLabel.Text = text

	if textLabel:FindFirstChildOfClass("UIStroke") == nil then
		local uiStroke: UIStroke = Instance.new("UIStroke")

		uiStroke.Thickness = 3.5
		uiStroke.Color = Color3.fromRGB(40, 34, 26)
		uiStroke.LineJoinMode = Enum.LineJoinMode.Round
		uiStroke.Parent = textLabel
	end

	if textColor3 ~= nil then
		textLabel.TextColor3 = textColor3

		local uiGradient = textLabel:FindFirstChildOfClass("UIGradient")

		if uiGradient then
			uiGradient:Destroy()
		end
	end

	textLabel.Parent = parent

	return textLabel
end
function module.SignRoot(parent, aspectRatio)
	local root: Frame = Instance.new("Frame")

	root.Name = "Root"
	root.BackgroundTransparency = 1
	root.AnchorPoint = Vector2.new(0.5, 0.5)
	root.Position = UDim2.fromScale(0.5, 0.5)
	root.Size = UDim2.fromScale(1, 1)

	local uiAspectRatioConstraint: UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

	uiAspectRatioConstraint.AspectRatio = aspectRatio
	uiAspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
	uiAspectRatioConstraint.Parent = root
	root.Parent = parent

	return root
end
function module.PriceTag(parent, p19)
	local priceTag: Frame = Instance.new("Frame")

	priceTag.Name = "PriceTag"
	priceTag.AnchorPoint = Vector2.new(0.5, 1)
	priceTag.Position = UDim2.new(0.5, 0, 0.99, 0)
	priceTag.Size = UDim2.new(0.92, 0, 0.24, 0)
	priceTag.BackgroundColor3 = Color3.fromRGB(24, 20, 12)
	priceTag.BackgroundTransparency = 0.25
	priceTag.BorderSizePixel = 0
	priceTag.ZIndex = 6

	local uiCorner: UICorner = Instance.new("UICorner")

	uiCorner.CornerRadius = UDim.new(0.35, 0)
	uiCorner.Parent = priceTag

	local imageLabel: ImageLabel = Instance.new("ImageLabel")

	imageLabel.BackgroundTransparency = 1
	imageLabel.Image = module.TokenIcon()
	imageLabel.AnchorPoint = Vector2.new(0, 0.5)
	imageLabel.Position = UDim2.new(0.04, 0, 0.5, 0)
	imageLabel.Size = UDim2.new(0.85, 0, 0.85, 0)
	imageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
	imageLabel.ZIndex = 7

	local uiAspectRatioConstraint: UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

	uiAspectRatioConstraint.AspectRatio = 1
	uiAspectRatioConstraint.Parent = imageLabel
	imageLabel.Parent = priceTag
	module.TokenAmount(priceTag, p19, UDim2.new(0.66, 0, 0.8, 0), UDim2.new(0.3, 0, 0.1, 0)).ZIndex = 7
	priceTag.Parent = parent

	return priceTag
end
function module.CreateTile(parent, layoutOrder)
	local v63 = t1.greenButton

	if v63 == nil or v63.Parent == nil then
		local LocalPlayer: Player = players.LocalPlayer
		local playerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
		local v66 = playerGui and playerGui:FindFirstChild("HUD") or nil
		local boothWindow = v66 and v66:FindFirstChild("BoothWindow")

		v66 = boothWindow

		if v66 then
			v66 = boothWindow:FindFirstChild("ActionBar")
		end

		local unclaimButton = v66 and v66:FindFirstChild("UnclaimButton")

		if unclaimButton and unclaimButton:IsA("TextButton") then
			t1.greenButton = unclaimButton
			v63 = unclaimButton
		end
	end

	local function retext(p22, text)
		if p22:IsA("TextLabel") then
			p22.Text = text
		end

		for _, v in ipairs(p22:GetDescendants()) do
			if v:IsA("TextLabel") then
				v.Text = text
			end
		end
	end

	local textButton

	if v63 == nil then
		textButton = Instance.new("TextButton")
		textButton.BackgroundColor3 = Color3.fromRGB(84, 196, 98)
	else
		textButton = v63:Clone()
	end

	textButton.Name = "CreateListingTile"
	textButton.AnchorPoint = Vector2.new(0, 0)
	textButton.Position = UDim2.fromScale(0, 0)
	textButton.Size = UDim2.fromScale(1, 1)
	textButton.Visible = true
	textButton.Active = true

	if layoutOrder ~= nil then
		textButton.LayoutOrder = layoutOrder
	end

	local textLabel = textButton:FindFirstChildOfClass("TextLabel")

	if textLabel ~= nil then
		textLabel.Visible = false
	end

	local plusIcon: ImageLabel = Instance.new("ImageLabel")

	plusIcon.Name = "PlusIcon"
	plusIcon.BackgroundTransparency = 1
	plusIcon.Image = "rbxassetid://98081120668060"
	plusIcon.ScaleType = Enum.ScaleType.Fit
	plusIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	plusIcon.Position = UDim2.fromScale(0.5, 0.5)
	plusIcon.Size = UDim2.fromScale(0.65, 0.65)
	plusIcon.ZIndex = textButton.ZIndex + 1

	local uiAspectRatioConstraint: UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

	uiAspectRatioConstraint.AspectRatio = 1
	uiAspectRatioConstraint.Parent = plusIcon
	plusIcon.Parent = textButton
	textButton.Parent = parent

	return textButton
end

return module
