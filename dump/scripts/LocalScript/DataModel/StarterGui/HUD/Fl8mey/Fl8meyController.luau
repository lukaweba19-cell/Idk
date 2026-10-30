-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local tweenService: TweenService = game:GetService("TweenService")
local userInputService: UserInputService = game:GetService("UserInputService")
local LocalPlayer: Player = players.LocalPlayer
local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui")
local activeWindowChanged: Instance = replicatedStorage:WaitForChild("Bindables"):WaitForChild("ActiveWindowChanged")
local fl8mey_Claim: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("Fl8mey_Claim")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local windowBlur = require(shared:WaitForChild("WindowBlur"))
local shineEffect = require(shared:WaitForChild("ShineEffect"))
local eventTimer = require(shared:WaitForChild("EventTimer"))
local scriptParent: Instance = script.Parent
local fl8meyCards = require(scriptParent:WaitForChild("Fl8meyCards"))
local fl8meyTooltip = require(scriptParent:WaitForChild("Fl8meyTooltip"))
local scriptParentParent: Instance = scriptParent.Parent
local timer: Instance = scriptParent:WaitForChild("Timer")
local rarity: Instance = scriptParent:FindFirstChild("Rarity")
local closeButton: Instance = scriptParent:FindFirstChild("CloseButton")
local tweenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function rs(p1)
	return replicatedStorage:GetAttribute(p1)
end
local function me(p2)
	return LocalPlayer:GetAttribute(p2)
end
local function now()
	return workspace:GetServerTimeNow()
end
local function phase()
	local v74: number = workspace:GetServerTimeNow()
	local fl8StartAt: any = replicatedStorage:GetAttribute("Fl8StartAt")

	if v74 < (fl8StartAt or math.huge) then
		return "soon"
	end

	if v74 >= (replicatedStorage:GetAttribute("Fl8EndAt") or 0) then
		return "over"
	end

	return "running"
end
local function eventRunning()
	local u76: boolean = false

	if replicatedStorage:GetAttribute("Fl8Enabled") == true then
		local v77: number = workspace:GetServerTimeNow()
		local fl8StartAt: any = replicatedStorage:GetAttribute("Fl8StartAt")

		u76 = (if v77 < (fl8StartAt or math.huge) then "soon" else if v77 >= (replicatedStorage:GetAttribute("Fl8EndAt") or 0) then "over" else "running") == "running"
	end

	return u76
end
local function num(p3, p4)
	local attributeValue: any = replicatedStorage:GetAttribute(p3)

	if typeof(attributeValue) == "number" then
		return attributeValue
	end

	return p4
end
local function eliteWaiting()
	local u82: boolean = false

	if replicatedStorage:GetAttribute("Fl8Enabled") == true then
		u82 = false

		if LocalPlayer:GetAttribute("Fl8Elite") == nil then
			local fl8Kills: any = LocalPlayer:GetAttribute("Fl8Kills")
			local fl8_eliteKills: any = replicatedStorage:GetAttribute("Fl8_eliteKills")
			local typeName: string = typeof(fl8_eliteKills)

			u82 = (fl8Kills or 0) >= (if typeName == "number" then fl8_eliteKills else 2500)
		end
	end

	return u82
end

local u29 = nil
local n1: number = 0
local u31: boolean = false

local function item(p5)
	local attributeValue: any = replicatedStorage:GetAttribute("Fl8Name_" .. p5)
	local attributeValue2: any = replicatedStorage:GetAttribute("Fl8Icon_" .. p5)
	local attributeValue3: any = replicatedStorage:GetAttribute("Fl8Rarity_" .. p5)

	return {
		name = attributeValue or "Shedletsekkar",
		icon = attributeValue2,
		rarity = attributeValue3
	}
end
local function rsItem(p6)
	local attributeValue: any = replicatedStorage:GetAttribute(p6 .. "Name")

	if typeof(attributeValue) == "string" then
		local attributeValue4: any = replicatedStorage:GetAttribute(p6 .. "Icon")
		local attributeValue5: any = replicatedStorage:GetAttribute(p6 .. "Rarity")

		return {
			name = attributeValue,
			icon = attributeValue4,
			rarity = attributeValue5
		}
	end

	return nil
