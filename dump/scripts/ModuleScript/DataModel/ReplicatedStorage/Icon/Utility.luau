-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local LocalPlayer: Player = game:GetService("Players").LocalPlayer

local module: {[any]: any} = {
	createStagger = function(p1: number, p2, p3)
		local u10: boolean = false
		local u11: boolean = false

		if not p1 or p1 == 0 then
			p1 = 0.01
		end

		local function staggeredCallback(...)
			if u10 then
				u11 = true

				return
			end

			local v79 = table.pack(...)

			u10 = true
			u11 = false
			task.spawn(function()
				if p3 then
					task.wait(p1)
				end

				p2(table.unpack(v79))
			end)
			task.delay(p1, function()
				u10 = false

				if u11 then
					staggeredCallback(table.unpack(v79))
				end
			end)
		end

		return staggeredCallback
	end,
	round = function(p4)
		return (math.floor(p4 + 0.5))
	end,
	reverseTable = function(p5)
		for i = 1, math.floor(#p5 / 2) do
			local n1: number = #p5 - i + 1
			local v17 = p5[i]

			p5[i] = p5[n1]
			p5[n1] = v17
		end
	end
}

function module.copyTable(p6)
	local typeName: string = type(p6)

	assert(typeName == "table", "First argument must be a table")

	local v20 = table.create(#p6)

	for k, v in pairs(p6) do
		if type(v) == "table" then
			v20[k] = module.copyTable(v)
		else
			v20[k] = v
		end
	end

	return v20
end

local t2: {[any]: any} = {
	"a",
	"b",
	"c",
	"d",
	"e",
	"f",
	"g",
	"h",
	"i",
	"j",
	"k",
	"l",
	"m",
	"n",
	"o",
	"p",
	"q",
	"r",
	"s",
	"t",
	"u",
	"v",
	"w",
	"x",
	"y",
	"z",
	"A",
	"B",
	"C",
	"D",
	"E",
	"F",
	"G",
	"H",
	"I",
	"J",
	"K",
	"L",
	"M",
	"N",
	"O",
	"P",
	"Q",
	"R",
	"S",
	"T",
	"U",
	"V",
	"W",
	"X",
	"Y",
	"Z",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"0",
	"<",
	">",
	"?",
	"@",
	"{",
	"}",
	"[",
	"]",
	"!",
	"(",
	")",
	"=",
	"+",
	"~",
	"#"
}

function module.generateUID(p7)
	local s1: string = ""
	local v25: {[any]: any} = t2

	for _ = 1, p7 or 8 do
		local randomNumber = math.random(1, #v25)

		s1 ..= v25[randomNumber]
	end

	return s1
end

local t3: {[any]: any} = {}

function module.setVisible(p8, p9, p10)
	local t4 = t3[p8]

	if not t4 then
		t4 = {}
		t3[p8] = t4
		p8.Destroying:Once(function()
			t3[p8] = nil
		end)
	end

	if not p9 then
		t4[p10] = true
	else
		t4[p10] = nil
	end

	local v32 = p9

	if p9 then
		for _, _ in pairs(t4) do
			v32 = false

			break
		end
	end

	p8.Visible = v32
end
function module.formatStateName(p11)
	local stringUpper = string.upper
	local v37 = string.sub(p11, 1, 1)
	local v38 = stringUpper(v37)
	local stringLower = string.lower
	local v40 = string.sub(p11, 2)

	v37 = stringLower(v40)

	return v38 .. v37
end
function module.localPlayerRespawned(p12)
	LocalPlayer.CharacterRemoving:Connect(p12)
end
function module.getClippedContainer(parent)
	local clippedContainer = parent:FindFirstChild("ClippedContainer")

	if not clippedContainer then
		clippedContainer = Instance.new("Folder")
		clippedContainer.Name = "ClippedContainer"
		clippedContainer.Parent = parent
	end

	return clippedContainer
end

local janitor = require(script.Parent.Packages.Janitor)
local guiService: GuiService = game:GetService("GuiService")

function module.clipOutside(p14, p15)
	local v46 = p14.janitor:add(janitor.new())

	p15.Destroying:Once(function()
		v46:Destroy()
	end)
	p14.janitor:add(p15)

	local parent = p15.Parent
	local v48 = v46:add(Instance.new("Frame"))

	v48:SetAttribute("IsAClippedClone", true)
	v48.Name = p15.Name
	v48.AnchorPoint = p15.AnchorPoint
	v48.Size = p15.Size
	v48.Position = p15.Position
	v48.BackgroundTransparency = 1
	v48.LayoutOrder = p15.LayoutOrder
	v48.Parent = parent

	local originalInstance: ObjectValue = Instance.new("ObjectValue")

	originalInstance.Name = "OriginalInstance"
	originalInstance.Value = p15
	originalInstance.Parent = v48

	local clone: Instance = originalInstance:Clone()

	p15:SetAttribute("HasAClippedClone", true)
	clone.Name = "ClippedClone"
	clone.Value = v48
	clone.Parent = p15

	local u51 = nil
	local iconModule = require(p14.iconModule)
	local iconModuleContainer = iconModule.container

	local function updateScreenGui()
		local v80 = parent:FindFirstAncestorWhichIsA("ScreenGui")

		u51 = if string.match(v80.Name, "Clipped") then v80 else iconModuleContainer[v80.Name .. "Clipped"]
		p15.AnchorPoint = Vector2.new(0, 0)
		p15.Parent = module.getClippedContainer(u51)
	end

	v46:add(p14.alignmentChanged:Connect(updateScreenGui))
	updateScreenGui()

	for _, v in pairs(p15:GetChildren()) do
		if v:IsA("UIAspectRatioConstraint") then
			local clone2 = v:Clone()

			clone2.Parent = v48
		end
	end

	local widget = p14.widget
	local u59 = false
	local ignoreVisibilityUpdater = p15:GetAttribute("IgnoreVisibilityUpdater")
	local v61 = widget:GetPropertyChangedSignal("Visible")

	v46:add(v61:Connect(function()
		if ignoreVisibilityUpdater then
			return
		end

		local v81 = widget.Visible

		if u59 then
			v81 = false
		end

		module.setVisible(p15, v81, "ClipHandler")
	end))

	local u62 = nil

	local function checkIfOutsideParentXBounds()
		task.defer(function()
			local v112 = nil
			local uid = p14.UID
			local v114 = uid

			if p15:GetAttribute("ClipToJoinedParent") then
				for _ = 1, 10 do
					local v116 = iconModule.getIconByUID(v114)

					if not v116 then
						break
					end

					local joinedFrame = v116.joinedFrame

					v114 = v116.parentIconUID

					if not joinedFrame then
						break
					end

					v112 = joinedFrame

					if v112 and v112.Name == "DropdownScroller" then
						break
					end
				end
			end

			if not v112 then
				u59 = false

				if ignoreVisibilityUpdater then
					return
				end

				local v118 = widget.Visible

				if u59 then
					v118 = false
				end

				module.setVisible(p15, v118, "ClipHandler")

				return
			end

			local absolutePosition = v112.AbsolutePosition
			local absoluteSize = v112.AbsoluteSize
			local n1 = p15.AbsolutePosition + p15.AbsoluteSize / 2

			n1 = n1.X < absolutePosition.X or n1.X > absolutePosition.X + absoluteSize.X or n1.Y < absolutePosition.Y or n1.Y > absolutePosition.Y + absoluteSize.Y

			if n1 ~= u59 then
				u59 = n1

				if not ignoreVisibilityUpdater then
					local v122 = widget.Visible

					if u59 then
						v122 = false
					end

					module.setVisible(p15, v122, "ClipHandler")
				end
			end

			if v112:IsA("ScrollingFrame") and v112 ~= u62 then
				u62 = v112

				local connection = v112:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
					checkIfOutsideParentXBounds()
				end)

				v46:add(connection, "Disconnect", "TrackUtilityScroller-" .. uid)
			end
		end)
	end

	local CurrentCamera: Camera = workspace.CurrentCamera
	local v65 = p15:GetAttribute("AdditionalOffsetX") or 0

	local function trackProperty(p16)
		local s1: string = "Absolute" .. p16

		local function updateProperty()
			local v124 = v48[s1]
			local v125 = UDim2.fromOffset(v124.X, v124.Y)

			if p16 == "Position" then
				local n1 = CurrentCamera.ViewportSize.X - p15.AbsoluteSize.X - 4
				local v127 = v125.X.Offset

				if v127 < 4 then
					v127 = 4
				elseif n1 < v127 then
					v127 = n1
				end

				local v128 = UDim2.fromOffset(v127, v125.Y.Offset)
				local v129 = UDim2.fromOffset(-((if iconModule.isOldTopbar then u51.AbsolutePosition.X else workspace.CurrentCamera.ViewportSize.X - u51.AbsoluteSize.X - 0) - v65), guiService.TopbarInset.Height)

				v125 = v128 + v129
				task.defer(function()
					local v130 = nil
					local uid = p14.UID
					local v132 = uid

					if p15:GetAttribute("ClipToJoinedParent") then
						for _ = 1, 10 do
							local v134 = iconModule.getIconByUID(v132)

							if not v134 then
								break
							end

							local joinedFrame = v134.joinedFrame

							v132 = v134.parentIconUID

							if not joinedFrame then
								break
							end

							v130 = joinedFrame

							if v130 and v130.Name == "DropdownScroller" then
								break
							end
						end
					end

					if not v130 then
						u59 = false

						if ignoreVisibilityUpdater then
							return
						end

						local v136 = widget.Visible

						if u59 then
							v136 = false
						end

						module.setVisible(p15, v136, "ClipHandler")

						return
					end

					local absolutePosition = v130.AbsolutePosition
					local absoluteSize = v130.AbsoluteSize
					local n1 = p15.AbsolutePosition + p15.AbsoluteSize / 2

					n1 = n1.X < absolutePosition.X or n1.X > absolutePosition.X + absoluteSize.X or n1.Y < absolutePosition.Y or n1.Y > absolutePosition.Y + absoluteSize.Y

					if n1 ~= u59 then
						u59 = n1

						if not ignoreVisibilityUpdater then
							local v140 = widget.Visible

							if u59 then
								v140 = false
							end

							module.setVisible(p15, v140, "ClipHandler")
						end
					end

					if v130:IsA("ScrollingFrame") and v130 ~= u62 then
						u62 = v130

						local connection = v130:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
							checkIfOutsideParentXBounds()
						end)

						v46:add(connection, "Disconnect", "TrackUtilityScroller-" .. uid)
					end
				end)
			end

			p15[p16] = v125
		end

		local v85 = module.createStagger(0.01, updateProperty)
		local v86 = v48:GetPropertyChangedSignal(s1)

		v46:add(v86:Connect(v85))
		v86 = v48:GetAttributeChangedSignal("ForceUpdate")
		v46:add(v86:Connect(function()
			v85()
		end))

		local v87 = module.createStagger(0.5, updateProperty, true)
		local v88 = v48:GetPropertyChangedSignal(s1)

		v46:add(v88:Connect(v87))

		if p16 == "Position" then
			local v89 = u51:GetPropertyChangedSignal("AbsoluteSize")

			v46:add(v89:Connect(function()
				v85()
			end))
		end
	end

	task.delay(0.1, checkIfOutsideParentXBounds)
	task.defer(function()
		local v90 = nil
		local uid = p14.UID
		local v92 = uid

		if p15:GetAttribute("ClipToJoinedParent") then
			for _ = 1, 10 do
				local v94 = iconModule.getIconByUID(v92)

				if not v94 then
					break
				end

				local joinedFrame = v94.joinedFrame

				v92 = v94.parentIconUID

				if not joinedFrame then
					break
				end

				v90 = joinedFrame

				if v90 and v90.Name == "DropdownScroller" then
					break
				end
			end
		end

		if not v90 then
			u59 = false

			if ignoreVisibilityUpdater then
				return
			end

			local v96 = widget.Visible

			if u59 then
				v96 = false
			end

			module.setVisible(p15, v96, "ClipHandler")

			return
		end

		local absolutePosition = v90.AbsolutePosition
		local absoluteSize = v90.AbsoluteSize
		local n1 = p15.AbsolutePosition + p15.AbsoluteSize / 2

		n1 = n1.X < absolutePosition.X or n1.X > absolutePosition.X + absoluteSize.X or n1.Y < absolutePosition.Y or n1.Y > absolutePosition.Y + absoluteSize.Y

		if n1 ~= u59 then
			u59 = n1

			if not ignoreVisibilityUpdater then
				local v100 = widget.Visible

				if u59 then
					v100 = false
				end

				module.setVisible(p15, v100, "ClipHandler")
			end
		end

		if v90:IsA("ScrollingFrame") and v90 ~= u62 then
			u62 = v90

			local connection = v90:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
				checkIfOutsideParentXBounds()
			end)

			v46:add(connection, "Disconnect", "TrackUtilityScroller-" .. uid)
		end
	end)

	if not ignoreVisibilityUpdater then
		local v67 = widget.Visible

		if u59 then
			v67 = false
		end

		module.setVisible(p15, v67, "ClipHandler")
	end

	trackProperty("Position")

	local v68 = p15:GetPropertyChangedSignal("Visible")

	v46:add(v68:Connect(function()
	end))

	if p15:GetAttribute("TrackCloneSize") then
		trackProperty("Size")
	else
		local v69 = p15:GetPropertyChangedSignal("AbsoluteSize")

		v46:add(v69:Connect(function()
			local absoluteSize = p15.AbsoluteSize

			v48.Size = UDim2.fromOffset(absoluteSize.X, absoluteSize.Y)
		end))
	end

	return v48
