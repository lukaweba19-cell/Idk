-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local teleportService: TeleportService = game:GetService("TeleportService")
local LocalPlayer: Player = players.LocalPlayer
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local screenWipe = require(shared:WaitForChild("ScreenWipe"))
local sound = require(replicatedStorage:WaitForChild("Sound"))
local matchmakingShared: Instance = replicatedStorage:WaitForChild("MatchmakingShared")
local config = require(matchmakingShared:WaitForChild("Config"))
local isReservedServer: Instance = matchmakingShared:WaitForChild("IsReservedServer", 3)
local u11: boolean = isReservedServer ~= nil and isReservedServer.Value == true
local remotes: Instance = matchmakingShared:WaitForChild("Remotes", 5)
local t1: {[any]: any} = {}

local function fanout(p1)
	for _, v in ipairs(t1) do
		v(p1)
	end
end

local t2: {[any]: any} = {
	subscribe = function(p2)
		table.insert(t1, p2)
	end
}

if remotes then
	local partyStateChanged: Instance = remotes:WaitForChild("PartyStateChanged", 5)
	local queueStateChanged: Instance = remotes:WaitForChild("QueueStateChanged", 5)

	if partyStateChanged then
		partyStateChanged.OnClientEvent:Connect(fanout)
	end

	if queueStateChanged then
		queueStateChanged.OnClientEvent:Connect(fanout)
	end
end

fanout = function(p3)
	return remotes and remotes:FindFirstChild(p3)
end

function t2.getMyState()
	local getMyState: Instance = remotes and remotes:FindFirstChild("GetMyState")

	if not getMyState then
		return nil
	end

	local ok, result = pcall(function()
		return getMyState:InvokeServer()
	end)

	return ok and result or nil
end
function t2.queueModes(p4)
	local queueModes: Instance = remotes and remotes:FindFirstChild("QueueModes")

	if not queueModes then
		return false, "Matchmaking unavailable"
	end

	return queueModes:InvokeServer(p4)
end
function t2.cancelQueue()
	local cancelQueue: Instance = remotes and remotes:FindFirstChild("CancelQueue")

	if not cancelQueue then
		return false, "Matchmaking unavailable"
	end

	return cancelQueue:InvokeServer()
end
function t2.setModes(p5)
	local setModes: Instance = remotes and remotes:FindFirstChild("SetModes")

	if setModes then
		setModes:FireServer(p5)
	end
end
function t2.isAvailable()
	return matchmakingShared:FindFirstChild("Remotes") ~= nil
end

local scriptParent: Instance = script.Parent
local openEvent: Instance = scriptParent:WaitForChild("OpenEvent")
local playBtn: Instance = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD"):WaitForChild("LobbyTopButtons"):WaitForChild("PlayBtn")
local cancelBtn: Instance = scriptParent:WaitForChild("CancelBtn")

cancelBtn:WaitForChild("TextLabel")

local u22 = nil

for _, v in ipairs(cancelBtn:GetChildren()) do
	if v:IsA("TextLabel") then
		if v.Text == "Cancel" then
		elseif string.find(string.lower(v.Text), "searching", 1, true) or u22 == nil then
			u22 = v
		end
	end
end

local t3: {[any]: any} = {}

for _, v in ipairs(cancelBtn:GetChildren()) do
	if v:IsA("UIStroke") then
		table.insert(t3, v)
	end
end

local cancelBtnBackgroundTransparency = cancelBtn.BackgroundTransparency
local matchmake: Instance = scriptParent:WaitForChild("Matchmake")
local btnContainer: Instance = matchmake:WaitForChild("BtnContainer")
local startBtn: Instance = btnContainer:WaitForChild("StartBtn")
local backBtn: Instance = btnContainer:WaitForChild("BackBtn")
local closeButton: Instance = matchmake:FindFirstChild("CloseButton")
local matchmakeFrame: Instance = matchmake:WaitForChild("Frame")
local u35 = nil

for _, v in ipairs(matchmake:GetChildren()) do
	if v:IsA("TextLabel") and v.Name == "Header" and (not u35 or v.Position.Y.Scale < u35.Position.Y.Scale) then
		u35 = v
	end
end

local v38 = u35 and u35.Text

matchmake.Active = true
startBtn.Active = true
startBtn.AutoButtonColor = true

local scriptParentDisplayOrder = scriptParent.DisplayOrder

local function setDisplayOrderElevated(p6)
	scriptParent.DisplayOrder = if p6 then 9 else scriptParentDisplayOrder
end

local t4: {[any]: any} = {
	strokeTransparency = 0,
	strokeThickness = 0.017,
	imageTransparency = 0.5,
	gradientEnabled = false,
	checkVisible = true,
	strokeColor = Color3.fromRGB(51, 255, 65),
	imageColor = Color3.new(1, 1, 1)
}
local t5: {[any]: any} = {
	strokeTransparency = 0.8,
	strokeThickness = 0.005,
	imageTransparency = 0.5,
	gradientEnabled = true,
	checkVisible = false,
	strokeColor = Color3.new(1, 1, 1),
	imageColor = Color3.new(1, 1, 1)
}
local color3 = Color3.fromRGB(120, 120, 120)
local t6: {[any]: any} = {
	strokeTransparency = 1,
	strokeThickness = 0.005,
	imageTransparency = 0.5,
	gradientEnabled = true,
	checkVisible = false,
	strokeColor = Color3.new(1, 1, 1),
	imageColor = color3
}
local t7: {[any]: any} = {}

