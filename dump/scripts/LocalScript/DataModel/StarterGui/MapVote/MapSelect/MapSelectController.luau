-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local runService: RunService = game:GetService("RunService")
local LocalPlayer: Player = players.LocalPlayer
local v5: Instance = replicatedStorage:WaitForChild("MatchRemotes"):WaitForChild("State")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local windowBlur = require(shared:WaitForChild("WindowBlur"))

local function showBlur()
	windowBlur.show("MapVote")
end
local function hideBlur()
	windowBlur.hide("MapVote")
end
local function killBlur()
	windowBlur.hide("MapVote")
end
local function getMapSelect()
	local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui")
	local mapVote: Instance = playerGui:WaitForChild("MapVote")
	local hud: Instance = playerGui:WaitForChild("HUD")

	return mapVote:WaitForChild("MapSelect"), hud
end

local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui")
local mapVote: Instance = playerGui:WaitForChild("MapVote")
local hud: Instance = playerGui:WaitForChild("HUD")
local mapSelect: Instance = mapVote:WaitForChild("MapSelect")
local v16: Instance = hud
local items: Instance = mapSelect:WaitForChild("Items")
local container: Instance = items:WaitForChild("Container")
local uiGridLayout: Instance = container:WaitForChild("UIGridLayout")
local uiPadding: Instance = container:WaitForChild("UIPadding")
local vector2 = Vector2.new(uiGridLayout.CellSize.X.Scale, uiGridLayout.CellSize.Y.Scale)
local vector22 = Vector2.new(uiGridLayout.CellPadding.X.Scale, uiGridLayout.CellPadding.Y.Scale)

local function layoutGrid()
	local x = container.AbsoluteSize.X
	local y = items.AbsoluteSize.Y

	if x <= 0 or y <= 0 then
		return
	end

	local uDim2FromOffset = UDim2.fromOffset
	local floored = math.floor(x * vector2.X)
	local floored2 = math.floor(y * vector2.Y)

	uiGridLayout.CellSize = uDim2FromOffset(floored, floored2)

	local v63 = UDim2.fromOffset
	local floored3 = math.floor(x * vector22.X)
	local floored4 = math.floor(y * vector22.Y)

	uiGridLayout.CellPadding = v63(floored3, floored4)
end

container:GetPropertyChangedSignal("AbsoluteSize"):Connect(layoutGrid)
items:GetPropertyChangedSignal("AbsoluteSize"):Connect(layoutGrid)
uiGridLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	container.CanvasSize = UDim2.fromOffset(0, uiGridLayout.AbsoluteContentSize.Y + (uiPadding.PaddingTop.Offset + uiPadding.PaddingBottom.Offset))
end)
layoutGrid()
container.CanvasSize = UDim2.fromOffset(0, uiGridLayout.AbsoluteContentSize.Y + (uiPadding.PaddingTop.Offset + uiPadding.PaddingBottom.Offset))

local timer: Instance = mapSelect:WaitForChild("VoteTimer"):WaitForChild("Timer")
local uiFramework: Instance = replicatedStorage:WaitForChild("UIFramework")
local basicPlayerGreen: Instance = uiFramework:WaitForChild("Misc"):WaitForChild("BasicPlayerGreen")
local basicPlayerRed: Instance = uiFramework:WaitForChild("Misc"):WaitForChild("BasicPlayerRed")
local u28 = nil
local serverEndTime = nil
local t1: {[any]: any} = {}
local connection = nil
local u32 = nil

