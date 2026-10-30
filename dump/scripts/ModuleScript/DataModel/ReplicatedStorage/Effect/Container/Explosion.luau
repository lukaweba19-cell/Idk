-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local CurrentCamera: Camera = workspace.CurrentCamera
local workspaceBin = workspace.Bin
local sound = require(game.ReplicatedStorage.Sound)

require(game.ReplicatedStorage.Util.ScaleParticle)

local misc = require(game.ReplicatedStorage.Util.Misc)
local debris = require(game.ReplicatedStorage.Util.Debris)
local tweenService: TweenService = game:GetService("TweenService")

local function makeTween(p1, p2, p3)
	return (tweenService:Create(p1, p2, p3))
end

return function(p4)
	local v12 = p4.Position
	local v13 = p4.Color

	if (CurrentCamera.CFrame.p - v12).magnitude > 700 + (p4.Scale or 12.5) * 50 then
		return
	end

	local clone = script.Explode.Attachment:Clone()

	clone.Position = v12
	clone.Parent = workspace.Terrain
	misc.EmitAll(clone)

	local cloneWorldPosition = clone.WorldPosition
	local LocalPlayer = game.Players.LocalPlayer
	local CFramePosition = workspace.CurrentCamera.CFrame.Position

	if LocalPlayer.Character then
		CFramePosition = LocalPlayer.Character:GetPivot().Position
	end

	if (cloneWorldPosition - CFramePosition).Magnitude < 35 then
		task.spawn(function()
			local depthOfFieldEffect: DepthOfFieldEffect = Instance.new("DepthOfFieldEffect")

			depthOfFieldEffect.Parent = game.Lighting
			debris:AddItem(depthOfFieldEffect, 0.5)

			local tweenInfo = TweenInfo.new(0.025, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

			tweenService:Create(depthOfFieldEffect, tweenInfo, {
				FarIntensity = 1,
				FocusDistance = 1,
				InFocusRadius = 1,
				NearIntensity = 0
			}):Play()
			task.wait(0.025)

			local tweenInfo2 = TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

			tweenService:Create(depthOfFieldEffect, tweenInfo2, {
				FarIntensity = 0,
				FocusDistance = 0,
				InFocusRadius = 0,
				NearIntensity = 0
			}):Play()
		end)
		_G.Shared.CamShaker:Shake("Explosion")
	end

	local clonePointLight = clone.PointLight
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

	tweenService:Create(clonePointLight, tweenInfo, { Brightness = 0 }):Play()
	task.delay(3, function()
		clone:Destroy()
	end)
	sound:Play("Misc.Explosion", clone, nil)
end
