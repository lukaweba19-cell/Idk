-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local marketplaceService: MarketplaceService = game:GetService("MarketplaceService")
local guiService: GuiService = game:GetService("GuiService")
local extensions: Instance = replicatedStorage:WaitForChild("Extensions")
local inputCategorizer = require(extensions:WaitForChild("InputCategorizer"))
local LocalPlayer: Player = players.LocalPlayer
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local currencyBuyRequest: Instance = remotes:WaitForChild("CurrencyBuyRequest")
local tokenPurchaseRequest: Instance = remotes:WaitForChild("TokenPurchaseRequest")
local showPurchaseModal = bindables:FindFirstChild("ShowPurchaseModal")

if not showPurchaseModal then
	local showPurchaseModal2: BindableEvent = Instance.new("BindableEvent")

	showPurchaseModal2.Name = "ShowPurchaseModal"
	showPurchaseModal2.Parent = bindables
	showPurchaseModal = showPurchaseModal2
end

local confirmModal: Instance = bindables:WaitForChild("ConfirmModal")
local scriptParent: Instance = script.Parent
local headerTextLabel: Instance = scriptParent:WaitForChild("HeaderTextLabel")
local container: Instance = scriptParent:WaitForChild("Container")
local tokenButton: Instance = scriptParent:WaitForChild("TokenButton")
local robuxButton: Instance = scriptParent:WaitForChild("RobuxButton")
local cancel: Instance = scriptParent:WaitForChild("Cancel")
local closeButton: Instance = scriptParent:WaitForChild("CloseButton")
local purchaseItemModalGui: ScreenGui = Instance.new("ScreenGui")

purchaseItemModalGui.Name = "PurchaseItemModalGui"
purchaseItemModalGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
purchaseItemModalGui.DisplayOrder = 15
purchaseItemModalGui.IgnoreGuiInset = true
purchaseItemModalGui.ResetOnSpawn = false
purchaseItemModalGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local purchaseModalBackdrop: TextButton = Instance.new("TextButton")

purchaseModalBackdrop.Name = "PurchaseModalBackdrop"
purchaseModalBackdrop.Text = ""
purchaseModalBackdrop.AutoButtonColor = false
purchaseModalBackdrop.BackgroundColor3 = Color3.new(0, 0, 0)
purchaseModalBackdrop.BackgroundTransparency = 0.5
purchaseModalBackdrop.BorderSizePixel = 0
purchaseModalBackdrop.Size = UDim2.fromScale(1, 1)
purchaseModalBackdrop.ZIndex = 49
purchaseModalBackdrop.Active = true
purchaseModalBackdrop.Selectable = false
purchaseModalBackdrop.Visible = false
purchaseModalBackdrop.Parent = purchaseItemModalGui

local function findLabelContaining(p1, p2)
	for _, v in ipairs(p1:GetDescendants()) do
		if v:IsA("TextLabel") and string.find(v.Text, p2, 1, true) and v.Parent and not v.Parent:IsA("TextLabel") then
			return v
		end
	end

	return nil
end

local v25 = findLabelContaining(container, "Token")
local v26 = findLabelContaining(tokenButton, "Token")
local v27 = findLabelContaining(robuxButton, "Robux")

findLabelContaining = function(p3, text)
	if not p3 then
		return
	end

	p3.Text = text

	local textLabel = p3:FindFirstChild("TextLabel")

	if textLabel and textLabel:IsA("TextLabel") then
		textLabel.Text = text
	end
end

local function fmt(p5)
	local floored = math.floor(p5)
	local text = tostring(floored)
	local s1: string = ""

	while #text > 3 do
		s1 = "," .. string.sub(text, -3) .. s1
		text = string.sub(text, 1, -4)
	end

	return text .. s1
end

local t1: {[any]: any} = {}

local function lookupPrices(p6)
	local v51 = t1[p6]

	if v51 and os.clock() - v51.at < 60 then
		return v51.tokens, v51.robux
	end

	local ok, result = pcall(function()
		return marketplaceService:GetProductInfo(p6, Enum.InfoType.Product)
	end)

	if ok and typeof(result) == "table" then
		local numberValue: number? = tonumber(result.PriceInRobux)
		local numberValue2: number? = tonumber(result.UserBasePriceInRobux)
		local v56: number? = if numberValue2 and numberValue2 > 0 then numberValue2 else numberValue

		if v56 and numberValue then
			local v57 = os.clock()

			t1[p6] = { tokens = v56, robux = numberValue, at = v57 }
		end

		return v56, numberValue
	end

	return nil, nil
end

local u31 = nil
local u32 = nil
local floored2 = nil

local function tokenBalance()
	local tradeTokens: any = LocalPlayer:GetAttribute("TradeTokens")

	if typeof(tradeTokens) == "number" then
		return tradeTokens
	end

	return 0
end
local function hide()
	scriptParent.Visible = false
	purchaseModalBackdrop.Visible = false

	local guiServiceSelectedObject: GuiObject = guiService.SelectedObject

	if guiServiceSelectedObject and guiServiceSelectedObject:IsDescendantOf(scriptParent) then
		guiService.SelectedObject = nil
	end

	u31 = nil
	u32 = nil
	floored2 = nil
end

