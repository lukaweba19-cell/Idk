-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {
	MODEL_NAME = "Offhand",
	FOLDER_NAME = "Offhands",
	ROOT_NAME = "OffhandRoot",
	MOTOR_PREFIX = "Offhand_",
	DEFAULT_LIMB = "Left Arm"
}

local function rootOf(p1)
	if p1.PrimaryPart then
		return p1.PrimaryPart
	end

	local foundChild = p1:FindFirstChild(module.ROOT_NAME)

	if foundChild and foundChild:IsA("BasePart") then
		return foundChild
	end

	for _, v in ipairs(p1:GetDescendants()) do
		if v:IsA("BasePart") then
			return v
		end
	end

	return nil
end
local function weldOverride(p2)
	local equip = p2:FindFirstChild("Equip")

	if equip and (not not equip:IsA("Motor6D") or not not equip:IsA("Weld")) then
		return equip.C0, equip.C1
	end

	return CFrame.identity, CFrame.identity
end
local function describe(p3)
	local v16 = rootOf(p3)

	if not v16 then
		return nil
	end

	local limb = p3:GetAttribute("Limb")

	if typeof(limb) ~= "string" or limb == "" then
		limb = module.DEFAULT_LIMB
	end

	local equip = v16:FindFirstChild("Equip")
	local v19
	local v20

	if equip and (not not equip:IsA("Motor6D") or not not equip:IsA("Weld")) then
		v19 = equip.C0
		v20 = equip.C1
	else
		v19 = CFrame.identity
		v20 = CFrame.identity
	end

	return {
		model = p3,
		root = v16,
		limbName = limb,
		motorName = module.MOTOR_PREFIX .. v16.Name,
		c0 = v19,
		c1 = v20
	}
end
function module.Collect(p4)
	local t2: {[any]: any} = {}

	if not p4 then
		return t2
	end

	local foundChild = p4:FindFirstChild(module.MODEL_NAME)

	if foundChild and foundChild:IsA("Model") then
		local v24 = describe(foundChild)

		if v24 then
			table.insert(t2, v24)
		end
	end

	local foundChild2 = p4:FindFirstChild(module.FOLDER_NAME)

	if foundChild2 then
		for _, v in ipairs(foundChild2:GetChildren()) do
			if v:IsA("Model") then
				local v28 = describe(v)

				if v28 then
					table.insert(t2, v28)
				end
			end
		end
	end

	return t2
end

module.DISPLAY_WELD_NAME = "DisplayWeld"

local function setDisplayWelds(p5, enabled)
	for _, v in ipairs(p5:GetDescendants()) do
		if v:IsA("JointInstance") and v.Name == module.DISPLAY_WELD_NAME then
			v.Enabled = enabled
		end
	end
end

module.HOLSTER_WELD_NAME = "Unequip"
module.HOLSTER_POSE_ENABLED = true

local function applyHolsterPose(p7)
	if not module.HOLSTER_POSE_ENABLED then
		return
	end

	for _, v in ipairs(p7:GetDescendants()) do
		if v:IsA("JointInstance") and v.Name == module.DISPLAY_WELD_NAME and v.Parent then
			local foundChild = v.Parent:FindFirstChild(module.HOLSTER_WELD_NAME)

			if foundChild and (not not foundChild:IsA("Weld") or not not foundChild:IsA("Motor6D")) then
				v.C0 = foundChild.C0
				v.C1 = foundChild.C1
			end
		end
	end
end
local function hasDisplayWeld(p8)
	for _, v in ipairs(p8:GetDescendants()) do
		if v:IsA("JointInstance") and v.Name == module.DISPLAY_WELD_NAME then
			return true
		end
	end

	return false
end
function module.Has(p9)
	return #module.Collect(p9) > 0
end
local function findMotor(p10, p11)
	for _, v in ipairs(p10:GetDescendants()) do
		if v:IsA("Motor6D") and p11 == v.Name then
			return v
		end
	end

	return nil
end
function module.Attach(p12, p13, p14)
	local n1: number = 0

	for _, v in ipairs(module.Collect(p13)) do
		local vlimbName = p12:FindFirstChild(v.limbName)

		if (not vlimbName or not vlimbName:IsA("BasePart")) and p14 and p14.Name == v.limbName and p14:IsDescendantOf(p12) then
			vlimbName = p14
		end

		if vlimbName and vlimbName:IsA("BasePart") then
			setDisplayWelds(v.model, false)

			local v52 = findMotor(p12, v.motorName)

			if not v52 then
				local motor6D: Motor6D = Instance.new("Motor6D")

				motor6D.Name = v.motorName
				v52 = motor6D
			end

			v52.Part0 = vlimbName
			v52.Part1 = v.root
			v52.C0 = v.c0
			v52.C1 = v.c1

			if vlimbName ~= v52.Parent then
				v52.Parent = vlimbName
			end

			n1 += 1
		end
	end

	return n1
end
function module.Detach(p15, p16)
	if p16 then
		for _, v in ipairs(module.Collect(p16)) do
			local v58 = findMotor(p15, v.motorName)

			if v58 then
				v58.Part0 = nil
				v58.Part1 = nil
				v58.Parent = nil
			end

			setDisplayWelds(v.model, true)
			applyHolsterPose(v.model)
		end

		return
	end

	for _, v in ipairs(p15:GetDescendants()) do
		if v:IsA("Motor6D") and v.Name:sub(1, #module.MOTOR_PREFIX) == module.MOTOR_PREFIX then
			local vPart1 = v.Part1

			if vPart1 and vPart1.Parent then
				setDisplayWelds(vPart1.Parent, true)
			end

			v.Part0 = nil
			v.Part1 = nil
			v.Parent = nil
		end
	end
end

module.STAYS_ON_THROW_ATTR = "StaysOnThrow"
module.HIDE_ON_HIP_ATTR = "HideOnHip"

function module.SetVisible(p17, p18, p19, p20)
	for _, v in ipairs(module.Collect(p17)) do
		local v68 = p18 or p19 == true and hasDisplayWeld(v.model)

		if not v68 then
			v68 = false

			if p20 == true then
				v68 = v.model:GetAttribute(module.STAYS_ON_THROW_ATTR) == true
			end
		end

		if not p18 and p19 == true and p20 ~= true and v.model:GetAttribute(module.HIDE_ON_HIP_ATTR) == true then
			v68 = false
		end

		local attributeValue = v.model:GetAttribute(module.HIDE_ON_HIP_ATTR)

		for iterFirst, iterSecond in v.model:QueryDescendants("BasePart, ParticleEmitter, Beam, PointLight, SurfaceLight, SpotLight, Decal, Texture") do
			if iterSecond:IsA("BasePart") or iterSecond:IsA("Decal") or iterSecond:IsA("Texture") then
				iterSecond.LocalTransparencyModifier = if v68 then 0 else 1

				if attributeValue == true then
					local offhandBaseTransparency = iterSecond:GetAttribute("OffhandBaseTransparency")

					if typeof(offhandBaseTransparency) ~= "number" then
						offhandBaseTransparency = iterSecond.Transparency
						iterSecond:SetAttribute("OffhandBaseTransparency", offhandBaseTransparency)
					end

					iterSecond.Transparency = if v68 then offhandBaseTransparency else 1
				end
			elseif iterSecond:IsA("ParticleEmitter") or iterSecond:IsA("Beam") or iterSecond:IsA("PointLight") or iterSecond:IsA("SurfaceLight") or iterSecond:IsA("SpotLight") then
				iterSecond.Enabled = v68
			end
		end
	end
end

return module
