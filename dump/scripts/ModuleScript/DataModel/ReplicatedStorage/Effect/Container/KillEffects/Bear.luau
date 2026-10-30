-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)

local sound = require(game.ReplicatedStorage.Sound)
local tweenService: TweenService = game:GetService("TweenService")
local misc = require(game.ReplicatedStorage.Util.Misc)
local bearAttack = game.ReplicatedStorage.FX.KillEffects.BearAttack
local bearAttackMesh = bearAttack.Mesh
local bearAttackSounds = bearAttack.Sounds
local debris = require(game.ReplicatedStorage.Util.Debris)
local v8 = CFrame.Angles(0, 0, 0)

local function makeTween(p1, p2, p3)
	return (tweenService:Create(p1, p2, p3))
end
local function playAnimation(parent, animationId)
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

local t1: {[any]: any} = {
	AnimationId = "rbxassetid://83140521244057",
	VictimPositionOffset = CFrame.new(0, 0.5, 0),
	VictimRotation = v8
}

return function(player)
	local Character = player.Character
	local p = workspace.CurrentCamera.CFrame.p
	local pivot = Character:GetPivot()

	if (p - pivot.Position).Magnitude < 1000 then
		local _fx_Bear: Folder = Instance.new("Folder")

		_fx_Bear.Name = "_FX_Bear"
		_fx_Bear.Parent = workspace.Bin
		Character.AncestryChanged:Once(function()
			if not Character:IsDescendantOf(game) then
				_fx_Bear:Destroy()
			end
		end)
		debris:AddItem(_fx_Bear, 7)

		local humanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
		local torso = Character:FindFirstChild("Torso")
		local clone = bearAttackMesh.bEAR:Clone()
		local clonePrimaryPart = clone.PrimaryPart

		clonePrimaryPart.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 2.51, 6.834)
		clonePrimaryPart.Anchored = true
		clonePrimaryPart.CanCollide = false
		clone.Parent = _fx_Bear
		debris:AddItem(clone, 6)
		clone.AnimationController:LoadAnimation(bearAttack.Animation):Play()
		sound:Play("KillEffects.Bear", clonePrimaryPart, nil, nil, nil, nil)
		task.spawn(function()
			task.wait(2.5)
			sound:Play("Abilities.Extinguish", clonePrimaryPart, nil, nil, nil, nil)
			misc.EmitAll(clonePrimaryPart)

			local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.In)

			tweenService:Create(clonePrimaryPart, tweenInfo, { Transparency = 1, Size = Vector3.new(0, 0, 0) }):Play()
		end)

		if torso then
			local t2: {[any]: any} = {}

			for _, v in pairs(Character:GetDescendants()) do
				if v:IsA("Motor6D") and v.Enabled == false then
					v.Enabled = true
					table.insert(t2, v)
				end
			end

			local v32 = playAnimation(Character.Humanoid, t1.AnimationId)

			task.delay(1.163, function()
				for _, v in pairs(t2) do
					v.Enabled = false
				end

				if v32 and v32.IsPlaying then
					v32:Stop(0)
				end
			end)
		end
	end
end
