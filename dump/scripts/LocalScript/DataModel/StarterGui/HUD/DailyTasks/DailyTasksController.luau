-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local tweenService: TweenService = game:GetService("TweenService")

game:GetService("RunService")
game:GetService("UserInputService")

local LocalPlayer: Player = players.LocalPlayer
local hud: Instance = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD")
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local dailyTasks_Push: Instance = remotes:WaitForChild("DailyTasks_Push")
local dailyTasks_Request: Instance = remotes:WaitForChild("DailyTasks_Request")
local maid = require(game.ReplicatedStorage.Util.Maid)
local dailyTasks: Instance = hud:WaitForChild("DailyTasks")
local title: Instance = dailyTasks:WaitForChild("Title")
local dailyTimer: Instance = title:WaitForChild("DailyTimer")
local titleLeft: Instance = title:WaitForChild("TitleLeft")
local friendBoost: Instance = title:WaitForChild("FriendBoost")
local textLabel: Instance = friendBoost:WaitForChild("TextLabel")

friendBoost.Visible = false

local function getFriendBoostCount()
	local friendBoostCount: any = LocalPlayer:GetAttribute("FriendBoostCount")

	return typeof(friendBoostCount) == "number" and friendBoostCount > 0 and math.floor(friendBoostCount) or 0
end
local function getFriendBoostMultiplier()
	local friendBoostMultiplier: any = LocalPlayer:GetAttribute("FriendBoostMultiplier")

	return typeof(friendBoostMultiplier) == "number" and friendBoostMultiplier >= 1 and friendBoostMultiplier or 1
end

local u18: boolean = false
local u19: boolean = false

local function effectiveBoostMultiplier()
	if not u18 and not u19 then
		local friendBoostMultiplier: any = LocalPlayer:GetAttribute("FriendBoostMultiplier")

		return typeof(friendBoostMultiplier) == "number" and friendBoostMultiplier >= 1 and friendBoostMultiplier or 1
	end

	return 1
end

local questFrame: Instance = dailyTasks:WaitForChild("QuestFrame")
local questTemplate1: Instance = questFrame:WaitForChild("QuestTemplate1")
local questTemplate2: Instance = questFrame:WaitForChild("QuestTemplate2")
local questTemplate3: Instance = questFrame:WaitForChild("QuestTemplate3")
local t1: {[any]: any} = { questTemplate1, questTemplate2, questTemplate3 }
local n1: number = #t1

local function restoreTemplateVisibility()
	for i, v in ipairs(t1) do
		v.Visible = i <= n1
	end
end

local toggleArrow: Instance = dailyTasks:WaitForChild("Folder"):WaitForChild("ToggleArrow")
local v29 = maid.new()

local function getRewardAccentStroke(p1)
	local reward = p1:FindFirstChild("Reward")

	if not reward then
		return nil
	end

	for _, v in ipairs(reward:GetChildren()) do
		if v:IsA("UIStroke") and v:FindFirstChildOfClass("UIGradient") then
			return v
		end
	end

	return nil
end
local function captureColors(p2)
	local uiGradient = p2:FindFirstChild("ProgressBar"):FindFirstChild("Progress"):FindFirstChildOfClass("UIGradient")
	local label = p2:FindFirstChild("Label")
	local v79 = getRewardAccentStroke(p2)
	local t3: {[any]: any} = {
		progressGradient = uiGradient.Color,
		questLabelColor = label.TextColor3,
		rewardAccentStrokeColor = v81
	}
	local v81 = if v79 then v79.Color else Color3.new(1, 1, 1)

	return t3
end

local v32 = captureColors(t1[1])
local v33 = captureColors(t1[2])
local clone = nil
local reward = t1[1]:FindFirstChild("Reward")

if reward then
	local glow = reward:FindFirstChild("Glow")

	if glow then
		clone = glow:Clone()
		glow:Destroy()
	end
end

local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local dailyTasksPosition = dailyTasks.Position
local tweenInfo2 = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local function getClosedPos()
	local floored = math.floor(dailyTasks.AbsoluteSize.X)

	return UDim2.new(dailyTasksPosition.X.Scale, dailyTasksPosition.X.Offset - floored, dailyTasksPosition.Y.Scale, dailyTasksPosition.Y.Offset)
