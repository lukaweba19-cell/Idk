-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local runService: RunService = game:GetService("RunService")
local userInputService: UserInputService = game:GetService("UserInputService")
local contextActionService: ContextActionService = game:GetService("ContextActionService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local httpService: HttpService = game:GetService("HttpService")
local starterGui: StarterGui = game:GetService("StarterGui")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local replayFormat = require(shared:WaitForChild("ReplayFormat"))
local replayActors = require(shared:WaitForChild("ReplayActors"))
local replayCodec = require(shared:WaitForChild("ReplayCodec"))
local replayUI = require(shared:WaitForChild("ReplayUI"))
local killcamTimeline = require(shared:WaitForChild("KillcamTimeline"))
local knifeCamPath = require(shared:WaitForChild("KnifeCamPath"))
local screenWipe = require(shared:WaitForChild("ScreenWipe"))
local replayTimeScale = require(shared:WaitForChild("ReplayTimeScale"))
local playerState = require(shared:WaitForChild("PlayerState"))
local viewedPlayer = require(shared:WaitForChild("ViewedPlayer"))
local sound = require(replicatedStorage:WaitForChild("Sound"))
local effect = require(replicatedStorage:WaitForChild("Effect"))
local crosshair = require(shared:WaitForChild("Crosshair"))
local actionButtonTheme = require(shared:WaitForChild("ActionButtonTheme"))
local fovController = require(shared:WaitForChild("FOVController"))
local abilityEffectClient = require(replicatedStorage:WaitForChild("AbilityEffectClient"))
local botPlayers = require(shared:WaitForChild("BotPlayers"))
local extensions: Instance = replicatedStorage:WaitForChild("Extensions")
local inputMap = require(extensions:WaitForChild("InputMap"))
local parkourCamera = require(shared:WaitForChild("ParkourCamera"))
local replayControlMenu = require(shared:WaitForChild("ReplayControlMenu"))
local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local LocalPlayer: Player = players.LocalPlayer
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local replayData: Instance = remotes:WaitForChild("ReplayData")
local replayClose: Instance = remotes:WaitForChild("ReplayClose")
local replayKillcamCue: Instance = remotes:WaitForChild("ReplayKillcamCue")
local t1: {[any]: any} = { 0.25, 0.5, 1, 2, 4 }
local n1 = 0
local n2 = 0
local u39: boolean = false
local u40 = nil
local vectorValue = Vector3.new(0, 0, 0)
local t2: {[any]: any} = {}
local characters = nil
local n3 = 0
local u45: boolean = true
local n4 = 3
local n5 = 0
local n6 = 1
local t3: {[any]: any} = { endMs = nil }
local n7 = 0
local u51: boolean = false
local n8 = 0
local n9 = 0
local n10 = 0
local n11 = 0
local u56: boolean = false
local u57: boolean = false
local n12 = 0
local u59: boolean = false
local cFrame = CFrame.new()
local n13 = 0
local n14 = 0
local n15: number = 0
local n16: number = -0.15
local u65: boolean = false
local screenGui = nil
local t4: {[any]: any} = {}
local connection = nil
local t5: {[any]: any} = {}
local n17 = -1
local u71: boolean = false
local n18 = 1
local t6: {[any]: any} = {}
local mapRoot = nil
local CameraType = nil
local CameraSubject = nil
local CameraMode = nil
local MouseBehavior = nil
local MouseIconEnabled = nil
local n19: number = 0

local function durationMs()
	if not u40 then
		return 0
	end

	local floored = math.floor(u40.sampleCount / u40.sampleRateHz * 1000)

	return (math.max(1, floored))
end
local function aliveSlots()
	local t34: {[any]: any} = {}

	if not u40 then
		return t34
	end

	for _, v in ipairs(u40.participants) do
		table.insert(t34, v.slot)
	end

	table.sort(t34)

	return t34
end
local function participantFor(p1)
	if not u40 then
		return nil
	end

	for _, v in ipairs(u40.participants) do
		if p1 == v.slot then
			return v
		end
	end

	return nil
end

local t7: {[any]: any} = {
	byId = {},
	tried = {}
}

function t7.For(p2)
	if typeof(p2) == "table" then
		if bit32.band(p2.pflags or 0, 1) == 0 then
			local userId = p2.userId

			if typeof(userId) == "number" and not (userId <= 0) then
				local v190 = t7.byId[userId]

				if v190 then
					return v190
				end

				if t7.tried[userId] then
					return nil
				end

				v190 = players:GetPlayerByUserId(userId)

				if v190 then
					t7.byId[userId] = v190.Name

					return v190.Name
				end

				t7.tried[userId] = true
				task.spawn(function()
					local ok, result = pcall(function()
						return players:GetNameFromUserIdAsync(userId)
					end)

					if ok and typeof(result) == "string" and result ~= "" then
						t7.byId[userId] = result
					end
				end)

				return nil
			end

			return nil
		end

		return nil
	end

	return nil
end

local t8: {[any]: any} = {}
local u86 = nil

local function duckAudio()
	playerState.ReplayActive = true
	playerState.ReplayPlayheadSeconds = n3 / 1000

	local soundService: SoundService = game:GetService("SoundService")

	if u86 == nil then
		local musicVolumeMultiplier: any = soundService:GetAttribute("MusicVolumeMultiplier")

		u86 = typeof(musicVolumeMultiplier) == "number" and musicVolumeMultiplier or 1
	end

	soundService:SetAttribute("MusicVolumeMultiplier", 0)
end
local function restoreAudio()
	playerState.ReplayActive = false
	playerState.ReplayTimeScale = 1
	playerState.ReplayPlayheadSeconds = nil
	playerState.ReplayViewSide = nil
	playerState.CameraFirstPerson = nil

	if u86 ~= nil then
		game:GetService("SoundService"):SetAttribute("MusicVolumeMultiplier", u86)
		u86 = nil
	end

	for k, v in pairs(t8) do
		if k and k.Parent then
			pcall(function()
				k.Volume = v
			end)
		end
	end

	t8 = {}
end

local t9: {[any]: any} = {
	ReplayHUD = true,
	ReviewPanel = true,
	Cursor = true,
	InMatchUI = true,
	HUD = true,
	ConfirmationModal = true,
	Notifications = true,
	CutsceneFadeGui = true,
	ScreenWipeOverlay = true
}
local t10: {[any]: any} = {
	KillFeed = true,
	GlobalKillFeed = true,
	MatchLeaderboard = true,
	ScoreboardMenu = true,
	BlackBackground3 = true
}
local t11: {[any]: any} = {}
local t12: {[any]: any} = {}
local connection2 = nil
local t13: {[any]: any} = {}
local u95 = nil
local t14: {[any]: any} = {}
local t15: {[any]: any} = {}

local function pushCrosshairStyle(p3)
	local v196 = t2[p3]

	if not v196 then
		return
	end

	if t15[p3] then
		return
	end

	local u197 = t14[p3]
	local v198: boolean = false

	if u197 == nil then
		local v199

		if not u40 then
			v199 = nil
		else
			local v200, v201, v202 = ipairs(u40.participants)
			local v203: boolean = false

			for iterFirst, iterSecond in v200, v201, v202 do
				if p3 == iterSecond.slot then
					v199 = iterSecond
					v203 = true

					break
				end
			end

			if not v203 then
				v199 = nil
			end
		end

		local crosshair2 = v199 and v199.crosshair

		if typeof(crosshair2) ~= "string" or crosshair2 == "" then
			t15[p3] = true

			return
		end

		local ok, result = pcall(httpService.JSONDecode, httpService, crosshair2)

		if not ok or typeof(result) ~= "table" then
			t15[p3] = true

			return
		end

		u197 = result
		t14[p3] = u197
	end

	v198 = true

	if v198 then
		t15[p3] = true
		pcall(function()
			crosshair.__ReplayInvoke("StyleFrom", v196.synthId, u197)
		end)

		return
	end
end
local function applySpectateAttribute()
	local v209 = t2[n5]

	pushCrosshairStyle(n5)
	LocalPlayer:SetAttribute("Spectating", v209 ~= nil and n6 ~= 3 and v209.synthId or nil)

	local u210 = true

	if n6 ~= 3 then
		u210 = nil
	end

	LocalPlayer:SetAttribute("ReplayFreecam", u210)
	LocalPlayer:SetAttribute("LobbySpectateMatchId", replayActors.MATCH_ID)

	local v211

	if v209 then
		local v212: number = n5

		if not u40 then
			v211 = nil
		else
			local v213, v214, v215 = ipairs(u40.participants)
			local v216: boolean = false

			for iterFirst, iterSecond in v213, v214, v215 do
				if v212 == iterSecond.slot then
					v211 = iterSecond
					v216 = true

					break
				end
			end

			if not v216 then
				v211 = nil
			end
		end

		if not v211 then
			v211 = nil
		end
	else
		v211 = nil
	end

	viewedPlayer.SetOverride(v209 and v209.model or nil, v209 and v209.synthId or nil, v211 and v211.userId or nil)
	playerState.ReplayViewSide = if v211 then if v211.side == 0 then "A" else "B" else nil
	LocalPlayer:SetAttribute("LobbySpectateTeam", playerState.ReplayViewSide)
	u95()
end
local function hideOtherUI()
	applySpectateAttribute()

	local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")

	if not playerGui then
		return
	end

	local function suppress(p4)
		if not p4:IsA("LayerCollector") then
			return
		end

		if t9[p4.Name] then
			return
		end

		if not p4.Enabled then
			return
		end

		t11[p4] = true
		p4.Enabled = false
	end

	for _, v in ipairs(playerGui:GetChildren()) do
		if v:IsA("LayerCollector") and not t9[v.Name] and v.Enabled then
			t11[v] = true
			v.Enabled = false
		end
	end

	connection2 = playerGui.ChildAdded:Connect(function(p5: Instance)
		task.defer(function()
			if u39 then
				local v1069: Instance = p5

				if not v1069:IsA("LayerCollector") then
					return
				end

				if t9[v1069.Name] then
					return
				end

				if not v1069.Enabled then
					return
				end

				t11[v1069] = true
				v1069.Enabled = false

				return
			end
		end)
	end)

	local hud: Instance = playerGui:FindFirstChild("HUD")

	if hud then
		for _, v in ipairs(hud:GetChildren()) do
			if v:IsA("GuiObject") and not t10[v.Name] then
				if v.Visible then
					t12[v] = true
					v.Visible = false
				end

				local v226: {[any]: any} = t13
				local v227 = v:GetPropertyChangedSignal("Visible")

				table.insert(v226, v227:Connect(function()
					if u39 and v.Visible then
						v.Visible = false
					end
				end))
			end
		end
	end
end

local t16: {[any]: any} = {}
local t17: {[any]: any} = {}

local function hideKillcamScoreBar()
	local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")

	if not playerGui then
		return
	end

	local inMatchUI: Instance = playerGui:FindFirstChild("InMatchUI")
	local v230: Instance = inMatchUI

	if v230 then
		v230 = inMatchUI:FindFirstChild("Round")
	end

	local matchStatusFrame: Instance = v230 and v230:FindFirstChild("MatchStatusFrame")

	if not matchStatusFrame or not matchStatusFrame:IsA("GuiObject") or not matchStatusFrame.Visible then
		return
	end

	t17[matchStatusFrame] = true
	matchStatusFrame.Visible = false

	local v232: {[any]: any} = t13
	local v233: RBXScriptSignal = matchStatusFrame:GetPropertyChangedSignal("Visible")

	table.insert(v232, v233:Connect(function()
		if u39 and matchStatusFrame.Visible then
			matchStatusFrame.Visible = false
		end
	end))
end
local function raiseMatchUI(p6)
	local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")

	if not playerGui then
		return
	end

	local inMatchUI: Instance = playerGui:FindFirstChild("InMatchUI")

	if not inMatchUI then
		return
	end

	for _, v in ipairs({ "Abilities", "AbilityBar", "Hotbar" }) do
		local v: Instance = inMatchUI:FindFirstChild(v)

		if v and v:IsA("GuiObject") and t16[v] == nil then
			t16[v] = v.Position

			local vPosition = v.Position
			local uDim2 = UDim2.new(0, 0, 0, p6 or 44)

			v.Position = vPosition - uDim2
		end
	end
end
local function restoreMatchUI()
	for k, v in pairs(t16) do
		if k and k.Parent then
			pcall(function()
				k.Position = v
			end)
		end
	end

	t16 = {}

	for iterKey in pairs(t17) do
		if iterKey and iterKey.Parent then
			pcall(function()
				iterKey.Visible = true
			end)
		end
	end

	t17 = {}
end
local function restoreOtherUI()
	LocalPlayer:SetAttribute("Spectating", nil)
	LocalPlayer:SetAttribute("LobbySpectateMatchId", nil)
	LocalPlayer:SetAttribute("ReplayXRay", nil)
	LocalPlayer:SetAttribute("ReplayFreecam", nil)
	u71 = false
	LocalPlayer:SetAttribute("LobbySpectateTeam", nil)
	viewedPlayer.SetOverride(nil, nil, nil)
	restoreMatchUI()

	if connection2 then
		connection2:Disconnect()
		connection2 = nil
	end

	for _, v in ipairs(t13) do
		pcall(function()
			v:Disconnect()
		end)
	end

	t13 = {}

	for iterKey in pairs(t11) do
		if iterKey and iterKey.Parent then
			pcall(function()
				iterKey.Enabled = true
			end)
		end
	end

	t11 = {}

	for iterKey2 in pairs(t12) do
		if iterKey2 and iterKey2.Parent and iterKey2.Name ~= "Spectating" then
			pcall(function()
				iterKey2.Visible = true
			end)
		end
	end

	t12 = {}
end

local t18: {[any]: any} = { h = 36, hTouch = 24, gap = 4, maxW = 0.55, maxWTouch = 0.42 }

local function resetToAuthored(p7, p8)
	if not p7 or not p7:IsA("GuiObject") then
		return
	end

	local hud: Instance = starterGui:FindFirstChild("HUD")

	hud = hud and hud:FindFirstChild("Spectating")

	for _, v in ipairs(p8) do
		if not hud then
			return
		end

		hud = hud:FindFirstChild(v)
	end

	if not hud or not hud:IsA("GuiObject") then
		return
	end

	p7.Position = hud.Position
	p7.Size = hud.Size
	p7.Visible = hud.Visible

	for _, v in ipairs(p7:GetChildren()) do
		if v:IsA("UIGradient") then
			local vName: Instance = hud:FindFirstChild(v.Name)

			if vName and vName:IsA("UIGradient") then
				v.Enabled = vName.Enabled
			end
		end
	end
end
local function placeStrip()
	local strip = t4.strip

	if not strip then
		return
	end

	local CurrentCamera: Camera = workspace.CurrentCamera
	local v259 = CurrentCamera and CurrentCamera.ViewportSize.Y or 800
	local v260 = t4.stripBarScaleH or 0.07
	local v261 = t4.stripAspect or 2
	local v262 = userInputService.TouchEnabled and not userInputService.KeyboardEnabled
	local v263 = math.min((if v262 then 24 else 36) / v260, (CurrentCamera and CurrentCamera.ViewportSize.X or 1280) * (if v262 then 0.42 else 0.55) / (t4.stripBarScaleW or 0.4) / v261)

	strip.Size = UDim2.fromOffset(v263 * v261, v263)
	v262 = v263 * v260
	v263 = nil

	local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local v265: Instance = playerGui

	if v265 then
		v265 = playerGui:FindFirstChild("InMatchUI")
	end

	v261 = v265

	if v261 then
		v261 = v265:FindFirstChild("Abilities")
	end

	if v261 and v261:IsA("GuiObject") and v261.AbsoluteSize.Y > 0 then
		local y = v261.AbsolutePosition.Y
		local v267 = game:GetService("GuiService"):GetGuiInset()

		v263 = y + v267.Y
	end

	if not v263 then
		v263 = v259 * 0.8
	end

	local uDim2New = UDim2.new
	local v269 = math.max(v262, v263 - 4 - v262 * 0.5)

	strip.Position = uDim2New(0.5, 0, 0, v269)
end
local function formatKillcamClock(p9)
	local n1 = math.max(0, p9) / 1000
	local floored = math.floor(n1 / 60)
	local floored2 = math.floor(n1 % 60)
	local floored3 = math.floor(n1 * 10 % 10)

	return string.format("%d:%02d.%d", floored, floored2, floored3)
end
local function buildKillcamChrome()
	if not screenGui then
		return
	end

	local function bar(name, p11, p12)
		local frame: Frame = Instance.new("Frame")

		frame.Name = name
		frame.AnchorPoint = Vector2.new(0.5, p11)
		frame.Position = UDim2.new(0.5, 0, p12, 0)
		frame.Size = UDim2.new(1, 0, 0, 0)
		frame.BackgroundColor3 = Color3.new(0, 0, 0)
		frame.BackgroundTransparency = 0.5
		frame.BorderSizePixel = 0
		frame.ZIndex = 2
		frame.Parent = screenGui

		return frame
	end

	local v276 = bar("LetterboxTop", 0, 0)
	local v277 = bar("LetterboxBottom", 1, 1)

	t4.kcTop = v276
	t4.kcBottom = v277

	local tweenService: TweenService = game:GetService("TweenService")
	local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local t35: {[any]: any} = { Size = UDim2.new(1, 0, 0.11, 0) }

	pcall(function()
		tweenService:Create(v276, tweenInfo, t35):Play()
		tweenService:Create(v277, tweenInfo, t35):Play()
	end)

	local function text(name, p14, textSize, p16)
		local textLabel: TextLabel = Instance.new("TextLabel")

		textLabel.Name = name
		textLabel.AnchorPoint = Vector2.new(0.5, 0)
		textLabel.Position = UDim2.new(0.5, 0, 0, p14)
		textLabel.Size = UDim2.new(0, 700, 0, p16)
		textLabel.BackgroundTransparency = 1
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextColor3 = Color3.new(1, 1, 1)
		textLabel.TextScaled = false
		textLabel.TextSize = textSize
		textLabel.ZIndex = 3
		textLabel.Parent = screenGui

		local uiStroke: UIStroke = Instance.new("UIStroke")

		uiStroke.Thickness = 2
		uiStroke.Color = Color3.new(0, 0, 0)
		uiStroke.Transparency = 0.35
		uiStroke.Parent = textLabel

		return textLabel
	end

	t4.kcTitle = text("KillcamTitle", 26, 30, 36)
	t4.kcTitle.Text = "FINAL KILL"
	t4.kcTimer = text("KillcamTimer", 64, 34, 40)
	t4.kcTimer.Text = ""
end

local uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))
local replicatedStorageExtensions: Instance = replicatedStorage:WaitForChild("Extensions")
local gamepadBindings = require(replicatedStorageExtensions:WaitForChild("GamepadBindings"))

