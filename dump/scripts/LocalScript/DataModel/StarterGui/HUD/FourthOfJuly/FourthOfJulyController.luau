-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local tweenService: TweenService = game:GetService("TweenService")
local LocalPlayer: Player = players.LocalPlayer
local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui")
local activeWindowChanged: Instance = replicatedStorage:WaitForChild("Bindables"):WaitForChild("ActiveWindowChanged")
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local julyEvent_Request: Instance = remotes:WaitForChild("JulyEvent_Request")
local julyEvent_Push: Instance = remotes:WaitForChild("JulyEvent_Push")
local julyEvent_Action: Instance = remotes:WaitForChild("JulyEvent_Action")
local julyEvent_DebugOpen: Instance = remotes:FindFirstChild("JulyEvent_DebugOpen")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local windowBlur = require(shared:WaitForChild("WindowBlur"))
local shineEffect = require(shared:WaitForChild("ShineEffect"))
local rarity = require(shared:WaitForChild("Rarity"))
local eventTimer = require(shared:WaitForChild("EventTimer"))
local fourthOfJulyTemplates: Instance = replicatedStorage:WaitForChild("UIFramework"):WaitForChild("FourthOfJulyTemplates")
local startButton: Instance = fourthOfJulyTemplates:WaitForChild("StartButton")
local claimOverlay: Instance = fourthOfJulyTemplates:WaitForChild("ClaimOverlay")
local claimedLabel: Instance = fourthOfJulyTemplates:WaitForChild("ClaimedLabel")
local lockedStartLabel: Instance = fourthOfJulyTemplates:WaitForChild("LockedStartLabel")
local skipButton: Instance = fourthOfJulyTemplates:WaitForChild("SkipButton")
local counter_Day: Instance = fourthOfJulyTemplates:WaitForChild("Counter_Day")

fourthOfJulyTemplates:WaitForChild("Counter_Kills")
fourthOfJulyTemplates:WaitForChild("Counter_Countdown")

local scriptParent: Instance = script.Parent
local v25 = scriptParent.Parent
local content: Instance = scriptParent:WaitForChild("Content")
local finalReward: Instance = scriptParent:WaitForChild("FinalReward")
local quest6: Instance = finalReward:WaitForChild("Quest6")
local timer: Instance = scriptParent:WaitForChild("Timer")
local closeButton: Instance = scriptParent:FindFirstChild("CloseButton")
local v31: Instance = content:WaitForChild("Quest" .. 1)
local v32: Instance = content:WaitForChild("Quest" .. 2)
local v33: Instance = content:WaitForChild("Quest" .. 3)
local v34: Instance = content:WaitForChild("Quest" .. 4)
local v35: Instance = content:WaitForChild("Quest" .. 5)
local t1: {[any]: any} = {}
local t2: {[any]: any} = { "StartButton", "ClaimOverlay", "ClaimedLabel", "SkipButton" }
local t3: {[any]: any} = { v31, v32, v33, v34, v35, quest6 }

for k, v in pairs(t3) do
	v.Interactable = true

	for _, iterValue in ipairs(t2) do
		local v2 = v:FindFirstChild(iterValue)

		if v2 and v2:IsA("GuiObject") then
			v2.Visible = false
		end
	end

	if not t1[k] then
		local counter = v:FindFirstChild("Counter")

		if counter and counter:IsA("GuiObject") then
			counter.Visible = false
		end
	end
end

local tweenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo3 = TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local vector2 = Vector2.new(0, -1.1)
local vector22 = Vector2.new(0, 2.2)
local u50: boolean = false
local u51 = nil
local u52 = nil
local u53 = nil
local n1: number = 0
local u55 = nil

task.spawn(function()
	local hud: Instance = playerGui:WaitForChild("HUD", 10)

	if not hud then
		return
	end

	local blackBackground2: Instance = hud:FindFirstChild("BlackBackground2")

	if blackBackground2 and blackBackground2:IsA("GuiObject") then
		u55 = blackBackground2
	end
end)
scriptParent.Visible = false

local function formatDHM(p1)
	return eventTimer.format(p1)
end
local function formatHMS(p2)
	local floored = math.floor(p2)
	local v89 = math.max(0, floored)
	local floored2 = math.floor(v89 / 3600)
	local floored3 = math.floor(v89 % 3600 / 60)

	return ("%02d:%02d:%02d"):format(floored2, floored3, v89 % 60)