end
local function touchOnly()
	return userInputService.TouchEnabled and not userInputService.MouseEnabled
end
local function rewardHintText()
	if userInputService.TouchEnabled and not userInputService.MouseEnabled then
		return "Tap for rewards"
	end

	if userInputService.GamepadEnabled and not userInputService.MouseEnabled then
		return "Select for rewards"
	end

	return "Hover for rewards"
end
local function state()
	local v94: number = workspace:GetServerTimeNow()
	local fl8StartAt: any = replicatedStorage:GetAttribute("Fl8StartAt")
	local t2: {[any]: any} = {
		phase = if v94 < (fl8StartAt or math.huge) then "soon" else if v94 >= (replicatedStorage:GetAttribute("Fl8EndAt") or 0) then "over" else "running",
		games = LocalPlayer:GetAttribute("Fl8Games") or 0,
		kills = LocalPlayer:GetAttribute("Fl8Kills") or 0,
		main = LocalPlayer:GetAttribute("Fl8Main") == true,
		secret = LocalPlayer:GetAttribute("Fl8Secret") == true,
		elite = LocalPlayer:GetAttribute("Fl8Elite")
	}
	local fl8_mainGames: any = replicatedStorage:GetAttribute("Fl8_mainGames")

	t2.mainGames = if typeof(fl8_mainGames) == "number" then fl8_mainGames else 5

	local fl8_mainKills: any = replicatedStorage:GetAttribute("Fl8_mainKills")

	t2.mainKills = if typeof(fl8_mainKills) == "number" then fl8_mainKills else 5

	local fl8_eliteKills: any = replicatedStorage:GetAttribute("Fl8_eliteKills")

	t2.eliteKills = if typeof(fl8_eliteKills) == "number" then fl8_eliteKills else 2500

	local fl8_mainCoins: any = replicatedStorage:GetAttribute("Fl8_mainCoins")

	t2.mainCoins = if typeof(fl8_mainCoins) == "number" then fl8_mainCoins else 0

	local fl8_mainTickets: any = replicatedStorage:GetAttribute("Fl8_mainTickets")

	t2.mainTickets = if typeof(fl8_mainTickets) == "number" then fl8_mainTickets else 0

	local fl8_secretCoins: any = replicatedStorage:GetAttribute("Fl8_secretCoins")

	t2.secretCoins = if typeof(fl8_secretCoins) == "number" then fl8_secretCoins else 0

	local fl8_secretTickets: any = replicatedStorage:GetAttribute("Fl8_secretTickets")

	t2.secretTickets = if typeof(fl8_secretTickets) == "number" then fl8_secretTickets else 0

	local fl8_eliteCoins: any = replicatedStorage:GetAttribute("Fl8_eliteCoins")

	t2.eliteCoins = if typeof(fl8_eliteCoins) == "number" then fl8_eliteCoins else 0

	local fl8_eliteTickets: any = replicatedStorage:GetAttribute("Fl8_eliteTickets")

	t2.eliteTickets = if typeof(fl8_eliteTickets) == "number" then fl8_eliteTickets else 0
	t2.secretFinisher = rsItem("Fl8SecretFinisher")
	t2.secretEmote = rsItem("Fl8SecretEmote")
	t2.mainKnife = rsItem("Fl8MainKnife")
	t2.eliteFinisher = rsItem("Fl8EliteFinisher")
	t2.rewardHint = if userInputService.TouchEnabled and not userInputService.MouseEnabled then "Tap for rewards" else if userInputService.GamepadEnabled and not userInputService.MouseEnabled then "Select for rewards" else "Hover for rewards"
	t2.hint = replicatedStorage:GetAttribute("Fl8SecretHint") or "???"
	t2.ticketIcon = replicatedStorage:GetAttribute("Fl8TicketIcon")

	local fl8Name_Knife: any = replicatedStorage:GetAttribute("Fl8Name_Knife")
	local fl8Icon_Knife: any = replicatedStorage:GetAttribute("Fl8Icon_Knife")
	local fl8Rarity_Knife: any = replicatedStorage:GetAttribute("Fl8Rarity_Knife")
	local fl8Name_Gun: any = replicatedStorage:GetAttribute("Fl8Name_Gun")
	local fl8Icon_Gun: any = replicatedStorage:GetAttribute("Fl8Icon_Gun")
	local fl8Rarity_Gun: any = replicatedStorage:GetAttribute("Fl8Rarity_Gun")

	t2.items = {
		Knife = {
			name = fl8Name_Knife or "Shedletsekkar",
			icon = fl8Icon_Knife,
			rarity = fl8Rarity_Knife
		},
		Gun = {
			name = fl8Name_Gun or "Shedletsekkar",
			icon = fl8Icon_Gun,
			rarity = fl8Rarity_Gun
		}
	}
	t2.confirm = u29
	t2.claiming = u31

	return t2
