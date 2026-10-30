-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local beam1 = replicatedStorage.FX.BulletFX.LibertysJustice.Beam1
local beam2 = replicatedStorage.FX.BulletFX.LibertysJustice.Beam2
local beam3 = replicatedStorage.FX.BulletFX.LibertysJustice.Beam3
local beam4 = replicatedStorage.FX.BulletFX.LibertysJustice.Beam4
local misc = require(game.ReplicatedStorage.Util.Misc)
local star = replicatedStorage.FX.BulletFX.LibertysJustice:FindFirstChild("Star")

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
			revolverMuzzle.Light.Brightness = 7

			local revolverMuzzleLight = revolverMuzzle.Light
			local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Linear)

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

	local tweenInfo2 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
	local v25: Tween = tweenService:Create(numberValue, tweenInfo2, { Value = 1 })

	v25:Play()
	v25.Completed:Connect(function()
		numberValue:Destroy()
	end)
	clone.TextureSpeed = 6

	local numberValue2: NumberValue = Instance.new("NumberValue")

	numberValue2.Value = 6
	numberValue2.Changed:Connect(function(textureSpeed: number)
		clone.TextureSpeed = textureSpeed
	end)

	local tweenInfo3 = TweenInfo.new(2, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
	local v28: Tween = tweenService:Create(numberValue2, tweenInfo3, { Value = 0 })

	v28:Play()
	v28.Completed:Connect(function()
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
	local v33: Tween = tweenService:Create(numberValue3, tweenInfo5, { Value = 1 })

	v33:Play()
	v33.Completed:Connect(function()
		numberValue3:Destroy()
	end)
	clone2.TextureSpeed = 6

	local numberValue4: NumberValue = Instance.new("NumberValue")

	numberValue4.Value = 6
	numberValue4.Changed:Connect(function(textureSpeed: number)
		clone2.TextureSpeed = textureSpeed
	end)

	local tweenInfo6 = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local v36: Tween = tweenService:Create(numberValue4, tweenInfo6, { Value = 0 })

	v36:Play()
	v36.Completed:Connect(function()
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
	local v41: Tween = tweenService:Create(numberValue5, tweenInfo8, { Value = 1 })

	v41:Play()
	v41.Completed:Connect(function()
		numberValue5:Destroy()
	end)
	clone3.TextureSpeed = 6

	local numberValue6: NumberValue = Instance.new("NumberValue")

	numberValue6.Value = 6
	numberValue6.Changed:Connect(function(textureSpeed: number)
		clone3.TextureSpeed = textureSpeed
	end)

	local tweenInfo9 = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local v44: Tween = tweenService:Create(numberValue6, tweenInfo9, { Value = 0 })

	v44:Play()
	v44.Completed:Connect(function()
		numberValue6:Destroy()
	end)

	local clone4 = beam4:Clone()

	clone4.Attachment0 = attachment0
	clone4.Attachment1 = attachment1
	clone4.Parent = parent

	local tweenInfo10 = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

	tweenService:Create(clone4, tweenInfo10, { Width0 = 0, Width1 = 0 }):Play()

	local numberValue7: NumberValue = Instance.new("NumberValue")

	numberValue7.Value = 0
	numberValue7.Changed:Connect(function(p8: number)
		clone4.Transparency = NumberSequence.new(p8)
	end)

	local tweenInfo11 = TweenInfo.new(1, Enum.EasingStyle.Linear)
	local v49: Tween = tweenService:Create(numberValue7, tweenInfo11, { Value = 1 })

	v49:Play()
	v49.Completed:Connect(function()
		numberValue7:Destroy()
	end)
	clone4.TextureSpeed = 6

	local numberValue8: NumberValue = Instance.new("NumberValue")

	numberValue8.Value = 6
	numberValue8.Changed:Connect(function(textureSpeed: number)
		clone4.TextureSpeed = textureSpeed
	end)

	local tweenInfo12 = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local v52 = tweenService:Create(numberValue8, tweenInfo12, { Value = 0 })

	v52:Play()
	v52.Completed:Connect(function()
		numberValue8:Destroy()
	end)
	v52 = hitPos - origin

	local magnitude = v52.Magnitude

	if magnitude < 0.1 then
		return
	end

	local unit = v52.Unit
	local roundedUp = math.ceil(magnitude / 10)

	v52 = math.max(3, roundedUp)

	local t1: {[any]: any} = {}

	for i = 1, v52 do
		local n1 = origin + unit * (magnitude * ((i - 0.5) / v52))
		local part: Part = Instance.new("Part")

		part.Name = "FrostTrailSeg_" .. i
		part.Anchored = true
		part.CanCollide = false
		part.CanTouch = false
		part.CanQuery = false
		part.Transparency = 1
		part.Size = Vector3.new(1, 1, magnitude / v52)
		part.CFrame = CFrame.lookAt(n1, n1 + unit)
		part.Parent = workspace.Bin
		t1[i] = part

		if star then
			local clone5 = star:Clone()

			clone5.Parent = part

			if not clone5:IsA("ParticleEmitter") then
				continue
			end

			clone5.Shape = Enum.ParticleEmitterShape.Box
			clone5.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
			clone5:Emit(6)
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
