-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local function windowAlong(p1, p2)
	local absoluteWindowSize = p1.AbsoluteWindowSize

	if p2.FillDirection == Enum.FillDirection.Horizontal then
		return absoluteWindowSize.X
	end

	return absoluteWindowSize.Y
end
local function onResize(p3, p4)
	p3:GetPropertyChangedSignal("AbsoluteSize"):Connect(p4)
	pcall(function()
		p3:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(p4)
	end)
end
local function bindGrid(p5, p6)
	local cellSize = p6.CellSize
	local cellPadding = p6.CellPadding

	if cellSize.X.Scale == 0 and cellSize.Y.Scale == 0 and cellPadding.X.Scale == 0 and cellPadding.Y.Scale == 0 then
		return
	end

	local uiAspectRatioConstraint = p6:FindFirstChildOfClass("UIAspectRatioConstraint")

	local function apply()
		local absoluteWindowSize = p5.AbsoluteWindowSize

		if absoluteWindowSize.X <= 0 or absoluteWindowSize.Y <= 0 then
			return
		end

		local n1 = cellSize.X.Scale * absoluteWindowSize.X + cellSize.X.Offset
		local n2 = cellSize.Y.Scale * absoluteWindowSize.Y + cellSize.Y.Offset

		if uiAspectRatioConstraint ~= nil and uiAspectRatioConstraint.AspectRatio > 0 then
			local uiAspectRatioConstraintAspectRatio = uiAspectRatioConstraint.AspectRatio

			if uiAspectRatioConstraint.AspectType == Enum.AspectType.FitWithinMaxSize then
				local v29 = math.min(n1, n2 * uiAspectRatioConstraintAspectRatio)

				n1 = v29
				n2 = v29 / uiAspectRatioConstraintAspectRatio
			elseif uiAspectRatioConstraint.DominantAxis == Enum.DominantAxis.Height then
				n1 = n2 * uiAspectRatioConstraintAspectRatio
			else
				n2 = n1 / uiAspectRatioConstraintAspectRatio
			end
		end

		local uDim2FromOffset = UDim2.fromOffset
		local floored = math.floor(n1)
		local floored2 = math.floor(n2)
		local uDim2 = uDim2FromOffset(floored, floored2)
		local v34 = UDim2.fromOffset
		local floored3 = math.floor(cellPadding.X.Scale * absoluteWindowSize.X + cellPadding.X.Offset)
		local floored4 = math.floor(cellPadding.Y.Scale * absoluteWindowSize.Y + cellPadding.Y.Offset)

		n2 = v34(floored3, floored4)

		if p6.CellSize ~= uDim2 then
			p6.CellSize = uDim2
		end

		if n2 ~= p6.CellPadding then
			p6.CellPadding = n2
		end
	end

	apply()
	p5:GetPropertyChangedSignal("AbsoluteSize"):Connect(apply)
	pcall(function()
		p5:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(apply)
	end)
end

local module: {[any]: any} = {
	bind = function(p7)
		local uiGridLayout = p7:FindFirstChildOfClass("UIGridLayout")

		if uiGridLayout then
			bindGrid(p7, uiGridLayout)

			return
		end

		local uiListLayout = p7:FindFirstChildOfClass("UIListLayout")

		if not uiListLayout then
			return
		end

		local scale = uiListLayout.Padding.Scale

		if scale == 0 then
			return
		end

		local offset = uiListLayout.Padding.Offset

		local function apply()
			local absoluteWindowSize = p7.AbsoluteWindowSize
			local v38 = if uiListLayout.FillDirection == Enum.FillDirection.Horizontal then absoluteWindowSize.X else absoluteWindowSize.Y

			if v38 <= 0 then
				return
			end

			local floored = math.floor(scale * v38 + offset + 0.5)

			if uiListLayout.Padding.Scale ~= 0 or floored ~= uiListLayout.Padding.Offset then
				uiListLayout.Padding = UDim.new(0, floored)
			end
		end

		apply()
		p7:GetPropertyChangedSignal("AbsoluteSize"):Connect(apply)
		pcall(function()
			p7:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(apply)
		end)
	end
}

function module.bindAll(p8)
	for _, v in ipairs(p8) do
		module.bind(v)
	end
end

return module
