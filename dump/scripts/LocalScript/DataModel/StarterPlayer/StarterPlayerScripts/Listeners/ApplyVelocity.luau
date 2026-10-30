-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ApplyVelocity").OnClientEvent:Connect(function(p1, assemblyLinearVelocity, assemblyAngularVelocity)
	for _ = 1, 9 do
		if not p1 then
			break
		end

		p1.AssemblyLinearVelocity = assemblyLinearVelocity
		p1.AssemblyAngularVelocity = assemblyAngularVelocity
		game:GetService("RunService").Stepped:Wait()
	end
end)
