-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local userInputService: UserInputService = game:GetService("UserInputService")
local guiService: GuiService = game:GetService("GuiService")
local tweenService: TweenService = game:GetService("TweenService")
local LocalPlayer: Player = players.LocalPlayer
local catalogs: Instance = replicatedStorage:WaitForChild("Catalogs")
local abilityCatalog = require(catalogs:WaitForChild("AbilityCatalog"))
local uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local abilities_Request: Instance = remotes:WaitForChild("Abilities_Request")
local abilities_Push: Instance = remotes:WaitForChild("Abilities_Push")
local showChangeAbilities: Instance = replicatedStorage:WaitForChild("Bindables"):WaitForChild("ShowChangeAbilities")
local extensions: Instance = replicatedStorage:WaitForChild("Extensions")
local gamepadBindings = require(extensions:WaitForChild("GamepadBindings"))
local replicatedStorageExtensions: Instance = replicatedStorage:WaitForChild("Extensions")
local inputCategorizer = require(replicatedStorageExtensions:WaitForChild("InputCategorizer"))
local v18: Instance = replicatedStorage:WaitForChild("Extensions")
local inputMap = require(v18:WaitForChild("InputMap"))
local u20 = nil
local t1: {[any]: any} = {}
local t2: {[any]: any} = { ["1"] = nil, ["2"] = nil }
local u23 = nil
local t3: {[any]: any} = { ["1"] = false, ["2"] = false, Character = false }
local t4: {[any]: any} = {}
local t5: {[any]: any} = {}
local t6: {[any]: any} = {}
local u28: boolean = false
local Id = nil
local u30 = nil
local u31 = nil
local scriptParent: Instance = script.Parent
local blackBackground: Instance = scriptParent.Parent:WaitForChild("BlackBackground")
local holder: Instance = scriptParent:WaitForChild("Holder")
local openBtn: Instance = scriptParent:WaitForChild("OpenBtn")
local knifeRow: Instance = holder:WaitForChild("KnifeRow")
local gunRow: Instance = holder:WaitForChild("GunRow")
local characterRow: Instance = holder:WaitForChild("CharacterRow")
local abilities: Instance = knifeRow:WaitForChild("Abilities")
local gunRowAbilities: Instance = gunRow:WaitForChild("Abilities")
local characterRowAbilities: Instance = characterRow:WaitForChild("Abilities")

for _, v in ipairs({
	{ actions = "CastAbility1", row = knifeRow },
	{ actions = "CastAbility2", row = gunRow },
	{
		row = characterRow,
		actions = { "CastAbility1", "CastAbility2" }
	}
}) do
	local folder = v.row:FindFirstChild("Folder")
	local folderKeybind = folder and folder:FindFirstChild("Keybind")

	if folderKeybind and folderKeybind:IsA("GuiObject") then
		uiFramework.bindKeybindLabel(folderKeybind, v.actions)
	end
end

local slots: Instance = scriptParent:WaitForChild("Slots")
local qSlot = slots:WaitForChild("QSlot")
local eSlot = slots:WaitForChild("ESlot")
local icon = qSlot:FindFirstChild("Icon")
local icon2 = eSlot:FindFirstChild("Icon")
local select2Skills: Instance = scriptParent:WaitForChild("Select2Skills")
local skillsCount: Instance = select2Skills:WaitForChild("SkillsCount")
local number: Instance = skillsCount:WaitForChild("Number")
local clone: Instance = number:Clone()
local u55 = nil
local n1 = 2

local function resetSkillsNumber()
	if u55 then
		task.cancel(u55)
		u55 = nil
	end

	for _, v in ipairs(skillsCount:GetChildren()) do
		if v:IsA("TextLabel") then
			v:Destroy()
		end
	end

	local clone2: Instance = clone:Clone()

	clone2.Text = "2"
	clone2.Position = UDim2.new(0.5, 0, 0.5, 0)
	clone2.Parent = skillsCount
	number = clone2
	n1 = 2
end
local function animateNumberChange(p1)
	if p1 == n1 then
		return
	end

	n1 = p1

	if u55 then
		task.cancel(u55)
		u55 = nil
	end

	for _, v in ipairs(skillsCount:GetChildren()) do
		if v:IsA("TextLabel") and v ~= number then
			v:Destroy()
		end
	end

	u55 = task.spawn(function()
		local v316: Instance = number
		local clone3: Instance = v316:Clone()

		clone3.Text = tostring(p1)
		clone3.Position = UDim2.new(0.5, 0, -0.5, 0)
		clone3.Parent = skillsCount

		local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

		tweenService:Create(v316, tweenInfo, { Position = UDim2.new(0.5, 0, 1.5, 0) }):Play()

		local v319: Tween = tweenService:Create(clone3, tweenInfo, { Position = UDim2.new(0.5, 0, 0.5, 0) })

		v319:Play()
		v319.Completed:Wait()
		v316:Destroy()
		clone3.Name = "Number"
		number = clone3
		u55 = nil
	end)
end

scriptParent.Visible = false
openBtn.Visible = false
holder.Visible = false
slots.Visible = false
select2Skills.Visible = false

for _, v in ipairs({ abilities, gunRowAbilities, characterRowAbilities }) do
	for _, iterValue in ipairs(v:GetChildren()) do
		if iterValue:IsA("ImageButton") then
			iterValue:Destroy()
		end
	end
