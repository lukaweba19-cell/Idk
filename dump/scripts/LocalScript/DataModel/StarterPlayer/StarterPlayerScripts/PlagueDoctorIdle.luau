-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local runService: RunService = game:GetService("RunService")
local LocalPlayer: Player = players.LocalPlayer
local t1: {[any]: any} = { PlagueDoctor = true, fl8meyNPC = true }

local function attr(p1, p2)
	local attributeValue: any = workspace:GetAttribute(p1)
	local typeName: string = typeof(attributeValue)
	local typeName2: string = typeof(p2)

	if typeName == typeName2 then
		return attributeValue
	end

	return p2
end

local t2: {[any]: any} = {}
local t3: {[any]: any} = {}

local function attach(p3)
	local v21 = p3.Name

	if p3 == t2[v21] then
		return
	end

	t2[v21] = p3

	if t3[v21] then
		t3[v21]:Disconnect()
		t3[v21] = nil
	end

	local humanoid = p3:WaitForChild("Humanoid", 10)
	local torso = p3:WaitForChild("Torso", 10)
	local head = p3:WaitForChild("Head", 10)
	local neck = torso and torso:WaitForChild("Neck", 10)

	if p3 ~= t2[v21] then
		return
	end

	if humanoid then
		local v26 = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator")

		v26.Parent = humanoid

		local animation: Animation = Instance.new("Animation")
		local plagueDoctorIdleAnim: any = workspace:GetAttribute("PlagueDoctorIdleAnim")

		animation.AnimationId = if typeof(plagueDoctorIdleAnim) == "string" then plagueDoctorIdleAnim else "rbxassetid://180435571"

		local ok, result = pcall(function()
			return v26:LoadAnimation(animation)
		end)

		if ok and result then
			result.Looped = true
			result.Priority = Enum.AnimationPriority.Idle
			result:Play(0.3)
		else
			local text: string = tostring(result)

			warn("[PlagueDoctorIdle] idle failed: " .. text)
		end
	end

	if torso and neck and head then
		local neckC0 = neck.C0
		local n1 = 0
		local n2 = 0

		t3[v21] = runService.RenderStepped:Connect(function(deltaTime: number)
			if not p3:IsDescendantOf(workspace) or not neck.Parent then
				return
			end

			local plagueDoctorLookRange: any = workspace:GetAttribute("PlagueDoctorLookRange")
			local v38 = if typeof(plagueDoctorLookRange) == "number" then plagueDoctorLookRange else 28
			local n3 = 0
			local n4 = 0
			local Character: Model = LocalPlayer.Character
			local head2 = Character and Character:FindFirstChild("Head")

			if v38 > 0 and head2 then
				local v43 = torso.CFrame:PointToObjectSpace(head2.Position)
				local magnitude = Vector2.new(v43.X, v43.Z).Magnitude

				if v38 >= magnitude and v43.Z < 0 then
					local v45 = math.atan2(-v43.X, -v43.Z)

					n3 = math.clamp(v45, -1.2217304763960306, 1.2217304763960306)
					v45 = math.atan2(head2.Position.Y - head.Position.Y, magnitude)
					n4 = math.clamp(v45, -0.4363323129985824, 0.4363323129985824)
				end
			end

			local v46 = math.min(1, deltaTime * 6)

			n1 += (n3 - n1) * v46
			n2 += (n4 - n2) * v46

			local v47 = CFrame.Angles(-n2, 0, n1)

			neck.C0 = neckC0 * v47
		end)

		return
	end
end
local function consider(p5)
	if t1[p5.Name] and p5:IsA("Model") then
		task.spawn(attach, p5)
	end
end

for iterFirst, iterSecond in workspace:GetChildren() do
	if t1[iterSecond.Name] and iterSecond:IsA("Model") then
		task.spawn(attach, iterSecond)
	end
end

workspace.ChildAdded:Connect(consider)

local lobby: Instance = workspace:WaitForChild("Lobby", 30)

if lobby then
	for iterFirst2, iterSecond2 in lobby:GetChildren() do
		if t1[iterSecond2.Name] and iterSecond2:IsA("Model") then
			task.spawn(attach, iterSecond2)
		end
	end

	lobby.ChildAdded:Connect(consider)
end