end

local u41: boolean = true
local u42: boolean = false
local ResetAt = nil
local u44 = false
local u45: boolean = false
local n2: number = 0
local t2: {[any]: any} = {}
local u48 = nil
local u49 = nil

local function dailiesSuppressed()
	local specialTasksCount: any = LocalPlayer:GetAttribute("SpecialTasksCount")

	if typeof(specialTasksCount) == "number" then
		return specialTasksCount >= 3
	end

	return LocalPlayer:GetAttribute("HasSpecialTasks") == true
end
local function applyDailyContentVisibility()
	local specialTasksCount: any = LocalPlayer:GetAttribute("SpecialTasksCount")
	local u85: boolean = if typeof(specialTasksCount) == "number" then specialTasksCount >= 3 else LocalPlayer:GetAttribute("HasSpecialTasks") == true

	questFrame.Visible = not u85

	if u85 then
		title.Visible = false
	elseif not u45 then
		title.Visible = true
	end
end
local function formatReward(p3)
	return (tostring(p3))
end
local function formatTime(p4)
	local floored = math.floor(p4)
	local v89 = math.max(0, floored)
	local floored2 = math.floor(v89 / 3600)
	local floored3 = math.floor(v89 % 3600 / 60)

	return ("%02d:%02d:%02d"):format(floored2, floored3, v89 % 60)
end
local function applyQuestColors(p5, p6, p7)
	local uiGradient = p5:FindFirstChild("ProgressBar"):FindFirstChild("Progress"):FindFirstChildOfClass("UIGradient")
	local label = p5:FindFirstChild("Label")

	uiGradient.Color = p6.progressGradient
	label.TextColor3 = p6.questLabelColor

	local v97 = getRewardAccentStroke(p5)

	if v97 then
		v97.Color = p6.rewardAccentStrokeColor
	end

	local reward2 = p5:FindFirstChild("Reward")

	if reward2 then
		local glow = reward2:FindFirstChild("Glow")

		if not p7 or not clone then
			if glow then
				glow:Destroy()
			end
		elseif not glow then
			local clone2 = clone:Clone()

			clone2.Parent = reward2

			return
		end

		return
	end
end
local function renderQuest(p8, p9)
	local label = p8:FindFirstChild("Label")
	local progressBar = p8:FindFirstChild("ProgressBar")
	local progress = progressBar:FindFirstChild("Progress")
	local label2 = progressBar:FindFirstChild("Label")
	local quantityCounter = p8:FindFirstChild("Reward"):FindFirstChild("QuantityCounter")

	label.Text = p9.Label
	label2.Text = ("%d/%d"):format(p9.Current, p9.Required)

	local reward = p9.Reward
	local n1

	if not u18 and not u19 then
		local friendBoostMultiplier: any = LocalPlayer:GetAttribute("FriendBoostMultiplier")

		n1 = typeof(friendBoostMultiplier) == "number" and friendBoostMultiplier >= 1 and friendBoostMultiplier or 1
	else
		n1 = 1
	end

	local floored = math.floor(reward * n1)

	quantityCounter.Text = tostring(floored)

	local current = p9.Current
	local v113 = math.max(p9.Required, 1)
	local v114 = math.clamp(current / v113, 0, 1)

	if p9.Claimed or p9.Completed == true then
		applyQuestColors(p8, v32, true)
		v114 = 1
	else
		applyQuestColors(p8, v33, false)
	end

	local uDim2 = UDim2.new(v114, 0, progress.Size.Y.Scale, progress.Size.Y.Offset)

	tweenService:Create(progress, tweenInfo, { Size = uDim2 }):Play()
end
local function cancelFlash()
	warn("cancelFlash")
	v29:DoCleaning()
	n2 += 1
	u45 = false

	local specialTasksCount: any = LocalPlayer:GetAttribute("SpecialTasksCount")

	title.Visible = not (if typeof(specialTasksCount) == "number" then specialTasksCount >= 3 else LocalPlayer:GetAttribute("HasSpecialTasks") == true)
	toggleArrow.Visible = true

	for i, v in ipairs(t1) do
		v.Visible = i <= n1
	end

	for _, v in ipairs(t1) do
		local _FlashHighlight = v:FindFirstChild("_FlashHighlight")

		if _FlashHighlight then
			_FlashHighlight:Destroy()
		end
	end

	dailyTasks.Position = dailyTasksPosition
