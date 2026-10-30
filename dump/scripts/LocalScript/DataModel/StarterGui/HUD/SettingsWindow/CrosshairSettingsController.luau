-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local tweenService: TweenService = game:GetService("TweenService")
local userInputService: UserInputService = game:GetService("UserInputService")
local playerGui: Instance = players.LocalPlayer:WaitForChild("PlayerGui")
local hud: Instance = playerGui:WaitForChild("HUD")
local uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local crosshairSettings = require(shared:WaitForChild("CrosshairSettings"))
local settingsWindow: Instance = hud:WaitForChild("SettingsWindow")
local contentCrosshair: Instance = settingsWindow:WaitForChild("ContentCrosshair")
local scrollingFrame: Instance = contentCrosshair:WaitForChild("ScrollingFrame")
local updateSettings: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("UpdateSettings")
local uiListLayout: Instance = scrollingFrame:FindFirstChildWhichIsA("UIListLayout")
local v15 = if uiListLayout then uiListLayout.Padding.Scale else 0

scrollingFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	if uiListLayout then
		local uDimNew = UDim.new
		local rounded = math.round(v15 * scrollingFrame.AbsoluteSize.Y)

		uiListLayout.Padding = uDimNew(0, rounded)
	end
end)

if uiListLayout then
	local uDimNew = UDim.new
	local rounded = math.round(v15 * scrollingFrame.AbsoluteSize.Y)

	uiListLayout.Padding = uDimNew(0, rounded)
end

local v18 = crosshairSettings.getActive()
local t1: {[any]: any} = {}
local t2: {[any]: any} = {}
local userInputServiceTouchEnabled: boolean = userInputService.TouchEnabled
local u22 = nil
local u23 = nil
local t3 = {}
local u25 = nil
local crosshairController: Instance = playerGui:WaitForChild("Cursor"):WaitForChild("CrosshairController")
local crosshairComponent = require(crosshairController:WaitForChild("CrosshairComponent"))
local centerDot: Instance = contentCrosshair:WaitForChild("Preview"):WaitForChild("CenterDot")
local frame: Instance = centerDot:WaitForChild("Frame")
local dot: Instance = centerDot:WaitForChild("Dot")
local circle: Instance = centerDot:FindFirstChild("Circle")

if circle and circle:IsA("GuiObject") then
	circle.Visible = false
end

for _, v in ipairs(frame:GetChildren()) do
	if v:IsA("Frame") then
		v:Destroy()
	end
end

local v34 = crosshairComponent.create(frame)

v34:setVisible(true)

local function updateMagneticLock(visible)
	for _, v in ipairs(t2) do
		local disabledFrame = v:FindFirstChild("DisabledFrame")

		if disabledFrame and disabledFrame:IsA("GuiObject") then
			disabledFrame.Visible = visible
		end
	end
end
local function applyMagneticMode()
	local visible: boolean = userInputServiceTouchEnabled and v18.MagneticEnabled == true

	if circle and circle:IsA("GuiObject") then
		circle.Visible = visible

		if visible and circle:IsA("ImageLabel") then
			circle.ImageTransparency = 0
		end
	end

	v34:setVisible(not visible)

	if visible and u23 then
		u23()
	end

	updateMagneticLock(visible)
end
local function refreshPreview()
	v34:applyStyle(v18)
	crosshairSettings.applyDot(dot, v18)
	applyMagneticMode()
	crosshairSettings.notifyChanged()
end

v34:applyStyle(v18)
crosshairSettings.applyDot(dot, v18)
applyMagneticMode()
crosshairSettings.notifyChanged()

local u38: boolean = false

local function queueSave()
	if u38 then
		return
	end

	u38 = true
	task.delay(0.3, function()
		u38 = false

		if u25 then
			u25()
		end

		local v181 = crosshairSettings.toWire(v18)

		v181.Palette = t3
		updateSettings:FireServer("UpdateCrosshair", v181)
	end)
