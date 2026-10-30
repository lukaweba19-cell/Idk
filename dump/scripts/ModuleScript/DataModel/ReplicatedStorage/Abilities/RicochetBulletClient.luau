-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local runService: RunService = game:GetService("RunService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

require(replicatedStorage:WaitForChild("Sound"))

local shared: Instance = replicatedStorage:WaitForChild("Shared")
local abilityVFXCleanup = require(shared:WaitForChild("AbilityVFXCleanup"))
local util: Instance = replicatedStorage:WaitForChild("Util")
local ricochetTrajectory = require(util:WaitForChild("RicochetTrajectory"))
local LocalPlayer: Player = players.LocalPlayer

local function getAimOriginAndDir(player)
	local CurrentCamera: Camera = workspace.CurrentCamera

	if not CurrentCamera then
		return nil, nil
	end

	local Character = player.Character

	if not Character then
		return nil, nil
	end

	if not Character:FindFirstChild("HumanoidRootPart") then
		return nil, nil
	end

	local CFramePosition = CurrentCamera.CFrame.Position
	local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local v15 = playerGui and playerGui:FindFirstChild("Cursor")

	v15 = CurrentCamera:ViewportPointToRay(CurrentCamera.ViewportSize.X / 2, if v15 then v15.AbsoluteSize.Y / 2 else CurrentCamera.ViewportSize.Y / 2)

	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.IgnoreWater = true
	raycastParams.FilterDescendantsInstances = { Character, workspace.Bin, workspace.Destructibles }

	local v17 = workspace:Raycast(v15.Origin, v15.Direction * 1000, raycastParams)
	local n1 = (v17 and v17.Position or v15.Origin + v15.Direction * 1000) - CFramePosition

	return CFramePosition, if n1.Magnitude < 0.001 then CurrentCamera.CFrame.LookVector else n1.Unit
end

return {
	BOUNCES = 10,
	SpectatorSafe = true,
	Cast = function(player)
		local abilityEffectClient = require(replicatedStorage:WaitForChild("AbilityEffectClient"))
		local v21 = nil

		if player == LocalPlayer then
			local v22 = replicatedStorage:WaitForChild("Catalogs")

			v22 = require(v22:WaitForChild("AbilityCatalog")).Get("RicochetBullet")
			v21 = abilityEffectClient.MakeEffectKey()
			abilityEffectClient.PredictGrant({
				id = "Ricochet",
				appliesTo = "bullet",
				usesLeft = 1,
				effectKey = v21,
				duration = v22 and v22.PendingExpiration,
				params = { bounces = 10 }
			})

			local v23 = player.Backpack:FindFirstChild("Revolver") or player.Character:FindFirstChild("Revolver")

			if v23 then
				local Character = player.Character

				if Character then
					Character = player.Character:FindFirstChildOfClass("Humanoid")
				end

				if Character then
					Character:EquipTool(v23)
				end
			end
		end

		task.spawn(function()
			if not player.Character then
				return
			end

			local v26 = ricochetTrajectory.CreateVisual(workspace.Bin, 11)
			local connection = nil

			connection = runService.RenderStepped:Connect(function()
				local u28: boolean = false

				if player == LocalPlayer then
					local v29 = abilityEffectClient.GetActiveFor("bullet", "Ricochet")

					u28 = v29 ~= nil and v29.usesLeft > 0
				else
					local attributeValue = player:GetAttribute("SERVER_RevolverEffects.Ricochet.ExpiresAt")

					if typeof(attributeValue) == "number" then
						local v31: number = workspace:GetServerTimeNow()

						u28 = attributeValue > v31
					end
				end

				if not u28 then
					if connection then
						connection:Disconnect()
						connection = nil
					end

					ricochetTrajectory.DestroyVisual(v26)

					return
				end

				local Character = player.Character

				if not Character or not Character:IsDescendantOf(game) then
					if connection then
						connection:Disconnect()
						connection = nil
					end

					ricochetTrajectory.DestroyVisual(v26)

					return
				end

				if Character:FindFirstChildOfClass("Humanoid") and not (Character:FindFirstChildOfClass("Humanoid").Health <= 0) then
					local v33, v34 = getAimOriginAndDir(player)

					if v33 and v34 then
						local v35 = ricochetTrajectory.ComputeTrajectory(v33, v34, 10, player)
						local v36 = ricochetTrajectory.GetMuzzlePosition(Character)

						ricochetTrajectory.UpdateVisual(v26, v35, v36)

						return
					end

					ricochetTrajectory.UpdateVisual(v26, {})

					return
				end

				if connection then
					connection:Disconnect()
					connection = nil
				end

				ricochetTrajectory.DestroyVisual(v26)
			end)
			abilityVFXCleanup.Track(player.UserId, "RicochetTrajectory", {
				duration = 300,
				onCleanup = function()
					if connection then
						connection:Disconnect()
						connection = nil
					end

					ricochetTrajectory.DestroyVisual(v26)
				end
			})
		end)

		return v21
	end,
	ForceCleanup = function(p3)
		abilityVFXCleanup.Cleanup(p3, "RicochetTrajectory")
	end
}
