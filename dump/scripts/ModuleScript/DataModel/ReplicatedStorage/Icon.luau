-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local userInputService: UserInputService = game:GetService("UserInputService")
local contentProvider: ContentProvider = game:GetService("ContentProvider")
local starterGui: StarterGui = game:GetService("StarterGui")
local players: Players = game:GetService("Players")

require(script.Types)

local v5 = script
local reference = require(v5.Reference)
local v7 = reference.getObject()
local v8 = v7 and v7.Value

if v8 and v8 ~= v5 then
	return (require(v8))
end

if not v7 then
	reference.addToReplicatedStorage()
end

local goodSignal = require(v5.Packages.GoodSignal)
local janitor = require(v5.Packages.Janitor)
local utility = require(v5.Utility)
local themes = require(v5.Features.Themes)
local gamepad = require(v5.Features.Gamepad)
local overflow = require(v5.Features.Overflow)
local module: {[any]: any} = {}

module.__index = module

local LocalPlayer: Player = players.LocalPlayer
local v17 = v5.Features.Themes
local t2: {[any]: any} = {}
local v19 = goodSignal.new()
local elements = v5.Elements
local n1: number = 0
local touch = Enum.PreferredInput.Touch
local keyboardAndMouse = Enum.PreferredInput.KeyboardAndMouse
local v24 = Enum.PreferredInput.Gamepad

module.baseDisplayOrderChanged = goodSignal.new()
module.baseDisplayOrder = 1000
module.baseTheme = require(v17.Default)
module.isOldTopbar = false
module.iconsDictionary = t2
module.insetHeightChanged = goodSignal.new()
module.container = require(elements.Container)(module)
module.topbarEnabled = true
module.iconAdded = goodSignal.new()
module.iconRemoved = goodSignal.new()
module.iconChanged = goodSignal.new()

function module.getIcons()
	return module.iconsDictionary
end
function module.getIconByUID(p1)
	local v27 = module.iconsDictionary[p1]

	if v27 then
		return v27
	end

	return nil
end
function module.getIcon(p2)
	local v29 = module.getIconByUID(p2)

	if v29 then
		return v29
	end

	for _, v in pairs(t2) do
		if p2 == v.name then
			return v
		end
	end

	return nil
end
function module.setTopbarEnabled(p3, p4)
	if typeof(p3) ~= "boolean" then
		p3 = module.topbarEnabled
	end

	if not p4 then
		module.topbarEnabled = p3
	end

	for _, v in pairs(module.container) do
		v.Enabled = p3
	end
end
function module.modifyBaseTheme(p5)
	local v37 = themes.getModifications(p5)

	for _, v in pairs(v37) do
		for _, iterValue in pairs(module.baseTheme) do
			themes.merge(iterValue, v)
		end
	end

	for _, v in pairs(t2) do
		v:setTheme(module.baseTheme)
	end
end
function module.setDisplayOrder(p6)
	module.baseDisplayOrder = p6
	module.baseDisplayOrderChanged:Fire(p6)
end

task.defer(gamepad.start, module)
task.defer(overflow.start, module)
task.defer(function()
	local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui")

	for _, v in pairs(module.container) do
		v.Parent = playerGui
	end

	require(v5.Attribute)
end)

local t3: {[any]: any} = { mobile = touch, desktop = keyboardAndMouse, console = v24 }