local function needsControlMenu()
	return userInputService.TouchEnabled or userInputService.GamepadEnabled
end

local t19: {[any]: any} = {
	inst = nil,
	openAction = "ReplayControls_OpenY",
	killcamAction = "ReplayKillcam_Exit",
	exitAction = "ReplayControls_ExitX",
	priority = 3900,
	openBound = false,
	killcamBound = false,
	exitBound = false,
	btnW = 132,
	btnH = 40,
	btnWTouch = 96,
	btnHTouch = 32,
	btnGap = 8,
	badges = {},
	UIFramework = uiFramework,
	GamepadBindings = gamepadBindings,
	touchOnly = function()
		return userInputService.TouchEnabled and not userInputService.KeyboardEnabled
	end
}

function t19.metrics()
	if t19.touchOnly() then
		return t19.btnWTouch, t19.btnHTouch, t19.btnGap
	end

	return t19.btnW, t19.btnH, t19.btnGap
end
local function refreshControlMenu()
	if not t19.inst then
		return
	end

	local v282: number = n5
	local v283

	if not u40 then
		v283 = nil
	else
		local v284, v285, v286 = ipairs(u40.participants)
		local v287: boolean = false

		for iterFirst, iterSecond in v284, v285, v286 do
			if v282 == iterSecond.slot then
				v283 = iterSecond
				v287 = true

				break
			end
		end

		if not v287 then
			v283 = nil
		end
	end

	t19.inst:SetState({
		playing = u45,
		speed = t1[n4],
		camera = if n6 == 2 then "First" else if n6 == 3 then "Free" else "Third",
		xray = u71,
		playerName = v283 and v283.displayName or "Freecam"
	})
end

local t20: {[any]: any} = {
	{ "Space", "play / pause" },
	{ "A / D", "frame step" },
	{ ", / .", "speed" },
	{ "Q / E", "player" },
	{ "1 / 2 / 3", "third / first / free" },
	{ "R / F", "round" },
	{ "X", "xray" },
	{ "RMB", "look" },
	{ "M", "exit" }
}

