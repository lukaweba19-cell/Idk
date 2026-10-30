-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local debris: Debris = game:GetService("Debris")
local tweenService: TweenService = game:GetService("TweenService")
local color3 = Color3.fromRGB(250, 226, 53)
local color32 = Color3.fromRGB(255, 170, 40)
local color33 = Color3.new(1, 1, 1)
local t1: {[any]: any} = {
	{
		Over = 50000,
		Sound = "rbxassetid://100160329421269",
		Duration = 4,
		Rate = 90,
		Burst = 90,
		Size = 1.7,
		Light = 8,
		Big = true,
		Speed = NumberRange.new(20, 34)
	},
	{
		Over = 5000,
		Sound = "rbxassetid://130965474624821",
		Duration = 2,
		Rate = 55,
		Burst = 45,
		Size = 1.35,
		Light = 4,
		Big = false,
		Speed = NumberRange.new(16, 27)
	},
	{
		Over = 500,
		Sound = "rbxassetid://79529507168669",
		Duration = 1,
		Rate = 35,
		Burst = 22,
		Size = 1.1,
		Light = 2,
		Big = false,
		Speed = NumberRange.new(13, 22)
	},
	{
		Over = -1,
		Sound = "rbxassetid://122242100525976",
		Duration = 0.5,
		Rate = 25,
		Burst = 12,
		Size = 0.9,
		Light = 0,
		Big = false,
		Speed = NumberRange.new(11, 18)
	}
}

local function anchorFor(p2)
	local signBoard = p2:FindFirstChild("SignBoard")
	local parent = if signBoard and signBoard:IsA("BasePart") then signBoard else p2.PrimaryPart or p2:FindFirstChildWhichIsA("BasePart")

	if parent == nil then
		return nil
	end

	local saleFX: Attachment = Instance.new("Attachment")

	saleFX.Name = "SaleFX"
	saleFX.CFrame = CFrame.new(0, parent.Size.Y / 2 + 0.4, 0)
	saleFX.Parent = parent

	return saleFX
end
local function tokens(parent, p4)
	local tokens: ParticleEmitter = Instance.new("ParticleEmitter")

	tokens.Name = "Tokens"
	tokens.Texture = "rbxassetid://136055703183590"
	tokens.Color = ColorSequence.new(color33)

	local numberSequenceNew = NumberSequence.new

	tokens.Size = numberSequenceNew({
		NumberSequenceKeypoint.new(0, p4.Size * 0.5),
		NumberSequenceKeypoint.new(0.12, p4.Size),
		NumberSequenceKeypoint.new(0.8, p4.Size),
		NumberSequenceKeypoint.new(1, p4.Size * 0.35)
	})
	tokens.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.75, 0),
		NumberSequenceKeypoint.new(1, 1)
	})
	tokens.Lifetime = NumberRange.new(1.1, 1.8)
	tokens.Speed = p4.Speed
	tokens.SpreadAngle = Vector2.new(38, 38)
	tokens.EmissionDirection = Enum.NormalId.Top
	tokens.Rotation = NumberRange.new(-180, 180)
	tokens.RotSpeed = NumberRange.new(-260, 260)
	tokens.Acceleration = Vector3.new(0, -30, 0)
	tokens.Drag = 0.6
	tokens.LightEmission = 0.35
	tokens.LightInfluence = 0
	tokens.Brightness = 1.4
	tokens.Rate = p4.Rate
	tokens.Enabled = false
	tokens.Parent = parent

	return tokens
end
local function sparks(parent, p6)
	local sparks: ParticleEmitter = Instance.new("ParticleEmitter")

	sparks.Name = "Sparks"
	sparks.Texture = "rbxasset://textures/particles/sparkles_main.dds"

	local colorSequenceNew = ColorSequence.new

	sparks.Color = colorSequenceNew({
		ColorSequenceKeypoint.new(0, color33),
		ColorSequenceKeypoint.new(0.3, color3),
		ColorSequenceKeypoint.new(1, color32)
	})

	local numberSequenceNew = NumberSequence.new
	local numberSequenceKeypoint = NumberSequenceKeypoint.new(0, p6.Size * 0.45)

	sparks.Size = numberSequenceNew({ numberSequenceKeypoint, NumberSequenceKeypoint.new(1, 0) })
	sparks.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.6, 0.2),
		NumberSequenceKeypoint.new(1, 1)
	})
	sparks.Lifetime = NumberRange.new(0.45, 1)
	sparks.Speed = NumberRange.new(p6.Speed.Min * 0.5, p6.Speed.Max * 0.7)
	sparks.SpreadAngle = Vector2.new(180, 180)
	sparks.Acceleration = Vector3.new(0, -8, 0)
	sparks.Drag = 1.5
	sparks.LightEmission = 1
	sparks.LightInfluence = 0
	sparks.Brightness = 2
	sparks.Rate = p6.Rate * 2
	sparks.Enabled = false
	sparks.Parent = parent

	return sparks
