-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local tweenService: TweenService = game:GetService("TweenService")
local runService: RunService = game:GetService("RunService")
local guiService: GuiService = game:GetService("GuiService")
local LocalPlayer: Player = players.LocalPlayer
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local windowBlur = require(shared:WaitForChild("WindowBlur"))
local rarity = require(shared:WaitForChild("Rarity"))
local makegoodWaves = require(shared:WaitForChild("MakegoodWaves"))
local sound = require(replicatedStorage:WaitForChild("Sound"))
local uiFramework = require(replicatedStorage:WaitForChild("UIFramework"))
local extensions: Instance = replicatedStorage:WaitForChild("Extensions")
local inputCategorizer = require(extensions:WaitForChild("InputCategorizer"))
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local makegoodWavesConfirm_delay = makegoodWaves.CONFIRM_DELAY
local scriptParent: Instance = script.Parent
local window: Instance = scriptParent:WaitForChild("Window")
local backdrop: Instance = scriptParent:WaitForChild("Backdrop")
local headerTextLabel: Instance = window:WaitForChild("HeaderTextLabel")
local bodyTextLabel: Instance = window:WaitForChild("BodyTextLabel")
local itemSlot: Instance = window:WaitForChild("ItemSlot")
local itemNameLabel: Instance = window:WaitForChild("ItemNameLabel")
local confirm: Instance = window:WaitForChild("Options"):WaitForChild("Confirm")
local clone: Instance = itemNameLabel:Clone()

clone.Name = "ItemTagLabel"

for _, v in ipairs(clone:GetChildren()) do
	if v:IsA("UIGradient") then
		v:Destroy()
	end
end

clone.Size = UDim2.fromScale(0.3, 0.05)
clone.Position = UDim2.fromScale(0.235, 0.233)
clone.Text = ""
clone.Visible = false
clone.Parent = window

local bodyTextLabelSize = bodyTextLabel.Size
local bodyTextLabelPosition = bodyTextLabel.Position
local v31 = UDim2.fromScale(0.82, 0.46)
local v32 = UDim2.fromScale(0.5, 0.5)
local bodyTextLabelTextSize = bodyTextLabel.TextSize

local function fitBody()
	bodyTextLabel.TextSize = bodyTextLabelTextSize

	while bodyTextLabel.TextSize > 13 and not bodyTextLabel.TextFits do
		local v54: Instance = bodyTextLabel

		v54.TextSize = v54.TextSize - 1
	end
end

local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local tweenInfo3 = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo4 = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function ensureScale(parent)
	local uiScale = parent:FindFirstChildOfClass("UIScale")

	if not uiScale then
		uiScale = Instance.new("UIScale")
		uiScale.Parent = parent
	end

	return uiScale
end

local uiScale = window:FindFirstChildOfClass("UIScale")

if not uiScale then
	uiScale = Instance.new("UIScale")
	uiScale.Parent = window
end

ensureScale = function(p2, text)
	local textLabel = p2:FindFirstChild("TextLabel")

	if textLabel and textLabel:IsA("TextLabel") then
		textLabel.Text = text

		local textLabel2 = textLabel:FindFirstChild("TextLabel")

		if textLabel2 and textLabel2:IsA("TextLabel") then
			textLabel2.Text = text
		end
	end
end

local u41: boolean = false
local t1: {[any]: any} = {}
local u43 = nil
local u44 = nil
local u45 = nil

local function clearCell()
	if u44 then
		u44:Destroy()
		u44 = nil
	end
