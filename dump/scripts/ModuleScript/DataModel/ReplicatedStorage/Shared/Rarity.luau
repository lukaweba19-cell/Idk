-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local color3 = Color3.fromRGB(155, 155, 155)
local color32 = Color3.fromRGB(95, 219, 105)
local color33 = Color3.fromRGB(80, 150, 255)
local color34 = Color3.fromRGB(185, 105, 255)
local color35 = Color3.fromRGB(255, 209, 24)
local color36 = Color3.fromRGB(255, 0, 0)
local color37 = Color3.fromRGB(38, 226, 213)
local color38 = Color3.fromRGB(255, 128, 26)
local module: {[any]: any} = {
	Order = {
		Common = 1,
		Uncommon = 2,
		Rare = 3,
		Epic = 4,
		Legendary = 5,
		Secret = 6,
		Collectible = 7,
		Exclusive = 8
	},
	Colors = {
		Common = color3,
		Uncommon = color32,
		Rare = color33,
		Epic = color34,
		Legendary = color35,
		Secret = color36,
		Collectible = color37,
		Exclusive = color38
	}
}

function module.GetColor(p1)
	return module.Colors[p1] or module.Colors.Common
end
function module.IsDefUntradeable(p2)
	if typeof(p2) == "table" then
		local u14: boolean = true

		if p2.Untradeable ~= true then
			u14 = p2.Rarity == "Exclusive"
		end

		return u14
	end

	return false
end

local t2: {[any]: any} = {
	Uncommon = "UncommonGradient",
	Rare = "RareGradient",
	Epic = "EpicGradient",
	Legendary = "LegendaryGradient",
	Secret = "SecretGradient",
	Collectible = "CollectibleGradient",
	Exclusive = "ExclusiveGradient"
}

function module.ApplyTextGradient(parent, p4)
	for _, v in ipairs(parent:GetChildren()) do
		if v:IsA("UIGradient") and v:GetAttribute("RarityGradient") then
			v:Destroy()
		end
	end

	local v19 = t2[p4]

	if not v19 then
		parent.TextColor3 = module.GetColor(p4)

		return
	end

	parent.TextColor3 = Color3.fromRGB(255, 255, 255)

	local foundChild = replicatedStorage.UIFramework.TextRarityGradients:FindFirstChild(v19)

	if foundChild and foundChild:IsA("UIGradient") then
		local clone = foundChild:Clone()

		clone:SetAttribute("RarityGradient", true)
		clone.Parent = parent
	end
end

return module
