-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")

game:GetService("SoundService")

local tweenService: TweenService = game:GetService("TweenService")
local playerGui: Instance = players.LocalPlayer:WaitForChild("PlayerGui")
local uiClick: Sound = Instance.new("Sound")

uiClick.Name = "UIClick"
uiClick.SoundId = "rbxassetid://6042053626"
uiClick.Volume = 1
uiClick.Parent = workspace

local uiHover: Sound = Instance.new("Sound")

uiHover.Name = "UIHover"
uiHover.SoundId = "rbxassetid://138699902284184"
uiHover.Volume = 4
uiHover.Parent = workspace

local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo3 = TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo4 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local t1: {[any]: any} = {}
local t2: {[any]: any} = {}
local t3: {[any]: any} = {}

local function getScreenGui(p1)
	local v24 = p1

	while v24 do
		if v24:IsA("ScreenGui") then
			return v24
		end

		v24 = v24.Parent
	end

	return nil
end
local function onScreenGuiDisabled(p2)
	for k, v in pairs(t2) do
		if k:IsDescendantOf(p2) then
			v.cancelTween()
			v.resetHovered()

			if v.uiScale then
				v.uiScale.Scale = 1
			end
		end
	end
end
local function ensureScreenGuiListener(p3)
	local v29 = p3

	while v29 do
		if v29:IsA("ScreenGui") then
			local v30 = v29

			break
		end

		v29 = v29.Parent
	end

	if not v29 then
		v30 = nil
	end

	if v30 and not t3[v30] then
		t3[v30] = true
		v30:GetPropertyChangedSignal("Enabled"):Connect(function()
			if not v30.Enabled then
				onScreenGuiDisabled(v30)
			end
		end)

		return
	end
end

local t4: {[any]: any} = {
	"LobbyButtons",
	"Leaderboard",
	"TouchGui",
	"MobileWeaponHUD",
	"MobilePersistentHUD",
	"EditPreview_Persistent",
	"EditPreview_Weapon",
	"ChangeAbilities",
	"Backdrop",
	"PurchaseModalBackdrop",
	"DisabledFrame"
}
local t5: {[any]: any} = { "CharacterRow", "GunRow", "KnifeRow" }
local collectionService: CollectionService = game:GetService("CollectionService")

local function isEffectBlacklisted(p4)
	local v32 = p4

	if v32:IsA("GuiButton") and v32.Active == false then
		return true
	end

	while v32 and v32 ~= playerGui do
		if collectionService:HasTag(v32, "BlacklistHover") then
			return true
		end

		for _, v in ipairs(t4) do
			if v == v32.Name then
				return true
			end
		end

		v32 = v32.Parent
	end

	return false
end
local function isEffectWhitelisted(p5)
	local v36 = p5

	while v36 and v36 ~= playerGui do
		for _, v in ipairs(t5) do
			if v == v36.Name then
				return true
			end
		end

		v36 = v36.Parent
	end

	return false
end
local function connectButton(p6)
	if t1[p6] then
		return
	end

	t1[p6] = true

	local function u40()
		if isEffectBlacklisted(p6) and not isEffectWhitelisted(p6) then
			return
		end

		uiClick:Play()
	end

	p6.MouseButton1Click:Connect(u40)

	local uiScale = nil
	local u42 = nil

	u40 = false

	local function effectEnabled()
		return not isEffectBlacklisted(p6)
	end
	local function ensureScale()
		if not uiScale then
			uiScale = p6:FindFirstChildOfClass("UIScale")

			if not uiScale then
				uiScale = Instance.new("UIScale")
				uiScale.Scale = 1
				uiScale.Parent = p6
			end
		end
	end
	local function tweenTo(p7, p8)
		if not uiScale then
			return
		end

		if u42 then
			u42:Cancel()
		end

		u42 = tweenService:Create(uiScale, p7, { Scale = p8 })
		u42:Play()
	end

	t2[p6] = {
		uiScale = nil,
		cancelTween = function()
			if u42 then
				u42:Cancel()
				u42 = nil
			end
		end,
		resetHovered = function()
			u40 = false
		end
	}
	ensureScreenGuiListener(p6)
	p6.MouseEnter:Connect(function()
		if not not isEffectBlacklisted(p6) then
			return
		end

		u40 = true
		uiHover:Play()

		if not uiScale then
			uiScale = p6:FindFirstChildOfClass("UIScale")

			if not uiScale then
				uiScale = Instance.new("UIScale")
				uiScale.Scale = 1
				uiScale.Parent = p6
			end
		end

		t2[p6].uiScale = uiScale
		tweenTo(tweenInfo, 1.05)
	end)
	p6.MouseLeave:Connect(function()
		local v67 = u40

		u40 = false

		if not v67 or not uiScale then
			return
		end

		tweenTo(tweenInfo2, 1)
	end)
	p6.MouseButton1Down:Connect(function()
		if not not isEffectBlacklisted(p6) then
			return
		end

		if not uiScale then
			uiScale = p6:FindFirstChildOfClass("UIScale")

			if not uiScale then
				uiScale = Instance.new("UIScale")
				uiScale.Scale = 1
				uiScale.Parent = p6
			end
		end

		t2[p6].uiScale = uiScale
		tweenTo(tweenInfo3, 0.925)
	end)
	p6.MouseButton1Up:Connect(function()
		if not not isEffectBlacklisted(p6) or not uiScale then
			return
		end

		tweenTo(tweenInfo4, if u40 then 1.05 else 1)
	end)
