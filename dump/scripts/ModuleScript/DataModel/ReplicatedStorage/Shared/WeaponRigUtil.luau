-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local knives: Instance = replicatedStorage:WaitForChild("Knives")
local revolvers: Instance = replicatedStorage:WaitForChild("Revolvers")
local t1: {[any]: any} = { Tag = "ClanTag", Rank = "ClanRank", Name = "ClanName" }

local module: {[any]: any} = {
	EnsureNoCollide = function(p1)
		for _, v in ipairs(p1:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
				v.CanQuery = false
				v.CanTouch = false
				v.Massless = true
			end
		end
	end,
	GetRootPart = function(p2, p3)
		local foundChild = p2:FindFirstChild(p3)

		if foundChild and foundChild:IsA("BasePart") then
			return foundChild
		end

		if p2.PrimaryPart and p2.PrimaryPart:IsA("BasePart") then
			return p2.PrimaryPart
		end

		for _, v in ipairs(p2:GetDescendants()) do
			if v:IsA("BasePart") then
				return v
			end
		end

		return nil
	end,
	GetKnifeTemplate = function(p4)
		local foundChild: Instance = knives:FindFirstChild(p4)

		if foundChild and foundChild:IsA("Model") then
			return foundChild
		end

		local default: Instance = knives:FindFirstChild("Default")

		if default and default:IsA("Model") then
			return default
		end

		return nil
	end,
	GetRevolverTemplate = function(p5)
		local foundChild: Instance = revolvers:FindFirstChild(p5)

		if foundChild and foundChild:IsA("Model") then
			return foundChild
		end

		local default: Instance = revolvers:FindFirstChild("Default")

		if default and default:IsA("Model") then
			return default
		end

		return nil
	end,
	ResolveClanSource = function(p6)
		if not p6 then
			return nil
		end

		local v22 = p6:IsA("Model") and players:GetPlayerFromCharacter(p6)

		if v22 then
			return v22
		end

		return p6
	end,
	ApplyClanLabels = function(p7, p8)
		if not p7 then
			return
		end

		for _, v in ipairs(p7:GetChildren()) do
			local v27 = t1[v.Name]

			if v27 ~= nil and v:IsA("BasePart") then
				local surfaceGui = v:FindFirstChildOfClass("SurfaceGui")
				local textLabel = surfaceGui and surfaceGui:FindFirstChildWhichIsA("TextLabel", true)

				if textLabel then
					local v30 = p8 and p8:GetAttribute(v27) or nil
					local s1 = ""

					if v.Name == "Rank" then
						if typeof(v30) == "number" and v30 >= 1 then
							local floored = math.floor(v30)

							s1 = "#" .. tostring(floored)
						end
					elseif typeof(v30) == "string" then
						s1 = v30
					end

					textLabel.Text = s1
				end
			end
		end
	end
}

function module.CloneRigTo(parent, name, p11, p12)
	local foundChild = parent:FindFirstChild(name)

	if foundChild and foundChild:IsA("Model") then
		foundChild:Destroy()
	end

	local clone = p11:Clone()

	clone.Name = name
	clone.Parent = parent

	local primaryPart = module.GetRootPart(clone, p12)

	if primaryPart then
		clone.PrimaryPart = primaryPart
	end

	module.EnsureNoCollide(clone)

	return clone, primaryPart
end
function module.ReconcileFromTemplate(parent, p14)
	if parent and p14 then
		local n1: number = 0

		for _, v in ipairs(p14:GetChildren()) do
			if not parent:FindFirstChild(v.Name) then
				local clone = v:Clone()

				for _, iterValue in ipairs(clone:GetDescendants()) do
					local t3 = nil

					if iterValue:IsA("Motor6D") or iterValue:IsA("Weld") then
						t3 = { iterValue.Part0, iterValue.Part1 }
					elseif iterValue:IsA("Constraint") then
						t3 = { iterValue.Attachment0, iterValue.Attachment1 }
					end

					for _, iterValue2 in ipairs(t3 or {}) do
						if iterValue2 and not iterValue2:IsDescendantOf(clone) then
							warn(("[WeaponRigUtil] ReconcileFromTemplate: %s.%s contains %s pointing at %s, which is outside the cloned child -- it still references the template and will not work on the rig."):format(p14.Name, v.Name, iterValue.ClassName, iterValue2:GetFullName()))
						end
					end
				end

				clone.Parent = parent
				n1 += 1
			end
		end

		if n1 > 0 then
			module.EnsureNoCollide(parent)
		end

		return n1
	end

	return 0
end
function module.GetWeldOverride(p15, p16)
	local foundChild = p15:FindFirstChild(p16)

	if foundChild and (not not foundChild:IsA("Weld") or not not foundChild:IsA("Motor6D")) then
		return foundChild.C0, foundChild.C1
	end

	return nil, nil
end
function module.FindMotor(p17, p18)
	for _, v in ipairs(p17:GetDescendants()) do
		if v:IsA("Motor6D") and p18 == v.Name then
			return v
		end
	end

	return nil
end
function module.BindMotor(p19, name, parent, part1, c0, c1)
	local v64 = module.FindMotor(p19, name)

	if not v64 then
		v64 = Instance.new("Motor6D")
		v64.Name = name
	end

	v64.Part0 = parent
	v64.Part1 = part1
	v64.C0 = c0
	v64.C1 = c1

	if parent ~= v64.Parent then
		v64.Parent = parent
	end
end
function module.DetachMotor(p25, p26)
	local v67 = module.FindMotor(p25, p26)

	if v67 then
		v67.Part0 = nil
		v67.Part1 = nil
		v67.Parent = nil
	end
end
function module.SetRigVisible(p27, enabled, p29)
	if not p27 then
		return
	end

	for iterFirst, iterSecond in p27:QueryDescendants("BasePart, ParticleEmitter, Beam, PointLight, SurfaceLight, SpotLight, Decal, Texture, SurfaceGui") do
		if not iterSecond.Parent or iterSecond.Parent.Name ~= "RevolverMuzzle" then
			if iterSecond:IsA("BasePart") then
				iterSecond.LocalTransparencyModifier = if enabled then 0 else 1
			elseif not iterSecond:IsA("Decal") and not iterSecond:IsA("Texture") then
				if iterSecond:IsA("ParticleEmitter") then
					if iterSecond.Enabled and iterSecond:GetAttribute("RigAmbient") == nil then
						iterSecond:SetAttribute("RigAmbient", true)
					end

					if iterSecond:GetAttribute("RigAmbient") == true or not iterSecond:GetAttribute("EmitCount") and not iterSecond:GetAttribute("FromAbilityCast") then
						iterSecond.Enabled = p29

						if not p29 then
							iterSecond:Clear()
						end
					end
				elseif iterSecond:IsA("SurfaceGui") then
					iterSecond.Enabled = enabled
				else
					iterSecond.Enabled = p29
				end
			else
				iterSecond.LocalTransparencyModifier = if enabled then 0 else 1
			end
		end
	end
end
function module.ApplyKnifeSkin(p30, p31, p32, p33)
	local v77 = module.GetKnifeTemplate(p31)

	if not v77 then
		return nil, nil
	end

	local v78, v79 = module.CloneRigTo(p30, "KnifeRig", v77, "KnifeRoot")

	module.ApplyClanLabels(v78, module.ResolveClanSource(p30))

	if not v79 then
		return v78, nil
	end

	local v80, v81 = module.GetWeldOverride(v79, "Equip")
	local cFrame = CFrame.new(0, -p32.Size.Y / 2, 0)
	local v83 = CFrame.Angles(-1.5707963267948966, 0, 0)

	module.BindMotor(p30, p33, p32, v79, v80 or cFrame * v83, v81 or CFrame.new(0, -1, -0.1))

	return v78, v79
end
function module.ApplyRevolverSkin(p34, p35, p36, p37)
	local v88 = module.GetRevolverTemplate(p35)

	if not v88 then
		return nil, nil
	end

	local v89, v90 = module.CloneRigTo(p34, "RevolverRig", v88, "RevolverRoot")

	module.ApplyClanLabels(v89, module.ResolveClanSource(p34))

	if not v90 then
		return v89, nil
	end

	local v91, v92 = module.GetWeldOverride(v90, "Equip")
	local cFrame = CFrame.new(0, -p36.Size.Y / 2 + 0.15, -0.35)
	local v94 = CFrame.Angles(-1.5707963267948966, 0, 0)

	module.BindMotor(p34, p37, p36, v90, v91 or cFrame * v94, v92 or CFrame.new(0, 0, 0))

	return v89, v90
end
function module.IsStaticOnHip(p38)
	if not p38 then
		return false
	end

	local foundChild = p38:FindFirstChild("StaticOnHip", true)
	local u97 = false

	if foundChild ~= nil then
		u97 = foundChild:IsA("BoolValue") and foundChild.Value == true
	end

	return u97
end
function module.GetADSSound(p39)
	if not p39 then
		return nil
	end

	local foundChild = p39:FindFirstChild("ADSSound", true)

	if foundChild and foundChild:IsA("StringValue") and foundChild.Value ~= "" then
		return foundChild.Value
	end

	return nil
end
function module.GetScopeType(p40)
	if not p40 then
		return nil
	end

	local foundChild = p40:FindFirstChild("ScopeType", true)

	if foundChild and foundChild:IsA("StringValue") and foundChild.Value ~= "" then
		return foundChild.Value
	end

	return nil
end
function module.ResetToBindPose(p41)
	if not p41 then
		return
	end

	for _, v in ipairs(p41:GetDescendants()) do
		if v:IsA("Motor6D") or v:IsA("Bone") then
			v.Transform = CFrame.identity
		end
	end
end

return module
