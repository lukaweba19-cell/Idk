-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local runService: RunService = game:GetService("RunService")
local LocalPlayer: Player = players.LocalPlayer

local function findPumpkin()
	local horseman: Instance = workspace:FindFirstChild("Horseman")

	if not horseman then
		local lobby: Instance = workspace:FindFirstChild("Lobby")

		horseman = lobby and lobby:FindFirstChild("Horseman")
	end

	local pumpkin: Instance = horseman and horseman:FindFirstChild("pumpkin")
	local v13: Instance = pumpkin

	if v13 then
		v13 = pumpkin:FindFirstChild("Main")
	end

	if v13 and v13:IsA("BasePart") then
		return v13
	end

	return nil
end

local u5 = nil
local cFrameIdentity = CFrame.identity
local n1 = 0
local n2 = 0
local n3 = 0

runService.RenderStepped:Connect(function(deltaTime: number)
	local v15 = os.clock()
	local v16 = u5

	if not v16 or not v16:IsDescendantOf(workspace) then
		u5 = nil

		if v15 < n3 then
			return
		end

		n3 = v15 + 1
		v16 = findPumpkin()

		if not v16 then
			return
		end

		u5 = v16
		cFrameIdentity = v16.CFrame
		n1 = 0
		n2 = 0
	end

	local Character: Model = LocalPlayer.Character
	local head = Character and Character:FindFirstChild("Head")

	if head and (head.Position - cFrameIdentity.Position).Magnitude > 250 then
		return
	end

	local n4 = 0
	local n5 = 0
	local horsemanLookRange = workspace:GetAttribute("HorsemanLookRange")

	if typeof(horsemanLookRange) ~= "number" then
		horsemanLookRange = 28
	end

	if horsemanLookRange > 0 and head then
		local v22 = cFrameIdentity:PointToObjectSpace(head.Position)
		local magnitude = Vector2.new(v22.X, v22.Z).Magnitude

		if horsemanLookRange >= magnitude and v22.Z < 0 then
			local v24 = math.atan2(-v22.X, -v22.Z)

			n4 = math.clamp(v24, -1.3089969389957472, 1.3089969389957472)
			v24 = math.atan2(v22.Y, magnitude)
			n5 = math.clamp(v24, -0.5235987755982988, 0.5235987755982988)
		end
	end

	local v25 = math.min(1, deltaTime * 5)

	n1 += (n4 - n1) * v25
	n2 += (n5 - n2) * v25

	local sine = math.sin(v15 * 3.141592653589793 * 2 / 2.6)
	local n6 = CFrame.new(cFrameIdentity.Position + Vector3.new(0, 1, 0) * (sine * 0.3)) * cFrameIdentity.Rotation
	local v28 = CFrame.Angles(0, n1, 0)
	local v29 = CFrame.Angles(n2, 0, 0)

	v16.CFrame = n6 * v28 * v29
end)
