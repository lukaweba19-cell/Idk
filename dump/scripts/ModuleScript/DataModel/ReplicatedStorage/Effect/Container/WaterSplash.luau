-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local bin: Instance = workspace:WaitForChild("Bin")
local CurrentCamera: Camera = workspace.CurrentCamera

return function(p1)
	local v4 = p1.CFrame or CFrame.new(p1.Position - Vector3.new(0, 0.5, 0))
	local v5 = p1.Scale or 1

	if (CurrentCamera.CFrame.p - v4.p).Magnitude > 1000 then
		return
	end

	local clone = script.WaterSplash:Clone()

	clone.CFrame = v4
	clone.Parent = bin
	clone.Submerge:Play()
	v4 = 0

	for _, v in pairs(clone:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v4 = math.max(v4, v.Lifetime.Max)
			v:Emit(v:GetAttribute("EmitCount"))
		end
	end

	task.delay(v4 + 0.1, function()
		clone:Destroy()
	end)
end
