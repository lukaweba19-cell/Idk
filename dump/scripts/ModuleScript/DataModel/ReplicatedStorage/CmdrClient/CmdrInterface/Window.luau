-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local guiService: GuiService = game:GetService("GuiService")
local userInputService: UserInputService = game:GetService("UserInputService")
local textChatService: TextChatService = game:GetService("TextChatService")
local LocalPlayer: Player = game:GetService("Players").LocalPlayer
local mouseButton1 = Enum.UserInputType.MouseButton1
local mouseButton2 = Enum.UserInputType.MouseButton2
local touch = Enum.UserInputType.Touch
local frame: Instance = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Cmdr"):WaitForChild("Frame")
local line: Instance = frame:WaitForChild("Line")
local entry: Instance = frame:WaitForChild("Entry")

line.Parent = nil

local module: {[any]: any} = {
	Valid = true,
	AutoComplete = nil,
	ProcessEntry = nil,
	OnTextChanged = nil,
	Cmdr = nil,
	HistoryState = nil,
	UpdateLabel = function(p1)
		entry.TextLabel.Text = LocalPlayer.Name .. "@" .. p1.Cmdr.PlaceName .. "$"
	end,
	GetLabel = function(_)
		return entry.TextLabel.Text
	end,
	UpdateWindowHeight = function(_)
		local n1 = frame.UIListLayout.AbsoluteContentSize.Y + frame.UIPadding.PaddingTop.Offset + frame.UIPadding.PaddingBottom.Offset
		local uDim2New = UDim2.new
		local scale = frame.Size.X.Scale
		local offset = frame.Size.X.Offset
		local v22 = math.clamp(n1, 0, 300)

		frame.Size = uDim2New(scale, offset, 0, v22)
		frame.CanvasPosition = Vector2.new(0, n1)
	end
}

function module.AddLine(p4, p5, p6)
	local t3 = p6 or {}
	local text: string = tostring(p5)

	if typeof(t3) == "Color3" then
		t3 = { Color = t3 }
	end

	if #text == 0 then
		module:UpdateWindowHeight()

		return
	end

	local v28 = p4.Cmdr.Util.EmulateTabstops(text or "nil", 8)
	local clone: Instance = line:Clone()

	clone.Text = v28
	clone.TextColor3 = t3.Color or clone.TextColor3
	clone.RichText = t3.RichText or false
	clone.Parent = frame
end
function module.IsVisible(_)
	return frame.Visible
end
function module.SetVisible(p8, visible)
	frame.Visible = visible

	if visible then
		p8.PreviousChatWindowConfigurationEnabled = textChatService.ChatWindowConfiguration.Enabled
		p8.PreviousChatInputBarConfigurationEnabled = textChatService.ChatInputBarConfiguration.Enabled
		textChatService.ChatWindowConfiguration.Enabled = false
		textChatService.ChatInputBarConfiguration.Enabled = false
		entry.TextBox:CaptureFocus()
		p8:SetEntryText("")

		if p8.Cmdr.ActivationUnlocksMouse then
			p8.PreviousMouseBehavior = userInputService.MouseBehavior
			userInputService.MouseBehavior = Enum.MouseBehavior.Default

			return
		end
	else
		textChatService.ChatWindowConfiguration.Enabled = if p8.PreviousChatWindowConfigurationEnabled == nil then true else p8.PreviousChatWindowConfigurationEnabled
		textChatService.ChatInputBarConfiguration.Enabled = if p8.PreviousChatInputBarConfigurationEnabled == nil then true else p8.PreviousChatInputBarConfigurationEnabled
		entry.TextBox:ReleaseFocus()
		p8.AutoComplete:Hide()

		if p8.PreviousMouseBehavior then
			userInputService.MouseBehavior = p8.PreviousMouseBehavior
			p8.PreviousMouseBehavior = nil
		end
	end
end
function module.Hide(p10)
	return p10:SetVisible(false)
end
function module.Show(p11)
	return p11:SetVisible(true)
end
function module.SetEntryText(p12, p13)
	entry.TextBox.Text = p13

	if p12:IsVisible() then
		entry.TextBox:CaptureFocus()
		entry.TextBox.CursorPosition = #p13 + 1
		module:UpdateWindowHeight()
	end
end
function module.GetEntryText(_)
	return entry.TextBox.Text:gsub("\t", "")
end
function module.SetIsValidInput(p15, valid, p17)
	entry.TextBox.TextColor3 = valid and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 73, 73)
	p15.Valid = valid
	p15._errorText = p17
end
function module.HideInvalidState(_)
	entry.TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
end
function module.LoseFocus(p19, p20)
	local text = entry.TextBox.Text

	p19:ClearHistoryState()

	if frame.Visible and not guiService.MenuIsOpen then
		entry.TextBox:CaptureFocus()
	elseif guiService.MenuIsOpen and frame.Visible then
		p19:Hide()
	end

	if p20 and p19.Valid then
		wait()
		p19:SetEntryText("")
		p19.ProcessEntry(text)
	elseif p20 then
		p19:AddLine(p19._errorText, Color3.fromRGB(255, 153, 153))
	end