local function setVisible(visible, p2)
	mapSelect.Visible = visible

	local CurrentCamera: Camera = workspace.CurrentCamera

	if visible then
		v16.Enabled = false
		windowBlur.show("MapVote")
		CurrentCamera.CameraType = Enum.CameraType.Scriptable
		CurrentCamera.CFrame = CFrame.new(259.307251, -1969.8810463, -328.150299, -0.00553035596, -0.187429249, -0.982262611, -0.0, 0.982277632, -0.187432125, 0.999984682, -0.00103656633, -0.00543234497)

		return
	end

	if p2 then
		v16.Enabled = false
		windowBlur.hide("MapVote")

		return
	end

	v16.Enabled = true
	windowBlur.hide("MapVote")
	CurrentCamera.CameraType = Enum.CameraType.Custom
	CurrentCamera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
end
local function clearContainer()
	for _, v in ipairs(container:GetChildren()) do
		if v:IsA("GuiObject") and v.Name ~= "UIGridLayout" and v.Name ~= "UIPadding" and v:GetAttribute("__IsTemplate") ~= true then
			v:Destroy()
		end
	end

	table.clear(t1)
end
local function getTemplates()
	local mapSelection: Instance = container:WaitForChild("MapSelection")
	local mapSelectionRANDOM: Instance = container:WaitForChild("MapSelectionRANDOM")

	mapSelection:SetAttribute("__IsTemplate", true)
	mapSelectionRANDOM:SetAttribute("__IsTemplate", true)
	mapSelection.Visible = false
	mapSelectionRANDOM.Visible = true

	return mapSelection, mapSelectionRANDOM
end
local function setMapCardMeta(p3, p4, p5: boolean)
	if p5 == nil then
		p5 = true
	end

	if p5 then
		p3.Name = "MapSelection_" .. p4.name
	end

	local foundChild = p3:FindFirstChild("MapName", true)

	if foundChild then
		foundChild.Text = p4.name
	end

	local v77 = p3:FindFirstChild("MapImage") or p3:FindFirstChild("ImageLabel", true)

	if v77 and v77:IsA("ImageLabel") and p4.image and p4.image ~= "" then
		v77.Image = p4.image
	end
end
local function getVotedFrame(p6)
	local foundChild = p6:FindFirstChild("Voted", true)

	if foundChild and foundChild:IsA("Frame") then
		return foundChild
	end

	return nil
end
local function getVoteTemplates()
	return basicPlayerRed, basicPlayerGreen
end
local function clearVotes(p7)
	for _, v in ipairs(p7:GetChildren()) do
		if v:IsA("GuiObject") and string.sub(v.Name, 1, 5) == "Vote_" then
			v:Destroy()
		end
	end
end
local function makeHeadShotImage(p8)
	return ("rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420"):format(p8)
end
local function addVoteIcon(parent, p10, p11)
	local clone = p10:Clone()

	clone.Name = "Vote_" .. tostring(p11)
	clone.Visible = true
	clone.Parent = parent

	local foundChild = clone:FindFirstChild("Headshot", true)

	if foundChild and foundChild:IsA("ImageLabel") then
		foundChild.Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420"):format(p11)
	end
end
local function containsUid(p12, p13)
	for _, v in ipairs(p12) do
		if v == p13 then
			return true
		end
	end

	return false
end
local function paintVotesForCard(p14, p15)
	local foundChild = p14:FindFirstChild("Voted", true)
	local v96 = if foundChild and foundChild:IsA("Frame") then foundChild else nil

	if not v96 then
		return
	end

	local v97: Instance = basicPlayerRed
	local v98: Instance = basicPlayerGreen

	if v97 and v98 then
		clearVotes(v96)

		local t2 = p15.votesB or {}
		local v100 = u32

		local function templateFor(p16, p17)
			if p16 == LocalPlayer.UserId then
				return v98
			end

			if v100 == nil then
				return v97
			end

			return p17 == v100 and v98 or v97
		end

		for _, v in ipairs(p15.votesA or {}) do
			addVoteIcon(v96, if v == LocalPlayer.UserId then v98 else if v100 == nil then v97 else v100 == "A" and v98 or v97, v)
		end

		for _, v in ipairs(t2) do
			addVoteIcon(v96, if v == LocalPlayer.UserId then v98 else if v100 == nil then v97 else v100 == "B" and v98 or v97, v)
		end

		return
	end
