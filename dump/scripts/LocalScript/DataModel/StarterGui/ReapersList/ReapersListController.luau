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
local korbloxEvent_Request: Instance = remotes:WaitForChild("KorbloxEvent_Request")
local korbloxEvent_Push: Instance = remotes:WaitForChild("KorbloxEvent_Push")
local korbloxEvent_Action: Instance = remotes:WaitForChild("KorbloxEvent_Action")
local korbloxEvent_DebugOpen: Instance = remotes:FindFirstChild("KorbloxEvent_DebugOpen")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local windowBlur = require(shared:WaitForChild("WindowBlur"))
local reapersListTemplates: Instance = replicatedStorage:WaitForChild("UIFramework"):WaitForChild("ReapersListTemplates")
local startButton: Instance = reapersListTemplates:WaitForChild("StartButton")
local claimButton: Instance = reapersListTemplates:WaitForChild("ClaimButton")
local claimOverlay: Instance = reapersListTemplates:WaitForChild("ClaimOverlay")
local claimedLabel: Instance = reapersListTemplates:WaitForChild("ClaimedLabel")
local lockedStartLabel: Instance = reapersListTemplates:WaitForChild("LockedStartLabel")
local skipButton: Instance = reapersListTemplates:WaitForChild("SkipButton")
local counter_Day: Instance = reapersListTemplates:WaitForChild("Counter_Day")

reapersListTemplates:WaitForChild("Counter_Kills")
reapersListTemplates:WaitForChild("Counter_Countdown")

local scriptParent: Instance = script.Parent
local frame: Instance = scriptParent:WaitForChild("Frame")
local content: Instance = frame:WaitForChild("Content")
local finalReward: Instance = frame:WaitForChild("FinalReward")
local quest6: Instance = finalReward:WaitForChild("Quest6")
local timer: Instance = frame:WaitForChild("Timer")
local closeButton: Instance = frame:FindFirstChild("CloseButton")
local v29: Instance = content:WaitForChild("Quest" .. 1)
local v30: Instance = content:WaitForChild("Quest" .. 2)
local v31: Instance = content:WaitForChild("Quest" .. 3)
local v32: Instance = content:WaitForChild("Quest" .. 4)
local v33: Instance = content:WaitForChild("Quest" .. 5)
local t1: {[any]: any} = { [5] = true }
local t2: {[any]: any} = {
	"StartButton",
	"ClaimButton",
	"ClaimOverlay",
	"ClaimedLabel",
	"SkipButton"
}
local t3: {[any]: any} = { v29, v30, v31, v32, v33, quest6 }

for k, v in pairs(t3) do
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
local u48: boolean = false
local u49 = nil
local u50 = nil
local u51 = nil
local n1: number = 0
local u53 = nil

task.spawn(function()
	local hud: Instance = playerGui:WaitForChild("HUD", 10)

	if not hud then
		return
	end

	local blackBackground2: Instance = hud:FindFirstChild("BlackBackground2")

	if blackBackground2 and blackBackground2:IsA("GuiObject") then
		u53 = blackBackground2
	end
end)
frame.Visible = false

local function formatDHM(p1)
	local floored = math.floor(p1)
	local v80 = math.max(0, floored)
	local floored2 = math.floor(v80 / 86400)
	local floored3 = math.floor(v80 % 86400 / 3600)
	local floored4 = math.floor(v80 % 3600 / 60)

	if floored2 > 0 then
		return ("%dd %dh %dm"):format(floored2, floored3, floored4)
	end

	if floored3 > 0 then
		return ("%dh %dm"):format(floored3, floored4)
	end

	return ("%dm %ds"):format(floored4, v80 % 60)
end
local function formatHMS(p2)
	local floored = math.floor(p2)
	local v86 = math.max(0, floored)
	local floored5 = math.floor(v86 / 3600)
	local floored6 = math.floor(v86 % 3600 / 60)

	return ("%02d:%02d:%02d"):format(floored5, floored6, v86 % 60)
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
	local v102 = if not p9:IsA("TextButton") and not p9:IsA("ImageButton") then p9:FindFirstChildWhichIsA("TextButton", true) or p9:FindFirstChildWhichIsA("ImageButton", true) else p9

	if v102 then
		v102.MouseButton1Click:Connect(p10)
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

