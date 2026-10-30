-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")

require(script.Parent.TargetSelector)

local aimAssistEnum = require(script.Parent.AimAssistEnum)
local module: {[any]: any} = {}

module.__index = module

function module.new()
	local t2: {[any]: any} = {
		lastTargetInstance = nil,
		subjectVelocity = Vector3.new(0, 0, 0),
		type = aimAssistEnum.AimAssistType.Rotational,
		lastTargetPositions = {},
		strengthTable = {
			[aimAssistEnum.AimAssistMethod.Friction] = 0,
			[aimAssistEnum.AimAssistMethod.Tracking] = 0,
			[aimAssistEnum.AimAssistMethod.Centering] = 0
		}
	}

	setmetatable(t2, module)

	return t2
end
function module.setType(p1, p2)
	p1.type = p2
end
function module.setMethodStrength(p3, p4, p5)
	p3.strengthTable[p4] = math.clamp(p5, 0, 1)
end
function module.adjustAimFriction(p6, p7)
	local v12 = math.clamp(p6.strengthTable[aimAssistEnum.AimAssistMethod.Friction] * p7.adjustmentStrength, 0, 1)

	if p7.targetResult and not (v12 <= 0) then
		local v13 = p7.subjectCFrame

		if p7.startingCFrame then
			local v14 = nil

			if p6.type == aimAssistEnum.AimAssistType.Rotational then
				v14 = p7.startingCFrame.Rotation + p7.subjectCFrame.Position
			elseif p6.type == aimAssistEnum.AimAssistType.Translational then
				v14 = p7.subjectCFrame.Rotation + p7.startingCFrame.Position
			end

			v13 = p7.subjectCFrame:Lerp(v14, v12)
		end

		return v13
	end

	return p7.subjectCFrame
end
function module.adjustAimTracking(p8, p9)
	local v17 = math.clamp(p8.strengthTable[aimAssistEnum.AimAssistMethod.Tracking] * p9.adjustmentStrength, 0, 1)

	if p9.targetResult and not (v17 <= 0) then
		local positions = p9.targetResult.positions
		local weights = p9.targetResult.weights
		local v20 = p9.subjectCFrame

		for i = 1, #positions do
			local v22 = positions[i]
			local v23 = weights[i]
			local v24 = p8.lastTargetPositions[i]

			if not (v23 <= 0) then
				if p8.type == aimAssistEnum.AimAssistType.Rotational then
					local n1 = p9.startingCFrame.Rotation + p9.subjectCFrame.Position
					local unit = p9.startingCFrame:PointToObjectSpace(v24).Unit
					local v27 = n1:PointToObjectSpace(v22)
					local v28 = CFrame.fromRotationBetweenVectors(unit, v27.Unit)

					v27 = CFrame.identity:Lerp(v28, v17 * v23)
					v20 *= v27
				elseif p8.type == aimAssistEnum.AimAssistType.Translational then
					local v29 = Vector3.new():Lerp(v22 - (p9.subjectCFrame.Rotation + p9.startingCFrame.Position).Position - (v24 - p9.startingCFrame.Position), v17 * v23)

					v20 += v29
				end
			end
		end

		p8.lastTargetPositions = positions

		return v20
	end

	return p9.subjectCFrame
end
function module.adjustAimCentering(p10, p11)
	local v32 = math.clamp(p10.strengthTable[aimAssistEnum.AimAssistMethod.Centering] * p11.adjustmentStrength, 0, 1)

	if p11.targetResult and not (v32 <= 0) then
		local bestPosition = p11.targetResult.bestPosition
		local v34 = p11.subjectCFrame

		if p10.type == aimAssistEnum.AimAssistType.Rotational then
			v34 = CFrame.lookAt(p11.subjectCFrame.Position, bestPosition)
		elseif p10.type == aimAssistEnum.AimAssistType.Translational then
			v34 = p11.subjectCFrame.Rotation + bestPosition
		end

		if not p11.deltaTime then
			return p11.subjectCFrame:Lerp(v34, v32)
		end

		local v35, v36 = tweenService:SmoothDamp(p11.subjectCFrame, v34, p10.subjectVelocity, 1 - v32, math.huge, p11.deltaTime)

		p10.subjectVelocity = v36

		return v35
	end

	return p11.subjectCFrame
end
function module.adjustAim(p12, p13)
	local v39 = if p13.targetResult then p13.targetResult.instance else nil

	if v39 ~= p12.lastTargetInstance then
		p12.lastTargetInstance = v39
		p12.lastTargetPositions = if p13.targetResult then p13.targetResult.positions else {}
		p12.subjectVelocity = Vector3.new(0, 0, 0)
	end

	p13.subjectCFrame = p12:adjustAimFriction(p13)
	p13.subjectCFrame = p12:adjustAimTracking(p13)
	p13.subjectCFrame = p12:adjustAimCentering(p13)

	return p13.subjectCFrame
end

return module
