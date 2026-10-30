-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local LocalPlayer: Player = game:GetService("Players").LocalPlayer

return function(p1)
	local util = p1.Util
	local autocomplete: Instance = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Cmdr"):WaitForChild("Autocomplete")
	local textButton: Instance = autocomplete:WaitForChild("TextButton")
	local title: Instance = autocomplete:WaitForChild("Title")
	local description: Instance = autocomplete:WaitForChild("Description")
	local entry: Instance = autocomplete.Parent:WaitForChild("Frame"):WaitForChild("Entry")

	textButton.Parent = nil

	local autocompleteScrollBarThickness = autocomplete.ScrollBarThickness

	local function SetText(p2, p3, p4, p5)
		p2.Visible = p4 ~= nil
		p3.Text = p4 or ""

		if p5 then
			local uDim2New = UDim2.new
			local v19 = util.GetTextSize(p4 or "", p3, Vector2.new(1000, 1000), 1, 0)

			p3.Size = uDim2New(0, v19.X, p2.Size.Y.Scale, p2.Size.Y.Offset)
		end
	end
	local function UpdateContainerSize()
		local uDim2New = UDim2.new
		local v21 = math.max(title.Field.TextBounds.X + title.Field.Type.TextBounds.X, autocomplete.Size.X.Offset)
		local v22 = math.min(autocomplete.UIListLayout.AbsoluteContentSize.Y, autocomplete.Parent.AbsoluteSize.Y - autocomplete.AbsolutePosition.Y - 10)

		autocomplete.Size = uDim2New(0, v21, 0, v22)
	end
	local function UpdateInfoDisplay(p6)
		SetText(title, title.Field, p6.name, true)

		local v24 = title.Field.Type
		local v25 = title.Field.Type
		local v26 = p6.type

		if v26 then
			local v27 = p6.type:sub(1, 1):upper()
			local substring = p6.type:sub(2)

			v26 = ": " .. v27 .. substring
		end

		v24.Visible = v26 ~= nil
		v25.Text = v26 or ""

		local descriptionLabel = description.Label
		local description2 = p6.description

		description.Visible = description2 ~= nil
		descriptionLabel.Text = description2 or ""
		description.Label.TextColor3 = p6.invalid and Color3.fromRGB(255, 73, 73) or Color3.fromRGB(255, 255, 255)
		description.Size = UDim2.new(1, 0, 0, 40)

		repeat
			if description.Label.TextFits then
				break
			end

			description.Size = description.Size + UDim2.new(0, 0, 0, 2)
		until description.Size.Y.Offset > 500

		task.wait()
		autocomplete.UIListLayout:ApplyLayout()
		UpdateContainerSize()
		autocomplete.ScrollBarThickness = autocompleteScrollBarThickness
	end

	local t1: {[any]: any} = {
		SelectedItem = 0,
		Items = {},
		ItemOptions = {},
		Show = function(p7, items, p9)
			local t2 = p9 or {}

			for _, v in pairs(p7.Items) do
				if v.gui then
					v.gui:Destroy()
				end
			end

			p7.SelectedItem = 1
			p7.Items = items
			p7.Prefix = t2.prefix or ""
			p7.LastItem = t2.isLast or false
			p7.Command = t2.command
			p7.Arg = t2.arg
			p7.NumArgs = t2.numArgs
			p7.IsPartial = t2.isPartial

			local n1 = 200

			autocomplete.ScrollBarThickness = 0

			for k, v in pairs(p7.Items) do
				local v40 = v[1]
				local v41 = v[2]
				local clone: Instance = textButton:Clone()

				clone.Name = v40 .. v41
				clone.BackgroundTransparency = if k == p7.SelectedItem then 0.5 else 1

				local stringFind = string.find
				local lowerText = v41:lower()
				local lowerText2 = v40:lower()
				local v46, v47 = stringFind(lowerText, lowerText2, 1, true)

				clone.Typed.Text = string.rep(" ", v46 - 1) .. v40

				local cloneSuggest = clone.Suggest
				local v49 = string.sub(v41, 0, v46 - 1)
				local v50 = string.rep(" ", #v40)
				local v51 = string.sub(v41, v47 + 1)

				cloneSuggest.Text = v49 .. v50 .. v51
				clone.Parent = autocomplete
				clone.LayoutOrder = k

				local n2 = math.max(clone.Typed.TextBounds.X, clone.Suggest.TextBounds.X) + 20

				if n1 < n2 then
					n1 = n2
				end

				v.gui = clone
			end

			autocomplete.UIListLayout:ApplyLayout()

			local text = entry.TextBox.Text
			local v54 = util.SplitString(text)

			if text:sub(#text, #text) == " " and not t2.at then
				v54[#v54 + 1] = "e"
			end

			table.remove(v54, #v54)

			local v55 = t2.at and t2.at

			if not v55 then
				v55 = #table.concat(v54, " ") + 1
			end

			autocomplete.Position = UDim2.new(0, entry.TextBox.AbsolutePosition.X - 10 + v55 * 7, 0, entry.TextBox.AbsolutePosition.Y + 30)
			autocomplete.Size = UDim2.new(0, n1, 0, autocomplete.UIListLayout.AbsoluteContentSize.Y)
			autocomplete.Visible = true
			UpdateInfoDisplay(p7.Items[1] and p7.Items[1].options or t2)
		end
	}

	function t1.GetSelectedItem(_)
		if autocomplete.Visible == false then
			return nil
		end

		return t1.Items[t1.SelectedItem]
	end
	function t1.Hide(_)
		autocomplete.Visible = false
	end
	function t1.IsVisible(_)
		return autocomplete.Visible
	end
	function t1.Select(p13, p14)
		if not autocomplete.Visible then
			return
		end

		p13.SelectedItem = p13.SelectedItem + p14

		if p13.SelectedItem > #p13.Items then
			p13.SelectedItem = 1
		elseif p13.SelectedItem < 1 then
			p13.SelectedItem = #p13.Items
		end

		for k, v in pairs(p13.Items) do
			v.gui.BackgroundTransparency = if k == p13.SelectedItem then 0.5 else 1
		end

		local vector2New = Vector2.new
		local v64 = math.max(0, title.Size.Y.Offset + description.Size.Y.Offset + p13.SelectedItem * textButton.Size.Y.Offset - autocomplete.Size.Y.Offset)

		autocomplete.CanvasPosition = vector2New(0, v64)

		if p13.Items[p13.SelectedItem] and p13.Items[p13.SelectedItem].options then
			UpdateInfoDisplay(p13.Items[p13.SelectedItem].options or {})
		end
	end

	autocomplete.Parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateContainerSize)

	return t1
end
