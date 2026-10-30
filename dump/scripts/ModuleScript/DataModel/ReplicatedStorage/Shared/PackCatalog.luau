-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local color3 = Color3.fromRGB(255, 20, 20)
local color32 = Color3.fromRGB(0, 175, 255)
local color33 = Color3.fromRGB(20, 255, 100)
local t1: {[any]: any} = {
	{
		Key = "Red",
		DisplayName = "Alpha",
		Glyph = "α",
		Orb = "rbxassetid://101936996991375",
		Knife = "RedEnergyBlade",
		KnifeName = "Alpha Energy Blade",
		Gun = "RedEnergyBlaster",
		GunName = "Alpha Energy Blaster",
		Finisher = "EnergyOverchargeRed",
		FinisherName = "Alpha Energy Overcharge",
		Art = {
			Knife = "rbxassetid://107314489273924",
			Gun = "rbxassetid://106649051731783",
			Finisher = "rbxassetid://77724984613037"
		},
		Swatch = color3
	},
	{
		Key = "Blue",
		DisplayName = "Beta",
		Glyph = "β",
		Orb = "rbxassetid://125557227870473",
		Knife = "BlueEnergyBlade",
		KnifeName = "Beta Energy Blade",
		Gun = "BlueEnergyBlaster",
		GunName = "Beta Energy Blaster",
		Finisher = "EnergyOverchargeBlue",
		FinisherName = "Beta Energy Overcharge",
		Art = {
			Knife = "rbxassetid://96191889430279",
			Gun = "rbxassetid://91693707122064",
			Finisher = "rbxassetid://124163660589867"
		},
		Swatch = color32
	},
	{
		Key = "Green",
		DisplayName = "Gamma",
		Glyph = "γ",
		Orb = "rbxassetid://82805978494946",
		Knife = "GreenEnergyBlade",
		KnifeName = "Gamma Energy Blade",
		Gun = "GreenEnergyBlaster",
		GunName = "Gamma Energy Blaster",
		Finisher = "EnergyOverchargeGreen",
		FinisherName = "Gamma Energy Overcharge",
		Art = {
			Knife = "rbxassetid://78625883985119",
			Gun = "rbxassetid://87278722181497",
			Finisher = "rbxassetid://88604866619541"
		},
		Swatch = color33
	}
}

local function energyColors(p1)
	local t3: {[any]: any} = {}

	for _, v in ipairs(p1) do
		t3[v] = true
	end

	local t4: {[any]: any} = {}

	for _, v in ipairs(t1) do
		local function art(p2)
			return v.Art and v.Art[p2] or nil
		end

		local t5: {[any]: any} = {}
		local t6: {[any]: any} = {}

		if t3.Knife then
			table.insert(t5, { Kind = "Knife", ItemId = v.Knife })
			table.insert(t6, {
				Kind = "Knife",
				Rarity = "Legendary",
				Label = "KNIFE",
				ItemId = v.Knife,
				Name = v.KnifeName,
				Icon = v.Art and v.Art.Knife or nil
			})
		end

		if t3.Revolver then
			table.insert(t5, { Kind = "Revolver", ItemId = v.Gun })
			table.insert(t6, {
				Kind = "Revolver",
				Rarity = "Legendary",
				Label = "GUN",
				ItemId = v.Gun,
				Name = v.GunName,
				Icon = v.Art and v.Art.Gun or nil
			})
		end

		if t3.Finisher then
			table.insert(t5, { Kind = "Finisher", Finisher = v.Finisher })
			table.insert(t6, {
				Kind = "Finisher",
				Rarity = "Legendary",
				Label = "FINISHER",
				ItemId = v.Finisher,
				Name = v.FinisherName,
				Icon = v.Art and v.Art.Finisher or nil
			})
		end

		table.insert(t4, {
			Key = v.Key,
			DisplayName = v.DisplayName,
			Glyph = v.Glyph,
			Orb = v.Orb,
			Art = v.Art,
			Swatch = v.Swatch,
			Rewards = t5,
			PreviewItems = t6
		})
	end

	return t4
end
local function energyPack(p3, p4, p5, p6)
	local v27 = energyColors(p6)

	return {
		ColorGroup = "Energy",
		VariantChance = 0.01,
		ExpiresAt = 1791655200,
		PurchaseLimit = 0,
		Id = p3,
		BuyProductId = p4,
		DisplayName = p5,
		Rewards = v27[1].Rewards,
		PreviewItems = v27[1].PreviewItems,
		Colors = v27
	}