local function whiteStroke(p7)
	for _, v in ipairs(p7:GetChildren()) do
		if v:IsA("UIStroke") and v.Color.R > 0.9 and v.Color.G > 0.9 and v.Color.B > 0.9 then
			return v
		end
	end

	return nil
end

for _, v in ipairs(config.ModeOrder) do
	local v2: Instance = matchmakeFrame:FindFirstChild(v)

	if v2 and v2:IsA("GuiButton") then
		local image: Instance = v2:FindFirstChild("Image")
		local frame: Instance = v2:FindFirstChild("Frame")
		local v52 = frame and frame:FindFirstChild("ImageLabel") or nil
		local v53 = whiteStroke(v2)

		t7[v] = {
			button = v2,
			stroke = v53,
			image = image,
			gradient = image and image:FindFirstChildOfClass("UIGradient") or nil,
			glow = v2 and v2:FindFirstChild("SelectedGlow") or nil,
			check = v52
		}
	end
end

local function applyLook(p8, p9)
	if p8.stroke then
		p8.stroke.Color = p9.strokeColor
		p8.stroke.Transparency = p9.strokeTransparency
		p8.stroke.Thickness = p9.strokeThickness
	end

	if p8.check then
		p8.check.Visible = p9.checkVisible
	end

	if p8.glow then
		p8.glow.Visible = p9.checkVisible
	end

	if p8.image then
		p8.image.ImageTransparency = p9.imageTransparency
		p8.image.ImageColor3 = p9.imageColor
	end

	if p8.gradient then
		p8.gradient.Enabled = p9.gradientEnabled
	end
end

local u55: boolean = false
local u56: boolean = false
local u57: boolean = false
local u58: boolean = false
local n1: number = 0
local u60 = nil
local u61 = nil
local u62 = nil
local u63 = nil
local u64 = nil
local u65: boolean = false
local u66: boolean = false
local n2: number = 0
local n3: number = 0
local t8: {[any]: any} = {}

local function setSelectionFromList(p10)
	table.clear(t8)

	if type(p10) == "table" then
		for _, v in ipairs(p10) do
			t8[v] = true
		end
	end
end
local function currentSelectionList()
	local t14: {[any]: any} = {}

	for _, v in ipairs(config.ModeOrder) do
		if t8[v] then
			table.insert(t14, v)
		end
	end

	return t14
end

local configModeOrder = config.ModeOrder

table.clear(t8)

if type(configModeOrder) == "table" then
	for _, v in ipairs(configModeOrder) do
		t8[v] = true
	end
end

local function isQueueing(p11)
	return p11 ~= nil and p11.activeTickets ~= nil and next(p11.activeTickets) ~= nil
end
local function isMatched(p12)
	return p12 ~= nil and p12.matched == true
end
local function partySizeFitsMode(p13, p14)
	return p13 <= config.Modes[p14].teamSize
end
local function reverseTable(p15)
	local t15: {[any]: any} = {}

	for i = #p15, 1, -1 do
		table.insert(t15, p15[i])
	end

	return t15
end
local function fittingSelectedModes(p16)
	local n1 = p16 and #p16.members or 1
	local t16: {[any]: any} = {}

	for _, v in ipairs(config.ModeOrder) do
		if t8[v] and n1 <= config.Modes[v].teamSize then
			table.insert(t16, v)
		end
	end

	return t16
end
local function computeModeStates(p17, _)
	local t17: {[any]: any} = {}
	local u203: boolean = p17 ~= nil and p17.activeTickets ~= nil and next(p17.activeTickets) ~= nil
	local n1 = p17 and #p17.members or 1

	for _, v in ipairs(config.ModeOrder) do
		if u203 then
			t17[v] = if p17.activeTickets[v] then "queued" else "disabled"
		elseif not (n1 <= config.Modes[v].teamSize) then
			t17[v] = "disabled"
		elseif t8[v] then
			t17[v] = "selected"
		else
			t17[v] = "unselected"
		end
	end

	return t17
end
local function countSelectedFitting(p19)
	local n1 = p19 and #p19.members or 1
	local n2: number = 0

	for key, value in t8 do
		if value and n1 <= config.Modes[key].teamSize then
			n2 += 1
		end
	end

	return n2
end
local function applyModeStates(p20, _)
	for _, v in ipairs(config.ModeOrder) do
		local v216 = t7[v]

		if v216 then
			local v217 = p20[v]

			applyLook(v216, if v217 == "selected" or v217 == "queued" then t4 else if v217 == "unselected" then t5 else t6)

			local u218: boolean = true

			if v217 ~= "selected" then
				u218 = v217 == "unselected"
			end

			v216.button.Active = u218
			v216.button.AutoButtonColor = u218
		end
	end