end

local u37: boolean = false
local u38 = nil

local function onClaim(p7)
	if u31 then
		return
	end

	if p7 ~= u29 then
		u29 = p7
		n1 += 1

		local v113: number = n1

		u38()
		task.delay(4, function()
			if n1 == v113 and u29 == p7 then
				u29 = nil

				if u37 then
					u38()
				end
			end
		end)

		return
	end

	u29 = nil
	u31 = true
	u38()

	local ok, result = pcall(function()
		return fl8mey_Claim:InvokeServer(p7)
	end)

	if not ok then
		local text: string = tostring(result)

		warn("[Fl8meyController] claim failed: " .. text)
	end

	u31 = false

	if u37 then
		u38()
	end
end
local function setText(p8, text)
	if p8 and p8:IsA("TextLabel") then
		p8.Text = text

		for iterFirst, iterSecond in p8:GetDescendants() do
			if iterSecond:IsA("TextLabel") then
				iterSecond.Text = text
			end
		end
	end
end

local t1: {[any]: any} = {}

for iterFirst, iterSecond in scriptParent:WaitForChild("Content"):WaitForChild("Quest3"):GetChildren() do
	local uIGradient = if iterSecond:IsA("UIStroke") then iterSecond:FindFirstChildOfClass("UIGradient") else nil

	if uIGradient then
		table.insert(t1, uIGradient)
	end
end

game:GetService("RunService").Heartbeat:Connect(function(deltaTime: number)
	if not u37 then
		return
	end

	for key, value in t1 do
		value.Rotation = (value.Rotation + deltaTime * 90) % 360
	end
end)

local function renderStatus()
	if not rarity then
		return
	end

	local v124: number = workspace:GetServerTimeNow()
	local fl8StartAt: any = replicatedStorage:GetAttribute("Fl8StartAt")
	local s1: string = if v124 < (fl8StartAt or math.huge) then "soon" else if v124 >= (replicatedStorage:GetAttribute("Fl8EndAt") or 0) then "over" else "running"
	local s2

	if s1 == "soon" then
		s2 = "Shedletsekkar's quests start soon."
	elseif s1 == "over" then
		local u128: boolean = false

		if replicatedStorage:GetAttribute("Fl8Enabled") == true then
			u128 = false

			if LocalPlayer:GetAttribute("Fl8Elite") == nil then
				local fl8Kills: any = LocalPlayer:GetAttribute("Fl8Kills")
				local fl8_eliteKills: any = replicatedStorage:GetAttribute("Fl8_eliteKills")
				local typeName: string = typeof(fl8_eliteKills)

				u128 = (fl8Kills or 0) >= (if typeName == "number" then fl8_eliteKills else 2500)
			end
		end

		s2 = if u128 then "The event is over, but your Elite reward is still waiting!" else "The event is over. Thanks for playing!"
	else
		s2 = "Complete quests for exclusive rewards!"
	end

	rarity.Text = s2
end
local function renderTimer()
	local fl8EndAt: any = replicatedStorage:GetAttribute("Fl8EndAt")
	local v133: number = workspace:GetServerTimeNow()
	local n1 = (fl8EndAt or 0) - v133
	local textLabel: Instance = timer:FindFirstChild("TextLabel")
	local s1 = if n1 <= 0 then "Ended" else eventTimer.format(n1)

	setText(textLabel, s1)
