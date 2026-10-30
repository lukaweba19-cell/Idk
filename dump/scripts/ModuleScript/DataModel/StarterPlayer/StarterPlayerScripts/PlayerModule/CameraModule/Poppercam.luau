-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local commonUtils: Instance = script.Parent.Parent:WaitForChild("CommonUtils")
local flagUtil = require(commonUtils:WaitForChild("FlagUtil"))
local zoomController = require(script.Parent:WaitForChild("ZoomController"))
local v4 = flagUtil.getUserFlag("UserFixCameraFPError")
local t1: {[any]: any} = {}

t1.__index = t1

local cFrame = CFrame.new()

local function cframeToAxis(p1)
	local v13, v14 = p1:ToAxisAngle()

	return v13 * v14
end
local function axisToCFrame(p2)
	local magnitude = p2.Magnitude

	if magnitude > 0.00001 then
		return CFrame.fromAxisAngle(p2, magnitude)
	end

	return cFrame
end
local function extractRotation(p3)
	local v18, v19, v20, v21, v22, v23, v24, v25, v26, v27, v28, v29 = p3:GetComponents()

	return CFrame.new(0, 0, 0, v21, v22, v23, v24, v25, v26, v27, v28, v29)
end
function t1.new()
	return (setmetatable({ lastCFrame = nil }, t1))
end
function t1.Step(p4, p5, p6)
	local v33 = p4.lastCFrame or p6

	p4.lastCFrame = p6

	local v34 = p6.Position
	local v35, v36, v37, v38, v39, v40, v41, v42, v43, v44, v45, v46 = p6:GetComponents()
	local cFrame2 = CFrame.new(0, 0, 0, v38, v39, v40, v41, v42, v43, v44, v45, v46)
	local p = v33.p
	local v49, v50, v51, v52, v53, v54, v55, v56, v57, v58, v59, v60 = v33:GetComponents()
	local cFrame3 = CFrame.new(0, 0, 0, v52, v53, v54, v55, v56, v57, v58, v59, v60)
	local n1 = (v34 - p) / p5
	local v63 = cFrame3:inverse()
	local v64, v65 = (cFrame2 * v63):ToAxisAngle()
	local n2 = v64 * v65 / p5

	return {
		extrapolate = function(p7)
			local n3 = n2 * p7
			local magnitude = n3.Magnitude
			local v93

			if magnitude > 0.00001 then
				v93 = CFrame.fromAxisAngle(n3, magnitude)
			else
				v93 = cFrame
			end

			return v93 * cFrame2 + (n1 * p7 + v34)
		end,
		posVelocity = n1,
		rotVelocity = n2
	}
end
function t1.Reset(p8)
	p8.lastCFrame = nil
end

local baseOcclusion = require(script.Parent:WaitForChild("BaseOcclusion"))
local object = setmetatable({}, baseOcclusion)

object.__index = object

function object.new()
	local v68 = baseOcclusion.new()
	local object2 = setmetatable(v68, object)

	object2.focusExtrapolator = t1.new()

	return object2
end
function object.GetOcclusionMode(_)
	return Enum.DevCameraOcclusionMode.Zoom
end
function object.Enable(p10, _)
	p10.focusExtrapolator:Reset()
end
function object.Update(p12, p13, p14, p15, _)
	local n1

	if v4 then
		n1 = CFrame.lookAlong(p15.p, -p14.LookVector) * CFrame.new(0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	else
		n1 = CFrame.new(p15.p, p14.p) * CFrame.new(0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	end

	local v79 = p12.focusExtrapolator:Step(p13, n1)
	local v80 = zoomController.Update(p13, n1, v79)
	local cFrame4 = CFrame.new(0, 0, v80)

	return n1 * cFrame4, p15
end
function object.CharacterAdded(_, _, _)
end
function object.CharacterRemoving(_, _, _)
end
function object.OnCameraSubjectChanged(_, _)
end

return object
