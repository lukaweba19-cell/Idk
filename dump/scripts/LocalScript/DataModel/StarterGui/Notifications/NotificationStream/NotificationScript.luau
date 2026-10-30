-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")
local sound = require(game.ReplicatedStorage:WaitForChild("Sound"))
local shared = game.ReplicatedStorage:WaitForChild("Shared")
local traitText = require(shared:WaitForChild("TraitText"))
local replicatedStorageShared = game.ReplicatedStorage:WaitForChild("Shared")
local playerState = require(replicatedStorageShared:WaitForChild("PlayerState"))
local LocalPlayer: Player = game:GetService("Players").LocalPlayer
local scriptParent: Instance = script.Parent
local t1: {[any]: any} = {}

for _, v in ipairs({
	"FailNotification",
	"LevelUpNotification",
	"PurchaseNotification",
	"GiftNotification",
	"SuccessNotification",
	"QuestProgressNotification",
	"QuestCompletedNotification",
	"AdminNotification",
	"NegativeNotification",
	"OmegaNotification",
	"HeartNotification",
	"SecretNotification",
	"PlagueNotification",
	"PurplePlagueNotification",
	"Fl8meyNotification"
}) do
	local v12: Instance = scriptParent:WaitForChild(v, 5)

	if v12 then
		v12.Visible = false
		t1[v] = v12
	else
		warn("[Notifications] Template missing: " .. v)
	end
end

local queueNotificationSlot: Instance = scriptParent:WaitForChild("QueueNotificationSlot")
local queueNotification: Instance = queueNotificationSlot:WaitForChild("QueueNotification")
local textLabel: Instance = queueNotification:WaitForChild("TextLabel")
local v16: Instance = queueNotification:WaitForChild("Type")
local timer: Instance = queueNotification:WaitForChild("Timer")
local cancelBtn: Instance = queueNotification:WaitForChild("CancelBtn")
local onCancel = nil
local t2: {[any]: any} = {
	FailNotification = "Misc.NotificationNegative",
	LevelUpNotification = "Misc.NotificationPositive",
	PurchaseNotification = "Misc.NotificationPurchase",
	GiftNotification = "Misc.NotificationPositive",
	SuccessNotification = "Misc.NotificationPositive",
	QuestProgressNotification = "Misc.NotificationNeutral",
	QuestCompletedNotification = "Misc.NotificationPositive",
	AdminNotification = "Misc.NotificationPositive",
	NegativeNotification = "Misc.NotificationVariant",
	HeartNotification = "Misc.NotificationVariant"
}

t2.SecretNotification = t2.SuccessNotification
t2.PlagueNotification = t2.GiftNotification
t2.PurplePlagueNotification = t2.GiftNotification
t2.Fl8meyNotification = t2.GiftNotification

local t3: {[any]: any} = { OmegaNotification = "rbxassetid://101504014380329" }
local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

local function captureTransparency(p1)
	local t10: {[any]: any} = {}

	local function add(p2, p3)
		t10[p2] = t10[p2] or {}
		t10[p2][p3] = p2[p3]
	end
	local function consider(p4)
		if not p4:IsA("TextLabel") and not p4:IsA("TextButton") and not p4:IsA("TextBox") then
			if not p4:IsA("ImageLabel") and not p4:IsA("ImageButton") then
				if not p4:IsA("Frame") and not p4:IsA("ScrollingFrame") then
					if p4:IsA("UIStroke") then
						t10[p4] = t10[p4] or {}
						t10[p4].Transparency = p4.Transparency
					end

					return
				end

				t10[p4] = t10[p4] or {}
				t10[p4].BackgroundTransparency = p4.BackgroundTransparency

				return
			end

			t10[p4] = t10[p4] or {}
			t10[p4].ImageTransparency = p4.ImageTransparency
			t10[p4] = t10[p4] or {}
			t10[p4].BackgroundTransparency = p4.BackgroundTransparency

			return
		end

		t10[p4] = t10[p4] or {}
		t10[p4].TextTransparency = p4.TextTransparency
		t10[p4] = t10[p4] or {}
		t10[p4].TextStrokeTransparency = p4.TextStrokeTransparency
		t10[p4] = t10[p4] or {}
		t10[p4].BackgroundTransparency = p4.BackgroundTransparency
	end

	consider(p1)

	for iterFirst, iterSecond in p1:GetDescendants() do
		consider(iterSecond)
	end

	return t10
