-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local tweenService: TweenService = game:GetService("TweenService")
local userInputService: UserInputService = game:GetService("UserInputService")
local extensions = game.ReplicatedStorage:WaitForChild("Extensions")
local gamepadBindings = require(extensions:WaitForChild("GamepadBindings"))
local replicatedStorageExtensions = game.ReplicatedStorage:WaitForChild("Extensions")
local inputMap = require(replicatedStorageExtensions:WaitForChild("InputMap"))
local LocalPlayer: Player = players.LocalPlayer
local matchRemotes: Instance = replicatedStorage:WaitForChild("MatchRemotes")
local v11: Instance = matchRemotes:WaitForChild("State")
local winScreenDismiss: Instance = matchRemotes:WaitForChild("WinScreenDismiss")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local winScreenCutscene = require(shared:WaitForChild("WinScreenCutscene"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local actionButtonTheme = require(replicatedStorageShared:WaitForChild("ActionButtonTheme"))
local uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))
local v18: Instance = replicatedStorage:WaitForChild("Shared")
local hoverInfoModule = require(v18:WaitForChild("HoverInfoModule"))
local sound = require(replicatedStorage:WaitForChild("Sound"))
local v21: Instance = replicatedStorage:WaitForChild("Shared")
local screenWipe = require(v21:WaitForChild("ScreenWipe"))
local ParentParent: Instance = script.Parent.Parent
local scriptParent: Instance = script.Parent
local bg: Instance = scriptParent:WaitForChild("BG")
local win: Instance = bg:WaitForChild("WIN")
local returnButton: Instance = ParentParent:WaitForChild("ReturnButton")
local u28 = nil

local function isReservedWin()
	local matchmakingShared: Instance = replicatedStorage:FindFirstChild("MatchmakingShared")
	local isReservedServer: Instance = matchmakingShared and matchmakingShared:FindFirstChild("IsReservedServer")

	return isReservedServer ~= nil and isReservedServer.Value == true
end
local function isTutorialMatchServer()
	local matchmakingShared: Instance = replicatedStorage:FindFirstChild("MatchmakingShared")

	return matchmakingShared ~= nil and matchmakingShared:GetAttribute("MMTutorialMatch") == true
end
local function getMMBridge()
	local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local matchmaking: Instance = playerGui and playerGui:FindFirstChild("Matchmaking")
	local v77: Instance = matchmaking

	if v77 then
		v77 = matchmaking:FindFirstChild("PostMatchIntent")
	end

	if v77 and v77:IsA("BindableEvent") then
		return v77
	end

	return nil
end

local v32 = hoverInfoModule.create(scriptParent)
local t1: {[any]: any} = {}
local t2: {[any]: any} = {}

local function clearHoverHandles()
	for _, v in ipairs(t2) do
		v.disconnect()
	end

	table.clear(t2)
end

local v36: Instance = replicatedStorage:WaitForChild("Shared")

require(v36:WaitForChild("Rarity"))

local v37: Instance = replicatedStorage:WaitForChild("Shared")
local device = require(v37:WaitForChild("Icons")).Device
local color3 = Color3.fromRGB(0, 255, 17)
local color32 = Color3.fromRGB(255, 0, 17)
local v41: Instance = scriptParent:WaitForChild("KillCard" .. 1)
local v42: Instance = scriptParent:WaitForChild("KillCard" .. 2)
local v43: Instance = scriptParent:WaitForChild("KillCard" .. 3)
local v44: Instance = scriptParent:WaitForChild("KillCard" .. 4)
local u45: boolean = false
local u46 = nil
local connection = nil
local u48 = nil
local u49: boolean = false
local t3: {[any]: any} = {}
local u51 = nil
local u52 = nil
local u53 = nil
local u54 = nil
local u55 = nil
local t4: {[any]: any} = { open = false, disabled = false, votes = 0, total = 0, voted = false }

local function updateRematchButton()
	local v80 = u54

	if not v80 then
		return
	end

	if not t4.open then
		v80.Visible = false

		return
	end

	v80.Visible = true

	local s1 = "Rematch unavailable"

	if not t4.disabled then
		if t4.voted then
			s1 = ("Waiting... (%d/%d)"):format(t4.votes, t4.total)
		else
			s1 = ("Rematch (%d/%d)"):format(t4.votes, t4.total)
		end
	end

	for _, v in ipairs(v80:GetDescendants()) do
		if v:IsA("TextLabel") then
			v.Text = s1
		end
	end

	if u55 then
		u55(t4.disabled)
	end

	v80.Active = not t4.disabled
	v80.AutoButtonColor = not t4.disabled
