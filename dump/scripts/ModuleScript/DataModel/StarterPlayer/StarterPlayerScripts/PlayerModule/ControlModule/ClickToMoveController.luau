-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local ok, result = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserExcludeNonCollidableForPathfinding")
end)

local v3 = ok and result

local ok2, result2 = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserClickToMoveSupportAgentCanClimb2")
end)

local v6 = ok2 and result2
local userInputService: UserInputService = game:GetService("UserInputService")
local pathfindingService: PathfindingService = game:GetService("PathfindingService")
local players: Players = game:GetService("Players")

game:GetService("Debris")

local starterGui: StarterGui = game:GetService("StarterGui")
local workspace: Workspace = game:GetService("Workspace")
local collectionService: CollectionService = game:GetService("CollectionService")
local guiService: GuiService = game:GetService("GuiService")
local commonUtils: Instance = script.Parent.Parent:WaitForChild("CommonUtils")
local v15 = require(commonUtils:WaitForChild("FlagUtil")).getUserFlag("UserRaycastUpdateAPI2")
local u16 = true
local u17 = true
local u18 = false
local n1 = 1
local n2 = 8
local t1: {[any]: any} = {
	[Enum.KeyCode.W] = true,
	[Enum.KeyCode.A] = true,
	[Enum.KeyCode.S] = true,
	[Enum.KeyCode.D] = true,
	[Enum.KeyCode.Up] = true,
	[Enum.KeyCode.Down] = true
}
local LocalPlayer: Player = players.LocalPlayer
local clickToMoveDisplay = require(script.Parent:WaitForChild("ClickToMoveDisplay"))
local raycastParams = RaycastParams.new()

raycastParams.FilterType = Enum.RaycastFilterType.Exclude

local t2: {[any]: any} = {}

if not v15 then
	local function findCharacterAncestor(character)
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")

			if humanoid then
				return character, humanoid
			end

			return findCharacterAncestor(character.Parent)
		end
	end

	t2.FindCharacterAncestor = findCharacterAncestor

	local function raycast(p2, p3, p4)
		local t4 = p4 or {}
		local character, v59, v60, v61 = workspace:FindPartOnRayWithIgnoreList(p2, t4)

		if not character then
			return nil, nil
		end

		if p3 and character.CanCollide == false then
			local v62

			if character then
				local humanoid = character:FindFirstChildOfClass("Humanoid")

				if humanoid then
					v62 = humanoid
				else
					local v64, v65 = findCharacterAncestor(character.Parent)

					v62 = v65
				end
			else
				v62 = nil
			end

			if v62 == nil then
				table.insert(t4, character)

				return raycast(p2, p3, t4)
			end

			return character, v59, v60, v61
		end

		return character, v59, v60, v61
	end

	t2.Raycast = raycast
end

local t3: {[any]: any} = {}

local function findPlayerHumanoid(player)
	local character = player and player.Character

	if character then
		local v68 = t3[player]

		if v68 and character == v68.Parent then
			return v68
		end

		t3[player] = nil

		local humanoid = character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			t3[player] = humanoid
		end

		return humanoid
	end
end

local u30 = nil
local u31 = nil
local connection = nil
local connection2 = nil

local function GetCharacter()
	return LocalPlayer and LocalPlayer.Character