end
local function setStatus(text)
	if u35 then
		u35.Text = text
	end
end
local function currentLeaderName()
	if u60 then
		for _, v in ipairs(u60.members) do
			if v.userId == u60.leaderUserId then
				return v.name
			end
		end

		return nil
	end

	return nil
end

local n4 = 0

local function notifyLeaderOnly(p23)
	local v223
	local v223

	if not _G.Notify then
		return
	end

	if os.clock() - n4 < 1.5 then
		return
	end

	n4 = os.clock()

	local v224
	local v225

	if u60 then
		for _, v in ipairs(u60.members) do
			if v.userId == u60.leaderUserId then
				v223 = v.name
				v224 = _G.Notify
				v225 = ("Only %s can %s."):format(if v223 then ("the party leader (@%s)"):format(v223) else "the party leader", p23)
				v224({ notifType = "FailNotification", errorMessage = v225 })

				return
			end
		end
	end

	v223 = nil

	do
		local v224 = _G.Notify
		local v225 = ("Only %s can %s."):format(if v223 then ("the party leader (@%s)"):format(v223) else "the party leader", p23)

		v224({ notifType = "FailNotification", errorMessage = v225 })

		return
	end
end
local function searchingBaseText(p24)
	local t18 = {}

	if p24 and p24.activeTickets and next(p24.activeTickets) then
		for _, v in ipairs(config.ModeOrder) do
			if p24.activeTickets[v] then
				table.insert(t18, v)
			end
		end
	else
		t18 = fittingSelectedModes(p24)
	end

	if #t18 == 0 then
		return "Searching"
	end

	return "Searching for " .. table.concat(t18, ", ")
end

local u88 = nil

local function formatElapsed(p25)
	local floored = math.floor(p25)
	local v234 = math.max(0, floored)
	local floored2 = math.floor(v234 / 60)

	return string.format("%d:%02d", floored2, v234 % 60)
end
local function refreshSearchLabel()
	if not u22 then
		return
	end

	local v236 = u60

	if v236 ~= nil and v236.matched == true then
		u22.Text = "Match found! Teleporting..."

		return
	end

	local v237 = searchingBaseText(u60)

	if u88 then
		local v238 = u22
		local stringFormat = string.format
		local v240 = os.clock()

		v238.Text = stringFormat("%s... (%s)", v237, formatElapsed(v240 - u88))

		return
	end

	u22.Text = v237 .. "..."
end
local function queueModesText()
	local t19 = {}

	if u60 and u60.activeTickets and next(u60.activeTickets) then
		local t20: {[any]: any} = {}

		for _, v in ipairs(config.ModeOrder) do
			if u60.activeTickets[v] then
				table.insert(t19, v)
				t20[v] = true
			end
		end

		for iterKey in pairs(u60.activeTickets) do
			if not t20[iterKey] then
				table.insert(t19, iterKey)
			end
		end
	else
		t19 = fittingSelectedModes(u60)
	end

	local t21: {[any]: any} = {}

	for _, v in ipairs(t19) do
		local v249 = config.Modes[v]

		table.insert(t21, v249 and v249.displayName or v)
	end

	return table.concat(t21, ", ")
end
local function pushQueueNotif(p26)
	local v251

	if not _G.QueueNotif then
		return
	end

	if not p26 then
		_G.QueueNotif({ active = false })

		return
	end

	local v252 = u60

	if v252 ~= nil and v252.matched == true and not u66 then
		_G.QueueNotif({
			active = true,
			header = "Match found!",
			modes = "Teleporting...",
			showCancel = false,
			onCancel = u64
		})

		return
	end

	local _GQueueNotif = _G.QueueNotif
	v252 = {
		active = true,
		header = "Searching for Players...",
		showCancel = true,
		modes = queueModesText(),
		timer = v251
	}

	if u88 then
		local v254 = os.clock()
		local floored = math.floor(v254 - u88)

		v254 = math.max(0, floored)

		local floored3 = math.floor(v254 / 60)
		local v251 = string.format("%d:%02d", floored3, v254 % 60) or "0:00"
	else
		v251 = "0:00"
	end

	v252.onCancel = u64
	_GQueueNotif(v252)
end

task.spawn(function()
	local v257
	local u258
	local v259
	local v260
	local u261

	while true do
		task.wait(0.5)
		v257 = u60
		u258 = false

		if v257 == nil then
		else
			u258 = false

			if v257.activeTickets == nil then
			else
				v259 = next(v257.activeTickets)
				u258 = v259 ~= nil
			end
		end

		if not u258 and not u57 or u58 then
		else
			v260 = u60
			u261 = false

			if v260 == nil then
			else
				u261 = v260.matched == true
			end

			if u261 and not u66 then
			else
				pushQueueNotif(true)
			end
		end

		continue
	end
end)
playBtn.Visible = false

local u93 = false

local function setPlayShown(visible)
	if visible == u93 then
		return
	end

	u93 = visible
	playBtn.Visible = visible
