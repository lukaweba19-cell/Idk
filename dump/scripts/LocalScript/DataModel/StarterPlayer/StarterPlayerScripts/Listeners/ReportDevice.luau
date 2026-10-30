-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local userInputService: UserInputService = game:GetService("UserInputService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

local function getDevice()
	if userInputService.TouchEnabled and not userInputService.KeyboardEnabled then
		return "mobile"
	end

	if userInputService.GamepadEnabled and not userInputService.KeyboardEnabled then
		return "console"
	end

	return "pc"
end

local s1: string = if userInputService.TouchEnabled and not userInputService.KeyboardEnabled then "mobile" else if userInputService.GamepadEnabled and not userInputService.KeyboardEnabled then "console" else "pc"

replicatedStorage:WaitForChild("ReportDevice"):FireServer(s1)
getDevice = { mobile = "Mobile", console = "Console", pc = "PC" }
replicatedStorage:WaitForChild("MatchmakingShared"):WaitForChild("Remotes"):WaitForChild("ReportPlatform"):FireServer(getDevice[s1])

local extensions: Instance = replicatedStorage:WaitForChild("Extensions")
local inputCategorizer = require(extensions:WaitForChild("InputCategorizer"))
local inputCohortSync: Instance = replicatedStorage:WaitForChild("InputCohortSync")
local u8 = nil
local n1: number = 0

getDevice = function(p1)
	if p1 == u8 then
		return
	end

	u8 = p1
	inputCohortSync:FireServer(p1)
end

local v10 = inputCategorizer.getLastInputCategory()

if v10 ~= u8 then
	u8 = v10
	inputCohortSync:FireServer(v10)
end

inputCategorizer.lastInputCategoryChanged:Connect(function(p2)
	n1 += 1

	local v13: number = n1

	task.delay(1, function()
		if v13 ~= n1 then
			return
		end

		if inputCategorizer.getLastInputCategory() ~= p2 then
			return
		end

		local v14 = p2

		if v14 == u8 then
			return
		end

		u8 = v14
		inputCohortSync:FireServer(v14)
	end)
end)
