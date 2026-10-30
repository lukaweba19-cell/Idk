-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
task.wait()

local icon = require(game.ReplicatedStorage:WaitForChild("Icon"))
local players: Players = game:GetService("Players")
local userInputService: UserInputService = game:GetService("UserInputService")
local extensions = game.ReplicatedStorage:WaitForChild("Extensions")
local inputMap = require(extensions:WaitForChild("InputMap"))
local tweenService: TweenService = game:GetService("TweenService")
local guiService: GuiService = game:GetService("GuiService")
local starterGui: StarterGui = game:GetService("StarterGui")
local LocalPlayer: Player = players.LocalPlayer
local scriptParent: Instance = script.Parent
local playerSelection = script.Parent.Parent.PlayerSelection
local scriptParentPlayerContainer = scriptParent.PlayerContainer
local leaderboardCustomisation = require(scriptParent:WaitForChild("LeaderboardCustomisation"))
local leaderboardCustomisationLeaderboardEnabled = leaderboardCustomisation.LeaderboardEnabled
local leaderboardCustomisationLeaderboardToggleable = leaderboardCustomisation.LeaderboardToggleable
local leaderboardCustomisationLeaderboardInfoEnabled = leaderboardCustomisation.LeaderboardInfoEnabled
local shared = game.ReplicatedStorage:WaitForChild("Shared")
local tradingPlazaGate = require(shared:WaitForChild("TradingPlazaGate"))
local replicatedStorageShared = game.ReplicatedStorage:WaitForChild("Shared")
local tradePublicFlags = require(replicatedStorageShared:WaitForChild("TradePublicFlags"))
local s1 = if tradingPlazaGate.IsTradingPlaza() and tradePublicFlags.PlazaRapEnabled() then "Value" else leaderboardCustomisation.Leaderstats.Stat2

if not leaderboardCustomisationLeaderboardEnabled then
	scriptParent.Visible = false
	playerSelection.Visible = false

	return
end

if userInputService.TouchEnabled or userInputService.VREnabled then
	scriptParent.Position = UDim2.new(1, 350, 0, 10)
	scriptParent.GroupTransparency = 1
	playerSelection.GroupTransparency = 1
end

local t1: {[any]: any} = {
	thin = "Thin",
	extralight = "ExtraLight",
	light = "Light",
	regular = "Regular",
	normal = "Regular",
	medium = "Medium",
	semibold = "Semibold",
	bold = "Bold",
	extrabold = "ExtraBold",
	heavy = "Heavy",
	black = "Black"
}
local t2: {[any]: any} = { normal = "Normal", italic = "Italic" }

local function getAttr(p1, p2)
	local ok, result = pcall(function()
		return p1:GetAttribute(p2)
	end)

	return ok and result or nil
end

local t3: {[any]: any} = {
	arcade = Enum.Font.Arcade,
	ui = Enum.Font.SourceSans,
	gotham = Enum.Font.Gotham,
	mono = Enum.Font.RobotoMono,
	cartoon = Enum.Font.Cartoon,
	code = Enum.Font.Code
}

local function resolveFontFaceForPlayer(p3)
	local s1
	local v73
	local v74
	local v75
	local v76
	local s2
	local v78
	local v79
	local v80
	local v81
	local s3
	local v83
	local v84
	local v85
	local v86
	local typeName
	local lowerText
	local v89
	local v90
	local typeName2
	local v92
	local v93
	local typeName3
	local v95
	local v96
	local v97
	local v98
	local v99
	local v100
	local v101

	s1 = "ChatFont"
	v73 = function()
		return p3:GetAttribute(s1)
	end
	v74, v75 = pcall(v73)
	v76 = v74 and v75 or nil
	s2 = "ChatFontWeight"
	v78 = function()
		return p3:GetAttribute(s2)
	end
	v79, v80 = pcall(v78)
	v81 = v79 and v80 or nil
	s3 = "ChatFontStyle"
	v83 = function()
		return p3:GetAttribute(s3)
	end
	v84, v85 = pcall(v83)
	v86 = v84 and v85 or nil
	typeName = type(v76)

	if typeName == "string" and v76 ~= "" then
		lowerText = string.lower(v76)

		if t3[lowerText] then
			v89 = Font.fromEnum(t3[lowerText])
			v90 = v89.Family
			typeName2 = type(v81)
			v92 = typeName2 == "string" and t1[string.lower(v81)]
			v93 = v92 and Enum.FontWeight[t1[string.lower(v81)]] or nil
			typeName3 = type(v86)
			v95 = typeName3 == "string" and t2[string.lower(v86)] and Enum.FontStyle[t2[string.lower(v86)]] or nil
			v96 = function()
				if v93 and v95 then
					return Font.new(v90, v93, v95)
				end

				if v93 then
					return Font.new(v90, v93)
				end

				return Font.new(v90)
			end
			v97, v98 = pcall(v96)

			if v97 and v98 then
				return v98
			else
				v99 = function()
					local v197 = type(v81) == "string" and t1[string.lower(v81)] and Enum.FontWeight[t1[string.lower(v81)]] or nil
					local v198 = type(v86) == "string" and t2[string.lower(v86)] and Enum.FontStyle[t2[string.lower(v86)]] or nil

					if v197 and v198 then
						return Font.new(v76, v197, v198)
					end

					if v197 then
						return Font.new(v76, v197)
					end

					return Font.new(v76)
				end
				v100, v101 = pcall(v99)

				return v100 and v101 or nil
			end
		else
			v99 = function()
				local v197 = type(v81) == "string" and t1[string.lower(v81)] and Enum.FontWeight[t1[string.lower(v81)]] or nil
				local v198 = type(v86) == "string" and t2[string.lower(v86)] and Enum.FontStyle[t2[string.lower(v86)]] or nil

				if v197 and v198 then
					return Font.new(v76, v197, v198)
				end

				if v197 then
					return Font.new(v76, v197)
				end

				return Font.new(v76)
			end
			v100, v101 = pcall(v99)

			return v100 and v101 or nil
		end
	else
		return nil
	end
