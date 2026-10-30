-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local tweenService: TweenService = game:GetService("TweenService")

game:GetService("UserInputService")

local shared: Instance = replicatedStorage:WaitForChild("Shared")
local extensions: Instance = replicatedStorage:WaitForChild("Extensions")
local windowSlide = require(shared:WaitForChild("WindowSlide"))
local gamepadSliderController = require(extensions:WaitForChild("GamepadSliderController"))
local inputCategorizer = require(extensions:WaitForChild("InputCategorizer"))
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local uDim2 = UDim2.new(0.5, 0, 0.46, 0)

local function hudSettingsWindow()
	local LocalPlayer: Player = players.LocalPlayer

	if not LocalPlayer then
		return nil
	end

	local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local v18: Instance = playerGui

	if v18 then
		v18 = playerGui:FindFirstChild("HUD")
	end

	return v18 and v18:FindFirstChild("SettingsWindow")
end
local function stripScripts(p1)
	for _, v in ipairs(p1:GetDescendants()) do
		if v:IsA("LuaSourceContainer") then
			v:Destroy()
		end
	end
end
local function setCaption(p2, text)
	if not p2 then
		return
	end

	for _, v in ipairs(p2:GetDescendants()) do
		if v:IsA("TextLabel") and text ~= v.Text then
			v.Text = text
		end
	end

	if p2:IsA("TextLabel") and text ~= p2.Text then
		p2.Text = text
	end
end
local function setRowLabel(p4, text)
	local settingName = p4:FindFirstChild("SettingName")

	if settingName and settingName:IsA("TextLabel") and text ~= settingName.Text then
		settingName.Text = text
	end
end

local t1: {[any]: any} = {}

t1.__index = t1

function t1._nextOrder(p7)
	p7._order = p7._order + 1

	return p7._order
end
function t1._addHeader(p8, text)
	local clone = p8._tpl.header:Clone()

	clone.Name = "Header_" .. text:gsub("%s", "")
	clone.LayoutOrder = p8:_nextOrder()

	for _, v in ipairs(clone:GetDescendants()) do
		if v:IsA("TextLabel") then
			v.Text = text
		end
	end

	clone.Parent = p8._panel
end
function t1._addPair(p10, p11, text, p13, p14, p15, p16)
	local clone = p10._tpl.pair:Clone()

	clone.Name = "Row_" .. p11
	clone.LayoutOrder = p10:_nextOrder()

	local settingName = clone:FindFirstChild("SettingName")

	if settingName and settingName:IsA("TextLabel") and text ~= settingName.Text then
		settingName.Text = text
	end

	local slot1 = clone:FindFirstChild("Slot1")
	local slot2 = clone:FindFirstChild("Slot2")

	setCaption(slot1, p13)
	setCaption(slot2, p14)

	if slot1 and slot1:IsA("GuiButton") then
		table.insert(p10._conns, slot1.MouseButton1Click:Connect(function()
			if p10._inert then
				return
			end

			if p16 then
				local v124 = os.clock()

				if v124 - (p10._lastRepeat[p11] or 0) < 0.22 then
					return
				end

				p10._lastRepeat[p11] = v124
				p15(-1)

				return
			end

			p15(-1)
		end))
	end

	if slot2 and slot2:IsA("GuiButton") then
		table.insert(p10._conns, slot2.MouseButton1Click:Connect(function()
			if p10._inert then
				return
			end

			if p16 then
				local v125 = os.clock()

				if v125 - (p10._lastRepeat[p11] or 0) < 0.22 then
					return
				end

				p10._lastRepeat[p11] = v125
				p15(1)

				return
			end

			p15(1)
		end))
	end

	clone.Parent = p10._panel
	p10._gamepad:addSlider(clone, function(p17)
		if p10._inert then
			return
		end

		if p16 then
			local v127 = os.clock()

			if v127 - (p10._lastRepeat[p11] or 0) < 0.22 then
				return
			end

			p10._lastRepeat[p11] = v127
			p15(p17)

			return
		end

		p15(p17)
	end)
	p10._shown[p11] = clone

	return clone
end
function t1._addButton(p18, p19, text, p21, p22)
	local clone = p18._tpl.button:Clone()

	clone.Name = "Row_" .. p19
	clone.LayoutOrder = p18:_nextOrder()

	local settingName = clone:FindFirstChild("SettingName")

	if settingName and settingName:IsA("TextLabel") and text ~= settingName.Text then
		settingName.Text = text
	end

	local openBtn = clone:FindFirstChild("OpenBtn")

	setCaption(openBtn, p21)

	local function fire()
		if p18._inert then
			return
		end

		p22()
	end

	if openBtn and openBtn:IsA("GuiButton") then
		table.insert(p18._conns, openBtn.MouseButton1Click:Connect(fire))
	end

	clone.Parent = p18._panel
	p18._gamepad:addButton(clone, fire)
	p18._shown[p19] = clone

	return clone
