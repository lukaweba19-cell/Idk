-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local proximityPromptService: ProximityPromptService = game:GetService("ProximityPromptService")
local userInputService: UserInputService = game:GetService("UserInputService")
local shared: Instance = replicatedStorage:WaitForChild("Shared")

if not require(shared:WaitForChild("TradingPlazaGate")).IsTradingPlaza() then
	return
end

local boothClient = require(shared:WaitForChild("BoothClient"))
local boothTheme = require(shared:WaitForChild("BoothTheme"))
local boothSaleFX = require(shared:WaitForChild("BoothSaleFX"))
local hoverInfoModule = require(shared:WaitForChild("HoverInfoModule"))
local uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))
local LocalPlayer: Player = players.LocalPlayer
local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local openBoothWindow: Instance = bindables:FindFirstChild("OpenBoothWindow")
local u14

if openBoothWindow and openBoothWindow:IsA("BindableEvent") then
	u14 = openBoothWindow
else
	local openBoothWindow: BindableEvent = Instance.new("BindableEvent")

	openBoothWindow.Name = "OpenBoothWindow"
	openBoothWindow.Parent = bindables
	u14 = openBoothWindow
end

local function notifyFail(p1)
	local _GNotify = _G.Notify

	if typeof(_GNotify) == "function" then
		pcall(function()
			_GNotify({ notifType = "FailNotification", errorMessage = p1 })
		end)
	end
end

local boothThemeFmt = boothTheme.Fmt

if workspace:GetAttribute("PlazaWorldReady") ~= true then
	workspace:GetAttributeChangedSignal("PlazaWorldReady"):Wait()
end

local booths: Instance = workspace:WaitForChild("Lobby"):WaitForChild("Booths", 30)

if booths == nil then
	return
end

local function boothFor(p2)
	return boothClient.FindBooth(p2)
end
local function getSurfacesGui()
	local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui")
	local boothSurfaces: Instance = playerGui:FindFirstChild("BoothSurfaces")

	if boothSurfaces ~= nil and boothSurfaces:IsA("ScreenGui") and boothSurfaces.Parent ~= nil then
		return boothSurfaces
	end

	if boothSurfaces ~= nil then
		boothSurfaces:Destroy()
	end

	local boothSurfaces: ScreenGui = Instance.new("ScreenGui")

	boothSurfaces.Name = "BoothSurfaces"
	boothSurfaces.ResetOnSpawn = false
	boothSurfaces.Enabled = true
	boothSurfaces.Parent = playerGui

	return boothSurfaces
end

local t1: {[any]: any} = {
	pendingOpen = nil,
	hover = nil,
	stands = {},
	tileHovers = {}
}

local function releaseTileHovers(p3)
	local v50 = t1.tileHovers[p3]

	if v50 == nil then
		return
	end

	for _, v in ipairs(v50) do
		v.disconnect()
	end

	t1.tileHovers[p3] = nil
end
local function clearGui(p4, p5)
	local foundChild = getSurfacesGui():FindFirstChild(p4 .. "_" .. p5)

	if foundChild then
		foundChild:Destroy()
	end

	if p5 == "Sign" then
		local v56 = t1.tileHovers[p4]

		if v56 == nil then
			return
		end

		for _, v in ipairs(v56) do
			v.disconnect()
		end

		t1.tileHovers[p4] = nil

		return
	end
end
local function ensureGui(p6, adornee, p8, pixelsPerStud, maxDistance)
	local parent = getSurfacesGui()
	local name: string = p6 .. "_" .. p8
	local foundChild = parent:FindFirstChild(name)

	if foundChild and foundChild:IsA("SurfaceGui") then
		foundChild.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
		foundChild.PixelsPerStud = pixelsPerStud
		foundChild.MaxDistance = maxDistance
		foundChild.Adornee = adornee
		foundChild:ClearAllChildren()

		return foundChild
	end

	if foundChild then
		foundChild:Destroy()
	end

	local surfaceGui: SurfaceGui = Instance.new("SurfaceGui")

	surfaceGui.Name = name
	surfaceGui.Face = Enum.NormalId.Front
	surfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	surfaceGui.PixelsPerStud = pixelsPerStud
	surfaceGui.MaxDistance = maxDistance
	surfaceGui.LightInfluence = 0
	surfaceGui.Brightness = 1
	surfaceGui.ResetOnSpawn = false
	surfaceGui.Adornee = adornee
	surfaceGui.Parent = parent

	return surfaceGui
