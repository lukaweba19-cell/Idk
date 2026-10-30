-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local colorSequenceKeypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(201, 255, 144))
local colorSequenceKeypoint2 = ColorSequenceKeypoint.new(0.08, Color3.fromRGB(202, 255, 146))
local colorSequenceKeypoint3 = ColorSequenceKeypoint.new(0.09, Color3.fromRGB(143, 237, 36))
local t1: {[any]: any} = {
	colorSequenceKeypoint,
	colorSequenceKeypoint2,
	colorSequenceKeypoint3,
	ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 161, 0))
}
local color3 = Color3.fromRGB(29, 104, 6)
local color32 = Color3.fromRGB(0, 40, 5)
local colorSequenceKeypoint4 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 152, 154))
local colorSequenceKeypoint5 = ColorSequenceKeypoint.new(0.08, Color3.fromRGB(255, 166, 167))
local colorSequenceKeypoint6 = ColorSequenceKeypoint.new(0.09, Color3.fromRGB(255, 74, 74))
local t2: {[any]: any} = {
	colorSequenceKeypoint4,
	colorSequenceKeypoint5,
	colorSequenceKeypoint6,
	ColorSequenceKeypoint.new(1, Color3.fromRGB(129, 20, 20))
}
local color33 = Color3.fromRGB(104, 0, 0)
local color34 = Color3.fromRGB(40, 0, 0)
local colorSequenceKeypoint7 = ColorSequenceKeypoint.new(0, Color3.fromRGB(153, 209, 255))
local colorSequenceKeypoint8 = ColorSequenceKeypoint.new(0.08, Color3.fromRGB(140, 200, 255))
local colorSequenceKeypoint9 = ColorSequenceKeypoint.new(0.09, Color3.fromRGB(38, 132, 255))
local t3: {[any]: any} = {
	colorSequenceKeypoint7,
	colorSequenceKeypoint8,
	colorSequenceKeypoint9,
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 80, 190))
}
local color35 = Color3.fromRGB(10, 54, 120)
local color36 = Color3.fromRGB(0, 20, 46)
local colorSequenceKeypoint10 = ColorSequenceKeypoint.new(0, Color3.fromRGB(190, 190, 196))
local colorSequenceKeypoint11 = ColorSequenceKeypoint.new(0.09, Color3.fromRGB(138, 138, 144))
local t4: {[any]: any} = {
	colorSequenceKeypoint10,
	colorSequenceKeypoint11,
	ColorSequenceKeypoint.new(1, Color3.fromRGB(92, 92, 98))
}
local color37 = Color3.fromRGB(70, 70, 74)
local color38 = Color3.fromRGB(28, 28, 32)

return {
	THEMES = {
		green = { grad = t1, shadow = color3, stroke = color32 },
		red = { grad = t2, shadow = color33, stroke = color34 },
		blue = { grad = t3, shadow = color35, stroke = color36 },
		gray = { grad = t4, shadow = color37, stroke = color38 }
	},
	Apply = function(p1, p2)
		local uiGradient = p1:FindFirstChildOfClass("UIGradient")

		if uiGradient then
			uiGradient.Color = ColorSequence.new(p2.grad)
		end

		for _, v in ipairs(p1:GetChildren()) do
			if v:IsA("TextLabel") then
				v.TextColor3 = p2.shadow

				local textLabel = v:FindFirstChildOfClass("TextLabel")
				local uiStroke = textLabel and textLabel:FindFirstChildOfClass("UIStroke")

				if uiStroke then
					uiStroke.Color = p2.stroke
				end
			end
		end
	end,
	SetText = function(p3, text)
		local textLabel = p3:FindFirstChild("TextLabel")

		if textLabel and textLabel:IsA("TextLabel") then
			textLabel.Text = text

			for _, v in ipairs(textLabel:GetChildren()) do
				if v:IsA("TextLabel") then
					v.Text = text
				end
			end
		end
	end
}