end
local function UpdateIgnoreTag(p6)
	if p6 == u31 then
		return
	end

	if connection then
		connection:Disconnect()
		connection = nil
	end

	if connection2 then
		connection2:Disconnect()
		connection2 = nil
	end

	u31 = p6
	u30 = { LocalPlayer and LocalPlayer.Character }

	if u31 ~= nil then
		local v71 = collectionService:GetTagged(u31)

		for _, v in ipairs(v71) do
			table.insert(u30, v)
		end

		connection = collectionService:GetInstanceAddedSignal(u31):Connect(function(p7)
			table.insert(u30, p7)
		end)
		connection2 = collectionService:GetInstanceRemovedSignal(u31):Connect(function(p8)
			for i = 1, #u30 do
				if p8 == u30[i] then
					u30[i] = u30[#u30]
					table.remove(u30)

					return
				end
			end
		end)
	end
end
local function getIgnoreList()
	if u30 then
		return u30
	end

	u30 = {}
	assert(u30, "")
	table.insert(u30, LocalPlayer and LocalPlayer.Character)

	return u30
end
local function minV(p9, p10)
	local v76 = math.min(p9.X, p10.X)
	local v77 = math.min(p9.Y, p10.Y)
	local v78 = math.min(p9.Z, p10.Z)
	local vector3 = Vector3.new(v76, v77, v78)

	return vector3
end
local function maxV(p11, p12)
	local v82 = math.max(p11.X, p12.X)
	local v83 = math.max(p11.Y, p12.Y)
	local v84 = math.max(p11.Z, p12.Z)
	local vector3 = Vector3.new(v82, v83, v84)

	return vector3
end
local function getCollidableExtentsSize(p13)
	if p13 == nil or p13.PrimaryPart == nil then
		return
	end

	assert(p13, "")
	assert(p13.PrimaryPart, "")

	local v87 = p13.PrimaryPart.CFrame:Inverse()
	local vectorValue = Vector3.new(inf, inf, inf)
	local vectorValue2 = Vector3.new(-inf, -inf, -inf)

	for _, v in pairs(p13:GetDescendants()) do
		if v:IsA("BasePart") and v.CanCollide then
			local n1 = v87 * v.CFrame
			local vector3 = Vector3.new(v.Size.X / 2, v.Size.Y / 2, v.Size.Z / 2)
			local vector32 = Vector3.new(vector3.X, vector3.Y, vector3.Z)
			local vector33 = Vector3.new(vector3.X, vector3.Y, -vector3.Z)
			local vector34 = Vector3.new(vector3.X, -vector3.Y, vector3.Z)
			local vector35 = Vector3.new(vector3.X, -vector3.Y, -vector3.Z)
			local vector36 = Vector3.new(-vector3.X, vector3.Y, vector3.Z)
			local vector37 = Vector3.new(-vector3.X, vector3.Y, -vector3.Z)
			local vector38 = Vector3.new(-vector3.X, -vector3.Y, vector3.Z)
			local vector39 = Vector3.new(-vector3.X, -vector3.Y, -vector3.Z)

			for _, iterValue in ipairs({
				vector32,
				vector33,
				vector34,
				vector35,
				vector36,
				vector37,
				vector38,
				vector39
			}) do
				local n2 = n1 * iterValue
				local v105 = vectorValue
				local v106 = math.min(v105.X, n2.X)
				local v107 = math.min(v105.Y, n2.Y)
				local v108 = math.min(v105.Z, n2.Z)

				vectorValue = Vector3.new(v106, v107, v108)
				v105 = vectorValue2
				v106 = math.max(v105.X, n2.X)
				v107 = math.max(v105.Y, n2.Y)
				v108 = math.max(v105.Z, n2.Z)
				vectorValue2 = Vector3.new(v106, v107, v108)
			end
		end
	end

	v87 = vectorValue2 - vectorValue

	if v87.X < 0 or v87.Y < 0 or v87.Z < 0 then
		return nil
	end

	return v87
end
local function Pather(p14, p15, p16)
	local v112
	local v113

	if p16 == nil then
		v112 = u18
		v113 = true
	else
		v112 = p16
		v113 = p16
	end

	local t5: {[any]: any} = {
		Cancelled = false,
		Started = false,
		Finished = Instance.new("BindableEvent"),
		PathFailed = Instance.new("BindableEvent"),
		PathComputing = false,
		PathComputed = false,
		OriginalTargetPoint = p14,
		TargetPoint = p14,
		TargetSurfaceNormal = p15,
		DiedConn = nil,
		SeatedConn = nil,
		BlockedConn = nil,
		TeleportedConn = nil,
		CurrentPoint = 0,
		HumanoidOffsetFromPath = Vector3.new(0, 0, 0),
		CurrentWaypointPosition = nil,
		CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0),
		CurrentWaypointPlaneDistance = 0,
		CurrentWaypointNeedsJump = false,
		CurrentHumanoidPosition = Vector3.new(0, 0, 0),
		CurrentHumanoidVelocity = 0,
		NextActionMoveDirection = Vector3.new(0, 0, 0),
		NextActionJump = false,
		Timeout = 0
	}
	local player: Player = LocalPlayer
	local character = player and player.Character
	local v117

	if character then
		local v118 = t3[player]

		if v118 and character == v118.Parent then
			v117 = v118
		else
			t3[player] = nil

			local humanoid = character:FindFirstChildOfClass("Humanoid")

			if humanoid then
				t3[player] = humanoid
			end

			v117 = humanoid
		end
	else
		v117 = nil
	end

	t5.Humanoid = v117
	t5.OriginPoint = nil
	t5.AgentCanFollowPath = false
	t5.DirectPath = false
	t5.DirectPathRiseFirst = false
	t5.stopTraverseFunc = nil
	t5.setPointFunc = nil
	t5.pointList = nil

	local v120 = t5.Humanoid and t5.Humanoid.RootPart

	if v120 then
		t5.OriginPoint = v120.CFrame.Position

		local n5 = 2
		local n6 = 5
		local u123: boolean = true
		local seatPart = t5.Humanoid.SeatPart

		if seatPart and seatPart:IsA("VehicleSeat") then
			local v125 = seatPart:FindFirstAncestorOfClass("Model")

			if v125 then
				local primaryPart = v125.PrimaryPart

				v125.PrimaryPart = seatPart

				if v113 then
					local v127 = v125:GetExtentsSize()
					local n3: number = n1 * 0.5
					local squareRoot = math.sqrt(v127.X * v127.X + v127.Z * v127.Z)

					n5 = n3 * squareRoot
					n6 = n1 * v127.Y
					u123 = false
					t5.AgentCanFollowPath = true
					t5.DirectPath = v113
				end

				v125.PrimaryPart = primaryPart
			end
		else
			local v130 = nil

			if v3 then
				local localPlayerCharacter = LocalPlayer and LocalPlayer.Character

				if localPlayerCharacter ~= nil then
					v130 = getCollidableExtentsSize(localPlayerCharacter)
				end
			end

			if v130 == nil then
				v130 = (LocalPlayer and LocalPlayer.Character):GetExtentsSize()
			end

			assert(v130, "")

			local n4: number = n1 * 0.5
			local squareRoot = math.sqrt(v130.X * v130.X + v130.Z * v130.Z)

			n5 = n4 * squareRoot
			n6 = n1 * v130.Y
			u123 = t5.Humanoid.JumpPower > 0
			t5.AgentCanFollowPath = true
			t5.DirectPath = v112
			t5.DirectPathRiseFirst = t5.Humanoid.Sit
		end

		if v6 then
			t5.pathResult = pathfindingService:CreatePath({
				AgentCanClimb = true,
				AgentRadius = n5,
				AgentHeight = n6,
				AgentCanJump = u123
			})
		else
			t5.pathResult = pathfindingService:CreatePath({ AgentRadius = n5, AgentHeight = n6, AgentCanJump = u123 })
		end
	end

	function t5.Cleanup(_)
		if t5.stopTraverseFunc then
			t5.stopTraverseFunc()
			t5.stopTraverseFunc = nil
		end

		if t5.BlockedConn then
			t5.BlockedConn:Disconnect()
			t5.BlockedConn = nil
		end

		if t5.DiedConn then
			t5.DiedConn:Disconnect()
			t5.DiedConn = nil
		end

		if t5.SeatedConn then
			t5.SeatedConn:Disconnect()
			t5.SeatedConn = nil
		end

		if t5.TeleportedConn then
			t5.TeleportedConn:Disconnect()
			t5.TeleportedConn = nil
		end

		t5.Started = false
	end
	function t5.Cancel(_)
		t5.Cancelled = true
		t5:Cleanup()
	end
	function t5.IsActive(_)
		return t5.AgentCanFollowPath and t5.Started and not t5.Cancelled
	end
	function t5.OnPathInterrupted(_)
		t5.Cancelled = true
		t5:OnPointReached(false)
	end
	function t5.ComputePath(_)
		if not t5.OriginPoint then
		elseif not t5.PathComputed and not t5.PathComputing then
			t5.PathComputing = true

			if t5.AgentCanFollowPath then
				if t5.DirectPath then
					t5.pointList = {
						PathWaypoint.new(t5.OriginPoint, Enum.PathWaypointAction.Walk),
						PathWaypoint.new(t5.TargetPoint, t5.DirectPathRiseFirst and Enum.PathWaypointAction.Jump or Enum.PathWaypointAction.Walk)
					}
					t5.PathComputed = true
				else
					t5.pathResult:ComputeAsync(t5.OriginPoint, t5.TargetPoint)
					t5.pointList = t5.pathResult:GetWaypoints()
					t5.BlockedConn = t5.pathResult.Blocked:Connect(function(p22)
						t5:OnPathBlocked(p22)
					end)
					t5.PathComputed = t5.pathResult.Status == Enum.PathStatus.Success
				end
			end

			t5.PathComputing = false

			return
		end
	end
	function t5.IsValidPath(_)
		t5:ComputePath()

		return t5.PathComputed and t5.AgentCanFollowPath
	end

	t5.Recomputing = false

	function t5.OnPathBlocked(_, p25)
		if p25 >= t5.CurrentPoint and not t5.Recomputing then
			t5.Recomputing = true

			if t5.stopTraverseFunc then
				t5.stopTraverseFunc()
				t5.stopTraverseFunc = nil
			end

			t5.OriginPoint = t5.Humanoid.RootPart.CFrame.p
			t5.pathResult:ComputeAsync(t5.OriginPoint, t5.TargetPoint)
			t5.pointList = t5.pathResult:GetWaypoints()

			if #t5.pointList > 0 then
				t5.HumanoidOffsetFromPath = t5.pointList[1].Position - t5.OriginPoint
			end

			t5.PathComputed = t5.pathResult.Status == Enum.PathStatus.Success

			if u16 then
				local v287, v288 = clickToMoveDisplay.CreatePathDisplay(t5.pointList)

				t5.stopTraverseFunc = v287
				t5.setPointFunc = v288
			end

			if t5.PathComputed then
				t5.CurrentPoint = 1
				t5:OnPointReached(true)
			else
				t5.PathFailed:Fire()
				t5:Cleanup()
			end

			t5.Recomputing = false

			return
		end
	end
	function t5.OnRenderStepped(_, p27)
		if t5.Started and not t5.Cancelled then
			t5.Timeout = t5.Timeout + p27

			if t5.Timeout > n2 then
				t5:OnPointReached(false)

				return
			end

			t5.CurrentHumanoidPosition = t5.Humanoid.RootPart.Position + t5.HumanoidOffsetFromPath
			t5.CurrentHumanoidVelocity = t5.Humanoid.RootPart.Velocity

			while true do
				if not t5.Started or not t5:IsCurrentWaypointReached() then
					break
				end

				t5:OnPointReached(true)
			end

			if t5.Started then
				t5.NextActionMoveDirection = t5.CurrentWaypointPosition - t5.CurrentHumanoidPosition

				if t5.NextActionMoveDirection.Magnitude > 0.000001 then
					t5.NextActionMoveDirection = t5.NextActionMoveDirection.Unit
				else
					t5.NextActionMoveDirection = Vector3.new(0, 0, 0)
				end

				if t5.CurrentWaypointNeedsJump then
					t5.NextActionJump = true
					t5.CurrentWaypointNeedsJump = false

					return
				end

				t5.NextActionJump = false

				return
			end

			return
		end
	end
	function t5.IsCurrentWaypointReached(_)
		local u292: boolean = if t5.CurrentWaypointPlaneNormal == Vector3.new(0, 0, 0) then true else t5.CurrentWaypointPlaneNormal:Dot(t5.CurrentHumanoidPosition) - t5.CurrentWaypointPlaneDistance < math.max(1, 0.0625 * -t5.CurrentWaypointPlaneNormal:Dot(t5.CurrentHumanoidVelocity))

		if u292 then
			t5.CurrentWaypointPosition = nil
			t5.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0)
			t5.CurrentWaypointPlaneDistance = 0
		end

		return u292
	end
	function t5.OnPointReached(_, p30)
		if p30 and not t5.Cancelled then
			if t5.setPointFunc then
				t5.setPointFunc(t5.CurrentPoint)
			end

			local n1 = t5.CurrentPoint + 1

			if n1 > #t5.pointList then
				if t5.stopTraverseFunc then
					t5.stopTraverseFunc()
				end

				t5.Finished:Fire()
				t5:Cleanup()

				return
			end

			local v296 = t5.pointList[t5.CurrentPoint]
			local v297 = t5.pointList[n1]
			local v298 = t5.Humanoid:GetState()
			local u299: boolean = true

			if v298 ~= Enum.HumanoidStateType.FallingDown then
				u299 = true

				if v298 ~= Enum.HumanoidStateType.Freefall then
					u299 = v298 == Enum.HumanoidStateType.Jumping
				end
			end

			if u299 then
				local u300: boolean = v297.Action == Enum.PathWaypointAction.Jump

				if not u300 and t5.CurrentPoint > 1 then
					local n2 = v296.Position - t5.pointList[t5.CurrentPoint - 1].Position
					local n3 = v297.Position - v296.Position
					local unit = Vector2.new(n2.x, n2.z).Unit
					local vector2 = Vector2.new(n3.x, n3.z)

					u300 = unit:Dot(vector2.Unit) < 0.996
				end

				if u300 then
					t5.Humanoid.FreeFalling:Wait()
					wait(0.1)
				end
			end

			t5:MoveToNextWayPoint(v296, v297, n1)

			return
		end

		t5.PathFailed:Fire()
		t5:Cleanup()
	end
	function t5.MoveToNextWayPoint(_, p32, p33, currentPoint)
		t5.CurrentWaypointPlaneNormal = p32.Position - p33.Position

		if not v6 or p33.Label ~= "Climb" then
			t5.CurrentWaypointPlaneNormal = Vector3.new(t5.CurrentWaypointPlaneNormal.X, 0, t5.CurrentWaypointPlaneNormal.Z)
		end

		if t5.CurrentWaypointPlaneNormal.Magnitude > 0.000001 then
			t5.CurrentWaypointPlaneNormal = t5.CurrentWaypointPlaneNormal.Unit
			t5.CurrentWaypointPlaneDistance = t5.CurrentWaypointPlaneNormal:Dot(p33.Position)
		else
			t5.CurrentWaypointPlaneNormal = Vector3.new(0, 0, 0)
			t5.CurrentWaypointPlaneDistance = 0
		end

		t5.CurrentWaypointNeedsJump = p33.Action == Enum.PathWaypointAction.Jump
		t5.CurrentWaypointPosition = p33.Position
		t5.CurrentPoint = currentPoint
		t5.Timeout = 0
	end
	function t5.Start(_, p36)
		if not t5.AgentCanFollowPath then
			t5.PathFailed:Fire()

			return
		end

		if t5.Started then
			return
		end

		t5.Started = true
		clickToMoveDisplay.CancelFailureAnimation()

		if u16 and (p36 == nil or p36) then
			local v311, v312 = clickToMoveDisplay.CreatePathDisplay(t5.pointList, t5.OriginalTargetPoint)

			t5.stopTraverseFunc = v311
			t5.setPointFunc = v312
		end

		if #t5.pointList > 0 then
			t5.HumanoidOffsetFromPath = Vector3.new(0, t5.pointList[1].Position.Y - t5.OriginPoint.Y, 0)
			t5.CurrentHumanoidPosition = t5.Humanoid.RootPart.Position + t5.HumanoidOffsetFromPath
			t5.CurrentHumanoidVelocity = t5.Humanoid.RootPart.Velocity
			t5.SeatedConn = t5.Humanoid.Seated:Connect(function(_, _)
				t5:OnPathInterrupted()
			end)
			t5.DiedConn = t5.Humanoid.Died:Connect(function()
				t5:OnPathInterrupted()
			end)
			t5.TeleportedConn = t5.Humanoid.RootPart:GetPropertyChangedSignal("CFrame"):Connect(function()
				t5:OnPathInterrupted()
			end)
			t5.CurrentPoint = 1
			t5:OnPointReached(true)

			return
		end

		t5.PathFailed:Fire()

		if t5.stopTraverseFunc then
			t5.stopTraverseFunc()
		end
	end

	v120 = t5.TargetPoint + t5.TargetSurfaceNormal * 1.5

	if v15 then
		local v135

		if u30 then
		else
			u30 = {}
			assert(u30, "")
			table.insert(u30, LocalPlayer and LocalPlayer.Character)
		end

		v135 = u30
		raycastParams.FilterDescendantsInstances = v135

		local v136 = workspace:Raycast(v120, Vector3.new(-0, -50, -0), raycastParams)

		if v136 then
			t5.TargetPoint = v136.Position
		end
	else
		local ray = Ray.new(v120, Vector3.new(0, -50, 0))
		local v139

		if u30 then
		else
			u30 = {}
			assert(u30, "")
			table.insert(u30, LocalPlayer and LocalPlayer.Character)
		end

		v139 = u30

		local v140, targetPoint = workspace:FindPartOnRayWithIgnoreList(ray, v139)

		if v140 then
			t5.TargetPoint = targetPoint
		end
	end

	t5:ComputePath()

	return t5
