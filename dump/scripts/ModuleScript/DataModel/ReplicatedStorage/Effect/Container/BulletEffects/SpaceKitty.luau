-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local beam = replicatedStorage.FX.BulletFX.SpaceKitty.Beam
local misc = require(game.ReplicatedStorage.Util.Misc)

return function(p1)
	local parent = p1.Part
	local attachment0 = p1.Attachment0
	local attachment1 = p1.Attachment1
	local cFrame = p1.CFrame
	local origin = p1.Origin
	local hitPos = p1.HitPos
	local length = p1.Length
	local stars = replicatedStorage.FX.BulletFX.SpaceKitty:FindFirstChild("Stars")
	local gunRoot = p1.GunRoot

	if gunRoot then
		local revolverMuzzle = gunRoot:FindFirstChild("RevolverMuzzle")

		if revolverMuzzle then
			revolverMuzzle.Light.Brightness = 7

			local revolverMuzzleLight = revolverMuzzle.Light
			local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Linear)

			tweenService:Create(revolverMuzzleLight, tweenInfo, { Brightness = 0 }):Play()
			misc.EmitAll(revolverMuzzle)
		end
	end

	local clone = beam:Clone()

	clone.Attachment0 = attachment0
	clone.Attachment1 = attachment1
	clone.Parent = parent

	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

	tweenService:Create(clone, tweenInfo, { Width0 = 0, Width1 = 0 }):Play()

	local numberValue: NumberValue = Instance.new("NumberValue")

	numberValue.Value = 0
	numberValue.Changed:Connect(function(p2: number)
		clone.Transparency = NumberSequence.new(p2)
	end)

	local tweenInfo2 = TweenInfo.new(1.8, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
	local v22: Tween = tweenService:Create(numberValue, tweenInfo2, { Value = 1 })

	v22:Play()
	v22.Completed:Connect(function()
		numberValue:Destroy()
	end)
	clone.TextureSpeed = 4

	local numberValue2: NumberValue = Instance.new("NumberValue")

	numberValue2.Value = 4
	numberValue2.Changed:Connect(function(textureSpeed: number)
		clone.TextureSpeed = textureSpeed
	end)

	local tweenInfo3 = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
	local v25 = tweenService:Create(numberValue2, tweenInfo3, { Value = 0 })

	v25:Play()
	v25.Completed:Connect(function()
		numberValue2:Destroy()
	end)
	v25 = hitPos - origin

	local magnitude = v25.Magnitude

	if magnitude < 0.1 then
		return
	end

	local unit = v25.Unit
	local roundedUp = math.ceil(magnitude / 10)

	v25 = math.max(3, roundedUp)

	local t1: {[any]: any} = {}

	for i = 1, v25 do
		local n1 = origin + unit * (magnitude * ((i - 0.5) / v25))
		local part: Part = Instance.new("Part")

		part.Name = "FrostTrailSeg_" .. i
		part.Anchored = true
		part.CanCollide = false
		part.CanTouch = false
		part.CanQuery = false
		part.Transparency = 1
		part.Size = Vector3.new(1, 1, magnitude / v25)
		part.CFrame = CFrame.lookAt(n1, n1 + unit)
		part.Parent = workspace.Bin
		t1[i] = part

		if stars then
			local clone2 = stars:Clone()

			clone2.Parent = part

			if not clone2:IsA("ParticleEmitter") then
				continue
			end

			clone2.Shape = Enum.ParticleEmitterShape.Box
			clone2.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
			clone2:Emit(6)
		end
	end

	task.delay(1, function()
		for _, v in ipairs(t1) do
			if v.Parent then
				for _, iterValue in ipairs(v:GetChildren()) do
					if iterValue:IsA("ParticleEmitter") then
						iterValue.Enabled = false
					end
				end
			end
		end

		task.delay(2, function()
			for _, v in ipairs(t1) do
				if v.Parent then
					v:Destroy()
				end
			end
		end)
	end)
end