end
local function label(p11, p12, p13, p14, textScaled, p16)
	local v74 = boothTheme.Label(p11, p12, p13, p14, p16)

	v74.TextScaled = textScaled

	return v74
end
local function renderNamePlate(p17, p18, p19)
	if p19 == nil or p19.OwnerUserId == nil then
		local foundChild = getSurfacesGui():FindFirstChild(p17 .. "_" .. "NamePlate")

		if foundChild then
			foundChild:Destroy()
		end

		return
	end

	local v79 = ensureGui(p17, p18, "NamePlate", 50, 80)
	local parent = boothTheme.SignRoot(v79, boothTheme.PLATE_ASPECT)
	local text: string = tostring(p19.OwnerDisplayName or p19.OwnerName or "Someone")
	local v82 = UDim2.fromScale(1, 0.44)
	local v83 = UDim2.fromScale(0, 0.05)
	local v84 = boothTheme.Label(parent, text .. "'s Booth", v82, v83, nil)

	v84.TextScaled = true

	local ownerName = p19.OwnerName

	if typeof(ownerName) == "string" and ownerName ~= "" and userInputService.MouseEnabled then
		v84.MouseEnter:Connect(function()
			v84.Text = "@" .. ownerName .. "'s Booth"
		end)
		v84.MouseLeave:Connect(function()
			v84.Text = text .. "'s Booth"
		end)
	end

	local frame: Frame = Instance.new("Frame")

	frame.BackgroundTransparency = 1
	frame.Size = UDim2.fromScale(1, 0.34)
	frame.Position = UDim2.fromScale(0, 0.56)
	frame.Parent = parent

	local uiListLayout: UIListLayout = Instance.new("UIListLayout")

	uiListLayout.FillDirection = Enum.FillDirection.Horizontal
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	uiListLayout.Padding = UDim.new(0.008, 0)
	uiListLayout.Parent = frame
	v83 = UDim2.fromScale(0.38, 1)

	local v88 = UDim2.fromScale(0, 0)
	local v89 = boothTheme.Label(frame, "Amount sold:", v83, v88, nil)

	v89.TextScaled = true
	v89.LayoutOrder = 1
	v89.TextXAlignment = Enum.TextXAlignment.Right

	local imageLabel: ImageLabel = Instance.new("ImageLabel")

	imageLabel.BackgroundTransparency = 1
	imageLabel.Image = boothTheme.TokenIcon()
	imageLabel.Size = UDim2.fromScale(0.09, 0.85)
	imageLabel.LayoutOrder = 2

	local uiAspectRatioConstraint: UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

	uiAspectRatioConstraint.AspectRatio = 1
	uiAspectRatioConstraint.Parent = imageLabel
	imageLabel.Parent = frame

	local boothThemeTokenAmount = boothTheme.TokenAmount
	local v93 = p19.TokensSold or 0
	local v94 = UDim2.fromScale(0.2, 1)
	local v95 = boothThemeTokenAmount(frame, v93, v94, UDim2.fromScale(0, 0))

	v95.LayoutOrder = 3
	v83 = function()
		if frame.Parent == nil then
			return
		end

		local floored = math.floor(frame.AbsoluteSize.Y * 0.8)
		local textSize = math.max(8, floored)

		for _, v in ipairs({ v89, v95 }) do
			v.TextScaled = false
			v.TextWrapped = false
			v.TextSize = textSize
			v.AutomaticSize = Enum.AutomaticSize.X
			v.Size = UDim2.new(0, 0, 1, 0)
		end
	end
	v83()
	frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(v83)