end
local function inActiveMatch()
	local u263: boolean = true

	if LocalPlayer:GetAttribute("InMatch") ~= true then
		u263 = LocalPlayer:GetAttribute("VotingPhase") == true
	end

	return u263
end
local function inMatchOrVoting()
	local u264: boolean = true

	if LocalPlayer:GetAttribute("InMatch") ~= true then
		u264 = LocalPlayer:GetAttribute("VotingPhase") == true
	end

	if not u264 then
		u264 = LocalPlayer:GetAttribute("_WinScreenOpen") == true
	end

	return u264
end
local function onDuelPad()
	return LocalPlayer:GetAttribute("DuelStationQueued") == true
end
local function isSpectating()
	local spectating: any = LocalPlayer:GetAttribute("Spectating")
	local u266: boolean = false

	if typeof(spectating) == "number" then
		u266 = spectating ~= 0
	end

	return u266
end
local function spinnerOpen()
	return LocalPlayer:GetAttribute("_SpinnerOpen") == true
end
local function mmLiveEnabled()
	return matchmakingShared:GetAttribute("MMEnabled") ~= false
end
local function playEligible()
	if u11 then
		local v267 = t2.isAvailable()

		if v267 then
			v267 = false

			if LocalPlayer:GetAttribute("DataReady") == true then
				v267 = false

				if LocalPlayer:GetAttribute("MMRequeueReady") == true then
					local u268: boolean = true

					if LocalPlayer:GetAttribute("InMatch") ~= true then
						u268 = LocalPlayer:GetAttribute("VotingPhase") == true
					end

					if not u268 then
						u268 = LocalPlayer:GetAttribute("_WinScreenOpen") == true
					end

					v267 = not u268

					if v267 then
						v267 = LocalPlayer:GetAttribute("DuelStationQueued") ~= true
					end
				end
			end
		end

		return v267
	end

	local v269 = t2.isAvailable()

	if v269 then
		v269 = matchmakingShared:GetAttribute("MMEnabled") ~= false

		if v269 then
			v269 = false

			if LocalPlayer:GetAttribute("DataReady") == true then
				local u270: boolean = true

				if LocalPlayer:GetAttribute("InMatch") ~= true then
					u270 = LocalPlayer:GetAttribute("VotingPhase") == true
				end

				if not u270 then
					u270 = LocalPlayer:GetAttribute("_WinScreenOpen") == true
				end

				v269 = not u270

				if v269 then
					v269 = LocalPlayer:GetAttribute("DuelStationQueued") ~= true

					if v269 then
						local spectating: any = LocalPlayer:GetAttribute("Spectating")
						local u272: boolean = false

						if typeof(spectating) == "number" then
							u272 = spectating ~= 0
						end

						v269 = not u272
					end
				end
			end
		end
	end

	return v269
end
local function isPhase1Tutorial()
	local v273 = t2.isAvailable() and not u11

	if v273 then
		v273 = LocalPlayer:GetAttribute("TutorialPhase") == 1
	end

	return v273
end
local function applyTutorialPanelChrome()
	local v274 = t2.isAvailable() and not u11

	if v274 then
		v274 = LocalPlayer:GetAttribute("TutorialPhase") == 1
	end

	for _, v in ipairs(config.ModeOrder) do
		local v277 = t7[v]

		if v277 then
			v277.button.Visible = not v274 or v == config.TutorialSourceMode
		end
	end

	if v274 then
		local configTutorialSourceMode = config.TutorialSourceMode

		table.clear(t8)

		local t22: {[any]: any} = { configTutorialSourceMode }

		if type(t22) == "table" then
			for _, v in ipairs(t22) do
				t8[v] = true
			end
		end

		if not u11 then
			backBtn.Visible = false

			if closeButton then
				closeButton.Visible = false

				return
			end
		end
	elseif not u11 then
		backBtn.Visible = true

		if closeButton then
			closeButton.Visible = true
		end
	end
