-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local t1: {[any]: any} = {}

local function isTarget(p1, p2)
	if p1:IsA("ParticleEmitter") then
		local u6: boolean = true

		if p1:GetAttribute("EmitCount") == nil then
			u6 = p1:GetAttribute("FromAbilityCast") ~= nil
		end

		if u6 and not p1.Enabled and p1:GetAttribute("RigAmbient") ~= true then
			return false
		end
	elseif not p1:IsA("Beam") then
		return false
	end

	local v7 = p1

	while v7 and v7 ~= p2 do
		if v7:GetAttribute("FromAbilityCast") ~= nil then
			return false
		end

		v7 = v7.Parent
	end

	return true
end

local module: {[any]: any} = {
	IsOn = function()
		return workspace:GetAttribute("ADSHideWeaponFX") ~= false
	end
}

function module.Hide(p3, p4)
	if not p4 or not module.IsOn() then
		return
	end

	local t3 = t1[p3]

	if not t3 then
		t3 = {
			saved = {},
			conns = {},
			rigs = {}
		}
		t1[p3] = t3
	end

	if t3.rigs[p4] then
		return
	end

	t3.rigs[p4] = true

	local function hideOne(p5)
		if t3.saved[p5] ~= nil or not isTarget(p5, p4) then
			return
		end

		t3.saved[p5] = p5.LocalTransparencyModifier
		p5.LocalTransparencyModifier = 1
	end

	for iterFirst, iterSecond in p4:GetDescendants() do
		if t3.saved[iterSecond] == nil and isTarget(iterSecond, p4) then
			t3.saved[iterSecond] = iterSecond.LocalTransparencyModifier
			iterSecond.LocalTransparencyModifier = 1
		end
	end

	table.insert(t3.conns, p4.DescendantAdded:Connect(function(p6)
		task.defer(function()
			if t1[p3] == t3 and p6:IsDescendantOf(p4) then
				local v24 = p6

				if t3.saved[v24] == nil then
					if not isTarget(v24, p4) then
						return
					end

					t3.saved[v24] = v24.LocalTransparencyModifier
					v24.LocalTransparencyModifier = 1

					return
				end

				return
			end
		end)
	end))

	local v14 = p4.Parent

	if v14 then
		table.insert(t3.conns, v14.ChildAdded:Connect(function(p7)
			if p7.Name == p4.Name and p7 ~= p4 then
				task.defer(function()
					if t1[p3] == t3 then
						module.Hide(p3, p7)
					end
				end)
			end
		end))
	end
end
function module.Restore(p8)
	local v16 = t1[p8]

	if not v16 then
		return
	end

	t1[p8] = nil

	for iterFirst, iterSecond in v16.conns, nil, nil do
		iterSecond:Disconnect()
	end

	for iterFirst2, iterSecond2 in v16.saved, nil, nil do
		iterFirst2.LocalTransparencyModifier = iterSecond2
	end
end

return module