function module.new()
	local t4: {[any]: any} = {}

	setmetatable(t4, module)

	local v49 = janitor.new()

	t4.janitor = v49
	t4.themesJanitor = v49:add(janitor.new())
	t4.singleClickJanitor = v49:add(janitor.new())
	t4.captionJanitor = v49:add(janitor.new())
	t4.joinJanitor = v49:add(janitor.new())
	t4.menuJanitor = v49:add(janitor.new())
	t4.dropdownJanitor = v49:add(janitor.new())

	local uid = utility.generateUID()

	t2[uid] = t4
	v49:add(function()
		t2[uid] = nil
	end)
	t4.selected = v49:add(goodSignal.new())
	t4.deselected = v49:add(goodSignal.new())
	t4.toggled = v49:add(goodSignal.new())
	t4.viewingStarted = v49:add(goodSignal.new())
	t4.viewingEnded = v49:add(goodSignal.new())
	t4.stateChanged = v49:add(goodSignal.new())
	t4.notified = v49:add(goodSignal.new())
	t4.noticeStarted = v49:add(goodSignal.new())
	t4.noticeChanged = v49:add(goodSignal.new())
	t4.endNotices = v49:add(goodSignal.new())
	t4.toggleKeyAdded = v49:add(goodSignal.new())
	t4.fakeToggleKeyChanged = v49:add(goodSignal.new())
	t4.alignmentChanged = v49:add(goodSignal.new())
	t4.updateSize = v49:add(goodSignal.new())
	t4.resizingComplete = v49:add(goodSignal.new())
	t4.joinedParent = v49:add(goodSignal.new())
	t4.menuSet = v49:add(goodSignal.new())
	t4.dropdownSet = v49:add(goodSignal.new())
	t4.updateMenu = v49:add(goodSignal.new())
	t4.startMenuUpdate = v49:add(goodSignal.new())
	t4.childThemeModified = v49:add(goodSignal.new())
	t4.indicatorSet = v49:add(goodSignal.new())
	t4.dropdownChildAdded = v49:add(goodSignal.new())
	t4.menuChildAdded = v49:add(goodSignal.new())
	t4.iconModule = v5
	t4.UID = uid
	t4.isEnabled = true
	t4.enabled = t4.isEnabled
	t4.isSelected = false
	t4.isViewing = false
	t4.joinedFrame = false
	t4.parentIconUID = false
	t4.deselectWhenOtherIconSelected = true
	t4.totalNotices = 0
	t4.activeState = "Deselected"
	t4.alignment = ""
	t4.originalAlignment = ""
	t4.appliedTheme = {}
	t4.appearance = {}
	t4.cachedInstances = {}
	t4.cachedNamesToInstances = {}
	t4.cachedCollectives = {}
	t4.bindedToggleKeys = {}
	t4.customBehaviours = {}
	t4.toggleItems = {}
	t4.bindedEvents = {}
	t4.notices = {}
	t4.menuIcons = {}
	t4.dropdownIcons = {}
	t4.childIconsDict = {}
	t4.creationTime = os.clock()

	local widget = require(elements.Widget)

	t4.widget = v49:add(widget(t4, module))
	t4:setAlignment()
	n1 += 1

	local n4 = n1 * 0.01 + 1

	t4:setOrder(n4, "deselected")
	t4:setOrder(n4, "selected")
	t4:setTheme(module.baseTheme)
	n4 = t4:getInstance("ClickRegion")

	local u53: boolean = false
	local n2 = 0

	local function handleToggle()
		if t4.locked then
			return
		end

		local timestamp = tick()

		if timestamp - n2 < 0.1 then
			return
		end

		n2 = timestamp

		if t4.isSelected then
			t4:deselect("User", t4)

			return
		end

		t4:select("User", t4)
	end

	n4.MouseButton1Click:Connect(function()
		u53 = true

		if t4.locked then
			return
		end

		local timestamp = tick()

		if timestamp - n2 < 0.1 then
			return
		end

		n2 = timestamp

		if t4.isSelected then
			t4:deselect("User", t4)

			return
		end

		t4:select("User", t4)
	end)
	n4.TouchTap:Connect(function()
		if u53 then
			return
		end

		if t4.locked then
			return
		end

		local timestamp = tick()

		if timestamp - n2 < 0.1 then
			return
		end

		n2 = timestamp

		if t4.isSelected then
			t4:deselect("User", t4)

			return
		end

		t4:select("User", t4)
	end)
	v49:add(userInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
		if t4.locked then
			return
		end

		if not t4.bindedToggleKeys[input.KeyCode] or gameProcessedEvent then
			return
		end

		if t4.locked then
			return
		end

		local timestamp = tick()

		if timestamp - n2 < 0.1 then
			return
		end

		n2 = timestamp

		if t4.isSelected then
			t4:deselect("User", t4)

			return
		end

		t4:select("User", t4)
	end))

	local function viewingEnded()
		if t4.locked then
			return
		end

		t4.isViewing = false
		t4.viewingEnded:Fire(true)
		t4:setState(nil, "User", t4)
	end

	t4.joinedParent:Connect(function()
		if not t4.isViewing then
			return
		end

		if t4.locked then
			return
		end

		t4.isViewing = false
		t4.viewingEnded:Fire(true)
		t4:setState(nil, "User", t4)
	end)
	n4.MouseEnter:Connect(function()
		local u275: boolean = userInputService.PreferredInput ~= t3.desktop

		if t4.locked then
			return
		end

		t4.isViewing = true
		t4.viewingStarted:Fire(true)

		if not u275 then
			t4:setState("Viewing", "User", t4)
		end
	end)

	local n3: number = 0

	v49:add(userInputService.TouchEnded:Connect(viewingEnded))
	n4.MouseLeave:Connect(viewingEnded)
	n4.SelectionGained:Connect(function(p9)
		if t4.locked then
			return
		end

		t4.isViewing = true
		t4.viewingStarted:Fire(true)

		if not p9 then
			t4:setState("Viewing", "User", t4)
		end
	end)
	n4.SelectionLost:Connect(viewingEnded)
	n4.MouseButton1Down:Connect(function()
		if not t4.locked and userInputService.PreferredInput == t3.mobile then
			n3 += 1

			local v277: number = n3

			task.delay(0.2, function()
				if v277 ~= n3 then
					return
				end

				if t4.locked then
					return
				end

				t4.isViewing = true
				t4.viewingStarted:Fire(true)
				t4:setState("Viewing", "User", t4)
			end)
		end
	end)
	n4.MouseButton1Up:Connect(function()
		n3 += 1
	end)

	local v58 = t4:getInstance("IconOverlay")

	t4.viewingStarted:Connect(function()
		v58.Visible = not t4.overlayDisabled
	end)
	t4.viewingEnded:Connect(function()
		v58.Visible = false
	end)
	v49:add(v19:Connect(function(p10)
		if p10 ~= t4 and t4.deselectWhenOtherIconSelected and p10.deselectWhenOtherIconSelected then
			t4:deselect("AutoDeselect", p10)
		end
	end))

	local v59 = debug.info(2, "s")

	v59 = string.split(v59, ".")
	v49 = game

	local v60 = nil

	for _, v in pairs(v59) do
		v49 = v49:FindFirstChild(v)

		if not v49 then
			break
		end

		if v49:IsA("ScreenGui") then
			v60 = v49
		end
	end

	if v49 and v60 and v60.ResetOnSpawn == true then
		t4.originsScreenGui = v60
		utility.localPlayerRespawned(function()
			t4:destroy()
		end)
	end

	t4.toggled:Connect(function(p11)
		t4.noticeChanged:Fire(t4.totalNotices)

		for k, _ in pairs(t4.childIconsDict) do
			local v282 = module.getIconByUID(k)

			v282.noticeChanged:Fire(v282.totalNotices)

			if not p11 and v282.isSelected then
				for _, _ in pairs(v282.childIconsDict) do
					v282:deselect("HideParentFeature", t4)
				end
			end
		end
	end)
	t4.selected:Connect(function()
		if #t4.dropdownIcons > 0 then
			if starterGui:GetCore("ChatActive") and t4.alignment ~= "Right" then
				t4.chatWasPreviouslyActive = true
				starterGui:SetCore("ChatActive", false)
			end

			if starterGui:GetCoreGuiEnabled("PlayerList") and t4.alignment ~= "Left" then
				t4.playerlistWasPreviouslyActive = true
				starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
			end
		end
	end)
	t4.deselected:Connect(function()
		if t4.chatWasPreviouslyActive then
			t4.chatWasPreviouslyActive = nil
			starterGui:SetCore("ChatActive", true)
		end

		if t4.playerlistWasPreviouslyActive then
			t4.playerlistWasPreviouslyActive = nil
			starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
		end
	end)
	task.delay(0.1, function()
		if t4.activeState == "Deselected" then
			t4.stateChanged:Fire("Deselected")
			t4:refresh()
		end
	end)
	module.iconAdded:Fire(t4)

	return t4