end

local v7 = energyPack("EnergyBundle", 3710196488, "Energy Bundle", { "Knife", "Revolver", "Finisher" })

v7.GiftProductId = 3710196517

local v8 = energyPack("EnergyKnife", 3710541003, "Energy Blade", { "Knife" })
local v9 = energyPack("EnergyGun", 3710541032, "Energy Blaster", { "Revolver" })
local v10 = energyPack("EnergyFinisher", 3710541056, "Energy Overcharge", { "Finisher" })
local module: {[any]: any} = {
	Packs = {
		ReleasePack = {
			Id = "ReleasePack",
			BuyProductId = 3552410176,
			GiftProductId = 3552412911,
			DisplayName = "Release Pack",
			ExpiresAt = 1781204400,
			PurchaseLimit = 3,
			Rewards = {
				{ Kind = "Knife", ItemId = "GoldenStiletto", Finisher = "Goldify" },
				{ Kind = "Revolver", ItemId = "GoldenLuger", Finisher = "Goldify" }
			}
		},
		StarterPack = {
			Id = "StarterPack",
			BuyProductId = 3572375799,
			DisplayName = "Starter Pack",
			ExpiresAt = nil,
			PurchaseLimit = 1,
			OwnershipCheck = "FlammableKnife",
			Rewards = {
				{ Kind = "Cases", CrateId = "RecruitCase", Amount = 3 },
				{ Kind = "Coins", Amount = 3000 },
				{ Kind = "Ability", AbilityId = "FlammableKnife" }
			}
		},
		CheapPack = {
			Id = "CheapPack",
			BuyProductId = 3600816191,
			DisplayName = "Special Offer",
			ExpiresAt = nil,
			PurchaseLimit = 1,
			Rewards = { { Kind = "Cases", CrateId = "RecruitCase", Amount = 1 } }
		},
		ExpensivePack = {
			Id = "ExpensivePack",
			BuyProductId = 3608055784,
			DisplayName = "Space Case",
			ExpiresAt = nil,
			PurchaseLimit = 1,
			Rewards = { { Kind = "Cases", CrateId = "SpaceCase", Amount = 1 } }
		},
		HallowsUpsell = {
			Id = "HallowsUpsell",
			BuyProductId = 3719895949,
			DisplayName = "Hallow's Case",
			ExpiresAt = nil,
			PurchaseLimit = 1,
			Rewards = { { Kind = "Cases", CrateId = "HallowsCase", Amount = 1 } }
		},
		BoothSign = {
			Id = "BoothSign",
			BuyProductId = 3711765627,
			DisplayName = "Booth Sign",
			ExpiresAt = nil,
			PurchaseLimit = 1,
			Rewards = {}
		},
		WantedSign = {
			Id = "WantedSign",
			BuyProductId = 3711765566,
			DisplayName = "Looking For... Sign",
			ExpiresAt = nil,
			PurchaseLimit = 1,
			Rewards = {}
		},
		TextSign = {
			Id = "TextSign",
			BuyProductId = 3711777178,
			DisplayName = "Custom Text Sign",
			ExpiresAt = nil,
			PurchaseLimit = 1,
			Rewards = {}
		},
		MegalodonBundle = {
			Id = "MegalodonBundle",
			BuyProductId = 3603920063,
			GiftProductId = 3603920838,
			DisplayName = "Megalodon Bundle",
			ExpiresAt = 1783710000,
			PurchaseLimit = 0,
			Rewards = {
				{ Kind = "Knife", ItemId = "Megalodon", Finisher = "SharkAttack" },
				{ Kind = "Revolver", ItemId = "Megalodon", Finisher = "SharkAttack" }
			}
		},
		MegalodonKnife = {
			Id = "MegalodonKnife",
			BuyProductId = 3603920577,
			DisplayName = "Megalodon Knife",
			ExpiresAt = 1783710000,
			PurchaseLimit = 0,
			Rewards = { { Kind = "Knife", ItemId = "Megalodon", Finisher = "SharkAttack" } }
		},
		MegalodonGun = {
			Id = "MegalodonGun",
			BuyProductId = 3603920617,
			DisplayName = "Megalodon Revolver",
			ExpiresAt = 1783710000,
			PurchaseLimit = 0,
			Rewards = { { Kind = "Revolver", ItemId = "Megalodon", Finisher = "SharkAttack" } }
		},
		MermaidBundle = {
			Id = "MermaidBundle",
			BuyProductId = 3603921063,
			GiftProductId = 3603921117,
			DisplayName = "Mermaid Bundle",
			ExpiresAt = 1783710000,
			PurchaseLimit = 0,
			Rewards = {
				{ Kind = "Knife", ItemId = "Mermaid", Finisher = "PearlChomp" },
				{ Kind = "Revolver", ItemId = "Mermaid", Finisher = "PearlChomp" }
			}
		},
		MermaidKnife = {
			Id = "MermaidKnife",
			BuyProductId = 3603921152,
			DisplayName = "Mermaid Knife",
			ExpiresAt = 1783710000,
			PurchaseLimit = 0,
			Rewards = { { Kind = "Knife", ItemId = "Mermaid", Finisher = "PearlChomp" } }
		},
		MermaidGun = {
			Id = "MermaidGun",
			BuyProductId = 3603921172,
			DisplayName = "Mermaid Revolver",
			ExpiresAt = 1783710000,
			PurchaseLimit = 0,
			Rewards = { { Kind = "Revolver", ItemId = "Mermaid", Finisher = "PearlChomp" } }
		},
		MidnightBundle = {
			Id = "MidnightBundle",
			BuyProductId = 3611805873,
			GiftProductId = 3611808990,
			DisplayName = "Midnight Bundle",
			ExpiresAt = 1788112800,
			PurchaseLimit = 0,
			Rewards = {
				{ Kind = "Knife", ItemId = "MidnightKatana" },
				{ Kind = "Revolver", ItemId = "MidnightCrossbow" },
				{ Kind = "Finisher", Finisher = "MidnightFlame" }
			},
			PreviewItems = {
				{
					Kind = "Knife",
					ItemId = "MidnightKatana",
					Name = "Midnight Katana",
					Rarity = "Legendary",
					Label = "KNIFE",
					Icon = "rbxassetid://134405098379727"
				},
				{
					Kind = "Revolver",
					ItemId = "MidnightCrossbow",
					Name = "Midnight Crossbow",
					Rarity = "Legendary",
					Label = "GUN",
					Icon = "rbxassetid://112700905336796"
				},
				{
					Kind = "Finisher",
					ItemId = "MidnightFlame",
					Name = "Midnight Flame",
					Rarity = "Legendary",
					Label = "FINISHER",
					Icon = "rbxassetid://120594955871012"
				}
			}
		},
		MidnightKnife = {
			Id = "MidnightKnife",
			BuyProductId = 3611808100,
			DisplayName = "Midnight Katana",
			ExpiresAt = 1788112800,
			PurchaseLimit = 0,
			Rewards = { { Kind = "Knife", ItemId = "MidnightKatana" } }
		},
		MidnightGun = {
			Id = "MidnightGun",
			BuyProductId = 3611807978,
			DisplayName = "Midnight Crossbow",
			ExpiresAt = 1788112800,
			PurchaseLimit = 0,
			Rewards = { { Kind = "Revolver", ItemId = "MidnightCrossbow" } }
		},
		MidnightFinisher = {
			Id = "MidnightFinisher",
			BuyProductId = 3611808256,
			DisplayName = "Midnight Flame",
			ExpiresAt = 1788112800,
			PurchaseLimit = 0,
			Rewards = { { Kind = "Finisher", Finisher = "MidnightFlame" } }
		},
		NinjaBundle = {
			Id = "NinjaBundle",
			BuyProductId = 3611805841,
			GiftProductId = 3611809069,
			DisplayName = "Ninja Bundle",
			ExpiresAt = 1788112800,
			PurchaseLimit = 0,
			Rewards = {
				{ Kind = "Knife", ItemId = "Kunai" },
				{ Kind = "Revolver", ItemId = "Silencer" },
				{ Kind = "Finisher", Finisher = "Kanji" }
			},
			PreviewItems = {
				{
					Kind = "Knife",
					ItemId = "Kunai",
					Name = "Kunai",
					Rarity = "Legendary",
					Label = "KNIFE",
					Icon = "rbxassetid://106471222888583"
				},
				{
					Kind = "Revolver",
					ItemId = "Silencer",
					Name = "Silencer",
					Rarity = "Legendary",
					Label = "GUN",
					Icon = "rbxassetid://101309265091993"
				},
				{
					Kind = "Finisher",
					ItemId = "Kanji",
					Name = "Kanji",
					Rarity = "Legendary",
					Label = "FINISHER",
					Icon = "rbxassetid://74546215297912"
				}
			}
		},
		NinjaKnife = {
			Id = "NinjaKnife",
			BuyProductId = 3611808816,
			DisplayName = "Kunai",
			ExpiresAt = 1788112800,
			PurchaseLimit = 0,
			Rewards = { { Kind = "Knife", ItemId = "Kunai" } }
		},
		NinjaGun = {
			Id = "NinjaGun",
			BuyProductId = 3611808699,
			DisplayName = "Silencer",
			ExpiresAt = 1788112800,
			PurchaseLimit = 0,
			Rewards = { { Kind = "Revolver", ItemId = "Silencer" } }
		},
		NinjaFinisher = {
			Id = "NinjaFinisher",
			BuyProductId = 3611808919,
			DisplayName = "Kanji",
			ExpiresAt = 1788112800,
			PurchaseLimit = 0,
			Rewards = { { Kind = "Finisher", Finisher = "Kanji" } }
		},
		EnergyBundle = v7,
		EnergyKnife = v8,
		EnergyGun = v9,
		EnergyFinisher = v10,
		HeartKeeperBundle = {
			Id = "HeartKeeperBundle",
			BuyProductId = 3710196559,
			GiftProductId = 3710196589,
			DisplayName = "Heart Keeper Bundle",
			ExpiresAt = 1791655200,
			PurchaseLimit = 0,
			Rewards = {
				{ Kind = "Knife", ItemId = "HeartKeeperKnife" },
				{ Kind = "Revolver", ItemId = "HeartKeeperGun" },
				{ Kind = "Finisher", Finisher = "Beloved" }
			},
			PreviewItems = {
				{
					Kind = "Knife",
					ItemId = "HeartKeeperKnife",
					Name = "Heart Keeper",
					Rarity = "Legendary",
					Label = "KNIFE",
					Icon = "rbxassetid://98095464465031"
				},
				{
					Kind = "Revolver",
					ItemId = "HeartKeeperGun",
					Name = "Heart Keeper",
					Rarity = "Legendary",
					Label = "GUN",
					Icon = "rbxassetid://120876295568246"
				},
				{
					Kind = "Finisher",
					ItemId = "Beloved",
					Name = "Beloved",
					Rarity = "Legendary",
					Label = "FINISHER",
					Icon = "rbxassetid://88229364433196"
				}
			}
		},
		HeartKeeperKnife = {
			Id = "HeartKeeperKnife",
			BuyProductId = 3710540522,
			DisplayName = "Heart Keeper Knife",
			ExpiresAt = 1791655200,
			PurchaseLimit = 0,
			Rewards = { { Kind = "Knife", ItemId = "HeartKeeperKnife" } }
		},
		HeartKeeperGun = {
			Id = "HeartKeeperGun",
			BuyProductId = 3710540649,
			DisplayName = "Heart Seeker",
			ExpiresAt = 1791655200,
			PurchaseLimit = 0,
			Rewards = { { Kind = "Revolver", ItemId = "HeartKeeperGun" } }
		},
		HeartKeeperFinisher = {
			Id = "HeartKeeperFinisher",
			BuyProductId = 3710540724,
			DisplayName = "Beloved",
			ExpiresAt = 1791655200,
			PurchaseLimit = 0,
			Rewards = { { Kind = "Finisher", Finisher = "Beloved" } }
		},
		BlackCatBundle = {
			Id = "BlackCatBundle",
			BuyProductId = 3718924628,
			GiftProductId = 3718924631,
			DisplayName = "Black Cat Bundle",
			ExpiresAt = 1795374000,
			PurchaseLimit = 0,
			ReleaseKey = "HalloweenBundles",
			Rewards = {
				{ Kind = "Knife", ItemId = "CatAxe" },
				{ Kind = "Revolver", ItemId = "CatShotgun" },
				{ Kind = "Finisher", Finisher = "CatDrop" }
			},
			PreviewItems = {
				{
					Kind = "Knife",
					ItemId = "CatAxe",
					Name = "Cat Axe",
					Rarity = "Legendary",
					Label = "KNIFE",
					Icon = "rbxassetid://84020876787794"
				},
				{
					Kind = "Revolver",
					ItemId = "CatShotgun",
					Name = "Cat Shotgun",
					Rarity = "Legendary",
					Label = "GUN",
					Icon = "rbxassetid://98300018455990"
				},
				{
					Kind = "Finisher",
					ItemId = "CatDrop",
					Name = "Cat Drop",
					Rarity = "Epic",
					Label = "FINISHER",
					Icon = "rbxassetid://94306006543549"
				}
			}
		},
		BlackCatKnife = {
			Id = "BlackCatKnife",
			BuyProductId = 3718924633,
			DisplayName = "Cat Axe",
			ExpiresAt = 1795374000,
			PurchaseLimit = 0,
			ReleaseKey = "HalloweenBundles",
			Rewards = { { Kind = "Knife", ItemId = "CatAxe" } }
		},
		BlackCatGun = {
			Id = "BlackCatGun",
			BuyProductId = 3718924634,
			DisplayName = "Cat Shotgun",
			ExpiresAt = 1795374000,
			PurchaseLimit = 0,
			ReleaseKey = "HalloweenBundles",
			Rewards = { { Kind = "Revolver", ItemId = "CatShotgun" } }
		},
		BlackCatFinisher = {
			Id = "BlackCatFinisher",
			BuyProductId = 3718924638,
			DisplayName = "Cat Drop",
			ExpiresAt = 1795374000,
			PurchaseLimit = 0,
			ReleaseKey = "HalloweenBundles",
			Rewards = { { Kind = "Finisher", Finisher = "CatDrop" } }
		},
		VampireBundle = {
			Id = "VampireBundle",
			BuyProductId = 3718924639,
			GiftProductId = 3718924641,
			DisplayName = "Vampiric Bundle",
			ExpiresAt = 1795374000,
			PurchaseLimit = 0,
			ReleaseKey = "HalloweenBundles",
			Rewards = {
				{ Kind = "Knife", ItemId = "VampireScythes" },
				{ Kind = "Revolver", ItemId = "VampireGun" },
				{ Kind = "Finisher", Finisher = "BatStorm" }
			},
			PreviewItems = {
				{
					Kind = "Knife",
					ItemId = "VampireScythes",
					Name = "Vampire Scythes",
					Rarity = "Legendary",
					Label = "KNIFE",
					Icon = "rbxassetid://86063677496159"
				},
				{
					Kind = "Revolver",
					ItemId = "VampireGun",
					Name = "Vampire Gunblade",
					Rarity = "Legendary",
					Label = "GUN",
					Icon = "rbxassetid://126969830150293"
				},
				{
					Kind = "Finisher",
					ItemId = "BatStorm",
					Name = "Bat Storm",
					Rarity = "Legendary",
					Label = "FINISHER",
					Icon = "rbxassetid://91194873009423"
				}
			}
		},
		VampireKnife = {
			Id = "VampireKnife",
			BuyProductId = 3718924642,
			DisplayName = "Vampire Scythes",
			ExpiresAt = 1795374000,
			PurchaseLimit = 0,
			ReleaseKey = "HalloweenBundles",
			Rewards = { { Kind = "Knife", ItemId = "VampireScythes" } }
		},
		VampireGun = {
			Id = "VampireGun",
			BuyProductId = 3718924644,
			DisplayName = "Vampire Gunblade",
			ExpiresAt = 1795374000,
			PurchaseLimit = 0,
			ReleaseKey = "HalloweenBundles",
			Rewards = { { Kind = "Revolver", ItemId = "VampireGun" } }
		},
		VampireFinisher = {
			Id = "VampireFinisher",
			BuyProductId = 3718924647,
			DisplayName = "Bat Storm",
			ExpiresAt = 1795374000,
			PurchaseLimit = 0,
			ReleaseKey = "HalloweenBundles",
			Rewards = { { Kind = "Finisher", Finisher = "BatStorm" } }
		}
	}
}

