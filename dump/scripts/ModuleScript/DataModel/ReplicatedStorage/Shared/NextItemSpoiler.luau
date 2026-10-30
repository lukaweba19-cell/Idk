-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer: Player = players.LocalPlayer
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local rarity = require(shared:WaitForChild("Rarity"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local traitText = require(replicatedStorageShared:WaitForChild("TraitText"))

local module: {[any]: any} = {
	IsRestricted = function()
		return LocalPlayer:GetAttribute("ArePaidRandomItemsRestricted") == true
	end
}

function module.OnRestrictedChanged(p1)
	p1(module.IsRestricted())

	local connection = LocalPlayer:GetAttributeChangedSignal("ArePaidRandomItemsRestricted"):Connect(function()
		p1(module.IsRestricted())
	end)

	return function()
		connection:Disconnect()
	end
end
local function render(p2, p3)
	if not p3 then
		p2.Visible = false

		return
	end

	local itemName = p2:FindFirstChild("ItemName")

	if itemName and itemName:IsA("TextLabel") then
		local v16 = p3.Name

		if p3.Suffix and p3.Suffix ~= "" then
			v16 = v16 .. " " .. p3.Suffix
		end

		traitText.Bind(itemName, v16)

		if p3.Rarity then
			itemName.TextColor3 = rarity.GetColor(p3.Rarity)
			rarity.ApplyTextGradient(itemName, p3.Rarity)
		end
	end

	p2.Visible = true
end
function module.Bind(p4, p5)
	p4.Visible = false

	local u19: boolean = false
	local u20: boolean = false

	local t2: {[any]: any} = {
		Refresh = function(_)
			if u19 then
				return
			end

			if not module.IsRestricted() then
				p4.Visible = false

				return
			end

			if u20 then
				return
			end

			u20 = true
			task.spawn(function()
				local ok, result = pcall(p5)

				u20 = false

				if u19 then
					return
				end

				if not module.IsRestricted() then
					p4.Visible = false

					return
				end

				if ok and typeof(result) == "table" then
					render(p4, result)

					return
				end

				p4.Visible = false
			end)
		end
	}

	local connection = LocalPlayer:GetAttributeChangedSignal("ArePaidRandomItemsRestricted"):Connect(function()
		if not module.IsRestricted() then
			p4.Visible = false

			return
		end

		t2:Refresh()
	end)

	function t2.Destroy(_)
		u19 = true
		connection:Disconnect()
		p4.Visible = false
	end

	return t2
end

local remotes: Instance = replicatedStorage:WaitForChild("Remotes")

function module.PeekCrate(p8)
	if not module.IsRestricted() then
		return nil
	end

	local peekNextCrateRoll: Instance = remotes:FindFirstChild("PeekNextCrateRoll")

	if not peekNextCrateRoll then
		return nil
	end

	local ok, result = pcall(function()
		return peekNextCrateRoll:InvokeServer({ CrateId = p8 })
	end)

	if ok and typeof(result) == "table" and result.Ok == true then
		return result.Result
	end

	return nil
end

return module