end
local function formatKills(p3, p4)
	return ("<font color=\"#ff0000\">%d</font>/%d"):format(math.min(p3, p4), p4)
end

local t4: {[any]: any} = {
	"RL_StartButton",
	"RL_ClaimButton",
	"RL_ClaimOverlay",
	"RL_ClaimedLabel",
	"RL_Counter",
	"RL_LockedStart",
	"RL_Skip"
}

local function clearClones(p5)
	for _, v in ipairs(t4) do
		local v = p5:FindFirstChild(v)

		if v then
			v:Destroy()
		end
	end
end
local function ensureClone(parent, p7, name)
	local foundChild = parent:FindFirstChild(name)

	if foundChild and foundChild:IsA("GuiObject") then
		return foundChild
	end

	local clone = p7:Clone()

	clone.Name = name
	clone.Visible = true
	clone.Parent = parent

	return clone
end
local function hookClick(p9, p10)
	local v105 = if not p9:IsA("TextButton") and not p9:IsA("ImageButton") then p9:FindFirstChildWhichIsA("TextButton", true) or p9:FindFirstChildWhichIsA("ImageButton", true) else p9

	if v105 then
		v105.MouseButton1Click:Connect(p10)
	end
end

local t5: {[any]: any} = {
	Countdown = function(p11)
		local counter = p11:FindFirstChild("Counter")

		if counter and counter:IsA("GuiObject") then
			counter.Visible = false
		end
	end,
	Kills = function(p12, p13)
		if p12 == "Countdown" then
			return formatHMS(p13)
		end

		if p12 == "Kills" then
			return formatKills(p13.current, p13.required)
		end

		if p12 == "DayLocked" then
			return "Day " .. tostring(p13)
		end

		return ""
	end,
	DayLocked = counter_Day
}

local function setCounterMode(_, parent, p16, p17)
	if p16 == "Hidden" then
		local rl_Counter = parent:FindFirstChild("RL_Counter")

		if rl_Counter then
			rl_Counter:Destroy()
		end

		local counter = parent:FindFirstChild("Counter")

		if counter and counter:IsA("GuiObject") then
			counter.Visible = false
		end

		return
	end

	local v116 = t5[p16]

	if not v116 then
		local rl_Counter = parent:FindFirstChild("RL_Counter")

		if rl_Counter then
			rl_Counter:Destroy()
		end

		return
	end

	local rl_Counter = parent:FindFirstChild("RL_Counter")

	if rl_Counter and p16 ~= rl_Counter:GetAttribute("CounterMode") then
		rl_Counter:Destroy()
		rl_Counter = nil
	end

	if not rl_Counter then
		rl_Counter = v116:Clone()
		rl_Counter.Name = "RL_Counter"
		rl_Counter:SetAttribute("CounterMode", p16)
		rl_Counter.Visible = true
		rl_Counter.Parent = parent

		local counter = parent:FindFirstChild("Counter")

		if counter and counter:IsA("GuiObject") then
			counter.Visible = false
		end
	end

	local amount = rl_Counter:FindFirstChild("Amount")

	if amount then
		local v121

		if p16 == "Countdown" then
			local floored = math.floor(p17)
			local v123 = math.max(0, floored)
			local floored4 = math.floor(v123 / 3600)
			local floored5 = math.floor(v123 % 3600 / 60)

			v121 = ("%02d:%02d:%02d"):format(floored4, floored5, v123 % 60)
		elseif p16 == "Kills" then
			local required = p17.required

			v121 = ("<font color=\"#ff0000\">%d</font>/%d"):format(math.min(p17.current, required), required)
		elseif p16 == "DayLocked" then
			v121 = "Day " .. tostring(p17)
		else
			v121 = ""
		end

		amount.Text = v121
	end
end

local t6: {[any]: any} = {}

local function setLocked(p18, visible)
	local questionMark = p18:FindFirstChild("QuestionMark")

	if questionMark and questionMark:IsA("TextLabel") then
		questionMark.Visible = visible
	end

	local imageLabel = p18:FindFirstChild("ImageLabel")

	if imageLabel and imageLabel:IsA("ImageLabel") then
		imageLabel.ImageColor3 = visible and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
	end

	local itemName = p18:FindFirstChild("ItemName")

	if itemName and itemName:IsA("GuiObject") then
		itemName.Visible = not visible
	end

	local rarity2 = p18:FindFirstChild("Rarity")

	if rarity2 and rarity2:IsA("GuiObject") then
		rarity2.Visible = not visible
	end

	local amount = p18:FindFirstChild("Amount")

	if not amount or not amount:IsA("GuiObject") then
	elseif visible then
		if t6[p18] == nil then
			t6[p18] = amount.Visible
		end

		amount.Visible = false
	elseif t6[p18] ~= nil then
		amount.Visible = t6[p18]
		t6[p18] = nil
	end