end

local function getMyMatchId()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")

	if typeof(matchId) == "string" then
		return matchId
	end

	return nil
end
local function isPractice()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")

	return (if typeof(matchId) == "string" then matchId else nil) == "PRACTICE"
end
local function isMMWarmup()
	return LocalPlayer:GetAttribute("MMWarmup") == true
end

local u66 = false

local function setMouseUnlocked(p2)
	if p2 == u66 then
		return
	end

	u66 = p2

	local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

	LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) + (if p2 then 1 else -1))
end

local u68 = false

local function setOpenButtonWanted(p3)
	u68 = p3

	local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
	local u140: boolean = false

	if typeof(mouseUnlocked) == "number" then
		u140 = mouseUnlocked > 0
	end

	openBtn.Visible = u68 and not u140
end

LocalPlayer:GetAttributeChangedSignal("MouseUnlocked"):Connect(function()
	local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
	local u142: boolean = false

	if typeof(mouseUnlocked) == "number" then
		u142 = mouseUnlocked > 0
	end

	openBtn.Visible = u68 and not u142
end)

local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local tweenInfo3 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo4 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local u74 = nil
local u75 = nil
local u76 = nil
local u77 = nil
local u78 = nil

local function showBlackBG()
	blackBackground.BackgroundTransparency = 1
	blackBackground.Visible = true

	if u74 then
		u74:Cancel()
	end

	u74 = tweenService:Create(blackBackground, tweenInfo, { BackgroundTransparency = 0.15 })
	u74:Play()
end
local function hideBlackBG(p4)
	if p4 then
		blackBackground.Visible = false
		blackBackground.BackgroundTransparency = 1

		return
	end

	if u74 then
		u74:Cancel()
	end

	u74 = tweenService:Create(blackBackground, tweenInfo2, { BackgroundTransparency = 1 })
	u74:Play()
	u74.Completed:Once(function()
		if blackBackground.BackgroundTransparency >= 0.99 then
			blackBackground.Visible = false
		end
	end)
end
local function showHolder()
	if not u77 then
		u77 = holder.Position
	end

	if not u78 then
		u78 = select2Skills.Position
	end

	local v144 = u77
	local v145 = UDim2.fromScale(0, 1)

	holder.Position = v144 + v145
	holder.Visible = true
	slots.Visible = false
	v144 = u78
	v145 = UDim2.fromScale(0, -1)
	select2Skills.Position = v144 + v145
	select2Skills.Visible = true

	if u75 then
		u75:Cancel()
	end

	u75 = tweenService:Create(holder, tweenInfo3, { Position = u77 })
	u75:Play()

	if u76 then
		u76:Cancel()
	end

	u76 = tweenService:Create(select2Skills, tweenInfo3, { Position = u78 })
	u76:Play()

	return u76
end

local t7: {[any]: any} = {}

local function clearSelectionClones()
	for _, v in pairs(t7) do
		if v.clone and v.clone.Parent then
			v.clone:Destroy()
		end

		if v.thread then
			task.cancel(v.thread)
		end
	end

	table.clear(t7)
end
local function hideHolder(p5)
	if p5 then
		holder.Visible = false
		slots.Visible = false
		select2Skills.Visible = false
		clearSelectionClones()

		return
	end

	if not u77 then
		u77 = holder.Position
	end

	if not u78 then
		u78 = select2Skills.Position
	end

	if u75 then
		u75:Cancel()
	end

	local v149 = u77
	local v150 = UDim2.fromScale(0, 1)

	u75 = tweenService:Create(holder, tweenInfo4, { Position = v149 + v150 })
	u75:Play()
	u75.Completed:Once(function()
		u68 = true

		local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
		local u321: boolean = false

		if typeof(mouseUnlocked) == "number" then
			u321 = mouseUnlocked > 0
		end

		openBtn.Visible = u68 and not u321
		holder.Visible = false
		slots.Visible = false
		holder.Position = u77
		clearSelectionClones()
	end)

	if u76 then
		u76:Cancel()
	end

	v149 = u78
	v150 = UDim2.fromScale(0, -1)
	u76 = tweenService:Create(select2Skills, tweenInfo4, { Position = v149 + v150 })
	u76:Play()
	u76.Completed:Once(function()
		select2Skills.Visible = false
		select2Skills.Position = u78
	end)
