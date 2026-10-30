-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)

local sound = require(game.ReplicatedStorage.Sound)
local tweenService: TweenService = game:GetService("TweenService")

require(game.ReplicatedStorage.Util.Misc)

local smooch = game.ReplicatedStorage.FX.KillEffects.Smooch
local smoochMesh = smooch.Mesh
local smoochSounds = smooch.Sounds

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
t1 = function(p4)
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
t1 = function(parent, animationId)
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
		local _fx_Smooch: Folder = Instance.new("Folder")

		_fx_Smooch.Name = "_FX_Smooch"
		_fx_Smooch.Parent = workspace.Bin
		Character.AncestryChanged:Once(function()
			if not Character:IsDescendantOf(game) then
				_fx_Smooch:Destroy()
			end
		end)
		debris:AddItem(_fx_Smooch, 7)

		local parent = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

		sound:Play("KillEffects.Smooch", parent)

		local clone = smooch.Mesh.Attachment:Clone()

		clone.Parent = parent
		misc.EmitAll(clone)
	end
end
