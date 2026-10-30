-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local workspace: Workspace = game:GetService("Workspace")
local collectionService: CollectionService = game:GetService("CollectionService")
local players: Players = game:GetService("Players")
local aimAssistEnum = require(script.Parent.AimAssistEnum)
local LocalPlayer: Player = players.LocalPlayer
local module: {[any]: any} = {}

module.__index = module

local function onSameTeam(player, player2)
	if not player.Team or not player2.Team then
	elseif player.Team ~= player2.Team then
	elseif not player.Neutral and not player2.Neutral then
		return true
	end

	return false
end
local function getCenterPoint(p3)
	if p3:IsA("Model") then
		local v12, v13 = p3:GetBoundingBox()

		return v12.Position
	end

	if p3:IsA("BasePart") then
		return p3.ExtentsCFrame.Position
	end

	return p3:GetPivot().Position
end
function module._checkLineOfSight(_, p5, p6, p7)
	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = { p5, p6 }

	if LocalPlayer and LocalPlayer.Character then
		raycastParams:AddToFilter({ LocalPlayer.Character })
	end

	local pivot = p5:GetPivot()

	return workspace:Raycast(pivot.Position, p7, raycastParams) == nil
end
function module._checkPointHit(p8, p9, p10, p11)
	local pivot = p9:GetPivot()
	local n1 = p11 - pivot.Position
	local magnitude = n1.Magnitude
	local v27 = pivot.LookVector:Dot(n1.Unit)
	local v28 = math.clamp(v27, -1, 1)
	local v29 = math.acos(v28)

	v27 = math.deg(v29)

	local u30 = magnitude <= p8.range and v27 <= p8.fieldOfView / 2

	if u30 and not p8.ignoreLineOfSight then
		u30 = p8:_checkLineOfSight(p9, p10, n1)
	end

	return { hit = u30, angle = v27, distance = magnitude }
end
function module._getTargetPoints(_, p13, p14)
	if not p14 then
		local v34

		if p13:IsA("Model") then
			local v35, v36 = p13:GetBoundingBox()

			v34 = v35.Position
		elseif p13:IsA("BasePart") then
			v34 = p13.ExtentsCFrame.Position
		else
			v34 = p13:GetPivot().Position
		end

		return { v34 }
	end

	local t2: {[any]: any} = {}

	for iterFirst, iterSecond in p14 do
		for iterFirst2, iterSecond2 in p13:GetDescendants() do
			if iterSecond2:IsA("PVInstance") and collectionService:HasTag(iterSecond2, iterSecond) then
				local v42

				if iterSecond2:IsA("Model") then
					local v43, v44 = iterSecond2:GetBoundingBox()

					v42 = v43.Position
				elseif iterSecond2:IsA("BasePart") then
					v42 = iterSecond2.ExtentsCFrame.Position
				else
					v42 = iterSecond2:GetPivot().Position
				end

				table.insert(t2, v42)
			end
		end
	end

	return t2
end
function module.setRange(p15, p16)
	p15.range = p16
end
function module.setFieldOfView(p17, p18)
	p17.fieldOfView = p18
end
function module.setSortingBehavior(p19, p20)
	p19.sortingBehavior = p20
end
function module.setIgnoreLineOfSight(p21, p22)
	p21.ignoreLineOfSight = p22
end
function module.addTargetTag(p23, p24, p25)
	p23.tags[p24] = true
	p23.tagBones[p24] = p25
end
function module.removeTargetTag(p26, p27)
	p26.tags[p27] = nil
	p26.tagBones[p27] = nil
end
function module.addPlayerTargets(p28, p29, p30, p31)
	p28.targetPlayers = true
	p28.ignoreLocalPlayer = if p29 == nil then true else p29
	p28.ignoreTeammates = if p30 == nil then false else p30
	p28.playerBones = p31
end
function module.removePlayerTargets(p32)
	p32.targetPlayers = false
end
function module.setCharacterFolder(p33, p34)
	p33.characterFolder = p34
