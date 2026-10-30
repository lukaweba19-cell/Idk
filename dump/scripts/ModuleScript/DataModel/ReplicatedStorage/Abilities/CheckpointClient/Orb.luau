-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local runService: RunService = game:GetService("RunService")
local tweenService: TweenService = game:GetService("TweenService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local color3 = Color3.fromRGB(255, 214, 64)
local color32 = Color3.fromRGB(80, 230, 110)
local color33 = Color3.fromRGB(240, 60, 60)

local module: {[any]: any} = {
	PARAMS = {
		recastRadiusSlack = 6,
		floorProbe = 12,
		hudTransparency = 0.3,
		miniScale = 0.5,
		miniTransparency = 0,
		miniSpinSpeed = 2.2,
		miniColorSelf = color3,
		miniColorAlly = color32,
		miniColorEnemy = color33
	},
	ATTR_OWNER = "CheckpointOwnerUserId",
	ATTR_ORB = "CheckpointOrbPosition",
	ATTR_CENTER = "CheckpointCenter",
	ATTR_RADIUS = "CheckpointRadius",
	GetFXFolder = function()
		return replicatedStorage:WaitForChild("FX"):WaitForChild("AbilityFX"):WaitForChild("Checkpoint")
	end
}

function module.GetAreaRadius()
	local teleportArea = module.GetFXFolder():FindFirstChild("TeleportArea")

	if teleportArea and teleportArea:IsA("BasePart") then
		return teleportArea.Size.X * 0.5
	end

	return 37.5
end

local LocalPlayer: Player = players.LocalPlayer
local u10 = nil
local u11 = false

local function hudOverlay()
	local playerGui = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local overlay = playerGui and playerGui:FindFirstChild("Overlay")
	local v38 = overlay

	if v38 then
		v38 = overlay:FindFirstChild("CheckpointUser")
	end

	if v38 and v38:IsA("ImageLabel") then
		return v38
	end

	return nil
end
local function setInside(p1)
	if p1 == u11 then
		return
	end

	u11 = p1

	local playerGui = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local overlay = playerGui and playerGui:FindFirstChild("Overlay")
	local v42 = overlay

	if v42 then
		v42 = overlay:FindFirstChild("CheckpointUser")
	end

	local v43 = if v42 and v42:IsA("ImageLabel") then v42 else nil

	if not v43 then
		return
	end

	if p1 then
		local tweenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

		tweenService:Create(v43, tweenInfo, { ImageTransparency = module.PARAMS.hudTransparency }):Play()

		return
	end

	local tweenInfo = TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	tweenService:Create(v43, tweenInfo, { ImageTransparency = 1 }):Play()
end
local function liveRoot()
	local Character: Model = LocalPlayer.Character
	local humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	local humanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

	if not humanoid or humanoid.Health <= 0 or not humanoidRootPart or not humanoidRootPart:IsA("BasePart") then
		return nil
	end

	return humanoidRootPart
end
local function isInside(p2)
	local Character: Model = LocalPlayer.Character
	local humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	local humanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
	local v53 = if not humanoid or humanoid.Health <= 0 or not humanoidRootPart or not humanoidRootPart:IsA("BasePart") then nil else humanoidRootPart

	if not v53 then
		return false
	end

	return (v53.Position - p2.center).Magnitude <= p2.radius
end
local function captureDome(p3)
	local specialMesh = p3:FindFirstChildOfClass("SpecialMesh")
	local t3: {[any]: any} = {
		anim = nil,
		part = p3,
		mesh = specialMesh,
		meshScale = specialMesh and specialMesh.Scale or Vector3.new(1, 1, 1),
		transparency = p3.Transparency,
		atts = {},
		beams = {}
	}

	for iterFirst, iterSecond in p3:GetChildren() do
		if iterSecond:IsA("Attachment") then
			table.insert(t3.atts, { att = iterSecond, pos = iterSecond.Position })
		elseif iterSecond:IsA("Beam") then
			table.insert(t3.beams, {
				beam = iterSecond,
				w0 = iterSecond.Width0,
				w1 = iterSecond.Width1,
				c0 = iterSecond.CurveSize0,
				c1 = iterSecond.CurveSize1,
				tr = iterSecond.Transparency
			})
		end
	end

	return t3
end
local function fadeSeq(p4, p5)
	local t4: {[any]: any} = {}

	for iterFirst, iterSecond in p4.Keypoints, nil, nil do
		table.insert(t4, NumberSequenceKeypoint.new(iterSecond.Time, 1 - (1 - iterSecond.Value) * p5, iterSecond.Envelope))
	end

	return NumberSequence.new(t4)
end
local function applyDome(p6, p7, p8)
	local v67 = math.max(p7, 0.001)
	local v68 = math.clamp(p8, 0, 1)

	if p6.mesh then
		p6.mesh.Scale = p6.meshScale * v67
	end

	p6.part.Transparency = 1 - (1 - p6.transparency) * v68

	for iterFirst, iterSecond in p6.atts, nil, nil do
		iterSecond.att.Position = iterSecond.pos * v67
	end

	for iterFirst2, iterSecond2 in p6.beams, nil, nil do
		iterSecond2.beam.Width0 = iterSecond2.w0 * v67
		iterSecond2.beam.Width1 = iterSecond2.w1 * v67
		iterSecond2.beam.CurveSize0 = iterSecond2.c0 * v67
		iterSecond2.beam.CurveSize1 = iterSecond2.c1 * v67
		iterSecond2.beam.Transparency = fadeSeq(iterSecond2.tr, v68)
	end
end
local function easeOutBack(p9)
	return (p9 - 1) ^ 3 * 2.9 + 1 + (p9 - 1) ^ 2 * 1.9
end
local function easeInBack(p10)
	return p10 ^ 3 * 2.7 - p10 ^ 2 * 1.7
end
local function runDome(p11, p12, p13, p14)
	if p11.anim then
		p11.anim:Disconnect()
	end

	local v79 = os.clock()
	local v80, v81 = p13(0)

	applyDome(p11, v80, v81)
	p11.anim = runService.RenderStepped:Connect(function()
		local v156 = os.clock()
		local v157 = math.min((v156 - v79) / p12, 1)
		local v158, v159 = p13(v157)

		applyDome(p11, v158, v159)

		if v157 >= 1 then
			if p11.anim then
				p11.anim:Disconnect()
			end

			p11.anim = nil

			if p14 then
				p14()
			end
		end
	end)
end
local function shockShell(p15, p16, p17, p18)
	local clone = p15.part:Clone()

	for iterFirst, iterSecond in clone:GetChildren() do
		if not iterSecond:IsA("SpecialMesh") then
			iterSecond:Destroy()
		end
	end

	clone.Parent = p15.part.Parent

	local specialMesh = clone:FindFirstChildOfClass("SpecialMesh")
	local v90 = os.clock()
	local connection = nil

	connection = runService.RenderStepped:Connect(function()
		local v160 = os.clock()
		local v161 = math.min((v160 - v90) / p18, 1)

		if specialMesh then
			specialMesh.Scale = p15.meshScale * (p16 + (p17 - p16) * (1 - (1 - v161) ^ 3))
		end

		clone.Transparency = 1 - (1 - p15.transparency) * 0.9 * (1 - v161)

		if v161 >= 1 then
			if connection then
				connection:Disconnect()
			end

			clone:Destroy()
		end
	end)
end
local function playDomeSpawn(p19)
	local u93: boolean = false

	runDome(p19, 0.6, function(p20)
		if not u93 and p20 >= 0.45 then
			u93 = true
			shockShell(p19, 1, 1.18, 0.45)
		end

		local v163 = math.min(p20 / 0.3, 1)

		return (p20 - 1) ^ 3 * 2.9 + 1 + (p20 - 1) ^ 2 * 1.9, v163
	end)
end
local function playDomeDespawn(p21, p22)
	local u96: boolean = false

	runDome(p21, 0.42, function(p23)
		if p23 < 0.25 then
			return math.sin(p23 / 0.25 * 3.141592653589793 * 0.5) * 0.07 + 1, 1
		end

		if not u96 then
			u96 = true
			shockShell(p21, 1.05, 1.3, 0.35)
		end

		local n1 = (p23 - 0.25) / 0.75

		return (1 - (n1 ^ 3 * 2.7 - n1 ^ 2 * 1.7)) * 1.07, 1 - n1 ^ 2
	end, p22)
end
local function unbind()
	local v97 = u10

	if not v97 then
		return
	end

	u10 = nil

	for iterFirst, iterSecond in v97.conns, nil, nil do
		iterSecond:Disconnect()
	end

	if u11 ~= false then
		u11 = false

		local playerGui = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
		local overlay = playerGui and playerGui:FindFirstChild("Overlay")
		local v102 = overlay

		if v102 then
			v102 = overlay:FindFirstChild("CheckpointUser")
		end

		local v103 = if v102 and v102:IsA("ImageLabel") then v102 else nil

		if v103 then
			local tweenInfo = TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

			tweenService:Create(v103, tweenInfo, { ImageTransparency = 1 }):Play()
		end
	end

	local area = v97.area

	if area then
		local v106 = v97.rig or captureDome(area)
		local u107: boolean = false

		runDome(v106, 0.42, function(p24)
			if p24 < 0.25 then
				return math.sin(p24 / 0.25 * 3.141592653589793 * 0.5) * 0.07 + 1, 1
			end

			if not u107 then
				u107 = true
				shockShell(v106, 1.05, 1.3, 0.35)
			end

			local n1 = (p24 - 0.25) / 0.75

			return (1 - (n1 ^ 3 * 2.7 - n1 ^ 2 * 1.7)) * 1.07, 1 - n1 ^ 2
		end, function()
			area:Destroy()
		end)
		task.delay(1.42, function()
			if area.Parent then
				area:Destroy()
			end
		end)
	end
end
local function bind(p25)
	if u10 and p25 == u10.orb then
		return
	end

	unbind()

	local attributeValue = p25:GetAttribute(module.ATTR_ORB)
	local attributeValue2 = p25:GetAttribute(module.ATTR_CENTER)
	local attributeValue3 = p25:GetAttribute(module.ATTR_RADIUS)

	if typeof(attributeValue) == "Vector3" and typeof(attributeValue2) == "Vector3" and typeof(attributeValue3) == "number" then
		local t5: {[any]: any} = {
			area = nil,
			rig = nil,
			orb = p25,
			orbPos = attributeValue,
			center = attributeValue2,
			radius = attributeValue3,
			conns = {}
		}

		u10 = t5

		local teleportArea = module.GetFXFolder():FindFirstChild("TeleportArea")

		if teleportArea and teleportArea:IsA("BasePart") then
			local clone = teleportArea:Clone()

			clone.CFrame = CFrame.new(attributeValue2) * teleportArea.CFrame.Rotation

			local v115 = captureDome(clone)

			applyDome(v115, 0.001, 0)
			clone.Parent = workspace:FindFirstChild("Bin") or workspace
			t5.area = clone
			t5.rig = v115

			local u116: boolean = false

			runDome(v115, 0.6, function(p26)
				if not u116 and p26 >= 0.45 then
					u116 = true
					shockShell(v115, 1, 1.18, 0.45)
				end

				local v169 = math.min(p26 / 0.3, 1)

				return (p26 - 1) ^ 3 * 2.9 + 1 + (p26 - 1) ^ 2 * 1.9, v169
			end)
		end

		table.insert(t5.conns, p25.AncestryChanged:Connect(function()
			if not p25:IsDescendantOf(workspace) then
				unbind()
			end
		end))
		table.insert(t5.conns, runService.Heartbeat:Connect(function()
			if u10 ~= t5 then
				return
			end

			local v170: {[any]: any} = t5
			local Character: Model = LocalPlayer.Character
			local humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
			local humanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			local v174 = if not humanoid or humanoid.Health <= 0 or not humanoidRootPart or not humanoidRootPart:IsA("BasePart") then nil else humanoidRootPart

			setInside(if not v174 then false else (v174.Position - v170.center).Magnitude <= v170.radius)
		end))

		local Character: Model = LocalPlayer.Character
		local humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
		local humanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
		local v120 = if not humanoid or humanoid.Health <= 0 or not humanoidRootPart or not humanoidRootPart:IsA("BasePart") then nil else humanoidRootPart

		setInside(if not v120 then false else (v120.Position - t5.center).Magnitude <= t5.radius)

		return
	end
end
local function consider(p27)
	if not p27:IsA("Model") then
		return
	end

	if p27:GetAttribute(module.ATTR_OWNER) ~= LocalPlayer.UserId then
		return
	end

	bind(p27)
end

local t2: {[any]: any} = {}
local connection = nil

local function miniColor(p28)
	if p28:GetAttribute(module.ATTR_OWNER) == LocalPlayer.UserId then
		return module.PARAMS.miniColorSelf
	end

	local matchSide: any = LocalPlayer:GetAttribute("MatchSide")
	local matchSide2 = p28:GetAttribute("MatchSide")

	if typeof(matchSide) == "string" and matchSide == matchSide2 then
		return module.PARAMS.miniColorAlly
	end

	return module.PARAMS.miniColorEnemy
end
local function paint(p29)
	local v126 = miniColor(p29.orb)

	for iterFirst, iterSecond in p29.mini:GetDescendants() do
		if iterSecond:IsA("BasePart") then
			iterSecond.Color = v126
		end
	end

	for iterFirst2, iterSecond2 in p29.lights, nil, nil do
		iterSecond2.Color = v126
	end
end
local function ensureSpin()
	if connection then
		return
	end

	connection = runService.RenderStepped:Connect(function(deltaTime: number)
		local u176: boolean = false

		for key, value in t2 do
			u176 = true

			if key ~= value.mini.Parent then
				t2[key] = nil
			else
				value.angle = (value.angle + deltaTime * module.PARAMS.miniSpinSpeed) % 6.283185307179586

				local mini = value.mini
				local cFrame = CFrame.new(value.pos)
				local v181 = CFrame.Angles(0, value.angle, 0)

				mini:PivotTo(cFrame * v181)
			end
		end

		if not u176 and connection then
			connection:Disconnect()
			connection = nil
		end
	end)
end
local function trackMini(p31)
	if t2[p31] then
		return
	end

	local mini = p31:WaitForChild("Mini", 5)

	if not mini or not mini:IsA("Model") or not p31:IsDescendantOf(workspace) then
		return
	end

	local attributeValue = p31:GetAttribute(module.ATTR_ORB)

	if typeof(attributeValue) ~= "Vector3" then
		attributeValue = mini:GetPivot().Position
	end

	local t6: {[any]: any} = {}

	for iterFirst, iterSecond in p31:GetDescendants() do
		if iterSecond:IsA("Light") and not iterSecond:IsDescendantOf(mini) then
			table.insert(t6, iterSecond)
		end
	end

	local t7: {[any]: any} = { angle = 0, orb = p31, mini = mini, pos = attributeValue, lights = t6 }

	t2[p31] = t7
	paint(t7)

	if not connection then
		connection = runService.RenderStepped:Connect(function(deltaTime: number)
			local u183: boolean = false

			for key, value in t2 do
				u183 = true

				if key ~= value.mini.Parent then
					t2[key] = nil
				else
					value.angle = (value.angle + deltaTime * module.PARAMS.miniSpinSpeed) % 6.283185307179586

					local mini = value.mini
					local cFrame = CFrame.new(value.pos)
					local v188 = CFrame.Angles(0, value.angle, 0)

					mini:PivotTo(cFrame * v188)
				end
			end

			if not u183 and connection then
				connection:Disconnect()
				connection = nil
			end
		end)
	end

	mini.DescendantAdded:Connect(function(p33)
		if p33:IsA("BasePart") then
			p33.Color = miniColor(p31)
		end
	end)
end
local function considerMini(p34)
	if not p34:IsA("Model") then
		return
	end

	if p34:GetAttribute(module.ATTR_OWNER) == nil then
		return
	end

	task.spawn(trackMini, p34)
end

if runService:IsClient() and LocalPlayer then
	task.spawn(function()
		local characters: Instance = workspace:WaitForChild("Characters")

		characters.ChildAdded:Connect(function(p35: Instance)
			if p35:IsA("Model") and p35:GetAttribute(module.ATTR_OWNER) == LocalPlayer.UserId then
				bind(p35)
			end

			if not p35:IsA("Model") then
				return
			end

			if p35:GetAttribute(module.ATTR_OWNER) == nil then
				return
			end

			task.spawn(trackMini, p35)
		end)

		for iterFirst, iterSecond in characters:GetChildren() do
			if iterSecond:IsA("Model") and iterSecond:GetAttribute(module.ATTR_OWNER) == LocalPlayer.UserId then
				bind(iterSecond)
			end

			if iterSecond:IsA("Model") and iterSecond:GetAttribute(module.ATTR_OWNER) ~= nil then
				task.spawn(trackMini, iterSecond)
			end
		end

		LocalPlayer:GetAttributeChangedSignal("MatchSide"):Connect(function()
			for key, value in t2 do
				paint(value)
			end
		end)
	end)
end

function module.Cast(p36)
	if p36 ~= LocalPlayer then
		return nil
	end

	local Character: Model = LocalPlayer.Character
	local humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	local humanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

	if not (if not humanoid or humanoid.Health <= 0 or not humanoidRootPart or not humanoidRootPart:IsA("BasePart") then nil else humanoidRootPart) then
		return -1
	end

	return require(replicatedStorage:WaitForChild("AbilityEffectClient")).MakeEffectKey()
end
function module.Recast(p37)
	if p37 ~= LocalPlayer then
		return -1
	end

	local v147 = u10

	if not v147 or not v147.orb:IsDescendantOf(workspace) then
		return -1
	end

	local Character: Model = LocalPlayer.Character
	local humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	local humanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
	local v151 = if not humanoid or humanoid.Health <= 0 or not humanoidRootPart or not humanoidRootPart:IsA("BasePart") then nil else humanoidRootPart

	if not (if not v151 then false else (v151.Position - v147.center).Magnitude <= v147.radius) then
		return -1
	end

	local Character2: Model = LocalPlayer.Character
	local character2Humanoid = Character2 and Character2:FindFirstChildOfClass("Humanoid")
	local character2HumanoidRootPart = Character2 and Character2:FindFirstChild("HumanoidRootPart")
	local v155 = if not character2Humanoid or character2Humanoid.Health <= 0 or not character2HumanoidRootPart or not character2HumanoidRootPart:IsA("BasePart") then nil else character2HumanoidRootPart

	if not v155 then
		return -1
	end

	v155.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
	v155.CFrame = CFrame.new(v147.orbPos) * v155.CFrame.Rotation

	return v147.orb
end

return module
