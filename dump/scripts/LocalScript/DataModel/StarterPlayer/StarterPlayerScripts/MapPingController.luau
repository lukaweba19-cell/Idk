-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local userInputService: UserInputService = game:GetService("UserInputService")
local tweenService: TweenService = game:GetService("TweenService")
local runService: RunService = game:GetService("RunService")
local soundService: SoundService = game:GetService("SoundService")
local LocalPlayer: Player = players.LocalPlayer
local sound = require(replicatedStorage:WaitForChild("Sound"))
local extensions: Instance = replicatedStorage:WaitForChild("Extensions")
local inputMap = require(extensions:WaitForChild("InputMap"))
local mapPing: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("MapPing")
local mapPing_Pin: Instance = replicatedStorage:WaitForChild("FX"):WaitForChild("MapPing_Pin")
local uiAspectRatioConstraint: Instance = mapPing_Pin:FindFirstChildOfClass("UIAspectRatioConstraint")
local squareRoot = math.sqrt(((if uiAspectRatioConstraint then uiAspectRatioConstraint.AspectRatio else 0.77) / 2) ^ 2 + 1)

local function ensurePingsFolder()
	local bin = workspace:FindFirstChild("Bin")

	if not bin then
		local bin2: Folder = Instance.new("Folder")

		bin2.Name = "Bin"
		bin2.Parent = workspace
		bin = bin2
	end

	local mapPings = bin:FindFirstChild("MapPings")

	if mapPings and mapPings:IsA("Folder") then
		return mapPings
	end

	local mapPings: Folder = Instance.new("Folder")

	mapPings.Name = "MapPings"
	mapPings.Parent = bin

	return mapPings
end

local v16 = (function()
	local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui")
	local mapPingGui: Instance = playerGui:FindFirstChild("MapPingGui")

	if mapPingGui and mapPingGui:IsA("ScreenGui") then
		mapPingGui.ResetOnSpawn = false
		mapPingGui.IgnoreGuiInset = true
		mapPingGui.DisplayOrder = -5
		mapPingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

		return mapPingGui
	end

	local mapPingGui: ScreenGui = Instance.new("ScreenGui")

	mapPingGui.Name = "MapPingGui"
	mapPingGui.IgnoreGuiInset = true
	mapPingGui.ResetOnSpawn = false
	mapPingGui.DisplayOrder = -5
	mapPingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	mapPingGui.Parent = playerGui

	return mapPingGui
end)()

local t1: {[any]: any} = { tokens = 5, lastRegen = os.clock() }

local function canFire()
	local v36 = os.clock()

	t1.tokens = math.min(5, t1.tokens + (v36 - t1.lastRegen) * 1.3333333333333333)
	t1.lastRegen = v36

	if t1.tokens >= 1 then
		local v37: {[any]: any} = t1

		v37.tokens = v37.tokens - 1

		return true
	end

	return false
end
local function isInMatch()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")

	if typeof(matchId) ~= "string" or matchId == "" then
		return false
	end

	if matchId == "PRACTICE" then
		return false
	end

	return true
end
local function getOwnedCharacters(player)
	local t3: {[any]: any} = {}

	if player.Character then
		table.insert(t3, player.Character)
	end

	local characters: Instance = workspace:FindFirstChild("Characters")

	if characters then
		for _, v in ipairs(characters:GetChildren()) do
			if v:IsA("Model") and typeof((v:GetAttribute("DecoyOwnerUserId"))) == "number" and v:GetAttribute("DecoyOwnerUserId") == player.UserId then
				table.insert(t3, v)
			end
		end
	end

	return t3
end
local function buildIgnore()
	local t4: {[any]: any} = {}
	local bin: Instance = workspace:FindFirstChild("Bin")

	if bin then
		table.insert(t4, bin)
	end

	local v46 = getOwnedCharacters(LocalPlayer)

	for _, v in ipairs(v46) do
		table.insert(t4, v)
	end

	local localPlayerTeam: Team = LocalPlayer.Team

	if localPlayerTeam then
		for _, v in ipairs(players:GetPlayers()) do
			if v ~= LocalPlayer and localPlayerTeam == v.Team then
				local v52 = getOwnedCharacters(v)

				for _, iterValue in ipairs(v52) do
					table.insert(t4, iterValue)
				end
			end
		end
	end

	return t4
