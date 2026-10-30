-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local userInputService: UserInputService = game:GetService("UserInputService")
local service = UserSettings():GetService("UserGameSettings")

local function round(p1)
	return (math.floor(p1 + 0.5))
end

local t1: {[any]: any} = {}

t1.__index = t1

function t1.new(p2, p3)
	return (setmetatable({ vel = 0, freq = p2, goal = p3, pos = p3 }, t1))
end
function t1.step(p4, p5)
	local n1 = p4.freq * 2 * 3.141592653589793
	local goal = p4.goal
	local vel = p4.vel
	local n2 = p4.pos - goal
	local v26 = math.exp(-n1 * p5)
	local n3 = (n2 * (n1 * p5 + 1) + vel * p5) * v26 + goal

	p4.pos = n3
	p4.vel = (vel * (1 - n1 * p5) - n2 * (n1 * n1 * p5)) * v26

	return n3
end

local module: {[any]: any} = {
	Spring = t1,
	map = function(p6, p7, p8, p9, p10)
		return (p6 - p7) * (p10 - p9) / (p8 - p7) + p9
	end,
	mapClamp = function(p11, p12, p13, p14, p15)
		local v38 = math.min(p14, p15)
		local v39 = math.max(p14, p15)

		return (math.clamp((p11 - p12) * (p15 - p14) / (p13 - p12) + p14, v38, v39))
	end,
	getLooseBoundingSphere = function(p16)
		local v41 = table.create(#p16)

		for k, v in pairs(p16) do
			v41[k] = v.Position
		end

		local v44 = v41[1]
		local v45 = v44
		local n1 = 0

		for _, v in ipairs(v41) do
			local magnitude = (v - v44).Magnitude

			if n1 < magnitude then
				v45 = v
				n1 = magnitude
			end
		end

		n1 = v45
		v44 = 0

		for _, v in ipairs(v41) do
			local v52 = (v - v45).Magnitude

			if v44 < v52 then
				n1 = v
				v44 = v52
			end
		end

		v44 = (v45 + n1) * 0.5

		local n2 = (v45 - n1).Magnitude * 0.5

		for _, v in ipairs(v41) do
			local v56 = (v - v44).Magnitude

			if v56 > n2 then
				v44 += (v56 - n2) * 0.5 * (v - v44).Unit
				n2 = (v56 + n2) * 0.5
			end
		end

		return v44, n2
	end,
	sanitizeAngle = function(p17)
		return (p17 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
	end,
	Round = function(p18, p19)
		local n1 = 10 ^ p19

		return math.floor(p18 * n1 + 0.5) / n1
	end,
	IsFinite = function(p20)
		return p20 == p20 and p20 ~= math.huge and p20 ~= -math.huge
	end
}

function module.IsFiniteVector3(p21)
	return module.IsFinite(p21.X) and module.IsFinite(p21.Y) and module.IsFinite(p21.Z)
end
function module.GetAngleBetweenXZVectors(p22, p23)
	return (math.atan2(p23.X * p22.Z - p23.Z * p22.X, p23.X * p22.X + p23.Z * p22.Z))
end
function module.RotateVectorByAngleAndRound(p24, p25, p26)
	if p24.Magnitude > 0 then
		local unit = p24.Unit
		local v69 = math.atan2(unit.Z, unit.X)
		local v70 = math.atan2(unit.Z, unit.X)

		return math.floor((v70 + p25) / p26 + 0.5) * p26 - v69
	end

	return 0
end
local function SCurveTranform(p27)
	local v72 = math.clamp(p27, -1, 1)

	if v72 >= 0 then
		return v72 * 0.35 / (0.35 - v72 + 1)
	end

	return -(-v72 * 0.8 / (v72 + 0.8 + 1))
end
local function toSCurveSpace(p28)
	return (math.abs(p28) * 2 - 1) * 1.1 - 0.1
end
local function fromSCurveSpace(p29)
	return p29 / 2 + 0.5
end
function module.GamepadLinearToCurve(p30)
	local function onAxis(p31)
		local n1: number = 1

		if p31 < 0 then
			n1 = -1
		end

		local absoluteValue = math.abs(p31)
		local absoluteValue2 = math.abs(absoluteValue)
		local v102 = math.clamp((absoluteValue2 * 2 - 1) * 1.1 - 0.1, -1, 1)

		return (math.clamp(((if v102 >= 0 then v102 * 0.35 / (0.35 - v102 + 1) else -(-v102 * 0.8 / (v102 + 0.8 + 1))) / 2 + 0.5) * n1, -1, 1))
	end

	local vector2New = Vector2.new
	local x = p30.X
	local n1: number = 1

	if x < 0 then
		n1 = -1
	end

	local absoluteValue = math.abs(x)
	local absoluteValue3 = math.abs(absoluteValue)
	local v82 = math.clamp((absoluteValue3 * 2 - 1) * 1.1 - 0.1, -1, 1)
	local v83 = math.clamp(((if v82 >= 0 then v82 * 0.35 / (0.35 - v82 + 1) else -(-v82 * 0.8 / (v82 + 0.8 + 1))) / 2 + 0.5) * n1, -1, 1)
	local y = p30.Y
	local n2: number = 1

	if y < 0 then
		n2 = -1
	end

	local absoluteValue4 = math.abs(y)
	local absoluteValue5 = math.abs(absoluteValue4)
	local v88 = math.clamp((absoluteValue5 * 2 - 1) * 1.1 - 0.1, -1, 1)

	v82 = math.clamp(((if v88 >= 0 then v88 * 0.35 / (0.35 - v88 + 1) else -(-v88 * 0.8 / (v88 + 0.8 + 1))) / 2 + 0.5) * n2, -1, 1)

	return vector2New(v83, v82)
end
function module.ConvertCameraModeEnumToStandard(p32)
	if p32 == Enum.TouchCameraMovementMode.Default then
		return Enum.ComputerCameraMovementMode.Follow
	end

	if p32 == Enum.ComputerCameraMovementMode.Default then
		return Enum.ComputerCameraMovementMode.Classic
	end

	if p32 == Enum.TouchCameraMovementMode.Classic or p32 == Enum.DevTouchCameraMovementMode.Classic or p32 == Enum.DevComputerCameraMovementMode.Classic or p32 == Enum.ComputerCameraMovementMode.Classic then
		return Enum.ComputerCameraMovementMode.Classic
	end

	if p32 == Enum.TouchCameraMovementMode.Follow or p32 == Enum.DevTouchCameraMovementMode.Follow or p32 == Enum.DevComputerCameraMovementMode.Follow or p32 == Enum.ComputerCameraMovementMode.Follow then
		return Enum.ComputerCameraMovementMode.Follow
	end

	if p32 == Enum.TouchCameraMovementMode.Orbital or p32 == Enum.DevTouchCameraMovementMode.Orbital or p32 == Enum.DevComputerCameraMovementMode.Orbital or p32 == Enum.ComputerCameraMovementMode.Orbital then
		return Enum.ComputerCameraMovementMode.Orbital
	end

	if p32 == Enum.ComputerCameraMovementMode.CameraToggle or p32 == Enum.DevComputerCameraMovementMode.CameraToggle then
		return Enum.ComputerCameraMovementMode.CameraToggle
	end

	if p32 == Enum.DevTouchCameraMovementMode.UserChoice or p32 == Enum.DevComputerCameraMovementMode.UserChoice then
		return Enum.DevComputerCameraMovementMode.UserChoice
	end

	return Enum.ComputerCameraMovementMode.Classic
end
local function getMouse()
	local LocalPlayer: Player = players.LocalPlayer

	if not LocalPlayer then
		players:GetPropertyChangedSignal("LocalPlayer"):Wait()
		LocalPlayer = players.LocalPlayer
	end

	assert(LocalPlayer)

	return LocalPlayer:GetMouse()
end

local s1 = ""
local u12 = nil

function module.setMouseIconOverride(icon)
	local LocalPlayer: Player = players.LocalPlayer

	if not LocalPlayer then
		players:GetPropertyChangedSignal("LocalPlayer"):Wait()
		LocalPlayer = players.LocalPlayer
	end

	assert(LocalPlayer)

	local mouse: Mouse = LocalPlayer:GetMouse()

	if mouse.Icon ~= u12 then
		s1 = mouse.Icon
	end

	mouse.Icon = icon
	u12 = icon
end
function module.restoreMouseIcon()
	local LocalPlayer: Player = players.LocalPlayer

	if not LocalPlayer then
		players:GetPropertyChangedSignal("LocalPlayer"):Wait()
		LocalPlayer = players.LocalPlayer
	end

	assert(LocalPlayer)

	local mouse: Mouse = LocalPlayer:GetMouse()

	if mouse.Icon == u12 then
		mouse.Icon = s1
	end

	u12 = nil
end

local default = Enum.MouseBehavior.Default
local u14 = nil

function module.setMouseBehaviorOverride(mouseBehavior)
	if userInputService.MouseBehavior ~= u14 then
		default = userInputService.MouseBehavior
	end

	userInputService.MouseBehavior = mouseBehavior
	u14 = mouseBehavior
end
function module.restoreMouseBehavior()
	if userInputService.MouseBehavior == u14 then
		userInputService.MouseBehavior = default
	end

	u14 = nil
end

local movementRelative = Enum.RotationType.MovementRelative
local u16 = nil

function module.setRotationTypeOverride(rotationType)
	if service.RotationType ~= u16 then
		movementRelative = service.RotationType
	end

	service.RotationType = rotationType
	u16 = rotationType
end
function module.restoreRotationType()
	if service.RotationType == u16 then
		service.RotationType = movementRelative
	end

	u16 = nil
end

return module