end
local function signHover()
	local hover = t1.hover

	if hover == nil or hover.frameFull.Parent == nil then
		local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui")
		local boothSignTooltip = playerGui:FindFirstChild("BoothSignTooltip")

		if not boothSignTooltip or not boothSignTooltip:IsA("ScreenGui") then
			if boothSignTooltip then
				boothSignTooltip:Destroy()
			end

			local boothSignTooltip2: ScreenGui = Instance.new("ScreenGui")

			boothSignTooltip2.Name = "BoothSignTooltip"
			boothSignTooltip2.ResetOnSpawn = false
			boothSignTooltip2.DisplayOrder = 6
			boothSignTooltip2.Enabled = true
			boothSignTooltip2.Parent = playerGui
			boothSignTooltip = boothSignTooltip2
		end

		local v100 = hoverInfoModule.create(boothSignTooltip, 1.8)

		t1.hover = v100

		return v100
	end

	return hover
end
local function renderSign(p20, p21, p22, p23, p24)
	local v106 = t1.tileHovers[p20]

	if v106 ~= nil then
		for _, v in ipairs(v106) do
			v.disconnect()
		end

		t1.tileHovers[p20] = nil
	end

	if t1.hover ~= nil then
		hoverInfoModule.hide(t1.hover)
	end

	if p22 == nil or p22.OwnerUserId == nil then
		local foundChild = getSurfacesGui():FindFirstChild(p20 .. "_" .. "Sign")

		if foundChild then
			foundChild:Destroy()
		end

		local v110 = t1.tileHovers[p20]

		if v110 == nil then
			return
		end

		for _, v in ipairs(v110) do
			v.disconnect()
		end

		t1.tileHovers[p20] = nil

		return
	end

	v106 = ensureGui(p20, p21, "Sign", 45, 120)

	local parent = boothTheme.SignRoot(v106, p23 or boothTheme.SIGN_ASPECT)

	v106 = p22.OwnerUserId == LocalPlayer.UserId

	local t2 = p22.Listings or {}

	if #t2 == 0 and not v106 then
		local v115 = UDim2.fromScale(1, 0.36)
		local v116 = UDim2.fromScale(0, 0.32)

		boothTheme.Label(parent, "Nothing listed yet!", v115, v116, nil).TextScaled = true

		return
	end

	local scrollingFrame: ScrollingFrame = Instance.new("ScrollingFrame")

	scrollingFrame.BackgroundTransparency = 1
	scrollingFrame.BorderSizePixel = 0
	scrollingFrame.Size = UDim2.fromScale(1, 0.94)
	scrollingFrame.Position = UDim2.fromScale(0, 0.03)
	scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
	scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.None
	scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollingFrame.ScrollBarThickness = 6
	scrollingFrame.ScrollBarImageTransparency = 0.35
	scrollingFrame.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
	scrollingFrame.ClipsDescendants = true
	scrollingFrame.Parent = parent

	local uiListLayout: UIListLayout = Instance.new("UIListLayout")

	uiListLayout.FillDirection = Enum.FillDirection.Horizontal
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	uiListLayout.Padding = UDim.new(0, 10)
	uiListLayout.Parent = scrollingFrame

	local uiPadding: UIPadding = Instance.new("UIPadding")

	uiPadding.PaddingLeft = UDim.new(0, 12)
	uiPadding.PaddingRight = UDim.new(0, 12)
	uiPadding.Parent = scrollingFrame

	local function fitCanvas()
		if scrollingFrame.Parent == nil then
			return
		end

		scrollingFrame.CanvasSize = UDim2.fromOffset(uiListLayout.AbsoluteContentSize.X + uiPadding.PaddingLeft.Offset + uiPadding.PaddingRight.Offset, 0)
	end

	uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fitCanvas)
	task.defer(fitCanvas)
	task.delay(0.15, fitCanvas)

	local u121 = v106

	if u121 then
		local v122 = boothClient.GetConfig() and tonumber(boothClient.GetConfig().MaxListings) or 8

		u121 = #t2 < v122
	end

	local v123 = p24 or 0.78

	local function squareHolder(layoutOrder)
		local frame: Frame = Instance.new("Frame")

		frame.BackgroundTransparency = 1
		frame.Size = UDim2.fromScale(0, v123)
		frame.LayoutOrder = layoutOrder

		local uiAspectRatioConstraint: UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

		uiAspectRatioConstraint.AspectRatio = 1
		uiAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize
		uiAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
		uiAspectRatioConstraint.Parent = frame
		frame.Parent = scrollingFrame

		return frame
	end

	for i = 1, #t2 do
		local v126 = t2[i]
		local t3 = v126.Meta or {}
		local v128 = if typeof(t3.Rarity) == "string" then t3.Rarity else "Common"
		local floored = math.floor(v126.Price or 0)
		local v130 = squareHolder(-floored)
		local v131, v132 = uiFramework.createItemCell(v128, {
			visible = true,
			active = true,
			interactable = true,
			selectable = false,
			icon = if typeof(t3.Icon) == "string" then t3.Icon else nil,
			name = "SignTile_" .. tostring(i),
			parent = v130
		})

		v131.Size = UDim2.fromScale(1, 1)
		v131.Position = UDim2.fromScale(0, 0)
		v131.AutoButtonColor = false

		local v133 = signHover()

		local v134 = hoverInfoModule.bind(v133, v131, function()
			return {
				Name = tostring(t3.Name or v126.ItemId),
				Rarity = v128,
				GlobalCopies = if typeof(t3.GlobalCopies) == "number" then t3.GlobalCopies else nil,
				Serial = if typeof(v126.Serial) == "number" then v126.Serial else nil,
				MaxSupply = if typeof(t3.MaxSupply) == "number" then t3.MaxSupply else nil,
				SourceButton = v131,
				FinisherName = if typeof(t3.FinisherName) == "string" then t3.FinisherName else nil,
				FinisherIcon = if typeof(t3.FinisherIcon) == "string" then t3.FinisherIcon else nil,
				FinisherRarity = if typeof(t3.FinisherRarity) == "string" then t3.FinisherRarity else nil,
				Kind = v126.Kind,
				ItemId = v126.ItemId,
				RAP = if typeof(t3.RAP) == "number" then t3.RAP else nil,
				RapConfidence = if typeof(t3.RapConfidence) == "string" then t3.RapConfidence else nil,
				RapProjected = t3.RapProjected == true,
				Note = boothTheme.StackNote(v126.Count, v126.Price),
				NoteIcon = if (v126.Count or 1) > 1 then boothTheme.TokenIcon() else nil
			}
		end)

		v131.Activated:Connect(function()
			if v134.tapConsumed() then
				return
			end

			u14:Fire({ BoothId = p22.Id, Lid = v126.Lid })
		end)
		v130 = t1.tileHovers[p20]

		if v130 == nil then
			v130 = {}
			t1.tileHovers[p20] = v130
		end

		table.insert(v130, v134)

		local v135 = boothTheme.PriceTag(v131, v126.Price or 0)

		v135.ZIndex = v131.ZIndex + 3

		if (v126.Count or 1) > 1 and v132.setStackCount then
			boothTheme.StackCount(v132, v131, v126.Count)
		end

		if v126.InFlight then
			local frame: Frame = Instance.new("Frame")

			frame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
			frame.BackgroundTransparency = 0.4
			frame.Size = UDim2.fromScale(1, 1)
			frame.ZIndex = v131.ZIndex + 4
			frame.Parent = v131
		end
	end

	if u121 then
		local v137 = squareHolder(1073741824)

		boothTheme.CreateTile(v137).Activated:Connect(function()
			u14:Fire({ Create = true, BoothId = p22.Id })
		end)
	end
