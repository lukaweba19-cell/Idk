-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local guiService: GuiService = game:GetService("GuiService")
local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local extensions: Instance = replicatedStorage:WaitForChild("Extensions")
local inputCategorizer = require(extensions:WaitForChild("InputCategorizer"))
local confirmModal = bindables:FindFirstChild("ConfirmModal")

if not confirmModal then
	local confirmModal2: BindableFunction = Instance.new("BindableFunction")

	confirmModal2.Name = "ConfirmModal"
	confirmModal2.Parent = bindables
	confirmModal = confirmModal2
end

local noticeModal = bindables:FindFirstChild("NoticeModal")

if not noticeModal then
	local noticeModal2: BindableFunction = Instance.new("BindableFunction")

	noticeModal2.Name = "NoticeModal"
	noticeModal2.Parent = bindables
	noticeModal = noticeModal2
end

local confirmModalCancel = bindables:FindFirstChild("ConfirmModalCancel")

if not confirmModalCancel then
	local confirmModalCancel2: BindableEvent = Instance.new("BindableEvent")

	confirmModalCancel2.Name = "ConfirmModalCancel"
	confirmModalCancel2.Parent = bindables
	confirmModalCancel = confirmModalCancel2
end

local scriptParent: Instance = script.Parent
local window: Instance = scriptParent:WaitForChild("Window")
local headerTextLabel: Instance = window:WaitForChild("HeaderTextLabel")
local winText: Instance = window:WaitForChild("WinText")
local options: Instance = window:WaitForChild("Options")
local accept: Instance = options:WaitForChild("Accept")
local decline: Instance = options:WaitForChild("Decline")
local closeButton: Instance = window:WaitForChild("CloseButton")
local backdrop: Instance = scriptParent:WaitForChild("Backdrop")

local function styleParts(p1)
	local uiGradient = p1:FindFirstChildOfClass("UIGradient")
	local textLabel = p1:FindFirstChild("TextLabel")
	local v38 = textLabel and textLabel:FindFirstChild("TextLabel")
	local uiStroke = v38 and v38:FindFirstChildOfClass("UIStroke")
	local v40 = textLabel and textLabel:IsA("TextLabel")

	return uiGradient, if v40 then textLabel else nil, uiStroke
end
local function captureStyle(p2)
	local v42, v43, v44 = styleParts(p2)

	return {
		fill = v42 and v42.Color,
		shadow = v43 and v43.TextColor3,
		outline = v44 and v44.Color
	}
end
local function applyStyle(p3, p4)
	local v47, v48, v49 = styleParts(p3)

	if v47 and p4.fill then
		v47.Color = p4.fill
	end

	if v48 and p4.shadow then
		v48.TextColor3 = p4.shadow
	end

	if v49 and p4.outline then
		v49.Color = p4.outline
	end
end

local v24, v25, v26 = styleParts(accept)
local t1: {[any]: any} = {
	fill = v24 and v24.Color,
	shadow = v25 and v25.TextColor3,
	outline = v26 and v26.Color
}
local v28, v29, v30 = styleParts(decline)
local t2: {[any]: any} = {
	fill = v28 and v28.Color,
	shadow = v29 and v29.TextColor3,
	outline = v30 and v30.Color
}

captureStyle = function(p5, text)
	local textLabel = p5:FindFirstChild("TextLabel")

	if textLabel and textLabel:IsA("TextLabel") then
		textLabel.Text = text

		local textLabel2 = textLabel:FindFirstChild("TextLabel")

		if textLabel2 and textLabel2:IsA("TextLabel") then
			textLabel2.Text = text
		end
	end
end

local bindableEvent: BindableEvent = Instance.new("BindableEvent")
local u33: boolean = false