end
local function onSettingChanged()
	v34:applyStyle(v18)
	crosshairSettings.applyDot(dot, v18)
	applyMagneticMode()
	crosshairSettings.notifyChanged()

	if u38 then
		return
	end

	u38 = true
	task.delay(0.3, function()
		u38 = false

		if u25 then
			u25()
		end

		local v182 = crosshairSettings.toWire(v18)

		v182.Palette = t3
		updateSettings:FireServer("UpdateCrosshair", v182)
	end)
end

local util: Instance = replicatedStorage:WaitForChild("Util")
local colorPicker = require(util:WaitForChild("ColorPicker"))
local color3 = Color3.fromRGB(20, 20, 20)
local color32 = Color3.fromRGB(40, 40, 40)
local color33 = Color3.fromRGB(255, 255, 255)
local u46 = nil
local u47: boolean = false
local t4: {[any]: any} = {}

u25 = function()
	if not u46 then
		return false
	end

	local v92 = u46:GetPaletteColors()

	if not v92 then
		return false
	end

	local u93: boolean = #v92 ~= #t3

	if not u93 then
		for i = 1, #v92 do
			if v92[i] ~= t3[i] then
				u93 = true

				break
			end
		end
	end

	t3 = v92

	return u93
end

local t5: {[any]: any} = {
	BackgroundColor = { Color = color3 },
	AccentColor = { Color = color32 },
	TextColor = { Color = color33 }
}

local function getPicker()
	if u46 then
		return u46
	end

	local colorPickerNew = colorPicker.new
	local v96 = UDim2.fromScale(0.63, 0.22)

	u46 = colorPickerNew({
		Size = 0.45,
		ZIndex = 10,
		PaletteEnabled = true,
		Resizable = false,
		TransparencyEnabled = false,
		UserCanClose = true,
		Parent = hud,
		Position = v96,
		PickerMode = colorPicker.PICKER_MODE.SQUARE,
		ColorSpace = colorPicker.COLOR_SPACE.RGB,
		Style = t5
	})
	u46:SetVisible(false)
	u46.ColorChanged:Connect(function(p2)
		if u47 then
			return
		end

		local v184 = u22

		if not v184 then
			return
		end

		v18[v184] = p2

		local v185 = t4[v184]

		if v185 then
			v185(p2)
		end

		v34:applyStyle(v18)
		crosshairSettings.applyDot(dot, v18)
		applyMagneticMode()
		crosshairSettings.notifyChanged()

		if u38 then
			return
		end

		u38 = true
		task.delay(0.3, function()
			u38 = false

			if u25 then
				u25()
			end

			local v195 = crosshairSettings.toWire(v18)

			v195.Palette = t3
			updateSettings:FireServer("UpdateCrosshair", v195)
		end)
	end)
	u46.WindowClosed:Connect(function()
		u22 = nil

		if u25 and u25() and not u38 then
			u38 = true
			task.delay(0.3, function()
				u38 = false

				if u25 then
					u25()
				end

				local v196 = crosshairSettings.toWire(v18)

				v196.Palette = t3
				updateSettings:FireServer("UpdateCrosshair", v196)
			end)
		end

		u46 = nil
	end)

	if #t3 > 0 then
		u46:AddPaletteColors(t3)
	end

	return u46
end
local function seedPicker(p3)
	u47 = true
	u46:SetColor(p3)
	u47 = false
end
local function openPickerFor(p4)
	getPicker()
	u22 = p4
	u47 = true
	u46:SetColor(v18[p4])
	u47 = false
	u46:SetVisible(true)
end

u23 = function()
	u22 = nil

	if u46 then
		if u25 and u25() and not u38 then
			u38 = true
			task.delay(0.3, function()
				u38 = false

				if u25 then
					u25()
				end

				local v186 = crosshairSettings.toWire(v18)

				v186.Palette = t3
				updateSettings:FireServer("UpdateCrosshair", v186)
			end)
		end

		u46:SetVisible(false)
	end
end

local function resyncPickerIfOpen()
	local v99 = u22

	if v99 and u46 and u46:GetVisible() then
		u47 = true
		u46:SetColor(v18[v99])
		u47 = false
	end
end

contentCrosshair:GetPropertyChangedSignal("Visible"):Connect(function()
	if not contentCrosshair.Visible and u23 then
		u23()
	end
end)
settingsWindow:GetPropertyChangedSignal("Visible"):Connect(function()
	if not settingsWindow.Visible and u23 then
		u23()
	end
end)