function module.Get(p7)
	return module.Packs[p7]
end
function module.HasColors(p8)
	local u30: boolean = false

	if typeof(p8) == "table" then
		u30 = false

		if typeof(p8.Colors) == "table" then
			u30 = #p8.Colors > 0
		end
	end

	return u30
end
function module.ColorGroupOf(p9)
	if not module.HasColors(p9) then
		return nil
	end

	return p9.ColorGroup or p9.Id
end
function module.DefaultColorKey(p10)
	if not module.HasColors(p10) then
		return nil
	end

	return p10.Colors[1].Key
end
function module.GetColor(p11, p12)
	if module.HasColors(p11) and typeof(p12) == "string" then
		for _, v in ipairs(p11.Colors) do
			if p12 == v.Key then
				return v
			end
		end

		return nil
	end

	return nil
end
function module.ResolveColorKey(p13, p14)
	if not module.HasColors(p13) then
		return nil
	end

	local v39 = module.GetColor(p13, p14)

	if v39 then
		return v39.Key
	end

	return module.DefaultColorKey(p13)
end
function module.RewardsFor(p15, p16)
	if typeof(p15) == "table" then
		local v42 = module.GetColor(p15, p16)

		if not v42 then
			v42 = module.HasColors(p15) and p15.Colors[1] or nil
		end

		if v42 then
			return v42.Rewards
		end

		return p15.Rewards
	end

	return {}
