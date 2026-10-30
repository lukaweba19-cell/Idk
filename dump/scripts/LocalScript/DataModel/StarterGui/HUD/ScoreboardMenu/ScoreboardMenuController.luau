-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local userInputService: UserInputService = game:GetService("UserInputService")
local guiService: GuiService = game:GetService("GuiService")
local contextActionService: ContextActionService = game:GetService("ContextActionService")
local LocalPlayer: Player = players.LocalPlayer
local bindables: Instance = replicatedStorage:WaitForChild("Bindables")

replicatedStorage:WaitForChild("Remotes")
bindables:WaitForChild("ConfirmModal")

local shared: Instance = replicatedStorage:WaitForChild("Shared")
local copyCrosshair = require(shared:WaitForChild("CopyCrosshair"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local reportPlayer = require(replicatedStorageShared:WaitForChild("ReportPlayer"))
local extensions: Instance = replicatedStorage:WaitForChild("Extensions")
local inputCategorizer = require(extensions:WaitForChild("InputCategorizer"))
local scriptParent: Instance = script.Parent
local main: Instance = scriptParent:WaitForChild("Main")
local reason: Instance = scriptParent:WaitForChild("Reason")
local report: Instance = main:WaitForChild("Report")
local mainCopyCrosshair: Instance = main:WaitForChild("CopyCrosshair")
local close: Instance = main:WaitForChild("Close")
local header: Instance = main:FindFirstChild("Header")
local cheating: Instance = reason:WaitForChild("Cheating")
local other: Instance = reason:WaitForChild("Other")
local back: Instance = reason:WaitForChild("Back")
local u24 = nil
local s1 = ""
local u26: boolean = false
local u27 = nil
local u28 = nil
local u29 = nil

local function bumpMouse()
	if u26 then
		return
	end

	u26 = true

	local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

	LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) + 1)
end
local function releaseMouse()
	if not u26 then
		return
	end

	u26 = false

	local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
	local v48 = math.max((mouseUnlocked or 0) - 1, 0)

	LocalPlayer:SetAttribute("MouseUnlocked", v48)
end
local function usingGamepad()
	return inputCategorizer.getLastInputCategory() == inputCategorizer.InputCategory.Gamepad
end
local function selectForPage()
	if inputCategorizer.getLastInputCategory() ~= inputCategorizer.InputCategory.Gamepad then
		return
	end

	if reason.Visible then
		guiService.SelectedObject = if cheating.Visible then cheating else back

		return
	end

	guiService.SelectedObject = if report.Visible then report else close
end
local function showPage(visible)
	main.Visible = not visible
	reason.Visible = visible

	if scriptParent.Visible then
		if inputCategorizer.getLastInputCategory() ~= inputCategorizer.InputCategory.Gamepad then
			return
		end

		if reason.Visible then
			guiService.SelectedObject = if cheating.Visible then cheating else back

			return
		end

		guiService.SelectedObject = if report.Visible then report else close

		return
	end
end
local function closeMenu()
	if not scriptParent.Visible then
		return
	end

	local guiServiceSelectedObject: GuiObject = guiService.SelectedObject
	local u51: boolean = false

	if guiServiceSelectedObject ~= nil then
		u51 = guiServiceSelectedObject:IsDescendantOf(scriptParent)
	end

	local selectedObject = u27

	scriptParent.Visible = false
	main.Visible = true
	reason.Visible = false

	if scriptParent.Visible and inputCategorizer.getLastInputCategory() == inputCategorizer.InputCategory.Gamepad then
		if reason.Visible then
			guiService.SelectedObject = if cheating.Visible then cheating else back
		else
			guiService.SelectedObject = if report.Visible then report else close
		end
	end

	if u29 then
		u29()
	end

	if u51 then
		local v53: GuiObject = guiService.SelectedObject

		if v53 == nil or v53:IsDescendantOf(scriptParent) then
			if LocalPlayer:GetAttribute("ScoreboardFocused") == true and selectedObject and selectedObject.Parent then
				guiService.SelectedObject = selectedObject
			elseif v53 ~= nil then
				guiService.SelectedObject = nil
			end
		end
	end

	u27 = nil
	u24 = nil
	s1 = ""

	if u26 then
		u26 = false

		local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")
		local v55 = math.max((mouseUnlocked or 0) - 1, 0)

		LocalPlayer:SetAttribute("MouseUnlocked", v55)
	end

	LocalPlayer:SetAttribute("ScoreboardMenuOpen", nil)
end
local function toGuiSpace(p2, p3)
	local v58 = guiService:GetGuiInset()
	local absolutePosition = p3.AbsolutePosition
	local absoluteSize = p3.AbsoluteSize

	local function inside(p4)
		return p4.X >= absolutePosition.X and p4.X <= absolutePosition.X + absoluteSize.X and p4.Y >= absolutePosition.Y and p4.Y <= absolutePosition.Y + absoluteSize.Y
	end

	for _, v in ipairs({ p2, p2 - v58, p2 + v58 }) do
		if v.X >= absolutePosition.X and v.X <= absolutePosition.X + absoluteSize.X and v.Y >= absolutePosition.Y and v.Y <= absolutePosition.Y + absoluteSize.Y then
			return v
		end
	end

	return p2
