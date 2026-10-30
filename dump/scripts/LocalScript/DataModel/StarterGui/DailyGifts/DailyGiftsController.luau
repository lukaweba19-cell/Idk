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
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local dailyRewards_Claim: Instance = remotes:WaitForChild("DailyRewards_Claim")
local dailyRewards_DebugOpen: Instance = remotes:WaitForChild("DailyRewards_DebugOpen")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local dailyRewards = require(shared:WaitForChild("DailyRewards"))
local windowBlur = require(shared:WaitForChild("WindowBlur"))
local uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))
local extensions: Instance = replicatedStorage:WaitForChild("Extensions")
local inputCategorizer = require(extensions:WaitForChild("InputCategorizer"))
local frame: Instance = script.Parent:WaitForChild("Frame")
local days_Row1: Instance = frame:WaitForChild("Content"):WaitForChild("Days_Row1")
local claimButton: Instance = frame:WaitForChild("ClaimButton")
local closeButton: Instance = frame:FindFirstChild("CloseButton")

local function findDayButton(p1)
	local v53 = ("RewardDay%d"):format(p1)
	local foundChild: Instance = days_Row1:FindFirstChild(v53)
	local v55 = foundChild and foundChild:IsA("TextButton")

	assert(v55, ("DailyGifts: missing %s"):format(v53))

	return foundChild
end

local t1: {[any]: any} = {}

for i = 1, dailyRewards.CYCLE_LENGTH do
	local v24 = ("RewardDay%d"):format(i)
	local foundChild: Instance = days_Row1:FindFirstChild(v24)
	local v26 = foundChild and foundChild:IsA("TextButton")

	assert(v26, ("DailyGifts: missing %s"):format(v24))
	t1[i] = foundChild
	t1[i].Active = false
	t1[i].Interactable = false
end

local glow = t1[7]:FindFirstChild("Glow")

if glow then
	glow.Visible = false
end

local u28 = nil

task.spawn(function()
	local hud: Instance = playerGui:WaitForChild("HUD", 10)

	if not hud then
		return
	end

	local blackBackground2: Instance = hud:FindFirstChild("BlackBackground2")

	if blackBackground2 and blackBackground2:IsA("GuiObject") then
		u28 = blackBackground2
	end
end)
frame.Visible = false

local keybind: Instance = claimButton:FindFirstChild("Keybind")

if keybind and keybind:IsA("GuiObject") then
	uiFramework.applyGamepadKeybind(keybind, Enum.KeyCode.ButtonA)
	keybind.Visible = inputCategorizer.getLastInputCategory() == inputCategorizer.InputCategory.Gamepad
	inputCategorizer.lastInputCategoryChanged:Connect(function()
		keybind.Visible = inputCategorizer.getLastInputCategory() == inputCategorizer.InputCategory.Gamepad
	end)
end

local tweenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local u32: boolean = false
local u33: boolean = false
local u34 = nil
local u35 = nil
local n1: number = 0

local function formatCooldown(p2)
	local floored = math.floor(p2)
	local v60 = math.max(0, floored)
	local floored2 = math.floor(v60 / 3600)
	local floored3 = math.floor(v60 % 3600 / 60)

	return ("In %02d:%02d:%02d"):format(floored2, floored3, v60 % 60)
end
local function formatAmount(p3)
	return "x" .. tostring(p3):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end
local function setNestedText(p4, p5, text)
	local foundChild2 = p4:FindFirstChild(p5)

	if foundChild2 and foundChild2:IsA("TextLabel") then
		foundChild2.Text = text

		local foundChild3 = foundChild2:FindFirstChild(p5)

		if foundChild3 and foundChild3:IsA("TextLabel") then
			foundChild3.Text = text
		end
	end
end
local function deriveClaimState(p7, p8)
	return dailyRewards.DeriveClaimState(p7, p8, os.time())
end
local function getDayState(p9, p10, _)
	if p10.StreakReset then
		if p9 ~= 1 then
			return "Future"
		end

		if p10.IsClaimable then
			return "Available"
		end

		return "Locked"
	end

	if p9 < p10.CurrentDay then
		return "Claimed"
	end

	if p9 ~= p10.CurrentDay then
		return "Future"
	end

	if p10.IsClaimable then
		return "Available"
	end

	return "Locked"
end
local function readAttributes()
	local dailyRewardsLastClaimDay: any = LocalPlayer:GetAttribute("DailyRewardsLastClaimDay")
	local dailyRewardsLastClaimAt: any = LocalPlayer:GetAttribute("DailyRewardsLastClaimAt")
	local v76 = if typeof(dailyRewardsLastClaimDay) == "number" then dailyRewardsLastClaimDay else 0

	if typeof(dailyRewardsLastClaimAt) == "number" then
		return v76, dailyRewardsLastClaimAt
	end

	return v76, 0
