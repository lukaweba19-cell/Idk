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
local function localScreenFX()
	task.spawn(function()
		local colorCorrectionEffect: ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

		colorCorrectionEffect.Parent = game.Lighting
		debris:AddItem(colorCorrectionEffect, 0.3)

		local tweenInfo = TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local color3 = Color3.fromRGB(89, 56, 255)

		tweenService:Create(colorCorrectionEffect, tweenInfo, {
			Brightness = -0.2,
			Saturation = -0.2,
			Contrast = 3,
			TintColor = color3
		}):Play()
		task.wait(0.05)

		local tweenInfo2 = TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local color32 = Color3.fromRGB(169, 169, 255)

		tweenService:Create(colorCorrectionEffect, tweenInfo2, { Brightness = 0.4, Saturation = 0, Contrast = 1, TintColor = color32 }):Play()
		task.wait(0.05)

		local tweenInfo3 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local color33 = Color3.fromRGB(255, 255, 255)

		tweenService:Create(colorCorrectionEffect, tweenInfo3, { Brightness = 0, Saturation = 0, Contrast = 0, TintColor = color33 }):Play()
	end)
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

		local tweenInfo4 = TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

		tweenService:Create(depthOfFieldEffect, tweenInfo4, {
			FarIntensity = 0,
			FocusDistance = 0,
			InFocusRadius = 0,
			NearIntensity = 0
		}):Play()
	end)

	if _G.Shared and _G.Shared.CamShaker then
		_G.Shared.CamShaker:Shake("Explosion")
	end
end

return function(p4)
	local isLocal = p4.IsLocal

	if p4.CameraOnly then
		if isLocal then
			localScreenFX()
		end

		return
	end

	local CFramePosition = p4.CFrame.Position

	if (CurrentCamera.CFrame.p - CFramePosition).magnitude > 1000 then
		return
	end

	local clone = game.ReplicatedStorage.FX.AbilityFX.Portal.PortalEmit.Attachment:Clone()

	clone.Position = CFramePosition
	clone.Parent = workspace.Terrain
	misc.EmitAll(clone)

	local cloneWorldPosition = clone.WorldPosition

	if isLocal then
		localScreenFX()
	end

	local clonePointLight = clone.PointLight
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

	tweenService:Create(clonePointLight, tweenInfo, { Brightness = 0 }):Play()
	task.delay(3, function()
		clone:Destroy()
	end)
	sound:Play("Abilities.PortalTP", clone)
end
