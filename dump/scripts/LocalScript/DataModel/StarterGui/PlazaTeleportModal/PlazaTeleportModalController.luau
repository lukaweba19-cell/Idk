-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local bindables: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Bindables")
local plazaTeleportChoice = bindables:FindFirstChild("PlazaTeleportChoice")

if not plazaTeleportChoice then
	local plazaTeleportChoice2: BindableFunction = Instance.new("BindableFunction")

	plazaTeleportChoice2.Name = "PlazaTeleportChoice"
	plazaTeleportChoice2.Parent = bindables
	plazaTeleportChoice = plazaTeleportChoice2
end

local plazaTeleportChoiceCancel = bindables:FindFirstChild("PlazaTeleportChoiceCancel")

if not plazaTeleportChoiceCancel then
	local plazaTeleportChoiceCancel2: BindableEvent = Instance.new("BindableEvent")

	plazaTeleportChoiceCancel2.Name = "PlazaTeleportChoiceCancel"
	plazaTeleportChoiceCancel2.Parent = bindables
	plazaTeleportChoiceCancel = plazaTeleportChoiceCancel2
end

local scriptParent: Instance = script.Parent
local window: Instance = scriptParent:WaitForChild("Window")
local headerTextLabel: Instance = window:WaitForChild("HeaderTextLabel")
local winText: Instance = window:WaitForChild("WinText")
local options: Instance = window:WaitForChild("Options")
local accept: Instance = options:WaitForChild("Accept")
local servers: Instance = options:WaitForChild("Servers")
local closeButton: Instance = window:WaitForChild("CloseButton")
local backdrop: Instance = scriptParent:WaitForChild("Backdrop")

local function firstLabelText(p1)
	for _, v in ipairs(p1:GetDescendants()) do
		if v:IsA("TextLabel") then
			return v.Text
		end
	end

	return ""
end
local function setButtonText(p2, text)
	for _, v in ipairs(p2:GetDescendants()) do
		if v:IsA("TextLabel") then
			v.Text = text
		end
	end
end

local v17 = firstLabelText(accept)
local v18 = firstLabelText(servers)
local bindableEvent: BindableEvent = Instance.new("BindableEvent")
local u20: boolean = false

accept.MouseButton1Click:Connect(function()
	if u20 then
		bindableEvent:Fire("teleport")
	end
end)
servers.MouseButton1Click:Connect(function()
	if u20 then
		bindableEvent:Fire("servers")
	end
end)
closeButton.MouseButton1Click:Connect(function()
	if u20 then
		bindableEvent:Fire("cancel")
	end
end)
plazaTeleportChoiceCancel.Event:Connect(function()
	if u20 then
		bindableEvent:Fire("cancel")
	end
end)

function plazaTeleportChoice.OnInvoke(p4: {[any]: any})
	if u20 then
		return "cancel"
	end

	if typeof(p4) ~= "table" then
		p4 = {}
	end

	headerTextLabel.Text = if typeof(p4.Header) == "string" then p4.Header else "Trading Plaza"
	winText.Text = if typeof(p4.Body) == "string" then p4.Body else "Teleport to the Trading Plaza?"

	local typeName: string = typeof(p4.AcceptText)

	setButtonText(accept, if typeName == "string" then p4.AcceptText else v17)

	local typeName2: string = typeof(p4.ServersText)

	setButtonText(servers, if typeName2 == "string" then p4.ServersText else v18)
	u20 = true
	backdrop.Visible = true
	window.Visible = true

	local v31 = bindableEvent.Event:Wait()

	window.Visible = false
	backdrop.Visible = false
	u20 = false

	if typeof(v31) == "string" then
		return v31
	end

	return "cancel"
end

window.Visible = false
backdrop.Visible = false
scriptParent.Enabled = true