end
local function setAllTransparent(p5)
	for k, v in pairs(p5) do
		for iterKey in pairs(v) do
			k[iterKey] = 1
		end
	end
end
local function tweenToOriginals(p6, p7)
	for k, v in pairs(p6) do
		if k.Parent then
			tweenService:Create(k, p7, v):Play()
		end
	end
end
local function tweenToInvisible(p8, p9)
	for k, v in pairs(p8) do
		if k.Parent then
			local t11: {[any]: any} = {}

			for iterKey in pairs(v) do
				t11[iterKey] = 1
			end

			tweenService:Create(k, p9, t11):Play()
		end
	end
end
local function spawnAnimation(_, p11)
	setAllTransparent(p11)
	tweenToOriginals(p11, tweenInfo)
end
local function despawnAnimation(p12, p13)
	tweenToInvisible(p13, tweenInfo2)
	task.wait(tweenInfo2.Time + 0.02)
	p12:Destroy()
end

local t4: {[any]: any} = {
	AdminNotification = 20,
	NegativeNotification = 8,
	OmegaNotification = 8,
	HeartNotification = 8,
	SecretNotification = 8
}
local n1: number = 0

local function trimIfNeeded()
	local t12: {[any]: any} = {}

	for iterFirst, iterSecond in scriptParent:GetChildren() do
		if iterSecond:IsA("ImageLabel") and iterSecond.Visible and not t1[iterSecond.Name] and iterSecond ~= queueNotificationSlot then
			table.insert(t12, iterSecond)
		end
	end

	table.sort(t12, function(p14, p15)
		return p14.LayoutOrder < p15.LayoutOrder
	end)

	while #t12 > 5 do
		table.remove(t12, 1):Destroy()
	end
end
local function formatNumber(p16)
	local text = tostring(p16)

	repeat
		local v76, v77 = text:gsub("^(-?%d+)(%d%d%d)", "%1,%2")

		text = v76
	until v77 == 0

	return text
