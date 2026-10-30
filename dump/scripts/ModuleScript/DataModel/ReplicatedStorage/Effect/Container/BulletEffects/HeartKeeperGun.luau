-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local beam1 = replicatedStorage.FX.BulletFX.HeartKeeperGun.Beam1
local beam2 = replicatedStorage.FX.BulletFX.HeartKeeperGun.Beam2
local beam3 = replicatedStorage.FX.BulletFX.HeartKeeperGun.Beam3
local beam4 = replicatedStorage.FX.BulletFX.HeartKeeperGun.Beam4
local misc = require(game.ReplicatedStorage.Util.Misc)

return function(p1)
	local part = p1.Part
	local attachment0 = p1.Attachment0
	local attachment1 = p1.Attachment1
	local cFrame = p1.CFrame
	local origin = p1.Origin
	local hitPos = p1.HitPos
	local length = p1.Length
	local gunRoot = p1.GunRoot
	local revolverMuzzle = gunRoot and gunRoot:FindFirstChild("RevolverMuzzle")

	if revolverMuzzle then
		revolverMuzzle.Light.Brightness = 7

		local revolverMuzzleLight = revolverMuzzle.Light
		local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Linear)

		tweenService:Create(revolverMuzzleLight, tweenInfo, { Brightness = 0 }):Play()
		misc.EmitAll(revolverMuzzle)
	end

	local clone = beam1:Clone()

	clone.Attachment0 = attachment0
	clone.Attachment1 = attachment1
	clone.Parent = part

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
	clone2.Parent = part

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
	clone3.Parent = part

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
	local v43: Tween = tweenService:Create(numberValue6, tweenInfo9, { Value = 0 })

	v43:Play()
	v43.Completed:Connect(function()
		numberValue6:Destroy()
	end)

	local clone4 = beam4:Clone()

	clone4.Attachment0 = attachment0
	clone4.Attachment1 = attachment1
	clone4.Parent = part

	local tweenInfo10 = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

	tweenService:Create(clone4, tweenInfo10, { Width0 = 0, Width1 = 0 }):Play()

	local numberValue7: NumberValue = Instance.new("NumberValue")

	numberValue7.Value = 0
	numberValue7.Changed:Connect(function(p8: number)
		clone4.Transparency = NumberSequence.new(p8)
	end)

	local tweenInfo11 = TweenInfo.new(1, Enum.EasingStyle.Linear)
	local v48: Tween = tweenService:Create(numberValue7, tweenInfo11, { Value = 1 })

	v48:Play()
	v48.Completed:Connect(function()
		numberValue7:Destroy()
	end)
	clone4.TextureSpeed = 6

	local numberValue8: NumberValue = Instance.new("NumberValue")

	numberValue8.Value = 6
	numberValue8.Changed:Connect(function(textureSpeed: number)
		clone4.TextureSpeed = textureSpeed
	end)

	local tweenInfo12 = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local v51: Tween = tweenService:Create(numberValue8, tweenInfo12, { Value = 0 })

	v51:Play()
	v51.Completed:Connect(function()
		numberValue8:Destroy()
	end)
end
