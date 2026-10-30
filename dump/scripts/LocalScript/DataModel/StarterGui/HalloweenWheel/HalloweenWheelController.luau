-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local runService: RunService = game:GetService("RunService")
local tweenService: TweenService = game:GetService("TweenService")
local soundService: SoundService = game:GetService("SoundService")
local contentProvider: ContentProvider = game:GetService("ContentProvider")
local proximityPromptService: ProximityPromptService = game:GetService("ProximityPromptService")
local LocalPlayer: Player = players.LocalPlayer
local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui")
local scriptParent: Instance = script.Parent
local scriptParentFrame: Instance = scriptParent:WaitForChild("Frame")
local wheelFrame: Instance = scriptParentFrame:WaitForChild("WheelFrame")
local wheel_Standard: Instance = wheelFrame:WaitForChild("Wheel_Standard")
local wheel_GrandPrize = wheelFrame:WaitForChild("Wheel_GrandPrize")
local centerPiece_Standard: Instance = wheelFrame:WaitForChild("CenterPiece_Standard")
local centerPiece_GrandPrize: Instance = wheelFrame:WaitForChild("CenterPiece_GrandPrize")
local wheelOutline_Standard: Instance = wheelFrame:FindFirstChild("WheelOutline_Standard")
local pointer: Instance = wheelFrame:WaitForChild("Pointer")
local jackpotWheelGlow: Instance = scriptParentFrame:FindFirstChild("JackpotWheelGlow")
local header: Instance = scriptParentFrame:WaitForChild("Header")
local headerTextLabel: Instance = header:WaitForChild("TextLabel")
local brightGlow: Instance = header:FindFirstChild("BrightGlow")
local scriptParentFrameTextLabel: Instance = scriptParentFrame:WaitForChild("TextLabel")
local options: Instance = scriptParentFrame:WaitForChild("Options")
local spinx1Button: Instance = options:WaitForChild("Spinx1Button")
local spinx3Button: Instance = options:WaitForChild("Spinx3Button")
local buyTickets: Instance = scriptParentFrame:FindFirstChild("BuyTickets")
local closeButton: Instance = scriptParentFrame:FindFirstChild("CloseButton")
local activeWindowChanged: Instance = replicatedStorage:WaitForChild("Bindables"):WaitForChild("ActiveWindowChanged")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local fovController = require(shared:WaitForChild("FOVController"))
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local wheelTicketProducts = require(replicatedStorageShared:WaitForChild("WheelTicketProducts"))
local replicatedStorageUiFramework: Instance = replicatedStorage:WaitForChild("UIFramework")
local giftPicker = require(replicatedStorageUiFramework:WaitForChild("GiftPicker"))
local uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))
local marketplaceService: MarketplaceService = game:GetService("MarketplaceService")
local httpService: HttpService = game:GetService("HttpService")
local v40 = utf8.char(57346)
local t1: {[any]: any} = {
	DEMO_MODE = false,
	state = nil,
	current = nil,
	requesting = false,
	Remotes = remotes,
	Tickets = wheelTicketProducts,
	GiftPicker = giftPicker,
	UIFramework = uiFramework,
	Market = marketplaceService,
	Http = httpService,
	ROBUX = v40,
	queue = {},
	ULTRA_SOLDOUT_FACE = "rbxassetid://137774631425812",
	ULTRA_SUBTITLE_SOLDOUT = "<b>FREE SPIN:</b> the best prizes. The <font color=\"#ff0000\"><b>ULTIMATE PRIZE</b></font> has sold out.",
	ultraLayoutShown = "Full",
	wantUltraLayout = "Full"
}
local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local color3 = Color3.fromRGB(255, 20, 20)
local t2: {[any]: any} = {
	Ticket = 116606442631051,
	WoodStart = 127688504441514,
	Stop = 75833025655519,
	RedSuspense = 127693078610781,
	Transform = 76015560194502,
	TransformHit = 124257249035731,
	UltraClick = 83291168744203,
	UltraRiser = 131468609195859,
	Coins = 135142453409806,
	CoinsBig = 123426009264394,
	CoinsQuick = 125731844743653
}
local t3: {[any]: any} = {
	Ticket = 0.8,
	WoodStart = 0.9,
	Stop = 1,
	RedSuspense = 1,
	Transform = 1,
	TransformHit = 1,
	UltraClick = 1,
	UltraRiser = 1,
	Coins = 0.6,
	CoinsBig = 0.6,
	CoinsQuick = 0.6
}
local t4: {[any]: any} = {
	["rbxassetid://72133540680965"] = "500 Coins",
	["rbxassetid://80961867726457"] = "5,000 Coins",
	["rbxassetid://83673928873413"] = "a Mystery Gun"
}
local color32 = Color3.fromRGB(110, 0, 0)
local colorSequenceNew = ColorSequence.new
local color33 = Color3.fromRGB(255, 40, 40)
local colorSequence = colorSequenceNew(color33, Color3.fromRGB(90, 0, 0))
local v51 = ColorSequence.new
local color34 = Color3.fromRGB(255, 30, 30)
local v53 = v51(color34, Color3.fromRGB(120, 0, 0))
local t5: {[any]: any} = { "HUD", "LeaderboardServiceUI" }

scriptParent.Enabled = false

local random = Random.new()

local function tween(p1, p2, p3, p4, p5)
	local tweenInfo2 = TweenInfo.new(p2, p4 or Enum.EasingStyle.Quad, p5 or Enum.EasingDirection.Out)
	local v185: Tween = tweenService:Create(p1, tweenInfo2, p3)

	v185:Play()

	return v185
end
local function setText(p6, text)
	if p6 and p6:IsA("TextLabel") then
		p6.Text = text

		for iterFirst, iterSecond in p6:GetDescendants() do
			if iterSecond:IsA("TextLabel") then
				iterSecond.Text = text
			end
		end
	end
end

local s1: string = "Closed"
local n1: number = 0
local v60: boolean = runService:IsStudio()

local function guarded(p9, p10)
	local v192, v193 = xpcall(p9, debug.traceback)

	if not v192 then
		local v194: string = s1
		local text: string = tostring(v193)

		warn(("[HalloweenWheel] %s failed in phase %s: %s"):format(p10, v194, text))
	end
end
local function after(p11, p12)
	local v198: number = n1

	task.delay(p11, function()
		if v198 == n1 and s1 ~= "Closed" then
			local v875, v876 = xpcall(p12, debug.traceback)

			if not v875 then
				local v877: string = s1
				local text: string = tostring(v876)

				warn(("[HalloweenWheel] %s failed in phase %s: %s"):format("delayed step", v877, text))
			end
		end
	end)
end

local wheelSounds: Folder = Instance.new("Folder")

wheelSounds.Name = "WheelSounds"
wheelSounds.Parent = scriptParent

local function volumeMult(p13)
	local attributeValue: any = soundService:GetAttribute(if p13 == "music" then "MusicVolumeMultiplier" else "SFXVolume")

	if typeof(attributeValue) == "number" then
		return attributeValue
	end

	return 1
end

local t6: {[any]: any} = {}

for key, value in t2 do
	local sound: Sound = Instance.new("Sound")

	sound.Name = "SFX_" .. key
	sound.SoundId = "rbxassetid://" .. value
	sound.Parent = wheelSounds
	t6[value] = sound
end

local function playOnce(p14, p15, p16)
	local v204 = t6[p14]

	if not v204 then
		return
	end

	local sfxVolume: any = soundService:GetAttribute("SFXVolume")
	local typeName: string = typeof(sfxVolume)

	v204.Volume = p15 * (if typeName == "number" then sfxVolume else 1)
	v204.PlaybackSpeed = p16 or 1
	v204.TimePosition = 0
	v204:Play()
end
local function applyVolume(p17)
	local sound = p17.sound
	local base = p17.base
	local attributeValue: any = soundService:GetAttribute(if p17.kind == "music" then "MusicVolumeMultiplier" else "SFXVolume")
	local typeName: string = typeof(attributeValue)

	sound.Volume = base * (if typeName == "number" then attributeValue else 1) * p17.level.Value
end
local function newLoop(name, p19, p20, p21)
	local sound2: Sound = Instance.new("Sound")

	sound2.Name = name
	sound2.SoundId = "rbxassetid://" .. p19
	sound2.Looped = true
	sound2.Volume = 0
	sound2.Parent = wheelSounds

	local level: NumberValue = Instance.new("NumberValue")

	level.Name = "Level"
	level.Parent = sound2

	local t13: {[any]: any} = { tween = nil, sound = sound2, base = p20, kind = p21, level = level }

	level.Changed:Connect(function()
		local v879: {[any]: any} = t13
		local sound = v879.sound
		local base = v879.base
		local attributeValue: any = soundService:GetAttribute(if v879.kind == "music" then "MusicVolumeMultiplier" else "SFXVolume")
		local typeName: string = typeof(attributeValue)

		sound.Volume = base * (if typeName == "number" then attributeValue else 1) * v879.level.Value
	end)

	return t13
end

local v72 = newLoop("Ambience", 107409025798102, 0.2, "music")
local v73 = newLoop("IdleTrack", 77929140902313, 0.375, "music")
local v74 = newLoop("LimboTrack", 116027281989317, 0.45, "music")
local v75 = newLoop("SpinLoop", 127764503733575, 0.6, "sfx")
local v76 = newLoop("UltraLoop", 133598059602598, 0.7, "sfx")

local function fade(p22, value, p24, p25)
	if p22.tween then
		p22.tween:Cancel()
	end

	p22.tween = nil

	if value > 0 and not p22.sound.IsPlaying then
		p22.sound.TimePosition = 0
		p22.sound:Play()
	end

	if p24 <= 0 then
		p22.level.Value = value

		if value == 0 and p25 then
			p22.sound:Stop()
		end

		return
	end

	local level = p22.level
	local tweenInfo3 = TweenInfo.new(p24, Enum.EasingStyle.Sine)
	local v225: Tween = tweenService:Create(level, tweenInfo3, { Value = value })

	p22.tween = v225
	v225:Play()

	if value == 0 and p25 then
		v225.Completed:Once(function(p26)
			if p26 == Enum.PlaybackState.Completed then
				p22.sound:Stop()
			end
		end)
	end
end

local t7: {[any]: any} = {
	Ambience = v72,
	Idle = v73,
	Limbo = v74,
	SpinLoop = v75,
	UltraLoop = v76
}

v76 = function()
	for key, value in t7 do
		local sound = value.sound
		local base = value.base
		local attributeValue: any = soundService:GetAttribute(if value.kind == "music" then "MusicVolumeMultiplier" else "SFXVolume")
		local typeName: string = typeof(attributeValue)

		sound.Volume = base * (if typeName == "number" then attributeValue else 1) * value.level.Value
	end
end
soundService:GetAttributeChangedSignal("MusicVolumeMultiplier"):Connect(v76)
soundService:GetAttributeChangedSignal("SFXVolume"):Connect(v76)
task.spawn(function()
	local t14: {[any]: any} = {}

	for key, value in t7 do
		table.insert(t14, value.sound)
	end

	for key2, value2 in t6 do
		table.insert(t14, value2)
	end

	pcall(function()
		contentProvider:PreloadAsync(t14)
	end)
end)

local numberValue: NumberValue = Instance.new("NumberValue")

numberValue.Value = 1

local u80 = nil
local u81 = nil
local u82: boolean = false

numberValue.Changed:Connect(function(p27: number)
	soundService:SetAttribute("MusicDuck", p27)
end)