end
local function ensurePrompt(_, parent)
	local proximityPrompt = parent:FindFirstChildOfClass("ProximityPrompt")

	if proximityPrompt == nil then
		proximityPrompt = Instance.new("ProximityPrompt")
		proximityPrompt.Name = "BoothPrompt"
		proximityPrompt.HoldDuration = 0
		proximityPrompt.MaxActivationDistance = 12
		proximityPrompt.RequiresLineOfSight = false
		proximityPrompt.Parent = parent
	end

	return proximityPrompt
end
local function applyVacancyLook(p28, _)
	for _, v in ipairs(p28:GetDescendants()) do
		if v:IsA("BasePart") then
			local boothBaseT = v:GetAttribute("BoothBaseT")

			if typeof(boothBaseT) ~= "number" then
				boothBaseT = v.Transparency
				v:SetAttribute("BoothBaseT", boothBaseT)
			end

			v.Transparency = boothBaseT
		end
	end
end
local function refreshStand(p30)
	local model = p30.model
	local promptAnchor = model:FindFirstChild("PromptAnchor")
	local signBoard = model:FindFirstChild("SignBoard")
	local namePlate = model:FindFirstChild("NamePlate")

	if not boothClient.IsEnabled() then
		p30.sig = nil

		if promptAnchor and promptAnchor:IsA("BasePart") then
			local proximityPrompt = promptAnchor:FindFirstChildOfClass("ProximityPrompt")

			if proximityPrompt then
				proximityPrompt:Destroy()
			end
		end

		local boothId = p30.boothId
		local foundChild = getSurfacesGui():FindFirstChild(boothId .. "_" .. "Sign")

		if foundChild then
			foundChild:Destroy()
		end

		local v154 = t1.tileHovers[boothId]

		if v154 ~= nil then
			for _, v in ipairs(v154) do
				v.disconnect()
			end

			t1.tileHovers[boothId] = nil
		end

		local v157 = p30.boothId
		local foundChild2 = getSurfacesGui():FindFirstChild(v157 .. "_" .. "NamePlate")

		if foundChild2 then
			foundChild2:Destroy()
		end

		applyVacancyLook(model, false)

		return
	end

	local v159 = boothClient.FindBooth(p30.boothId)
	local u160: boolean = true

	if v159 ~= nil then
		u160 = v159.OwnerUserId == nil
	end

	local v161 = boothClient.GetConfig()
	local v162 = boothClient.Signature(v159)
	local text: string = tostring(v161 and v161.MaxListings)
	local text2: string = tostring(u160)
	local text3: string = tostring(LocalPlayer.UserId)
	local s1: string = v162 .. "|" .. text .. "|" .. text2 .. "|" .. text3

	if p30.sig == s1 then
		return
	end

	p30.sig = s1
	applyVacancyLook(model, u160)

	if promptAnchor and promptAnchor:IsA("BasePart") then
		local proximityPrompt = promptAnchor:FindFirstChildOfClass("ProximityPrompt")

		if proximityPrompt == nil then
			proximityPrompt = Instance.new("ProximityPrompt")
			proximityPrompt.Name = "BoothPrompt"
			proximityPrompt.HoldDuration = 0
			proximityPrompt.MaxActivationDistance = 12
			proximityPrompt.RequiresLineOfSight = false
			proximityPrompt.Parent = promptAnchor
		end

		if u160 then
			proximityPrompt.ActionText = "Claim Booth!"
			proximityPrompt.ObjectText = "Vacant Booth"
		elseif v159.OwnerUserId == LocalPlayer.UserId then
			proximityPrompt.ActionText = "Edit Booth"
			proximityPrompt.ObjectText = "Your Booth"
		else
			proximityPrompt.ActionText = "Open Booth"
			proximityPrompt.ObjectText = tostring(v159.OwnerDisplayName or v159.OwnerName or "Someone") .. "'s Booth"
		end
	end

	if u160 then
		local v168 = p30.boothId
		local foundChild = getSurfacesGui():FindFirstChild(v168 .. "_" .. "Sign")

		if foundChild then
			foundChild:Destroy()
		end

		local v170 = t1.tileHovers[v168]

		if v170 ~= nil then
			for _, v in ipairs(v170) do
				v.disconnect()
			end

			t1.tileHovers[v168] = nil
		end

		local v173 = p30.boothId
		local foundChild3 = getSurfacesGui():FindFirstChild(v173 .. "_" .. "NamePlate")

		if foundChild3 then
			foundChild3:Destroy()
		end

		return
	end

	if signBoard and signBoard:IsA("BasePart") then
		renderSign(p30.boothId, signBoard, v159)
	end

	if namePlate and namePlate:IsA("BasePart") then
		renderNamePlate(p30.boothId, namePlate, v159)
	end
