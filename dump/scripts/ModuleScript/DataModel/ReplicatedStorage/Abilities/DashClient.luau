-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local runService: RunService = game:GetService("RunService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local sound = require(replicatedStorage:WaitForChild("Sound"))
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local abilityVFXCleanup = require(shared:WaitForChild("AbilityVFXCleanup"))
local module: {[any]: any} = {
	PARAMS = { distance = 33, duration = 0.3 }
}

local function playVFX(player)
	local Character = player.Character

	if not Character then
		return
	end

	local humanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart then
		local v12 = sound:Find("Abilities.Dash")

		sound:Play(if v12 then "Abilities.Dash" else "Abilities.SpeedBoost", humanoidRootPart)
	end

	local abilityFX = replicatedStorage.FX.AbilityFX
	local dash = abilityFX:FindFirstChild("Dash")
	local v15 = dash and dash:FindFirstChild("SpeedLines")

	if not v15 then
		local speedBoost = abilityFX:FindFirstChild("SpeedBoost")

		v15 = speedBoost and speedBoost:FindFirstChild("SpeedLines")
	end

	local bin: Instance = workspace:FindFirstChild("Bin")

	if v15 and bin then
		local CurrentCamera: Camera = workspace.CurrentCamera
		local clone = v15:Clone()

		clone.Parent = bin

		for iterFirst, iterSecond in clone:GetDescendants() do
			if iterSecond:IsA("ParticleEmitter") then
				local roundedUp = math.ceil(iterSecond.Rate * 0.1)

				iterSecond:Emit(roundedUp)
			end
		end

		local connection = runService.RenderStepped:Connect(function()
			if clone.Parent then
				clone.CFrame = CurrentCamera.CFrame * CFrame.new(0, 0, -3)
			end
		end)

		abilityVFXCleanup.Track(player.UserId, "Dash", {
			duration = module.PARAMS.duration + 0.1,
			onCleanup = function()
				connection:Disconnect()
				task.delay(0.5, function()
					if clone.Parent then
						clone:Destroy()
					end
				end)
			end
		})

		return
	end
end
function module.Cast(player)
	local Character = player.Character

	if not Character then
		return -1
	end

	if player ~= players.LocalPlayer then
		task.spawn(playVFX, player)

		return nil
	end

	local humanoid = Character:FindFirstChildOfClass("Humanoid")
	local movementController = Character:FindFirstChild("MovementController")
	local v28 = movementController

	if v28 then
		v28 = movementController:FindFirstChild("Dash")
	end

	if not humanoid or humanoid.Health <= 0 or not v28 or not v28:IsA("BindableEvent") then
		return -1
	end

	local params = module.PARAMS

	v28:Fire(params.distance / params.duration, params.duration)
	task.spawn(playVFX, player)

	return nil
end
function module.ForceCleanup(p3)
	abilityVFXCleanup.Cleanup(p3, "Dash")
end

return module
