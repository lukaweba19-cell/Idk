-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local userInputService: UserInputService = game:GetService("UserInputService")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local controlLabels: Instance = script.Parent.Parent:WaitForChild("ControlLabels")
local extensions: Instance = replicatedStorage:WaitForChild("Extensions")
local inputCategorizer = require(extensions:WaitForChild("InputCategorizer"))
local u6 = nil
local u7 = nil
local u8: boolean = false

local function updateTouchState()
	local v14: Enum.UserInputType = userInputService:GetLastInputType()
	local v15: boolean = u8

	u8 = v14 == Enum.UserInputType.Touch

	if v15 ~= u8 then
		controlLabels.Visible = not u8
	end
end

userInputService.LastInputTypeChanged:Connect(function(lastInputType: Enum.UserInputType)
	local v17: boolean = u8

	u8 = lastInputType == Enum.UserInputType.Touch

	if v17 ~= u8 then
		controlLabels.Visible = not u8
	end
end)
task.defer(function()
	local v18: Enum.UserInputType = userInputService:GetLastInputType()
	local v19: boolean = u8

	u8 = v18 == Enum.UserInputType.Touch

	if v19 ~= u8 then
		controlLabels.Visible = not u8
	end
end)

local function compare(p2, p3)
	if p2 == p3 then
		return true
	end

	local t1 = p2 or {}
	local t2 = p3 or {}

	if #t1 ~= #t2 then
		return false
	end

	for i, v in ipairs(t1) do
		local v26 = t2[i]

		if v.Keybind ~= v26.Keybind or v.MouseTemplate ~= v26.MouseTemplate or v.Label ~= v26.Label or v.GamepadKeyCode ~= v26.GamepadKeyCode or v.gamepadOnly ~= v26.gamepadOnly then
			return false
		end
	end

	return true
end
local function clearLabels()
	for iterFirst, iterSecond in controlLabels:GetChildren() do
		if not iterSecond.Name:match("ControlTemplate") and not iterSecond:IsA("UIListLayout") then
			iterSecond:Destroy()
		end
	end
end
local function isGamepad()
	return inputCategorizer.getLastInputCategory() == inputCategorizer.InputCategory.Gamepad
end
local function buildLabels(p4)
	if p4 and #p4 ~= 0 then
		local u30: boolean = inputCategorizer.getLastInputCategory() == inputCategorizer.InputCategory.Gamepad

		for _, v in ipairs(p4) do
			if not v.gamepadOnly or u30 then
				local clone

				if u30 and v.GamepadKeyCode then
					clone = controlLabels.ControlTemplateLMB:Clone()

					local keybind = clone:FindFirstChild("Keybind")

					if keybind then
						local ok, result = pcall(function()
							return userInputService:GetImageForKeyCode(v.GamepadKeyCode)
						end)

						if ok and result ~= "" then
							keybind.Image = result
						else
							keybind.Image = ""
						end
					end
				elseif v.MouseTemplate == "LMB" then
					clone = controlLabels.ControlTemplateLMB:Clone()
				elseif v.MouseTemplate == "RMB" then
					clone = controlLabels.ControlTemplateRMB:Clone()
				else
					clone = controlLabels.ControlTemplate:Clone()
					clone.Keybind.Text = v.Keybind
				end

				clone.Name = "ControlLabel"
				clone.Selectable = false
				clone.Label.Text = v.Label
				clone.Visible = true
				clone.Parent = controlLabels
			end
		end

		return
	end
end

inputCategorizer.lastInputCategoryChanged:Connect(function(p6)
	if u6 and #u6 ~= 0 then
		local s1: string = if p6 == inputCategorizer.InputCategory.Gamepad then "Gamepad" else "KBM"

		if s1 ~= u7 then
			u7 = s1
			clearLabels()
			buildLabels(u6)
		end

		return
	end
end)

return {
	setList = function(p5)
		local s1: string = if inputCategorizer.getLastInputCategory() == inputCategorizer.InputCategory.Gamepad then "Gamepad" else "KBM"

		if compare(p5, u6) and s1 == u7 then
			return
		end

		u6 = p5
		u7 = s1
		clearLabels()
		buildLabels(p5)
	end
}
