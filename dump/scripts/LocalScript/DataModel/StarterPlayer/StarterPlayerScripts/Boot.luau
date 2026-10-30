-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local userInputService: UserInputService = game:GetService("UserInputService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("GuiService")
_G.Shared = {}
task.spawn(function()
	if not userInputService.TouchEnabled then
		return
	end

	local extensions: Instance = replicatedStorage:WaitForChild("Extensions")

	require(extensions:WaitForChild("MobileTouchController")):init()
end)

local v3 = replicatedStorage:WaitForChild("Util")

v3 = require(v3:WaitForChild("CameraShaker")).new(Enum.RenderPriority.Camera.Value + 1, function(p1)
	local CurrentCamera: Camera = workspace.CurrentCamera

	CurrentCamera.CFrame = CurrentCamera.CFrame * p1
end)
v3:Start()
_G.Shared.CamShaker = v3

local util: Instance = replicatedStorage:WaitForChild("Util")

require(util:WaitForChild("Debris"))

local replicatedStorageUtil: Instance = replicatedStorage:WaitForChild("Util")

require(replicatedStorageUtil:WaitForChild("EncodeObj"))

local t1: {[any]: any} = { Cmdr = true, CmdrClient = true }

for _, v in pairs(replicatedStorage:GetChildren()) do
	if v:IsA("ModuleScript") and not t1[v.Name] then
		require(v)
	end
end

for _, v in pairs(replicatedStorage.Util:GetChildren()) do
	if v:IsA("ModuleScript") then
		require(v)
	end
end

for _, v in pairs(replicatedStorage.Shared:GetChildren()) do
	if v:IsA("ModuleScript") then
		require(v)
	end
end

for _, v in pairs(replicatedStorage.Extensions:GetChildren()) do
	if v:IsA("ModuleScript") then
		require(v)
	end
end

require(replicatedStorage.Util.ForgeVFX).init()