end
local function applyRewardIdentity(p20, p21)
	local rewardIcon = p21.RewardIcon

	if typeof(rewardIcon) == "string" then
		local v137 = rewardIcon ~= "" and p20:FindFirstChild("ImageLabel")

		if v137 and v137:IsA("ImageLabel") then
			v137.Image = rewardIcon
		end
	end

	local rewardRarity = p21.RewardRarity

	if typeof(rewardRarity) == "string" and rewardRarity ~= "" then
		local rarity3 = p20:FindFirstChild("Rarity")

		if rarity3 and rarity3:IsA("TextLabel") then
			rarity3.Text = rewardRarity
			rarity.ApplyTextGradient(rarity3, rewardRarity)
		end

		local rarityFade = p20:FindFirstChild("RarityFade")
		local uiGradient = rarityFade and rarityFade:FindFirstChildOfClass("UIGradient")

		if uiGradient then
			uiGradient.Color = ColorSequence.new(rarity.GetColor(rewardRarity))
		end
	end
end
local function renderSlot(p22, p23)
	local parent = t3[p22]

	if not parent then
		return
	end

	clearClones(parent)
	applyRewardIdentity(parent, p23)

	local state = p23.State

	setLocked(parent, false)

	local rl_Counter = parent:FindFirstChild("RL_Counter")

	if rl_Counter then
		rl_Counter:Destroy()
	end

	local counter = parent:FindFirstChild("Counter")

	if counter and counter:IsA("GuiObject") then
		counter.Visible = false
	end

	if state == "DayLocked" then
		setLocked(parent, true)
		setCounterMode(p22, parent, "DayLocked", p22)
	elseif state == "LockedReady" then
		local rl_Counter2 = parent:FindFirstChild("RL_Counter")

		if rl_Counter2 then
			rl_Counter2:Destroy()
		end

		local counter2 = parent:FindFirstChild("Counter")

		if counter2 and counter2:IsA("GuiObject") then
			counter2.Visible = false
		end

		local v150: Instance = lockedStartLabel
		local rl_LockedStart = parent:FindFirstChild("RL_LockedStart")

		if not rl_LockedStart or not rl_LockedStart:IsA("GuiObject") then
			local clone: Instance = v150:Clone()

			clone.Name = "RL_LockedStart"
			clone.Visible = true
			clone.Parent = parent
		end
	elseif state == "Countdown" then
		setLocked(parent, true)

		local v153 = p23.UnlockAt or os.time()
		local timestamp = os.time()

		setCounterMode(p22, parent, "Countdown", v153 - timestamp)
	elseif state == "Grabbable" then
		local v155: Instance = startButton
		local rl_StartButton = parent:FindFirstChild("RL_StartButton")
		local v157

		if rl_StartButton and rl_StartButton:IsA("GuiObject") then
			v157 = rl_StartButton
		else
			local clone: Instance = v155:Clone()

			clone.Name = "RL_StartButton"
			clone.Visible = true
			clone.Parent = parent
			v157 = clone
		end

		hookClick(v157, function()
			julyEvent_Action:FireServer("Grab")
		end)
	elseif state == "InProgress" then
		setCounterMode(p22, parent, "Kills", { current = p23.Current, required = p23.Required })
	elseif state == "Claimable" then
		local v159: Instance = claimOverlay
		local rl_ClaimOverlay = parent:FindFirstChild("RL_ClaimOverlay")
		local v161

		if rl_ClaimOverlay and rl_ClaimOverlay:IsA("GuiObject") then
			v161 = rl_ClaimOverlay
		else
			local clone: Instance = v159:Clone()

			clone.Name = "RL_ClaimOverlay"
			clone.Visible = true
			clone.Parent = parent
			v161 = clone
		end

		local claimButton = v161:FindFirstChild("ClaimButton")

		if claimButton and claimButton:IsA("GuiObject") then
			hookClick(claimButton, function()
				julyEvent_Action:FireServer("Claim")
			end)
		else
			hookClick(v161, function()
				julyEvent_Action:FireServer("Claim")
			end)
		end
	elseif state == "Completed" then
		local v164: Instance = claimedLabel
		local rl_ClaimedLabel = parent:FindFirstChild("RL_ClaimedLabel")

		if not rl_ClaimedLabel or not rl_ClaimedLabel:IsA("GuiObject") then
			local clone: Instance = v164:Clone()

			clone.Name = "RL_ClaimedLabel"
			clone.Visible = true
			clone.Parent = parent
		end
	elseif state == "Expired" then
		setLocked(parent, true)

		local rl_Counter3 = parent:FindFirstChild("RL_Counter")

		if rl_Counter3 then
			rl_Counter3:Destroy()
		end

		local counter3 = parent:FindFirstChild("Counter")

		if counter3 and counter3:IsA("GuiObject") then
			counter3.Visible = false
		end
	end

	if p23.CanSkip and p23.SkipProductId then
		setLocked(parent, false)

		local v169: Instance = skipButton
		local rl_Skip = parent:FindFirstChild("RL_Skip")
		local v171

		if rl_Skip and rl_Skip:IsA("GuiObject") then
			v171 = rl_Skip
		else
			local clone: Instance = v169:Clone()

			clone.Name = "RL_Skip"
			clone.Visible = true
			clone.Parent = parent
			v171 = clone
		end

		local priceTextLabel = v171:FindFirstChild("PriceTextLabel")

		if priceTextLabel then
			local v174 = utf8.char(57346)
			local v175 = p23.SkipPrice and tostring(p23.SkipPrice) or "???"

			priceTextLabel.Text = v174 .. v175
		end

		hookClick(v171, function()
			julyEvent_Action:FireServer("Skip")
		end)
	end
