-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local httpService: HttpService = game:GetService("HttpService")
local tweenService: TweenService = game:GetService("TweenService")
local runService: RunService = game:GetService("RunService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer: Player = players.LocalPlayer
local duelStations: Instance = workspace:WaitForChild("DuelStations")
local sound = require(game.ReplicatedStorage.Sound)

local function isSmallScreen()
	local CurrentCamera: Camera = workspace.CurrentCamera

	if not CurrentCamera then
		return false
	end

	local currentCameraViewportSize: Vector2 = CurrentCamera.ViewportSize

	return math.min(currentCameraViewportSize.X, currentCameraViewportSize.Y) <= 500
end

local CurrentCamera: Camera = workspace.CurrentCamera
local u11

if not CurrentCamera then
	u11 = false
else
	local currentCameraViewportSize: Vector2 = CurrentCamera.ViewportSize

	u11 = math.min(currentCameraViewportSize.X, currentCameraViewportSize.Y) <= 500
end

local n1: number = if u11 then 2 else 3
local t1: {[any]: any} = {}

local function MAX_VISIBLE_CARDS()
	return (math.max(0, n1 - #t1))
end
local function getMatchContainer()
	return (LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD"):WaitForChild("MatchContainer"))
end

local matchContainer: Instance = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD"):WaitForChild("MatchContainer")
local matchTemplate: Instance = matchContainer:WaitForChild("MatchTemplate")

matchTemplate.Visible = false

local team1: Instance = matchTemplate:WaitForChild("Team1")
local team2: Instance = matchTemplate:WaitForChild("Team2")
local playerTemplate: Instance = team1:WaitForChild("PlayerTemplate")

playerTemplate.Visible = false

local waitingForPlayerTemplate: Instance = team2:WaitForChild("WaitingForPlayerTemplate")

waitingForPlayerTemplate.Visible = false

local t2: {[any]: any} = {}

local function startSpinner(p1)
	if t2[p1] then
		return
	end

	p1.Visible = true
	p1.Rotation = 0
	t2[p1] = runService.Heartbeat:Connect(function(deltaTime: number)
		p1.Rotation = (p1.Rotation + deltaTime * 360) % 360
	end)
end
local function stopSpinner(p3)
	local v103 = t2[p3]

	if v103 then
		v103:Disconnect()
		t2[p3] = nil
	end
end
local function parseMode(p4)
	local v105 = (p4:match("^([^_]+)") or p4):match("^(%d+)v%d+$")

	return tonumber(v105) or 1
end
local function decodeIds(p5)
	if typeof(p5) == "string" and p5 ~= "" then
		local ok, result = pcall(function()
			return httpService:JSONDecode(p5)
		end)

		if ok and typeof(result) == "table" then
			local t10: {[any]: any} = {}

			for _, v in ipairs(result) do
				if typeof(v) == "number" then
					local floored = math.floor(v)

					table.insert(t10, floored)
				end
			end

			return t10
		end

		return {}
	end

	return {}
end
local function containsId(p6, p7)
	for _, v in ipairs(p6) do
		if v == p7 then
			return true
		end
	end

	return false
end
local function findDeep(p8, p9, p10)
	local foundChild = p8:FindFirstChild(p9, true)

	if foundChild and p10 == foundChild.ClassName then
		return foundChild
	end

	return nil
end
local function teleportLocalToStation(p11)
	local pad1 = p11:FindFirstChild("Pad1")
	local pad2 = p11:FindFirstChild("Pad2")

	if not pad1 or not pad1:IsA("BasePart") then
		return
	end

	if not pad2 or not pad2:IsA("BasePart") then
		return
	end

	local Character: Model = LocalPlayer.Character

	if not Character then
		return
	end

	if not Character:FindFirstChild("HumanoidRootPart") then
		return
	end

	local n1 = pad1.CFrame.RightVector * -1
	local n2 = (pad1.Position + pad2.Position) * 0.5 + n1 * 7.5
	local cFrame = CFrame.new(n2, n2 - n1)

	Character:PivotTo(cFrame + Vector3.new(0, 2.5, 0))
end
local function clearSlots(p12)
	for _, v in ipairs(p12:GetChildren()) do
		if v:IsA("ImageButton") and v.Name == "PlayerSlot" then
			local loading = v:FindFirstChild("Loading")

			if loading then
				local v132 = t2[loading]

				if v132 then
					v132:Disconnect()
					t2[loading] = nil
				end
			end

			v:Destroy()
		end
	end
end
local function renderTeam(parent, p14, p15)
	clearSlots(parent)

	for i = 1, p15 do
		local v137 = p14[i]
		local v138 = v137 and v137 > 0
		local clone = (v138 and playerTemplate or waitingForPlayerTemplate):Clone()

		clone.Name = "PlayerSlot"
		clone.Visible = true
		clone.Parent = parent

		if v138 then
			local headshot = clone:FindFirstChild("Headshot")
			local loading = clone:FindFirstChild("Loading")

			if headshot then
				headshot.Visible = true

				local v142 = v137

				if v142 < 0 then
					v142 = 1
				end

				headshot.Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420"):format(v142)
			end

			if loading then
				loading.Visible = false
			end
		else
			local headshot = clone:FindFirstChild("Headshot")
			local loading = clone:FindFirstChild("Loading")

			if headshot then
				headshot.Visible = false
			end

			if loading and not t2[loading] then
				loading.Visible = true
				loading.Rotation = 0
				t2[loading] = runService.Heartbeat:Connect(function(deltaTime: number)
					loading.Rotation = (loading.Rotation + deltaTime * 360) % 360
				end)
			end
		end
	end
end
local function shouldSuppressContainer()
	if LocalPlayer:GetAttribute("MatchId") == nil then
		local spectating: any = LocalPlayer:GetAttribute("Spectating")

		if typeof(spectating) == "number" and spectating ~= 0 then
			return true
		end

		return false
	end

	return true
end
local function setJoinVisible(p17, visible)
	local foundChild = p17:FindFirstChild("JoinBtn", true)
	local v149 = if foundChild and foundChild.ClassName == "TextButton" then foundChild else nil

	if v149 then
		v149.Visible = visible
	end
end
local function applyContainerVisibility()
	if #t1 > 0 then
		matchContainer.Visible = true

		return
	end

	local u150

	if LocalPlayer:GetAttribute("MatchId") == nil then
		local spectating: any = LocalPlayer:GetAttribute("Spectating")

		u150 = typeof(spectating) == "number" and spectating ~= 0
	else
		u150 = true
	end

	matchContainer.Visible = not u150
end

local t3: {[any]: any} = {}
local t4: {[any]: any} = {}

local function cancelPendingShow(p19)
	t4[p19] = nil
end
local function playPopInTween(parent)
	local popInScale = parent:FindFirstChild("PopInScale")

	if popInScale then
		popInScale:Destroy()
	end

	local popInScale: UIScale = Instance.new("UIScale")

	popInScale.Name = "PopInScale"
	popInScale.Scale = 0.85
	popInScale.Parent = parent

	local tweenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local v157: Tween = tweenService:Create(popInScale, tweenInfo, { Scale = 1 })

	v157:Play()
	v157.Completed:Connect(function()
		if popInScale.Parent then
			popInScale:Destroy()
		end
	end)
end
local function setCardVisible(p21, p22)
	p21.Card.Visible = p22

	if p22 and not p21.HasAnimatedIn then
		p21.HasAnimatedIn = true
		playPopInTween(p21.Card)
	end
end

local t5: {[any]: any} = {}
local t6: {[any]: any} = {}

local function removeFromList(p23, p24)
	for i, v in ipairs(p23) do
		if v == p24 then
			table.remove(p23, i)

			return true
		end
	end

	return false
end
local function isInList(p25, p26)
	for _, v in ipairs(p25) do
		if v == p26 then
			return true
		end
	end

	return false
end
local function promoteFromQueue()
	while true do
		local v168 = math.max(0, n1 - #t1)

		if not (#t5 < v168) or not (#t6 > 0) then
			break
		end

		local v169 = table.remove(t6, 1)

		table.insert(t5, v169)
		v168 = t3[v169]

		if v168 and v168.Card then
			local v170 = decodeIds(v169:GetAttribute("QueueA"))
			local v171 = decodeIds(v169:GetAttribute("QueueB"))
			local localPlayerUserId = LocalPlayer.UserId
			local v173, v174, v175 = ipairs(v170)
			local v176: boolean = false
			local u177

			for iterFirst, iterSecond in v173, v174, v175 do
				if iterSecond == localPlayerUserId then
					u177 = true
					v176 = true

					break
				end
			end

			if not v176 then
				u177 = false
			end

			if not u177 then
				local userId = LocalPlayer.UserId
				local v181, v182, v183 = ipairs(v171)
				local v184: boolean = false

				for iterFirst2, iterSecond2 in v181, v182, v183 do
					if iterSecond2 == userId then
						u177 = true
						v184 = true

						break
					end
				end

				if not v184 then
					u177 = false
				end
			end

			local u187: boolean = not u177

			v168.Card.Visible = u187

			if u187 and not v168.HasAnimatedIn then
				v168.HasAnimatedIn = true
				playPopInTween(v168.Card)
			end
		end
	end
end
local function destroyCard(p27)
	t4[p27] = nil

	local v189 = t3[p27]

	removeFromList(t5, p27)
	removeFromList(t6, p27)

	if not v189 then
		promoteFromQueue()

		return
	end

	if v189.JoinConn then
		v189.JoinConn:Disconnect()
	end

	if v189.Card then
		for _, v in ipairs(v189.Card:GetDescendants()) do
			if v:IsA("ImageLabel") and v.Name == "Loading" then
				local v192 = t2[v]

				if v192 then
					v192:Disconnect()
					t2[v] = nil
				end
			end
		end

		v189.Card:Destroy()
	end

	t3[p27] = nil
	promoteFromQueue()
end
local function getOrCreateCard(p28)
	local v194 = t3[p28]

	if v194 and v194.Card and v194.Card.Parent then
		return v194
	end

	local clone: Instance = matchTemplate:Clone()

	clone.Name = "Match_" .. p28.Name
	clone.Parent = matchContainer

	local team1: Instance = clone:FindFirstChild("Team1")
	local team2: Instance = clone:FindFirstChild("Team2")

	if team1 then
		local playerTemplate: Instance = team1:FindFirstChild("PlayerTemplate")

		if playerTemplate then
			playerTemplate.Visible = false
		end
	end

	if team2 then
		local waitingForPlayerTemplate: Instance = team2:FindFirstChild("WaitingForPlayerTemplate")

		if waitingForPlayerTemplate then
			waitingForPlayerTemplate.Visible = false
		end
	end

	local foundChild: Instance = clone:FindFirstChild("JoinBtn", true)
	local v201 = if foundChild and foundChild.ClassName == "TextButton" then foundChild else nil
	local connection = nil

	if v201 then
		connection = v201.MouseButton1Click:Connect(function()
			local u452

			if LocalPlayer:GetAttribute("MatchId") == nil then
				local spectating: any = LocalPlayer:GetAttribute("Spectating")

				u452 = typeof(spectating) == "number" and spectating ~= 0
			else
				u452 = true
			end

			if u452 then
				return
			end

			teleportLocalToStation(p28)
		end)
	end

	v201 = {
		HasAnimatedIn = false,
		Card = clone,
		Station = p28,
		JoinConn = connection
	}
	t3[p28] = v201

	local v203, v204, v205 = ipairs(t5)
	local v206: boolean = false
	local u207

	for iterFirst, iterSecond in v203, v204, v205 do
		if iterSecond == p28 then
			u207 = true
			v206 = true

			break
		end
	end

	if not v206 then
		u207 = false
	end

	if not u207 then
		local v210, v211, v212 = ipairs(t6)
		local v213: boolean = false

		for iterFirst2, iterSecond2 in v210, v211, v212 do
			if iterSecond2 == p28 then
				u207 = true
				v213 = true

				break
			end
		end

		if not v213 then
			u207 = false
		end
	end

	if not u207 then
		local v216 = math.max(0, n1 - #t1)

		if not (#t5 < v216) then
			table.insert(t6, p28)
			v201.Card.Visible = false

			return v201
		end

		table.insert(t5, p28)
		v201.Card.Visible = true

		if not v201.HasAnimatedIn then
			v201.HasAnimatedIn = true
			playPopInTween(v201.Card)

			return v201
		end
	else
		local v217, v218, v219 = ipairs(t5)
		local v220: boolean = false
		local u221

		for iterFirst3, iterSecond3 in v217, v218, v219 do
			if iterSecond3 == p28 then
				u221 = true
				v220 = true

				break
			end
		end

		if not v220 then
			u221 = false
		end

		v201.Card.Visible = u221

		if u221 and not v201.HasAnimatedIn then
			v201.HasAnimatedIn = true
			playPopInTween(v201.Card)
		end
	end

	return v201
end
local function renderStation(p29, p30)
	local u226

	if LocalPlayer:GetAttribute("MatchId") == nil then
		local spectating: any = LocalPlayer:GetAttribute("Spectating")

		u226 = typeof(spectating) == "number" and spectating ~= 0
	else
		u226 = true
	end

	if u226 then
		return
	end

	local teamSize = p29:GetAttribute("TeamSize")
	local v229 = typeof(teamSize) == "number" and teamSize > 0 and math.max(1, (math.floor(teamSize)))

	if not v229 then
		local v230 = p29.Name
		local v231 = (v230:match("^([^_]+)") or v230):match("^(%d+)v%d+$")

		v229 = tonumber(v231) or 1
	end

	local n1 = v229 * 2
	local v233 = decodeIds(p29:GetAttribute("QueueA"))
	local v234 = decodeIds(p29:GetAttribute("QueueB"))
	local n2: number = #v233 + #v234

	if n2 == 0 or n1 <= n2 then
		destroyCard(p29)

		return
	end

	if t3[p29] or p30 then
		t4[p29] = nil

		local v236 = getOrCreateCard(p29)
		local card = v236.Card
		local localPlayerUserId = LocalPlayer.UserId
		local v239, v240, v241 = ipairs(v233)
		local v242: boolean = false
		local u243

		for iterFirst, iterSecond in v239, v240, v241 do
			if iterSecond == localPlayerUserId then
				u243 = true
				v242 = true

				break
			end
		end

		if not v242 then
			u243 = false
		end

		if not u243 then
			local userId = LocalPlayer.UserId
			local v247, v248, v249 = ipairs(v234)
			local v250: boolean = false

			for iterFirst2, iterSecond2 in v247, v248, v249 do
				if iterSecond2 == userId then
					u243 = true
					v250 = true

					break
				end
			end

			if not v250 then
				u243 = false
			end
		end

		local v253, v254, v255 = ipairs(t5)
		local v256: boolean = false
		local u257

		for iterFirst3, iterSecond3 in v253, v254, v255 do
			if iterSecond3 == p29 then
				u257 = true
				v256 = true

				break
			end
		end

		if not v256 then
			u257 = false
		end

		local u260 = u257 and not u243

		v236.Card.Visible = u260

		if u260 and not v236.HasAnimatedIn then
			v236.HasAnimatedIn = true
			playPopInTween(v236.Card)
		end

		local foundChild = card:FindFirstChild("DuelType", true)
		local v262 = if foundChild and foundChild.ClassName == "TextLabel" then foundChild else nil

		if v262 then
			v262.Text = ("%dv%d"):format(v229, v229)
		end

		local foundChild2 = card:FindFirstChild("ParticipantCount", true)

		v262 = if foundChild2 and foundChild2.ClassName == "TextLabel" then foundChild2 else nil

		if v262 then
			v262.Text = ("%d/%d"):format(n2, n1)
		end

		local foundChild3 = card:FindFirstChild("Team1", true)

		v262 = if foundChild3 and foundChild3.ClassName == "Frame" then foundChild3 else nil

		local foundChild4 = card:FindFirstChild("Team2", true)
		local v266 = if foundChild4 and foundChild4.ClassName == "Frame" then foundChild4 else nil

		if v262 and v266 then
			renderTeam(v262, v233, v229)
			renderTeam(v266, v234, v229)
		end

		local u267

		if LocalPlayer:GetAttribute("MatchId") == nil then
			local spectating: any = LocalPlayer:GetAttribute("Spectating")

			u267 = typeof(spectating) == "number" and spectating ~= 0
		else
			u267 = true
		end

		local foundChild5 = card:FindFirstChild("JoinBtn", true)
		local v270 = if foundChild5 and foundChild5.ClassName == "TextButton" then foundChild5 else nil

		if v270 then
			v270.Visible = not u267
		end

		return
	end

	if t4[p29] then
		return
	end

	local t11: {[any]: any} = {}

	t4[p29] = t11
	task.delay(1, function()
		if t4[p29] ~= t11 then
			return
		end

		t4[p29] = nil

		local u454

		if LocalPlayer:GetAttribute("MatchId") == nil then
			local spectating: any = LocalPlayer:GetAttribute("Spectating")

			u454 = typeof(spectating) == "number" and spectating ~= 0
		else
			u454 = true
		end

		if not u454 and p29.Parent ~= nil then
			renderStation(p29, true)

			return
		end
	end)
end
local function rerenderAll()
	local u272

	if LocalPlayer:GetAttribute("MatchId") == nil then
		local spectating: any = LocalPlayer:GetAttribute("Spectating")

		u272 = typeof(spectating) == "number" and spectating ~= 0
	else
		u272 = true
	end

	if u272 then
		return
	end

	for _, v in ipairs(duelStations:GetChildren()) do
		if v:IsA("Folder") or v:IsA("Model") then
			renderStation(v)
		end
	end
end
local function hookStation(p31)
	renderStation(p31)
	p31:GetAttributeChangedSignal("QueueA"):Connect(function()
		renderStation(p31)
	end)
	p31:GetAttributeChangedSignal("QueueB"):Connect(function()
		renderStation(p31)
	end)
	p31:GetAttributeChangedSignal("TeamSize"):Connect(function()
		renderStation(p31)
	end)
end

for _, v in ipairs(duelStations:GetChildren()) do
	if v:IsA("Model") then
		hookStation(v)
	end
end

duelStations.ChildAdded:Connect(function(p32: Instance)
	if p32:IsA("Model") then
		if p32.ModelStreamingMode ~= Enum.ModelStreamingMode.Persistent then
			warn("FIX THIS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		end

		task.spawn(function()
			hookStation(p32)
		end)
	end
end)

local function onSuppressionChange()
	if #t1 > 0 then
		matchContainer.Visible = true
	else
		local u278

		if LocalPlayer:GetAttribute("MatchId") == nil then
			local spectating: any = LocalPlayer:GetAttribute("Spectating")

			u278 = typeof(spectating) == "number" and spectating ~= 0
		else
			u278 = true
		end

		matchContainer.Visible = not u278
	end

	rerenderAll()
end

LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(onSuppressionChange)
LocalPlayer:GetAttributeChangedSignal("Spectating"):Connect(onSuppressionChange)
LocalPlayer.CharacterAdded:Connect(function()
	rerenderAll()
end)

if #t1 > 0 then
	matchContainer.Visible = true
else
	local u54

	if LocalPlayer:GetAttribute("MatchId") == nil then
		local spectating: any = LocalPlayer:GetAttribute("Spectating")

		u54 = typeof(spectating) == "number" and spectating ~= 0
	else
		u54 = true
	end

	matchContainer.Visible = not u54
end

rerenderAll()

local color3 = Color3.fromRGB(52, 188, 65)
local color32 = Color3.fromRGB(70, 255, 90)
local color33 = Color3.fromRGB(40, 127, 71)
local color34 = Color3.fromRGB(208, 57, 57)
local color35 = Color3.fromRGB(255, 70, 70)
local color36 = Color3.fromRGB(127, 40, 48)

local function isLocalOnPad(p33)
	local Character: Model = LocalPlayer.Character

	if not Character then
		return false
	end

	local humanoidRootPart: Instance = Character:FindFirstChild("HumanoidRootPart")

	if not humanoidRootPart then
		return false
	end

	local v283 = p33.CFrame:PointToObjectSpace(humanoidRootPart.Position)
	local n1 = p33.Size.X * 0.5 + 0.5
	local n2 = p33.Size.Z * 0.5 + 0.5
	local absoluteValue = math.abs(v283.X)

	if n1 < absoluteValue then
		return false
	end

	if n2 < math.abs(v283.Z) then
		return false
	end

	return v283.Y >= -6 and p33.Size.Y * 0.5 + 25 >= v283.Y
end

local t7: {[any]: any} = {}

local function occupiedFor(p34, p35)
	local n1: number = #p35
	local localPlayerUserId = LocalPlayer.UserId
	local v291, v292, v293 = ipairs(p35)
	local v294: boolean = false
	local u295

	for iterFirst, iterSecond in v291, v292, v293 do
		if iterSecond == localPlayerUserId then
			u295 = true
			v294 = true

			break
		end
	end

	if not v294 then
		u295 = false
	end

	if u295 then
		if isLocalOnPad(p34.Pad) then
			return true
		end

		n1 -= 1

		return n1 > 0
	end

	return n1 > 0
end
local function baseColorOf(p36, p37)
	local baseColor = p36:GetAttribute("BaseColor")

	if typeof(baseColor) == "Color3" then
		return baseColor
	end

	return p37
end
local function buildSide(p38)
	local inner = p38:FindFirstChild("Inner")

	if inner and not inner:IsA("BasePart") then
		inner = nil
	end

	local spinMesh = p38:FindFirstChild("SpinMesh")

	if spinMesh and not spinMesh:IsA("BasePart") then
		spinMesh = nil
	end

	local t12: {[any]: any} = {}
	local beams = p38:FindFirstChild("Beams")

	if beams then
		for _, v in ipairs(beams:GetDescendants()) do
			if v:IsA("Beam") then
				table.insert(t12, v)
			end
		end
	end

	local t13: {[any]: any} = {}
	local t14: {[any]: any} = {}

	for i, v in ipairs(t12) do
		local v312 = v.Color.Keypoints[1].Value
		local baseColor = v:GetAttribute("BaseColor")

		t13[i] = if typeof(baseColor) == "Color3" then baseColor else v312
		t14[i] = t13[i]
	end

	local v314 = p38.Color
	local baseColor2 = p38:GetAttribute("BaseColor")
	local v316 = if typeof(baseColor2) == "Color3" then baseColor2 else v314
	local v317

	if inner then
		local innerColor = inner.Color
		local baseColor3 = inner:GetAttribute("BaseColor")

		v317 = if typeof(baseColor3) == "Color3" then baseColor3 else innerColor
	else
		v317 = nil
	end

	local v320

	if spinMesh then
		local spinMeshColor = spinMesh.Color
		local baseColor4 = spinMesh:GetAttribute("BaseColor")

		v320 = if typeof(baseColor4) == "Color3" then baseColor4 else spinMeshColor
	else
		v320 = nil
	end

	return {
		SpinAngle = 0,
		Occupied = false,
		Mode = "off",
		Alpha = 1,
		Stepped = false,
		Pad = p38,
		Inner = inner,
		Spin = spinMesh,
		Beams = t12,
		PadBase = v316,
		InnerBase = v317,
		SpinBase = v320,
		BeamBase = t13,
		SpinCFrame = if spinMesh then spinMesh.CFrame else nil,
		FromPad = v316,
		FromInner = v317 or v316,
		FromSpin = v320 or v316,
		FromBeam = t14
	}
end
local function targetsFor(p39, p40)
	if p40 == "green" then
		return color3, color3, color33, color32
	end

	if p40 == "red" then
		return color34, color34, color36, color35
	end

	return p39.PadBase, p39.InnerBase or p39.PadBase, p39.SpinBase or p39.PadBase, nil
end
local function setMode(p41, mode)
	if mode == p41.Mode then
		return
	end

	p41.Mode = mode
	p41.Alpha = 0
	p41.FromPad = p41.Pad.Color

	if p41.Inner then
		p41.FromInner = p41.Inner.Color
	end

	if p41.Spin then
		p41.FromSpin = p41.Spin.Color
	end

	for i, v in ipairs(p41.Beams) do
		p41.FromBeam[i] = v.Color.Keypoints[1].Value
	end
end
local function stepSide(p43, p44)
	if p43.Alpha < 1 then
		p43.Alpha = math.min(p43.Alpha + p44 / 0.05, 1)

		local alpha = p43.Alpha
		local mode = p43.Mode
		local v333
		local v334
		local v335
		local v336

		if mode == "green" then
			v333 = color3
			v334 = color3
			v335 = color33
			v336 = color32
		elseif mode == "red" then
			v333 = color34
			v334 = color34
			v335 = color36
			v336 = color35
		else
			v333 = p43.PadBase
			v334 = p43.InnerBase or p43.PadBase
			v335 = p43.SpinBase or p43.PadBase
			v336 = nil
		end

		if alpha >= 1 then
			p43.Pad.Color = v333

			if p43.Inner then
				p43.Inner.Color = v334
			end

			if p43.Spin then
				p43.Spin.Color = v335
			end

			for i, v in ipairs(p43.Beams) do
				v.Color = ColorSequence.new(v336 or p43.BeamBase[i])
			end
		else
			p43.Pad.Color = p43.FromPad:Lerp(v333, alpha)

			if p43.Inner then
				p43.Inner.Color = p43.FromInner:Lerp(v334, alpha)
			end

			if p43.Spin then
				p43.Spin.Color = p43.FromSpin:Lerp(v335, alpha)
			end

			for i, v in ipairs(p43.Beams) do
				v.Color = ColorSequence.new(p43.FromBeam[i]:Lerp(v336 or p43.BeamBase[i], alpha))
			end
		end
	end

	local spin = p43.Spin
	local spinCFrame = p43.SpinCFrame

	if p43.Occupied and spin and spinCFrame then
		p43.SpinAngle = (p43.SpinAngle + p44 * 1.5707963267948966) % 6.283185307179586

		local v343 = CFrame.Angles(0, p43.SpinAngle, 0)

		spin.CFrame = spinCFrame * v343
	end
end
local function setStepped(p45, stepped)
	if stepped == p45.Stepped then
		return
	end

	p45.Stepped = stepped
	sound:Play(if stepped then "Misc.PadStep" else "Misc.PadStepOff", p45.Pad)
end
local function hookPadFx(p47)
	local pad1 = p47:WaitForChild("Pad1", 30)
	local pad2 = p47:WaitForChild("Pad2", 30)

	if not pad1 or not pad1:IsA("BasePart") then
		return
	end

	if not pad2 or not pad2:IsA("BasePart") then
		return
	end

	local v349 = buildSide(pad1)
	local v350 = buildSide(pad2)

	t7[p47] = { Folder = p47, A = v349, B = v350 }
end

for _, v in ipairs(duelStations:GetChildren()) do
	if v:IsA("Folder") or v:IsA("Model") then
		task.spawn(function()
			hookPadFx(v)
		end)
	end
end

duelStations.ChildAdded:Connect(function(p48: Instance)
	if p48:IsA("Folder") or p48:IsA("Model") then
		task.defer(function()
			hookPadFx(p48)
		end)
	end
end)

local n2: number = 0

runService.RenderStepped:Connect(function(deltaTime: number)
	n2 += deltaTime

	local u353: boolean = n2 >= 0.05

	if u353 then
		n2 = 0
	end

	for k, v in pairs(t7) do
		local vA = v.A
		local vB = v.B

		if u353 then
			if k.Parent == nil then
				vA.Occupied = false
				vB.Occupied = false

				if vA.Stepped ~= false then
					vA.Stepped = false
					sound:Play("Misc.PadStepOff", vA.Pad)
				end

				if vB.Stepped ~= false then
					vB.Stepped = false
					sound:Play("Misc.PadStepOff", vB.Pad)
				end

				setMode(vA, "off")
				setMode(vB, "off")
			else
				local u358

				if LocalPlayer:GetAttribute("MatchId") == nil then
					local spectating: any = LocalPlayer:GetAttribute("Spectating")

					u358 = typeof(spectating) == "number" and spectating ~= 0
				else
					u358 = true
				end

				if u358 then
					vA.Occupied = false
					vB.Occupied = false

					if vA.Stepped ~= false then
						vA.Stepped = false
						sound:Play("Misc.PadStepOff", vA.Pad)
					end

					if vB.Stepped ~= false then
						vB.Stepped = false
						sound:Play("Misc.PadStepOff", vB.Pad)
					end

					setMode(vA, "off")
					setMode(vB, "off")
				else
					local v360 = decodeIds(k:GetAttribute("QueueA"))
					local v361 = decodeIds(k:GetAttribute("QueueB"))
					local n1: number = #v360
					local localPlayerUserId = LocalPlayer.UserId
					local v364, v365, v366 = ipairs(v360)
					local v367: boolean = false
					local u368

					for iterFirst, iterSecond in v364, v365, v366 do
						if iterSecond == localPlayerUserId then
							u368 = true
							v367 = true

							break
						end
					end

					if not v367 then
						u368 = false
					end

					local u371

					if not u368 then
						u371 = n1 > 0
					elseif isLocalOnPad(vA.Pad) then
						u371 = true
					else
						n1 -= 1
						u371 = n1 > 0
					end

					vA.Occupied = u371

					local n3: number = #v361
					local userId = LocalPlayer.UserId
					local v374, v375, v376 = ipairs(v361)
					local v377: boolean = false
					local u378

					for iterFirst2, iterSecond2 in v374, v375, v376 do
						if iterSecond2 == userId then
							u378 = true
							v377 = true

							break
						end
					end

					if not v377 then
						u378 = false
					end

					local u381

					if not u378 then
						u381 = n3 > 0
					elseif isLocalOnPad(vB.Pad) then
						u381 = true
					else
						n3 -= 1
						u381 = n3 > 0
					end

					vB.Occupied = u381

					local v382 = LocalPlayer.UserId
					local v383, v384, v385 = ipairs(v360)
					local v386: boolean = false
					local u387

					for iterFirst3, iterSecond3 in v383, v384, v385 do
						if iterSecond3 == v382 then
							u387 = true
							v386 = true

							break
						end
					end

					if not v386 then
						u387 = false
					end

					local v390

					if u387 then
						v390 = vA
					else
						local v391 = LocalPlayer.UserId
						local v392, v393, v394 = ipairs(v361)
						local v395: boolean = false
						local u396

						for iterFirst4, iterSecond4 in v392, v393, v394 do
							if iterSecond4 == v391 then
								u396 = true
								v395 = true

								break
							end
						end

						if not v395 then
							u396 = false
						end

						v390 = if u396 then vB else nil
					end

					local u399 = false

					if v390 ~= nil then
						u399 = isLocalOnPad(v390.Pad)
					end

					local u400 = false

					if v390 == vA then
						u400 = u399
					end

					if u400 ~= vA.Stepped then
						vA.Stepped = u400
						sound:Play(if u400 then "Misc.PadStep" else "Misc.PadStepOff", vA.Pad)
					end

					local u401 = false

					if v390 == vB then
						u401 = u399
					end

					if u401 ~= vB.Stepped then
						vB.Stepped = u401
						sound:Play(if u401 then "Misc.PadStep" else "Misc.PadStepOff", vB.Pad)
					end

					if u399 and v390 then
						local v402 = if v390 == vA then vB else vA

						setMode(v390, "green")
						setMode(v402, if v402.Occupied then "red" else "off")
					else
						setMode(vA, if vA.Occupied then "green" else "off")
						setMode(vB, if vB.Occupied then "green" else "off")
					end
				end
			end
		end

		stepSide(vA, deltaTime)
		stepSide(vB, deltaTime)
	end
end)

local shared: Instance = replicatedStorage:WaitForChild("Shared")
local gameFlags = require(shared:WaitForChild("GameFlags"))
local playerRequestNotify = replicatedStorage.Remotes:WaitForChild("PlayerRequestNotify")
local playerRequestRespond = replicatedStorage.Remotes:WaitForChild("PlayerRequestRespond")
local tradeRequestResolved: Instance = replicatedStorage:WaitForChild("Bindables"):WaitForChild("TradeRequestResolved")
local partyInvitation: Instance = matchContainer:WaitForChild("PartyInvitation")
local duelRequest: Instance = matchContainer:WaitForChild("DuelRequest")
local tradeRequest: Instance = matchContainer:WaitForChild("TradeRequest")
local matchContainerPartyInvitation: Instance = matchContainer:WaitForChild("PartyInvitation")
local t8: {[any]: any} = {
	Party = partyInvitation,
	Duel = duelRequest,
	Trade = tradeRequest,
	ClanInvite = matchContainerPartyInvitation
}

for _, v in pairs(t8) do
	v.Visible = false
end

local t9: {[any]: any} = {}

local function reconcileVisibleCardsCount()
	local v403 = math.max(0, n1 - #t1)

	while v403 < #t5 do
		local v404 = table.remove(t5, #t5)

		table.insert(t6, 1, v404)

		local v405 = t3[v404]

		if v405 then
			v405.Card.Visible = false
		end
	end

	promoteFromQueue()
end

local connection = nil

local function applyScreenCap()
	local CurrentCamera2: Camera = workspace.CurrentCamera
	local u407

	if not CurrentCamera2 then
		u407 = false
	else
		local currentCamera2ViewportSize: Vector2 = CurrentCamera2.ViewportSize

		u407 = math.min(currentCamera2ViewportSize.X, currentCamera2ViewportSize.Y) <= 500
	end

	local n2: number = if u407 then 2 else 3

	if n2 == n1 then
		return
	end

	n1 = n2
	reconcileVisibleCardsCount()
end

local CurrentCamera3: Camera = workspace.CurrentCamera

if CurrentCamera3 then
	connection = CurrentCamera3:GetPropertyChangedSignal("ViewportSize"):Connect(applyScreenCap)
end

local CurrentCamera4: Camera = workspace.CurrentCamera
local u93

if not CurrentCamera4 then
	u93 = false
else
	local currentCamera4ViewportSize: Vector2 = CurrentCamera4.ViewportSize

	u93 = math.min(currentCamera4ViewportSize.X, currentCamera4ViewportSize.Y) <= 500
end

local n3: number = if u93 then 2 else 3

if n3 ~= n1 then
	n1 = n3
	reconcileVisibleCardsCount()
end

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	if connection then
		connection:Disconnect()
	end

	local CurrentCamera5: Camera = workspace.CurrentCamera

	if CurrentCamera5 then
		connection = CurrentCamera5:GetPropertyChangedSignal("ViewportSize"):Connect(applyScreenCap)
	end

	local CurrentCamera6: Camera = workspace.CurrentCamera
	local u412

	if not CurrentCamera6 then
		u412 = false
	else
		local currentCamera6ViewportSize: Vector2 = CurrentCamera6.ViewportSize

		u412 = math.min(currentCamera6ViewportSize.X, currentCamera6ViewportSize.Y) <= 500
	end

	local n2: number = if u412 then 2 else 3

	if n2 == n1 then
		return
	end

	n1 = n2
	reconcileVisibleCardsCount()
end)

local function removeFromActiveList(p50)
	for i, v in ipairs(t1) do
		if p50 == v.Token then
			table.remove(t1, i)

			break
		end
	end

	t9[p50] = nil
end
local function endRequest(p51, p52)
	local v420 = t9[p51]

	if not v420 then
		return
	end

	if p52 ~= nil then
		playerRequestRespond:FireServer(p51, p52)
	end

	for _, v in ipairs(v420.Conns) do
		if v.Connected then
			v:Disconnect()
		end
	end

	if v420.ExpiryThread then
		task.cancel(v420.ExpiryThread)
		v420.ExpiryThread = nil
	end

	if v420.Frame and v420.Frame.Parent then
		v420.Frame:Destroy()
	end

	removeFromActiveList(p51)
	reconcileVisibleCardsCount()

	if #t1 > 0 then
		matchContainer.Visible = true
	else
		local u423

		if LocalPlayer:GetAttribute("MatchId") == nil then
			local spectating: any = LocalPlayer:GetAttribute("Spectating")

			u423 = typeof(spectating) == "number" and spectating ~= 0
		else
			u423 = true
		end

		matchContainer.Visible = not u423
	end

	if p52 ~= nil then
		tradeRequestResolved:Fire(p51, p52)
	end
end
local function showRequest(p53, text, p55, p56, p57)
	local v430 = t8[p53]

	if not v430 then
		return
	end

	local clone = v430:Clone()

	clone.Name = "Request_" .. p53 .. "_" .. p56
	clone.Visible = true
	clone.LayoutOrder = 100
	clone.Parent = matchContainer

	local username = clone:FindFirstChild("Username")

	if username then
		username.Text = text
	end

	v430 = p53 == "ClanInvite" and clone:FindFirstChild("Status")

	if v430 then
		v430.Text = "invites you to join their clan..."
	end

	local imageLabel = clone:FindFirstChild("ImageLabel")

	if imageLabel and p55 > 0 then
		imageLabel.Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420"):format(p55)
	end

	local v434 = os.clock()
	local t15: {[any]: any} = {
		ExpiryThread = nil,
		Token = p56,
		Until = v434 + p57,
		Frame = clone,
		Conns = {}
	}

	table.insert(t1, t15)
	t9[p56] = t15
	playPopInTween(clone)

	if p53 == "Party" or p53 == "ClanInvite" or p53 == "Trade" then
		sound:Play("Misc.NotificationInvite", workspace)
	end

	local acceptButton = clone:FindFirstChild("AcceptButton")
	local declineButton = clone:FindFirstChild("DeclineButton")

	if acceptButton then
		table.insert(t15.Conns, acceptButton.MouseButton1Click:Connect(function()
			task.wait()
			endRequest(p56, true)
		end))
	end

	if declineButton then
		table.insert(t15.Conns, declineButton.MouseButton1Click:Connect(function()
			task.wait()
			endRequest(p56, false)
		end))
	end

	t15.ExpiryThread = task.delay(p57 - 0.1, function()
		if t9[p56] then
			t9[p56].ExpiryThread = nil
		end

		endRequest(p56, nil)
	end)
	reconcileVisibleCardsCount()

	if #t1 > 0 then
		matchContainer.Visible = true

		return
	end

	local u438

	if LocalPlayer:GetAttribute("MatchId") == nil then
		local spectating: any = LocalPlayer:GetAttribute("Spectating")

		u438 = typeof(spectating) == "number" and spectating ~= 0
	else
		u438 = true
	end

	matchContainer.Visible = not u438
end

playerRequestNotify.OnClientEvent:Connect(function(p58)
	if typeof(p58) == "table" then
		local token = p58.Token
		local v442 = p58.FromName
		local v443 = p58.FromUserId
		local v444 = p58.Type
		local v445 = p58.ExpiresIn

		if typeof(token) == "string" then
			if typeof(v442) ~= "string" then
				v442 = "Player"
			end

			if typeof(v443) ~= "number" then
				v443 = 0
			end

			if typeof(v444) ~= "string" then
				v444 = "Request"
			end

			if typeof(v445) ~= "number" then
				v445 = 5
			end

			if not t8[v444] then
				return
			end

			if v444 == "Trade" and not gameFlags.TradingEnabled then
				playerRequestRespond:FireServer(token, false)

				return
			end

			if v444 == "Trade" and LocalPlayer:GetAttribute("TradeRequests") == false then
				playerRequestRespond:FireServer(token, false)

				return
			end

			if v444 == "Duel" and LocalPlayer:GetAttribute("DuelRequests") == false then
				playerRequestRespond:FireServer(token, false)

				return
			end

			if #t1 >= n1 then
				return
			end

			if t9[token] then
				return
			end

			local numberValue: number? = tonumber(p58.PopupSeconds)
			local v447 = math.min(numberValue or v445, v445)
			local v448 = math.max(1, v447)

			showRequest(v444, v442, v443, token, v448)

			return
		end

		return
	end
end)
tradeRequestResolved.Event:Connect(function(p59)
	if typeof(p59) == "string" and t9[p59] then
		endRequest(p59, nil)
	end
end)
