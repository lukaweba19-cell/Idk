-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local contextActionService: ContextActionService = game:GetService("ContextActionService")
local module: {[any]: any} = {}

module.__index = module

function module.new(control_action_priority)
	local object = setmetatable({}, module)

	object.CONTROL_ACTION_PRIORITY = control_action_priority
	object.enabled = false
	object.vehicleSeat = nil
	object.throttle = 0
	object.steer = 0
	object.acceleration = 0
	object.decceleration = 0
	object.turningRight = 0
	object.turningLeft = 0
	object.vehicleMoveVector = Vector3.new(0, 0, 0)
	object.autoPilot = {}
	object.autoPilot.MaxSpeed = 0
	object.autoPilot.MaxSteeringAngle = 0

	return object
end
function module.BindContextActions(p2)
	contextActionService:BindActionAtPriority("throttleAccel", function(p3, p4, p5)
		p2:OnThrottleAccel(p3, p4, p5)

		return Enum.ContextActionResult.Pass
	end, false, p2.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonR2)
	contextActionService:BindActionAtPriority("throttleDeccel", function(p6, p7, p8)
		p2:OnThrottleDeccel(p6, p7, p8)

		return Enum.ContextActionResult.Pass
	end, false, p2.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonL2)
	contextActionService:BindActionAtPriority("arrowSteerRight", function(p9, p10, p11)
		p2:OnSteerRight(p9, p10, p11)

		return Enum.ContextActionResult.Pass
	end, false, p2.CONTROL_ACTION_PRIORITY, Enum.KeyCode.Right)
	contextActionService:BindActionAtPriority("arrowSteerLeft", function(p12, p13, p14)
		p2:OnSteerLeft(p12, p13, p14)

		return Enum.ContextActionResult.Pass
	end, false, p2.CONTROL_ACTION_PRIORITY, Enum.KeyCode.Left)
end
function module.Enable(p15, p16, p17)
	if p16 == p15.enabled and p17 == p15.vehicleSeat then
		return
	end

	p15.enabled = p16
	p15.vehicleMoveVector = Vector3.new(0, 0, 0)

	if not p16 then
		contextActionService:UnbindAction("throttleAccel")
		contextActionService:UnbindAction("throttleDeccel")
		contextActionService:UnbindAction("arrowSteerRight")
		contextActionService:UnbindAction("arrowSteerLeft")
		p15.vehicleSeat = nil
	elseif p17 then
		p15.vehicleSeat = p17
		p15:SetupAutoPilot()
		p15:BindContextActions()

		return
	end
end
function module.OnThrottleAccel(p18, _, p20, _)
	if p20 == Enum.UserInputState.End or p20 == Enum.UserInputState.Cancel then
		p18.acceleration = 0
	else
		p18.acceleration = -1
	end

	p18.throttle = p18.acceleration + p18.decceleration
end
function module.OnThrottleDeccel(p22, _, p24, _)
	if p24 == Enum.UserInputState.End or p24 == Enum.UserInputState.Cancel then
		p22.decceleration = 0
	else
		p22.decceleration = 1
	end

	p22.throttle = p22.acceleration + p22.decceleration
end
function module.OnSteerRight(p26, _, p28, _)
	if p28 == Enum.UserInputState.End or p28 == Enum.UserInputState.Cancel then
		p26.turningRight = 0
	else
		p26.turningRight = 1
	end

	p26.steer = p26.turningRight + p26.turningLeft
end
function module.OnSteerLeft(p30, _, p32, _)
	if p32 == Enum.UserInputState.End or p32 == Enum.UserInputState.Cancel then
		p30.turningLeft = 0
	else
		p30.turningLeft = -1
	end

	p30.steer = p30.turningRight + p30.turningLeft
end
function module.Update(p34, p35, p36, _)
	if not p34.vehicleSeat then
		return p35, false
	end

	if p36 then
		local vector3 = Vector3.new(p34.steer, 0, p34.throttle)
		local n1 = p35 + vector3

		p34.vehicleSeat.ThrottleFloat = -n1.Z
		p34.vehicleSeat.SteerFloat = n1.X

		return n1, true
	end

	local v31 = p34.vehicleSeat.Occupant.RootPart.CFrame:VectorToObjectSpace(p35)

	p34.vehicleSeat.ThrottleFloat = p34:ComputeThrottle(v31)
	p34.vehicleSeat.SteerFloat = p34:ComputeSteer(v31)

	return Vector3.new(0, 0, 0), true
end
function module.ComputeThrottle(_, p39)
	if p39 ~= Vector3.new(0, 0, 0) then
		return -p39.Z
	end

	return 0
end
function module.ComputeSteer(p40, p41)
	if p41 ~= Vector3.new(0, 0, 0) then
		return -math.atan2(-p41.x, -p41.z) * 57.29577951308232 / p40.autoPilot.MaxSteeringAngle
	end

	return 0
end
function module.SetupAutoPilot(p42)
	p42.autoPilot.MaxSpeed = p42.vehicleSeat.MaxSpeed
	p42.autoPilot.MaxSteeringAngle = 35
end

return module