end
local function dimRow(p6, p7)
	local disabledUIFrame = p6:FindFirstChild("DisabledUIFrame")

	if disabledUIFrame then
		disabledUIFrame.Visible = true
	end

	local abilities = p6:FindFirstChild("Abilities")

	if abilities then
		for _, v in ipairs(abilities:GetChildren()) do
			if v:IsA("GuiButton") then
				v.Interactable = false
				v.Active = false
				v.Selectable = false
			end
		end
	end

	local v157 = t7[p6.Name]

	if v157 then
		if v157.clone and v157.clone.Parent then
			v157.clone:Destroy()
		end

		if v157.thread then
			task.cancel(v157.thread)
		end

		t7[p6.Name] = nil
	end

	local v158 = p7 and abilities and t4[p7]

	if v158 then
		local absolutePosition = v158.AbsolutePosition
		local absoluteSize = v158.AbsoluteSize
		local scriptParentAbsolutePosition = scriptParent.AbsolutePosition
		local clone4 = v158:Clone()

		clone4.Name = "_SelectionClone"
		clone4.Interactable = false
		clone4.Active = false
		clone4.Selectable = false
		clone4.AnchorPoint = Vector2.new(0, 0)
		clone4.ZIndex = 10

		local scriptParentAbsoluteSize = scriptParent.AbsoluteSize

		clone4.Size = UDim2.fromScale(absoluteSize.X / scriptParentAbsoluteSize.X, absoluteSize.Y / scriptParentAbsoluteSize.Y)
		clone4.Position = UDim2.fromScale((absolutePosition.X - scriptParentAbsolutePosition.X) / scriptParentAbsoluteSize.X, (absolutePosition.Y - scriptParentAbsolutePosition.Y) / scriptParentAbsoluteSize.Y)

		for _, v in ipairs(clone4:GetChildren()) do
			if v:IsA("UIListLayout") or v:IsA("UIGridLayout") or v:IsA("UIAspectRatioConstraint") or v:IsA("UISizeConstraint") then
				v:Destroy()
			end
		end

		for _, v in ipairs(clone4:GetDescendants()) do
			if v:IsA("GuiButton") then
				v.Interactable = false
				v.Active = false
				v.Selectable = false
			end
		end

		clone4.Parent = scriptParent

		local v168 = task.spawn(function()
			while clone4 and clone4.Parent and v158 and v158.Parent do
				local scriptParentAbsolutePosition = scriptParent.AbsolutePosition
				local absolutePosition = v158.AbsolutePosition
				local absoluteSize = v158.AbsoluteSize
				local scriptParentAbsoluteSize = scriptParent.AbsoluteSize

				clone4.Size = UDim2.fromScale(absoluteSize.X / scriptParentAbsoluteSize.X, absoluteSize.Y / scriptParentAbsoluteSize.Y)
				clone4.Position = UDim2.fromScale((absolutePosition.X - scriptParentAbsolutePosition.X) / scriptParentAbsoluteSize.X, (absolutePosition.Y - scriptParentAbsolutePosition.Y) / scriptParentAbsoluteSize.Y)
				task.wait()
			end
		end)

		t7[p6.Name] = { clone = clone4, thread = v168 }
	end
end
local function undimRow(p8)
	local disabledUIFrame = p8:FindFirstChild("DisabledUIFrame")

	if disabledUIFrame then
		disabledUIFrame.Visible = false
	end

	local v171 = t7[p8.Name]

	if v171 then
		if v171.clone and v171.clone.Parent then
			v171.clone:Destroy()
		end

		if v171.thread then
			task.cancel(v171.thread)
		end

		t7[p8.Name] = nil
	end

	local abilities = p8:FindFirstChild("Abilities")

	if abilities then
		for _, v in ipairs(abilities:GetChildren()) do
			if v:IsA("GuiButton") then
				v.Interactable = true
				v.Active = true
				v.Selectable = true
			end
		end
	end
end
local function gamepadAutoSelect()
	if not u28 then
		return
	end

	if inputCategorizer.getLastInputCategory() ~= inputCategorizer.InputCategory.Gamepad then
		return
	end

	for _, v in ipairs({ abilities, gunRowAbilities, characterRowAbilities }) do
		local disabledUIFrame = v.Parent:FindFirstChild("DisabledUIFrame")

		if not disabledUIFrame or not disabledUIFrame.Visible then
			for _, iterValue in ipairs(v:GetChildren()) do
				if iterValue:IsA("GuiButton") and iterValue.Selectable and iterValue.Visible and iterValue.LayoutOrder >= 0 then
					task.defer(function()
						if not u28 then
							return
						end

						if not iterValue.Parent then
							return gamepadAutoSelect()
						end

						guiService.SelectedObject = iterValue
					end)

					return
				end
			end
		end
	end

	guiService:Select(holder)
end

game:GetService("GuiService"):GetPropertyChangedSignal("SelectedObject"):Connect(function()
	if not u28 then
		return
	end

	local guiServiceSelectedObject: GuiObject = guiService.SelectedObject

	if guiServiceSelectedObject and guiServiceSelectedObject:IsDescendantOf(holder) then
		return
	end

	gamepadAutoSelect()
end)

local function invoke(p9, p10)
	task.spawn(function()
		abilities_Request:InvokeServer(p9, p10)
	end)
end
local function buildUnlockedSet(p11)
	local t12: {[any]: any} = {}

	for _, v in ipairs(p11) do
		t12[v] = true
	end

	t1 = t12
end
local function isUnlocked(p12)
	return t1[p12] == true
end
local function getEquippedSlotFor(p13)
	if p13 == t2["1"] then
		return "1"
	end

	if p13 == t2["2"] then
		return "2"
	end

	return nil
end

getEquippedSlotFor = function(p14)
	local u190: boolean = true

	if p14 ~= Id then
		u190 = true

		if p14 ~= u30 then
			u190 = true

			if p14 ~= u31 then
				u190 = true

				if p14 ~= t2["1"] then
					u190 = p14 == t2["2"]
				end
			end
		end
	end

	return u190
end

