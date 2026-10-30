-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
game:GetService("Players")

local guiService: GuiService = game:GetService("GuiService")
local userInputService: UserInputService = game:GetService("UserInputService")

UserSettings():GetService("UserGameSettings")

local commonUtils: Instance = script.Parent.Parent:WaitForChild("CommonUtils")
local v4 = require(commonUtils:WaitForChild("FlagUtil")).getUserFlag("UserPlayerScriptsCanUseLCC")
local avatarAbilitiesInterface = nil

if v4 then
	avatarAbilitiesInterface = require(script.Parent:WaitForChild("AvatarAbilitiesInterface"))
end

local baseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"))
local object = setmetatable({}, baseCharacterController)

object.__index = object

function object.new()
	local v8 = baseCharacterController.new()
	local object2 = setmetatable(v8, object)

	object2.isFollowStick = false
	object2.thumbstickFrame = nil
	object2.moveTouchObject = nil
	object2.onTouchMovedConn = nil
	object2.onTouchEndedConn = nil
	object2.screenPos = nil
	object2.stickImage = nil
	object2.thumbstickSize = nil

	return object2
end
function object.Enable(p1, p2, p3)
	if p2 == nil then
		return false
	end

	local u13: boolean = if p2 then true else false

	if p1.enabled == u13 then
		return true
	end

	p1.moveVector = Vector3.new(0, 0, 0)
	p1.isJumping = false

	if u13 then
		if not p1.thumbstickFrame then
			p1:Create(p3)
		end

		p1.thumbstickFrame.Visible = true
	else
		p1.thumbstickFrame.Visible = false
		p1:OnInputEnded()
	end

	p1.enabled = u13
end
function object.OnInputEnded(p4)
	p4.thumbstickFrame.Position = p4.screenPos
	p4.stickImage.Position = UDim2.new(0, p4.thumbstickFrame.Size.X.Offset / 2 - p4.thumbstickSize / 4, 0, p4.thumbstickFrame.Size.Y.Offset / 2 - p4.thumbstickSize / 4)
	p4.moveVector = Vector3.new(0, 0, 0)
	p4.isJumping = false
	p4.thumbstickFrame.Position = p4.screenPos
	p4.moveTouchObject = nil
