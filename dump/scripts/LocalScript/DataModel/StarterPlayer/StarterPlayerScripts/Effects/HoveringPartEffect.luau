-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local collectionService: CollectionService = game:GetService("CollectionService")
local runService: RunService = game:GetService("RunService")
local LocalPlayer: Player = game:GetService("Players").LocalPlayer
local t1: {[any]: any} = {}

local function findOwningModel(p1)
	local v14 = p1.Parent

	while v14 do
		if v14:IsA("Model") and p1 == v14.PrimaryPart then
			return v14
		end

		v14 = v14.Parent
	end

	return nil
end
local function phaseFromName(p2)
	local n1 = 5381

	for i = 1, #p2 do
		local v18 = string.byte(p2, i)

		n1 = (n1 * 33 + v18) % 4294967296
	end

	return n1 % 10000 / 10000 * 3.141592653589793 * 2
end
local function weaponsGroupOf(p3)
	local v20 = findOwningModel(p3)
	local v21 = v20 and v20.Parent

	return v21 and v21.Name == "Weapons" and v21 or nil
end
local function respaceWeaponsGroup(p4)
	local t2: {[any]: any} = {}

	for k, v in pairs(t1) do
		if p4 == v.group then
			table.insert(t2, k)
		end
	end

	if #t2 == 0 then
		return
	end

	table.sort(t2, function(p5, p6)
		local v59 = p5:GetFullName()
		local n1 = 5381

		for i = 1, #v59 do
			local v62 = string.byte(v59, i)

			n1 = (n1 * 33 + v62) % 4294967296
		end

		local n2 = n1 % 10000 / 10000 * 3.141592653589793 * 2

		v59 = p6:GetFullName()
		n1 = 5381

		for i = 1, #v59 do
			local v65 = string.byte(v59, i)

			n1 = (n1 * 33 + v65) % 4294967296
		end

		local n3 = n1 % 10000 / 10000 * 3.141592653589793 * 2

		if n2 ~= n3 then
			return n2 < n3
		end

		n1 = p5:GetFullName()

		local v67 = p6:GetFullName()

		return n1 < v67
	end)

	local v26 = p4:GetFullName()
	local v27 = t2[1]:GetFullName()
	local s1: string = v26 .. "|" .. v27

	v26 = 5381

	for i = 1, #s1 do
		local v30 = string.byte(s1, i)

		v26 = (v26 * 33 + v30) % 4294967296
	end

	for i, v in ipairs(t2) do
		t1[v].phase = v26 % 10000 / 10000 * 3.141592653589793 * 2 + (i - 1) / #t2 * 3.141592653589793 * 2
	end
end
local function addPart(p7)
	if t1[p7] then
		return
	end

	local v34 = findOwningModel(p7)
	local v35 = v34 and v34.Parent
	local v36 = v35 and v35.Name == "Weapons" and v35 or nil
	v35 = { baseCFrame = p7.CFrame }
	local v37 = p7:GetFullName()
	local n1 = 5381

	for i = 1, #v37 do
		local v40 = string.byte(v37, i)

		n1 = (n1 * 33 + v40) % 4294967296
	end

	v35.phase = n1 % 10000 / 10000 * 3.141592653589793 * 2
	v35.model = findOwningModel(p7)
	v35.group = v36
	t1[p7] = v35

	if v36 then
		respaceWeaponsGroup(v36)
	end
end
local function removePart(p8)
	local v42 = t1[p8]

	t1[p8] = nil

	if v42 and v42.group then
		respaceWeaponsGroup(v42.group)
	end
end

for _, v in ipairs(collectionService:GetTagged("HoveringPart")) do
	if v:IsA("BasePart") then
		addPart(v)
	end
end

collectionService:GetInstanceAddedSignal("HoveringPart"):Connect(function(p9)
	if p9:IsA("BasePart") then
		addPart(p9)
	end
end)
collectionService:GetInstanceRemovedSignal("HoveringPart"):Connect(function(p10)
	if p10:IsA("BasePart") then
		local v45 = t1[p10]

		t1[p10] = nil

		if v45 and v45.group then
			respaceWeaponsGroup(v45.group)
		end
	end
end)
runService.Heartbeat:Connect(function()
	if LocalPlayer:GetAttribute("InMatch") == true then
		return
	end

	local n1 = os.clock() * 0.15 * 3.141592653589793 * 2

	for k, v in pairs(t1) do
		if not k:IsDescendantOf(workspace) then
			t1[k] = nil
		else
			local sine = math.sin(n1 + v.phase)
			local vBaseCFrame = v.baseCFrame
			local cFrameAngles = CFrame.Angles
			local sine2 = math.sin(n1 * 0.9 + v.phase)
			local sine3 = math.sin(n1 * 1.3 + v.phase * 1.7)
			local cFrame = cFrameAngles(sine2 * 0.03490658503988659, 0, sine3 * 0.03490658503988659)
			local vector3 = Vector3.new(0, (sine + 1) / 2 * 0.5, 0)
			local n2 = vBaseCFrame * cFrame + vector3

			if v.model and v.model.Parent then
				v.model:PivotTo(n2)
			else
				k.CFrame = n2
			end
		end
	end
end)