local resetBtn: Instance = scrollingFrame:WaitForChild("LineLength"):FindFirstChild("ResetBtn")
local lineWidth: Instance = scrollingFrame:FindFirstChild("LineWidth")
local v56 = if lineWidth then lineWidth:FindFirstChild("DisabledFrame") else nil
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function isSettingDisabled(p5, p6)
	if p6.disabled == true then
		return true
	end

	local v102 = p6.availability or "all"

	if v102 == "mobile" and not userInputServiceTouchEnabled then
		return true
	end

	if v102 == "desktop" and userInputServiceTouchEnabled then
		return true
	end

	local disabledFrame = p5:FindFirstChild("DisabledFrame")
	local u104 = false

	if disabledFrame ~= nil then
		u104 = disabledFrame:IsA("GuiObject") and disabledFrame.Visible
	end

	return u104
end
local function ensureDisabledOverlay(parent)
	local disabledFrame = parent:FindFirstChild("DisabledFrame")

	if disabledFrame and disabledFrame:IsA("GuiObject") then
		return disabledFrame
	end

	if not v56 then
		return nil
	end

	local clone = v56:Clone()

	clone.Name = "DisabledFrame"
	clone.Parent = parent

	if clone:IsA("GuiObject") then
		return clone
	end

	return nil
end
local function applyDisabledOverlay(parent)
	local disabledFrame = parent:FindFirstChild("DisabledFrame")
	local v110

	if disabledFrame and disabledFrame:IsA("GuiObject") then
		v110 = disabledFrame
	elseif not v56 then
		v110 = nil
	else
		local clone = v56:Clone()

		clone.Name = "DisabledFrame"
		clone.Parent = parent
		v110 = if clone:IsA("GuiObject") then clone else nil
	end

	if v110 then
		v110.Visible = true
	end
end
local function ensureResetButton(parent)
	local resetBtn2 = parent:FindFirstChild("ResetBtn")

	if resetBtn2 and resetBtn2:IsA("TextButton") then
		return resetBtn2
	end

	if not resetBtn then
		return nil
	end

	local clone: Instance = resetBtn:Clone()

	clone.Name = "ResetBtn"
	clone.Parent = parent

	return clone
end
local function wireReset(parent, p11)
	local resetBtn3 = parent:FindFirstChild("ResetBtn")
	local v118

	if resetBtn3 and resetBtn3:IsA("TextButton") then
		v118 = resetBtn3
	elseif not resetBtn then
		v118 = nil
	else
		local clone: Instance = resetBtn:Clone()

		clone.Name = "ResetBtn"
		clone.Parent = parent
		v118 = clone
	end

	if not v118 then
		return nil
	end

	v118.MouseButton1Click:Connect(p11)

	return v118
end
local function placeResetLeftOf(p12, p13)
	p12.Position = UDim2.new(p13.Position.X.Scale - p13.AnchorPoint.X * p13.Size.X.Scale - 0.015 - (1 - p12.AnchorPoint.X) * p12.Size.X.Scale, 0, p12.Position.Y.Scale, p12.Position.Y.Offset)
end
local function wireSliderRow(parent, p15, p16)
	local barContainer = parent:FindFirstChild("BarContainer")

	if not barContainer then
		return
	end

	local bar = barContainer:FindFirstChild("Bar")

	if not bar then
		return
	end

	local knob = bar:FindFirstChild("Knob")
	local value = parent:FindFirstChild("Value")

	local v129 = uiFramework.wireSlider({
		barContainer = barContainer,
		innerBar = bar,
		knob = knob,
		valueLabel = value,
		min = p16.min or 0,
		max = p16.max or 100,
		default = p16.default,
		getValue = function()
			return v18[p15]
		end,
		setValue = function(p17)
			v18[p15] = p17
		end,
		onChange = onSettingChanged
	})

	table.insert(t1, v129.refresh)

	local resetBtn4 = parent:FindFirstChild("ResetBtn")
	local v131

	if resetBtn4 and resetBtn4:IsA("TextButton") then
		v131 = resetBtn4
	elseif not resetBtn then
		v131 = nil
	else
		local clone: Instance = resetBtn:Clone()

		clone.Name = "ResetBtn"
		clone.Parent = parent
		v131 = clone
	end

	if not v131 then
		return
	end

	v131.MouseButton1Click:Connect(function()
		v18[p15] = p16.default
		v129.refresh()
		v34:applyStyle(v18)
		crosshairSettings.applyDot(dot, v18)
		applyMagneticMode()
		crosshairSettings.notifyChanged()

		if u38 then
			return
		end

		u38 = true
		task.delay(0.3, function()
			u38 = false

			if u25 then
				u25()
			end

			local v197 = crosshairSettings.toWire(v18)

			v197.Palette = t3
			updateSettings:FireServer("UpdateCrosshair", v197)
		end)
	end)