end
function module.setName(p12, name)
	p12.widget.Name = name
	p12.name = name

	return p12
end
function module.setState(p14, p15: string, p16, p17)
	if not p15 then
		p15 = if p14.isSelected then "Selected" else "Deselected"
	end

	local v69 = utility.formatStateName(p15)

	if p14.activeState == v69 then
		return
	end

	local isSelected = p14.isSelected

	p14.activeState = v69

	if v69 == "Deselected" then
		p14.isSelected = false

		if isSelected then
			p14.toggled:Fire(false, p16, p17)
			p14.deselected:Fire(p16, p17)
		end

		p14:_setToggleItemsVisible(false, p16, p17)
	elseif v69 == "Selected" then
		p14.isSelected = true

		if not isSelected then
			p14.toggled:Fire(true, p16, p17)
			p14.selected:Fire(p16, p17)
			v19:Fire(p14, p16, p17)
		end

		p14:_setToggleItemsVisible(true, p16, p17)
	end

	p14.stateChanged:Fire(v69, p16, p17)
end
function module.getInstance(p18, p19)
	local v73 = p18.cachedNamesToInstances[p19]

	if v73 then
		return v73
	end

	local function cacheInstance(p20, p21)
		if not p18.cachedInstances[p21] then
			local collective = p21:GetAttribute("Collective")
			local v288 = collective and p18.cachedCollectives[collective]

			if v288 then
				table.insert(v288, p21)
			end

			p18.cachedNamesToInstances[p20] = p21
			p18.cachedInstances[p21] = true
			p21.Destroying:Once(function()
				p18.cachedNamesToInstances[p20] = nil
				p18.cachedInstances[p21] = nil
			end)
		end
	end

	local widget = p18.widget

	cacheInstance("Widget", widget)

	if p19 == "Widget" then
		return widget
	end

	local u76 = nil

	local function scanChildren(p22)
		for _, v in pairs(p22:GetChildren()) do
			local widgetUID = v:GetAttribute("WidgetUID")

			if not widgetUID or widgetUID == p18.UID then
				local v293 = themes.getRealInstance(v)

				if v293 then
					v = v293
				end

				scanChildren(v)

				if v:IsA("GuiBase") or v:IsA("UIBase") or v:IsA("ValueBase") then
					local vName = v.Name

					cacheInstance(vName, v)

					if vName == p19 then
						u76 = v
					end
				end
			end
		end
	end

	scanChildren(widget)

	return u76
