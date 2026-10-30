-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local tweenService: TweenService = game:GetService("TweenService")
local runService: RunService = game:GetService("RunService")

game:GetService("Lighting")

local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local windowBlur = require(shared:WaitForChild("WindowBlur"))
local sound = require(replicatedStorage:WaitForChild("Sound"))
local LocalPlayer: Player = players.LocalPlayer
local scriptParent: Instance = script.Parent
local ParentParent: Instance = scriptParent.Parent.Parent
local spinner: Instance = ParentParent.Parent:WaitForChild("Spinner")
local activeWindowChanged: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Bindables"):WaitForChild("ActiveWindowChanged")
local shopOpenAnalytics: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("ShopOpenAnalytics")
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

local tweenInfo3 = TweenInfo.new(0.1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
local tweenInfo4 = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local tweenInfo5 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo6 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local t1: {[any]: any} = {
	Abilities = "UI.ClickAbilities",
	Inventory = "UI.ClickInventory",
	Shop = "UI.ClickShop"
}
local t2: {[any]: any} = {}
local u22 = nil
local t3: {[any]: any} = {}

local function ensureUIScale(parent)
	local uiScale = parent:FindFirstChildWhichIsA("UIScale")

	if uiScale then
		return uiScale, false
	end

	local uiScale2: UIScale = Instance.new("UIScale")

	uiScale2.Scale = 1
	uiScale2.Parent = parent

	return uiScale2, true
end
local function wireHover(parent)
	local uiScale = parent:FindFirstChildWhichIsA("UIScale")
	local v74

	if uiScale then
		v74 = uiScale
	else
		local uiScale3: UIScale = Instance.new("UIScale")

		uiScale3.Scale = 1
		uiScale3.Parent = parent
		v74 = uiScale3
	end

	local u76 = nil
	local anchorPoint = parent.AnchorPoint
	local parentPosition = parent.Position
	local uDim2New = UDim2.new
	local n1 = parentPosition.X.Scale + (0.5 - anchorPoint.X) * parent.Size.X.Scale
	local offset = parentPosition.X.Offset
	local rounded = math.round((0.5 - anchorPoint.X) * parent.Size.X.Offset)
	local n2 = parentPosition.Y.Scale + (0.5 - anchorPoint.Y) * parent.Size.Y.Scale
	local v84 = parentPosition.Y.Offset
	local rounded2 = math.round((0.5 - anchorPoint.Y) * parent.Size.Y.Offset)
	local uDim2 = uDim2New(n1, offset + rounded, n2, v84 + rounded2)

	parent.AnchorPoint = Vector2.new(0.5, 0.5)
	parent.Position = uDim2
	parent.MouseEnter:Connect(function()
		if u76 then
			u76:Cancel()
		end

		u76 = tweenService:Create(v74, tweenInfo5, { Scale = 1.15 })
		u76:Play()
	end)
	parent.MouseLeave:Connect(function()
		if u76 then
			u76:Cancel()
		end

		u76 = tweenService:Create(v74, tweenInfo6, { Scale = 1 })
		u76:Play()
	end)
end
local function bubblePop(parent, p4, p5)
	local uiScale = parent:FindFirstChildWhichIsA("UIScale")
	local v91

	if uiScale then
		v91 = uiScale
	else
		local uiScale4: UIScale = Instance.new("UIScale")

		uiScale4.Scale = 1
		uiScale4.Parent = parent
		v91 = uiScale4
	end

	local v93: Tween = tweenService:Create(v91, tweenInfo3, { Scale = v91.Scale * 0.8 })

	v93:Play()
	v93.Completed:Once(function()
		if p4 then
			p4()
		end

		local v197: Tween = tweenService:Create(v91, tweenInfo4, { Scale = 1 })

		v197:Play()
		v197.Completed:Once(function()
			if p5 then
				p5()
			end
		end)
	end)
end
local function isInMatch()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")

	if typeof(matchId) == "string" and matchId ~= "" then
		return true
	end

	local spectating: any = LocalPlayer:GetAttribute("Spectating")

	if typeof(spectating) == "number" and spectating ~= 0 then
		return true
	end

	return false
end
local function cancelTween(p6)
	local v97 = t3[p6]

	if v97 then
		v97:Cancel()
		t3[p6] = nil
	end
end
local function showBlur()
	windowBlur.show("LobbyPanel")
end
local function hideBlur()
	windowBlur.hide("LobbyPanel")
end
local function openWindowTween(p7, p8)
	local v100 = t3[p7]

	if v100 then
		v100:Cancel()
		t3[p7] = nil
	end

	p7.Position = p8.closedPos
	p7.Visible = true

	local v101: Tween = tweenService:Create(p7, tweenInfo, { Position = p8.openPos })

	t3[p7] = v101
	v101:Play()
	v101.Completed:Once(function()
		if t3[p7] == v101 then
			t3[p7] = nil
		end
	end)
	windowBlur.show("LobbyPanel")
	activeWindowChanged:Fire("LobbyPanel")
end
local function closeWindowTween(p9, p10)
	local v104 = t3[p9]

	if v104 then
		v104:Cancel()
		t3[p9] = nil
	end

	local v105: Tween = tweenService:Create(p9, tweenInfo2, { Position = p10.closedPos })

	t3[p9] = v105
	v105:Play()
	v105.Completed:Once(function()
		if t3[p9] == v105 then
			t3[p9] = nil
			p9.Visible = false
		end
	end)
	windowBlur.hide("LobbyPanel")
end
local function findPairByWindow(p11)
	for _, v in ipairs(t2) do
		if p11 == v.window then
			return v
		end
	end

	return nil
end
local function closeWindow(p12)
	local v110, v111, v112 = ipairs(t2)
	local v113: boolean = false
	local v114

	for iterFirst, iterSecond in v110, v111, v112 do
		if p12 == iterSecond.window then
			v114 = iterSecond
			v113 = true

			break
		end
	end

	if not v113 then
		v114 = nil
	end

	if v114 then
		closeWindowTween(p12, v114)
	else
		p12.Visible = false
		windowBlur.hide("LobbyPanel")
	end

	if p12 == u22 then
		u22 = nil
	end
end
local function closeAll()
	for _, v in ipairs(t2) do
		local vWindow = v.window
		local v120 = t3[vWindow]

		if v120 then
			v120:Cancel()
			t3[vWindow] = nil
		end

		v.window.Visible = false
		v.window.Position = v.closedPos
	end

	u22 = nil
	windowBlur.clear()
end
local function shouldHidePair(_)
	local matchId: any = LocalPlayer:GetAttribute("MatchId")

	if typeof(matchId) == "string" and matchId ~= "" then
		return true
	end

	local spectating: any = LocalPlayer:GetAttribute("Spectating")

	if typeof(spectating) == "number" and spectating ~= 0 then
		return true
	end

	return false
end
local function applyVisibilityRules()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")
	local u125

	if typeof(matchId) == "string" and matchId ~= "" then
		u125 = true
	else
		local spectating: any = LocalPlayer:GetAttribute("Spectating")

		u125 = typeof(spectating) == "number" and spectating ~= 0
	end

	scriptParent.Parent.Visible = not u125
	scriptParent.Parent.BG.Visible = not u125

	for _, v in ipairs(t2) do
		local matchId2: any = LocalPlayer:GetAttribute("MatchId")
		local u130

		if typeof(matchId2) == "string" and matchId2 ~= "" then
			u130 = true
		else
			local spectating: any = LocalPlayer:GetAttribute("Spectating")

			u130 = typeof(spectating) == "number" and spectating ~= 0
		end

		v.button.Visible = not u130

		if u130 then
			local vWindow = v.window
			local v133 = t3[vWindow]

			if v133 then
				v133:Cancel()
				t3[vWindow] = nil
			end

			v.window.Visible = false
			v.window.Position = v.closedPos

			if u22 == v.window then
				u22 = nil
			end
		end
	end

	if not u22 then
		if blurTween then
			blurTween:Cancel()
			blurTween = nil
		end

		if activeBlur then
			activeBlur:Destroy()
			activeBlur = nil
		end
	end
end
local function wirePair(p14, p15, p16)
	local v137 = p15.Position
	local uDim2 = UDim2.new(v137.X.Scale, v137.X.Offset, v137.Y.Scale + 1, v137.Y.Offset)

	p15.Visible = false
	p15.Position = uDim2

	local t4: {[any]: any} = {
		button = p14,
		window = p15,
		base = p16,
		openPos = v137,
		closedPos = uDim2
	}

	p14.MouseButton1Click:Connect(function()
		if p14:GetAttribute("Locked") then
			return
		end

		if LocalPlayer:GetAttribute("DailyGiftsOpen") then
			return
		end

		applyVisibilityRules()

		if not p14.Visible then
			return
		end

		if spinner.Enabled then
			return
		end

		local v198 = t1[p16]

		if v198 then
			pcall(function()
				sound:Play(v198, workspace)
			end)
		end

		sound:Play("UI.Click", workspace)

		if u22 and u22 ~= p15 then
			local v199 = u22
			local v200, v201, v202 = ipairs(t2)
			local v203: boolean = false
			local v204

			for iterFirst, iterSecond in v200, v201, v202 do
				if v199 == iterSecond.window then
					v204 = iterSecond
					v203 = true

					break
				end
			end

			if not v203 then
				v204 = nil
			end

			if v204 then
				closeWindowTween(v199, v204)
			else
				v199.Visible = false
				windowBlur.hide("LobbyPanel")
			end

			if v199 == u22 then
				u22 = nil
			end
		end

		if p15.Visible and u22 == p15 then
			closeWindowTween(p15, t4)
			u22 = nil

			return
		end

		u22 = p15
		openWindowTween(p15, t4)

		if p16 == "Shop" then
			shopOpenAnalytics:FireServer("LobbyButton")
		end
	end)

	local trueFrame = p15:FindFirstChild("TrueFrame")
	local u141 = trueFrame

	if u141 then
		u141 = trueFrame:FindFirstChild("CloseBtn")
	end

	if not u141 then
		u141 = p15:FindFirstChild("CloseBtn") or p15:FindFirstChild("CloseButton")
	end

	if u141 and u141:IsA("ImageButton") then
		wireHover(u141)
		u141.MouseButton1Click:Connect(function()
			if p15.Visible and u22 == p15 then
				bubblePop(u141, function()
					closeWindowTween(p15, t4)
					u22 = nil
				end, nil)
			end
		end)
	end

	p15:GetPropertyChangedSignal("Visible"):Connect(function()
		if not p15.Visible and u22 == p15 then
			u22 = nil
			windowBlur.hide("LobbyPanel")
		end
	end)
	table.insert(t2, t4)
end

for _, v in ipairs(scriptParent:GetChildren()) do
	if v:IsA("GuiButton") then
		local replacedText = v.Name:gsub("Button$", "")

		if replacedText ~= v.Name then
			local foundChild: Instance = ParentParent:FindFirstChild(replacedText .. "Window")

			if foundChild and foundChild:IsA("GuiObject") then
				wirePair(v, foundChild, replacedText)
			end
		end
	end
end

closeAll()
applyVisibilityRules()

local u43 = nil

LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(function()
	closeAll()
	applyVisibilityRules()

	if u43 then
		u43()
	end
end)
LocalPlayer:GetAttributeChangedSignal("Spectating"):Connect(function()
	closeAll()
	applyVisibilityRules()

	if u43 then
		u43()
	end
end)

local bindables: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Bindables")

bindables:WaitForChild("OpenShop").Event:Connect(function()
	if LocalPlayer:GetAttribute("DailyGiftsOpen") then
		return
	end

	local shopWindow: Instance = ParentParent:FindFirstChild("ShopWindow")

	if not shopWindow or not shopWindow:IsA("GuiObject") then
		return
	end

	local v143 = nil

	for _, v in ipairs(t2) do
		if shopWindow == v.window then
			v143 = v

			break
		end
	end

	if not v143 then
		return
	end

	if u22 and shopWindow ~= u22 then
		local v146 = u22
		local v147, v148, v149 = ipairs(t2)
		local v150: boolean = false
		local v151

		for iterFirst, iterSecond in v147, v148, v149 do
			if v146 == iterSecond.window then
				v151 = iterSecond
				v150 = true

				break
			end
		end

		if not v150 then
			v151 = nil
		end

		if v151 then
			closeWindowTween(v146, v151)
		else
			v146.Visible = false
			windowBlur.hide("LobbyPanel")
		end

		if v146 == u22 then
			u22 = nil
		end
	end

	if not shopWindow.Visible or shopWindow ~= u22 then
		openWindowTween(shopWindow, v143)
		u22 = shopWindow
	end
end)

local openLobbyWindow: Instance = bindables:FindFirstChild("OpenLobbyWindow")

if openLobbyWindow and openLobbyWindow:IsA("BindableEvent") then
	openLobbyWindow.Event:Connect(function(p17)
		if typeof(p17) == "string" then
			if LocalPlayer:GetAttribute("DailyGiftsOpen") then
			elseif not spinner.Enabled then
				local matchId: any = LocalPlayer:GetAttribute("MatchId")
				local u156

				if typeof(matchId) == "string" and matchId ~= "" then
					u156 = true
				else
					local spectating: any = LocalPlayer:GetAttribute("Spectating")

					u156 = typeof(spectating) == "number" and spectating ~= 0
				end

				if u156 then
					return
				end

				local foundChild: Instance = ParentParent:FindFirstChild(p17 .. "Window")

				if not foundChild or not foundChild:IsA("GuiObject") then
					return
				end

				local v159, v160, v161 = ipairs(t2)
				local v162: boolean = false
				local v163

				for iterFirst, iterSecond in v159, v160, v161 do
					if foundChild == iterSecond.window then
						v163 = iterSecond
						v162 = true

						break
					end
				end

				if not v162 then
					v163 = nil
				end

				if not v163 or not v163.button.Visible then
					return
				end

				if u22 and foundChild ~= u22 then
					local v166 = u22
					local v167, v168, v169 = ipairs(t2)
					local v170: boolean = false
					local v171

					for iterFirst2, iterSecond2 in v167, v168, v169 do
						if v166 == iterSecond2.window then
							v171 = iterSecond2
							v170 = true

							break
						end
					end

					if not v170 then
						v171 = nil
					end

					if v171 then
						closeWindowTween(v166, v171)
					else
						v166.Visible = false
						windowBlur.hide("LobbyPanel")
					end

					if v166 == u22 then
						u22 = nil
					end
				end

				if not foundChild.Visible or foundChild ~= u22 then
					u22 = foundChild
					openWindowTween(foundChild, v163)
				end

				return
			end

			return
		end
	end)
end

activeWindowChanged.Event:Connect(function(p18)
	if p18 ~= "LobbyPanel" and u22 then
		local v175 = u22
		local v176, v177, v178 = ipairs(t2)
		local v179: boolean = false
		local v180

		for iterFirst, iterSecond in v176, v177, v178 do
			if v175 == iterSecond.window then
				v180 = iterSecond
				v179 = true

				break
			end
		end

		if not v179 then
			v180 = nil
		end

		if v180 then
			closeWindowTween(v175, v180)
		else
			v175.Visible = false
			windowBlur.hide("LobbyPanel")
		end

		if v175 == u22 then
			u22 = nil
		end

		u22 = nil
	end
end)

local abilitiesButton: Instance = scriptParent:FindFirstChild("AbilitiesButton")

if abilitiesButton then
	local imageLabel: Instance = abilitiesButton:FindFirstChild("ImageLabel")
	local textLabel: Instance = abilitiesButton:FindFirstChild("TextLabel")
	local hint: Instance = abilitiesButton:FindFirstChild("Hint")
	local hintTextLabel: Instance = hint and hint:FindFirstChild("TextLabel")
	local v51 = imageLabel and imageLabel.ImageColor3 or Color3.new(1, 1, 1)
	local v52 = textLabel and textLabel.TextColor3 or Color3.new(1, 1, 1)
	local color3 = Color3.fromRGB(17, 17, 17)
	local u54: boolean = false
	local connection = nil
	local v56 = hint and hint.Position or nil

	local function startFloatAnim()
		if connection then
			connection:Disconnect()
		end

		if not hint then
			return
		end

		local v183 = v56 or hint.Position

		connection = runService.Heartbeat:Connect(function()
			if not hint or not hint.Parent then
				if connection then
					connection:Disconnect()
					connection = nil
				end

				return
			end

			local v207 = os.clock()
			local sine = math.sin(v207 * 3.141592653589793)

			hint.Position = UDim2.new(v183.X.Scale, v183.X.Offset, v183.Y.Scale + (sine * 0.02 + 0.01), v183.Y.Offset)
		end)
	end
	local function stopFloatAnim()
		if connection then
			connection:Disconnect()
			connection = nil
		end
	end
	local function updateAbilitiesLock()
		local tutorialPhase: any = LocalPlayer:GetAttribute("TutorialPhase")
		local u185: boolean = false

		if typeof(tutorialPhase) == "number" then
			u185 = tutorialPhase > 0
		end

		if u185 and tutorialPhase < 2 then
			u54 = true

			if imageLabel then
				imageLabel.ImageColor3 = color3
			end

			if textLabel then
				textLabel.TextColor3 = color3
			end

			local visible: boolean = LocalPlayer:GetAttribute("MMQueued") == true

			if hint then
				hint.Visible = visible

				if hintTextLabel then
					hintTextLabel.Text = "Play a match to unlock!"
				end
			end

			if visible then
				if connection then
					connection:Disconnect()
				end

				if hint then
					local v187 = v56 or hint.Position

					connection = runService.Heartbeat:Connect(function()
						if not hint or not hint.Parent then
							if connection then
								connection:Disconnect()
								connection = nil
							end

							return
						end

						local v209 = os.clock()
						local sine = math.sin(v209 * 3.141592653589793)

						hint.Position = UDim2.new(v187.X.Scale, v187.X.Offset, v187.Y.Scale + (sine * 0.02 + 0.01), v187.Y.Offset)
					end)
				end
			elseif connection then
				connection:Disconnect()
				connection = nil
			end
		elseif u185 and tutorialPhase == 2 then
			u54 = false

			if imageLabel then
				imageLabel.ImageColor3 = v51
			end

			if textLabel then
				textLabel.TextColor3 = v52
			end

			if hint then
				hint.Visible = false
			end

			if connection then
				connection:Disconnect()
			end

			if hint then
				local v188 = v56 or hint.Position

				connection = runService.Heartbeat:Connect(function()
					if not hint or not hint.Parent then
						if connection then
							connection:Disconnect()
							connection = nil
						end

						return
					end

					local v211 = os.clock()
					local sine = math.sin(v211 * 3.141592653589793)

					hint.Position = UDim2.new(v188.X.Scale, v188.X.Offset, v188.Y.Scale + (sine * 0.02 + 0.01), v188.Y.Offset)
				end)
			end
		else
			u54 = false

			if imageLabel then
				imageLabel.ImageColor3 = v51
			end

			if textLabel then
				textLabel.TextColor3 = v52
			end

			local matchId: any = LocalPlayer:GetAttribute("MatchId")
			local u190

			if typeof(matchId) == "string" and matchId ~= "" then
				u190 = true
			else
				local spectating: any = LocalPlayer:GetAttribute("Spectating")

				u190 = typeof(spectating) == "number" and spectating ~= 0
			end

			local u192: boolean = not u190

			if u192 then
				u192 = LocalPlayer:GetAttribute("ShowSkillsBubble") == true
			end

			if not hint then
				if connection then
					connection:Disconnect()
					connection = nil
				end
			elseif u192 then
				if hintTextLabel then
					hintTextLabel.Text = "New skills available!"
				end

				hint.Visible = true

				if connection then
					connection:Disconnect()
				end

				if hint then
					local v193 = v56 or hint.Position

					connection = runService.Heartbeat:Connect(function()
						if not hint or not hint.Parent then
							if connection then
								connection:Disconnect()
								connection = nil
							end

							return
						end

						local v213 = os.clock()
						local sine = math.sin(v213 * 3.141592653589793)

						hint.Position = UDim2.new(v193.X.Scale, v193.X.Offset, v193.Y.Scale + (sine * 0.02 + 0.01), v193.Y.Offset)
					end)
				end
			else
				hint.Visible = false

				if connection then
					connection:Disconnect()
					connection = nil
				end
			end
		end

		abilitiesButton:SetAttribute("Locked", u54)
	end

	LocalPlayer:GetAttributeChangedSignal("TutorialPhase"):Connect(updateAbilitiesLock)
	LocalPlayer:GetAttributeChangedSignal("MMQueued"):Connect(updateAbilitiesLock)
	LocalPlayer:GetAttributeChangedSignal("ShowSkillsBubble"):Connect(updateAbilitiesLock)
	u43 = updateAbilitiesLock
	updateAbilitiesLock()
end

local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local tradingPlazaGate = require(replicatedStorageShared:WaitForChild("TradingPlazaGate"))
local tradeButton: Instance = scriptParent:FindFirstChild("TradeButton")

if tradeButton then
	local gameFlags: Instance = replicatedStorage:WaitForChild("Shared"):WaitForChild("GameFlags")
	local v64 = tradingPlazaGate.IsTradingPlaza()

	if v64 then
		v64 = gameFlags:GetAttribute("TradingEnabled") == true
	end

	tradeButton.Visible = v64
	gameFlags:GetAttributeChangedSignal("TradingEnabled"):Connect(function()
		local v194 = tradingPlazaGate.IsTradingPlaza()

		if v194 then
			v194 = gameFlags:GetAttribute("TradingEnabled") == true
		end

		tradeButton.Visible = v194
	end)
	tradeButton.MouseButton1Click:Connect(function()
		if tradeButton:GetAttribute("Locked") then
		elseif LocalPlayer:GetAttribute("DailyGiftsOpen") then
		elseif spinner.Enabled then
		elseif not tradingPlazaGate.IsTradingPlaza() then
		elseif gameFlags:GetAttribute("TradingEnabled") == true then
			sound:Play("UI.Click", workspace)

			local _GToggleTradePlayerList = _G.ToggleTradePlayerList

			if typeof(_GToggleTradePlayerList) == "function" then
				_GToggleTradePlayerList()

				return
			end

			local _GOpenTradePlayerList = _G.OpenTradePlayerList

			if typeof(_GOpenTradePlayerList) == "function" then
				_GOpenTradePlayerList()
			end

			return
		end
	end)
end

local seasonPassButton: Instance = scriptParent:FindFirstChild("SeasonPassButton")

if seasonPassButton then
	local v66: Instance = replicatedStorage:WaitForChild("Shared")
	local seasonPassGate = require(v66:WaitForChild("SeasonPassGate"))
	local toggleSeasonPass: Instance = bindables:WaitForChild("ToggleSeasonPass")

	seasonPassButton.Visible = seasonPassGate.IsEnabled()
	seasonPassGate.Changed():Connect(function()
		seasonPassButton.Visible = seasonPassGate.IsEnabled()
	end)
	seasonPassButton.MouseButton1Click:Connect(function()
		if seasonPassButton:GetAttribute("Locked") then
			return
		end

		if LocalPlayer:GetAttribute("DailyGiftsOpen") then
			return
		end

		if spinner.Enabled then
			return
		end

		if not seasonPassGate.IsEnabled() then
			return
		end

		sound:Play("UI.Click", workspace)
		toggleSeasonPass:Fire()
	end)
end