end
local function CheckAlive()
	local player: Player = LocalPlayer
	local character = player and player.Character
	local v144

	if character then
		local v145 = t3[player]

		if v145 and character == v145.Parent then
			v144 = v145
		else
			t3[player] = nil

			local humanoid = character:FindFirstChildOfClass("Humanoid")

			if humanoid then
				t3[player] = humanoid
			end

			v144 = humanoid
		end
	else
		v144 = nil
	end

	return v144 ~= nil and v144.Health > 0
end
local function GetEquippedTool(p39)
	if p39 == nil then
		return
	end

	for _, v in pairs(p39:GetChildren()) do
		if v:IsA("Tool") then
			return v
		end
	end
end

local u43 = nil
local connection = nil
local connection3 = nil

local function CleanupPath()
	if u43 then
		u43:Cancel()
		u43 = nil
	end

	if connection then
		connection:Disconnect()
		connection = nil
	end

	if connection3 then
		connection3:Disconnect()
		connection3 = nil
	end
end
local function HandleMoveTo(p40, p41, p42, p43, p44)
	if u43 then
		u43:Cancel()
		u43 = nil

		if connection then
			connection:Disconnect()
			connection = nil
		end

		if connection3 then
			connection3:Disconnect()
			connection3 = nil
		end
	end

	u43 = p40
	p40:Start(p44)
	connection = p40.Finished.Event:Connect(function()
		if u43 then
			u43:Cancel()
			u43 = nil
		end

		if connection then
			connection:Disconnect()
			connection = nil
		end

		if connection3 then
			connection3:Disconnect()
			connection3 = nil
		end

		local v313 = p42 and GetEquippedTool(p43)

		if v313 then
			v313:Activate()
		end
	end)
	connection3 = p40.PathFailed.Event:Connect(function()
		if u43 then
			u43:Cancel()
			u43 = nil
		end

		if connection then
			connection:Disconnect()
			connection = nil
		end

		if connection3 then
			connection3:Disconnect()
			connection3 = nil
		end

		if p44 == nil or p44 then
			local v314: boolean = u17

			if v314 then
				v314 = not u43 or not u43:IsActive()
			end

			if v314 then
				clickToMoveDisplay.PlayFailureAnimation()
			end

			clickToMoveDisplay.DisplayFailureWaypoint(p41)
		end
	end)
