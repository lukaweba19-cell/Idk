-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local LocalPlayer: Player = game:GetService("Players").LocalPlayer
local scriptParent: Instance = script.Parent

scriptParent.Anchored = true

local scriptParentCFrame = scriptParent.CFrame
local scriptParentCFramePosition = scriptParentCFrame.Position
local scriptParentCFrameRotation = scriptParentCFrame.Rotation

runService.RenderStepped:Connect(function()
	if not scriptParent.Parent then
		return
	end

	if LocalPlayer and LocalPlayer:GetAttribute("InMatch") then
		return
	end

	if workspace.CurrentCamera and (workspace.CurrentCamera.CFrame.Position - scriptParentCFramePosition).Magnitude > 300 then
		return
	end

	local v7 = os.clock()
	local cFrame = CFrame.new(scriptParentCFramePosition)
	local v9 = CFrame.Angles(0, v7 * 0.7853981633974483 % 6.283185307179586, 0)

	scriptParent.CFrame = cFrame * v9 * scriptParentCFrameRotation
end)
