-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer: Player = players.LocalPlayer
local openShop: Instance = replicatedStorage:WaitForChild("Bindables"):WaitForChild("OpenShop")
local shopOpenAnalytics: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("ShopOpenAnalytics")

local v6 = (function()
	local v10 = os.clock()

	while true do
		local v11 = os.clock()

		if not (v10 + 30 > v11) then
			break
		end

		local lobby: Instance = workspace:FindFirstChild("Lobby")
		local v13: Instance = lobby and lobby:FindFirstChild("OGKnifePodium") or workspace:FindFirstChild("OGKnifePodium")

		if v13 and v13:IsA("Model") then
			return v13
		end

		task.wait(0.25)
	end

	return nil
end)()

if not v6 then
	warn("[OGKnifePodiumController] OGKnifePodium not found in Workspace or Workspace.Lobby")

	return
end

local parent = (function(p1)
	local promptPart = p1:FindFirstChild("PromptPart")

	if promptPart and promptPart:IsA("BasePart") then
		return promptPart
	end

	for _, v in ipairs(p1:GetDescendants()) do
		if v:IsA("BasePart") and v:FindFirstChildOfClass("BillboardGui") then
			return v
		end
	end

	return p1.PrimaryPart or p1:FindFirstChildWhichIsA("BasePart", true)
end)(v6)

if not parent then
	local v8 = v6:GetFullName()

	warn("[OGKnifePodiumController] no BasePart on " .. v8 .. " to anchor the prompt on")

	return
end

local ogKnifePrompt: ProximityPrompt = Instance.new("ProximityPrompt")

ogKnifePrompt.Name = "OGKnifePrompt"
ogKnifePrompt.ActionText = "Redeem"
ogKnifePrompt.ObjectText = "OG Knife"
ogKnifePrompt.KeyboardKeyCode = Enum.KeyCode.E
ogKnifePrompt.HoldDuration = 0
ogKnifePrompt.MaxActivationDistance = 10
ogKnifePrompt.RequiresLineOfSight = false
ogKnifePrompt.Exclusivity = Enum.ProximityPromptExclusivity.AlwaysShow
ogKnifePrompt.Parent = parent
ogKnifePrompt.Triggered:Connect(function(playerWhoTriggered: Player)
	if playerWhoTriggered ~= LocalPlayer then
		return
	end

	if LocalPlayer:GetAttribute("RedeemedCode_100MOG") == true then
		if _G.Notify then
			_G.Notify({
				notifType = "FailNotification",
				errorMessage = "You've already claimed the OG Knife!"
			})
		end

		return
	end

	openShop:Fire("Codes")
	shopOpenAnalytics:FireServer("OGKnifePodium")
end)