end
local function createFlashHighlight(parent)
	local _FlashHighlight = parent:FindFirstChild("_FlashHighlight")

	if _FlashHighlight then
		_FlashHighlight:Destroy()
	end

	local _FlashHighlight: Frame = Instance.new("Frame")

	_FlashHighlight.Name = "_FlashHighlight"
	_FlashHighlight.Size = UDim2.new(0.2, 0, 1, 0)
	_FlashHighlight.Position = UDim2.new(0, 0, 0, 0)
	_FlashHighlight.BackgroundColor3 = Color3.fromRGB(255, 255, 100)
	_FlashHighlight.BackgroundTransparency = 1
	_FlashHighlight.BorderSizePixel = 0
	_FlashHighlight.ZIndex = parent.ZIndex + 10
	_FlashHighlight.Parent = parent

	return _FlashHighlight
end
local function runFlashSequence(p11)
	v29:DoCleaning()
	v29.flashThread = task.spawn(function()
		n2 += 1

		local v175: number = n2

		u45 = true
		title.Visible = false
		toggleArrow.Visible = false

		for i, v in ipairs(t1) do
			v.Visible = i == p11
		end

		v29:GiveTask(function()
			u45 = false

			local specialTasksCount: any = LocalPlayer:GetAttribute("SpecialTasksCount")

			title.Visible = not (if typeof(specialTasksCount) == "number" then specialTasksCount >= 3 else LocalPlayer:GetAttribute("HasSpecialTasks") == true)
			toggleArrow.Visible = true

			for i, v in ipairs(t1) do
				v.Visible = i <= n1
			end

			dailyTasks.Position = dailyTasksPosition
			u49()
		end)
		dailyTasks.Visible = true

		local v178: Tween = tweenService:Create(dailyTasks, tweenInfo2, { Position = dailyTasksPosition })

		v178:Play()
		v29:GiveTask(function()
			if v178.PlaybackState == Enum.PlaybackState.Playing then
				v178:Cancel()
			end
		end)

		local v179 = createFlashHighlight(t1[p11])

		v29.highlightFrame = v179
		v179.BackgroundTransparency = 0.2

		local tweenInfo3 = TweenInfo.new(0.6, Enum.EasingStyle.Quad)
		local v181: Tween = tweenService:Create(v179, tweenInfo3, { BackgroundTransparency = 1, Size = UDim2.new(1.4, 0, 1, 0) })

		v181:Play()
		v29:GiveTask(function()
			if v181.PlaybackState == Enum.PlaybackState.Playing then
				v181:Cancel()
			end
		end)
		task.wait(4)

		if v175 ~= n2 then
			return
		end

		local floored = math.floor(dailyTasks.AbsoluteSize.X)
		local uDim2 = UDim2.new(dailyTasksPosition.X.Scale, dailyTasksPosition.X.Offset - floored, dailyTasksPosition.Y.Scale, dailyTasksPosition.Y.Offset)
		local v184 = UDim2.fromScale(0.2, 0)
		local v185: Tween = tweenService:Create(dailyTasks, tweenInfo2, { Position = uDim2 - v184 })

		v185:Play()
		v29:GiveTask(function()
			if v185.PlaybackState == Enum.PlaybackState.Playing then
				v185:Cancel()
			end
		end)
		task.wait(tweenInfo2.Time)

		if v175 ~= n2 then
			return
		end

		if v179 and v179.Parent then
			v179:Destroy()
		end

		task.defer(v29.DoCleaning, v29)
	end)