local function duckMusic(p28)
	if u81 then
		u81:Cancel()
	end

	if p28 then
		if not u82 then
			local musicDuck: any = soundService:GetAttribute("MusicDuck")

			u80 = if typeof(musicDuck) == "number" then musicDuck else nil
			numberValue.Value = if typeof(musicDuck) == "number" then musicDuck else 1
		end

		u82 = false

		local tweenInfo4 = TweenInfo.new(0.8, Enum.EasingStyle.Sine or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local v241: Tween = tweenService:Create(numberValue, tweenInfo4, { Value = 0 })

		v241:Play()
		u81 = v241

		return
	end

	u82 = true

	local v242 = u80
	local tweenInfo5 = TweenInfo.new(1.2, Enum.EasingStyle.Sine or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local v244: Tween = tweenService:Create(numberValue, tweenInfo5, { Value = v242 or 1 })

	v244:Play()
	u81 = v244
	v244.Completed:Once(function(p29)
		if p29 ~= Enum.PlaybackState.Completed then
			return
		end

		u82 = false

		if v242 == nil then
			soundService:SetAttribute("MusicDuck", nil)
		end
	end)
end
local function readPrizes(p30, p31)
	local t15: {[any]: any} = {}

	for iterFirst, iterSecond in p30:GetChildren() do
		if iterSecond:IsA("GuiObject") then
			table.insert(t15, iterSecond)
		end
	end

	local n1 = 360 / math.max(#t15, 1)
	local t16: {[any]: any} = {}

	for key, value in t15 do
		local v254 = math.atan2(value.Position.X.Scale + (0.5 - value.AnchorPoint.X) * value.Size.X.Scale - 0.5, -(value.Position.Y.Scale + (0.5 - value.AnchorPoint.Y) * value.Size.Y.Scale - 0.5))
		local v255 = math.deg(v254)
		local n2 = math.floor(v255 % 360 / n1 + 0.5) * n1 % 360
		local icon = value:FindFirstChild("Icon")
		local v258 = if icon and icon:IsA("ImageLabel") then icon.Image else ""
		local u259: boolean = n2 == 0

		v255 = if u259 then if p31 then "the ULTIMATE PRIZE" else "???" else t4[v258] or "a prize"

		local floored = math.floor(n2 / n1 + 0.5)

		table.insert(t16, {
			frame = value,
			angle = n2,
			special = u259,
			label = v255,
			slot = floored % #t15
		})
	end

	return t16, n1
end

local v85, v86 = readPrizes(wheel_Standard, false)
local u87, u88 = readPrizes(wheel_GrandPrize, true)

function t1.buildSoldOutFace()
	local wheel_GrandPrize_SoldOut: Instance = wheelFrame:FindFirstChild("Wheel_GrandPrize_SoldOut")

	if wheel_GrandPrize_SoldOut and wheel_GrandPrize_SoldOut:IsA("GuiObject") then
		return wheel_GrandPrize_SoldOut
	end

	for iterFirst, iterSecond in u87 do
		iterSecond.frame:SetAttribute("WheelSlot", iterSecond.slot)
	end

	local clone: Instance = wheel_GrandPrize:Clone()

	for iterFirst2, iterSecond2 in u87 do
		iterSecond2.frame:SetAttribute("WheelSlot", nil)
	end

	clone.Name = "Wheel_GrandPrize_SoldOut"

	if clone:IsA("ImageLabel") then
		clone.Image = t1.ULTRA_SOLDOUT_FACE
	end

	clone.Visible = false

	local t17: {[any]: any} = {}

	for iterFirst3, iterSecond3 in clone:GetChildren() do
		local wheelSlot = iterSecond3:GetAttribute("WheelSlot")

		if typeof(wheelSlot) == "number" then
			iterSecond3:SetAttribute("WheelSlot", nil)

			if wheelSlot == 0 then
				iterSecond3:Destroy()
			else
				table.insert(t17, { f = iterSecond3, s = wheelSlot })
			end
		end
	end

	table.sort(t17, function(p32, p33)
		return p32.s < p33.s
	end)

	for key, value in t17 do
		local f = value.f
		local n1 = 0.5 - f.AnchorPoint.X
		local n2 = 0.5 - f.AnchorPoint.Y
		local squareRoot = math.sqrt((f.Position.X.Scale + n1 * f.Size.X.Scale - 0.5) ^ 2 + (f.Position.Y.Scale + n2 * f.Size.Y.Scale - 0.5) ^ 2)
		local v277 = math.rad((key - 1) * 360 / #t17)
		local uDim2FromScale = UDim2.fromScale
		local sine = math.sin(v277)
		local n3 = squareRoot * sine + 0.5 - n1 * f.Size.X.Scale
		local cosine = math.cos(v277)

		f.Position = uDim2FromScale(n3, 0.5 - squareRoot * cosine - n2 * f.Size.Y.Scale)
	end

	clone.Parent = wheelFrame

	return clone
end
function t1.initUltraFaces()
	t1.ultraFaces = {
		Full = { face = wheel_GrandPrize, prizes = u87, seg = u88 }
	}

	if #u87 == 6 or wheelFrame:FindFirstChild("Wheel_GrandPrize_SoldOut") then
		local ok, result = pcall(t1.buildSoldOutFace)

		if ok and result then
			local v284, v285 = readPrizes(result, true)

			for iterFirst, iterSecond in v284 do
				iterSecond.special = false
			end

			t1.ultraFaces.SoldOut = { face = result, prizes = v284, seg = v285 }

			return
		end

		local text: string = tostring(result)

		warn("[HalloweenWheel] couldn't build the sold-out Ultra face: " .. text)

		return
	end
end

t1.initUltraFaces()

function t1.prizesForLayout(p34)
	return (t1.ultraFaces[p34] or t1.ultraFaces.Full).prizes
end
function t1.prizeBySlot(p35, p36)
	for iterFirst, iterSecond in p35 do
		if p36 == iterSecond.slot then
			return iterSecond
		end
	end

	return nil
end

t1.CYCLE_EVERY = 1.2
t1.CYCLE_ICON_SIZE = 1
t1.cycleIdx = 1
t1.cycleSlice = nil
t1.cycleOdds = nil

function t1.ultraIcons()
	local v294 = t1.state and t1.state.ultra

	if typeof(v294) == "table" then
		local v295 = table.clone(v294)

		table.sort(v295, function(p37, p38)
			local numberValue2: number? = tonumber(p37.slot)
			local numberValue3: number? = tonumber(p38.slot)

			return (numberValue2 or 0) < (numberValue3 or 0)
		end)

		local t18: {[any]: any} = {}

		for iterFirst, iterSecond in v295 do
			if typeof(iterSecond.icon) == "string" and iterSecond.icon ~= "" and (tonumber(iterSecond.odds) or 0) > 0 then
				table.insert(t18, iterSecond.icon)
			end
		end

		return t18
	end

	return {}
end
function t1.cycleImage()
	local v299 = t1.ultraIcons()

	if #v299 == 0 then
		return nil
	end

	t1.cycleIdx = (t1.cycleIdx - 1) % #v299 + 1

	return v299[t1.cycleIdx]
end
function t1.cycleTargets()
	local t19: {[any]: any} = {}
	local cycleSlice = t1.cycleSlice
	local cycleOdds = t1.cycleOdds

	if cycleSlice and cycleSlice.Parent then
		table.insert(t19, cycleSlice)
	end

	if cycleOdds and cycleOdds.Parent then
		table.insert(t19, cycleOdds)
	end

	return t19
end
function t1.cycleShow()
	local image = t1.cycleImage()

	if not image then
		return
	end

	for iterFirst, iterSecond in t1.cycleTargets() do
		iterSecond.Image = image
		iterSecond.ImageColor3 = Color3.new(1, 1, 1)
	end
end
function t1.cycleStep()
	local v306: {[any]: any} = t1

	v306.cycleIdx = v306.cycleIdx + 1

	local v307 = t1.cycleImage()

	if not v307 then
		return
	end

	for iterFirst, iterSecond in t1.cycleTargets() do
		local wheelFXScale = iterSecond:FindFirstChild("WheelFXScale")

		if not wheelFXScale then
			local wheelFXScale2: UIScale = Instance.new("UIScale")

			wheelFXScale2.Name = "WheelFXScale"
			wheelFXScale2.Parent = iterSecond
			wheelFXScale = wheelFXScale2
		end

		local tweenInfo6 = TweenInfo.new(0.12, Enum.EasingStyle.Quad or Enum.EasingStyle.Quad, Enum.EasingDirection.In or Enum.EasingDirection.Out)
		local v313: Tween = tweenService:Create(wheelFXScale, tweenInfo6, { Scale = 0 })

		v313:Play()
		v313.Completed:Once(function()
			iterSecond.Image = v307
			iterSecond.ImageColor3 = Color3.new(1, 1, 1)

			local tweenInfo7 = TweenInfo.new(0.3, Enum.EasingStyle.Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

			tweenService:Create(wheelFXScale, tweenInfo7, { Scale = 1 }):Play()
		end)
	end
end

task.spawn(function()
	while true do
		task.wait(t1.CYCLE_EVERY)

		if scriptParent.Enabled then
			t1.cycleStep()
		end
	end
end)

function t1.applyState(p39)
	local ok, result = pcall(function()
		return t1.Http:JSONDecode(p39)
	end)

	if ok and typeof(result) == "table" then
		t1.state = result

		local resultStandard = result.standard
		local v318 = t1.prizesForLayout(result.ultraLayout)

		for iterFirst, value in {
			{ v85, resultStandard },
			{ v318, result.ultra }
		}, nil, nil do
			local v321 = value[1]
			local v322 = value[2]

			if typeof(v322) == "table" then
				for iterFirst2, iterSecond in v322 do
					local v325 = t1.prizeBySlot(v321, iterSecond.slot)

					if v325 then
						v325.label = tostring(iterSecond.name)

						local icon = v325.frame:FindFirstChild("Icon")

						if icon and icon:IsA("ImageLabel") and iterSecond.kind == "Ultra" then
							t1.cycleSlice = icon
							icon.Size = UDim2.fromScale(t1.CYCLE_ICON_SIZE, t1.CYCLE_ICON_SIZE)
						elseif icon and icon:IsA("ImageLabel") and typeof(iterSecond.icon) == "string" and iterSecond.icon ~= "" then
							icon.Image = iterSecond.icon
							icon.ImageColor3 = Color3.new(1, 1, 1)
						end

						local textLabel = icon and icon:FindFirstChildWhichIsA("TextLabel")

						if textLabel then
							local amount = iterSecond.amount

							if iterSecond.kind == "Coins" and typeof(amount) == "number" then
								local v329 = if amount >= 1000 then string.format("%gk", amount / 1000) else tostring(amount)

								setText(textLabel, v329)
								textLabel.Visible = true
							else
								textLabel.Visible = false
							end
						end
					end
				end
			end
		end

		t1.cycleShow()

		local v330 = t1.ultraIcons()

		task.spawn(function()
			pcall(contentProvider.PreloadAsync, contentProvider, v330)
		end)

		if t1.refreshOdds then
			t1.refreshOdds()
		end

		t1.wantUltraLayout = if typeof(result.ultraLayout) == "string" then result.ultraLayout else "Full"

		if t1.syncUltraLayout then
			t1.syncUltraLayout()
		end

		return
	end
end

task.spawn(function()
	local halloweenWheelState = t1.Remotes:WaitForChild("HalloweenWheelState", 60)

	if not halloweenWheelState or not halloweenWheelState:IsA("StringValue") then
		return
	end

	t1.applyState(halloweenWheelState.Value)
	halloweenWheelState:GetPropertyChangedSignal("Value"):Connect(function()
		t1.applyState(halloweenWheelState.Value)
	end)
end)

local function pick(p40, p41)
	local v334 = nil
	local t20: {[any]: any} = {}

	for iterFirst, iterSecond in p40 do
		if iterSecond.special then
			v334 = iterSecond
		else
			table.insert(t20, iterSecond)
		end
	end

	if v334 and (p41 > random:NextNumber() or #t20 == 0) then
		return v334
	end

	local v338 = random:NextInteger(1, #t20)

	return t20[v338]
end

local t8: {[any]: any} = {}

for iterFirst, iterSecond in scriptParentFrame:GetChildren() do
	if iterSecond.Name == "Vignette" and iterSecond:IsA("ImageLabel") then
		table.insert(t8, iterSecond)
	end
end

local wheelOutline_StandardUiGradient: Instance = wheelOutline_Standard and wheelOutline_Standard:FindFirstChildOfClass("UIGradient")
local v94: Instance = brightGlow

if v94 then
	v94 = brightGlow:FindFirstChildOfClass("UIGradient")
end

local textLabel: Instance = spinx1Button:FindFirstChild("TextLabel")
local price: Instance = spinx1Button:FindFirstChild("Price")
local v97: Instance = price and price:FindFirstChild("Price")
local icon: Instance = price and price:FindFirstChild("Icon")
local t9: {[any]: any} = {
	header = headerTextLabel.Text,
	subtitle = scriptParentFrameTextLabel.Text,
	framePos = scriptParentFrame.Position,
	glowT = if jackpotWheelGlow then jackpotWheelGlow.ImageTransparency else 0,
	glowSize = if jackpotWheelGlow then jackpotWheelGlow.Size else UDim2.new(),
	vignette = {},
	outline = if wheelOutline_StandardUiGradient then wheelOutline_StandardUiGradient.Color else nil,
	headerGlow = if v94 then v94.Color else nil,
	x1Text = if textLabel and textLabel:IsA("TextLabel") then textLabel.Text else "Spin x1",
	x1Price = if v97 and v97:IsA("TextLabel") then v97.Text else "x1",
	x3Visible = spinx3Button.Visible,
	buyVisible = if buyTickets then buyTickets.Visible else false
}

for key2, value2 in t8 do
	t9.vignette[value2] = value2.ImageColor3
end

local wheelFXScale = wheelFrame:FindFirstChild("WheelFXScale")

if not wheelFXScale then
	local wheelFXScale4: UIScale = Instance.new("UIScale")

	wheelFXScale4.Name = "WheelFXScale"
	wheelFXScale4.Parent = wheelFrame
	wheelFXScale = wheelFXScale4
end

local wheelFXScale2 = scriptParentFrameTextLabel:FindFirstChild("WheelFXScale")

if not wheelFXScale2 then
	local uiScale: UIScale = Instance.new("UIScale")

	uiScale.Name = "WheelFXScale"
	uiScale.Parent = scriptParentFrameTextLabel
	wheelFXScale2 = uiScale
end

local wheelFXScale3 = spinx1Button:FindFirstChild("WheelFXScale")

if not wheelFXScale3 then
	local uiScale: UIScale = Instance.new("UIScale")

	uiScale.Name = "WheelFXScale"
	uiScale.Parent = spinx1Button
	wheelFXScale3 = uiScale
end

local fx_Flash: Frame = Instance.new("Frame")

fx_Flash.Name = "FX_Flash"
fx_Flash.AnchorPoint = Vector2.new(0.5, 0.5)
fx_Flash.Position = UDim2.fromScale(0.5, 0.5)
fx_Flash.Size = UDim2.fromScale(1.3, 1.3)
fx_Flash.BorderSizePixel = 0
fx_Flash.BackgroundTransparency = 1
fx_Flash.ZIndex = 9000
fx_Flash.Active = false
fx_Flash.Parent = scriptParentFrame

local fx_SpeedLines: Frame = Instance.new("Frame")

fx_SpeedLines.Name = "FX_SpeedLines"
fx_SpeedLines.Size = UDim2.fromScale(1, 1)
fx_SpeedLines.BackgroundTransparency = 1
fx_SpeedLines.Visible = false
fx_SpeedLines.ZIndex = -100
fx_SpeedLines.Parent = scriptParentFrame

local t10: {[any]: any} = {}

for i = 1, 44 do
	local frame: Frame = Instance.new("Frame")

	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BorderSizePixel = 0
	frame.BackgroundColor3 = Color3.new(1, 1, 1)

	local uiGradient: UIGradient = Instance.new("UIGradient")

	uiGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.5, 0.4),
		NumberSequenceKeypoint.new(1, 0)
	})
	uiGradient.Parent = frame
	frame.Parent = fx_SpeedLines
	t10[i] = frame
end

local u114 = false
local n2 = 0
local u116 = nil
local n3 = 0
local n4 = 0
local u119: boolean = false
local u120 = nil
local n5: number = 1.2
local u122 = nil
local n6 = -10
local t11: {[any]: any} = {}

local function addShake(p42, p43, p44)
	local v342 = os.clock()

	table.insert(t11, {
		start = v342,
		dur = p42,
		amp = p43,
		ramp = if p44 == true then true else false
	})
end

local u126 = nil

local function flash(backgroundColor3, p46, p47, p48)
	if u126 then
		u126:Cancel()
	end

	fx_Flash.BackgroundColor3 = backgroundColor3
	fx_Flash.BackgroundTransparency = 1

	local tweenInfo8 = TweenInfo.new(p47, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local v348: Tween = tweenService:Create(fx_Flash, tweenInfo8, { BackgroundTransparency = 1 - p46 })

	v348:Play()
	u126 = v348
	v348.Completed:Once(function(p49)
		if p49 ~= Enum.PlaybackState.Completed then
			return
		end

		local tweenInfo9 = TweenInfo.new(p48, Enum.EasingStyle.Quad or Enum.EasingStyle.Quad, Enum.EasingDirection.In or Enum.EasingDirection.Out)
		local v895: Tween = tweenService:Create(fx_Flash, tweenInfo9, { BackgroundTransparency = 1 })

		v895:Play()
		u126 = v895
	end)
end

local u128 = nil

local function scaleWheel(p50, p51, p52, p53)
	if u128 then
		u128:Cancel()
	end

	local tweenInfo10 = TweenInfo.new(p51, p52 or Enum.EasingStyle.Quad, p53 or Enum.EasingDirection.Out)
	local v354: Tween = tweenService:Create(wheelFXScale, tweenInfo10, { Scale = p50 })

	v354:Play()
	u128 = v354

	return v354
end

local u130 = nil
local n7 = 0
local n8 = 0

local function shuffleLines(p54, p55)
	local scriptParentFrameAbsoluteSize = scriptParentFrame.AbsoluteSize
	local scriptParentFrameAbsoluteSizeY = scriptParentFrameAbsoluteSize.Y
	local n1 = scriptParentFrameAbsoluteSize.X / 2
	local n2 = scriptParentFrameAbsoluteSizeY / 2
	local n3 = 1 - p55 * 0.7

	for key, value in t10 do
		if random:NextNumber() < 0.35 - p54 * 0.2 then
			value.Visible = false
		else
			local v364 = random:NextNumber()
			local n4 = (key + v364 - 0.5) / #t10 * 3.141592653589793 * 2
			local cosine = math.cos(n4)
			local sine = math.sin(n4)
			local absoluteValue = math.abs(cosine)

			v364 = math.max(absoluteValue, 0.001)

			local absoluteValue2 = math.abs(sine)
			local v370 = math.max(absoluteValue2, 0.001)
			local v371 = math.min(n1 / v364, n2 / v370)
			local n5 = scriptParentFrameAbsoluteSizeY * 0.3

			v364 = v371 * 1.15

			local v373 = random:NextNumber(0.05, 0.8 - p54 * 0.45)

			v370 = n5 + (v371 - n5) * v373
			n5 = (v370 + v364) / 2

			local uDim2FromOffset = UDim2.fromOffset
			local v375 = random:NextNumber()

			value.Size = uDim2FromOffset(v364 - v370, scriptParentFrameAbsoluteSizeY * (0.003 + 0.007 * v375))
			value.Position = UDim2.fromOffset(n1 + cosine * n5, n2 + sine * n5)
			value.Rotation = math.deg(n4)
			value.BackgroundColor3 = Color3.new(1, n3, n3)
			v373 = random:NextNumber(0.4, 1)
			value.BackgroundTransparency = 1 - (p54 * 0.7 + 0.3) * v373
			value.Visible = true
		end
	end
end
local function fovPush(p56, p57, p58)
	local fovControllerPush = fovController.Push
	local v380 = fovController.GetBase()

	pcall(fovControllerPush, "HalloweenWheel", v380 * p56, p57, p58)
end
local function fovPop(p59, p60)
	pcall(fovController.Pop, "HalloweenWheel", p59, p60)
end
local function startBuild(p61, p62, p63, p64)
	u130 = { start = os.clock(), dur = p61, zoom = p62, ultra = p64 }
	n7 = 0
	n8 = 0

	if u128 then
		u128:Cancel()
	end

	fx_SpeedLines.Visible = true

	if p63 > 0 then
		local linear = Enum.EasingStyle.Linear
		local fovControllerPush = fovController.Push
		local v389 = fovController.GetBase()

		pcall(fovControllerPush, "HalloweenWheel", v389 * -p63, p61, linear)
	end
end
local function endBuild()
	u130 = nil
	fx_SpeedLines.Visible = false
end

local u138 = nil
local u139 = nil

local function clearTint()
	if u139 then
		u139:Cancel()
	end

	u139 = nil

	if u138 then
		u138:Destroy()
	end

	u138 = nil
end
local function tintIn(p65)
	if u139 then
		u139:Cancel()
	end

	u139 = nil

	if u138 then
		u138:Destroy()
	end

	u138 = nil

	local CurrentCamera: Camera = workspace.CurrentCamera

	if not CurrentCamera then
		return
	end

	local wheelRedTint: ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

	wheelRedTint.Name = "WheelRedTint"
	wheelRedTint.Parent = CurrentCamera
	u138 = wheelRedTint

	local tweenInfo11 = TweenInfo.new(p65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local v394: Tween = tweenService:Create(wheelRedTint, tweenInfo11, { Contrast = 0.3, Saturation = -1, TintColor = color3 })

	v394:Play()
	u139 = v394
end
local function tintOut(p66)
	local v396 = u138

	if not v396 then
		return
	end

	if u139 then
		u139:Cancel()
	end

	local t21: {[any]: any} = { Contrast = 0, Saturation = 0, TintColor = Color3.new(1, 1, 1) }
	local tweenInfo12 = TweenInfo.new(p66, Enum.EasingStyle.Sine or Enum.EasingStyle.Quad, Enum.EasingDirection.InOut or Enum.EasingDirection.Out)
	local v399: Tween = tweenService:Create(v396, tweenInfo12, t21)

	v399:Play()
	u139 = v399
	v399.Completed:Once(function(p67)
		if p67 == Enum.PlaybackState.Completed and u138 == v396 then
			if u139 then
				u139:Cancel()
			end

			u139 = nil

			if u138 then
				u138:Destroy()
			end

			u138 = nil
		end
	end)
end
local function punchWheel()
	if u128 then
		u128:Cancel()
	end

	local tweenInfo13 = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local v401: Tween = tweenService:Create(wheelFXScale, tweenInfo13, { Scale = 1.04 })

	v401:Play()
	u128 = v401
	v401.Completed:Once(function(p68)
		if p68 == Enum.PlaybackState.Completed then
			local back = Enum.EasingStyle.Back

			if u128 then
				u128:Cancel()
			end

			local tweenInfo14 = TweenInfo.new(0.3, back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local v900: Tween = tweenService:Create(wheelFXScale, tweenInfo14, { Scale = 1 })

			v900:Play()
			u128 = v900
		end
	end)
end
local function pulsePrize(parent, p70)
	local wheelFXScale4 = parent:FindFirstChild("WheelFXScale")

	if not wheelFXScale4 then
		local wheelFXScale: UIScale = Instance.new("UIScale")

		wheelFXScale.Name = "WheelFXScale"
		wheelFXScale.Parent = parent
		wheelFXScale4 = wheelFXScale
	end

	local tweenInfo15 = TweenInfo.new(0.18, Enum.EasingStyle.Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local v407: Tween = tweenService:Create(wheelFXScale4, tweenInfo15, { Scale = p70 })

	v407:Play()
	v407.Completed:Once(function(p71)
		if p71 == Enum.PlaybackState.Completed then
			local tweenInfo16 = TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

			tweenService:Create(wheelFXScale4, tweenInfo16, { Scale = 1 }):Play()
		end
	end)
end

local n9: number = 0

local function defaultSubtitle()
	if u114 and t1.ultraLayoutShown == "SoldOut" then
		return t1.ULTRA_SUBTITLE_SOLDOUT
	end

	if u114 then
		return "<b>FREE SPIN:</b> All prizes are secret."
	end

	return t9.subtitle
end
local function showResult(text, p73)
	n9 += 1

	local v410: number = n9

	scriptParentFrameTextLabel.Text = text
	wheelFXScale2.Scale = 1.3

	local tweenInfo17 = TweenInfo.new(0.35, Enum.EasingStyle.Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	tweenService:Create(wheelFXScale2, tweenInfo17, { Scale = 1 }):Play()
	task.delay(p73, function()
		if v410 == n9 then
			scriptParentFrameTextLabel.Text = if u114 and t1.ultraLayoutShown == "SoldOut" then t1.ULTRA_SUBTITLE_SOLDOUT else if u114 then "<b>FREE SPIN:</b> All prizes are secret." else t9.subtitle
		end
	end)
end
local function setUltraLook(visible)
	u114 = visible
	wheel_Standard.Visible = not visible
	wheel_GrandPrize.Visible = visible
	centerPiece_Standard.Visible = not visible
	centerPiece_GrandPrize.Visible = visible

	for iterFirst, iterSecond in t9.vignette, nil, nil do
		iterFirst.ImageColor3 = if visible then color32 else iterSecond
	end

	if wheelOutline_StandardUiGradient and t9.outline then
		wheelOutline_StandardUiGradient.Color = if visible then colorSequence else t9.outline
	end

	if v94 and t9.headerGlow then
		v94.Color = if visible then v53 else t9.headerGlow
	end

	headerTextLabel.Text = if visible then "ULTRA WHEEL" else t9.header
	n9 += 1
	scriptParentFrameTextLabel.Text = if u114 and t1.ultraLayoutShown == "SoldOut" then t1.ULTRA_SUBTITLE_SOLDOUT else if u114 then "<b>FREE SPIN:</b> All prizes are secret." else t9.subtitle
	spinx3Button.Visible = not visible and t9.x3Visible

	if t1.refreshBulkButton then
		t1.refreshBulkButton()
	end

	setText(textLabel, if visible then "SPIN!" else t9.x1Text)
	setText(v97, if visible then "FREE" else t9.x1Price)

	if icon and icon:IsA("GuiObject") then
		icon.Visible = not visible
	end

	if buyTickets then
		buyTickets.Visible = not visible and t9.buyVisible
	end

	if jackpotWheelGlow and not visible then
		jackpotWheelGlow.ImageTransparency = t9.glowT
		jackpotWheelGlow.Size = t9.glowSize
	end

	u122 = nil

	if not visible and t1.syncUltraLayout then
		t1.syncUltraLayout()
	end
end
function t1.setUltraLayout(p75)
	local v416 = if typeof(p75) == "string" and t1.ultraFaces[p75] then p75 else "Full"

	if v416 == t1.ultraLayoutShown then
		return
	end

	local v417 = t1.ultraFaces[v416]
	local v418: Instance = wheel_GrandPrize

	wheel_GrandPrize = v417.face
	u87 = v417.prizes
	u88 = v417.seg
	t1.ultraLayoutShown = v416
	v418.Visible = false
	wheel_GrandPrize.Rotation = v418.Rotation
	wheel_GrandPrize.Visible = u114
	u122 = nil
end
function t1.syncUltraLayout()
	if not u114 and s1 ~= "Transform" then
		t1.setUltraLayout(t1.wantUltraLayout)

		return
	end
end

t1.syncUltraLayout()

local function resetVisuals()
	u130 = nil
	fx_SpeedLines.Visible = false
	pcall(fovController.Pop, "HalloweenWheel", 0.2, nil)

	if u139 then
		u139:Cancel()
	end

	u139 = nil

	if u138 then
		u138:Destroy()
	end

	u138 = nil
	setUltraLook(false)

	if u128 then
		u128:Cancel()
	end

	wheelFXScale.Scale = 1
	wheelFXScale3.Scale = 1
	wheelFXScale2.Scale = 1

	if u126 then
		u126:Cancel()
	end

	fx_Flash.BackgroundTransparency = 1
	scriptParentFrame.Position = t9.framePos
	pointer.Rotation = 0
	u120 = nil
	table.clear(t11)

	for iterFirst, value in { v85, u87 }, nil, nil do
		for iterFirst2, iterSecond in value do
			local frame = iterSecond.frame
			local wheelFXScale5 = frame:FindFirstChild("WheelFXScale")

			if not wheelFXScale5 then
				local wheelFXScale4: UIScale = Instance.new("UIScale")

				wheelFXScale4.Name = "WheelFXScale"
				wheelFXScale4.Parent = frame
				wheelFXScale5 = wheelFXScale4
			end

			wheelFXScale5.Scale = 1
		end
	end
end

local n10 = 0
local s2: string = s1

runService.RenderStepped:Connect(function(deltaTime: number)
	if v60 and s1 ~= s2 then
		local v427: string = s2
		local v428: string = s1
		local text: string = tostring(u114)

		print(("[HalloweenWheel] %s -> %s (ultra=%s)"):format(v427, v428, text))
		s2 = s1
	end

	if s1 == "Closed" then
		return
	end

	local v430 = os.clock()
	local v431 = u116

	if v431 then
		local n1 = v430 - v431.start
		local from = v431.from
		local curve = v431.curve
		local v435 = math.min(n1, v431.duration)
		local v436 = curve(v435)
		local n9 = from + v436

		if n9 == n9 then
			n2 = n9
		elseif v60 then
			warn("[HalloweenWheel] spin curve gave NaN; holding the last angle")
		end

		if n1 >= v431.duration then
			u116 = nil

			local v438, v439 = xpcall(v431.done, debug.traceback)

			if not v438 then
				local v440: string = s1
				local text: string = tostring(v439)

				warn(("[HalloweenWheel] %s failed in phase %s: %s"):format("spin finish", v440, text))
			end
		end
	elseif v430 >= n3 then
		n2 += (if u114 then 7 else 10) * deltaTime
	end

	v431 = n2

	local v442 = u120

	if v442 then
		local n11 = v430 - v442

		if n11 > 0.7 then
			u120 = nil
		else
			local v444: number = n5
			local v445 = math.exp(-n11 * 8)
			local sine = math.sin(n11 * 26)

			v431 += v444 * v445 * sine
		end
	end

	v442 = v431 % 360

	for iterFirst, value in { wheel_Standard, wheel_GrandPrize }, nil, nil do
		value.Rotation = v442

		for iterFirst2, iterSecond in value:GetChildren() do
			if iterSecond:IsA("GuiObject") then
				iterSecond.Rotation = -v442
			end
		end
	end

	v442 = if u114 then u88 else v86

	local floored = math.floor((n2 + v442 / 2) / v442)

	if u122 ~= nil and floored ~= u122 then
		n6 = v430
	end

	u122 = floored
	pointer.Rotation = math.exp(-(v430 - n6) * 14) * -18

	local absoluteValue = math.abs(n2 - n10)
	local v453 = math.max(deltaTime, 0.004166666666666667)

	n10 = n2

	local sound = t7.SpinLoop.sound

	if sound.IsPlaying then
		local soundPlaybackSpeed = sound.PlaybackSpeed
		local n4 = math.clamp(absoluteValue / v453 / 650, 0, 1) ^ 0.6 * 0.55 + 0.55 - sound.PlaybackSpeed
		local v457 = math.min(1, deltaTime * 10)

		sound.PlaybackSpeed = soundPlaybackSpeed + n4 * v457
	else
		sound.PlaybackSpeed = 0.55
	end

	v442 = 0

	for i = #t11, 1, -1 do
		local v459 = t11[i]
		local n12 = (v430 - v459.start) / v459.dur

		if n12 >= 1 then
			table.remove(t11, i)
		else
			v442 = math.max(v442, if v459.ramp then v459.amp * n12 * n12 else v459.amp * (1 - n12) ^ 2)
		end
	end

	if v442 > 0.05 then
		local framePos = t9.framePos
		local uDim2FromOffset = UDim2.fromOffset
		local v463 = math.noise(v430 * 25, 0.3)
		local v464 = math.noise(0.7, v430 * 25)
		local uDim2 = uDim2FromOffset(v463 * v442 * 2, v464 * v442 * 2)

		scriptParentFrame.Position = framePos + uDim2
	else
		scriptParentFrame.Position = t9.framePos
	end

	v442 = u130

	if v442 then
		local v466 = math.clamp((v430 - v442.start) / v442.dur, 0, 1)
		local n13 = 0

		if not v442.ultra then
			n7 += deltaTime * (v466 * 2.2 + 1.3)

			local n14 = n7 % 1
			local v469 = math.exp(-(((n14 - 0.1) / 0.045) ^ 2))
			local v470 = math.exp(-(((n14 - 0.3) / 0.045) ^ 2))

			n13 = (v469 + v470 * 0.6) * (v466 * 0.03 + 0.015)
		end

		wheelFXScale.Scale = 1 + v442.zoom * v466 * v466 + n13

		if v430 - n8 > (if v442.ultra then 0.06 - v466 * 0.03 else 0.06) then
			n8 = v430
			shuffleLines(v466, if v442.ultra then v466 * 0.5 + 0.5 else v466)
		end

		if jackpotWheelGlow and not v442.ultra then
			jackpotWheelGlow.ImageTransparency = math.clamp(t9.glowT * (1 - v466) - n13 * 6, 0, 1)

			local glowSize = t9.glowSize
			local v472 = UDim2.fromScale(v466 * 0.15 + n13 * 2, v466 * 0.15 + n13 * 2)

			jackpotWheelGlow.Size = glowSize + v472
		end

		if not v442.ultra then
			for iterFirst3, iterSecond2 in t9.vignette, nil, nil do
				iterFirst3.ImageColor3 = iterSecond2:Lerp(color32, v466)
			end
		end
	end

	if jackpotWheelGlow and u114 then
		local sine = math.sin(v430 * (if s1 == "UltraSpinning" then 12 else 3))

		jackpotWheelGlow.ImageTransparency = sine * 0.12 + 0.12

		local v476 = t9.glowSize
		local v477 = UDim2.fromScale(sine * 0.03 + 0.05, sine * 0.03 + 0.05)

		jackpotWheelGlow.Size = v476 + v477
	end

	wheelFXScale3.Scale = if s1 == "Ultra" then math.sin(v430 * 4) * 0.05 + 1 else 1

	if closeButton and closeButton:IsA("GuiObject") then
		closeButton.Visible = s1 == "Idle"
	end
end)

local function targetFor(p77, p78, p79)
	local v481 = random:NextNumber()

	return n2 + p79 * 360 + (((v481 - 0.5) * (p78 - 16) - p77.angle) % 360 - n2 % 360) % 360
end
local function spinCurve(p80, p81, p82, p83)
	local n1 = p81 + p82 + p83
	local v487 = table.create(481, 0)
	local n2 = 0
	local n3 = 0

	for i = 0, 480 do
		local n4 = n1 * i / 480
		local n5 = n4 / p81
		local n6 = if p81 > n4 then n5 * n5 * (3 - n5 * 2) else if n4 < p81 + p82 then 1 else (1 - math.clamp((n4 - p81 - p82) / p83, 0, 1)) ^ 2.4 * 0.985 + 0.015

		if i > 0 then
			n2 += (n3 + n6) / 2
		end

		v487[i + 1] = n2
		n3 = n6
	end

	return function(p84)
		local n3 = math.clamp(p84 / n1, 0, 1) * 480
		local floored = math.floor(n3)
		local v906 = math.min(floored, 480)
		local v907 = v487[v906 + 1]
		local v908 = math.min(floored + 1, 480)

		return p80 * ((v907 + (v487[v908 + 1] - v907) * (n3 - floored)) / n2)
	end
end
local function eased(p85, p86, p87)
	return function(p88)
		local v910 = math.clamp(p88 / p86, 0, 1)
		local v911 = p87(v910)

		return p85 * v911
	end
end
local function ultraEase(p89)
	return p89 ^ 1.3
end
local function whirlEase(p90)
	return -(math.cos(3.141592653589793 * p90) - 1) / 2
end
local function startIdleTrack(p91)
	local function v500()
		if s1 == "Idle" then
			fade(t7.Idle, 1, 2)
		end
	end

	local v501: number = n1

	task.delay(p91, function()
		if v501 == n1 and s1 ~= "Closed" then
			local v912, v913 = xpcall(v500, debug.traceback)

			if not v912 then
				local v914: string = s1
				local text: string = tostring(v913)

				warn(("[HalloweenWheel] %s failed in phase %s: %s"):format("delayed step", v914, text))
			end
		end
	end)
end
local function backToIdle()
	s1 = "Idle"

	local function v502()
		if s1 == "Idle" then
			fade(t7.Idle, 1, 2)
		end
	end

	local v503: number = n1

	task.delay(1.2, function()
		if v503 == n1 and s1 ~= "Closed" then
			local v916, v917 = xpcall(v502, debug.traceback)

			if not v916 then
				local v918: string = s1
				local text: string = tostring(v917)

				warn(("[HalloweenWheel] %s failed in phase %s: %s"):format("delayed step", v918, text))
			end
		end
	end)
	t1.releaseCash()
end

local u159 = nil
local u160 = nil

local function popUltraPrizes()
	for iterFirst, iterSecond in u87 do
		local frame = iterSecond.frame
		local wheelFXScale6 = frame:FindFirstChild("WheelFXScale")

		if not wheelFXScale6 then
			local wheelFXScale: UIScale = Instance.new("UIScale")

			wheelFXScale.Name = "WheelFXScale"
			wheelFXScale.Parent = frame
			wheelFXScale6 = wheelFXScale
		end

		wheelFXScale6.Scale = 0

		local function v509()
			local tweenInfo18 = TweenInfo.new(0.35, Enum.EasingStyle.Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

			tweenService:Create(wheelFXScale6, tweenInfo18, { Scale = 1 }):Play()
		end

		local v510: number = n1

		task.delay(iterFirst * 0.05, function()
			if v510 == n1 and s1 ~= "Closed" then
				local v921, v922 = xpcall(v509, debug.traceback)

				if not v921 then
					local v923: string = s1
					local text: string = tostring(v922)

					warn(("[HalloweenWheel] %s failed in phase %s: %s"):format("delayed step", v923, text))
				end
			end
		end)
	end
end
local function enterUltra()
	s1 = "Transform"
	n3 = math.huge

	local v511 = t6[t2.Transform]

	if v511 then
		local sfxVolume: any = soundService:GetAttribute("SFXVolume")

		v511.Volume = (if typeof(sfxVolume) == "number" then sfxVolume else 1) * 1
		v511.PlaybackSpeed = 1
		v511.TimePosition = 0
		v511:Play()
	end

	v511 = t6[t2.TransformHit]

	if v511 then
		local sfxVolume: any = soundService:GetAttribute("SFXVolume")

		v511.Volume = (if typeof(sfxVolume) == "number" then sfxVolume else 1) * 1
		v511.PlaybackSpeed = 1
		v511.TimePosition = 0
		v511:Play()
	end

	showResult("<font color=\"#ff2a2a\"><b>???</b></font> The Ultra Wheel awakens...", 2.2)

	local v514 = os.clock()

	table.insert(t11, { dur = 1.7, amp = 8, ramp = false, start = v514 })

	if jackpotWheelGlow then
		local glowSize = t9.glowSize
		local v516 = UDim2.fromScale(0.2, 0.2)
		local tweenInfo19 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		tweenService:Create(jackpotWheelGlow, tweenInfo19, { ImageTransparency = 0, Size = glowSize + v516 }):Play()
	end

	local function v518()
		local quad = Enum.EasingStyle.Quad
		local v926 = Enum.EasingDirection.In

		if u128 then
			u128:Cancel()
		end

		local tweenInfo20 = TweenInfo.new(0.45, quad or Enum.EasingStyle.Quad, v926 or Enum.EasingDirection.Out)
		local v928: Tween = tweenService:Create(wheelFXScale, tweenInfo20, { Scale = 0.85 })

		v928:Play()
		u128 = v928
		v928.Completed:Once(function(p92)
			if p92 ~= Enum.PlaybackState.Completed then
				return
			end

			local back = Enum.EasingStyle.Back

			if u128 then
				u128:Cancel()
			end

			local tweenInfo21 = TweenInfo.new(0.28, back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local v1064: Tween = tweenService:Create(wheelFXScale, tweenInfo21, { Scale = 1.12 })

			v1064:Play()
			u128 = v1064
			v1064.Completed:Once(function(p93)
				if p93 == Enum.PlaybackState.Completed then
					if u128 then
						u128:Cancel()
					end

					local tweenInfo22 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					local v1087: Tween = tweenService:Create(wheelFXScale, tweenInfo22, { Scale = 1 })

					v1087:Play()
					u128 = v1087
				end
			end)
		end)

		local v929 = n2
		local v930 = os.clock()
		local v931: (...any) -> ...any = whirlEase
		local n4: number = 900
		local n5: number = 1.15
		u116 = {
			duration = 1.15,
			from = v929,
			start = v930,
			curve = function(p94)
				local v1066 = math.clamp(p94 / n5, 0, 1)
				local v1067 = v931(v1066)

				return n4 * v1067
			end,
			done = function()
				s1 = "Ultra"
				n3 = 0
				fade(t7.Limbo, 1, 0.8)
			end
		}

		local function v934()
			local color35 = Color3.fromRGB(255, 40, 40)

			flash(color35, 0.85, 0.06, 0.7)
			setUltraLook(true)
			popUltraPrizes()
		end

		local v935: number = n1

		task.delay(0.5, function()
			if v935 == n1 and s1 ~= "Closed" then
				local v1069, v1070 = xpcall(v934, debug.traceback)

				if not v1069 then
					local v1071: string = s1
					local text: string = tostring(v1070)

					warn(("[HalloweenWheel] %s failed in phase %s: %s"):format("delayed step", v1071, text))
				end
			end
		end)
	end

	local v519: number = n1

	task.delay(0.45, function()
		if v519 == n1 and s1 ~= "Closed" then
			local v936, v937 = xpcall(v518, debug.traceback)

			if not v936 then
				local v938: string = s1
				local text: string = tostring(v937)

				warn(("[HalloweenWheel] %s failed in phase %s: %s"):format("delayed step", v938, text))
			end
		end
	end)
end
local function onStandardStop(p95)
	local u521: boolean = t1.quickSpin == true

	t1.quickSpin = false

	if u521 then
		fade(t7.SpinLoop, 0.3, 0.12)
	else
		fade(t7.SpinLoop, 0, 0.06, true)
	end

	local v522 = t6[t2.Stop]

	if v522 then
		local sfxVolume: any = soundService:GetAttribute("SFXVolume")
		local typeName: string = typeof(sfxVolume)

		v522.Volume = 1 * (if u521 then 0.6 else 1) * (if typeName == "number" then sfxVolume else 1)
		v522.PlaybackSpeed = 1
		v522.TimePosition = 0
		v522:Play()
	end

	n5 = 1.2
	u120 = os.clock()

	local v525 = os.clock()

	table.insert(t11, {
		dur = 0.25,
		ramp = false,
		start = v525,
		amp = if u521 then 1.5 else 3
	})
	pulsePrize(p95.frame, if p95.special then 1.6 else if u521 then 1.2 else 1.35)

	if p95.special then
		u130 = nil
		fx_SpeedLines.Visible = false
		pcall(fovController.Pop, "HalloweenWheel", 0.45, Enum.EasingStyle.Back)
		t1.setUltraLayout(if t1.current and t1.current.ultraLayout then t1.current.ultraLayout else t1.wantUltraLayout)
		enterUltra()

		return
	end

	s1 = "Result"

	local v526 = if u521 then t1.QUICK_HOLD else if u119 then 1.3 else 2.4

	n3 = os.clock() + v526
	v522 = t1.wonText(p95.label, false)
	showResult(v522, v526)
	t1.coinLanded(false)

	local function v527()
		if s1 ~= "Result" then
			return
		end

		if n4 > 0 then
			u159()

			return
		end

		t1.runOut()
	end

	local v528: number = n1

	task.delay(if u521 then t1.QUICK_GAP else if u119 then 1 else 1.9, function()
		if v528 == n1 and s1 ~= "Closed" then
			local v940, v941 = xpcall(v527, debug.traceback)

			if not v940 then
				local v942: string = s1
				local text: string = tostring(v941)

				warn(("[HalloweenWheel] %s failed in phase %s: %s"):format("delayed step", v942, text))
			end
		end
	end)
end

u159 = function()
	n4 -= 1
	s1 = "Spinning"

	local u530

	if t1.DEMO_MODE then
		local u532: boolean = scriptParent:GetAttribute("DemoForceUltra") == true

		if u532 then
			scriptParent:SetAttribute("DemoForceUltra", nil)
		end

		u530 = pick(v85, if u532 then 1 else 0.6)
	else
		t1.current = table.remove(t1.queue, 1)
		u530 = t1.prizeBySlot(v85, t1.current and t1.current.slot) or pick(v85, 0)
	end

	local u531 = t1.bulk ~= nil and not u530.special

	t1.quickSpin = u531

	if t1.bulk then
		t1.refreshBulkButton()
	end

	fade(t7.Idle, 0, 0.5, true)

	if not u531 or not t7.SpinLoop.sound.IsPlaying then
		local v532 = t6[t2.WoodStart]

		if v532 then
			local sfxVolume: any = soundService:GetAttribute("SFXVolume")

			v532.Volume = (if typeof(sfxVolume) == "number" then sfxVolume else 1) * 0.9
			v532.PlaybackSpeed = 1
			v532.TimePosition = 0
			v532:Play()
		end
	end

	if u128 then
		u128:Cancel()
	end

	local tweenInfo23 = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local v535: Tween = tweenService:Create(wheelFXScale, tweenInfo23, { Scale = 1.04 })

	v535:Play()
	u128 = v535
	v535.Completed:Once(function(p96)
		if p96 == Enum.PlaybackState.Completed then
			local back = Enum.EasingStyle.Back

			if u128 then
				u128:Cancel()
			end

			local tweenInfo24 = TweenInfo.new(0.3, back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local v947: Tween = tweenService:Create(wheelFXScale, tweenInfo24, { Scale = 1 })

			v947:Play()
			u128 = v947
		end
	end)

	local v536 = if u531 then t1.QUICK_ACCEL else if u119 then 1 else 2
	local v537 = if u531 then t1.QUICK_CRUISE else if u119 then 0.4 else 0.8

	local function v538()
		if s1 == "Spinning" then
			fade(t7.SpinLoop, 1, v536 * 0.6)
		end
	end

	local v539: number = n1

	task.delay(v536 * 0.3, function()
		if v539 == n1 and s1 ~= "Closed" then
			local v948, v949 = xpcall(v538, debug.traceback)

			if not v948 then
				local v950: string = s1
				local text: string = tostring(v949)

				warn(("[HalloweenWheel] %s failed in phase %s: %s"):format("delayed step", v950, text))
			end
		end
	end)

	local n3 = (random:NextNumber() * 2 - 1) * 0.4
	local n5 = if u530.special then 7.2 else if u531 then t1.QUICK_DECEL else if u119 then 2.6 + n3 * 0.5 else 5.2 + n3

	n3 = if u530.special then 8 else if u531 then t1.QUICK_TURNS else if u119 then 4 else 6

	local v542 = u530
	local v543 = random:NextNumber()

	u531 = n2 + n3 * 360 + (((v543 - 0.5) * (v86 - 16) - v542.angle) % 360 - n2 % 360) % 360 - n2
	n3 = v536 + v537 + n5
	v542 = n2

	local v544 = os.clock()
	local v545 = spinCurve(u531, v536, v537, n5)
	u116 = {
		from = v542,
		start = v544,
		duration = n3,
		curve = v545,
		done = function()
			onStandardStop(u530)
		end
	}

	if u530.special then
		local function v546()
			local v952 = t6[t2.RedSuspense]

			if v952 then
				local sfxVolume: any = soundService:GetAttribute("SFXVolume")

				v952.Volume = (if typeof(sfxVolume) == "number" then sfxVolume else 1) * 1
				v952.PlaybackSpeed = 1
				v952.TimePosition = 0
				v952:Play()
			end

			startBuild(4, 0.12, 0.15, false)

			local v954 = os.clock()

			table.insert(t11, { dur = 4, amp = 5, ramp = true, start = v954 })
		end

		local v547: number = n1

		task.delay(n3 - 4, function()
			if v547 == n1 and s1 ~= "Closed" then
				local v955, v956 = xpcall(v546, debug.traceback)

				if not v955 then
					local v957: string = s1
					local text: string = tostring(v956)

					warn(("[HalloweenWheel] %s failed in phase %s: %s"):format("delayed step", v957, text))
				end
			end
		end)
	end
end

local function onUltraStop(p97)
	fade(t7.UltraLoop, 0, 0.05, true)
	table.clear(t11)

	local v549 = os.clock()

	table.insert(t11, { dur = 0.8, amp = 18, ramp = false, start = v549 })
	flash(Color3.new(1, 1, 1), 0.9, 0.03, 0.9)
	u130 = nil
	fx_SpeedLines.Visible = false
	tintOut(1.2)

	local quad = Enum.EasingStyle.Quad
	local fovControllerPush = fovController.Push
	local v552 = fovController.GetBase()

	pcall(fovControllerPush, "HalloweenWheel", v552 * 0.06, 0.06, quad)

	local function v553()
		pcall(fovController.Pop, "HalloweenWheel", 0.9, Enum.EasingStyle.Sine)
	end

	local v554: number = n1

	task.delay(0.12, function()
		if v554 == n1 and s1 ~= "Closed" then
			local v959, v960 = xpcall(v553, debug.traceback)

			if not v959 then
				local v961: string = s1
				local text: string = tostring(v960)

				warn(("[HalloweenWheel] %s failed in phase %s: %s"):format("delayed step", v961, text))
			end
		end
	end)

	if u128 then
		u128:Cancel()
	end

	local tweenInfo25 = TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local v556: Tween = tweenService:Create(wheelFXScale, tweenInfo25, { Scale = 1.18 })

	v556:Play()
	u128 = v556
	v556.Completed:Once(function(p98)
		if p98 == Enum.PlaybackState.Completed then
			if u128 then
				u128:Cancel()
			end

			local tweenInfo26 = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local v965: Tween = tweenService:Create(wheelFXScale, tweenInfo26, { Scale = 1 })

			v965:Play()
			u128 = v965
		end
	end)
	n5 = 4
	u120 = os.clock()
	pulsePrize(p97.frame, 1.7)
	s1 = "UltraResult"
	n3 = math.huge

	local v557 = t1.wonText(p97.label, true)

	showResult(v557, 3.6)
	t1.coinLanded(true)

	local v558 = u160
	local v559: number = n1

	task.delay(3.8, function()
		if v559 == n1 and s1 ~= "Closed" then
			local v966, v967 = xpcall(v558, debug.traceback)

			if not v966 then
				local v968: string = s1
				local text: string = tostring(v967)

				warn(("[HalloweenWheel] %s failed in phase %s: %s"):format("delayed step", v968, text))
			end
		end
	end)
end
local function beginUltraSpin()
	s1 = "UltraSpinning"

	local v560 = t6[t2.UltraClick]

	if v560 then
		local sfxVolume: any = soundService:GetAttribute("SFXVolume")

		v560.Volume = (if typeof(sfxVolume) == "number" then sfxVolume else 1) * 1
		v560.PlaybackSpeed = 1
		v560.TimePosition = 0
		v560:Play()
	end

	v560 = t6[t2.UltraRiser]

	if v560 then
		local sfxVolume: any = soundService:GetAttribute("SFXVolume")

		v560.Volume = (if typeof(sfxVolume) == "number" then sfxVolume else 1) * 1
		v560.PlaybackSpeed = 1
		v560.TimePosition = 0
		v560:Play()
	end

	fade(t7.Limbo, 0, 0.3, true)
	fade(t7.UltraLoop, 1, 0.4)

	local v563 = os.clock()

	table.insert(t11, { dur = 7, amp = 9, ramp = true, start = v563 })
	startBuild(7, 0.1, 0.18, true)
	tintIn(0.25)

	local v564 = if t1.DEMO_MODE then pick(u87, 0.25) else t1.prizeBySlot(u87, t1.current and t1.current.ultra) or pick(u87, 0)

	v563 = u88

	local v565 = random:NextNumber()
	local n1 = n2 + 5040 + (((v565 - 0.5) * (v563 - 16) - v564.angle) % 360 - n2 % 360) % 360 - n2

	v563 = n2

	local v567 = os.clock()
	local v568: (...any) -> ...any = ultraEase
	local n3: number = 7
	u116 = {
		duration = 7,
		from = v563,
		start = v567,
		curve = function(p99)
			local v971 = math.clamp(p99 / n3, 0, 1)
			local v972 = v568(v971)

			return n1 * v972
		end,
		done = function()
			onUltraStop(v564)
		end
	}
end

u160 = function()
	s1 = "TransformBack"

	local color36 = Color3.fromRGB(20, 0, 0)

	flash(color36, 0.8, 0.15, 0.6)

	local v571 = n2
	local v572 = os.clock()
	local v573: (...any) -> ...any = whirlEase
	local n5: number = 540
	local n6: number = 0.8
	u116 = {
		duration = 0.8,
		from = v571,
		start = v572,
		curve = function(p100)
			local v974 = math.clamp(p100 / n6, 0, 1)
			local v975 = v573(v974)

			return n5 * v975
		end,
		done = function()
			n3 = 0

			if n4 > 0 then
				s1 = "Result"

				local function v976()
					if s1 == "Result" then
						u159()
					end
				end

				local v977: number = n1

				task.delay(0.9, function()
					if v977 == n1 and s1 ~= "Closed" then
						local v1073, v1074 = xpcall(v976, debug.traceback)

						if not v1073 then
							local v1075: string = s1
							local text: string = tostring(v1074)

							warn(("[HalloweenWheel] %s failed in phase %s: %s"):format("delayed step", v1075, text))
						end
					end
				end)

				return
			end

			t1.runOut()
		end
	}

	local function v576()
		setUltraLook(false)
	end

	local v577: number = n1

	task.delay(0.15, function()
		if v577 == n1 and s1 ~= "Closed" then
			local v978, v979 = xpcall(v576, debug.traceback)

			if not v978 then
				local v980: string = s1
				local text: string = tostring(v979)

				warn(("[HalloweenWheel] %s failed in phase %s: %s"):format("delayed step", v980, text))
			end
		end
	end)
end

function t1.wonText(p101, p102)
	if not t1.DEMO_MODE and t1.current and t1.current.refunded then
		return "That prize couldn't be delivered, so your ticket was refunded."
	end

	if p102 then
		return ("<font color=\"#ff3b3b\"><b>ULTIMATE REWARD:</b></font> %s!"):format(p101)
	end

	return ("You won <b>%s</b>!"):format(p101)
end
function t1.requestSpin(p103)
	if t1.requesting then
		return
	end

	if t1.state and t1.state.enabled == false then
		showResult("The Horseman's Wheel is closed right now.", 2.4)

		return
	end

	if p103 > t1.balance() then
		t1.needTickets(p103)

		return
	end

	local halloweenWheelSpin = t1.Remotes:FindFirstChild("HalloweenWheelSpin")

	if not halloweenWheelSpin or not halloweenWheelSpin:IsA("RemoteFunction") then
		showResult("The wheel isn't ready yet. Try again in a moment.", 2.4)

		return
	end

	t1.requesting = true
	t1.holdCash()

	local v582: number = n1

	task.spawn(function()
		local ok, result = pcall(function()
			return halloweenWheelSpin:InvokeServer(p103)
		end)

		t1.requesting = false

		if v582 == n1 and s1 == "Idle" then
			if not ok or typeof(result) ~= "table" then
				t1.releaseCash()
				showResult("Couldn't reach the wheel. Your tickets are safe.", 2.4)

				return
			end

			if not result.ok then
				t1.releaseCash()

				local resultReason = result.reason

				if resultReason == "NoTickets" then
					t1.needTickets(p103)
				elseif resultReason == "InventoryFull" then
					showResult("Your inventory is full!", 2.4)
				elseif resultReason == "Closed" then
					showResult("The Horseman's Wheel is closed right now.", 2.4)
				elseif resultReason ~= "Busy" then
					showResult("Couldn't spin right now. Your tickets are safe.", 2.4)
				end

				return
			end

			t1.queue = if typeof(result.results) == "table" then result.results else {}
			n4 = #t1.queue

			if n4 == 0 then
				t1.releaseCash()

				return
			end

			local v985 = t6[t2.Ticket]

			if v985 then
				local sfxVolume: any = soundService:GetAttribute("SFXVolume")

				v985.Volume = (if typeof(sfxVolume) == "number" then sfxVolume else 1) * 0.8
				v985.PlaybackSpeed = 1
				v985.TimePosition = 0
				v985:Play()
			end

			u119 = n4 > 1
			u159()

			return
		end

		t1.releaseCash()
	end)
end
local function onSpinClicked(p104)
	if s1 ~= "Idle" then
		if s1 == "Ultra" then
			beginUltraSpin()
		end

		return
	end

	if not t1.DEMO_MODE then
		t1.requestSpin(p104)

		return
	end

	local v584 = t6[t2.Ticket]

	if v584 then
		local sfxVolume: any = soundService:GetAttribute("SFXVolume")

		v584.Volume = (if typeof(sfxVolume) == "number" then sfxVolume else 1) * 0.8
		v584.PlaybackSpeed = 1
		v584.TimePosition = 0
		v584:Play()
	end

	n4 = p104
	u119 = p104 > 1
	u159()
end

spinx1Button.MouseButton1Click:Connect(function()
	if s1 ~= "Idle" then
		if s1 == "Ultra" then
			beginUltraSpin()
		end

		return
	end

	if not t1.DEMO_MODE then
		t1.requestSpin(1)

		return
	end

	local ticket = t2.Ticket
	local v587 = t3.Ticket
	local v588 = t6[ticket]

	if v588 then
		local sfxVolume: any = soundService:GetAttribute("SFXVolume")
		local typeName: string = typeof(sfxVolume)

		v588.Volume = v587 * (if typeName == "number" then sfxVolume else 1)
		v588.PlaybackSpeed = 1
		v588.TimePosition = 0
		v588:Play()
	end

	n4 = 1
	u119 = false
	u159()
end)
spinx3Button.MouseButton1Click:Connect(function()
	if s1 ~= "Idle" then
		if s1 == "Ultra" then
			beginUltraSpin()
		end

		return
	end

	if not t1.DEMO_MODE then
		t1.requestSpin(3)

		return
	end

	local ticket = t2.Ticket
	local v592 = t3.Ticket
	local v593 = t6[ticket]

	if v593 then
		local sfxVolume: any = soundService:GetAttribute("SFXVolume")
		local typeName: string = typeof(sfxVolume)

		v593.Volume = v592 * (if typeName == "number" then sfxVolume else 1)
		v593.PlaybackSpeed = 1
		v593.TimePosition = 0
		v593:Play()
	end

	n4 = 3
	u119 = true
	u159()
end)
t1.BULK_MIN = 10
t1.BULK_BATCH = 5
t1.QUICK_ACCEL = 0.12
t1.QUICK_CRUISE = 0.08
t1.QUICK_DECEL = 0.5
t1.QUICK_TURNS = 1
t1.QUICK_HOLD = 0.7
t1.QUICK_GAP = 0.3
t1.bulk = nil
t1.quickSpin = false

function t1.refreshBulkButton()
	local spinAll = t1.spinAll

	if not spinAll then
		return
	end

	local bulk = t1.bulk
	local u598: boolean = not u114 and not t1.DEMO_MODE

	if u598 then
		u598 = true

		if bulk == nil then
			u598 = t1.balance() > t1.BULK_MIN
		end
	end

	spinAll.Visible = u598
	spinx3Button.Visible = not u114 and t9.x3Visible and not u598
	setText(t1.spinAllLabel, if not bulk then "Spin All" else if bulk.stop then "Stopping..." else "Stop")

	local spinAllPrice = t1.spinAllPrice
	local comma = t1.comma
	local n1

	if bulk then
		local bulkLeft = bulk.left
		local v603 = math.max(n4, 0)

		n1 = bulkLeft + v603
	else
		n1 = t1.balance()
	end

	local v604 = comma(n1)

	setText(spinAllPrice, "x" .. v604)
end
function t1.endBulk()
	if not t1.bulk then
		return
	end

	t1.bulk = nil
	t1.quickSpin = false
	fade(t7.SpinLoop, 0, 0.3, true)
	t1.refreshBulkButton()
end
function t1.requestBulk()
	local bulk = t1.bulk

	if bulk and not t1.requesting then
		local v606 = math.min(bulk.left, t1.BULK_BATCH, t1.balance())
		local halloweenWheelSpin = t1.Remotes:FindFirstChild("HalloweenWheelSpin")

		if v606 < 1 or not halloweenWheelSpin or not halloweenWheelSpin:IsA("RemoteFunction") then
			t1.endBulk()
			s1 = "Idle"

			local function v608()
				if s1 == "Idle" then
					fade(t7.Idle, 1, 2)
				end
			end

			local v609: number = n1

			task.delay(1.2, function()
				if v609 == n1 and s1 ~= "Closed" then
					local v987, v988 = xpcall(v608, debug.traceback)

					if not v987 then
						local v989: string = s1
						local text: string = tostring(v988)

						warn(("[HalloweenWheel] %s failed in phase %s: %s"):format("delayed step", v989, text))
					end
				end
			end)
			t1.releaseCash()

			return
		end

		t1.requesting = true
		t1.holdCash()

		local v610: number = n1

		task.spawn(function()
			local ok, result = pcall(function()
				return halloweenWheelSpin:InvokeServer(v606, true)
			end)

			t1.requesting = false

			if v610 ~= n1 or t1.bulk ~= bulk then
				return
			end

			if ok and typeof(result) == "table" and not result.ok and result.reason == "Busy" and not bulk.stop then
				local requestBulk = t1.requestBulk
				local v994: number = n1

				task.delay(1, function()
					if v994 == n1 and s1 ~= "Closed" then
						local v1077, v1078 = xpcall(requestBulk, debug.traceback)

						if not v1077 then
							local v1079: string = s1
							local text: string = tostring(v1078)

							warn(("[HalloweenWheel] %s failed in phase %s: %s"):format("delayed step", v1079, text))
						end
					end
				end)

				return
			end

			local v995 = if ok and typeof(result) == "table" and result.ok and typeof(result.results) == "table" then result.results else nil

			if v995 and #v995 ~= 0 then
				if not bulk.started then
					bulk.started = true

					local v996 = t6[t2.Ticket]

					if v996 then
						local sfxVolume: any = soundService:GetAttribute("SFXVolume")

						v996.Volume = (if typeof(sfxVolume) == "number" then sfxVolume else 1) * 0.8
						v996.PlaybackSpeed = 1
						v996.TimePosition = 0
						v996:Play()
					end
				end

				bulk.left = math.max(bulk.left - #v995, 0)
				t1.queue = v995
				n4 = #v995
				u119 = false
				u159()

				return
			end

			local v998 = if ok and typeof(result) == "table" then result.reason else nil

			t1.endBulk()
			s1 = "Idle"

			local function v999()
				if s1 == "Idle" then
					fade(t7.Idle, 1, 2)
				end
			end

			local v1000: number = n1

			task.delay(1.2, function()
				if v1000 == n1 and s1 ~= "Closed" then
					local v1081, v1082 = xpcall(v999, debug.traceback)

					if not v1081 then
						local v1083: string = s1
						local text: string = tostring(v1082)

						warn(("[HalloweenWheel] %s failed in phase %s: %s"):format("delayed step", v1083, text))
					end
				end
			end)
			t1.releaseCash()

			if v998 == "InventoryFull" then
				showResult("Your inventory is full!", 2.4)
			elseif v998 == "Closed" then
				showResult("The Horseman's Wheel is closed right now.", 2.4)
			elseif not ok or v998 ~= "NoTickets" then
				showResult("Couldn't spin right now. Your tickets are safe.", 2.4)
			end
		end)

		return
	end
end
function t1.runOut()
	local bulk = t1.bulk

	if bulk and not bulk.stop and bulk.left > 0 and t1.balance() > 0 then
		t1.requestBulk()

		return
	end

	t1.endBulk()
	s1 = "Idle"

	local function v612()
		if s1 == "Idle" then
			fade(t7.Idle, 1, 2)
		end
	end

	local v613: number = n1

	task.delay(1.2, function()
		if v613 == n1 and s1 ~= "Closed" then
			local v1001, v1002 = xpcall(v612, debug.traceback)

			if not v1001 then
				local v1003: string = s1
				local text: string = tostring(v1002)

				warn(("[HalloweenWheel] %s failed in phase %s: %s"):format("delayed step", v1003, text))
			end
		end
	end)
	t1.releaseCash()
end
function t1.onSpinAll()
	local bulk = t1.bulk

	if bulk then
		bulk.stop = true
		t1.refreshBulkButton()

		return
	end

	if s1 ~= "Idle" or t1.requesting or t1.DEMO_MODE then
		return
	end

	if t1.state and t1.state.enabled == false then
		showResult("The Horseman's Wheel is closed right now.", 2.4)

		return
	end

	local v615 = t1.balance()

	if v615 <= t1.BULK_MIN then
		return
	end

	t1.bulk = { stop = false, started = false, left = v615 }
	t1.refreshBulkButton()
	t1.requestBulk()
end

local spinAllButton: Instance = options:FindFirstChild("SpinAllButton")

if spinAllButton and spinAllButton:IsA("GuiButton") then
	t1.spinAll = spinAllButton
	t1.spinAllLabel = spinAllButton:FindFirstChild("TextLabel")

	local price2: Instance = spinAllButton:FindFirstChild("Price")

	t1.spinAllPrice = price2 and price2:FindFirstChild("Price")
	spinAllButton.MouseButton1Click:Connect(function()
		t1.onSpinAll()
	end)
end

function t1.restricted()
	return LocalPlayer:GetAttribute("ArePaidRandomItemsRestricted") ~= false
end
function t1.balance()
	return tonumber(LocalPlayer:GetAttribute("WheelTickets")) or 0
end
function t1.comma(p105)
	local floored = math.floor(p105)
	local text = tostring(floored)

	repeat
		local v619, v620 = text:gsub("^(-?%d+)(%d%d%d)", "%1,%2")

		text = v619
	until v620 == 0

	return text
end
function t1.pct(p106)
	if p106 >= 10 or p106 == math.floor(p106) then
		local stringFormat = string.format
		local floored = math.floor(p106 + 0.5)

		return stringFormat("%d%%", floored)
	end

	return string.format("%.2f", p106):gsub("0+$", ""):gsub("%.$", "") .. "%"
end
function t1.pulseShop()
	if not buyTickets or not buyTickets.Visible then
		return
	end

	local v624 = buyTickets
	local wheelFXScale7 = v624:FindFirstChild("WheelFXScale")

	if not wheelFXScale7 then
		local wheelFXScale: UIScale = Instance.new("UIScale")

		wheelFXScale.Name = "WheelFXScale"
		wheelFXScale.Parent = v624
		wheelFXScale7 = wheelFXScale
	end

	local tweenInfo27 = TweenInfo.new(0.12, Enum.EasingStyle.Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	v624 = tweenService:Create(wheelFXScale7, tweenInfo27, { Scale = 1.06 })
	v624:Play()
	v624.Completed:Once(function()
		local tweenInfo28 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		tweenService:Create(wheelFXScale7, tweenInfo28, { Scale = 1 }):Play()
	end)
end
function t1.buy(p107)
	if t1.restricted() then
		return
	end

	local bindables: Instance = replicatedStorage:FindFirstChild("Bindables")
	local showPurchaseModal: Instance = bindables and bindables:FindFirstChild("ShowPurchaseModal")

	if showPurchaseModal and showPurchaseModal:IsA("BindableEvent") then
		showPurchaseModal:Fire({
			ProductId = p107.productId,
			Name = p107.displayName,
			RobuxPrice = if p107.robuxPrice > 0 then p107.robuxPrice else nil
		})

		return
	end

	local currencyBuyRequest = t1.Remotes:FindFirstChild("CurrencyBuyRequest")

	if currencyBuyRequest and currencyBuyRequest:IsA("RemoteEvent") then
		currencyBuyRequest:FireServer(p107.productId)
	end
end
function t1.needTickets(p108)
	local v633 = ("You need <b>%d</b> ticket%s to spin. You have %d."):format(p108, if p108 == 1 then "" else "s", t1.balance())

	showResult(v633, 2.4)
	t1.pulseShop()

	if not t1.restricted() then
		t1.buy(if p108 <= 1 then t1.Tickets.Products.Tickets1 else t1.Tickets.Products.Tickets3)
	end
end
function t1.returnMenu()
	local lentMenu = t1.lentMenu

	t1.lentMenu = nil

	if lentMenu and t1.menuHome and t1.menuHome.Parent then
		lentMenu.Parent = t1.menuHome
	end
end
function t1.gift(p109)
	if t1.restricted() then
		return
	end

	local hud: Instance = playerGui:FindFirstChild("HUD")
	local giftingMenu: Instance = hud and hud:FindFirstChild("GiftingMenu")

	if t1.GiftPicker.Open({
		productId = p109.productId,
		displayName = p109.displayName,
		onClose = t1.returnMenu
	}) and hud and giftingMenu then
		local v638 = t1.giftHost

		if not v638 then
			local halloweenWheelGiftHost: ScreenGui = Instance.new("ScreenGui")

			halloweenWheelGiftHost.Name = "HalloweenWheelGiftHost"
			halloweenWheelGiftHost.ResetOnSpawn = false
			halloweenWheelGiftHost.IgnoreGuiInset = hud.IgnoreGuiInset
			halloweenWheelGiftHost.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			halloweenWheelGiftHost.DisplayOrder = scriptParent.DisplayOrder + 2
			halloweenWheelGiftHost.Parent = playerGui
			t1.giftHost = halloweenWheelGiftHost
			v638 = halloweenWheelGiftHost
		end

		t1.lentMenu = giftingMenu
		t1.menuHome = hud
		giftingMenu.Parent = v638

		return
	end
end

t1.WALLET = {
	{
		key = "Coins",
		attr = "Cash",
		src = "Currency",
		label = "Cash",
		prefix = "$"
	},
	{
		key = "Tokens",
		attr = "TradeTokens",
		src = "TradeTokens",
		label = "Tokens"
	},
	{
		key = "Tickets",
		attr = "WheelTickets",
		src = "TradeTokens",
		label = "Tokens",
		ticket = true
	}
}

local v169 = ColorSequence.new
local color37 = Color3.fromRGB(255, 70, 70)

t1.TICKET_TEXT = v169(color37, Color3.fromRGB(255, 25, 25))
t1.WALLET_GAP = 0.16

function t1.buildCurrencies()
	if t1.wallet then
		return
	end

	local hud: Instance = playerGui:FindFirstChild("HUD")

	if not hud or not hud:IsA("ScreenGui") then
		return
	end

	local currency: Instance = hud:FindFirstChild("Currency")
	local tradeTokens: Instance = hud:FindFirstChild("TradeTokens")

	if not currency or not currency:IsA("GuiObject") or not tradeTokens or not tradeTokens:IsA("GuiObject") then
		return
	end

	local halloweenWheelWallet: ScreenGui = Instance.new("ScreenGui")

	halloweenWheelWallet.Name = "HalloweenWheelWallet"
	halloweenWheelWallet.ResetOnSpawn = false
	halloweenWheelWallet.Enabled = false
	halloweenWheelWallet.IgnoreGuiInset = hud.IgnoreGuiInset
	halloweenWheelWallet.ScreenInsets = hud.ScreenInsets
	halloweenWheelWallet.ZIndexBehavior = hud.ZIndexBehavior
	halloweenWheelWallet.DisplayOrder = scriptParent.DisplayOrder + 1

	local stack: Frame = Instance.new("Frame")

	stack.Name = "Stack"
	stack.BackgroundTransparency = 1
	stack.AnchorPoint = currency.AnchorPoint
	stack.Position = currency.Position
	stack.Size = currency.Size

	local uiAspectRatioConstraint: Instance = currency:FindFirstChildOfClass("UIAspectRatioConstraint")

	if uiAspectRatioConstraint then
		local clone: Instance = uiAspectRatioConstraint:Clone()

		clone.Parent = stack
	end

	stack.Parent = halloweenWheelWallet

	local t22: {[any]: any} = {}

	for i, v in ipairs(t1.WALLET) do
		local vsrc: Instance = hud:FindFirstChild(v.src)

		if vsrc and vsrc:IsA("GuiObject") then
			local clone: Instance = vsrc:Clone()

			for iterFirst, iterSecond in clone:GetDescendants() do
				if iterSecond:IsA("LuaSourceContainer") then
					iterSecond:Destroy()
				end
			end

			clone.Name = v.key
			clone.Visible = true
			clone.AnchorPoint = Vector2.new(0.5, 0.5)
			clone.Size = UDim2.fromScale(1, 1)
			clone.Position = UDim2.fromScale(0.5, 0.5 + (i - 1) * (1 + t1.WALLET_GAP))

			if v.ticket then
				local icon: Instance = clone:FindFirstChild("Icon")

				if icon and icon:IsA("ImageLabel") then
					icon.Image = t1.Tickets.ICON_ONE
					icon.AnchorPoint = Vector2.new(0.5, 0.5)
					icon.Position = UDim2.fromScale(0.1, 0.45)
					icon.Size = UDim2.fromScale(0.3, 1.7)
				end

				local vlabel: Instance = clone:FindFirstChild(v.label)
				local uiGradient: Instance = vlabel and vlabel:FindFirstChildOfClass("UIGradient")

				if uiGradient then
					uiGradient.Color = t1.TICKET_TEXT
				elseif vlabel and vlabel:IsA("TextLabel") then
					vlabel.TextColor3 = t1.TICKET_TEXT.Keypoints[1].Value
				end
			end

			local more: Instance = clone:FindFirstChild("More")

			if more and more:IsA("GuiButton") then
				if v.ticket then
					more.MouseButton1Click:Connect(function()
						t1.pulseShop()
					end)
				else
					more:Destroy()
				end
			end

			clone.Parent = stack

			local vKey = v.key
			local vlabel: Instance = clone:FindFirstChild(v.label)

			t22[vKey] = { last = nil, pill = clone, label = vlabel, def = v }
		end
	end

	halloweenWheelWallet.Parent = playerGui
	t1.walletGui = halloweenWheelWallet
	t1.wallet = t22
end
function t1.refreshWallet(p110)
	local wallet = t1.wallet

	if not wallet then
		return
	end

	for iterFirst, iterSecond in wallet do
		local v664 = if iterSecond.def.attr == "Cash" and t1.cashShown ~= nil then t1.cashShown else tonumber(LocalPlayer:GetAttribute(iterSecond.def.attr)) or 0
		local label = iterSecond.label
		local v666 = iterSecond.def.prefix or ""
		local v667 = t1.comma(v664)

		setText(label, v666 .. v667)

		if p110 and iterSecond.last ~= nil and v664 ~= iterSecond.last then
			local pill = iterSecond.pill
			local wheelFXScale8 = pill:FindFirstChild("WheelFXScale")

			if not wheelFXScale8 then
				local wheelFXScale: UIScale = Instance.new("UIScale")

				wheelFXScale.Name = "WheelFXScale"
				wheelFXScale.Parent = pill
				wheelFXScale8 = wheelFXScale
			end

			local tweenInfo29 = TweenInfo.new(0.12, Enum.EasingStyle.Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local v672: Tween = tweenService:Create(wheelFXScale8, tweenInfo29, { Scale = 1.08 })

			v672:Play()
			v672.Completed:Once(function()
				local tweenInfo30 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

				tweenService:Create(wheelFXScale8, tweenInfo30, { Scale = 1 }):Play()
			end)
		end

		iterSecond.last = v664

		if iterSecond.def.ticket then
			local more = iterSecond.pill:FindFirstChild("More")

			if more and more:IsA("GuiObject") then
				more.Visible = not t1.restricted()
			end
		end
	end
end
function t1.refreshTickets(p111)
	t1.refreshWallet(p111)

	local frame: Instance = buyTickets and buyTickets:FindFirstChild("Frame")

	if frame and frame:IsA("GuiObject") then
		frame.Visible = not t1.restricted()
	end

	t1.refreshBigPack()

	if t1.refreshBulkButton then
		t1.refreshBulkButton()
	end
end

t1.DEV_PLACE_ID = 118700671270994

function t1.refreshBigPack()
	local frame: Instance = buyTickets and buyTickets:FindFirstChild("Frame")
	local ticketBuy_100: Instance = frame and frame:FindFirstChild("TicketBuy_100")

	if not buyTickets or not frame or not frame:IsA("GuiObject") or not ticketBuy_100 or not ticketBuy_100:IsA("GuiObject") then
		return
	end

	local tickets100 = t1.Tickets.Products.Tickets100
	local u679 = true

	if game.PlaceId ~= t1.DEV_PLACE_ID then
		u679 = false

		if tickets100 ~= nil then
			u679 = false

			if t1.bigPackForSale == true then
				u679 = t1.Tickets.MeetsSpendGate(LocalPlayer, tickets100.productId)
			end
		end
	end

	if u679 and not t1.bigPackForSale then
		local textLabel2: Instance = ticketBuy_100:FindFirstChild("TextLabel")

		setText(textLabel2, "100 Tickets")

		local priceButton: Instance = ticketBuy_100:FindFirstChild("PriceButton")
		local textLabel: Instance = priceButton and priceButton:FindFirstChild("TextLabel")

		setText(textLabel, if tickets100 then "Off sale" else "Soon")
	end

	if not t1.packBase then
		t1.packBase = {
			listPos = frame.Position,
			listSize = frame.Size,
			panelPos = buyTickets.Position
		}
	end

	local packBase = t1.packBase

	ticketBuy_100.Visible = u679

	local uiListLayout: Instance = frame:FindFirstChildOfClass("UIListLayout")
	local v685 = if uiListLayout then uiListLayout.Padding.Scale else 0
	local n1 = if u679 then packBase.listSize.Y.Scale * ((1 - 2 * v685) / 3 / ((1 - 3 * v685) / 4) - 1) else 0
	local packBaseListSize = packBase.listSize
	local v688 = UDim2.fromScale(0, n1)

	frame.Size = packBaseListSize + v688

	local packBaseListPos = packBase.listPos

	v688 = UDim2.fromScale(0, n1)
	frame.Position = packBaseListPos + v688

	local packBasePanelPos = packBase.panelPos
	local v691 = UDim2.fromScale(0, n1 * buyTickets.Size.Y.Scale)

	buyTickets.Position = packBasePanelPos - v691
end
function t1.checkBigPackSale()
	local tickets100 = t1.Tickets.Products.Tickets100

	if tickets100 and not t1.bigPackForSale and not t1.bigPackChecking then
		t1.bigPackChecking = true
		task.spawn(function()
			local ok, result = pcall(function()
				return t1.Market:GetProductInfo(tickets100.productId, Enum.InfoType.Product)
			end)

			t1.bigPackChecking = false

			if ok and typeof(result) == "table" and result.IsForSale == true then
				t1.bigPackForSale = true

				local v1009: Instance = buyTickets

				if v1009 then
					v1009 = buyTickets:FindFirstChild("Frame")
				end

				local ticketBuy_100: Instance = v1009 and v1009:FindFirstChild("TicketBuy_100")

				v1009 = ticketBuy_100

				if v1009 then
					v1009 = ticketBuy_100:FindFirstChild("PriceButton")
				end

				local numberValue4: number? = tonumber(result.PriceInRobux)

				if numberValue4 then
					local textLabel: Instance = v1009 and v1009:FindFirstChild("TextLabel")
					local robux = t1.ROBUX
					local v1014 = t1.comma(numberValue4)

					setText(textLabel, robux .. " " .. v1014)
				end

				t1.refreshBigPack()

				return
			end
		end)

		return
	end
end

LocalPlayer:GetAttributeChangedSignal("WheelTickets"):Connect(function()
	t1.refreshTickets(true)
end)
LocalPlayer:GetAttributeChangedSignal("ArePaidRandomItemsRestricted"):Connect(function()
	t1.refreshTickets()
end)
LocalPlayer:GetAttributeChangedSignal("Cash"):Connect(function()
	t1.refreshWallet(true)
end)
LocalPlayer:GetAttributeChangedSignal("TradeTokens"):Connect(function()
	t1.refreshWallet(true)
end)
LocalPlayer:GetAttributeChangedSignal("RobuxSpent"):Connect(function()
	t1.refreshTickets()
end)
t1.COIN_BIG = 5000
t1.COIN_TICK = 1.2
t1.COIN_TICK_BIG = 3.2
t1.COIN_PITCH_MIN = 0.9
t1.COIN_PITCH_MAX = 1.05
t1.cashShown = nil
t1.cashTarget = nil
t1.cashTickId = 0
t1.cashReleasing = false

function t1.cashNow()
	return tonumber(LocalPlayer:GetAttribute("Cash")) or 0
end
function t1.paintCash()
	local v693 = t1.wallet and t1.wallet.Coins

	if not v693 then
		return
	end

	local v694 = t1.cashShown or t1.cashNow()
	local label = v693.label
	local v696 = v693.def.prefix or ""
	local v697 = t1.comma(v694)

	setText(label, v696 .. v697)
	v693.last = v694
end
function t1.holdCash()
	if t1.cashShown == nil then
		t1.cashShown = t1.cashNow()
	end

	t1.cashReleasing = false
end
function t1.releaseCash()
	if t1.cashShown == nil then
		return
	end

	if t1.cashTarget == nil then
		t1.cashShown = nil
		t1.cashReleasing = false
		t1.paintCash()

		return
	end

	t1.cashReleasing = true
end
function t1.dropCash()
	local v698: {[any]: any} = t1

	v698.cashTickId = v698.cashTickId + 1
	t1.cashShown = nil
	t1.cashTarget = nil
	t1.cashReleasing = false
	t1.paintCash()
end
function t1.floatCoins(parent, p113, p114)
	local cash = parent:FindFirstChild("Cash")

	if not cash or not cash:IsA("TextLabel") then
		return
	end

	local clone = cash:Clone()

	clone.Name = "CoinFloat"
	clone.Text = "+" .. t1.comma(p113)
	clone.AnchorPoint = Vector2.new(0, 1)
	clone.Position = UDim2.fromScale(cash.Position.X.Scale, 0.1)
	clone.Size = UDim2.fromScale(cash.Size.X.Scale, 0.8)
	clone.TextXAlignment = Enum.TextXAlignment.Left
	clone.Parent = parent

	local n1 = p114 + 0.4
	local clonePosition = clone.Position
	local v706 = UDim2.fromScale(0, 0.9)
	local tweenInfo31 = TweenInfo.new(n1, Enum.EasingStyle.Quad or Enum.EasingStyle.Quad, Enum.EasingDirection.In or Enum.EasingDirection.Out)

	tweenService:Create(clone, tweenInfo31, { TextTransparency = 1, Position = clonePosition - v706 }):Play()

	local uiStroke = clone:FindFirstChildOfClass("UIStroke")

	if uiStroke then
		local tweenInfo32 = TweenInfo.new(n1, Enum.EasingStyle.Quad or Enum.EasingStyle.Quad, Enum.EasingDirection.In or Enum.EasingDirection.Out)

		tweenService:Create(uiStroke, tweenInfo32, { Transparency = 1 }):Play()
	end

	task.delay(n1 + 0.05, function()
		clone:Destroy()
	end)
end
function t1.countCash(p115)
	if t1.cashShown == nil or p115 <= 0 then
		return
	end

	local u711: boolean = p115 >= t1.COIN_BIG
	local v712 = t2.Coins
	local n1: number = 0.6

	if t1.bulk then
		v712 = t2.CoinsQuick
		n1 = 0.6
	elseif u711 then
		v712 = t2.CoinsBig
		n1 = 0.6
	end

	local coin_pitch_min = t1.COIN_PITCH_MIN
	local v715 = random:NextNumber()
	local n2 = coin_pitch_min + v715 * (t1.COIN_PITCH_MAX - t1.COIN_PITCH_MIN)
	local v717 = t6[v712]

	if v717 then
		local sfxVolume: any = soundService:GetAttribute("SFXVolume")
		local typeName: string = typeof(sfxVolume)

		v717.Volume = n1 * (if typeName == "number" then sfxVolume else 1)
		v717.PlaybackSpeed = n2 or 1
		v717.TimePosition = 0
		v717:Play()
	end

	local cashShown = t1.cashShown
	local n3 = (t1.cashTarget or cashShown) + p115
	local v722 = if u711 then t1.COIN_TICK_BIG else t1.COIN_TICK
	local v723: {[any]: any} = t1

	v723.cashTickId = v723.cashTickId + 1

	local cashTickId = t1.cashTickId

	t1.cashTarget = n3
	n2 = t1.wallet and t1.wallet.Coins

	if n2 then
		local pill = n2.pill
		local wheelFXScale9 = pill:FindFirstChild("WheelFXScale")

		if not wheelFXScale9 then
			local wheelFXScale: UIScale = Instance.new("UIScale")

			wheelFXScale.Name = "WheelFXScale"
			wheelFXScale.Parent = pill
			wheelFXScale9 = wheelFXScale
		end

		local tweenInfo33 = TweenInfo.new(0.15, Enum.EasingStyle.Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local v729: Tween = tweenService:Create(wheelFXScale9, tweenInfo33, {
			Scale = if u711 then 1.18 else 1.12
		})

		v729:Play()
		v729.Completed:Once(function()
			local tweenInfo34 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

			tweenService:Create(wheelFXScale9, tweenInfo34, { Scale = 1 }):Play()
		end)
		t1.floatCoins(n2.pill, p115, v722)
	end

	local v730 = os.clock()

	task.spawn(function()
		while cashTickId == t1.cashTickId do
			local v1016 = os.clock()
			local v1017 = math.min((v1016 - v730) / v722, 1)

			t1.cashShown = math.floor(cashShown + (n3 - cashShown) * (1 - (1 - v1017) ^ 2) + 0.5)
			t1.paintCash()

			if v1017 >= 1 then
				t1.cashTarget = nil

				if not t1.cashReleasing then
					break
				end

				t1.releaseCash()

				return
			end

			task.wait()
		end
	end)
end
function t1.coinLanded(p116)
	local current = t1.current

	if not t1.DEMO_MODE and current and not current.refunded then
		local v733 = t1.state and (if p116 then t1.state.ultra else t1.state.standard)

		if typeof(v733) == "table" then
			local v734 = if p116 then current.ultra else current.slot

			for iterFirst, iterSecond in v733 do
				if v734 == iterSecond.slot and iterSecond.kind == "Coins" and typeof(iterSecond.amount) == "number" then
					t1.countCash(iterSecond.amount)

					return
				end
			end

			return
		end

		return
	end
end

t1.ODDS_LIST_H = 1.42
t1.ODDS_MIN_ROWS = 8
t1.ODDS_ROW_GAP = 0.01
t1.ODDS_ICON = 1.1
t1.ODDS_TEXT = 0.62
t1.ODDS_WEIGHT = Enum.FontWeight.Bold

function t1.unbutton(p117, name)
	local frame2: Frame = Instance.new("Frame")

	frame2.Name = name
	frame2.AnchorPoint = p117.AnchorPoint
	frame2.Position = p117.Position
	frame2.Size = p117.Size
	frame2.BackgroundColor3 = p117.BackgroundColor3
	frame2.BackgroundTransparency = p117.BackgroundTransparency
	frame2.BorderSizePixel = 0

	for iterFirst, iterSecond in p117:GetChildren() do
		iterSecond.Parent = frame2
	end

	p117:Destroy()

	return frame2
end
function t1.buildOdds()
	if not not t1.odds or not buyTickets then
		return
	end

	local clone: Instance = buyTickets:Clone()

	for iterFirst, iterSecond in clone:GetDescendants() do
		if iterSecond:IsA("LuaSourceContainer") then
			iterSecond:Destroy()
		end
	end

	local oddsButton: Instance = buyTickets:FindFirstChild("OddsButton")

	if oddsButton and oddsButton:IsA("GuiObject") then
		oddsButton.Visible = false
	end

	local oddsButton2: Instance = clone:FindFirstChild("OddsButton")

	if oddsButton2 then
		oddsButton2:Destroy()
	end

	clone.Name = "OddsPanel"

	local v747 = buyTickets.Position
	local buyTicketsAnchorPoint = buyTickets.AnchorPoint

	clone.AnchorPoint = Vector2.new(1 - buyTicketsAnchorPoint.X, buyTicketsAnchorPoint.Y)
	clone.Position = UDim2.new(1 - v747.X.Scale, -v747.X.Offset, v747.Y.Scale, v747.Y.Offset)
	clone.Visible = true

	local frame3: Instance = clone:FindFirstChild("Frame")

	v747 = frame3

	if v747 then
		v747 = frame3:FindFirstChild("TicketBuy_1")
	end

	if not frame3 or not v747 or not v747:IsA("GuiButton") then
		clone:Destroy()

		return
	end

	local clone2 = v747:Clone()

	for iterFirst2, iterSecond2 in frame3:GetChildren() do
		if iterSecond2:IsA("GuiButton") then
			iterSecond2:Destroy()
		end
	end

	local giftButton = clone2:FindFirstChild("GiftButton")

	if giftButton then
		giftButton:Destroy()
	end

	local parent = t1.unbutton(clone2, "OddsRow")
	v747 = {}
	local priceButton = parent:FindFirstChild("PriceButton")

	if priceButton and priceButton:IsA("GuiObject") then
		local v756 = t1.unbutton(priceButton, "Pill")

		v756.AnchorPoint = Vector2.new(1, 0.5)
		v756.Position = UDim2.fromScale(0.97, 0.5)
		v756.Size = UDim2.fromScale(0.22, 0.74)
		v756.Parent = parent

		for iterFirst3, iterSecond3 in v756:GetDescendants() do
			if iterSecond3:IsA("TextLabel") then
				iterSecond3.FontFace = Font.new(iterSecond3.FontFace.Family, t1.ODDS_WEIGHT, iterSecond3.FontFace.Style)
			end
		end

		local uiGradient2 = v756:FindFirstChildOfClass("UIGradient")
		local textLabel3 = v756:FindFirstChild("TextLabel")

		v756 = textLabel3

		if v756 then
			v756 = textLabel3:FindFirstChild("TextLabel")
		end

		local uiStroke = v756 and v756:FindFirstChildOfClass("UIStroke")

		v747.grad = uiGradient2 and uiGradient2.Color
		v747.shadow = if textLabel3 and textLabel3:IsA("TextLabel") then textLabel3.TextColor3 else nil
		v747.stroke = uiStroke and uiStroke.Color
	end

	local icon = parent:FindFirstChild("Icon")

	if icon and icon:IsA("ImageLabel") then
		icon.AnchorPoint = Vector2.new(0.5, 0.5)
		icon.Position = UDim2.fromScale(0.08, 0.5)
		icon.Size = UDim2.fromScale(0.3, t1.ODDS_ICON)
		icon.ScaleType = Enum.ScaleType.Fit

		local uiAspectRatioConstraint: UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

		uiAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
		uiAspectRatioConstraint.Parent = icon
	end

	local textLabel4 = parent:FindFirstChild("TextLabel")

	if textLabel4 and textLabel4:IsA("TextLabel") then
		textLabel4.AnchorPoint = Vector2.new(0, 0.5)
		textLabel4.Position = UDim2.fromScale(0.17, 0.5)
		textLabel4.Size = UDim2.fromScale(0.56, t1.ODDS_TEXT)
		textLabel4.TextXAlignment = Enum.TextXAlignment.Left
		textLabel4.FontFace = Font.new(textLabel4.FontFace.Family, t1.ODDS_WEIGHT, textLabel4.FontFace.Style)
	end

	local n1 = frame3.Position.Y.Scale - frame3.AnchorPoint.Y * frame3.Size.Y.Scale

	frame3.Size = UDim2.new(frame3.Size.X.Scale, frame3.Size.X.Offset, t1.ODDS_LIST_H, 0)
	frame3.Position = UDim2.new(frame3.Position.X.Scale, frame3.Position.X.Offset, n1 + frame3.AnchorPoint.Y * t1.ODDS_LIST_H, 0)

	local uiListLayout: Instance = frame3:FindFirstChildOfClass("UIListLayout")

	if uiListLayout then
		uiListLayout.VerticalFlex = Enum.UIFlexAlignment.None
		uiListLayout.Padding = UDim.new(t1.ODDS_ROW_GAP, 0)
	end

	t1.odds = { panel = clone, list = frame3, template = parent, colours = v747 }
	clone.Parent = scriptParentFrame
end

t1.PILL_HUE = { Legendary = 0.1 }

function t1.tintPill(p119, p120)
	local v769 = t1.odds and t1.odds.colours

	if not v769 then
		return
	end

	local v770 = t1.PILL_HUE[p120]

	local function tint(p121)
		if v770 then
			local v1019, v1020, v1021 = p121:ToHSV()

			return Color3.fromHSV(v770, v1020, v1021)
		end

		local ok, result = pcall(t1.UIFramework.applyRarityColor, p121, p120)

		if ok and typeof(result) == "Color3" then
			return result
		end

		return p121
	end

	local uiGradient3 = p119:FindFirstChildOfClass("UIGradient")

	if uiGradient3 and v769.grad then
		local t23: {[any]: any} = {}

		for iterFirst, iterSecond in v769.grad.Keypoints, nil, nil do
			table.insert(t23, ColorSequenceKeypoint.new(iterSecond.Time, tint(iterSecond.Value)))
		end

		uiGradient3.Color = ColorSequence.new(t23)
	end

	local textLabel5 = p119:FindFirstChild("TextLabel")

	if textLabel5 and textLabel5:IsA("TextLabel") and v769.shadow then
		local shadow = v769.shadow
		local color38

		if v770 then
			local v779, v780, v781 = shadow:ToHSV()

			color38 = Color3.fromHSV(v770, v780, v781)
		else
			local ok, result = pcall(t1.UIFramework.applyRarityColor, shadow, p120)

			color38 = if ok and typeof(result) == "Color3" then result else shadow
		end

		textLabel5.TextColor3 = color38
	end

	local textLabel = textLabel5 and textLabel5:FindFirstChild("TextLabel")
	local v785 = textLabel

	if v785 then
		v785 = textLabel:FindFirstChildOfClass("UIStroke")
	end

	if v785 and v769.stroke then
		local stroke = v769.stroke
		local color39

		if v770 then
			local v788, v789, v790 = stroke:ToHSV()

			color39 = Color3.fromHSV(v770, v789, v790)
		else
			local ok, result = pcall(t1.UIFramework.applyRarityColor, stroke, p120)

			color39 = if ok and typeof(result) == "Color3" then result else stroke
		end

		v785.Color = color39
	end
end
function t1.oddsEntries(p122, p123)
	local t24: {[any]: any} = {}
	local t25: {[any]: any} = {}
	local t26: {[any]: any} = {}

	for iterFirst, iterSecond in if typeof(p122) == "table" then p122 else {}, nil, nil do
		local text: string = tostring(iterSecond.kind)
		local text2: string = tostring(iterSecond.name)
		local s1: string = text .. ":" .. text2
		local t27 = t24[s1]

		if not t27 then
			t27 = {
				odds = 0,
				name = iterSecond.name,
				icon = iterSecond.icon,
				kind = iterSecond.kind,
				slot = iterSecond.slot,
				rarity = iterSecond.rarity,
				pill = iterSecond.pill,
				collectible = iterSecond.collectible,
				remaining = iterSecond.remaining,
				maxSupply = iterSecond.maxSupply,
				soldOut = iterSecond.soldOut
			}
			t24[s1] = t27
			table.insert(t25, t27)
			t26[iterSecond.name] = (t26[iterSecond.name] or 0) + 1
		end

		local odds = t27.odds
		local numberValue5: number? = tonumber(iterSecond.odds)

		t27.odds = odds + (numberValue5 or 0) * p123
	end

	local t28: {[any]: any} = {}

	for key, value in t25 do
		value.base = value.name

		local name = value.name
		local v810 = t28[value.name] or math.huge
		local numberValue6: number? = tonumber(value.slot)

		t28[name] = math.min(v810, numberValue6 or 0)
	end

	for key2, value2 in t25 do
		if (t26[value2.name] or 0) > 1 and (value2.kind == "Knife" or value2.kind == "Revolver") then
			value2.name = value2.name .. (if value2.kind == "Knife" then " Knife" else " Gun")
		end
	end

	local t29: {[any]: any} = { Knife = 0, Revolver = 1 }

	table.sort(t25, function(p124, p125)
		if p124.odds ~= p125.odds then
			return p124.odds > p125.odds
		end

		local v1026 = t28[p124.base]
		local v1027 = t28[p125.base]

		if v1026 ~= v1027 then
			return v1026 < v1027
		end

		local v1028 = t29[p124.kind] or 2
		local v1029 = t29[p125.kind] or 2

		if v1028 ~= v1029 then
			return v1028 < v1029
		end

		local numberValue7: number? = tonumber(p124.slot)
		local numberValue8: number? = tonumber(p125.slot)

		return (numberValue7 or 0) < (numberValue8 or 0)
	end)

	return t25
end
function t1.refreshOdds()
	local odds = t1.odds
	local state = t1.state

	if odds and state then
		local header = odds.panel:FindFirstChild("Header")
		local textLabel = header and header:FindFirstChild("TextLabel")

		setText(textLabel, "Wheel Odds")

		for iterFirst, iterSecond in odds.list:GetChildren() do
			if iterSecond:IsA("GuiObject") then
				iterSecond:Destroy()
			end
		end

		t1.cycleOdds = nil

		local t30: {[any]: any} = {}
		local n1 = 0

		for iterFirst2, iterSecond2 in t1.oddsEntries(state.standard, 1) do
			if iterSecond2.kind == "Ultra" then
				n1 += iterSecond2.odds
			else
				table.insert(t30, iterSecond2)
			end
		end

		local t31

		if n1 > 0 then
			t31 = t1.oddsEntries(state.ultra, n1 / 100)
		else
			t31 = {}
		end

		local v826 = math.max(#t30 + #t31, t1.ODDS_MIN_ROWS)
		local n2 = (1 - (v826 - 1) * t1.ODDS_ROW_GAP) / v826
		local n3: number = 0

		v826 = function()
			n3 += 1

			local clone = odds.template:Clone()

			clone.Name = "Odds_" .. n3
			clone.LayoutOrder = n3
			clone.Size = UDim2.fromScale(1, n2)

			return clone
		end

		local function addPrize(p126, _)
			n3 += 1

			local clone = odds.template:Clone()

			clone.Name = "Odds_" .. n3
			clone.LayoutOrder = n3
			clone.Size = UDim2.fromScale(1, n2)

			local icon = clone:FindFirstChild("Icon")

			if icon and icon:IsA("ImageLabel") then
				icon.Image = p126.icon or ""
			end

			local v1037 = p126.name
			local t32: {[any]: any} = {}

			if p126.collectible then
				if p126.soldOut then
					table.insert(t32, "SOLD OUT")
				elseif typeof(p126.remaining) == "number" and typeof(p126.maxSupply) == "number" then
					local v1039 = t1.comma(p126.remaining)

					table.insert(t32, ("%s/%s left"):format(v1039, t1.comma(p126.maxSupply)))
				end
			end

			if #t32 > 0 then
				local v1040 = table.concat(t32, ", ")

				v1037 = v1037 .. " (" .. v1040 .. ")"
			end

			local textLabel6 = clone:FindFirstChild("TextLabel")

			setText(textLabel6, v1037)

			local pill = clone:FindFirstChild("Pill")

			if pill then
				local textLabel7 = pill:FindFirstChild("TextLabel")

				setText(textLabel7, t1.pct(p126.odds))

				local tintPill = t1.tintPill
				local v1045 = if typeof(p126.pill) == "string" then p126.pill else if typeof(p126.rarity) == "string" then p126.rarity else "Common"

				tintPill(pill, v1045)
			end

			clone.Parent = odds.list
		end

		for key, value in t30 do
			addPrize(value, false)
		end

		for key2, value2 in t31 do
			addPrize(value2, true)
		end

		return
	end
end
function t1.wireShop()
	if not not t1.shopWired or not buyTickets then
		return
	end

	t1.shopWired = true

	local frame4: Instance = buyTickets:FindFirstChild("Frame")

	for iterFirst, iterSecond in t1.Tickets.Products, nil, nil do
		local v837: Instance = frame4 and frame4:FindFirstChild("TicketBuy_" .. iterSecond.amount)

		if v837 and v837:IsA("GuiButton") then
			local icon: Instance = v837:FindFirstChild("Icon")

			if icon and icon:IsA("ImageLabel") then
				icon.Image = iterSecond.icon
			end

			local textLabel8: Instance = v837:FindFirstChild("TextLabel")

			setText(textLabel8, if iterSecond.amount == 1 then "1 Ticket" else iterSecond.amount .. " Tickets")

			local priceButton: Instance = v837:FindFirstChild("PriceButton")

			local function showPrice(p128)
				local textLabel: Instance = priceButton and priceButton:FindFirstChild("TextLabel")
				local robux = t1.ROBUX
				local v1049 = t1.comma(p128)

				setText(textLabel, robux .. " " .. v1049)
			end

			if iterSecond.robuxPrice > 0 then
				local robuxPrice = iterSecond.robuxPrice
				local textLabel: Instance = priceButton and priceButton:FindFirstChild("TextLabel")
				local robux = t1.ROBUX
				local v845 = t1.comma(robuxPrice)

				setText(textLabel, robux .. " " .. v845)
			end

			v837.MouseButton1Click:Connect(function()
				t1.buy(iterSecond)
			end)

			if priceButton and priceButton:IsA("GuiButton") then
				priceButton.MouseButton1Click:Connect(function()
					t1.buy(iterSecond)
				end)
			end

			local giftButton: Instance = v837:FindFirstChild("GiftButton")

			if giftButton and giftButton:IsA("GuiButton") then
				giftButton.MouseButton1Click:Connect(function()
					t1.gift(iterSecond)
				end)
			end

			task.spawn(function()
				local ok, result = pcall(function()
					return t1.Market:GetProductInfo(iterSecond.productId, Enum.InfoType.Product)
				end)

				local v1052 = if ok and typeof(result) == "table" then tonumber(result.PriceInRobux) else nil

				if v1052 then
					local textLabel: Instance = priceButton and priceButton:FindFirstChild("TextLabel")
					local robux = t1.ROBUX
					local v1055 = t1.comma(v1052)

					setText(textLabel, robux .. " " .. v1055)
				end
			end)
		end
	end
end
function t1.onOpen()
	t1.queue = {}
	t1.current = nil
	t1.buildOdds()
	t1.buildCurrencies()

	if t1.walletGui then
		t1.walletGui.Enabled = true
	end

	t1.wireShop()
	t1.refreshTickets()
	t1.checkBigPackSale()

	if t1.odds then
		t1.odds.panel.Visible = true
		t1.refreshOdds()
	end
end
function t1.onClose()
	t1.queue = {}
	t1.current = nil
	t1.bulk = nil
	t1.quickSpin = false
	t1.dropCash()

	if t1.walletGui then
		t1.walletGui.Enabled = false
	end

	if t1.lentMenu and t1.GiftPicker.IsOpen() then
		t1.GiftPicker.Close()
	end
end

local t12: {[any]: any} = {}

local function hideOthers()
	for key, value in t5 do
		local foundChild: Instance = playerGui:FindFirstChild(value)

		if foundChild and foundChild:IsA("ScreenGui") and foundChild.Enabled then
			foundChild.Enabled = false
			table.insert(t12, foundChild)
		end
	end
end
local function restoreOthers()
	for key, value in t12 do
		if value.Parent then
			value.Enabled = true
		end
	end

	table.clear(t12)
end

local v174 = (function(parent)
	local wheelFXScale10 = parent:FindFirstChild("WheelFXScale")

	if not wheelFXScale10 then
		local wheelFXScale: UIScale = Instance.new("UIScale")

		wheelFXScale.Name = "WheelFXScale"
		wheelFXScale.Parent = parent
		wheelFXScale10 = wheelFXScale
	end

	return wheelFXScale10
end)(scriptParentFrame)

local function open()
	if s1 == "Closed" then
		activeWindowChanged:Fire("HalloweenWheel")
		n1 += 1
		s1 = "Idle"
		n3 = 0
		n4 = 0
		resetVisuals()
		hideOthers()
		t1.onOpen()
		v174.Scale = 0.92
		scriptParent.Enabled = true

		local tweenInfo35 = TweenInfo.new(tweenInfo.Time, tweenInfo.EasingStyle or Enum.EasingStyle.Quad, tweenInfo.EasingDirection or Enum.EasingDirection.Out)

		tweenService:Create(v174, tweenInfo35, { Scale = 1 }):Play()

		local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

		LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) + 1)
		LocalPlayer:SetAttribute("_WheelOpen", true)

		if u81 then
			u81:Cancel()
		end

		if not u82 then
			local musicDuck: any = soundService:GetAttribute("MusicDuck")

			u80 = if typeof(musicDuck) == "number" then musicDuck else nil
			numberValue.Value = if typeof(musicDuck) == "number" then musicDuck else 1
		end

		u82 = false

		local tweenInfo36 = TweenInfo.new(0.8, Enum.EasingStyle.Sine or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local v859: Tween = tweenService:Create(numberValue, tweenInfo36, { Value = 0 })

		v859:Play()
		u81 = v859
		fade(t7.Ambience, 1, 1.2)

		local function v860()
			if s1 == "Idle" then
				fade(t7.Idle, 1, 2)
			end
		end

		local v861: number = n1

		task.delay(2, function()
			if v861 == n1 and s1 ~= "Closed" then
				local v1056, v1057 = xpcall(v860, debug.traceback)

				if not v1056 then
					local v1058: string = s1
					local text: string = tostring(v1057)

					warn(("[HalloweenWheel] %s failed in phase %s: %s"):format("delayed step", v1058, text))
				end
			end
		end)

		return
	end
end
local function canClose()
	return s1 == "Idle" and not t1.requesting
end
local function close(p129)
	if s1 == "Closed" then
		return
	end

	if not p129 then
		if s1 ~= "Idle" or not not t1.requesting then
			return
		end
	end

	s1 = "Closed"
	n1 += 1
	u116 = nil
	n4 = 0
	t1.onClose()

	for key, value in t7 do
		fade(value, 0, 0.35, true)
	end

	if u81 then
		u81:Cancel()
	end

	u82 = true

	local v865 = u80
	local tweenInfo37 = TweenInfo.new(1.2, Enum.EasingStyle.Sine or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local v867: Tween = tweenService:Create(numberValue, tweenInfo37, { Value = v865 or 1 })

	v867:Play()
	u81 = v867
	v867.Completed:Once(function(p130)
		if p130 ~= Enum.PlaybackState.Completed then
			return
		end

		u82 = false

		if v865 == nil then
			soundService:SetAttribute("MusicDuck", nil)
		end
	end)
	scriptParent.Enabled = false
	resetVisuals()

	for key2, value2 in t12 do
		if value2.Parent then
			value2.Enabled = true
		end
	end

	table.clear(t12)

	local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
	local v871 = math.max((mouseUnlocked or 0) - 1, 0)

	LocalPlayer:SetAttribute("MouseUnlocked", v871)
	LocalPlayer:SetAttribute("_WheelOpen", nil)
end

if closeButton and closeButton:IsA("GuiButton") then
	closeButton.MouseButton1Click:Connect(function()
		close()
	end)
end

activeWindowChanged.Event:Connect(function(p131)
	if p131 ~= "HalloweenWheel" and s1 ~= "Closed" then
		close()
	end
end)
LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(function()
	if s1 ~= "Closed" and LocalPlayer:GetAttribute("MatchId") ~= nil then
		close(true)
	end
end)
LocalPlayer:GetAttributeChangedSignal("VotingPhase"):Connect(function()
	if s1 ~= "Closed" and LocalPlayer:GetAttribute("VotingPhase") == true then
		close(true)
	end
end)
proximityPromptService.PromptTriggered:Connect(function(prompt: ProximityPrompt, playerWhoTriggered: Player)
	if playerWhoTriggered == LocalPlayer and prompt.Name == "WheelPrompt" then
		if not prompt:FindFirstAncestor("Horseman") then
			return
		end

		if s1 == "Closed" then
			open()

			return
		end

		if s1 == "Idle" and not t1.requesting then
			close()
		end

		return
	end
end)

local halloweenWheel_Open: BindableEvent = Instance.new("BindableEvent")

halloweenWheel_Open.Name = "HalloweenWheel_Open"
halloweenWheel_Open.Parent = scriptParent
halloweenWheel_Open.Event:Connect(function()
	if s1 == "Closed" then
		open()

		return
	end

	if s1 == "Idle" and not t1.requesting then
		close()
	end
end)