end
local function refreshAll()
	for _, v in pairs(t1.stands) do
		refreshStand(v)
	end
end
local function bindStand(p31)
	if not p31:IsA("Model") then
		return
	end

	local boothId = p31:GetAttribute("BoothId")

	if typeof(boothId) == "string" then
		local t4: {[any]: any} = {
			sig = nil,
			model = p31,
			boothId = boothId,
			conns = {}
		}

		t1.stands[boothId] = t4
		table.insert(t4.conns, p31.ChildAdded:Connect(function()
			t4.sig = nil
			task.defer(refreshStand, t4)
		end))
		table.insert(t4.conns, p31.ChildRemoved:Connect(function()
			t4.sig = nil
			task.defer(refreshStand, t4)
		end))
		refreshStand(t4)

		return
	end
end

for _, v in ipairs(booths:GetChildren()) do
	bindStand(v)
end

booths.ChildAdded:Connect(bindStand)
booths.ChildRemoved:Connect(function(p32: Instance)
	for k, v in pairs(t1.stands) do
		if p32 == v.model then
			for _, iterValue in ipairs(v.conns) do
				iterValue:Disconnect()
			end

			local foundChild = getSurfacesGui():FindFirstChild(k .. "_" .. "Sign")

			if foundChild then
				foundChild:Destroy()
			end

			local v186 = t1.tileHovers[k]

			if v186 ~= nil then
				for _, iterValue2 in ipairs(v186) do
					iterValue2.disconnect()
				end

				t1.tileHovers[k] = nil
			end

			local foundChild4 = getSurfacesGui():FindFirstChild(k .. "_" .. "NamePlate")

			if foundChild4 then
				foundChild4:Destroy()
			end

			t1.stands[k] = nil

			return
		end
	end
end)