end
local function getDeviceIcon(p1)
	local lowerText = string.lower(p1)

	return device[lowerText] or device.pc
end
local function getNameFrame(p2)
	for _, v in ipairs(p2:GetChildren()) do
		if v:IsA("Frame") and v.Name == "Name" then
			return v
		end
	end

	return nil
end
local function setLocalCharAnchored(anchored)
	local Character: Model = LocalPlayer.Character

	if not Character then
		return
	end

	local humanoidRootPart: Instance = Character:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart then
		humanoidRootPart.Anchored = anchored
	end
end
local function hideFadeFailsafe()
	local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")

	if not playerGui then
		return
	end

	local cutsceneFadeGui: Instance = playerGui:FindFirstChild("CutsceneFadeGui")

	if not cutsceneFadeGui then
		return
	end

	local cutsceneFade: Instance = cutsceneFadeGui:FindFirstChild("CutsceneFade")

	if not cutsceneFade then
		return
	end

	if not cutsceneFade.Visible then
		return
	end

	cutsceneFade.BackgroundTransparency = 1
	cutsceneFade.Visible = false
end
local function populateCard(p4, p5, p6, enabled, p8)
	p4.Visible = true

	if not p4:GetAttribute("OriginalPosition") then
		p4:SetAttribute("OriginalPosition", p4.Position)
	end

	if p8 == 1 or p8 == 3 then
		local originalPosition = p4:GetAttribute("OriginalPosition")
		local v101 = UDim2.fromScale(0.08, 0)

		p4.Position = originalPosition - v101
	elseif p8 == 2 then
		local originalPosition = p4:GetAttribute("OriginalPosition")
		local v103 = UDim2.fromScale(0.15000000000000002, 0)

		p4.Position = originalPosition - v103
	else
		p4.Position = p4:GetAttribute("OriginalPosition")
	end

	local v104 = getNameFrame(p4)

	if v104 then
		local lossStroke = v104:FindFirstChild("LossStroke")
		local lossGradient = v104:FindFirstChild("LossGradient")
		local winStroke = v104:FindFirstChild("WinStroke")
		local winGradient = v104:FindFirstChild("WinGradient")

		if lossStroke then
			lossStroke.Enabled = not enabled
		end

		if lossGradient then
			lossGradient.Enabled = not enabled
		end

		if winStroke then
			winStroke.Enabled = enabled
		end

		if winGradient then
			winGradient.Enabled = enabled
		end

		local name = v104:FindFirstChild("Name")

		if name then
			name.Text = p5.DisplayName or p5.Name or "Unknown"
		end

		local crown = v104:FindFirstChild("Crown")

		if crown then
			crown.Visible = p6 and p8 > 1
		end

		local playerInfo = v104:FindFirstChild("PlayerInfo")
		local v112 = playerInfo

		if v112 then
			v112 = playerInfo:FindFirstChild("Frame")
		end

		if v112 then
			local device2 = v112:FindFirstChild("Device")

			if device2 then
				local lowerText = string.lower(p5.Device or "pc")

				device2.Image = device[lowerText] or device.pc
			end

			local streak = v112:FindFirstChild("Streak")

			if streak then
				local v116 = p5.WinStreak or 0

				streak.Visible = v116 >= 2

				local level = streak:FindFirstChild("Level")

				if level then
					level.Text = tostring(v116)
				end
			end

			local star = v112:FindFirstChild("Star")

			if star then
				local level = star:FindFirstChild("Level")

				if level then
					level.Text = tostring(p5.Level or 0)
				end
			end
		end
	end

	local stats = p4:FindFirstChild("Stats")

	if stats then
		local kills = stats:FindFirstChild("Kills")

		if kills then
			local amount = kills:FindFirstChild("Amount")

			if amount then
				amount.Text = tostring(p5.MatchKills or 0)
			end
		end

		local deaths = stats:FindFirstChild("Deaths")

		if deaths then
			local amount = deaths:FindFirstChild("Amount")

			if amount then
				amount.Text = tostring(p5.MatchDeaths or 0)
			end
		end

		local assists = stats:FindFirstChild("Assists")

		if assists then
			local amount = assists:FindFirstChild("Amount")

			if amount then
				amount.Text = tostring(p5.MatchAssists or 0)
			end
		end
	end

	local weapons = p4:FindFirstChild("Weapons")

	if not weapons then
		return
	end

	for _, v in ipairs(weapons:GetChildren()) do
		if v:IsA("GuiObject") and (v.Name == "LegendaryCell" or v.Name == "EpicCell" or v.Name == "WeaponTile") then
			v:Destroy()
		end
	end

	for _, v in ipairs({
		{
			layoutOrder = 0,
			icon = p5.KnifeIcon,
			rarity = p5.KnifeRarity,
			name = p5.KnifeName,
			globalCopies = p5.KnifeGlobalCopies,
			serial = p5.KnifeSerial,
			maxSupply = p5.KnifeMaxSupply
		},
		{
			layoutOrder = 1,
			icon = p5.RevolverIcon,
			rarity = p5.RevolverRarity,
			name = p5.RevolverName,
			globalCopies = p5.RevolverGlobalCopies,
			serial = p5.RevolverSerial,
			maxSupply = p5.RevolverMaxSupply
		}
	}) do
		local vIcon = v.icon

		if vIcon and vIcon ~= "" then
			local v133 = v.rarity or "Common"
			local weaponTile = uiFramework.createItemCell(v133, { icon = vIcon })

			weaponTile.Name = "WeaponTile"
			weaponTile.Size = UDim2.fromScale(1, 1)
			weaponTile.LayoutOrder = v.layoutOrder
			weaponTile.Visible = true
			weaponTile.Parent = weapons

			local v135 = v.name or "Unknown"
			local vGlobalCopies = v.globalCopies
			local vSerial = v.serial
			local vMaxSupply = v.maxSupply

			table.insert(t2, hoverInfoModule.bind(v32, weaponTile, function()
				return {
					Name = v135,
					Rarity = v133,
					GlobalCopies = vGlobalCopies,
					Serial = vSerial,
					MaxSupply = vMaxSupply,
					SourceButton = weaponTile
				}
			end))
		end
	end