end

local content: Instance = scriptParent:WaitForChild("Content")
local u48 = nil
local u49 = nil

local function hideTip()
	fl8meyTooltip.hide(u48)
	u49 = nil
end

local u51: boolean = false

local function showTip(p11, p12)
	if not u37 then
		return
	end

	local foundChild: Instance = content:FindFirstChild("Quest" .. p11)

	if not foundChild or not foundChild:IsA("GuiObject") then
		return
	end

	if not u48 then
		local v140: Instance = scriptParent:FindFirstAncestorWhichIsA("LayerCollector")

		if not v140 then
			return
		end

		u48 = fl8meyTooltip.new(v140)
	end

	local fl8meyTooltipFill = fl8meyTooltip.fill
	local v142 = u48
	local fl8meyCardsRewardsFor = fl8meyCards.rewardsFor
	local v144 = state()

	fl8meyTooltipFill(v142, fl8meyCardsRewardsFor(p11, v144))
	u51 = p12 == true

	if u51 then
		fl8meyTooltip.showBeside(u48, foundChild)
	else
		fl8meyTooltip.showAtMouse(u48)
	end

	u49 = p11
end

for i = 1, 3 do
	local v54: Instance = content:WaitForChild("Quest" .. i)

	if v54:IsA("GuiButton") then
		v54.MouseEnter:Connect(function()
			if not userInputService.TouchEnabled or not not userInputService.MouseEnabled then
				showTip(i)
			end
		end)
		v54.MouseLeave:Connect(function()
			if u49 == i and (not userInputService.TouchEnabled or not not userInputService.MouseEnabled) then
				fl8meyTooltip.hide(u48)
				u49 = nil
			end
		end)
		v54.SelectionGained:Connect(function()
			showTip(i, true)
		end)
		v54.SelectionLost:Connect(function()
			if u49 == i then
				fl8meyTooltip.hide(u48)
				u49 = nil
			end
		end)
		v54.Activated:Connect(function()
			if u49 == i then
				fl8meyTooltip.hide(u48)
				u49 = nil

				return
			end

			showTip(i, userInputService.TouchEnabled and not userInputService.MouseEnabled)
		end)
	end
end

userInputService.InputBegan:Connect(function(input: InputObject)
	if input.UserInputType == Enum.UserInputType.Touch and u49 then
		fl8meyTooltip.hide(u48)
		u49 = nil
	end
end)
u38 = function()
	local fl8meyCardsRender = fl8meyCards.render
	local v147 = state()

	fl8meyCardsRender(scriptParent, v147, onClaim)

	if rarity then
		local v148: number = workspace:GetServerTimeNow()
		local fl8StartAt: any = replicatedStorage:GetAttribute("Fl8StartAt")
		local s1: string = if v148 < (fl8StartAt or math.huge) then "soon" else if v148 >= (replicatedStorage:GetAttribute("Fl8EndAt") or 0) then "over" else "running"
		local s2

		if s1 == "soon" then
			s2 = "Shedletsekkar's quests start soon."
		elseif s1 == "over" then
			local u152: boolean = false

			if replicatedStorage:GetAttribute("Fl8Enabled") == true then
				u152 = false

				if LocalPlayer:GetAttribute("Fl8Elite") == nil then
					local fl8Kills: any = LocalPlayer:GetAttribute("Fl8Kills")
					local fl8_eliteKills: any = replicatedStorage:GetAttribute("Fl8_eliteKills")
					local typeName: string = typeof(fl8_eliteKills)

					u152 = (fl8Kills or 0) >= (if typeName == "number" then fl8_eliteKills else 2500)
				end
			end

			s2 = if u152 then "The event is over, but your Elite reward is still waiting!" else "The event is over. Thanks for playing!"
		else
			s2 = "Complete quests for exclusive rewards!"
		end

		rarity.Text = s2
	end

	local fl8EndAt: any = replicatedStorage:GetAttribute("Fl8EndAt")

	v147 = workspace:GetServerTimeNow()

	local n1 = (fl8EndAt or 0) - v147
	local textLabel: Instance = timer:FindFirstChild("TextLabel")
	local s3 = if n1 <= 0 then "Ended" else eventTimer.format(n1)

	setText(textLabel, s3)

	if u49 then
		showTip(u49, u51)
	end
