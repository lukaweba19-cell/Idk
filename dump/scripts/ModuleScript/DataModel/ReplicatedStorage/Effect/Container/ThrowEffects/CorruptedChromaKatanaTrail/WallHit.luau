-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)

local sound = require(game.ReplicatedStorage.Sound)
local debris = require(game.ReplicatedStorage.Util.Debris)
local tweenService: TweenService = game:GetService("TweenService")

local function makeTween(p1, p2, p3)
	return (tweenService:Create(p1, p2, p3))
end

local color3 = Color3.fromRGB(103, 0, 0)
local color32 = Color3.fromRGB(65, 0, 0)
local color33 = Color3.fromRGB(3, 3, 3)
local color34 = Color3.fromRGB(28, 28, 28)

local function getBrightness(p4)
	return p4.R * 0.2126 + p4.G * 0.7152 + p4.B * 0.0722
end
local function recolorColor(p5)
	local n1 = p5.R * 0.2126 + p5.G * 0.7152 + p5.B * 0.0722

	if n1 < 0.38 then
		local v18 = math.clamp(n1 / 0.38, 0, 1)

		return color33:Lerp(color34, v18)
	end

	local v19 = math.clamp((n1 - 0.38) / 0.62, 0, 1)

	return color32:Lerp(color3, v19)
end
local function recolorSequence(p6)
	local t1: {[any]: any} = {}

	for iterFirst, iterSecond in p6.Keypoints, nil, nil do
		table.insert(t1, ColorSequenceKeypoint.new(iterSecond.Time, recolorColor(iterSecond.Value)))
	end

	return ColorSequence.new(t1)
end

return function(p7)
	local cFrame = p7.CFrame

	if (workspace.CurrentCamera.CFrame.p - cFrame.p).Magnitude > 1000 + (p7.Scale or 1.75) * 10 then
		return
	end

	sound:Play("WallHit." .. script.Parent.Name, cFrame, nil, nil, nil, nil)

	local clone = game.ReplicatedStorage.FX.WallHitFX.ChromaKatanaWallHit:Clone()

	clone.CFrame = cFrame

	for iterFirst, iterSecond in clone:GetDescendants() do
		if iterSecond:IsA("ParticleEmitter") or iterSecond:IsA("Beam") or iterSecond:IsA("Trail") then
			iterSecond.Color = recolorSequence(iterSecond.Color)
		end
	end

	clone.Parent = workspace.Bin
	debris:AddItem(clone, 1)

	for _, v in pairs(clone:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v:Emit(v:GetAttribute("EmitCount"))
		end
	end

	local pointLight = clone.IMPACTBAMP.PointLight
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.In)

	tweenService:Create(pointLight, tweenInfo, { Brightness = 0 }):Play()
end