end
local function closeWinScreen()
	if not u45 then
		return
	end

	u45 = false

	if u46 then
		local matchmakingShared: Instance = replicatedStorage:FindFirstChild("MatchmakingShared")

		if matchmakingShared ~= nil and matchmakingShared:GetAttribute("MMTutorialMatch") == true then
			screenWipe.cover(0, "Teleporting to Lobby")
			task.delay(15, function()
				if screenWipe.isCovered() then
					screenWipe.reveal()
					warn("[WinScreen] Tutorial return-to-lobby teleport did not land within 15s; revealing.")
				end
			end)
		end
	end

	hoverInfoModule.hide(v32)

	for _, v in ipairs(t1) do
		v:Disconnect()
	end

	table.clear(t1)
	LocalPlayer:SetAttribute("_WinScreenOpen", nil)
	userInputService.ModalEnabled = false

	for _, v in ipairs(t3) do
		if v and v.Parent then
			v:Resume()
		end
	end

	table.clear(t3)
	u52 = nil

	if u51 and not u51.Destroyed then
		u51:Destroy()
	end

	u51 = nil
	winScreenCutscene.StopCutscene()

	if u46 then
		winScreenDismiss:FireServer(u46)
		u46 = nil
	end

	if u48 then
		task.cancel(u48)
		u48 = nil
	end

	if connection then
		connection:Disconnect()
		connection = nil
	end

	local Character: Model = LocalPlayer.Character

	if Character then
		local humanoidRootPart: Instance = Character:FindFirstChild("HumanoidRootPart")

		if humanoidRootPart then
			humanoidRootPart.Anchored = false
		end
	end

	local CurrentCamera: Camera = workspace.CurrentCamera

	if CurrentCamera then
		local Character2: Model = LocalPlayer.Character

		if Character2 then
			local humanoidRootPart: Instance = Character2:FindFirstChild("HumanoidRootPart")

			if humanoidRootPart then
				CurrentCamera.CFrame = CFrame.new(humanoidRootPart.Position - humanoidRootPart.CFrame.LookVector * 10 + Vector3.new(0, 2, 0), humanoidRootPart.Position)
			end

			CurrentCamera.CameraSubject = Character2:FindFirstChildOfClass("Humanoid")
		end

		CurrentCamera.CameraType = Enum.CameraType.Custom
	end

	ParentParent.Enabled = false
	scriptParent.Visible = false

	local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")

	if playerGui then
		local hud: Instance = playerGui:FindFirstChild("HUD")

		if hud and hud:IsA("ScreenGui") then
			hud.Enabled = true
		end

		local inMatchUI: Instance = playerGui:FindFirstChild("InMatchUI")

		if inMatchUI and inMatchUI:IsA("ScreenGui") then
			inMatchUI.Enabled = true
		end

		local cursor: Instance = playerGui:FindFirstChild("Cursor")

		if cursor and cursor:IsA("ScreenGui") then
			cursor.Enabled = true
		end
	end
