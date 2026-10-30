-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer: Player = players.LocalPlayer
local scriptParent: Instance = script.Parent

scriptParent.Enabled = false

local panel: Instance = scriptParent:WaitForChild("Panel")
local content: Instance = panel:WaitForChild("Content")
local playersScrollingFrame: Instance = content:WaitForChild("PlayersScrollingFrame")
local closeButton: Instance = panel:WaitForChild("CloseButton")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local windowBlur = require(shared:WaitForChild("WindowBlur"))
local windowSlide = require(shared:WaitForChild("WindowSlide"))
local screenWipe = require(shared:WaitForChild("ScreenWipe"))
local serverNameGen = require(scriptParent:WaitForChild("ServerNameGen"))
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local plazaServerList: Instance = remotes:WaitForChild("PlazaServerList")
local plazaJoinServer: Instance = remotes:WaitForChild("PlazaJoinServer")
local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local activeWindowChanged: Instance = bindables:WaitForChild("ActiveWindowChanged")
local openPlazaServerList = bindables:FindFirstChild("OpenPlazaServerList")

if not openPlazaServerList then
	local openPlazaServerList2: BindableEvent = Instance.new("BindableEvent")

	openPlazaServerList2.Name = "OpenPlazaServerList"
	openPlazaServerList2.Parent = bindables
	openPlazaServerList = openPlazaServerList2
end

local textLabel: Instance = panel:FindFirstChild("TextLabel")

if textLabel and textLabel:IsA("TextLabel") then
	textLabel.Text = "Join a server to trade with others"
end

local function notifyError(p1)
	if _G.Notify then
		_G.Notify({ notifType = "FailNotification", errorMessage = p1 })
	end
end

local u23 = nil

for _, v in ipairs(playersScrollingFrame:GetChildren()) do
	if v:IsA("Frame") and v.Name == "ServerCard_Template" then
		v.Visible = false
		u23 = v

		break
	end
end

local statusLabel: TextLabel = Instance.new("TextLabel")

statusLabel.Name = "StatusLabel"
statusLabel.BackgroundTransparency = 1
statusLabel.Size = UDim2.fromScale(0.9, 0.3)
statusLabel.Position = UDim2.fromScale(0.5, 0.42)
statusLabel.AnchorPoint = Vector2.new(0.5, 0.5)
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextSize = 20
statusLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
statusLabel.TextWrapped = true
statusLabel.Visible = false
statusLabel.ZIndex = 5
statusLabel.Parent = content

local function setStatus(text)
	if text then
		statusLabel.Text = text
		statusLabel.Visible = true

		return
	end

	statusLabel.Visible = false
end

local t1 = {}
local n1 = 0
local u30: boolean = false
local n2: number = 0
local n3: number = 0

local function u33()
end
local function v34()
end
local function clearRows()
	for _, v in ipairs(playersScrollingFrame:GetChildren()) do
		if v:IsA("GuiObject") and v ~= u23 and v.Name ~= "PADDINGFIX" then
			v:Destroy()
		end
	end

	n1 = 0
end
local function attemptJoin(p3)
	if u30 then
		return
	end

	u30 = true
	n2 += 1

	local v52: number = n2

	screenWipe.cover(0.5, "Joining Trading Plaza")
	plazaJoinServer:FireServer(p3)
	task.delay(12, function()
		if n2 ~= v52 then
			return
		end

		u30 = false
		screenWipe.reveal(0.5)

		if scriptParent.Enabled then
			task.spawn(u33)
		end
	end)
end
local function makeRow(p4, layoutOrder)
	if not u23 then
		return
	end

	local clone = u23:Clone()

	clone.Name = "ServerRow"
	clone.LayoutOrder = layoutOrder
	clone.Visible = true

	local numberValue: number? = tonumber(p4.count)
	local numberValue2: number? = tonumber(p4.max)
	local username = clone:FindFirstChild("Username")

	if username and username:IsA("TextLabel") then
		username.Text = string.format("%d / %d", numberValue or 0, numberValue2 or 50)
	end

	local serverId = clone:FindFirstChild("ServerId")

	if serverId and serverId:IsA("TextLabel") then
		if type(p4.jobId) == "string" and p4.jobId ~= "" then
			serverId.Text = "ID: " .. serverNameGen.fromJobId(p4.jobId)
		else
			serverId.Text = ""
		end
	end

	local buttons = clone:FindFirstChild("Buttons")
	local v61 = buttons

	if v61 then
		v61 = buttons:FindFirstChild("JoinButton")
	end

	if v61 and v61:IsA("TextButton") then
		v61.MouseButton1Click:Connect(function()
			if not v61.Interactable then
			elseif type(p4.jobId) == "string" and p4.jobId ~= "" then
				attemptJoin(p4.jobId)

				return
			end
		end)
	end

	clone.Parent = playersScrollingFrame
