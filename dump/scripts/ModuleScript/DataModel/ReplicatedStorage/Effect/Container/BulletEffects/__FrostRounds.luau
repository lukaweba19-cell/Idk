-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
game:GetService("TweenService")

local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local misc = require(game.ReplicatedStorage.Util.Misc)
local highlightPools = require(game.ReplicatedStorage.Util.HighlightPools)
local beam = replicatedStorage.FX.AbilityFX.FrostRounds.Beam
local beam2 = replicatedStorage.FX.AbilityFX.FrostRounds.Beam2
local airSnow = replicatedStorage.FX.AbilityFX.FrostRounds:FindFirstChild("AirSnow")
local tweenService: TweenService = game:GetService("TweenService")
local t1: {[any]: any} = {
	Duration = 1,
	TextureSpeedStart = 6,
	TextureSpeedEnd = 0,
	WidthEasing = Enum.EasingStyle.Quint,
	WidthDirection = Enum.EasingDirection.In,
	TransparencyEasing = Enum.EasingStyle.Linear,
	TransparencyDirection = Enum.EasingDirection.Out,
	TextureSpeedEasing = Enum.EasingStyle.Quint,
	TextureSpeedDirection = Enum.EasingDirection.Out
}

local function tweenBeam(p1, attachment0, attachment1, parent, p5)
	local t2 = p5 or {}

	local function get(p6)
		return t2[p6] ~= nil and t2[p6] or t1[p6]
	end

	local v17 = t2.Duration ~= nil and t2.Duration or t1.Duration
	local clone = p1:Clone()

	clone.Attachment0 = attachment0
	clone.Attachment1 = attachment1
	clone.Parent = parent

	local tweenInfo = TweenInfo.new(v17, t2.WidthEasing ~= nil and t2.WidthEasing or t1.WidthEasing, t2.WidthDirection ~= nil and t2.WidthDirection or t1.WidthDirection)

	tweenService:Create(clone, tweenInfo, { Width0 = 0, Width1 = 0 }):Play()

	local numberValue: NumberValue = Instance.new("NumberValue")

	numberValue.Value = 0
	numberValue.Changed:Connect(function(p7: number)
		clone.Transparency = NumberSequence.new(p7)
	end)

	local tweenInfo2 = TweenInfo.new(v17, t2.TransparencyEasing ~= nil and t2.TransparencyEasing or t1.TransparencyEasing, t2.TransparencyDirection ~= nil and t2.TransparencyDirection or t1.TransparencyDirection)
	local v22 = tweenService:Create(numberValue, tweenInfo2, { Value = 1 })

	v22:Play()
	v22.Completed:Connect(function()
		numberValue:Destroy()
	end)
	v22 = t2.TextureSpeedStart ~= nil and t2.TextureSpeedStart or t1.TextureSpeedStart

	local value = t2.TextureSpeedEnd ~= nil and t2.TextureSpeedEnd or t1.TextureSpeedEnd

	clone.TextureSpeed = v22

	local numberValue2: NumberValue = Instance.new("NumberValue")

	numberValue2.Value = v22
	numberValue2.Changed:Connect(function(textureSpeed: number)
		clone.TextureSpeed = textureSpeed
	end)

	local tweenInfo3 = TweenInfo.new(v17, t2.TextureSpeedEasing ~= nil and t2.TextureSpeedEasing or t1.TextureSpeedEasing, t2.TextureSpeedDirection ~= nil and t2.TextureSpeedDirection or t1.TextureSpeedDirection)

	v22 = tweenService:Create(numberValue2, tweenInfo3, { Value = value })
	v22:Play()
	v22.Completed:Connect(function()
		numberValue2:Destroy()
	end)
	task.delay(v17, function()
		if clone.Parent then
			clone:Destroy()
		end
	end)

	return clone
end

return function(p9)
	local v27 = p9.Part
	local attachment0 = p9.Attachment0
	local attachment1 = p9.Attachment1
	local origin = p9.Origin
	local hitPos = p9.HitPos
	local gunRoot = p9.GunRoot

	if gunRoot then
		local revolverMuzzle = gunRoot:FindFirstChild("RevolverMuzzle")

		if revolverMuzzle then
			local light = revolverMuzzle:FindFirstChild("Light")

			if light then
				light.Brightness = 7

				local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Linear)

				tweenService:Create(light, tweenInfo, { Brightness = 0 }):Play()
			end

			misc.EmitAll(revolverMuzzle)
		end
	end

	if gunRoot and gunRoot.Parent then
		local __FrostGunHL = gunRoot.Parent:FindFirstChild("__FrostGunHL")

		if __FrostGunHL and __FrostGunHL:IsA("ObjectValue") and __FrostGunHL.Value then
			local __FrostGunHLValue = __FrostGunHL.Value
			local poolGeneration = __FrostGunHL:GetAttribute("PoolGeneration")
			local u39: boolean = true

			if typeof(poolGeneration) == "number" then
				local v40 = highlightPools.Effect:generationOf(__FrostGunHLValue)

				u39 = poolGeneration == v40
			end

			if u39 then
				local v41 = math.min(1, __FrostGunHLValue.FillTransparency + 0.25)
				local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear)
				local v43: Tween = tweenService:Create(__FrostGunHLValue, tweenInfo, { FillTransparency = v41 })

				highlightPools.Effect:trackTween(__FrostGunHLValue, v43)
				v43:Play()
			end
		end
	end

	tweenBeam(beam, attachment0, attachment1, v27, {
		Duration = 0.5,
		TextureSpeedStart = 10,
		WidthEasing = Enum.EasingStyle.Linear
	})
	tweenBeam(beam2, attachment0, attachment1, v27, {
		Duration = 0.5,
		TextureSpeedStart = 10,
		WidthEasing = Enum.EasingStyle.Linear
	})

	local n1 = hitPos - origin
	local magnitude = n1.Magnitude

	if magnitude < 0.1 then
		return
	end

	local unit = n1.Unit
	local roundedUp = math.ceil(magnitude / 20)

	n1 = math.max(3, roundedUp)

	local t3: {[any]: any} = {}

	for i = 1, n1 do
		local n2 = origin + unit * (magnitude * ((i - 0.5) / n1))
		local part: Part = Instance.new("Part")

		part.Name = "FrostTrailSeg_" .. i
		part.Anchored = true
		part.CanCollide = false
		part.CanTouch = false
		part.CanQuery = false
		part.Transparency = 1
		part.Size = Vector3.new(1, 1, magnitude / n1)
		part.CFrame = CFrame.lookAt(n2, n2 + unit)
		part.Parent = workspace.Bin
		t3[i] = part

		if airSnow then
			local clone = airSnow:Clone()

			clone.Parent = part

			if not clone:IsA("ParticleEmitter") then
				continue
			end

			clone.Shape = Enum.ParticleEmitterShape.Box
			clone.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
			clone.Enabled = true
		end
	end

	task.delay(1, function()
		for _, v in ipairs(t3) do
			if v.Parent then
				for _, iterValue in ipairs(v:GetChildren()) do
					if iterValue:IsA("ParticleEmitter") then
						iterValue.Enabled = false
					end
				end
			end
		end

		task.delay(2, function()
			for _, v in ipairs(t3) do
				if v.Parent then
					v:Destroy()
				end
			end
		end)
	end)
end