end
local function ShowPathFailedFeedback(p45)
	if u43 and u43:IsActive() then
		u43:Cancel()
	end

	if u17 then
		clickToMoveDisplay.PlayFailureAnimation()
	end

	clickToMoveDisplay.DisplayFailureWaypoint(p45)
end
function OnTap(list, p47, p48)
	local CurrentCamera: Camera = workspace.CurrentCamera
	local Character: Model = LocalPlayer.Character
	local player: Player = LocalPlayer
	local character = player and player.Character
	local v163

	if character then
		local v164 = t3[player]

		if v164 and character == v164.Parent then
			v163 = v164
		else
			t3[player] = nil

			local humanoid = character:FindFirstChildOfClass("Humanoid")

			if humanoid then
				t3[player] = humanoid
			end

			v163 = humanoid
		end
	else
		v163 = nil
	end

	if v163 == nil or not (v163.Health > 0) then
	elseif #list ~= 1 and not p47 then
		local v166 = #list >= 2 and CurrentCamera and GetEquippedTool(Character)

		if v166 then
			v166:Activate()
		end
	elseif CurrentCamera then
		local v167: Ray = CurrentCamera:ScreenPointToRay(list[1].X, list[1].Y)

		if v15 then
			local humanoid = nil
			local v169 = nil
			local t6

			if u30 then
			else
				u30 = {}
				assert(u30, "")
				table.insert(u30, LocalPlayer and LocalPlayer.Character)
			end

			t6 = u30

			if not t6 then
				t6 = {}
			end

			local v172

			while true do
				local u173: boolean = true

				raycastParams.FilterDescendantsInstances = t6
				v172 = workspace:Raycast(v167.Origin, v167.Direction * 1000, raycastParams)

				if v172 then
					local v174 = v172.Instance

					if not v174.CanCollide then
						repeat
							humanoid = v174:FindFirstChildOfClass("Humanoid")
							v169 = v174
							v174 = v174.Parent
						until not not humanoid or not v174

						if not humanoid and v174 then
							v169 = nil
							u173 = false
							table.insert(t6, v174)
						end
					end
				end

				if u173 then
					break
				end
			end

			if p48 and humanoid and starterGui:GetCore("AvatarContextMenuEnabled") and players:GetPlayerFromCharacter(humanoid.Parent) then
				if u43 then
					u43:Cancel()
					u43 = nil
				end

				if connection then
					connection:Disconnect()
					connection = nil
				end

				if connection3 then
					connection3:Disconnect()
					connection3 = nil
				end
			elseif v172 and Character then
				local v175 = v172.Position

				if p47 then
					v175 = p47
					v169 = nil
				end

				if u43 then
					u43:Cancel()
					u43 = nil
				end

				if connection then
					connection:Disconnect()
					connection = nil
				end

				if connection3 then
					connection3:Disconnect()
					connection3 = nil
				end

				local v176 = Pather(v175, v172.Normal)

				if v176:IsValidPath() then
					HandleMoveTo(v176, v175, v169, Character)

					return
				end

				v176:Cleanup()

				if u43 and u43:IsActive() then
					u43:Cancel()
				end

				if u17 then
					clickToMoveDisplay.PlayFailureAnimation()
				end

				clickToMoveDisplay.DisplayFailureWaypoint(v175)

				return
			end

			return
		end

		local ray = Ray.new(v167.Origin, v167.Direction * 1000)
		local raycast = t2.Raycast
		local v180

		if u30 then
		else
			u30 = {}
			assert(u30, "")
			table.insert(u30, LocalPlayer and LocalPlayer.Character)
		end

		v180 = u30

		local v181, v182, v183 = raycast(ray, true, v180)
		local v184, v185 = t2.FindCharacterAncestor(v181)

		if p48 and v185 and starterGui:GetCore("AvatarContextMenuEnabled") and players:GetPlayerFromCharacter(v185.Parent) then
			if u43 then
				u43:Cancel()
				u43 = nil
			end

			if connection then
				connection:Disconnect()
				connection = nil
			end

			if connection3 then
				connection3:Disconnect()
				connection3 = nil
			end

			return
		end

		if p47 then
			v182 = p47
			v184 = nil
		end

		if v182 and Character then
			if u43 then
				u43:Cancel()
				u43 = nil
			end

			if connection then
				connection:Disconnect()
				connection = nil
			end

			if connection3 then
				connection3:Disconnect()
				connection3 = nil
			end

			local v186 = Pather(v182, v183)

			if v186:IsValidPath() then
				HandleMoveTo(v186, v182, v184, Character)

				return
			end

			v186:Cleanup()

			if u43 and u43:IsActive() then
				u43:Cancel()
			end

			if u17 then
				clickToMoveDisplay.PlayFailureAnimation()
			end

			clickToMoveDisplay.DisplayFailureWaypoint(v182)

			return
		end
	end