end
local function isAnyClaimable()
	local dailyRewardsLastClaimDay: any = LocalPlayer:GetAttribute("DailyRewardsLastClaimDay")
	local dailyRewardsLastClaimAt: any = LocalPlayer:GetAttribute("DailyRewardsLastClaimAt")
	local typeName: string = typeof(dailyRewardsLastClaimDay)
	local typeName2: string = typeof(dailyRewardsLastClaimAt)

	return dailyRewards.DeriveClaimState(if typeName == "number" then dailyRewardsLastClaimDay else 0, if typeName2 == "number" then dailyRewardsLastClaimAt else 0, os.time()).IsClaimable
end
local function renderDay(p12, p13, _)
	local v84 = dailyRewards.Rewards[p12]

	if not v84 then
		return
	end

	local parent = t1[p12]
	local s1: string = if p13.StreakReset then if p12 == 1 then if p13.IsClaimable then "Available" else "Locked" else "Future" else if p12 < p13.CurrentDay then "Claimed" else if p12 == p13.CurrentDay then if p13.IsClaimable then "Available" else "Locked" else "Future"
	local reward = v84.Reward
	local amount = parent:FindFirstChild("Amount")

	if amount and amount:IsA("TextLabel") then
		if reward.Kind == "Coins" then
			amount.Text = "x" .. tostring(reward.Amount or 0):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
			amount.Visible = true
		elseif reward.Kind == "Cases" then
			local v89 = reward.Amount or 1

			if v89 > 1 then
				amount.Text = "x" .. tostring(v89):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
				amount.Visible = true
			else
				amount.Visible = false
			end
		end
	end

	if reward.Kind == "Coins" then
		local itemName = parent:FindFirstChild("ItemName")

		if itemName and itemName:IsA("TextLabel") then
			itemName.Text = "Coins"
		end
	end

	local timer = parent:FindFirstChild("Timer")

	if timer and timer:IsA("TextLabel") then
		if s1 == "Locked" then
			local floored = math.floor(p13.SecondsUntilClaim)
			local v93 = math.max(0, floored)
			local floored4 = math.floor(v93 / 3600)
			local floored5 = math.floor(v93 % 3600 / 60)

			timer.Text = ("In %02d:%02d:%02d"):format(floored4, floored5, v93 % 60)
		else
			timer.Text = ("Day %d"):format(p12)
		end

		timer.Visible = true
	end

	local claimedGlow = parent:FindFirstChild("ClaimedGlow")

	if s1 ~= "Claimed" then
		if claimedGlow then
			claimedGlow:Destroy()
		end
	elseif not claimedGlow and glow then
		local clone = glow:Clone()

		clone.Name = "ClaimedGlow"
		clone.Visible = true
		clone.Parent = parent

		return
	end
end
local function renderGlobalClaimButton(p15)
	local s1

	if p15.IsClaimable then
		s1 = "Claim!"
	else
		local floored = math.floor(p15.SecondsUntilClaim)
		local v101 = math.max(0, floored)
		local floored6 = math.floor(v101 / 3600)
		local floored7 = math.floor(v101 % 3600 / 60)

		s1 = ("In %02d:%02d:%02d"):format(floored6, floored7, v101 % 60)
	end

	local textLabel: Instance = claimButton:FindFirstChild("TextLabel")

	if textLabel and textLabel:IsA("TextLabel") then
		textLabel.Text = s1

		local textLabel2: Instance = textLabel:FindFirstChild("TextLabel")

		if textLabel2 and textLabel2:IsA("TextLabel") then
			textLabel2.Text = s1
		end
	end

	claimButton.Text = s1
	claimButton.Active = true
	claimButton.Interactable = true
