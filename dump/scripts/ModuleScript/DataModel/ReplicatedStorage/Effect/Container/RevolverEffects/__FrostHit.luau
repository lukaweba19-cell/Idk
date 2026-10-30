-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("TweenService")
require(replicatedStorage:WaitForChild("Sound"))

local util: Instance = replicatedStorage:WaitForChild("Util")

require(util:WaitForChild("Debris"))

local replicatedStorageUtil: Instance = replicatedStorage:WaitForChild("Util")

require(replicatedStorageUtil:WaitForChild("Misc"))

local shared: Instance = replicatedStorage:WaitForChild("Shared")
local viewedPlayer = require(shared:WaitForChild("ViewedPlayer"))
local LocalPlayer: Player = players.LocalPlayer

return function(player)
	local Character = player.Character

	if Character and typeof(Character) == "Instance" then
		if not Character:FindFirstChild("HumanoidRootPart") then
			return
		end

		local numberValue = tonumber(player.Stacks) or 1
		local numberValue2: number? = tonumber(player.AttackerUserId)

		viewedPlayer.IsViewed(Character)

		if viewedPlayer.IsViewedUserId(numberValue2 or 0) then
		end

		return
	end
end