end
local function detectProgressAndFlash(p12)
	if typeof(p12) == "table" then
		for i, v in ipairs(p12) do
			if typeof(v) == "table" and typeof(v.Id) == "string" and typeof(v.Current) == "number" and t2[v.Id] ~= nil and v.Current > t2[v.Id] and not v.Claimed and not (if typeof((LocalPlayer:GetAttribute("SpecialTasksCount"))) == "number" then LocalPlayer:GetAttribute("SpecialTasksCount") >= 3 else LocalPlayer:GetAttribute("HasSpecialTasks") == true) and i >= 1 and i <= #t1 then
				task.spawn(function()
					local v186 = i

					v29:DoCleaning()
					v29.flashThread = task.spawn(function()
						n2 += 1

						local v191: number = n2

						u45 = true
						title.Visible = false
						toggleArrow.Visible = false

						for i2, iterValue in ipairs(t1) do
							iterValue.Visible = i2 == v186
						end

						v29:GiveTask(function()
							u45 = false

							local specialTasksCount: any = LocalPlayer:GetAttribute("SpecialTasksCount")

							title.Visible = not (if typeof(specialTasksCount) == "number" then specialTasksCount >= 3 else LocalPlayer:GetAttribute("HasSpecialTasks") == true)
							toggleArrow.Visible = true

							for i, v in ipairs(t1) do
								v.Visible = i <= n1
							end

							dailyTasks.Position = dailyTasksPosition
							u49()
						end)
						dailyTasks.Visible = true

						local v194: Tween = tweenService:Create(dailyTasks, tweenInfo2, { Position = dailyTasksPosition })

						v194:Play()
						v29:GiveTask(function()
							if v194.PlaybackState == Enum.PlaybackState.Playing then
								v194:Cancel()
							end
						end)

						local v195 = createFlashHighlight(t1[v186])

						v29.highlightFrame = v195
						v195.BackgroundTransparency = 0.2

						local tweenInfo4 = TweenInfo.new(0.6, Enum.EasingStyle.Quad)
						local v197: Tween = tweenService:Create(v195, tweenInfo4, { BackgroundTransparency = 1, Size = UDim2.new(1.4, 0, 1, 0) })

						v197:Play()
						v29:GiveTask(function()
							if v197.PlaybackState == Enum.PlaybackState.Playing then
								v197:Cancel()
							end
						end)
						task.wait(4)

						if v191 ~= n2 then
							return
						end

						local floored = math.floor(dailyTasks.AbsoluteSize.X)
						local uDim2 = UDim2.new(dailyTasksPosition.X.Scale, dailyTasksPosition.X.Offset - floored, dailyTasksPosition.Y.Scale, dailyTasksPosition.Y.Offset)
						local v200 = UDim2.fromScale(0.2, 0)
						local v201: Tween = tweenService:Create(dailyTasks, tweenInfo2, { Position = uDim2 - v200 })

						v201:Play()
						v29:GiveTask(function()
							if v201.PlaybackState == Enum.PlaybackState.Playing then
								v201:Cancel()
							end
						end)
						task.wait(tweenInfo2.Time)

						if v191 ~= n2 then
							return
						end

						if v195 and v195.Parent then
							v195:Destroy()
						end

						task.defer(v29.DoCleaning, v29)
					end)
				end)

				break
			end
		end

		for _, v in ipairs(p12) do
			if typeof(v) == "table" and typeof(v.Id) == "string" then
				t2[v.Id] = v.Current
			end
		end

		return
	end
end

u48 = function()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")

	if typeof(matchId) == "string" and matchId ~= "" and matchId ~= "PRACTICE" then
		return true
	end

	local spectating: any = LocalPlayer:GetAttribute("Spectating")

	if typeof(spectating) == "number" and spectating ~= 0 then
		return true
	end

	return false
end
u49 = function()
	if u45 and not u44 then
		return
	end

	if u48() then
		if u44 or u19 then
			if u45 then
				cancelFlash()
			end

			dailyTasks.Visible = true

			return
		end

		if not u45 then
			dailyTasks.Visible = false

			return
		end
	else
		if u45 then
			cancelFlash()
		end

		dailyTasks.Visible = true
	end
end

