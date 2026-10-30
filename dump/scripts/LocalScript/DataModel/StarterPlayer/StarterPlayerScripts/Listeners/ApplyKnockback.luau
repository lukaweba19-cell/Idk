-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local LocalPlayer: Player = game:GetService("Players").LocalPlayer

game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ApplyKnockback").OnClientEvent:Connect(function(p1)
	if typeof(p1) == "Vector3" then
		local Character: Model = LocalPlayer.Character

		if not Character then
			return
		end

		local movementController: Instance = Character:FindFirstChild("MovementController")
		local v5: Instance = movementController

		if v5 then
			v5 = movementController:FindFirstChild("Knockback")
		end

		if v5 and v5:IsA("BindableEvent") then
			v5:Fire(p1)
		end

		return
	end
end)
