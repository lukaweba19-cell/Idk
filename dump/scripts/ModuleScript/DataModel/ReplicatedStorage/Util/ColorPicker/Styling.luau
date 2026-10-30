-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {
	applyStyleColor = function(p1, p2, p3, p4)
		if p4.Color then
			p1[p2] = p4.Color
		end

		if p4.Transparency then
			p1[p3] = p4.Transparency
		end
	end
}

function module.stylize(p5, p6)
	local instance = p5.Instance

	if p6.BackgroundColor then
		module.applyStyleColor(instance.Background, "BackgroundColor3", "BackgroundTransparency", p6.BackgroundColor)
	end

	if p6.AccentColor then
		module.applyStyleColor(instance.Topbar, "BackgroundColor3", "BackgroundTransparency", p6.AccentColor)
		module.applyStyleColor(instance.Middle.Options, "BackgroundColor3", "BackgroundTransparency", p6.AccentColor)
		module.applyStyleColor(instance.Palette, "BackgroundColor3", "BackgroundTransparency", p6.AccentColor)
	end

	if p6.TextColor then
		for iterFirst, iterSecond in instance:GetDescendants() do
			if not iterSecond:IsDescendantOf(instance.Picker) then
				if iterSecond:IsA("TextLabel") or iterSecond:IsA("TextBox") then
					module.applyStyleColor(iterSecond, "TextColor3", "TextTransparency", p6.TextColor)
				elseif iterSecond:IsA("ImageLabel") or iterSecond:IsA("ImageButton") then
					module.applyStyleColor(iterSecond, "ImageColor3", "ImageTransparency", p6.TextColor)
				end
			end
		end

		if instance:FindFirstChild("Resize") and instance.Resize:FindFirstChild("Frame") then
			instance.Resize.Frame.BackgroundColor3 = p6.TextColor.Color
		end
	end

	if p6.RoundedCorners == false then
		for iterFirst2, iterSecond2 in instance:GetDescendants() do
			if iterSecond2:IsA("UICorner") then
				iterSecond2:Destroy()
			end
		end
	end
end
function module.stylizeSlider(p7, p8)
	if p8.AccentColor then
		module.applyStyleColor(p7.Input, "BackgroundColor3", "BackgroundTransparency", p8.AccentColor)
	end

	if p8.TextColor then
		module.applyStyleColor(p7.Input.TextBox, "TextColor3", "TextTransparency", p8.TextColor)
	end

	if p8.RoundedCorners == false then
		for iterFirst, iterSecond in p7:GetDescendants() do
			if iterSecond:IsA("UICorner") then
				iterSecond:Destroy()
			end
		end
	end
end

return module
