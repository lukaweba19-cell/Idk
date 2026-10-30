-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local userInputService: UserInputService = game:GetService("UserInputService")
local uiFramework = require(game.ReplicatedStorage:WaitForChild("UIFramework"))
local extensions = game.ReplicatedStorage:WaitForChild("Extensions")
local gamepadBindings = require(extensions:WaitForChild("GamepadBindings"))
local replicatedStorageExtensions = game.ReplicatedStorage:WaitForChild("Extensions")
local inputMap = require(replicatedStorageExtensions:WaitForChild("InputMap"))
local contextActionService: ContextActionService = game:GetService("ContextActionService")
local guiService: GuiService = game:GetService("GuiService")
local v11 = game.ReplicatedStorage:WaitForChild("Extensions")
local inputCategorizer = require(v11:WaitForChild("InputCategorizer"))
local runService: RunService = game:GetService("RunService")
local lighting: Lighting = game:GetService("Lighting")

game:GetService("TweenService")

local shared: Instance = replicatedStorage:WaitForChild("Shared")
local windowBlur = require(shared:WaitForChild("WindowBlur"))
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local finisherPreview = require(replicatedStorageShared:WaitForChild("FinisherPreview"))
local v19: Instance = replicatedStorage:WaitForChild("Shared")
local playerState = require(v19:WaitForChild("PlayerState"))
local v21: Instance = replicatedStorage:WaitForChild("Shared")
local wieldedPreview = require(v21:WaitForChild("WieldedPreview"))
local v23: Instance = replicatedStorage:WaitForChild("Extensions")
local mobileTouchController = require(v23:WaitForChild("MobileTouchController"))
local LocalPlayer: Player = players.LocalPlayer
local CurrentCamera: Camera = workspace.CurrentCamera
local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui")

local v28, v29, v30, v31, v32, v33, v34, parent, v36 = (function()
	local inspectHUD: Instance = playerGui:WaitForChild("InspectHUD")
	local frame: Instance = inspectHUD:WaitForChild("Frame")
	local exit: Instance = frame:WaitForChild("Exit")
	local itemName: Instance = frame:WaitForChild("ItemName")
	local itemRarity: Instance = frame:WaitForChild("ItemRarity")
	local itemExist: Instance = frame:WaitForChild("ItemExist")
	local itemStrip: Instance = frame:WaitForChild("ItemStrip")
	local modeStrip: Instance = frame:WaitForChild("ModeStrip")
	local hud: Instance = playerGui:WaitForChild("HUD")

	return inspectHUD, hud, exit, itemName, itemRarity, itemExist, itemStrip, modeStrip, frame
end)()

v28.Enabled = false
v36.SelectionGroup = true
v36.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
v36.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
v36.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
v36.SelectionBehaviorRight = Enum.SelectionBehavior.Stop

local template = v34:WaitForChild("Template")
local templateAccent = v34:WaitForChild("TemplateAccent")

template.Visible = false
templateAccent.Visible = false
v34.Visible = false

local s1 = "Inspect"
local t1: {[any]: any} = {}

parent.Visible = false

local function updateModeSelection()
	for k, v in pairs(t1) do
		local darkenDeselectedCover = v:FindFirstChild("DarkenDeselectedCover")

		if darkenDeselectedCover and darkenDeselectedCover:IsA("GuiObject") then
			darkenDeselectedCover.Visible = k ~= s1
		end
	end
end

local v42 = v33.Position
local uDim2 = UDim2.new(v42.X.Scale, v42.X.Offset, v42.Y.Scale - 0.085, v42.Y.Offset)
local inspectRoom: Instance = workspace:WaitForChild("Lobby"):WaitForChild("InspectRoom")
local itemPart: Instance = inspectRoom:WaitForChild("ItemPart")

itemPart.Transparency = 1
itemPart.CanCollide = false
itemPart.CanQuery = false
itemPart.CanTouch = false

local v46: Instance = replicatedStorage:WaitForChild("Shared")
local rarity = require(v46:WaitForChild("Rarity"))
local v48: Instance = replicatedStorage:WaitForChild("Shared")
local traitText = require(v48:WaitForChild("TraitText"))
local rarityColors = rarity.Colors

local function rarityColor(p1)
	return rarityColors[p1] or rarityColors.Common
end
local function setRarityTag(text)
	v32.Text = text
	v32.BackgroundTransparency = 1
	v32.BackgroundColor3 = rarityColors[text] or rarityColors.Common
	rarity.ApplyTextGradient(v32, text)

	local uiStroke = v32:FindFirstChildWhichIsA("UIStroke")

	if uiStroke then
		uiStroke.Color = Color3.new(0, 0, 0)
	end

	local uiStrokeBorder = v32:FindFirstChild("UIStrokeBorder")

	if uiStrokeBorder and uiStrokeBorder:IsA("UIStroke") then
		uiStrokeBorder.Color = Color3.new(0, 0, 0)
	end
