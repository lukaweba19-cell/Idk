-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local t1: {[any]: any} = {}
local t2: {[any]: any} = {}
local u3 = nil
local CurrentCamera: Camera = workspace.CurrentCamera
local t3: {[any]: any} = {}
local t4: {[any]: any} = {}
local utility = require(script.Parent.Parent.Utility)
local u8: boolean = false
local u9: boolean = false
local u10 = nil
local module: {[any]: any} = {}

function module.start(p1)
	u10 = p1
	u3 = u10.iconsDictionary

	local v13 = nil

	for _, v in pairs(u10.container) do
		if v13 == nil and v.ScreenInsets == Enum.ScreenInsets.TopbarSafeInsets then
			v13 = v
		end

		for _, iterValue in pairs(v.Holders:GetChildren()) do
			if iterValue:GetAttribute("IsAHolder") then
				t1[iterValue.Name] = iterValue
			end
		end
	end

	local u18: boolean = false

	local v19 = utility.createStagger(0.1, function(p2)
		if not u18 then
			return
		end

		if not p2 then
			module.updateAvailableIcons("Center")
		end

		module.updateBoundary("Left")
		module.updateBoundary("Right")
	end)

	task.delay(0.5, function()
		u18 = true
		v19()
	end)
	task.delay(2, function()
		u8 = true
		v19()
	end)
	u10.iconAdded:Connect(v19)
	u10.iconRemoved:Connect(v19)
	u10.iconChanged:Connect(v19)
	CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		v19(true)
	end)
	v13:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		v19(true)
	end)
end
function module.getWidth(p3, _)
	local widget = p3.widget

	return widget:GetAttribute("TargetWidth") or widget.AbsoluteSize.X
end
function module.getAvailableIcons(p5)
	local v24 = t2[p5]

	if not v24 then
		v24 = module.updateAvailableIcons(p5)
	end

	return v24
end
function module.updateAvailableIcons(p6)
	local n1: number = 0
	local t6: {[any]: any} = {}

	for _, v in pairs(u3) do
		local vParentIconUID = v.parentIconUID

		if (not vParentIconUID or t4[vParentIconUID]) and p6 == v.alignment and not t4[v.UID] and v.isEnabled then
			table.insert(t6, v)
			n1 += 1
		end
	end

	if n1 <= 0 then
		return {}
	end

	table.sort(t6, function(p7, p8)
		local layoutOrder = p7.widget.LayoutOrder
		local v86 = p8.widget.LayoutOrder
		local parentIconUID = p7.parentIconUID
		local v88 = p8.parentIconUID

		if parentIconUID == v88 then
			if layoutOrder < v86 then
				return true
			end

			if layoutOrder > v86 then
				return false
			end

			return p7.widget.AbsolutePosition.X < p8.widget.AbsolutePosition.X
		end

		if v88 then
			return false
		end

		if parentIconUID then
			return true
		end

		return nil
	end)
	t2[p6] = t6

	return t6
end
function module.getRealXPositions(p9, p10)
	local u33: boolean = p9 == "Left"
	local v34 = t1[p9]
	local x = v34.AbsolutePosition.X
	local offset = v34.UIListLayout.Padding.Offset
	local v37 = u33 and x or x + v34.AbsoluteSize.X
	local t7: {[any]: any} = {}

	if u33 then
		utility.reverseTable(p10)
	end

	for i = #p10, 1, -1 do
		local v40 = p10[i]
		local v41 = module.getWidth(v40)

		if not u33 then
			v37 -= v41
		end

		t7[v40.UID] = v37

		if u33 then
			v37 += v41
		end

		v37 += u33 and offset or -offset
	end

	return t7