end

local u55 = nil

task.spawn(function()
	local hud: Instance = playerGui:WaitForChild("HUD", 10)
	local blackBackground2: Instance = hud and hud:FindFirstChild("BlackBackground2")

	if blackBackground2 and blackBackground2:IsA("GuiObject") then
		u55 = blackBackground2
	end
end)

local u56 = nil
local u57 = nil

local function ensurePopScale()
	if u56 and u56.Parent == scriptParent then
		return u56
	end

	local popScale: UIScale = Instance.new("UIScale")

	popScale.Name = "PopScale"
	popScale.Parent = scriptParent
	u56 = popScale

	return popScale
end

local u59 = nil

local function hideBoard()
	local leaderboardServiceUI: Instance = playerGui:FindFirstChild("LeaderboardServiceUI")

	if leaderboardServiceUI and leaderboardServiceUI:IsA("ScreenGui") and leaderboardServiceUI.Enabled then
		leaderboardServiceUI.Enabled = false
		u59 = leaderboardServiceUI
	end
end
local function restoreBoard()
	if u59 and u59.Parent then
		u59.Enabled = true
	end

	u59 = nil
end
local function open()
	if u37 then
		return
	end

	u37 = true
	u29 = nil

	local leaderboardServiceUI: Instance = playerGui:FindFirstChild("LeaderboardServiceUI")

	if leaderboardServiceUI and leaderboardServiceUI:IsA("ScreenGui") and leaderboardServiceUI.Enabled then
		leaderboardServiceUI.Enabled = false
		u59 = leaderboardServiceUI
	end

	u38()

	local v165

	if u56 and u56.Parent == scriptParent then
		v165 = u56
	else
		local popScale: UIScale = Instance.new("UIScale")

		popScale.Name = "PopScale"
		popScale.Parent = scriptParent
		u56 = popScale
		v165 = popScale
	end

	v165.Scale = 0.85
	scriptParent.Visible = true

	if u55 then
		u55.Visible = true
	end

	if u57 then
		u57:Cancel()
	end

	u57 = tweenService:Create(v165, tweenInfo, { Scale = 1 })
	u57:Play()

	local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

	LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) + 1)
	windowBlur.show("Fl8mey")
	activeWindowChanged:Fire("Fl8mey")
	task.spawn(function()
		while u37 do
			task.wait(1)

			if u37 then
				if rarity then
					local v203: number = workspace:GetServerTimeNow()
					local fl8StartAt: any = replicatedStorage:GetAttribute("Fl8StartAt")
					local s1: string = if v203 < (fl8StartAt or math.huge) then "soon" else if v203 >= (replicatedStorage:GetAttribute("Fl8EndAt") or 0) then "over" else "running"
					local s2

					if s1 == "soon" then
						s2 = "Shedletsekkar's quests start soon."
					elseif s1 == "over" then
						local u207: boolean = false

						if replicatedStorage:GetAttribute("Fl8Enabled") == true then
							u207 = false

							if LocalPlayer:GetAttribute("Fl8Elite") == nil then
								local fl8Kills: any = LocalPlayer:GetAttribute("Fl8Kills")
								local fl8_eliteKills: any = replicatedStorage:GetAttribute("Fl8_eliteKills")
								local typeName: string = typeof(fl8_eliteKills)

								u207 = (fl8Kills or 0) >= (if typeName == "number" then fl8_eliteKills else 2500)
							end
						end

						s2 = if u207 then "The event is over, but your Elite reward is still waiting!" else "The event is over. Thanks for playing!"
					else
						s2 = "Complete quests for exclusive rewards!"
					end

					rarity.Text = s2
				end

				local fl8EndAt: any = replicatedStorage:GetAttribute("Fl8EndAt")
				local v212: number = workspace:GetServerTimeNow()
				local n1 = (fl8EndAt or 0) - v212
				local textLabel: Instance = timer:FindFirstChild("TextLabel")
				local s3 = if n1 <= 0 then "Ended" else eventTimer.format(n1)

				setText(textLabel, s3)
			end
		end
	end)
