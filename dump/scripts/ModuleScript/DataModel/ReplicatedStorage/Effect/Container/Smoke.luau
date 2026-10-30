-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local CurrentCamera: Camera = workspace.CurrentCamera
local players: Players = game:GetService("Players")
local sound = require(game.ReplicatedStorage.Sound)

require(game.ReplicatedStorage.Util.ScaleParticle)

local misc = require(game.ReplicatedStorage.Util.Misc)

require(game.ReplicatedStorage.Util.Debris)

local tweenService: TweenService = game:GetService("TweenService")
local runService: RunService = game:GetService("RunService")

local function makeTween(p1, p2, p3)
	return tweenService:Create(p1, p2, p3)
end

local t1: {[any]: any} = { count = 0, gui = nil, frame = nil, tween = nil }

local function getPlayerGui()
	local LocalPlayer: Player = players.LocalPlayer

	if not LocalPlayer then
		return nil
	end

	return (LocalPlayer:FindFirstChildOfClass("PlayerGui"))
end
local function ensure()
	if t1.gui and t1.gui.Parent and t1.frame and t1.frame.Parent then
		return t1.gui, t1.frame
	end

	local LocalPlayer: Player = players.LocalPlayer
	local parent = if not LocalPlayer then nil else LocalPlayer:FindFirstChildOfClass("PlayerGui")

	if not parent then
		return nil, nil
	end

	local smokeSphere_Fog: ScreenGui = Instance.new("ScreenGui")

	smokeSphere_Fog.Name = "SmokeSphere_Fog"
	smokeSphere_Fog.ResetOnSpawn = false
	smokeSphere_Fog.IgnoreGuiInset = true
	smokeSphere_Fog.DisplayOrder = -100000

	local overlay: Frame = Instance.new("Frame")

	overlay.Name = "Overlay"
	overlay.BackgroundColor3 = Color3.fromRGB(160, 160, 160)
	overlay.BackgroundTransparency = 1
	overlay.BorderSizePixel = 0
	overlay.Size = UDim2.fromScale(1, 1)
	overlay.Position = UDim2.fromScale(0, 0)
	overlay.Parent = smokeSphere_Fog
	smokeSphere_Fog.Parent = parent
	t1.gui = smokeSphere_Fog
	t1.frame = overlay

	return smokeSphere_Fog, overlay