end
local function show(p4)
	local v62
	local typeName
	local v64
	local typeName2
	local typeName3
	local u67
	local typeName4
	local typeName5
	local v70
	local typeName6
	local t2
	local v73
	local v74
	local v75
	local vector2
	local v77
	local typeName7
	local typeName8
	local v80
	local typeName9
	local v82
	local v83
	local v84
	local textLabel
	local v86
	local textLabel3
	local v88
	local v89
	local t3
	local v91
	local t4
	local v93
	local v94
	local v95
	local v96
	local mouseUnlocked

	u41 = true
	headerTextLabel.RichText = false
	bodyTextLabel.RichText = false
	v62 = headerTextLabel
	typeName = typeof(p4.Header)
	v62.Text = if typeName == "string" then p4.Header else "Sorry About That!"
	v64 = bodyTextLabel
	typeName2 = typeof(p4.Body)
	v64.Text = if typeName2 == "string" then p4.Body else ""

	if u44 then
		u44:Destroy()
		u44 = nil
	end

	typeName3 = typeof(p4.ItemIcon)

	if typeName3 == "string" then
		u67 = true

		if p4.ItemIcon == "" then
			u67 = false
			typeName4 = typeof(p4.ItemName)

			if typeName4 == "string" then
				u67 = p4.ItemName ~= ""
			end
		end
	else
		u67 = false
		typeName4 = typeof(p4.ItemName)

		if typeName4 == "string" then
			u67 = p4.ItemName ~= ""
		end
	end

	if u67 then
		typeName5 = typeof(p4.ItemRarity)
		v70 = if typeName5 == "string" then p4.ItemRarity else "Common"
		typeName6 = typeof(p4.ItemIcon)
		t2 = {
			icon = if typeName6 == "string" and not (p4.ItemIcon == "") then p4.ItemIcon else "rbxasset://textures/ui/GuiImagePlaceholder.png"
		}
		v73 = uiFramework.createItemCell(v70, t2)
		v73.Name = "__MakegoodCell"
		v74 = UDim2.fromScale(1, 1)
		v73.Size = v74
		v75 = UDim2.fromScale(0.5, 0.5)
		v73.Position = v75
		vector2 = Vector2.new(0.5, 0.5)
		v73.AnchorPoint = vector2
		v73.ZIndex = 54
		v73.Active = false
		v73.Selectable = false
		v73.Interactable = false
		v73.AutoButtonColor = false
		v73.Parent = itemSlot
		u44 = v73
		v77 = itemNameLabel
		typeName7 = typeof(p4.ItemName)
		v77.Text = if typeName7 == "string" then p4.ItemName else ""
		rarity.ApplyTextGradient(itemNameLabel, v70)
		typeName8 = typeof(p4.ItemTag)
		v80 = if typeName8 == "string" then p4.ItemTag else ""
		clone.Text = v80
		clone.Visible = v80 ~= ""
		itemSlot.Visible = true
		itemNameLabel.Visible = true
		bodyTextLabel.Size = bodyTextLabelSize
		bodyTextLabel.Position = bodyTextLabelPosition
	else
		itemSlot.Visible = false
		itemNameLabel.Visible = false
		clone.Visible = false
		bodyTextLabel.Size = v31
		bodyTextLabel.Position = v32
	end

	typeName9 = typeof(p4.ButtonText)
	v82 = if typeName9 == "string" then p4.ButtonText else "Thanks!"
	uiFramework.setButtonDisabled(confirm)
	v83 = confirm
	v84 = ("%s (%d)"):format(v82, makegoodWavesConfirm_delay)
	textLabel = v83:FindFirstChild("TextLabel")
	v86 = textLabel and textLabel:IsA("TextLabel")

	if v86 then
		textLabel.Text = v84
		textLabel3 = textLabel:FindFirstChild("TextLabel")

		if textLabel3 and textLabel3:IsA("TextLabel") then
			textLabel3.Text = v84
		end
	end

	backdrop.BackgroundTransparency = 1
	backdrop.Visible = true
	uiScale.Scale = 0.6
	window.Visible = true
	scriptParent.Enabled = true
	bodyTextLabel.TextSize = bodyTextLabelTextSize

	while true do
		if bodyTextLabel.TextSize > 13 and not bodyTextLabel.TextFits then
			v88 = bodyTextLabel
			v88.TextSize = v88.TextSize - 1

			continue
		else
			v89 = function()
				if u41 then
					bodyTextLabel.TextSize = bodyTextLabelTextSize

					while bodyTextLabel.TextSize > 13 and not bodyTextLabel.TextFits do
						local v104: Instance = bodyTextLabel

						v104.TextSize = v104.TextSize - 1
					end
				end
			end
			task.defer(v89)
			t3 = { BackgroundTransparency = 0.4 }
			v91 = tweenService:Create(backdrop, tweenInfo3, t3)
			v91:Play()
			t4 = { Scale = 1 }
			v93 = tweenService:Create(uiScale, tweenInfo, t4)
			v93:Play()
			sound:Play("Misc.Makegood", workspace)

			if u43 then
				task.cancel(u43)
			end

			break
		end
	end

	v94 = function()
		local n1 = os.clock() + makegoodWavesConfirm_delay
		local n2 = -1

		while u41 do
			local v107 = os.clock()
			local n3 = n1 - v107

			if n3 <= 0 then
				break
			end

			local roundedUp = math.ceil(n3)

			if n2 ~= roundedUp then
				n2 = roundedUp

				local text = ("%s (%d)"):format(v82, roundedUp)
				local textLabel4: Instance = confirm:FindFirstChild("TextLabel")

				if textLabel4 and textLabel4:IsA("TextLabel") then
					textLabel4.Text = text

					local textLabel5: Instance = textLabel4:FindFirstChild("TextLabel")

					if textLabel5 and textLabel5:IsA("TextLabel") then
						textLabel5.Text = text
					end
				end
			end

			runService.Heartbeat:Wait()
		end

		u43 = nil

		if not u41 then
			return
		end

		local v113 = v82
		local textLabel6: Instance = confirm:FindFirstChild("TextLabel")

		if textLabel6 and textLabel6:IsA("TextLabel") then
			textLabel6.Text = v113

			local textLabel7: Instance = textLabel6:FindFirstChild("TextLabel")

			if textLabel7 and textLabel7:IsA("TextLabel") then
				textLabel7.Text = v113
			end
		end

		uiFramework.setButtonEnabled(confirm)

		if inputCategorizer.getLastInputCategory() == inputCategorizer.InputCategory.Gamepad then
			guiService.SelectedObject = confirm
		end
	end
	v95 = task.spawn(v94)
	u43 = v95
	v96 = LocalPlayer
	mouseUnlocked = LocalPlayer:GetAttribute("MouseUnlocked")
	v96:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) + 1)
	windowBlur.show("MakegoodModal")