end
local function close()
	if not u37 then
		return
	end

	u37 = false
	u29 = nil
	fl8meyTooltip.hide(u48)
	u49 = nil

	if u59 and u59.Parent then
		u59.Enabled = true
	end

	u59 = nil

	local v168

	if u56 and u56.Parent == scriptParent then
		v168 = u56
	else
		local popScale: UIScale = Instance.new("UIScale")

		popScale.Name = "PopScale"
		popScale.Parent = scriptParent
		u56 = popScale
		v168 = popScale
	end

	if u57 then
		u57:Cancel()
	end

	local v170: Tween = tweenService:Create(v168, tweenInfo2, { Scale = 0.92 })

	u57 = v170
	v170:Play()
	v170.Completed:Once(function()
		if not u37 then
			scriptParent.Visible = false

			if u55 then
				u55.Visible = false
			end

			v168.Scale = 1
		end
	end)

	local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
	local v172 = math.max((mouseUnlocked or 0) - 1, 0)

	LocalPlayer:SetAttribute("MouseUnlocked", v172)
	windowBlur.hide("Fl8mey")
end

scriptParent.Visible = false
activeWindowChanged.Event:Connect(function(p14)
	if p14 ~= "Fl8mey" and u37 then
		close()
	end
end)

if closeButton and (not not closeButton:IsA("ImageButton") or not not closeButton:IsA("TextButton")) then
	closeButton.MouseButton1Click:Connect(close)
end

for iterFirst2, value in { "Fl8Games", "Fl8Kills", "Fl8Main", "Fl8Secret", "Fl8Elite" }, nil, nil do
	LocalPlayer:GetAttributeChangedSignal(value):Connect(function()
		if u37 then
			u38()
		end
	end)
end

replicatedStorage.AttributeChanged:Connect(function(attribute: string)
	if u37 and string.sub(attribute, 1, 3) == "Fl8" then
		u38()
	end
end)

local fl8mey_Open: BindableEvent = Instance.new("BindableEvent")

fl8mey_Open.Name = "Fl8mey_Open"
fl8mey_Open.Parent = scriptParent
fl8mey_Open.Event:Connect(function()
	if u37 then
		close()

		return
	end

	open()
end)

local function buttonWanted()
	local u175: boolean = false

	if replicatedStorage:GetAttribute("Fl8Enabled") == true then
		local v176: number = workspace:GetServerTimeNow()
		local fl8StartAt: any = replicatedStorage:GetAttribute("Fl8StartAt")

		u175 = (if v176 < (fl8StartAt or math.huge) then "soon" else if v176 >= (replicatedStorage:GetAttribute("Fl8EndAt") or 0) then "over" else "running") == "running"
	end

	if not u175 then
		u175 = false

		if replicatedStorage:GetAttribute("Fl8Enabled") == true then
			u175 = false

			if LocalPlayer:GetAttribute("Fl8Elite") == nil then
				local fl8Kills: any = LocalPlayer:GetAttribute("Fl8Kills")
				local fl8_eliteKills: any = replicatedStorage:GetAttribute("Fl8_eliteKills")
				local typeName: string = typeof(fl8_eliteKills)

				u175 = (fl8Kills or 0) >= (if typeName == "number" then fl8_eliteKills else 2500)
			end
		end
	end

	return u175
end

local events: Instance = scriptParentParent:FindFirstChild("Events")
local v69: Instance = events

if v69 then
	v69 = events:FindFirstChild("Fl8mey")
end