end
function t1._addToggle(p23, p24, text, p26)
	local clone = p23._tpl.toggle:Clone()

	clone.Name = "Row_" .. p24
	clone.LayoutOrder = p23:_nextOrder()

	local settingName = clone:FindFirstChild("SettingName")

	if settingName and settingName:IsA("TextLabel") and text ~= settingName.Text then
		settingName.Text = text
	end

	local toggle = clone:FindFirstChild("Toggle")
	local circle = toggle and toggle:FindFirstChild("Circle")
	local equipStroke = toggle and toggle:FindFirstChild("EquipStroke")
	local defaultStroke = toggle and toggle:FindFirstChild("DefaultStroke")
	local u65 = nil
	local u66 = nil

	if toggle then
		for _, v in ipairs(toggle:GetChildren()) do
			if v:IsA("UIGradient") then
				if equipStroke and equipStroke:IsA("UIStroke") and v.Enabled == equipStroke.Enabled then
					u65 = v
				else
					u66 = v
				end
			end
		end
	end

	p23._toggleVisual[p24] = function(enabled)
		if circle and circle:IsA("GuiObject") then
			local uDim22 = UDim2.new(if enabled then 0.965 else 0.481, 0, 0.5, 0)

			tweenService:Create(circle, tweenInfo, { Position = uDim22 }):Play()
		end

		if u65 then
			u65.Enabled = enabled
		end

		if u66 then
			u66.Enabled = not enabled
		end

		if equipStroke and equipStroke:IsA("UIStroke") then
			equipStroke.Enabled = enabled
		end

		if defaultStroke and defaultStroke:IsA("UIStroke") then
			defaultStroke.Enabled = not enabled
		end
	end

	if toggle and toggle:IsA("GuiObject") then
		table.insert(p23._conns, toggle.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			if p23._inert then
				return
			end

			p26()
		end))
	end

	clone.Parent = p23._panel
	p23._gamepad:addToggle(clone, function()
		if p23._inert then
			return
		end

		p26()
	end)
	p23._shown[p24] = clone

	return clone
end
function t1._build(p29)
	local _actions = p29._actions

	p29:_addHeader("PLAYBACK")
	p29:_addButton("play", "Play / Pause", "Pause", _actions.togglePlay)
	p29:_addPair("step", "Frame Step", "<", ">", _actions.step, false)
	p29:_addPair("speed", "Speed", "-", "+", _actions.speed, true)
	p29:_addPair("round", "Round", "<", ">", _actions.round, true)
	p29:_addHeader("VIEW")
	p29:_addPair("player", "Player", "<", ">", _actions.player, true)
	p29:_addButton("cam", "Camera", "Third", _actions.cycleCam)
	p29:_addToggle("xray", "X-Ray", _actions.toggleXRay)
	p29:_addHeader("")
	p29:_addButton("exit", "Leave Replay", "Exit", _actions.exit)
end
function t1.SetState(p30, p31)
	local v73 = p31.playing ~= nil and p30._shown.play

	if v73 then
		local openBtn = v73:FindFirstChild("OpenBtn")

		setCaption(openBtn, if p31.playing then "Pause" else "Play")
	end

	v73 = p31.speed ~= nil and p30._shown.speed

	if v73 then
		local formattedText = string.format("Speed  -  %gx", p31.speed)
		local settingName = v73:FindFirstChild("SettingName")

		if settingName and settingName:IsA("TextLabel") and formattedText ~= settingName.Text then
			settingName.Text = formattedText
		end
	end

	v73 = p31.camera ~= nil and p30._shown.cam

	if v73 then
		local openBtn = v73:FindFirstChild("OpenBtn")

		setCaption(openBtn, p31.camera)
	end

	v73 = p31.playerName ~= nil and p30._shown.player

	local text: string = "Player  -  " .. p31.playerName
	local v79 = v73 and v73:FindFirstChild("SettingName")

	if v79 and v79:IsA("TextLabel") and text ~= v79.Text then
		v79.Text = text
	end

	if p31.xray ~= nil and p31.xray ~= p30._xrayShown then
		p30._xrayShown = p31.xray

		local xray = p30._toggleVisual.xray

		if xray then
			xray(p31.xray)
		end
	end
end
function t1._syncInputMode(p32)
	local v82 = inputCategorizer.getLastInputCategory()

	if p32._open and v82 == inputCategorizer.InputCategory.Gamepad then
		p32._gamepad:activate()

		return
	end

	p32._gamepad:deactivate()
end
function t1.IsOpen(p33)
	return p33._open
end
function t1.Open(p34)
	if p34._open then
		return
	end

	p34._open = true

	local _window = p34._window
	local v86 = windowSlide.closedPosFor(uDim2)

	if p34._slideTween then
		p34._slideTween:Cancel()
	end

	p34._slideTween = windowSlide.slideIn(_window, uDim2, v86)
	p34:_syncInputMode()
