-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
game:GetService("Players")

local catalogs: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Catalogs")
local clanCatalog = require(catalogs:WaitForChild("ClanCatalog"))
local t1: {[any]: any} = {}

for iterKey in pairs(clanCatalog.ROLES) do
	t1[iterKey] = clanCatalog.RoleSortIndex(iterKey)
end

local module: {[any]: any} = {
	ROLE_ORDER = t1,
	commas = function(p1)
		local floored = math.floor(p1)

		return (tostring(floored):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
	end,
	grabTemplates = function(p2)
		local v9 = nil
		local v10 = nil

		for _, v in ipairs(p2:GetChildren()) do
			if v:IsA("Frame") and v.Name == "PlayerCard_Template_Leader" then
				v9 = v9 or v
				v.Visible = false
			elseif v:IsA("Frame") and v.Name == "PlayerCard_Template" then
				v10 = v10 or v
				v.Visible = false
			end
		end

		return v9, v10
	end,
	clearClones = function(p3)
		for _, v in ipairs(p3:GetChildren()) do
			if v:IsA("Frame") and v.Name == "ClanMemberCard" then
				v:Destroy()
			end
		end
	end,
	applyAvatar = function(p4, p5)
		if p5 <= 0 then
			return
		end

		p4.Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=420&h=420"):format(p5)
	end,
	sortMembers = function(p6)
		table.sort(p6, function(p7, p8)
			local v30 = t1[p7.Role] or 2
			local v31 = t1[p8.Role] or 2

			if v30 ~= v31 then
				return v30 < v31
			end

			return (p7.Kills or 0) > (p8.Kills or 0)
		end)
	end
}

function module.fillCommon(p9, player)
	local username = p9:FindFirstChild("Username")

	if username and username:IsA("TextLabel") then
		username.Text = tostring(player.Name)
	end

	local role_Rank = p9:FindFirstChild("Role_Rank")

	if role_Rank and role_Rank:IsA("TextLabel") then
		role_Rank.Text = "Level " .. tostring(player.Level or 1)
	end

	local contributions = p9:FindFirstChild("Contributions")

	if contributions then
		local kills = contributions:FindFirstChild("Kills")

		if kills and kills:IsA("TextLabel") then
			kills.Text = "💀 Clan Kills: <b>" .. module.commas(player.Kills or 0) .. "</b>"
		end

		local streak = contributions:FindFirstChild("Streak")

		if streak and streak:IsA("TextLabel") then
			streak.Text = "🔥 Streak: <b>" .. tostring(player.Streak or 0) .. "</b>"
		end
	end

	local playerDisplay = p9:FindFirstChild("PlayerDisplay")

	if playerDisplay and playerDisplay:IsA("ImageLabel") then
		if typeof(player.UserId) == "number" then
			module.applyAvatar(playerDisplay, player.UserId)
		end

		local status = playerDisplay:FindFirstChild("Status")

		if status and status:IsA("GuiObject") then
			status.Visible = player.Online == true
		end
	end
end

return module
