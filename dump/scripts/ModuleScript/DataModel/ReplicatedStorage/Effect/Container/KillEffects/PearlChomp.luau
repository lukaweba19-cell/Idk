-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)

local sound = require(game.ReplicatedStorage.Sound)
local tweenService: TweenService = game:GetService("TweenService")

require(game.ReplicatedStorage.Util.Misc)

local mermaid = game.ReplicatedStorage.FX.KillEffects.Mermaid
local mermaidMesh = mermaid.Mesh
local mermaidSounds = mermaid.Sounds

require(game.ReplicatedStorage.Util.RayCast)

local debris = require(game.ReplicatedStorage.Util.Debris)
local misc = require(game.ReplicatedStorage.Util.Misc)
local v8 = CFrame.Angles(0, 0, 0)
local t1 = {
	PositionSettleTime = 0.1,
	CancelRagdoll = true,
	AnimationId = "rbxassetid://100702658584314",
	VictimPositionOffset = CFrame.new(0, 0.5, 0),
	VictimRotation = v8
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

v8 = function(parent, animationId)
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
		local _fx_Mermaid: Folder = Instance.new("Folder")

		_fx_Mermaid.Name = "_FX_Mermaid"
		_fx_Mermaid.Parent = workspace.Bin

		if Character and Character.Parent then
			hideCharacter(Character)
		end

		Character.AncestryChanged:Once(function()
			if not Character:IsDescendantOf(game) then
				_fx_Mermaid:Destroy()
			end
		end)
		debris:AddItem(_fx_Mermaid, 7)

		local part: Part = Instance.new("Part")

		Character:FindFirstChild("HumanoidRootPart")

		local v28 = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

		if not v28 then
			return
		end

		v28.Anchored = true

		local cFrame = Character.Torso.CFrame

		part.CFrame = CFrame.new(cFrame.p, cFrame.p - cFrame.LookVector * Vector3.new(1, 0, 1))

		local clone = mermaidMesh.Clam:Clone()

		for iterFirst, iterSecond in clone:GetDescendants() do
			if iterSecond:IsA("BasePart") then
				iterSecond.CollisionGroup = "Debris"
			end
		end

		local clonePrimaryPart = clone.PrimaryPart

		clonePrimaryPart.CFrame = part.CFrame * CFrame.new(0, 5000, 0)
		task.delay(0.033, function()
			local partCFrame: CFrame = part.CFrame
			local v39 = CFrame.Angles(0, 3.141592653589793, 0)

			clonePrimaryPart.CFrame = partCFrame * v39
		end)
		task.delay(0.033, function()
			misc.EmitAll(clone.ball_low.IMPACTBAMP)
		end)
		task.delay(0.533, function()
			misc.EmitAll(clone.Root.Water)
		end)
		task.delay(1.767, function()
			misc.EmitAll(clone.Root.shut)
		end)
		task.delay(2.533, function()
			misc.EmitAll(clone.up_low)
		end)

		for _, v in pairs(clonePrimaryPart:GetDescendants()) do
			if v:IsA("Trail") then
				v.Enabled = false
			end
		end

		local v36 = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

		sound:Play("KillEffects.Mermaid", v36)
		clone.Parent = _fx_Mermaid
		debris:AddItem(clone, 4)
		misc.EmitAll(clone)

		local animationTrack = clone.AnimationController.Animator:LoadAnimation(mermaid.Animation)

		if animationTrack.Length > 0.1 then
			task.delay(animationTrack.Length - 0.05, function()
				clone:Destroy()
			end)
		end

		animationTrack:Play()

		return
	end
end