end
local function startTimer(p18)
	serverEndTime = p18

	if connection then
		connection:Disconnect()
	end

	connection = runService.RenderStepped:Connect(function()
		if not serverEndTime then
			return
		end

		local v152 = serverEndTime
		local v153: number = workspace:GetServerTimeNow()
		local v154 = math.max(0, v152 - v153)

		timer.Text = string.format("%.1fs", v154)
	end)
end
local function stopTimer()
	serverEndTime = nil

	if connection then
		connection:Disconnect()
		connection = nil
	end

	timer.Text = ""
end

local mapSelection: Instance = container:WaitForChild("MapSelection")
local mapSelectionRANDOM: Instance = container:WaitForChild("MapSelectionRANDOM")

mapSelection:SetAttribute("__IsTemplate", true)
mapSelectionRANDOM:SetAttribute("__IsTemplate", true)
mapSelection.Visible = false
mapSelectionRANDOM.Visible = true

local v48: Instance = mapSelection
local v49: Instance = mapSelectionRANDOM

local function buildCards(p19)
	clearContainer()
	t1.RANDOM = v49

	if not v49:GetAttribute("__VoteHooked") then
		v49:SetAttribute("__VoteHooked", true)
		v49.MouseButton1Click:Connect(function()
			if not u28 then
				return
			end

			v5:FireServer(u28, { t = "MapVoteCast", mapName = "RANDOM" })
		end)
		setMapCardMeta(v49, { name = "RANDOM" }, false)
	end

	for _, v in ipairs(p19) do
		if v.name ~= "RANDOM" then
			local clone: Instance = v48:Clone()

			clone:SetAttribute("__IsTemplate", nil)
			clone.Visible = true
			clone.Parent = container
			setMapCardMeta(clone, v)
			t1[v.name] = clone
			clone.MouseButton1Click:Connect(function()
				if not u28 then
					return
				end

				v5:FireServer(u28, { t = "MapVoteCast", mapName = v.name })
			end)
		end
	end
end
local function onMapVoteStart(p20, p21)
	u28 = p20

	local matchSide: any = LocalPlayer:GetAttribute("MatchSide")

	if matchSide == "A" or matchSide == "B" then
		u32 = matchSide
	end

	mapSelect.Visible = true

	local CurrentCamera: Camera = workspace.CurrentCamera

	v16.Enabled = false
	windowBlur.show("MapVote")
	CurrentCamera.CameraType = Enum.CameraType.Scriptable
	CurrentCamera.CFrame = CFrame.new(259.307251, -1969.8810463, -328.150299, -0.00553035596, -0.187429249, -0.982262611, -0.0, 0.982277632, -0.187432125, 0.999984682, -0.00103656633, -0.00543234497)

	local options = p21.options

	if typeof(options) == "table" then
		local t3: {[any]: any} = {}

		for _, v in ipairs(options) do
			if typeof(v) == "table" and typeof(v.name) == "string" then
				table.insert(t3, {
					name = v.name,
					image = typeof(v.image) == "string" and v.image or nil,
					tier = typeof(v.tier) == "string" and v.tier or nil
				})
			end
		end

		buildCards(t3)
		layoutGrid()
		container.CanvasPosition = Vector2.zero

		if typeof(p21.serverEndTime) == "number" then
			serverEndTime = p21.serverEndTime

			if connection then
				connection:Disconnect()
			end

			connection = runService.RenderStepped:Connect(function()
				if not serverEndTime then
					return
				end

				local v155 = serverEndTime
				local v156: number = workspace:GetServerTimeNow()
				local v157 = math.max(0, v155 - v156)

				timer.Text = string.format("%.1fs", v157)
			end)
		end

		return
	end