if v69 and v69:IsA("GuiButton") then
	v69.MouseButton1Click:Connect(function()
		if u37 then
			close()

			return
		end

		open()
	end)

	local shine: Instance = v69:FindFirstChild("Shine")

	if shine then
		shineEffect.loop(shine, {
			duration = 1,
			offsetStart = Vector2.new(-1.8, 0),
			offsetEnd = Vector2.new(1.8, 0)
		})
	end

	if v69:IsA("ImageButton") then
		v69.Image = ""
		v69.HoverImage = ""
	end

	local countdown: Instance = v69:FindFirstChild("Countdown")

	if countdown and countdown:IsA("TextLabel") then
		eventTimer.driveLabel(countdown, function()
			local fl8EndAt: any = replicatedStorage:GetAttribute("Fl8EndAt")

			if typeof(fl8EndAt) == "number" then
				return fl8EndAt
			end

			return nil
		end, {
			redInFinalDay = true,
			onUpdate = function()
				local u182: boolean = false

				if replicatedStorage:GetAttribute("Fl8Enabled") == true then
					local v183: number = workspace:GetServerTimeNow()
					local fl8StartAt: any = replicatedStorage:GetAttribute("Fl8StartAt")

					u182 = (if v183 < (fl8StartAt or math.huge) then "soon" else if v183 >= (replicatedStorage:GetAttribute("Fl8EndAt") or 0) then "over" else "running") == "running"
				end

				if not u182 then
					u182 = false

					if replicatedStorage:GetAttribute("Fl8Enabled") == true then
						u182 = false

						if LocalPlayer:GetAttribute("Fl8Elite") == nil then
							local fl8Kills: any = LocalPlayer:GetAttribute("Fl8Kills")
							local fl8_eliteKills: any = replicatedStorage:GetAttribute("Fl8_eliteKills")
							local typeName: string = typeof(fl8_eliteKills)

							u182 = (fl8Kills or 0) >= (if typeName == "number" then fl8_eliteKills else 2500)
						end
					end
				end

				v69.Visible = u182
			end
		})
	end

	task.spawn(function()
		local v188
		local u189
		local fl8Enabled
		local v191
		local fl8StartAt
		local s1
		local fl8Kills
		local fl8_eliteKills
		local typeName

		while true do
			v188 = v69
			u189 = false
			fl8Enabled = replicatedStorage:GetAttribute("Fl8Enabled")

			if fl8Enabled == true then
				v191 = workspace:GetServerTimeNow()
				fl8StartAt = replicatedStorage:GetAttribute("Fl8StartAt")
				s1 = if v191 < (fl8StartAt or math.huge) then "soon" else if v191 >= (replicatedStorage:GetAttribute("Fl8EndAt") or 0) then "over" else "running"
				u189 = s1 == "running"
			end

			if not u189 then
				u189 = false

				if replicatedStorage:GetAttribute("Fl8Enabled") == true then
					u189 = false

					if LocalPlayer:GetAttribute("Fl8Elite") == nil then
						fl8Kills = LocalPlayer:GetAttribute("Fl8Kills")
						fl8_eliteKills = replicatedStorage:GetAttribute("Fl8_eliteKills")
						typeName = typeof(fl8_eliteKills)
						u189 = (fl8Kills or 0) >= (if typeName == "number" then fl8_eliteKills else 2500)
					end
				end
			end

			v188.Visible = u189

			if u37 and replicatedStorage:GetAttribute("Fl8Enabled") ~= true then
				close()
			end

			task.wait(1)

			continue
		end
	end)
end

task.spawn(function()
	local v197
	local lobby
	local v199
	local v200
	local foundChild
	local v202

	v197 = nil

	while true do
		lobby = workspace:FindFirstChild("Lobby")
		v199 = lobby and lobby:FindFirstChild("fl8meyNPC") or workspace:FindFirstChild("fl8meyNPC")
		v200 = v199

		if v200 then
			foundChild = v199:FindFirstChildWhichIsA("ProximityPrompt", true)
			v200 = foundChild
		end

		if v200 and v200 ~= v197 then
			v197 = v200
			v202 = function(p16)
				if p16 == LocalPlayer and not u37 then
					open()
				end
			end
			v200.Triggered:Connect(v202)
		end

		task.wait(5)

		continue
	end
end)
