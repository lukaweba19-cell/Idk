-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
game:GetService("Players")

local guiService: GuiService = game:GetService("GuiService")
local commonUtils: Instance = script.Parent.Parent:WaitForChild("CommonUtils")
local connectionUtil = require(commonUtils:WaitForChild("ConnectionUtil"))
local characterUtil = require(commonUtils:WaitForChild("CharacterUtil"))
local v5 = require(commonUtils:WaitForChild("FlagUtil")).getUserFlag("UserPlayerScriptsCanUseLCC")
local avatarAbilitiesInterface = nil

if v5 then
	avatarAbilitiesInterface = require(script.Parent:WaitForChild("AvatarAbilitiesInterface"))
end

local t1: {[any]: any} = {
	"rbxasset://textures/ui/Input/JumpButtonRegular.png",
	"rbxasset://textures/ui/Input/JumpButtonPressed.png"
}
local t2: {[any]: any} = {
	HUMANOID_STATE_ENABLED_CHANGED = "HUMANOID_STATE_ENABLED_CHANGED",
	HUMANOID_JUMP_POWER = "HUMANOID_JUMP_POWER",
	HUMANOID_JUMP_HEIGHT = "HUMANOID_JUMP_HEIGHT",
	HUMANOID = "HUMANOID",
	JUMP_INPUT_ENDED = "JUMP_INPUT_ENDED",
	MENU_OPENED = "MENU_OPENED"
}
local baseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"))
local object = setmetatable({}, baseCharacterController)

object.__index = object

function object.new()
	local v11 = baseCharacterController.new()
	local object2 = setmetatable(v11, object)

	object2.parentUIFrame = nil
	object2.jumpButton = nil
	object2.externallyEnabled = false
	object2.isJumping = false
	object2._active = false
	object2._connectionUtil = connectionUtil.new()

	return object2
end
function object._reset(p1)
	p1.isJumping = false
	p1.touchObject = nil

	if p1.jumpButton then
		if v5 and avatarAbilitiesInterface:isEnabled() then
			p1.jumpButton.Image = t1[1]

			return
		end

		p1.jumpButton.ImageRectOffset = Vector2.new(1, 146)

		return
	end
end
function object.EnableButton(p2, p3)
	if p3 == p2._active then
		return
	end

	if p3 then
		if not p2.jumpButton then
			p2:Create()
		end

		p2.jumpButton.Visible = true
		p2._connectionUtil:trackConnection("JUMP_INPUT_ENDED", p2.jumpButton.InputEnded:Connect(function(p4)
			if p4 == p2.touchObject then
				p2:_reset()
			end
		end))
		p2._connectionUtil:trackConnection("MENU_OPENED", guiService.MenuOpened:Connect(function()
			if p2.touchObject then
				p2:_reset()
			end
		end))
	else
		if p2.jumpButton then
			p2.jumpButton.Visible = false
		end

		p2._connectionUtil:disconnect("JUMP_INPUT_ENDED")
		p2._connectionUtil:disconnect("MENU_OPENED")
	end

	p2:_reset()
	p2._active = p3
end
function object.UpdateEnabled(p5)
	local v17 = characterUtil.getChild("Humanoid", "Humanoid")

	if v17 and p5.externallyEnabled and (v17.UseJumpPower and v17.JumpPower > 0 or not v17.UseJumpPower and v17.JumpHeight > 0) and v17:GetStateEnabled(Enum.HumanoidStateType.Jumping) then
		p5:EnableButton(true)

		return
	end

	p5:EnableButton(false)
end
function object._setupConfigurations(p6)
	local function update()
		p6:UpdateEnabled()
	end

	local v20 = characterUtil.onChild("Humanoid", "Humanoid", function(p7)
		p6:UpdateEnabled()
		p6:_reset()

		local _connectionUtil = p6._connectionUtil
		local v29 = p7:GetPropertyChangedSignal("JumpPower")

		_connectionUtil:trackConnection("HUMANOID_JUMP_POWER", v29:Connect(update))

		local v30 = p6._connectionUtil

		v29 = p7:GetPropertyChangedSignal("JumpHeight")
		v30:trackConnection("HUMANOID_JUMP_HEIGHT", v29:Connect(update))
		p6._connectionUtil:trackConnection("HUMANOID_STATE_ENABLED_CHANGED", p7.StateEnabledChanged:Connect(function(p8, p9)
			if p8 == Enum.HumanoidStateType.Jumping and p9 ~= p6._active then
				p6:UpdateEnabled()
			end
		end))
	end)

	p6._connectionUtil:trackConnection("HUMANOID", v20)
