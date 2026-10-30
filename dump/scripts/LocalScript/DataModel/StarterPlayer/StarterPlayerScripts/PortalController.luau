-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local runService: RunService = game:GetService("RunService")
local soundService: SoundService = game:GetService("SoundService")
local debris: Debris = game:GetService("Debris")
local workspace: Workspace = game:GetService("Workspace")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local effect = require(replicatedStorage:WaitForChild("Effect"))
local LocalPlayer: Player = players.LocalPlayer
local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui")
local portal: Instance = soundService:WaitForChild("Portal", 10)
local v11: Instance = portal

if v11 then
	v11 = portal:FindFirstChild("portalgo")
end

local function playAt(p1)
	if not v11 then
		return
	end

	local part: Part = Instance.new("Part")

	part.Size = Vector3.new(1, 1, 1)
	part.Transparency = 1
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	part.CastShadow = false
	part.Anchored = true
	part.Position = p1
	part.Parent = workspace.Bin

	local clone: Instance = v11:Clone()

	clone.Looped = false
	clone.RollOffMode = Enum.RollOffMode.Linear
	clone.RollOffMinDistance = 15
	clone.RollOffMaxDistance = 300
	clone.Parent = part
	clone:Play()
	clone.Ended:Connect(function()
		part:Destroy()
	end)
	debris:AddItem(part, 10)
end

local n1 = -math.huge

local function portalNormal(p2)
	local v29 = p2.CFrame.UpVector

	v29 = Vector3.new(v29.X, 0, v29.Z)

	if v29.Magnitude < 0.0001 then
		return Vector3.new(1, 0, 0)
	end

	return v29.Unit
end

local u15 = nil

local function getCameraRedirect()
	if u15 and u15:IsDescendantOf(playerGui) then
		return u15
	end

	u15 = nil

	local hud: Instance = playerGui:FindFirstChild("HUD")
	local camera: Instance = hud and hud:FindFirstChild("Camera")
	local v32: Instance = camera

	if v32 then
		v32 = camera:FindFirstChild("PortalRedirect")
	end

	if v32 and v32:IsA("BindableEvent") then
		u15 = v32
	end

	return u15
end
local function teleport(p3, p4)
	local v35 = os.clock()

	if v35 - n1 < 1.5 then
		return
	end

	local Character: Model = LocalPlayer.Character

	if not Character then
		return
	end

	local humanoidRootPart: Instance = Character:FindFirstChild("HumanoidRootPart")
	local humanoid: Instance = Character:FindFirstChildOfClass("Humanoid")

	if humanoidRootPart and humanoid and not (humanoid.Health <= 0) then
		n1 = v35

		local v39 = p3.CFrame.UpVector

		v39 = Vector3.new(v39.X, 0, v39.Z)

		local v40 = if v39.Magnitude < 0.0001 then Vector3.new(1, 0, 0) else v39.Unit
		local v41 = p4.CFrame.UpVector

		v41 = Vector3.new(v41.X, 0, v41.Z)

		local v42 = if v41.Magnitude < 0.0001 then Vector3.new(1, 0, 0) else v41.Unit
		local humanoidRootPartAssemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
		local vector3 = Vector3.new(humanoidRootPartAssemblyLinearVelocity.X, 0, humanoidRootPartAssemblyLinearVelocity.Z)

		if vector3.Magnitude < 1 then
			local lookVector = humanoidRootPart.CFrame.LookVector

			vector3 = Vector3.new(lookVector.X, 0, lookVector.Z)
		end

		local n5 = if vector3:Dot(v40) >= 0 then 1 else -1
		local n2 = v40 * n5

		v40 = v42 * n5

		local y = n2:Cross(v40).Y
		local v49 = n2:Dot(v40)

		n5 = math.atan2(y, v49)
		n2 = CFrame.Angles(0, n5, 0)
		n5 = math.min(p4.Size.X, p4.Size.Z) * 0.5

		local v50 = math.clamp(humanoidRootPart.Position.Y - p3.Position.Y, -(n5 - 2.5), n5 - 2.5)

		n5 = n2:VectorToWorldSpace(humanoidRootPartAssemblyLinearVelocity)

		if Vector3.new(n5.X, 0, n5.Z).Magnitude < 12 then
			local vector32 = Vector3.new(0, n5.Y, 0)

			n5 = v40 * 12 + vector32
		end

		local n3 = p4.Position + v40 * 3.5
		local vector33 = Vector3.new(0, v50, 0)
		local n4 = n3 + vector33

		v42 = p4.Parent

		if v42 then
			v42 = p4.Parent:FindFirstChild(p4.Name .. "Point")
		end

		if v42 and v42:IsA("BasePart") then
			local v55 = v42.Position
			local vector34 = Vector3.new(0, v42.Size.Y * 0.5 + 3, 0)

			n4 = v55 + vector34
		end

		humanoidRootPart.CFrame = CFrame.new(n4) * (n2 * humanoidRootPart.CFrame.Rotation)
		humanoidRootPart.AssemblyLinearVelocity = n5
		n5 = getCameraRedirect()

		if n5 then
			n5:Fire(n2)
		end

		local movementController: Instance = Character:FindFirstChild("MovementController")

		v42 = movementController

		if v42 then
			v42 = movementController:FindFirstChild("PortalRedirect")
		end

		if v42 and v42:IsA("BindableEvent") then
			v42:Fire(n2)
		end

		playAt(n4)
		n3 = effect.new("Portal")

		local cFrame = CFrame.new(n4)

		n3:replicate({ IsLocal = true, CameraOnly = true, CFrame = cFrame })

		return
	end