end
function module.getCollective(p23, p24)
	local v80 = p23.cachedCollectives[p24]

	if v80 then
		return v80
	end

	v80 = {}

	for k, _ in pairs(p23.cachedInstances) do
		local collective = k:GetAttribute("Collective")

		if p24 == collective then
			table.insert(v80, k)
		end
	end

	p23.cachedCollectives[p24] = v80

	return v80
end
function module.getInstanceOrCollective(p25, p26)
	local t5 = {}
	local v87 = p25:getInstance(p26)

	if v87 then
		table.insert(t5, v87)
	end

	if #t5 == 0 then
		t5 = p25:getCollective(p26)
	end

	return t5
end
function module.getStateGroup(p27, p28)
	local v90 = p28 or p27.activeState
	local t6 = p27.appearance[v90]

	if not t6 then
		t6 = {}
		p27.appearance[v90] = t6
	end

	return t6
end
function module.refreshAppearance(p29, p30, p31)
	themes.refresh(p29, p30, p31)

	return p29
end
function module.refresh(p32)
	p32:refreshAppearance(p32.widget)
	p32.updateSize:Fire()

	return p32
end
function module.updateParent(p33)
	local v97 = module.getIconByUID(p33.parentIconUID)

	if v97 then
		v97.updateSize:Fire()
	end
end
function module.setBehaviour(p34, p35, p36, p37, p38)
	p34.customBehaviours[p35 .. "-" .. p36] = p37

	if p38 then
		local v103 = p34:getInstanceOrCollective(p35)

		for _, v in pairs(v103) do
			p34:refreshAppearance(v, p36)
		end
	end
end
function module.modifyTheme(p39, p40, p41)
	local v109 = themes.modify(p39, p40, p41)

	return p39, v109
