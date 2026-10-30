-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local runService: RunService = game:GetService("RunService")
local shared: Instance = replicatedStorage:WaitForChild("Shared")

if not require(shared:WaitForChild("TradingPlazaGate")).IsTradingPlaza() then
	return
end

local spin: Instance = workspace:WaitForChild("Lobby"):WaitForChild("Spin", 30)

if not spin or not spin:IsA("Model") then
	return
end

for _, v in ipairs(spin:GetDescendants()) do
	if v:IsA("BasePart") then
		v.Anchored = true
	end
end

local pivot = spin:GetPivot()
local pivotPosition = pivot.Position
local pivotRotation = pivot.Rotation

runService.RenderStepped:Connect(function()
	if not spin.Parent then
		return
	end

	local v10: number = workspace:GetServerTimeNow()
	local cFrame = CFrame.new(pivotPosition)
	local v12 = CFrame.Angles(0, v10 % 125.66370614359172 * 0.05, 0)

	spin:PivotTo(cFrame * v12 * pivotRotation)
end)