end
local function renderAll()
	n1 += 1

	local v106: number = n1
	local dailyRewardsLastClaimDay: any = LocalPlayer:GetAttribute("DailyRewardsLastClaimDay")
	local dailyRewardsLastClaimAt: any = LocalPlayer:GetAttribute("DailyRewardsLastClaimAt")
	local v109 = if typeof(dailyRewardsLastClaimDay) == "number" then dailyRewardsLastClaimDay else 0
	local typeName: string = typeof(dailyRewardsLastClaimAt)
	local v111 = dailyRewards.DeriveClaimState(v109, if typeName == "number" then dailyRewardsLastClaimAt else 0, os.time())

	for i = 1, dailyRewards.CYCLE_LENGTH do
		renderDay(i, v111, v109)
	end

	local s1

	if v111.IsClaimable then
		s1 = "Claim!"
	else
		local floored = math.floor(v111.SecondsUntilClaim)
		local v115 = math.max(0, floored)
		local floored8 = math.floor(v115 / 3600)
		local floored9 = math.floor(v115 % 3600 / 60)

		s1 = ("In %02d:%02d:%02d"):format(floored8, floored9, v115 % 60)
	end

	local textLabel: Instance = claimButton:FindFirstChild("TextLabel")

	if textLabel and textLabel:IsA("TextLabel") then
		textLabel.Text = s1

		local textLabel3: Instance = textLabel:FindFirstChild("TextLabel")

		if textLabel3 and textLabel3:IsA("TextLabel") then
			textLabel3.Text = s1
		end
	end

	claimButton.Text = s1
	claimButton.Active = true
	claimButton.Interactable = true

	if not v111.IsClaimable and v111.SecondsUntilClaim > 0 then
		task.spawn(function()
			while v106 == n1 do
				local dailyRewardsLastClaimDay2: any = LocalPlayer:GetAttribute("DailyRewardsLastClaimDay")
				local dailyRewardsLastClaimAt2: any = LocalPlayer:GetAttribute("DailyRewardsLastClaimAt")
				local typeName3: string = typeof(dailyRewardsLastClaimDay2)
				local typeName4: string = typeof(dailyRewardsLastClaimAt2)
				local v148 = dailyRewards.DeriveClaimState(if typeName3 == "number" then dailyRewardsLastClaimDay2 else 0, if typeName4 == "number" then dailyRewardsLastClaimAt2 else 0, os.time())

				if v148.IsClaimable or v148.SecondsUntilClaim <= 0 then
					if v106 == n1 then
						renderAll()
					end

					return
				end

				local floored = math.floor(v148.SecondsUntilClaim)
				local v150 = math.max(0, floored)
				local floored10 = math.floor(v150 / 3600)
				local floored11 = math.floor(v150 % 3600 / 60)
				local text = ("In %02d:%02d:%02d"):format(floored10, floored11, v150 % 60)
				local timer = t1[v148.CurrentDay]:FindFirstChild("Timer")

				if timer and timer:IsA("TextLabel") then
					timer.Text = text
				end

				local textLabel4: Instance = claimButton:FindFirstChild("TextLabel")

				if textLabel4 and textLabel4:IsA("TextLabel") then
					textLabel4.Text = text

					local textLabel5: Instance = textLabel4:FindFirstChild("TextLabel")

					if textLabel5 and textLabel5:IsA("TextLabel") then
						textLabel5.Text = text
					end
				end

				claimButton.Text = text
				task.wait(1)
			end
		end)
	end
end
local function ensurePopScale()
	if u34 and u34.Parent == frame then
		return u34
	end

	local popScale: UIScale = Instance.new("UIScale")

	popScale.Name = "PopScale"
	popScale.Scale = 1
	popScale.Parent = frame
	u34 = popScale

	return popScale
end
local function cancelActiveTween()
	if u35 then
		u35:Cancel()
		u35 = nil
	end
end

local u49 = nil
local u50 = nil

u49 = function()
	if u32 then
		return
	end

	u32 = true
	LocalPlayer:SetAttribute("DailyGiftsOpen", true)
	renderAll()

	local v121

	if u34 and u34.Parent == frame then
		v121 = u34
	else
		local popScale: UIScale = Instance.new("UIScale")

		popScale.Name = "PopScale"
		popScale.Scale = 1
		popScale.Parent = frame
		u34 = popScale
		v121 = popScale
	end

	v121.Scale = 0.85
	frame.Visible = true

	if u28 then
		u28.Visible = true
	end

	if u35 then
		u35:Cancel()
		u35 = nil
	end

	local v123: Tween = tweenService:Create(v121, tweenInfo, { Scale = 1 })

	u35 = v123
	v123:Play()
	windowBlur.show("DailyGifts")
	activeWindowChanged:Fire("DailyGifts")
end
u50 = function()
	if not u32 then
		return
	end

	u32 = false
	u33 = false
	LocalPlayer:SetAttribute("DailyGiftsOpen", false)

	local v124

	if u34 and u34.Parent == frame then
		v124 = u34
	else
		local popScale: UIScale = Instance.new("UIScale")

		popScale.Name = "PopScale"
		popScale.Scale = 1
		popScale.Parent = frame
		u34 = popScale
		v124 = popScale
	end

	if u35 then
		u35:Cancel()
		u35 = nil
	end

	local v126: Tween = tweenService:Create(v124, tweenInfo2, { Scale = 0.92 })

	u35 = v126
	v126:Play()
	v126.Completed:Once(function()
		if not u32 then
			frame.Visible = false

			if u28 then
				u28.Visible = false
			end

			v124.Scale = 1
		end
	end)
	windowBlur.hide("DailyGifts")