end
function module.modifyChildTheme(p42, p43, p44)
	p42.childModifications = p43
	p42.childModificationsUID = p44

	for k, _ in pairs(p42.childIconsDict) do
		module.getIconByUID(k):modifyTheme(p43, p44)
	end

	p42.childThemeModified:Fire()

	return p42
end
function module.removeModification(p45, p46)
	themes.remove(p45, p46)

	return p45
end
function module.removeModificationWith(p47, p48, p49, p50)
	themes.removeWith(p47, p48, p49, p50)

	return p47
end
function module.setTheme(p51, p52)
	themes.set(p51, p52)

	return p51
end
function module.setEnabled(p53, p54)
	p53.isEnabled = p54
	p53.enabled = p53.isEnabled
	p53.widget.Visible = p54
	p53:updateParent()

	return p53
end
function module.select(p55, p56, p57)
	p55:setState("Selected", p56, p57)

	return p55
end
function module.deselect(p58, p59, p60)
	p58:setState("Deselected", p59, p60)

	return p58
end
function module.notify(p61, p62, p63)
	if not p61.notice then
		p61.notice = require(elements.Notice)(p61, module)
	end

	p61.noticeStarted:Fire(p62, p63)

	return p61
end
function module.clearNotices(p64)
	p64.endNotices:Fire()

	return p64
end
function module.disableOverlay(p65, p66)
	p65.overlayDisabled = p66

	return p65
end

module.disableStateOverlay = module.disableOverlay

function module.setImage(p67, p68, p69)
	p67:modifyTheme({ "IconImage", "Image", p68, p69 })
	task.spawn(function()
		local v295 = if tonumber(p68) then ("rbxassetid://%*"):format(p68) else p68

		if contentProvider:GetAssetFetchStatus(v295) ~= Enum.AssetFetchStatus.Success then
			pcall(contentProvider.PreloadAsync, contentProvider, { v295 })
		end
	end)

	return p67
end
function module.setLabel(p70, p71, p72)
	p70:modifyTheme({ "IconLabel", "Text", p71, p72 })

	return p70
end
function module.setOrder(p73, p74, p75)
	local n1 = p74 * 100

	p73:modifyTheme({ "IconSpot", "LayoutOrder", n1, p75 })
	p73:modifyTheme({ "Widget", "LayoutOrder", n1, p75 })

	return p73
end
function module.setCornerRadius(p76, p77, p78)
	p76:modifyTheme({ "IconCorners", "CornerRadius", p77, p78 })

	return p76
end
function module.align(p79, p80, p81)
	local lowerText = tostring(p80):lower()

	if lowerText == "mid" or lowerText == "centre" then
		lowerText = "center"
	end

	if lowerText ~= "left" and lowerText ~= "center" and lowerText ~= "right" then
		lowerText = "left"
	end

	local v154 = lowerText == "center" and module.container.TopbarCentered or module.container.TopbarStandard
	local holders = v154.Holders
	local stringUpper = string.upper
	local v157 = string.sub(lowerText, 1, 1)
	local v158 = stringUpper(v157)

	v157 = string.sub(lowerText, 2)

	local s1: string = v158 .. v157

	if not p81 then
		p79.originalAlignment = s1
	end

	local joinedFrame = p79.joinedFrame

	v158 = holders[s1]
	p79.screenGui = v154
	p79.alignmentHolder = v158

	if not p79.isDestroyed then
		p79.widget.Parent = joinedFrame or v158
	end

	p79.alignment = s1
	p79.alignmentChanged:Fire(s1)
	module.iconChanged:Fire(p79)

	return p79
end

module.setAlignment = module.align

function module.setLeft(p82)
	p82:setAlignment("Left")

	return p82
end
function module.setMid(p83)
	p83:setAlignment("Center")

	return p83
end
function module.setRight(p84)
	p84:setAlignment("Right")

	return p84
end
function module.setWidth(p85, p86, p87)
	p85:modifyTheme({ "Widget", "DesiredWidth", p86, p87 })

	return p85
end
function module.setImageScale(p88, p89, p90)
	p88:modifyTheme({ "IconImageScale", "Value", p89, p90 })

	return p88
