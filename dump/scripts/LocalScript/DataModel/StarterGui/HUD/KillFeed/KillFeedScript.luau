-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local tweenService: TweenService = game:GetService("TweenService")
local LocalPlayer: Player = players.LocalPlayer
local killFeed_Push: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("KillFeed_Push")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local icons = require(shared:WaitForChild("Icons"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local viewedPlayer = require(replicatedStorageShared:WaitForChild("ViewedPlayer"))
local t1: {[any]: any} = {
	Kill = "KILL",
	Headshot = "HEADSHOT",
	Melee = "MELEE",
	Longshot = "LONGSHOT",
	Backstab = "BACKSTAB"
}
local iconsKillTypes = icons.KillTypes
local n1 = 0

local v13, v14, v15, v16, v17 = (function()
	local killFeed: Instance = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD"):WaitForChild("KillFeed")
	local playerHeadshots: Instance = killFeed:WaitForChild("PlayerHeadshots")
	local killFeedText: Instance = killFeed:WaitForChild("KillFeedText")
	local playerKillTemplate: Instance = playerHeadshots:WaitForChild("PlayerKillTemplate")
	local killTextTemplate: Instance = killFeedText:WaitForChild("KillTextTemplate")
	local killTypeTemplate: Instance = killFeedText:WaitForChild("KillTypeTemplate")

	playerKillTemplate.Visible = false
	killTextTemplate.Visible = false
	killTypeTemplate.Visible = false
	killFeedText.ClipsDescendants = false
	playerHeadshots.ClipsDescendants = false
	killFeed.Visible = true

	return playerHeadshots, killFeedText, playerKillTemplate, killTextTemplate, killTypeTemplate
end)()

local function captureAlpha(p1)
	local t4: {[any]: any} = {
		bg = {},
		img = {},
		txt = {},
		stroke = {}
	}

	local function cap(p2)
		if p2:IsA("Frame") then
			t4.bg[p2] = p2.BackgroundTransparency

			return
		end

		if not p2:IsA("ImageLabel") and not p2:IsA("ImageButton") then
			if not p2:IsA("TextLabel") and not p2:IsA("TextButton") and not p2:IsA("TextBox") then
				if p2:IsA("UIStroke") then
					t4.stroke[p2] = p2.Transparency
				end

				return
			end

			t4.bg[p2] = p2.BackgroundTransparency
			t4.txt[p2] = p2.TextTransparency

			return
		end

		t4.bg[p2] = p2.BackgroundTransparency
		t4.img[p2] = p2.ImageTransparency
	end

	cap(p1)

	for _, v in ipairs(p1:GetDescendants()) do
		cap(v)
	end

	return t4
end
local function applyAlpha(p3, p4)
	for k, v in pairs(p3.bg) do
		if k.Parent then
			k.BackgroundTransparency = v + (1 - v) * p4
		end
	end

	for k, v in pairs(p3.img) do
		if k.Parent then
			k.ImageTransparency = v + (1 - v) * p4
		end
	end

	for k, v in pairs(p3.txt) do
		if k.Parent then
			k.TextTransparency = v + (1 - v) * p4
		end
	end

	for k, v in pairs(p3.stroke) do
		if k.Parent then
			k.Transparency = v + (1 - v) * p4
		end
	end
end
local function getOrMakeScale(parent)
	local __uiScale = parent:FindFirstChild("__UIScale")

	if __uiScale and __uiScale:IsA("UIScale") then
		return __uiScale
	end

	local __uiScale: UIScale = Instance.new("UIScale")

	__uiScale.Name = "__UIScale"
	__uiScale.Scale = 1
	__uiScale.Parent = parent

	return __uiScale
end
local function popIn(parent)
	local v69 = captureAlpha(parent)

	applyAlpha(v69, 1)

	local v70 = parent.Position

	parent.Position = v70 + UDim2.new(0, -16, 0, 0)
	parent.Visible = true

	local __uiScale = parent:FindFirstChild("__UIScale")

	if not __uiScale or not __uiScale:IsA("UIScale") then
		__uiScale = Instance.new("UIScale")
		__uiScale.Name = "__UIScale"
		__uiScale.Scale = 1
		__uiScale.Parent = parent
	end

	__uiScale.Scale = 0.9

	local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	tweenService:Create(parent, tweenInfo, { Position = v70 }):Play()

	local tweenInfo2 = TweenInfo.new(0.14, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	v70 = tweenService:Create(__uiScale, tweenInfo2, { Scale = 1.16 })

	local tweenInfo3 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local v75: Tween = tweenService:Create(__uiScale, tweenInfo3, { Scale = 1 })

	v70:Play()
	v70.Completed:Connect(function()
		if __uiScale.Parent then
			v75:Play()
		end
	end)

	local v76 = os.clock()

	task.spawn(function()
		while parent.Parent do
			local v166 = os.clock()
			local v167 = math.clamp((v166 - v76) / 0.14, 0, 1)

			applyAlpha(v69, 1 - v167)

			if v167 >= 1 then
				break
			end

			task.wait()
		end
	end)
end
local function fadeOutAndDestroy(p7)
	local v78 = captureAlpha(p7)
	local v79 = p7.Position
	local tweenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

	tweenService:Create(p7, tweenInfo, { Position = v79 + UDim2.new(0, -16, 0, 0) }):Play()

	local v81 = os.clock()

	task.spawn(function()
		while p7.Parent do
			local v168 = os.clock()
			local v169 = math.clamp((v168 - v81) / 0.22, 0, 1)

			applyAlpha(v78, v169)

			if v169 >= 1 then
				break
			end

			task.wait()
		end

		if p7.Parent then
			p7:Destroy()
		end
	end)
end
local function headshotFlash(parent)
	local __HeadshotFlash: Frame = Instance.new("Frame")

	__HeadshotFlash.Name = "__HeadshotFlash"
	__HeadshotFlash.BorderSizePixel = 0
	__HeadshotFlash.BackgroundColor3 = Color3.new(1, 1, 1)
	__HeadshotFlash.BackgroundTransparency = 0
	__HeadshotFlash.Size = UDim2.fromScale(1, 1)
	__HeadshotFlash.Position = UDim2.fromScale(0, 0)
	__HeadshotFlash.AnchorPoint = Vector2.new(0, 0)
	__HeadshotFlash.ZIndex = parent.ZIndex + 10
	__HeadshotFlash.Parent = parent

	local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local v85: Tween = tweenService:Create(__HeadshotFlash, tweenInfo, { BackgroundTransparency = 1 })

	v85:Play()
	v85.Completed:Connect(function()
		if __HeadshotFlash.Parent then
			__HeadshotFlash:Destroy()
		end
	end)
end
local function killedFlash(p9)
	local foundChild = p9:FindFirstChild("TextLabel", true)

	if not foundChild then
		return
	end

	local __KillFlash: Frame = Instance.new("Frame")

	__KillFlash.Name = "__KillFlash"
	__KillFlash.BorderSizePixel = 0
	__KillFlash.BackgroundColor3 = Color3.new(1, 1, 1)
	__KillFlash.BackgroundTransparency = 0
	__KillFlash.Size = UDim2.fromScale(0.5, 1)
	__KillFlash.Position = UDim2.fromScale(0, 0)
	__KillFlash.AnchorPoint = Vector2.new(0, 0)
	__KillFlash.ZIndex = foundChild.ZIndex + 5
	__KillFlash.Parent = foundChild

	local uiGradient: UIGradient = Instance.new("UIGradient")

	uiGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
	uiGradient.Parent = __KillFlash

	local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local v91 = UDim2.fromScale(2, 1)
	local v92: Tween = tweenService:Create(__KillFlash, tweenInfo, { BackgroundTransparency = 1, Size = v91 })

	v92:Play()
	v92.Completed:Connect(function()
		if __KillFlash.Parent then
			__KillFlash:Destroy()
		end
	end)
end
local function setHeadshotImage(p10, image)
	local foundChild = p10:FindFirstChild("Headshot", true)

	if foundChild then
		foundChild.Image = image
		foundChild.ImageTransparency = 0
	end
end
local function setTypeRow(p12, p13, p14)
	local foundChild = p12:FindFirstChild("Icon", true)

	if foundChild then
		foundChild.Image = iconsKillTypes[p13]
	end

	local foundChild2 = p12:FindFirstChild("TextLabel", true)

	if foundChild2 then
		local v101 = t1[p13] or string.upper(p13)

		foundChild2.Text = ("[+%d XP] %s"):format(p14, v101)
	end
end

local t2: {[any]: any} = {}
local n2: number = -100000
local n3: number = -50000

local function allocKilledOrder()
	n2 -= 1

	return n2
end
local function allocTypeOrder()
	n3 -= 1

	return n3
end

local t3: {[any]: any} = {}

local function getStackForType(p15, p16)
	local v104 = t3[p15]

	if not v104 then
		return nil
	end

	if not v104.row.Parent then
		t3[p15] = nil

		return nil
	end

	if p16 >= v104.expiresAt then
		fadeOutAndDestroy(v104.row)
		t3[p15] = nil

		return nil
	end

	if p16 - n1 > 1.25 then
		return nil
	end

	return v104
end
local function ensureTypeStack(p17, p18, p19)
	local v108 = t3[p17]
	local v109

	if not v108 then
		v109 = nil
	elseif not v108.row.Parent then
		t3[p17] = nil
		v109 = nil
	elseif p18 >= v108.expiresAt then
		fadeOutAndDestroy(v108.row)
		t3[p17] = nil
		v109 = nil
	else
		v109 = if p18 - n1 > 1.25 then nil else v108
	end

	if v109 then
		v109.expiresAt = math.max(v109.expiresAt, p19)
		v109.lastAt = p18

		return v109
	end

	local clone = v17:Clone()

	clone.Name = "Stack_" .. p17
	clone.Visible = true
	clone.Parent = v14
	n3 -= 1
	clone.LayoutOrder = n3
	popIn(clone)
	v108 = {
		xpTotal = 0,
		typeId = p17,
		row = clone,
		lastAt = p18,
		expiresAt = p19
	}
	t3[p17] = v108
	setTypeRow(clone, p17, 0)

	return v108
end
local function absorbType(p20, p21, p22, p23)
	local v115 = ensureTypeStack(p20, p22, p23)

	v115.xpTotal = v115.xpTotal + p21
	v115.lastAt = p22
	v115.expiresAt = math.max(v115.expiresAt, p23)
	setTypeRow(v115.row, p20, v115.xpTotal)

	local row = v115.row
	local __uiScale = row:FindFirstChild("__UIScale")

	if not __uiScale or not __uiScale:IsA("UIScale") then
		__uiScale = Instance.new("UIScale")
		__uiScale.Name = "__UIScale"
		__uiScale.Scale = 1
		__uiScale.Parent = row
	end

	__uiScale.Scale = 1

	local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	v115 = tweenService:Create(__uiScale, tweenInfo, { Scale = 1.1 })

	local tweenInfo4 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local v120: Tween = tweenService:Create(__uiScale, tweenInfo4, { Scale = 1 })

	v115:Play()
	v115.Completed:Connect(function()
		if __uiScale.Parent then
			v120:Play()
		end
	end)
end
local function createGroup(p24, image)
	local v123 = os.clock()
	local v124 = os.clock()
	local t5: {[any]: any} = {
		headshotUi = nil,
		createdAt = v123,
		expiresAt = v124 + 4,
		killedRow = v16,
		typeRows = {}
	}
	local clone = v15:Clone()

	clone.Name = "Kill_" .. p24
	clone.Visible = true
	n2 -= 1
	clone.LayoutOrder = n2
	clone.Parent = v13

	local foundChild = clone:FindFirstChild("Headshot", true)

	if foundChild then
		foundChild.Image = image
		foundChild.ImageTransparency = 0
	end

	popIn(clone)
	headshotFlash(clone)
	t5.headshotUi = clone

	local clone2 = v16:Clone()

	clone2.Name = "Killed_" .. p24
	clone2.Visible = true
	n2 -= 1
	clone2.LayoutOrder = n2
	clone2.Parent = v14

	local foundChild3 = clone2:FindFirstChild("TextLabel", true)

	if foundChild3 then
		foundChild3.Text = ("KILLED %s"):format(p24)
	end

	popIn(clone2)
	killedFlash(clone2)
	t5.killedRow = clone2
	table.insert(t2, 1, t5)

	return t5
end
local function createNonStackTypeRow(p26, p27, p28)
	local clone = v17:Clone()

	clone.Name = ("Type_%s_%d"):format(p27, p28)
	clone.Visible = true
	clone.Parent = v14
	n3 -= 1
	clone.LayoutOrder = n3
	popIn(clone)
	setTypeRow(clone, p27, p28)
	table.insert(p26.typeRows, clone)
end
local function clearFeedImmediate()
	for i = #t2, 1, -1 do
		local v135 = t2[i]

		if v135.headshotUi and v135.headshotUi.Parent then
			v135.headshotUi:Destroy()
		end

		if v135.killedRow and v135.killedRow.Parent then
			v135.killedRow:Destroy()
		end

		for _, v in ipairs(v135.typeRows) do
			if v and v.Parent then
				v:Destroy()
			end
		end

		t2[i] = nil
	end

	for k, v in pairs(t3) do
		if v.row and v.row.Parent then
			v.row:Destroy()
		end

		t3[k] = nil
	end

	n2 = -100000
	n3 = -50000
	n1 = 0
end

local u39 = nil
local viewedPlayerGetSpecTargetUserId = viewedPlayer.GetSpecTargetUserId

LocalPlayer:GetAttributeChangedSignal("Spectating"):Connect(function()
	local v140 = viewedPlayerGetSpecTargetUserId()

	if v140 ~= nil and v140 ~= u39 then
		clearFeedImmediate()
	end

	u39 = v140
end)
task.spawn(function()
	while true do
		task.wait(0.1)

		local v141 = os.clock()

		for i = #t2, 1, -1 do
			local v143 = t2[i]

			if v141 >= v143.expiresAt then
				table.remove(t2, i)

				if v143.headshotUi and v143.headshotUi.Parent then
					fadeOutAndDestroy(v143.headshotUi)
				end

				if v143.killedRow and v143.killedRow.Parent then
					fadeOutAndDestroy(v143.killedRow)
				end

				for _, v in ipairs(v143.typeRows) do
					if v.Parent then
						fadeOutAndDestroy(v)
					end
				end
			end
		end

		for k, v in pairs(t3) do
			if v141 >= v.expiresAt or not v.row.Parent then
				if v.row and v.row.Parent then
					fadeOutAndDestroy(v.row)
				end

				t3[k] = nil
			end
		end

		continue
	end
end)

local function applyKillEvent(p29, p30, p31)
	local v151 = createGroup(p29, p30)
	local v152 = os.clock()

	n1 = v152

	for _, v in ipairs(p31) do
		absorbType(v.id, v.xp, v152, v151.expiresAt)
	end
end
local function handleKillFeed(p32)
	if typeof(p32) ~= "table" then
		return
	end

	if p32.killer then
		return
	end

	local victim = p32.victim
	local t6 = p32.types

	if typeof(victim) == "table" and typeof(victim.kind) == "string" and typeof(victim.name) == "string" then
		if typeof(t6) ~= "table" then
			t6 = {}
		end

		local victimName = victim.name
		local v159

		if victim.kind == "Player" and typeof(victim.userId) == "number" then
			v159 = ("rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420"):format(victim.userId)
		else
			v159 = typeof(victim.image) == "string" and victim.image or "rbxassetid://18520238127"
		end

		local t7: {[any]: any} = {}

		for _, v in ipairs(t6) do
			if typeof(v) == "table" and typeof(v.id) == "string" and typeof(v.xp) == "number" then
				local vId = v.id
				local floored = math.floor(v.xp + 0.5)

				table.insert(t7, { id = vId, xp = floored })
			end
		end

		if #t7 == 0 then
			t7 = { { id = "Kill", xp = 50 } }
		end

		applyKillEvent(victimName, v159, t7)

		return
	end
end

killFeed_Push.OnClientEvent:Connect(handleKillFeed)

local bindables: Instance = replicatedStorage:FindFirstChild("Bindables")

bindables = bindables and bindables:FindFirstChild("ReplayKillFeed")

if bindables and bindables:IsA("BindableEvent") then
	bindables.Event:Connect(handleKillFeed)
end