end
function module.PreviewItemsFor(p17, p18)
	if typeof(p17) == "table" then
		local v45 = module.GetColor(p17, p18)

		if v45 then
			return v45.PreviewItems
		end

		return p17.PreviewItems
	end

	return nil
end
function module.IsExpired(p19)
	if p19.ExpiresAt == nil then
		return false
	end

	return os.time() >= p19.ExpiresAt
end
function module.IsExpiredHard(p20)
	if p20.ExpiresAt == nil then
		return false
	end

	return os.time() >= p20.ExpiresAt + 3600
end

local updateGate = nil

function module.IsReleased(p21)
	local releaseKey = p21.ReleaseKey

	if releaseKey == nil then
		return true
	end

	if not updateGate then
		updateGate = require(script.Parent:WaitForChild("UpdateGate"))
	end

	return updateGate.IsReleased(releaseKey)
end
function module.GetTimeRemaining(p22)
	if p22.ExpiresAt == nil then
		return math.huge
	end

	local expiresAt = p22.ExpiresAt
	local timestamp = os.time()

	return (math.max(0, expiresAt - timestamp))
end
function module.GetAllProductIds()
	local t7: {[any]: any} = {}

	for _, v in pairs(module.Packs) do
		table.insert(t7, v.BuyProductId)

		if v.GiftProductId then
			table.insert(t7, v.GiftProductId)
		end
	end

	return t7