end
local function castFromMouse()
	local CurrentCamera: Camera = workspace.CurrentCamera

	if not CurrentCamera then
		return nil, nil
	end

	local v56: Vector2 = userInputService:GetMouseLocation()
	local v57 = CurrentCamera:ViewportPointToRay(v56.X, v56.Y, 0)
	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = buildIgnore()
	raycastParams.IgnoreWater = true

	local v59 = workspace:Raycast(v57.Origin, v57.Direction * 1000, raycastParams)

	if not v59 then
		return nil, nil
	end

	v57 = v59.Instance:FindFirstAncestorOfClass("Model")

	if v57 then
		local characters: Instance = workspace:FindFirstChild("Characters")
		local u61: boolean = false

		if characters and characters == v57.Parent then
			u61 = true
		end

		if not u61 then
			u61 = players:GetPlayerFromCharacter(v57) ~= nil
		end

		local v62 = u61 and v57:FindFirstChild("HumanoidRootPart")

		if v62 and v62:IsA("BasePart") then
			local player: Player = players:GetPlayerFromCharacter(v57)
			local v64 = if player then player.UserId else nil

			if not v64 then
				local decoyOwnerUserId = v57:GetAttribute("DecoyOwnerUserId")

				if typeof(decoyOwnerUserId) == "number" then
					v64 = decoyOwnerUserId
				end
			end

			return v62.Position, v64
		end

		return v59.Position, nil
	end

	return v59.Position, nil
end

local t2: {[any]: any} = {}

local function clearPing(p2)
	local v67 = t2[p2]

	if not v67 then
		return
	end

	t2[p2] = nil

	if v67.expireTask then
		pcall(task.cancel, v67.expireTask)
	end

	if v67.attachment then
		v67.attachment:Destroy()
	end

	if v67.group then
		v67.group:Destroy()
	end
end
local function buildPingFrame(p3)
	local canvasGroup: CanvasGroup = Instance.new("CanvasGroup")

	canvasGroup.Name = "MapPing_" .. tostring(p3)
	canvasGroup.BackgroundTransparency = 1
	canvasGroup.BorderSizePixel = 0
	canvasGroup.AnchorPoint = Vector2.new(0.5, 1)
	canvasGroup.Rotation = 0
	canvasGroup.GroupTransparency = 0
	canvasGroup.Parent = v16

	local clone: Instance = mapPing_Pin:Clone()

	clone.AnchorPoint = Vector2.new(0.5, 1)
	clone.Position = UDim2.fromScale(0.5, 1)
	clone.Size = UDim2.fromScale(1, 1)
	clone.Rotation = 0
	clone.Parent = canvasGroup

	local headshot: Instance = clone:FindFirstChild("Headshot")

	if headshot and headshot:IsA("ImageLabel") then
		headshot.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(p3) .. "&w=150&h=150"
	end

	return canvasGroup
end
local function computeBillboardPixelSize(p4, p5)
	local v74 = math.rad(p4.FieldOfView)
	local y = p4.ViewportSize.Y
	local v76 = math.tan(v74 / 2)
	local v77 = math.max(p5, 0.001)

	return (math.clamp(y / (v76 * 2) * 4 / v77, 0.026 * y, 0.13 * y))