end
local function ensureStroke(parent)
	local nameStroke = parent:FindFirstChild("NameStroke")

	if not nameStroke then
		nameStroke = Instance.new("UIStroke")
		nameStroke.Name = "NameStroke"
		nameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		nameStroke.Thickness = 1
		nameStroke.Transparency = 0
		nameStroke.LineJoinMode = Enum.LineJoinMode.Round
		nameStroke.Parent = parent
	end

	return nameStroke
end
local function clearStroke(p5)
	local nameStroke = p5:FindFirstChild("NameStroke")

	if nameStroke then
		nameStroke:Destroy()
	end
end
local function styleLabelForPlayerName(p6, parent)
	if not p6 or not parent or not parent:IsA("TextLabel") then
		return
	end

	local s1: string = "ChatTextColor"

	local ok, result = pcall(function()
		return p6:GetAttribute(s1)
	end)

	local v111 = ok and result or nil

	if typeof(v111) == "Color3" then
		parent.TextColor3 = v111
	end

	v111 = resolveFontFaceForPlayer(p6)

	if v111 then
		parent.FontFace = v111
	end

	local s2: string = "ChatBackgroundColor"

	local ok2, result2 = pcall(function()
		return p6:GetAttribute(s2)
	end)

	v111 = ok2 and result2 or nil

	if typeof(v111) == "Color3" then
		local nameStroke = parent:FindFirstChild("NameStroke")

		if not nameStroke then
			nameStroke = Instance.new("UIStroke")
			nameStroke.Name = "NameStroke"
			nameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
			nameStroke.Thickness = 1
			nameStroke.Transparency = 0
			nameStroke.LineJoinMode = Enum.LineJoinMode.Round
			nameStroke.Parent = parent
		end

		nameStroke.Color = v111

		return
	end

	local nameStroke = parent:FindFirstChild("NameStroke")

	if nameStroke then
		nameStroke:Destroy()
	end
end

local object = setmetatable({}, { __mode = "k" })

local function tween(p8, p9, p10, p11)
	if object[p8] then
		object[p8]:Pause()
		object[p8]:Destroy()
	end

	local tweenInfo = TweenInfo.new(p9, p11 or Enum.EasingStyle.Quint)
	local v122: Tween = tweenService:Create(p8, tweenInfo, p10)

	object[p8] = v122
	v122:Play()

	return v122
end

pcall(function()
	starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
end)

local function isSmallScreen()
	local CurrentCamera: Camera = workspace.CurrentCamera

	if not CurrentCamera then
		return false
	end

	local currentCameraViewportSize: Vector2 = CurrentCamera.ViewportSize

	return math.min(currentCameraViewportSize.X, currentCameraViewportSize.Y) <= 500
end
local function updateSize()
	local CurrentCamera: Camera = workspace.CurrentCamera
	local u126

	if not CurrentCamera then
		u126 = false
	else
		local currentCameraViewportSize: Vector2 = CurrentCamera.ViewportSize

		u126 = math.min(currentCameraViewportSize.X, currentCameraViewportSize.Y) <= 500
	end

	local n1: number = if u126 then 166 else 400
	local y = scriptParentPlayerContainer.UIListLayout.AbsoluteContentSize.Y

	if n1 > y then
		scriptParentPlayerContainer.AutomaticCanvasSize = Enum.AutomaticSize.None
		scriptParentPlayerContainer.Size = UDim2.new(0, 325, 0, y)
		scriptParent.Size = UDim2.new(0, 325, 0, y + 33)

		return
	end

	scriptParentPlayerContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scriptParentPlayerContainer.Size = UDim2.new(0, 325, 0, n1)
	scriptParent.Size = UDim2.new(0, 325, 0, n1 + 33)
end

local CurrentCamera: Camera = workspace.CurrentCamera
local connection = nil

CurrentCamera = workspace.CurrentCamera

if CurrentCamera then
	connection = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateSize)
end

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	if connection then
		connection:Disconnect()
	end

	CurrentCamera = workspace.CurrentCamera

	if CurrentCamera then
		connection = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateSize)
	end
end)

local function checkIfBlocked(p12)
	local v131 = game.StarterGui:GetCore("GetBlockedUserIds")
	local u132: boolean = false

	for _, v in ipairs(v131) do
		if v == p12 then
			u132 = true
		end
	end

	return u132
end
local function removePlayer(player)
	local foundChild = scriptParentPlayerContainer:FindFirstChild(player.UserId)

	if foundChild then
		foundChild:Destroy()
	end

	updateSize()
end
local function getStatNumber(p14, p15)
	local leaderstats = p14:FindFirstChild("leaderstats")

	if not leaderstats then
		return -math.huge
	end

	local foundChild = leaderstats:FindFirstChild(p15)

	if not foundChild then
		return -math.huge
	end

	return tonumber(foundChild.Value) or -math.huge
end
local function resort()
	local n1
	local n2
	local t4: {[any]: any} = {}

	for _, v in ipairs(players:GetPlayers()) do
		local vUserId = scriptParentPlayerContainer:FindFirstChild(v.UserId)

		if vUserId then
			local t5: {[any]: any} = { frame = vUserId, primary = n1, secondary = n2 }
			local v148 = s1
			local leaderstats = v:FindFirstChild("leaderstats")

			if not leaderstats then
				local n1 = -math.huge
			else
				local foundChild = leaderstats:FindFirstChild(v148)

				n1 = if not foundChild then -math.huge else tonumber(foundChild.Value) or -math.huge
			end

			local leaderstats2 = v:FindFirstChild("leaderstats")

			if not leaderstats2 then
				local n2 = -math.huge
			else
				local level = leaderstats2:FindFirstChild("Level")

				if not level then
					n2 = -math.huge
				else
					n2 = tonumber(level.Value) or -math.huge
				end
			end

			t5.userId = v.UserId
			table.insert(t4, t5)
		end
	end

	table.sort(t4, function(p16, p17)
		if p16.primary ~= p17.primary then
			return p16.primary > p17.primary
		end

		if p16.secondary ~= p17.secondary then
			return p16.secondary > p17.secondary
		end

		return p16.userId < p17.userId
	end)

	for i, v in ipairs(t4) do
		v.frame.LayoutOrder = i
	end