end
local function DisconnectEvent(p49)
	if p49 then
		p49:Disconnect()
	end
end

local keyboard = require(script.Parent:WaitForChild("Keyboard"))
local object = setmetatable({}, keyboard)

object.__index = object

function object.new(p50)
	local v189 = keyboard.new(p50)
	local object2 = setmetatable(v189, object)

	object2.fingerTouches = {}
	object2.numUnsunkTouches = 0
	object2.mouse2DownTime = tick()
	object2.mouse2DownPos = Vector2.new()
	object2.mouse2UpTime = tick()
	object2.keyboardMoveVector = Vector3.new(0, 0, 0)
	object2.tapConn = nil
	object2.inputBeganConn = nil
	object2.inputChangedConn = nil
	object2.inputEndedConn = nil
	object2.humanoidDiedConn = nil
	object2.characterChildAddedConn = nil
	object2.onCharacterAddedConn = nil
	object2.characterChildRemovedConn = nil
	object2.renderSteppedConn = nil
	object2.menuOpenedConnection = nil
	object2.preferredInputChangedConnection = nil
	object2.running = false
	object2.wasdEnabled = false

	return object2
end
function object.DisconnectEvents(p51)
	local tapConn = p51.tapConn

	if tapConn then
		tapConn:Disconnect()
	end

	local inputBeganConn = p51.inputBeganConn

	if inputBeganConn then
		inputBeganConn:Disconnect()
	end

	local inputChangedConn = p51.inputChangedConn

	if inputChangedConn then
		inputChangedConn:Disconnect()
	end

	local inputEndedConn = p51.inputEndedConn

	if inputEndedConn then
		inputEndedConn:Disconnect()
	end

	local humanoidDiedConn = p51.humanoidDiedConn

	if humanoidDiedConn then
		humanoidDiedConn:Disconnect()
	end

	local characterChildAddedConn = p51.characterChildAddedConn

	if characterChildAddedConn then
		characterChildAddedConn:Disconnect()
	end

	local onCharacterAddedConn = p51.onCharacterAddedConn

	if onCharacterAddedConn then
		onCharacterAddedConn:Disconnect()
	end

	local renderSteppedConn = p51.renderSteppedConn

	if renderSteppedConn then
		renderSteppedConn:Disconnect()
	end

	local characterChildRemovedConn = p51.characterChildRemovedConn

	if characterChildRemovedConn then
		characterChildRemovedConn:Disconnect()
	end

	local menuOpenedConnection = p51.menuOpenedConnection

	if menuOpenedConnection then
		menuOpenedConnection:Disconnect()
	end

	local preferredInputChangedConnection = p51.preferredInputChangedConnection

	if preferredInputChangedConnection then
		preferredInputChangedConnection:Disconnect()
	end