end
local function render()
	local v282 = u60
	local v283: boolean = (v282 ~= nil and v282.activeTickets ~= nil and next(v282.activeTickets) ~= nil or u57) and not u58

	if v283 and not u88 then
		u88 = os.clock()
	elseif not v283 and not u58 and u88 then
		u88 = nil
	end

	local u284: boolean = v282 ~= nil and v282.leaderUserId == LocalPlayer.UserId
	local u285 = v282 ~= nil and v282.matched == true

	if u285 then
		u285 = not u66
	end

	local u286: boolean = true

	if LocalPlayer:GetAttribute("InMatch") ~= true then
		u286 = LocalPlayer:GetAttribute("VotingPhase") == true
	end

	if u286 or LocalPlayer:GetAttribute("DuelStationQueued") == true then
		u55 = false
	end

	applyTutorialPanelChrome()

	if u285 or v283 then
		matchmake.Visible = false
	elseif u55 then
		matchmake.Visible = true
	else
		matchmake.Visible = false
	end

	if u11 then
		pushQueueNotif(u285 or v283)
		cancelBtn.Visible = false

		if u93 ~= false then
			u93 = false
			playBtn.Visible = false
		end

		if u62 then
			u62(v282, v283, u285)
		end

		local v287 = matchmake.Visible

		if not v287 then
			v287 = false

			if u61 ~= nil then
				v287 = u61.Visible
			end
		end

		scriptParent.DisplayOrder = if v287 then 9 else scriptParentDisplayOrder
	else
		pushQueueNotif(u285 or v283)
		scriptParent.DisplayOrder = if matchmake.Visible then 9 else scriptParentDisplayOrder

		local visible = not v283 and not u58 and not u55 and not u285 and playEligible()

		if visible ~= u93 then
			u93 = visible
			playBtn.Visible = visible
		end
	end

	u285 = computeModeStates(v282, u284)
	applyModeStates(u285, u284)

	if not v283 and u55 then
		if not u284 or countSelectedFitting(v282) ~= 0 then
			local t23: {[any]: any} = {}

			for iterFirst, iterSecond in u285 do
				if iterSecond == "selected" then
					table.insert(t23, iterFirst)
				end
			end

			local t24: {[any]: any} = t23
			t23 = {}

			for i = #t24, 1, -1 do
				table.insert(t23, t24[i])
			end

			local v294 = table.concat(t23, ", ")

			if u35 then
				u35.Text = "Modes: " .. v294
			end
		elseif u35 then
			u35.Text = "Select at least one mode."

			return
		end

		return
	end
end
local function openMenu()
	u55 = true

	local v295 = t2.isAvailable() and not u11

	if v295 then
		v295 = LocalPlayer:GetAttribute("TutorialPhase") == 1
	end

	if v295 then
		local remotes: Instance = matchmakingShared:FindFirstChild("Remotes")
		local tutorialPanelOpened: Instance = remotes and remotes:FindFirstChild("TutorialPanelOpened")

		if tutorialPanelOpened and tutorialPanelOpened:IsA("RemoteEvent") then
			tutorialPanelOpened:FireServer()
		end
	end

	render()
end
local function closeMenu()
	u55 = false
	render()
end

local u107: boolean = false

local function returnToLobby()
	if u107 then
		return
	end

	u107 = true
	n3 += 1

	local v298: number = n3

	screenWipe.cover(0, "Teleporting to Lobby")
	task.delay(12, function()
		if u107 and n3 == v298 then
			u107 = false
			screenWipe.reveal()
			warn(("[Matchmaking] Return-to-lobby teleport did not land within %ds; restoring UI."):format(12))
		end
	end)

	local ok, result = pcall(function()
		teleportService:Teleport(game.PlaceId, LocalPlayer)
	end)

	if not ok then
		if v298 == n3 then
			u107 = false
			screenWipe.reveal()
		end

		local text: string = tostring(result)

		warn("[Matchmaking] Return-to-lobby teleport failed: " .. text)
	end
end

playBtn.Activated:Connect(openMenu)
openEvent.OnClientEvent:Connect(openMenu)
matchmakingShared:GetAttributeChangedSignal("MMEnabled"):Connect(render)
backBtn.Activated:Connect(function()
	u55 = false
	render()
end)

if closeButton then
	closeButton.Activated:Connect(closeMenu)
end

local textLabel: Instance = backBtn:FindFirstChildWhichIsA("TextLabel")

if textLabel then
	textLabel.Text = "Back"

	for _, v in ipairs(textLabel:GetDescendants()) do
		if v:IsA("TextLabel") then
			v.Text = "Back"
		end
	end
end