end
function module.setImageRatio(p91, p92, p93)
	p91:modifyTheme({ "IconImageRatio", "AspectRatio", p92, p93 })

	return p91
end
function module.setTextSize(p94, p95, p96)
	p94:modifyTheme({ "IconLabel", "TextSize", p95, p96 })

	return p94
end
function module.setTextFont(p97, p98, p99, p100, p101)
	local v181 = p99 or Enum.FontWeight.Regular
	local v182 = p100 or Enum.FontStyle.Normal
	local v183 = nil
	local typeName: string = typeof(p98)

	if typeName == "number" then
		v183 = Font.fromId(p98, v181, v182)
	elseif typeName == "EnumItem" then
		v183 = Font.fromEnum(p98)
	elseif typeName == "string" and not p98:match("rbxasset") then
		v183 = Font.fromName(p98, v181, v182)
	end

	if not v183 then
		v183 = Font.new(p98, v181, v182)
	end

	p97:modifyTheme({ "IconLabel", "FontFace", v183, p101 })

	return p97
end
function module.setTextColor(p102, p103, p104)
	if p103 == nil or p103 == "" or type(p103) ~= "userdata" or typeof(p103) ~= "Color3" then
		if p103 ~= nil and p103 ~= "" then
			warn("setTextColor item must be a Color3 value! Changed the color to white.")
		end

		p103 = Color3.fromRGB(255, 255, 255)
	end

	p102:modifyTheme({ "IconLabel", "TextColor3", p103, p104 })

	return p102
end
function module.bindToggleItem(p105, p106)
	if not p106:IsA("GuiObject") and not p106:IsA("LayerCollector") then
		error("Toggle item must be a GuiObject or LayerCollector!")
	end

	p105.toggleItems[p106] = true
	p105:_updateSelectionInstances()

	return p105
end
function module.unbindToggleItem(p107, p108)
	p107.toggleItems[p108] = nil
	p107:_updateSelectionInstances()

	return p107
end
function module._updateSelectionInstances(p109)
	for k, _ in pairs(p109.toggleItems) do
		local t7: {[any]: any} = {}

		for _, v in pairs(k:GetDescendants()) do
			if (v:IsA("TextButton") or v:IsA("ImageButton")) and v.Active then
				table.insert(t7, v)
			end
		end

		p109.toggleItems[k] = t7
	end
end
function module._setToggleItemsVisible(p110, p111, _, p113)
	for k, _ in pairs(p110.toggleItems) do
		if not p113 or p113 == p110 or p113.toggleItems[k] == nil then
			local s1: string = "Visible"

			if k:IsA("LayerCollector") then
				s1 = "Enabled"
			end

			k[s1] = p111
		end
	end
end
function module.bindEvent(p114, p115, p116)
	local v208 = p114[p115]
	local v209 = v208

	if v209 then
		v209 = false

		if typeof(v208) == "table" then
			v209 = v208.Connect
		end
	end

	assert(v209, "argument[1] must be a valid topbarplus icon event name!")

	local typeName: string = typeof(p116)

	assert(typeName == "function", "argument[2] must be a function!")
	p114.bindedEvents[p115] = v208:Connect(function(...)
		p116(p114, ...)
	end)

	return p114
end
function module.unbindEvent(p117, p118)
	local v213 = p117.bindedEvents[p118]

	if v213 then
		v213:Disconnect()
		p117.bindedEvents[p118] = nil
	end

	return p117
end
function module.bindToggleKey(p119, p120)
	local typeName: string = typeof(p120)

	assert(typeName == "EnumItem", "argument[1] must be a KeyCode EnumItem!")
	p119.bindedToggleKeys[p120] = true
	p119.toggleKeyAdded:Fire(p120)
	p119:setCaption("_hotkey_")

	return p119
end
function module.unbindToggleKey(p121, p122)
	local typeName: string = typeof(p122)

	assert(typeName == "EnumItem", "argument[1] must be a KeyCode EnumItem!")
	p121.bindedToggleKeys[p122] = nil

	return p121
end
function module.call(p123, p124, ...)
	local v222 = table.pack(...)

	task.spawn(function()
		p124(p123, table.unpack(v222))
	end)

	return p123
