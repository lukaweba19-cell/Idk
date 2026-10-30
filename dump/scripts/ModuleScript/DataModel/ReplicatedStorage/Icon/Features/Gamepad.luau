-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local gamepadService: GamepadService = game:GetService("GamepadService")
local userInputService: UserInputService = game:GetService("UserInputService")
local guiService: GuiService = game:GetService("GuiService")
local dPadUp = Enum.KeyCode.DPadUp
local gamepad = Enum.PreferredInput.Gamepad
local u6 = nil
local module: {[any]: any} = {}

function module.start(p1)
	u6 = p1
	u6.highlightKey = if u6.highlightKey == nil then dPadUp else u6.highlightKey
	u6.highlightIcon = false
	task.delay(1, function()
		local iconsDictionary = u6.iconsDictionary

		local function getIconFromSelectedObject()
			local guiServiceSelectedObject: GuiObject = guiService.SelectedObject
			local v27 = guiServiceSelectedObject and guiServiceSelectedObject:GetAttribute("CorrespondingIconUID")

			return v27 and iconsDictionary[v27]
		end

		local u18 = nil
		local u19: boolean = dPadUp ~= u6.highlightKey
		local u20: boolean = dPadUp ~= u6.highlightKey
		local selection = require(script.Parent.Parent.Elements.Selection)

		local function updateSelectedObject()
			local guiServiceSelectedObject: GuiObject = guiService.SelectedObject
			local v29 = guiServiceSelectedObject and guiServiceSelectedObject:GetAttribute("CorrespondingIconUID")
			local v30 = v29 and iconsDictionary[v29]
			local u31: boolean = userInputService.PreferredInput == gamepad

			if v30 then
				if u31 then
					local v32 = v30:getInstance("ClickRegion")
					local v33 = v30.selection

					if not v33 then
						v33 = v30.janitor:add(selection(u6))
						v33:SetAttribute("IgnoreVisibilityUpdater", true)
						v33.Parent = v30.widget
						v30.selection = v33
						v30:refreshAppearance(v33)
					end

					v32.SelectionImageObject = v33.Selection
				end

				if u18 and v30 ~= u18 then
					u18:setIndicator()
				end

				local v34 = if u31 and not u20 and not v30.parentIconUID then Enum.KeyCode.ButtonB else nil

				u18 = v30
				u6.lastHighlightedIcon = v30
				v30:setIndicator(v34)

				return
			end

			v29 = if u31 and not u19 then u6.highlightKey else nil

			if not u18 then
				u18 = module.getIconToHighlight()
			end

			if v29 == u6.highlightKey then
				u19 = true
			end

			if u18 then
				u18:setIndicator(v29)
			end
		end

		guiService:GetPropertyChangedSignal("SelectedObject"):Connect(updateSelectedObject)
		userInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function()
			if userInputService.PreferredInput ~= gamepad then
				u19 = false
				u20 = false
			end

			updateSelectedObject()
		end)

		if userInputService.PreferredInput ~= gamepad then
			u19 = false
			u20 = false
		end

		updateSelectedObject()
		userInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				local guiServiceSelectedObject: GuiObject = guiService.SelectedObject
				local v38 = guiServiceSelectedObject and guiServiceSelectedObject:GetAttribute("CorrespondingIconUID")

				if v38 and iconsDictionary[v38] then
					guiService.SelectedObject = nil
				end

				return
			end

			if input.KeyCode ~= u6.highlightKey then
				return
			end

			task.wait()

			local timestamp = tick()
			local gamepadOpenAbilities = game.Players.LocalPlayer:GetAttribute("GamepadOpenAbilities")

			if timestamp - (gamepadOpenAbilities or 0) < 0.1 then
				return
			end

			if tick() - (game.Players.LocalPlayer:GetAttribute("GamepadInspect") or 0) < 0.1 then
				return
			end

			local v41 = module.getIconToHighlight()

			if v41 then
				if gamepadService.GamepadCursorEnabled then
					task.wait(0.2)
					gamepadService:DisableGamepadCursor()
				end

				guiService.SelectedObject = v41:getInstance("ClickRegion")
			end
		end)
	end)
end
function module.getIconToHighlight()
	local v9 = u6.highlightIcon or u6.lastHighlightedIcon

	if not v9 then
		local v10 = nil

		for _, v in pairs(u6.iconsDictionary) do
			if not v.parentIconUID and (not v10 or v10 > v.widget.AbsolutePosition.X) then
				v9 = v
				v10 = v9.widget.AbsolutePosition.X
			end
		end
	end

	return v9
end
function module.registerButton(p4)
	local u14: boolean = false

	p4.InputBegan:Connect(function(_)
		u14 = true
		task.wait()
		task.wait()
		u14 = false
	end)

	local connection = userInputService.InputBegan:Connect(function(input: InputObject)
		task.wait()

		if input.KeyCode == Enum.KeyCode.ButtonA and u14 then
			task.wait(0.2)
			gamepadService:DisableGamepadCursor()
			guiService.SelectedObject = p4

			return
		end

		local KeyCodeName = input.KeyCode.Name

		if table.find({ "ButtonB", "ButtonSelect" }, KeyCodeName) and guiService.SelectedObject == p4 and (KeyCodeName ~= "ButtonSelect" or not not gamepadService.GamepadCursorEnabled) then
			guiService.SelectedObject = nil
		end
	end)

	p4.Destroying:Once(function()
		connection:Disconnect()
	end)
end

return module
