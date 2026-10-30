-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local LocalPlayer: Player = game:GetService("Players").LocalPlayer
local localPlayerUserId = LocalPlayer.UserId
local t1: {[any]: any} = {
	[67819707] = true,
	[3095250] = true,
	[2903687155] = true,
	[896538] = true,
	[45124586] = true
}

if not t1[localPlayerUserId] then
	return
end

local userInputService: UserInputService = game:GetService("UserInputService")
local runService: RunService = game:GetService("RunService")
local contextActionService: ContextActionService = game:GetService("ContextActionService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local u8 = nil

local ok, result = pcall(function()
	return require(replicatedStorage:WaitForChild("Sound", 10))
end)

if ok then
	u8 = result
else
	warn("[MD Fly] Sound module not found; flight will be silent.")
end

local u11 = nil
local u12 = nil
local u13 = nil
local animator = nil
local u15 = nil
local u16 = nil
local u17 = nil
local u18 = nil
local u19 = nil
local u20: boolean = false
local n1 = 0
local n2 = 0
local bodyVelocity = nil
local bodyGyro = nil
local connection = nil
local n3 = 0
local u27: boolean = false
local u28 = nil
local screenGui = nil

local function loadAnim(animationId, p2)
	local animation: Animation = Instance.new("Animation")

	animation.AnimationId = animationId

	local animationTrack = animator:LoadAnimation(animation)

	animationTrack.Priority = Enum.AnimationPriority.Action
	animationTrack.Looped = p2 ~= false

	return animationTrack
end
local function isValidAnimId(p3)
	return p3 ~= nil and p3 ~= "" and p3 ~= "rbxassetid://0"
end
local function createSpeedGui()
	if screenGui then
		return
	end

	local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui", 5)

	if not playerGui then
		return
	end

	screenGui = Instance.new("ScreenGui")
	screenGui.Name = "MD_FlySpeedGui"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.DisplayOrder = 100
	screenGui.Parent = playerGui

	local container: Frame = Instance.new("Frame")

	container.Name = "Container"
	container.AnchorPoint = Vector2.new(0, 0.5)
	container.Position = UDim2.new(0, 20, 0.5, 280)
	container.Size = UDim2.fromOffset(220, 56)
	container.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.Parent = screenGui

	local uiCorner: UICorner = Instance.new("UICorner")

	uiCorner.CornerRadius = UDim.new(0, 10)
	uiCorner.Parent = container

	local uiStroke: UIStroke = Instance.new("UIStroke")

	uiStroke.Color = Color3.fromRGB(255, 255, 255)
	uiStroke.Thickness = 1
	uiStroke.Transparency = 1
	uiStroke.Parent = container

	local speedLabel: TextLabel = Instance.new("TextLabel")

	speedLabel.Name = "SpeedLabel"
	speedLabel.Size = UDim2.fromScale(1, 1)
	speedLabel.BackgroundTransparency = 1
	speedLabel.Text = "Current Speed: 0"
	speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	speedLabel.TextSize = 12
	speedLabel.Font = Enum.Font.GothamBold
	speedLabel.Parent = container
end
local function destroySpeedGui()
	if screenGui then
		screenGui:Destroy()
		screenGui = nil
	end
end
local function updateSpeedGui()
	if not screenGui then
		return
	end

	local container = screenGui:FindFirstChild("Container")

	if container then
		container = container:FindFirstChild("SpeedLabel")
	end

	if container then
		local floored = math.floor(n1 + 0.5)

		container.Text = "Current Speed: " .. tostring(floored)
	end
end
local function setupCharacter(p4)
	u11 = p4
	u12 = p4:WaitForChild("Humanoid")
	u13 = p4:WaitForChild("HumanoidRootPart")
	animator = u12:FindFirstChildOfClass("Animator")

	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = u12
	end

	local animation: Animation = Instance.new("Animation")

	animation.AnimationId = "rbxassetid://107918164085092"

	local v54 = animator:LoadAnimation(animation)

	v54.Priority = Enum.AnimationPriority.Action
	v54.Looped = true
	u15 = v54

	local animation2: Animation = Instance.new("Animation")

	animation2.AnimationId = "rbxassetid://93100077048587"
	v54 = animator:LoadAnimation(animation2)
	v54.Priority = Enum.AnimationPriority.Action
	v54.Looped = true
	u16 = v54

	local animation3: Animation = Instance.new("Animation")

	animation3.AnimationId = "rbxassetid://130239068076680"
	v54 = animator:LoadAnimation(animation3)
	v54.Priority = Enum.AnimationPriority.Action
	v54.Looped = true
	u17 = v54

	if true then
		local animation4: Animation = Instance.new("Animation")

		animation4.AnimationId = "rbxassetid://130226398753137"

		local animationTrack = animator:LoadAnimation(animation4)

		animationTrack.Priority = Enum.AnimationPriority.Action
		animationTrack.Looped = false
		u18 = animationTrack
		u18.Priority = Enum.AnimationPriority.Action4
	else
		u18 = nil
	end

	if true then
		local animation5: Animation = Instance.new("Animation")

		animation5.AnimationId = "rbxassetid://113845970289702"

		local v60 = animator:LoadAnimation(animation5)

		v60.Priority = Enum.AnimationPriority.Action
		v60.Looped = false
		u19 = v60
		u19.Priority = Enum.AnimationPriority.Action4
	else
		u19 = nil
	end

	u20 = false
	n1 = 0
	n2 = 0
	bodyVelocity = nil
	bodyGyro = nil
	connection = nil
	u28 = nil

	if screenGui then
		screenGui:Destroy()
		screenGui = nil
	end
end
local function stopAllFlyAnims()
	if u15 then
		u15:Stop(0.2)
	end

	if u16 then
		u16:Stop(0.2)
	end

	if u17 then
		u17:Stop(0.2)
	end

	if u18 then
		u18:Stop(0.2)
	end

	if u19 then
		u19:Stop(0.2)
	end
end
local function startFlying()
	if u20 then
		return
	end

	if not u13 or not u13.Parent then
		return
	end

	u20 = true
	n1 = 0
	n2 = 0
	createSpeedGui()
	u12:ChangeState(Enum.HumanoidStateType.Physics)
	u12.PlatformStand = false

	for _, v in ipairs(animator:GetPlayingAnimationTracks()) do
		v:Stop(0.1)
	end

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(inf, inf, inf)
	bodyVelocity.Velocity = Vector3.new(0, 0, 0)
	bodyVelocity.P = 1250
	bodyVelocity.Parent = u13
	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(inf, inf, inf)
	bodyGyro.D = 500
	bodyGyro.P = 8000
	bodyGyro.CFrame = u13.CFrame
	bodyGyro.Parent = u13

	local u63: boolean = false

	if u18 then
		u18:Play(0.1)

		local connection3 = nil

		connection3 = u18.Stopped:Connect(function()
			connection3:Disconnect()
			u63 = true

			if u20 and u15 and not u15.IsPlaying then
				u15:Play(0.3)
			end
		end)
	else
		connection3 = u15
		connection3:Play(0.3)
		u63 = true
	end

	local u65: boolean = false
	local connection2 = nil
	local u67: boolean = false
	local u68: boolean = false
	local n4: number = 0
	local n5 = 100
	local timestamp = tick()

	n3 = timestamp
	u27 = true
	connection = runService.RenderStepped:Connect(function(deltaTime: number)
		if not u13 or not u13.Parent then
			return
		end

		local v75: CFrame = workspace.CurrentCamera.CFrame
		local lookVector = v75.LookVector
		local rightVector = v75.RightVector
		local isKeyDown: boolean = userInputService:IsKeyDown(Enum.KeyCode.W)
		local v79: boolean = not u67 and isKeyDown
		local v80: boolean = u67 and not isKeyDown

		u67 = isKeyDown

		if u8 then
			if v79 and not u28 and u13 and u13.Parent then
				local ok2, result2 = pcall(function()
					return u8:Play("Misc.FlyLoop", u13)
				end)

				if ok2 and result2 and not result2.Destroyed then
					u28 = result2
				end
			elseif v80 and u28 then
				pcall(function()
					u28:FadeOut(0.5)
				end)
				u28 = nil

				if u13 and u13.Parent then
					pcall(function()
						u8:Play("Misc.FlyStop", u13)
					end)
				end
			end
		end

		if isKeyDown then
			n4 += deltaTime

			if n4 > 3 then
				n5 = math.min(n5 + 35 * deltaTime, 3555)
			end

			n2 = math.min(n2 + deltaTime, 1.4)
			n1 = (n5 - 15) * (n2 / 1.4) + 15
		else
			n4 = 0
			n5 = 100
			n2 = 0
			n1 = math.max(0, n1 - 109 * deltaTime)
		end

		local n6: number = 0

		if userInputService:IsKeyDown(Enum.KeyCode.A) then
			n6 -= 1
		end

		if userInputService:IsKeyDown(Enum.KeyCode.D) then
			n6 += 1
		end

		local n7: number = 0

		if userInputService:IsKeyDown(Enum.KeyCode.Space) then
			n7 += 1
		end

		if userInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
			n7 -= 1
		end

		local n8: number = 0

		if userInputService:IsKeyDown(Enum.KeyCode.S) then
			n8 = -15
		end

		local n9 = lookVector * (n1 + n8) + rightVector * (n6 * 25)
		local vector3 = Vector3.new(0, n7 * 8, 0)
		local n10 = n9 + vector3
		local u89: boolean = true

		if not (n1 > 0.5) then
			u89 = true

			if n6 == 0 then
				u89 = true

				if n7 == 0 then
					u89 = n8 ~= 0
				end
			end
		end

		if not u89 then
			local timestamp2 = tick()
			local sine = math.sin((timestamp2 - timestamp) * 1.8 * 3.141592653589793)

			n10 = Vector3.new(0, sine * 0.15, 0)
		end

		if u27 then
			local timestamp3 = tick()
			local v93 = math.min((timestamp3 - n3) / 0.6, 1)

			if v93 >= 1 then
				u27 = false
			else
				n10 = Vector3.new(n10.X, (1 - v93) * 3 * (1 - v93) * 8.333333333333334, n10.Z)
			end
		end

		bodyVelocity.Velocity = n10

		if screenGui then
			local container = screenGui:FindFirstChild("Container")

			if container then
				container = container:FindFirstChild("SpeedLabel")
			end

			if container then
				local floored = math.floor(n1 + 0.5)

				container.Text = "Current Speed: " .. tostring(floored)
			end
		end

		local cFrame = CFrame.new(u13.Position, u13.Position + lookVector)
		local v97 = bodyGyro
		local bodyGyroCFrame = bodyGyro.CFrame
		local v99 = math.clamp(8 * deltaTime, 0, 1)

		v97.CFrame = bodyGyroCFrame:Lerp(cFrame, v99)

		if isKeyDown then
			u68 = false
		end

		if u18 and not u63 then
		elseif not u65 then
			if v80 and u19 and u17.IsPlaying then
				u16:Stop(0.1)
				u17:Stop(0.1)
				u15:Stop(0.1)
				u19:Play(0.1)
				u65 = true
				connection2 = u19.Stopped:Connect(function()
					if connection2 then
						connection2:Disconnect()
						connection2 = nil
					end

					u65 = false

					if u20 and u15 and not u15.IsPlaying then
						u15:Play(0.3)
					end
				end)

				return
			end

			if v80 and u16.IsPlaying then
				u16:Stop(0.2)
				u17:Stop(0.2)

				if not u15.IsPlaying then
					u15:Play(0.3)
				end

				u68 = true

				return
			end

			if not u68 then
				if u89 and n1 > 7.5 then
					if n1 > 63.25000000000001 then
						if not u17.IsPlaying then
							u16:Stop(0.2)
							u15:Stop(0.2)
							u17:Play(0.2)
						end

						u17:AdjustSpeed(1.6)

						return
					end

					if not u16.IsPlaying then
						u17:Stop(0.2)
						u15:Stop(0.2)
						u16:Play(0.2)
					end

					u16:AdjustSpeed(1)

					return
				end

				if not u15.IsPlaying then
					u16:Stop(0.2)
					u17:Stop(0.2)
					u15:Play(0.3)
				end
			elseif not u15.IsPlaying then
				u15:Play(0.3)

				return
			end
		elseif isKeyDown then
			if connection2 then
				connection2:Disconnect()
				connection2 = nil
			end

			if u19 then
				u19:Stop(0.15)
			end

			u65 = false

			return
		end
	end)
end
local function stopFlying()
	if not u20 then
		return
	end

	u20 = false
	n1 = 0
	n2 = 0
	u27 = false

	if connection then
		connection:Disconnect()
		connection = nil
	end

	if bodyVelocity then
		bodyVelocity:Destroy()
		bodyVelocity = nil
	end

	if bodyGyro then
		bodyGyro:Destroy()
		bodyGyro = nil
	end

	if u28 then
		pcall(function()
			u28:FadeOut(0.5)
		end)
		u28 = nil
	end

	if screenGui then
		screenGui:Destroy()
		screenGui = nil
	end

	stopAllFlyAnims()

	if u12 and u12.Parent then
		u12:ChangeState(Enum.HumanoidStateType.GettingUp)
	end
end
local function toggleFly()
	if u20 then
		stopFlying()

		return
	end

	startFlying()
end

contextActionService:BindAction("MD_FlyToggle", function(_, p7)
	if p7 == Enum.UserInputState.Begin then
		if u20 then
			stopFlying()
		else
			startFlying()
		end
	end

	return Enum.ContextActionResult.Pass
end, false, Enum.KeyCode.X)

if LocalPlayer.Character then
	setupCharacter(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(setupCharacter)
print("[MD Fly] Owner flight loaded. Press X to toggle. Hold W to accelerate.")