end
function object.OnTouchBegan(p52, p53, p54)
	if p52.fingerTouches[p53] == nil and not p54 then
		p52.numUnsunkTouches = p52.numUnsunkTouches + 1
	end

	p52.fingerTouches[p53] = p54
end
function object.OnTouchChanged(p55, p56, p57)
	if p55.fingerTouches[p56] == nil then
		p55.fingerTouches[p56] = p57

		if not p57 then
			p55.numUnsunkTouches = p55.numUnsunkTouches + 1
		end
	end
end
function object.OnTouchEnded(p58, p59, _)
	if p58.fingerTouches[p59] ~= nil and p58.fingerTouches[p59] == false then
		p58.numUnsunkTouches = p58.numUnsunkTouches - 1
	end

	p58.fingerTouches[p59] = nil
end
function object.OnPreferredInputChanged(_)
	local Character: Model = LocalPlayer.Character

	if Character then
		local manualActivationOnly: boolean = userInputService.PreferredInput == Enum.PreferredInput.Touch

		for _, v in pairs(Character:GetChildren()) do
			if v:IsA("Tool") then
				v.ManualActivationOnly = manualActivationOnly
			end
		end
	end
end
function object.OnCharacterAdded(p62, p63)
	p62:DisconnectEvents()
	p62.inputBeganConn = userInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
		if input.UserInputType == Enum.UserInputType.Touch then
			p62:OnTouchBegan(input, gameProcessedEvent)
		end

		if p62.wasdEnabled and gameProcessedEvent == false and input.UserInputType == Enum.UserInputType.Keyboard and t1[input.KeyCode] then
			if u43 then
				u43:Cancel()
				u43 = nil
			end

			if connection then
				connection:Disconnect()
				connection = nil
			end

			if connection3 then
				connection3:Disconnect()
				connection3 = nil
			end

			clickToMoveDisplay.CancelFailureAnimation()
		end

		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			p62.mouse2DownTime = tick()
			p62.mouse2DownPos = input.Position
		end
	end)
	p62.inputChangedConn = userInputService.InputChanged:Connect(function(input: InputObject, gameProcessedEvent: boolean)
		if input.UserInputType == Enum.UserInputType.Touch then
			p62:OnTouchChanged(input, gameProcessedEvent)
		end
	end)
	p62.inputEndedConn = userInputService.InputEnded:Connect(function(input: InputObject, gameProcessedEvent: boolean)
		if input.UserInputType == Enum.UserInputType.Touch then
			p62:OnTouchEnded(input, gameProcessedEvent)
		end

		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			p62.mouse2UpTime = tick()

			local inputPosition: Vector3 = input.Position

			if p62.mouse2UpTime - p62.mouse2DownTime < 0.25 and (inputPosition - p62.mouse2DownPos).magnitude < 5 and (u43 or p62.keyboardMoveVector.Magnitude <= 0) then
				OnTap({ inputPosition })
			end
		end
	end)
	p62.tapConn = userInputService.TouchTap:Connect(function(touchPositions, gameProcessedEvent: boolean)
		if not gameProcessedEvent then
			OnTap(touchPositions, nil, true)
		end
	end)
	p62.menuOpenedConnection = guiService.MenuOpened:Connect(function()
		if u43 then
			u43:Cancel()
			u43 = nil
		end

		if connection then
			connection:Disconnect()
			connection = nil
		end

		if connection3 then
			connection3:Disconnect()
			connection3 = nil
		end
	end)

	local function OnCharacterChildAdded(p72)
		if userInputService.PreferredInput == Enum.PreferredInput.Touch and p72:IsA("Tool") then
			p72.ManualActivationOnly = true
		end

		if p72:IsA("Humanoid") then
			local humanoidDiedConn = p62.humanoidDiedConn

			if humanoidDiedConn then
				humanoidDiedConn:Disconnect()
			end

			p62.humanoidDiedConn = p72.Died:Connect(function()
			end)
		end
	end

	p62.characterChildAddedConn = p63.ChildAdded:Connect(function(p73)
		OnCharacterChildAdded(p73)
	end)
	p62.characterChildRemovedConn = p63.ChildRemoved:Connect(function(p74)
		if userInputService.PreferredInput == Enum.PreferredInput.Touch and p74:IsA("Tool") then
			p74.ManualActivationOnly = false
		end
	end)

	for _, v in pairs(p63:GetChildren()) do
		OnCharacterChildAdded(v)
	end

	p62.preferredInputChangedConnection = userInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function()
		p62:OnPreferredInputChanged()
	end)