end
local function formatNumber(p3)
	return (tostring(p3):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
end
local function setExistText(p4)
	if typeof(p4) == "number" then
		v33.Text = tostring(p4):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") .. " exist"

		return
	end

	v33.Text = ""
end

local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local inspectItem: Instance = bindables:WaitForChild("InspectItem")
local animateSkins: Instance = bindables:WaitForChild("AnimateSkins")
local u58 = nil
local n1 = 1
local t2: {[any]: any} = {}
local u61 = nil
local u62 = nil
local default: Instance = replicatedStorage:WaitForChild("Anims"):WaitForChild("Default")
local u64 = nil
local u65: boolean = false
local u66: boolean = false
local u67 = nil
local CFrame2 = nil
local u69 = nil

local function isGamepad()
	return inputCategorizer.getLastInputCategory() == inputCategorizer.InputCategory.Gamepad
end
local function isReachable(p5)
	if p5 == nil or p5.Parent == nil then
		return false
	end

	local v164 = p5

	while v164 and v164 ~= v28 do
		if v164:IsA("GuiObject") and not v164.Visible then
			return false
		end

		v164 = v164.Parent
	end

	local u165 = false

	if v164 == v28 then
		u165 = v28.Enabled
	end

	return u165
end
local function preferredSelection()
	for k, v in pairs(t1) do
		if k ~= s1 and isReachable(v) then
			return v
		end
	end

	local v168 = t2[n1]

	if isReachable(v168) then
		return v168
	end

	return v30
end
local function claimSelection()
	if inputCategorizer.getLastInputCategory() ~= inputCategorizer.InputCategory.Gamepad then
		return
	end

	local selectedObject = preferredSelection()

	if not selectedObject then
		return
	end

	u69 = selectedObject
	guiService.SelectedObject = selectedObject
end
local function releaseSelection()
	u69 = nil

	local guiServiceSelectedObject: GuiObject = guiService.SelectedObject

	if guiServiceSelectedObject and guiServiceSelectedObject:IsDescendantOf(v28) then
		guiService.SelectedObject = nil
	end
end

guiService:GetPropertyChangedSignal("SelectedObject"):Connect(function()
	if guiService.SelectedObject ~= nil then
		return
	end

	if not u65 or not v28.Enabled then
		return
	end

	if u69 == nil or isReachable(u69) then
		return
	end

	task.defer(function()
		if not u65 or not v28.Enabled then
		elseif guiService.SelectedObject == nil then
			if inputCategorizer.getLastInputCategory() ~= inputCategorizer.InputCategory.Gamepad then
				return
			end

			local selectedObject = preferredSelection()

			if not selectedObject then
				return
			end

			u69 = selectedObject
			guiService.SelectedObject = selectedObject

			return
		end
	end)
end)

local u75: boolean = false
local u76 = nil
local n2: number = 0.016666666666666666
local cFrameIdentity = CFrame.identity
local vector2Zero = Vector2.zero
local n3 = 3
local n4 = 3
local n5 = 1
local connection4 = nil
local connection = nil
local connection2 = nil
local connection3 = nil
local u87 = Vector2.zero
local n6: number = 0
local u89 = nil
local u90 = nil
local u91 = nil

local function disconnectAll()
	if connection4 then
		connection4:Disconnect()
		connection4 = nil
	end

	if connection then
		connection:Disconnect()
		connection = nil
	end

	if connection2 then
		connection2:Disconnect()
		connection2 = nil
	end

	if connection3 then
		connection3:Disconnect()
		connection3 = nil
	end
end

local u93 = nil

local function destroyActive()
	u93()

	if u62 then
		u62:Destroy()
		u62 = nil
	end
end
local function resolveRigIdleAnim(p6, p7)
	local s1 = if p6 == "Knife" then "Knives" else if p6 == "Revolver" then "Revolvers" else nil

	if not s1 then
		return nil
	end

	local foundChild: Instance = default:FindFirstChild(s1)

	if not foundChild then
		return nil
	end

	local foundChild2: Instance = foundChild:FindFirstChild(p7)

	if not foundChild2 then
		foundChild2 = foundChild:FindFirstChild("Default")
	end

	local idle: Instance = foundChild2 and foundChild2:FindFirstChild("Idle")

	return idle and idle:IsA("Animation") and idle or nil
end
local function startRigAnim(p8, p9, p10)
	local foundChild = p8:FindFirstChildWhichIsA("AnimationController", true)

	if not foundChild then
		return
	end

	local animator = foundChild:FindFirstChildWhichIsA("Animator")

	if not animator then
		return
	end

	local v182 = resolveRigIdleAnim(p9, p10)

	if not v182 then
		return
	end

	local ok, result = pcall(function()
		return animator:LoadAnimation(v182)
	end)

	if ok and result then
		result.Looped = true
		result.Priority = Enum.AnimationPriority.Idle
		result:Play()
		u64 = result

		return
	end
end

u93 = function()
	if u64 then
		pcall(function()
			u64:Stop(0)
		end)
		u64 = nil
	end
end

local function setHudEnabled(enabled)
	v29.Enabled = enabled
end
local function clampCamDist(p12)
	local n1: number = n5 * 1.5
	local n2: number = n5 * 6

	if p12 < n1 then
		return n1
	end

	if p12 > n2 then
		return n2
	end

	return p12
end
local function applyTileContent(p13, text, p15)
	local u192: boolean = false

	if typeof(p15) == "string" then
		u192 = p15 ~= ""
	end

	local icon = p13:FindFirstChild("Icon")

	if icon and icon:IsA("ImageLabel") then
		icon.Image = if u192 then p15 else ""
		icon.Visible = u192
	end

	local label = p13:FindFirstChild("Label")

	if label and label:IsA("TextLabel") then
		label.Text = text

		for _, v in ipairs(label:GetDescendants()) do
			if v:IsA("TextLabel") then
				v.Text = text
			end
		end

		if not u192 then
			label.Position = UDim2.new(0.5, 0, label.Position.Y.Scale, 0)
			label.Size = UDim2.fromScale(0.84, label.Size.Y.Scale)
		end
	end
end
local function setCameraInspect()
	CurrentCamera.CameraType = Enum.CameraType.Scriptable

	local itemPartCFrame = itemPart.CFrame
	local cFrame = CFrame.new(0, 0, -n4)

	CurrentCamera.CFrame = CFrame.lookAt((itemPartCFrame * cFrame).Position, itemPartCFrame.Position)
	game.Lighting.EnvironmentSpecularScale = 1
end
local function setCameraWielded()
	CurrentCamera.CameraType = Enum.CameraType.Scriptable

	local itemPartCFrame = itemPart.CFrame

	CurrentCamera.CFrame = CFrame.lookAt((itemPartCFrame * CFrame.new(0, 0, -3)).Position, itemPartCFrame.Position)
	game.Lighting.EnvironmentSpecularScale = 1
end
local function restoreCamera()
	if CFrame2 then
		CurrentCamera.CFrame = CFrame2
		CFrame2 = nil
	end

	CurrentCamera.CameraType = Enum.CameraType.Custom

	local Character: Model = LocalPlayer.Character
	local humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		CurrentCamera.CameraSubject = humanoid
	end

	game.Lighting.EnvironmentSpecularScale = 0.1
end
local function pivotItem()
	if not u62 then
		return
	end

	u62:PivotTo(itemPart.CFrame * cFrameIdentity)
end
local function applyDeltaRotation(p16, p17, p18)
	if not u62 then
		return
	end

	local rightVector = CurrentCamera.CFrame.RightVector
	local v206 = CFrame.fromAxisAngle(CurrentCamera.CFrame.UpVector, -p16 * p18)
	local v207 = CFrame.fromAxisAngle(rightVector, -p17 * p18)

	cFrameIdentity = v206 * v207 * cFrameIdentity

	if not u62 then
		return
	end

	u62:PivotTo(itemPart.CFrame * cFrameIdentity)
end
local function applyZoomDelta(p19)
	local n1 = n3 - p19 * n5
	local n2: number = n5 * 1.5
	local n4: number = n5 * 6

	n3 = if n1 < n2 then n2 else if n1 > n4 then n4 else n1
end
local function visibleRadius(p20)
	local v213, v214 = p20:GetBoundingBox()
	local v215 = v213:Inverse()
	local vector3 = nil
	local vector32 = nil

	for _, v in ipairs(p20:GetDescendants()) do
		if v:IsA("BasePart") and v.Transparency < 1 then
			local n1 = v215 * v.Position
			local n2 = v.Size * 0.5
			local n3 = n1 - n2
			local n4 = n1 + n2

			if vector3 and vector32 then
				local v224 = math.min(vector3.X, n3.X)
				local v225 = math.min(vector3.Y, n3.Y)
				local v226 = math.min(vector3.Z, n3.Z)

				vector3 = Vector3.new(v224, v225, v226)
				v224 = math.max(vector32.X, n4.X)
				v225 = math.max(vector32.Y, n4.Y)
				v226 = math.max(vector32.Z, n4.Z)
				vector32 = Vector3.new(v224, v225, v226)
			else
				vector3 = n3
				vector32 = n4
			end
		end
	end

	if vector3 and vector32 then
		return (vector32 - vector3).Magnitude * 0.5
	end

	return v214.Magnitude * 0.5
end
local function fitDistanceFor(p21)
	local n1 = math.rad(CurrentCamera.FieldOfView) * 0.5

	if n1 <= 0 then
		return 3
	end

	local v229 = visibleRadius(p21)
	local v230 = math.tan(n1)

	return v229 / v230 * 1.15
end
local function inspectPoseFor(p22)
	local inspectCFrame = p22:GetAttribute("InspectCFrame")

	if typeof(inspectCFrame) == "CFrame" then
		return inspectCFrame.Rotation
	end

	if typeof(inspectCFrame) == "Vector3" then
		local cFrameFromOrientation = CFrame.fromOrientation
		local v234 = math.rad(inspectCFrame.X)
		local v235 = math.rad(inspectCFrame.Y)
		local v236 = math.rad(inspectCFrame.Z)

		return cFrameFromOrientation(v234, v235, v236)
	end

	return nil
end
local function visibleCenter(p23, p24)
	local v239 = nil
	local v240 = nil

	for _, v in ipairs(p23:GetDescendants()) do
		if v:IsA("BasePart") and v.Transparency < 1 then
			local v243 = p24:ToObjectSpace(v.CFrame)
			local n1 = v.Size * 0.5

			for _, iterValue in ipairs({ -1, 1 }) do
				for _, iterValue2 in ipairs({ -1, 1 }) do
					for _, iterValue3 in ipairs({ -1, 1 }) do
						local vector3 = Vector3.new(n1.X * iterValue, n1.Y * iterValue2, n1.Z * iterValue3)
						local n2 = v243 * vector3

						v239 = if v239 then v239:Min(n2) else n2
						v240 = if v240 then v240:Max(n2) else n2
					end
				end
			end
		end
	end

	if v239 and v240 then
		return p24 * ((v239 + v240) * 0.5)
	end

	return nil
end
local function ensureCenteredPrimaryPart(parent, p26)
	local v255, v256 = parent:GetBoundingBox()
	local boundingBox = parent:FindFirstChild("BoundingBox")

	if boundingBox then
		v255 = boundingBox.CFrame

		local boundingBoxSize = boundingBox.Size
	end

	local __InspectPivot: Part = Instance.new("Part")

	__InspectPivot.Name = "__InspectPivot"
	__InspectPivot.Size = Vector3.new(0.2, 0.2, 0.2)
	__InspectPivot.Transparency = 1
	__InspectPivot.Anchored = true
	__InspectPivot.CanCollide = false
	__InspectPivot.CanQuery = false
	__InspectPivot.CanTouch = false
	__InspectPivot.CastShadow = false

	local inspectOffset = parent:GetAttribute("InspectOffset")
	local n1 = v255 * (inspectOffset or CFrame.identity)

	if not boundingBox and inspectOffset == nil then
		local v262 = nil
		local v263 = p26 == "Revolver" and parent:FindFirstChild("RevolverRoot")

		if v263 and v263:IsA("BasePart") then
			v262 = v263
		end

		v263 = if v262 and parent:GetAttribute("InspectCFrame") == nil then v262.CFrame.Rotation else v255.Rotation
		v262 = visibleCenter(parent, v263)

		if v262 then
			n1 = CFrame.new(v262) * v263
		end
	else
		local rotation = v255.Rotation
		local v265 = p26 == "Knife" and boundingBox and inspectOffset == nil and visibleCenter(parent, rotation)

		if v265 then
			n1 = CFrame.new(v265) * rotation
		end
	end

	__InspectPivot.CFrame = n1
	__InspectPivot.Parent = parent
	parent.PrimaryPart = __InspectPivot
end
local function bindGamepad()
	contextActionService:BindAction("InspectRotateGamepad", function(_, p28, input)
		if not u65 then
			return Enum.ContextActionResult.Pass
		end

		if input.UserInputType ~= Enum.UserInputType.Gamepad1 then
			return Enum.ContextActionResult.Pass
		end

		if input.KeyCode ~= Enum.KeyCode.Thumbstick2 then
			return Enum.ContextActionResult.Pass
		end

		if p28 == Enum.UserInputState.Cancel then
			u87 = Vector2.zero

			return Enum.ContextActionResult.Sink
		end

		local inputPosition = input.Position
		local vector2 = Vector2.new(inputPosition.X, inputPosition.Y)

		u87 = if vector2.Magnitude < 0.2 then Vector2.zero else vector2

		return Enum.ContextActionResult.Sink
	end, false, Enum.KeyCode.Thumbstick2)
	contextActionService:BindAction("InspectZoomGamepad", function(_, p31, input)
		if not u65 then
			return Enum.ContextActionResult.Pass
		end

		if input.UserInputType ~= Enum.UserInputType.Gamepad1 then
			return Enum.ContextActionResult.Pass
		end

		local keyCode = input.KeyCode

		if keyCode == Enum.KeyCode.ButtonR2 then
			if p31 == Enum.UserInputState.Begin then
				n6 = 1
			end

			if (p31 == Enum.UserInputState.End or p31 == Enum.UserInputState.Cancel) and n6 == 1 then
				n6 = 0
			end

			return Enum.ContextActionResult.Sink
		end

		if keyCode == Enum.KeyCode.ButtonL2 then
			if p31 == Enum.UserInputState.Begin then
				n6 = -1
			end

			if (p31 == Enum.UserInputState.End or p31 == Enum.UserInputState.Cancel) and n6 == -1 then
				n6 = 0
			end

			return Enum.ContextActionResult.Sink
		end

		if keyCode == Enum.KeyCode.DPadUp and p31 == Enum.UserInputState.Begin then
			local n1 = n3 - n5 * -1
			local n2: number = n5 * 1.5
			local n7: number = n5 * 6

			n3 = if n1 < n2 then n2 else if n1 > n7 then n7 else n1

			return Enum.ContextActionResult.Sink
		end

		if keyCode == Enum.KeyCode.DPadDown and p31 == Enum.UserInputState.Begin then
			local n4 = n3 - n5 * 1
			local n8: number = n5 * 1.5
			local n9: number = n5 * 6

			n3 = if n4 < n8 then n8 else if n4 > n9 then n9 else n4

			return Enum.ContextActionResult.Sink
		end

		return Enum.ContextActionResult.Pass
	end, false, Enum.KeyCode.ButtonR2, Enum.KeyCode.ButtonL2, Enum.KeyCode.DPadUp, Enum.KeyCode.DPadDown)
end
local function unbindGamepad()
	contextActionService:UnbindAction("InspectRotateGamepad")
	contextActionService:UnbindAction("InspectZoomGamepad")
	u87 = Vector2.zero
	n6 = 0
end
local function startInput()
	if connection4 then
		connection4:Disconnect()
		connection4 = nil
	end

	if connection then
		connection:Disconnect()
		connection = nil
	end

	if connection2 then
		connection2:Disconnect()
		connection2 = nil
	end

	if connection3 then
		connection3:Disconnect()
		connection3 = nil
	end

	u75 = false
	u76 = nil
	vector2Zero = Vector2.zero
	u89 = nil
	u90 = nil
	u91 = nil
	connection = userInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
		if not u65 then
		elseif gameProcessedEvent then
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			u75 = true
			u76 = userInputService:GetMouseLocation()
			vector2Zero = Vector2.zero
		elseif input.UserInputType ~= Enum.UserInputType.Touch then
		elseif not u89 then
			u89 = input
			u75 = true
			u76 = input.Position
			vector2Zero = Vector2.zero
		elseif not u90 then
			u90 = input
			u91 = (u89.Position - u90.Position).Magnitude
		end
	end)
	connection2 = userInputService.InputChanged:Connect(function(input: InputObject, gameProcessedEvent: boolean)
		if gameProcessedEvent then
		elseif not u65 then
		elseif input.UserInputType == Enum.UserInputType.MouseWheel then
			local z = input.Position.Z

			if z ~= 0 then
				local n1 = n3 - z * 0.6 * n5
				local n9: number = n5 * 1.5
				local n10: number = n5 * 6

				n3 = if n1 < n9 then n9 else if n1 > n10 then n10 else n1
			end
		elseif input.UserInputType == Enum.UserInputType.Touch and u89 and u90 then
			local magnitude = (u89.Position - u90.Position).Magnitude
			local v378 = u91

			u91 = magnitude

			if v378 then
				local n4 = n3 - (magnitude - v378) * 0.012 * n5
				local n11: number = n5 * 1.5
				local n6: number = n5 * 6

				n3 = if n4 < n11 then n11 else if n4 > n6 then n6 else n4
			end
		elseif not u75 then
		elseif input.UserInputType == Enum.UserInputType.MouseMovement then
			local v382: Vector2 = userInputService:GetMouseLocation()
			local v383 = u76

			u76 = v382

			if v383 then
				local n7 = v382 - v383
				local y = n7.Y

				if u62 then
					local rightVector = CurrentCamera.CFrame.RightVector
					local v387 = CFrame.fromAxisAngle(CurrentCamera.CFrame.UpVector, -n7.X * 0.01)
					local v388 = CFrame.fromAxisAngle(rightVector, -y * 0.01)

					cFrameIdentity = v387 * v388 * cFrameIdentity

					if u62 then
						u62:PivotTo(itemPart.CFrame * cFrameIdentity)
					end
				end

				local v389 = math.max(n2, 0.004166666666666667)

				vector2Zero = n7 / v389

				return
			end
		elseif input.UserInputType == Enum.UserInputType.Touch and u89 and input == u89 and not u90 then
			local inputPosition: Vector3 = input.Position
			local v391 = u76

			u76 = inputPosition

			if v391 then
				local n8 = inputPosition - v391
				local v393 = n8.Y

				if u62 then
					local v394 = CurrentCamera.CFrame.RightVector
					local v395 = CFrame.fromAxisAngle(CurrentCamera.CFrame.UpVector, -n8.X * 0.012)
					local v396 = CFrame.fromAxisAngle(v394, -v393 * 0.012)

					cFrameIdentity = v395 * v396 * cFrameIdentity

					if u62 then
						u62:PivotTo(itemPart.CFrame * cFrameIdentity)
					end
				end

				local v397 = math.max(n2, 0.004166666666666667)

				vector2Zero = n8 / v397
			end
		end
	end)
	connection3 = userInputService.InputEnded:Connect(function(input: InputObject, gameProcessedEvent: boolean)
		if gameProcessedEvent then
		elseif not u65 then
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			u75 = false
			u76 = nil
		elseif input.UserInputType ~= Enum.UserInputType.Touch then
		elseif input == u89 then
			u89 = u90
			u90 = nil
			u91 = nil

			if u89 then
				u75 = true
				u76 = u89.Position

				return
			end

			u75 = false
			u76 = nil
		elseif input == u90 then
			u90 = nil
			u91 = nil
		end
	end)
	bindGamepad()
	connection4 = runService.RenderStepped:Connect(function(deltaTime: number)
		if not u65 then
			return
		end

		if u66 then
			return
		end

		local v401 = math.clamp(deltaTime * 9, 0, 1)

		n4 += (n3 - n4) * v401
		CurrentCamera.CameraType = Enum.CameraType.Scriptable

		local itemPartCFrame = itemPart.CFrame
		local cFrame = CFrame.new(0, 0, -n4)

		CurrentCamera.CFrame = CFrame.lookAt((itemPartCFrame * cFrame).Position, itemPartCFrame.Position)
		game.Lighting.EnvironmentSpecularScale = 1

		if u87.Magnitude > 0 then
			local n1 = -u87.Y * 120 * deltaTime

			if u62 then
				local rightVector = CurrentCamera.CFrame.RightVector
				local v406 = CFrame.fromAxisAngle(CurrentCamera.CFrame.UpVector, -(u87.X * 120 * deltaTime) * 0.01)
				local v407 = CFrame.fromAxisAngle(rightVector, -n1 * 0.01)

				cFrameIdentity = v406 * v407 * cFrameIdentity

				if u62 then
					u62:PivotTo(itemPart.CFrame * cFrameIdentity)
				end
			end
		else
			local v408 = math.exp(-9 * deltaTime)

			vector2Zero *= v408

			if not u75 and vector2Zero.Magnitude > 0.1 then
				local n7 = vector2Zero.Y * deltaTime

				if u62 then
					local v410 = CurrentCamera.CFrame.RightVector
					local v411 = CFrame.fromAxisAngle(CurrentCamera.CFrame.UpVector, -(vector2Zero.X * deltaTime) * 0.01)
					local v412 = CFrame.fromAxisAngle(v410, -n7 * 0.01)

					cFrameIdentity = v411 * v412 * cFrameIdentity

					if u62 then
						u62:PivotTo(itemPart.CFrame * cFrameIdentity)
					end
				end
			end
		end

		if n6 ~= 0 then
			local n8 = n3 - n6 * 6.5 * deltaTime * n5
			local n9: number = n5 * 1.5
			local n10: number = n5 * 6

			n3 = if n8 < n9 then n9 else if n8 > n10 then n10 else n8
		end

		n2 = deltaTime
	end)
