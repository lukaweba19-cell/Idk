-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local module: {[any]: any} = {
	CardHeightScale = 0.95,
	CardGapPerCard = 0.16,
	CentreCardScale = 1.06,
	CentrePulseIn = tweenInfo,
	CentrePulseOut = tweenInfo2,
	SpringDamping = 2,
	SpringFrequency = 0.5,
	SkipDamping = 0.9,
	SkipFrequency = 8,
	SnapTime = 0.2
}

function module.ScrollDecayRate()
	local springDamping = module.SpringDamping
	local n1 = module.SpringFrequency * 2 * 3.141592653589793

	if springDamping <= 1 then
		return -springDamping * n1
	end

	local squareRoot = math.sqrt(springDamping * springDamping - 1)

	return -n1 * (springDamping - squareRoot)
end
function module.ScrollSpeedHalfLife()
	return 0.6931471805599453 / -module.ScrollDecayRate()
end

module.IntroRiseTime = 0.8
module.IntroSlashTime = 0.5
module.IntroButtonSwoopTime = 0.35
module.IntroLead = module.IntroRiseTime + module.IntroSlashTime + module.IntroButtonSwoopTime

return module