end
function object.Start(p75)
	p75:Enable(true)
end
function object.Stop(p76)
	p76:Enable(false)
end
function object.CleanupPath(_)
	if u43 then
		u43:Cancel()
		u43 = nil
	end

	if connection then
		connection:Disconnect()
		connection = nil
	end

	if connection3 then
		connection3:Disconnect()
		connection3 = nil
	end
end
function object.Enable(p78, p79, p80, p81)
	if p79 then
		if not p78.running then
			if LocalPlayer.Character then
				p78:OnCharacterAdded(LocalPlayer.Character)
			end

			p78.onCharacterAddedConn = LocalPlayer.CharacterAdded:Connect(function(character: Model)
				p78:OnCharacterAdded(character)
			end)
			p78.running = true
		end

		p78.touchJumpController = p81

		if p78.touchJumpController then
			p78.touchJumpController:Enable(p78.jumpEnabled)
		end
	else
		if p78.running then
			p78:DisconnectEvents()

			if u43 then
				u43:Cancel()
				u43 = nil
			end

			if connection then
				connection:Disconnect()
				connection = nil
			end

			if connection3 then
				connection3:Disconnect()
				connection3 = nil
			end

			local v229 = userInputService.PreferredInput == Enum.PreferredInput.Touch and LocalPlayer.Character

			if v229 then
				for _, v in pairs(v229:GetChildren()) do
					if v:IsA("Tool") then
						v.ManualActivationOnly = false
					end
				end
			end

			p78.running = false
		end

		if p78.touchJumpController and not p78.jumpEnabled then
			p78.touchJumpController:Enable(true)
		end

		p78.touchJumpController = nil
	end

	keyboard.Enable(p78, p79)
	p78.wasdEnabled = p79 and p80 or false
	p78.enabled = p79
