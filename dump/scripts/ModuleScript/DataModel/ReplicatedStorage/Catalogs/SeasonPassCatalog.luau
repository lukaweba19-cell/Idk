-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local function nothing()
	return {
		Type = "Nothing",
		Display = { Name = "", Icon = "" }
	}
end
local function cash(p1)
	local formattedText = string.format("%d Coins", p1)

	return {
		Type = "Cash",
		Tile = "Rare",
		Amount = p1,
		Display = { Icon = "rbxassetid://98610346948622", Name = formattedText }
	}
end
local function crate(p2, p3, p4)
	return { Type = "Crate", Id = p2, Amount = p3 or 1, Tile = p4 or "Rare" }
end
local function hallowsCase()
	return { Type = "Crate", Id = "HallowsCase", Amount = 1, Tile = "Legendary" }
end
local function recruitCase()
	return { Type = "Crate", Id = "RecruitCase", Amount = 1, Tile = "Rare" }
end
local function spaceCase()
	return { Type = "Crate", Id = "SpaceCase", Amount = 1, Tile = "Rare" }
end

local shared: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local wheelTicketProducts = require(shared:WaitForChild("WheelTicketProducts"))

local function tickets(p5)
	return {
		Type = "WheelTickets",
		Tile = "Rare",
		Amount = p5,
		Display = {
			Name = if p5 == 1 then "1 Ticket" else p5 .. " Tickets",
			Icon = wheelTicketProducts.IconFor(p5)
		}
	}
end
local function finisher()
	return {
		Type = "Finisher",
		Tile = "Rare",
		Display = { Name = "Finisher", Icon = "rbxassetid://107738609773613" }
	}
end
local function tiled(p6, tile)
	p6.Tile = tile

	return p6
end

tiled = function(p8)
	return { Type = "Finisher", Id = p8 }
end

local function knife(p9)
	return { Type = "Knife", Id = p9 }
end
local function revolver(p10)
	return { Type = "Revolver", Id = p10 }
end
local function emote(p11)
	return { Type = "Emote", Id = p11 }
end
local function choice(p12, p13)
	return {
		Type = "Choice",
		Options = p12,
		Display = {
			Name = "Grand Prize",
			Icon = "rbxassetid://85072009579489",
			Rarity = "Secret"
		},
		Challenge = p13
	}
end

local v16 = cash(100)
local v17 = cash(350)
local v18 = cash(400)
local v19 = cash(500)
local v20 = cash(250)
local v21 = cash(350)
local v22 = cash(450)
local v23 = cash(600)
local v24 = cash(350)
local v25 = cash(400)
local v26 = tickets(1)
local v27 = cash(250)
local v28 = tickets(3)
local v29 = tickets(5)

local v30 = (function()
	return {
		Type = "Choice",
		Options = {
			{ Type = "Knife", Id = "RedScythe" },
			{ Type = "Knife", Id = "PinkScythe" }
		},
		Display = {
			Name = "Grand Prize",
			Icon = "rbxassetid://85072009579489",
			Rarity = "Secret"
		},
		Challenge = { Kind = "Kills", Goal = 500 }
	}
end)()