end
local function tweenTo(p4, p5)
	local v24, v25 = ensure()

	if not v25 then
		return
	end

	if t1.tween then
		t1.tween:Cancel()
		t1.tween = nil
	end

	local tweenInfo = TweenInfo.new(p5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local v27: Tween = tweenService:Create(v25, tweenInfo, { BackgroundTransparency = p4 })

	t1.tween = v27
	v27:Play()
end
local function fadeBeamsTransparencyLoop(p6, p7, p8)
	local function faded(p9, p10)
		local v71 = table.create(#p9.Keypoints)

		for iterFirst, iterSecond in p9.Keypoints, nil, nil do
			v71[iterFirst] = NumberSequenceKeypoint.new(iterSecond.Time, iterSecond.Value + (1 - iterSecond.Value) * p10)
		end

		return NumberSequence.new(v71)
	end

	for iterFirst, iterSecond in p6:GetDescendants() do
		if iterSecond:IsA("Beam") then
			local transparency = iterSecond.Transparency

			task.spawn(function()
				while p6.Parent do
					for i = 0, p8 do
						iterSecond.Transparency = faded(transparency, i / p8)
						task.wait(p7 / p8)
					end

					task.wait(15)
					iterSecond.Transparency = transparency
					task.wait(1)
				end
			end)
		end
	end
end

local t2: {[any]: any} = {
	Enter = function()
		local v35: {[any]: any} = t1

		v35.count = v35.count + 1

		if t1.count == 1 then
			tweenTo(0.05, 0.12)
		end
	end,
	Exit = function()
		local v36: {[any]: any} = t1

		v36.count = v36.count - 1

		if t1.count < 0 then
			t1.count = 0
		end

		if t1.count == 0 then
			local v37, v38 = ensure()

			if v37 and v38 then
				if t1.tween then
					t1.tween:Cancel()
					t1.tween = nil
				end

				local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				local v40: Tween = tweenService:Create(v38, tweenInfo, { BackgroundTransparency = 1 })

				t1.tween = v40
				v40:Play()
				task.delay(0.22, function()
					if t1.count == 0 and t1.gui == v37 and v37.Parent then
						v37:Destroy()
						t1.gui = nil
						t1.frame = nil
						t1.tween = nil
					end
				end)

				return
			end

			return
		end
	end
}

return function(p11)
	local radius = p11.Radius
	local duration = p11.Duration
	local isLocal = p11.IsLocal
	local CFramePosition = p11.CFrame.Position

	if (CurrentCamera.CFrame.Position - CFramePosition).Magnitude > 1000 then
		return
	end

	local clone = game.ReplicatedStorage.FX.AbilityFX.Smoke.FancyBall:Clone()

	clone.Name = "SmokeSphere"
	clone.Size = Vector3.new(0, 0, 0)
	clone.CFrame = CFrame.new(CFramePosition)
	clone:SetAttribute("BlocksVision", true)
	clone.Parent = workspace.Bin

	local clone2 = game.ReplicatedStorage.FX.AbilityFX.Smoke.WindSphere:Clone()

	clone2.Name = "SmokeSphere"
	clone2.Size = Vector3.new(0, 0, 0)

	local cFrame = CFrame.new(CFramePosition)
	local v49 = CFrame.Angles(0, 0, -1.5707963267948966)

	clone2.CFrame = cFrame * v49
	clone2.Parent = workspace.Bin

	local clone3 = game.ReplicatedStorage.FX.AbilityFX.Smoke.Smoke:Clone()

	clone3.Parent = clone

	local clone4 = game.ReplicatedStorage.FX.AbilityFX.Smoke.Emit:Clone()

	clone4.Parent = clone

	local cFrame2 = CFrame.new(clone2.Position)
	local numberValue: NumberValue = Instance.new("NumberValue")

	numberValue.Value = 0
	numberValue.Changed:Connect(function(p12: number)
		local cFrameAngles = CFrame.Angles
		local v77 = math.rad(p12)
		local cFrame = cFrameAngles(0, v77, -1.5707963267948966)

		clone2.CFrame = cFrame2 * cFrame
	end)

	local tweenInfo = TweenInfo.new(5, Enum.EasingStyle.Linear)
	local v55: Tween = tweenService:Create(numberValue, tweenInfo, { Value = 720 })

	v55:Play()
	v55.Completed:Connect(function()
		numberValue:Destroy()
	end)

	local tweenInfo2 = TweenInfo.new(0.225, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local vector3 = Vector3.new(radius * 2, radius * 2, radius * 2)

	tweenService:Create(clone, tweenInfo2, { Size = vector3 }):Play()

	local tweenInfo3 = TweenInfo.new(0.225, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local vector32 = Vector3.new(radius * 2.001, radius * 2.001, radius * 2.001)

	tweenService:Create(clone2, tweenInfo3, { Size = vector32 }):Play()
	misc.EmitAll(clone4)

	for _, v in pairs(clone:GetDescendants()) do
		if v:IsA("Beam") then
			local keypoints = v.Transparency.Keypoints
			local numberValue2: NumberValue = Instance.new("NumberValue")

			numberValue2.Value = 0
			numberValue2.Parent = clone
			numberValue2.Changed:Connect(function(p13: number)
				local t3: {[any]: any} = {}

				for iterFirst, iterSecond in keypoints do
					table.insert(t3, NumberSequenceKeypoint.new(iterSecond.Time, iterSecond.Value + (1 - iterSecond.Value) * p13, iterSecond.Envelope))
				end

				v.Transparency = NumberSequence.new(t3)
			end)

			local tweenInfo4 = TweenInfo.new(3, Enum.EasingStyle.Linear)
			local v65: Tween = tweenService:Create(numberValue2, tweenInfo4, { Value = 1 })

			v65:Play()
			v65.Completed:Connect(function()
				numberValue2:Destroy()
			end)
		end
	end

	sound:Play("Abilities.SmokeBomb", clone)

	local u66: boolean = false
	local connection = nil
	local u68: boolean = true

	connection = runService.RenderStepped:Connect(function()
		if u68 == false or not clone.Parent then
			if u66 then
				u66 = false
				t2.Exit()
			end

			if connection then
				connection:Disconnect()
			end

			return
		end

		local u83: boolean = (CurrentCamera.CFrame.Position - CFramePosition).Magnitude <= radius

		if u83 ~= u66 then
			u66 = u83

			if u66 then
				t2.Enter()

				return
			end

			t2.Exit()

			return
		end
	end)
	task.delay(duration, function()
		if connection then
			connection:Disconnect()
		end

		if u66 then
			u66 = false
			t2.Exit()
		end

		if clone and clone.Parent then
			local smoke = clone:FindFirstChild("Smoke")

			if smoke then
				smoke.Enabled = false
			end

			local tweenInfo5 = TweenInfo.new(0.425, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local vector33 = Vector3.new(radius * 2.5, radius * 2.5, radius * 2.5)

			tweenService:Create(clone, tweenInfo5, { Transparency = 1, Size = vector33 }):Play()
			task.delay(0.425, function()
				if clone and clone.Parent then
					clone:SetAttribute("BlocksVision", nil)
				end
			end)

			if clone2 and clone2.Parent then
				local tweenInfo6 = TweenInfo.new(0.425, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				local vector34 = Vector3.new(radius * 2.501, radius * 2.501, radius * 2.501)

				tweenService:Create(clone2, tweenInfo6, { Transparency = 1, Size = vector34 }):Play()

				for _, v in pairs(clone2:GetDescendants()) do
					if v:IsA("Decal") then
						local tweenInfo7 = TweenInfo.new(0.825, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

						tweenService:Create(v, tweenInfo7, { Transparency = 1 }):Play()
					end
				end
			end

			for _, v in pairs(clone:GetDescendants()) do
				if v:IsA("Decal") then
					local tweenInfo8 = TweenInfo.new(0.825, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

					tweenService:Create(v, tweenInfo8, { Transparency = 1 }):Play()
				end
			end

			task.wait(0.3)
			u68 = false
			task.wait(3)

			if clone.Parent then
				clone:Destroy()
			end

			if clone2 and clone2.Parent then
				clone2:Destroy()
			end
		end
	end)
end
