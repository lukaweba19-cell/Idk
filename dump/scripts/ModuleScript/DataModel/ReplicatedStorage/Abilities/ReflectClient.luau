-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local anims = require(replicatedStorage:WaitForChild("Anims"))

require(replicatedStorage:WaitForChild("Sound"))

local shared: Instance = replicatedStorage:WaitForChild("Shared")
local abilityVFXCleanup = require(shared:WaitForChild("AbilityVFXCleanup"))
local effect = require(replicatedStorage:WaitForChild("Effect"))

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
			local u12: boolean = p1 == players.LocalPlayer
			local backpack = p1:FindFirstChild("Backpack")
			local v14 = Character:FindFirstChild("Knife") or backpack and backpack:FindFirstChild("Knife")

			if u12 then
				Character:SetAttribute("ClientReflecting", true)

				if v14 then
					humanoid:EquipTool(v14)
				end

				effect.new("Misc.ReflectActivate"):replicate({ Character = Character })
			end

			local humanoid2 = Character:FindFirstChildOfClass("Humanoid")
			local v16 = humanoid2

			if v16 then
				v16 = humanoid2:FindFirstChildOfClass("Animator")
			end

			if v16 then
				for _, v in ipairs(v16:GetPlayingAnimationTracks()) do
					if v.Name == "Equip" or v.Name:match("Stab") then
						v:Stop(0)
					end
				end
			end

			local knifeSkin = p1:GetAttribute("KnifeSkin")

			knifeSkin = string.format("Knives.%s.Parry", knifeSkin or "Default")

			local u20 = anims.Get(Character, knifeSkin)

			if not u20 then
				u20 = anims.Get(Character, "Knives.Default.Parry")
			end

			if u20 then
				u20.Priority = Enum.AnimationPriority.Action2
				u20:Play(0)
			end

			local u21: boolean = false
			local connection = nil

			if u12 then
				connection = v14.AncestryChanged:Connect(function(_)
					if u21 then
						return
					end

					u21 = true

					if u20 and u20.IsPlaying then
						u20:Stop(0)
					end

					Character:SetAttribute("ClientReflecting", nil)
					abilityVFXCleanup.Cleanup(userId, "Reflect")
					abilityVFXCleanup.Cleanup(userId, "ReflectActivateVFX")
				end)
			end

			abilityVFXCleanup.Track(userId, "Reflect", {
				duration = 1,
				onCleanup = function()
					if connection then
						connection:Disconnect()
						connection = nil
					end

					if u20 and u20.IsPlaying then
						u20:Stop(0.3)
					end

					if u12 then
						Character:SetAttribute("ClientReflecting", nil)
					end

					abilityVFXCleanup.Cleanup(userId, "ReflectActivateVFX")
				end
			})
		end)
	end,
	ForceCleanup = function(p3)
		abilityVFXCleanup.Cleanup(p3, "Reflect")
	end
}