end
function object.OnRenderStepped(p83, p84)
	p83.isJumping = false

	if u43 then
		u43:OnRenderStepped(p84)

		if u43 then
			p83.moveVector = u43.NextActionMoveDirection
			p83.moveVectorIsCameraRelative = false

			if u43.NextActionJump then
				p83.isJumping = true
			end
		else
			p83.moveVector = p83.keyboardMoveVector
			p83.moveVectorIsCameraRelative = true
		end
	else
		p83.moveVector = p83.keyboardMoveVector
		p83.moveVectorIsCameraRelative = true
	end

	if p83.jumpRequested then
		p83.isJumping = true
	end
end
function object.UpdateMovement(p85, p86)
	if p86 == Enum.UserInputState.Cancel then
		p85.keyboardMoveVector = Vector3.new(0, 0, 0)
	elseif p85.wasdEnabled then
		p85.keyboardMoveVector = Vector3.new(p85.leftValue + p85.rightValue, 0, p85.forwardValue + p85.backwardValue)
	end
end
function object.UpdateJump(_)
end
function object.SetShowPath(_, p89)
	u16 = p89
end
function object.GetShowPath(_)
	return u16
end
function object.SetWaypointTexture(_, p92)
	clickToMoveDisplay.SetWaypointTexture(p92)
end
function object.GetWaypointTexture(_)
	return clickToMoveDisplay.GetWaypointTexture()
end
function object.SetWaypointRadius(_, p95)
	clickToMoveDisplay.SetWaypointRadius(p95)
end
function object.GetWaypointRadius(_)
	return clickToMoveDisplay.GetWaypointRadius()
end
function object.SetEndWaypointTexture(_, p98)
	clickToMoveDisplay.SetEndWaypointTexture(p98)
end
function object.GetEndWaypointTexture(_)
	return clickToMoveDisplay.GetEndWaypointTexture()
end
function object.SetWaypointsAlwaysOnTop(_, p101)
	clickToMoveDisplay.SetWaypointsAlwaysOnTop(p101)
end
function object.GetWaypointsAlwaysOnTop(_)
	return clickToMoveDisplay.GetWaypointsAlwaysOnTop()
end
function object.SetFailureAnimationEnabled(_, p104)
	u17 = p104
end
function object.GetFailureAnimationEnabled(_)
	return u17
end
function object.SetIgnoredPartsTag(_, p107)
	UpdateIgnoreTag(p107)
end
function object.GetIgnoredPartsTag(_)
	return u31
end
function object.SetUseDirectPath(_, p110)
	u18 = p110
end
function object.GetUseDirectPath(_)
	return u18
end
function object.SetAgentSizeIncreaseFactor(_, p113)
	n1 = p113 / 100 + 1
end
function object.GetAgentSizeIncreaseFactor(_)
	return (n1 - 1) * 100
end
function object.SetUnreachableWaypointTimeout(_, p116)
	n2 = p116
end
function object.GetUnreachableWaypointTimeout(_)
	return n2
end
function object.SetUserJumpEnabled(p118, p119)
	p118.jumpEnabled = p119

	if p118.touchJumpController then
		p118.touchJumpController:Enable(p119)
	end
end
function object.GetUserJumpEnabled(p120)
	return p120.jumpEnabled
end
function object.MoveTo(_, p122, p123, p124)
	local Character: Model = LocalPlayer.Character

	if Character == nil then
		return false
	end

	local v275 = Pather(p122, Vector3.new(0, 1, 0), p124)

	if v275 and v275:IsValidPath() then
		HandleMoveTo(v275, p122, nil, Character, p123)

		return true
	end

	return false
end

return object
