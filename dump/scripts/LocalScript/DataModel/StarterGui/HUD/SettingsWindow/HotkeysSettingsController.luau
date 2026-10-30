-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local userInputService: UserInputService = game:GetService("UserInputService")
local extensions: Instance = replicatedStorage:WaitForChild("Extensions")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local keybindSettings = require(shared:WaitForChild("KeybindSettings"))
local inputMap = require(extensions:WaitForChild("InputMap"))
local scriptParent: Instance = script.Parent
local contentHotkeys: Instance = scriptParent:WaitForChild("ContentHotkeys")
local scrollingFrame: Instance = contentHotkeys:WaitForChild("ScrollingFrame")
local t1: {[any]: any} = {}
local u12 = nil
local n1: number = 0
local connection = nil

local function setButtonText(p1, text)
	local textLabel = p1:FindFirstChild("TextLabel")

	if not textLabel or not textLabel:IsA("TextLabel") then
		return
	end

	textLabel.Text = text

	local textLabel2 = textLabel:FindFirstChild("TextLabel")

	if textLabel2 and textLabel2:IsA("TextLabel") then
		textLabel2.Text = text
	end
end
local function paintAction(p3)
	local v42 = t1[p3]

	if not v42 then
		return
	end

	local v43 = keybindSettings.isRebindable(p3)
	local v44 = if v43 then inputMap.getBindings(p3) else keybindSettings.defaultsFor(p3)

	for i, v in ipairs(v42.slots) do
		if u12 and v43 and p3 == u12.actionId and i == u12.slot then
			local textLabel = v:FindFirstChild("TextLabel")

			if textLabel and textLabel:IsA("TextLabel") then
				textLabel.Text = "..."

				local textLabel3 = textLabel:FindFirstChild("TextLabel")

				if textLabel3 and textLabel3:IsA("TextLabel") then
					textLabel3.Text = "..."
				end
			end
		else
			local v49 = v44[i]
			local text = (if v49 then inputMap.displayFor(v49) else nil) or "-"
			local textLabel = v:FindFirstChild("TextLabel")

			if textLabel and textLabel:IsA("TextLabel") then
				textLabel.Text = text

				local textLabel4 = textLabel:FindFirstChild("TextLabel")

				if textLabel4 and textLabel4:IsA("TextLabel") then
					textLabel4.Text = text
				end
			end
		end
	end
end
local function onCapturedInput(input)
	local v54 = u12

	if not v54 then
		return
	end

	local keyCode = input.KeyCode

	if keyCode == Enum.KeyCode.Escape then
		if connection then
			connection:Disconnect()
			connection = nil
		end

		local v56 = u12

		u12 = nil
		n1 += 1
		inputMap.setCapturing(false)

		if v56 then
			paintAction(v56.actionId)
		end

		return
	end

	if keyCode == Enum.KeyCode.Backspace or keyCode == Enum.KeyCode.Delete then
		if connection then
			connection:Disconnect()
			connection = nil
		end

		local v57 = u12

		u12 = nil
		n1 += 1
		inputMap.setCapturing(false)

		if v57 then
			paintAction(v57.actionId)
		end

		inputMap.setBinding(v54.actionId, v54.slot, nil)

		return
	end

	local v58 = inputMap.nameFor(input)

	if not v58 then
		return
	end

	if connection then
		connection:Disconnect()
		connection = nil
	end

	local v59 = u12

	u12 = nil
	n1 += 1
	inputMap.setCapturing(false)

	if v59 then
		paintAction(v59.actionId)
	end

	inputMap.setBinding(v54.actionId, v54.slot, v58)
end
local function startListening(p5, p6)
	if not keybindSettings.isRebindable(p5) then
		return
	end

	if connection then
		connection:Disconnect()
		connection = nil
	end

	local v62 = u12

	u12 = nil
	n1 += 1
	inputMap.setCapturing(false)

	if v62 then
		paintAction(v62.actionId)
	end

	u12 = { actionId = p5, slot = p6 }
	n1 += 1

	local v63: number = n1

	inputMap.setCapturing(true)
	paintAction(p5)
	task.defer(function()
		if n1 ~= v63 then
			return
		end

		connection = userInputService.InputBegan:Connect(function(input: InputObject)
			onCapturedInput(input)
		end)
	end)
	task.delay(5, function()
		if n1 == v63 then
			if connection then
				connection:Disconnect()
				connection = nil
			end

			local v86 = u12

			u12 = nil
			n1 += 1
			inputMap.setCapturing(false)

			if v86 then
				paintAction(v86.actionId)
			end
		end
	end)
end

local attack: Instance = scrollingFrame:FindFirstChild("Attack")
local u20 = nil
local v21 = if attack then attack:FindFirstChild("ResetBtn") else nil

if v21 and v21:IsA("TextButton") then
	u20 = v21
end

if not u20 then
	warn("[Hotkeys] no authored ResetBtn template on the Attack row; per-row reset disabled")
end

local function ensureResetButton(parent)
	local resetBtn = parent:FindFirstChild("ResetBtn")

	if resetBtn and resetBtn:IsA("TextButton") then
		return resetBtn
	end

	local v66 = u20

	if not v66 then
		return nil
	end

	local clone = v66:Clone()

	clone.Name = "ResetBtn"
	clone.Parent = parent

	return clone
end

