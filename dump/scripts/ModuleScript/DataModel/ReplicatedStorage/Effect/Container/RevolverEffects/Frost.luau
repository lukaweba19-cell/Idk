-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local LocalPlayer: Player = game:GetService("Players").LocalPlayer

require(game.ReplicatedStorage.Effect)

local sound = require(game.ReplicatedStorage.Sound)
local tweenService: TweenService = game:GetService("TweenService")

require(game.ReplicatedStorage.Util.Misc)
require(game.ReplicatedStorage.Util.Debris)

local stopSoundOnToolEquip = require(game.ReplicatedStorage.Util.StopSoundOnToolEquip)
local highlightPools = require(game.ReplicatedStorage.Util.HighlightPools)
local viewedPlayer = require(game.ReplicatedStorage.Shared.ViewedPlayer)

return function(p1)
	local model = p1.Model
	local revolver = p1.Revolver
	local toggle = p1.Toggle
	local v11 = viewedPlayer.IsViewed(model and model.Parent)

	if not toggle then
		if v11 then
			playerGui = LocalPlayer
			playerGui = playerGui:FindFirstChildOfClass("PlayerGui")

			local overlay = playerGui and playerGui:FindFirstChild("Overlay")

			playerGui = overlay

			if playerGui then
				playerGui = overlay:FindFirstChild("IceShotUser")
			end

			if playerGui then
				local v13 = playerGui
				local tweenInfo = TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

				tweenService:Create(v13, tweenInfo, { ImageTransparency = 1 }):Play()
			end
		end

		playerGui = pcall
		playerGui(function()
			revolver.Parent:FindFirstChild("RevolverMuzzle", true):FindFirstChild("FROSTVFX"):Destroy()
		end)
		playerGui = pcall
		playerGui(function()
			local destroying = p1.Root and p1.Root:FindFirstChild("FrostLight")

			if destroying then
				destroying.Name = "DESTROYING"

				local tweenInfo = TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

				tweenService:Create(destroying, tweenInfo, { Brightness = 0 }):Play()
				task.delay(0.32, function()
					destroying:Destroy()
				end)
			end
		end)
		playerGui = pcall
		playerGui(function()
			local __FrostGunHL = model and model:FindFirstChild("__FrostGunHL")

			if __FrostGunHL and __FrostGunHL.Value then
				highlightPools.Effect:releaseIfGeneration(__FrostGunHL.Value, __FrostGunHL:GetAttribute("PoolGeneration"))
				__FrostGunHL:Destroy()
			end
		end)

		if v11 then
			playerGui = LocalPlayer
			playerGui:SetAttribute("FrostGunActive", nil)
		end
	elseif (workspace.CurrentCamera.CFrame.p - revolver.Position).Magnitude < 1000 then
		local playerGui = nil

		if v11 then
			local frostGunHighlight = game.ReplicatedStorage.FX.AbilityFX.FrostRounds:FindFirstChild("FrostGunHighlight")
			local value = model and frostGunHighlight and highlightPools.Effect:acquire(model, {
				FillTransparency = 0.25,
				DepthMode = Enum.HighlightDepthMode.Occluded,
				OutlineTransparency = frostGunHighlight.OutlineTransparency,
				FillColor = frostGunHighlight.FillColor,
				OutlineColor = frostGunHighlight.OutlineColor
			})

			if value then
				playerGui = Instance.new("ObjectValue")
				playerGui.Name = "__FrostGunHL"
				playerGui.Value = value
				playerGui:SetAttribute("PoolGeneration", highlightPools.Effect:generationOf(value))
				playerGui.Parent = model
			end

			LocalPlayer:SetAttribute("FrostGunActive", true)
		end

		if v11 then
			local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")
			local playerGuiOverlay: Instance = playerGui and playerGui:FindFirstChild("Overlay")
			local v19: Instance = playerGuiOverlay

			if v19 then
				v19 = playerGuiOverlay:FindFirstChild("IceShotUser")
			end

			if v19 then
				local tweenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

				tweenService:Create(v19, tweenInfo, { ImageTransparency = 0.3 }):Play()
			end
		end

		local clone = game.ReplicatedStorage.FX.AbilityFX.FrostRounds.IceMuzzle:Clone()

		clone:SetAttribute("FromAbilityCast", true)
		clone.Name = "FROSTVFX"
		clone.Parent = revolver.Parent:FindFirstChild("RevolverMuzzle", true)

		if clone:IsDescendantOf(workspace) then
			local v22 = sound:Play("Abilities.IceShotLoop", revolver)
			local v23 = sound:Play("Abilities.IceShotActivate", revolver)

			stopSoundOnToolEquip.Bind(v22, p1.Root and p1.Root.Parent, "Revolver")
			stopSoundOnToolEquip.Bind(v23, p1.Root and p1.Root.Parent, "Revolver")

			if p1.Root then
				local clone2 = game.ReplicatedStorage.FX.AbilityFX.FrostRounds.FrostLight:Clone()

				clone2.Brightness = 0
				clone2.Parent = p1.Root

				local tweenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

				tweenService:Create(clone2, tweenInfo, { Brightness = 1 }):Play()
			end

			clone.AncestryChanged:Once(function()
				if playerGui then
					highlightPools.Effect:releaseIfGeneration(playerGui.Value, playerGui:GetAttribute("PoolGeneration"))
				end

				local playerGui2 = game.Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
				local overlay = playerGui2 and playerGui2:FindFirstChild("Overlay")

				if overlay then
					overlay:FindFirstChild("IceShotUser")
				end

				if v11 then
					local iceShotUser = game.Players.LocalPlayer.PlayerGui.Overlay.IceShotUser
					local tweenInfo = TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

					tweenService:Create(iceShotUser, tweenInfo, { ImageTransparency = 1 }):Play()
					LocalPlayer:SetAttribute("FrostGunActive", nil)
				end

				v22:FadeOut(0.05)
				v23:FadeOut(0.05)
			end)
		end

		return
	end
end
