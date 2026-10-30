-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local lighting: Lighting = game:GetService("Lighting")
local tweenService: TweenService = game:GetService("TweenService")
local LocalPlayer: Player = players.LocalPlayer
local u5: boolean = false
local connection = nil

local function pulse()
	if u5 then
		return
	end

	u5 = true

	local ok, result = pcall(function()
		local playerBrightness: ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

		playerBrightness.Name = "PlayerBrightness"
		playerBrightness.Brightness = 0
		playerBrightness.Parent = lighting

		local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local v24: Tween = tweenService:Create(playerBrightness, tweenInfo, { Brightness = 2 })

		v24:Play()
		v24.Completed:Wait()

		local tweenInfo2 = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		v24 = tweenService:Create(playerBrightness, tweenInfo2, { Brightness = 0 })
		v24:Play()
		v24.Completed:Wait()
		playerBrightness:Destroy()
	end)

	if not ok then
		warn("[TrainingPortal] pulse failed:", result)
	end

	u5 = false
end
local function connectToPortal(p1)
	if connection then
		connection:Disconnect()
		connection = nil
	end

	connection = p1.Touched:Connect(function(p2)
		local Character: Model = LocalPlayer.Character

		if not Character then
			return
		end

		if not p2 or not p2:IsDescendantOf(Character) then
			return
		end

		if u5 then
			return
		end

		u5 = true

		local ok, result = pcall(function()
			local playerBrightness: ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

			playerBrightness.Name = "PlayerBrightness"
			playerBrightness.Brightness = 0
			playerBrightness.Parent = lighting

			local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local v32: Tween = tweenService:Create(playerBrightness, tweenInfo, { Brightness = 2 })

			v32:Play()
			v32.Completed:Wait()

			local tweenInfo3 = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

			v32 = tweenService:Create(playerBrightness, tweenInfo3, { Brightness = 0 })
			v32:Play()
			v32.Completed:Wait()
			playerBrightness:Destroy()
		end)

		if not ok then
			warn("[TrainingPortal] pulse failed:", result)
		end

		u5 = false
	end)
end
local function tryFindPortal()
	local trainingPortal: Instance = workspace:FindFirstChild("TrainingPortal")

	if trainingPortal and trainingPortal:IsA("BasePart") then
		return trainingPortal
	end

	return nil
end

local trainingPortal: Instance = workspace:FindFirstChild("TrainingPortal")
local v11 = if trainingPortal and trainingPortal:IsA("BasePart") then trainingPortal else nil

if v11 then
	if connection then
		connection:Disconnect()
		connection = nil
	end

	connection = v11.Touched:Connect(function(p3)
		local Character: Model = LocalPlayer.Character

		if not Character then
			return
		end

		if not p3 or not p3:IsDescendantOf(Character) then
			return
		end

		if u5 then
			return
		end

		u5 = true

		local ok, result = pcall(function()
			local playerBrightness: ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

			playerBrightness.Name = "PlayerBrightness"
			playerBrightness.Brightness = 0
			playerBrightness.Parent = lighting

			local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local v32: Tween = tweenService:Create(playerBrightness, tweenInfo, { Brightness = 2 })

			v32:Play()
			v32.Completed:Wait()

			local tweenInfo3 = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

			v32 = tweenService:Create(playerBrightness, tweenInfo3, { Brightness = 0 })
			v32:Play()
			v32.Completed:Wait()
			playerBrightness:Destroy()
		end)

		if not ok then
			warn("[TrainingPortal] pulse failed:", result)
		end

		u5 = false
	end)
end

workspace.ChildAdded:Connect(function(child: Instance)
	if child.Name == "TrainingPortal" and child:IsA("BasePart") then
		if connection then
			connection:Disconnect()
			connection = nil
		end

		connection = child.Touched:Connect(function(p2)
			local Character: Model = LocalPlayer.Character

			if not Character then
				return
			end

			if not p2 or not p2:IsDescendantOf(Character) then
				return
			end

			if u5 then
				return
			end

			u5 = true

			local ok, result = pcall(function()
				local playerBrightness: ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

				playerBrightness.Name = "PlayerBrightness"
				playerBrightness.Brightness = 0
				playerBrightness.Parent = lighting

				local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				local v32: Tween = tweenService:Create(playerBrightness, tweenInfo, { Brightness = 2 })

				v32:Play()
				v32.Completed:Wait()

				local tweenInfo3 = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

				v32 = tweenService:Create(playerBrightness, tweenInfo3, { Brightness = 0 })
				v32:Play()
				v32.Completed:Wait()
				playerBrightness:Destroy()
			end)

			if not ok then
				warn("[TrainingPortal] pulse failed:", result)
			end

			u5 = false
		end)
	end
end)
workspace.ChildRemoved:Connect(function(child: Instance)
	if child.Name == "TrainingPortal" and connection then
		connection:Disconnect()
		connection = nil
	end
end)