for _, v in ipairs(config.ModeOrder) do
	local v114 = t7[v]

	if v114 then
		v114.button.Activated:Connect(function()
			if not u60 then
				return
			end

			local v302 = u60

			if v302 ~= nil and v302.activeTickets ~= nil and next(v302.activeTickets) ~= nil then
				return
			end

			if u60.leaderUserId ~= LocalPlayer.UserId then
				notifyLeaderOnly("change the match modes")

				return
			end

			if not (#u60.members <= config.Modes[v].teamSize) then
				return
			end

			t8[v] = not t8[v] or nil

			local setModes = t2.setModes

			v302 = currentSelectionList()
			setModes(v302)
			render()
		end)
	end
end

startBtn.Activated:Connect(function()
	if u56 then
		return
	end

	if not u60 then
		return
	end

	local v304 = u60

	if v304 ~= nil and v304.activeTickets ~= nil and next(v304.activeTickets) ~= nil then
		return
	end

	if u60.leaderUserId ~= LocalPlayer.UserId then
		notifyLeaderOnly("start matchmaking")

		return
	end

	local v305 = fittingSelectedModes(u60)

	if #v305 == 0 then
		if u35 then
			u35.Text = "Select at least one mode that fits your party."
		end

		return
	end

	sound:Play("Misc.StartQueueSound", workspace)
	u57 = true
	u55 = false
	u56 = true
	render()

	local v306, v307, text = pcall(function()
		return t2.queueModes(v305)
	end)

	u56 = false
	u57 = false

	if not v306 or v307 == false then
		u55 = true

		if not v306 or type(text) ~= "string" or text == "" then
			local s1: string = if v306 then "Queue failed." else "Queue failed: " .. tostring(v307)

			if u35 then
				u35.Text = s1
			end
		elseif u35 then
			u35.Text = text
		end
	end

	render()
end)
u64 = function()
	local v310 = u60

	if v310 ~= nil and v310.matched == true then
		return
	end

	if u60 and u60.leaderUserId ~= LocalPlayer.UserId then
		notifyLeaderOnly("cancel matchmaking")

		return
	end

	if u56 then
		return
	end

	u56 = true
	u57 = false
	u58 = true
	n1 += 1

	local v311: number = n1

	task.delay(5, function()
		if u58 and n1 == v311 then
			u58 = false
			render()
		end
	end)
	u55 = false
	render()

	local v312, v313, v314 = pcall(function()
		return t2.cancelQueue()
	end)

	u56 = false

	if not v312 or v313 == false then
		if v311 == n1 then
			u58 = false
		end

		local text: string = tostring(if v312 then v314 or "rejected" else v313)

		if u35 then
			u35.Text = "Cancel failed: " .. text
		end

		local v316 = t2.getMyState()

		if v316 then
			u60 = v316
		end

		if v316 and v316.modeSelection then
			local modeSelection = v316.modeSelection

			table.clear(t8)

			if type(modeSelection) == "table" then
				for _, v in ipairs(modeSelection) do
					t8[v] = true
				end
			end
		end
	end

	render()
end
cancelBtn.Activated:Connect(u64)
LocalPlayer:GetAttributeChangedSignal("DataReady"):Connect(render)
LocalPlayer:GetAttributeChangedSignal("InMatch"):Connect(render)
LocalPlayer:GetAttributeChangedSignal("VotingPhase"):Connect(render)
LocalPlayer:GetAttributeChangedSignal("DuelStationQueued"):Connect(render)
LocalPlayer:GetAttributeChangedSignal("Spectating"):Connect(render)
LocalPlayer:GetAttributeChangedSignal("TutorialPhase"):Connect(render)
LocalPlayer:GetAttributeChangedSignal("MMRequeueReady"):Connect(render)
LocalPlayer:GetAttributeChangedSignal("_WinScreenOpen"):Connect(render)
LocalPlayer:GetAttributeChangedSignal("_SpinnerOpen"):Connect(render)

local function updateMatchFoundFailsafe(p28)
	if not p28 then
		if u65 and not u66 then
			screenWipe.reveal()
		end

		u65 = false
		u66 = false
		n2 += 1
	elseif not u65 then
		u65 = true
		u66 = false
		n2 += 1

		local v321: number = n2

		sound:Play("Misc.MatchFoundSound", workspace)
		screenWipe.cover(nil, "Found a Match! Teleporting")
		task.delay(12, function()
			if n2 == v321 and u65 and not u66 then
				u66 = true
				screenWipe.reveal()
				warn(("[Matchmaking] Match-found teleport did not land within %ds; restoring lobby."):format(12))
				render()
			end
		end)

		return
	end
end
local function applySnapshot(p29)
	u60 = p29

	if u58 then
		if p29 == nil or p29.activeTickets == nil or next(p29.activeTickets) == nil then
			u58 = false
			n1 += 1
		end
	end

	if p29 and p29.modeSelection then
		local modeSelection = p29.modeSelection

		table.clear(t8)

		if type(modeSelection) == "table" then
			for _, v in ipairs(modeSelection) do
				t8[v] = true
			end
		end
	end

	if u63 then
		u63()
	end

	updateMatchFoundFailsafe(p29 ~= nil and p29.matched == true)
	render()
end

t2.subscribe(applySnapshot)
teleportService.TeleportInitFailed:Connect(function()
	if u65 and not u66 then
		u66 = true
		screenWipe.reveal()
		render()
	elseif u107 then
		u107 = false
		n3 += 1
		screenWipe.reveal()
		render()
	end
end)

if u11 then
	local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
	local windowBlur = require(replicatedStorageShared:WaitForChild("WindowBlur"))
	local u119 = windowBlur.isActive()
	local colorSequenceKeypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(201, 255, 144))
	local colorSequenceKeypoint2 = ColorSequenceKeypoint.new(0.08, Color3.fromRGB(202, 255, 146))
	local colorSequenceKeypoint3 = ColorSequenceKeypoint.new(0.09, Color3.fromRGB(143, 237, 36))
	local t9: {[any]: any} = {
		colorSequenceKeypoint,
		colorSequenceKeypoint2,
		colorSequenceKeypoint3,
		ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 161, 0))
	}
	local color32 = Color3.fromRGB(29, 104, 6)
	local color33 = Color3.fromRGB(0, 40, 5)
	local colorSequenceKeypoint4 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 152, 154))
	local colorSequenceKeypoint5 = ColorSequenceKeypoint.new(0.08, Color3.fromRGB(255, 166, 167))
	local colorSequenceKeypoint6 = ColorSequenceKeypoint.new(0.09, Color3.fromRGB(255, 74, 74))
	local t10: {[any]: any} = {
		colorSequenceKeypoint4,
		colorSequenceKeypoint5,
		colorSequenceKeypoint6,
		ColorSequenceKeypoint.new(1, Color3.fromRGB(129, 20, 20))
	}
	local color34 = Color3.fromRGB(104, 0, 0)
	local color35 = Color3.fromRGB(40, 0, 0)
	local colorSequenceKeypoint7 = ColorSequenceKeypoint.new(0, Color3.fromRGB(153, 209, 255))
	local colorSequenceKeypoint8 = ColorSequenceKeypoint.new(0.08, Color3.fromRGB(140, 200, 255))
	local colorSequenceKeypoint9 = ColorSequenceKeypoint.new(0.09, Color3.fromRGB(38, 132, 255))
	local t11: {[any]: any} = {
		colorSequenceKeypoint7,
		colorSequenceKeypoint8,
		colorSequenceKeypoint9,
		ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 80, 190))
	}
	local color36 = Color3.fromRGB(10, 54, 120)
	local color37 = Color3.fromRGB(0, 20, 46)
	local colorSequenceKeypoint10 = ColorSequenceKeypoint.new(0, Color3.fromRGB(190, 190, 196))
	local colorSequenceKeypoint11 = ColorSequenceKeypoint.new(0.09, Color3.fromRGB(138, 138, 144))
	local t12: {[any]: any} = {
		colorSequenceKeypoint10,
		colorSequenceKeypoint11,
		ColorSequenceKeypoint.new(1, Color3.fromRGB(92, 92, 98))
	}
	local color38 = Color3.fromRGB(70, 70, 74)
	local color39 = Color3.fromRGB(28, 28, 32)

	local function setButtonText(p30, text)
		for _, v in ipairs(p30:GetDescendants()) do
			if v:IsA("TextLabel") then
				v.Text = text
			end
		end
	end
	local function themeButton(p32, p33)
		local uiGradient = p32:FindFirstChildOfClass("UIGradient")

		if uiGradient then
			uiGradient.Color = ColorSequence.new(p33.grad)
		end

		for _, v in ipairs(p32:GetChildren()) do
			if v:IsA("TextLabel") then
				v.TextColor3 = p33.shadow

				local textLabel2 = v:FindFirstChildOfClass("TextLabel")
				local uiStroke = textLabel2 and textLabel2:FindFirstChildOfClass("UIStroke")

				if uiStroke then
					uiStroke.Color = p33.stroke
				end
			end
		end
	end
	local function stripKeybind(p34)
		local keybind = p34:FindFirstChild("Keybind")

		if keybind and keybind:IsA("GuiObject") then
			keybind.Visible = false
		end
	end

	local reservedActions: Frame = Instance.new("Frame")

	reservedActions.Name = "ReservedActions"
	reservedActions.BackgroundTransparency = 1
	reservedActions.Active = false
	reservedActions.Size = UDim2.fromScale(1, 1)
	reservedActions.Position = UDim2.fromScale(0, 0)
	reservedActions.Visible = false
	reservedActions.Parent = scriptParent

	local function makeStackButton(name, p36, p37)
		local clone: Instance = playBtn:Clone()

		clone.Name = name
		clone.Visible = true
		setButtonText(clone, p36)
		themeButton(clone, p37)

		local keybind: Instance = clone:FindFirstChild("Keybind")

		if keybind and keybind:IsA("GuiObject") then
			keybind.Visible = false
		end

		clone.Parent = reservedActions

		return clone
	end

	local t13 = {
		green = { grad = t9, shadow = color32, stroke = color33 },
		red = { grad = t10, shadow = color34, stroke = color35 },
		blue = { grad = t11, shadow = color36, stroke = color37 },
		gray = { grad = t12, shadow = color38, stroke = color39 }
	}
	local green = t13.green
	local clone: Instance = playBtn:Clone()

	clone.Name = "PlayNow"
	clone.Visible = true
	setButtonText(clone, "Play Again")
	themeButton(clone, green)

	local keybind: Instance = clone:FindFirstChild("Keybind")

	if keybind and keybind:IsA("GuiObject") then
		keybind.Visible = false
	end

	clone.Parent = reservedActions

	local red = t13.red
	local clone2: Instance = playBtn:Clone()

	clone2.Name = "ReturnToLobby"
	clone2.Visible = true
	setButtonText(clone2, "Return to Lobby")
	themeButton(clone2, red)

	local keybind2: Instance = clone2:FindFirstChild("Keybind")

	if keybind2 and keybind2:IsA("GuiObject") then
		keybind2.Visible = false
	end

	clone2.Parent = reservedActions
	makeStackButton = playBtn.Parent
	t13 = playBtn.Size.X.Scale * makeStackButton.Size.X.Scale

	local n5 = playBtn.Size.Y.Scale * makeStackButton.Size.Y.Scale
	local n6 = t13 * 0.06

	clone.Size = UDim2.fromScale(t13, n5)
	clone.AnchorPoint = Vector2.new(1, 1)
	clone.Position = UDim2.fromScale(0.5 - n6 / 2, 0.825)
	clone2.Size = UDim2.fromScale(t13, n5)
	clone2.AnchorPoint = Vector2.new(0, 1)
	clone2.Position = UDim2.fromScale(0.5 + n6 / 2, 0.825)

	local party = makeStackButton:WaitForChild("Party")

	t13 = party.Size.X.Scale * makeStackButton.Size.X.Scale

	local n7 = party.Size.Y.Scale * makeStackButton.Size.Y.Scale

	party.Parent = reservedActions
	party.AnchorPoint = Vector2.new(0.5, 1)
	party.Size = UDim2.fromScale(t13, n7)
	party.Position = UDim2.fromScale(0.5, 0.825 - n5 - n5 * 0.2)

	local list = party:FindFirstChild("List")

	n6 = list

	if n6 then
		n6 = list:FindFirstChildOfClass("UIListLayout")
	end

	if n6 then
		n6.HorizontalAlignment = Enum.HorizontalAlignment.Center
	end

	local u160: boolean = false

	u61 = reservedActions

	local function playAgainImpl()
		if u56 then
			return
		end

		if u60 and u60.leaderUserId ~= LocalPlayer.UserId then
			notifyLeaderOnly("start matchmaking")

			return
		end

		sound:Play("Misc.StartQueueSound", workspace)
		u57 = true
		u55 = false
		u56 = true
		render()
		task.spawn(function()
			local v356 = os.clock()

			while true do
				if LocalPlayer:GetAttribute("MMRequeueReady") == true or not (os.clock() - v356 < 5) then
					break
				end

				task.wait(0.1)
			end

			v356 = t2.getMyState()

			if v356 then
				u60 = v356
			end

			if v356 and v356.modeSelection then
				local modeSelection = v356.modeSelection

				table.clear(t8)

				if type(modeSelection) == "table" then
					for _, v in ipairs(modeSelection) do
						t8[v] = true
					end
				end
			end

			local v360 = fittingSelectedModes(u60)
			local u361 = false
			local v362 = nil

			if #v360 > 0 then
				local ok, result = pcall(function()
					return t2.queueModes(v360)
				end)

				u361 = ok
				v362 = result
			end

			u56 = false
			u57 = false

			if #v360 == 0 or not u361 or v362 == false then
				u55 = false

				if #v360 == 0 and _G.Notify then
					_G.Notify({
						notifType = "FailNotification",
						errorMessage = "No modes selected that fit your party."
					})
				end
			end

			render()
		end)
	end

	u62 = function(_, p39, p40)
		if u160 and (LocalPlayer:GetAttribute("VotingPhase") == true or LocalPlayer:GetAttribute("InMatch") == true) then
			u160 = false
		end

		local u347 = not p39 and not u58 and not u55 and not p40 and not u160 and not u119

		if u347 then
			u347 = LocalPlayer:GetAttribute("_SpinnerOpen") ~= true and playEligible()
		end

		reservedActions.Visible = u347
	end
	windowBlur.onActiveChanged(function(p41)
		u119 = p41
		render()
	end)
	clone.Activated:Connect(openMenu)
	clone2.Activated:Connect(returnToLobby)

	local postMatchIntent: Instance = scriptParent:FindFirstChild("PostMatchIntent")

	if postMatchIntent and postMatchIntent:IsA("BindableEvent") then
		postMatchIntent.Event:Connect(function(p42)
			if p42 == "PlayAgain" then
				playAgainImpl()
			elseif p42 == "OpenPanel" then
				openMenu()
			end
		end)
	end

	n5 = function()
		if postMatchIntent then
			postMatchIntent:SetAttribute("IsLeader", u60 ~= nil and u60.leaderUserId == LocalPlayer.UserId)
		end
	end
	t2.subscribe(n5)

	if postMatchIntent then
		postMatchIntent:SetAttribute("IsLeader", u60 ~= nil and u60.leaderUserId == LocalPlayer.UserId)
	end

	u63 = n5
	task.spawn(function()
		local remotes: Instance = matchmakingShared:WaitForChild("Remotes", 10)

		if not remotes then
			return
		end

		local rematchStarting: Instance = remotes:WaitForChild("RematchStarting", 10)

		if rematchStarting then
			rematchStarting.OnClientEvent:Connect(function()
				u160 = true
				render()
				task.delay(10, function()
					if u160 then
						u160 = false
						render()
					end
				end)
			end)
		end

		local autoRequeue: Instance = remotes:WaitForChild("AutoRequeue", 10)

		if autoRequeue then
			autoRequeue.OnClientEvent:Connect(function()
				local v365 = t2.getMyState()

				if v365 then
					applySnapshot(v365)
				end

				if u60 and u60.leaderUserId == LocalPlayer.UserId then
					playAgainImpl()
				end
			end)
		end
	end)
end

render()
scriptParent.Enabled = true
task.spawn(function()
	local v353 = t2.getMyState()

	if v353 then
		applySnapshot(v353)
	end
end)
task.spawn(function()
	local ok, result = pcall(function()
		return teleportService:GetLocalPlayerTeleportData()
	end)

	if ok and type(result) == "table" and result.boardingFailed then
		openMenu()
	end
end)
