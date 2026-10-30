-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")

game:GetService("GuiService")

if workspace.StreamingEnabled then
	task.spawn(function()
		local LocalPlayer = game.Players.LocalPlayer

		if not LocalPlayer then
			return
		end

		while not _G.PersistentLoaded do
			runService.RenderStepped:Wait()

			local Character = LocalPlayer.Character
			local humanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

			if humanoidRootPart then
				humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				warn("applied velocity fix")
			end
		end
	end)
end

workspace.PersistentLoaded:Connect(function()
	_G.PersistentLoaded = true
end)
