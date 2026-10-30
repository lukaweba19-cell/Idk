-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local v1 = CFrame.fromEulerAngles(0, -0.007853981633974483, 0)
local n1 = CFrame.new(-0.03, 0, 0) * v1

local module: {[any]: any} = {
	HoldCFrame = function(p1)
		local v5, v6, v7 = p1.cameraCF:ToEulerAnglesYXZ()
		local v8 = p1.viewmodelOffset or Vector3.new()
		local v9 = p1.sway

		if not v9 then
			v9 = Vector3.new()
		end

		local v10 = CFrame.Angles(0, p1.torsoY, p1.torsoZ)
		local cFrame = CFrame.new(v8.X, v8.Y, -v8.Z)
		local v12 = CFrame.Angles(0, -v6, 0)
		local v13 = CFrame.Angles(v9.Y, -v9.X / 4, v9.X / 8)

		return p1.cameraCF * cFrame * v12 * v10 * v13 * (p1.movement or CFrame.identity) * (p1.adsCorrection or CFrame.identity)
	end,
	ArmsWidth = function(p2, p3)
		if not p3 then
			return 0.75
		end

		local revolverRig = p2 and p2:FindFirstChild("RevolverRig")
		local revolverRoot = revolverRig and revolverRig:FindFirstChild("RevolverRoot")
		local v18 = revolverRoot

		if v18 then
			v18 = revolverRoot:FindFirstChild("ArmsWidth")
		end

		if v18 and v18:IsA("NumberValue") then
			return v18.Value
		end

		return 0.75
	end,
	Pose = function(p4, p5, p6)
		p4.leftArm.Size = Vector3.new(p6, 2, p6)
		p4.rightArm.Size = Vector3.new(p6, 2, p6)

		local v22 = p4.torso.CFrame:Inverse()
		local rightShoulder = p4.rightShoulder
		local v24 = CFrame.Angles(0, 1.5707963267948966, 0)
		local cFrame = CFrame.new(0, -1, p4.rightArm.Size.Y / 2)

		rightShoulder.C0 = v22 * (p5 * v24 * cFrame)

		local leftShoulder = p4.leftShoulder

		v24 = CFrame.Angles(0, -1.5707963267948966, 0)
		leftShoulder.C0 = v22 * (p5 * v24 * CFrame.new(0, -1, 1))
	end,
	ADS_LERP_SPEED = 10
}

function module.StepAdsAlpha(p7, p8, p9)
	if p7 < p8 then
		return (math.min(p7 + p9 * module.ADS_LERP_SPEED, p8))
	end

	if p7 > p8 then
		return (math.max(p7 - p9 * module.ADS_LERP_SPEED, p8))
	end

	return p7
end
function module.AdsCorrection(p10, p11)
	local revolverRig = p10 and p10:FindFirstChild("RevolverRig")
	local revolverRoot = revolverRig and revolverRig:FindFirstChild("RevolverRoot")
	local v34 = revolverRoot

	if v34 then
		v34 = revolverRoot:FindFirstChild("ADSOffset")
	end

	local v35 = v34 and v34:IsA("CFrameValue")

	return CFrame.identity:Lerp(v35 and v34.Value or n1, p11)
end
function module.AdsLift(p12, p13)
	return p12 + Vector3.new(0, 0.249, 0) * p13
end

return module
