-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local tweenService: TweenService = game:GetService("TweenService")
local runService: RunService = game:GetService("RunService")
local LocalPlayer: Player = players.LocalPlayer
local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local windowBlur = require(shared:WaitForChild("WindowBlur"))
local eventTimer = require(shared:WaitForChild("EventTimer"))
local shineEffect = require(shared:WaitForChild("ShineEffect"))
local packCatalog = require(shared:WaitForChild("PackCatalog"))
local uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))
local activeWindowChanged: Instance = replicatedStorage:WaitForChild("Bindables"):WaitForChild("ActiveWindowChanged")
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local packRequest: Instance = remotes:WaitForChild("PackRequest")
local packPush: Instance = remotes:WaitForChild("PackPush")
local currencyBuyRequest: Instance = remotes:WaitForChild("CurrencyBuyRequest")
local starterPack = packCatalog.Get("StarterPack")
local scriptParent: Instance = script.Parent
local backdrop: Instance = scriptParent:WaitForChild("Backdrop")
local window: Instance = scriptParent:WaitForChild("Window")
local topBanner: Instance = window:WaitForChild("TopBanner")
local closeButton: Instance = topBanner:WaitForChild("CloseButton")
local timerTextLabel: Instance = topBanner:WaitForChild("Timer"):WaitForChild("TextLabel")
local textLabel: Instance = timerTextLabel:FindFirstChildOfClass("TextLabel")
local buyButton: Instance = window:WaitForChild("BuyButton")
local videoFrame: Instance = window:FindFirstChild("VideoFrame")
local t1: {[any]: any} = {}

for k, v in pairs({ CasesSlot = 9, MolotovSlot = -14, CoinsSlot = 9, BigSunburst = 3 }) do
	local k: Instance = window:FindFirstChild(k)
	local v32: Instance = if k and k:IsA("ImageLabel") then k else k and k:FindFirstChild("Sunburst")

	if v32 and v32:IsA("ImageLabel") then
		table.insert(t1, { img = v32, speed = v })
	end
end

local connection = nil

local function startSpin()
	if connection then
		return
	end

	connection = runService.RenderStepped:Connect(function(deltaTime: number)
		for _, v in ipairs(t1) do
			v.img.Rotation = (v.img.Rotation + v.speed * deltaTime) % 360
		end
	end)
end
local function stopSpin()
	if connection then
		connection:Disconnect()
		connection = nil
	end
end

local price: Instance = buyButton:WaitForChild("Price")
local wasPrice: Instance = buyButton:WaitForChild("WasPrice")
local tweenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local u40: boolean = false
local u41 = nil
local u42 = nil
local u43 = nil

window.Visible = false
backdrop.Visible = false
scriptParent.Enabled = true

local function commaFormat(p2)
	local floored = math.floor(p2)

	return (tostring(floored):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
end
local function getEndsAt()
	local starterPackExpiresAt: any = LocalPlayer:GetAttribute("StarterPackExpiresAt")

	if typeof(starterPackExpiresAt) == "number" then
		return starterPackExpiresAt
	end

	return nil
end
local function isOwned()
	return LocalPlayer:GetAttribute("OwnsPack_StarterPack") == true
end
local function isExpired()
	local starterPackExpiresAt: any = LocalPlayer:GetAttribute("StarterPackExpiresAt")
	local v57 = if typeof(starterPackExpiresAt) == "number" then starterPackExpiresAt else nil
	local u58: boolean = false

	if typeof(v57) == "number" then
		local timestamp = os.time()

		u58 = v57 - timestamp <= 0
	end

	return u58
end
local function refreshBuyButton()
	if LocalPlayer:GetAttribute("OwnsPack_StarterPack") == true then
		uiFramework.setButtonDisabled(buyButton)
		price.Text = "OWNED"
		wasPrice.Visible = false

		return
	end

	uiFramework.setButtonEnabled(buyButton)

	local s1

	if u43 then
		local v61 = utf8.char(57346)
		local floored = math.floor(u43)
		local replacedText = tostring(floored):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")

		s1 = v61 .. replacedText
	else
		s1 = "..."
	end

	price.Text = s1
	wasPrice.Visible = true
end
local function ensurePopScale()
	if u41 and u41.Parent == window then
		return u41
	end

	local popScale: UIScale = Instance.new("UIScale")

	popScale.Name = "PopScale"
	popScale.Scale = 1
	popScale.Parent = window
	u41 = popScale

	return popScale
end
local function cancelActiveTween()
	if u42 then
		u42:Cancel()
		u42 = nil
	end
end

local u51 = nil
local u52 = nil

u51 = function()
	if u40 then
		return
	end

	local starterPackExpiresAt: any = LocalPlayer:GetAttribute("StarterPackExpiresAt")
	local v66 = if typeof(starterPackExpiresAt) == "number" then starterPackExpiresAt else nil
	local u67: boolean = false

	if typeof(v66) == "number" then
		local timestamp = os.time()

		u67 = v66 - timestamp <= 0
	end

	if u67 and LocalPlayer:GetAttribute("OwnsPack_StarterPack") ~= true then
		return
	end

	u40 = true
	refreshBuyButton()

	local v69

	if u41 and u41.Parent == window then
		v69 = u41
	else
		local popScale: UIScale = Instance.new("UIScale")

		popScale.Name = "PopScale"
		popScale.Scale = 1
		popScale.Parent = window
		u41 = popScale
		v69 = popScale
	end

	v69.Scale = 0.85
	window.Visible = true
	backdrop.Visible = true

	if videoFrame then
		videoFrame.TimePosition = 0
		videoFrame.Playing = true
	end

	if not connection then
		connection = runService.RenderStepped:Connect(function(deltaTime: number)
			for _, v in ipairs(t1) do
				v.img.Rotation = (v.img.Rotation + v.speed * deltaTime) % 360
			end
		end)
	end

	if u42 then
		u42:Cancel()
		u42 = nil
	end

	v66 = tweenService:Create(v69, tweenInfo, { Scale = 1 })
	u42 = v66
	v66:Play()

	local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

	LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) + 1)
	windowBlur.show("StarterPackWindow")
	activeWindowChanged:Fire("StarterPackWindow")
