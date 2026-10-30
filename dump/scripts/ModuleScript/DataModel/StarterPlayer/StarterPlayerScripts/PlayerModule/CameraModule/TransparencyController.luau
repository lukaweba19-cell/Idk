-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local vrService: VRService = game:GetService("VRService")
local t1: {[any]: any} = {
	"BasePart",
	"Decal",
	"Beam",
	"ParticleEmitter",
	"Trail",
	"Fire",
	"Smoke",
	"Sparkles",
	"Explosion"
}
local cameraUtils = require(script.Parent:WaitForChild("CameraUtils"))

local ok, result = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserHideCharacterParticlesInFirstPerson")
end)

local u6 = ok and result
local module: {[any]: any} = {}

module.__index = module

function module.new()
	local object = setmetatable({}, module)

	object.transparencyDirty = false
	object.enabled = false
	object.lastTransparency = nil
	object.descendantAddedConn = nil
	object.descendantRemovingConn = nil
	object.toolDescendantAddedConns = {}
	object.toolDescendantRemovingConns = {}
	object.cachedParts = {}

	return object
end
function module.HasToolAncestor(p1, p2)
	if p2.Parent == nil then
		return false
	end

	assert(p2.Parent, "")

	return p2.Parent:IsA("Tool") or p1:HasToolAncestor(p2.Parent)
end
function module.IsValidPartToModify(p3, p4)
	if u6 then
		for key, value in t1 do
			if p4:IsA(value) then
				return not p3:HasToolAncestor(p4)
			end
		end
	elseif p4:IsA("BasePart") or p4:IsA("Decal") then
		return not p3:HasToolAncestor(p4)
	end

	return false
end
function module.CachePartsRecursive(p5, p6)
	if p6 then
		if p5:IsValidPartToModify(p6) then
			p5.cachedParts[p6] = true
			p5.transparencyDirty = true
		end

		for _, v in pairs(p6:GetChildren()) do
			p5:CachePartsRecursive(v)
		end
	end
end
function module.TeardownTransparency(p7)
	for k, _ in pairs(p7.cachedParts) do
		k.LocalTransparencyModifier = 0
	end

	p7.cachedParts = {}
	p7.transparencyDirty = true
	p7.lastTransparency = nil

	if p7.descendantAddedConn then
		p7.descendantAddedConn:disconnect()
		p7.descendantAddedConn = nil
	end

	if p7.descendantRemovingConn then
		p7.descendantRemovingConn:disconnect()
		p7.descendantRemovingConn = nil
	end

	for k, v in pairs(p7.toolDescendantAddedConns) do
		v:Disconnect()
		p7.toolDescendantAddedConns[k] = nil
	end

	for k, v in pairs(p7.toolDescendantRemovingConns) do
		v:Disconnect()
		p7.toolDescendantRemovingConns[k] = nil
	end
end
function module.SetupTransparency(p8, p9)
	p8:TeardownTransparency()

	if p8.descendantAddedConn then
		p8.descendantAddedConn:disconnect()
	end

	p8.descendantAddedConn = p9.DescendantAdded:Connect(function(p10)
		if p8:IsValidPartToModify(p10) then
			p8.cachedParts[p10] = true
			p8.transparencyDirty = true

			return
		end

		if p10:IsA("Tool") then
			if p8.toolDescendantAddedConns[p10] then
				p8.toolDescendantAddedConns[p10]:Disconnect()
			end

			p8.toolDescendantAddedConns[p10] = p10.DescendantAdded:Connect(function(p11)
				p8.cachedParts[p11] = nil

				if p11:IsA("BasePart") or p11:IsA("Decal") then
					p11.LocalTransparencyModifier = 0
				end
			end)

			if p8.toolDescendantRemovingConns[p10] then
				p8.toolDescendantRemovingConns[p10]:disconnect()
			end

			p8.toolDescendantRemovingConns[p10] = p10.DescendantRemoving:Connect(function(p12)
				wait()

				if p9 and p12 and p12:IsDescendantOf(p9) and p8:IsValidPartToModify(p12) then
					p8.cachedParts[p12] = true
					p8.transparencyDirty = true
				end
			end)
		end
	end)

	if p8.descendantRemovingConn then
		p8.descendantRemovingConn:disconnect()
	end

	p8.descendantRemovingConn = p9.DescendantRemoving:connect(function(p13)
		if p8.cachedParts[p13] then
			p8.cachedParts[p13] = nil
			p13.LocalTransparencyModifier = 0
		end
	end)
	p8:CachePartsRecursive(p9)
end
function module.Enable(p14, p15)
	if p15 ~= p14.enabled then
		p14.enabled = p15
	end
end
function module.SetSubject(p16, p17)
	local OccupantParent = nil

	if p17 and p17:IsA("Humanoid") then
		OccupantParent = p17.Parent
	end

	if p17 and p17:IsA("VehicleSeat") and p17.Occupant then
		OccupantParent = p17.Occupant.Parent
	end

	if OccupantParent then
		p16:SetupTransparency(OccupantParent)

		return
	end

	p16:TeardownTransparency()
end
function module.Update(p18, p19)
	local CurrentCamera: Camera = workspace.CurrentCamera

	if CurrentCamera and p18.enabled then
		local magnitude = (CurrentCamera.Focus.p - CurrentCamera.CoordinateFrame.p).magnitude
		local n1 = magnitude < 2 and 1 - (magnitude - 0.5) / 1.5 or 0

		if n1 < 0.5 then
			n1 = 0
		end

		if p18.lastTransparency and n1 < 1 and p18.lastTransparency < 0.95 then
			local n2 = 2.8 * p19
			local v39 = math.clamp(n1 - p18.lastTransparency, -n2, n2)

			n1 = p18.lastTransparency + v39
		else
			p18.transparencyDirty = true
		end

		local v40 = cameraUtils.Round(n1, 2)

		n1 = math.clamp(v40, 0, 1)

		if p18.transparencyDirty or n1 ~= p18.lastTransparency then
			for k, _ in pairs(p18.cachedParts) do
				if vrService.VREnabled and vrService.AvatarGestures then
					local t3: {[any]: any} = {
						[Enum.AccessoryType.Hat] = true,
						[Enum.AccessoryType.Hair] = true,
						[Enum.AccessoryType.Face] = true,
						[Enum.AccessoryType.Eyebrow] = true,
						[Enum.AccessoryType.Eyelash] = true
					}

					if k.Parent:IsA("Accessory") and t3[k.Parent.AccessoryType] or k.Name == "Head" then
						k.LocalTransparencyModifier = n1
					else
						k.LocalTransparencyModifier = 0
					end
				else
					k.LocalTransparencyModifier = n1
				end
			end

			p18.transparencyDirty = false
			p18.lastTransparency = n1
		end
	end
end

return module
