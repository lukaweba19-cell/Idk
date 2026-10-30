-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local beam1 = replicatedStorage.FX.BulletFX.SeaPiercer.Beam1
local beam2 = replicatedStorage.FX.BulletFX.SeaPiercer.Beam2
local beam3 = replicatedStorage.FX.BulletFX.SeaPiercer.Beam3
local water = replicatedStorage.FX.BulletFX.SeaPiercer:FindFirstChild("Water")
local misc = require(game.ReplicatedStorage.Util.Misc)

return function(p1)
	local parent = p1.Part
	local attachment0 = p1.Attachment0
	local attachment1 = p1.Attachment1
	local cFrame = p1.CFrame
	local origin = p1.Origin
	local hitPos = p1.HitPos
	local length = p1.Length
	local gunRoot = p1.GunRoot

	if gunRoot then
		local revolverMuzzle = gunRoot:FindFirstChild("RevolverMuzzle")

		if revolverMuzzle then
			revolverMuzzle.Light.Brightness = 10

			local revolverMuzzleLight = revolverMuzzle.Light
			local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Linear)

			tweenService:Create(revolverMuzzleLight, tweenInfo, { Brightness = 0 }):Play()
			misc.EmitAll(revolverMuzzle)
		end
	end

	local clone = beam1:Clone()

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

	local tweenInfo2 = TweenInfo.new(1, Enum.EasingStyle.Linear)
	local v24: Tween = tweenService:Create(numberValue, tweenInfo2, { Value = 1 })

	v24:Play()
	v24.Completed:Connect(function()
		numberValue:Destroy()
	end)
	clone.TextureSpeed = 6

	local numberValue2: NumberValue = Instance.new("NumberValue")

	numberValue2.Value = 6
	numberValue2.Changed:Connect(function(textureSpeed: number)
		clone.TextureSpeed = textureSpeed
	end)

	local tweenInfo3 = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local v27: Tween = tweenService:Create(numberValue2, tweenInfo3, { Value = 0 })

	v27:Play()
	v27.Completed:Connect(function()
		numberValue2:Destroy()
	end)

	local clone2 = beam2:Clone()

	clone2.Attachment0 = attachment0
	clone2.Attachment1 = attachment1
	clone2.Parent = parent

	local tweenInfo4 = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

	tweenService:Create(clone2, tweenInfo4, { Width0 = 0, Width1 = 0 }):Play()

	local numberValue3: NumberValue = Instance.new("NumberValue")

	numberValue3.Value = 0
	numberValue3.Changed:Connect(function(p4: number)
		clone2.Transparency = NumberSequence.new(p4)
	end)

	local tweenInfo5 = TweenInfo.new(1, Enum.EasingStyle.Linear)
	local v32: Tween = tweenService:Create(numberValue3, tweenInfo5, { Value = 1 })

	v32:Play()
	v32.Completed:Connect(function()
		numberValue3:Destroy()
	end)
	clone2.TextureSpeed = 6

	local numberValue4: NumberValue = Instance.new("NumberValue")

	numberValue4.Value = 6
	numberValue4.Changed:Connect(function(textureSpeed: number)
		clone2.TextureSpeed = textureSpeed
	end)

	local tweenInfo6 = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local v35: Tween = tweenService:Create(numberValue4, tweenInfo6, { Value = 0 })

	v35:Play()
	v35.Completed:Connect(function()
		numberValue4:Destroy()
	end)

	local clone3 = beam3:Clone()

	clone3.Attachment0 = attachment0
	clone3.Attachment1 = attachment1
	clone3.Parent = parent

	local tweenInfo7 = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

	tweenService:Create(clone3, tweenInfo7, { Width0 = 0, Width1 = 0 }):Play()

	local numberValue5: NumberValue = Instance.new("NumberValue")

	numberValue5.Value = 0
	numberValue5.Changed:Connect(function(p6: number)
		clone3.Transparency = NumberSequence.new(p6)
	end)

	local tweenInfo8 = TweenInfo.new(1, Enum.EasingStyle.Linear)
	local v40: Tween = tweenService:Create(numberValue5, tweenInfo8, { Value = 1 })

	v40:Play()
	v40.Completed:Connect(function()
		numberValue5:Destroy()
	end)
	clone3.TextureSpeed = 6

	local numberValue6: NumberValue = Instance.new("NumberValue")

	numberValue6.Value = 6
	numberValue6.Changed:Connect(function(textureSpeed: number)
		clone3.TextureSpeed = textureSpeed
	end)

	local tweenInfo9 = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local v43 = tweenService:Create(numberValue6, tweenInfo9, { Value = 0 })

	v43:Play()
	v43.Completed:Connect(function()
		numberValue6:Destroy()
	end)
	v43 = hitPos - origin

	local magnitude = v43.Magnitude

	if magnitude < 0.1 then
		return
	end

	local unit = v43.Unit
	local roundedUp = math.ceil(magnitude / 10)

	v43 = math.max(3, roundedUp)

	local t1: {[any]: any} = {}

	for i = 1, v43 do
		local n1 = origin + unit * (magnitude * ((i - 0.5) / v43))
		local part: Part = Instance.new("Part")

		part.Name = "FrostTrailSeg_" .. i
		part.Anchored = true
		part.CanCollide = false
		part.CanTouch = false
		part.CanQuery = false
		part.Transparency = 1
		part.Size = Vector3.new(1, 1, magnitude / v43)
		part.CFrame = CFrame.lookAt(n1, n1 + unit)
		part.Parent = workspace.Bin
		t1[i] = part

		if water then
			local clone4 = water:Clone()

			clone4.Parent = part

			if not clone4:IsA("ParticleEmitter") then
				continue
			end

			clone4.Shape = Enum.ParticleEmitterShape.Box
			clone4.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
			clone4:Emit(3)
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