local boothSignRender = bindables:FindFirstChild("BoothSignRender")

if boothSignRender == nil then
	local boothSignRender2: BindableFunction = Instance.new("BindableFunction")

	boothSignRender2.Name = "BoothSignRender"
	boothSignRender2.Parent = bindables
	boothSignRender = boothSignRender2
end

function boothSignRender.OnInvoke(p33, p34, p35, p36, p37, p38)
	if p33 == "Clear" then
		local foundChild = getSurfacesGui():FindFirstChild(p34 .. "_" .. "Sign")

		if foundChild then
			foundChild:Destroy()
		end

		local v197 = t1.tileHovers[p34]

		if v197 ~= nil then
			for _, v in ipairs(v197) do
				v.disconnect()
			end

			t1.tileHovers[p34] = nil
		end

		return true
	end

	if p33 == "Render" and p35 ~= nil and p35:IsA("BasePart") then
		local v200 = nil
		local v201 = boothClient.GetSnapshot()

		if typeof(v201) == "table" then
			for _, v in ipairs(v201) do
				if p36 == v.OwnerUserId then
					v200 = v

					break
				end
			end
		end

		if v200 == nil then
			local foundChild = getSurfacesGui():FindFirstChild(p34 .. "_" .. "Sign")

			if foundChild then
				foundChild:Destroy()
			end

			local v205 = t1.tileHovers[p34]

			if v205 ~= nil then
				for _, v in ipairs(v205) do
					v.disconnect()
				end

				t1.tileHovers[p34] = nil
			end

			return false
		end

		renderSign(p34, p35, v200, p37, p38)

		return true
	end

	return false
end

