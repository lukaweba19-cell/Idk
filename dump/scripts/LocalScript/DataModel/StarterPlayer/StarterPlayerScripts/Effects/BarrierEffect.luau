-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local util: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Util")
local distanceFade = require(util:WaitForChild("DistanceFade"))
local color3 = Color3.fromRGB(115, 248, 255)
local color32 = Color3.fromRGB(0, 153, 255)
local t1: {[any]: any} = {}

local function isWallPart(p1)
	return p1:IsA("BasePart")
end

local t2: {[any]: any} = {
	EdgeDistanceCalculations = true,
	Texture = "rbxassetid://18852900044",
	TextureTransparency = 0.25,
	BackgroundTransparency = 0.95,
	TextureColor = color3,
	BackgroundColor = color32,
	TextureSize = Vector2.new(6, 5.5),
	TextureOffset = Vector2.new(0, 0.5),
	Brightness = 1.5,
	EffectRadius = 10,
	DistanceOuter = 10,
	DistanceInner = 3
}

local function addFadeToWallPart(p2)
	if t1[p2] then
		return
	end

	local v18 = distanceFade.new()

	v18:UpdateSettings(t2)
	v18:AddFace(p2, Enum.NormalId.Back)
	v18:AddFace(p2, Enum.NormalId.Front)
	v18:AddFace(p2, Enum.NormalId.Left)
	v18:AddFace(p2, Enum.NormalId.Right)
	t1[p2] = v18
	p2.AncestryChanged:Connect(function(_, p4)
		local v30 = p4 == nil and t1[p2]

		if v30 then
			if v30.Clear then
				pcall(function()
					v30:Clear()
				end)
			end

			t1[p2] = nil
		end
	end)
end
local function scanBarriersFolder(p5)
	for _, v in ipairs(p5:GetChildren()) do
		if v:IsA("BasePart") then
			addFadeToWallPart(v)
		end
	end
end
local function hookBarriersFolder(p6)
	scanBarriersFolder(p6)
	p6.ChildAdded:Connect(function(p7: Instance)
		if p7:IsA("BasePart") then
			addFadeToWallPart(p7)
		end
	end)
end

local game2: Instance = workspace:WaitForChild("Game")

local function tryHook(p8)
	if p8:IsA("Folder") and p8.Name == "Barriers" then
		scanBarriersFolder(p8)
		p8.ChildAdded:Connect(function(p7: Instance)
			if p7:IsA("BasePart") then
				addFadeToWallPart(p7)
			end
		end)
	end
end

for _, v in ipairs(game2:GetDescendants()) do
	if v:IsA("Folder") and v.Name == "Barriers" then
		scanBarriersFolder(v)
		v.ChildAdded:Connect(function(p9)
			if p9:IsA("BasePart") then
				addFadeToWallPart(p9)
			end
		end)
	end
end

game2.DescendantAdded:Connect(function(p10: Instance)
	if p10:IsA("Folder") and p10.Name == "Barriers" then
		scanBarriersFolder(p10)
		p10.ChildAdded:Connect(function(p7: Instance)
			if p7:IsA("BasePart") then
				addFadeToWallPart(p7)
			end
		end)
	end
end)
runService.RenderStepped:Connect(function()
	for k, v in pairs(t1) do
		if k.Parent == nil then
			if v and v.Clear then
				pcall(function()
					v:Clear()
				end)
			end

			t1[k] = nil
		else
			v:Step()
		end
	end
end)