end
local function renderNextChunk()
	local v62 = math.min(n1 + 20, #t1)

	for i = n1 + 1, v62 do
		makeRow(t1[i], i)
	end

	n1 = v62
end
local function nearBottom()
	return playersScrollingFrame.CanvasPosition.Y + playersScrollingFrame.AbsoluteWindowSize.Y >= playersScrollingFrame.AbsoluteCanvasSize.Y - 140
end

u33 = function()
	n3 += 1

	local v64: number = n3

	clearRows()
	t1 = {}
	statusLabel.Text = "Loading servers…"
	statusLabel.Visible = true

	local ok, result = pcall(function()
		return plazaServerList:InvokeServer()
	end)

	if v64 ~= n3 or not scriptParent.Enabled then
		return
	end

	if ok and type(result) == "table" and type(result.servers) == "table" then
		t1 = result.servers

		if #t1 == 0 then
			statusLabel.Text = "No open servers right now."
			statusLabel.Visible = true

			return
		end

		statusLabel.Visible = false

		local v67 = math.min(n1 + 20, #t1)

		for i = n1 + 1, v67 do
			makeRow(t1[i], i)
		end

		n1 = v67

		return
	end

	statusLabel.Text = "Couldn't load servers. Try again."
	statusLabel.Visible = true
end
playersScrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
	if n1 < #t1 and playersScrollingFrame.CanvasPosition.Y + playersScrollingFrame.AbsoluteWindowSize.Y >= playersScrollingFrame.AbsoluteCanvasSize.Y - 140 then
		local v69 = math.min(n1 + 20, #t1)

		for i = n1 + 1, v69 do
			makeRow(t1[i], i)
		end

		n1 = v69
	end
end)
plazaJoinServer.OnClientEvent:Connect(function(p6)
	if p6 == "failed" then
		n2 += 1
		u30 = false
		screenWipe.reveal(0.5)

		if _G.Notify then
			_G.Notify({
				notifType = "FailNotification",
				errorMessage = "Couldn't join that server - it may have just filled up."
			})
		end

		if scriptParent.Enabled then
			task.spawn(u33)
		end
	end
end)

local panelPosition = panel.Position
local v41 = windowSlide.closedPosFor(panelPosition)
local u42 = nil
local u43: boolean = false

local function cancelSlide()
	if u42 then
		u42:Cancel()
		u42 = nil
	end
end
local function openWindow()
	if u42 then
		u42:Cancel()
		u42 = nil
	end

	local v72: boolean = u43

	if not u43 then
		u43 = true

		local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

		LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) + 1)
		pcall(function()
			windowBlur.show("PlazaServerList")
		end)
	end

	activeWindowChanged:Fire("PlazaServerList")
	scriptParent.Enabled = true

	if not v72 then
		u42 = windowSlide.slideIn(panel, panelPosition, v41)
	else
		panel.Visible = true
	end

	task.spawn(u33)
end
local function u46()
	if not u43 then
		return
	end

	u43 = false

	local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
	local v75 = math.max((mouseUnlocked or 0) - 1, 0)

	LocalPlayer:SetAttribute("MouseUnlocked", v75)
	pcall(function()
		windowBlur.hide("PlazaServerList")
	end)

	if u42 then
		u42:Cancel()
		u42 = nil
	end

	u42 = windowSlide.slideOut(panel, v41, function()
		if not u43 then
			scriptParent.Enabled = false
			panel.Position = panelPosition
		end
	end)
end

closeButton.MouseButton1Click:Connect(function()
	u46()
end)
openPlazaServerList.Event:Connect(openWindow)
_G.OpenPlazaServerList = openWindow
activeWindowChanged.Event:Connect(function(p7)
	if p7 ~= "PlazaServerList" and scriptParent.Enabled then
		u46()
	end
end)
