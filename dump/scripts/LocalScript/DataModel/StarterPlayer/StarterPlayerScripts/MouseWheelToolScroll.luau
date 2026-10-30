-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local userInputService: UserInputService = game:GetService("UserInputService")
local LocalPlayer: Player = players.LocalPlayer
local n1 = 0
local t1: {[any]: any} = { "Knife", "Revolver" }

local function getCharacter()
	return LocalPlayer.Character
end
local function getHumanoid()
	local Character: Model = LocalPlayer.Character

	return Character and Character:FindFirstChildOfClass("Humanoid")
end
local function getEquippedToolName()
	local Character: Model = LocalPlayer.Character

	if not Character then
		return nil
	end

	for iterFirst, iterSecond in Character:GetChildren() do
		if iterSecond:IsA("Tool") then
			return iterSecond.Name
		end
	end

	return nil
end
local function findTool(p1)
	local Character: Model = LocalPlayer.Character
	local backpack: Instance = LocalPlayer:FindFirstChildOfClass("Backpack")

	if backpack then
		for iterFirst, iterSecond in backpack:GetChildren() do
			if iterSecond:IsA("Tool") and p1 == iterSecond.Name then
				return iterSecond
			end
		end
	end

	if Character then
		for iterFirst2, iterSecond2 in Character:GetChildren() do
			if iterSecond2:IsA("Tool") and p1 == iterSecond2.Name then
				return iterSecond2
			end
		end

		return nil
	end

	return nil
end
local function canUse()
	if workspace:GetAttribute("LoadingScreenCompleted") == true then
		if not LocalPlayer:GetAttribute("BackpackEnabled") then
		elseif LocalPlayer:GetAttribute("MatchId") and LocalPlayer:GetAttribute("MatchId") ~= "" then
			return true
		end

		return false
	end

	return false
end

userInputService.InputChanged:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	if gameProcessedEvent then
		return
	end

	if input.UserInputType ~= Enum.UserInputType.MouseWheel then
		return
	end

	local u24

	if workspace:GetAttribute("LoadingScreenCompleted") ~= true or not LocalPlayer:GetAttribute("BackpackEnabled") then
		u24 = false
	else
		local matchId: any = LocalPlayer:GetAttribute("MatchId")

		u24 = if matchId and matchId ~= "" then true else false
	end

	if not u24 then
		return
	end

	local v26 = os.clock()

	if v26 - n1 < 0.05 then
		return
	end

	n1 = v26

	local Character: Model = LocalPlayer.Character

	v26 = Character

	if v26 then
		v26 = Character:FindFirstChildOfClass("Humanoid")
	end

	if v26 and not (v26.Health <= 0) then
		local v28 = getEquippedToolName()
		local n3 = 0

		for key, value in t1 do
			if value == v28 then
				n3 = key

				break
			end
		end

		local n2 = n3 + (if input.Position.Z > 0 then -1 else 1)

		if n2 > #t1 then
			n2 = 1
		end

		if n2 < 1 then
			n2 = #t1
		end

		local v33 = findTool(t1[n2])

		if v33 and v28 ~= v33.Name then
			if not v26:IsDescendantOf(workspace) then
				warn("nice bug buddy, nice try")

				return
			end

			v26:EquipTool(v33)

			return
		end

		return
	end
end)
