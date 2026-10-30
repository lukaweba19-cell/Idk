-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local shared: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local updateGate = require(shared:WaitForChild("UpdateGate"))
local module: {[any]: any} = { CANCEL_COOLDOWN_DURATION = 1, CHECKPOINT_MODE = "Rewind" }
local u4: boolean = module.CHECKPOINT_MODE ~= "Orb"

module.SLOT_KEY = { ["1"] = "Q", ["2"] = "E" }

local color3 = Color3.fromRGB(255, 70, 70)
local color32 = Color3.fromRGB(60, 155, 255)
local color33 = Color3.fromRGB(120, 255, 90)

module.TYPE_COLOR = { Knife = color3, Revolver = color32, Character = color33 }

local t2: {[any]: any} = {
	TripleKnife = {
		Id = "TripleKnife",
		DisplayName = "Triple Knife",
		Description = "Split your next throw into three knives.",
		Type = "Knife",
		Icon = "rbxassetid://91874319998014",
		Cooldown = 7.5,
		Cost = 0,
		SortOrder = 100,
		IsPending = true
	},
	ExplosiveKnife = {
		Id = "ExplosiveKnife",
		DisplayName = "Explosive Knife",
		Description = "Your next knife throw detonates, dealing splash damage.",
		Type = "Knife",
		Icon = "rbxassetid://87648798449959",
		Cooldown = 14.5,
		Cost = 1200,
		SortOrder = 101,
		IsPending = true,
		PendingExpiration = 4
	},
	SmokeKnife = {
		Id = "SmokeKnife",
		DisplayName = "Smoke Knife",
		Description = "Create a smoke burst at impact to block vision.",
		Type = "Knife",
		Icon = "rbxassetid://78586863181968",
		Cooldown = 10,
		Cost = 2400,
		SortOrder = 102,
		IsPending = true
	},
	Reflect = {
		Id = "Reflect",
		DisplayName = "Deflect",
		Description = "Parry shots with your knife. Successful deflects stun.",
		Type = "Knife",
		Icon = "rbxassetid://82181608265145",
		Cooldown = 11.5,
		Cost = 4800,
		SortOrder = 103
	},
	FlammableKnife = {
		Id = "FlammableKnife",
		DisplayName = "Molotov Knife",
		Description = "Ignite the surface hit by your knife for burn damage.",
		Type = "Knife",
		Icon = "rbxassetid://72246143137505",
		Cooldown = 14,
		Cost = 7200,
		SortOrder = 104,
		IsPending = true
	},
	PortalKnife = {
		Id = "PortalKnife",
		DisplayName = "Portal Knife",
		Description = "Open a short portal to reposition quickly.",
		Type = "Knife",
		Icon = "rbxassetid://139146824763830",
		Cooldown = 16,
		Cost = 24000,
		SortOrder = 105,
		IsPending = true
	},
	BarrageBullet = {
		Id = "BarrageBullet",
		DisplayName = "Bullet Barrage",
		Description = "Fire a burst of revolver shots with reduced accuracy and damage.",
		Type = "Revolver",
		Icon = "rbxassetid://102842372749343",
		Cooldown = 9,
		Cost = 0,
		SortOrder = 200,
		IsPending = true
	},
	RicochetBullet = {
		Id = "RicochetBullet",
		DisplayName = "Ricochet Bullet",
		Description = "Your next revolver shot bounces off enemies and walls.",
		Type = "Revolver",
		Icon = "rbxassetid://109832167947447",
		Cooldown = 11,
		Cost = 2400,
		SortOrder = 201,
		IsPending = true,
		PendingExpiration = 4,
		RoundStartLockout = 1.5
	},
	RapidReload = {
		Id = "RapidReload",
		DisplayName = "Rapid Reload",
		Description = "Resets your reload, allowing you to shoot again immediately.",
		Type = "Revolver",
		Icon = "rbxassetid://132795924935163",
		Cooldown = 20,
		Cost = 7200,
		SortOrder = 202
	},
	FrostRounds = {
		Id = "FrostRounds",
		DisplayName = "Frost Rounds",
		Description = "Load 3 icy rounds with reduced cooldown that slow enemies at the cost of damage.",
		Type = "Revolver",
		Icon = "rbxassetid://112593229436123",
		Cooldown = 15,
		Cost = 14400,
		SortOrder = 203,
		IsPending = true
	},
	SpeedBoost = {
		Id = "SpeedBoost",
		DisplayName = "Speed Boost",
		Description = "Burst forward with a speed surge.",
		Type = "Character",
		Icon = "rbxassetid://115210198739521",
		Cooldown = 14,
		Cost = 800,
		SortOrder = 300
	},
	SuperJump = {
		Id = "SuperJump",
		DisplayName = "Super Jump",
		Description = "Launch upward with a powerful jump.",
		Type = "Character",
		Icon = "rbxassetid://92766937179781",
		Cooldown = 11,
		Cost = 1600,
		SortOrder = 301
	},
	Decoy = {
		Id = "Decoy",
		DisplayName = "Decoy",
		Description = "Drop a decoy to bait enemies and confuse aim.",
		Type = "Character",
		Icon = "rbxassetid://119857931736978",
		Cooldown = 10,
		Cost = 3200,
		SortOrder = 302
	},
	XRay = {
		Id = "XRay",
		DisplayName = "X-Ray",
		Description = "Reveal nearby enemies through walls for a short time.",
		Type = "Character",
		Icon = "rbxassetid://115295974331946",
		Cooldown = 20,
		Cost = 6400,
		SortOrder = 303
	},
	Checkpoint = {
		Id = "Checkpoint",
		Type = "Character",
		Cooldown = 15,
		Cost = 9600,
		SortOrder = 305,
		UpdateKey = "Checkpoint",
		DisplayName = if u4 then "Rewind" else "Checkpoint",
		Description = if u4 then "Go back to where you were 3 seconds ago and recover the health you lost since." else "Plant a checkpoint. Press again inside its area to teleport back to it.",
		Icon = if u4 then "rbxassetid://126892040408257" else "rbxassetid://103134865997609",
		IsPending = if u4 then nil else true,
		Recastable = if u4 then nil else true,
		RoundStartLockout = if u4 then 3 else nil
	},
	Dash = {
		Id = "Dash",
		DisplayName = "Dash",
		Description = "Burst forward in a straight line.",
		Type = "Character",
		Icon = "rbxassetid://122249826826162",
		Cooldown = 14,
		Cost = 4800,
		SortOrder = 304,
		UpdateKey = "Dash",
		RoundStartLockout = 1.5
	}
}

function module.Get(p1)
	return t2[p1]
end
function module.Exists(p2)
	return t2[p2] ~= nil
end
function module.IsReleased(p3)
	local v12 = t2[p3]

	if not v12 then
		return false
	end

	if not v12.UpdateKey then
		return true
	end

	return updateGate.IsReleased(v12.UpdateKey)
end
function module.ShouldShowInShop(p4)
	local v14 = t2[p4]

	if not v14 then
		return false
	end

	if module.IsReleased(p4) then
		return true
	end

	return v14.ShowWhileGated == true
end
function module.GetAll()
	return t2
end
function module.GetAllList()
	local t3: {[any]: any} = {}

	for _, v in pairs(t2) do
		table.insert(t3, v)
	end

	table.sort(t3, function(p5, p6)
		local v20 = p5.SortOrder or 999999
		local v21 = p6.SortOrder or 999999

		if v20 ~= v21 then
			return v20 < v21
		end

		return p5.Id < p6.Id
	end)

	return t3
end

return module
