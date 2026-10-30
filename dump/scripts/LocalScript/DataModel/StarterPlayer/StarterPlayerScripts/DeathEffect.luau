-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local sound = require(replicatedStorage:WaitForChild("Sound"))
local LocalPlayer: Player = players.LocalPlayer

local function WastedCCE()
	task.spawn(function()
		local colorCorrectionEffect: ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

		colorCorrectionEffect.Parent = game.Lighting

		local tweenInfo = TweenInfo.new(0.025, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local color3 = Color3.fromRGB(255, 79, 79)

		tweenService:Create(colorCorrectionEffect, tweenInfo, { Brightness = 0.7, Saturation = 0, Contrast = 0, TintColor = color3 }):Play()
		task.wait(0.025)

		local tweenInfo2 = TweenInfo.new(0.025, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
		local color32 = Color3.fromRGB(255, 21, 21)

		tweenService:Create(colorCorrectionEffect, tweenInfo2, {
			Brightness = 0,
			Saturation = -0.2,
			Contrast = 0.4,
			TintColor = color32
		}):Play()
		task.wait(0.025)

		local tweenInfo3 = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
		local color33 = Color3.fromRGB(255, 255, 255)

		tweenService:Create(colorCorrectionEffect, tweenInfo3, {
			Brightness = -0.1,
			Saturation = -0.3,
			Contrast = 0.6,
			TintColor = color33
		}):Play()
		task.wait(1.9500000000000002)

		local tweenInfo4 = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
		local color34 = Color3.fromRGB(255, 255, 255)

		tweenService:Create(colorCorrectionEffect, tweenInfo4, { Brightness = 0, Saturation = 0, Contrast = 0, TintColor = color34 }):Play()
		task.wait(0.5)
		colorCorrectionEffect:Destroy()
	end)
end
local function WastedDOF()
	task.spawn(function()
		local depthOfFieldEffect: DepthOfFieldEffect = Instance.new("DepthOfFieldEffect")

		depthOfFieldEffect.Parent = game.Lighting

		local tweenInfo = TweenInfo.new(0.025, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

		tweenService:Create(depthOfFieldEffect, tweenInfo, {
			FarIntensity = 1,
			FocusDistance = 1,
			InFocusRadius = 1,
			NearIntensity = 0
		}):Play()
		task.wait(0.025)

		local tweenInfo5 = TweenInfo.new(0.025, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

		tweenService:Create(depthOfFieldEffect, tweenInfo5, {
			FarIntensity = 0,
			FocusDistance = 1,
			InFocusRadius = 1,
			NearIntensity = 1
		}):Play()
		task.wait(0.025)

		local tweenInfo6 = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

		tweenService:Create(depthOfFieldEffect, tweenInfo6, {
			FarIntensity = 0,
			FocusDistance = 1,
			InFocusRadius = 1,
			NearIntensity = 0
		}):Play()
		task.wait(1.9500000000000002)

		local tweenInfo7 = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

		tweenService:Create(depthOfFieldEffect, tweenInfo7, {
			FarIntensity = 0,
			FocusDistance = 0,
			InFocusRadius = 0,
			NearIntensity = 0
		}):Play()
		task.wait(0.5)
		depthOfFieldEffect:Destroy()
	end)
end

if LocalPlayer.Character then
	LocalPlayer.Character:WaitForChild("Humanoid").Died:Connect(function()
		if not LocalPlayer:GetAttribute("InMatch") then
			return
		end

		task.spawn(function()
			local colorCorrectionEffect: ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

			colorCorrectionEffect.Parent = game.Lighting

			local tweenInfo = TweenInfo.new(0.025, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			local color3 = Color3.fromRGB(255, 79, 79)

			tweenService:Create(colorCorrectionEffect, tweenInfo, { Brightness = 0.7, Saturation = 0, Contrast = 0, TintColor = color3 }):Play()
			task.wait(0.025)

			local tweenInfo8 = TweenInfo.new(0.025, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
			local color35 = Color3.fromRGB(255, 21, 21)

			tweenService:Create(colorCorrectionEffect, tweenInfo8, {
				Brightness = 0,
				Saturation = -0.2,
				Contrast = 0.4,
				TintColor = color35
			}):Play()
			task.wait(0.025)

			local tweenInfo9 = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
			local color36 = Color3.fromRGB(255, 255, 255)

			tweenService:Create(colorCorrectionEffect, tweenInfo9, {
				Brightness = -0.1,
				Saturation = -0.3,
				Contrast = 0.6,
				TintColor = color36
			}):Play()
			task.wait(1.9500000000000002)

			local tweenInfo10 = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
			local color37 = Color3.fromRGB(255, 255, 255)

			tweenService:Create(colorCorrectionEffect, tweenInfo10, { Brightness = 0, Saturation = 0, Contrast = 0, TintColor = color37 }):Play()
			task.wait(0.5)
			colorCorrectionEffect:Destroy()
		end)
		task.spawn(function()
			local depthOfFieldEffect: DepthOfFieldEffect = Instance.new("DepthOfFieldEffect")

			depthOfFieldEffect.Parent = game.Lighting

			local tweenInfo = TweenInfo.new(0.025, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

			tweenService:Create(depthOfFieldEffect, tweenInfo, {
				FarIntensity = 1,
				FocusDistance = 1,
				InFocusRadius = 1,
				NearIntensity = 0
			}):Play()
			task.wait(0.025)

			local tweenInfo11 = TweenInfo.new(0.025, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

			tweenService:Create(depthOfFieldEffect, tweenInfo11, {
				FarIntensity = 0,
				FocusDistance = 1,
				InFocusRadius = 1,
				NearIntensity = 1
			}):Play()
			task.wait(0.025)

			local tweenInfo12 = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

			tweenService:Create(depthOfFieldEffect, tweenInfo12, {
				FarIntensity = 0,
				FocusDistance = 1,
				InFocusRadius = 1,
				NearIntensity = 0
			}):Play()
			task.wait(1.9500000000000002)

			local tweenInfo13 = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

			tweenService:Create(depthOfFieldEffect, tweenInfo13, {
				FarIntensity = 0,
				FocusDistance = 0,
				InFocusRadius = 0,
				NearIntensity = 0
			}):Play()
			task.wait(0.5)
			depthOfFieldEffect:Destroy()
		end)
		sound:Play("Misc.Death", workspace)
	end)
end

LocalPlayer.CharacterAdded:Connect(function(character: Model)
	character:WaitForChild("Humanoid").Died:Connect(function()
		if not LocalPlayer:GetAttribute("InMatch") then
			return
		end

		task.spawn(function()
			local colorCorrectionEffect: ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

			colorCorrectionEffect.Parent = game.Lighting

			local tweenInfo = TweenInfo.new(0.025, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			local color3 = Color3.fromRGB(255, 79, 79)

			tweenService:Create(colorCorrectionEffect, tweenInfo, { Brightness = 0.7, Saturation = 0, Contrast = 0, TintColor = color3 }):Play()
			task.wait(0.025)

			local tweenInfo8 = TweenInfo.new(0.025, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
			local color35 = Color3.fromRGB(255, 21, 21)

			tweenService:Create(colorCorrectionEffect, tweenInfo8, {
				Brightness = 0,
				Saturation = -0.2,
				Contrast = 0.4,
				TintColor = color35
			}):Play()
			task.wait(0.025)

			local tweenInfo9 = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
			local color36 = Color3.fromRGB(255, 255, 255)

			tweenService:Create(colorCorrectionEffect, tweenInfo9, {
				Brightness = -0.1,
				Saturation = -0.3,
				Contrast = 0.6,
				TintColor = color36
			}):Play()
			task.wait(1.9500000000000002)

			local tweenInfo10 = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
			local color37 = Color3.fromRGB(255, 255, 255)

			tweenService:Create(colorCorrectionEffect, tweenInfo10, { Brightness = 0, Saturation = 0, Contrast = 0, TintColor = color37 }):Play()
			task.wait(0.5)
			colorCorrectionEffect:Destroy()
		end)
		task.spawn(function()
			local depthOfFieldEffect: DepthOfFieldEffect = Instance.new("DepthOfFieldEffect")

			depthOfFieldEffect.Parent = game.Lighting

			local tweenInfo = TweenInfo.new(0.025, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

			tweenService:Create(depthOfFieldEffect, tweenInfo, {
				FarIntensity = 1,
				FocusDistance = 1,
				InFocusRadius = 1,
				NearIntensity = 0
			}):Play()
			task.wait(0.025)

			local tweenInfo11 = TweenInfo.new(0.025, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

			tweenService:Create(depthOfFieldEffect, tweenInfo11, {
				FarIntensity = 0,
				FocusDistance = 1,
				InFocusRadius = 1,
				NearIntensity = 1
			}):Play()
			task.wait(0.025)

			local tweenInfo12 = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

			tweenService:Create(depthOfFieldEffect, tweenInfo12, {
				FarIntensity = 0,
				FocusDistance = 1,
				InFocusRadius = 1,
				NearIntensity = 0
			}):Play()
			task.wait(1.9500000000000002)

			local tweenInfo13 = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

			tweenService:Create(depthOfFieldEffect, tweenInfo13, {
				FarIntensity = 0,
				FocusDistance = 0,
				InFocusRadius = 0,
				NearIntensity = 0
			}):Play()
			task.wait(0.5)
			depthOfFieldEffect:Destroy()
		end)
		sound:Play("Misc.Death", workspace)
	end)
end)
