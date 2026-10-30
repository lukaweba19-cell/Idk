-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")

game:GetService("RunService")

local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local debris = require(game.ReplicatedStorage.Util.Debris)
local sound = require(replicatedStorage:WaitForChild("Sound"))

return {
	Cast = function(p1)
		task.spawn(function()
			local Character = p1.Character

			if not Character then
				return
			end

			local humanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

			if not humanoidRootPart then
				return
			end

			if p1 == players.LocalPlayer then
				task.spawn(function()
					for _ = 1, 4 do
						humanoidRootPart.AssemblyLinearVelocity = Vector3.new(humanoidRootPart.AssemblyLinearVelocity.X, 80, humanoidRootPart.AssemblyLinearVelocity.Z)
						task.wait()
					end
				end)
			end

			sound:Play("Abilities.JumpBoost", Character.PrimaryPart)
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
		end)
	end
}