end
local function setBtnText(text)
	local textLabel: Instance = returnButton:FindFirstChild("TextLabel")

	if textLabel then
		textLabel.Text = text

		for _, v in ipairs(textLabel:GetChildren()) do
			if v:IsA("TextLabel") then
				v.Text = text
			end
		end
	end
end
local function buildActionStack()
	if u28 then
		return
	end

	local actionButtonThemeThemes = actionButtonTheme.THEMES

	local function retext(p10, text)
		for _, v in ipairs(p10:GetDescendants()) do
			if v:IsA("TextLabel") then
				v.Text = text
			end
		end
	end
	local function themeButton(p12, p13)
		local uiGradient = p12:FindFirstChildOfClass("UIGradient")

		if uiGradient then
			uiGradient.Color = ColorSequence.new(p13.grad)
		end

		for _, v in ipairs(p12:GetChildren()) do
			if v:IsA("TextLabel") then
				v.TextColor3 = p13.shadow

				local textLabel = v:FindFirstChildOfClass("TextLabel")
				local uiStroke = textLabel and textLabel:FindFirstChildOfClass("UIStroke")

				if uiStroke then
					uiStroke.Color = p13.stroke
				end
			end
		end
	end
	local function hideKeybind(p14)
		local keybind = p14:FindFirstChild("Keybind")

		if keybind and keybind:IsA("GuiObject") then
			keybind.Visible = false
		end
	end

	local postMatchActions: Frame = Instance.new("Frame")

	postMatchActions.Name = "PostMatchActions"
	postMatchActions.BackgroundTransparency = 1
	postMatchActions.Active = false
	postMatchActions.Size = UDim2.fromScale(1, 1)
	postMatchActions.Visible = false
	postMatchActions.Parent = ParentParent

	local function makeBtn(name, p16, p17)
		local clone: Instance = returnButton:Clone()

		for _, v in ipairs(clone:GetChildren()) do
			if v:IsA("UIScale") then
				v:Destroy()
			end
		end

		clone.Name = name
		clone.Visible = true
		retext(clone, p16)
		themeButton(clone, p17)

		local keybind: Instance = clone:FindFirstChild("Keybind")

		if keybind and keybind:IsA("GuiObject") then
			keybind.Visible = false
		end

		clone.Parent = postMatchActions

		return clone
	end

	local scale = returnButton.Size.X.Scale
	local v164 = returnButton.Size.Y.Scale
	local v165 = scale
	local v166 = v164
	local n1 = v164 * 0.18
	local v168 = returnButton.Position.X.Scale
	local v169 = returnButton.Position.Y.Scale
	local matchmakingShared: Instance = replicatedStorage:FindFirstChild("MatchmakingShared")

	if matchmakingShared ~= nil and matchmakingShared:GetAttribute("MMTutorialMatch") == true then
		local v171 = makeBtn("ReturnToLobbyAction", "Return to Lobby", actionButtonThemeThemes.red)

		v171.Size = UDim2.fromScale(scale * 1.5, v164 * 1.45)
		v171.AnchorPoint = Vector2.new(1, 1)
		v171.Position = UDim2.fromScale(v168, v169)
		v171.MouseButton1Click:Connect(function()
			closeWinScreen()
		end)
		u28 = postMatchActions

		return
	end

	local v172 = makeBtn("PlayAgainAction", "Play Again", actionButtonThemeThemes.green)
	local v173 = makeBtn("BackAction", "Back", actionButtonThemeThemes.red)

	v173.Size = UDim2.fromScale(v165, v166)
	v173.AnchorPoint = Vector2.new(1, 1)
	v173.Position = UDim2.fromScale(v168, v169)
	v172.Size = UDim2.fromScale(v165, v166)
	v172.AnchorPoint = Vector2.new(1, 1)
	v172.Position = UDim2.fromScale(v168, v169 - v166 - n1)

	local v174 = makeBtn("RematchAction", "Rematch", actionButtonThemeThemes.blue)

	v174.Size = UDim2.fromScale(v165, v166)
	v174.AnchorPoint = Vector2.new(1, 1)
	v174.Position = UDim2.fromScale(v168, v169 - 2 * (v166 + n1))
	v174.Visible = false
	u54 = v174
	u55 = function(p18)
		themeButton(v174, p18 and actionButtonThemeThemes.gray or actionButtonThemeThemes.blue)
	end
	v174.MouseButton1Click:Connect(function()
		if t4.disabled then
		elseif u53 then
			u53:FireServer()
		end
	end)
	v172.MouseButton1Click:Connect(function()
		local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")
		local matchmaking: Instance = playerGui and playerGui:FindFirstChild("Matchmaking")
		local v283: Instance = matchmaking

		if v283 then
			v283 = matchmaking:FindFirstChild("PostMatchIntent")
		end

		local v284 = if v283 and v283:IsA("BindableEvent") then v283 else nil

		if v284 and v284:GetAttribute("IsLeader") == false then
			if _G.Notify then
				_G.Notify({
					notifType = "FailNotification",
					errorMessage = "Only the party leader can start the queue."
				})
			end

			return
		end

		closeWinScreen()

		if v284 then
			v284:Fire("PlayAgain")
		end
	end)
	v173.MouseButton1Click:Connect(function()
		closeWinScreen()
	end)
	u28 = postMatchActions
	updateRematchButton()