end
function module.joinFeature(p17, p18, p19, p20)
	local joinJanitor = p17.joinJanitor

	joinJanitor:clean()

	if not p20 then
		p17:leave()

		return
	end

	p17.parentIconUID = p18.UID
	p17.joinedFrame = p20
	joinJanitor:add(p18.alignmentChanged:Connect(function()
		local v103 = p18.alignment

		if v103 == "Center" then
			v103 = "Left"
		end

		p17:setAlignment(v103, true)
	end))

	local v75 = p18.alignment

	if v75 == "Center" then
		v75 = "Left"
	end

	p17:setAlignment(v75, true)
	p17:modifyTheme({ "IconButton", "BackgroundTransparency", 1 }, "JoinModification")
	p17:modifyTheme({ "ClickRegion", "Active", false }, "JoinModification")

	if p18.childModifications then
		task.defer(function()
			p17:modifyTheme(p18.childModifications, p18.childModificationsUID)
		end)
	end

	local v76 = p17:getInstance("ClickRegion")

	local function makeSelectable()
		v76.Selectable = p18.isSelected
	end

	joinJanitor:add(p18.toggled:Connect(makeSelectable))
	task.defer(makeSelectable)
	joinJanitor:add(function()
		v76.Selectable = true
	end)

	local uid = p17.UID

	table.insert(p19, uid)
	p18:autoDeselect(false)
	p18.childIconsDict[uid] = true

	if not p18.isEnabled then
		p18:setEnabled(true)
	end

	p17.joinedParent:Fire(p18)
	joinJanitor:add(function()
		if not p17.joinedFrame then
			return
		end

		for k, v in pairs(p19) do
			if v == uid then
				table.remove(p19, k)

				break
			end
		end

		local v106 = require(p17.iconModule).getIconByUID(p17.parentIconUID)

		if not v106 then
			return
		end

		p17:setAlignment(p17.originalAlignment)
		p17.parentIconUID = false
		p17.joinedFrame = false
		p17:removeModification("JoinModification")

		local u107: boolean = true
		local childIconsDict = v106.childIconsDict

		childIconsDict[uid] = nil

		for _, _ in pairs(childIconsDict) do
			u107 = false

			break
		end

		if u107 and not v106.isAnOverflow then
			v106:setEnabled(false)
		end

		local v111 = p18.alignment

		if v111 == "Center" then
			v111 = "Left"
		end

		p17:setAlignment(v111, true)
	end)
end

return module
