-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")
local runService: RunService = game:GetService("RunService")
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local debris = require(replicatedStorage.Util.Debris)
local sound = require(replicatedStorage:WaitForChild("Sound"))
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local abilityVFXCleanup = require(shared:WaitForChild("AbilityVFXCleanup"))
local speedBoost = replicatedStorage.FX.AbilityFX.SpeedBoost

return {
	Cast = function(p1)
		task.spawn(function()
			local Character = p1.Character

			if not Character then
				return
			end

			local humanoid = Character:FindFirstChildOfClass("Humanoid")

			if not humanoid then
				return
			end

			local userId = p1.UserId

			if p1 == players.LocalPlayer then
				humanoid:SetAttribute("SpeedBoost", 14)
				task.delay(3, function()
					if humanoid.Parent then
						humanoid:SetAttribute("SpeedBoost", nil)
					end
				end)
			end

			sound:Play("Abilities.SpeedBoost", Character.PrimaryPart)
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

			local CurrentCamera: Camera = workspace.CurrentCamera
			local clone = speedBoost.SpeedLines:Clone()

			clone.Parent = workspace.Bin

			local connection = runService.RenderStepped:Connect(function()
				if clone and clone.Parent then
					clone.CFrame = CurrentCamera.CFrame * CFrame.new(0, 0, -3)
				end
			end)

			for _, v in pairs(clone:GetDescendants()) do
				if v:IsA("ParticleEmitter") then
					v.Enabled = true
				end
			end

			abilityVFXCleanup.Track(userId, "SpeedBoost", {
				duration = 3,
				onCleanup = function()
					connection:Disconnect()

					for _, v in pairs(clone:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							v.Enabled = false
						end
					end

					task.delay(0.5, function()
						if clone and clone.Parent then
							clone:Destroy()
						end
					end)
				end
			})
		end)
	end,
	ForceCleanup = function(p2)
		abilityVFXCleanup.Cleanup(p2, "SpeedBoost")
	end
}