end
local function hide()
	if not u41 then
		return
	end

	u41 = false

	if u43 then
		task.cancel(u43)
		u43 = nil
	end

	local guiServiceSelectedObject: GuiObject = guiService.SelectedObject

	if guiServiceSelectedObject and guiServiceSelectedObject:IsDescendantOf(scriptParent) then
		guiService.SelectedObject = nil
	end

	tweenService:Create(backdrop, tweenInfo4, { BackgroundTransparency = 1 }):Play()

	local v99: Tween = tweenService:Create(uiScale, tweenInfo2, { Scale = 0.9 })

	v99:Play()
	v99.Completed:Once(function()
		if u41 then
			return
		end

		window.Visible = false
		backdrop.Visible = false
		uiScale.Scale = 1

		if u44 then
			u44:Destroy()
			u44 = nil
		end

		if u45 then
			u45()
		end
	end)

	local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
	local v101 = math.max((mouseUnlocked or 0) - 1, 0)

	LocalPlayer:SetAttribute("MouseUnlocked", v101)
	windowBlur.hide("MakegoodModal")
end

u45 = function()
	if u41 then
		return
	end

	local v102 = table.remove(t1, 1)

	if v102 then
		show(v102)
	end
end

local function enqueue(p5)
	if typeof(p5) == "table" then
		table.insert(t1, p5)
		u45()

		return
	end
end

confirm.MouseButton1Click:Connect(function()
	if not u41 then
		return
	end

	if not confirm.Interactable then
		return
	end

	hide()
end)

local makegoodGranted: Instance = remotes:FindFirstChild("MakegoodGranted")

if makegoodGranted and makegoodGranted:IsA("RemoteEvent") then
	makegoodGranted.OnClientEvent:Connect(enqueue)
else
	warn("[MakegoodModal] Remotes.MakegoodGranted missing -- compensation modal will never fire")
end

local showMakegood = bindables:FindFirstChild("ShowMakegood")

if not showMakegood then
	local showMakegood2: BindableEvent = Instance.new("BindableEvent")

	showMakegood2.Name = "ShowMakegood"
	showMakegood2.Parent = bindables
	showMakegood = showMakegood2
end

showMakegood.Event:Connect(enqueue)
window.Visible = false
backdrop.Visible = false
window.SelectionGroup = true
window.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
window.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
window.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
window.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
scriptParent.Enabled = true

local makegoodReady: Instance = remotes:WaitForChild("MakegoodReady", 10)

if makegoodReady and makegoodReady:IsA("RemoteEvent") then
	makegoodReady:FireServer()
else
	warn("[MakegoodModal] Remotes.MakegoodReady missing -- falling back to the server's blind timer")
end