end

local t1: {[any]: any} = {}

local function isFacilityMap(p5)
	if not p5:IsA("Model") then
		return false
	end

	local u60: boolean = true

	if p5.Name ~= "Facility" then
		u60 = string.match(p5.Name, "^MatchMap_Facility_") ~= nil
	end

	return u60
end
local function hookPortal(p6, p7, p8, p9, p10)
	local function wire(p11)
		if p11.Name ~= p8 or not p11:IsA("BasePart") then
			return
		end

		p6.spinners[p11] = p10
		table.insert(p6.conns, p11.Touched:Connect(function(p12)
			local Character: Model = LocalPlayer.Character

			if not Character or not p12 or not p12:IsDescendantOf(Character) then
				return
			end

			local foundChild = p7:FindFirstChild(p9, true)

			if not foundChild or not foundChild:IsA("BasePart") then
				return
			end

			teleport(p11, foundChild)
		end))
		table.insert(p6.conns, p11.AncestryChanged:Connect(function()
			if not p11:IsDescendantOf(workspace) then
				p6.spinners[p11] = nil
			end
		end))
	end

	local foundChild = p7:FindFirstChild(p8, true)

	if foundChild then
		wire(foundChild)
	end

	table.insert(p6.conns, p7.DescendantAdded:Connect(wire))
end
local function startSystem(p13)
	if t1[p13] then
		return
	end

	local t2: {[any]: any} = {
		conns = {},
		spinners = {}
	}

	t1[p13] = t2
	hookPortal(t2, p13, "PortalA", "PortalB", 1.0471975511965976)
	hookPortal(t2, p13, "PortalB", "PortalA", -0.7853981633974483)
	table.insert(t2.conns, p13.AncestryChanged:Connect(function()
		local v84 = not p13:IsDescendantOf(game) and t1[p13]

		if v84 then
			for _, v in ipairs(v84.conns) do
				v:Disconnect()
			end

			t1[p13] = nil
		end
	end))
end
local function tryHook(p14)
	local u71

	if not p14:IsA("Model") then
		u71 = false
	else
		u71 = true

		if p14.Name ~= "Facility" then
			u71 = string.match(p14.Name, "^MatchMap_Facility_") ~= nil
		end
	end

	if u71 then
		startSystem(p14)
	end
end
local function hookContainer(p15)
	for _, v in ipairs(p15:GetChildren()) do
		local u75

		if not v:IsA("Model") then
			u75 = false
		else
			u75 = true

			if v.Name ~= "Facility" then
				u75 = string.match(v.Name, "^MatchMap_Facility_") ~= nil
			end
		end

		if u75 then
			startSystem(v)
		end
	end

	p15.ChildAdded:Connect(tryHook)
end

local game2: Instance = workspace:WaitForChild("Game")

if game2 then
	hookContainer(game2)
end

runService.Heartbeat:Connect(function(deltaTime: number)
	for _, v in pairs(t1) do
		for k, iterValue in pairs(v.spinners) do
			local kCFrame = k.CFrame
			local v82 = CFrame.Angles(0, iterValue * deltaTime, 0)

			k.CFrame = kCFrame * v82
		end
	end
end)
