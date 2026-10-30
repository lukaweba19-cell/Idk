-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local runService: RunService = game:GetService("RunService")
local userInputService: UserInputService = game:GetService("UserInputService")
local u4 = nil
local u5 = nil

local function probe()
	local v8 = u4

	if v8 and v8:IsDescendantOf(game) then
		return v8
	end

	u4 = nil

	if not runService:IsClient() then
		error("GuiSpace is client-only -- it measures against the local PlayerGui")
	end

	local LocalPlayer: Player = players.LocalPlayer

	if LocalPlayer == nil then
		return nil
	end

	local playerGui: Instance = LocalPlayer:FindFirstChildOfClass("PlayerGui")

	if playerGui == nil then
		return nil
	end

	local guiSpaceOrigin: Instance = playerGui:FindFirstChild("GuiSpaceOrigin")
	local v12: boolean = guiSpaceOrigin ~= nil and guiSpaceOrigin:IsA("ScreenGui")
	local screenGui

	if v12 then
		screenGui = guiSpaceOrigin
	else
		screenGui = Instance.new("ScreenGui")
		screenGui.Name = "GuiSpaceOrigin"
		screenGui.ResetOnSpawn = false
		screenGui.DisplayOrder = -1000
		screenGui.IgnoreGuiInset = true
		pcall(function()
			screenGui.ScreenInsets = Enum.ScreenInsets.None
		end)
		screenGui.Parent = playerGui
	end

	local originRef = screenGui:FindFirstChild("OriginRef")
	local frame

	if originRef ~= nil and originRef:IsA("Frame") then
		frame = originRef
	else
		frame = Instance.new("Frame")
		frame.Name = "OriginRef"
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		frame.Size = UDim2.new(0, 0, 0, 0)
		frame.Position = UDim2.new(0, 0, 0, 0)
		frame.AnchorPoint = Vector2.new(0, 0)
		frame.ZIndex = 0
		frame.Parent = screenGui
	end

	u4 = frame

	return frame
end

local module: {[any]: any} = {
	originOffset = function()
		local v17 = probe()

		if v17 == nil then
		elseif v17.Parent ~= nil and v17.Parent:IsA("ScreenGui") and v17.Parent.AbsoluteSize.X > 0 and v17.Parent.AbsoluteSize.Y > 0 then
			local absolutePosition = v17.AbsolutePosition

			u5 = absolutePosition

			return absolutePosition
		end

		return u5
	end
}

function module.toGuiSpace(p1)
	local v20 = module.originOffset()

	if v20 == nil then
		return nil
	end

	return p1 + v20
end
function module.mouseLocation()
	return module.toGuiSpace(userInputService:GetMouseLocation())
end
function module.contains(p2, p3)
	local absolutePosition = p2.AbsolutePosition
	local absoluteSize = p2.AbsoluteSize

	return p3.X >= absolutePosition.X and p3.X <= absolutePosition.X + absoluteSize.X and p3.Y >= absolutePosition.Y and p3.Y <= absolutePosition.Y + absoluteSize.Y
end

return module