v21 = function(p9, parent)
	local resetBtn = parent:FindFirstChild("ResetBtn")
	local v71

	if resetBtn and resetBtn:IsA("TextButton") then
		v71 = resetBtn
	else
		local v72 = u20

		if not v72 then
			v71 = nil
		else
			local clone = v72:Clone()

			clone.Name = "ResetBtn"
			clone.Parent = parent
			v71 = clone
		end
	end

	if not v71 then
		return
	end

	v71.AnchorPoint = Vector2.new(1, 0.5)
	v71.Position = UDim2.new(0.683, 0, 0.5, 0)
	v71.ZIndex = 4
	v71.Selectable = false

	local settingName = parent:FindFirstChild("SettingName")

	if settingName and settingName:IsA("TextLabel") then
		settingName.Size = UDim2.new(0.61, settingName.Size.X.Offset, settingName.Size.Y.Scale, settingName.Size.Y.Offset)
	end

	v71.Activated:Connect(function()
		if connection then
			connection:Disconnect()
			connection = nil
		end

		local v87 = u12

		u12 = nil
		n1 += 1
		inputMap.setCapturing(false)

		if v87 then
			paintAction(v87.actionId)
		end

		inputMap.resetAction(p9)
	end)
end

local function applyRowEnabled(p11, p12)
	local settingName = p11:FindFirstChild("SettingName")

	if settingName and settingName:IsA("TextLabel") then
		settingName.TextTransparency = if p12 then 0.08 else 0.55
	end

	for i = 1, keybindSettings.MAX_SLOTS do
		local foundChild = p11:FindFirstChild("Slot" .. i)

		if foundChild and foundChild:IsA("TextButton") then
			foundChild.Active = p12
			foundChild.AutoButtonColor = p12

			local textLabel = foundChild:FindFirstChild("TextLabel")

			if not textLabel or not textLabel:IsA("TextLabel") then
				continue
			end

			textLabel.TextTransparency = if p12 then 0 else 0.55
		end
	end
end

for _, v in ipairs(keybindSettings.Order) do
	local v2: Instance = scrollingFrame:FindFirstChild(v)

	if v2 and v2:IsA("Frame") then
		local t2 = {}

		for i = 1, keybindSettings.MAX_SLOTS do
			local foundChild: Instance = v2:FindFirstChild("Slot" .. i)

			if foundChild and foundChild:IsA("TextButton") then
				t2[i] = foundChild
				foundChild.Activated:Connect(function()
					startListening(v, i)
				end)
			end
		end

		t1[v] = { frame = v2, slots = t2 }
		t2 = keybindSettings.isRebindable(v)
		applyRowEnabled(v2, t2)

		if t2 then
			v21(v, v2)
		end
	else
		warn("[Hotkeys] no authored row for action: " .. v)
	end
end

local resetAllRow: Instance = scrollingFrame:FindFirstChild("ResetAllRow")

v21 = resetAllRow

if v21 then
	v21 = resetAllRow:FindFirstChild("ResetAllBtn")
end

if v21 and v21:IsA("TextButton") then
	local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
	local u32 = nil

	local function getConfirmFn()
		if u32 == nil then
			u32 = bindables:WaitForChild("ConfirmModal", 5)
		end

		return u32
	end

	v21.Activated:Connect(function()
		if connection then
			connection:Disconnect()
			connection = nil
		end

		local v81 = u12

		u12 = nil
		n1 += 1
		inputMap.setCapturing(false)

		if v81 then
			paintAction(v81.actionId)
		end

		if u32 == nil then
			u32 = bindables:WaitForChild("ConfirmModal", 5)
		end

		v81 = u32

		if not v81 then
			return
		end

		if v81:Invoke({
			Header = "Reset Hotkeys?",
			Body = "This will restore every key binding to its default.",
			AcceptText = "Reset All",
			DeclineText = "Cancel"
		}) == true then
			inputMap.resetAll()

			return
		end
	end)
end

inputMap.changed:Connect(function()
	for iterKey in pairs(t1) do
		paintAction(iterKey)
	end
end)
contentHotkeys:GetPropertyChangedSignal("Visible"):Connect(function()
	if not contentHotkeys.Visible then
		if connection then
			connection:Disconnect()
			connection = nil
		end

		local v83 = u12

		u12 = nil
		n1 += 1
		inputMap.setCapturing(false)

		if v83 then
			paintAction(v83.actionId)
		end
	end
end)
scriptParent:GetPropertyChangedSignal("Visible"):Connect(function()
	if not scriptParent.Visible then
		if connection then
			connection:Disconnect()
			connection = nil
		end

		local v84 = u12

		u12 = nil
		n1 += 1
		inputMap.setCapturing(false)

		if v84 then
			paintAction(v84.actionId)
		end
	end
end)
players.LocalPlayer.CharacterRemoving:Connect(function()
	if connection then
		connection:Disconnect()
		connection = nil
	end

	local v85 = u12

	u12 = nil
	n1 += 1
	inputMap.setCapturing(false)

	if v85 then
		paintAction(v85.actionId)
	end
end)

for iterKey in pairs(t1) do
	paintAction(iterKey)
end

local emoteFlags: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("EmoteFlags")
local emote: Instance = scrollingFrame:FindFirstChild("Emote")

if emote and emote:IsA("GuiObject") then
	emote.Visible = emoteFlags:GetAttribute("EmotesEnabled") == true
	emoteFlags:GetAttributeChangedSignal("EmotesEnabled"):Connect(function()
		emote.Visible = emoteFlags:GetAttribute("EmotesEnabled") == true
	end)
end