local function getEquippedType(p15)
	local v192 = t2[p15]

	if not v192 then
		return nil
	end

	local v193 = abilityCatalog.Get(v192)

	return v193 and v193.Type or nil
end
local function findSlotForAbility(p16)
	local v195 = p16.Id
	local u196 = true

	if Id ~= v195 then
		u196 = true

		if v195 ~= u30 then
			u196 = true

			if v195 ~= u31 then
				u196 = true

				if v195 ~= t2["1"] then
					u196 = v195 == t2["2"]
				end
			end
		end
	end

	if u196 then
		return nil
	end

	u196 = p16.Type

	if u196 ~= "Knife" then
		if u196 ~= "Revolver" then
			if not t2["1"] then
				return "1"
			end

			if not t2["2"] then
				return "2"
			end

			return nil
		end

		if t2["2"] then
			local v197 = t2["2"]
			local v198

			if not v197 then
				v198 = nil
			else
				local v199 = abilityCatalog.Get(v197)

				v198 = v199 and v199.Type or nil
			end

			if v198 == "Revolver" then
				return nil
			end

			return "2"
		end

		return "2"
	end

	if t2["1"] then
		local v200 = t2["1"]
		local v201

		if not v200 then
			v201 = nil
		else
			local v202 = abilityCatalog.Get(v200)

			v201 = v202 and v202.Type or nil
		end

		if v201 == "Knife" then
			return nil
		end

		return "1"
	end

	return "1"
end

findSlotForAbility = function(p17)
	if p17 == "Knife" then
		return not t3["1"] and t2["1"] ~= nil
	end

	if p17 == "Revolver" then
		return not t3["2"] and t2["2"] ~= nil
	end

	return not t3.Character and u23 ~= nil
end

local function randomPickForType(p18)
	local v205 = abilityCatalog.GetAllList()
	local t13: {[any]: any} = {}

	for _, v in ipairs(v205) do
		if p18 == v.Type and t1[v.Id] == true then
			local vId = v.Id
			local u210: boolean = true

			if Id ~= vId then
				u210 = true

				if vId ~= u30 then
					u210 = true

					if vId ~= u31 then
						u210 = true

						if vId ~= t2["1"] then
							u210 = vId == t2["2"]
						end
					end
				end
			end

			if not u210 then
				table.insert(t13, v)
			end
		end
	end

	if #t13 == 0 then
		return nil
	end

	local randomNumber = math.random(1, #t13)

	return t13[randomNumber]
end
local function getAbilityType(p19)
	local v213 = p19 and abilityCatalog.Get(p19)

	if v213 then
		return v213.Type
	end

	return nil
end

local t8: {[any]: any} = { Q = "CastAbility1", E = "CastAbility2" }
local t9: {[any]: any} = { Q = "", E = "" }
local t10: {[any]: any} = { ["1"] = "Knife", ["2"] = "Revolver" }

local function rebuildSlot(p20, p21)
	local v216: Instance = if p20 == "Q" then qSlot else eSlot
	local v217 = t2[p21]
	local v218 = v217 and abilityCatalog.Get(v217)
	local v219 = (if v218 then v218.Type else nil) or t10[p21]

	if v219 ~= t9[p20] then
		t9[p20] = v219

		local v220, v221 = uiFramework.createAbilityCell(v219, { selectable = true, replaces = v216, keybindAction = t8[p20] })
		local abilityIcon = v220:FindFirstChild("AbilityIcon") or v220:FindFirstChild("Icon")

		if abilityIcon then
			abilityIcon.Name = "AbilityIcon"
		end

		if p20 == "Q" then
			qSlot = v220
			icon = v220:FindFirstChild("AbilityIcon")
		else
			eSlot = v220
			icon2 = v220:FindFirstChild("AbilityIcon")
		end
	end

	v218 = if p20 == "Q" then icon else icon2

	if not v218 then
		return
	end

	if v217 then
		local v223 = abilityCatalog.Get(v217)

		if v223 then
			v218.Image = v223.Icon
			v218.ImageTransparency = 0

			return
		end

		v218.Image = ""
		v218.ImageTransparency = 1

		return
	end

	v218.Image = ""
	v218.ImageTransparency = 1
end
local function refreshBottomSlots()
	rebuildSlot("Q", "1")
	rebuildSlot("E", "2")
end

rebuildSlot("Q", "1")
rebuildSlot("E", "2")

local function refreshRowDimming()
	if not t3["1"] and t2["1"] ~= nil then
		dimRow(knifeRow, t2["1"])
	else
		undimRow(knifeRow)
	end

	if not t3["2"] and t2["2"] ~= nil then
		dimRow(gunRow, t2["2"])
	else
		undimRow(gunRow)
	end

	if not t3.Character and u23 ~= nil then
		dimRow(characterRow, u23)

		return
	end

	undimRow(characterRow)
end

local t11: {[any]: any} = {
	Knife = abilities,
	Revolver = gunRowAbilities,
	Character = characterRowAbilities
}
t11 = {
	Knife = "rbxassetid://138389592094013",
	Revolver = "rbxassetid://100453557928225",
	Character = "rbxassetid://92009368366387"
}

local function clearGenerated(p22)
	local v225 = t6[p22]

	if v225 then
		for _, v in ipairs(v225) do
			if v and v.Parent then
				v:Destroy()
			end
		end
	end

	t6[p22] = {}
end
local function rememberGenerated(p23, p24)
	local t14 = t6[p23]

	if not t14 then
		t14 = {}
		t6[p23] = t14
	end

	table.insert(t14, p24)
end

local u105 = nil

local function commitSelections()
	local v231 = nil
	local v232 = nil

	if Id then
		v231 = Id
	end

	if u30 then
		v232 = u30
	end

	if u31 then
		if not v231 then
			v231 = u31
		elseif not v232 then
			v232 = u31
		end
	end

	if v231 then
		local s1: string = "Equip"
		local t15: {[any]: any} = { slot = "1", abilityId = v231 }

		task.spawn(function()
			abilities_Request:InvokeServer(s1, t15)
		end)
	end

	if v232 then
		local s2: string = "Equip"
		local t16: {[any]: any} = { slot = "2", abilityId = v232 }

		task.spawn(function()
			abilities_Request:InvokeServer(s2, t16)
		end)
	end
end
local function onEquipClicked(p25)
	if t1[p25.Id] ~= true then
		return
	end

	local v238 = p25.Type

	if v238 ~= "Knife" then
		if v238 ~= "Revolver" then
			u31 = if u31 == p25.Id then nil else p25.Id
		elseif u30 == p25.Id then
			u30 = nil
		else
			u30 = p25.Id
		end
	elseif Id == p25.Id then
		Id = nil
	else
		Id = p25.Id
	end

	t2["1"] = Id
	t2["2"] = u30
	u23 = u31

	if Id then
		t3["1"] = false
	end

	if u30 then
		t3["2"] = false
	end

	if u31 then
		t3.Character = false
	end

	rebuildSlot("Q", "1")
	rebuildSlot("E", "2")
	refreshRowDimming()
	u105()
	gamepadAutoSelect()
	v238 = 0

	if Id then
		v238 += 1
	end

	if u30 then
		v238 += 1
	end

	if u31 then
		v238 += 1
	end

	animateNumberChange(2 - v238)

	if v238 >= 2 then
		animateNumberChange(0)
		commitSelections()
		task.wait()
		hideHolder()
		hideBlackBG()

		local matchId: any = LocalPlayer:GetAttribute("MatchId")

		if (if typeof(matchId) == "string" then matchId else nil) == "PRACTICE" then
			scriptParent.Visible = true
		else
			scriptParent.Visible = false
		end

		u28 = false
		guiService.SelectedObject = nil

		if u66 == false then
			return
		end

		u66 = false

		local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

		LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) + -1)

		return
	end