end
local function positionFor(p5, p6)
	local CurrentCamera: Camera = workspace.CurrentCamera
	local v67 = CurrentCamera and CurrentCamera.ViewportSize or Vector2.new(1280, 720)
	local n1: number = 0

	for _, v in ipairs(main:GetChildren()) do
		if v:IsA("TextButton") and v.Visible then
			n1 += 1
		end
	end

	local v71 = math.max(n1 - 1, 0)
	local n2 = n1 * 34 + v71 * 4 + 12

	if header and header.Visible then
		n2 += 24
	end

	local n3
	local n4

	if p6 then
		local v75 = toGuiSpace(p6, p5)

		n3 = v75.X + 6
		n4 = v75.Y + 6
	else
		local absolutePosition = p5.AbsolutePosition
		local absoluteSize = p5.AbsoluteSize

		n3 = absolutePosition.X + absoluteSize.X - 176
		n4 = absolutePosition.Y + absoluteSize.Y
	end

	if n3 + 176 > v67.X - 8 then
		n3 = n3 - 176 - 12
	end

	if n4 + n2 > v67.Y - 8 then
		n4 = n4 - n2 - 12
	end

	local v78 = math.max(8, v67.X - 176 - 8)
	local v79 = math.clamp(n3, 8, v78)

	v78 = math.max(8, v67.Y - n2 - 8)

	local v80 = math.clamp(n4, 8, v78)

	scriptParent.Position = UDim2.fromOffset(v79, v80)
end
local function openMenu(p7, p8, p9, p10, _, p12, p13)
	if scriptParent.Visible and p8 == u24 then
		closeMenu()

		return
	end

	u24 = p8
	s1 = p9
	report.Visible = not p12
	mainCopyCrosshair.Visible = not p12

	if p12 then
		u24 = nil
		s1 = ""

		return
	end

	if header then
		header.Text = if p10 == "" then p9 else "@" .. p10
	end

	main.Visible = true
	reason.Visible = false

	if scriptParent.Visible and inputCategorizer.getLastInputCategory() == inputCategorizer.InputCategory.Gamepad then
		if reason.Visible then
			guiService.SelectedObject = if cheating.Visible then cheating else back
		else
			guiService.SelectedObject = if report.Visible then report else close
		end
	end

	LocalPlayer:SetAttribute("ScoreboardMenuOpen", true)

	if not u26 then
		u26 = true

		local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

		LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) + 1)
	end

	scriptParent.Visible = true
	positionFor(p7, p13)
	u27 = p7
	u28()

	if inputCategorizer.getLastInputCategory() ~= inputCategorizer.InputCategory.Gamepad then
		return
	end

	if reason.Visible then
		guiService.SelectedObject = if cheating.Visible then cheating else back

		return
	end

	guiService.SelectedObject = if report.Visible then report else close
end
local function reportOrigin()
	local matchId: any = LocalPlayer:GetAttribute("MatchId")

	if typeof(matchId) == "string" and matchId ~= "" and matchId ~= "PRACTICE" then
		return "live"
	end

	local lobbySpectateMatchId: any = LocalPlayer:GetAttribute("LobbySpectateMatchId")

	if typeof(lobbySpectateMatchId) == "string" and lobbySpectateMatchId ~= "" then
		return "spectate"
	end

	local spectating: any = LocalPlayer:GetAttribute("Spectating")

	if typeof(spectating) == "number" and spectating ~= 0 then
		return "spectate"
	end

	return "live"
end
local function submitReport(p14)
	local v93 = u24
	local v94 = s1

	if not v93 then
		closeMenu()

		return
	end

	closeMenu()

	local reportPlayerRequest = reportPlayer.Request
	local v96 = reportOrigin()

	reportPlayerRequest(v93, v94, p14, v96)
end

local u41: boolean = false

u28 = function()
	if u41 then
		return
	end

	u41 = true
	contextActionService:BindActionAtPriority("ScoreboardMenu_CloseB", function(_, p16, input)
		if input.UserInputType ~= Enum.UserInputType.Gamepad1 then
			return Enum.ContextActionResult.Pass
		end

		if not scriptParent.Visible then
			return Enum.ContextActionResult.Pass
		end

		if p16 == Enum.UserInputState.Begin then
			if reason.Visible then
				main.Visible = true
				reason.Visible = false

				if scriptParent.Visible and inputCategorizer.getLastInputCategory() == inputCategorizer.InputCategory.Gamepad then
					if reason.Visible then
						guiService.SelectedObject = if cheating.Visible then cheating else back
					else
						guiService.SelectedObject = if report.Visible then report else close
					end
				end
			else
				closeMenu()
			end
		end

		return Enum.ContextActionResult.Sink
	end, false, 5000, Enum.KeyCode.ButtonB)