end
function module.addToJanitor(p125, p126, p127, p128)
	p125.janitor:add(p126, p127, p128)

	return p125
end
function module.lock(p129)
	p129:getInstance("ClickRegion").Visible = false
	p129.locked = true

	return p129
end
function module.unlock(p130)
	p130:getInstance("ClickRegion").Visible = true
	p130.locked = false

	return p130
end
function module.debounce(p131, p132)
	p131:lock()
	task.wait(p132)
	p131:unlock()

	return p131
end
function module.autoDeselect(p133, p134: boolean)
	if p134 == nil then
		p134 = true
	end

	p133.deselectWhenOtherIconSelected = p134

	return p133
end
function module.oneClick(p135, p136)
	local singleClickJanitor = p135.singleClickJanitor

	singleClickJanitor:clean()

	if p136 or p136 == nil then
		singleClickJanitor:add(p135.selected:Connect(function()
			p135:deselect("OneClick", p135)
		end))
	end

	p135.oneClickEnabled = true

	return p135
end
function module.setCaption(p137, p138)
	if p138 == "_hotkey_" and p137.captionText then
		return p137
	end

	local captionJanitor = p137.captionJanitor

	p137.captionJanitor:clean()

	if p138 and p138 ~= "" then
		local caption = require(elements.Caption)
		local v240 = captionJanitor:add(caption(p137))

		v240:SetAttribute("CaptionText", p138)
		p137.caption = v240
		p137.captionText = p138

		return p137
	end

	p137.caption = nil
	p137.captionText = nil

	return p137
end
function module.setCaptionHint(p139, p140)
	local typeName: string = typeof(p140)

	assert(typeName == "EnumItem", "argument[1] must be a KeyCode EnumItem!")
	p139.fakeToggleKey = p140
	p139.fakeToggleKeyChanged:Fire(p140)
	p139:setCaption("_hotkey_")

	return p139
end
function module.leave(p141)
	p141.joinJanitor:clean()

	return p141
end
function module.joinMenu(p142, p143)
	utility.joinFeature(p142, p143, p143.menuIcons, p143:getInstance("Menu"))
	p143.menuChildAdded:Fire(p142)

	return p142
end
function module.setMenu(p144, p145)
	p144.menuSet:Fire(p145)

	return p144
end
function module.setFixedMenu(p146, p147)
	p146:freezeMenu(p147)
	p146:setMenu(p147)
end

module.setFrozenMenu = module.setFixedMenu

function module.freezeMenu(p148)
	p148:select("FrozenMenu", p148)
	p148:bindEvent("deselected", function(p149)
		p149:select("FrozenMenu", p148)
	end)
	p148:modifyTheme({ "IconSpot", "Visible", false })
end
function module.joinDropdown(p150, p151)
	p151:getDropdown()
	utility.joinFeature(p150, p151, p151.dropdownIcons, p151:getInstance("DropdownScroller"))
	p151.dropdownChildAdded:Fire(p150)

	return p150
end
function module.getDropdown(p152)
	local v255 = p152.dropdown

	if not v255 then
		v255 = require(elements.Dropdown)(p152)
		p152.dropdown = v255
		p152:clipOutside(v255)
	end

	return v255
end
function module.setDropdown(p153, p154)
	p153:getDropdown()
	p153.dropdownSet:Fire(p154)

	return p153
end
function module.clipOutside(p155, p156)
	local v260 = utility.clipOutside(p155, p156)

	p155:refreshAppearance(p156)

	return p155, v260
end
function module.setIndicator(p157, p158)
	if not p157.indicator then
		local janitor = p157.janitor
		local indicator = require(elements.Indicator)

		p157.indicator = janitor:add(indicator(p157, module))
	end

	p157.indicatorSet:Fire(p158)
