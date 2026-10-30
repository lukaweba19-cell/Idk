-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local userInputService: UserInputService = game:GetService("UserInputService")
local guiService: GuiService = game:GetService("GuiService")

local module: {[any]: any} = {
	monotoneSlopes = function(p1, p2)
		local n1: number = #p1

		if n1 < 2 then
			return { 0 }
		end

		local t2: {[any]: any} = {}

		for i = 1, n1 - 1 do
			t2[i] = (p1[i + 1] - p1[i]) / p2
		end

		local t3: {[any]: any} = { t2[1], [n1] = t2[n1 - 1] }

		for i = 2, n1 - 1 do
			if t2[i - 1] * t2[i] <= 0 then
				t3[i] = 0
			else
				t3[i] = (t2[i - 1] + t2[i]) / 2
			end
		end

		for i = 1, n1 - 1 do
			if math.abs(t2[i]) < 1E-9 then
				t3[i] = 0
				t3[i + 1] = 0
			else
				local n2 = t3[i] / t2[i]
				local n3 = t3[i + 1] / t2[i]
				local n4 = n2 * n2 + n3 * n3

				if n4 > 9 then
					local n5 = 3 / math.sqrt(n4)

					t3[i] = n5 * n2 * t2[i]
					t3[i + 1] = n5 * n3 * t2[i]
				end
			end
		end

		return t3
	end
}