end
local function onRandomClicked(p26)
	local v242 = randomPickForType(p26)

	if not v242 then
		return
	end

	if p26 == "Knife" then
		Id = v242.Id
	elseif p26 == "Revolver" then
		u30 = v242.Id
	else
		u31 = v242.Id
	end

	t2["1"] = Id
	t2["2"] = u30
	u23 = u31

	if Id then
		t3["1"] = false
	end

	if u30 then
		t3["2"] = false
	end

	if u31 then
		t3.Character = false
	end

	rebuildSlot("Q", "1")
	rebuildSlot("E", "2")
	refreshRowDimming()
	u105()
	gamepadAutoSelect()
	v242 = 0

	if Id then
		v242 += 1
	end

	if u30 then
		v242 += 1
	end

	if u31 then
		v242 += 1
	end

	animateNumberChange(2 - v242)

	if v242 >= 2 then
		animateNumberChange(0)
		commitSelections()
		guiService.SelectedObject = nil
		task.wait()
		hideHolder()
		hideBlackBG()

		local matchId: any = LocalPlayer:GetAttribute("MatchId")

		if (if typeof(matchId) == "string" then matchId else nil) == "PRACTICE" then
			scriptParent.Visible = true
		else
			scriptParent.Visible = false
		end

		u28 = false

		if u66 == false then
			return
		end

		u66 = false

		local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

		LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) + -1)

		return
	end
end

u105 = function()
end

