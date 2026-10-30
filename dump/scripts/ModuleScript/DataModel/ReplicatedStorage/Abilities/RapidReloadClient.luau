-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
game:GetService("TweenService")
game:GetService("RunService")

local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local t1: {[any]: any} = {}
local CurrentCamera: Camera = workspace.CurrentCamera

require(replicatedStorage:WaitForChild("Sound"))

return {
	Cast = function(player)
		local Character = player.Character

		if not Character then
			return
		end

		if not Character:FindFirstChild("HumanoidRootPart") then
			return
		end

		task.spawn(function()
		end)

		local v6 = player.Backpack:FindFirstChild("Revolver") or Character:FindFirstChild("Revolver")

		if v6 and v6:GetAttribute("Reloading") then
			player.Character.Humanoid:EquipTool(v6)
			v6:SetAttribute("RapidReload", tick())

			return
		end

		return -1
	end
}