end
local function wireToggleRow(parent, p19, p20)
	local toggle = parent:FindFirstChild("Toggle")

	if not toggle then
		return
	end

	local circle2 = toggle:FindFirstChild("Circle")
	local equipStroke = toggle:FindFirstChild("EquipStroke")
	local defaultStroke = toggle:FindFirstChild("DefaultStroke")
	local u140 = nil
	local u141 = nil

	for _, v in ipairs(toggle:GetChildren()) do
		if v:IsA("UIGradient") then
			if equipStroke and v.Enabled == equipStroke.Enabled then
				u140 = v
			else
				u141 = v
			end
		end
	end

	local function setVisual(enabled)
		if circle2 then
			local uDim2 = UDim2.new(if enabled then 0.965 else 0.481, 0, 0.5, 0)

			tweenService:Create(circle2, tweenInfo, { Position = uDim2 }):Play()
		end

		if u140 then
			u140.Enabled = enabled
		end

		if u141 then
			u141.Enabled = not enabled
		end

		if equipStroke then
			equipStroke.Enabled = enabled
		end

		if defaultStroke then
			defaultStroke.Enabled = not enabled
		end
	end

	toggle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			v18[p19] = not v18[p19]
			setVisual(v18[p19] == true)
			v34:applyStyle(v18)
			crosshairSettings.applyDot(dot, v18)
			applyMagneticMode()
			crosshairSettings.notifyChanged()

			if u38 then
				return
			end

			u38 = true
			task.delay(0.3, function()
				u38 = false

				if u25 then
					u25()
				end

				local v198 = crosshairSettings.toWire(v18)

				v198.Palette = t3
				updateSettings:FireServer("UpdateCrosshair", v198)
			end)

			return
		end
	end)

	local function v145()
		v18[p19] = p20.default
		setVisual(v18[p19] == true)
		v34:applyStyle(v18)
		crosshairSettings.applyDot(dot, v18)
		applyMagneticMode()
		crosshairSettings.notifyChanged()

		if u38 then
			return
		end

		u38 = true
		task.delay(0.3, function()
			u38 = false

			if u25 then
				u25()
			end

			local v197 = crosshairSettings.toWire(v18)

			v197.Palette = t3
			updateSettings:FireServer("UpdateCrosshair", v197)
		end)
	end

	local resetBtn5 = parent:FindFirstChild("ResetBtn")
	local v147

	if resetBtn5 and resetBtn5:IsA("TextButton") then
		v147 = resetBtn5
	elseif not resetBtn then
		v147 = nil
	else
		local clone: Instance = resetBtn:Clone()

		clone.Name = "ResetBtn"
		clone.Parent = parent
		v147 = clone
	end

	local v149

	if not v147 then
		v149 = nil
	else
		v147.MouseButton1Click:Connect(v145)
		v149 = v147
	end

	if v149 then
		placeResetLeftOf(v149, toggle)
	end

	table.insert(t1, function()
		setVisual(v18[p19] == true)
	end)
	setVisual(v18[p19] == true)