end
local function addPlayer(p18)
	task.spawn(function()
		local clone = script.UserFrame:Clone()
		local userId = p18.UserId

		clone.Name = userId
		clone.ZIndex = 999
		clone.Visible = false
		clone.Parent = scriptParentPlayerContainer
		clone.Visible = true

		local s7 = ""

		task.spawn(function()
			local ok, result = pcall(players.GetUserThumbnailAsync, players, userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size60x60)

			if ok and result then
				s7 = result
			end

			if ok and result and clone and clone.Parent then
				clone.Info.Avatar.Image = result
			end
		end)

		local s2: string = ""
		local s3 = ""

		if p18.MembershipType == Enum.MembershipType.Premium then
			s2 = "  "
		end

		if p18.HasVerifiedBadge then
			s3 = utf8.char(57344)
		end

		local s4: string = s2
		local v207 = s3

		clone.Info.Identifier.Text = s4 .. p18.DisplayName .. v207

		local function updName()
			local characterName = p18:GetAttribute("CharacterName")

			if characterName then
				clone.Info.Identifier.Text = s2 .. characterName .. s3

				return
			end

			clone.Info.Identifier.Text = s2 .. p18.DisplayName .. s3
		end

		p18:GetAttributeChangedSignal("CharacterName"):Connect(updName)
		p18:GetPropertyChangedSignal("HasVerifiedBadge"):Connect(updName)

		local characterName = p18:GetAttribute("CharacterName")

		if characterName then
			local s5: string = s2
			local v211 = s3

			clone.Info.Identifier.Text = s5 .. characterName .. v211
		else
			local s6: string = s2
			local v213 = s3

			clone.Info.Identifier.Text = s6 .. p18.DisplayName .. v213
		end

		styleLabelForPlayerName(p18, clone.Info.Identifier)
		updName = function()
			styleLabelForPlayerName(p18, clone.Info.Identifier)
		end
		p18:GetAttributeChangedSignal("ChatTextColor"):Connect(updName)
		p18:GetAttributeChangedSignal("ChatFont"):Connect(updName)
		p18:GetAttributeChangedSignal("ChatFontWeight"):Connect(updName)
		p18:GetAttributeChangedSignal("ChatFontStyle"):Connect(updName)

		local function formatWithCommas(p19)
			if typeof(p19) == "number" then
				local floored = math.floor(p19)
				local text = tostring(floored)

				repeat
					local v225, v226 = text:gsub("^(-?%d+)(%d%d%d)", "%1,%2")

					text = v225
				until v226 == 0

				return text
			end

			local numberValue: number? = tonumber(p19)

			if numberValue then
				local floored = math.floor(numberValue)
				local text = tostring(floored)

				repeat
					local v230, v231 = text:gsub("^(-?%d+)(%d%d%d)", "%1,%2")

					text = v230
				until v231 == 0

				return text
			end

			return (tostring(p19 or "-"))
		end

		if leaderboardCustomisation.Leaderstats.LeaderstatsEnabled then
			local stat1 = leaderboardCustomisation.Leaderstats.Stat1
			local v216 = s1

			if stat1 == "" or stat1 == nil then
				clone.Stats.Stat1.Visible = false
				scriptParent.LeaderboardInfo.Statistics.Stat1.Visible = false
			else
				scriptParent.LeaderboardInfo.Statistics.Stat1.Visible = true
				scriptParent.LeaderboardInfo.Statistics.Stat1.Text = stat1
				clone.Stats.Stat1.Text = "-"
			end

			if v216 == "" or v216 == nil then
				clone.Stats.Stat2.Visible = false
				scriptParent.LeaderboardInfo.Statistics.Stat2.Visible = false
			else
				scriptParent.LeaderboardInfo.Statistics.Stat2.Visible = true
				scriptParent.LeaderboardInfo.Statistics.Stat2.Text = v216
				clone.Stats.Stat2.Text = "-"
			end

			task.spawn(function()
				local leaderstats = p18:WaitForChild("leaderstats", 30)

				if not leaderstats or not clone.Parent then
					return
				end

				if stat1 ~= "" then
					local v263 = stat1 ~= nil and leaderstats:WaitForChild(stat1, 10)

					if v263 and clone.Parent then
						v263.Changed:Connect(function()
							clone.Stats.Stat1.Text = formatWithCommas(v263.Value)
							resort()
						end)
						clone.Stats.Stat1.Text = formatWithCommas(v263.Value)
						resort()
					end
				end

				if v216 ~= "" then
					local v264 = v216 ~= nil and leaderstats:WaitForChild(v216, 10)

					if v264 and clone.Parent then
						v264.Changed:Connect(function()
							clone.Stats.Stat2.Text = formatWithCommas(v264.Value)
							resort()
						end)
						clone.Stats.Stat2.Text = formatWithCommas(v264.Value)
						resort()
					end
				end
			end)
		else
			clone.Stats.Stat1.Visible = false
			clone.Stats.Stat2.Visible = false
			scriptParent.LeaderboardInfo.Statistics.Stat1.Visible = false
			scriptParent.LeaderboardInfo.Statistics.Stat2.Visible = false
		end

		clone.UIPadding.PaddingLeft = UDim.new(0, 15)
		tween(clone.UIPadding, 0.2, { PaddingLeft = UDim.new(0, 15) })
		clone.Activated:Connect(function()
			if playerSelection:GetAttribute("selected_user") == userId then
				playerSelection:SetAttribute("selected_user", 0)

				local uDim2 = UDim2.new(0, clone.AbsolutePosition.X, 0, clone.AbsolutePosition.Y)

				tween(playerSelection, 0.2, { GroupTransparency = 1, Position = uDim2 }).Completed:Connect(function()
					playerSelection.Visible = false
				end)
				playerSelection.UserInformation.Info.Username.Text = "@" .. p18.Name
				playerSelection.UserInformation.Info.DisplayName.Text = p18.DisplayName
				styleLabelForPlayerName(p18, playerSelection.UserInformation.Info.DisplayName)

				return
			end

			playerSelection:SetAttribute("selected_user", p18.UserId)
			playerSelection.GroupTransparency = 1
			playerSelection.Position = UDim2.new(0, clone.AbsolutePosition.X - 20, 0, clone.AbsolutePosition.Y)

			local uDim2 = UDim2.new(0, clone.AbsolutePosition.X - 10, 0, clone.AbsolutePosition.Y)

			tween(playerSelection, 0.2, { GroupTransparency = 0, Position = uDim2 }).Completed:Connect(function()
				playerSelection.Visible = true
			end)
			playerSelection.Visible = true
			playerSelection.UserInformation.Avatar.Image = s7
			playerSelection.UserInformation.Info.Username.Text = "@" .. p18.Name
			playerSelection.UserInformation.Info.DisplayName.Text = s2 .. p18.DisplayName .. s3
			styleLabelForPlayerName(p18, playerSelection.UserInformation.Info.DisplayName)

			local v267 = userId
			local v268 = game.StarterGui:GetCore("GetBlockedUserIds")
			local u269: boolean = false

			for _, v in ipairs(v268) do
				if v == v267 then
					u269 = true
				end
			end

			if u269 then
				playerSelection.ChoiceList.AddFriend.Visible = false
				playerSelection.ChoiceList.Unfriend.Visible = false
				playerSelection.ChoiceList.BlockUser.Visible = false
				playerSelection.ChoiceList.UnblockUser.Visible = true
			end

			if p18:IsFriendsWith(LocalPlayer.UserId) then
				playerSelection.ChoiceList.AddFriend.Visible = false
				playerSelection.ChoiceList.Unfriend.Visible = true
			else
				playerSelection.ChoiceList.AddFriend.Visible = true
				playerSelection.ChoiceList.Unfriend.Visible = false
			end

			if p18 == LocalPlayer then
				playerSelection.ChoiceList.AddFriend.Visible = false
				playerSelection.ChoiceList.Unfriend.Visible = false
				playerSelection.ChoiceList.BlockUser.Visible = false
				playerSelection.ChoiceList.UnblockUser.Visible = false
			end
		end)
		playerSelection.ChoiceList.Close.Activated:Connect(function()
			if playerSelection:GetAttribute("selected_user") == userId then
				playerSelection:SetAttribute("selected_user", 0)

				local uDim2 = UDim2.new(0, clone.AbsolutePosition.X, 0, clone.AbsolutePosition.Y)

				tween(playerSelection, 0.2, { GroupTransparency = 1, Position = uDim2 }).Completed:Connect(function()
					playerSelection.Visible = false
				end)
				playerSelection.UserInformation.Info.Username.Text = "@" .. p18.Name
				playerSelection.UserInformation.Info.DisplayName.Text = p18.DisplayName
				styleLabelForPlayerName(p18, playerSelection.UserInformation.Info.DisplayName)
			end
		end)
		updateSize()
	end)