end
function module.updateBoundary(p11)
	local v43 = t1[p11]
	local uiListLayout = v43.UIListLayout
	local x = v43.AbsolutePosition.X
	local v46 = v43.AbsoluteSize.X
	local offset = uiListLayout.Padding.Offset
	local v48 = uiListLayout.Padding.Offset
	local v49 = module.updateAvailableIcons(p11)
	local n1 = 0
	local n2 = 0

	for _, v in pairs(v49) do
		local v54 = module.getWidth(v)

		n1 += v54 + v48
		n2 += 1
	end

	if n2 <= 0 then
		return
	end

	local u55: boolean = p11 == "Left"
	local u56: boolean = not u55
	local v57 = t3[p11]

	if not v57 and p11 ~= "Center" and #v49 > 0 then
		v57 = u10.new()
		v57:setImage(6069276526, "Deselected")
		v57:setName("Overflow" .. p11)
		v57:setOrder(if u55 then -9999999 else 9999999)
		v57:setAlignment(p11)
		v57:autoDeselect(false)
		v57.isAnOverflow = true
		v57:select("OverflowStart", v57)
		v57:setEnabled(false)
		t3[p11] = v57
		t4[v57.UID] = true

		if not u10.closeableOverflowMenus then
			v57:getInstance("IconSpot").Visible = false
		end
	end

	n2 = if p11 == "Left" then "Right" else "Left"

	local v58 = module.updateAvailableIcons(n2)
	local v59 = u55 and v58[1] or u56 and v58[#v58]
	local v60 = t3[n2]
	local n3 = u55 and x + v46 or x

	if v59 then
		local v62 = module.getRealXPositions(n2, v58)[v59.UID]
		local v63 = module.getWidth(v59)

		n3 = u55 and v62 - offset or v62 + v63 + offset
	end

	local n4: number = 0

	local function checkToShiftCentralIcon()
		local center = module.getAvailableIcons("Center")
		local v90 = center[if u55 then 1 else #center]

		local function secondaryCheck()
			if not u9 then
				u9 = true
				task.delay(3, module.updateBoundary, p11)
			end
		end

		if v90 and not v90.hasRelocatedInOverflow then
			local v92 = u55 and v49[#v49] or u56 and v49[1]
			local x = v90.widget.AbsolutePosition.X
			local v94 = v92.widget.AbsolutePosition.X
			local v95 = module.getWidth(v92)

			v92 = u55 and x - offset

			if not v92 then
				local v96 = module.getWidth(v90)

				v92 = x + v96 + offset
			end

			local n1 = u55 and v94 + v95 or v94

			v95 = false

			if not u55 then
				if u56 and v92 > n1 then
					if not u8 or n1 < 0 then
						if not u9 then
							u9 = true
							task.delay(3, module.updateBoundary, p11)
						end

						return
					end

					v90:align("Right")
					v90.hasRelocatedInOverflow = true
					v95 = true
				end
			elseif v92 < n1 then
				if not u8 then
					if not u9 then
						u9 = true
						task.delay(3, module.updateBoundary, p11)
					end

					return
				end

				v90:align("Left")
				v90.hasRelocatedInOverflow = true
				v95 = true
			end

			if v95 then
				n4 += 1

				if n4 <= 4 then
					module.updateAvailableIcons("Center")
					checkToShiftCentralIcon()
				end
			end

			return
		end
	end

	checkToShiftCentralIcon()

	if v57 then
		local v66 = v57:getInstance("Menu")
		local v67 = v46

		if v66 and v60 then
			local v68 = v60.widget.AbsolutePosition.X
			local v69 = module.getWidth(v60)
			local v70 = v60:getInstance("Menu")
			local n5 = x + v46 / 2
			local n6 = u55 and n5 - offset / 2 or n5 + offset / 2

			if v66.AbsoluteCanvasSize.X >= v70.AbsoluteCanvasSize.X then
				n6 = u55 and v68 - offset or v68 + v69 + offset
			end

			v67 = u55 and n6 - x or x + v46 - n6
		end

		local v73 = v66

		if v73 then
			v73 = v66:GetAttribute("MaxWidth")
		end

		local v74 = utility.round(v67)

		if v66 and v73 ~= v74 then
			v66:SetAttribute("MaxWidth", v74)
		end
	end

	v60 = false

	local v75 = module.getRealXPositions(p11, v49)

	for i = #v49, 1, -1 do
		local v77 = v49[i]
		local v78 = module.getWidth(v77)
		local v79 = v75[v77.UID]

		if u55 and n3 <= v79 + v78 or u56 and n3 >= v79 then
			v60 = true
		end
	end

	for i = #v49, 1, -1 do
		local v81 = v49[i]

		if not t4[v81.UID] then
			if v60 and not v81.parentIconUID then
				v81:joinMenu(v57)
			elseif not v60 and v81.parentIconUID then
				v81:leave()
			end
		end
	end

	if v60 ~= v57.isEnabled then
		v57:setEnabled(v60)
	end

	if v57.isEnabled and not v57.overflowAlreadyOpened then
		v57.overflowAlreadyOpened = true
		v57:select()
	end
end

return module