robuxButton.MouseButton1Click:Connect(function()
	local v60 = u31

	if not v60 then
		return
	end

	scriptParent.Visible = false
	purchaseModalBackdrop.Visible = false

	local guiServiceSelectedObject: GuiObject = guiService.SelectedObject

	if guiServiceSelectedObject and guiServiceSelectedObject:IsDescendantOf(scriptParent) then
		guiService.SelectedObject = nil
	end

	u31 = nil
	u32 = nil
	floored2 = nil
	currencyBuyRequest:FireServer(v60)
end)
tokenButton.MouseButton1Click:Connect(function()
	local v62 = u31

	if not v62 then
		return
	end

	local v63 = u32 or "this item"
	local v64 = floored2

	scriptParent.Visible = false
	purchaseModalBackdrop.Visible = false

	local guiServiceSelectedObject: GuiObject = guiService.SelectedObject

	if guiServiceSelectedObject and guiServiceSelectedObject:IsDescendantOf(scriptParent) then
		guiService.SelectedObject = nil
	end

	u31 = nil
	u32 = nil
	floored2 = nil

	local s1: string = if v64 then "Spend " .. fmt(v64) .. " Trade Tokens on " .. v63 .. "?" else "Spend Trade Tokens on " .. v63 .. "?"

	if confirmModal:Invoke({ Header = "Confirm Purchase", Body = s1 }) == true then
		tokenPurchaseRequest:FireServer(v62, v64)
	end
end)
cancel.MouseButton1Click:Connect(hide)
closeButton.MouseButton1Click:Connect(hide)
scriptParent.Parent = purchaseItemModalGui
scriptParent.Visible = false
scriptParent.ZIndex = 50
scriptParent.Active = true
scriptParent.SelectionGroup = true
scriptParent.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
scriptParent.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
scriptParent.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
scriptParent.SelectionBehaviorRight = Enum.SelectionBehavior.Stop

local tradeTokens = LocalPlayer:GetAttribute("TradeTokens")

if typeof(tradeTokens) ~= "number" then
	tradeTokens = 0
end

local text: string = fmt(tradeTokens) .. " Trade Tokens"

if v25 then
	v25.Text = text

	local textLabel = v25:FindFirstChild("TextLabel")

	if textLabel and textLabel:IsA("TextLabel") then
		textLabel.Text = text
	end
end

LocalPlayer:GetAttributeChangedSignal("TradeTokens"):Connect(function()
	local tradeTokens2 = LocalPlayer:GetAttribute("TradeTokens")

	if typeof(tradeTokens2) ~= "number" then
		tradeTokens2 = 0
	end

	local v68 = v25
	local text: string = fmt(tradeTokens2) .. " Trade Tokens"

	if not v68 then
		return
	end

	v68.Text = text

	local textLabel = v68:FindFirstChild("TextLabel")

	if textLabel and textLabel:IsA("TextLabel") then
		textLabel.Text = text
	end
end)
showPurchaseModal.Event:Connect(function(p7)
	if typeof(p7) == "table" then
		local numberValue: number? = tonumber(p7.ProductId)

		if not numberValue then
			return
		end

		local floored = math.floor(numberValue)
		local v74, v75 = lookupPrices(floored)
		local numberValue3: number? = tonumber(p7.RobuxPrice)
		local v77 = v74 or numberValue3
		local v78 = v75 or numberValue3

		if v77 and v78 then
			local tradeTokens3: any = LocalPlayer:GetAttribute("TradeTokens")

			if (if typeof(tradeTokens3) == "number" then tradeTokens3 else 0) < math.floor(v77) then
				currencyBuyRequest:FireServer(floored)

				return
			end

			u31 = floored
			u32 = if typeof(p7.Name) == "string" then p7.Name else nil
			floored2 = math.floor(v77)
			headerTextLabel.Text = if u32 then "Purchase " .. u32 .. "?" else "Purchase Item?"

			local v80 = v26
			local text: string = fmt(v77) .. " Tokens"

			if v80 then
				v80.Text = text

				local textLabel = v80:FindFirstChild("TextLabel")

				if textLabel and textLabel:IsA("TextLabel") then
					textLabel.Text = text
				end
			end

			local v83 = v27
			local v84 = utf8.char(57346)
			local v85 = fmt(v78)
			local s2: string = "Buy with " .. v84 .. v85 .. " Robux"

			if v83 then
				v83.Text = s2

				local textLabel = v83:FindFirstChild("TextLabel")

				if textLabel and textLabel:IsA("TextLabel") then
					textLabel.Text = s2
				end
			end

			local tradeTokens4 = LocalPlayer:GetAttribute("TradeTokens")

			if typeof(tradeTokens4) ~= "number" then
				tradeTokens4 = 0
			end

			local v89 = v25
			local s3: string = fmt(tradeTokens4) .. " Trade Tokens"

			if v89 then
				v89.Text = s3

				local textLabel = v89:FindFirstChild("TextLabel")

				if textLabel and textLabel:IsA("TextLabel") then
					textLabel.Text = s3
				end
			end

			purchaseModalBackdrop.Visible = true
			scriptParent.Visible = true

			if inputCategorizer.getLastInputCategory() == inputCategorizer.InputCategory.Gamepad then
				guiService.SelectedObject = tokenButton
			end

			return
		end

		currencyBuyRequest:FireServer(floored)

		return
	end
end)
