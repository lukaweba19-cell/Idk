-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {}

module.__index = module

local vector3New = Vector3.new
local mathNoise = math.noise

module.CameraShakeState = { FadingIn = 0, FadingOut = 1, Sustained = 2, Inactive = 3 }

function module.new(p1, p2, p3: number, p4: number)
	if p3 == nil then
		p3 = 0
	end

	if p4 == nil then
		p4 = 0
	end

	local typeName: string = type(p1)

	assert(typeName == "number", "Magnitude must be a number")

	local typeName2: string = type(p2)

	assert(typeName2 == "number", "Roughness must be a number")

	local typeName3: string = type(p3)

	assert(typeName3 == "number", "FadeInTime must be a number")

	local typeName4: string = type(p4)

	assert(typeName4 == "number", "FadeOutTime must be a number")

	local v12 = vector3New()
	local v13 = vector3New()

	return (setmetatable({
		DeleteOnInactive = true,
		roughMod = 1,
		magnMod = 1,
		_camShakeInstance = true,
		Magnitude = p1,
		Roughness = p2,
		PositionInfluence = v12,
		RotationInfluence = v13,
		fadeOutDuration = p4,
		fadeInDuration = p3,
		sustain = if p3 > 0 then true else false,
		currentFadeTime = if p3 > 0 then 0 else 1,
		tick = Random.new():NextNumber(-100, 100)
	}, module))
end
function module.UpdateShake(p5, p6)
	local tick = p5.tick
	local v17 = p5.currentFadeTime
	local v18 = mathNoise(tick, 0)
	local v19 = mathNoise(0, tick)
	local v20 = mathNoise(tick, tick)
	local v21 = vector3New(v18 * 0.5, v19 * 0.5, v20 * 0.5)

	if p5.fadeInDuration > 0 and p5.sustain then
		if v17 < 1 then
			v17 = math.min(1, v17 + p6 / p5.fadeInDuration)
		elseif p5.fadeOutDuration > 0 then
			p5.sustain = false
		end
	end

	if not p5.sustain then
		v17 = math.max(0, v17 - p6 / p5.fadeOutDuration)
	end

	if p5.sustain then
		p5.tick = tick + p6 * p5.Roughness * p5.roughMod
	else
		p5.tick = tick + p6 * p5.Roughness * p5.roughMod * v17
	end

	p5.currentFadeTime = v17

	return v21 * p5.Magnitude * p5.magnMod * v17
end
function module.StartFadeOut(p7, p8)
	if p8 == 0 then
		p7.currentFadeTime = 0
	end

	p7.fadeOutDuration = p8
	p7.fadeInDuration = 0
	p7.sustain = false
end
function module.StartFadeIn(p9, p10)
	if p10 == 0 then
		p9.currentFadeTime = 1
	end

	p9.fadeInDuration = p10 or p9.fadeInDuration
	p9.fadeOutDuration = 0
	p9.sustain = true
end
function module.GetScaleRoughness(p11)
	return p11.roughMod
end
function module.SetScaleRoughness(p12, p13)
	p12.roughMod = p13
end
function module.GetScaleMagnitude(p14)
	return p14.magnMod
end
function module.SetScaleMagnitude(p15, p16)
	p15.magnMod = p16
end
function module.GetNormalizedFadeTime(p17)
	return p17.currentFadeTime
end
function module.IsShaking(p18)
	local u34 = true

	if not (p18.currentFadeTime > 0) then
		u34 = p18.sustain
	end

	return u34
end
function module.IsFadingOut(p19)
	return not p19.sustain and p19.currentFadeTime > 0
end
function module.IsFadingIn(p20)
	local u37 = false

	if p20.currentFadeTime < 1 then
		u37 = p20.sustain and p20.fadeInDuration > 0
	end

	return u37
end
function module.GetState(p21)
	if p21:IsFadingIn() then
		return module.CameraShakeState.FadingIn
	end

	if p21:IsFadingOut() then
		return module.CameraShakeState.FadingOut
	end

	if p21:IsShaking() then
		return module.CameraShakeState.Sustained
	end

	return module.CameraShakeState.Inactive
end

return module