end
u29 = function()
	if not u41 then
		return
	end

	u41 = false
	contextActionService:UnbindAction("ScoreboardMenu_CloseB")
end
report.Activated:Connect(function()
	if not u24 then
		return
	end

	main.Visible = false
	reason.Visible = true

	if scriptParent.Visible then
		if inputCategorizer.getLastInputCategory() ~= inputCategorizer.InputCategory.Gamepad then
			return
		end

		if reason.Visible then
			guiService.SelectedObject = if cheating.Visible then cheating else back

			return
		end

		guiService.SelectedObject = if report.Visible then report else close

		return
	end
end)
back.Activated:Connect(function()
	main.Visible = true
	reason.Visible = false

	if scriptParent.Visible then
		if inputCategorizer.getLastInputCategory() ~= inputCategorizer.InputCategory.Gamepad then
			return
		end

		if reason.Visible then
			guiService.SelectedObject = if cheating.Visible then cheating else back

			return
		end

		guiService.SelectedObject = if report.Visible then report else close

		return
	end
end)
cheating.Activated:Connect(function()
	local v97 = u24
	local v98 = s1

	if not v97 then
		closeMenu()

		return
	end

	closeMenu()

	local reportPlayerRequest = reportPlayer.Request
	local v100 = reportOrigin()

	reportPlayerRequest(v97, v98, "Cheating", v100)
end)
other.Activated:Connect(function()
	local v101 = u24
	local v102 = s1

	if not v101 then
		closeMenu()

		return
	end

	closeMenu()

	local reportPlayerRequest = reportPlayer.Request
	local v104 = reportOrigin()

	reportPlayerRequest(v101, v102, "Other", v104)
end)
close.Activated:Connect(closeMenu)
mainCopyCrosshair.Activated:Connect(function()
	local v105 = u24
	local v106 = s1

	if not v105 then
		closeMenu()

		return
	end

	closeMenu()
	copyCrosshair.Request(v105, v106)
end)
LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(closeMenu)
LocalPlayer:GetAttributeChangedSignal("Spectating"):Connect(closeMenu)
players.PlayerRemoving:Connect(function(player: Player)
	if u24 == player.UserId then
		closeMenu()
	end
end)
userInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	if gameProcessedEvent then
	elseif input.KeyCode == Enum.KeyCode.Escape and scriptParent.Visible then
		closeMenu()
	end
end)
userInputService.InputBegan:Connect(function(input: InputObject)
	if not scriptParent.Visible then
	elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		local vector2 = Vector2.new(input.Position.X, input.Position.Y)
		local v112 = reason.Visible and reason or main
		local absolutePosition = v112.AbsolutePosition
		local absoluteSize = v112.AbsoluteSize

		v112 = guiService:GetGuiInset()

		for _, v in ipairs({ vector2, vector2 - v112, vector2 + v112 }) do
			if v.X >= absolutePosition.X and v.X <= absolutePosition.X + absoluteSize.X and v.Y >= absolutePosition.Y and v.Y <= absolutePosition.Y + absoluteSize.Y then
				return
			end
		end

		local v117 = u24

		task.defer(function()
			if scriptParent.Visible and u24 == v117 then
				closeMenu()
			end
		end)

		return
	end
end)

local activeWindowChanged: Instance = bindables:FindFirstChild("ActiveWindowChanged")

if activeWindowChanged then
	activeWindowChanged.Event:Connect(function(p22)
		if p22 ~= "ScoreboardMenu" then
			closeMenu()
		end
	end)
end

local openScoreboardMenu: BindableEvent = Instance.new("BindableEvent")

openScoreboardMenu.Name = "OpenScoreboardMenu"
openScoreboardMenu.Parent = script
openScoreboardMenu.Event:Connect(function(p23)
	if typeof(p23) == "table" then
		local rowFrame = p23.RowFrame
		local userId = p23.UserId

		if typeof(userId) == "number" then
			if typeof(rowFrame) ~= "Instance" or not rowFrame:IsA("GuiObject") then
				return
			end

			local v122 = typeof(p23.DisplayName) == "string" and p23.DisplayName or "this player"
			local v123 = typeof(p23.Username) == "string" and p23.Username or ""
			local u124: boolean = p23.IsBot == true
			local u125: boolean = userId == LocalPlayer.UserId
			local typeName: string = typeof(p23.ClickPosition)

			openMenu(rowFrame, userId, v122, v123, u124, u125, typeName == "Vector2" and p23.ClickPosition or nil)

			return
		end

		return
	end
end)
scriptParent.Visible = false
main.Visible = true
reason.Visible = false

if scriptParent.Visible and inputCategorizer.getLastInputCategory() == inputCategorizer.InputCategory.Gamepad then
	if reason.Visible then
		guiService.SelectedObject = if cheating.Visible then cheating else back
	else
		guiService.SelectedObject = if report.Visible then report else close
	end
end

LocalPlayer:SetAttribute("ScoreboardMenuOpen", nil)

for _, v in ipairs({ main, reason }) do
	v.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
	v.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
	v.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
	v.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
end