local function setCounterMode(p14, parent, p16, p17)
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

	if p14 == 5 and p16 == "DayLocked" then
		local rl_Counter = parent:FindFirstChild("RL_Counter")

		if rl_Counter then
			rl_Counter:Destroy()
		end

		local counter = parent:FindFirstChild("Counter")

		if counter and counter:IsA("Frame") then
			counter.Visible = true

			local amount = counter:FindFirstChild("Amount")

			if amount then
				amount.Text = "Day " .. tostring(p17)
			end
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
			local floored7 = math.floor(v123 / 3600)
			local floored8 = math.floor(v123 % 3600 / 60)

			v121 = ("%02d:%02d:%02d"):format(floored7, floored8, v123 % 60)
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

	local rarity = p18:FindFirstChild("Rarity")

	if rarity and rarity:IsA("GuiObject") then
		rarity.Visible = not visible
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
local function renderSlot(p20, p21)
	local parent = t3[p20]

	if not parent then
		return
	end

	clearClones(parent)

	local state = p21.State

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
		setCounterMode(p20, parent, "DayLocked", p20)
	elseif state == "LockedReady" then
		local rl_Counter2 = parent:FindFirstChild("RL_Counter")

		if rl_Counter2 then
			rl_Counter2:Destroy()
		end

		local counter2 = parent:FindFirstChild("Counter")

		if counter2 and counter2:IsA("GuiObject") then
			counter2.Visible = false
		end

		local v142: Instance = lockedStartLabel
		local rl_LockedStart = parent:FindFirstChild("RL_LockedStart")

		if not rl_LockedStart or not rl_LockedStart:IsA("GuiObject") then
			local clone: Instance = v142:Clone()

			clone.Name = "RL_LockedStart"
			clone.Visible = true
			clone.Parent = parent
		end
	elseif state == "Countdown" then
		setLocked(parent, true)

		local v145 = p21.UnlockAt or os.time()
		local timestamp = os.time()

		setCounterMode(p20, parent, "Countdown", v145 - timestamp)
	elseif state == "Grabbable" then
		local v147: Instance = startButton
		local rl_StartButton = parent:FindFirstChild("RL_StartButton")
		local v149

		if rl_StartButton and rl_StartButton:IsA("GuiObject") then
			v149 = rl_StartButton
		else
			local clone: Instance = v147:Clone()

			clone.Name = "RL_StartButton"
			clone.Visible = true
			clone.Parent = parent
			v149 = clone
		end

		hookClick(v149, function()
			korbloxEvent_Action:FireServer("Grab")
		end)
	elseif state == "InProgress" then
		setCounterMode(p20, parent, "Kills", { current = p21.Current, required = p21.Required })
	elseif state == "Claimable" then
		local v151: Instance = claimOverlay
		local rl_ClaimOverlay = parent:FindFirstChild("RL_ClaimOverlay")

		if not rl_ClaimOverlay or not rl_ClaimOverlay:IsA("GuiObject") then
			local clone: Instance = v151:Clone()

			clone.Name = "RL_ClaimOverlay"
			clone.Visible = true
			clone.Parent = parent
		end

		local v154: Instance = claimButton
		local rl_ClaimButton = parent:FindFirstChild("RL_ClaimButton")
		local v156

		if rl_ClaimButton and rl_ClaimButton:IsA("GuiObject") then
			v156 = rl_ClaimButton
		else
			local clone: Instance = v154:Clone()

			clone.Name = "RL_ClaimButton"
			clone.Visible = true
			clone.Parent = parent
			v156 = clone
		end

		hookClick(v156, function()
			korbloxEvent_Action:FireServer("Claim")
		end)
	elseif state == "Completed" then
		local v158: Instance = claimedLabel
		local rl_ClaimedLabel = parent:FindFirstChild("RL_ClaimedLabel")

		if not rl_ClaimedLabel or not rl_ClaimedLabel:IsA("GuiObject") then
			local clone: Instance = v158:Clone()

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

	if p21.CanSkip and p21.SkipProductId then
		setLocked(parent, false)

		local v163: Instance = skipButton
		local rl_Skip = parent:FindFirstChild("RL_Skip")
		local v165

		if rl_Skip and rl_Skip:IsA("GuiObject") then
			v165 = rl_Skip
		else
			local clone: Instance = v163:Clone()

			clone.Name = "RL_Skip"
			clone.Visible = true
			clone.Parent = parent
			v165 = clone
		end

		local priceTextLabel = v165:FindFirstChild("PriceTextLabel")

		if priceTextLabel then
			local v168 = utf8.char(57346)
			local v169 = p21.SkipPrice and tostring(p21.SkipPrice) or "???"

			priceTextLabel.Text = v168 .. v169
		end

		hookClick(v165, function()
			korbloxEvent_Action:FireServer("Skip")
		end)
	end