end
local function enterReturnState()
	local matchmakingShared: Instance = replicatedStorage:FindFirstChild("MatchmakingShared")
	local isReservedServer: Instance = matchmakingShared and matchmakingShared:FindFirstChild("IsReservedServer")

	if isReservedServer ~= nil and isReservedServer.Value == true then
		buildActionStack()
		returnButton.Visible = false

		if u28 then
			u28.Visible = true

			return
		end
	else
		setBtnText("RETURN")
	end
end

local t5: {[any]: any} = { v41, v42, v43, v44 }

local function openWinScreen(p19, p20, p21, p22, p23)
	if u45 then
		return
	end

	u45 = true
	hoverInfoModule.hide(v32)

	for _, v in ipairs(t1) do
		v:Disconnect()
	end

	table.clear(t1)
	u46 = p19
	LocalPlayer:SetAttribute("_WinScreenOpen", true)
	userInputService.ModalEnabled = true
	ParentParent.Enabled = true
	scriptParent.Visible = true
	bg.Visible = false
	u49 = false
	setBtnText("SKIP")

	local matchmakingShared: Instance = replicatedStorage:FindFirstChild("MatchmakingShared")
	local isReservedServer: Instance = matchmakingShared and matchmakingShared:FindFirstChild("IsReservedServer")

	if isReservedServer ~= nil and isReservedServer.Value == true then
		returnButton.Visible = true

		if u28 then
			u28.Visible = false
		end
	end

	local Character: Model = LocalPlayer.Character

	if Character then
		local humanoidRootPart: Instance = Character:FindFirstChild("HumanoidRootPart")

		if humanoidRootPart then
			humanoidRootPart.Anchored = true
		end
	end

	local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")

	if playerGui then
		local hud: Instance = playerGui:FindFirstChild("HUD")

		if hud and hud:IsA("ScreenGui") then
			hud.Enabled = false
		end

		local inMatchUI: Instance = playerGui:FindFirstChild("InMatchUI")

		if inMatchUI and inMatchUI:IsA("ScreenGui") then
			inMatchUI.Enabled = false
		end

		local cursor: Instance = playerGui:FindFirstChild("Cursor")

		if cursor and cursor:IsA("ScreenGui") then
			cursor.Enabled = false
		end
	end

	if connection then
		connection:Disconnect()
	end

	connection = LocalPlayer.CharacterAdded:Connect(function(character: Model)
		task.defer(function()
			local humanoidRootPart: Instance = character:WaitForChild("HumanoidRootPart", 5)

			task.wait(0.1)

			if humanoidRootPart and u45 then
				humanoidRootPart.Anchored = true
			end
		end)
	end)
	table.sort(p21, function(p25, p26)
		return (p25.MatchKills or 0) > (p26.MatchKills or 0)
	end)

	local v192 = math.min(#p21, 4)
	local u193 = false

	if typeof(LocalPlayer:GetAttribute("Spectating")) == "number" then
		u193 = LocalPlayer:GetAttribute("Spectating") ~= 0
	end

	local u194 = u193 or p20 == p22

	win.Text = if u194 then "VICTORY" else "DEFEAT"
	bg.ImageColor3 = u194 and color3 or color32

	local imageLabel: Instance = bg:FindFirstChild("ImageLabel")

	if imageLabel then
		local winGradient: Instance = imageLabel:FindFirstChild("WinGradient")
		local lossGradient: Instance = imageLabel:FindFirstChild("LossGradient")

		if winGradient then
			winGradient.Enabled = u194
		end

		if lossGradient then
			lossGradient.Enabled = not u194
		end
	end

	t5[1].Visible = false
	t5[2].Visible = false
	t5[3].Visible = false
	t5[4].Visible = false

	for i = 1, v192 do
		populateCard(t5[i], p21[i], i == 1, u194, v192)
		t5[i].Visible = false
	end

	u194 = {}

	for i = 1, v192 do
		table.insert(u194, {
			UserId = p21[i].UserId,
			KnifeSkin = p21[i].KnifeSkin or "Default",
			RevolverSkin = p21[i].RevolverSkin or "Default"
		})
	end

	u193 = nil

	if p23 then
		local foundChild = workspace.Game:FindFirstChild(p23)

		if foundChild and foundChild:IsA("Model") then
			u52 = foundChild

			local cutscene = foundChild:FindFirstChild("CUTSCENE")

			if cutscene and cutscene:IsA("BasePart") then
				u193 = cutscene.CFrame
			end
		end
	end

	if u193 then
		winScreenCutscene.PlayCutscene(u193, u194, function()
			bg.Visible = true

			for i = 1, v192 do
				t5[i].Visible = true
			end

			u49 = true

			local matchmakingShared2: Instance = replicatedStorage:FindFirstChild("MatchmakingShared")
			local isReservedServer: Instance = matchmakingShared2 and matchmakingShared2:FindFirstChild("IsReservedServer")

			if isReservedServer ~= nil and isReservedServer.Value == true then
				buildActionStack()
				returnButton.Visible = false

				if u28 then
					u28.Visible = true

					return
				end
			else
				setBtnText("RETURN")
			end
		end, function()
			if u52 then
				for _, v in ipairs(u52:GetDescendants()) do
					if v:IsA("Sound") and v.Playing then
						v:Pause()
						table.insert(t3, v)
					end
				end
			end

			u51 = sound:Play("Misc.WinScreen", workspace)
		end)
	else
		warn("[WinScreenController] No CUTSCENE part found in map, cutscene skipped")

		local playerGui2: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")

		if playerGui2 then
			local cutsceneFadeGui: Instance = playerGui2:FindFirstChild("CutsceneFadeGui")

			if cutsceneFadeGui then
				local cutsceneFade: Instance = cutsceneFadeGui:FindFirstChild("CutsceneFade")

				if cutsceneFade and cutsceneFade.Visible then
					cutsceneFade.BackgroundTransparency = 1
					cutsceneFade.Visible = false
				end
			end
		end

		u49 = true

		local matchmakingShared3: Instance = replicatedStorage:FindFirstChild("MatchmakingShared")
		local matchmakingShared3IsReservedServer: Instance = matchmakingShared3 and matchmakingShared3:FindFirstChild("IsReservedServer")

		if matchmakingShared3IsReservedServer ~= nil and matchmakingShared3IsReservedServer.Value == true then
			buildActionStack()
			returnButton.Visible = false

			if u28 then
				u28.Visible = true
			end
		else
			setBtnText("RETURN")
		end

		bg.Visible = true

		for i = 1, v192 do
			t5[i].Visible = true
		end
	end

	u48 = task.delay(120, function()
		u48 = nil
		closeWinScreen()
	end)
end
local function getMyRelevantMatch()
	local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

	if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then
		local lobbySpectateTeam: any = LocalPlayer:GetAttribute("LobbySpectateTeam")
		local v210: any = lobbySpectateMatchId

		if typeof(lobbySpectateTeam) == "string" then
			return v210, lobbySpectateTeam
		end

		return v210, nil
	end

	local spectating: any = LocalPlayer:GetAttribute("Spectating")
	local v212 = typeof(spectating) == "number" and spectating ~= 0 and players:GetPlayerByUserId(spectating)

	if v212 then
		local v213 = v212:GetAttribute("_LastMatchId") or v212:GetAttribute("MatchId")

		if typeof(v213) == "string" then
			local v214 = v212:GetAttribute("_LastMatchSide") or v212:GetAttribute("MatchSide")
			local v215 = v213

			if typeof(v214) == "string" then
				return v215, v214
			end

			return v215, nil
		end
	end

	local v216: any = LocalPlayer:GetAttribute("MatchId") or LocalPlayer:GetAttribute("_LastMatchId")

	if typeof(v216) == "string" then
		local v217: any = LocalPlayer:GetAttribute("MatchSide") or LocalPlayer:GetAttribute("_LastMatchSide")
		local v218: any = v216

		if typeof(v217) == "string" then
			return v218, v217
		end

		return v218, nil
	end

	return nil, nil
end
local function onReturnAction()
	if not u45 then
	elseif not u49 then
		u49 = true

		if u51 and not u51.Destroyed then
			u51:Destroy()
		end

		u51 = nil
		winScreenCutscene.SkipToIdle()

		local matchmakingShared: Instance = replicatedStorage:FindFirstChild("MatchmakingShared")
		local isReservedServer: Instance = matchmakingShared and matchmakingShared:FindFirstChild("IsReservedServer")

		if isReservedServer == nil or isReservedServer.Value ~= true then
			setBtnText("RETURN")

			return
		end

		buildActionStack()
		returnButton.Visible = false

		if u28 then
			u28.Visible = true

			return
		end
	else
		local matchmakingShared: Instance = replicatedStorage:FindFirstChild("MatchmakingShared")
		local matchmakingSharedIsReservedServer: Instance = matchmakingShared and matchmakingShared:FindFirstChild("IsReservedServer")

		if matchmakingSharedIsReservedServer ~= nil and matchmakingSharedIsReservedServer.Value == true then
			return
		end

		closeWinScreen()
	end
end

returnButton.MouseButton1Click:Connect(onReturnAction)

local keybind: Instance = returnButton:FindFirstChild("Keybind")

if keybind then
	uiFramework.applyGamepadKeybind(keybind, gamepadBindings.Menu)
	uiFramework.bindKeybindLabel(keybind, "Menu")
end

userInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	if gameProcessedEvent then
		return
	end

	if inputMap.matches("Menu", input) then
		onReturnAction()
	end
end)
LocalPlayer:GetAttributeChangedSignal("MMQueued"):Connect(function()
	local matchmakingShared: Instance = replicatedStorage:FindFirstChild("MatchmakingShared")
	local isReservedServer: Instance = matchmakingShared and matchmakingShared:FindFirstChild("IsReservedServer")

	if isReservedServer == nil or isReservedServer.Value ~= true then
	elseif u45 and LocalPlayer:GetAttribute("MMQueued") == true then
		closeWinScreen()
	end
end)
v11.OnClientEvent:Connect(function(p29, p30)
	if typeof(p30) == "table" then
		if p30.t == "PreMatchEnded" then
			local v229 = getMyRelevantMatch()

			if p29 ~= v229 then
				return
			end

			local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")

			if playerGui then
				local cutsceneFadeGui: Instance = playerGui:FindFirstChild("CutsceneFadeGui")
				local cutsceneFadeGuiCutsceneFade: Instance = cutsceneFadeGui and cutsceneFadeGui:FindFirstChild("CutsceneFade")

				if cutsceneFadeGuiCutsceneFade and game.Lighting.WinCutsceneDOF.Enabled == false and (not cutsceneFadeGuiCutsceneFade.Visible or not (cutsceneFadeGuiCutsceneFade.BackgroundTransparency < 1)) then
					cutsceneFadeGuiCutsceneFade.BackgroundTransparency = 1
					cutsceneFadeGuiCutsceneFade.Visible = true

					local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

					tweenService:Create(cutsceneFadeGuiCutsceneFade, tweenInfo, { BackgroundTransparency = 0 }):Play()
				end

				task.delay(0.2, function()
					local hud: Instance = playerGui:FindFirstChild("HUD")

					if hud and hud:IsA("ScreenGui") then
						hud.Enabled = false
					end

					local inMatchUI: Instance = playerGui:FindFirstChild("InMatchUI")

					if inMatchUI and inMatchUI:IsA("ScreenGui") then
						inMatchUI.Enabled = false
					end

					local cursor: Instance = playerGui:FindFirstChild("Cursor")

					if cursor and cursor:IsA("ScreenGui") then
						cursor.Enabled = false
					end
				end)
			end
		elseif p30.t == "MatchEnded" then
			local v234, v235 = getMyRelevantMatch()

			if not v234 or p29 ~= v234 then
				local localPlayerUserId = LocalPlayer.UserId
				local v237 = nil

				if p30.playersA then
					for _, v in ipairs(p30.playersA) do
						if localPlayerUserId == v.UserId then
							v237 = "A"

							break
						end
					end
				end

				if not v237 and p30.playersB then
					for _, v in ipairs(p30.playersB) do
						if localPlayerUserId == v.UserId then
							v237 = "B"

							break
						end
					end
				end

				if not v237 then
					if not v234 then
						local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")

						if not playerGui then
							return
						end

						local cutsceneFadeGui: Instance = playerGui:FindFirstChild("CutsceneFadeGui")

						if not cutsceneFadeGui then
							return
						end

						local cutsceneFade: Instance = cutsceneFadeGui:FindFirstChild("CutsceneFade")

						if not cutsceneFade then
							return
						end

						if not cutsceneFade.Visible then
							return
						end

						cutsceneFade.BackgroundTransparency = 1
						cutsceneFade.Visible = false

						return
					end

					return
				end

				v235 = v235 or v237
			end

			local winner = p30.winner

			if not winner then
				local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")

				if not playerGui then
					return
				end

				local cutsceneFadeGui: Instance = playerGui:FindFirstChild("CutsceneFadeGui")

				if not cutsceneFadeGui then
					return
				end

				local cutsceneFade: Instance = cutsceneFadeGui:FindFirstChild("CutsceneFade")

				if not cutsceneFade then
					return
				end

				if not cutsceneFade.Visible then
					return
				end

				cutsceneFade.BackgroundTransparency = 1
				cutsceneFade.Visible = false

				return
			end

			local v249 = winner == "A" and p30.playersA or p30.playersB

			if not v249 or #v249 == 0 then
				v249 = winner == "A" and p30.playersB or p30.playersA
			end

			if v249 and #v249 ~= 0 then
				openWinScreen(p29, winner, v249, v235 or "A", p30.mapName)

				local spectating: any = LocalPlayer:GetAttribute("Spectating")
				local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")
				local v252 = (typeof(spectating) == "number" and spectating ~= 0 or typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "") and replicatedStorage.Remotes:FindFirstChild("Spectate")

				if v252 then
					v252:FireServer(nil)
				end

				return
			end

			local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")

			if not playerGui then
				return
			end

			local cutsceneFadeGui: Instance = playerGui:FindFirstChild("CutsceneFadeGui")

			if not cutsceneFadeGui then
				return
			end

			local cutsceneFade: Instance = cutsceneFadeGui:FindFirstChild("CutsceneFade")

			if not cutsceneFade then
				return
			end

			if not cutsceneFade.Visible then
				return
			end

			cutsceneFade.BackgroundTransparency = 1
			cutsceneFade.Visible = false

			return
		end

		return
	end
end)
task.spawn(function()
	local matchmakingShared: Instance = replicatedStorage:WaitForChild("MatchmakingShared", 10)
	local remotes: Instance = matchmakingShared and matchmakingShared:WaitForChild("Remotes", 10)

	if not remotes then
		return
	end

	u53 = remotes:WaitForChild("RematchVote", 10)

	local rematchState: Instance = remotes:WaitForChild("RematchState", 10)
	local rematchStarting: Instance = remotes:WaitForChild("RematchStarting", 10)

	if rematchState then
		rematchState.OnClientEvent:Connect(function(p31)
			if typeof(p31) == "table" then
				t4.open = p31.open == true
				t4.disabled = p31.disabled == true
				t4.votes = tonumber(p31.votes) or 0
				t4.total = tonumber(p31.total) or 0

				local u297: boolean = false

				if type(p31.voters) == "table" then
					for _, v in ipairs(p31.voters) do
						if v == LocalPlayer.UserId then
							u297 = true

							break
						end
					end
				end

				t4.voted = u297
				updateRematchButton()

				return
			end
		end)
	end

	if rematchStarting then
		rematchStarting.OnClientEvent:Connect(function()
			t4.open = false
			updateRematchButton()

			if u45 then
				closeWinScreen()
			end
		end)
	end
end)
