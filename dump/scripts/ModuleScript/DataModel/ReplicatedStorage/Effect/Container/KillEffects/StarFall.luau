-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)

local sound = require(game.ReplicatedStorage.Sound)
local tweenService: TweenService = game:GetService("TweenService")

require(game.ReplicatedStorage.Util.Misc)

local starFall = game.ReplicatedStorage.FX.KillEffects.StarFall
local starFallMesh = starFall.Mesh
local starFallSounds = starFall.Sounds
local rayCast = require(game.ReplicatedStorage.Util.RayCast)
local debris = require(game.ReplicatedStorage.Util.Debris)
local misc = require(game.ReplicatedStorage.Util.Misc)
local v9 = CFrame.Angles(0, 0, 0)
local t1 = {
	PositionSettleTime = 0.1,
	CancelRagdoll = true,
	AnimationId = "rbxassetid://100702658584314",
	VictimPositionOffset = CFrame.new(0, 0.5, 0),
	VictimRotation = v9
}

t1 = function(p1, p2, p3)
	return (tweenService:Create(p1, p2, p3))
end

local function hideCharacter(p4)
	for _, v in pairs(p4:GetDescendants()) do
		if v:IsA("BasePart") or v:IsA("MeshPart") then
			v.Transparency = 1
		elseif not v:IsA("Decal") and not v:IsA("Texture") then
			if v:IsA("ParticleEmitter") or v:IsA("Beam") or v:IsA("Trail") or v:IsA("Light") then
				v.Enabled = false
			elseif not v:IsA("BillboardGui") and not v:IsA("SurfaceGui") then
				if v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
					v.Enabled = false
				end
			else
				v.Enabled = false
			end
		else
			v.Transparency = 1
		end
	end
end

v9 = function(parent, animationId)
	if not parent then
		return nil
	end

	local animator = parent:FindFirstChildOfClass("Animator")

	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = parent
	end

	local animation: Animation = Instance.new("Animation")

	animation.AnimationId = animationId

	local animationTrack = animator:LoadAnimation(animation)

	animationTrack:Play()

	return animationTrack
end

return function(player)
	local Character = player.Character
	local p = workspace.CurrentCamera.CFrame.p
	local pivot = Character:GetPivot()

	if (p - pivot.Position).Magnitude < 1000 then
		local _fx_StarFall: Folder = Instance.new("Folder")

		_fx_StarFall.Name = "_FX_StarFall"
		_fx_StarFall.Parent = workspace.Bin
		Character.AncestryChanged:Once(function()
			if not Character:IsDescendantOf(game) then
				_fx_StarFall:Destroy()
			end
		end)
		debris:AddItem(_fx_StarFall, 7)

		local function createsfx(parent, p9)
			local clone = p9:Clone()

			clone.Parent = parent
			clone:Play()
			debris:AddItem(clone, 1)
		end

		local part: Part = Instance.new("Part")

		Character:FindFirstChild("HumanoidRootPart")

		local v30 = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

		if not v30 then
			return
		end

		v30.Anchored = true

		local cFrame = Character.Torso.CFrame

		part.CFrame = CFrame.new(cFrame.p) * CFrame.new(0, 0, 0)

		local clone = starFallMesh.Falling:Clone()

		for iterFirst, iterSecond in clone:GetDescendants() do
			if iterSecond:IsA("BasePart") then
				iterSecond.CollisionGroup = "Debris"
			end
		end

		local clonePrimaryPart = clone.PrimaryPart

		clonePrimaryPart.CFrame = part.CFrame * CFrame.new(0, 5000, 0)

		for _, v in pairs(clonePrimaryPart:GetDescendants()) do
			if v:IsA("Trail") then
				v.Enabled = false
			end
		end

		task.spawn(function()
			task.wait(0.05)

			local v42, v43, v44 = rayCast(part.Position, Vector3.new(-0, -20, -0))

			if v42 then
				local v45, v46, v47 = cFrame:ToEulerAnglesYXZ()
				local cFrame2 = CFrame.new(v43)
				local v49 = CFrame.Angles(0, v46, 0)
				local v50 = CFrame.Angles(0, -1.5707963267948966, 0)

				clonePrimaryPart.CFrame = cFrame2 * v49 * v50

				for _, v in pairs(clonePrimaryPart:GetDescendants()) do
					if v:IsA("Trail") then
						v.Enabled = true
					end
				end
			end
		end)

		local v38 = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

		sound:Play("KillEffects.StarFall", v38)
		clone.Parent = _fx_StarFall
		debris:AddItem(clone, 4)
		misc.EmitAll(clone)
		clone.AnimationController.Animator:LoadAnimation(starFall.Animation):Play()
		task.delay(2.075, function()
			if Character and Character.Parent then
				hideCharacter(Character)
			end
		end)

		return
	end
end
