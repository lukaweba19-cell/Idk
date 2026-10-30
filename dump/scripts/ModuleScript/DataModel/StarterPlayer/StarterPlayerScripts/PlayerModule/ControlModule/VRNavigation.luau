-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local vrService: VRService = game:GetService("VRService")
local userInputService: UserInputService = game:GetService("UserInputService")
local runService: RunService = game:GetService("RunService")
local players: Players = game:GetService("Players")
local pathfindingService: PathfindingService = game:GetService("PathfindingService")
local contextActionService: ContextActionService = game:GetService("ContextActionService")
local starterGui: StarterGui = game:GetService("StarterGui")
local commonUtils: Instance = script.Parent.Parent:WaitForChild("CommonUtils")
local flagUtil = require(commonUtils:WaitForChild("FlagUtil"))
local u10 = nil
local LocalPlayer: Player = players.LocalPlayer
local raycastParams = RaycastParams.new()

raycastParams.FilterType = Enum.RaycastFilterType.Exclude

local v13 = flagUtil.getUserFlag("UserRaycastUpdateAPI2")

local function IsFinite(p1)
	return p1 == p1 and p1 ~= math.huge and p1 ~= -math.huge
end
local function IsFiniteVector3(p2)
	local x = p2.x
	local u22: boolean = x == x and x ~= math.huge and x ~= -math.huge

	if u22 then
		local y = p2.y

		u22 = false

		if y == y then
			u22 = false

			if y ~= math.huge then
				u22 = y ~= -math.huge
			end
		end

		if u22 then
			local z = p2.z

			u22 = false

			if z == z then
				u22 = false

				if z ~= math.huge then
					u22 = z ~= -math.huge
				end
			end
		end
	end

	return u22
end

local movementUpdate: BindableEvent = Instance.new("BindableEvent")

movementUpdate.Name = "MovementUpdate"
movementUpdate.Parent = script
coroutine.wrap(function()
	local pathDisplay: Instance = script.Parent:WaitForChild("PathDisplay")

	if pathDisplay then
		u10 = require(pathDisplay)
	end
end)()

local baseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"))
local object = setmetatable({}, baseCharacterController)

object.__index = object

function object.new(control_action_priority)
	local v27 = baseCharacterController.new()
	local object2 = setmetatable(v27, object)

	object2.CONTROL_ACTION_PRIORITY = control_action_priority
	object2.navigationRequestedConn = nil
	object2.heartbeatConn = nil
	object2.currentDestination = nil
	object2.currentPath = nil
	object2.currentPoints = nil
	object2.currentPointIdx = 0
	object2.expectedTimeToNextPoint = 0
	object2.timeReachedLastPoint = tick()
	object2.moving = false
	object2.isJumpBound = false
	object2.moveLatch = false
	object2.userCFrameEnabledConn = nil

	return object2
end
function object.SetLaserPointerMode(_, p5)
	pcall(function()
		starterGui:SetCore("VRLaserPointerMode", p5)
	end)
end
function object.GetLocalHumanoid(_)
	local Character: Model = LocalPlayer.Character

	if not Character then
		return
	end

	for _, v in pairs(Character:GetChildren()) do
		if v:IsA("Humanoid") then
			return v
		end
	end

	return nil
end
function object.HasBothHandControllers(_)
	return vrService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) and vrService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand)
end
function object.HasAnyHandControllers(_)
	return vrService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) or vrService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand)
end
function object.IsMobileVR(_)
	return userInputService.TouchEnabled
end
function object.HasGamepad(_)
	return userInputService.GamepadEnabled
end
function object.ShouldUseNavigationLaser(p11)
	if p11:IsMobileVR() then
		return true
	end

	if p11:HasBothHandControllers() then
		return false
	end

	if not p11:HasAnyHandControllers() then
		return not p11:HasGamepad()
	end

	return true
end
function object.StartFollowingPath(p12, p13)
	currentPath = p13
	currentPoints = currentPath:GetPointCoordinates()
	currentPointIdx = 1
	moving = true
	timeReachedLastPoint = tick()

	local v42 = p12:GetLocalHumanoid()

	if v42 and v42.Torso and #currentPoints >= 1 then
		expectedTimeToNextPoint = (currentPoints[1] - v42.Torso.Position).magnitude / v42.WalkSpeed
	end

	movementUpdate:Fire("targetPoint", p12.currentDestination)
end
function object.GoToPoint(p14, p15)
	currentPath = true
	currentPoints = { p15 }
	currentPointIdx = 1
	moving = true

	local v45 = p14:GetLocalHumanoid()
	local n1 = (v45.Torso.Position - p15).magnitude / v45.WalkSpeed

	timeReachedLastPoint = tick()
	expectedTimeToNextPoint = n1
	movementUpdate:Fire("targetPoint", p15)
end
function object.StopFollowingPath(p16)
	currentPath = nil
	currentPoints = nil
	currentPointIdx = 0
	moving = false
	p16.moveVector = Vector3.new(0, 0, 0)