local function updateFriendBoost()
	if not u18 and not u19 then
		local friendBoostCount: any = LocalPlayer:GetAttribute("FriendBoostCount")

		if (typeof(friendBoostCount) == "number" and friendBoostCount > 0 and math.floor(friendBoostCount) or 0) <= 0 then
			friendBoost.Visible = false

			return
		end

		local friendBoostMultiplier: any = LocalPlayer:GetAttribute("FriendBoostMultiplier")
		local typeName: string = typeof(friendBoostMultiplier)
		local floored = math.floor(((typeName == "number" and friendBoostMultiplier >= 1 and friendBoostMultiplier or 1) - 1) * 100 + 0.5)

		textLabel.Text = string.format("+%d%% Friend Boost", floored)
		friendBoost.Visible = true

		return
	end

	friendBoost.Visible = false
end

local u61 = nil

local function applySnapshot(p13)
	if typeof(p13) == "table" then
		local tasks = p13.Tasks

		if typeof(tasks) == "table" then
			u61 = p13

			local tutorialPhase = p13.TutorialPhase
			local u140: boolean = false

			if typeof(tutorialPhase) == "number" then
				u140 = tutorialPhase > 0
			end

			u18 = u140
			u140 = p13.GettingStarted == true
			u19 = u140

			if not u18 and not u19 then
				local friendBoostCount: any = LocalPlayer:GetAttribute("FriendBoostCount")

				if (typeof(friendBoostCount) == "number" and friendBoostCount > 0 and math.floor(friendBoostCount) or 0) <= 0 then
					friendBoost.Visible = false
				else
					local friendBoostMultiplier: any = LocalPlayer:GetAttribute("FriendBoostMultiplier")
					local typeName: string = typeof(friendBoostMultiplier)
					local floored = math.floor(((typeName == "number" and friendBoostMultiplier >= 1 and friendBoostMultiplier or 1) - 1) * 100 + 0.5)

					textLabel.Text = string.format("+%d%% Friend Boost", floored)
					friendBoost.Visible = true
				end
			else
				friendBoost.Visible = false
			end

			if u18 then
				titleLeft.Text = "Beginner Tasks (" .. tostring(tutorialPhase) .. "/3)"
				dailyTimer.Visible = false
				ResetAt = nil
				n1 = #tasks
			elseif u140 then
				titleLeft.Text = "Getting Started"
				dailyTimer.Visible = false
				ResetAt = nil
				n1 = #tasks
			else
				titleLeft.Text = "Daily Tasks"
				n1 = #t1
				ResetAt = p13.ResetAt
			end

			for i, v in ipairs(t1) do
				v.Visible = i <= n1
			end

			for i, v in ipairs(tasks) do
				local v149 = t1[i]

				if v149 and typeof(v) == "table" then
					renderQuest(v149, v)

					local vClaimed = v.Claimed
				end
			end

			if typeof(tutorialPhase) ~= "number" or not (tutorialPhase > 0) then
				dailyTimer.Visible = ResetAt ~= nil
			end

			if u48() and not u19 then
				detectProgressAndFlash(tasks)
			else
				for _, v in ipairs(tasks) do
					if typeof(v) == "table" and typeof(v.Id) == "string" then
						t2[v.Id] = v.Current
					end
				end
			end

			local specialTasksCount: any = LocalPlayer:GetAttribute("SpecialTasksCount")

			u140 = if typeof(specialTasksCount) == "number" then specialTasksCount >= 3 else LocalPlayer:GetAttribute("HasSpecialTasks") == true
			questFrame.Visible = not u140

			if u140 then
				title.Visible = false
			elseif not u45 then
				title.Visible = true
			end

			u49()

			return
		end

		return
	end
end

for _, v in ipairs(t1) do
	applyQuestColors(v, v33, false)
end