end
local function populate(p17, p18)
	local notifType = p18.notifType

	if notifType == "FailNotification" then
		local topLabel = p17:FindFirstChild("TopLabel")
		local bottomLabel = p17:FindFirstChild("BottomLabel")

		if topLabel then
			topLabel.Text = p18.topText or "Error!"
		end

		if bottomLabel then
			bottomLabel.Text = p18.errorMessage or "Something went wrong"
		end

		local imageLabel = p17:FindFirstChild("ImageLabel")

		if imageLabel and p18.iconOverride then
			imageLabel.Image = p18.iconOverride
			imageLabel.ImageColor3 = Color3.new(1, 1, 1)
		end

		if bottomLabel then
			bottomLabel.RichText = p18.richBottom == true

			return
		end
	elseif notifType == "LevelUpNotification" then
		local topLabel = p17:FindFirstChild("TopLabel")
		local bottomLabel = p17:FindFirstChild("BottomLabel")
		local icon = p17:FindFirstChild("Icon")

		if topLabel then
			topLabel.Text = "Level Up!"
		end

		if bottomLabel then
			bottomLabel.Text = "You are now Level " .. tostring(p18.level or 1)
		end

		local iconQuantityCounter = icon and icon:FindFirstChild("QuantityCounter")

		if iconQuantityCounter then
			iconQuantityCounter.Text = formatNumber(p18.coins or 0)

			return
		end
	elseif notifType == "PurchaseNotification" then
		local topLabel = p17:FindFirstChild("TopLabel")
		local bottomLabel = p17:FindFirstChild("BottomLabel")
		local imageLabel = p17:FindFirstChild("ImageLabel")

		if topLabel then
			topLabel.Text = "Spent " .. formatNumber(p18.cost or 0) .. " Coins"
		end

		if bottomLabel then
			bottomLabel.Text = "Purchased " .. (p18.itemName or "Item")
		end

		if imageLabel and p18.iconOverride then
			imageLabel.Image = p18.iconOverride

			return
		end
	elseif notifType == "GiftNotification" or notifType == "NegativeNotification" or notifType == "OmegaNotification" or notifType == "HeartNotification" or notifType == "SecretNotification" or notifType == "PlagueNotification" or notifType == "PurplePlagueNotification" or notifType == "Fl8meyNotification" then
		local topLabel = p17:FindFirstChild("TopLabel")
		local bottomLabel = p17:FindFirstChild("BottomLabel")
		local icon = p17:FindFirstChild("Icon")

		if topLabel then
			topLabel.Text = p18.topText or "Gift!"
		end

		if bottomLabel then
			local v94 = p18.itemName or p18.bottomText

			if v94 then
				traitText.Bind(bottomLabel, v94, notifType == "NegativeNotification")
			else
				bottomLabel.Visible = false

				if topLabel then
					topLabel.Position = UDim2.new(0.565, 0, 0.475, 0)
					topLabel.Size = UDim2.new(0.82, 0, 0.6, 0)
				end
			end
		end

		if icon then
			local quantityCounter = icon:FindFirstChild("QuantityCounter")

			if quantityCounter and p18.coins then
				quantityCounter.Text = formatNumber(p18.coins)
				icon.Visible = true
			end

			if p18.rewardIcon then
				icon.Image = p18.rewardIcon
				icon.Visible = true

				if quantityCounter then
					quantityCounter.Visible = false

					return
				end
			end
		end
	elseif notifType == "SuccessNotification" then
		local topLabel = p17:FindFirstChild("TopLabel")
		local bottomLabel = p17:FindFirstChild("BottomLabel")
		local icon = p17:FindFirstChild("Icon")

		if topLabel then
			topLabel.Text = p18.topText or "Success!"
		end

		if bottomLabel then
			if p18.bottomText then
				bottomLabel.Text = p18.bottomText
				bottomLabel.Visible = true
			else
				bottomLabel.Visible = false

				if topLabel then
					topLabel.Position = UDim2.new(0.565, 0, 0.475, 0)
					topLabel.Size = UDim2.new(0.82, 0, 0.6, 0)
				end
			end
		end

		if icon then
			local quantityCounter = icon:FindFirstChild("QuantityCounter")

			if quantityCounter and p18.coins then
				quantityCounter.Text = formatNumber(p18.coins)
				icon.Visible = true
			end

			if p18.counterIcon then
				icon.Image = p18.counterIcon
			end
		end

		local imageLabel = p17:FindFirstChild("ImageLabel")

		if imageLabel and p18.iconOverride then
			imageLabel.Image = p18.iconOverride
			imageLabel.ImageColor3 = Color3.new(1, 1, 1)
		end

		if bottomLabel then
			bottomLabel.RichText = p18.richBottom == true

			return
		end
	elseif notifType == "QuestProgressNotification" then
		local topLabel = p17:FindFirstChild("TopLabel")
		local icon = p17:FindFirstChild("Icon")
		local progressLabel = p17:FindFirstChild("ProgressLabel")
		local progressBarContainer = p17:FindFirstChild("ProgressBarContainer")
		local v105 = p18.questCurrent or 0
		local v106 = p18.questRequired or 1
		local v107 = p18.questPrevious or 0

		if topLabel then
			topLabel.Text = p18.questLabel or "Task"
		end

		if progressLabel then
			local text: string = tostring(v105)
			local text2: string = tostring(v106)

			progressLabel.Text = text .. "/" .. text2
		end

		local v110 = icon and icon:FindFirstChild("QuantityCounter")

		if v110 then
			v110.Text = formatNumber(p18.questReward or 0)
		end

		local bar = progressBarContainer and progressBarContainer:FindFirstChild("Bar")

		if bar then
			local v112 = math.clamp(v107 / v106, 0, 1)
			local v113 = math.clamp(v105 / v106, 0, 1)

			bar.Size = UDim2.new(v112, 0, 1, 0)
			task.defer(function()
				local tweenInfo3 = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				local uDim2 = UDim2.new(v113, 0, 1, 0)

				tweenService:Create(bar, tweenInfo3, { Size = uDim2 }):Play()
			end)

			return
		end
	elseif notifType == "QuestCompletedNotification" then
		local topLabel = p17:FindFirstChild("TopLabel")
		local bottomLabel = p17:FindFirstChild("BottomLabel")
		local icon = p17:FindFirstChild("Icon")

		if topLabel then
			topLabel.Text = "Task Completed!"
		end

		if bottomLabel then
			bottomLabel.Text = p18.questLabel or "Task"
		end

		local v117 = icon and icon:FindFirstChild("QuantityCounter")

		if v117 then
			v117.Text = formatNumber(p18.questReward or 0)

			return
		end
	elseif notifType == "AdminNotification" then
		local bottomLabel = p17:FindFirstChild("BottomLabel")
		local adminPfp = p17:FindFirstChild("AdminPfp")

		if bottomLabel and p18.bottomText then
			bottomLabel.Text = p18.bottomText
		end

		if adminPfp and p18.senderUserId then
			adminPfp.Image = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150", p18.senderUserId)
		end
	end