end
local function stopInput()
	if connection4 then
		connection4:Disconnect()
		connection4 = nil
	end

	if connection then
		connection:Disconnect()
		connection = nil
	end

	if connection2 then
		connection2:Disconnect()
		connection2 = nil
	end

	if connection3 then
		connection3:Disconnect()
		connection3 = nil
	end

	contextActionService:UnbindAction("InspectRotateGamepad")
	contextActionService:UnbindAction("InspectZoomGamepad")
	u87 = Vector2.zero
	n6 = 0
	u75 = false
	u76 = nil
	vector2Zero = Vector2.zero
	u89 = nil
	u90 = nil
	u91 = nil
end

local t3 = {}

local function setDefaultCameraZoom(p40)
	LocalPlayer.CameraMinZoomDistance = p40
	LocalPlayer.CameraMaxZoomDistance = p40
	task.delay(0.1, function()
		LocalPlayer.CameraMinZoomDistance = game.StarterPlayer.CameraMinZoomDistance
		LocalPlayer.CameraMaxZoomDistance = game.StarterPlayer.CameraMaxZoomDistance
	end)
end

local u117 = nil
local u118: boolean = false

local function exitFinisherMode()
	if not u66 then
		return
	end

	finisherPreview.stop()

	if u118 then
		u118 = false

		if u117 then
			local v267 = u117

			LocalPlayer.CameraMinZoomDistance = v267
			LocalPlayer.CameraMaxZoomDistance = v267
			task.delay(0.1, function()
				LocalPlayer.CameraMinZoomDistance = game.StarterPlayer.CameraMinZoomDistance
				LocalPlayer.CameraMaxZoomDistance = game.StarterPlayer.CameraMaxZoomDistance
			end)
		end
	end

	pcall(function()
		local shared: Instance = replicatedStorage:WaitForChild("Shared")

		require(shared:WaitForChild("EmotePreview")).StopStage()
	end)
	u66 = false
	playerState.FinisherPreviewActive = false
	LocalPlayer.ReplicationFocus = nil
