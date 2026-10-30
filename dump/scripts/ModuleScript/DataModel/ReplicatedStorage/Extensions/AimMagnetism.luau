-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")

game:GetService("RunService")

local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local extensions: Instance = replicatedStorage:WaitForChild("Extensions")
local inputCategorizer = require(extensions:WaitForChild("InputCategorizer"))
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local smokeOcclusion = require(shared:WaitForChild("SmokeOcclusion"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local crosshairSettings = require(replicatedStorageShared:WaitForChild("CrosshairSettings"))
local v9: Instance = replicatedStorage:WaitForChild("Shared")
local viewedPlayer = require(v9:WaitForChild("ViewedPlayer"))
local LocalPlayer: Player = players.LocalPlayer
local module: {[any]: any} = {}

module.__index = module

local u13: boolean = false
local characterFolder = nil
local u15 = true
local t2: {[any]: any} = {}
local t3: {[any]: any} = {}
local u18 = nil
local u19 = nil
local u20: boolean = false
local n1 = 0
local n2 = -1

local function inputQualifies()
	local v34 = inputCategorizer.getLastInputCategory()
	local u35: boolean = true

	if v34 ~= inputCategorizer.InputCategory.Gamepad then
		u35 = v34 == inputCategorizer.InputCategory.Touch
	end

	return u35
end
local function getScreenCenter()
	local viewportSize: Vector2 = workspace.CurrentCamera.ViewportSize
	local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local cursor: Instance = playerGui and playerGui:FindFirstChild("Cursor")

	if cursor then
		return Vector2.new(viewportSize.X / 2, cursor.AbsoluteSize.Y / 2)
	end

	return Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
end
local function isEnemy(character)
	if LocalPlayer.Character and character == LocalPlayer.Character then
		return false
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if humanoid and not (humanoid.Health <= 0) then
		local predictedHealth = humanoid:GetAttribute("PredictedHealth")

		if typeof(predictedHealth) == "number" and predictedHealth <= 0 then
			return false
		end

		if u15 then
			local player: Player = players:GetPlayerFromCharacter(character)

			if player and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
				return false
			end

			local matchSide: any = LocalPlayer:GetAttribute("MatchSide")

			if typeof(matchSide) == "string" and matchSide == character:GetAttribute("MatchSide") then
				return false
			end

			return true
		end

		return true
	end

	return false
end
local function getPartCorners(p2)
	local cFrame = p2.CFrame
	local n1 = p2.Size.X / 2
	local n2 = p2.Size.Y / 2
	local n3 = p2.Size.Z / 2
	local vector3 = Vector3.new(n1, n2, n3)
	local v50 = cFrame:PointToWorldSpace(vector3)
	local vector32 = Vector3.new(n1, n2, -n3)
	local v52 = cFrame:PointToWorldSpace(vector32)
	local vector33 = Vector3.new(n1, -n2, n3)
	local v54 = cFrame:PointToWorldSpace(vector33)
	local vector34 = Vector3.new(n1, -n2, -n3)
	local v56 = cFrame:PointToWorldSpace(vector34)
	local vector35 = Vector3.new(-n1, n2, n3)
	local v58 = cFrame:PointToWorldSpace(vector35)
	local vector36 = Vector3.new(-n1, n2, -n3)
	local v60 = cFrame:PointToWorldSpace(vector36)
	local vector37 = Vector3.new(-n1, -n2, n3)
	local v62 = cFrame:PointToWorldSpace(vector37)
	local vector38 = Vector3.new(-n1, -n2, -n3)

	return {
		v50,
		v52,
		v54,
		v56,
		v58,
		v60,
		v62,
		cFrame:PointToWorldSpace(vector38)
	}
end

local t4: {[any]: any} = {
	Head = true,
	Torso = true,
	["Left Arm"] = true,
	["Right Arm"] = true,
	["Left Leg"] = true,
	["Right Leg"] = true,
	UpperTorso = true,
	LowerTorso = true,
	LeftUpperArm = true,
	LeftLowerArm = true,
	LeftHand = true,
	RightUpperArm = true,
	RightLowerArm = true,
	RightHand = true,
	LeftUpperLeg = true,
	LeftLowerLeg = true,
	LeftFoot = true,
	RightUpperLeg = true,
	RightLowerLeg = true,
	RightFoot = true
}

local function computeScreenBB(p3)
	local CurrentCamera: Camera = workspace.CurrentCamera
	local n1 = math.huge
	local n2 = math.huge
	local n3 = -math.huge
	local n4 = -math.huge
	local vectorValue = Vector3.new(0, 0, 0)
	local n5: number = 0
	local u72: boolean = false

	for iterFirst, iterSecond in p3:GetChildren() do
		if iterSecond:IsA("BasePart") and t4[iterSecond.Name] then
			for iterFirst2, iterSecond2 in getPartCorners(iterSecond), nil, nil do
				local v77, v78 = CurrentCamera:WorldToViewportPoint(iterSecond2)

				if v78 then
					u72 = true
					n1 = math.min(n1, v77.X)
					n3 = math.max(n3, v77.X)
					n2 = math.min(n2, v77.Y)
					n4 = math.max(n4, v77.Y)
				end

				vectorValue += iterSecond2
				n5 += 1
			end
		end
	end

	if u72 and n5 ~= 0 then
		return n1, n2, n3, n4, vectorValue / n5
	end

	return nil
end
local function updateBlock(p4)
	local CurrentCamera: Camera = workspace.CurrentCamera
	local v81, v82, v83, v84, v85 = computeScreenBB(p4)

	if v81 and v85 then
		local n1 = v83 - v81
		local n2 = v84 - v82

		if n1 < 2 or n2 < 2 then
			local v88 = t2[p4]

			if v88 then
				v88.Parent = nil
			end

			return
		end

		local magnitude = (CurrentCamera.CFrame.Position - v85).Magnitude
		local v90 = math.rad(CurrentCamera.FieldOfView)
		local v91 = math.tan(v90 / 2)

		v90 = 2 * magnitude * v91 / CurrentCamera.ViewportSize.Y

		local v92 = t2[p4]

		if not v92 then
			v92 = Instance.new("Part")
			v92.Name = "_AimAssistBlock"
			v92.Anchored = true
			v92.CanCollide = false
			v92.CanQuery = true
			v92.CastShadow = false
			v92.Material = Enum.Material.Neon
			v92.Color = Color3.fromRGB(255, 50, 50)
			v92.Transparency = 1
			v92:SetAttribute("BlocksVision", false)
			t2[p4] = v92
			t3[v92] = p4
		end

		v92.Size = Vector3.new(n1 * v90 + 1, n2 * v90 + 1, 0.1)
		v92.CFrame = CFrame.lookAt(v85, CurrentCamera.CFrame.Position)
		v92.Parent = workspace.Bin

		return
	end

	local v93 = t2[p4]

	if v93 then
		v93.Parent = nil
	end
end
local function clearAllBlocks()
	for key, value in t2 do
		t3[value] = nil
		value:Destroy()
	end

	table.clear(t2)
end
local function removeBlock(p5)
	local v97 = t2[p5]

	if v97 then
		t3[v97] = nil
		v97:Destroy()
		t2[p5] = nil
	end
end
local function findNearestLimbScreen(p6, p7)
	local CurrentCamera: Camera = workspace.CurrentCamera
	local n1 = math.huge
	local v102 = nil

	for iterFirst, iterSecond in p6:GetChildren() do
		if iterSecond:IsA("BasePart") and t4[iterSecond.Name] then
			local v105, v106 = CurrentCamera:WorldToViewportPoint(iterSecond.Position)

			if v106 then
				local vector2 = Vector2.new(v105.X, v105.Y)
				local magnitude = (vector2 - p7).Magnitude

				if n1 > magnitude then
					n1 = magnitude
					v102 = vector2
				end
			end
		end
	end

	return v102
end
local function updateCache()
	local v109 = os.clock()

	if v109 == n2 then
		return
	end

	n2 = v109
	u20 = false
	u18 = nil
	u19 = nil
	n1 = 0

	if u13 then
		local v110 = inputCategorizer.getLastInputCategory()
		local u111: boolean = true

		if v110 ~= inputCategorizer.InputCategory.Gamepad then
			u111 = v110 == inputCategorizer.InputCategory.Touch
		end

		if u111 then
			local v112 = characterFolder or workspace:FindFirstChild("Characters")

			if not v112 then
				return
			end

			local t5 = {}

			for iterFirst, iterSecond in v112:GetChildren() do
				if iterSecond:IsA("Model") then
					if not isEnemy(iterSecond) then
						local v116 = t2[iterSecond]

						if v116 then
							t3[v116] = nil
							v116:Destroy()
							t2[iterSecond] = nil
						end
					else
						t5[iterSecond] = true
						updateBlock(iterSecond)
					end
				end
			end

			for key, value in t2 do
				if not t5[key] then
					local v119 = t2[key]

					if v119 then
						t3[v119] = nil
						v119:Destroy()
						t2[key] = nil
					end
				end
			end

			t5 = {}

			for key2, value2 in t2 do
				if value2.Parent then
					table.insert(t5, value2)
				end
			end

			if #t5 == 0 then
				return
			end

			table.insert(t5, workspace.Game)

			local CurrentCamera: Camera = workspace.CurrentCamera
			local v123 = getScreenCenter()
			local v124 = CurrentCamera:ViewportPointToRay(v123.X, v123.Y)
			local raycastParams = RaycastParams.new()

			raycastParams.FilterType = Enum.RaycastFilterType.Include
			raycastParams.FilterDescendantsInstances = t5
			t5 = workspace:Raycast(v124.Origin, v124.Direction * 1000, raycastParams)

			if not t5 or not t5.Instance then
				return
			end

			v124 = t3[t5.Instance]

			if not v124 then
				return
			end

			if smokeOcclusion.IsBlocked(CurrentCamera.CFrame.Position, t5.Position) then
				return
			end

			local v126 = findNearestLimbScreen(v124, v123)

			if v126 then
				u20 = true
				u18 = v124
				u19 = v126
				n1 = (CurrentCamera.CFrame.Position - t5.Position).Magnitude
			end

			return
		end
	end

	for key3, value3 in t2 do
		if value3.Parent then
			value3.Parent = nil
		end
	end
end
function module.configure(_, p9)
	if p9 then
		if p9.characterFolder ~= nil then
			characterFolder = p9.characterFolder
		end

		if p9.ignoreTeammates ~= nil then
			u15 = p9.ignoreTeammates
		end
	end
end
function module.enable(_)
	u13 = true
end
function module.disable(_)
	u13 = false

	for key, value in t2 do
		t3[value] = nil
		value:Destroy()
	end

	table.clear(t2)
	u20 = false
	u18 = nil
	u19 = nil
	n1 = 0
end
function module.setReticleRadius(_, _)
end
function module.setBaseFOV(_, _)
end
function module.isActive(_)
	if not u13 then
		return false
	end

	if viewedPlayer.IsSpectating() then
		return false
	end

	local Character: Model = LocalPlayer.Character

	if not Character or not Character:FindFirstChildWhichIsA("Tool") then
		return false
	end

	if LocalPlayer:GetAttribute("AimAssist") == false then
		return false
	end

	if crosshairSettings.getActive().MagneticEnabled == false then
		return false
	end

	local v141 = inputCategorizer.getLastInputCategory()
	local u142: boolean = true

	if v141 ~= inputCategorizer.InputCategory.Gamepad then
		u142 = v141 == inputCategorizer.InputCategory.Touch
	end

	return u142
end
function module.hasTarget(_)
	updateCache()

	return u20
end
function module.getStrength(_)
	updateCache()

	if u20 then
		return 1
	end

	return 0
end
function module.getHitConfidence(_)
	updateCache()

	if u20 then
		return 1
	end

	return 0
end
function module.getTargetDistance(_)
	updateCache()

	return n1
end
function module.isSecuredHit(_)
	updateCache()

	return u20
end
function module.getSecuredScreenPoint(p22, p23)
	if not p22:isActive() then
		return nil
	end

	if p23 then
		return nil
	end

	updateCache()

	return u19
end
function module.getAdjustedScreenPoint(p24, p25)
	if not p24:isActive() then
		return nil
	end

	if p25 then
		return nil
	end

	updateCache()

	return u19
end

return module
