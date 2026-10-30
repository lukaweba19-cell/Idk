-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local humanoidRootPart: Instance = script.Parent:WaitForChild("HumanoidRootPart")

if workspace:GetAttribute("__FloorLoaded") then
	return
end

humanoidRootPart.Anchored = true
workspace:WaitForChild("Lobby"):WaitForChild("BaseFloor")
humanoidRootPart.Anchored = false
workspace:SetAttribute("__FloorLoaded", true)
