-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local userInputService: UserInputService = game:GetService("UserInputService")

require(script.Parent.AimAssistEnum)

local targetSelector = require(script.Parent.TargetSelector)
local aimAdjuster = require(script.Parent.AimAdjuster)
local module: {[any]: any} = {}

module.__index = module

function module.enable(p1)
	p1.enabled = true
	runService:BindToRenderStep("RevolverAimAssist_Start", Enum.RenderPriority.Camera.Value - 1, function()
		p1:startAimAssist()
	end)
	runService:BindToRenderStep("RevolverAimAssist_Apply", Enum.RenderPriority.Camera.Value + 1, function(p2)
		p1:applyAimAssist(p2)
	end)
end
function module.disable(p3)
	p3.enabled = false
	pcall(function()
		runService:UnbindFromRenderStep("RevolverAimAssist_Start")
	end)
	pcall(function()
		runService:UnbindFromRenderStep("RevolverAimAssist_Apply")
	end)
end
function module.getGamepadEligibility(p4)
	if userInputService.PreferredInput ~= Enum.PreferredInput.Gamepad or not p4.thumbstickStates then
		return false
	end

	for iterFirst, iterSecond in p4.thumbstickStates, nil, nil do
		if iterSecond > 0.1 then
			return true
		end
	end

	return false
end
function module.updateGamepadEligibility(p5, p6, p7)
	p5.thumbstickStates[p6] = Vector2.new(p7.X, p7.Y).Magnitude
end
function module.getTouchEligibility(p8)
	if userInputService.PreferredInput ~= Enum.PreferredInput.Touch or not p8.lastActiveTouch then
		return false
	end

	local lastActiveTouch = p8.lastActiveTouch
	local v16 = os.clock()

	return lastActiveTouch - v16 < 0.1
end
function module.updateTouchEligibility(p9)
	p9.lastActiveTouch = os.clock()
end
function module.setSubject(p10, p11)
	p10.subject = p11
	p10:startAimAssist()
end
function module.setType(p12, p13)
	p12.aimAdjuster:setType(p13)
end
function module.setRange(p14, p15)
	p14.targetSelector:setRange(p15)
end
function module.setFieldOfView(p16, p17)
	p16.targetSelector:setFieldOfView(p17)
end
function module.setSortingBehavior(p18, p19)
	p18.targetSelector:setSortingBehavior(p19)
end
function module.setIgnoreLineOfSight(p20, p21)
	p20.targetSelector:setIgnoreLineOfSight(p21)
end
function module.addTargetTag(p22, p23, p24)
	p22.targetSelector:addTargetTag(p23, p24)
end
function module.removeTargetTag(p25, p26)
	p25.targetSelector:removeTargetTag(p26)
end
function module.addPlayerTargets(p27, p28, p29, p30)
	p27.targetSelector:addPlayerTargets(p28, p29, p30)
end
function module.removePlayerTargets(p31)
	p31.targetSelector:removePlayerTargets()
end
function module.setMethodStrength(p32, p33, p34)
	p32.aimAdjuster:setMethodStrength(p33, p34)
end
function module.setEasingFunc(p35, p36, p37)
	p35.easingFuncs[p36] = p37
end
function module.startAimAssist(p38)
	if not p38.subject then
		return
	end

	p38.startingSubjectCFrame = p38.subject:GetPivot()
end
function module.applyAimAssist(p39, p40)
	if not p39.subject then
		return
	end

	local pivot = p39.subject:GetPivot()
	local v50 = nil

	if p39:getGamepadEligibility() or p39:getTouchEligibility() then
		v50 = p39.targetSelector:selectTarget(p39.subject)
	end

	local n1 = 1

	if v50 then
		for iterFirst, iterSecond in p39.easingFuncs, nil, nil do
			local v54 = iterSecond(v50[iterFirst])

			n1 *= v54
		end
	end

	local v55 = p39.aimAdjuster:adjustAim({
		subjectCFrame = pivot,
		startingCFrame = p39.startingSubjectCFrame,
		adjustmentStrength = n1,
		targetResult = v50,
		deltaTime = p40
	})

	p39.startingSubjectCFrame = v55
	p39.subject:PivotTo(v55)
end
function module.setCharacterFolder(p41, p42)
	p41.targetSelector:setCharacterFolder(p42)
end
function module.hasTarget(p43)
	if not p43.enabled or not p43.subject then
		return false
	end

	return p43.targetSelector:selectTarget(p43.subject) ~= nil
end
function module.new()
	local v59 = targetSelector.new()
	local v60 = aimAdjuster.new()
	local t2: {[any]: any} = {
		enabled = false,
		subject = nil,
		startingSubjectCFrame = nil,
		thumbstickStates = {},
		easingFuncs = {},
		targetSelector = v59,
		aimAdjuster = v60
	}

	setmetatable(t2, module)

	return t2
end
function module.destroy(p44)
	p44:disable()
end

return module