end

local u69: boolean = false

local function playFinalReveal()
	content.Visible = false

	local revealScale = finalReward:FindFirstChild("RevealScale")

	if not revealScale then
		revealScale = Instance.new("UIScale")
		revealScale.Name = "RevealScale"
		revealScale.Parent = finalReward
	end

	finalReward.Visible = true
	revealScale.Scale = 0.6

	local v177: boolean = finalReward:IsA("GuiObject")
	local v178 = v177 and finalReward.BackgroundTransparency or 0

	if v177 then
		finalReward.BackgroundTransparency = 1
	end

	local tweenInfo4 = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	tweenService:Create(revealScale, tweenInfo4, { Scale = 1 }):Play()

	if v177 then
		local tweenInfo5 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		tweenService:Create(finalReward, tweenInfo5, { BackgroundTransparency = v178 }):Play()
	end
end
local function renderFinal(p24)
	local v182 = p24.Views and p24.Views[6]

	if (p24.CurrentTier and p24.CurrentTier > 5) == true then
		if not u69 then
			u69 = true
			playFinalReveal()
		else
			content.Visible = false
			finalReward.Visible = true
		end

		if v182 then
			renderSlot(6, v182)

			return
		end
	else
		u69 = false
		finalReward.Visible = false
		content.Visible = true
	end
end
local function renderTimer(p25)
	local v184 = p25.EventEndsAt or 0

	local function setText(text)
		local textLabel: Instance = timer:FindFirstChild("TextLabel")

		if textLabel and textLabel:IsA("TextLabel") then
			textLabel.Text = text

			local textLabel2: Instance = textLabel:FindFirstChild("TextLabel")

			if textLabel2 and textLabel2:IsA("TextLabel") then
				textLabel2.Text = text
			end
		end
	end

	local timestamp = os.time()
	local n1 = v184 - timestamp

	if n1 <= 0 then
		local textLabel: Instance = timer:FindFirstChild("TextLabel")

		if textLabel and textLabel:IsA("TextLabel") then
			textLabel.Text = "Ended"

			local textLabel3: Instance = textLabel:FindFirstChild("TextLabel")

			if textLabel3 and textLabel3:IsA("TextLabel") then
				textLabel3.Text = "Ended"

				return
			end
		end
	else
		local text = eventTimer.format(n1)
		local textLabel: Instance = timer:FindFirstChild("TextLabel")

		if textLabel and textLabel:IsA("TextLabel") then
			textLabel.Text = text

			local textLabel4: Instance = textLabel:FindFirstChild("TextLabel")

			if textLabel4 and textLabel4:IsA("TextLabel") then
				textLabel4.Text = text
			end
		end
	end
