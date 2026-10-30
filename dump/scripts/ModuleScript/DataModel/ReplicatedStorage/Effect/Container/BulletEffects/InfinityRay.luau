-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local beam1 = replicatedStorage.FX.BulletFX.InfinityRay.Beam1
local beam2 = replicatedStorage.FX.BulletFX.InfinityRay.Beam2
local beam3 = replicatedStorage.FX.BulletFX.InfinityRay.Beam3
local beam4 = replicatedStorage.FX.BulletFX.InfinityRay.Beam4
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
		revolverMuzzle.Light.Brightness = 25

		local revolverMuzzleLight = revolverMuzzle.Light
		local tweenInfo = TweenInfo.new(0.42, Enum.EasingStyle.Linear)

		tweenService:Create(revolverMuzzleLight, tweenInfo, { Brightness = 0 }):Play()
		misc.EmitAll(revolverMuzzle)
	end

	local clone = beam1:Clone()

	clone.Attachment0 = attachment0
	clone.Attachment1 = attachment1
	clone.Parent = part

	local tweenInfo = TweenInfo.new(1.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut)

	tweenService:Create(clone, tweenInfo, { Width0 = 0 }):Play()

	local tweenInfo2 = TweenInfo.new(2.1, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

	tweenService:Create(clone, tweenInfo2, { Width1 = 0 }):Play()
	clone.TextureSpeed = 6

	local numberValue: NumberValue = Instance.new("NumberValue")

	numberValue.Value = 6
	numberValue.Changed:Connect(function(textureSpeed: number)
		clone.TextureSpeed = textureSpeed
	end)

	local tweenInfo3 = TweenInfo.new(1.7, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
	local v25: Tween = tweenService:Create(numberValue, tweenInfo3, { Value = 0 })

	v25:Play()
	v25.Completed:Connect(function()
		numberValue:Destroy()
	end)

	local clone2 = beam2:Clone()

	clone2.Attachment0 = attachment0
	clone2.Attachment1 = attachment1
	clone2.Parent = part

	local tweenInfo4 = TweenInfo.new(1.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut)

	tweenService:Create(clone2, tweenInfo4, { Width0 = 0 }):Play()

	local tweenInfo5 = TweenInfo.new(2.1, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

	tweenService:Create(clone2, tweenInfo5, { Width1 = 0 }):Play()
	clone2.TextureSpeed = 6

	local numberValue2: NumberValue = Instance.new("NumberValue")

	numberValue2.Value = 6
	numberValue2.Changed:Connect(function(textureSpeed: number)
		clone2.TextureSpeed = textureSpeed
	end)

	local tweenInfo6 = TweenInfo.new(1.7, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
	local v31: Tween = tweenService:Create(numberValue2, tweenInfo6, { Value = 0 })

	v31:Play()
	v31.Completed:Connect(function()
		numberValue2:Destroy()
	end)

	local clone3 = beam3:Clone()

	clone3.Attachment0 = attachment0
	clone3.Attachment1 = attachment1
	clone3.Parent = part

	local tweenInfo7 = TweenInfo.new(1.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut)

	tweenService:Create(clone3, tweenInfo7, { Width0 = 0 }):Play()

	local tweenInfo8 = TweenInfo.new(2.1, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

	tweenService:Create(clone3, tweenInfo8, { Width1 = 0 }):Play()
	clone3.TextureSpeed = 6

	local numberValue3: NumberValue = Instance.new("NumberValue")

	numberValue3.Value = 6
	numberValue3.Changed:Connect(function(textureSpeed: number)
		clone3.TextureSpeed = textureSpeed
	end)

	local tweenInfo9 = TweenInfo.new(1.7, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
	local v37: Tween = tweenService:Create(numberValue3, tweenInfo9, { Value = 0 })

	v37:Play()
	v37.Completed:Connect(function()
		numberValue3:Destroy()
	end)

	local clone4 = beam4:Clone()

	clone4.Attachment0 = attachment0
	clone4.Attachment1 = attachment1
	clone4.Parent = part

	local tweenInfo10 = TweenInfo.new(1.4, Enum.EasingStyle.Back, Enum.EasingDirection.InOut)

	tweenService:Create(clone4, tweenInfo10, { Width0 = 0 }):Play()

	local tweenInfo11 = TweenInfo.new(2.1, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

	tweenService:Create(clone4, tweenInfo11, { Width1 = 0 }):Play()
	clone4.TextureSpeed = 6

	local numberValue4: NumberValue = Instance.new("NumberValue")

	numberValue4.Value = 6
	numberValue4.Changed:Connect(function(textureSpeed: number)
		clone4.TextureSpeed = textureSpeed
	end)

	local tweenInfo12 = TweenInfo.new(1.7, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
	local v43: Tween = tweenService:Create(numberValue4, tweenInfo12, { Value = 0 })

	v43:Play()
	v43.Completed:Connect(function()
		numberValue4:Destroy()
	end)
end