end
function object.Enable(p10, p11, p12)
	if p12 then
		p10.parentUIFrame = p12
	end

	if p11 == p10.externallyEnabled then
		return
	end

	p10.externallyEnabled = p11
	p10:UpdateEnabled()

	if p11 then
		p10:_setupConfigurations()

		return
	end

	p10._connectionUtil:disconnectAll()
end
function object.Create(p13)
	if not p13.parentUIFrame then
		return
	end

	if p13.jumpButton then
		p13.jumpButton:Destroy()
		p13.jumpButton = nil
	end

	if p13.absoluteSizeChangedConn then
		p13.absoluteSizeChangedConn:Disconnect()
		p13.absoluteSizeChangedConn = nil
	end

	if v5 and p13.avatarAbilitiesEnabledChangedConn then
		p13.avatarAbilitiesEnabledChangedConn:Disconnect()
		p13.avatarAbilitiesEnabledChangedConn = nil
	end

	p13.jumpButton = Instance.new("ImageButton")
	p13.jumpButton.Name = "JumpButton"
	p13.jumpButton.Visible = false
	p13.jumpButton.BackgroundTransparency = 1

	if v5 and avatarAbilitiesInterface:isEnabled() then
		p13.jumpButton.Image = t1[1]
	else
		p13.jumpButton.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
		p13.jumpButton.ImageRectOffset = Vector2.new(1, 146)
		p13.jumpButton.ImageRectSize = Vector2.new(144, 144)
	end

	local function ResizeJumpButton()
		local u31: boolean = math.min(p13.parentUIFrame.AbsoluteSize.x, p13.parentUIFrame.AbsoluteSize.y) <= 500

		if v5 and avatarAbilitiesInterface:isEnabled() then
			local n1: number = if u31 then 72 else 120
			local n2: number = -n1 - (if u31 then 64 else 88)

			p13.jumpButton.Image = t1[1]
			p13.jumpButton.ImageRectOffset = Vector2.new(0, 0)
			p13.jumpButton.ImageRectSize = Vector2.new(0, 0)
			p13.jumpButton.Size = UDim2.new(0, n1, 0, n1)
			p13.jumpButton.Position = UDim2.new(1, n2, 1, n2)

			return
		end

		local n3: number = if u31 then 70 else 120

		if v5 then
			p13.jumpButton.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
			p13.jumpButton.ImageRectOffset = Vector2.new(1, 146)
			p13.jumpButton.ImageRectSize = Vector2.new(144, 144)
		end

		p13.jumpButton.Size = UDim2.new(0, n3, 0, n3)
		p13.jumpButton.Position = u31 and UDim2.new(1, -(n3 * 1.5 - 10), 1, -n3 - 20) or UDim2.new(1, -(n3 * 1.5 - 10), 1, -n3 * 1.75)
	end

	ResizeJumpButton()
	p13.absoluteSizeChangedConn = p13.parentUIFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeJumpButton)

	if v5 then
		p13.avatarAbilitiesEnabledChangedConn = avatarAbilitiesInterface:GetEnabledChangedSignal():Connect(ResizeJumpButton)
	end

	p13.touchObject = nil
	p13.jumpButton.InputBegan:connect(function(input)
		if not p13.touchObject and input.UserInputType == Enum.UserInputType.Touch and input.UserInputState == Enum.UserInputState.Begin then
			p13.touchObject = input

			if v5 and avatarAbilitiesInterface:isEnabled() then
				p13.jumpButton.Image = t1[2]
			else
				p13.jumpButton.ImageRectOffset = Vector2.new(146, 146)
			end

			p13.isJumping = true

			return
		end
	end)
	p13.jumpButton.Parent = p13.parentUIFrame
end

return object