end
local function renderAll(p27)
	if not p27 then
		return
	end

	u53 = p27
	n1 += 1

	local v194: number = n1

	for i = 1, 5 do
		local v196 = p27.Views and p27.Views[i]

		if v196 then
			renderSlot(i, v196)
		end
	end

	renderFinal(p27)
	renderTimer(p27)
	task.spawn(function()
		while v194 == n1 and u50 do
			task.wait(1)

			if v194 ~= n1 or not u50 then
				return
			end

			for i = 1, 6 do
				local v236 = p27.Views and p27.Views[i]

				if v236 and v236.State == "Countdown" then
					local v237 = t3[i]

					if not v237 then
						continue
					end

					local v238 = v236.UnlockAt or os.time()
					local timestamp = os.time()
					local n2 = v238 - timestamp

					if n2 <= 0 then
						julyEvent_Action:FireServer("Refresh")

						return
					end

					setCounterMode(i, v237, "Countdown", n2)
				end
			end

			renderTimer(p27)
		end
	end)
end
local function ensurePopScale()
	if u51 and u51.Parent == scriptParent then
		return u51
	end

	local popScale: UIScale = Instance.new("UIScale")

	popScale.Name = "PopScale"
	popScale.Scale = 1
	popScale.Parent = scriptParent
	u51 = popScale

	return popScale
end
local function cancelActiveTween()
	if u52 then
		u52:Cancel()
		u52 = nil
	end
end

local u76 = nil
local u77 = nil

u76 = function()
	if u50 then
		return
	end

	u50 = true
	LocalPlayer:SetAttribute("FourthOfJulyOpen", true)
	task.spawn(function()
		local ok, result = pcall(function()
			return julyEvent_Request:InvokeServer("GetState")
		end)

		if ok and result then
			renderAll(result)
		elseif u53 then
			renderAll(u53)
		end
	end)

	if u53 then
		renderAll(u53)
	end

	local v198

	if u51 and u51.Parent == scriptParent then
		v198 = u51
	else
		local popScale: UIScale = Instance.new("UIScale")

		popScale.Name = "PopScale"
		popScale.Scale = 1
		popScale.Parent = scriptParent
		u51 = popScale
		v198 = popScale
	end

	v198.Scale = 0.85
	scriptParent.Visible = true

	if u55 then
		u55.Visible = true
	end

	if u52 then
		u52:Cancel()
		u52 = nil
	end

	local v200: Tween = tweenService:Create(v198, tweenInfo, { Scale = 1 })

	u52 = v200
	v200:Play()

	local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

	LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) + 1)
	windowBlur.show("FourthOfJuly")
	activeWindowChanged:Fire("FourthOfJuly")
end
u77 = function()
	if not u50 then
		return
	end

	u50 = false
	LocalPlayer:SetAttribute("FourthOfJulyOpen", false)

	local v202

	if u51 and u51.Parent == scriptParent then
		v202 = u51
	else
		local popScale: UIScale = Instance.new("UIScale")

		popScale.Name = "PopScale"
		popScale.Scale = 1
		popScale.Parent = scriptParent
		u51 = popScale
		v202 = popScale
	end

	if u52 then
		u52:Cancel()
		u52 = nil
	end

	local v204: Tween = tweenService:Create(v202, tweenInfo2, { Scale = 0.92 })

	u52 = v204
	v204:Play()
	v204.Completed:Once(function()
		if not u50 then
			scriptParent.Visible = false

			if u55 then
				u55.Visible = false
			end

			v202.Scale = 1
		end
	end)

	local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
	local v206 = math.max((mouseUnlocked or 0) - 1, 0)

	LocalPlayer:SetAttribute("MouseUnlocked", v206)
	windowBlur.hide("FourthOfJuly")
end
activeWindowChanged.Event:Connect(function(p28)
	if p28 ~= "FourthOfJuly" and u50 then
		u77()
	end
end)

if closeButton and (not not closeButton:IsA("ImageButton") or not not closeButton:IsA("TextButton")) then
	closeButton.MouseButton1Click:Connect(function()
		if u50 then
			u77()
		end
	end)
end

julyEvent_Push.OnClientEvent:Connect(function(p29)
	u53 = p29

	if u50 then
		renderAll(p29)
	end
end)

if julyEvent_DebugOpen then
	julyEvent_DebugOpen.OnClientEvent:Connect(function()
		if not u50 then
			u76()
		end
	end)
end

local fourthOfJuly_Open: BindableEvent = Instance.new("BindableEvent")

fourthOfJuly_Open.Name = "FourthOfJuly_Open"
fourthOfJuly_Open.Parent = scriptParent
fourthOfJuly_Open.Event:Connect(function()
	if u50 then
		u77()

		return
	end

	u76()
end)

