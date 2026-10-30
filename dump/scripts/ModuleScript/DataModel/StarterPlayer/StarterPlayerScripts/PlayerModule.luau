-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local t1: {[any]: any} = {}

t1.__index = t1

function t1.new()
	local object = setmetatable({}, t1)

	object.cameras = require(script:WaitForChild("CameraModule"))
	object.controls = require(script:WaitForChild("ControlModule"))

	return object
end
function t1.GetCameras(p1)
	return p1.cameras
end
function t1.GetControls(p2)
	return p2.controls
end
function t1.GetClickToMoveController(p3)
	return p3.controls:GetClickToMoveController()
end

return t1.new()