end
function object.TryComputePath(_, p18, p19)
	local n1: number = 0
	local v52 = nil

	while not v52 and n1 < 5 do
		v52 = pathfindingService:ComputeSmoothPathAsync(p18, p19, 200)
		n1 += 1

		if v52.Status == Enum.PathStatus.ClosestNoPath or v52.Status == Enum.PathStatus.ClosestOutOfRange then
			return nil
		end

		if v52 and v52.Status == Enum.PathStatus.FailStartNotEmpty then
			p18 += (p19 - p18).Unit
			v52 = nil
		end

		if v52 and v52.Status == Enum.PathStatus.FailFinishNotEmpty then
			p19 += Vector3.new(0, 1, 0)
			v52 = nil
		end
	end

	return v52
end
function object.OnNavigationRequest(p20, p21, _)
	local v56 = p21.Position
	local currentDestination = p20.currentDestination
	local x = v56.x
	local u59 = x == x and x ~= math.huge and x ~= -math.huge

	if u59 then
		local y = v56.y

		u59 = false

		if y == y then
			u59 = false

			if y ~= math.huge then
				u59 = y ~= -math.huge
			end
		end

		if u59 then
			local z = v56.z

			u59 = false

			if z == z then
				u59 = false

				if z ~= math.huge then
					u59 = z ~= -math.huge
				end
			end
		end
	end

	if not u59 then
		return
	end

	p20.currentDestination = v56
	v56 = p20:GetLocalHumanoid()

	if not v56 or not v56.Torso then
		return
	end

	u59 = v56.Torso.Position

	if (p20.currentDestination - u59).magnitude < 12 then
		p20:GoToPoint(p20.currentDestination)
	elseif currentDestination and not ((p20.currentDestination - currentDestination).magnitude > 4) then
		if moving then
			p20.currentPoints[#currentPoints] = p20.currentDestination

			return
		end

		p20:GoToPoint(p20.currentDestination)
	else
		local v62 = p20:TryComputePath(u59, p20.currentDestination)

		if v62 then
			p20:StartFollowingPath(v62)

			if u10 then
				u10.setCurrentPoints(p20.currentPoints)
				u10.renderPath()

				return
			end
		else
			p20:StopFollowingPath()

			if u10 then
				u10.clearRenderedPath()

				return
			end
		end
	end
end
function object.OnJumpAction(p23, _, p25, _)
	if p25 == Enum.UserInputState.Begin then
		p23.isJumping = true
	end

	return Enum.ContextActionResult.Sink
end
function object.BindJumpAction(p27, p28)
	if not p28 then
		if p27.isJumpBound then
			p27.isJumpBound = false
			contextActionService:UnbindAction("VRJumpAction")
		end
	elseif not p27.isJumpBound then
		p27.isJumpBound = true
		contextActionService:BindActionAtPriority("VRJumpAction", function()
			return p27:OnJumpAction()
		end, false, p27.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonA)

		return
	end
end
function object.ControlCharacterGamepad(p29, _, p31, input)
	if input.KeyCode ~= Enum.KeyCode.Thumbstick1 then
		return
	end

	if p31 == Enum.UserInputState.Cancel then
		p29.moveVector = Vector3.new(0, 0, 0)

		return
	end

	if p31 ~= Enum.UserInputState.End then
		p29:StopFollowingPath()

		if u10 then
			u10.clearRenderedPath()
		end

		if p29:ShouldUseNavigationLaser() then
			p29:BindJumpAction(true)
			p29:SetLaserPointerMode("Hidden")
		end

		if input.Position.magnitude > 0.22 then
			p29.moveVector = Vector3.new(input.Position.X, 0, -input.Position.Y)

			if p29.moveVector.magnitude > 0 then
				local unit = p29.moveVector.unit
				local v74 = math.min(1, input.Position.magnitude)

				p29.moveVector = unit * v74
			end

			p29.moveLatch = true
		end
	else
		p29.moveVector = Vector3.new(0, 0, 0)

		if p29:ShouldUseNavigationLaser() then
			p29:BindJumpAction(false)
			p29:SetLaserPointerMode("Navigation")
		end

		if p29.moveLatch then
			p29.moveLatch = false
			movementUpdate:Fire("offtrack")
		end
	end

	return Enum.ContextActionResult.Sink
end
function object.OnHeartbeat(p33, p34)
	local v77 = p33.moveVector
	local v78 = p33:GetLocalHumanoid()

	if not v78 or not v78.Torso then
		return
	end

	if p33.moving and p33.currentPoints then
		local TorsoPosition = v78.Torso.Position
		local n1 = (currentPoints[1] - TorsoPosition) * Vector3.new(1, 0, 1)
		local magnitude = n1.magnitude
		local n2 = n1 / magnitude

		if magnitude < 1 then
			local n3 = 0
			local v84 = currentPoints[1]

			for k, v in pairs(currentPoints) do
				if k ~= 1 then
					local v87 = (v - v84).magnitude

					v84 = v
					n3 += v87 / v78.WalkSpeed
				end
			end

			table.remove(currentPoints, 1)
			currentPointIdx += 1

			if #currentPoints == 0 then
				p33:StopFollowingPath()

				if u10 then
					u10.clearRenderedPath()
				end

				return
			end

			if u10 then
				u10.setCurrentPoints(currentPoints)
				u10.renderPath()
			end

			expectedTimeToNextPoint = (currentPoints[1] - TorsoPosition).magnitude / v78.WalkSpeed
			timeReachedLastPoint = tick()
		else
			if v13 then
				raycastParams.FilterDescendantsInstances = { game.Players.LocalPlayer.Character, workspace.CurrentCamera }

				local v88 = workspace:Raycast(TorsoPosition - Vector3.new(0, 1, 0), n2 * 3, raycastParams)

				if v88 then
					local n4 = workspace:Raycast(v88.Position + n2 * 0.5 + Vector3.new(0, 100, 0), Vector3.new(-0, -100, -0), raycastParams).Position.Y - TorsoPosition.Y

					if n4 < 6 and n4 > -2 then
						v78.Jump = true
					end
				end
			else
				local Character = game.Players.LocalPlayer.Character
				local CurrentCamera: Camera = workspace.CurrentCamera
				local ray = Ray.new(TorsoPosition - Vector3.new(0, 1, 0), n2 * 3)
				local t1: {[any]: any} = { Character, CurrentCamera }
				local v94, v95, v96 = workspace:FindPartOnRayWithIgnoreList(ray, t1)

				if v94 then
					local ray2 = Ray.new(v95 + n2 * 0.5 + Vector3.new(0, 100, 0), Vector3.new(-0, -100, -0))
					local v98, v99, v100 = workspace:FindPartOnRayWithIgnoreList(ray2, t1)
					local n5 = v99.Y - TorsoPosition.Y

					if n5 < 6 and n5 > -2 then
						v78.Jump = true
					end
				end
			end

			if tick() - timeReachedLastPoint > expectedTimeToNextPoint + 2 then
				p33:StopFollowingPath()

				if u10 then
					u10.clearRenderedPath()
				end

				movementUpdate:Fire("offtrack")
			end

			v77 = p33.moveVector:Lerp(n2, p34 * 10)
		end
	end

	local x = v77.x
	local u103: boolean = x == x and x ~= math.huge and x ~= -math.huge

	if u103 then
		local y = v77.y

		u103 = false

		if y == y then
			u103 = false

			if y ~= math.huge then
				u103 = y ~= -math.huge
			end
		end

		if u103 then
			local z = v77.z

			u103 = false

			if z == z then
				u103 = false

				if z ~= math.huge then
					u103 = z ~= -math.huge
				end
			end
		end
	end

	if u103 then
		p33.moveVector = v77
	end
end
function object.OnUserCFrameEnabled(p35)
	if p35:ShouldUseNavigationLaser() then
		p35:BindJumpAction(false)
		p35:SetLaserPointerMode("Navigation")

		return
	end

	p35:BindJumpAction(true)
	p35:SetLaserPointerMode("Hidden")
end
function object.Enable(p36, p37)
	p36.moveVector = Vector3.new(0, 0, 0)
	p36.isJumping = false

	if p37 then
		p36.navigationRequestedConn = vrService.NavigationRequested:Connect(function(cframe: CFrame, inputUserCFrame: Enum.UserCFrame)
			p36:OnNavigationRequest(cframe, inputUserCFrame)
		end)
		p36.heartbeatConn = runService.Heartbeat:Connect(function(deltaTime: number)
			p36:OnHeartbeat(deltaTime)
		end)
		contextActionService:BindAction("MoveThumbstick", function(p41, p42, p43)
			return p36:ControlCharacterGamepad(p41, p42, p43)
		end, false, p36.CONTROL_ACTION_PRIORITY, Enum.KeyCode.Thumbstick1)
		contextActionService:BindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
		p36.userCFrameEnabledConn = vrService.UserCFrameEnabled:Connect(function()
			p36:OnUserCFrameEnabled()
		end)
		p36:OnUserCFrameEnabled()
		vrService:SetTouchpadMode(Enum.VRTouchpad.Left, Enum.VRTouchpadMode.VirtualThumbstick)
		vrService:SetTouchpadMode(Enum.VRTouchpad.Right, Enum.VRTouchpadMode.ABXY)
		p36.enabled = true

		return
	end

	p36:StopFollowingPath()
	contextActionService:UnbindAction("MoveThumbstick")
	contextActionService:UnbindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
	p36:BindJumpAction(false)
	p36:SetLaserPointerMode("Disabled")

	if p36.navigationRequestedConn then
		p36.navigationRequestedConn:Disconnect()
		p36.navigationRequestedConn = nil
	end

	if p36.heartbeatConn then
		p36.heartbeatConn:Disconnect()
		p36.heartbeatConn = nil
	end

	if p36.userCFrameEnabledConn then
		p36.userCFrameEnabledConn:Disconnect()
		p36.userCFrameEnabledConn = nil
	end

	p36.enabled = false
end

return object