accept.MouseButton1Click:Connect(function()
	if u33 then
		bindableEvent:Fire(true)
	end
end)
decline.MouseButton1Click:Connect(function()
	if u33 then
		bindableEvent:Fire(false)
	end
end)
closeButton.MouseButton1Click:Connect(function()
	if u33 then
		bindableEvent:Fire(false)
	end
end)
confirmModalCancel.Event:Connect(function()
	if u33 then
		bindableEvent:Fire(false)
	end
end)

local function present(p7: {[any]: any}, p8)
	if u33 then
		return false
	end

	if typeof(p7) ~= "table" then
		p7 = {}
	end

	headerTextLabel.RichText = false
	winText.RichText = p7.RichText == true
	headerTextLabel.Text = if typeof(p7.Header) == "string" then p7.Header else if p8 then "Heads up" else "Confirm?"
	winText.Text = if typeof(p7.Body) == "string" then p7.Body else "Are you sure?"

	if p8 then
		local text = if typeof(p7.ButtonText) == "string" then p7.ButtonText else "OK"
		local textLabel: Instance = accept:FindFirstChild("TextLabel")

		if textLabel and textLabel:IsA("TextLabel") then
			textLabel.Text = text

			local textLabel3: Instance = textLabel:FindFirstChild("TextLabel")

			if textLabel3 and textLabel3:IsA("TextLabel") then
				textLabel3.Text = text
			end
		end
	else
		local v59 = if typeof(p7.AcceptText) == "string" then p7.AcceptText else "Accept"
		local textLabel: Instance = accept:FindFirstChild("TextLabel")

		if textLabel and textLabel:IsA("TextLabel") then
			textLabel.Text = v59

			local textLabel4: Instance = textLabel:FindFirstChild("TextLabel")

			if textLabel4 and textLabel4:IsA("TextLabel") then
				textLabel4.Text = v59
			end
		end

		v59 = if typeof(p7.DeclineText) == "string" then p7.DeclineText else "Decline"

		local textLabel5: Instance = decline:FindFirstChild("TextLabel")

		if textLabel5 and textLabel5:IsA("TextLabel") then
			textLabel5.Text = v59

			local textLabel6: Instance = textLabel5:FindFirstChild("TextLabel")

			if textLabel6 and textLabel6:IsA("TextLabel") then
				textLabel6.Text = v59
			end
		end
	end

	decline.Visible = not p8

	local u64 = not p8 and p7.Destructive == true
	local v65: {[any]: any} = if u64 then t2 else t1
	local v66, v67, v68 = styleParts(accept)

	if v66 and v65.fill then
		v66.Color = v65.fill
	end

	if v67 and v65.shadow then
		v67.TextColor3 = v65.shadow
	end

	if v68 and v65.outline then
		v68.Color = v65.outline
	end

	v65 = if u64 then t1 else t2

	local v69, v70, v71 = styleParts(decline)

	if v69 and v65.fill then
		v69.Color = v65.fill
	end

	if v70 and v65.shadow then
		v70.TextColor3 = v65.shadow
	end

	if v71 and v65.outline then
		v71.Color = v65.outline
	end

	u33 = true
	backdrop.Visible = true
	window.Visible = true

	if inputCategorizer.getLastInputCategory() == inputCategorizer.InputCategory.Gamepad then
		guiService.SelectedObject = if p8 then accept else decline
	end

	u64 = bindableEvent.Event:Wait()

	local guiServiceSelectedObject: GuiObject = guiService.SelectedObject

	if guiServiceSelectedObject and guiServiceSelectedObject:IsDescendantOf(scriptParent) then
		guiService.SelectedObject = nil
	end

	window.Visible = false
	backdrop.Visible = false
	decline.Visible = true
	u33 = false

	return u64 == true
end
function confirmModal.OnInvoke(p9)
	return (present(p9, false))
end
function noticeModal.OnInvoke(p10)
	return (present(p10, true))
end

window.Visible = false
backdrop.Visible = false
window.SelectionGroup = true
window.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
window.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
window.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
window.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
scriptParent.Enabled = true