end
activeWindowChanged.Event:Connect(function(p16)
	if p16 ~= "DailyGifts" and u32 then
		u50()
	end
end)

local function tryClaim()
	task.delay(0.4, function()
		if u32 then
			u50()
		end
	end)

	if u33 then
		return
	end

	local dailyRewardsLastClaimDay: any = LocalPlayer:GetAttribute("DailyRewardsLastClaimDay")
	local dailyRewardsLastClaimAt: any = LocalPlayer:GetAttribute("DailyRewardsLastClaimAt")
	local typeName: string = typeof(dailyRewardsLastClaimDay)
	local typeName5: string = typeof(dailyRewardsLastClaimAt)

	if not dailyRewards.DeriveClaimState(if typeName == "number" then dailyRewardsLastClaimDay else 0, if typeName5 == "number" then dailyRewardsLastClaimAt else 0, os.time()).IsClaimable then
		return
	end

	u33 = true
	n1 += 1

	local textLabel: Instance = claimButton:FindFirstChild("TextLabel")

	if textLabel and textLabel:IsA("TextLabel") then
		textLabel.Text = "Claimed"

		local textLabel6: Instance = textLabel:FindFirstChild("TextLabel")

		if textLabel6 and textLabel6:IsA("TextLabel") then
			textLabel6.Text = "Claimed"
		end
	end

	claimButton.Text = "Claimed"
	dailyRewards_Claim:FireServer()
end

if closeButton and (not not closeButton:IsA("ImageButton") or not not closeButton:IsA("TextButton")) then
	closeButton.MouseButton1Click:Connect(function()
		if u32 then
			u50()
		end
	end)
end

claimButton.MouseButton1Click:Connect(tryClaim)
userInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	if not u32 then
	elseif input.KeyCode == Enum.KeyCode.ButtonA then
		tryClaim()
	end
end)
LocalPlayer:GetAttributeChangedSignal("DailyRewardsLastClaimDay"):Connect(renderAll)
LocalPlayer:GetAttributeChangedSignal("DailyRewardsLastClaimAt"):Connect(renderAll)
renderAll()
dailyRewards_DebugOpen.OnClientEvent:Connect(function()
	if not u32 then
		u49()
	end
end)
task.spawn(function()
	local v136 = os.clock()

	while true do
		if LocalPlayer:GetAttribute("DailyRewardsLastClaimAt") ~= nil or LocalPlayer:GetAttribute("DailyRewardsLastClaimDay") ~= nil or not (os.clock() - v136 < 30) then
			break
		end

		task.wait(0.1)
	end

	v136 = os.clock()

	while true do
		if workspace:GetAttribute("LoadingScreenCompleted") == true or not (os.clock() - v136 < 60) then
			break
		end

		task.wait(0.1)
	end

	if workspace:GetAttribute("LoadingScreenCompleted") == true then
		task.wait(0.5)

		while true do
			if LocalPlayer:GetAttribute("TutorialPhase") == 0 then
				break
			end

			LocalPlayer:GetAttributeChangedSignal("TutorialPhase"):Wait()
		end

		while true do
			if LocalPlayer:GetAttribute("MatchId") == nil then
				break
			end

			LocalPlayer:GetAttributeChangedSignal("MatchId"):Wait()
		end

		task.wait(0.5)

		local hud: Instance = playerGui:FindFirstChild("HUD")
		local updateLogWindow: Instance = hud and hud:FindFirstChild("UpdateLogWindow")

		if updateLogWindow and updateLogWindow:IsA("GuiObject") then
			local v139 = os.clock()

			while updateLogWindow.Visible and os.clock() - v139 < 60 do
				task.wait(0.2)
			end
		end

		if u32 then
			return
		end

		local dailyRewardsLastClaimDay: any = LocalPlayer:GetAttribute("DailyRewardsLastClaimDay")
		local dailyRewardsLastClaimAt: any = LocalPlayer:GetAttribute("DailyRewardsLastClaimAt")
		local typeName: string = typeof(dailyRewardsLastClaimDay)
		local typeName6: string = typeof(dailyRewardsLastClaimAt)

		if not dailyRewards.DeriveClaimState(if typeName == "number" then dailyRewardsLastClaimDay else 0, if typeName6 == "number" then dailyRewardsLastClaimAt else 0, os.time()).IsClaimable then
			return
		end

		u49()

		return
	end
end)