local function buildListForCurrentStep()
	for _, v in ipairs({ abilities, gunRowAbilities, characterRowAbilities }) do
		clearGenerated(v)
	end

	table.clear(t4)
	table.clear(t5)

	local v247 = abilityCatalog.GetAllList()

	local function createSkillTile(p27, p28)
		local v328, v329 = uiFramework.createAbilityCell(p28.Type, {
			selectable = true,
			icon = p28.Icon,
			name = p28.Id,
			size = UDim2.new(1, 0, 1, 0),
			parent = p27
		})

		v328.Visible = true

		local t24 = t6[p27]

		if not t24 then
			t24 = {}
			t6[p27] = t24
		end

		table.insert(t24, v328)
		t4[p28.Id] = v328
		t5[p28.Id] = v329
		v328.MouseButton1Click:Connect(function()
			onEquipClicked(p28)
		end)
	end
	local function createRandomTile(p29, p30)
		local v333, v334 = uiFramework.createAbilityCell(p30, {
			icon = "rbxassetid://124601369731686",
			layoutOrder = -1,
			selectable = true,
			name = "Random_" .. p30,
			size = UDim2.new(1, 0, 1, 0),
			parent = p29
		})

		v333.Visible = true

		local t25 = t6[p29]

		if not t25 then
			t25 = {}
			t6[p29] = t25
		end

		table.insert(t25, v333)
		v333.MouseButton1Click:Connect(function()
			onRandomClicked(p30)
		end)
	end

	createRandomTile(abilities, "Knife")

	for _, v in ipairs(v247) do
		if v.Type == "Knife" and t1[v.Id] == true then
			createSkillTile(abilities, v)
		end
	end

	createRandomTile(gunRowAbilities, "Revolver")

	for _, v in ipairs(v247) do
		if v.Type == "Revolver" and t1[v.Id] == true then
			createSkillTile(gunRowAbilities, v)
		end
	end

	createRandomTile(characterRowAbilities, "Character")

	for _, v in ipairs(v247) do
		if v.Type == "Character" and t1[v.Id] == true then
			createSkillTile(characterRowAbilities, v)
		end
	end

	createRandomTile = function(parent, p32)
		for i = 1, 7 - p32 do
			local _RowFiller: Frame = Instance.new("Frame")

			_RowFiller.Name = "_RowFiller"
			_RowFiller.BackgroundColor3 = Color3.new()
			_RowFiller.BackgroundTransparency = 0.7
			_RowFiller.BorderSizePixel = 0
			_RowFiller.Size = UDim2.new(1, 0, 1, 0)
			_RowFiller.LayoutOrder = i + 999
			_RowFiller.Visible = true
			_RowFiller.Parent = parent

			local uiAspectRatioConstraint: UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

			uiAspectRatioConstraint.AspectRatio = 1
			uiAspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
			uiAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Width
			uiAspectRatioConstraint.Parent = _RowFiller

			local uiCorner: UICorner = Instance.new("UICorner")

			uiCorner.CornerRadius = UDim.new(0.09, 0)
			uiCorner.Parent = _RowFiller

			local t26 = t6[parent]

			if not t26 then
				t26 = {}
				t6[parent] = t26
			end

			table.insert(t26, _RowFiller)
		end
	end

	local n1: number = 0
	local n2: number = 0
	local n3: number = 0

	for _, v in ipairs(abilities:GetChildren()) do
		if v:IsA("GuiButton") then
			n1 += 1
		end
	end

	for _, v in ipairs(gunRowAbilities:GetChildren()) do
		if v:IsA("GuiButton") then
			n2 += 1
		end
	end

	for _, v in ipairs(characterRowAbilities:GetChildren()) do
		if v:IsA("GuiButton") then
			n3 += 1
		end
	end

	createRandomTile(abilities, n1)
	createRandomTile(gunRowAbilities, n2)
	createRandomTile(characterRowAbilities, n3)
	u105()
	gamepadAutoSelect()
end

local bindableEvent: BindableEvent = Instance.new("BindableEvent")

local function applySnapshot(p33)
	u20 = p33

	local t17: {[any]: any} = {}

	for _, v in ipairs(p33.Unlocked) do
		t17[v] = true
	end

	t1 = t17
	t2["1"] = p33.Equipped["1"]
	t2["2"] = p33.Equipped["2"]

	if p33.Equipped["1"] == nil then
		t3["1"] = false
	end

	if p33.Equipped["2"] == nil then
		t3["2"] = false
	end

	u23 = nil

	for _, v in ipairs({ "1", "2" }) do
		local v271 = p33.Equipped[v]

		if v271 and abilityCatalog.Get(v271) and abilityCatalog.Get(v271).Type == "Character" then
			u23 = v271
		end
	end

	if u23 == nil then
		t3.Character = false
	end

	bindableEvent:Fire()

	if u28 then
		buildListForCurrentStep()
		rebuildSlot("Q", "1")
		rebuildSlot("E", "2")
		refreshRowDimming()
	end
end

abilities_Push.OnClientEvent:Connect(function(p34, player)
	if p34 == "Snapshot" and typeof(player) == "table" then
		local userId = player.UserId

		if typeof(userId) == "number" and userId ~= LocalPlayer.UserId then
			return
		end

		applySnapshot(player)

		return
	end
end)

local function ensureSnapshot()
	if u20 then
		return true
	end

	local u275: boolean = false

	local connection = bindableEvent.Event:Connect(function()
		u275 = true
	end)

	local v277 = os.clock()

	while not u275 and os.clock() - v277 < 3 do
		task.wait(0.1)
	end

	connection:Disconnect()

	return u20 ~= nil
end
local function unequipAll()
	local t18: {[any]: any} = { slot = "1" }
	local s1: string = "Unequip"

	task.spawn(function()
		abilities_Request:InvokeServer(s1, t18)
	end)

	local t19: {[any]: any} = { slot = "2" }
	local s2: string = "Unequip"

	task.spawn(function()
		abilities_Request:InvokeServer(s2, t19)
	end)
	t2["1"] = nil
	t2["2"] = nil
	u23 = nil
	t3["1"] = true
	t3["2"] = true
	t3.Character = true
	Id = nil
	u30 = nil
	u31 = nil
	resetSkillsNumber()
	clearSelectionClones()