end

local t5: {[any]: any} = {
	["[NEGATIVE]"] = "NegativeNotification",
	["[OMEGA]"] = "OmegaNotification"
}

local function traitTemplateFor(p19)
	if p19.notifType == "GiftNotification" then
		local v121 = traitText.TagOf(p19.itemName or p19.bottomText)

		if not v121 then
			return nil
		end

		local v122 = t5[v121]

		if v122 and t1[v122] then
			return v122
		end

		return nil
	end

	return nil
end

local t6: {[any]: any} = { AdminNotification = true }
local t7: {[any]: any} = {}
local u39: boolean = false

local function holdActive()
	if playerState.ReplayActive then
		return true
	end

	return LocalPlayer:GetAttribute("_EndNotifHold") == true
end

local t8: {[any]: any} = {}

function t8.Notify(p20)
	if (if playerState.ReplayActive then true else LocalPlayer:GetAttribute("_EndNotifHold") == true) and not t6[p20.notifType] then
		table.insert(t7, table.clone(p20))

		while #t7 > 20 do
			table.remove(t7, 1)
		end

		if not u39 then
			u39 = true
			task.spawn(function()
				while true do
					if not (if playerState.ReplayActive then true else LocalPlayer:GetAttribute("_EndNotifHold") == true) then
						break
					end

					task.wait(0.1)
				end

				u39 = false

				local v158: {[any]: any} = t7
				t7 = {}

				for _, v in ipairs(v158) do
					t8.Notify(v)
				end
			end)
		end

		return nil
	end

	local v124

	if p20.notifType == "GiftNotification" then
		local v125 = traitText.TagOf(p20.itemName or p20.bottomText)
		local v126 = t5[v125]

		v124 = if not v125 then nil else if v126 and t1[v126] then v126 else nil
	else
		v124 = nil
	end

	if v124 then
		p20 = table.clone(p20)
		p20.notifType = v124
	end

	if not t1[p20.notifType] and (p20.notifType == "PlagueNotification" or p20.notifType == "PurplePlagueNotification" or p20.notifType == "Fl8meyNotification") then
		p20 = table.clone(p20)
		p20.notifType = "GiftNotification"
	end

	local notifType = p20.notifType
	local v128 = t1[notifType]

	if not v128 then
		local text: string = tostring(notifType)

		warn("[Notifications] Unknown notifType: " .. text)

		return nil
	end

	local v130 = p20.duration or t4[notifType] or 5
	local v131 = t2[notifType]
	local v132 = if typeof(p20.sound) == "string" and p20.sound ~= "" then p20.sound else nil

	if v131 and not v132 then
		sound:Play(v131, workspace)
	else
		local soundId = v132 or t3[notifType]

		if soundId then
			local sound2: Sound = Instance.new("Sound")

			sound2.SoundId = soundId
			sound2.Volume = 1
			sound2.PlayOnRemove = true
			sound2.Parent = workspace
			sound2:Destroy()
		end
	end

	local clone = v128:Clone()

	n1 += 1
	clone.Name = "Toast_" .. n1
	clone.LayoutOrder = n1
	clone.Visible = true
	clone.Parent = scriptParent
	populate(clone, p20)

	local v136 = captureTransparency(clone)

	setAllTransparent(v136)
	tweenToOriginals(v136, tweenInfo)

	if notifType == "OmegaNotification" then
		task.spawn(function()
			local t13: {[any]: any} = {}

			for _, v in ipairs(clone:GetChildren()) do
				if v:IsA("UIStroke") then
					table.insert(t13, v)
				end
			end

			local v164 = os.clock()

			while clone.Parent do
				local color3FromHSV = Color3.fromHSV
				local v166 = os.clock()
				local color3 = color3FromHSV((v166 - v164) / 2 % 1, 0.85, 1)

				clone.BackgroundColor3 = color3

				for _, v in ipairs(t13) do
					v.Color = color3
				end

				task.wait(0.03333333333333333)
			end
		end)
	end

	task.delay(v130, function()
		if clone and clone.Parent then
			tweenToInvisible(v136, tweenInfo2)
			task.wait(tweenInfo2.Time + 0.02)
			clone:Destroy()
		end
	end)
	trimIfNeeded()

	return clone
