-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local runService: RunService = game:GetService("RunService")
local soundFetcher = require(script:WaitForChild("SoundFetcher"))
local LocalPlayer: Player = players.LocalPlayer
local CurrentCamera: Camera = workspace.CurrentCamera
local t1: {[any]: any} = {}
local raycastParams = RaycastParams.new()

raycastParams.FilterType = Enum.RaycastFilterType.Exclude
raycastParams.IgnoreWater = false

local function getFootstepVariantName(p1, p2)
	raycastParams.FilterDescendantsInstances = { p1 }

	local v22 = workspace:Raycast(p2.Position, Vector3.new(0, -6, 0), raycastParams)

	if not v22 then
		return nil
	end

	local instance = v22.Instance

	if instance and instance:GetAttribute("FootstepVariant") then
		return instance:GetAttribute("FootstepVariant")
	end

	return nil
end
local function onCharacterAdded(p3)
	runService.Stepped:wait()

	local u25: boolean = p3 == game.Players.LocalPlayer.Character

	if not t1[p3] then
		local humanoid = p3:WaitForChild("Humanoid", 60)

		if not humanoid then
			return
		end

		local humanoidRootPart = p3:WaitForChild("HumanoidRootPart", 60)

		if not humanoidRootPart then
			return
		end

		local running = humanoidRootPart:WaitForChild("Running", 60)

		if not running then
			print("HumanoidAddonController - Running sound not found for:", p3)

			return
		end

		task.spawn(function()
			local died = humanoidRootPart:WaitForChild("Died", 60)

			if died then
				died.Volume = 0
			end
		end)

		local function update(p4)
			local humanoidFloorMaterial = humanoid.FloorMaterial

			if humanoidFloorMaterial == Enum.Material.Air or (CurrentCamera.CFrame.Position - humanoidRootPart.Position).Magnitude > 200 then
				running.Volume = 0

				return
			end

			local v40 = getFootstepVariantName(p3, humanoidRootPart)
			local v41 = soundFetcher:fetch(humanoidFloorMaterial, v40)

			v40 = v41

			if not v40 then
				v40 = soundFetcher:fetch("DEFAULT")
			end

			running.SoundId = (if v41 then "rbxassetid://" else "rbxasset://") .. v40.ID

			local n1 = (humanoidRootPart.Velocity * Vector3.new(1, 0, 1)).Magnitude * (if humanoid.Jump then 0 else 1)
			local typeName: string = typeof(p4)

			if typeName == "number" and p4 < 1 or typeName == "EnumItem" and p4 == Enum.HumanoidStateType.Jumping or p3:GetAttribute("ParkourState") ~= nil or humanoid.PlatformStand or typeName == "EnumItem" and p4 == Enum.HumanoidStateType.Physics then
				n1 = 0
			end

			if n1 ~= n1 or n1 == math.huge then
				n1 = 0
			end

			if n1 == 0 then
				running.Volume = 0

				return
			end

			local v44 = math.clamp(v40.Speed * (n1 / 19), 0, 3.7)

			running.PlaybackSpeed = math.max(v44, 0.1)
			running.RollOffMinDistance = 10
			running.RollOffMaxDistance = math.clamp(n1 / 19 * 10, 5, 10) * 4
			running.Volume = math.clamp(n1 / 19 * 0.3, 0.3, 0.6)
		end

		t1[p3] = {
			Humanoid = humanoid,
			HRP = humanoidRootPart,
			Update = update,
			InRange = u25
		}
		humanoid:GetPropertyChangedSignal("FloorMaterial"):Connect(update)
		humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(update)
		humanoid.Running:Connect(update)
		humanoid.StateChanged:Connect(update)

		return
	end
end
local function onCharacterRemoving(p5)
	t1[p5] = nil
end

players.PlayerAdded:Connect(function(player: Player)
	player.CharacterAdded:Connect(onCharacterAdded)
	player.CharacterRemoving:Connect(onCharacterRemoving)

	if player.Character then
		onCharacterAdded(player.Character)
	end
end)

for _, v in pairs(players:GetPlayers()) do
	task.spawn(function()
		local player = v

		player.CharacterAdded:Connect(onCharacterAdded)
		player.CharacterRemoving:Connect(onCharacterRemoving)

		if player.Character then
			onCharacterAdded(player.Character)
		end
	end)
end

local characters: Instance = workspace:WaitForChild("Characters", 30)

if characters then
	for _, v in ipairs(characters:GetChildren()) do
		if v and v:IsA("Model") then
			task.spawn(onCharacterAdded, v)
		end
	end

	characters.ChildAdded:Connect(function(p7: Instance)
		if p7 and p7:IsA("Model") then
			task.spawn(onCharacterAdded, p7)
		end
	end)
	characters.ChildRemoved:Connect(onCharacterRemoving)
end

task.spawn(function()
	while true do
		if not task.wait(0.1) then
			break
		end

		local Character: Model = LocalPlayer.Character

		for _, v in pairs(t1) do
			if v ~= Character and v.InRange then
				v.Update()
			end
		end
	end
end)

while true do
	if not task.wait(1) then
		break
	end

	local Character: Model = LocalPlayer.Character
	local v17 = t1[Character]

	if v17 then
		for k, v in pairs(t1) do
			if k ~= Character then
				if (v17.HRP.Position - v.HRP.Position).Magnitude < 500 then
					v.InRange = true
				else
					v.InRange = false
				end
			end
		end
	end
end
