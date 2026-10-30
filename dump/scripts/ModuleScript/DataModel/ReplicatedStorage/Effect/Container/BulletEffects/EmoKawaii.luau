-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")
local beam = game:GetService("ReplicatedStorage").FX.BulletFX.EmoKawaii.Beam
local misc = require(game.ReplicatedStorage.Util.Misc)

return function(p1)
	local part = p1.Part
	local attachment0 = p1.Attachment0
	local attachment1 = p1.Attachment1
	local origin = p1.Origin
	local hitPos = p1.HitPos
	local gunRoot = p1.GunRoot
	local revolver = gunRoot and gunRoot:FindFirstChild("Revolver")
	local revolverMuzzle = revolver and revolver:FindFirstChild("RevolverMuzzle")

	if revolverMuzzle then
		revolverMuzzle.Light.Brightness = 7

		local revolverMuzzleLight = revolverMuzzle.Light
		local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Linear)

		tweenService:Create(revolverMuzzleLight, tweenInfo, { Brightness = 0 }):Play()
		misc.EmitAll(revolverMuzzle)
	end

	local clone = beam:Clone()

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
	local v19: Tween = tweenService:Create(numberValue, tweenInfo2, { Value = 1 })

	v19:Play()
	v19.Completed:Connect(function()
		numberValue:Destroy()
	end)
	clone.TextureSpeed = 6

	local numberValue2: NumberValue = Instance.new("NumberValue")

	numberValue2.Value = 6
	numberValue2.Changed:Connect(function(textureSpeed: number)
		clone.TextureSpeed = textureSpeed
	end)

	local tweenInfo3 = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local v22: Tween = tweenService:Create(numberValue2, tweenInfo3, { Value = 0 })

	v22:Play()
	v22.Completed:Connect(function()
		numberValue2:Destroy()
	end)
end
