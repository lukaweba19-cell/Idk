-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local util: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Util")
local shotPath = require(util:WaitForChild("ShotPath"))

local function buildCastAdapter(p1)
	return function(p2, p3, p4, p5)
		local filterDescendantsInstances: {[any]: any} = { workspace.Bin, workspace.Destructibles }
		local Character = p1.Character

		if Character then
			table.insert(filterDescendantsInstances, Character)
		end

		for iterFirst, iterSecond in players:GetPlayers() do
			if iterSecond ~= p1 and iterSecond.Character and iterSecond.Team == p1.Team then
				table.insert(filterDescendantsInstances, iterSecond.Character)
			end
		end

		for iterFirst2, iterSecond2 in workspace.Characters:GetChildren() do
			local humanoid = iterSecond2:FindFirstChildWhichIsA("Humanoid")

			if humanoid and humanoid.Health <= 0 then
				table.insert(filterDescendantsInstances, iterSecond2)
			end
		end

		for _, v in ipairs(p5) do
			table.insert(filterDescendantsInstances, v)
		end

		local raycastParams = RaycastParams.new()

		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams.FilterDescendantsInstances = filterDescendantsInstances
		raycastParams.IgnoreWater = true

		return workspace:Raycast(p2, p3 * p4, raycastParams)
	end
end
local function isCharacterPart(p6)
	local character = p6:FindFirstAncestorOfClass("Model")

	return character ~= nil and character:FindFirstChildOfClass("Humanoid") ~= nil
end
local function makeSegmentPart()
	local trajectorySegPart: Part = Instance.new("Part")

	trajectorySegPart.Name = "TrajectorySegPart"
	trajectorySegPart.Size = Vector3.new(0.1, 0.1, 0.1)
	trajectorySegPart.Transparency = 1
	trajectorySegPart.Anchored = true
	trajectorySegPart.CanCollide = false
	trajectorySegPart.CanQuery = false
	trajectorySegPart.CanTouch = false
	trajectorySegPart.CastShadow = false

	return trajectorySegPart
end

return {
	ComputeTrajectory = function(p7, p8, p9, p10)
		local floored = math.floor(p9)
		local v16 = math.clamp(floored, 0, 18)

		local v17 = shotPath.Build(p7, p8, function(p11, p12, p13, p14)
			local filterDescendantsInstances: {[any]: any} = { workspace.Bin, workspace.Destructibles }
			local Character = p10.Character

			if Character then
				table.insert(filterDescendantsInstances, Character)
			end

			for iterFirst, iterSecond in players:GetPlayers() do
				if iterSecond ~= p10 and iterSecond.Character and iterSecond.Team == p10.Team then
					table.insert(filterDescendantsInstances, iterSecond.Character)
				end
			end

			for iterFirst2, iterSecond2 in workspace.Characters:GetChildren() do
				local humanoid = iterSecond2:FindFirstChildWhichIsA("Humanoid")

				if humanoid and humanoid.Health <= 0 then
					table.insert(filterDescendantsInstances, iterSecond2)
				end
			end

			for _, v in ipairs(p14) do
				table.insert(filterDescendantsInstances, v)
			end

			local raycastParams = RaycastParams.new()

			raycastParams.FilterType = Enum.RaycastFilterType.Exclude
			raycastParams.FilterDescendantsInstances = filterDescendantsInstances
			raycastParams.IgnoreWater = true

			return workspace:Raycast(p11, p12 * p13, raycastParams)
		end, {
			maxRange = 1000,
			bounces = v16,
			maxBouncesCap = v16,
			isCharacterHit = isCharacterPart
		})

		local t1: {[any]: any} = {}

		for i, v in ipairs(v17) do
			table.insert(t1, {
				from = if i == 1 then p7 else v.from,
				to = v.hitPos
			})
		end

		return t1
	end,
	CreateVisual = function(parent, p16)
		local ricochetTrajectory: Folder = Instance.new("Folder")

		ricochetTrajectory.Name = "RicochetTrajectory"

		local t2: {[any]: any} = {}

		for i = 1, p16 do
			local part: Part = Instance.new("Part")

			part.Name = "TrajectorySegPart"
			part.Size = Vector3.new(0.1, 0.1, 0.1)
			part.Transparency = 1
			part.Anchored = true
			part.CanCollide = false
			part.CanQuery = false
			part.CanTouch = false
			part.CastShadow = false
			part.Name = "Seg_" .. i
			part.Parent = ricochetTrajectory

			local a0: Attachment = Instance.new("Attachment")

			a0.Name = "A0"
			a0.Parent = part

			local a1: Attachment = Instance.new("Attachment")

			a1.Name = "A1"
			a1.Parent = part

			local clone = game.ReplicatedStorage.FX.AbilityFX.Ricochet.PreviewLine:Clone()

			clone.Name = "Beam"
			clone.Attachment0 = a0
			clone.Attachment1 = a1
			clone.FaceCamera = true
			clone.Segments = 1
			clone.CurveSize0 = 0
			clone.CurveSize1 = 0
			clone.Enabled = false
			clone.Parent = part

			local part2: Part = Instance.new("Part")

			part2.Name = "Bounce_" .. i
			part2.Anchored = true
			part2.CanCollide = false
			part2.CanQuery = false
			part2.CanTouch = false
			part2.CastShadow = false
			part2.Transparency = 1
			part2.Parent = ricochetTrajectory
			table.insert(t2, { part = part, a0 = a0, a1 = a1, beam = clone, marker = part2 })
		end

		ricochetTrajectory.Parent = parent

		return { folder = ricochetTrajectory, segments = t2, maxSlots = p16 }
	end,
	GetMuzzlePosition = function(p17)
		local revolverRig = p17:FindFirstChild("RevolverRig")

		if not revolverRig then
			return nil
		end

		local foundChild = revolverRig:FindFirstChild("RevolverMuzzle", true)

		if foundChild and foundChild:IsA("Attachment") then
			return foundChild.WorldPosition
		end

		return nil
	end,
	UpdateVisual = function(p18, p19, p20)
		local n1: number = #p19

		for i = 1, p18.maxSlots do
			local v39 = p18.segments[i]

			if n1 >= i then
				local v40 = p19[i]
				local v41 = if i == 1 and p20 then p20 else v40.from
				local n2 = (v41 + v40.to) / 2
				local magnitude = (v40.to - v41).Magnitude

				if magnitude > 0.01 then
					v39.part.CFrame = CFrame.lookAt(n2, v40.to)
				else
					v39.part.CFrame = CFrame.new(n2)
				end

				v39.a0.CFrame = CFrame.new(0, 0, magnitude / 2)
				v39.a1.CFrame = CFrame.new(0, 0, -magnitude / 2)
				v39.beam.Enabled = true

				if n1 > i then
					v39.marker.Position = v40.to
				end
			else
				v39.beam.Enabled = false
			end
		end
	end,
	DestroyVisual = function(p21)
		if p21.folder and p21.folder.Parent then
			p21.folder:Destroy()
		end
	end
}
