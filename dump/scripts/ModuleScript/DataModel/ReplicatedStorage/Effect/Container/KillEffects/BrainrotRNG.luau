-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local sound = require(game.ReplicatedStorage.Sound)
local tweenService: TweenService = game:GetService("TweenService")
local debris = require(game.ReplicatedStorage.Util.Debris)

require(game.ReplicatedStorage.Util.Misc)

local mesh = game.ReplicatedStorage.FX.KillEffects.BrainrotRNG.Mesh
local n1 = 0
local t1: {[any]: any} = {
	{ Name = "BrrBrrPatapim", Weight = 25, Offset = CFrame.new(0, -3, 0) },
	{
		Name = "BallerinaCappuccina",
		Weight = 20,
		Offset = CFrame.new(0, 0.45, 0)
	},
	{
		Name = "BonecaAmbalabu",
		Weight = 17,
		Offset = CFrame.new(0, 0.225, 0)
	},
	{ Name = "FrigoCamelo", Weight = 12, Offset = CFrame.new(0, 0.15, 0) },
	{ Name = "LiriliLarila", Weight = 10, Offset = CFrame.new(0, 0.05, 0) },
	{
		Name = "ChimpanziniBananini",
		Weight = 7,
		Offset = CFrame.new(0, -0.065, 0)
	},
	{
		Name = "CappuccinoAssasino",
		Weight = 5,
		Offset = CFrame.new(0, -0.75, 0)
	},
	{ Name = "TrippiTroppi", Weight = 3, Offset = CFrame.new(0, 1.3, 0) },
	{
		Name = "TralaleloTralala",
		Weight = 1,
		Offset = CFrame.new(0, 0.065, 0)
	}
}

for _, v in ipairs(t1) do
	n1 += v.Weight
end

local function rollBrainrot()
	local n3 = math.random() * n1
	local n2 = 0

	for _, v in ipairs(t1) do
		n2 += v.Weight

		if n3 <= n2 then
			return v
		end
	end

	return t1[1]
end

return function(player)
	local Character = player.Character

	if not Character then
		return
	end

	if (workspace.CurrentCamera.CFrame.Position - Character:GetPivot().Position).Magnitude > 1000 then
		return
	end

	local humanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

	if not humanoidRootPart then
		return
	end

	humanoidRootPart.Anchored = true

	for _, v in ipairs(Character:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Transparency = 1
		elseif not v:IsA("Decal") and not v:IsA("Texture") then
			if v:IsA("PointLight") or v:IsA("ParticleEmitter") or v:IsA("Beam") or v:IsA("Trail") then
				v.Enabled = false
			end
		else
			v.Transparency = 1
		end
	end

	local n3 = math.random() * n1
	local n2 = 0
	local v21, v22, v23 = ipairs(t1)
	local v24: boolean = false
	local s1

	for iterFirst, iterSecond in v21, v22, v23 do
		n2 += iterSecond.Weight

		if n3 <= n2 then
			s1 = iterSecond
			v24 = true

			break
		end
	end

	if not v24 then
		s1 = t1[1]
	end

	local foundChild = mesh:FindFirstChild(s1.Name)

	if not foundChild then
		return
	end

	local _fx_BrainrotRNG: Folder = Instance.new("Folder")

	_fx_BrainrotRNG.Name = "_FX_BrainrotRNG"
	_fx_BrainrotRNG.Parent = workspace.Bin
	Character.AncestryChanged:Once(function()
		if not Character:IsDescendantOf(game) then
			_fx_BrainrotRNG:Destroy()
		end
	end)
	debris:AddItem(_fx_BrainrotRNG, 8)

	local clone = foundChild:Clone()
	local clonePrimaryPart = clone.PrimaryPart
	local cFrame = CFrame.new(humanoidRootPart.Position)

	clone:PivotTo(cFrame * s1.Offset)

	local clonePrimaryPartCFrame = clonePrimaryPart.CFrame
	local v34 = CFrame.Angles(0, 3.141592653589793, 0)

	clonePrimaryPart.CFrame = clonePrimaryPartCFrame * v34

	for _, v in ipairs(clone:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Anchored = true
			v.CanCollide = false
		end
	end

	clone.Parent = _fx_BrainrotRNG

	local t2: {[any]: any} = {}

	for _, v in ipairs(clone:GetDescendants()) do
		if v:IsA("BasePart") then
			t2[v] = v.Size
			v.Size = Vector3.new(0, 0, 0)
		end
	end

	local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	for k, v in pairs(t2) do
		tweenService:Create(k, tweenInfo, { Size = v }):Play()
	end

	local torso = Character:FindFirstChild("Torso")

	sound:Play("KillEffects.BrainrotRNG." .. s1.Name, torso or humanoidRootPart)
	task.delay(5, function()
		if not clone or not clone.Parent then
			return
		end

		local tweenInfo2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

		for _, v in ipairs(clone:GetDescendants()) do
			if v:IsA("BasePart") then
				tweenService:Create(v, tweenInfo2, { Size = Vector3.new(0, 0, 0), Transparency = 1 }):Play()
			end
		end

		task.wait(0.5)

		if clone and clone.Parent then
			clone:Destroy()
		end
	end)
end
