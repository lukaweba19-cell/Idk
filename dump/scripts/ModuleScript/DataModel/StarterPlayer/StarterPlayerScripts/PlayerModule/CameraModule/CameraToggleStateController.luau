-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
game:GetService("Players")
game:GetService("UserInputService")
UserSettings():GetService("UserGameSettings")

local cameraInput = require(script.Parent:WaitForChild("CameraInput"))
local cameraUI = require(script.Parent:WaitForChild("CameraUI"))
local cameraUtils = require(script.Parent:WaitForChild("CameraUtils"))
local u4 = false
local timestamp = tick()
local u6: boolean = false
local u7 = false
local u8 = false

cameraUI.setCameraModeToastEnabled(false)

return function(p1)
	local v10 = cameraInput.getTogglePan()

	if p1 and v10 ~= u4 then
		u6 = true
	end

	if v10 ~= u4 or tick() - timestamp > 3 then
		local v11 = v10

		if v11 then
			v11 = tick() - timestamp < 3
		end

		cameraUI.setCameraModeToastOpen(v11)

		if v10 then
			u6 = false
		end

		timestamp = tick()
		u4 = v10
	end

	if p1 ~= u8 then
		if p1 then
			u7 = cameraInput.getTogglePan()
			cameraInput.setTogglePan(true)
		elseif not u6 then
			cameraInput.setTogglePan(u7)
		end
	end

	if p1 then
		if cameraInput.getTogglePan() then
			cameraUtils.setMouseIconOverride("rbxasset://textures/Cursors/CrossMouseIcon.png")
			cameraUtils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCenter)
		else
			cameraUtils.restoreMouseIcon()
			cameraUtils.restoreMouseBehavior()
		end

		cameraUtils.setRotationTypeOverride(Enum.RotationType.CameraRelative)
	elseif cameraInput.getTogglePan() then
		cameraUtils.setMouseIconOverride("rbxasset://textures/Cursors/CrossMouseIcon.png")
		cameraUtils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCenter)
		cameraUtils.setRotationTypeOverride(Enum.RotationType.MovementRelative)
	elseif cameraInput.getHoldPan() then
		cameraUtils.restoreMouseIcon()
		cameraUtils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCurrentPosition)
		cameraUtils.setRotationTypeOverride(Enum.RotationType.MovementRelative)
	else
		cameraUtils.restoreMouseIcon()
		cameraUtils.restoreMouseBehavior()
		cameraUtils.restoreRotationType()
	end

	u8 = p1
end