end
local function updatePing(p6)
	local CurrentCamera: Camera = workspace.CurrentCamera

	if not CurrentCamera then
		return
	end

	if not p6.group.Parent then
		return
	end

	local n1 = p6.worldPos + Vector3.new(0, 0.5, 0)
	local v81, v82 = CurrentCamera:WorldToViewportPoint(n1)
	local currentCameraViewportSize: Vector2 = CurrentCamera.ViewportSize
	local magnitude = (n1 - CurrentCamera.CFrame.Position).Magnitude
	local v85 = math.rad(CurrentCamera.FieldOfView)
	local y = CurrentCamera.ViewportSize.Y
	local v87 = math.tan(v85 / 2)
	local v88 = math.max(magnitude, 0.001)

	n1 = math.clamp(y / (v87 * 2) * 4 / v88, 0.026 * y, 0.13 * y)

	local n2 = os.clock() - p6.startTime

	v85 = if n2 >= 0.25 then 1 else tweenService:GetValue(n2 / 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	n2 = n1 * v85
	p6.group.Size = UDim2.fromOffset(n2, n2)
	v85 = n1 / 2 + 12
	n2 = 12 + n1 * squareRoot

	local n3 = currentCameraViewportSize.X / 2
	local n4 = currentCameraViewportSize.Y / 2
	local v92 = v81.X
	local v93 = v81.Y

	if v81.Z < 0 then
		v92 = 2 * n3 - v92
		v93 = 2 * n4 - v93
	end

	n1 = true

	if not (v81.Z < 0) then
		n1 = true

		if not (v85 > v92) then
			n1 = true

			if not (v92 > currentCameraViewportSize.X - v85) then
				n1 = true

				if not (v85 > v93) then
					n1 = v93 > currentCameraViewportSize.Y - v85
				end
			end
		end
	end

	if n1 then
		local n5 = v92 - n3
		local n6 = v93 - n4

		if math.abs(n5) < 0.001 and math.abs(n6) < 0.001 then
			n5 = 0
			n6 = 1
		end

		local v96 = math.max(1, n3 - n2)
		local v97 = math.max(1, n4 - n2)
		local absoluteValue = math.abs(n5)
		local v99 = math.max(absoluteValue, 0.001)
		local absoluteValue2 = math.abs(n6)
		local v101 = math.max(absoluteValue2, 0.001)
		local v102 = math.min(v96 / v99, v97 / v101)

		v92 = n3 + n5 * v102
		v93 = n4 + n6 * v102

		local group = p6.group

		v101 = math.atan2(n6, n5)
		group.Rotation = math.deg(v101) - 90
	else
		p6.group.Rotation = 0
	end

	p6.group.Position = UDim2.fromOffset(v92, v93)
end

runService.RenderStepped:Connect(function()
	for _, v in pairs(t2) do
		updatePing(v)
	end
end)

local function renderPing(p7, worldPosition, _)
	local v109 = t2[p7]

	if v109 then
		t2[p7] = nil

		if v109.expireTask then
			pcall(task.cancel, v109.expireTask)
		end

		if v109.attachment then
			v109.attachment:Destroy()
		end

		if v109.group then
			v109.group:Destroy()
		end
	end

	v109 = ensurePingsFolder()

	local attachment: Attachment = Instance.new("Attachment")

	attachment.Name = "MapPing_" .. tostring(p7)
	attachment.WorldPosition = worldPosition
	attachment.Parent = v109

	local v111 = buildPingFrame(p7)

	pcall(function()
		if p7 == LocalPlayer.UserId then
			sound:Play("UI.MapPing", soundService, nil, nil, 1)

			return
		end

		sound:Play("UI.MapPing", attachment, 50, nil, 0.6)
	end)

	local v112 = os.clock()
	local t5: {[any]: any} = {
		expireTask = nil,
		attachment = attachment,
		group = v111,
		worldPos = worldPosition,
		startTime = v112
	}

	t2[p7] = t5
	updatePing(t5)
	t5.expireTask = task.delay(3.85, function()
		v111.GroupTransparency = 0

		local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		tweenService:Create(v111, tweenInfo, { GroupTransparency = 1 }):Play()
		task.wait(0.15)

		local v126 = p7
		local v127 = t2[v126]

		if not v127 then
			return
		end

		t2[v126] = nil

		if v127.expireTask then
			pcall(task.cancel, v127.expireTask)
		end

		if v127.attachment then
			v127.attachment:Destroy()
		end

		if v127.group then
			v127.group:Destroy()
		end
	end)
end

userInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	if gameProcessedEvent then
		return
	end

	if not inputMap.matches("Ping", input) then
		return
	end

	local matchId: any = LocalPlayer:GetAttribute("MatchId")

	if not (if typeof(matchId) == "string" and matchId ~= "" then matchId ~= "PRACTICE" else false) then
		return
	end

	local v117 = os.clock()

	t1.tokens = math.min(5, t1.tokens + (v117 - t1.lastRegen) * 1.3333333333333333)
	t1.lastRegen = v117

	local u118

	if t1.tokens >= 1 then
		local v119: {[any]: any} = t1

		v119.tokens = v119.tokens - 1
		u118 = true
	else
		u118 = false
	end

	if not u118 then
		return
	end

	local v120, v121 = castFromMouse()

	if not v120 then
		return
	end

	renderPing(LocalPlayer.UserId, v120, v121)
	mapPing:FireServer(v120, v121)
end)
mapPing.OnClientEvent:Connect(function(p12, p13, p14)
	if typeof(p12) == "number" then
		if typeof(p13) == "Vector3" then
			if p14 ~= nil and typeof(p14) ~= "number" then
				return
			end

			if p12 == LocalPlayer.UserId then
				return
			end

			renderPing(p12, p13, p14)

			return
		end

		return
	end
end)