end
function t1.Close(p35)
	if not p35._open then
		return
	end

	p35._open = false
	p35._gamepad:deactivate()

	local _window = p35._window
	local v89 = windowSlide.closedPosFor(uDim2)

	if p35._slideTween then
		p35._slideTween:Cancel()
	end

	p35._slideTween = windowSlide.slideOut(_window, v89, function()
		if not p35._open then
			_window.Visible = false
		end
	end)
end
function t1.Toggle(p36)
	if p36._open then
		p36:Close()

		return
	end

	p36:Open()
end
function t1.Destroy(p37)
	for _, v in ipairs(p37._conns) do
		v:Disconnect()
	end

	table.clear(p37._conns)

	if p37._slideTween then
		p37._slideTween:Cancel()
		p37._slideTween = nil
	end

	p37._gamepad:deactivate()

	for _, v in pairs(p37._tpl) do
		v:Destroy()
	end

	p37._window:Destroy()
end

return {
	new = function(p6)
		local LocalPlayer: Player = players.LocalPlayer
		local settingsWindow

		if not LocalPlayer then
			settingsWindow = nil
		else
			local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")
			local v100: Instance = playerGui

			if v100 then
				v100 = playerGui:FindFirstChild("HUD")
			end

			settingsWindow = v100

			if settingsWindow then
				settingsWindow = v100:FindFirstChild("SettingsWindow")
			end
		end

		if not settingsWindow then
			return nil
		end

		local ok, result = pcall(function()
			return settingsWindow:Clone()
		end)

		if not ok or not result or not result:IsA("GuiObject") then
			return nil
		end

		stripScripts(result)

		local content = result:FindFirstChild("Content")
		local contentHotkeys = result:FindFirstChild("ContentHotkeys")
		local contentHotkeysScrollingFrame = contentHotkeys and contentHotkeys:FindFirstChild("ScrollingFrame")

		if not content or not contentHotkeys or not contentHotkeysScrollingFrame or not contentHotkeysScrollingFrame:IsA("ScrollingFrame") then
			result:Destroy()

			return nil
		end

		local scrollingFrame = contentHotkeys:FindFirstChild("ScrollingFrame")
		local scrollingFrame2 = content:FindFirstChild("ScrollingFrame")
		local scoreboard = scrollingFrame and scrollingFrame:FindFirstChild("Scoreboard")
		local v109 = scrollingFrame2

		if v109 then
			v109 = scrollingFrame2:FindFirstChild("LowVFX")
		end

		local editControls = scrollingFrame2 and scrollingFrame2:FindFirstChild("EditControls")
		local gameplayHeader = scrollingFrame2 and scrollingFrame2:FindFirstChild("GameplayHeader")

		if scoreboard and v109 and editControls and gameplayHeader then
			local clone = scoreboard:Clone()
			local clone2 = v109:Clone()
			local clone3 = editControls:Clone()
			local clone4 = gameplayHeader:Clone()
			local navigator = result:FindFirstChild("Navigator")

			if navigator then
				navigator:Destroy()
			end

			content:Destroy()

			local contentCrosshair = result:FindFirstChild("ContentCrosshair")

			if contentCrosshair then
				contentCrosshair:Destroy()
			end

			contentHotkeys.Visible = true

			for _, v in ipairs(contentHotkeysScrollingFrame:GetChildren()) do
				if v:IsA("GuiObject") then
					v:Destroy()
				end
			end

			local header = result:FindFirstChild("Header")
			local v121 = header

			if v121 then
				v121 = header:FindFirstChild("TextLabel")
			end

			if v121 and v121:IsA("TextLabel") then
				v121.Text = "REPLAY CONTROLS"
			end

			local closeButton = result:FindFirstChild("CloseButton")

			result.Name = "ReplayControlMenu"
			result.AnchorPoint = Vector2.new(0.5, 0.5)
			result.Position = uDim2
			result.Visible = false
			result.ZIndex = 60
			result.Parent = p6.parent

			local object = setmetatable({}, t1)

			object._window = result
			object._panel = contentHotkeysScrollingFrame
			object._actions = p6.actions
			object._inert = p6.inert == true
			object._open = false
			object._order = 0
			object._conns = {}
			object._lastRepeat = {}
			object._shown = {}
			object._toggleVisual = {}
			object._xrayShown = nil
			object._slideTween = nil
			object._gamepad = gamepadSliderController.new({
				actionPrefix = "ReplayControls",
				scrollFrame = contentHotkeysScrollingFrame,
				windowFrame = result,
				closeButton = if closeButton and closeButton:IsA("GuiButton") then closeButton else nil,
				closeFn = function()
					object:Close()
				end
			})
			object._tpl = { pair = clone, toggle = clone2, button = clone3, header = clone4 }
			object:_build()

			if closeButton and closeButton:IsA("GuiButton") then
				table.insert(object._conns, closeButton.MouseButton1Click:Connect(function()
					object:Close()
				end))
			end

			table.insert(object._conns, inputCategorizer.lastInputCategoryChanged:Connect(function()
				if object._open then
					object:_syncInputMode()
				end
			end))

			return object
		end

		result:Destroy()

		return nil
	end
}
