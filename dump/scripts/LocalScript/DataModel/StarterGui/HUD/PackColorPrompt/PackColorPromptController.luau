-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local tweenService: TweenService = game:GetService("TweenService")
local guiService: GuiService = game:GetService("GuiService")
local extensions: Instance = replicatedStorage:WaitForChild("Extensions")
local inputCategorizer = require(extensions:WaitForChild("InputCategorizer"))
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local packCatalog = require(shared:WaitForChild("PackCatalog"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local traitText = require(replicatedStorageShared:WaitForChild("TraitText"))
local LocalPlayer: Player = players.LocalPlayer
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local currencyBuyRequest: Instance = remotes:WaitForChild("CurrencyBuyRequest")
local packColorSelect: Instance = remotes:WaitForChild("PackColorSelect")
local shopOpenAnalytics: Instance = remotes:WaitForChild("ShopOpenAnalytics")
local openShop: Instance = bindables:WaitForChild("OpenShop")
local packColorPrompt: Instance = bindables:WaitForChild("PackColorPrompt")
local packColorChoose: Instance = bindables:WaitForChild("PackColorChoose")
local scriptParent: Instance = script.Parent
local chance: Instance = scriptParent:WaitForChild("Chance")
local tiles: Instance = scriptParent:WaitForChild("Tiles")
local closeButton: Instance = scriptParent:WaitForChild("CloseButton")
local packColorPromptGui: ScreenGui = Instance.new("ScreenGui")

packColorPromptGui.Name = "PackColorPromptGui"
packColorPromptGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
packColorPromptGui.DisplayOrder = 16
packColorPromptGui.IgnoreGuiInset = true
packColorPromptGui.ResetOnSpawn = false
packColorPromptGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local packColorPromptBackdrop: Frame = Instance.new("Frame")

packColorPromptBackdrop.Name = "PackColorPromptBackdrop"
packColorPromptBackdrop.BackgroundColor3 = Color3.new(0, 0, 0)
packColorPromptBackdrop.BackgroundTransparency = 0.5
packColorPromptBackdrop.BorderSizePixel = 0
packColorPromptBackdrop.Size = UDim2.fromScale(1, 1)
packColorPromptBackdrop.ZIndex = 49
packColorPromptBackdrop.Active = true
packColorPromptBackdrop.Selectable = false
packColorPromptBackdrop.Visible = false
packColorPromptBackdrop.Parent = packColorPromptGui
chance.TextColor3 = Color3.new(1, 1, 1)
traitText.Bind(chance, chance.Text)

local uiGradient: UIGradient = Instance.new("UIGradient")
local colorSequenceNew = ColorSequence.new

uiGradient.Color = colorSequenceNew({
	ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
	ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.16666666666666666, 1, 1)),
	ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.3333333333333333, 1, 1)),
	ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
	ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.6666666666666666, 1, 1)),
	ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.8333333333333334, 1, 1)),
	ColorSequenceKeypoint.new(1, Color3.fromHSV(0, 1, 1))
})
uiGradient.Offset = Vector2.new(-1, 0)
uiGradient.Parent = chance

local tweenInfo = TweenInfo.new(2.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1, false)
local v29: Tween = tweenService:Create(uiGradient, tweenInfo, { Offset = Vector2.new(1, 0) })
local u30 = nil
local t1: {[any]: any} = {}

local function onPick(p1)
	local v35 = u30

	if not v35 then
		return
	end

	local v36 = packCatalog.Get(v35)

	if not v36 then
		scriptParent.Visible = false
		packColorPromptBackdrop.Visible = false
		v29:Pause()

		local guiServiceSelectedObject: GuiObject = guiService.SelectedObject

		if guiServiceSelectedObject and guiServiceSelectedObject:IsDescendantOf(scriptParent) then
			guiService.SelectedObject = nil
		end

		u30 = nil

		return
	end

	scriptParent.Visible = false
	packColorPromptBackdrop.Visible = false
	v29:Pause()

	local selectedObject: GuiObject = guiService.SelectedObject

	if selectedObject and selectedObject:IsDescendantOf(scriptParent) then
		guiService.SelectedObject = nil
	end

	u30 = nil

	if packCatalog.IsExpired(v36) then
		return
	end

	packColorSelect:FireServer(v35, p1)
	packColorChoose:Fire(v35, p1)
	openShop:Fire(v35)
	shopOpenAnalytics:FireServer("PackPodium")
	currencyBuyRequest:FireServer(v36.BuyProductId)
end
local function paintTile(p2, p3)
	local colorName = p2:FindFirstChild("ColorName")

	if colorName and colorName:IsA("TextLabel") then
		colorName.Text = p3.DisplayName
		colorName.TextColor3 = p3.Swatch
	end

	for _, v in ipairs(p2:GetChildren()) do
		if v:IsA("UIStroke") then
			v.Color = p3.Swatch
		end
	end
end

closeButton.MouseButton1Click:Connect(function()
	scriptParent.Visible = false
	packColorPromptBackdrop.Visible = false
	v29:Pause()

	local guiServiceSelectedObject: GuiObject = guiService.SelectedObject

	if guiServiceSelectedObject and guiServiceSelectedObject:IsDescendantOf(scriptParent) then
		guiService.SelectedObject = nil
	end

	u30 = nil
end)
scriptParent.Parent = packColorPromptGui
scriptParent.Visible = false
scriptParent.ZIndex = 50
scriptParent.Active = true
scriptParent.SelectionGroup = true
scriptParent.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
scriptParent.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
scriptParent.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
scriptParent.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
packColorPrompt.Event:Connect(function(p4)
	if typeof(p4) == "string" then
		local v46 = packCatalog.Get(p4)

		if not v46 or not packCatalog.HasColors(v46) then
			local text: string = tostring(p4)

			warn("[PackColorPrompt] '" .. text .. "' has no colourways; nothing to choose")

			return
		end

		u30 = p4

		local t2: {[any]: any} = {}
		local v49 = nil

		for _, v in ipairs(v46.Colors) do
			local vKey: Instance = tiles:FindFirstChild(v.Key)

			if vKey and vKey:IsA("GuiButton") then
				t2[v.Key] = true
				vKey.Visible = true
				paintTile(vKey, v)

				if not v49 then
					v49 = vKey
				end

				if not t1[vKey] then
					t1[vKey] = true

					local v53 = v.Key

					vKey.Activated:Connect(function()
						if not vKey.Interactable then
							return
						end

						onPick(v53)
					end)
				end
			else
				warn("[PackColorPrompt] Pack '" .. p4 .. "' declares colour '" .. v.Key .. "' but the menu has no tile for it")
			end
		end

		for _, v in ipairs(tiles:GetChildren()) do
			if v:IsA("GuiButton") and not t2[v.Name] then
				v.Visible = false
			end
		end

		packColorPromptBackdrop.Visible = true
		scriptParent.Visible = true
		v29:Play()

		if inputCategorizer.getLastInputCategory() == inputCategorizer.InputCategory.Gamepad then
			guiService.SelectedObject = v49
		end

		return
	end
end)
