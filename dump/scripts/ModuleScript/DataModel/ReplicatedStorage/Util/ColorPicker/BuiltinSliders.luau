-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local colorSequenceNew = ColorSequence.new
local colorSequence = colorSequenceNew({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
	ColorSequenceKeypoint.new(0.16666666666666666, Color3.fromRGB(255, 255, 0)),
	ColorSequenceKeypoint.new(0.3333333333333333, Color3.fromRGB(0, 255, 0)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
	ColorSequenceKeypoint.new(0.6666666666666666, Color3.fromRGB(0, 0, 255)),
	ColorSequenceKeypoint.new(0.8333333333333334, Color3.fromRGB(255, 0, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
})

return {
	Hue = function(p1)
		local v4 = p1:_createSlider("Hue", 1, 360)
		local gradient = v4.Instance:WaitForChild("Slider"):WaitForChild("Gradient")

		gradient.Color = colorSequence

		function v4.OnManualChange(p2)
			p1.Color.Hue = p2
		end
		function v4.GetValue()
			return p1.Color.Hue or 0
		end

		v4:UpdateVisual()

		return v4
	end,
	Saturation = function(p3)
		local v7 = p3:_createSlider("Saturation", 2, 100)

		function v7.OnManualChange(p4)
			p3.Color.Saturation = p4
		end
		function v7.GetValue()
			return p3.Color.Saturation or 0
		end
		function v7.OnValueChanged()
			local hue = p3.Color.Hue
			local saturation = p3.Color.Saturation
			local ColorValue = p3.Color.Value
			local gradient = v7.Instance:WaitForChild("Slider"):WaitForChild("Gradient")
			local colorSequenceNew = ColorSequence.new
			local colorSequenceKeypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255))

			gradient.Color = colorSequenceNew({
				colorSequenceKeypoint,
				ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, 1, ColorValue))
			})
		end

		v7:UpdateVisual()

		return v7
	end,
	Value = function(p5)
		local v9 = p5:_createSlider("Value", 3, 100)

		function v9.OnManualChange(value)
			p5.Color.Value = value
		end
		function v9.GetValue()
			return p5.Color.Value or 0
		end
		function v9.OnValueChanged()
			local v30, v31, v32 = p5:GetHSV()
			local gradient = v9.Instance:WaitForChild("Slider"):WaitForChild("Gradient")
			local colorSequenceNew = ColorSequence.new
			local colorSequenceKeypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0))

			gradient.Color = colorSequenceNew({
				colorSequenceKeypoint,
				ColorSequenceKeypoint.new(1, Color3.fromHSV(v30, v31, 1))
			})
		end

		v9:UpdateVisual()

		return v9
	end,
	Red = function(p7)
		local v11 = p7:_createSlider("Red", 1, 255)

		function v11.OnManualChange(p8)
			local v37 = p7:GetColor()
			local v38 = p7.Color
			local v39 = p7.Color
			local v40 = p7.Color
			local color3 = Color3.new(p8, v37.G, v37.B)
			local hue, saturation, value = color3:ToHSV()

			v38.Hue = hue
			v39.Saturation = saturation
			v40.Value = value
		end
		function v11.GetValue()
			return p7:GetColor().R or 0
		end
		function v11.OnValueChanged()
			local v45 = p7:GetColor()
			local g = v45.G
			local b = v45.B
			local gradient = v11.Instance:WaitForChild("Slider"):WaitForChild("Gradient")
			local colorSequenceNew = ColorSequence.new
			local colorSequenceKeypoint = ColorSequenceKeypoint.new(0, Color3.new(0, g, b))

			gradient.Color = colorSequenceNew({
				colorSequenceKeypoint,
				ColorSequenceKeypoint.new(1, Color3.new(1, g, b))
			})
		end

		v11:UpdateVisual()

		return v11
	end,
	Green = function(p9)
		local v13 = p9:_createSlider("Green", 2, 255)

		function v13.OnManualChange(p10)
			local v52 = p9:GetColor()
			local v53 = p9.Color
			local v54 = p9.Color
			local v55 = p9.Color
			local color3 = Color3.new(v52.R, p10, v52.B)
			local hue, saturation, value = color3:ToHSV()

			v53.Hue = hue
			v54.Saturation = saturation
			v55.Value = value
		end
		function v13.GetValue()
			return p9:GetColor().G or 0
		end
		function v13.OnValueChanged()
			local v60 = p9:GetColor()
			local r = v60.R
			local b = v60.B
			local gradient = v13.Instance:WaitForChild("Slider"):WaitForChild("Gradient")
			local colorSequenceNew = ColorSequence.new
			local colorSequenceKeypoint = ColorSequenceKeypoint.new(0, Color3.new(r, 0, b))

			gradient.Color = colorSequenceNew({
				colorSequenceKeypoint,
				ColorSequenceKeypoint.new(1, Color3.new(r, 1, b))
			})
		end

		v13:UpdateVisual()

		return v13
	end,
	Blue = function(p11)
		local v15 = p11:_createSlider("Blue", 3, 255)

		function v15.OnManualChange(p12)
			local v67 = p11:GetColor()
			local v68 = p11.Color
			local v69 = p11.Color
			local v70 = p11.Color
			local color3 = Color3.new(v67.R, v67.G, p12)
			local hue, saturation, value = color3:ToHSV()

			v68.Hue = hue
			v69.Saturation = saturation
			v70.Value = value
		end
		function v15.GetValue()
			return p11:GetColor().B or 0
		end
		function v15.OnValueChanged()
			local v75 = p11:GetColor()
			local r = v75.R
			local g = v75.G
			local gradient = v15.Instance:WaitForChild("Slider"):WaitForChild("Gradient")
			local colorSequenceNew = ColorSequence.new
			local colorSequenceKeypoint = ColorSequenceKeypoint.new(0, Color3.new(r, g, 0))

			gradient.Color = colorSequenceNew({
				colorSequenceKeypoint,
				ColorSequenceKeypoint.new(1, Color3.new(r, g, 1))
			})
		end

		v15:UpdateVisual()

		return v15
	end,
	Transparency = function(p13)
		local v17 = p13:_createSlider("Transparency", 4, 100)
		local gradient = v17.Instance:WaitForChild("Slider"):WaitForChild("Gradient")

		gradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })

		local imageLabel: ImageLabel = Instance.new("ImageLabel")

		imageLabel.BackgroundTransparency = 1
		imageLabel.Size = UDim2.fromScale(0.77, 1)
		imageLabel.Image = "rbxassetid://111137375763311"
		imageLabel.ImageTransparency = 0.5
		imageLabel.ScaleType = Enum.ScaleType.Tile
		imageLabel.TileSize = UDim2.fromScale(0.08, 1)
		imageLabel.ZIndex = -1

		local uiCorner: UICorner = Instance.new("UICorner")

		uiCorner.CornerRadius = UDim.new(0.4, 0)
		uiCorner.Parent = imageLabel
		imageLabel.Parent = v17.Instance

		function v17.OnManualChange(p14)
			p13.Color.Transparency = p14
		end
		function v17.GetValue()
			return p13.Color.Transparency or 0
		end
		function v17.OnValueChanged()
			gradient.Color = ColorSequence.new(p13:GetColor())
		end

		return v17
	end
}