end
local function tryAutoEquip()
	if not u20 then
		return false
	end

	local unlocked = u20.Unlocked

	if #unlocked > 2 then
		return false
	end

	local t20: {[any]: any} = {}

	for _, v in ipairs(unlocked) do
		local v286 = abilityCatalog.Get(v)

		if v286 then
			table.insert(t20, v286)
		end
	end

	if #t20 == 0 then
		return true
	end

	local t21: {[any]: any} = {}

	for _, v in ipairs(t20) do
		if v.Type == "Knife" and not t21["1"] then
			t21["1"] = v.Id
		elseif v.Type == "Revolver" and not t21["2"] then
			t21["2"] = v.Id
		end
	end

	for _, v in ipairs(t20) do
		if v.Type == "Character" then
			if not t21["1"] then
				t21["1"] = v.Id
			elseif not t21["2"] then
				t21["2"] = v.Id
			end
		end
	end

	if not t21["1"] and t20[1] then
		t21["1"] = t20[1].Id
	end

	if not t21["2"] and t20[2] then
		t21["2"] = t20[2].Id
	end

	if t21["1"] then
		local s1: string = "Equip"
		local t22: {[any]: any} = { slot = "1", abilityId = t21["1"] }

		task.spawn(function()
			abilities_Request:InvokeServer(s1, t22)
		end)
		t2["1"] = t21["1"]
		t3["1"] = false

		if abilityCatalog.Get(t21["1"]) and abilityCatalog.Get(t21["1"]).Type == "Character" then
			t3.Character = false
		end
	end

	if t21["2"] then
		local s2: string = "Equip"
		local t23: {[any]: any} = { slot = "2", abilityId = t21["2"] }

		task.spawn(function()
			abilities_Request:InvokeServer(s2, t23)
		end)
		t2["2"] = t21["2"]
		t3["2"] = false

		if abilityCatalog.Get(t21["2"]) and abilityCatalog.Get(t21["2"]).Type == "Character" then
			t3.Character = false
		end
	end

	rebuildSlot("Q", "1")
	rebuildSlot("E", "2")

	return true
end
local function openWizard()
	if not u20 then
		ensureSnapshot()
	end

	if tryAutoEquip() then
		scriptParent.Visible = false
		u68 = false

		local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
		local u297: boolean = false

		if typeof(mouseUnlocked) == "number" then
			u297 = mouseUnlocked > 0
		end

		openBtn.Visible = u68 and not u297
		u28 = false

		if u66 ~= false then
			u66 = false

			local mouseUnlocked2: any = LocalPlayer:GetAttribute("MouseUnlocked")

			LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked2 or 0) + -1)
		end

		blackBackground.Visible = false
		blackBackground.BackgroundTransparency = 1
		holder.Visible = false
		slots.Visible = false
		select2Skills.Visible = false
		clearSelectionClones()

		return
	end

	u68 = false

	local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
	local u300: boolean = false

	if typeof(mouseUnlocked) == "number" then
		u300 = mouseUnlocked > 0
	end

	openBtn.Visible = u68 and not u300
	scriptParent.Visible = true
	unequipAll()

	if not u20 then
		task.spawn(function()
			if ensureSnapshot() and u28 then
				buildListForCurrentStep()
				rebuildSlot("Q", "1")
				rebuildSlot("E", "2")
				refreshRowDimming()
				gamepadAutoSelect()
			end
		end)
	end

	rebuildSlot("Q", "1")
	rebuildSlot("E", "2")
	refreshRowDimming()
	buildListForCurrentStep()

	local v301 = showHolder()

	showBlackBG()
	u28 = true

	if u66 ~= true then
		u66 = true

		local mouseUnlocked3: any = LocalPlayer:GetAttribute("MouseUnlocked")

		LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked3 or 0) + 1)
	end

	task.spawn(function()
		if v301 and v301.PlaybackState == Enum.PlaybackState.Playing then
			v301.Completed:Wait()
		end

		task.wait()

		if not u28 then
			return
		end

		gamepadAutoSelect()
	end)
end

showChangeAbilities.Event:Connect(function()
	openWizard()
end)

local n2: number = 0;

(function()
	local matchRemotes: Instance = replicatedStorage:WaitForChild("MatchRemotes", 30)

	if not matchRemotes then
		return
	end

	local v304: Instance = matchRemotes:WaitForChild("State", 30)

	if not v304 then
		return
	end

	v304.OnClientEvent:Connect(function(p36, p37)
		if typeof(p37) == "table" then
			local matchId: any = LocalPlayer:GetAttribute("MatchId")
			local v346 = if typeof(matchId) == "string" then matchId else nil

			if p37.t == "MatchStarted" then
				if not v346 then
					task.wait(0.1)

					local matchId2: any = LocalPlayer:GetAttribute("MatchId")

					v346 = if typeof(matchId2) == "string" then matchId2 else nil
				end

				if v346 ~= p36 then
					return
				end
			elseif not v346 or v346 ~= p36 then
				return
			end

			if p37.t == "MatchStarted" then
				n2 = 0
			elseif p37.t == "SkillSelect" then
				n2 += 1

				if n2 > 1 then
					if not u20 then
						ensureSnapshot()
					end

					if u20 and #u20.Unlocked <= 2 then
						tryAutoEquip()

						return
					end

					scriptParent.Visible = true
					u68 = true

					local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
					local u349: boolean = false

					if typeof(mouseUnlocked) == "number" then
						u349 = mouseUnlocked > 0
					end

					openBtn.Visible = u68 and not u349

					return
				end

				openWizard()
			elseif p37.t == "RoundLive" then
				local matchId3: any = LocalPlayer:GetAttribute("MatchId")

				if (if typeof(matchId3) == "string" then matchId3 else nil) ~= "PRACTICE" then
					u68 = false

					local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
					local u352: boolean = false

					if typeof(mouseUnlocked) == "number" then
						u352 = mouseUnlocked > 0
					end

					openBtn.Visible = u68 and not u352

					return
				end
			elseif p37.t == "MatchEnded" then
				holder.Visible = false
				slots.Visible = false
				select2Skills.Visible = false
				clearSelectionClones()
				blackBackground.Visible = false
				blackBackground.BackgroundTransparency = 1
				scriptParent.Visible = false

				if u66 ~= false then
					u66 = false

					local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

					LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) + -1)
				end

				u68 = false

				local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
				local u355: boolean = false

				if typeof(mouseUnlocked) == "number" then
					u355 = mouseUnlocked > 0
				end

				openBtn.Visible = u68 and not u355
				n2 = 0
				u28 = false
			end

			return
		end
	end)