end

playerSelection.ChoiceList.ViewAvatar.Visible = false
playerSelection.ChoiceList.ViewAvatar.Activated:Connect(function()
	if playerSelection:GetAttribute("selected_user") ~= 0 then
		guiService:InspectPlayerFromUserId(playerSelection:GetAttribute("selected_user"))
	end
end)
playerSelection.ChoiceList.ViewProfile.Activated:Connect(function()
	local selected_user = playerSelection:GetAttribute("selected_user")

	if selected_user and selected_user ~= 0 then
		local player: Player = players:GetPlayerByUserId(selected_user)
		local v158 = player and game.ReplicatedStorage:FindFirstChild("Bindables")
		local requestPlayerCard = v158 and v158:FindFirstChild("RequestPlayerCard")

		if requestPlayerCard then
			requestPlayerCard:Fire(player)
		end

		playerSelection:SetAttribute("selected_user", 0)
		tween(playerSelection, 0.2, { GroupTransparency = 1 }).Completed:Connect(function()
			playerSelection.Visible = false
		end)
	end
end)
playerSelection.ChoiceList.AddFriend.Activated:Connect(function()
	pcall(function()
		starterGui:SetCore("PromptSendFriendRequest", players:GetPlayerByUserId(playerSelection:GetAttribute("selected_user")))
	end)
end)
playerSelection.ChoiceList.Unfriend.Activated:Connect(function()
	pcall(function()
		starterGui:SetCore("PromptUnfriend", players:GetPlayerByUserId(playerSelection:GetAttribute("selected_user")))
	end)
end)
playerSelection.ChoiceList.BlockUser.Activated:Connect(function()
	pcall(function()
		starterGui:SetCore("PromptBlockPlayer", players:GetPlayerByUserId(playerSelection:GetAttribute("selected_user")))
	end)
end)
playerSelection.ChoiceList.UnblockUser.Activated:Connect(function()
	pcall(function()
		starterGui:SetCore("PromptUnblockPlayer", players:GetPlayerByUserId(playerSelection:GetAttribute("selected_user")))
	end)
end)

local starterGui2: StarterGui = game:GetService("StarterGui")
local runService: RunService = game:GetService("RunService")

local function retryBindCoreEvent(p20, p21)
	task.spawn(function()
		while true do
			local ok, result = pcall(function()
				return starterGui2:GetCore(s5)
			end)

			if ok and result and typeof(result) == "RBXScriptSignal" and pcall(function()
				result.Event:Connect(function(...)
					pcall(v50, ...)
				end)
			end) then
				break
			end

			runService.Heartbeat:Wait()
		end
	end)
end
local function v44()
	if playerSelection:GetAttribute("selected_user") ~= 0 then
		playerSelection.ChoiceList.AddFriend.Visible = false
		playerSelection.ChoiceList.Unfriend.Visible = false
		playerSelection.ChoiceList.BlockUser.Visible = false
		playerSelection.ChoiceList.UnblockUser.Visible = true
	end