end
function module.convertLabelToNumberSpinner(p159, p160, p161)
	task.defer(function()
		local v297 = p159:getInstance("IconLabel")

		v297.Transparency = 1
		p160.Parent = v297.Parent
		p160.Size = UDim2.fromScale(1, 1)
		p160.AnchorPoint = Vector2.new(0.5, 0.5)
		p160.Position = UDim2.new(0.5, 0, 0.5, 0)
		p160.TextXAlignment = Enum.TextXAlignment.Center
		p160.ClipsDescendants = false

		for _, v in ipairs({
			"FontFace",
			"BorderSizePixel",
			"BorderColor3",
			"Rotation",
			"TextStrokeTransparency",
			"TextStrokeColor3",
			"TextStrokeTransparency",
			"TextColor3"
		}) do
			p160[v] = v297[v]

			local v300 = v297:GetPropertyChangedSignal(v)

			p159:addToJanitor(v300:Connect(function()
				p160[v] = v297[v]
			end))
		end

		local function getSpinnerSizeAndDigitCount()
			local n1 = 0
			local n2: number = 0

			for iterFirst, iterSecond in p160.Frame:GetChildren() do
				local lowerText = string.lower(iterSecond.Name)

				if lowerText == "digit" or (lowerText == "prefix" or lowerText == "suffix" or lowerText == "comma") and iterSecond.Text ~= "" then
					n1 += iterSecond.AbsoluteSize.X
					n2 += 1
				end
			end

			return n1, n2
		end
		local function getLabelParentContainerXSize()
			local v310 = v297.Parent
			local v311 = v310 and v310.Parent

			if v311 == nil then
				return 0
			end

			if v311.IconImage.Visible == true then
				return p160.Frame.AbsoluteSize.X + v297.Parent.Parent.IconImage.AbsoluteSize.X
			end

			return v311.AbsoluteSize.X
		end
		local function getNumberSpinnerXSize()
			return p160.Frame.AbsoluteSize.X
		end
		local function adjustSize()
			local v312, v313 = getSpinnerSizeAndDigitCount()

			if v313 < 18 then
				p159:setLabel(p160.Value)
			end

			local v314 = p160.Frame.AbsoluteSize.X

			while v312 < v314 and p159.isDestroyed ~= true do
				task.wait(0.05)

				if v313 > 0 and v313 < 8 then
					p160.TextSize = v297.TextSize

					break
				end

				local v315 = p160

				v315.TextSize = v315.TextSize + 1
				v314 = p160.Frame.AbsoluteSize.X

				local v316, v317 = getSpinnerSizeAndDigitCount()

				v312 = v316
				v313 = v317
			end

			local v318 = v297.Parent
			local v319 = v318 and v318.Parent
			local n1 = if v319 == nil then 0 else if v319.IconImage.Visible == true then p160.Frame.AbsoluteSize.X + v297.Parent.Parent.IconImage.AbsoluteSize.X else v319.AbsoluteSize.X

			while v312 > n1 and p159.isDestroyed ~= true do
				task.wait(0.05)

				if v313 < 8 and v313 > 0 then
					p160.TextSize = v297.TextSize

					return
				end

				local v321 = p160

				v321.TextSize = v321.TextSize - 1
				v321 = v297.Parent

				local v322 = v321 and v321.Parent

				n1 = if v322 == nil then 0 else if v322.IconImage.Visible == true then p160.Frame.AbsoluteSize.X + v297.Parent.Parent.IconImage.AbsoluteSize.X else v322.AbsoluteSize.X

				local v323, v324 = getSpinnerSizeAndDigitCount()

				v312 = v323
				v313 = v324
			end
		end

		p159:addToJanitor(p160.Frame.ChildAdded:Connect(adjustSize))
		p159:addToJanitor(p160.Frame.ChildRemoved:Connect(adjustSize))
		p159:addToJanitor(p159.iconAdded:Connect(function()
			task.wait(1)
			adjustSize()
		end))
		p159:updateParent()
		p160.Name = "LabelSpinner"
		p160.Prefix = "$"
		p160.Commas = true
		p160.Decimals = 0
		p160.Duration = 0.25
		p160.Value = 10
		task.wait(0.2)

		if typeof(p161) == "function" then
			p161()
		end
	end)

	return p159
end
function module.destroy(p162)
	if p162.isDestroyed then
		return
	end

	p162:clearNotices()

	if p162.parentIconUID then
		p162:leave()
	end

	p162.isDestroyed = true
	p162.janitor:clean()
	module.iconRemoved:Fire(p162)
end

module.Destroy = module.destroy

return module
