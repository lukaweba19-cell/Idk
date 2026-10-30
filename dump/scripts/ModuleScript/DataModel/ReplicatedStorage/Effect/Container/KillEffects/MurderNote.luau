-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local debris = require(game.ReplicatedStorage.Util.Debris)
local sound = require(game.ReplicatedStorage.Sound)
local murderNoteCatalog = require(game.ReplicatedStorage.Shared.MurderNoteCatalog)
local t1: {[any]: any} = {
	StartDelay = 0.35,
	CharInterval = 0.028,
	LinePause = 0.12,
	Lifetime = 12,
	Offset = Vector3.new(0, 2.8, 0),
	MaxDistance = 20
}

local function noteFont(p1)
	local ok, result = pcall(function()
		return Font.new("rbxasset://fonts/families/Kalam.json", p1)
	end)

	if ok and result then
		return result
	end

	return Font.fromEnum(Enum.Font.SpecialElite)
end
local function makeLine(parent, layoutOrder, text, textSize, textColor3, p7)
	local textLabel: TextLabel = Instance.new("TextLabel")

	textLabel.Name = "Line" .. layoutOrder
	textLabel.LayoutOrder = layoutOrder
	textLabel.BackgroundTransparency = 1
	textLabel.Size = UDim2.new(1, 0, 0, textSize + 8)
	textLabel.Text = text
	textLabel.TextColor3 = textColor3
	textLabel.TextSize = textSize

	local ok, result = pcall(function()
		return Font.new("rbxasset://fonts/families/Kalam.json", p7)
	end)

	local v20

	if ok and result then
		v20 = result
	else
		v20 = Font.fromEnum(Enum.Font.SpecialElite)
	end

	textLabel.FontFace = v20
	textLabel.TextXAlignment = Enum.TextXAlignment.Center
	textLabel.MaxVisibleGraphemes = 0

	local uiStroke: UIStroke = Instance.new("UIStroke")

	uiStroke.Color = Color3.fromRGB(10, 10, 12)
	uiStroke.Thickness = 2
	uiStroke.Parent = textLabel
	textLabel.Parent = parent

	return textLabel
end
local function writeDeathNote(p8, p9)
	local parent = p8:FindFirstChild("Head") or p8:FindFirstChild("Torso") or p8:FindFirstChild("HumanoidRootPart")

	if not parent then
		return
	end

	local murderNotePage: BillboardGui = Instance.new("BillboardGui")

	murderNotePage.Name = "MurderNotePage"
	murderNotePage.Adornee = parent
	murderNotePage.Size = UDim2.fromOffset(360, 118)
	murderNotePage.StudsOffset = Vector3.new(0, 2.8, 0)
	murderNotePage.AlwaysOnTop = true
	murderNotePage.MaxDistance = 20
	murderNotePage.LightInfluence = 0
	murderNotePage.ResetOnSpawn = false

	local frame: Frame = Instance.new("Frame")

	frame.BackgroundTransparency = 1
	frame.Size = UDim2.fromScale(1, 1)
	frame.Parent = murderNotePage

	local uiListLayout: UIListLayout = Instance.new("UIListLayout")

	uiListLayout.FillDirection = Enum.FillDirection.Vertical
	uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Parent = frame

	local v28 = p8.Name
	local color3 = Color3.fromRGB(245, 245, 245)
	local v30 = makeLine(frame, 1, v28, 28, color3, Enum.FontWeight.Bold)
	local s1: string = "CAUSE OF DEATH: " .. p9.name
	local color32 = Color3.fromRGB(225, 80, 80)
	local v33 = makeLine(frame, 2, s1, 22, color32, Enum.FontWeight.Regular)
	local dateText = os.date("%m/%d/%Y")
	local color33 = Color3.fromRGB(200, 200, 205)
	local v36 = makeLine(frame, 3, "DATE: " .. dateText, 20, color33, Enum.FontWeight.Regular)

	murderNotePage.Parent = parent
	debris:AddItem(murderNotePage, 12)

	local t2: {[any]: any} = { v30, v33, v36 }

	task.spawn(function()
		task.wait(0.35)

		for key, value in t2 do
			if not murderNotePage.Parent or not value.Parent or not parent.Parent then
				return
			end

			for i = 1, utf8.len(value.Text) or #value.Text do
				if not murderNotePage.Parent or not value.Parent then
					return
				end

				value.MaxVisibleGraphemes = i
				sound:Play("KillEffects.MurderNote.Type", parent, 25, nil, 0.6, 0.09)
				task.wait(0.028)
			end

			task.wait(0.12)
		end
	end)
end

return function(player)
	local Character = player.Character

	if not Character then
		return
	end

	if (workspace.CurrentCamera.CFrame.p - Character:GetPivot().Position).Magnitude >= 1000 then
		return
	end

	local v40 = typeof(player.Seed) == "number" and player.Seed or math.random(1, 1073741824)
	local v41 = murderNoteCatalog.Pick(v40)
	local foundChild: Instance = script:FindFirstChild(v41.id)

	if not foundChild or not foundChild:IsA("ModuleScript") then
		warn(("[MurderNote] catalog entry '%s' has no child module"):format(v41.id))

		return
	end

	local random = Random.new(v40 * 31 + 7)

	writeDeathNote(Character, v41)
	require(foundChild)(player, v41, random)
end