end
local function connectSelectProxy(p9)
	if p9:IsA("ImageButton") and p9.Name == "CLICK" then
		local v47 = p9.Parent

		if not v47 or not v47:IsA("GuiObject") then
			return
		end

		if t1[v47] then
			return
		end

		t1[v47] = true

		local function effectEnabled()
			return not isEffectBlacklisted(p9)
		end

		local anchorPoint = v47.AnchorPoint
		local v50 = v47.Position

		v47.AnchorPoint = Vector2.new(0.5, 0.5)

		local uDim2New = UDim2.new
		local n1 = v50.X.Scale + (0.5 - anchorPoint.X) * v47.Size.X.Scale
		local offset = v50.X.Offset
		local rounded = math.round((0.5 - anchorPoint.X) * v47.Size.X.Offset)
		local n2 = v50.Y.Scale + (0.5 - anchorPoint.Y) * v47.Size.Y.Scale
		local v56 = v50.Y.Offset
		local rounded2 = math.round((0.5 - anchorPoint.Y) * v47.Size.Y.Offset)

		v47.Position = uDim2New(n1, offset + rounded, n2, v56 + rounded2)
		p9.AnchorPoint = Vector2.new(0.5, 0.5)
		p9.Position = UDim2.fromScale(0.5, 0.5)

		local uiScale = nil
		local u59 = nil
		local u60: boolean = false

		v50 = function()
			if not uiScale then
				uiScale = v47:FindFirstChildOfClass("UIScale")

				if not uiScale then
					uiScale = Instance.new("UIScale")
					uiScale.Scale = 1
					uiScale.Parent = v47
				end
			end
		end

		local function tweenTo(p10, p11)
			if not uiScale then
				return
			end

			if u59 then
				u59:Cancel()
			end

			u59 = tweenService:Create(uiScale, p10, { Scale = p11 })
			u59:Play()
		end

		t2[v47] = {
			uiScale = nil,
			cancelTween = function()
				if u59 then
					u59:Cancel()
					u59 = nil
				end
			end,
			resetHovered = function()
				u60 = false
			end
		}
		ensureScreenGuiListener(p9)
		p9.MouseEnter:Connect(function()
			if not not isEffectBlacklisted(p9) then
				return
			end

			u60 = true
			uiHover:Play()

			if not uiScale then
				uiScale = v47:FindFirstChildOfClass("UIScale")

				if not uiScale then
					uiScale = Instance.new("UIScale")
					uiScale.Scale = 1
					uiScale.Parent = v47
				end
			end

			t2[v47].uiScale = uiScale
			tweenTo(tweenInfo, 1.05)
		end)
		p9.MouseLeave:Connect(function()
			local v70: boolean = u60

			u60 = false

			if not v70 or not uiScale then
				return
			end

			tweenTo(tweenInfo2, 1)
		end)
		p9.MouseButton1Down:Connect(function()
			if not not isEffectBlacklisted(p9) then
				return
			end

			if not uiScale then
				uiScale = v47:FindFirstChildOfClass("UIScale")

				if not uiScale then
					uiScale = Instance.new("UIScale")
					uiScale.Scale = 1
					uiScale.Parent = v47
				end
			end

			t2[v47].uiScale = uiScale
			tweenTo(tweenInfo3, 0.925)
		end)
		p9.MouseButton1Up:Connect(function()
			if not not isEffectBlacklisted(p9) or not uiScale then
				return
			end

			tweenTo(tweenInfo4, if u60 then 1.05 else 1)
		end)

		return
	end
end

playerGui.DescendantAdded:Connect(function(p12: Instance)
	if p12:IsA("GuiButton") then
		connectButton(p12)
		connectSelectProxy(p12)
	end
end)
task.spawn(function()
	for _, v in ipairs(playerGui:GetDescendants()) do
		if v:IsA("GuiButton") then
			connectButton(v)
			connectSelectProxy(v)
		end
	end
end)