end
function object.Create(p5, parent)
	if p5.thumbstickFrame then
		p5.thumbstickFrame:Destroy()
		p5.thumbstickFrame = nil

		if p5.onTouchMovedConn then
			p5.onTouchMovedConn:Disconnect()
			p5.onTouchMovedConn = nil
		end

		if p5.onTouchEndedConn then
			p5.onTouchEndedConn:Disconnect()
			p5.onTouchEndedConn = nil
		end

		if p5.absoluteSizeChangedConn then
			p5.absoluteSizeChangedConn:Disconnect()
			p5.absoluteSizeChangedConn = nil
		end

		if v4 and p5.avatarAbilitiesEnabledChangedConn then
			p5.avatarAbilitiesEnabledChangedConn:Disconnect()
			p5.avatarAbilitiesEnabledChangedConn = nil
		end
	end

	p5.thumbstickFrame = Instance.new("Frame")
	p5.thumbstickFrame.Name = "ThumbstickFrame"
	p5.thumbstickFrame.Active = true
	p5.thumbstickFrame.Visible = false
	p5.thumbstickFrame.BackgroundTransparency = 1

	local outerImage: ImageLabel = Instance.new("ImageLabel")

	outerImage.Name = "OuterImage"
	outerImage.Image = "rbxasset://textures/ui/TouchControlsSheet.png"
	outerImage.ImageRectOffset = Vector2.new()
	outerImage.ImageRectSize = Vector2.new(220, 220)
	outerImage.BackgroundTransparency = 1
	outerImage.Position = UDim2.new(0, 0, 0, 0)
	p5.stickImage = Instance.new("ImageLabel")
	p5.stickImage.Name = "StickImage"
	p5.stickImage.Image = "rbxasset://textures/ui/TouchControlsSheet.png"
	p5.stickImage.ImageRectOffset = Vector2.new(220, 0)
	p5.stickImage.ImageRectSize = Vector2.new(111, 111)
	p5.stickImage.BackgroundTransparency = 1
	p5.stickImage.ZIndex = 2

	local function ResizeThumbstick()
		local u21: boolean = math.min(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) <= 500

		if v4 and avatarAbilitiesInterface:isEnabled() then
			local n1: number = if u21 then 64 else 88

			p5.thumbstickSize = if u21 then 72 else 120
			p5.screenPos = UDim2.new(0, n1, 1, -p5.thumbstickSize - n1)
		else
			p5.thumbstickSize = if u21 then 70 else 120
			p5.screenPos = u21 and UDim2.new(0, p5.thumbstickSize / 2 - 10, 1, -p5.thumbstickSize - 20) or UDim2.new(0, p5.thumbstickSize / 2, 1, -p5.thumbstickSize * 1.75)
		end

		p5.thumbstickFrame.Size = UDim2.new(0, p5.thumbstickSize, 0, p5.thumbstickSize)
		p5.thumbstickFrame.Position = p5.screenPos
		outerImage.Size = UDim2.new(0, p5.thumbstickSize, 0, p5.thumbstickSize)
		p5.stickImage.Size = UDim2.new(0, p5.thumbstickSize / 2, 0, p5.thumbstickSize / 2)
		p5.stickImage.Position = UDim2.new(0, p5.thumbstickSize / 2 - p5.thumbstickSize / 4, 0, p5.thumbstickSize / 2 - p5.thumbstickSize / 4)
	end

	ResizeThumbstick()
	p5.absoluteSizeChangedConn = parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeThumbstick)

	if v4 then
		p5.avatarAbilitiesEnabledChangedConn = avatarAbilitiesInterface:GetEnabledChangedSignal():Connect(ResizeThumbstick)
	end

	outerImage.Parent = p5.thumbstickFrame
	p5.stickImage.Parent = p5.thumbstickFrame

	local vector2 = nil

	ResizeThumbstick = function(p7)
		local n1 = p7 / (p5.thumbstickSize / 2)
		local magnitude = n1.magnitude
		local vector3

		if magnitude < 0.05 then
			vector3 = Vector3.new()
		else
			local unit = n1.unit
			local v29 = math.min(1, (magnitude - 0.05) / 0.95)
			local n2 = unit * v29

			vector3 = Vector3.new(n2.X, 0, n2.Y)
		end

		p5.moveVector = vector3
	end

	local function MoveStick(p8)
		local vector3 = Vector2.new(p8.X - vector2.X, p8.Y - vector2.Y)
		local vector2Magnitude = vector3.magnitude
		local n1 = p5.thumbstickFrame.AbsoluteSize.X / 2

		if p5.isFollowStick and vector2Magnitude > n1 then
			local n2 = vector3.unit * n1

			p5.thumbstickFrame.Position = UDim2.new(0, p8.X - p5.thumbstickFrame.AbsoluteSize.X / 2 - n2.X, 0, p8.Y - p5.thumbstickFrame.AbsoluteSize.Y / 2 - n2.Y)
		else
			local v35 = math.min(vector2Magnitude, n1)

			vector3 = vector3.unit * v35
		end

		p5.stickImage.Position = UDim2.new(0, vector3.X + p5.stickImage.AbsoluteSize.X / 2, 0, vector3.Y + p5.stickImage.AbsoluteSize.Y / 2)
	end

	p5.thumbstickFrame.InputBegan:Connect(function(input)
		if not p5.moveTouchObject and input.UserInputType == Enum.UserInputType.Touch and input.UserInputState == Enum.UserInputState.Begin then
			p5.moveTouchObject = input
			p5.thumbstickFrame.Position = UDim2.new(0, input.Position.X - p5.thumbstickFrame.Size.X.Offset / 2, 0, input.Position.Y - p5.thumbstickFrame.Size.Y.Offset / 2)
			vector2 = Vector2.new(p5.thumbstickFrame.AbsolutePosition.X + p5.thumbstickFrame.AbsoluteSize.X / 2, p5.thumbstickFrame.AbsolutePosition.Y + p5.thumbstickFrame.AbsoluteSize.Y / 2)
			Vector2.new(input.Position.X - vector2.X, input.Position.Y - vector2.Y)

			return
		end
	end)
	p5.onTouchMovedConn = userInputService.TouchMoved:Connect(function(touch: InputObject, gameProcessedEvent: boolean)
		if touch == p5.moveTouchObject then
			vector2 = Vector2.new(p5.thumbstickFrame.AbsolutePosition.X + p5.thumbstickFrame.AbsoluteSize.X / 2, p5.thumbstickFrame.AbsolutePosition.Y + p5.thumbstickFrame.AbsoluteSize.Y / 2)

			local n1 = Vector2.new(touch.Position.X - vector2.X, touch.Position.Y - vector2.Y) / (p5.thumbstickSize / 2)
			local magnitude = n1.magnitude
			local vector3

			if magnitude < 0.05 then
				vector3 = Vector3.new()
			else
				local unit = n1.unit
				local v44 = math.min(1, (magnitude - 0.05) / 0.95)
				local n2 = unit * v44

				vector3 = Vector3.new(n2.X, 0, n2.Y)
			end

			p5.moveVector = vector3
			MoveStick(touch.Position)
		end
	end)
	p5.onTouchEndedConn = userInputService.TouchEnded:Connect(function(touch: InputObject, gameProcessedEvent: boolean)
		if touch == p5.moveTouchObject then
			p5:OnInputEnded()
		end
	end)
	guiService.MenuOpened:Connect(function()
		if p5.moveTouchObject then
			p5:OnInputEnded()
		end
	end)
	p5.thumbstickFrame.Parent = parent
end

return object