end
local function ring(parent, p8)
	local ring: ParticleEmitter = Instance.new("ParticleEmitter")

	ring.Name = "Ring"
	ring.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	ring.Color = ColorSequence.new(color3, color33)

	local numberSequenceNew = NumberSequence.new
	local numberSequenceKeypoint = NumberSequenceKeypoint.new(0, p8.Size * 0.9)

	ring.Size = numberSequenceNew({ numberSequenceKeypoint, NumberSequenceKeypoint.new(1, p8.Size * 0.2) })
	ring.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
	ring.Lifetime = NumberRange.new(0.5, 0.7)
	ring.Speed = NumberRange.new(40, 55)
	ring.SpreadAngle = Vector2.new(180, 8)
	ring.EmissionDirection = Enum.NormalId.Top
	ring.Drag = 3
	ring.LightEmission = 1
	ring.LightInfluence = 0
	ring.Brightness = 3
	ring.Rate = 0
	ring.Enabled = false
	ring.Parent = parent

	return ring
end

local module: {[any]: any} = {
	TierFor = function(p1)
		for _, v in ipairs(t1) do
			if p1 > v.Over then
				return v
			end
		end

		return t1[#t1]
	end
}

function module.Play(p9, p10)
	local tierFor = module.TierFor
	local numberValue: number? = tonumber(p10)
	local v38 = tierFor(numberValue or 0)
	local parent = anchorFor(p9)

	if parent == nil then
		return
	end

	local v40 = tokens(parent, v38)
	local v41 = sparks(parent, v38)
	local v42 = if v38.Big then ring(parent, v38) else nil
	local saleSound: Sound = Instance.new("Sound")

	saleSound.Name = "SaleSound"
	saleSound.SoundId = v38.Sound
	saleSound.Volume = 2.5
	saleSound.RollOffMode = Enum.RollOffMode.InverseTapered
	saleSound.RollOffMinDistance = 12
	saleSound.RollOffMaxDistance = 180
	saleSound.Parent = parent
	saleSound:Play()

	if v38.Light > 0 then
		local pointLight: PointLight = Instance.new("PointLight")

		pointLight.Color = color3
		pointLight.Brightness = v38.Light
		pointLight.Range = if v38.Big then 34 else 22
		pointLight.Shadows = false
		pointLight.Parent = parent

		local tweenInfo = TweenInfo.new(v38.Duration + 0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		tweenService:Create(pointLight, tweenInfo, { Brightness = 0 }):Play()
	end

	v40:Emit(v38.Burst)
	v41:Emit(v38.Burst * 2)

	if v42 then
		v42:Emit(120)
	end

	v40.Enabled = true
	v41.Enabled = true
	task.spawn(function()
		if v38.Big then
			local n1: number = 0

			while n1 < v38.Duration - 0.2 and parent.Parent ~= nil do
				task.wait(0.8)
				n1 += 0.8

				if parent.Parent == nil then
					return
				end

				v40:Emit(v38.Burst)

				if v42 then
					v42:Emit(90)
				end
			end
		else
			task.wait(v38.Duration)
		end

		if parent.Parent == nil then
			return
		end

		v40.Enabled = false
		v41.Enabled = false

		local n2 = os.clock() + 12

		task.wait(2)

		while saleSound.Parent ~= nil and saleSound.IsPlaying and n2 > os.clock() do
			task.wait(0.25)
		end

		parent:Destroy()
	end)
	debris:AddItem(parent, v38.Duration + 16)
end

return module