local function buildUI()
	screenGui = Instance.new("ScreenGui")
	screenGui.Name = "ReplayHUD"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.DisplayOrder = 50
	screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

	local v290 = replayUI.CloneFromHud({ "Spectating" })
	local bottom = v290 and v290:FindFirstChild("Bottom")

	if v290 and bottom and bottom:IsA("GuiObject") then
		replayUI.StripScripts(v290)

		for _, v in ipairs({ "Exit" }) do
			local v = v290:FindFirstChild(v)

			if v then
				v:Destroy()
			end
		end

		t4.stripBarScaleH = bottom.Size.Y.Scale > 0 and bottom.Size.Y.Scale or 0.07
		t4.stripBarScaleW = bottom.Size.X.Scale > 0 and bottom.Size.X.Scale or 0.4

		local uiAspectRatioConstraint = v290:FindFirstChildOfClass("UIAspectRatioConstraint")

		t4.stripAspect = uiAspectRatioConstraint and uiAspectRatioConstraint.AspectRatio > 0 and uiAspectRatioConstraint.AspectRatio or 2
		v290.Name = "Strip"
		v290.Visible = true
		v290.BackgroundTransparency = 1
		v290.ZIndex = 8
		v290.AnchorPoint = Vector2.new(0.5, bottom.Position.Y.Scale)
		v290.Position = UDim2.new(0.5, 0, 0.78, 0)
		v290.Parent = screenGui
		t4.strip = v290
		t4.label = bottom:FindFirstChild("Spectating")
		t4.playerName = bottom:FindFirstChild("PlayerName")
		t4.playerUser = bottom:FindFirstChild("PlayerUsername")

		local playerTemplate = bottom:FindFirstChild("PlayerTemplate")

		t4.headshot = playerTemplate and playerTemplate:FindFirstChild("Headshot")
		t4.back = v290:FindFirstChild("Back")
		t4.next = v290:FindFirstChild("Next")

		if t4.back then
			t4.back.Visible = true
		end

		if t4.next then
			t4.next.Visible = true
		end

		t4.exit = nil

		if t4.label then
			t4.label.Text = "Replay"
		end

		resetToAuthored(t4.playerName, { "Bottom", "PlayerName" })
		resetToAuthored(t4.playerUser, { "Bottom", "PlayerUsername" })
	elseif v290 then
		v290:Destroy()
	end

	local dock: Frame = Instance.new("Frame")

	dock.Name = "Dock"
	dock.AnchorPoint = Vector2.new(0.5, 1)
	dock.Position = UDim2.new(0.5, 0, 1, 0)
	dock.Size = UDim2.new(1, 0, 0, 64)
	dock.BackgroundTransparency = 1
	dock.BorderSizePixel = 0
	dock.ZIndex = 5
	dock.Parent = screenGui
	t4.dock = dock
	v290 = replayUI.CloneFromHud({ "PlayerLevelFrame", "LevelBarFrame", "BarBacking" })

	local scrubHolder: Frame = Instance.new("Frame")

	scrubHolder.Name = "ScrubHolder"
	scrubHolder.AnchorPoint = Vector2.new(0.5, 1)
	scrubHolder.Position = UDim2.new(0.5, 0, 1, -14)
	scrubHolder.Size = UDim2.new(0.62, 0, 0, 18)
	scrubHolder.BackgroundTransparency = 1
	scrubHolder.ZIndex = 6
	scrubHolder.Parent = dock
	t4.holder = scrubHolder

	if v290 then
		replayUI.StripScripts(v290)
		v290.Name = "Scrub"
		v290.Size = UDim2.fromScale(1, 1)
		v290.Position = UDim2.fromScale(0, 0)
		v290.AnchorPoint = Vector2.new(0, 0)
		v290.Parent = scrubHolder
		t4.scrub = v290
		t4.fill = v290:FindFirstChild("BarFill")

		if t4.fill then
			t4.fill.Size = UDim2.new(0, 0, 1, -4)
		end
	else
		local frame: Frame = Instance.new("Frame")

		frame.Size = UDim2.fromScale(1, 1)
		frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		frame.BorderSizePixel = 0
		frame.Parent = scrubHolder

		local uiCorner: UICorner = Instance.new("UICorner")

		uiCorner.Parent = frame

		local barFill: Frame = Instance.new("Frame")

		barFill.Name = "BarFill"
		barFill.Size = UDim2.new(0, 0, 1, -4)
		barFill.Position = UDim2.fromOffset(2, 2)
		barFill.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
		barFill.BorderSizePixel = 0
		barFill.Parent = frame

		local uiCorner2: UICorner = Instance.new("UICorner")

		uiCorner2.Parent = barFill
		t4.scrub = frame
		t4.fill = barFill
	end

	local seekHit: TextButton = Instance.new("TextButton")

	seekHit.Name = "SeekHit"
	seekHit.Size = UDim2.fromScale(1, 1)
	seekHit.BackgroundTransparency = 1
	seekHit.Text = ""
	seekHit.ZIndex = 20
	seekHit.Parent = scrubHolder
	t4.seekHit = seekHit
	t4.markerLayer = Instance.new("Frame")
	t4.markerLayer.Name = "Markers"
	t4.markerLayer.Size = UDim2.fromScale(1, 1)
	t4.markerLayer.BackgroundTransparency = 1
	t4.markerLayer.ZIndex = 15
	t4.markerLayer.Parent = scrubHolder

	local v304, v305, v306 = t19.metrics()
	local v307 = replayUI.CloneFromGui("WinScreen", { "ReturnButton" })

	if v307 then
		replayUI.StripScripts(v307)
		v307.Name = "ExitButton"
		v307.Visible = true
		v307.AnchorPoint = Vector2.new(1, 0.5)
		v307.Position = UDim2.new(1, -20, 0.5, -4)
		v307.Size = UDim2.fromOffset(v304, v305)
		v307.ZIndex = 30

		if t19.touchOnly() then
			local keybind = v307:FindFirstChild("Keybind")

			if keybind then
				keybind:Destroy()
			end
		elseif userInputService.GamepadEnabled then
			local keybind = v307:FindFirstChild("Keybind")

			if keybind and keybind:IsA("Frame") then
				local ok, result = pcall(t19.UIFramework.applyGamepadKeybind, keybind, t19.GamepadBindings.Menu)

				if ok and result then
					table.insert(t19.badges, result)
				end
			end
		end

		actionButtonTheme.SetText(v307, "Exit")
		v307.Parent = dock
		t4.exit = v307
	else
		local exitButton: TextButton = Instance.new("TextButton")

		exitButton.Name = "ExitButton"
		exitButton.AnchorPoint = Vector2.new(1, 0.5)
		exitButton.Position = UDim2.new(1, -20, 0.5, -4)
		exitButton.Size = UDim2.fromOffset(v304, v305)
		exitButton.BackgroundColor3 = Color3.fromRGB(190, 55, 55)
		exitButton.BorderSizePixel = 0
		exitButton.Font = Enum.Font.GothamBold
		exitButton.Text = if t19.touchOnly() then "EXIT" else "EXIT  (M)"
		exitButton.TextColor3 = Color3.new(1, 1, 1)
		exitButton.TextSize = 14
		exitButton.ZIndex = 30
		exitButton.Parent = dock

		local uiCorner: UICorner = Instance.new("UICorner")

		uiCorner.CornerRadius = UDim.new(0, 6)
		uiCorner.Parent = exitButton
		t4.exit = exitButton
	end

	if userInputService.TouchEnabled or userInputService.GamepadEnabled then
		local v314 = replayUI.CloneFromGui("WinScreen", { "ReturnButton" })

		if v314 then
			replayUI.StripScripts(v314)
			v314.Name = "ControlsButton"
			v314.Visible = true
			v314.AnchorPoint = Vector2.new(1, 0.5)
			v314.Position = UDim2.new(1, -20, 0.5, -4 - (v305 + v306))
			v314.Size = UDim2.fromOffset(v304, v305)
			v314.ZIndex = 30
			actionButtonTheme.Apply(v314, actionButtonTheme.THEMES.blue)

			local keybind = v314:FindFirstChild("Keybind")

			if keybind then
				if userInputService.GamepadEnabled then
					for _, v in ipairs(keybind:GetDescendants()) do
						if v:IsA("TextLabel") then
							v.Text = "Y"
						end
					end

					if keybind:IsA("Frame") then
						local ok, result = pcall(t19.UIFramework.applyGamepadKeybind, keybind, t19.GamepadBindings.ReplayControls)

						if ok and result then
							table.insert(t19.badges, result)
						end
					end
				else
					keybind:Destroy()
				end
			end

			actionButtonTheme.SetText(v314, "Controls")
			v314.Parent = dock
			t4.menuBtn = v314
		else
			local controlsButton: TextButton = Instance.new("TextButton")

			controlsButton.Name = "ControlsButton"
			controlsButton.AnchorPoint = Vector2.new(1, 0.5)
			controlsButton.Position = UDim2.new(1, -20, 0.5, -4 - (v305 + v306))
			controlsButton.Size = UDim2.fromOffset(v304, v305)
			controlsButton.BackgroundColor3 = Color3.fromRGB(38, 132, 255)
			controlsButton.BorderSizePixel = 0
			controlsButton.Font = Enum.Font.GothamBold
			controlsButton.Text = if userInputService.GamepadEnabled then "CONTROLS (Y)" else "CONTROLS"
			controlsButton.TextColor3 = Color3.new(1, 1, 1)
			controlsButton.TextSize = 14
			controlsButton.ZIndex = 30
			controlsButton.Parent = dock

			local uiCorner: UICorner = Instance.new("UICorner")

			uiCorner.CornerRadius = UDim.new(0, 6)
			uiCorner.Parent = controlsButton
			t4.menuBtn = controlsButton
		end
	end

	local function mkLabel(name, p18, anchorPoint, p20, p21)
		local textLabel: TextLabel = Instance.new("TextLabel")

		textLabel.Name = name
		textLabel.AnchorPoint = anchorPoint
		textLabel.Position = p18
		textLabel.Size = p20
		textLabel.BackgroundTransparency = 1
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextScaled = true
		textLabel.TextColor3 = Color3.new(1, 1, 1)
		textLabel.Text = ""
		textLabel.ZIndex = 7
		textLabel.Parent = p21 or t4.dock or screenGui

		local uiStroke: UIStroke = Instance.new("UIStroke")

		uiStroke.Thickness = 2
		uiStroke.Color = Color3.new(0, 0, 0)
		uiStroke.Parent = textLabel

		return textLabel
	end

	t4.time = mkLabel("TimeText", UDim2.new(0, 16, 1, -36), Vector2.new(0, 1), UDim2.new(0, 130, 0, 18))
	t4.time.TextXAlignment = Enum.TextXAlignment.Left
	t4.time.TextScaled = false
	t4.time.TextSize = 15
	t4.tip = mkLabel("TipText", UDim2.new(0.5, 0, 1, -40), Vector2.new(0.5, 1), UDim2.new(0, 320, 0, 16))
	t4.tip.TextTransparency = 0.15
	t4.tip.TextScaled = false
	t4.tip.TextSize = 13

	local controls: Frame = Instance.new("Frame")

	controls.Name = "Controls"
	controls.AnchorPoint = Vector2.new(0, 0.5)
	controls.Position = UDim2.new(0, 16, 0.5, 0)
	controls.Size = UDim2.fromOffset(210, #t20 * 18)
	controls.BackgroundTransparency = 1
	controls.ZIndex = 7
	controls.Visible = userInputService.KeyboardEnabled
	controls.Parent = screenGui
	t4.hints = controls

	local uiListLayout: UIListLayout = Instance.new("UIListLayout")

	uiListLayout.FillDirection = Enum.FillDirection.Vertical
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Padding = UDim.new(0, 3)
	uiListLayout.Parent = controls

	for i, v in ipairs(t20) do
		local frame: Frame = Instance.new("Frame")

		frame.Name = "Row" .. i
		frame.LayoutOrder = i
		frame.Size = UDim2.new(1, 0, 0, 15)
		frame.BackgroundTransparency = 1
		frame.ZIndex = 7
		frame.Parent = controls

		local v328 = UDim2.fromOffset(0, 0)
		local v329 = mkLabel("Key", v328, Vector2.new(0, 0), UDim2.new(0, 74, 1, 0), frame)

		v329.TextXAlignment = Enum.TextXAlignment.Left
		v329.TextScaled = false
		v329.TextSize = 13
		v329.Text = v[1]
		v328 = UDim2.fromOffset(74, 0)
		v329 = mkLabel("Action", v328, Vector2.new(0, 0), UDim2.new(1, -74, 1, 0), frame)
		v329.TextXAlignment = Enum.TextXAlignment.Left
		v329.TextScaled = false
		v329.TextSize = 13
		v329.TextTransparency = 0.35
		v329.Text = v[2]
	end
end
local function buildMarkers()
	if not u40 or not t4.markerLayer then
		return
	end

	for _, v in ipairs(t4.markerLayer:GetChildren()) do
		v:Destroy()
	end

	local n1

	if not u40 then
		n1 = 0
	else
		local floored = math.floor(u40.sampleCount / u40.sampleRateHz * 1000)

		n1 = math.max(1, floored)
	end

	for _, v in ipairs(u40.markers) do
		local v336 = math.clamp(v.timeMs / n1, 0, 1)
		local marker: Frame = Instance.new("Frame")

		marker.Name = "Marker"
		marker.AnchorPoint = Vector2.new(0.5, 0.5)
		marker.Position = UDim2.new(v336, 0, 0.5, 0)
		v336 = true

		if v.kind ~= replayFormat.MK_ROUND_START then
			v336 = v.kind == replayFormat.MK_ROUND_WIN
		end

		marker.Size = v336 and UDim2.new(0, 2, 1, 6) or UDim2.new(0, 4, 0, 10)
		marker.BackgroundColor3 = replayUI.MarkerColors[v.kind] or Color3.new(1, 1, 1)
		marker.BorderSizePixel = 0
		marker.ZIndex = 16
		marker.Parent = t4.markerLayer

		if not v336 then
			local uiCorner: UICorner = Instance.new("UICorner")

			uiCorner.CornerRadius = UDim.new(1, 0)
			uiCorner.Parent = marker
		end

		local textButton: TextButton = Instance.new("TextButton")

		textButton.Size = UDim2.fromOffset(14, 22)
		textButton.AnchorPoint = Vector2.new(0.5, 0.5)
		textButton.Position = UDim2.fromScale(0.5, 0.5)
		textButton.BackgroundTransparency = 1
		textButton.Text = ""
		textButton.ZIndex = 22
		textButton.Parent = marker

		local u340 = replayUI.MarkerNames[v.kind] or "Event"

		if v.label ~= "" then
			u340 = v.label
		end

		textButton.MouseEnter:Connect(function()
			if t4.tip then
				local tip = t4.tip
				local stringFormat = string.format
				local v976 = replayUI.FormatTime(v.timeMs)

				tip.Text = stringFormat("%s  -  %s", v976, u340)
			end
		end)
		textButton.MouseLeave:Connect(function()
			if t4.tip then
				t4.tip.Text = ""
			end
		end)
		textButton.MouseButton1Click:Connect(function()
			n3 = math.clamp(v.timeMs - 1200, 0, n1)
		end)
	end
end

u95 = function()
	local v341
	local headshot = t4.headshot

	if not headshot or not headshot:IsA("ImageLabel") or not u40 then
		return
	end

	local v343: number = n5
	local v344, v345, v346 = ipairs(u40.participants)
	local v347: boolean = false

	for iterFirst, iterSecond in v344, v345, v346 do
		if v343 == iterSecond.slot then
			v341 = iterSecond
			v347 = true

			break
		end
	end

	if not v347 then
		v341 = nil
	end

	if v341 and v341.userId > 0 then
		headshot.Image = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420", v341.userId)

		return
	end

	headshot.Image = ""
end

local t21: {[any]: any} = {
	ShootReplicate = "SpawnBullet",
	ThrowReplicate = "SpawnKnife",
	HitReplicate = "ReplayHitReplicate",
	KillFeed = "ReplayKillFeed",
	GlobalKillFeed = "ReplayGlobalKillFeed"
}
local t22: {[any]: any} = {
	Hit = "Hit",
	AbilityCast = "ReplayAbilityCast",
	AbilityPanel = "ReplayAbilityPanel",
	RoundCleanup = "ReplayRoundCleanup"
}
local t23: {[any]: any} = { AbilityCast = 1 }
local t24: {[any]: any} = {
	Hit = true,
	KillFeed = true,
	AbilityEffect = true,
	AbilityPanel = true
}
local t25: {[any]: any} = { RoundCleanup = true, GlobalKillFeed = true }
local t26: {[any]: any} = { MatchState = "ReplayMatchState" }
local u127 = nil

local function rewriteGlobalKillFeed(p22)
	if typeof(p22) == "table" then
		local killer = p22.killer

		if typeof(killer) == "table" then
			local v352 = u127(killer.UserId)

			if v352 then
				p22.killer = v352
			else
				killer.MatchId = replayActors.MATCH_ID
			end
		end

		local v353 = u127
		local typeName: string = typeof(p22.assister)

		p22.assister = v353(typeName == "table" and p22.assister.UserId or nil)

		local victim = p22.victim

		p22.victimRef = typeof(victim) == "table" and u127(victim.userId) or nil
		p22.replayResolved = true

		return
	end
end

local t27: {[any]: any} = {
	BotUserId = true,
	BotMatchBot = true,
	MatchId = true,
	InMatch = true,
	ReplayActor = true,
	ReplaySlot = true,
	Spectating = true,
	EnableKnifeRig = true,
	EnableRevolverRig = true
}

local function decodeCtx()
	local t36: {[any]: any} = {}

	for k, v in pairs(t2) do
		if v.model then
			t36[k] = v.model
		end
	end

	return { mapRoot = mapRoot, actorModels = t36 }
end
local function readStartLooped(p35)
	local v360, v361, v362, v363, v364 = pcall(string.unpack, "<ffs2", p35.payload)

	if v360 and typeof(v364) == "number" then
		local n1 = #p35.payload - v364 + 1
		local s1 = if n1 >= 3 then "<BH" else if n1 == 2 then "<BB" else if n1 == 1 then "<B" else nil

		if not s1 then
			return nil
		end

		local ok, result = pcall(string.unpack, s1, p35.payload, v364)

		if not ok then
			return nil
		end

		return result == 1
	end

	return nil
end
local function markAnimHolds(p36)
	local t37: {[any]: any} = {}
	local t38: {[any]: any} = {}

	for _, v in ipairs(p36) do
		if v.etype == replayFormat.EV_ANIM_START then
			local v374, v375, v376, v377 = pcall(string.unpack, "<ffs2", v.payload)

			if v374 then
				local v378 = readStartLooped(v)

				if v378 ~= nil then
					local s1: string = v.actorSlot .. "|" .. v377

					t38[s1] = true

					if v378 then
						t37[s1] = true
					end
				end
			end
		end
	end

	local t39: {[any]: any} = {}

	for i = #p36, 1, -1 do
		local v382 = p36[i]

		if v382.etype == replayFormat.EV_ANIM_STOP then
			local ok, result = pcall(string.unpack, "<s2", v382.payload)

			if ok then
				t39[v382.actorSlot .. "|" .. result] = i
			end
		elseif v382.etype == replayFormat.EV_ANIM_START then
			local v385, v386, v387, v388 = pcall(string.unpack, "<ffs2", v382.payload)

			if v385 then
				local s2: string = v382.actorSlot .. "|" .. v388
				local u390: boolean = t39[s2] ~= nil

				v382._hasStop = u390

				local u391: boolean = true

				if t37[s2] ~= true then
					u391 = false

					if t38[s2] ~= true then
						u391 = not u390
					end
				end

				v382._loop = u391
				t39[s2] = nil
			end
		end
	end
end

ReplayController_DEBUG_EVENTS = true
ReplayController_Perf = {
	warns = 0,
	folded = 0,
	PERF_SLOW_MS = 60,
	MAX_WARNS = 6,
	ev = {},
	evN = {}
}

local t28: {[any]: any} = {}
local t29: {[any]: any} = {
	LEAD_MS = 70,
	HOLD_MS = 260,
	HANDOFF = 0.45,
	PULLBACK = 1.9,
	PROBES = 10,
	VICTIM_Y = 1.5,
	flight = nil,
	window = nil,
	offset = nil,
	right = Vector3.new(1, 0, 0),
	fwd = Vector3.new(0, 0, 1),
	victimSlot = nil,
	engaged = false,
	BACK = { 6, 9 },
	LATERAL = { 3, 5 },
	HEIGHT = { 1.4, 3 }
}

local t30: {[any]: any} = {
	Sound = function(p23)
		if typeof(p23) == "table" then
			sound.__ReplayInvoke(table.unpack(p23, 1, table.maxn(p23)))

			return
		end
	end,
	Effect = function(list)
		if typeof(list) == "table" then
			if ReplayController_DEBUG_EVENTS then
				local v394 = list[1]
				local player = list[2]
				local v396 = typeof(v394) == "table" and tostring(v394.Name) or "?"
				local v397 = typeof(v394) == "table" and v394.Module or nil
				local v398 = typeof(player) == "table" and player.Character or nil
				local s1 = "no Character in data"
				local n1 = -1

				if typeof(v398) == "Instance" then
					local ok, result = pcall(function()
						return v398:GetPivot().Position
					end)

					local CurrentCamera: Camera = workspace.CurrentCamera

					if ok then
						local stringFormat = string.format
						local v405 = v398.Name
						local text: string = tostring(result)

						s1 = stringFormat("%s @ %s", v405, text)

						if CurrentCamera then
							n1 = (CurrentCamera.CFrame.Position - result).Magnitude
						end
					end
				end

				local v407 = v397 and v397:GetFullName() or "MISSING"

				print(("[ReplayController] effect %s | module %s | subject %s | camDist %.0f"):format(v396, v407, s1, n1))
			end

			effect.__ReplayInvoke(list[1], list[2])

			if ReplayController_DEBUG_EVENTS then
				task.defer(function()
					local bin: Instance = workspace:FindFirstChild("Bin")
					local n1 = bin and #bin:GetChildren() or -1

					print(("[ReplayController]   -> workspace.Bin now has %d children"):format(n1))
				end)
			end

			return
		end
	end,
	Crosshair = function(list, p26)
		if typeof(list) == "table" then
			local v410 = t2[p26]

			if not v410 then
				return
			end

			crosshair.__ReplayInvoke(list[1], v410.synthId, list[3])

			return
		end
	end,
	AbilityEffect = function(p27)
		if u51 then
			return
		end

		abilityEffectClient.__ReplayInvoke(p27)
	end,
	FOV = function(list, p29)
		if typeof(list) == "table" then
			local v414 = t2[p29]

			if not v414 then
				return
			end

			fovController.__ReplayInvoke(list[1], v414.synthId, list[3])

			return
		end
	end
}

local function fireEvent(p37)
	if p37.etype == replayFormat.EV_ANIM_START then
		local v416 = t2[p37.actorSlot]

		if not v416 then
			return
		end

		local v417, v418, v419, v420, v421 = pcall(string.unpack, "<ffs2", p37.payload)

		if not v417 then
			return
		end

		local v422 = nil

		if typeof(v421) == "number" then
			local n1 = #p37.payload - v421 + 1

			if n1 >= 3 then
				local v424, v425, v426 = pcall(string.unpack, "<BH", p37.payload, v421)

				if v424 then
					v422 = v426
				end
			elseif n1 == 2 then
				local v427, v428, v429 = pcall(string.unpack, "<BB", p37.payload, v421)

				if v427 then
					v422 = v429
				end
			elseif n1 == 1 then
				local ok, result = pcall(string.unpack, "<B", p37.payload, v421)
			end
		end

		replayActors.PlayAnim(v416, v420, v418, v419, p37._loop, v422)

		return
	end

	if p37.etype == replayFormat.EV_ANIM_STOP then
		local v432 = t2[p37.actorSlot]

		if not v432 then
			return
		end

		local ok, result = pcall(string.unpack, "<s2", p37.payload)

		if ok then
			replayActors.StopAnim(v432, result)
		end

		return
	end

	if p37.etype == replayFormat.EV_DEATH then
		local v435 = t2[p37.targetSlot]

		if v435 and #p37.payload >= 12 then
			local v436, v437, v438, v439 = pcall(string.unpack, "<fff", p37.payload)

			if v436 then
				v435.deathDir = Vector3.new(v437, v438, v439)
			end
		end

		return
	end

	if p37.etype == replayFormat.EV_ROUND_START then
		for _, v in pairs(t2) do
			pcall(replayActors.MarkRoundBoundary, v)
		end

		return
	end

	local substring

	if p37.etype == replayFormat.EV_ATTR then
		local v444 = t2[p37.actorSlot]

		if not v444 or not v444.model then
			return
		end

		local v445, v446, v447 = pcall(string.unpack, "<s1", p37.payload)

		if not v445 then
			return
		end

		if t27[v446] then
			return
		end

		local replayCodecDecode = replayCodec.Decode
		local substring2 = p37.payload:sub(v447)
		local v450 = decodeCtx()

		substring = replayCodecDecode(substring2, v450)

		if typeof(substring) == "number" and replayFormat.IsTimeAttr(v446) then
			substring = workspace:GetServerTimeNow() + substring
		end

		pcall(function()
			v444.model:SetAttribute(v446, substring)
		end)

		return
	end

	if p37.etype ~= replayFormat.EV_REMOTE then
		return
	end

	local v451, v452, v453 = pcall(string.unpack, "<s1", p37.payload)

	if not v451 then
		return
	end

	local decode = replayCodec.Decode

	substring = p37.payload
	substring = substring:sub(v453)

	local v455 = decodeCtx()
	local v456 = decode(substring, v455)

	if v456 == nil then
		return
	end

	local v457 = u40

	if v457 then
		substring = v456
	end

	if v457 and typeof(substring) == "table" then
		substring = v456
		replayCodec.Rebase(substring, vectorValue - u40.origin)
	end

	v457 = u51

	if v457 then
		substring = t25
	end

	if v457 and substring[v452] then
		return
	end

	if u51 and t29.window ~= nil then
		substring = t29
		substring = substring.window
		substring = substring.startMs

		if p37.timeMs > substring and (v452 == "Crosshair" or v452 == "FOV") then
			return
		end
	end

	substring = t24

	if substring[v452] then
		if n6 == 3 then
			return
		end

		substring = n5

		if p37.actorSlot ~= substring then
			return
		end
	end

	local v458 = t30[v452]

	if v458 then
		substring = v456
		v458(substring, p37.actorSlot)

		return
	end

	v458 = t22[v452]

	if v458 then
		substring = v456

		if typeof(substring) == "table" then
			substring = t23

			local v459 = substring[v452]

			if v459 then
				substring = t2[p37.actorSlot]

				if not substring then
					return
				end

				v456[v459] = substring.synthId
			end

			local foundChild: Instance = bindables:FindFirstChild(v458)

			if foundChild then
				substring = foundChild:IsA("BindableEvent")

				if substring then
					foundChild:Fire(table.unpack(v456, 1, table.maxn(v456)))
				end
			end

			return
		end

		return
	end

	v458 = t26[v452]

	if not v458 then
		local v461 = t21[v452]

		if not v461 then
			local v462 = ReplayController_DEBUG_EVENTS

			if v462 then
				substring = t28
			end

			if v462 and not substring["unrouted:" .. v452] then
				substring = "unrouted:" .. v452
				t28[substring] = true
				substring = "[ReplayController] no route for remote %q -- captured but nothing plays it"
				warn(substring:format(v452))
			end

			return
		end

		substring = v456

		if typeof(substring) == "table" then
			local foundChild: Instance = bindables:FindFirstChild(v461)

			if foundChild then
				substring = foundChild:IsA("BindableEvent")

				if substring then
					substring = t2

					local v464 = substring[p37.actorSlot]

					if not v464 then
						substring = typeof
						substring = substring(v456.ownerUserId)

						if substring == "number" then
							substring = t6[v456.ownerUserId]

							if substring then
								v464 = t2[substring]
							end
						end
					end

					if v464 then
						substring = v464.synthId
						v456.ownerUserId = substring
					end

					if v452 == "GlobalKillFeed" then
						substring = rewriteGlobalKillFeed
						substring(v456)
					end

					foundChild:Fire(v456)

					return
				end
			end

			substring = ReplayController_DEBUG_EVENTS

			if substring then
				substring = t28["nobindable:" .. v461]

				if not substring then
					substring = t28
					substring["nobindable:" .. v461] = true
					substring = warn
					substring(("[ReplayController] Bindables.%s missing -- %q cannot be replayed"):format(v461, v452))
				end
			end

			return
		end

		return
	end

	if u51 then
		return
	end

	substring = v456

	if typeof(substring) == "table" then
		local foundChild: Instance = bindables:FindFirstChild(v458)

		if foundChild then
			substring = foundChild:IsA("BindableEvent")

			if substring then
				foundChild:Fire(v456, (p37.timeMs or 0) / 1000)
			end
		end

		return
	end
end
local function eventLabel(p38)
	local _label = p38._label

	if _label then
		return _label
	end

	local s1 = "type" .. tostring(p38.etype)

	if p38.etype == replayFormat.EV_REMOTE then
		local ok, result = pcall(string.unpack, "<s1", p38.payload)

		s1 = ok and "remote:" .. result or "remote:?"
	elseif p38.etype == replayFormat.EV_ATTR then
		local ok, result = pcall(string.unpack, "<s1", p38.payload)

		s1 = ok and "attr:" .. result or "attr:?"
	elseif p38.etype == replayFormat.EV_ANIM_START then
		s1 = "anim:start"
	elseif p38.etype == replayFormat.EV_ANIM_STOP then
		s1 = "anim:stop"
	end

	p38._label = s1

	return s1
end
local function fireEventSafe(p39)
	local v474 = eventLabel(p39)

	debug.profilebegin(v474)

	local v475 = os.clock()
	local ok, result = pcall(fireEvent, p39)
	local v478 = ReplayController_Perf
	local ev = v478.ev
	local v480 = v478.ev[v474] or 0
	local v481 = os.clock()

	ev[v474] = v480 + (v481 - v475) * 1000
	v478.evN[v474] = (v478.evN[v474] or 0) + 1
	debug.profileend()

	if not not ok or not ReplayController_DEBUG_EVENTS then
		return
	end

	local text: string = tostring(result)

	v478 = v474 .. "|" .. text

	if t28[v478] then
		return
	end

	t28[v478] = true

	local v483 = p39.timeMs or -1
	local text2: string = tostring(result)

	warn(("[ReplayController] %s failed at %dms: %s"):format(v474, v483, text2))
end

local t31: {[any]: any} = {
	remoteName = function(p30)
		local v486 = p30._rmName

		if v486 == nil then
			local v487, v488, v489 = pcall(string.unpack, "<s1", p30.payload)

			if v487 and typeof(v488) == "string" then
				p30._rmOff = v489
				v486 = v488
			else
				v486 = false
			end

			p30._rmName = v486
		end

		return v486 or nil
	end,
	remoteArgs = function(p31, p32)
		local _rmArgs = p31._rmArgs

		if _rmArgs == nil then
			local _rmOff = p31._rmOff

			if _rmOff == nil then
				return nil
			end

			local u494: boolean = false

			local object = setmetatable({}, {
				__index = function(_, p34)
					u494 = true

					return p32[p34]
				end
			})

			local replayCodecDecode = replayCodec.Decode
			local substring = p31.payload:sub(_rmOff)
			local ok, result = pcall(replayCodecDecode, substring, object)
			local v500 = ok and typeof(result) == "table" and result or nil

			if ok and not u494 then
				p31._rmArgs = v500 or false
			end

			return v500
		end

		return _rmArgs or nil
	end
}

local function matchStateSnapshotAt(p40)
	local t40: {[any]: any} = { t = "ReplaySync", scoreA = 0, scoreB = 0, frozenLeft = 0 }

	if not u40 then
		return t40
	end

	local v503 = decodeCtx()

	for _, v in ipairs(u40.events) do
		if p40 < v.timeMs then
			break
		end

		if v.etype == replayFormat.EV_REMOTE and t31.remoteName(v) == "MatchState" then
			local v506 = t31.remoteArgs(v, v503)

			if v506 ~= nil then
				local n1 = v.timeMs / 1000

				if typeof(v506.scoreA) == "number" and typeof(v506.scoreB) == "number" then
					local scoreB = v506.scoreB

					t40.scoreA = v506.scoreA
					t40.scoreB = scoreB
				end

				if typeof(v506.roundsToWin) == "number" then
					t40.roundsToWin = v506.roundsToWin
				end

				local t = v506.t

				if t == "MatchStarted" then
					t40.scoreA = 0
					t40.scoreB = 0
					t40.endAt = nil
				elseif t == "SkillSelect" then
					local numberValue: number? = tonumber(v506.seconds)

					t40.endAt = n1 + (numberValue or 1) + 3
				elseif t == "RoundLive" then
					local numberValue: number? = tonumber(v506.roundSeconds)

					t40.endAt = n1 + (numberValue or 180)
				elseif t == "RoundEnded" or t == "MatchEnded" then
					t40.frozenLeft = typeof(t40.endAt) == "number" and math.max(0, t40.endAt - n1) or 0
					t40.endAt = nil
				end
			end
		end
	end

	return t40
end
local function pushMatchStateSnapshot()
	if not not u51 or not u40 then
		return
	end

	local replayMatchState: Instance = bindables:FindFirstChild("ReplayMatchState")

	if not replayMatchState or not replayMatchState:IsA("BindableEvent") then
		return
	end

	local ok, result = pcall(matchStateSnapshotAt, n3)

	if not ok then
		return
	end

	replayMatchState:Fire(result, n3 / 1000)
end

local t32: {[any]: any} = { "1", "2" }

local function abilityPanelSnapshotAt(p41, p42)
	if not u40 then
		return nil
	end

	local t41: {[any]: any} = {}
	local t42: {[any]: any} = { ["1"] = 0, ["2"] = 0 }
	local t43: {[any]: any} = {}
	local u520: boolean = false
	local v521 = decodeCtx()

	for _, v in ipairs(u40.events) do
		if p41 < v.timeMs then
			break
		end

		if v.etype == replayFormat.EV_REMOTE and p42 == v.actorSlot and t31.remoteName(v) == "AbilityPanel" then
			local v524 = t31.remoteArgs(v, v521)

			if v524 ~= nil then
				local v525 = v524[1]
				local v526 = v524[2]

				if typeof(v526) == "table" then
					u520 = true

					if v525 == "Snapshot" then
						t41 = {}
						local equipped = v526.Equipped

						for _, iterValue in ipairs(t32) do
							local v530 = typeof(equipped) == "table" and equipped[iterValue] or nil

							t41[iterValue] = typeof(v530) == "string" and v530 ~= "" and v530 or nil
						end

						local cooldownRemaining = v526.CooldownRemaining

						for _, iterValue2 in ipairs(t32) do
							local v534 = typeof(cooldownRemaining) == "table" and cooldownRemaining[iterValue2] or nil

							t42[iterValue2] = typeof(v534) == "number" and v534 > 0 and v.timeMs + v534 * 1000 or 0
						end

						t43 = {}
						local pendingSlots = v526.PendingSlots

						if typeof(pendingSlots) == "table" then
							for _, iterValue3 in ipairs(t32) do
								if pendingSlots[iterValue3] then
									t43[iterValue3] = true
								end
							end
						end
					elseif v525 == "Cooldown" then
						local slot = v526.slot

						if slot == "1" or slot == "2" then
							local v539 = typeof(v526.cooldownDuration) == "number" and v526.cooldownDuration or 0

							t42[slot] = v539 > 0 and v.timeMs + v539 * 1000 or 0
							t43[slot] = nil

							if t41[slot] == nil and typeof(v526.abilityId) == "string" and v526.abilityId ~= "" then
								t41[slot] = v526.abilityId
							end
						end
					elseif v525 == "Pending" then
						local v540 = v526.slot

						if v540 == "1" or v540 == "2" then
							t43[v540] = true

							if t41[v540] == nil and typeof(v526.abilityId) == "string" and v526.abilityId ~= "" then
								t41[v540] = v526.abilityId
							end
						end
					end
				end
			end
		end
	end

	if not u520 then
		return nil
	end

	v521 = {}

	for _, v in ipairs(t32) do
		v521[v] = math.max(0, (t42[v] - p41) / 1000)
	end

	return {
		Unlocked = {},
		Equipped = t41,
		CooldownRemaining = v521,
		PendingSlots = t43
	}
end
local function pushAbilityPanelSnapshot()
	if not u40 then
		return
	end

	local replayAbilityPanel: Instance = bindables:FindFirstChild("ReplayAbilityPanel")

	if not replayAbilityPanel or not replayAbilityPanel:IsA("BindableEvent") then
		return
	end

	local ok, result = pcall(abilityPanelSnapshotAt, n3, n5)

	if ok and result ~= nil then
		replayAbilityPanel:Fire("Snapshot", result)

		return
	end
end
function t31.snapshotsAt(p43, p44)
	local t44: {[any]: any} = {}
	local t45: {[any]: any} = {}

	if not u40 then
		return t44, t45
	end

	local v550 = decodeCtx()

	for _, v in ipairs(u40.events) do
		if p43 < v.timeMs then
			break
		end

		if v.etype == replayFormat.EV_REMOTE and (p44 == nil or p44 == v.actorSlot) then
			local v553 = t31.remoteName(v)

			if v553 == "Crosshair" or v553 == "FOV" then
				local v554 = t31.remoteArgs(v, v550)

				if v554 ~= nil and v554[1] == "PatchFrom" then
					local v555 = v554[3]

					if typeof(v555) == "table" then
						if v553 ~= "FOV" then
							local t46 = t44[v.actorSlot]

							if not t46 then
								t46 = {
									Enabled = true,
									Aiming = false,
									Spread = 0,
									IsGun = false,
									ADS = "",
									TwoHanded = false,
									ReloadingDuration = 2,
									AmmoCount = 0,
									_reloadStartMs = nil,
									AmmoTint = Color3.new(1, 1, 1)
								}
								t44[v.actorSlot] = t46
							end

							if v555.Enabled ~= nil then
								t46.Enabled = v555.Enabled == true
							end

							if v555.Aiming ~= nil then
								t46.Aiming = v555.Aiming == true
							end

							if v555.IsGun ~= nil then
								t46.IsGun = v555.IsGun == true
							end

							if v555.TwoHanded ~= nil then
								t46.TwoHanded = v555.TwoHanded == true
							end

							if v555.ADS ~= nil then
								t46.ADS = typeof(v555.ADS) == "string" and v555.ADS or ""
							end

							if typeof(v555.Spread) == "number" then
								t46.Spread = v555.Spread
							end

							if typeof(v555.AmmoCount) == "number" then
								t46.AmmoCount = v555.AmmoCount
							end

							if typeof(v555.AmmoTint) == "Color3" then
								t46.AmmoTint = v555.AmmoTint
							end

							if typeof(v555.ReloadingDuration) == "number" and v555.ReloadingDuration > 0 then
								t46.ReloadingDuration = v555.ReloadingDuration
							end

							if typeof(v555.Reloading) == "number" then
								t46._reloadStartMs = v555.Reloading > 0 and v.timeMs or nil
							end
						elseif typeof(v555.offsets) == "table" then
							t45[v.actorSlot] = v555.offsets
						end
					end
				end
			end
		end
	end

	v550 = workspace:GetServerTimeNow()

	for _, v in pairs(t44) do
		local v_reloadStartMs = v._reloadStartMs

		v._reloadStartMs = nil

		local n1 = v_reloadStartMs and (p43 - v_reloadStartMs) / 1000 or nil

		if n1 and n1 < v.ReloadingDuration then
			v.Reloading = v550 - n1
		else
			v.Reloading = 0
		end
	end

	return t44, t45
end
function t31.push(p45)
	if not u40 then
		return
	end

	local v562, v563, v564 = pcall(t31.snapshotsAt, n3, p45)

	if v562 and typeof(v563) == "table" then
		local v565 = crosshair

		for k, v in pairs(v563) do
			local v568 = t2[k]

			if v568 then
				pcall(v565.__ReplayInvoke, "Snapshot", v568.synthId, v)
			end
		end

		if typeof(v564) == "table" then
			local v569 = fovController

			for k, v in pairs(v564) do
				local v572 = t2[k]

				if v572 then
					local __ReplayInvoke = v569.__ReplayInvoke
					local synthId = v572.synthId
					local v575 = table.clone(v)

					pcall(__ReplayInvoke, "Snapshot", synthId, { tweenTime = 0, offsets = v575 })
				end
			end

			return
		end

		return
	end
end

local u145 = nil
local t33: {[any]: any} = {}

u127 = function(p46)
	if typeof(p46) == "number" and not (p46 <= 0) then
		local v577 = t6[p46]

		if v577 == nil then
			return nil
		end

		return t33[v577]
	end

	return nil
end

local function destroyRoster()
	botPlayers.SetOverride(replayActors.MATCH_ID, nil)
	botPlayers.SetMatchNode(replayActors.MATCH_ID, nil)
	t33 = {}

	if u145 then
		pcall(function()
			u145:Destroy()
		end)
		u145 = nil
	end
end
local function buildRoster()
	destroyRoster()

	if not u40 then
		return
	end

	local replayRoster: Folder = Instance.new("Folder")

	replayRoster.Name = "ReplayRoster"
	replayRoster.Parent = replicatedStorage
	u145 = replayRoster

	local t47: {[any]: any} = {}

	for _, v in ipairs(u40.participants) do
		local folder: Folder = Instance.new("Folder")

		folder.Name = "Slot" .. tostring(v.slot)

		local typeName: string = typeof(v.userId)

		folder:SetAttribute("UserId", typeName == "number" and v.userId > 0 and v.userId or -1)
		folder:SetAttribute("DisplayName", v.displayName)
		folder:SetAttribute("BotName", v.displayName)
		folder:SetAttribute("MatchId", replayActors.MATCH_ID)
		folder:SetAttribute("InMatch", true)
		folder:SetAttribute("MatchSide", if v.side == 0 then "A" else "B")

		if typeof(v.device) == "string" and v.device ~= "" then
			folder:SetAttribute("Device", v.device)
		end

		if typeof(v.crosshair) == "string" and v.crosshair ~= "" then
			folder:SetAttribute("Crosshair", v.crosshair)
		end

		folder:SetAttribute("MatchKills", 0)
		folder:SetAttribute("MatchDeaths", 0)
		folder:SetAttribute("MatchAssists", 0)
		folder:SetAttribute("Alive", true)
		folder.Parent = replayRoster
		t33[v.slot] = folder
		table.insert(t47, botPlayers.NewProxy(folder))
	end

	botPlayers.SetOverride(replayActors.MATCH_ID, t47)
	t47 = { [0] = 0, 0 }

	for _, v in ipairs(u40.participants) do
		local n1: number = if v.side == 0 then 0 else 1

		t47[n1] = t47[n1] + 1
	end

	local v587 = math.max(t47[0], t47[1], 1)

	replayRoster:SetAttribute("TeamSize", v587)
	replayRoster:SetAttribute("MapName", u40.mapName or "")
	botPlayers.SetMatchNode(replayActors.MATCH_ID, replayRoster)
end
local function updateRoster()
	if u40 and u145 ~= nil then
		local t48: {[any]: any} = {}
		local t49: {[any]: any} = {}
		local t50: {[any]: any} = {}

		for _, v in ipairs(u40.markers) do
			if v.timeMs <= n3 and v.kind == replayFormat.MK_KILL then
				if v.actorSlot ~= replayFormat.NO_SLOT then
					t48[v.actorSlot] = (t48[v.actorSlot] or 0) + 1
				end

				if v.targetSlot ~= replayFormat.NO_SLOT then
					t49[v.targetSlot] = (t49[v.targetSlot] or 0) + 1
				end

				for _, iterValue in ipairs(v.assistSlots or {}) do
					if iterValue ~= replayFormat.NO_SLOT then
						t50[iterValue] = (t50[iterValue] or 0) + 1
					end
				end
			end
		end

		for k, v in pairs(t33) do
			local v597 = u40:stateAt(n3, k)

			if v597 then
				local u598: boolean = bit32.band(v597.sflags, replayFormat.S_ALIVE) ~= 0

				if u598 ~= v:GetAttribute("Alive") then
					v:SetAttribute("Alive", u598)
				end
			end

			v597 = t48[k] or 0

			if v:GetAttribute("MatchKills") ~= v597 then
				v:SetAttribute("MatchKills", v597)
			end

			v597 = t49[k] or 0

			if v:GetAttribute("MatchDeaths") ~= v597 then
				v:SetAttribute("MatchDeaths", v597)
			end

			v597 = t50[k] or 0

			if v:GetAttribute("MatchAssists") ~= v597 then
				v:SetAttribute("MatchAssists", v597)
			end
		end

		return
	end
end
local function stepEvents(_, p48)
	if not u40 then
		return
	end

	local n1 = n3 - n17
	local u602: boolean = true

	if not (n1 < -400) then
		u602 = n1 > (p48 or 0) + 400
	end

	if u602 then
		debug.profilebegin("RC seekFold")
		ReplayController_Perf.folded = #u40.events

		for _, v in pairs(t2) do
			replayActors.ResetForSeek(v)
		end

		if t2[n5] then
			local parkourCameraTotalOffsetY = parkourCamera.TotalOffsetY
			local replayActorsParkour_names = replayActors.PARKOUR_NAMES
			local v607 = u40:stateAt(n3, n5)

			n7 = parkourCameraTotalOffsetY(replayActorsParkour_names[v607.state])
		end

		n18 = 1

		local t51: {[any]: any} = {}
		local t52: {[any]: any} = {}
		local t53: {[any]: any} = {}
		local t54: {[any]: any} = {}
		local t55: {[any]: any} = {}

		for i, v in ipairs(u40.events) do
			if v.timeMs > n3 then
				break
			end

			n18 = i + 1

			local vEtype = v.etype

			if vEtype == replayFormat.EV_ANIM_START or vEtype == replayFormat.EV_ANIM_STOP or vEtype == replayFormat.EV_ATTR then
				local v616 = v._seekKey

				if v616 == nil then
					v616 = false

					if vEtype == replayFormat.EV_ANIM_START then
						local v617, v618, v619, v620 = pcall(string.unpack, "<ffs2", v.payload)

						if v617 and typeof(v620) == "string" then
							v616 = tostring(v.actorSlot) .. "\000" .. v620
						end
					elseif vEtype == replayFormat.EV_ANIM_STOP then
						local ok, result = pcall(string.unpack, "<s2", v.payload)

						if ok and typeof(result) == "string" then
							v616 = tostring(v.actorSlot) .. "\000" .. result
						end
					else
						local ok, result = pcall(string.unpack, "<s1", v.payload)

						if ok then
							v616 = tostring(v.actorSlot) .. "\000" .. result
						end
					end

					v._seekKey = v616
				end

				if v616 then
					if vEtype == replayFormat.EV_ANIM_START then
						if not t54[v616] then
							t54[v616] = true
							table.insert(t53, v616)
						end

						t55[v616] = v
					elseif vEtype == replayFormat.EV_ANIM_STOP then
						t55[v616] = nil
					else
						if t52[v616] == nil then
							table.insert(t51, v616)
						end

						t52[v616] = v
					end
				end
			end
		end

		for _, v in ipairs(t53) do
			local v627 = t55[v]

			if v627 then
				fireEventSafe(v627)
			end
		end

		for _, v in ipairs(t51) do
			fireEventSafe(t52[v])
		end

		pushMatchStateSnapshot()
		pushAbilityPanelSnapshot()
		t31.push()
		debug.profileend()
	elseif n3 > n17 then
		local events = u40.events

		while n18 <= #events do
			local v631 = events[n18]

			if v631.timeMs > n3 then
				break
			end

			if v631.timeMs > n17 then
				fireEventSafe(v631)
			end

			n18 += 1
		end
	end

	n17 = n3
end

local u151 = nil
local u152 = nil
local u153 = nil

local function clearFirstPersonHidden()
	if u151 then
		replayActors.SetFirstPersonHidden(u151, false)
		u151 = nil
	end

	for _, v in pairs(t2) do
		if v.fpHidden then
			replayActors.SetFirstPersonHidden(v, false)
		end
	end
end
local function setCamMode(p49)
	if p49 == n6 then
		return
	end

	local u635: boolean = n6 == 3

	n6 = p49
	u152 = nil
	u153 = nil

	if u635 ~= (p49 == 3) then
		applySpectateAttribute()
	end
end
local function stepParkourCamY(p50, p51)
	local v638 = parkourCamera.TotalOffsetY(replayActors.PARKOUR_NAMES[p50])
	local n1 = p51 * (playerState.ReplayTimeScale or 1)

	if n1 > 0 then
		local v640 = n7
		local n2 = v638 - n7
		local v642 = math.exp(-n1 / 0.075)

		n7 = v640 + n2 * (1 - v642)
	end

	return n7
end
local function knifeVictimPos(p52)
	if not u40 or not t29.victimSlot then
		return nil
	end

	local v644 = u40:stateAt(p52 - n11, t29.victimSlot)
	local v645 = vectorValue
	local vector3 = Vector3.new(v644.x, v644.y + t29.VICTIM_Y, v644.z)

	return v645 + vector3
end
local function knifeBladePos(p53)
	local v648 = vectorValue
	local v649 = knifeCamPath.PositionAt(t29.flight, p53)

	return v648 + v649
end
local function chooseKnifeCamOffset()
	local v650 = knifeCamPath.Sample(t29.flight, t29.PROBES)
	local v651

	if u40 and t29.victimSlot then
		local v652 = u40:stateAt(t29.flight.impactMs - n11, t29.victimSlot)
		local v653 = vectorValue
		local vector3 = Vector3.new(v652.x, v652.y + t29.VICTIM_Y, v652.z)

		v651 = v653 + vector3
	else
		v651 = nil
	end

	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Include
	raycastParams.FilterDescendantsInstances = if mapRoot then { mapRoot } else {}

	local v656 = OverlapParams.new()

	v656.FilterType = Enum.RaycastFilterType.Include
	v656.FilterDescendantsInstances = if mapRoot then { mapRoot } else {}
	v656.MaxParts = 1

	local function toWorld(p54)
		local n1 = t29.right * p54.X
		local vector3 = Vector3.new(0, p54.Y, 0)

		return n1 + vector3 - t29.fwd * p54.Z
	end

	local v658 = nil
	local n1: number = -math.huge

	for _, v in ipairs(t29.BACK) do
		for _, iterValue in ipairs(t29.LATERAL) do
			for _, iterValue2 in ipairs(t29.HEIGHT) do
				for _, iterValue3 in ipairs({ 1, -1 }) do
					local vector3 = Vector3.new(iterValue * iterValue3, iterValue2, v)
					local n2 = t29.right * vector3.X
					local vector32 = Vector3.new(0, vector3.Y, 0)
					local n3 = n2 + vector32 - t29.fwd * vector3.Z
					local n4: number = 0

					for _, iterValue4 in ipairs(v650) do
						local n5 = vectorValue + iterValue4
						local n6 = n5 + n3

						n4 = if workspace:Raycast(n5, n6 - n5, raycastParams) then n4 - 2 else n4 + 2

						if #workspace:GetPartBoundsInRadius(n6, 1.2, v656) > 0 then
							n4 -= 5
						end
					end

					if v651 and not workspace:Raycast(vectorValue + t29.flight.impact + n3, v651 - (vectorValue + t29.flight.impact + n3), raycastParams) then
						n4 += 8
					end

					if n1 < n4 then
						n1 = n4
						v658 = n3
					end
				end
			end
		end
	end

	local n7 = v658

	if not n7 then
		local vector33 = Vector3.new(t29.LATERAL[1], t29.HEIGHT[1], t29.BACK[1])
		local n8 = t29.right * vector33.X
		local vector34 = Vector3.new(0, vector33.Y, 0)

		n7 = n8 + vector34 - t29.fwd * vector33.Z
	end

	return n7
end
local function setupKnifeCam(p55)
	t29.flight = nil
	t29.offset = nil
	t29.victimSlot = nil
	t29.engaged = false

	if t29.window == nil then
		return
	end

	if typeof(p55) == "table" and typeof(p55.victimSlot) == "number" then
		if LocalPlayer:GetAttribute("KnifeKillcam") == false then
			t29.window = nil

			return
		end

		t29.victimSlot = p55.victimSlot

		local ok, result = pcall(knifeCamPath.Solve, u40, {
			killMs = n10,
			killerSlot = n5,
			victimSlot = p55.victimSlot,
			rewindMs = n11
		})

		if ok and result then
			t29.flight = result

			local n1 = result.impact - result.origin

			n1 = Vector3.new(n1.X, 0, n1.Z)

			if n1.Magnitude < 0.001 then
				n1 = Vector3.new(0, 0, 1)
			end

			t29.fwd = n1.Unit
			t29.right = t29.fwd:Cross(Vector3.new(0, 1, 0)).Unit

			local ok2, result2 = pcall(chooseKnifeCamOffset)

			t29.offset = ok2 and result2 or t29.right * 3 + Vector3.new(0, 1.4, 0) - t29.fwd * 6

			local resultDistance = result.distance
			local resultThrowMs = result.throwMs
			local resultImpactMs = result.impactMs
			local text: string = tostring(t29.offset)

			warn(("[ReplayController] knife cam armed: %.0f studs, %d..%dms, offset %s"):format(resultDistance, resultThrowMs, resultImpactMs, text))

			return
		end

		warn("[ReplayController] server sent a knife cam this client could not solve -- skipping")
		t29.window = nil
		t29.victimSlot = nil

		return
	end

	t29.window = nil
end
local function knifeCamActive()
	local flight = t29.flight

	return flight ~= nil and t29.offset ~= nil and n3 >= flight.throwMs - t29.LEAD_MS and n3 <= flight.impactMs + t29.HOLD_MS
end
local function smoothstep01(p56)
	local v693 = math.clamp(p56, 0, 1)

	return v693 * v693 * (3 - v693 * 2)
end
local function firstPersonCF(p57, p58)
	if not u40 then
		return nil
	end

	local u696: boolean = p57 ~= nil and p57.root ~= nil

	if not u696 then
		local v697: number = n5
		local v698

		if not u40 then
			v698 = nil
		else
			local v699, v700, v701 = ipairs(u40.participants)
			local v702: boolean = false

			for iterFirst, iterSecond in v699, v700, v701 do
				if v697 == iterSecond.slot then
					v698 = iterSecond
					v702 = true

					break
				end
			end

			if not v702 then
				v698 = nil
			end
		end

		if not v698 then
			return nil
		end
	end

	local v705 = u40:stateAt(n3, n5)
	local v706 = if u696 then p57.root.CFrame else CFrame.new(vectorValue + Vector3.new(v705.x, v705.y, v705.z)) * CFrame.fromEulerAnglesYXZ(v705.bodyPitch or 0, v705.camYaw, v705.bodyRoll or 0)
	local n1 = v706.Position + v706.UpVector * parkourCamera.EYE_HEIGHT
	local v708 = parkourCamera.TotalOffsetY(replayActors.PARKOUR_NAMES[v705.state])
	local n2 = p58 * (playerState.ReplayTimeScale or 1)

	if n2 > 0 then
		local v710 = n7
		local n4 = v708 - n7
		local v712 = math.exp(-n2 / 0.075)

		n7 = v710 + n4 * (1 - v712)
	end

	local vector3 = Vector3.new(0, n7, 0)
	local cFrame2 = CFrame.new(n1 + vector3)
	local v715 = CFrame.Angles(0, v705.camYaw, 0)
	local v716 = CFrame.Angles(v705.pitch, 0, 0)

	return cFrame2 * v715 * v716
end
local function applyKnifeCamera(p59, p60)
	local offset = t29.offset
	local flight = t29.flight

	if not t29.engaged then
		t29.engaged = true
		clearFirstPersonHidden()
		u152 = nil
		u153 = nil
	end

	p59.CameraType = Enum.CameraType.Scriptable

	local v721 = math.clamp(n3, flight.throwMs, flight.impactMs)
	local v722 = vectorValue
	local v723 = knifeCamPath.PositionAt(t29.flight, v721)
	local n1 = v722 + v723

	v722 = math.min(n3, flight.impactMs)

	local v725

	if not u40 or not t29.victimSlot then
		v725 = nil
	else
		local v726 = u40:stateAt(v722 - n11, t29.victimSlot)
		local v727 = vectorValue
		local vector3 = Vector3.new(v726.x, v726.y + t29.VICTIM_Y, v726.z)

		v725 = v727 + vector3
	end

	v722 = math.max(flight.impactMs - flight.throwMs, 1)
	v723 = math.clamp((n3 - flight.throwMs) / v722, 0, 1)
	v722 = math.clamp((n3 - flight.impactMs) / t29.HOLD_MS, 0, 1)

	local n2 = t29.PULLBACK - 1
	local v730 = math.clamp(v722, 0, 1)
	local vector3 = Vector3.new(0, v722 * 1.2, 0)
	local n8 = n1 + offset * (1 + n2 * (v730 * v730 * (3 - v730 * 2))) + vector3
	local n4 = n1

	if v725 then
		local v734 = math.clamp(v723, 0, 1)
		local v735 = math.clamp(v722, 0, 1)

		n4 = n1:Lerp(v725, v734 * v734 * (3 - v734 * 2) * 0.45 + 0.3 + v735 * v735 * (3 - v735 * 2) * 0.25)
	end

	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Include
	raycastParams.FilterDescendantsInstances = if mapRoot then { mapRoot } else {}
	v721 = workspace:Raycast(n1, n8 - n1, raycastParams)

	if v721 then
		n8 = v721.Position + (n1 - n8).Unit * 0.5
	end

	v723 = CFrame.lookAt(n8, n4)
	n4 = firstPersonCF(t2[n5], p60)

	if n4 then
		if n3 < flight.throwMs then
			local v737 = math.clamp((n3 - (flight.throwMs - t29.LEAD_MS)) / t29.LEAD_MS, 0, 1)

			v723 = n4:Lerp(v723, v737 * v737 * (3 - v737 * 2))
		elseif v722 > 1 - t29.HANDOFF then
			local v738 = math.clamp((v722 - (1 - t29.HANDOFF)) / t29.HANDOFF, 0, 1)

			v723 = v723:Lerp(n4, v738 * v738 * (3 - v738 * 2))
		end
	else
		local v739 = parkourCamera.TotalOffsetY(replayActors.PARKOUR_NAMES[0])
		local n9 = p60 * (playerState.ReplayTimeScale or 1)

		if n9 > 0 then
			local v741 = n7
			local n6 = v739 - n7
			local v743 = math.exp(-n9 / 0.075)

			n7 = v741 + n6 * (1 - v743)
		end
	end

	p59.CFrame = v723
	p59.Focus = v723 * CFrame.new(0, 0, -20)
	playerState.CameraFirstPerson = false

	return true
end
local function applyCamera(p61)
	local CurrentCamera: Camera = workspace.CurrentCamera

	if not CurrentCamera then
		return
	end

	local vectorValue2
	local isKeyDown
	local v748
	local v749
	local n12
	local cFrameNew
	local cFramePosition
	local v753
	local v754
	local v755
	local cFrame2
	local n15
	local v758
	local n16
	local v760
	local n4
	local v762
	local vector3
	local cFrame3
	local v765
	local v766
	local v767
	local v768
	local n17
	local v769
	local n18
	local v771
	local n19
	local v773
	local vector4
	local v775
	local n8
	local v777
	local cFrame4
	local v779
	local v780
	local n9
	local n10
	local raycastParams
	local v784
	local v785
	local v786: boolean = false

	if u51 then
		local flight = t29.flight

		if flight ~= nil and t29.offset ~= nil and n3 >= flight.throwMs - t29.LEAD_MS and n3 <= flight.impactMs + t29.HOLD_MS then
			if applyKnifeCamera(CurrentCamera, p61) then
				return
			end

			v786 = true
		end
	end

	if not v786 then
		if t29.engaged then
			t29.engaged = false
		end
	end

	if n6 == 3 then
		if u152 ~= 3 then
			u152 = 3
			u153 = nil
			clearFirstPersonHidden()
		end

		CurrentCamera.CameraType = Enum.CameraType.Scriptable

		local vectorValue2 = Vector3.new(0, 0, 0)

		if inputMap.isPhysicallyDown("MoveForward") then
			vectorValue2 += Vector3.new(0, 0, -1)
		end

		if inputMap.isPhysicallyDown("MoveBackward") then
			vectorValue2 += Vector3.new(0, 0, 1)
		end

		if inputMap.isPhysicallyDown("MoveLeft") then
			vectorValue2 += Vector3.new(-1, 0, 0)
		end

		if inputMap.isPhysicallyDown("MoveRight") then
			vectorValue2 += Vector3.new(1, 0, 0)
		end

		if userInputService:IsKeyDown(Enum.KeyCode.E) then
			vectorValue2 += Vector3.new(0, 1, 0)
		end

		if userInputService:IsKeyDown(Enum.KeyCode.Q) then
			vectorValue2 += Vector3.new(0, -1, 0)
		end

		local isKeyDown = userInputService:IsKeyDown(Enum.KeyCode.LeftShift)
		local v748 = CFrame.Angles(0, n13, 0)
		local v749 = CFrame.Angles(n14, 0, 0)
		local n12 = v748 * v749

		if vectorValue2.Magnitude > 0 then
			local cFrameNew = CFrame.new
			local cFramePosition = cFrame.Position
			local v753 = n12:VectorToWorldSpace(vectorValue2.Unit)

			cFrame = cFrameNew(cFramePosition + v753 * (if isKeyDown then 260 else 90) * p61)
		end

		CurrentCamera.CFrame = CFrame.new(cFrame.Position) * n12
		CurrentCamera.Focus = CurrentCamera.CFrame * CFrame.new(0, 0, -20)
		playerState.CameraFirstPerson = false

		return
	end

	local v754 = t2[n5]

	if v754 and v754.root then
		if n6 == 2 and (n6 ~= 2 or v754.released ~= true) then
			if u152 ~= 2 or u153 ~= v754.model then
				u152 = 2
				u153 = v754.model
				clearFirstPersonHidden()
				replayActors.SetFirstPersonHidden(v754, true)
				u151 = v754
			end

			CurrentCamera.CameraType = Enum.CameraType.Scriptable

			local v755 = u40:stateAt(n3, n5)
			local cFrame2 = v754.root.CFrame
			local n15 = cFrame2.Position + cFrame2.UpVector * parkourCamera.EYE_HEIGHT
			local v758 = parkourCamera.TotalOffsetY(replayActors.PARKOUR_NAMES[v755.state])
			local n16 = p61 * (playerState.ReplayTimeScale or 1)

			if n16 > 0 then
				local v760 = n7
				local n4 = v758 - n7
				local v762 = math.exp(-n16 / 0.075)

				n7 = v760 + n4 * (1 - v762)
			end

			local vector3 = Vector3.new(0, n7, 0)
			local cFrame3 = CFrame.new(n15 + vector3)
			local v765 = CFrame.Angles(0, v755.camYaw, 0)
			local v766 = CFrame.Angles(v755.pitch, 0, 0)

			CurrentCamera.CFrame = cFrame3 * v765 * v766
			CurrentCamera.Focus = CurrentCamera.CFrame
			playerState.CameraFirstPerson = true

			return
		end

		if u152 ~= 1 or u153 ~= v754.model then
			u152 = 1
			u153 = v754.model
			clearFirstPersonHidden()
			n1 = 0
			n2 = 0
		end

		CurrentCamera.CameraType = Enum.CameraType.Scriptable

		local v767 = u40:stateAt(n3, n5)
		local n11

		if v754.released == true and v754.torso and v754.torso.Parent then
			n11 = v754.torso.Position + Vector3.new(0, 1.2, 0)
		else
			local v768 = v754.root.CFrame
			local n17 = v768.Position + v768.UpVector * parkourCamera.EYE_HEIGHT
			local v769 = parkourCamera.TotalOffsetY(replayActors.PARKOUR_NAMES[v767.state])
			local n18 = p61 * (playerState.ReplayTimeScale or 1)

			if n18 > 0 then
				local v771 = n7
				local n19 = v769 - n7
				local v773 = math.exp(-n18 / 0.075)

				n7 = v771 + n19 * (1 - v773)
			end

			local vector4 = Vector3.new(0, n7, 0)

			n11 = n17 + vector4
		end

		if not u65 then
			local v775 = math.exp(-p61 / 0.45)

			n1 *= v775
			n2 *= v775
		end

		local n8 = v767.camYaw + n1
		local v777 = math.clamp(v767.pitch + n2, -1.3, 1.3)
		local cFrame4 = CFrame.new(n11)
		local v779 = CFrame.Angles(0, n8, 0)
		local v780 = CFrame.Angles(v777, 0, 0)
		local n9 = cFrame4 * v779 * v780
		local n10 = n11 - n9.LookVector * 9 + n9.RightVector * 2.6
		local raycastParams = RaycastParams.new()

		raycastParams.FilterType = Enum.RaycastFilterType.Include
		raycastParams.FilterDescendantsInstances = if mapRoot then { mapRoot } else {}

		local v784 = workspace:Raycast(n11, n10 - n11, raycastParams)

		if v784 then
			n10 = v784.Position + (n11 - n10).Unit * 0.6
		end

		CurrentCamera.CFrame = CFrame.lookAt(n10, n11 + n9.LookVector * 500)
		CurrentCamera.Focus = CFrame.new(n11)
		playerState.CameraFirstPerson = false
	elseif n6 == 2 then
		local v785 = firstPersonCF(nil, p61)

		if not v785 then
			return
		end

		if u151 then
			clearFirstPersonHidden()
		end

		CurrentCamera.CameraType = Enum.CameraType.Scriptable
		CurrentCamera.CFrame = v785
		CurrentCamera.Focus = CurrentCamera.CFrame
		playerState.CameraFirstPerson = true

		return
	end
end
local function killcamFadeFrame()
	local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local cutsceneFadeGui: Instance = playerGui and playerGui:FindFirstChild("CutsceneFadeGui")
	local v792: Instance = cutsceneFadeGui

	if v792 then
		v792 = cutsceneFadeGui:FindFirstChild("CutsceneFade")
	end

	return v792 and v792:IsA("Frame") and v792 or nil
end
local function clearKillcamFadeFrame()
	local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local cutsceneFadeGui: Instance = playerGui and playerGui:FindFirstChild("CutsceneFadeGui")
	local v795: Instance = cutsceneFadeGui

	if v795 then
		v795 = cutsceneFadeGui:FindFirstChild("CutsceneFade")
	end

	local v796 = v795 and v795:IsA("Frame") and v795 or nil

	if not v796 then
		return
	end

	v796.BackgroundTransparency = 1
	v796.Visible = false
end
local function startKillcamFadeOut(p62)
	local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local cutsceneFadeGui: Instance = playerGui and playerGui:FindFirstChild("CutsceneFadeGui")
	local v800: Instance = cutsceneFadeGui

	if v800 then
		v800 = cutsceneFadeGui:FindFirstChild("CutsceneFade")
	end

	local v801 = v800 and v800:IsA("Frame") and v800 or nil

	if not v801 then
		return
	end

	v801.BackgroundTransparency = 1
	v801.Visible = true

	local tweenService: TweenService = game:GetService("TweenService")

	pcall(function()
		local tweenInfo = TweenInfo.new(p62 or killcamTimeline.FADE_OUT_MS / 1000, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		tweenService:Create(v801, tweenInfo, { BackgroundTransparency = 0 }):Play()
	end)
	task.delay(12, function()
		if LocalPlayer:GetAttribute("_WinScreenOpen") == true then
			return
		end

		local playerGui2: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")
		local cutsceneFadeGui: Instance = playerGui2 and playerGui2:FindFirstChild("CutsceneFadeGui")
		local v987: Instance = cutsceneFadeGui

		if v987 then
			v987 = cutsceneFadeGui:FindFirstChild("CutsceneFade")
		end

		local v988 = v987 and v987:IsA("Frame") and v987 or nil

		if not v988 or not v988.Visible then
			return
		end

		if v988.BackgroundTransparency > 0.99 then
			return
		end

		warn("[ReplayController] killcam fade never handed off to a win screen -- clearing")
		v988.BackgroundTransparency = 1
		v988.Visible = false
	end)
end
local function requestKillcamSkip()
	if not u39 or not u51 then
	elseif not u56 and not u59 then
		u59 = true

		if t4.kcSkip then
			t4.kcSkip.Visible = false
		end

		pcall(function()
			replayKillcamCue:FireServer("skip")
		end)
		pcall(startKillcamFadeOut, 0.15)
		task.delay(1, function()
			if u39 and u51 then
				ReplayController_Stop()
			end
		end)

		return
	end
end
local function step(p63)
	if not u39 or not u40 then
		return
	end

	if u56 then
		return
	end

	local v804 = ReplayController_Perf

	table.clear(v804.ev)
	table.clear(v804.evN)
	v804.folded = 0

	local v805 = os.clock()
	local n1 = if not u40 then 0 else math.max(1, (math.floor(u40.sampleCount / u40.sampleRateHz * 1000)))
	local v807 = t1[n4]

	if u51 then
		v807 = killcamTimeline.RateAt(n3, n10, t29.window)
	end

	local replayTimeScale2 = u45 and v807 or 0

	if u45 then
		n3 += p63 * 1000 * v807

		if n1 <= n3 then
			n3 = n1
			u45 = false
		end
	end

	n3 = math.clamp(n3, 0, n1)

	if t3.endMs and u45 and n3 >= t3.endMs then
		u45 = false
		t3.endMs = nil

		local replayReviewState: Instance = bindables:FindFirstChild("ReplayReviewState")

		if replayReviewState and replayReviewState:IsA("BindableEvent") then
			replayReviewState:Fire("clipEnded", n3)
		end
	end

	if u51 then
		if not u59 and n3 >= n9 - killcamTimeline.FADE_OUT_MS - killcamTimeline.FADE_LEAD_MS then
			u59 = true
			pcall(startKillcamFadeOut)
		end

		n3 = math.clamp(n3, n8, n9)

		if n3 >= n9 then
			u45 = false

			if n12 == 0 then
				n12 = os.clock()
			end

			if os.clock() - n12 > 5 then
				warn("[ReplayController] killcam held past failsafe -- closing locally")
				u56 = true
				ReplayController_Stop()

				return
			end
		end
	end

	debug.profilebegin("RC actors")

	local v810 = os.clock()

	for k, v in pairs(t2) do
		local v813 = n3

		if u51 and n11 > 0 and k ~= n5 then
			v813 = n3 - n11
		end

		local v814 = u40:stateAt(v813, k)

		replayActors.Apply(v, v814, vectorValue, p63)
		replayActors.SetTimeScale(v, replayTimeScale2)
	end

	local n2 = (os.clock() - v810) * 1000

	debug.profileend()
	playerState.ReplayTimeScale = replayTimeScale2
	replayTimeScale.Set(replayTimeScale2)
	playerState.ReplayPlayheadSeconds = n3 / 1000
	debug.profilebegin("RC camera")
	v810 = os.clock()
	applyCamera(p63)

	local n13 = (os.clock() - v810) * 1000

	debug.profileend()
	debug.profilebegin("RC events")
	v810 = os.clock()
	stepEvents(p63, p63 * 1000 * replayTimeScale2)

	local n14 = (os.clock() - v810) * 1000

	debug.profileend()
	debug.profilebegin("RC roster+ui")
	updateRoster()

	if u51 and t4.kcTimer then
		local kcTimer = t4.kcTimer
		local n15 = math.max(0, n10 - n3) / 1000
		local floored = math.floor(n15 / 60)
		local floored4 = math.floor(n15 % 60)
		local floored5 = math.floor(n15 * 10 % 10)

		kcTimer.Text = string.format("%d:%02d.%d", floored, floored4, floored5)
	end

	if t4.fill then
		t4.fill.Size = UDim2.new(n3 / n1, -4, 1, -4)
	end

	if t4.time then
		local time = t4.time
		local stringFormat = string.format
		local v825 = replayUI.FormatTime(n3)
		local v826 = replayUI.FormatTime(n1)

		time.Text = stringFormat("%s / %s   x%g%s", v825, v826, t1[n4], if u45 then "" else "   [PAUSED]")
	end

	refreshControlMenu()

	if t4.playerName then
		local v827 = n5
		local v828

		if not u40 then
			v828 = nil
		else
			local v829, v830, v831 = ipairs(u40.participants)
			local v832: boolean = false

			for iterFirst, iterSecond in v829, v830, v831 do
				if v827 == iterSecond.slot then
					v828 = iterSecond
					v832 = true

					break
				end
			end

			if not v832 then
				v828 = nil
			end
		end

		v827 = t7.For(v828)
		t4.playerName.Text = string.upper(if v827 then "@" .. v827 else v828 and v828.displayName or "Freecam")
	end

	debug.profileend()

	local n6 = (os.clock() - v805) * 1000

	if n6 >= v804.PERF_SLOW_MS and v804.warns < v804.MAX_WARNS then
		v804.warns = v804.warns + 1

		local n7: number = 0

		for iterKey in pairs(t2) do
			n7 += 1
		end

		local t56: {[any]: any} = {}

		for k, v in pairs(v804.ev) do
			table.insert(t56, { label = k, ms = v, n = v804.evN[k] or 0 })
		end

		table.sort(t56, function(p64, p65)
			return p64.ms > p65.ms
		end)

		local t57: {[any]: any} = {}

		for i = 1, math.min(8, #t56) do
			table.insert(t57, string.format("%s x%d %.1fms", t56[i].label, t56[i].n, t56[i].ms))
		end

		local v843 = string.format
		local text: string = tostring(u51)
		local v845 = n3
		local s1: string = if v804.folded > 0 then "yes/" .. v804.folded .. " events" else "no"
		local v847 = if #t57 > 0 then table.concat(t57, "; ") else "none"

		warn(v843("[ReplayController] SLOW FRAME %.0fms (killcam=%s playhead=%.0fms puppets=%d seekFold=%s) actors=%.1fms camera=%.1fms events=%.1fms other=%.1fms | top events: %s", n6, text, v845, n7, s1, n2, n13, n14, n6 - n2 - n13 - n14, v847))
	end
end
local function cycleSlot(p66)
	local v849 = aliveSlots()

	if #v849 == 0 then
		return
	end

	local n1 = 1

	for i, v in ipairs(v849) do
		if v == n5 then
			n1 = i

			break
		end
	end

	n5 = v849[(n1 - 1 + p66) % #v849 + 1]

	if n6 == 3 and n6 ~= 1 then
		local u853: boolean = n6 == 3

		n6 = 1
		u152 = nil
		u153 = nil

		if u853 ~= false then
			applySpectateAttribute()
		end
	end

	applySpectateAttribute()
	pushAbilityPanelSnapshot()
end
local function skipRound(p67)
	if not u40 then
		return
	end

	local t58: {[any]: any} = {}

	for _, v in ipairs(u40.rounds) do
		local floored = math.floor(v.startSample / u40.sampleRateHz * 1000)

		table.insert(t58, floored)
	end

	table.sort(t58)

	if #t58 == 0 then
		return
	end

	if p67 > 0 then
		for _, v in ipairs(t58) do
			if v > n3 + 250 then
				n3 = v

				return
			end
		end

		local n1

		if not u40 then
			n1 = 0
		else
			local floored6 = math.floor(u40.sampleCount / u40.sampleRateHz * 1000)

			n1 = math.max(1, floored6)
		end

		n3 = n1

		return
	end

	for i = #t58, 1, -1 do
		if t58[i] < n3 - 250 then
			n3 = t58[i]

			return
		end
	end

	n3 = 0
end
local function seekToFraction(p68)
	local v865 = math.clamp(p68, 0, 1)
	local n1

	if not u40 then
		n1 = 0
	else
		local floored = math.floor(u40.sampleCount / u40.sampleRateHz * 1000)

		n1 = math.max(1, floored)
	end

	n3 = v865 * n1
end

local replayReviewControl: Instance = bindables:FindFirstChild("ReplayReviewControl")

if replayReviewControl and replayReviewControl:IsA("BindableEvent") then
	replayReviewControl.Event:Connect(function(p69, p70, p71, p72)
		if not u39 or not u40 then
		elseif p69 == "seek" and typeof(p70) == "number" then
			local n1 = if not u40 then 0 else math.max(1, (math.floor(u40.sampleCount / u40.sampleRateHz * 1000)))

			n3 = math.clamp(p70, 0, n1)
			t3.endMs = typeof(p71) == "number" and p70 < p71 and math.min(p71, n1) or nil

			if typeof(p72) == "number" and p72 ~= n5 then
				local v873

				if not u40 then
					v873 = nil
				else
					local v874, v875, v876 = ipairs(u40.participants)
					local v877: boolean = false

					for iterFirst, iterSecond in v874, v875, v876 do
						if p72 == iterSecond.slot then
							v873 = iterSecond
							v877 = true

							break
						end
					end

					if not v877 then
						v873 = nil
					end
				end

				if v873 then
					n5 = p72
					applySpectateAttribute()
					pushAbilityPanelSnapshot()
				end
			end

			if n6 ~= 2 and n6 ~= 2 then
				local u880: boolean = n6 == 3

				n6 = 2
				u152 = nil
				u153 = nil

				if u880 ~= false then
					applySpectateAttribute()
				end
			end

			u45 = true
		elseif p69 == "keep" then
			t3.endMs = nil
			u45 = true
		elseif p69 == "pause" then
			u45 = false
		elseif p69 == "play" then
			u45 = true
		end
	end)
end

local function stepFrame(p73)
	if n6 == 3 then
		return
	end

	u45 = false

	local n1 = n3 + p73 * 1000 / u40.sampleRateHz
	local n2

	if not u40 then
		n2 = 0
	else
		local floored = math.floor(u40.sampleCount / u40.sampleRateHz * 1000)

		n2 = math.max(1, floored)
	end

	n3 = math.clamp(n1, 0, n2)
end
local function nudgeSpeed(p74)
	n4 = math.clamp(n4 + p74, 1, #t1)
end
local function cycleCamMode()
	local n1: number = if n6 == 2 then 1 else 2

	if n1 == n6 then
		return
	end

	local u887: boolean = n6 == 3

	n6 = n1
	u152 = nil
	u153 = nil

	if u887 ~= (n1 == 3) then
		applySpectateAttribute()
	end
end
local function toggleXRay()
	u71 = not u71
	LocalPlayer:SetAttribute("ReplayXRay", u71 or nil)
end
local function bindInput()
	table.insert(t5, userInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
		if not not gameProcessedEvent or not u39 then
			return
		end

		local keyCode: Enum.KeyCode = input.KeyCode

		if u51 then
			if keyCode == Enum.KeyCode.M then
				requestKillcamSkip()
			end

			return
		end

		if keyCode == Enum.KeyCode.Space then
			u45 = not u45

			return
		end

		if keyCode ~= Enum.KeyCode.D then
			if keyCode ~= Enum.KeyCode.A then
				if keyCode == Enum.KeyCode.Comma then
					n4 = math.clamp(n4 + -1, 1, #t1)
				elseif keyCode == Enum.KeyCode.Period then
					n4 = math.clamp(n4 + 1, 1, #t1)
				elseif keyCode == Enum.KeyCode.E and n6 ~= 3 then
					cycleSlot(1)
				elseif keyCode == Enum.KeyCode.Q and n6 ~= 3 then
					cycleSlot(-1)
				elseif keyCode == Enum.KeyCode.One then
					if n6 == 1 then
						return
					end

					local u994: boolean = n6 == 3

					n6 = 1
					u152 = nil
					u153 = nil

					if u994 ~= false then
						applySpectateAttribute()

						return
					end
				elseif keyCode == Enum.KeyCode.Two then
					if n6 == 2 then
						return
					end

					local u995: boolean = n6 == 3

					n6 = 2
					u152 = nil
					u153 = nil

					if u995 ~= false then
						applySpectateAttribute()

						return
					end
				elseif keyCode == Enum.KeyCode.Three then
					local CurrentCamera: Camera = workspace.CurrentCamera

					if CurrentCamera then
						cFrame = CFrame.new(CurrentCamera.CFrame.Position)

						local lookVector = CurrentCamera.CFrame.LookVector

						n13 = math.atan2(-lookVector.X, -lookVector.Z)

						local v998 = math.clamp(lookVector.Y, -1, 1)

						n14 = math.asin(v998)
					end

					if n6 == 3 then
						return
					end

					local u999: boolean = n6 == 3

					n6 = 3
					u152 = nil
					u153 = nil

					if u999 ~= true then
						applySpectateAttribute()

						return
					end
				else
					if keyCode == Enum.KeyCode.R then
						skipRound(1)

						return
					end

					if keyCode == Enum.KeyCode.F then
						skipRound(-1)

						return
					end

					if keyCode == Enum.KeyCode.X then
						u71 = not u71
						LocalPlayer:SetAttribute("ReplayXRay", u71 or nil)

						return
					end

					if keyCode == Enum.KeyCode.M then
						ReplayController_Stop()
					end
				end

				return
			end

			if n6 == 3 then
				return
			end

			u45 = false

			local n1 = n3 + -1000 / u40.sampleRateHz
			local n2

			if not u40 then
				n2 = 0
			else
				local floored = math.floor(u40.sampleCount / u40.sampleRateHz * 1000)

				n2 = math.max(1, floored)
			end

			n3 = math.clamp(n1, 0, n2)

			return
		end

		if n6 == 3 then
			return
		end

		u45 = false

		local n5 = n3 + 1000 / u40.sampleRateHz
		local n7

		if not u40 then
			n7 = 0
		else
			local floored = math.floor(u40.sampleCount / u40.sampleRateHz * 1000)

			n7 = math.max(1, floored)
		end

		n3 = math.clamp(n5, 0, n7)
	end))
	table.insert(t5, userInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
		if u39 and not gameProcessedEvent then
			if input.UserInputType == Enum.UserInputType.MouseButton2 then
				u65 = true
				userInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
			end

			return
		end
	end))
	table.insert(t5, userInputService.InputEnded:Connect(function(input: InputObject)
		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			u65 = false
			userInputService.MouseBehavior = Enum.MouseBehavior.Default
		end
	end))
	table.insert(t5, userInputService.InputChanged:Connect(function(input: InputObject, gameProcessedEvent: boolean)
		if not u39 then
			return
		end

		local u1011: boolean = input.UserInputType == Enum.UserInputType.Touch

		if not u1011 and input.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end

		if not u1011 then
			if not u65 then
				return
			end
		elseif gameProcessedEvent then
			return
		end

		local n3: number = if u1011 then 0.006 else 0.0032
		local delta: Vector3 = input.Delta

		if n6 == 3 then
			n13 -= delta.X * n3
			n14 = math.clamp(n14 - delta.Y * n3, -1.45, 1.45)
		elseif n6 == 1 then
			n1 = math.clamp(n1 - delta.X * n3, -2.6, 2.6)
			n2 = math.clamp(n2 - delta.Y * n3, -0.9, 0.9)
		end
	end))
end
function ReplayController_Stop()
	if not u39 then
		return
	end

	u39 = false
	t3.endMs = nil

	local replayReviewState: Instance = bindables:FindFirstChild("ReplayReviewState")

	if replayReviewState and replayReviewState:IsA("BindableEvent") then
		replayReviewState:Fire("closed")
	end

	u51 = false
	u56 = false
	n11 = 0
	n12 = 0
	u59 = false

	if u57 then
		u57 = false
		pcall(function()
			screenWipe.reveal(0.5)
		end)
	end

	for _, v in pairs(t2) do
		pcall(replayActors.SetTimeScale, v, 1)
	end

	pcall(replayTimeScale.End)
	n19 += 1

	if connection then
		connection:Disconnect()
		connection = nil
	end

	for _, v in ipairs(t5) do
		pcall(function()
			v:Disconnect()
		end)
	end

	t5 = {}

	if t19.inst then
		pcall(function()
			t19.inst:Destroy()
		end)
		t19.inst = nil
	end

	if t19.openBound then
		t19.openBound = false
		pcall(contextActionService.UnbindAction, contextActionService, t19.openAction)
	end

	if t19.killcamBound then
		t19.killcamBound = false
		pcall(contextActionService.UnbindAction, contextActionService, t19.killcamAction)
	end

	if t19.exitBound then
		t19.exitBound = false
		pcall(contextActionService.UnbindAction, contextActionService, t19.exitAction)
	end

	for _, v in ipairs(t19.badges) do
		pcall(function()
			v:destroy()
		end)
	end

	t19.badges = {}

	for _, v in pairs(t2) do
		replayActors.Destroy(v)
	end

	t2 = {}
	characters = nil
	mapRoot = nil
	restoreOtherUI()
	destroyRoster()
	restoreAudio()

	if screenGui then
		pcall(function()
			screenGui:Destroy()
		end)
		screenGui = nil
	end

	t4 = {}
	u40 = nil
	userInputService.MouseBehavior = Enum.MouseBehavior.Default

	if CameraMode then
		LocalPlayer.CameraMode = CameraMode
		CameraMode = nil
	end

	if MouseBehavior then
		userInputService.MouseBehavior = MouseBehavior
		MouseBehavior = nil
	end

	if MouseIconEnabled ~= nil then
		userInputService.MouseIconEnabled = MouseIconEnabled
		MouseIconEnabled = nil
	end

	clearFirstPersonHidden()
	u152 = nil
	u153 = nil
	n7 = 0

	local CurrentCamera: Camera = workspace.CurrentCamera

	if CurrentCamera then
		CurrentCamera.CameraType = CameraType or Enum.CameraType.Custom
		CurrentCamera.CameraSubject = CameraSubject or LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	end

	replayClose:FireServer()
end
local function start(p82)
	if u39 then
		ReplayController_Stop()
	end

	n19 += 1

	local v899: number = n19
	local v900 = replayFormat.decode(p82.blob)

	if not v900.ok then
		local text: string = tostring(v900.err)

		warn("[ReplayController] decode failed: " .. text)

		return
	end

	u40 = v900.replay

	if typeof(p82.weapons) == "table" then
		for _, v in ipairs(u40.participants) do
			local v904 = p82.weapons[v.slot]

			if typeof(v904) == "table" then
				v.knifeIcon = v904.ki
				v.knifeRarity = v904.kr
				v.revolverIcon = v904.ri
				v.revolverRarity = v904.rr
			end
		end
	end

	vectorValue = p82.origin
	mapRoot = p82.mapRoot
	n3 = 0
	u45 = true
	n4 = 3
	n6 = 2
	n15 = 0
	n16 = -0.15
	n17 = -1
	n18 = 1
	t28 = {}
	t14 = {}
	t15 = {}
	u71 = false
	LocalPlayer:SetAttribute("ReplayXRay", nil)

	local v905 = aliveSlots()

	n5 = v905[1] or 0
	u51 = false
	u56 = false
	n10 = 0
	n11 = 0
	n12 = 0
	u59 = false
	t29.window = nil
	t29.flight = nil
	t29.offset = nil
	t29.victimSlot = nil
	t29.engaged = false

	local killcam = p82.killcam

	if typeof(killcam) == "table" and typeof(killcam.startMs) == "number" and typeof(killcam.endMs) == "number" and killcam.endMs > killcam.startMs then
		local n1 = if not u40 then 0 else math.max(1, (math.floor(u40.sampleCount / u40.sampleRateHz * 1000)))

		n8 = math.clamp(killcam.startMs, 0, n1)
		n9 = math.clamp(killcam.endMs, n8, n1)

		if n9 > n8 then
			u51 = true
			n3 = n8
			u45 = false
			n10 = typeof(killcam.killMs) == "number" and math.clamp(killcam.killMs, n8, n9) or n9
			n11 = typeof(killcam.rewindMs) == "number" and math.clamp(killcam.rewindMs, 0, 1000) or 0

			if typeof(killcam.followSlot) == "number" then
				for _, v in ipairs(v905) do
					if v == killcam.followSlot then
						n5 = v

						break
					end
				end
			end

			local killcamKnifeCam = killcam.knifeCam

			if typeof(killcamKnifeCam) == "table" and typeof(killcamKnifeCam.throwMs) == "number" and typeof(killcamKnifeCam.impactMs) == "number" and killcamKnifeCam.impactMs > killcamKnifeCam.throwMs and killcamKnifeCam.throwMs >= n8 and killcamKnifeCam.impactMs <= n9 then
				t29.window = { startMs = killcamKnifeCam.throwMs, endMs = killcamKnifeCam.impactMs }
			end

			local ok, result = pcall(setupKnifeCam, killcamKnifeCam)

			if not ok then
				local text: string = tostring(result)

				warn("[ReplayController] knife cam setup threw: " .. text)
				t29.window = nil
				t29.flight = nil
				t29.offset = nil
			end
		end
	end

	t3.endMs = nil

	local review = p82.review

	if not u51 and typeof(review) == "table" and typeof(review.startMs) == "number" then
		local n2 = if not u40 then 0 else math.max(1, (math.floor(u40.sampleCount / u40.sampleRateHz * 1000)))

		n3 = math.clamp(review.startMs, 0, n2)

		if typeof(review.endMs) == "number" and review.endMs > review.startMs then
			t3.endMs = math.min(review.endMs, n2)
		end

		if typeof(review.followSlot) == "number" then
			for _, v in ipairs(v905) do
				if v == review.followSlot then
					n5 = v

					break
				end
			end
		end

		n6 = 2
	end

	characters = workspace:FindFirstChild("Characters")

	if not characters then
		warn("[ReplayController] workspace.Characters missing")

		return
	end

	local function seedActorState(p83)
		if not u40 then
			return
		end

		if n17 < 0 then
			return
		end

		local t62: {[any]: any} = {}
		local t63: {[any]: any} = {}
		local t64: {[any]: any} = {}
		local t65: {[any]: any} = {}
		local t66: {[any]: any} = {}

		for _, v in ipairs(u40.events) do
			if v.timeMs > n3 then
				break
			end

			if p83 == v.actorSlot then
				if v.etype == replayFormat.EV_ANIM_START then
					local v1022, v1023, v1024, v1025 = pcall(string.unpack, "<ffs2", v.payload)

					if v1022 and typeof(v1025) == "string" then
						if not t63[v1025] then
							t63[v1025] = true
							table.insert(t62, v1025)
						end

						t64[v1025] = v
					end
				elseif v.etype == replayFormat.EV_ANIM_STOP then
					local ok, result = pcall(string.unpack, "<s2", v.payload)

					if ok and typeof(result) == "string" then
						t64[result] = nil
					end
				elseif v.etype == replayFormat.EV_ATTR then
					local ok, result = pcall(string.unpack, "<s1", v.payload)

					if ok then
						if t66[result] == nil then
							table.insert(t65, result)
						end

						t66[result] = v
					end
				end
			end
		end

		for _, v in ipairs(t62) do
			local v1032 = t64[v]

			if v1032 then
				fireEventSafe(v1032)
			end
		end

		for _, v in ipairs(t65) do
			fireEventSafe(t66[v])
		end

		pcall(t31.push, p83)
	end

	for _, v in ipairs(u40.participants) do
		task.spawn(function()
			local ok, result = pcall(replayActors.Build, v, characters)

			if ok and result and n19 == v899 then
				t2[v.slot] = result
				pcall(seedActorState, v.slot)

				if v.slot == n5 then
					applySpectateAttribute()

					return
				end
			elseif ok and result then
				replayActors.Destroy(result)
			end
		end)
	end

	if not u51 then
		buildRoster()
	end

	buildUI()
	hideOtherUI()

	if u51 then
		if t4.dock then
			t4.dock.Visible = false
		end

		if t4.hints then
			t4.hints.Visible = false
		end

		if t4.back then
			t4.back.Visible = false
		end

		if t4.next then
			t4.next.Visible = false
		end

		pcall(clearKillcamFadeFrame)
		pcall(hideKillcamScoreBar)
		buildKillcamChrome()

		local skipButton = replayUI.CloneFromGui("WinScreen", { "ReturnButton" })

		if skipButton then
			replayUI.StripScripts(skipButton)
			skipButton.Name = "SkipButton"
			skipButton.Visible = true
			skipButton.ZIndex = 30
			actionButtonTheme.Apply(skipButton, actionButtonTheme.THEMES.red)

			if t19.touchOnly() then
				local keybind = skipButton:FindFirstChild("Keybind")

				if keybind then
					keybind:Destroy()
				end
			else
				local keybind = skipButton:FindFirstChild("Keybind")

				if keybind and keybind:IsA("Frame") then
					local ok, result = pcall(t19.UIFramework.applyGamepadKeybind, keybind, t19.GamepadBindings.Menu)

					if ok and result then
						table.insert(t19.badges, result)
					end

					pcall(t19.UIFramework.bindKeybindLabel, keybind, "Menu")
				end
			end

			actionButtonTheme.SetText(skipButton, "Skip")
			skipButton.Parent = screenGui
			t4.kcSkip = skipButton
			table.insert(t5, skipButton.Activated:Connect(requestKillcamSkip))
		end

		table.insert(t5, userInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
			if not not gameProcessedEvent or not u39 or not u51 then
				return
			end

			if inputMap.matches("Menu", input) then
				requestKillcamSkip()
			end
		end))

		local CurrentCamera: Camera = workspace.CurrentCamera
		local floored = math.floor((CurrentCamera and CurrentCamera.ViewportSize.Y or 800) * 0.11)

		raiseMatchUI(floored + 12)
	else
		raiseMatchUI()
	end

	placeStrip()

	local v928: {[any]: any} = t5
	local v929: RBXScriptSignal = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize")

	table.insert(v928, v929:Connect(function()
		if u39 then
			placeStrip()
		end
	end))
	playerState.ReplayActive = true
	playerState.ReplayPlayheadSeconds = n3 / 1000

	local soundService: SoundService = game:GetService("SoundService")

	if u86 == nil then
		local musicVolumeMultiplier: any = soundService:GetAttribute("MusicVolumeMultiplier")

		u86 = typeof(musicVolumeMultiplier) == "number" and musicVolumeMultiplier or 1
	end

	soundService:SetAttribute("MusicVolumeMultiplier", 0)
	pcall(replayTimeScale.Begin, mapRoot)
	buildMarkers()
	u95()
	markAnimHolds(u40.events)
	t6 = {}

	for _, v in ipairs(u40.participants) do
		if typeof(v.userId) == "number" and v.userId ~= 0 then
			t6[v.userId] = v.slot
		end

		t7.For(v)
	end

	if ReplayController_DEBUG_EVENTS then
		local t59: {[any]: any} = {}

		for _, v in ipairs(u40.events) do
			local s1

			if v.etype == replayFormat.EV_REMOTE then
				local ok, result = pcall(string.unpack, "<s1", v.payload)

				s1 = ok and "remote:" .. result or "remote:?"
			else
				s1 = if v.etype == replayFormat.EV_ATTR then "attr" else if v.etype == replayFormat.EV_ANIM_START then "anim:start" else if v.etype == replayFormat.EV_ANIM_STOP then "anim:stop" else "type" .. tostring(v.etype)
			end

			t59[s1] = (t59[s1] or 0) + 1
		end

		local t60: {[any]: any} = {}

		for k, v in pairs(t59) do
			table.insert(t60, k .. "=" .. v)
		end

		table.sort(t60)

		local substring = u40.matchId:sub(1, 8)

		print(("[ReplayController] opened %s: %d events -- %s"):format(substring, #u40.events, table.concat(t60, " ")))
	end

	if t4.next then
		t4.next.MouseButton1Click:Connect(function()
			cycleSlot(1)
		end)
	end

	if t4.back then
		t4.back.MouseButton1Click:Connect(function()
			cycleSlot(-1)
		end)
	end

	if t4.exit then
		t4.exit.MouseButton1Click:Connect(function()
			ReplayController_Stop()
		end)
	end

	if (userInputService.TouchEnabled or userInputService.GamepadEnabled) and not u51 then
		t19.inst = replayControlMenu.new({
			parent = screenGui,
			actions = {
				togglePlay = function()
					u45 = not u45
				end,
				step = function(p86)
					if n6 == 3 then
						return
					end

					u45 = false

					local n1 = n3 + p86 * 1000 / u40.sampleRateHz
					local n2

					if not u40 then
						n2 = 0
					else
						local floored = math.floor(u40.sampleCount / u40.sampleRateHz * 1000)

						n2 = math.max(1, floored)
					end

					n3 = math.clamp(n1, 0, n2)
				end,
				speed = function(p87)
					n4 = math.clamp(n4 + p87, 1, #t1)
				end,
				round = function(p88)
					skipRound(p88)
				end,
				player = function(p89)
					cycleSlot(p89)
				end,
				cycleCam = cycleCamMode,
				toggleXRay = toggleXRay,
				exit = function()
					ReplayController_Stop()
				end
			}
		})

		if t19.inst then
			refreshControlMenu()

			if t4.menuBtn then
				table.insert(t5, t4.menuBtn.MouseButton1Click:Connect(function()
					t19.inst:Toggle()
				end))
			end

			contextActionService:BindActionAtPriority(t19.openAction, function(_, p91, input)
				if input.UserInputType ~= Enum.UserInputType.Gamepad1 then
					return Enum.ContextActionResult.Pass
				end

				if p91 ~= Enum.UserInputState.Begin then
					return Enum.ContextActionResult.Sink
				end

				if not t19.inst then
					return Enum.ContextActionResult.Pass
				end

				t19.inst:Open()

				return Enum.ContextActionResult.Sink
			end, false, t19.priority, Enum.KeyCode.ButtonY)
			t19.openBound = true
		end
	elseif u51 and userInputService.GamepadEnabled then
		contextActionService:BindActionAtPriority(t19.killcamAction, function(_, p94, input)
			if input.UserInputType ~= Enum.UserInputType.Gamepad1 then
				return Enum.ContextActionResult.Pass
			end

			if p94 ~= Enum.UserInputState.Begin then
				return Enum.ContextActionResult.Sink
			end

			requestKillcamSkip()

			return Enum.ContextActionResult.Sink
		end, false, t19.priority, t19.GamepadBindings.Menu)
		t19.killcamBound = true
	end

	if not u51 and userInputService.GamepadEnabled then
		contextActionService:BindActionAtPriority(t19.exitAction, function(_, p97, input)
			if input.UserInputType ~= Enum.UserInputType.Gamepad1 then
				return Enum.ContextActionResult.Pass
			end

			if p97 ~= Enum.UserInputState.Begin then
				return Enum.ContextActionResult.Sink
			end

			ReplayController_Stop()

			return Enum.ContextActionResult.Sink
		end, false, t19.priority, t19.GamepadBindings.Menu)
		t19.exitBound = true
	end

	if t4.seekHit then
		t4.seekHit.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				local holder = t4.holder
				local n1 = input.Position.X - holder.AbsolutePosition.X
				local v1058 = math.max(holder.AbsoluteSize.X, 1)
				local v1059 = math.clamp(n1 / v1058, 0, 1)
				local n2

				if not u40 then
					n2 = 0
				else
					local floored = math.floor(u40.sampleCount / u40.sampleRateHz * 1000)

					n2 = math.max(1, floored)
				end

				n3 = v1059 * n2

				return
			end
		end)
	end

	local CurrentCamera: Camera = workspace.CurrentCamera

	if CurrentCamera then
		CameraType = CurrentCamera.CameraType
		CameraSubject = CurrentCamera.CameraSubject
		CurrentCamera.CameraType = Enum.CameraType.Scriptable
	end

	CameraMode = LocalPlayer.CameraMode
	MouseBehavior = userInputService.MouseBehavior
	MouseIconEnabled = userInputService.MouseIconEnabled
	LocalPlayer.CameraMode = Enum.CameraMode.Classic
	userInputService.MouseBehavior = Enum.MouseBehavior.Default
	userInputService.MouseIconEnabled = true
	pushMatchStateSnapshot()
	pushAbilityPanelSnapshot()
	u39 = true

	if not u51 then
		bindInput()
	end

	if u51 then
		local v945: number = n19

		task.spawn(function()
			local n1 = os.clock() + killcamTimeline.LEAD_IN_MS / 1000
			local u1063: boolean = false

			while true do
				local v1064 = os.clock()

				if not (n1 > v1064) then
					break
				end

				if n19 ~= v945 or not u39 then
					return
				end

				v1064 = t2[n5]

				if v1064 and v1064.root then
					u1063 = true

					break
				end

				task.wait(0.05)
			end

			if n19 ~= v945 or not u39 then
				return
			end

			if not u1063 then
				warn(("[ReplayController] killcam revealing without the followed actor (slot %d) -- avatar build exceeded %dms; camera falls back to the recorded view"):format(n5, killcamTimeline.LEAD_IN_MS))
			end

			if u57 then
				u57 = false
				pcall(function()
					screenWipe.reveal(0.5)
				end)
			end

			u45 = true
			pcall(function()
				replayKillcamCue:FireServer()
			end)
		end)
	end

	local n7: number = 0
	local t61: {[any]: any} = {}

	connection = runService.RenderStepped:Connect(function(deltaTime: number)
		local ok, result = pcall(step, deltaTime)

		if ok then
			return
		end

		n7 += 1

		local text: string = tostring(result)

		if not t61[text] then
			t61[text] = true
			warn(("[ReplayController] step error (continuing): %s"):format(text))
		end

		if n7 > 240 then
			warn("[ReplayController] step failing every frame -- closing replay")
			ReplayController_Stop()
		end
	end)
end

replayData.OnClientEvent:Connect(function(p101)
	if typeof(p101) ~= "table" or not p101.blob then
		return
	end

	local ok, result = pcall(start, p101)

	if not ok then
		local text: string = tostring(result)

		warn("[ReplayController] start failed: " .. text)
		ReplayController_Stop()
	end
end)
replayClose.OnClientEvent:Connect(function()
	ReplayController_Stop()
end)
replayKillcamCue.OnClientEvent:Connect(function(p102)
	if p102 then
		u57 = true
		pcall(function()
			screenWipe.cover(0.25)
		end)
	elseif u57 then
		u57 = false
		pcall(function()
			screenWipe.reveal(0.5)
		end)
	end
end)