end

local v42 = UDim2.fromScale(0.5, 0.5)
local tweenInfo4 = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local u44 = nil

queueNotificationSlot.Visible = false

local function queueOffscreenPos()
	return UDim2.new(0.5, 0, 0.5, -(scriptParent.AbsolutePosition.Y + scriptParent.AbsoluteSize.Y * queueNotificationSlot.Size.Y.Scale + 16))
end

cancelBtn.Activated:Connect(function()
	local v137 = onCancel

	if v137 then
		v137()
	end
end)

function t8.QueueNotif(p21)
	if p21 and p21.active ~= false then
		onCancel = p21.onCancel
		textLabel.Text = p21.header or "Searching for Players..."
		v16.Text = p21.modes or ""

		if p21.timer == nil then
			timer.Visible = false
		else
			timer.Text = p21.timer
			timer.Visible = true
		end

		cancelBtn.Visible = p21.showCancel ~= false

		if not queueNotificationSlot.Visible then
			if u44 then
				u44:Cancel()
			end

			queueNotification.Position = UDim2.new(0.5, 0, 0.5, -(scriptParent.AbsolutePosition.Y + scriptParent.AbsoluteSize.Y * queueNotificationSlot.Size.Y.Scale + 16))
			queueNotificationSlot.Visible = true
			u44 = tweenService:Create(queueNotification, tweenInfo4, { Position = v42 })
			u44:Play()
		end

		return
	end

	queueNotificationSlot.Visible = false

	if u44 then
		u44:Cancel()
		u44 = nil
	end

	queueNotification.Position = v42
	onCancel = nil
end

game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Notification").OnClientEvent:Connect(function(p22)
	if typeof(p22) == "table" and p22.notifType then
		t8.Notify(p22)
	end
end)

local t9: {[any]: any} = {
	{
		match = "Omega",
		template = "OmegaNotification",
		data = {
			notifType = "OmegaNotification",
			topText = "OMEGA VARIANT FOUND",
			bottomText = "SECRET TRANSMISSION: 0M3GA",
			rewardIcon = "rbxassetid://95117527383202"
		}
	},
	{
		match = "HeartStealer",
		template = "HeartNotification",
		data = {
			notifType = "HeartNotification",
			topText = "HEART STEALER!",
			bottomText = "You found the rare variant.",
			rewardIcon = "rbxassetid://111349502828048"
		}
	},
	{
		match = "WhiteCat",
		template = "NegativeNotification",
		data = {
			notifType = "NegativeNotification",
			topText = "WHITE CAT!",
			bottomText = "Mewow, lucky 10% variant unlocked!",
			rewardIcon = "rbxassetid://131369991525019",
			sound = "rbxassetid://134699420140804"
		}
	}
}

game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("PackVariantHit").OnClientEvent:Connect(function(p23)
	if typeof(p23) == "table" and typeof(p23.Rewards) == "table" then
		local s1: string = ""

		for _, v in ipairs(p23.Rewards) do
			if typeof(v) == "table" then
				local text: string = tostring(v.ItemId or "")
				local text3: string = tostring(v.Finisher or "")

				s1 = s1 .. text .. "|" .. text3 .. "|"
			end
		end

		for _, v in ipairs(t9) do
			if string.find(s1, v.match, 1, true) then
				local v148 = table.clone(v.data)

				if not t1[v.template] then
					v148.notifType = "GiftNotification"
				end

				t8.Notify(v148)

				return
			end
		end

		return
	end
end)

function _G.Notify(p24)
	return t8.Notify(p24)
end
function _G.QueueNotif(p25)
	return t8.QueueNotif(p25)
end
