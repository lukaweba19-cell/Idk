-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local CurrentCamera: Camera = workspace.CurrentCamera

game:GetService("TweenService")

local sound = require(game.ReplicatedStorage.Sound)

require(game.ReplicatedStorage.Util.Misc)

return function(p1)
	local positions = p1.Positions

	if positions and #positions ~= 0 then
		for _, v in ipairs(positions) do
			if not ((CurrentCamera.CFrame.Position - v).Magnitude > 500) then
				local extinguishFX: Part = Instance.new("Part")

				extinguishFX.Name = "ExtinguishFX"
				extinguishFX.Size = Vector3.new(2, 2, 2)
				extinguishFX.Position = v + Vector3.new(0, 1, 0)
				extinguishFX.Anchored = true
				extinguishFX.CanCollide = false
				extinguishFX.CanQuery = false
				extinguishFX.Transparency = 1
				extinguishFX.Parent = workspace.Bin

				local clone = game.ReplicatedStorage.FX.AbilityFX.Flammable.Extinguish.Extinguish1:Clone()
				local clone2 = game.ReplicatedStorage.FX.AbilityFX.Flammable.Extinguish.Extinguish1:Clone()

				clone.Parent = extinguishFX
				clone2.Parent = extinguishFX
				clone:Emit(12)
				clone2:Emit(12)
				sound:Play("Abilities.Extinguish", extinguishFX)
				task.delay(2, function()
					if extinguishFX.Parent then
						extinguishFX:Destroy()
					end
				end)
			end
		end

		return
	end
end
