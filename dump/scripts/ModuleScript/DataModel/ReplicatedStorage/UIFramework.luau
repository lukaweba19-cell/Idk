-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")
local runService: RunService = game:GetService("RunService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local module: {[any]: any} = {}
local sound = require(replicatedStorage:WaitForChild("Sound"))
local assets = script:WaitForChild("Assets")
local itemCells = assets:WaitForChild("ItemCells")
local selectedItemCells = assets:WaitForChild("SelectedItemCells")
local misc = script:WaitForChild("Misc")
local cooldown = misc:WaitForChild("Cooldown")
local inspectButton = misc:WaitForChild("InspectButton")

require(script:WaitForChild("GlitchEffect"))

local quantityCounter = misc:WaitForChild("QuantityCounter")
local equippedTag = misc:WaitForChild("EquippedTag")

misc:WaitForChild("Alert")

local finisherTag = misc:WaitForChild("FinisherTag")
local alert = misc:WaitForChild("Alert")
local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local t2: {[any]: any} = {
	GuiObject = {
		"Visible",
		"Size",
		"Position",
		"Rotation",
		"BackgroundTransparency",
		"BackgroundColor3",
		"Interactable",
		"Active",
		"Selectable"
	},
	ImageLabel = { "ImageTransparency", "ImageColor3" },
	ImageButton = { "ImageTransparency", "ImageColor3" },
	TextLabel = { "TextColor3" },
	UIStroke = { "Transparency", "Thickness", "Color", "Enabled" },
	UIGradient = { "Offset", "Color", "Transparency" }
}

local function buildSelectedDiffs(p1, p2)
	local t7: {[any]: any} = {}

	local function diffInstance(p3, p4)
		local t25: {[any]: any} = {}

		for k, v in pairs(t2) do
			if p3:IsA(k) then
				for _, iterValue in ipairs(v) do
					table.insert(t25, iterValue)
				end
			end
		end

		local t26: {[any]: any} = {}
		local u316: boolean = false

		for _, v in ipairs(t25) do
			local ok, result = pcall(function()
				return p3[v]
			end)

			local ok2, result2 = pcall(function()
				return p4[v]
			end)

			if ok and ok2 and tostring(result) ~= tostring(result2) then
				t26[v] = result2
				u316 = true
			end
		end

		if u316 then
			table.insert(t7, { inst = p3, props = t26 })
		end

		for _, v in ipairs(p3:GetChildren()) do
			if not v:IsA("UIStroke") or p3 ~= p1 then
				local vName = p4:FindFirstChild(v.Name)

				if vName and vName.ClassName == v.ClassName then
					diffInstance(v, vName)
				end
			end
		end
	end

	diffInstance(p1, p2)

	return t7
end
local function cacheOriginals(p5)
	local t8: {[any]: any} = {}

	for _, v in ipairs(p5) do
		local t9: {[any]: any} = {}

		for k, _ in pairs(v.props) do
			local ok, result = pcall(function()
				return v.inst[k]
			end)

			if ok then
				t9[k] = result
			end
		end

		table.insert(t8, { inst = v.inst, props = t9 })
	end

	return t8
end
local function findSelectedOnlyChildren(p6, p7)
	local t10: {[any]: any} = {}

	for _, v in ipairs(p7:GetChildren()) do
		if not p6:FindFirstChild(v.Name) then
			table.insert(t10, v)
		end
	end

	return t10
end
local function findNormalOnlyInstances(p8, p9)
	local t11: {[any]: any} = {}

	local function recurse(p10, p11)
		for _, v in ipairs(p10:GetChildren()) do
			local vName = p11:FindFirstChild(v.Name)

			if not vName then
				table.insert(t11, v)
			elseif vName.ClassName == v.ClassName then
				recurse(v, vName)
			end
		end
	end

	recurse(p8, p9)

	return t11
end
local function collectStrokeSwaps(p12, p13)
	local t12: {[any]: any} = {}
	local t13: {[any]: any} = {}

	for _, v in ipairs(p12:GetChildren()) do
		if v:IsA("UIStroke") then
			table.insert(t12, v)
		end
	end

	for _, v in ipairs(p13:GetChildren()) do
		if v:IsA("UIStroke") then
			table.insert(t13, v)
		end
	end

	return { normalStrokes = t12, selectedTemplates = t13 }
end
local function applyDiffs(p14)
	for _, v in ipairs(p14) do
		for k, iterValue in pairs(v.props) do
			pcall(function()
				v.inst[k] = iterValue
			end)
		end
	end
end
local function applyOpts(p15, p16)
	if not p16 then
		return
	end

	if p16.replaces then
		local replaces = p16.replaces
		local __BasePosXS = replaces:GetAttribute("__BasePosXS")
		local __BasePosYS = replaces:GetAttribute("__BasePosYS")
		local __BasePosXO = replaces:GetAttribute("__BasePosXO")
		local __BasePosYO = replaces:GetAttribute("__BasePosYO")
		local uDim2

		if __BasePosXS and __BasePosYS and __BasePosXO and __BasePosYO then
			uDim2 = UDim2.new(__BasePosXS, __BasePosXO, __BasePosYS, __BasePosYO)
		else
			uDim2 = replaces.Position
		end

		p15.Name = p16.name or replaces.Name
		p15.Size = p16.size or replaces.Size
		p15.Position = p16.position or uDim2
		p15.AnchorPoint = p16.anchorPoint or replaces.AnchorPoint
		p15.LayoutOrder = p16.layoutOrder or replaces.LayoutOrder
		p15.Visible = if p16.visible == nil then replaces.Visible else p16.visible
		p15.Active = if p16.active == nil then replaces.Active else p16.active
		p15.Selectable = if p16.selectable == nil then replaces.Selectable else p16.selectable
		p15.Interactable = if p16.interactable == nil then replaces.Interactable else p16.interactable
		p15.AutoButtonColor = not p15.Interactable
		p15.Parent = p16.parent or replaces.Parent
		replaces:Destroy()

		return
	end

	if p16.name then
		p15.Name = p16.name
	end

	if p16.size then
		p15.Size = p16.size
	end

	if p16.position then
		p15.Position = p16.position
	end

	if p16.anchorPoint then
		p15.AnchorPoint = p16.anchorPoint
	end

	if p16.layoutOrder then
		p15.LayoutOrder = p16.layoutOrder
	end

	if p16.visible ~= nil then
		p15.Visible = p16.visible
	end

	if p16.active ~= nil then
		p15.Active = p16.active
	end

	if p16.selectable ~= nil then
		p15.Selectable = p16.selectable
	end

	if p16.interactable ~= nil then
		p15.Interactable = p16.interactable
	end

	if p16.parent then
		p15.Parent = p16.parent
	end
end
local function setupKeybind(p17, text, p19)
	local keybind = p17:FindFirstChild("Keybind")

	if not text and p19 == nil then
		if keybind then
			keybind:Destroy()
		end
	elseif keybind then
		keybind.ZIndex = 3

		if p19 == nil then
			local keyBind = keybind:FindFirstChild("KeyBind")

			if keyBind then
				keyBind.Text = text
			end

			return
		end

		module.bindKeybindLabel(keybind, p19)

		return
	end
end
local function setupIcon(p20, image)
	local icon = p20:FindFirstChild("Icon")

	if icon and image then
		icon.Image = image
	end
end
local function wireSelected(parent, p23, p24, p25, p26, p27, p28)
	local u115 = false
	local u116 = false
	local selectedOffset = p28 and p28.selectedOffset
	local v118 = if selectedOffset then parent.Position else nil

	if v118 then
		parent:SetAttribute("__BasePosXS", v118.X.Scale)
		parent:SetAttribute("__BasePosXO", v118.X.Offset)
		parent:SetAttribute("__BasePosYS", v118.Y.Scale)
		parent:SetAttribute("__BasePosYO", v118.Y.Offset)
	end

	local t14: {[any]: any} = {
		cell = parent,
		setSelected = function(_, p30)
			if p30 == u115 then
				return
			end

			u115 = p30
			parent:SetAttribute("Selected", p30)

			if p30 then
				applyDiffs(p23)

				for _, v in ipairs(p25) do
					if not parent:FindFirstChild(v.Name) then
						local clone = v:Clone()

						clone.Parent = parent
					end
				end

				for _, v in ipairs(p26) do
					if v:IsA("UIStroke") then
						v.Enabled = false
					elseif v:IsA("GuiObject") then
						v.Visible = false
					end
				end

				if p27 then
					for _, v in ipairs(p27.normalStrokes) do
						v.Enabled = false
					end

					for _, v in ipairs(p27.selectedTemplates) do
						local clone = v:Clone()

						clone:SetAttribute("__SelectedStroke", true)
						clone.Parent = parent
					end
				end

				if selectedOffset and v118 then
					local uDim2 = UDim2.new(v118.X.Scale + selectedOffset.X.Scale, v118.X.Offset + selectedOffset.X.Offset, v118.Y.Scale + selectedOffset.Y.Scale, v118.Y.Offset + selectedOffset.Y.Offset)

					tweenService:Create(parent, tweenInfo, { Position = uDim2 }):Play()

					return
				end
			else
				if not u116 then
					applyDiffs(p24)

					for _, v in ipairs(p25) do
						local vName = parent:FindFirstChild(v.Name)

						if vName then
							vName:Destroy()
						end
					end

					for _, v in ipairs(p26) do
						if v:IsA("UIStroke") then
							v.Enabled = true
						elseif v:IsA("GuiObject") then
							v.Visible = true
						end
					end

					if p27 then
						for _, v in ipairs(parent:GetChildren()) do
							if v:GetAttribute("__SelectedStroke") then
								v:Destroy()
							end
						end

						for _, v in ipairs(p27.normalStrokes) do
							v.Enabled = true
						end
					end
				end

				if selectedOffset and v118 then
					tweenService:Create(parent, tweenInfo2, { Position = v118 }):Play()
				end
			end
		end,
		setIcon = function(_, image)
			local icon = parent:FindFirstChild("Icon")

			if icon then
				icon.Image = image
			end
		end,
		setKeybind = function(_, text, p35)
			local keybind = parent:FindFirstChild("Keybind")

			if not text and p35 == nil then
				if keybind then
					keybind:Destroy()
				end

				return
			end

			if not keybind then
				return
			end

			if p35 == nil then
				local keyBind = keybind:FindFirstChild("KeyBind")

				if keyBind then
					keyBind.Text = text
				end

				return
			end

			module.bindKeybindLabel(keybind, p35)
		end
	}

	local frame = nil
	local frame2 = nil

	if p28 and p28.hasCooldown then
		frame = Instance.new("Frame")
		frame.Name = "ReadyFlash"
		frame.BackgroundColor3 = Color3.new(1, 1, 1)
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		frame.ZIndex = 2
		frame.AnchorPoint = Vector2.new(0.5, 0.5)
		frame.Position = UDim2.fromScale(0.5, 0.5)
		frame.Size = UDim2.fromScale(1, 1)
		frame.Parent = parent
		frame2 = Instance.new("Frame")
		frame2.Name = "DenyFlash"
		frame2.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		frame2.BackgroundTransparency = 1
		frame2.BorderSizePixel = 0
		frame2.ZIndex = 2
		frame2.AnchorPoint = Vector2.new(0.5, 0.5)
		frame2.Position = UDim2.fromScale(0.5, 0.5)
		frame2.Size = UDim2.fromScale(1, 1)
		frame2.Parent = parent
	end

	local uiScale = parent:FindFirstChildOfClass("UIScale")

	if not uiScale then
		uiScale = Instance.new("UIScale")
		uiScale.Scale = 1
		uiScale.Parent = parent
	end

	function t14.fxReady(_)
		if frame then
			frame.BackgroundTransparency = 0.25

			local v362 = frame
			local tweenInfo3 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

			tweenService:Create(v362, tweenInfo3, { BackgroundTransparency = 1 }):Play()
		end

		uiScale.Scale = 1.06

		local v364 = uiScale
		local tweenInfo4 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		tweenService:Create(v364, tweenInfo4, { Scale = 1 }):Play()
	end
	function t14.fxDeny(_)
		sound:Play("Abilities.CooldownError", workspace)

		if frame2 then
			frame2.BackgroundTransparency = 0.35

			local v367 = frame2
			local tweenInfo5 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

			tweenService:Create(v367, tweenInfo5, { BackgroundTransparency = 1 }):Play()
		end

		local origPosition = parent:GetAttribute("OrigPosition")

		if not origPosition then
			origPosition = parent.Position
			parent:SetAttribute("OrigPosition", origPosition)
		end

		local function nudge(p38)
			parent.Position = UDim2.new(origPosition.X.Scale, origPosition.X.Offset + p38, origPosition.Y.Scale, origPosition.Y.Offset)
		end

		parent.Position = UDim2.new(origPosition.X.Scale, origPosition.X.Offset + -3, origPosition.Y.Scale, origPosition.Y.Offset)
		task.delay(0.03, function()
			parent.Position = UDim2.new(origPosition.X.Scale, origPosition.X.Offset + 3, origPosition.Y.Scale, origPosition.Y.Offset)
		end)
		task.delay(0.06, function()
			parent.Position = UDim2.new(origPosition.X.Scale, origPosition.X.Offset + -2, origPosition.Y.Scale, origPosition.Y.Offset)
		end)
		task.delay(0.09, function()
			parent.Position = origPosition
		end)
	end
	function t14.fxCastPop(_)
		uiScale.Scale = 1.12

		local v372 = uiScale
		local tweenInfo6 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		tweenService:Create(v372, tweenInfo6, { Scale = 1 }):Play()
	end

	local clone = nil
	local uiGradient = nil
	local textLabel = nil
	local connection = nil

	if p28 and p28.hasCooldown then
		clone = cooldown:Clone()
		clone.Visible = false
		clone.Parent = parent
		uiGradient = clone:FindFirstChildOfClass("UIGradient")
		textLabel = clone:FindFirstChild("TextLabel")
	end

	local function setCooldownEdge(p40)
		if not uiGradient then
			return
		end

		if p40 <= 0 then
			uiGradient.Transparency = NumberSequence.new(1)

			return
		end

		if p40 >= 1 then
			uiGradient.Transparency = NumberSequence.new(0)

			return
		end

		local v375 = math.max(0.001, p40 - 0.003)
		local v376 = math.min(0.999, p40 + 0.003)

		if v375 >= v376 then
			v375 = v376 - 0.001
		end

		local v377 = uiGradient
		local numberSequenceNew = NumberSequence.new
		local numberSequenceKeypoint = NumberSequenceKeypoint.new(v375, 0)
		local numberSequenceKeypoint2 = NumberSequenceKeypoint.new(v376, 1)

		v377.Transparency = numberSequenceNew({
			NumberSequenceKeypoint.new(0, 0),
			numberSequenceKeypoint,
			numberSequenceKeypoint2,
			NumberSequenceKeypoint.new(1, 1)
		})
	end
	local function stopCooldownTicker()
		if connection then
			connection:Disconnect()
			connection = nil
		end
	end

	local colorSequence = ColorSequence.new(Color3.new(1, 1, 1))

	function t14.playCooldown(_, p42)
		if not clone then
			return
		end

		if connection then
			connection:Disconnect()
			connection = nil
		end

		local v383 = math.max(0.05, p42)
		local n1 = os.clock() + v383

		clone.Visible = true

		if uiGradient then
			uiGradient.Color = colorSequence
		end

		if textLabel then
			textLabel.Visible = true
		end

		if uiGradient then
			uiGradient.Transparency = NumberSequence.new(0)
		end

		connection = runService.Heartbeat:Connect(function()
			local v577 = os.clock()
			local n2 = n1 - v577

			if n2 <= 0 then
				if connection then
					connection:Disconnect()
					connection = nil
				end

				clone.Visible = false

				if textLabel then
					textLabel.Text = ""
					textLabel.Visible = false
				end

				t14:fxReady()

				return
			end

			setCooldownEdge(n2 / v383)

			if textLabel then
				local floored = math.floor(n2 * 10 + 0.5)

				textLabel.Text = if n2 > 100000 then "" else string.format("%.1fs", floored / 10)
			end
		end)
	end
	function t14.clearCooldown(_)
		if connection then
			connection:Disconnect()
			connection = nil
		end

		if clone then
			clone.Visible = false
		end

		if textLabel then
			textLabel.Text = ""
			textLabel.Visible = false
		end
	end
	function t14.playPending(_)
		if not clone then
			return
		end

		if connection then
			connection:Disconnect()
			connection = nil
		end

		clone.Visible = true

		if uiGradient then
			uiGradient.Color = colorSequence
		end

		if uiGradient then
			uiGradient.Transparency = NumberSequence.new(0)
		end

		if textLabel then
			textLabel.Visible = true
			textLabel.Text = "..."
		end
	end

	local clone = nil

	if p28 and p28.inspectable then
		clone = inspectButton:Clone()
		clone.Visible = true
		clone.Parent = parent
	end

	function t14.getInspectButton(_)
		return clone
	end

	local clone = nil

	function t14.setStackCount(_, p47)
		if p47 > 1 then
			if not clone then
				clone = quantityCounter:Clone()
				clone.Parent = parent
			end

			clone.Text = "x" .. tostring(p47)
			clone.Visible = true
		elseif clone then
			clone.Visible = false
		end
	end
	function t14.getQuantityCounter(_)
		return clone
	end

	local clone = nil
	local clone2 = nil
	local connection2 = nil
	local clone3 = nil

	function t14.setEquipped(_, p50)
		if p50 then
			if not clone then
				clone = equippedTag:Clone()
				clone.Parent = parent
			end

			clone.Visible = true
		elseif clone then
			clone.Visible = false
		end
	end
	function t14.setEquippedStyle(_, p52)
		if p52 == u116 then
			return
		end

		u116 = p52

		if p52 then
			applyDiffs(p23)

			for _, v in ipairs(p25) do
				if not parent:FindFirstChild(v.Name) then
					local clone = v:Clone()

					clone.Parent = parent
				end
			end

			for _, v in ipairs(p26) do
				if v:IsA("UIStroke") then
					v.Enabled = false
				elseif v:IsA("GuiObject") then
					v.Visible = false
				end
			end

			if p27 then
				for _, v in ipairs(p27.normalStrokes) do
					v.Enabled = false
				end

				for _, v in ipairs(p27.selectedTemplates) do
					local clone = v:Clone()

					clone:SetAttribute("__SelectedStroke", true)
					clone.Parent = parent
				end

				return
			end
		elseif not u115 then
			applyDiffs(p24)

			for _, v in ipairs(p25) do
				local vName = parent:FindFirstChild(v.Name)

				if vName then
					vName:Destroy()
				end
			end

			for _, v in ipairs(p26) do
				if v:IsA("UIStroke") then
					v.Enabled = true
				elseif v:IsA("GuiObject") then
					v.Visible = true
				end
			end

			if p27 then
				for _, v in ipairs(parent:GetChildren()) do
					if v:GetAttribute("__SelectedStroke") then
						v:Destroy()
					end
				end

				for _, v in ipairs(p27.normalStrokes) do
					v.Enabled = true
				end
			end
		end
	end
	function t14.getEquippedTag(_)
		return clone
	end
	function t14.setFinisher(_, p55)
		if p55 and p55 ~= "" then
			if not clone2 then
				clone2 = finisherTag:Clone()
				clone2.Parent = parent
			end

			clone2.Visible = true

			local uIGradient = not connection2 and clone2:FindFirstChildOfClass("UIGradient")

			if uIGradient then
				local function upd()
					uIGradient.Rotation = os.clock() * 66 % 360
				end

				connection2 = runService.Heartbeat:Connect(function(deltaTime: number)
					if not clone2 or not clone2.Parent then
						if connection2 then
							connection2:Disconnect()
							connection2 = nil
						end

						return
					end

					uIGradient.Rotation = os.clock() * 66 % 360
				end)
				uIGradient.Rotation = os.clock() * 66 % 360

				return
			end
		else
			if clone2 then
				clone2.Visible = false
			end

			if connection2 then
				connection2:Disconnect()
				connection2 = nil
			end
		end
	end
	function t14.getFinisherTag(_)
		return clone2
	end
	function t14.setAlert(_, p59, p60)
		if p59 then
			if not clone3 then
				clone3 = alert:Clone()
				clone3.Parent = parent
			end

			clone3.Visible = true

			local quantity = clone3:FindFirstChild("Quantity")

			if quantity then
				local v424 = p60 or 1

				quantity.Text = if v424 > 99 then "!" else if v424 > 1 then tostring(v424) else ""

				return
			end
		elseif clone3 then
			clone3.Visible = false
		end
	end
	function t14.getAlertTag(_)
		return clone3
	end
	function t14.destroy(_)
		if connection then
			connection:Disconnect()
			connection = nil
		end

		if connection2 then
			connection2:Disconnect()
			connection2 = nil
		end

		parent:Destroy()
	end

	parent:GetAttributeChangedSignal("Selected"):Connect(function()
		local selected = parent:GetAttribute("Selected")

		if typeof(selected) == "boolean" and selected ~= u115 then
			t14:setSelected(selected)
		end
	end)

	return t14
end
function module.createItemCell(p63, p64)
	local v138 = itemCells:FindFirstChild(p63 .. "Cell") or itemCells:FindFirstChild("CommonCell")

	assert(v138, "UIFramework: no ItemCell template for " .. p63)

	local foundChild = selectedItemCells:FindFirstChild(p63 .. "Cell_Selected")

	if not foundChild then
		foundChild = selectedItemCells:FindFirstChild("CommonCell_Selected")
	end

	local clone = v138:Clone()
	local t15

	if foundChild then
		t15 = {}

		local function diffInstance(p65, p66)
			local t27: {[any]: any} = {}

			for k, v in pairs(t2) do
				if p65:IsA(k) then
					for _, iterValue in ipairs(v) do
						table.insert(t27, iterValue)
					end
				end
			end

			local t28: {[any]: any} = {}
			local u436: boolean = false

			for _, v in ipairs(t27) do
				local ok, result = pcall(function()
					return p65[v]
				end)

				local ok3, result3 = pcall(function()
					return p66[v]
				end)

				if ok and ok3 and tostring(result) ~= tostring(result3) then
					t28[v] = result3
					u436 = true
				end
			end

			if u436 then
				table.insert(t15, { inst = p65, props = t28 })
			end

			for _, v in ipairs(p65:GetChildren()) do
				if not v:IsA("UIStroke") or p65 ~= clone then
					local vName = p66:FindFirstChild(v.Name)

					if vName and vName.ClassName == v.ClassName then
						diffInstance(v, vName)
					end
				end
			end
		end

		diffInstance(clone, foundChild)
	else
		t15 = {}
	end

	local v143 = cacheOriginals(t15)
	local t16 = if foundChild then findSelectedOnlyChildren(clone, foundChild) else {}
	local t17

	if foundChild then
		t17 = {}

		local function recurse(p67, p68)
			for _, v in ipairs(p67:GetChildren()) do
				local vName = p68:FindFirstChild(v.Name)

				if not vName then
					table.insert(t17, v)
				elseif vName.ClassName == v.ClassName then
					recurse(v, vName)
				end
			end
		end

		recurse(clone, foundChild)
	else
		t17 = {}
	end

	local v147 = if foundChild then collectStrokeSwaps(clone, foundChild) else nil

	setupKeybind(clone, p64 and p64.keybind, p64 and p64.keybindAction)

	local image = p64 and p64.icon
	local icon = clone:FindFirstChild("Icon")

	if icon and image then
		icon.Image = image
	end

	applyOpts(clone, p64)

	local v150 = wireSelected(clone, t15, v143, t16, t17, v147, p64)
	local outer = clone:FindFirstChild("Outer")

	if outer and outer:FindFirstChildOfClass("UIGradient") then
		local connection = nil

		connection = runService.Heartbeat:Connect(function(deltaTime: number)
			if not clone:IsDescendantOf(game) then
				connection:Disconnect()

				return
			end

			v452.Rotation = (v452.Rotation + deltaTime * 60) % 360
		end)
	end

	local pattern = clone:FindFirstChild("Pattern")
	local uiGradient = pattern and pattern:FindFirstChildOfClass("UIGradient")

	if uiGradient then
		local t18: {[any]: any} = {}

		for _, v in ipairs(uiGradient.Transparency.Keypoints) do
			table.insert(t18, NumberSequenceKeypoint.new(v.Time, 1 - v.Value, v.Envelope))
		end

		local n1: number = 0

		local function buildScrolled(p70)
			local t29: {[any]: any} = {}

			for i = -1, 1 do
				for _, v in ipairs(t18) do
					local n1 = v.Time + p70 + i

					if n1 > 0 and n1 < 1 then
						table.insert(t29, NumberSequenceKeypoint.new(n1, v.Value, v.Envelope))
					end
				end
			end

			table.sort(t29, function(p71, p72)
				return p71.Time < p72.Time
			end)

			local v459 = if #t29 > 0 then t29[#t29].Value else 1

			table.insert(t29, 1, NumberSequenceKeypoint.new(0, if #t29 > 0 then t29[1].Value else 1))
			table.insert(t29, NumberSequenceKeypoint.new(1, v459))

			return NumberSequence.new(t29)
		end

		local connection = nil

		connection = runService.Heartbeat:Connect(function(deltaTime: number)
			if not clone:IsDescendantOf(game) then
				connection:Disconnect()

				return
			end

			n1 = (n1 + deltaTime * 0.35) % 1
			uiGradient.Transparency = buildScrolled(n1)
		end)
	end

	return clone, v150
end

local t3: {[any]: any} = { Knife = "Secret", Revolver = "Rare", Character = "Uncommon" }

function module.createAbilityCell(p74, p75)
	local v163 = t3[p74] or "Common"
	local v164 = itemCells:FindFirstChild(v163 .. "Cell") or itemCells:FindFirstChild("CommonCell")

	assert(v164, "UIFramework: no ItemCell template for " .. v163)

	local foundChild = selectedItemCells:FindFirstChild(v163 .. "Cell_Selected")

	if not foundChild then
		foundChild = selectedItemCells:FindFirstChild("CommonCell_Selected")
	end

	local clone = v164:Clone()
	v164 = { "Pattern", "Outer", "InnerGlow" }

	if v163 == "Secret" then
		for _, v in ipairs(v164) do
			local v = clone:FindFirstChild(v)

			if v then
				v:Destroy()
			end
		end
	end

	local icon = clone:FindFirstChild("Icon")

	if icon then
		icon.Name = "AbilityIcon"
	end

	local clone2 = nil

	if foundChild then
		clone2 = foundChild:Clone()

		if v163 == "Secret" then
			for _, v in ipairs(v164) do
				local v = clone2:FindFirstChild(v)

				if v then
					v:Destroy()
				end
			end
		end

		local icon2 = clone2:FindFirstChild("Icon")

		if icon2 then
			icon2.Name = "AbilityIcon"
		end
	end

	local t19

	if clone2 then
		t19 = {}

		local function diffInstance(p76, p77)
			local t30: {[any]: any} = {}

			for k, v in pairs(t2) do
				if p76:IsA(k) then
					for _, iterValue in ipairs(v) do
						table.insert(t30, iterValue)
					end
				end
			end

			local t31: {[any]: any} = {}
			local u469: boolean = false

			for _, v in ipairs(t30) do
				local ok, result = pcall(function()
					return p76[v]
				end)

				local ok4, result4 = pcall(function()
					return p77[v]
				end)

				if ok and ok4 and tostring(result) ~= tostring(result4) then
					t31[v] = result4
					u469 = true
				end
			end

			if u469 then
				table.insert(t19, { inst = p76, props = t31 })
			end

			for _, v in ipairs(p76:GetChildren()) do
				if not v:IsA("UIStroke") or p76 ~= clone then
					local vName = p77:FindFirstChild(v.Name)

					if vName and vName.ClassName == v.ClassName then
						diffInstance(v, vName)
					end
				end
			end
		end

		diffInstance(clone, clone2)
	else
		t19 = {}
	end

	local v178 = cacheOriginals(t19)
	local t20 = if clone2 then findSelectedOnlyChildren(clone, clone2) else {}
	local t21

	if clone2 then
		t21 = {}

		local function recurse(p78, p79)
			for _, v in ipairs(p78:GetChildren()) do
				local vName = p79:FindFirstChild(v.Name)

				if not vName then
					table.insert(t21, v)
				elseif vName.ClassName == v.ClassName then
					recurse(v, vName)
				end
			end
		end

		recurse(clone, clone2)
	else
		t21 = {}
	end

	local v182 = if clone2 then collectStrokeSwaps(clone, clone2) else nil

	if clone2 then
		clone2:Destroy()
	end

	setupKeybind(clone, p75 and p75.keybind, p75 and p75.keybindAction)
	clone2 = p75 and p75.icon and clone:FindFirstChild("AbilityIcon")

	if clone2 then
		clone2.Image = p75.icon
		clone2.Size = UDim2.fromScale(0.92, 0.92)
	end

	applyOpts(clone, p75)

	local v183 = wireSelected(clone, t19, v178, t20, t21, v182, p75)

	return clone, v183
end

local t4: {[any]: any} = {
	Common = nil,
	Uncommon = 0.303,
	Rare = 0.585,
	Epic = 0.766,
	Legendary = 0.14,
	Secret = 0,
	Collectible = 0.488,
	Exclusive = 0.074
}

function module.applyRarityColor(p80, p81)
	local v186, v187, v188 = p80:ToHSV()
	local v189 = t4[p81]

	if v189 == nil then
		return Color3.fromHSV(0, 0, v188)
	end

	return Color3.fromHSV(v189, v187, v188)
end

local disabledButton = misc:WaitForChild("DisabledButton")
local vColor = nil
local u33 = nil
local TextColor3 = nil
local u35 = nil
local color3 = Color3.fromRGB(160, 160, 160)
local Thickness = nil

for _, v in ipairs(disabledButton:GetChildren()) do
	if v:IsA("UIGradient") then
		vColor = v.Color

		break
	end
end

for _, v in ipairs(disabledButton:GetChildren()) do
	if v:IsA("UIStroke") and v.Color == Color3.new(1, 1, 1) then
		Thickness = v.Thickness

		break
	end
end

local textLabel = disabledButton:FindFirstChild("TextLabel")

if textLabel and textLabel:IsA("TextLabel") then
	TextColor3 = textLabel.TextColor3
	DISABLED_OUTER_TEXT_TRANSPARENCY = textLabel.TextTransparency

	local textLabel2 = textLabel:FindFirstChild("TextLabel")

	if textLabel2 and textLabel2:IsA("TextLabel") then
		local uiGradient = textLabel2:FindFirstChildOfClass("UIGradient")

		if uiGradient then
			u33 = uiGradient.Color
		end

		local uiStroke = textLabel2:FindFirstChildOfClass("UIStroke")

		if uiStroke then
			u35 = uiStroke.Color
		end
	end
end

local t5: {[any]: any} = {}

local function cacheButtonOriginals(p82)
	if t5[p82] then
		return
	end

	local t22: {[any]: any} = {}

	for _, v in ipairs(p82:GetChildren()) do
		if v:IsA("UIGradient") and v.Name ~= "Default" then
			t22.btnGradientColor = v.Color

			break
		end
	end

	for _, v in ipairs(p82:GetChildren()) do
		if v:IsA("UIStroke") and v.Color.R > 0.9 and v.Color.G > 0.9 and v.Color.B > 0.9 then
			t22.whiteStrokeThickness = v.Thickness

			break
		end
	end

	local textLabel3 = p82:FindFirstChild("TextLabel")

	if textLabel3 and textLabel3:IsA("TextLabel") then
		t22.outerTextColor = textLabel3.TextColor3
		t22.outerTextTransparency = textLabel3.TextTransparency

		local textLabel4 = textLabel3:FindFirstChild("TextLabel")

		if textLabel4 and textLabel4:IsA("TextLabel") then
			t22.innerTextColor = textLabel4.TextColor3

			local uiGradient = textLabel4:FindFirstChildOfClass("UIGradient")

			if uiGradient then
				t22.innerGradientColor = uiGradient.Color
			end

			local uiStroke = textLabel4:FindFirstChildOfClass("UIStroke")

			if uiStroke then
				t22.innerStrokeColor = uiStroke.Color
			end
		end
	end

	local icon = p82:FindFirstChild("Icon")

	if icon and icon:IsA("ImageLabel") then
		t22.iconColor = icon.ImageColor3
	end

	t5[p82] = t22
end
function module.setButtonDisabled(p83)
	cacheButtonOriginals(p83)
	p83.Active = false
	p83.Interactable = false
	p83.AutoButtonColor = false

	for _, v in ipairs(p83:GetChildren()) do
		if v:IsA("UIGradient") and v.Name ~= "Default" then
			v.Color = vColor

			break
		end
	end

	if Thickness then
		for _, v in ipairs(p83:GetChildren()) do
			if v:IsA("UIStroke") and v.Color.R > 0.9 and v.Color.G > 0.9 and v.Color.B > 0.9 then
				v.Thickness = Thickness

				break
			end
		end
	end

	local textLabel5 = p83:FindFirstChild("TextLabel")

	if textLabel5 and textLabel5:IsA("TextLabel") then
		textLabel5.TextColor3 = TextColor3
		textLabel5.TextTransparency = DISABLED_OUTER_TEXT_TRANSPARENCY

		local textLabel6 = textLabel5:FindFirstChild("TextLabel")

		if textLabel6 and textLabel6:IsA("TextLabel") then
			local v208 = u33 and textLabel6:FindFirstChildOfClass("UIGradient")

			if v208 then
				v208.Color = u33
			end

			v208 = u35 and textLabel6:FindFirstChildOfClass("UIStroke")

			if v208 then
				v208.Color = u35
			end
		end
	end

	local icon = p83:FindFirstChild("Icon")

	if icon and icon:IsA("ImageLabel") then
		icon.ImageColor3 = color3
	end
end
function module.setButtonEnabled(p84)
	local v211 = t5[p84]

	p84.Active = true
	p84.Interactable = true
	p84.AutoButtonColor = false

	if v211 and v211.btnGradientColor then
		for _, v in ipairs(p84:GetChildren()) do
			if v:IsA("UIGradient") and v.Name ~= "Default" then
				v.Color = v211.btnGradientColor

				break
			end
		end
	end

	if v211 and v211.whiteStrokeThickness then
		for _, v in ipairs(p84:GetChildren()) do
			if v:IsA("UIStroke") and v.Color.R > 0.9 and v.Color.G > 0.9 and v.Color.B > 0.9 then
				v.Thickness = v211.whiteStrokeThickness

				break
			end
		end
	end

	local textLabel7 = p84:FindFirstChild("TextLabel")

	if textLabel7 and textLabel7:IsA("TextLabel") then
		if v211 and v211.outerTextColor then
			textLabel7.TextColor3 = v211.outerTextColor
		end

		if v211 and v211.outerTextTransparency then
			textLabel7.TextTransparency = v211.outerTextTransparency
		end

		local textLabel8 = textLabel7:FindFirstChild("TextLabel")

		if textLabel8 and textLabel8:IsA("TextLabel") then
			local v218 = v211 and v211.innerGradientColor and textLabel8:FindFirstChildOfClass("UIGradient")

			if v218 then
				v218.Color = v211.innerGradientColor
			end

			v218 = v211 and v211.innerStrokeColor and textLabel8:FindFirstChildOfClass("UIStroke")

			if v218 then
				v218.Color = v211.innerStrokeColor
			end
		end
	end

	local icon = p84:FindFirstChild("Icon")

	if icon and icon:IsA("ImageLabel") and v211 and v211.iconColor then
		icon.ImageColor3 = v211.iconColor
	end
end
function module.setupCoinCounter(p85, p86)
	local tweenService2: TweenService = game:GetService("TweenService")
	local u223 = nil
	local u224 = nil

	for _, v in ipairs(p85:GetChildren()) do
		if v:IsA("TextLabel") and v.Name == "TextLabel" then
			u223 = v

			local textLabel9 = v:FindFirstChild("TextLabel")

			if not textLabel9 or not textLabel9:IsA("TextLabel") then
				break
			end

			u224 = textLabel9

			break
		end
	end

	if not u223 then
		return
	end

	local function formatCash(p87)
		local floored = math.floor(p87)
		local text = tostring(floored)

		repeat
			local v487, v488 = text:gsub("^(-?%d+)(%d%d%d)", "%1,%2")

			text = v487
		until v488 == 0

		return "$" .. text
	end
	local function setText(p88)
		local text = formatCash(p88)

		u223.Text = text

		if u224 then
			u224.Text = text
		end
	end

	local n1: number = 0
	local textSize = u223.TextSize
	local v232 = u223.Position
	local textColor3 = u223.TextColor3

	local function playAnim(p89)
		if p89 == 0 or not u223 then
			return
		end

		n1 += 1

		local v492: number = n1

		u223.TextSize = textSize
		u223.Position = v232
		u223.TextColor3 = textColor3

		local v493

		if p89 > 0 then
			local color3New = Color3.new
			local v495 = math.clamp(textColor3.R + 0.25, 0, 1)
			local v496 = math.clamp(textColor3.G + 0.25, 0, 1)
			local v497 = math.clamp(textColor3.B + 0.25, 0, 1)

			v493 = color3New(v495, v496, v497)
		else
			local v498 = Color3.new
			local v499 = math.clamp(textColor3.R - 0.25, 0, 1)
			local v500 = math.clamp(textColor3.G - 0.25, 0, 1)
			local v501 = math.clamp(textColor3.B - 0.25, 0, 1)

			v493 = v498(v499, v500, v501)
		end

		local uDim2 = UDim2.new(v232.X.Scale, v232.X.Offset, v232.Y.Scale, v232.Y.Offset - 3)
		local v503 = u223
		local tweenInfo7 = TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		local v505: Tween = tweenService2:Create(v503, tweenInfo7, { TextSize = textSize + 2, Position = uDim2, TextColor3 = v493 })
		local v506 = u223
		local tweenInfo8 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local v508: Tween = tweenService2:Create(v506, tweenInfo8, { TextSize = textSize, Position = v232, TextColor3 = textColor3 })

		v505:Play()
		v505.Completed:Connect(function()
			if n1 ~= v492 then
				return
			end

			v508:Play()
		end)
	end

	local cash = p86:GetAttribute("Cash")

	if typeof(cash) ~= "number" then
		cash = 0
	end

	local text = formatCash(cash)

	u223.Text = text

	if u224 then
		u224.Text = text
	end

	p86:GetAttributeChangedSignal("Cash"):Connect(function()
		local cash2 = p86:GetAttribute("Cash")

		if typeof(cash2) ~= "number" then
			cash2 = 0
		end

		local n1 = cash2 - cash

		cash = cash2

		local text = formatCash(cash2)

		u223.Text = text

		if u224 then
			u224.Text = text
		end

		playAnim(n1)
	end)
end
function module.bindKeybindLabel(p90, p91, p92)
	local extensions: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Extensions")
	local inputMap = require(extensions:WaitForChild("InputMap"))
	local keyBind = p90:FindFirstChild("KeyBind")

	if not keyBind then
		return nil
	end

	local t23 = if typeof(p91) == "table" then p91 else { p91 }
	local v244 = p92 and p92.separator or "/"
	local connection = nil
	local connection2 = nil
	local u247 = nil

	local function resolve()
		local t32: {[any]: any} = {}

		for _, v in ipairs(t23) do
			local v515 = inputMap.primaryText(v)

			if v515 then
				table.insert(t32, v515)
			end
		end

		if #t32 == 0 then
			return "—"
		end

		return table.concat(t32, v244)
	end

	local t24: {[any]: any} = {
		refresh = function(_)
			local text = resolve()

			keyBind:SetAttribute("OriginalText", text)

			if u247 == nil or keyBind.Text == u247 then
				u247 = text
				keyBind.Text = text

				return
			end
		end,
		destroy = function(_)
			if connection then
				connection:Disconnect()
				connection = nil
			end

			if connection2 then
				connection2:Disconnect()
				connection2 = nil
			end
		end
	}

	local text = resolve()

	keyBind:SetAttribute("OriginalText", text)

	if u247 == nil or u247 == keyBind.Text then
		u247 = text
		keyBind.Text = text
	end

	connection = inputMap.changed:Connect(function()
		local text = resolve()

		keyBind:SetAttribute("OriginalText", text)

		if u247 == nil or keyBind.Text == u247 then
			u247 = text
			keyBind.Text = text

			return
		end
	end)
	connection2 = p90.AncestryChanged:Connect(function(_, p96)
		if p96 == nil then
			t24:destroy()
		end
	end)

	return t24
end

local t6: {[any]: any} = {}

function module.applyGamepadKeybind(parent, p98, p99)
	local userInputService: UserInputService = game:GetService("UserInputService")
	local extensions: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Extensions")
	local inputCategorizer = require(extensions:WaitForChild("InputCategorizer"))
	local keyBind = parent:FindFirstChild("KeyBind")
	local gamepadIcon = parent:FindFirstChild("GamepadIcon")

	if gamepadIcon then
		gamepadIcon:Destroy()
	end

	local gamepadIcon: ImageLabel = Instance.new("ImageLabel")

	gamepadIcon.Name = "GamepadIcon"
	gamepadIcon.Size = UDim2.fromScale(0.9, 0.9)
	gamepadIcon.Position = UDim2.fromScale(0.5, 0.5)
	gamepadIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	gamepadIcon.BackgroundTransparency = 1
	gamepadIcon.ScaleType = Enum.ScaleType.Fit
	gamepadIcon.ZIndex = parent.ZIndex + 1
	gamepadIcon.ImageColor3 = Color3.new(1, 1, 1)
	gamepadIcon.Visible = false

	local ok, result = pcall(function()
		return userInputService:GetImageForKeyCode(p98)
	end)

	if ok and result ~= "" then
		gamepadIcon.Image = result
	end

	gamepadIcon.Parent = parent

	local function refresh()
		local v522 = inputCategorizer.getLastInputCategory()
		local visible: boolean = v522 == inputCategorizer.InputCategory.Gamepad
		local u524: boolean = v522 == inputCategorizer.InputCategory.Touch

		parent.Visible = not u524 or p99 ~= nil
		gamepadIcon.Visible = visible

		if not keyBind then
			return
		end

		if p99 and u524 then
			keyBind.Visible = true

			if not keyBind:GetAttribute("OriginalText") then
				keyBind:SetAttribute("OriginalText", keyBind.Text)
			end

			keyBind.Text = p99

			return
		end

		local originalText = keyBind:GetAttribute("OriginalText")

		if originalText then
			keyBind.Text = originalText
		end

		keyBind.Visible = not visible and not u524
	end

	refresh()

	local connection = inputCategorizer.lastInputCategoryChanged:Connect(refresh)

	table.insert(t6, connection)

	return {
		setColor = function(_, imageColor3)
			gamepadIcon.ImageColor3 = imageColor3
		end,
		destroy = function(_)
			connection:Disconnect()

			if gamepadIcon.Parent then
				gamepadIcon:Destroy()
			end
		end
	}
end

local userInputService: UserInputService = game:GetService("UserInputService")
local u50 = nil

function module.wireSlider(p103)
	local barContainer = p103.barContainer
	local innerBar = p103.innerBar
	local knob = p103.knob
	local valueLabel = p103.valueLabel
	local min = p103.min
	local max = p103.max
	local default = p103.default
	local getValue = p103.getValue
	local setValue = p103.setValue
	local onChange = p103.onChange
	local v275 = p103.isPercent or false
	local snapValue = p103.snapValue
	local formatSuffix = p103.formatSuffix
	local v278 = p103.normalizeDefault or false
	local v279 = p103.knobPositionAxis or false
	local v280 = p103.stepPercent or 0.02
	local v281 = p103.gamepadSelectable or false
	local gamepadParent = p103.gamepadParent
	local u283: boolean = false

	local function valueToRatio(p104)
		if max == min then
			return 0
		end

		if not v278 then
			return (p104 - min) / (max - min)
		end

		if not (p104 <= default) then
			if default == max then
				return 0.5
			end

			return (p104 - default) * 0.5 / (max - default) + 0.5
		end

		if default == min then
			return 0.5
		end

		return (p104 - min) * 0.5 / (default - min)
	end
	local function ratioToValue(p105)
		if max == min then
			return min
		end

		if not v278 then
			return min + p105 * (max - min)
		end

		if not (p105 <= 0.5) then
			if default == max then
				return max
			end

			return default + (p105 - 0.5) / 0.5 * (max - default)
		end

		if default == min then
			return min
		end

		return min + p105 / 0.5 * (default - min)
	end
	local function formatValue(p106)
		if formatSuffix then
			return string.format("%.2fx", p106 / 100)
		end

		if v275 then
			return tostring(p106) .. "%"
		end

		return (tostring(p106))
	end
	local function setVisual(p107)
		local v533 = math.clamp(p107, 0, 1)

		innerBar.Size = UDim2.new(v533, 0, 1, 0)

		if knob and v279 then
			knob.Position = UDim2.new(v533, 0, knob.Position.Y.Scale, knob.Position.Y.Offset)
		end

		local floored = math.floor((if max == min then min else if not v278 then min + v533 * (max - min) else if v533 <= 0.5 then if default == min then min else min + v533 / 0.5 * (default - min) else if default == max then max else default + (v533 - 0.5) / 0.5 * (max - default)) + 0.5)

		if valueLabel then
			if not valueLabel:IsA("TextBox") then
				local formattedText

				if formatSuffix then
					formattedText = string.format("%.2fx", floored / 100)
				elseif v275 then
					formattedText = tostring(floored) .. "%"
				else
					formattedText = tostring(floored)
				end

				valueLabel.Text = formattedText
			elseif not valueLabel:IsFocused() then
				local formattedText

				if formatSuffix then
					formattedText = string.format("%.2fx", floored / 100)
				elseif v275 then
					formattedText = tostring(floored) .. "%"
				else
					formattedText = tostring(floored)
				end

				valueLabel.Text = formattedText

				return
			end

			return
		end
	end
	local function applyValue(p108)
		local v538 = math.clamp(p108, 0, 1)

		if snapValue then
			local v539 = snapValue
			local n1 = if max == min then 0 else if not v278 then (v539 - min) / (max - min) else if v539 <= default then if default == min then 0.5 else (v539 - min) * 0.5 / (default - min) else if default == max then 0.5 else (v539 - default) * 0.5 / (max - default) + 0.5

			if math.abs(v538 - n1) < 0.03 then
				v538 = n1
			end
		end

		local floored = math.floor((if max == min then min else if not v278 then min + v538 * (max - min) else if v538 <= 0.5 then if default == min then min else min + v538 / 0.5 * (default - min) else if default == max then max else default + (v538 - 0.5) / 0.5 * (max - default)) + 0.5)

		setValue(floored)
		setVisual(if max == min then 0 else if not v278 then (floored - min) / (max - min) else if floored <= default then if default == min then 0.5 else (floored - min) * 0.5 / (default - min) else if default == max then 0.5 else (floored - default) * 0.5 / (max - default) + 0.5)

		if onChange then
			onChange()
		end
	end
	local function onInput(p109)
		if not u283 then
			return
		end

		local x = barContainer.AbsoluteSize.X

		if x <= 0 then
			return
		end

		local v544 = math.clamp((p109.Position.X - barContainer.AbsolutePosition.X) / x, 0, 1)

		applyValue(v544)
	end

	barContainer.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		if u50 ~= nil then
			return
		end

		u50 = input
		u283 = true

		do
			local x = barContainer.AbsoluteSize.X

			if x <= 0 then
				return
			end

			local v547 = math.clamp((input.Position.X - barContainer.AbsolutePosition.X) / x, 0, 1)

			applyValue(v547)

			return
		end
	end)

	if knob then
		knob.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			if u50 ~= nil then
				return
			end

			u50 = input
			u283 = true

			do
				local x = barContainer.AbsoluteSize.X

				if x <= 0 then
					return
				end

				local v550 = math.clamp((input.Position.X - barContainer.AbsolutePosition.X) / x, 0, 1)

				applyValue(v550)

				return
			end
		end)
	end

	userInputService.InputChanged:Connect(function(input: InputObject)
		if not u283 then
			return
		end

		local v552: boolean = false

		if input.UserInputType ~= Enum.UserInputType.MouseMovement then
			if input.UserInputType ~= Enum.UserInputType.Touch or input ~= u50 then
				return
			end

			v552 = true
		end

		if not u283 then
			return
		end

		local x = barContainer.AbsoluteSize.X

		if x <= 0 then
			return
		end

		local v554 = math.clamp((input.Position.X - barContainer.AbsolutePosition.X) / x, 0, 1)

		applyValue(v554)
	end)
	userInputService.InputEnded:Connect(function(input: InputObject)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and u283 and input == u50 then
			u283 = false
			u50 = nil
		end
	end)

	if valueLabel and valueLabel:IsA("TextBox") then
		valueLabel.FocusLost:Connect(function()
			local valueLabelText = valueLabel.Text

			if formatSuffix then
				local replacedText = valueLabelText:gsub("x$", ""):gsub("X$", "")

				replacedText = tonumber(replacedText)

				if replacedText then
					local v558 = if replacedText <= max / 100 + 0.01 then math.clamp(math.floor(replacedText * 100 + 0.5), min, max) else math.clamp(math.floor(replacedText + 0.5), min, max)

					setValue(v558)
					setVisual(if max == min then 0 else if not v278 then (v558 - min) / (max - min) else if v558 <= default then if default == min then 0.5 else (v558 - min) * 0.5 / (default - min) else if default == max then 0.5 else (v558 - default) * 0.5 / (max - default) + 0.5)
				else
					setValue(default)

					local v559 = default

					setVisual(if max == min then 0 else if not v278 then (v559 - min) / (max - min) else if v559 <= default then if default == min then 0.5 else (v559 - min) * 0.5 / (default - min) else if default == max then 0.5 else (v559 - default) * 0.5 / (max - default) + 0.5)
				end

				if onChange then
					onChange()
				end

				local v560 = getValue()
				local formattedText

				if formatSuffix then
					formattedText = string.format("%.2fx", v560 / 100)
				elseif v275 then
					formattedText = tostring(v560) .. "%"
				else
					formattedText = tostring(v560)
				end

				valueLabel.Text = formattedText

				return
			end

			local numberValue: number? = tonumber(valueLabelText)

			if numberValue then
				local floored = math.floor(numberValue)
				local v564 = math.clamp(floored, min, max)

				setValue(v564)
				setVisual(if max == min then 0 else if not v278 then (v564 - min) / (max - min) else if v564 <= default then if default == min then 0.5 else (v564 - min) * 0.5 / (default - min) else if default == max then 0.5 else (v564 - default) * 0.5 / (max - default) + 0.5)

				if onChange then
					onChange()

					return
				end
			else
				setValue(default)

				local v565 = default

				setVisual(if max == min then 0 else if not v278 then (v565 - min) / (max - min) else if v565 <= default then if default == min then 0.5 else (v565 - min) * 0.5 / (default - min) else if default == max then 0.5 else (v565 - default) * 0.5 / (max - default) + 0.5)

				if onChange then
					onChange()
				end
			end
		end)
	end

	local floored = math.floor((max - min) * v280 + 0.5)
	local u291 = math.max(1, floored)
	local v292 = getValue()
	local v293 = math.clamp(v292, min, max)

	setVisual(if max == min then 0 else if not v278 then (v293 - min) / (max - min) else if default >= v293 then if default == min then 0.5 else (v293 - min) * 0.5 / (default - min) else if default == max then 0.5 else (v293 - default) * 0.5 / (max - default) + 0.5)
	v292 = nil

	if v281 then
		v292 = Instance.new("TextButton")
		v292.Name = "GamepadProxy"
		v292.Text = ""
		v292.BackgroundTransparency = 1
		v292.BorderSizePixel = 0
		v292.Size = UDim2.new(1, 0, 1, 0)
		v292.Position = UDim2.new(0, 0, 0, 0)
		v292.AnchorPoint = Vector2.new(0, 0)
		v292.ZIndex = 0
		v292.Selectable = true
		v292.Active = false
		v292.Interactable = false
		v292.Parent = gamepadParent or barContainer
	end

	return {
		refresh = function()
			local v566 = getValue()
			local v567 = math.clamp(v566, min, max)

			setVisual(if max == min then 0 else if not v278 then (v567 - min) / (max - min) else if not (v567 <= default) then if default == max then 0.5 else (v567 - default) * 0.5 / (max - default) + 0.5 else if default == min then 0.5 else (v567 - min) * 0.5 / (default - min))
		end,
		adjustByDelta = function(p114)
			local v569 = getValue()
			local v570 = math.clamp(v569 + p114 * u291, min, max)

			setValue(v570)
			setVisual(if max == min then 0 else if not v278 then (v570 - min) / (max - min) else if v570 <= default then if default == min then 0.5 else (v570 - min) * 0.5 / (default - min) else if default == max then 0.5 else (v570 - default) * 0.5 / (max - default) + 0.5)

			if onChange then
				onChange()
			end
		end,
		setRange = function(p115, p116, p117)
			min = p115
			max = p116
			default = p117 or min

			local floored2 = math.floor((max - min) * (p103.stepPercent or 0.02) + 0.5)

			u291 = math.max(1, floored2)
		end,
		proxy = v292
	}
end

local logService: LogService = game:GetService("LogService")
local flagNotify: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("FlagNotify")
local u53: boolean = false

local function matchSignature(p118)
	local lowerText = string.lower(p118)

	if string.find(lowerText, "loadstring") and string.find(lowerText, "coregui") then
		return "loadstring"
	end

	if string.find(p118, "ESPHighlight") then
		return "esphighlight"
	end

	if string.find(p118, "CoreGui%.%d+%.%d+:%d+") then
		return "coregui_numbered"
	end

	return nil
end

logService.MessageOut:Connect(function(message: string, messageType: Enum.MessageType)
	if u53 then
		return
	end

	local v298 = matchSignature(message)

	if v298 then
		u53 = true
		pcall(function()
			flagNotify:FireServer(v298)
		end)
	end
end)

local scriptContext: ScriptContext = game:GetService("ScriptContext")
local u56: boolean = false

scriptContext.Error:Connect(function(message: string, stackTrace: string, script: Instance)
	if u56 then
		return
	end

	local u302 = script == nil

	if not u302 and typeof(script) == "Instance" then
		local ok, result = pcall(function()
			return script:IsDescendantOf(game)
		end)

		u302 = ok and not result
	end

	if not u302 then
		return
	end

	u56 = true

	local stringMatch = string.match
	local text: string = tostring(stackTrace or "")
	local v307 = stringMatch(text, "^[^\n]*") or ""

	pcall(function()
		local v575 = string.sub(v307, 1, 80)

		flagNotify:FireServer("scripterr", v575)
	end)
end)

return module