end

local s2: string = "PlayerBlockedEvent"

task.spawn(function()
	while true do
		local ok, result = pcall(function()
			return starterGui2:GetCore(s5)
		end)

		if ok and result and typeof(result) == "RBXScriptSignal" and pcall(function()
			result.Event:Connect(function(...)
				pcall(v50, ...)
			end)
		end) then
			break
		end

		runService.Heartbeat:Wait()
	end
end)

local function v46()
	if playerSelection:GetAttribute("selected_user") ~= 0 then
		playerSelection.ChoiceList.AddFriend.Visible = true
		playerSelection.ChoiceList.Unfriend.Visible = false
		playerSelection.ChoiceList.BlockUser.Visible = true
		playerSelection.ChoiceList.UnblockUser.Visible = false
	end
end

local s3: string = "PlayerUnblockedEvent"

task.spawn(function()
	while true do
		local ok, result = pcall(function()
			return starterGui2:GetCore(s5)
		end)

		if ok and result and typeof(result) == "RBXScriptSignal" and pcall(function()
			result.Event:Connect(function(...)
				pcall(v50, ...)
			end)
		end) then
			break
		end

		runService.Heartbeat:Wait()
	end
end)

local function v48()
	if playerSelection:GetAttribute("selected_user") ~= 0 then
		playerSelection.ChoiceList.AddFriend.Visible = false
		playerSelection.ChoiceList.Unfriend.Visible = true
	end
end

local s4: string = "PlayerFriendedEvent"

task.spawn(function()
	while true do
		local ok, result = pcall(function()
			return starterGui2:GetCore(s5)
		end)

		if ok and result and typeof(result) == "RBXScriptSignal" and pcall(function()
			result.Event:Connect(function(...)
				pcall(v50, ...)
			end)
		end) then
			break
		end

		runService.Heartbeat:Wait()
	end
end)

local function v50()
	if playerSelection:GetAttribute("selected_user") ~= 0 then
		playerSelection.ChoiceList.AddFriend.Visible = true
		playerSelection.ChoiceList.Unfriend.Visible = false
	end
end

local s5: string = "PlayerUnfriendedEvent"

task.spawn(function()
	while true do
		local ok, result = pcall(function()
			return starterGui2:GetCore(s5)
		end)

		if ok and result and typeof(result) == "RBXScriptSignal" and pcall(function()
			result.Event:Connect(function(...)
				pcall(v50, ...)
			end)
		end) then
			break
		end

		runService.Heartbeat:Wait()
	end
end)

if leaderboardCustomisationLeaderboardToggleable then
	local u52 = not userInputService.TouchEnabled and not userInputService.VREnabled
	local u53 = false
	local u54 = nil
	local v55 = icon.new():setName("PlayerList"):setLabel(if u52 then "Hide" else "Show"):setRight(true)

	local function applyState(p22)
		if p22 then
			scriptParent.Visible = true
			tween(scriptParent, 0.2, { GroupTransparency = 0, Position = UDim2.new(1, -10, 0, 10) })
			tween(playerSelection, 0.2, { GroupTransparency = 1 })
			v55:setLabel("Hide")
		else
			tween(scriptParent, 0.2, { GroupTransparency = 1, Position = UDim2.new(1, 350, 0, 10) }).Completed:Connect(function()
				scriptParent.Visible = false
			end)
			playerSelection:SetAttribute("selected_user", 0)
			tween(playerSelection, 0.2, { GroupTransparency = 1 }).Completed:Connect(function()
				playerSelection.Visible = false
			end)
			v55:setLabel("Show")
		end

		v55:deselect()
	end
	local function action()
		if u53 then
			return
		end

		u52 = not u52
		applyState(u52)
	end

	userInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
		if u53 then
			return
		end

		if not not gameProcessedEvent or not inputMap.matches("Scoreboard", input) then
			return
		end

		if u53 then
			return
		end

		u52 = not u52
		applyState(u52)
	end)
	scriptParent.LeaderboardInfo.MouseButton1Click:Connect(function()
		if u53 then
			return
		end

		u52 = not u52
		applyState(u52)
	end)
	v55.selected:Connect(function()
		if u53 then
			return
		end

		u52 = not u52
		applyState(u52)
	end)

	local LocalPlayer2: Player = players.LocalPlayer

	local function setLocked(p25)
		if p25 == u53 then
			return
		end

		u53 = p25

		if u53 then
			u54 = u52
			applyState(false)
			v55:setLabel("In Match")
			v55:deselect()

			if v55.setEnabled then
				v55:setEnabled(false)

				return
			end
		else
			if v55.setEnabled then
				v55:setEnabled(true)
			end

			if u54 ~= nil then
				u52 = u54
				u54 = nil
			end

			applyState(u52)
		end
	end
	local function updateLock()
		local matchId: any = LocalPlayer2:GetAttribute("MatchId")
		local votingPhase: any = LocalPlayer2:GetAttribute("VotingPhase")
		local spectating: any = LocalPlayer2:GetAttribute("Spectating")
		local u177: boolean = false

		if typeof(spectating) == "number" then
			u177 = spectating ~= 0
		end

		setLocked(matchId ~= nil or u177 or votingPhase == true)
	end

	local matchId: any = LocalPlayer2:GetAttribute("MatchId")
	local votingPhase: any = LocalPlayer2:GetAttribute("VotingPhase")
	local spectating: any = LocalPlayer2:GetAttribute("Spectating")
	local u64: boolean = false

	if typeof(spectating) == "number" then
		u64 = spectating ~= 0
	end

	setLocked(matchId ~= nil or u64 or votingPhase == true)
	LocalPlayer2:GetAttributeChangedSignal("MatchId"):Connect(updateLock)
	LocalPlayer2:GetAttributeChangedSignal("Spectating"):Connect(updateLock)
	LocalPlayer2:GetAttributeChangedSignal("VotingPhase"):Connect(updateLock)

	if not u53 then
		applyState(u52)
	end