end
function module.getAllTargetPoints(p35)
	local t3: {[any]: any} = {}

	for iterFirst, iterSecond in p35.tags, nil, nil do
		local v69 = p35.tagBones[iterFirst]

		for iterFirst2, iterSecond2 in collectionService:GetTagged(iterFirst), nil, nil do
			if iterSecond2 and iterSecond2:IsA("PVInstance") then
				local v72 = p35:_getTargetPoints(iterSecond2, v69)

				table.insert(t3, { instance = iterSecond2, points = v72 })
			end
		end
	end

	if LocalPlayer and p35.targetPlayers then
		local playerBones = p35.playerBones

		for iterFirst3, iterSecond3 in players:GetPlayers() do
			if not p35.ignoreLocalPlayer or iterSecond3 ~= LocalPlayer then
				if p35.ignoreTeammates and (if iterSecond3.Team and LocalPlayer.Team then if iterSecond3.Team == LocalPlayer.Team then not iterSecond3.Neutral and not LocalPlayer.Neutral else false else false) then
					continue
				end

				if iterSecond3.Character and (not iterSecond3.Character:FindFirstChildOfClass("Humanoid") or not (iterSecond3.Character:FindFirstChildOfClass("Humanoid").Health <= 0)) then
					local Character = iterSecond3.Character
					local v77 = p35:_getTargetPoints(iterSecond3.Character, playerBones)

					table.insert(t3, { instance = Character, points = v77 })
				end
			end
		end
	end

	if p35.characterFolder then
		local t4: {[any]: any} = {}

		for key, value in t3 do
			if value.instance then
				t4[value.instance] = true
			end
		end

		for iterFirst4, iterSecond4 in p35.characterFolder:GetChildren() do
			if iterSecond4:IsA("Model") and not t4[iterSecond4] and iterSecond4:FindFirstChildOfClass("Humanoid") and not (iterSecond4:FindFirstChildOfClass("Humanoid").Health <= 0) and (not LocalPlayer or iterSecond4 ~= LocalPlayer.Character) then
				if p35.ignoreTeammates and LocalPlayer and players:GetPlayerFromCharacter(iterSecond4) and (if players:GetPlayerFromCharacter(iterSecond4).Team and LocalPlayer.Team then if players:GetPlayerFromCharacter(iterSecond4).Team == LocalPlayer.Team then not players:GetPlayerFromCharacter(iterSecond4).Neutral and not LocalPlayer.Neutral else false else false) then
					continue
				end

				local v83 = p35:_getTargetPoints(iterSecond4, p35.playerBones)

				table.insert(t3, { instance = iterSecond4, points = v83 })
			end
		end
	end

	return t3
end
function module.selectTarget(p36, p37)
	local t5: {[any]: any} = {
		instance = nil,
		bestPosition = Vector3.new(0, 0, 0),
		distance = 0,
		normalizedDistance = 0,
		angle = 0,
		normalizedAngle = 0,
		positions = {},
		weights = {}
	}
	local n1 = math.huge

	for iterFirst, iterSecond in p36:getAllTargetPoints(), nil, nil do
		local instance = iterSecond.instance
		local points = iterSecond.points

		for iterFirst2, iterSecond2 in points do
			local v94 = p36:_checkPointHit(p37, instance, iterSecond2)

			if v94.hit then
				local v95 = nil

				if p36.sortingBehavior == aimAssistEnum.AimAssistSortingBehavior.Angle then
					v95 = v94.angle
				elseif p36.sortingBehavior == aimAssistEnum.AimAssistSortingBehavior.Distance then
					v95 = v94.distance
				end

				if v95 and n1 > v95 then
					n1 = v95
					t5.distance = v94.distance
					t5.angle = v94.angle
					t5.instance = instance
					t5.bestPosition = iterSecond2
					t5.positions = points
				end
			end
		end
	end

	if not t5.instance then
		return nil
	end

	local t6: {[any]: any} = {}

	n1 = 0

	for iterFirst3, iterSecond3 in t5.positions, nil, nil do
		local v99 = p36:_checkPointHit(p37, t5.instance, iterSecond3)
		local n2 = 0

		if v99.hit then
			if p36.sortingBehavior == aimAssistEnum.AimAssistSortingBehavior.Angle then
				n2 = 1 / (v99.angle + 0.001)
			elseif p36.sortingBehavior == aimAssistEnum.AimAssistSortingBehavior.Distance then
				n2 = 1 / (v99.distance + 0.001)
			end
		end

		n1 += n2
		t6[iterFirst3] = n2
	end

	if n1 > 0 then
		for i = 1, #t6 do
			t6[i] = t6[i] / n1
		end
	end

	t5.weights = t6
	t5.normalizedDistance = t5.distance / p36.range
	t5.normalizedAngle = t5.angle / p36.fieldOfView * 2

	return t5
end
function module.new()
	local t7: {[any]: any} = {
		range = 100,
		fieldOfView = 20,
		targetPlayers = true,
		ignoreLineOfSight = false,
		ignoreLocalPlayer = true,
		ignoreTeammates = false,
		sortingBehavior = aimAssistEnum.AimAssistSortingBehavior.Angle,
		playerBones = {},
		tags = {},
		tagBones = {}
	}

	setmetatable(t7, module)

	return t7
end

return module