local events: Instance = v25:FindFirstChild("Events")
local fourthOfJuly: Instance = events and events:FindFirstChild("FourthOfJuly")

if fourthOfJuly then
	if fourthOfJuly:IsA("TextButton") or fourthOfJuly:IsA("ImageButton") then
		fourthOfJuly.MouseButton1Click:Connect(function()
			if u50 then
				u77()

				return
			end

			u76()
		end)
	end

	local shine: Instance = fourthOfJuly:FindFirstChild("Shine")

	if shine then
		shineEffect.loop(shine, {
			duration = 1,
			offsetStart = Vector2.new(-1.8, 0),
			offsetEnd = Vector2.new(1.8, 0)
		})
	end
end

task.spawn(function()
	local eagle: Instance = workspace:WaitForChild("Eagle", 60)

	if not eagle then
		return
	end

	local humanoidRootPart: Instance = eagle:WaitForChild("HumanoidRootPart", 30)

	if not humanoidRootPart then
		return
	end

	local eventPrompt: Instance = humanoidRootPart:WaitForChild("EventPrompt", 30)

	if not eventPrompt or not eventPrompt:IsA("ProximityPrompt") then
		return
	end

	eventPrompt.Triggered:Connect(function(p30)
		if p30 ~= LocalPlayer then
		elseif not u50 then
			u76()
		end
	end)
end)
task.spawn(function()
	if LocalPlayer:GetAttribute("DataReady") ~= true then
		LocalPlayer:GetAttributeChangedSignal("DataReady"):Wait()
	end

	local ok, result = pcall(function()
		return julyEvent_Request:InvokeServer("GetState")
	end)

	if ok and result then
		u53 = result
	end

	if ok and result and u50 then
		renderAll(result)
	end
end)
v25 = nil

local countdown: Instance = fourthOfJuly and fourthOfJuly:FindFirstChild("Countdown")

if countdown and countdown:IsA("TextLabel") then
	v25 = countdown
end

local function setBtnVisible(visible)
	if fourthOfJuly and fourthOfJuly:IsA("GuiObject") then
		fourthOfJuly.Visible = visible
	end
end

if v25 then
	eventTimer.driveLabel(v25, function()
		return u53 and u53.EventEndsAt
	end, {
		redInFinalDay = true,
		onUpdate = function(_, p33)
			if fourthOfJuly and fourthOfJuly:IsA("GuiObject") then
				fourthOfJuly.Visible = not p33
			end
		end
	})
else
	task.spawn(function()
		local typeName
		local v218

		while true do
			typeName = typeof(u53 and u53.EventEndsAt)
			v218 = typeName == "number" and fourthOfJuly and fourthOfJuly:IsA("GuiObject")

			if v218 then
				fourthOfJuly.Visible = u219
			end

			task.wait(1)

			continue
		end
	end)
end

task.spawn(function()
	local eagle: Instance = workspace:WaitForChild("Eagle", 60)

	if not eagle then
		return
	end

	local humanoidRootPart: Instance = eagle:WaitForChild("HumanoidRootPart", 30)

	if not humanoidRootPart then
		return
	end

	local billboardGui: Instance = humanoidRootPart:WaitForChild("BillboardGui", 30)

	if not billboardGui then
		return
	end

	local title: Instance = billboardGui:WaitForChild("Title", 10)

	if not title then
		return
	end

	local timeLeft: Instance = title:FindFirstChild("TimeLeft")

	if not timeLeft then
		return
	end

	eventTimer.driveLabel(timeLeft, function()
		return u53 and u53.EventEndsAt
	end, { redInFinalDay = true })
end);
(function()
	local t7: {[any]: any} = {}

	for _, v in ipairs({ 5, 6 }) do
		local v228 = t3[v]
		local shine = v228 and v228:FindFirstChild("Shine")

		v228 = shine

		if v228 then
			v228 = shine:FindFirstChildOfClass("UIGradient")
		end

		if v228 then
			table.insert(t7, v228)
		end
	end

	if #t7 == 0 then
		return
	end

	for _, v in ipairs(t7) do
		v.Offset = vector2
	end

	task.spawn(function()
		while true do
			if u50 then
				for _, v in ipairs(t7) do
					v.Offset = vector2
					tweenService:Create(v, tweenInfo3, { Offset = vector22 }):Play()
				end
			end

			task.wait(3)
		end
	end)
end)()
