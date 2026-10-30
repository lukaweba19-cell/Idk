-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")
local beam = game:GetService("ReplicatedStorage").FX.BulletFX.Lightning.Beam
local misc = require(game.ReplicatedStorage.Util.Misc)
local lightning = require(game.ReplicatedStorage.Util.Lightning)
local lightningConfig = lightning.Config
local color3 = Color3.fromRGB(137, 153, 255)
local v7 = lightningConfig({
	Branch_ThicknessFactor = 0.5,
	Branch_ThicknessRandomness = 0.3,
	AnimationType = "Sway",
	Sway_MaxOffsetFactor = 0.04,
	Sway_FalloffPower = 8.2,
	Raycast = false,
	FolderName = "LightningBulletFX",
	Segments = NumberRange.new(6, 10),
	Jaggedness = NumberRange.new(0.04, 0.08),
	Curvature = NumberRange.new(0.02, 0.05),
	CurveBreaks = NumberRange.new(1, 2),
	Thickness = NumberRange.new(0.15, 0.3),
	Color = color3,
	Material = Enum.Material.Neon,
	SpawnDur = NumberRange.new(0.03, 0.06),
	Lifetime = NumberRange.new(0.25, 0.4),
	FadeTime = NumberRange.new(0.3, 0.5),
	Branch_Amount = NumberRange.new(1, 3),
	Branch_Span = NumberRange.new(1, 3),
	Branch_Segments = NumberRange.new(3, 5),
	Branch_LengthFactor = NumberRange.new(0.15, 0.3),
	Sway_Grabs = NumberRange.new(7, 77),
	Parent = workspace
})
local v8 = lightning.UsePreset("ThinZap", v7)

v8.AnimationType = "Sway"
v8.Sway_MaxOffsetFactor = 0.04
v8.Sway_FalloffPower = 1.2
v8.Sway_Grabs = NumberRange.new(2, 4)
v8.Lifetime = NumberRange.new(0.25, 0.4)
v8.FadeTime = NumberRange.new(0.3, 0.5)
v8.SpawnDur = NumberRange.new(0.03, 0.06)

local v9 = lightning.Storm({
	SpawnRate = NumberRange.new(1, 1),
	StartVolume = workspace.Terrain,
	EndVolume = workspace.Terrain
}, v8)

return function(p1)
	local part = p1.Part
	local attachment0 = p1.Attachment0
	local attachment1 = p1.Attachment1
	local origin = p1.Origin
	local hitPos = p1.HitPos
	local gunRoot = p1.GunRoot
	local revolverMuzzle = gunRoot and gunRoot:FindFirstChild("RevolverMuzzle")

	if revolverMuzzle then
		revolverMuzzle.Light.Brightness = 7

		local revolverMuzzleLight = revolverMuzzle.Light
		local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Linear)

		tweenService:Create(revolverMuzzleLight, tweenInfo, { Brightness = 0 }):Play()
		misc.EmitAll(revolverMuzzle)
	end

	if origin and hitPos then
		v9:Strike(origin, hitPos)
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
end