end
u52 = function()
	if not u40 then
		return
	end

	u40 = false

	local v72

	if u41 and u41.Parent == window then
		v72 = u41
	else
		local popScale: UIScale = Instance.new("UIScale")

		popScale.Name = "PopScale"
		popScale.Scale = 1
		popScale.Parent = window
		u41 = popScale
		v72 = popScale
	end

	if u42 then
		u42:Cancel()
		u42 = nil
	end

	local v74: Tween = tweenService:Create(v72, tweenInfo2, { Scale = 0.92 })

	u42 = v74
	v74:Play()

	if videoFrame then
		videoFrame.Playing = false
	end

	if connection then
		connection:Disconnect()
		connection = nil
	end

	v74.Completed:Once(function()
		if not u40 then
			window.Visible = false
			backdrop.Visible = false
			v72.Scale = 1
		end
	end)

	local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
	local v76 = math.max((mouseUnlocked or 0) - 1, 0)

	LocalPlayer:SetAttribute("MouseUnlocked", v76)
	windowBlur.hide("StarterPackWindow")
end
activeWindowChanged.Event:Connect(function(p4)
	if p4 ~= "StarterPackWindow" and u40 then
		u52()
	end
end)
closeButton.MouseButton1Click:Connect(function()
	if u40 then
		u52()
	end
end)
buyButton.MouseButton1Click:Connect(function()
	if not buyButton.Interactable then
	elseif not starterPack then
	elseif LocalPlayer:GetAttribute("OwnsPack_StarterPack") ~= true then
		local starterPackExpiresAt: any = LocalPlayer:GetAttribute("StarterPackExpiresAt")
		local v79 = if typeof(starterPackExpiresAt) == "number" then starterPackExpiresAt else nil
		local u80: boolean = false

		if typeof(v79) == "number" then
			local timestamp = os.time()

			u80 = v79 - timestamp <= 0
		end

		if u80 then
			return
		end

		currencyBuyRequest:FireServer(starterPack.BuyProductId)

		return
	end
end)
eventTimer.driveLabel(timerTextLabel, getEndsAt, {
	onUpdate = function(_, p6)
		if textLabel then
			textLabel.Text = timerTextLabel.Text
		end

		if p6 and u40 and LocalPlayer:GetAttribute("OwnsPack_StarterPack") ~= true then
			u52()
		end
	end
})
task.spawn(function()
	local starterPack: Instance = playerGui:WaitForChild("HUD"):WaitForChild("Events"):WaitForChild("StarterPack")

	starterPack.MouseButton1Click:Connect(function()
		if u40 then
			u52()

			return
		end

		u51()
	end)

	local shine: Instance = starterPack:FindFirstChild("Shine")

	if shine then
		shineEffect.loop(shine, {
			duration = 1,
			offsetStart = Vector2.new(-1.8, 0),
			offsetEnd = Vector2.new(1.8, 0)
		})
	end

	local function applyVisibility(p7)
		local v105

		if p7 == nil then
			local starterPackExpiresAt: any = LocalPlayer:GetAttribute("StarterPackExpiresAt")
			local v107 = if typeof(starterPackExpiresAt) == "number" then starterPackExpiresAt else nil

			v105 = false

			if typeof(v107) == "number" then
				local timestamp = os.time()

				v105 = v107 - timestamp <= 0
			end
		else
			v105 = p7
		end

		local u109: boolean = not v105

		if u109 then
			u109 = LocalPlayer:GetAttribute("OwnsPack_StarterPack") ~= true

			if u109 then
				local starterPackExpiresAt: any = LocalPlayer:GetAttribute("StarterPackExpiresAt")

				u109 = (if typeof(starterPackExpiresAt) == "number" then starterPackExpiresAt else nil) ~= nil
			end
		end

		starterPack.Visible = u109
	end

	local countdown: Instance = starterPack:FindFirstChild("Countdown")

	if countdown and countdown:IsA("TextLabel") then
		eventTimer.driveLabel(countdown, getEndsAt, {
			redInFinalDay = false,
			onUpdate = function(_, p9)
				local v113

				if p9 == nil then
					local starterPackExpiresAt: any = LocalPlayer:GetAttribute("StarterPackExpiresAt")
					local v115 = if typeof(starterPackExpiresAt) == "number" then starterPackExpiresAt else nil

					v113 = false

					if typeof(v115) == "number" then
						local timestamp = os.time()

						v113 = v115 - timestamp <= 0
					end
				else
					v113 = p9
				end

				local u117: boolean = not v113

				if u117 then
					u117 = LocalPlayer:GetAttribute("OwnsPack_StarterPack") ~= true

					if u117 then
						local starterPackExpiresAt: any = LocalPlayer:GetAttribute("StarterPackExpiresAt")

						u117 = (if typeof(starterPackExpiresAt) == "number" then starterPackExpiresAt else nil) ~= nil
					end
				end

				starterPack.Visible = u117
			end
		})
	end

	LocalPlayer:GetAttributeChangedSignal("OwnsPack_StarterPack"):Connect(function()
		local starterPackExpiresAt: any = LocalPlayer:GetAttribute("StarterPackExpiresAt")
		local v120 = if typeof(starterPackExpiresAt) == "number" then starterPackExpiresAt else nil
		local u121: boolean = false

		if typeof(v120) == "number" then
			local timestamp = os.time()

			u121 = v120 - timestamp <= 0
		end

		local u123: boolean = not u121

		if u123 then
			u123 = LocalPlayer:GetAttribute("OwnsPack_StarterPack") ~= true

			if u123 then
				local starterPackExpiresAt2: any = LocalPlayer:GetAttribute("StarterPackExpiresAt")

				u123 = (if typeof(starterPackExpiresAt2) == "number" then starterPackExpiresAt2 else nil) ~= nil
			end
		end

		starterPack.Visible = u123
		refreshBuyButton()

		if LocalPlayer:GetAttribute("OwnsPack_StarterPack") == true and u40 then
			u52()
		end
	end)
	LocalPlayer:GetAttributeChangedSignal("StarterPackExpiresAt"):Connect(function()
		local starterPackExpiresAt: any = LocalPlayer:GetAttribute("StarterPackExpiresAt")
		local v126 = if typeof(starterPackExpiresAt) == "number" then starterPackExpiresAt else nil
		local u127: boolean = false

		if typeof(v126) == "number" then
			local timestamp = os.time()

			u127 = v126 - timestamp <= 0
		end

		local u129: boolean = not u127

		if u129 then
			u129 = LocalPlayer:GetAttribute("OwnsPack_StarterPack") ~= true

			if u129 then
				local starterPackExpiresAt3: any = LocalPlayer:GetAttribute("StarterPackExpiresAt")

				u129 = (if typeof(starterPackExpiresAt3) == "number" then starterPackExpiresAt3 else nil) ~= nil
			end
		end

		starterPack.Visible = u129
	end)

	local starterPackExpiresAt: any = LocalPlayer:GetAttribute("StarterPackExpiresAt")
	local v89 = if typeof(starterPackExpiresAt) == "number" then starterPackExpiresAt else nil
	local u90: boolean = false

	if typeof(v89) == "number" then
		local timestamp = os.time()

		u90 = v89 - timestamp <= 0
	end

	v89 = not u90

	if v89 then
		v89 = LocalPlayer:GetAttribute("OwnsPack_StarterPack") ~= true

		if v89 then
			local starterPackExpiresAt4: any = LocalPlayer:GetAttribute("StarterPackExpiresAt")

			v89 = (if typeof(starterPackExpiresAt4) == "number" then starterPackExpiresAt4 else nil) ~= nil
		end
	end

	starterPack.Visible = v89
end)
packPush.OnClientEvent:Connect(function(p10)
	if typeof(p10) == "table" then
		if typeof(p10.RobuxPrices) == "table" then
			local StarterPack = p10.RobuxPrices.StarterPack

			if typeof(StarterPack) == "number" then
				u43 = StarterPack
			end
		end

		refreshBuyButton()

		return
	end
end)
task.spawn(function()
	if LocalPlayer:GetAttribute("DataReady") ~= true then
		LocalPlayer:GetAttributeChangedSignal("DataReady"):Wait()
	end

	local ok, result = pcall(function()
		return packRequest:InvokeServer("GetState")
	end)

	if ok then
		if typeof(result) == "table" then
			if typeof(result.RobuxPrices) == "table" then
				local StarterPack = result.RobuxPrices.StarterPack

				if typeof(StarterPack) == "number" then
					u43 = StarterPack
				end
			end

			refreshBuyButton()

			return
		end

		return
	end
end)