end
function module.GetPackFinisherSet()
	local t8: {[any]: any} = {}

	local function collect(p23)
		for _, v in ipairs(p23) do
			if typeof(v.Finisher) == "string" then
				t8[v.Finisher] = true
			end
		end
	end

	for _, v in pairs(module.Packs) do
		collect(v.Rewards)

		if v.Colors then
			for _, iterValue in ipairs(v.Colors) do
				collect(iterValue.Rewards)
			end
		end
	end

	return t8
end
function module.GetShopItemSet()
	local t9: {[any]: any} = {
		Knife = {},
		Revolver = {},
		Finisher = {}
	}

	local function collect(p24)
		for _, v in ipairs(p24) do
			if (v.Kind == "Knife" or v.Kind == "Revolver") and typeof(v.ItemId) == "string" then
				t9[v.Kind][v.ItemId] = true
			end

			if typeof(v.Finisher) == "string" then
				t9.Finisher[v.Finisher] = true
			end
		end
	end

	for _, v in pairs(module.Packs) do
		if v.BuyProductId ~= 0 and not module.IsExpired(v) and module.IsReleased(v) then
			collect(v.Rewards)

			if v.Colors then
				for _, iterValue in ipairs(v.Colors) do
					collect(iterValue.Rewards)
				end
			end
		end
	end

	return t9
end
function module.ShopLeavesAt(p25, p26)
	local function grants(p27)
		for _, v in ipairs(p27) do
			if p25 ~= "Finisher" then
				if v.Kind == p25 and v.ItemId == p26 then
					return true
				end
			elseif v.Finisher == p26 then
				return true
			end
		end

		return false
	end

	local v71 = nil

	for _, v in pairs(module.Packs) do
		if v.BuyProductId ~= 0 and not module.IsExpired(v) and module.IsReleased(v) then
			local v74 = grants(v.Rewards)

			if not v74 and v.Colors then
				for _, iterValue in ipairs(v.Colors) do
					if grants(iterValue.Rewards) then
						v74 = true

						break
					end
				end
			end

			if v74 then
				local v77 = v.ExpiresAt or math.huge

				if v71 == nil or v71 < v77 then
					v71 = v77
				end
			end
		end
	end

	return v71
end

return module