task.spawn(function()
	local v154
	local timestamp
	local n1
	local v157
	local v158
	local floored
	local v160
	local v161
	local floored4
	local floored5
	local v164

	while true do
		if ResetAt and dailyTimer.Visible then
			v154 = ResetAt
			timestamp = os.time()
			n1 = v154 - timestamp

			if n1 <= 0 then
				dailyTimer.Text = "00:00:00"
				v157 = function()
					local v187 = dailyTasks_Request:InvokeServer("GetSnapshot")

					applySnapshot(v187)
				end
				task.defer(v157)
				ResetAt = nil
			else
				v158 = dailyTimer
				floored = math.floor(n1)
				v160 = math.max(0, floored)
				v161 = v160
				floored4 = math.floor(v161 / 3600)
				floored5 = math.floor(v161 % 3600 / 60)
				v164 = ("%02d:%02d:%02d"):format(floored4, floored5, v161 % 60)
				v158.Text = v164
			end
		else
			if not dailyTimer.Visible then
				dailyTimer.Text = ""
			end
		end

		task.wait(1)

		continue
	end
end)
toggleArrow.MouseButton1Click:Connect(function()
	warn("toggle")

	if u42 then
		return
	end

	u42 = true
	u41 = not u41

	local v165 = u41 and dailyTasksPosition

	if not v165 then
		local floored = math.floor(dailyTasks.AbsoluteSize.X)

		v165 = UDim2.new(dailyTasksPosition.X.Scale, dailyTasksPosition.X.Offset - floored, dailyTasksPosition.Y.Scale, dailyTasksPosition.Y.Offset)
	end

	tweenService:Create(dailyTasks, tweenInfo2, { Position = v165 }):Play()
	toggleArrow.Image = if u41 then "rbxassetid://108124336893774" else "rbxassetid://92952642150188"
	task.delay(tweenInfo2.Time, function()
		u42 = false
	end)
end)
dailyTasks:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	if not u41 and not u42 then
		local floored = math.floor(dailyTasks.AbsoluteSize.X)

		dailyTasks.Position = UDim2.new(dailyTasksPosition.X.Scale, dailyTasksPosition.X.Offset - floored, dailyTasksPosition.Y.Scale, dailyTasksPosition.Y.Offset)
	end
end)
dailyTasks_Push.OnClientEvent:Connect(function(p14)
	applySnapshot(p14)
end)

local function onFriendBoostChanged()
	if u61 then
		applySnapshot(u61)

		return
	end

	if not u18 and not u19 then
		local friendBoostCount: any = LocalPlayer:GetAttribute("FriendBoostCount")

		if (typeof(friendBoostCount) == "number" and friendBoostCount > 0 and math.floor(friendBoostCount) or 0) <= 0 then
			friendBoost.Visible = false

			return
		end

		local friendBoostMultiplier: any = LocalPlayer:GetAttribute("FriendBoostMultiplier")
		local typeName: string = typeof(friendBoostMultiplier)
		local floored = math.floor(((typeName == "number" and friendBoostMultiplier >= 1 and friendBoostMultiplier or 1) - 1) * 100 + 0.5)

		textLabel.Text = string.format("+%d%% Friend Boost", floored)
		friendBoost.Visible = true

		return
	end

	friendBoost.Visible = false
end

LocalPlayer:GetAttributeChangedSignal("FriendBoostMultiplier"):Connect(onFriendBoostChanged)
LocalPlayer:GetAttributeChangedSignal("FriendBoostCount"):Connect(onFriendBoostChanged)
task.spawn(function()
	if LocalPlayer:GetAttribute("DataReady") ~= true then
		LocalPlayer:GetAttributeChangedSignal("DataReady"):Wait()
	end

	local v173 = dailyTasks_Request:InvokeServer("GetSnapshot")

	applySnapshot(v173)
end)
replicatedStorage:WaitForChild("Bindables"):WaitForChild("ToggleMatchLeaderboard").Event:Connect(function(p15)
	u44 = p15
	u49()
end)
LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(u49)
LocalPlayer:GetAttributeChangedSignal("Spectating"):Connect(u49)
u49()

local specialTasksCount: any = LocalPlayer:GetAttribute("SpecialTasksCount")

onFriendBoostChanged = if typeof(specialTasksCount) == "number" then specialTasksCount >= 3 else LocalPlayer:GetAttribute("HasSpecialTasks") == true
questFrame.Visible = not onFriendBoostChanged

if onFriendBoostChanged then
	title.Visible = false
elseif not u45 then
	title.Visible = true
end

LocalPlayer:GetAttributeChangedSignal("HasSpecialTasks"):Connect(applyDailyContentVisibility)
LocalPlayer:GetAttributeChangedSignal("SpecialTasksCount"):Connect(applyDailyContentVisibility)