end
local function wireColorRow(parent, p24, p25)
	local selectedColor = parent:FindFirstChild("SelectedColor")

	t4[p24] = function(backgroundColor3)
		if selectedColor then
			selectedColor.BackgroundColor3 = backgroundColor3
		end
	end

	local editBtn = parent:FindFirstChild("EditBtn")

	if editBtn and editBtn:IsA("GuiButton") then
		editBtn.MouseButton1Click:Connect(function()
			local v192 = p24

			getPicker()
			u22 = v192
			u47 = true
			u46:SetColor(v18[v192])
			u47 = false
			u46:SetVisible(true)
		end)
	end

	local function v155()
		v18[p24] = p25.default

		if selectedColor then
			selectedColor.BackgroundColor3 = v18[p24]
		end

		local v193 = u22

		if v193 and u46 and u46:GetVisible() then
			u47 = true
			u46:SetColor(v18[v193])
			u47 = false
		end

		v34:applyStyle(v18)
		crosshairSettings.applyDot(dot, v18)
		applyMagneticMode()
		crosshairSettings.notifyChanged()

		if u38 then
			return
		end

		u38 = true
		task.delay(0.3, function()
			u38 = false

			if u25 then
				u25()
			end

			local v199 = crosshairSettings.toWire(v18)

			v199.Palette = t3
			updateSettings:FireServer("UpdateCrosshair", v199)
		end)
	end

	local resetBtn6 = parent:FindFirstChild("ResetBtn")
	local v157

	if resetBtn6 and resetBtn6:IsA("TextButton") then
		v157 = resetBtn6
	elseif not resetBtn then
		v157 = nil
	else
		local clone: Instance = resetBtn:Clone()

		clone.Name = "ResetBtn"
		clone.Parent = parent
		v157 = clone
	end

	local v159

	if not v157 then
		v159 = nil
	else
		v157.MouseButton1Click:Connect(v155)
		v159 = v157
	end

	if v159 and selectedColor then
		placeResetLeftOf(v159, selectedColor)
	end

	table.insert(t1, function()
		if selectedColor then
			selectedColor.BackgroundColor3 = v18[p24]
		end
	end)

	if selectedColor then
		selectedColor.BackgroundColor3 = v18[p24]
	end
end
local function seedDisabledVisual(p27, p28)
	if p28.kind == "slider" then
		local barContainer = p27:FindFirstChild("BarContainer")

		if not barContainer then
			return
		end

		local bar = barContainer:FindFirstChild("Bar")

		if not bar then
			return
		end

		local v164 = p28.min or 0
		local v165 = p28.max or 100
		local n1 = if v165 == v164 then 0 else math.clamp((p28.default - v164) / (v165 - v164), 0, 1)

		bar.Size = UDim2.new(n1, 0, 1, 0)

		local value = p27:FindFirstChild("Value")

		if value and value:IsA("TextBox") and not value:IsFocused() then
			value.Text = tostring(p28.default)

			return
		end
	elseif p28.kind == "toggle" then
		local toggle = p27:FindFirstChild("Toggle")
		local circle = toggle and toggle:FindFirstChild("Circle")

		if circle then
			circle.Position = UDim2.new(if p28.default == true then 0.965 else 0.481, 0, 0.5, 0)

			return
		end
	else
		local v170 = p28.kind == "color" and p27:FindFirstChild("SelectedColor")

		if v170 and v170:IsA("GuiObject") then
			v170.BackgroundColor3 = p28.default
		end
	end
end

