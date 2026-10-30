-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local commonUtils: Instance = script.Parent.Parent:WaitForChild("CommonUtils")
local connectionUtil = require(commonUtils:WaitForChild("ConnectionUtil"))
local vector3 = Vector3.new()
local module: {[any]: any} = {}

module.__index = module

function module.new()
	local object = setmetatable({}, module)

	object.enabled = false
	object.moveVector = vector3
	object.moveVectorIsCameraRelative = true
	object.isJumping = false
	object._connectionUtil = connectionUtil.new()

	return object
end
function module.GetMoveVector(p1)
	return p1.moveVector
end
function module.IsMoveVectorCameraRelative(p2)
	return p2.moveVectorIsCameraRelative
end
function module.GetIsJumping(p3)
	return p3.isJumping
end
function module.Enable(_, _)
	error("BaseCharacterController:Enable must be overridden in derived classes and should not be called.")

	return false
end

return module
