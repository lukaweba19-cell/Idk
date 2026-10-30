-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
game:GetService("Players")

local runService: RunService = game:GetService("RunService")
local replayAimSync: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ReplayAimSync")
local CurrentCamera: Camera = workspace.CurrentCamera
local n1 = 0
local n2 = math.huge
local n3 = math.huge

runService.RenderStepped:Connect(function()
	CurrentCamera = workspace.CurrentCamera

	if not CurrentCamera then
		return
	end

	local v7 = os.clock()

	if v7 - n1 < 0.016666666666666666 then
		return
	end

	local lookVector = CurrentCamera.CFrame.LookVector
	local v9 = math.clamp(lookVector.Y, -1, 1)
	local v10 = math.asin(v9)

	v9 = math.atan2(-lookVector.X, -lookVector.Z)

	if math.abs(v10 - n2) < 0.0015 and math.abs(v9 - n3) < 0.0015 then
		return
	end

	n1 = v7
	n2 = v10
	n3 = v9
	replayAimSync:FireServer(v10, v9)
end)