end
local function onMapVoteUpdate(p22)
	if typeof(p22.serverEndTime) == "number" then
		serverEndTime = p22.serverEndTime

		if connection then
			connection:Disconnect()
		end

		connection = runService.RenderStepped:Connect(function()
			if not serverEndTime then
				return
			end

			local v152 = serverEndTime
			local v153: number = workspace:GetServerTimeNow()
			local v154 = math.max(0, v152 - v153)

			timer.Text = string.format("%.1fs", v154)
		end)
	end

	local items = p22.items

	if typeof(items) == "table" then
		if not u32 then
			for _, v in ipairs(items) do
				if typeof(v) == "table" then
					local t4 = v.votesB or {}
					local localPlayerUserId = LocalPlayer.UserId
					local v125, v126, v127 = ipairs(v.votesA or {})
					local v128: boolean = false
					local u129

					for iterFirst, iterSecond in v125, v126, v127 do
						if iterSecond == localPlayerUserId then
							u129 = true
							v128 = true

							break
						end
					end

					if not v128 then
						u129 = false
					end

					if u129 then
						u32 = "A"

						break
					end

					local userId = LocalPlayer.UserId
					local v133, v134, v135 = ipairs(t4)
					local v136: boolean = false
					local u137

					for iterFirst2, iterSecond2 in v133, v134, v135 do
						if iterSecond2 == userId then
							u137 = true
							v136 = true

							break
						end
					end

					if not v136 then
						u137 = false
					end

					if u137 then
						u32 = "B"

						break
					end
				end
			end
		end

		if not u32 then
			local matchSide: any = LocalPlayer:GetAttribute("MatchSide")

			if matchSide == "A" or matchSide == "B" then
				u32 = matchSide
			end
		end

		for _, v in ipairs(items) do
			if typeof(v) == "table" and typeof(v.name) == "string" then
				local v143 = t1[v.name]

				if v143 then
					paintVotesForCard(v143, v)
				end
			end
		end

		return
	end
end
local function onMapVoteEnd(p23)
	serverEndTime = nil

	if connection then
		connection:Disconnect()
		connection = nil
	end

	timer.Text = ""
	u28 = nil
	u32 = nil

	if p23 and p23.aborted == true then
		mapSelect.Visible = false

		local CurrentCamera: Camera = workspace.CurrentCamera

		v16.Enabled = true
		windowBlur.hide("MapVote")
		CurrentCamera.CameraType = Enum.CameraType.Custom
		CurrentCamera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
		clearContainer()
		_G.Notify({
			notifType = "FailNotification",
			errorMessage = "The enemy team left! Match aborted."
		})

		return
	end

	LocalPlayer:SetAttribute("VoteToMatchTransition", true)
	mapSelect.Visible = false

	local CurrentCamera: Camera = workspace.CurrentCamera

	v16.Enabled = false
	windowBlur.hide("MapVote")
	clearContainer()
	task.spawn(function()
		LocalPlayer:GetAttributeChangedSignal("VoteToMatchTransition"):Wait()
		mapSelect.Visible = false

		local CurrentCamera2: Camera = workspace.CurrentCamera

		v16.Enabled = true
		windowBlur.hide("MapVote")
		CurrentCamera2.CameraType = Enum.CameraType.Custom
		CurrentCamera2.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
	end)
end

mapSelect.Visible = false

local CurrentCamera: Camera = workspace.CurrentCamera

v16.Enabled = true
windowBlur.hide("MapVote")
CurrentCamera.CameraType = Enum.CameraType.Custom
CurrentCamera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
windowBlur.hide("MapVote")
v5.OnClientEvent:Connect(function(p24, p25)
	if typeof(p25) == "table" then
		local t = p25.t

		if t == "MapVoteStart" then
			onMapVoteStart(p24, p25)
		elseif t == "MapVoteUpdate" then
			onMapVoteUpdate(p25)
		elseif t == "MapVoteEnd" then
			onMapVoteEnd(p25)
		end

		return
	end
end)
