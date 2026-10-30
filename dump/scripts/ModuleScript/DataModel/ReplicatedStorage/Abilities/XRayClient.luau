-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local debris = require(replicatedStorage.Util.Debris)
local sound = require(replicatedStorage:WaitForChild("Sound"))
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local abilityVFXCleanup = require(shared:WaitForChild("AbilityVFXCleanup"))

return {
	Cast = function(player)
		if not player.Character then
			return
		end

		local LocalPlayer: Player = players.LocalPlayer

		LocalPlayer:SetAttribute("XRay", true)
		sound:Play("Abilities.XRay", workspace)
		task.spawn(function()
			local colorCorrectionEffect: ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

			colorCorrectionEffect.Parent = game.Lighting
			task.spawn(function()
				local Lighting = game.Lighting
				local tweenInfo = TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

				tweenService:Create(Lighting, tweenInfo, { ExposureCompensation = 1.7 }):Play()
				task.wait(0.06)

				local Lighting2 = game.Lighting
				local tweenInfo2 = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

				tweenService:Create(Lighting2, tweenInfo2, { ExposureCompensation = 0 }):Play()
			end)

			local screenGui: ScreenGui = Instance.new("ScreenGui")

			screenGui.IgnoreGuiInset = true
			screenGui.DisplayOrder = -99
			screenGui.Parent = game.Players.LocalPlayer.PlayerGui
			debris:AddItem(screenGui, 3)

			local imageLabel: ImageLabel = Instance.new("ImageLabel")

			imageLabel.Parent = screenGui
			imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
			imageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
			imageLabel.Size = UDim2.new(1, 0, 1, 0)
			imageLabel.BackgroundTransparency = 1
			imageLabel.Image = "rbxassetid://107167244054760"

			local tweenInfo = TweenInfo.new(0.425, Enum.EasingStyle.Back, Enum.EasingDirection.In)

			tweenService:Create(imageLabel, tweenInfo, { ImageTransparency = 1 }):Play()

			local tweenInfo3 = TweenInfo.new(0.125, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			local color3 = Color3.fromRGB(44, 44, 44)

			tweenService:Create(colorCorrectionEffect, tweenInfo3, { Brightness = 0, Contrast = 2, Saturation = -1, TintColor = color3 }):Play()
			abilityVFXCleanup.Track(player.UserId, "XRay", {
				duration = 0.85,
				onCleanup = function()
					task.spawn(function()
						local tweenInfo4 = TweenInfo.new(0.225, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						local color32 = Color3.fromRGB(255, 255, 255)

						tweenService:Create(colorCorrectionEffect, tweenInfo4, { Brightness = 0, Contrast = 0, Saturation = 0, TintColor = color32 }):Play()
						LocalPlayer:SetAttribute("XRay", nil)
						task.wait(0.125)
						colorCorrectionEffect:Destroy()
					end)
				end
			})
		end)
	end,
	ForceCleanup = function(p2)
		abilityVFXCleanup.Cleanup(p2, "XRay")
	end
}