for _, v in ipairs(scrollingFrame:GetChildren()) do
	if v:IsA("Frame") then
		local v70 = crosshairSettings.Defaults[v.Name]

		if v70 then
			local u71

			if v70.disabled == true then
				u71 = true
			else
				local v72 = v70.availability or "all"

				if v72 == "mobile" and not userInputServiceTouchEnabled or v72 == "desktop" and userInputServiceTouchEnabled then
					u71 = true
				else
					local disabledFrame = v:FindFirstChild("DisabledFrame")

					u71 = false

					if disabledFrame ~= nil then
						u71 = disabledFrame:IsA("GuiObject") and disabledFrame.Visible
					end
				end
			end

			if u71 then
				local disabledFrame = v:FindFirstChild("DisabledFrame")
				local v75

				if disabledFrame and disabledFrame:IsA("GuiObject") then
					v75 = disabledFrame
				elseif not v56 then
					v75 = nil
				else
					local clone = v56:Clone()

					clone.Name = "DisabledFrame"
					clone.Parent = v
					v75 = if clone:IsA("GuiObject") then clone else nil
				end

				if v75 then
					v75.Visible = true
				end

				seedDisabledVisual(v, v70)
			else
				if v70.kind == "slider" then
					wireSliderRow(v, v.Name, v70)
				elseif v70.kind == "toggle" then
					wireToggleRow(v, v.Name, v70)
				elseif v70.kind == "color" then
					wireColorRow(v, v.Name, v70)
				end

				if v.Name ~= "MagneticEnabled" then
					local disabledFrame = v:FindFirstChild("DisabledFrame")

					if (not disabledFrame or not disabledFrame:IsA("GuiObject")) and v56 then
						local clone = v56:Clone()

						clone.Name = "DisabledFrame"
						clone.Parent = v

						if clone:IsA("GuiObject") then
						end
					end

					table.insert(t2, v)
				end
			end
		end
	end
end

local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local u80 = nil

wireColorRow = function()
	if u80 == nil then
		u80 = bindables:WaitForChild("ConfirmModal", 5)
	end

	return u80
end

local resetAllRow: Instance = scrollingFrame:FindFirstChild("ResetAllRow")

if resetAllRow then
	local disabledFrame: Instance = resetAllRow:FindFirstChild("DisabledFrame")

	if (not disabledFrame or not disabledFrame:IsA("GuiObject")) and v56 then
		local clone = v56:Clone()

		clone.Name = "DisabledFrame"
		clone.Parent = resetAllRow

		if clone:IsA("GuiObject") then
		end
	end

	table.insert(t2, resetAllRow)
end

applyDisabledOverlay = if resetAllRow then resetAllRow:FindFirstChild("ResetAllBtn") else nil

if applyDisabledOverlay and applyDisabledOverlay:IsA("TextButton") then
	applyDisabledOverlay.MouseButton1Click:Connect(function()
		if u80 == nil then
			u80 = bindables:WaitForChild("ConfirmModal", 5)
		end

		local v171 = u80

		if not v171 then
			return
		end

		if v171:Invoke({
			Header = "Reset Crosshair?",
			Body = "This will restore every crosshair setting to its default value.",
			AcceptText = "Reset All",
			DeclineText = "Cancel"
		}) == true then
			crosshairSettings.replaceActive(nil)

			for _, v in ipairs(t1) do
				v()
			end

			local v174 = u22

			if v174 and u46 and u46:GetVisible() then
				u47 = true
				u46:SetColor(v18[v174])
				u47 = false
			end

			v34:applyStyle(v18)
			crosshairSettings.applyDot(dot, v18)
			applyMagneticMode()
			crosshairSettings.notifyChanged()

			if u38 then
				return
			end

			u38 = true
			task.delay(0.3, function()
				u38 = false

				if u25 then
					u25()
				end

				local v194 = crosshairSettings.toWire(v18)

				v194.Palette = t3
				updateSettings:FireServer("UpdateCrosshair", v194)
			end)

			return
		end
	end)
end

local u84: boolean = false

updateSettings.OnClientEvent:Connect(function(p29, p30)
	if p29 == "SyncCrosshair" then
		u84 = true
		crosshairSettings.replaceActive(crosshairSettings.fromWire(p30))

		if typeof(p30) == "table" and typeof(p30.Palette) == "table" then
			t3 = p30.Palette

			if u46 then
				u46:SetPaletteColors(t3)
			end
		end

		for _, v in ipairs(t1) do
			v()
		end

		local v179 = u22

		if v179 and u46 and u46:GetVisible() then
			u47 = true
			u46:SetColor(v18[v179])
			u47 = false
		end

		v34:applyStyle(v18)
		crosshairSettings.applyDot(dot, v18)
		applyMagneticMode()
		crosshairSettings.notifyChanged()

		return
	end
end)
task.spawn(function()
	for _ = 1, 15 do
		if u84 then
			return
		end

		updateSettings:FireServer("RequestCrosshair")
		task.wait(1)
	end
end)
applyMagneticMode()