end)()
openBtn.MouseButton1Click:Connect(function()
	openWizard()
end)
userInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	if gameProcessedEvent then
		return
	end

	if inputMap.matches("ChangeAbilities", input) and scriptParent.Visible and u68 and not holder.Visible then
		openWizard()
	end
end)

local keybind: Instance = openBtn:FindFirstChild("Keybind")
local keyBind: Instance = keybind and keybind:FindFirstChild("KeyBind")
local imageLabel = nil

if keybind then
	imageLabel = Instance.new("ImageLabel")
	imageLabel.Name = "GamepadIcon"
	imageLabel.Size = UDim2.fromScale(0.9, 0.9)
	imageLabel.Position = UDim2.fromScale(0.5, 0.5)
	imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	imageLabel.BackgroundTransparency = 1
	imageLabel.ScaleType = Enum.ScaleType.Fit
	imageLabel.ZIndex = keybind.ZIndex + 1
	imageLabel.ImageColor3 = Color3.new(1, 1, 1)
	imageLabel.Visible = false

	local ok, result = pcall(function()
		return userInputService:GetImageForKeyCode(gamepadBindings.OpenAbilities)
	end)

	if ok and result ~= "" then
		imageLabel.Image = result
	end

	imageLabel.Parent = keybind
	uiFramework.bindKeybindLabel(keybind, "ChangeAbilities")
end

local v122 = inputCategorizer.getLastInputCategory()
local visible: boolean = v122 == inputCategorizer.InputCategory.Gamepad
local u124: boolean = v122 == inputCategorizer.InputCategory.Touch

if keybind then
	keybind.Visible = not u124
end

if imageLabel then
	imageLabel.Visible = visible
end

if keyBind then
	keyBind.Visible = not visible and not u124
end

inputCategorizer.lastInputCategoryChanged:Connect(function()
	local v307 = inputCategorizer.getLastInputCategory()
	local visible: boolean = v307 == inputCategorizer.InputCategory.Gamepad
	local u309: boolean = v307 == inputCategorizer.InputCategory.Touch

	if keybind then
		keybind.Visible = not u309
	end

	if imageLabel then
		imageLabel.Visible = visible
	end

	if keyBind then
		keyBind.Visible = not visible and not u309
	end
end)
LocalPlayer:GetAttributeChangedSignal("GamepadOpenAbilities"):Connect(function()
	if scriptParent.Visible and u68 and not holder.Visible then
		openWizard()
	end
end)
LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(function()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")

	if (if typeof(matchId) == "string" then matchId else nil) == "PRACTICE" then
		scriptParent.Visible = true
		u68 = true

		local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
		local u312: boolean = false

		if typeof(mouseUnlocked) == "number" then
			u312 = mouseUnlocked > 0
		end

		openBtn.Visible = u68 and not u312

		if LocalPlayer:GetAttribute("MMWarmup") ~= true then
			openWizard()

			return
		end
	elseif not (if typeof((LocalPlayer:GetAttribute("MatchId"))) == "string" then LocalPlayer:GetAttribute("MatchId") else nil) then
		blackBackground.Visible = false
		blackBackground.BackgroundTransparency = 1
		holder.Visible = false
		slots.Visible = false
		select2Skills.Visible = false
		clearSelectionClones()
		scriptParent.Visible = false

		if u66 ~= false then
			u66 = false

			local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

			LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) + -1)
		end

		u68 = false

		local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
		local u315: boolean = false

		if typeof(mouseUnlocked) == "number" then
			u315 = mouseUnlocked > 0
		end

		openBtn.Visible = u68 and not u315
		u28 = false
	end
end)

local matchId: any = LocalPlayer:GetAttribute("MatchId")

if (if typeof(matchId) == "string" then matchId else nil) == "PRACTICE" then
	scriptParent.Visible = true
	u68 = true

	local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
	local u127: boolean = false

	if typeof(mouseUnlocked) == "number" then
		u127 = mouseUnlocked > 0
	end

	openBtn.Visible = u68 and not u127

	if LocalPlayer:GetAttribute("MMWarmup") ~= true then
		task.defer(openWizard)
	end
end