local module: {[any]: any} = {
	Seasons = {
		S1 = {
			Name = "Season 1",
			Free = {
				v16,
				{ Type = "Knife", Id = "Watermelon" },
				{ Type = "Crate", Id = "RecruitCase", Amount = 1, Tile = "Rare" },
				{ Type = "Revolver", Id = "Seaside" },
				v17,
				{ Type = "Crate", Id = "RecruitCase", Amount = 1, Tile = "Rare" },
				v18,
				{ Type = "Knife", Id = "Pineapple" },
				{
					Type = "Finisher",
					Tile = "Rare",
					Display = { Name = "Finisher", Icon = "rbxassetid://107738609773613" }
				},
				v19,
				{ Type = "Finisher", Id = "WaterBalloons" },
				{ Type = "Revolver", Id = "Turtle" },
				{
					Type = "Finisher",
					Tile = "Rare",
					Display = { Name = "Finisher", Icon = "rbxassetid://107738609773613" }
				},
				{ Type = "Knife", Id = "Popsicle" },
				{ Type = "Revolver", Id = "UltraSoaker" }
			},
			Premium = {
				{ Type = "Revolver", Id = "Triton" },
				{ Type = "Crate", Id = "SpaceCase", Amount = 1, Tile = "Rare" },
				v20,
				{ Type = "Crate", Id = "RecruitCase", Amount = 1, Tile = "Rare" },
				{ Type = "Finisher", Id = "EpicDuck" },
				v21,
				{ Type = "Crate", Id = "SpaceCase", Amount = 1, Tile = "Rare" },
				{ Type = "Knife", Id = "Banana" },
				v22,
				{
					Type = "Finisher",
					Tile = "Rare",
					Display = { Name = "Finisher", Icon = "rbxassetid://107738609773613" }
				},
				{ Type = "Finisher", Id = "WaterSpout" },
				{ Type = "Knife", Id = "Lotus" },
				{ Type = "Crate", Id = "SpaceCase", Amount = 1, Tile = "Rare" },
				v23,
				{ Type = "Knife", Id = "Poseidon" }
			}
		},
		S2 = {
			Name = "Season 2",
			Free = {
				{
					Type = "Nothing",
					Display = { Name = "", Icon = "" }
				},
				{ Type = "Knife", Id = "Cobweb" },
				{ Type = "Crate", Id = "RecruitCase", Amount = 1, Tile = "Rare" },
				{ Type = "Revolver", Id = "Unblinking" },
				v24,
				{ Type = "Crate", Id = "RecruitCase", Amount = 1, Tile = "Rare" },
				v25,
				{ Type = "Knife", Id = "Snake" },
				{ Type = "Finisher", Id = "Zombify" },
				{
					Type = "Finisher",
					Tile = "Rare",
					Display = { Name = "Finisher", Icon = "rbxassetid://107738609773613" }
				},
				{ Type = "Revolver", Id = "Snake" },
				{ Type = "Emote", Id = "MonsterMash" },
				{ Type = "Knife", Id = "Clown" },
				v26,
				{ Type = "Knife", Id = "KitchenKnife" },
				{ Type = "Revolver", Id = "PumpkinLauncher" }
			},
			Premium = {
				{ Type = "Revolver", Id = "SpiritGun" },
				{ Type = "Crate", Id = "HallowsCase", Amount = 1, Tile = "Legendary" },
				v27,
				{ Type = "Emote", Id = "Breakbeat" },
				{
					Type = "Finisher",
					Tile = "Rare",
					Display = { Name = "Finisher", Icon = "rbxassetid://107738609773613" }
				},
				{ Type = "Knife", Id = "PumpkinBucket" },
				{ Type = "Crate", Id = "HallowsCase", Amount = 1, Tile = "Legendary" },
				v28,
				{ Type = "Finisher", Id = "BatBurst" },
				{ Type = "Emote", Id = "WitchesBrew" },
				{ Type = "Knife", Id = "BaseballBat" },
				{ Type = "Crate", Id = "HallowsCase", Amount = 1, Tile = "Legendary" },
				v29,
				{ Type = "Revolver", Id = "Clown" },
				{ Type = "Knife", Id = "DevilTrident" },
				v30
			}
		}
	}
}

function module.Exists(p14)
	return module.Seasons[p14] ~= nil
end
function module.Get(p15)
	return module.Seasons[p15]
end
function module.GetReward(p16, p17, p18)
	local v54 = module.Seasons[p16]

	if not v54 then
		return nil
	end

	local v55 = if p17 == "Free" then v54.Free else if p17 == "Premium" then v54.Premium else nil

	if not v55 then
		return nil
	end

	return v55[p18]
end

local httpService: HttpService = game:GetService("HttpService")
local u33 = nil
local u34 = nil

emote = function(p19)
	local ok, result = pcall(function()
		return httpService:JSONDecode(p19.Value)
	end)

	u33 = if ok and type(result) == "table" then result else nil
end
revolver = function(p20)
	if p20 == u34 then
		return
	end

	u34 = p20

	local ok, result = pcall(function()
		return httpService:JSONDecode(p20.Value)
	end)

	u33 = if ok and type(result) == "table" then result else nil
	p20:GetPropertyChangedSignal("Value"):Connect(function()
		local v72 = p20

		local ok2, result2 = pcall(function()
			return httpService:JSONDecode(v72.Value)
		end)

		u33 = if ok2 and type(result2) == "table" then result2 else nil
	end)
end

function module.AwaitDisplay(p21)
	if u33 then
		return true
	end

	local v63: Instance = script:FindFirstChild("Projection") or script:WaitForChild("Projection", p21 or 15)

	if v63 and v63:IsA("StringValue") and v63 ~= u34 then
		u34 = v63

		local ok, result = pcall(function()
			return httpService:JSONDecode(v63.Value)
		end)

		u33 = if ok and type(result) == "table" then result else nil
		v63:GetPropertyChangedSignal("Value"):Connect(function()
			local v75: Instance = v63

			local ok3, result3 = pcall(function()
				return httpService:JSONDecode(v75.Value)
			end)

			u33 = if ok3 and type(result3) == "table" then result3 else nil
		end)
	end

	return u33 ~= nil
end
function module.GetDisplay(p22)
	if p22.Display then
		return p22.Display
	end

	local v67 = p22.Id
	local v68 = if v67 and u33 then u33[p22.Type .. ":" .. v67] else nil

	if v68 then
		local v69 = v68.Name
		local v70 = p22.Amount or 1

		if p22.Type == "Crate" and v70 > 1 then
			local text: string = tostring(v70)

			v69 = v69 .. " x" .. text
		end

		return { Name = v69, Icon = v68.Icon, Rarity = v68.Rarity }
	end

	return { Icon = "", Rarity = nil, Name = v67 or "?" }
end

return module
