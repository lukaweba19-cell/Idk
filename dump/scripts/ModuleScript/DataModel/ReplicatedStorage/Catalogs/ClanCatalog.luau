-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {
	MIN_LEVEL = 20,
	CREATE_COST = 5000,
	BASE_MEMBER_CAP = 10,
	MAX_MEMBER_CAP = 30,
	UPGRADE_MEMBER_STEP = 5,
	UPGRADE_COSTS = { [10] = 25000, [15] = 50000, [20] = 75000, [25] = 100000 },
	UPGRADE_COST_FALLBACK = 100000
}

function module.GetUpgradeCost(p1)
	return module.UPGRADE_COSTS[p1] or module.UPGRADE_COST_FALLBACK
end

module.MAX_PENDING_REQUESTS = 50
module.NAME_MIN_LENGTH = 3
module.NAME_MAX_LENGTH = 20
module.TAG_MIN_LENGTH = 2
module.TAG_MAX_LENGTH = 4
module.TAG_FORCE_UPPERCASE = true
module.BANNED_CHARS = { "|", ";" }
module.ROLES = {
	Owner = { Rank = 3, Label = "Leader", Emoji = "👑" },
	Officer = { Rank = 2, Label = "Co-Leader", Emoji = "🏅" },
	Member = { Rank = 1, Label = "Member", Emoji = "✊" }
}
module.OWNER_ROLE = "Owner"
module.DEFAULT_ROLE = "Member"
module.OWNER_LEAVE_DISBANDS = true
module.PERMISSIONS = {
	AcceptRequest = { "Owner", "Officer" },
	Invite = { "Owner", "Officer" },
	RejectRequest = { "Owner", "Officer" },
	KickMember = { "Owner", "Officer" },
	KickOfficer = { "Owner" },
	Promote = { "Owner" },
	Demote = { "Owner" },
	EditImage = { "Owner" },
	Upgrade = { "Owner" },
	Disband = { "Owner" }
}
module.LEADERBOARD = {
	TopN = 100,
	Stats = { "Kills", "Streak" },
	Windows = { "AllTime", "Weekly" }
}
module.COMMAND_COOLDOWN = 0.5

function module.IsValidRole(p2)
	return module.ROLES[p2] ~= nil
end
function module.GetRoleLabel(p3)
	local v5 = module.ROLES[p3]

	return v5 and v5.Label or p3
end
function module.RoleRank(p4)
	local v7 = module.ROLES[p4]

	return v7 and v7.Rank or 0
end
function module.GetRoleDisplay(p5)
	local v9 = module.ROLES[p5]

	if not v9 then
		return p5
	end

	if v9.Emoji == "" then
		return v9.Label
	end

	return v9.Emoji .. " " .. v9.Label
end
function module.RoleSortIndex(p6)
	return -module.RoleRank(p6)
end
function module.CanRole(p7, p8)
	local v13 = module.PERMISSIONS[p7]

	if not v13 then
		return false
	end

	for _, v in ipairs(v13) do
		if v == p8 then
			return true
		end
	end

	return false
end
function module.DisplayTag(p9, p10)
	if p10 == nil or p10 == "" then
		return p9
	end

	return p10
end

module.DEFAULT_IMAGE = "rbxassetid://111221790313594"

function module.NormalizeImageId(p11)
	if typeof(p11) == "number" then
		local floored = math.floor(p11)

		return (tostring(floored))
	end

	if typeof(p11) == "string" then
		for _, v in ipairs({
			"rbxassetid://(%d+)",
			"[?&][Aa]sset[Ii][dD]=(%d+)",
			"[?&][Ii][dD]=(%d+)",
			"/asset/(%d+)",
			"/catalog/(%d+)",
			"/library/(%d+)",
			"^%s*(%d+)%s*$"
		}) do
			local v22 = string.match(p11, v)

			if v22 then
				return v22
			end
		end

		return ""
	end

	return ""
end

module.THUMB_SIZE = 420

function module.ThumbFor(p12)
	return "rbxthumb://type=Asset&id=" .. p12 .. "&w=" .. module.THUMB_SIZE .. "&h=" .. module.THUMB_SIZE
end
function module.ResolveImage(p13)
	local v25 = module.NormalizeImageId(p13)

	if v25 == "" then
		return module.DEFAULT_IMAGE
	end

	return module.ThumbFor(v25)
end

return module
