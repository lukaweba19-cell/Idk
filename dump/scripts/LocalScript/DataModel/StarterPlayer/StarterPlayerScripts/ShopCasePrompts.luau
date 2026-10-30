-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local collectionService: CollectionService = game:GetService("CollectionService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer: Player = players.LocalPlayer
local openShop: Instance = replicatedStorage:WaitForChild("Bindables"):WaitForChild("OpenShop")
local shopOpenAnalytics: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("ShopOpenAnalytics")
local t1: {[any]: any} = {}

local function setupCase(p1)
	if not p1:IsA("Model") then
		return
	end

	if t1[p1] then
		return
	end

	local promptPart = p1:WaitForChild("PromptPart", 60)

	if not promptPart or not promptPart:IsA("BasePart") then
		return
	end

	local v13 = p1.Name
	local proximityPrompt: ProximityPrompt = Instance.new("ProximityPrompt")

	proximityPrompt.ObjectText = ""
	proximityPrompt.ActionText = "View"
	proximityPrompt.HoldDuration = 0
	proximityPrompt.MaxActivationDistance = 5
	proximityPrompt.RequiresLineOfSight = false
	proximityPrompt.Exclusivity = Enum.ProximityPromptExclusivity.AlwaysShow
	proximityPrompt.Parent = promptPart
	proximityPrompt.Triggered:Connect(function(playerWhoTriggered: Player)
		if playerWhoTriggered ~= LocalPlayer then
			return
		end

		openShop:Fire("Cases", v13)
		shopOpenAnalytics:FireServer("ProximityCase", v13)
	end)
	t1[p1] = proximityPrompt
end

for iterFirst, iterSecond in collectionService:GetTagged("ShopCase") do
	task.spawn(setupCase, iterSecond)
end

collectionService:GetInstanceAddedSignal("ShopCase"):Connect(setupCase)
collectionService:GetInstanceRemovedSignal("ShopCase"):Connect(function(p3)
	local v16 = t1[p3]

	if v16 then
		v16:Destroy()
		t1[p3] = nil
	end
end)