end

local u66: boolean = false

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

	local v171: boolean = finalReward:IsA("GuiObject")
	local v172 = v171 and finalReward.BackgroundTransparency or 0

	if v171 then
		finalReward.BackgroundTransparency = 1
	end

	local tweenInfo4 = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	tweenService:Create(revealScale, tweenInfo4, { Scale = 1 }):Play()

	if v171 then
		local tweenInfo5 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		tweenService:Create(finalReward, tweenInfo5, { BackgroundTransparency = v172 }):Play()
	end
end
local function renderFinal(p22)
	local v176 = p22.Views and p22.Views[6]

	if (p22.CurrentTier and p22.CurrentTier > 5) == true then
		if not u66 then
			u66 = true
			playFinalReveal()
		else
			content.Visible = false
			finalReward.Visible = true
		end

		if v176 then
			renderSlot(6, v176)

			return
		end
	else
		u66 = false
		finalReward.Visible = false
		content.Visible = true
	end
end
local function renderTimer(p23)
	local v178 = p23.EventEndsAt or 0

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
	local n1 = v178 - timestamp

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
		local text = formatDHM(n1)
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
local function renderAll(p25)
	if not p25 then
		return
	end

	u51 = p25
	n1 += 1

	local v188: number = n1

	for i = 1, 5 do
		local v190 = p25.Views and p25.Views[i]

		if v190 then
			renderSlot(i, v190)
		end
	end

	renderFinal(p25)
	renderTimer(p25)
	task.spawn(function()
		while v188 == n1 and u48 do
			task.wait(1)

			if v188 ~= n1 or not u48 then
				return
			end

			for i = 1, 6 do
				local v233 = p25.Views and p25.Views[i]

				if v233 and v233.State == "Countdown" then
					local v234 = t3[i]

					if not v234 then
						continue
					end

					local v235 = v233.UnlockAt or os.time()
					local timestamp = os.time()
					local n2 = v235 - timestamp

					if n2 <= 0 then
						korbloxEvent_Action:FireServer("Refresh")

						return
					end

					setCounterMode(i, v234, "Countdown", n2)
				end
			end

			renderTimer(p25)
		end
	end)
end
local function ensurePopScale()
	if u49 and u49.Parent == frame then
		return u49
	end

	local popScale: UIScale = Instance.new("UIScale")

	popScale.Name = "PopScale"
	popScale.Scale = 1
	popScale.Parent = frame
	u49 = popScale

	return popScale
end
local function cancelActiveTween()
	if u50 then
		u50:Cancel()
		u50 = nil
	end
end

local u73 = nil
local u74 = nil

u73 = function()
	if u48 then
		return
	end

	u48 = true
	LocalPlayer:SetAttribute("ReapersListOpen", true)
	task.spawn(function()
		local ok, result = pcall(function()
			return korbloxEvent_Request:InvokeServer("GetState")
		end)

		if ok and result then
			renderAll(result)
		elseif u51 then
			renderAll(u51)
		end
	end)

	if u51 then
		renderAll(u51)
	end

	local v192

	if u49 and u49.Parent == frame then
		v192 = u49
	else
		local popScale: UIScale = Instance.new("UIScale")

		popScale.Name = "PopScale"
		popScale.Scale = 1
		popScale.Parent = frame
		u49 = popScale
		v192 = popScale
	end

	v192.Scale = 0.85
	frame.Visible = true

	if u53 then
		u53.Visible = true
	end

	if u50 then
		u50:Cancel()
		u50 = nil
	end

	local v194: Tween = tweenService:Create(v192, tweenInfo, { Scale = 1 })

	u50 = v194
	v194:Play()

	local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

	LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) + 1)
	windowBlur.show("ReapersList")
	activeWindowChanged:Fire("ReapersList")
end
u74 = function()
	if not u48 then
		return
	end

	u48 = false
	LocalPlayer:SetAttribute("ReapersListOpen", false)

	local v196

	if u49 and u49.Parent == frame then
		v196 = u49
	else
		local popScale: UIScale = Instance.new("UIScale")

		popScale.Name = "PopScale"
		popScale.Scale = 1
		popScale.Parent = frame
		u49 = popScale
		v196 = popScale
	end

	if u50 then
		u50:Cancel()
		u50 = nil
	end

	local v198: Tween = tweenService:Create(v196, tweenInfo2, { Scale = 0.92 })

	u50 = v198
	v198:Play()
	v198.Completed:Once(function()
		if not u48 then
			frame.Visible = false

			if u53 then
				u53.Visible = false
			end

			v196.Scale = 1
		end
	end)

	local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
	local v200 = math.max((mouseUnlocked or 0) - 1, 0)

	LocalPlayer:SetAttribute("MouseUnlocked", v200)
	windowBlur.hide("ReapersList")