end

local u120: boolean = false

local function setWieldedMobileControls(p41)
	if not userInputService.TouchEnabled then
		return
	end

	if p41 then
		if LocalPlayer:GetAttribute("InMatch") == true then
			return
		end

		local v269 = u61

		if not v269 then
			return
		end

		mobileTouchController:init()

		local t4: {[any]: any} = {
			hasADS = if v269.Kind == "Revolver" then true else false,
			onFire = function()
				wieldedPreview.PrimaryDown()
			end,
			onFireRelease = function()
				wieldedPreview.PrimaryUp()
			end,
			onADSEnter = function()
				wieldedPreview.SecondaryDown()

				return wieldedPreview.IsAiming()
			end,
			onADSExit = function()
				wieldedPreview.SecondaryUp()
			end,
			onInspect = function()
				wieldedPreview.Inspect()
			end
		}

		mobileTouchController:equipWeapon(t4)
		mobileTouchController:setWeaponButtonsOverride(true)
		u120 = true

		return
	end

	if not u120 then
		return
	end

	u120 = false
	mobileTouchController:setWeaponButtonsOverride(false)
	mobileTouchController:unequipWeapon()
end
local function loadItem(p42)
	exitFinisherMode()
	wieldedPreview.Stop()

	if userInputService.TouchEnabled and u120 then
		u120 = false
		mobileTouchController:setWeaponButtonsOverride(false)
		mobileTouchController:unequipWeapon()
	end

	LocalPlayer:SetAttribute("WieldedPreviewActive", nil)
	u61 = p42

	local u272: boolean = true

	if p42.Kind ~= "Knife" then
		u272 = p42.Kind == "Revolver"
	end

	parent.Visible = u272

	if not u272 and s1 ~= "Inspect" then
		s1 = "Inspect"
		updateModeSelection()
	end

	local inspectDOF: Instance = lighting:FindFirstChild("InspectDOF")

	if inspectDOF then
		inspectDOF:Destroy()
	end

	if p42.Kind ~= "Finisher" and s1 ~= "Wielded" then
		local inspectDOF: DepthOfFieldEffect = Instance.new("DepthOfFieldEffect")

		inspectDOF.Name = "InspectDOF"
		inspectDOF.FarIntensity = 0.75
		inspectDOF.FocusDistance = 8
		inspectDOF.InFocusRadius = 2
		inspectDOF.NearIntensity = 0
		inspectDOF.Parent = lighting
	end

	traitText.Bind(v31, p42.Name or p42.ItemId)
	setRarityTag(p42.Rarity or "Common")

	local globalCopies = p42.GlobalCopies

	if typeof(globalCopies) == "number" then
		v33.Text = tostring(globalCopies):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") .. " exist"
	else
		v33.Text = ""
	end

	u93()

	if u62 then
		u62:Destroy()
		u62 = nil
	end

	if p42.Kind == "Emote" then
		if connection4 then
			connection4:Disconnect()
			connection4 = nil
		end

		if connection then
			connection:Disconnect()
			connection = nil
		end

		if connection2 then
			connection2:Disconnect()
			connection2 = nil
		end

		if connection3 then
			connection3:Disconnect()
			connection3 = nil
		end

		contextActionService:UnbindAction("InspectRotateGamepad")
		contextActionService:UnbindAction("InspectZoomGamepad")
		u87 = Vector2.zero
		n6 = 0
		u75 = false
		u76 = nil
		vector2Zero = Vector2.zero
		u89 = nil
		u90 = nil
		u91 = nil
		u66 = true
		u65 = true
		playerState.FinisherPreviewActive = true

		local v276 = finisherPreview.getCameraSubject()
		local CurrentCamera2: Camera = workspace.CurrentCamera
		local v278 = v276.CFrame

		CurrentCamera2.CFrame = CFrame.lookAt(v278.Position - v278.LookVector * 9 + Vector3.new(0, 2.5, 0), v278.Position + Vector3.new(0, 1.5, 0))
		CurrentCamera2.CameraSubject = v276
		CurrentCamera2.CameraType = Enum.CameraType.Custom
		LocalPlayer.CameraMinZoomDistance = 9
		LocalPlayer.CameraMaxZoomDistance = 9
		task.delay(0.1, function()
			LocalPlayer.CameraMinZoomDistance = game.StarterPlayer.CameraMinZoomDistance
			LocalPlayer.CameraMaxZoomDistance = game.StarterPlayer.CameraMaxZoomDistance
		end)
		u118 = true
		LocalPlayer.ReplicationFocus = v276

		local shared: Instance = replicatedStorage:WaitForChild("Shared")
		local emotePreview = require(shared:WaitForChild("EmotePreview"))
		local cFrame = CFrame.new(v278.Position, v278.Position - v278.LookVector)

		emotePreview.StartStage(cFrame, p42.ItemId, workspace:FindFirstChild("Bin"))

		return
	end

	if p42.Kind == "Finisher" then
		if connection4 then
			connection4:Disconnect()
			connection4 = nil
		end

		if connection then
			connection:Disconnect()
			connection = nil
		end

		if connection2 then
			connection2:Disconnect()
			connection2 = nil
		end

		if connection3 then
			connection3:Disconnect()
			connection3 = nil
		end

		contextActionService:UnbindAction("InspectRotateGamepad")
		contextActionService:UnbindAction("InspectZoomGamepad")
		u87 = Vector2.zero
		n6 = 0
		u75 = false
		u76 = nil
		vector2Zero = Vector2.zero
		u89 = nil
		u90 = nil
		u91 = nil
		u66 = true
		u65 = true
		playerState.FinisherPreviewActive = true

		local CurrentCamera3: Camera = workspace.CurrentCamera
		local v283 = finisherPreview.getCameraSubject()
		local v284 = v283.CFrame

		CurrentCamera3.CFrame = CFrame.lookAt(v284.Position - v284.LookVector * 16 + Vector3.new(0, 3, 0), v284.Position + Vector3.new(0, 1, 0))
		CurrentCamera3.CameraSubject = v283
		CurrentCamera3.CameraType = Enum.CameraType.Custom
		LocalPlayer.ReplicationFocus = v283
		finisherPreview.start(p42.ItemId)

		return
	end

	u66 = false

	if s1 == "Wielded" then
		if connection4 then
			connection4:Disconnect()
			connection4 = nil
		end

		if connection then
			connection:Disconnect()
			connection = nil
		end

		if connection2 then
			connection2:Disconnect()
			connection2 = nil
		end

		if connection3 then
			connection3:Disconnect()
			connection3 = nil
		end

		contextActionService:UnbindAction("InspectRotateGamepad")
		contextActionService:UnbindAction("InspectZoomGamepad")
		u87 = Vector2.zero
		n6 = 0
		u75 = false
		u76 = nil
		vector2Zero = Vector2.zero
		u89 = nil
		u90 = nil
		u91 = nil

		if CFrame2 == nil then
			CFrame2 = CurrentCamera.CFrame
		end

		CurrentCamera.CameraType = Enum.CameraType.Scriptable

		local itemPartCFrame = itemPart.CFrame

		CurrentCamera.CFrame = CFrame.lookAt((itemPartCFrame * CFrame.new(0, 0, -3)).Position, itemPartCFrame.Position)
		game.Lighting.EnvironmentSpecularScale = 1

		if wieldedPreview.Start(p42.Kind, p42.ItemId, workspace.Bin) then
			u65 = true
			userInputService.ModalEnabled = true
			setWieldedMobileControls(true)
			LocalPlayer:SetAttribute("WieldedPreviewActive", true)

			return
		end

		warn("[InspectHUD] No wielded rig for", p42.Kind, p42.ItemId)
		s1 = "Inspect"
		updateModeSelection()
	end

	local v286

	if p42.Kind == "Knife" then
		v286 = replicatedStorage:WaitForChild("Knives")
	else
		if p42.Kind ~= "Revolver" then
			warn("[InspectHUD] Unknown kind:", p42.Kind)

			return
		end

		v286 = replicatedStorage:WaitForChild("Revolvers")
	end

	local foundChild = v286:FindFirstChild(p42.ItemId)

	if not foundChild or not foundChild:IsA("Model") then
		warn("[InspectHUD] Missing model:", p42.Kind, p42.ItemId)

		return
	end

	local clone = foundChild:Clone()

	clone.Name = "__InspectItem"

	local text: string = tostring(p42.Kind)
	local text2: string = tostring(p42.ItemId)

	u67 = text .. ":" .. text2

	for _, v in ipairs(clone:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Anchored = true
			v.CanCollide = false
			v.CanQuery = false
			v.CanTouch = false
		end
	end

	ensureCenteredPrimaryPart(clone, p42.Kind)
	clone.Parent = inspectRoom
	u62 = clone
	animateSkins:Fire(clone)
	u93()
	startRigAnim(clone, p42.Kind, p42.ItemId)
	cFrameIdentity = CFrame.identity
	n3 = 3

	local v293 = inspectPoseFor(clone)

	if p42.Kind == "Knife" then
		if not v293 then
			cFrameIdentity = CFrame.new(0, 0, 0, 0.418805301, 0.808831573, -0.412794948, -0.0898146853, 0.489247978, 0.867512345, 0.903628111, -0.326236814, 0.277544826)
		end

		n3 = 3
	elseif p42.Kind == "Revolver" then
		if not v293 then
			cFrameIdentity = CFrame.new(0, 0, 0, 0.111458465, -0.447068274, -0.887529552, 0.119116351, 0.892664433, -0.434698373, 0.986603498, -0.0572628938, 0.15274927)
		end

		n3 = 2.25
	end

	if v293 then
		cFrameIdentity = itemPart.CFrame.Rotation:Inverse() * v293
	end

	local n1 = math.rad(CurrentCamera.FieldOfView) * 0.5

	v293 = if n1 <= 0 then 3 else visibleRadius(clone) / math.tan(n1) * 1.15

	if v293 > n3 then
		n5 = v293 / n3
		n3 = v293
	else
		n5 = 1
	end

	n4 = n3

	if u62 then
		u62:PivotTo(itemPart.CFrame * cFrameIdentity)
	end

	u65 = true

	if CFrame2 == nil then
		CFrame2 = CurrentCamera.CFrame
	end

	CurrentCamera.CameraType = Enum.CameraType.Scriptable

	local v295 = itemPart.CFrame
	local cFrame = CFrame.new(0, 0, -n4)

	CurrentCamera.CFrame = CFrame.lookAt((v295 * cFrame).Position, v295.Position)
	game.Lighting.EnvironmentSpecularScale = 1
	startInput()
	userInputService.ModalEnabled = true
end
local function setViewMode(p43)
	if p43 == s1 then
		return
	end

	local v298 = u61

	if not v298 then
	elseif v298.Kind == "Knife" or v298.Kind == "Revolver" then
		s1 = p43
		updateModeSelection()
		loadItem(v298)

		return
	end
end

for i, v in ipairs({
	{ mode = "Inspect", label = "INSPECT" },
	{ mode = "Wielded", label = "WIELDED" }
}) do
	local clone = template:Clone()

	clone.Name = v.mode
	clone.LayoutOrder = i
	clone.Visible = true
	clone.Size = UDim2.fromScale(1, 0.44)
	clone.Selectable = true
	applyTileContent(clone, v.label, nil)

	local vMode = v.mode

	clone.Activated:Connect(function()
		local v299 = vMode

		if v299 == s1 then
			return
		end

		local v300 = u61

		if not v300 then
		elseif v300.Kind == "Knife" or v300.Kind == "Revolver" then
			s1 = v299
			updateModeSelection()
			loadItem(v300)

			return
		end
	end)
	clone.Parent = parent
	t1[v.mode] = clone
end

updateModeSelection()

local function updateStripSelection()
	for i, v in ipairs(t2) do
		local u303: boolean = i == n1
		local darkenDeselectedCover = v:FindFirstChild("DarkenDeselectedCover")

		if darkenDeselectedCover and darkenDeselectedCover:IsA("GuiObject") then
			darkenDeselectedCover.Visible = not u303
		end
	end
end
local function showIndex(p44: number)
	local v306 = u58

	if v306 and #v306 ~= 0 then
		if p44 < 1 then
			p44 = #v306
		elseif p44 > #v306 then
			p44 = 1
		end

		n1 = p44
		updateStripSelection()
		loadItem(v306[p44])

		return
	end
end
local function clearStrip()
	for _, v in ipairs(t2) do
		v:Destroy()
	end

	t2 = {}
	v34.Visible = false
	v33.Position = v42
end
local function buildStrip(p45)
	clearStrip()

	if #p45 < 2 then
		return
	end

	for i, v in ipairs(p45) do
		local clone2 = (if if v.Style == nil then v.Kind == "Finisher" else v.Style == "Accent" then templateAccent else template):Clone()

		clone2.Name = "Item" .. i
		clone2.LayoutOrder = i
		clone2.Visible = true
		clone2.Selectable = true

		local v313 = v.Label or string.upper(v.Kind)

		applyTileContent(clone2, v313, v.Icon)
		clone2.Activated:Connect(function()
			local v417 = i
			local v418 = i ~= n1 and u58

			if not v418 then
				return
			end

			if #v418 == 0 then
				return
			end

			if v417 < 1 then
				v417 = #v418
			elseif v417 > #v418 then
				v417 = 1
			end

			n1 = v417
			updateStripSelection()
			loadItem(v418[v417])
		end)
		clone2.Parent = v34
		table.insert(t2, clone2)
	end

	v34.Visible = true
	v33.Position = uDim2
	updateStripSelection()
end

local ok, result = pcall(function()
	return require(replicatedStorage:WaitForChild("Icon", 10))
end)

local v134 = if ok then result else nil
local u135 = nil
local u136: boolean = false

local function setTopbarHighlightSuppressed(p46)
	if v134 == nil then
		return
	end

	if p46 == u136 then
		return
	end

	if not p46 then
		u136 = false
		v134.highlightKey = u135
		u135 = nil

		return
	end

	if v134.highlightKey == nil then
		return
	end

	u136 = true
	u135 = v134.highlightKey
	v134.highlightKey = false
end

local u138: boolean = false

local function bindGamepadPaging()
	if u138 then
		return
	end

	u138 = true
	contextActionService:BindAction("InspectPageGamepad", function(_, p48, input)
		if not u65 or not u58 then
			return Enum.ContextActionResult.Pass
		end

		if p48 == Enum.UserInputState.Begin then
			if input.KeyCode == Enum.KeyCode.ButtonR1 then
				local n3 = n1 + 1
				local v423 = u58

				if v423 and #v423 ~= 0 then
					if n3 < 1 then
						n3 = #v423
					elseif n3 > #v423 then
						n3 = 1
					end

					n1 = n3
					updateStripSelection()
					loadItem(v423[n3])
				end
			else
				local n2 = n1 - 1
				local v425 = input.KeyCode == Enum.KeyCode.ButtonL1 and u58

				if v425 and #v425 ~= 0 then
					if n2 < 1 then
						n2 = #v425
					elseif n2 > #v425 then
						n2 = 1
					end

					n1 = n2
					updateStripSelection()
					loadItem(v425[n2])
				end
			end

			local selectedObject = t2[n1]
			local guiServiceSelectedObject: GuiObject = guiService.SelectedObject

			if selectedObject and guiServiceSelectedObject and guiServiceSelectedObject:IsDescendantOf(v34) then
				u69 = selectedObject
				guiService.SelectedObject = selectedObject
			end
		end

		return Enum.ContextActionResult.Sink
	end, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
end
local function unbindGamepadPaging()
	if not u138 then
		return
	end

	u138 = false
	contextActionService:UnbindAction("InspectPageGamepad")
end
local function openInspect(p50)
	if not v28.Enabled then
		u117 = if CurrentCamera.CameraType == Enum.CameraType.Custom then (CurrentCamera.CFrame.Position - CurrentCamera.Focus.Position).Magnitude else nil
	end

	v28.Enabled = true
	v29.Enabled = false
	t3 = windowBlur.saveAndClear()

	if v134 ~= nil and u136 ~= true and v134.highlightKey ~= nil then
		u136 = true
		u135 = v134.highlightKey
		v134.highlightKey = false
	end

	if not u138 then
		u138 = true
		contextActionService:BindAction("InspectPageGamepad", function(_, p52, input)
			if not u65 or not u58 then
				return Enum.ContextActionResult.Pass
			end

			if p52 == Enum.UserInputState.Begin then
				if input.KeyCode == Enum.KeyCode.ButtonR1 then
					local n3 = n1 + 1
					local v432 = u58

					if v432 and #v432 ~= 0 then
						if n3 < 1 then
							n3 = #v432
						elseif n3 > #v432 then
							n3 = 1
						end

						n1 = n3
						updateStripSelection()
						loadItem(v432[n3])
					end
				else
					local n2 = n1 - 1
					local v434 = input.KeyCode == Enum.KeyCode.ButtonL1 and u58

					if v434 and #v434 ~= 0 then
						if n2 < 1 then
							n2 = #v434
						elseif n2 > #v434 then
							n2 = 1
						end

						n1 = n2
						updateStripSelection()
						loadItem(v434[n2])
					end
				end

				local selectedObject = t2[n1]
				local guiServiceSelectedObject: GuiObject = guiService.SelectedObject

				if selectedObject and guiServiceSelectedObject and guiServiceSelectedObject:IsDescendantOf(v34) then
					u69 = selectedObject
					guiService.SelectedObject = selectedObject
				end
			end

			return Enum.ContextActionResult.Sink
		end, false, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
	end

	local items = p50.Items

	if typeof(items) == "table" and #items > 0 then
		u58 = items
		n1 = math.clamp(p50.Index or 1, 1, #items)
		buildStrip(items)
		loadItem(items[n1])
	else
		u58 = nil
		n1 = 1
		clearStrip()
		loadItem(p50)
	end

	if inputCategorizer.getLastInputCategory() ~= inputCategorizer.InputCategory.Gamepad then
		return
	end

	local selectedObject = preferredSelection()

	if not selectedObject then
		return
	end

	u69 = selectedObject
	guiService.SelectedObject = selectedObject
end
local function closeInspect(p54)
	if not v28.Enabled then
		return
	end

	if connection4 then
		connection4:Disconnect()
		connection4 = nil
	end

	if connection then
		connection:Disconnect()
		connection = nil
	end

	if connection2 then
		connection2:Disconnect()
		connection2 = nil
	end

	if connection3 then
		connection3:Disconnect()
		connection3 = nil
	end

	contextActionService:UnbindAction("InspectRotateGamepad")
	contextActionService:UnbindAction("InspectZoomGamepad")
	u87 = Vector2.zero
	n6 = 0
	u75 = false
	u76 = nil
	vector2Zero = Vector2.zero
	u89 = nil
	u90 = nil
	u91 = nil
	u65 = false
	u69 = nil

	local guiServiceSelectedObject: GuiObject = guiService.SelectedObject

	if guiServiceSelectedObject and guiServiceSelectedObject:IsDescendantOf(v28) then
		guiService.SelectedObject = nil
	end

	if u138 then
		u138 = false
		contextActionService:UnbindAction("InspectPageGamepad")
	end

	if v134 ~= nil and u136 ~= false then
		u136 = false
		v134.highlightKey = u135
		u135 = nil
	end

	clearStrip()
	u58 = nil
	n1 = 1
	u61 = nil
	wieldedPreview.Stop()

	if userInputService.TouchEnabled and u120 then
		u120 = false
		mobileTouchController:setWeaponButtonsOverride(false)
		mobileTouchController:unequipWeapon()
	end

	LocalPlayer:SetAttribute("WieldedPreviewActive", nil)
	parent.Visible = false
	s1 = "Inspect"
	updateModeSelection()
	LocalPlayer.ReplicationFocus = nil

	local inspectDOF: Instance = lighting:FindFirstChild("InspectDOF")

	if inspectDOF then
		inspectDOF:Destroy()
	end

	if next(t3) then
		windowBlur.restore(t3)
		t3 = {}
	end

	if u66 then
		exitFinisherMode()

		if not p54 then
			local LocalPlayer2: Player = game:GetService("Players").LocalPlayer

			if LocalPlayer2 and LocalPlayer2.Character then
				local CurrentCamera4: Camera = workspace.CurrentCamera

				CurrentCamera4.CameraType = Enum.CameraType.Custom
				CurrentCamera4.CameraSubject = LocalPlayer2.Character:FindFirstChildOfClass("Humanoid")
			end
		end
	end

	u93()

	if u62 then
		u62:Destroy()
		u62 = nil
	end

	v28.Enabled = false
	userInputService.ModalEnabled = false

	if p54 then
		CFrame2 = nil
		lighting.EnvironmentSpecularScale = 0.1

		return
	end

	v29.Enabled = true

	if CFrame2 then
		CurrentCamera.CFrame = CFrame2
		CFrame2 = nil
	end

	CurrentCamera.CameraType = Enum.CameraType.Custom

	local Character: Model = LocalPlayer.Character
	local humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		CurrentCamera.CameraSubject = humanoid
	end

	game.Lighting.EnvironmentSpecularScale = 0.1
end

v30.Activated:Connect(function()
	closeInspect()
end)

local keybind = v30:FindFirstChild("Keybind")

if keybind then
	uiFramework.applyGamepadKeybind(keybind, gamepadBindings.Menu)
	uiFramework.bindKeybindLabel(keybind, "Menu")
end

local v144: Instance = replicatedStorage:WaitForChild("Shared")

if require(v144:WaitForChild("Universe")).IsDev() then
	userInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
		if gameProcessedEvent or not u65 or u66 then
			return
		end

		if input.KeyCode ~= Enum.KeyCode.P then
			return
		end

		local v327 = u62

		if not v327 then
			return
		end

		local v328, v329, v330 = v327:GetPivot():ToOrientation()
		local v331 = u67 or v327.Name
		local v332 = math.deg(v328)
		local v333 = math.deg(v329)
		local v334 = math.deg(v330)

		print(("[InspectHUD] %s pose -> set InspectCFrame (Vector3, degrees) to  %.3f, %.3f, %.3f"):format(v331, v332, v333, v334))
	end)
end

userInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	if gameProcessedEvent then
	elseif u65 and s1 == "Wielded" then
		if inputMap.matches("Attack", input) then
			wieldedPreview.PrimaryDown()

			return
		end

		if inputMap.matches("Aim", input) then
			wieldedPreview.SecondaryDown()

			return
		end

		if inputMap.matches("Inspect", input) then
			wieldedPreview.Inspect()
		end

		return
	end
end)
userInputService.InputEnded:Connect(function(input: InputObject)
	if inputMap.matches("Attack", input) then
		wieldedPreview.PrimaryUp()

		return
	end

	if inputMap.matches("Aim", input) then
		wieldedPreview.SecondaryUp()
	end
end)
userInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	if gameProcessedEvent then
		return
	end

	if not u65 then
		return
	end

	if inputMap.matches("Menu", input) then
		closeInspect()
	end
end)
userInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	if gameProcessedEvent then
		return
	end

	if not u65 or not u58 then
		return
	end

	local keyCode: Enum.KeyCode = input.KeyCode

	if keyCode == Enum.KeyCode.E or keyCode == Enum.KeyCode.Right then
		local n3 = n1 + 1
		local v344 = u58

		if v344 then
			if #v344 == 0 then
				return
			end

			if n3 < 1 then
				n3 = #v344
			elseif n3 > #v344 then
				n3 = 1
			end

			n1 = n3
			updateStripSelection()
			loadItem(v344[n3])

			return
		end
	else
		local n2 = n1 - 1
		local v346 = (keyCode == Enum.KeyCode.Q or keyCode == Enum.KeyCode.Left) and u58

		if v346 then
			if #v346 == 0 then
				return
			end

			if n2 < 1 then
				n2 = #v346
			elseif n2 > #v346 then
				n2 = 1
			end

			n1 = n2
			updateStripSelection()
			loadItem(v346[n2])
		end
	end
end)
inspectItem.Event:Connect(function(p64)
	if typeof(p64) == "table" then
		if typeof(p64.Items) == "table" then
			local items: {[any]: any} = {}

			for _, v in ipairs(p64.Items) do
				if typeof(v) == "table" and typeof(v.Kind) == "string" and typeof(v.ItemId) == "string" then
					table.insert(items, v)
				end
			end

			if #items == 0 then
				return
			end

			p64.Items = items
			openInspect(p64)
		elseif typeof(p64.Kind) == "string" then
			if typeof(p64.ItemId) == "string" then
				openInspect(p64)

				return
			end

			return
		end

		return
	end
end)
replicatedStorage:WaitForChild("MatchRemotes"):WaitForChild("State").OnClientEvent:Connect(function(_, p66)
	if typeof(p66) == "table" then
		if p66.t == "MapVoteStart" and u65 then
			closeInspect(true)
		end

		return
	end
end)