function module.build(p3)
	local points = p3.points
	local scale = p3.scale
	local n1 = p3.yMax - p3.yMin

	if n1 <= 0 then
		n1 = 1
	end

	local zIndex = p3.zIndex or 2
	local frame: Frame = Instance.new("Frame")

	frame.Name = p3.name or "Plot"
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.ClipsDescendants = false
	frame.Size = p3.size

	if p3.position ~= nil then
		frame.Position = p3.position
	end

	if p3.anchorPoint ~= nil then
		frame.AnchorPoint = p3.anchorPoint
	end

	if p3.layoutOrder ~= nil then
		frame.LayoutOrder = p3.layoutOrder
	end

	frame.ZIndex = zIndex
	frame.Parent = p3.parent

	local function sx(p4)
		if #points == 1 then
			return 0.5
		end

		return (p4 - 1) * 0.91 / (#points - 1) + 0.045
	end
	local function sy(p5)
		return (1 - (p5 - p3.yMin) / n1) * 0.8 + 0.1
	end

	for i, v in ipairs(p3.gridlines or {}) do
		local frame2: Frame = Instance.new("Frame")

		frame2.Name = ("Grid%d"):format(i)
		frame2.BorderSizePixel = 0
		frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		frame2.BackgroundTransparency = if v == p3.emphasisGridline then 0.85 else 0.93
		frame2.AnchorPoint = Vector2.new(0, 0.5)
		frame2.Position = UDim2.fromScale(0.045, (1 - (v - p3.yMin) / n1) * 0.8 + 0.1)
		frame2.Size = UDim2.new(0.91, 0, 0, 1)
		frame2.ZIndex = zIndex
		frame2.Parent = frame
	end

	local labelTemplate = p3.labelTemplate

	if labelTemplate ~= nil then
		local function makeLabel(name, text, textXAlignment)
			local clone = labelTemplate:Clone()

			clone.Name = name
			clone.Visible = true
			clone.BackgroundTransparency = 1
			clone.RichText = false
			clone.TextScaled = false
			clone.TextWrapped = false
			clone.AutomaticSize = Enum.AutomaticSize.None

			local rounded = math.round(scale * 11)

			clone.TextSize = math.max(8, rounded)
			clone.TextXAlignment = textXAlignment
			clone.TextYAlignment = Enum.TextYAlignment.Center

			if p3.labelColor ~= nil then
				clone.TextColor3 = p3.labelColor

				for _, v in ipairs(clone:GetChildren()) do
					if v:IsA("UIGradient") then
						v:Destroy()
					end
				end
			end

			clone.Text = text
			clone.ZIndex = zIndex
			clone.Parent = frame

			return clone
		end

		local rounded = math.round(scale * 16)

		for i, v in ipairs(p3.yLabels or {}) do
			local v32 = ("YLabel%d"):format(i)
			local v33 = makeLabel(v32, v.text, Enum.TextXAlignment.Right)

			v33.AnchorPoint = Vector2.new(1, 0.5)

			local uDim2New = UDim2.new
			local rounded2 = math.round(scale * 6)

			v33.Position = uDim2New(0.045, -rounded2, (1 - (v.v - p3.yMin) / n1) * 0.8 + 0.1, 0)

			local v36 = UDim2.new
			local rounded3 = math.round(scale * 64)

			v33.Size = v36(0, rounded3, 0, rounded)
		end

		for k, v in pairs(p3.xLabels or {}) do
			if typeof(k) == "number" and k >= 1 and k <= #points then
				local v40 = ("XLabel%d"):format(k)
				local v41 = makeLabel(v40, v, Enum.TextXAlignment.Center)

				v41.AnchorPoint = Vector2.new(0.5, 0)

				local v42 = UDim2.new
				local rounded4 = math.round(scale * 2)

				v41.Position = v42(if #points == 1 then 0.5 else (k - 1) * 0.91 / (#points - 1) + 0.045, 0, 1, rounded4)

				local v44 = UDim2.new
				local rounded5 = math.round(scale * 72)

				v41.Size = v44(0, rounded5, 0, rounded)
			end
		end
	end

	local n2 = #points > 1 and 0.91 / (#points - 1) or 0.91
	local t4: {[any]: any} = {}

	local function flushRun(p9, p10)
		if p9 == nil then
			return
		end

		if p10 - p9 + 1 < 2 then
			return
		end

		local t7: {[any]: any} = {}

		for i = p9, p10 do
			t7[i - p9 + 1] = (1 - (points[i].y - p3.yMin) / n1) * 0.8 + 0.1
		end

		local v113 = module.monotoneSlopes(t7, n2)
		local curve: Path2D = Instance.new("Path2D")

		curve.Name = "Curve"
		curve.Color3 = p3.lineColor

		local rounded = math.round(scale * 3)

		curve.Thickness = math.max(2, rounded)
		curve.ZIndex = zIndex + 1

		local t8: {[any]: any} = {}

		for i = 1, #t7 do
			local v118 = v113[i] or 0
			local n3 = n2 / 3
			local v120 = i == 1 and UDim2.new() or UDim2.fromScale(-n3, -v118 * n3)
			local v121 = i == #t7 and UDim2.new() or UDim2.fromScale(n3, v118 * n3)
			local path2DControlPointNew = Path2DControlPoint.new
			local v123 = UDim2.fromScale(if #points == 1 then 0.5 else (p9 + i - 1 - 1) * 0.91 / (#points - 1) + 0.045, t7[i])

			t8[i] = path2DControlPointNew(v123, v120, v121)
		end

		curve:SetControlPoints(t8)
		curve.Parent = frame
		table.insert(t4, curve)
	end

	local v49 = nil

	for i, v in ipairs(points) do
		if v.y == nil then
			flushRun(v49, i - 1)
			v49 = nil
		elseif v49 == nil then
			v49 = i
		end
	end

	flushRun(v49, #points)

	if p3.clipTo ~= nil or p3.window ~= nil then
		local clipTo = p3.clipTo
		local window = p3.window

		local function syncCurveVisible()
			if not frame.Parent then
				return
			end

			local u124 = true

			if window ~= nil then
				u124 = window.Visible
			end

			if clipTo ~= nil then
				local y = clipTo.AbsolutePosition.Y
				local v126 = frame.AbsolutePosition.Y
				local v127 = u124

				if v127 then
					v127 = false

					if y < v126 + frame.AbsoluteSize.Y then
						v127 = y + clipTo.AbsoluteSize.Y > v126
					end
				end

				u124 = v127
			end

			for _, v in ipairs(t4) do
				if v.Parent then
					v.Visible = u124
				end
			end
		end

		frame:GetPropertyChangedSignal("AbsolutePosition"):Connect(syncCurveVisible)
		frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(syncCurveVisible)

		local connection

		if window == nil then
			connection = nil
		else
			connection = window:GetPropertyChangedSignal("Visible"):Connect(syncCurveVisible)
		end

		frame.Destroying:Connect(function()
			if connection then
				connection:Disconnect()
			end
		end)
		task.defer(syncCurveVisible)
	end

	local t5: {[any]: any} = {}
	local v57 = p3.tooltip
	local u58

	if v57 == nil then
		local tooltip: Frame = Instance.new("Frame")

		tooltip.Name = "Tooltip"
		tooltip.Visible = false
		tooltip.BorderSizePixel = 0
		tooltip.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
		tooltip.BackgroundTransparency = 0.08
		tooltip.AutomaticSize = Enum.AutomaticSize.XY
		tooltip.Size = UDim2.fromOffset(0, 0)
		tooltip.ZIndex = zIndex + 18

		local uiCorner: UICorner = Instance.new("UICorner")
		local uDimNew = UDim.new
		local rounded = math.round(scale * 6)

		uiCorner.CornerRadius = uDimNew(0, rounded)
		uiCorner.Parent = tooltip

		local uiStroke: UIStroke = Instance.new("UIStroke")

		uiStroke.Color = Color3.fromRGB(68, 68, 68)
		uiStroke.Thickness = 1
		uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		uiStroke.Parent = tooltip

		local uiPadding: UIPadding = Instance.new("UIPadding")
		local rounded6 = math.round(scale * 7)

		uiPadding.PaddingTop = UDim.new(0, rounded6)
		uiPadding.PaddingBottom = UDim.new(0, rounded6)
		uiPadding.PaddingLeft = UDim.new(0, rounded6 + 2)
		uiPadding.PaddingRight = UDim.new(0, rounded6 + 2)
		uiPadding.Parent = tooltip

		local uiListLayout: UIListLayout = Instance.new("UIListLayout")

		uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uiListLayout.FillDirection = Enum.FillDirection.Vertical
		uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left

		local v67 = UDim.new
		local rounded7 = math.round(scale * 1)

		uiListLayout.Padding = v67(0, rounded7)
		uiListLayout.Parent = tooltip

		local tipTemplate = p3.tipTemplate

		if tipTemplate ~= nil then
			for i, v in ipairs(p3.tipLines or {}) do
				local clone = tipTemplate:Clone()

				clone.Visible = true
				clone.LayoutOrder = i
				clone.AutomaticSize = Enum.AutomaticSize.XY
				clone.Size = UDim2.fromOffset(0, 0)
				clone.TextWrapped = false
				clone.RichText = true
				clone.TextXAlignment = Enum.TextXAlignment.Left
				clone.TextSize = math.round(v.size * scale)
				clone.TextColor3 = v.color
				clone.TextTransparency = 0
				clone.ZIndex = zIndex + 19
				clone.Parent = tooltip
				t5[i] = clone
			end
		end

		u58 = tooltip
	else
		u58 = v57.frame
		u58.Name = "Tooltip"
		u58.Visible = false
		u58.ZIndex = zIndex + 18
	end

	u58.Parent = frame

	local rounded = math.round(scale * 8)
	local v74 = math.max(7, rounded)
	local t6: {[any]: any} = {}
	local u76 = nil

	local function setHover(p11, p12)
		for k, v in pairs(t6) do
			local v134 = p12 and k == p11 and math.round(v74 * 1.5) or v74

			v.Size = UDim2.fromOffset(v134, v134)
		end

		if p12 and p11 then
			local v135 = points[p11]

			if p11 ~= u76 then
				u76 = p11

				if v57 ~= nil then
					v57.update(v135.data)
				elseif p3.formatTip ~= nil then
					local v136 = p3.formatTip(v135.data)

					for i, v in ipairs(t5) do
						local v139 = v136[i]

						v.Visible = v139 ~= nil
						v.Text = v139 or ""
					end
				end
			end

			local n4 = if #points == 1 then 0.5 else (p11 - 1) * 0.91 / (#points - 1) + 0.045
			local n2: number = 0.5

			if n4 < 0.18 then
				n2 = 0
			elseif n4 > 0.82 then
				n2 = 1
			end

			local n3 = if v135.y == nil then (1 - (p3.yMin - p3.yMin) / n1) * 0.8 + 0.1 else (1 - (v135.y - p3.yMin) / n1) * 0.8 + 0.1
			local rounded8 = math.round(scale * 10)

			if n3 < 0.45 then
				u58.AnchorPoint = Vector2.new(n2, 0)
				u58.Position = UDim2.new(n4, 0, n3, rounded8)
			else
				u58.AnchorPoint = Vector2.new(n2, 1)
				u58.Position = UDim2.new(n4, 0, n3, -rounded8)
			end

			u58.Visible = true

			return
		end

		u76 = nil
		u58.Visible = false
	end

	for i, v in ipairs(points) do
		if v.y ~= nil then
			local frame3: Frame = Instance.new("Frame")

			frame3.Name = if p3.pointName == nil then ("Pt%d"):format(i) else p3.pointName(v.data, i)
			frame3.BorderSizePixel = 0
			frame3.BackgroundColor3 = p3.lineColor
			frame3.AnchorPoint = Vector2.new(0.5, 0.5)
			frame3.Size = UDim2.fromOffset(v74, v74)
			frame3.Position = UDim2.fromScale(if #points == 1 then 0.5 else (i - 1) * 0.91 / (#points - 1) + 0.045, (1 - (v.y - p3.yMin) / n1) * 0.8 + 0.1)
			frame3.ZIndex = zIndex + 2

			local uiCorner: UICorner = Instance.new("UICorner")

			uiCorner.CornerRadius = UDim.new(1, 0)
			uiCorner.Parent = frame3
			frame3.Parent = frame
			t6[i] = frame3
		end
	end

	local markers = p3.markers

	if markers ~= nil and #markers > 0 then
		local rounded9 = math.round(scale * 5)
		local v84 = math.max(4, rounded9)
		local backgroundColor3 = p3.markerColor or p3.lineColor

		for i, v in ipairs(markers) do
			if typeof(v.x) == "number" and typeof(v.y) == "number" then
				local frame4: Frame = Instance.new("Frame")

				frame4.Name = ("Mk%d"):format(i)
				frame4.BorderSizePixel = 0
				frame4.BackgroundColor3 = backgroundColor3
				frame4.BackgroundTransparency = 0.25
				frame4.AnchorPoint = Vector2.new(0.5, 0.5)
				frame4.Size = UDim2.fromOffset(v84, v84)

				local uDim2FromScale = UDim2.fromScale
				local vX = v.x
				local v91 = math.max(1, #points)
				local v92 = math.clamp(vX, 1, v91)
				local v93 = math.clamp(v.y, p3.yMin, p3.yMax)

				frame4.Position = uDim2FromScale(if #points == 1 then 0.5 else (v92 - 1) * 0.91 / (#points - 1) + 0.045, (1 - (v93 - p3.yMin) / n1) * 0.8 + 0.1)
				frame4.ZIndex = zIndex + 1

				local uiCorner: UICorner = Instance.new("UICorner")

				uiCorner.CornerRadius = UDim.new(1, 0)
				uiCorner.Parent = frame4
				frame4.Parent = frame
			end
		end
	end

	local function pointFromX(p13)
		local n1 = p13 - frame.AbsolutePosition.X
		local v146 = math.max(1, frame.AbsoluteSize.X)
		local rounded10 = math.round((n1 / v146 - 0.045) / 0.91 * (#points - 1) + 1)

		return (math.clamp(rounded10, 1, #points))
	end
	local function overPlot(p14)
		if not frame.Parent or not frame.Visible then
		elseif p3.window == nil or p3.window.Visible then
			local frameAbsolutePosition: Vector2 = frame.AbsolutePosition
			local frameAbsoluteSize: Vector2 = frame.AbsoluteSize

			if p14.X < frameAbsolutePosition.X or p14.Y < frameAbsolutePosition.Y or p14.X > frameAbsolutePosition.X + frameAbsoluteSize.X or p14.Y > frameAbsolutePosition.Y + frameAbsoluteSize.Y then
				return false
			end

			local clipTo = p3.clipTo

			if clipTo == nil then
			elseif p14.X < clipTo.AbsolutePosition.X or p14.Y < clipTo.AbsolutePosition.Y or p14.X > clipTo.AbsolutePosition.X + clipTo.AbsoluteSize.X or p14.Y > clipTo.AbsolutePosition.Y + clipTo.AbsoluteSize.Y then
				return false
			end

			return true
		end

		return false
	end
	local function mousePoint()
		local v152: Vector2 = userInputService:GetMouseLocation()
		local v153 = guiService:GetGuiInset()

		return v152 - v153
	end

	local connection = userInputService.InputChanged:Connect(function(input: InputObject)
		if input.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end

		local v155: Vector2 = userInputService:GetMouseLocation()
		local v156 = guiService:GetGuiInset()
		local n1 = v155 - v156

		if overPlot(n1) then
			local n2 = n1.X - frame.AbsolutePosition.X
			local v159 = math.max(1, frame.AbsoluteSize.X)
			local rounded11 = math.round((n2 / v159 - 0.045) / 0.91 * (#points - 1) + 1)

			v159 = math.clamp(rounded11, 1, #points)
			setHover(v159, true)
		elseif u76 ~= nil then
			for _, v in pairs(t6) do
				local v163 = v74

				v.Size = UDim2.fromOffset(v163, v163)
			end

			u76 = nil
			u58.Visible = false
		end
	end)

	local connection2 = userInputService.InputBegan:Connect(function(input: InputObject)
		if input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		local vector2 = Vector2.new(input.Position.X, input.Position.Y)

		if overPlot(vector2) then
			local n1 = vector2.X - frame.AbsolutePosition.X
			local v167 = math.max(1, frame.AbsoluteSize.X)
			local rounded12 = math.round((n1 / v167 - 0.045) / 0.91 * (#points - 1) + 1)

			v167 = math.clamp(rounded12, 1, #points)
			setHover(v167, true)
		elseif u76 ~= nil then
			for _, v in pairs(t6) do
				local v171 = v74

				v.Size = UDim2.fromOffset(v171, v171)
			end

			u76 = nil
			u58.Visible = false
		end
	end)

	frame.Destroying:Connect(function()
		connection:Disconnect()
		connection2:Disconnect()
	end)

	return frame
end

return module