end
activeWindowChanged.Event:Connect(function(p26)
	if p26 ~= "ReapersList" and u48 then
		u74()
	end
end)

if closeButton and (not not closeButton:IsA("ImageButton") or not not closeButton:IsA("TextButton")) then
	closeButton.MouseButton1Click:Connect(function()
		if u48 then
			u74()
		end
	end)
end

korbloxEvent_Push.OnClientEvent:Connect(function(p27)
	u51 = p27

	if u48 then
		renderAll(p27)
	end
end)

if korbloxEvent_DebugOpen then
	korbloxEvent_DebugOpen.OnClientEvent:Connect(function()
		if not u48 then
			u73()
		end
	end)
end

local reapersList_Open: BindableEvent = Instance.new("BindableEvent")

reapersList_Open.Name = "ReapersList_Open"
reapersList_Open.Parent = scriptParent
reapersList_Open.Event:Connect(function()
	if u48 then
		u74()

		return
	end

	u73()
end)
task.spawn(function()
	local lobby: Instance = workspace:WaitForChild("Lobby", 30)

	if not lobby then
		return
	end

	local eventPromptPart: Instance = lobby:WaitForChild("EventPromptPart", 30)

	if not eventPromptPart then
		return
	end

	local eventPrompt: Instance = eventPromptPart:WaitForChild("EventPrompt", 30)

	if not eventPrompt or not eventPrompt:IsA("ProximityPrompt") then
		return
	end

	eventPrompt.Triggered:Connect(function(p28)
		if p28 ~= LocalPlayer then
		elseif not u48 then
			u73()
		end
	end)
end)
task.spawn(function()
	if LocalPlayer:GetAttribute("DataReady") ~= true then
		LocalPlayer:GetAttributeChangedSignal("DataReady"):Wait()
	end

	local ok, result = pcall(function()
		return korbloxEvent_Request:InvokeServer("GetState")
	end)

	if ok and result then
		u51 = result
	end

	if ok and result and u48 then
		renderAll(result)
	end
end)
task.spawn(function()
	local v208
	local v209
	local v210
	local v211
	local v212
	local timeLeft
	local v214
	local color3
	local color32
	local v217
	local typeName
	local timestamp
	local n1
	local v221

	v208 = workspace:WaitForChild("TheReaper", 60)

	if not v208 then
		return
	else
		v209 = v208:WaitForChild("HumanoidRootPart", 30)

		if not v209 then
			return
		else
			v210 = v209:WaitForChild("BillboardGui", 30)
			v211 = v210

			if not v211 then
				return
			else
				v212 = v211:WaitForChild("Title", 10)

				if not v212 then
					return
				else
					timeLeft = v212:FindFirstChild("TimeLeft")
					v214 = timeLeft

					if not v214 then
						return
					else
						color3 = Color3.fromRGB(255, 0, 0)
						color32 = Color3.fromRGB(255, 255, 255)

						while true do
							v217 = u51 and u51.EventEndsAt
							typeName = typeof(v217)

							if typeName == "number" then
								timestamp = os.time()
								n1 = v217 - timestamp

								if n1 <= 0 then
									v214.Text = "ENDED"
									v214.TextColor3 = color3
								else
									v221 = formatDHM(n1)
									v214.Text = v221
									v214.TextColor3 = n1 <= 86400 and color3 or color32
								end
							end

							task.wait(1)

							continue
						end
					end
				end
			end
		end
	end
end);
(function()
	local t7: {[any]: any} = {}

	for _, v in ipairs({ 5, 6 }) do
		local v225 = t3[v]
		local shine = v225 and v225:FindFirstChild("Shine")

		v225 = shine

		if v225 then
			v225 = shine:FindFirstChildOfClass("UIGradient")
		end

		if v225 then
			table.insert(t7, v225)
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
			if u48 then
				for _, v in ipairs(t7) do
					v.Offset = vector2
					tweenService:Create(v, tweenInfo3, { Offset = vector22 }):Play()
				end
			end

			task.wait(3)
		end
	end)
end)()