end

for _, v in ipairs(players:GetPlayers()) do
	task.spawn(function()
		local clone = script.UserFrame:Clone()
		local vUserId = v.UserId

		clone.Name = vUserId
		clone.ZIndex = 999
		clone.Visible = false
		clone.Parent = scriptParentPlayerContainer
		clone.Visible = true

		local s7 = ""

		task.spawn(function()
			local ok, result = pcall(players.GetUserThumbnailAsync, players, vUserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size60x60)

			if ok and result then
				s7 = result
			end

			if ok and result and clone and clone.Parent then
				clone.Info.Avatar.Image = result
			end
		end)

		local s2: string = ""
		local s3 = ""

		if v.MembershipType == Enum.MembershipType.Premium then
			s2 = "  "
		end

		if v.HasVerifiedBadge then
			s3 = utf8.char(57344)
		end

		local s4: string = s2
		local v184 = s3

		clone.Info.Identifier.Text = s4 .. v.DisplayName .. v184

		local function updName()
			local characterName = v:GetAttribute("CharacterName")

			if characterName then
				clone.Info.Identifier.Text = s2 .. characterName .. s3

				return
			end

			clone.Info.Identifier.Text = s2 .. v.DisplayName .. s3
		end

		v:GetAttributeChangedSignal("CharacterName"):Connect(updName)
		v:GetPropertyChangedSignal("HasVerifiedBadge"):Connect(updName)

		local characterName = v:GetAttribute("CharacterName")

		if characterName then
			local s5: string = s2
			local v188 = s3

			clone.Info.Identifier.Text = s5 .. characterName .. v188
		else
			local s6: string = s2
			local v190 = s3

			clone.Info.Identifier.Text = s6 .. v.DisplayName .. v190
		end

		styleLabelForPlayerName(v, clone.Info.Identifier)
		updName = function()
			styleLabelForPlayerName(v, clone.Info.Identifier)
		end
		v:GetAttributeChangedSignal("ChatTextColor"):Connect(updName)
		v:GetAttributeChangedSignal("ChatFont"):Connect(updName)
		v:GetAttributeChangedSignal("ChatFontWeight"):Connect(updName)
		v:GetAttributeChangedSignal("ChatFontStyle"):Connect(updName)

		local function formatWithCommas(p19)
			if typeof(p19) == "number" then
				local floored = math.floor(p19)
				local text = tostring(floored)

				repeat
					local v225, v226 = text:gsub("^(-?%d+)(%d%d%d)", "%1,%2")

					text = v225
				until v226 == 0

				return text
			end

			local numberValue: number? = tonumber(p19)

			if numberValue then
				local floored = math.floor(numberValue)
				local text = tostring(floored)

				repeat
					local v230, v231 = text:gsub("^(-?%d+)(%d%d%d)", "%1,%2")

					text = v230
				until v231 == 0

				return text
			end

			return (tostring(p19 or "-"))
		end

		if leaderboardCustomisation.Leaderstats.LeaderstatsEnabled then
			local stat1 = leaderboardCustomisation.Leaderstats.Stat1
			local v193 = s1

			if stat1 == "" or stat1 == nil then
				clone.Stats.Stat1.Visible = false
				scriptParent.LeaderboardInfo.Statistics.Stat1.Visible = false
			else
				scriptParent.LeaderboardInfo.Statistics.Stat1.Visible = true
				scriptParent.LeaderboardInfo.Statistics.Stat1.Text = stat1
				clone.Stats.Stat1.Text = "-"
			end

			if v193 == "" or v193 == nil then
				clone.Stats.Stat2.Visible = false
				scriptParent.LeaderboardInfo.Statistics.Stat2.Visible = false
			else
				scriptParent.LeaderboardInfo.Statistics.Stat2.Visible = true
				scriptParent.LeaderboardInfo.Statistics.Stat2.Text = v193
				clone.Stats.Stat2.Text = "-"
			end

			task.spawn(function()
				local leaderstats = v:WaitForChild("leaderstats", 30)

				if not leaderstats or not clone.Parent then
					return
				end

				if stat1 ~= "" then
					local v233 = stat1 ~= nil and leaderstats:WaitForChild(stat1, 10)

					if v233 and clone.Parent then
						v233.Changed:Connect(function()
							clone.Stats.Stat1.Text = formatWithCommas(v233.Value)
							resort()
						end)
						clone.Stats.Stat1.Text = formatWithCommas(v233.Value)
						resort()
					end
				end

				if v193 ~= "" then
					local v234 = v193 ~= nil and leaderstats:WaitForChild(v193, 10)

					if v234 and clone.Parent then
						v234.Changed:Connect(function()
							clone.Stats.Stat2.Text = formatWithCommas(v234.Value)
							resort()
						end)
						clone.Stats.Stat2.Text = formatWithCommas(v234.Value)
						resort()
					end
				end
			end)
		else
			clone.Stats.Stat1.Visible = false
			clone.Stats.Stat2.Visible = false
			scriptParent.LeaderboardInfo.Statistics.Stat1.Visible = false
			scriptParent.LeaderboardInfo.Statistics.Stat2.Visible = false
		end

		clone.UIPadding.PaddingLeft = UDim.new(0, 15)
		tween(clone.UIPadding, 0.2, { PaddingLeft = UDim.new(0, 15) })
		clone.Activated:Connect(function()
			if playerSelection:GetAttribute("selected_user") == vUserId then
				playerSelection:SetAttribute("selected_user", 0)

				local uDim2 = UDim2.new(0, clone.AbsolutePosition.X, 0, clone.AbsolutePosition.Y)

				tween(playerSelection, 0.2, { GroupTransparency = 1, Position = uDim2 }).Completed:Connect(function()
					playerSelection.Visible = false
				end)
				playerSelection.UserInformation.Info.Username.Text = "@" .. v.Name
				playerSelection.UserInformation.Info.DisplayName.Text = v.DisplayName
				styleLabelForPlayerName(v, playerSelection.UserInformation.Info.DisplayName)

				return
			end

			playerSelection:SetAttribute("selected_user", v.UserId)
			playerSelection.GroupTransparency = 1
			playerSelection.Position = UDim2.new(0, clone.AbsolutePosition.X - 20, 0, clone.AbsolutePosition.Y)

			local uDim2 = UDim2.new(0, clone.AbsolutePosition.X - 10, 0, clone.AbsolutePosition.Y)

			tween(playerSelection, 0.2, { GroupTransparency = 0, Position = uDim2 }).Completed:Connect(function()
				playerSelection.Visible = true
			end)
			playerSelection.Visible = true
			playerSelection.UserInformation.Avatar.Image = s7
			playerSelection.UserInformation.Info.Username.Text = "@" .. v.Name
			playerSelection.UserInformation.Info.DisplayName.Text = s2 .. v.DisplayName .. s3
			styleLabelForPlayerName(v, playerSelection.UserInformation.Info.DisplayName)

			local v237 = vUserId
			local v238 = game.StarterGui:GetCore("GetBlockedUserIds")
			local u239: boolean = false

			for _, iterValue in ipairs(v238) do
				if iterValue == v237 then
					u239 = true
				end
			end

			if u239 then
				playerSelection.ChoiceList.AddFriend.Visible = false
				playerSelection.ChoiceList.Unfriend.Visible = false
				playerSelection.ChoiceList.BlockUser.Visible = false
				playerSelection.ChoiceList.UnblockUser.Visible = true
			end

			if v:IsFriendsWith(LocalPlayer.UserId) then
				playerSelection.ChoiceList.AddFriend.Visible = false
				playerSelection.ChoiceList.Unfriend.Visible = true
			else
				playerSelection.ChoiceList.AddFriend.Visible = true
				playerSelection.ChoiceList.Unfriend.Visible = false
			end

			if v == LocalPlayer then
				playerSelection.ChoiceList.AddFriend.Visible = false
				playerSelection.ChoiceList.Unfriend.Visible = false
				playerSelection.ChoiceList.BlockUser.Visible = false
				playerSelection.ChoiceList.UnblockUser.Visible = false
			end
		end)
		playerSelection.ChoiceList.Close.Activated:Connect(function()
			if playerSelection:GetAttribute("selected_user") == vUserId then
				playerSelection:SetAttribute("selected_user", 0)

				local uDim2 = UDim2.new(0, clone.AbsolutePosition.X, 0, clone.AbsolutePosition.Y)

				tween(playerSelection, 0.2, { GroupTransparency = 1, Position = uDim2 }).Completed:Connect(function()
					playerSelection.Visible = false
				end)
				playerSelection.UserInformation.Info.Username.Text = "@" .. v.Name
				playerSelection.UserInformation.Info.DisplayName.Text = v.DisplayName
				styleLabelForPlayerName(v, playerSelection.UserInformation.Info.DisplayName)
			end
		end)
		updateSize()
	end)