end
function module.TraverseHistory(p21, p22)
	local v47 = p21.Cmdr.Dispatcher:GetHistory()

	if p21.HistoryState == nil then
		local v48 = p21:GetEntryText()

		p21.HistoryState = { Position = #v47 + 1, InitialText = v48 }
	end

	p21.HistoryState.Position = math.clamp(p21.HistoryState.Position + p22, 1, #v47 + 1)
	p21:SetEntryText(p21.HistoryState.Position == #v47 + 1 and p21.HistoryState.InitialText or v47[p21.HistoryState.Position])
end
function module.ClearHistoryState(p23)
	p23.HistoryState = nil
end
function module.SelectVertical(p24, p25)
	if p24.AutoComplete:IsVisible() and not p24.HistoryState then
		p24.AutoComplete:Select(p25)

		return
	end

	p24:TraverseHistory(p25)
end

local n1 = 0
local n2: number = 0
local t2: {[any]: any} = { mouseButton1, mouseButton2, touch }

function module.BeginInput(p26, input, p28)
	if guiService.MenuIsOpen then
		p26:Hide()
	end

	if p28 and p26:IsVisible() == false then
	elseif not p26.Cmdr.ActivationKeys[input.KeyCode] then
		if p26.Cmdr.Enabled == false or not p26:IsVisible() then
			if p26:IsVisible() then
				p26:Hide()
			end
		elseif p26.Cmdr.HideOnLostFocus and table.find(t2, input.UserInputType) then
			local inputPosition = input.Position
			local frameAbsolutePosition = frame.AbsolutePosition
			local frameAbsoluteSize = frame.AbsoluteSize

			if inputPosition.X < frameAbsolutePosition.X or inputPosition.X > frameAbsolutePosition.X + frameAbsoluteSize.X or inputPosition.Y < frameAbsolutePosition.Y or inputPosition.Y > frameAbsolutePosition.Y + frameAbsoluteSize.Y then
				p26:Hide()

				return
			end
		else
			if input.KeyCode == Enum.KeyCode.Down then
				p26:SelectVertical(1)

				return
			end

			if input.KeyCode == Enum.KeyCode.Up then
				p26:SelectVertical(-1)

				return
			end

			if input.KeyCode == Enum.KeyCode.Return then
				wait()

				local replacedText = p26:GetEntryText():gsub("\n", "")

				p26:SetEntryText(replacedText:gsub("\r", ""))

				return
			end

			if input.KeyCode == Enum.KeyCode.Tab then
				local v59 = p26.AutoComplete:GetSelectedItem()
				local v60 = p26:GetEntryText()

				if v59 and (not v60:sub(#v60, #v60):match("%s") or not p26.AutoComplete.LastItem) then
					local v61 = v59[2]
					local u62: boolean = true
					local command = p26.AutoComplete.Command
					local v65

					if command then
						local arg = p26.AutoComplete.Arg

						v65 = command.Alias
						u62 = p26.AutoComplete.NumArgs ~= #command.ArgumentDefinitions and p26.AutoComplete.IsPartial == false

						local commandArguments = command.Arguments

						for i = 1, #commandArguments do
							local v69 = commandArguments[i]
							local rawSegments = v69.RawSegments

							if arg == v69 then
								rawSegments[#rawSegments] = v61
							end

							local prefix = v69.Prefix
							local v72 = table.concat(rawSegments, ",")
							local s1 = prefix .. v72

							if s1:find(" ") or s1 == "" then
								s1 = ("%q"):format(s1)
							end

							v65 = ("%s %s"):format(v65, s1)

							if v69 == arg then
								break
							end
						end
					else
						v65 = v61
					end

					wait()
					p26:SetEntryText(v65 .. (if u62 then " " else ""))

					return
				end

				wait()
				p26:SetEntryText(p26:GetEntryText())

				return
			end

			p26:ClearHistoryState()
		end
	elseif p26.Cmdr.MashToEnable and not p26.Cmdr.Enabled then
		if tick() - n1 < 1 then
			if n2 >= 5 then
				return p26.Cmdr:SetEnabled(true)
			end

			n2 += 1
		else
			n2 = 1
		end

		n1 = tick()
	elseif p26.Cmdr.Enabled then
		local v74 = p26:IsVisible()

		p26:SetVisible(not v74)
		wait()
		p26:SetEntryText("")

		if guiService.MenuIsOpen then
			p26:Hide()
		end
	end
end

entry.TextBox.FocusLost:Connect(function(p29)
	return module:LoseFocus(p29)
end)
userInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	return module:BeginInput(input, gameProcessedEvent)
end)
entry.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
	frame.CanvasPosition = Vector2.new(0, frame.AbsoluteCanvasSize.Y)

	if entry.TextBox.Text:match("\t") then
		entry.TextBox.Text = entry.TextBox.Text:gsub("\t", "")
	elseif module.OnTextChanged then
		return module.OnTextChanged(entry.TextBox.Text)
	end
end)
frame.ChildAdded:Connect(function()
	task.defer(module.UpdateWindowHeight)
end)

return module