boothClient.Sale:Connect(function(p39, p40)
	local v210 = t1.stands[p39]

	if v210 == nil or v210.model.Parent == nil then
		return
	end

	boothSaleFX.Play(v210.model, p40)
end)

local universe = require(shared:WaitForChild("Universe"))
local boothSaleFXPreview = bindables:FindFirstChild("BoothSaleFXPreview")

if boothSaleFXPreview == nil then
	local boothSaleFXPreview2: BindableEvent = Instance.new("BindableEvent")

	boothSaleFXPreview2.Name = "BoothSaleFXPreview"
	boothSaleFXPreview2.Parent = bindables
	boothSaleFXPreview = boothSaleFXPreview2
end

boothSaleFXPreview.Event:Connect(function(p41)
	if not universe.IsDev() then
	elseif typeof(p41) == "table" then
		local boothId = p41.BoothId
		local v213 = if typeof(boothId) == "string" then t1.stands[boothId] else nil

		if v213 == nil then
			local Character: Model = LocalPlayer.Character
			local humanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			local v216 = nil

			for _, v in pairs(t1.stands) do
				local v219 = v.model.PrimaryPart or v.model:FindFirstChildWhichIsA("BasePart")

				if v219 then
					local v220 = if humanoidRootPart then (v219.Position - humanoidRootPart.Position).Magnitude else 0

					if v216 == nil or v216 > v220 then
						v216 = v220
						v213 = v
					end
				end
			end
		end

		if v213 == nil then
			return
		end

		local boothSaleFXPlay = boothSaleFX.Play
		local model = v213.model
		local numberValue: number? = tonumber(p41.Price)

		boothSaleFXPlay(model, numberValue or 0)

		return
	end
end)

local function boothIdOfPrompt(p42)
	local v225 = p42.Parent
	local v226 = v225 and v225.Parent

	if v226 and v226:IsA("Model") then
		local boothId = v226:GetAttribute("BoothId")

		if typeof(boothId) == "string" then
			return boothId
		end

		return nil
	end

	return nil
end
local function openAfterClaim(p43)
	local v229 = boothClient.FindBooth(p43)

	if v229 == nil or v229.OwnerUserId ~= LocalPlayer.UserId then
		return false
	end

	t1.pendingOpen = nil

	if #(v229.Listings or {}) == 0 then
		u14:Fire({ BoothId = p43 })
	end

	return true
end

proximityPromptService.PromptTriggered:Connect(function(prompt: ProximityPrompt, playerWhoTriggered: Player)
	if playerWhoTriggered ~= LocalPlayer then
	elseif prompt.Name == "BoothPrompt" then
		local promptParent: Instance = prompt.Parent
		local promptParentParent: Instance = promptParent and promptParent.Parent
		local v234

		if promptParentParent and promptParentParent:IsA("Model") then
			local boothId: any = promptParentParent:GetAttribute("BoothId")

			v234 = if typeof(boothId) == "string" then boothId else nil
		else
			v234 = nil
		end

		if v234 == nil then
			return
		end

		if boothClient.FindBooth(v234) == nil or boothClient.FindBooth(v234).OwnerUserId == nil then
			task.spawn(function()
				local v248, v249 = boothClient.Invoke("Claim", v234)

				if not v248 then
					local text: string = tostring(v249 or "Couldn't claim that booth.")
					local _GNotify = _G.Notify

					if typeof(_GNotify) == "function" then
						pcall(function()
							_GNotify({ notifType = "FailNotification", errorMessage = text })
						end)
					end

					return
				end

				t1.pendingOpen = v234
				openAfterClaim(v234)
			end)

			return
		end

		u14:Fire({ BoothId = v234 })

		return
	end
end)
boothClient.Changed:Connect(function()
	for _, v in pairs(t1.stands) do
		refreshStand(v)
	end

	local pendingOpen = t1.pendingOpen

	if pendingOpen ~= nil then
		openAfterClaim(pendingOpen)
	end
end)
LocalPlayer.CharacterAdded:Connect(function()
	for _, v in pairs(t1.stands) do
		v.sig = nil
	end

	task.defer(refreshAll)
end)