end

resort()
players.PlayerAdded:Connect(function(player: Player)
	task.spawn(function()
		local clone = script.UserFrame:Clone()
		local userId = player.UserId

		clone.Name = userId
		clone.ZIndex = 999
		clone.Visible = false
		clone.Parent = scriptParentPlayerContainer
		clone.Visible = true

		local s7 = ""

		task.spawn(function()
			local ok, result = pcall(players.GetUserThumbnailAsync, players, userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size60x60)

			if ok and result then
				s7 = result
			end

			if ok and result and clone and clone.Parent then
				clone.Info.Avatar.Image = result
			end
		end)

		local s2: string = ""
		local s3 = ""

		if player.MembershipType == Enum.MembershipType.Premium then
			s2 = "  "
		end

		if player.HasVerifiedBadge then
			s3 = utf8.char(57344)
		end

		local s4: string = s2
		local v249 = s3

		clone.Info.Identifier.Text = s4 .. player.DisplayName .. v249

		local function updName()
			local characterName: any = player:GetAttribute("CharacterName")

			if characterName then
				clone.Info.Identifier.Text = s2 .. characterName .. s3

				return
			end

			clone.Info.Identifier.Text = s2 .. player.DisplayName .. s3
		end

		player:GetAttributeChangedSignal("CharacterName"):Connect(updName)
		player:GetPropertyChangedSignal("HasVerifiedBadge"):Connect(updName)

		local characterName: any = player:GetAttribute("CharacterName")

		if characterName then
			local s5: string = s2
			local v253 = s3

			clone.Info.Identifier.Text = s5 .. characterName .. v253
		else
			local s6: string = s2
			local v255 = s3

			clone.Info.Identifier.Text = s6 .. player.DisplayName .. v255
		end

		styleLabelForPlayerName(player, clone.Info.Identifier)
		updName = function()
			styleLabelForPlayerName(player, clone.Info.Identifier)
		end
		player:GetAttributeChangedSignal("ChatTextColor"):Connect(updName)
		player:GetAttributeChangedSignal("ChatFont"):Connect(updName)
		player:GetAttributeChangedSignal("ChatFontWeight"):Connect(updName)
		player:GetAttributeChangedSignal("ChatFontStyle"):Connect(updName)

		local function formatWithCommas(p19)
			if typeof(p19) == "number" then
				local floored = math.floor(p19)
				local text = tostring(floored)

				repeat
					local v225, v226 = text:gsub("^(-?%d+)(%d%d%d)", "%1,%2")

					text = v225
				until v226 == 0

				return text
			end

			local numberValue: number? = tonumber(p19)

			if numberValue then
				local floored = math.floor(numberValue)
				local text = tostring(floored)

				repeat
					local v230, v231 = text:gsub("^(-?%d+)(%d%d%d)", "%1,%2")

					text = v230
				until v231 == 0

				return text
			end

			return (tostring(p19 or "-"))
		end

		if leaderboardCustomisation.Leaderstats.LeaderstatsEnabled then
			local stat1 = leaderboardCustomisation.Leaderstats.Stat1
			local v258 = s1

			if stat1 == "" or stat1 == nil then
				clone.Stats.Stat1.Visible = false
				scriptParent.LeaderboardInfo.Statistics.Stat1.Visible = false
			else
				scriptParent.LeaderboardInfo.Statistics.Stat1.Visible = true
				scriptParent.LeaderboardInfo.Statistics.Stat1.Text = stat1
				clone.Stats.Stat1.Text = "-"
			end

			if v258 == "" or v258 == nil then
				clone.Stats.Stat2.Visible = false
				scriptParent.LeaderboardInfo.Statistics.Stat2.Visible = false
			else
				scriptParent.LeaderboardInfo.Statistics.Stat2.Visible = true
				scriptParent.LeaderboardInfo.Statistics.Stat2.Text = v258
				clone.Stats.Stat2.Text = "-"
			end

			task.spawn(function()
				local leaderstats: Instance = player:WaitForChild("leaderstats", 30)

				if not leaderstats or not clone.Parent then
					return
				end

				if stat1 ~= "" then
					local v277 = stat1 ~= nil and leaderstats:WaitForChild(stat1, 10)

					if v277 and clone.Parent then
						v277.Changed:Connect(function()
							clone.Stats.Stat1.Text = formatWithCommas(v277.Value)
							resort()
						end)
						clone.Stats.Stat1.Text = formatWithCommas(v277.Value)
						resort()
					end
				end

				if v258 ~= "" then
					local v278 = v258 ~= nil and leaderstats:WaitForChild(v258, 10)

					if v278 and clone.Parent then
						v278.Changed:Connect(function()
							clone.Stats.Stat2.Text = formatWithCommas(v278.Value)
							resort()
						end)
						clone.Stats.Stat2.Text = formatWithCommas(v278.Value)
						resort()
					end
				end
			end)
		else
			clone.Stats.Stat1.Visible = false
			clone.Stats.Stat2.Visible = false
			scriptParent.LeaderboardInfo.Statistics.Stat1.Visible = false
			scriptParent.LeaderboardInfo.Statistics.Stat2.Visible = false
		end

		clone.UIPadding.PaddingLeft = UDim.new(0, 15)
		tween(clone.UIPadding, 0.2, { PaddingLeft = UDim.new(0, 15) })
		clone.Activated:Connect(function()
			if playerSelection:GetAttribute("selected_user") == userId then
				playerSelection:SetAttribute("selected_user", 0)

				local uDim2 = UDim2.new(0, clone.AbsolutePosition.X, 0, clone.AbsolutePosition.Y)

				tween(playerSelection, 0.2, { GroupTransparency = 1, Position = uDim2 }).Completed:Connect(function()
					playerSelection.Visible = false
				end)
				playerSelection.UserInformation.Info.Username.Text = "@" .. player.Name
				playerSelection.UserInformation.Info.DisplayName.Text = player.DisplayName
				styleLabelForPlayerName(player, playerSelection.UserInformation.Info.DisplayName)

				return
			end

			playerSelection:SetAttribute("selected_user", player.UserId)
			playerSelection.GroupTransparency = 1
			playerSelection.Position = UDim2.new(0, clone.AbsolutePosition.X - 20, 0, clone.AbsolutePosition.Y)

			local uDim2 = UDim2.new(0, clone.AbsolutePosition.X - 10, 0, clone.AbsolutePosition.Y)

			tween(playerSelection, 0.2, { GroupTransparency = 0, Position = uDim2 }).Completed:Connect(function()
				playerSelection.Visible = true
			end)
			playerSelection.Visible = true
			playerSelection.UserInformation.Avatar.Image = s7
			playerSelection.UserInformation.Info.Username.Text = "@" .. player.Name
			playerSelection.UserInformation.Info.DisplayName.Text = s2 .. player.DisplayName .. s3
			styleLabelForPlayerName(player, playerSelection.UserInformation.Info.DisplayName)

			local v281 = userId
			local v282 = game.StarterGui:GetCore("GetBlockedUserIds")
			local u283: boolean = false

			for _, v in ipairs(v282) do
				if v == v281 then
					u283 = true
				end
			end

			if u283 then
				playerSelection.ChoiceList.AddFriend.Visible = false
				playerSelection.ChoiceList.Unfriend.Visible = false
				playerSelection.ChoiceList.BlockUser.Visible = false
				playerSelection.ChoiceList.UnblockUser.Visible = true
			end

			if player:IsFriendsWith(LocalPlayer.UserId) then
				playerSelection.ChoiceList.AddFriend.Visible = false
				playerSelection.ChoiceList.Unfriend.Visible = true
			else
				playerSelection.ChoiceList.AddFriend.Visible = true
				playerSelection.ChoiceList.Unfriend.Visible = false
			end

			if player == LocalPlayer then
				playerSelection.ChoiceList.AddFriend.Visible = false
				playerSelection.ChoiceList.Unfriend.Visible = false
				playerSelection.ChoiceList.BlockUser.Visible = false
				playerSelection.ChoiceList.UnblockUser.Visible = false
			end
		end)
		playerSelection.ChoiceList.Close.Activated:Connect(function()
			if playerSelection:GetAttribute("selected_user") == userId then
				playerSelection:SetAttribute("selected_user", 0)

				local uDim2 = UDim2.new(0, clone.AbsolutePosition.X, 0, clone.AbsolutePosition.Y)

				tween(playerSelection, 0.2, { GroupTransparency = 1, Position = uDim2 }).Completed:Connect(function()
					playerSelection.Visible = false
				end)
				playerSelection.UserInformation.Info.Username.Text = "@" .. player.Name
				playerSelection.UserInformation.Info.DisplayName.Text = player.DisplayName
				styleLabelForPlayerName(player, playerSelection.UserInformation.Info.DisplayName)
			end
		end)
		updateSize()
	end)
	resort()
end)
players.PlayerRemoving:Connect(function(player: Player)
	local foundChild = scriptParentPlayerContainer:FindFirstChild(player.UserId)

	if foundChild then
		foundChild:Destroy()
	end

	updateSize()
	resort()
end)
