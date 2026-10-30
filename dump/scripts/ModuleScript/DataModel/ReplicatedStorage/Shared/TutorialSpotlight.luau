-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")
local runService: RunService = game:GetService("RunService")
local LocalPlayer: Player = game:GetService("Players").LocalPlayer
local playerGui: Instance = LocalPlayer:WaitForChild("PlayerGui")
local color3 = Color3.new(0, 0, 0)
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local color32 = Color3.fromRGB(0, 170, 255)
local module: {[any]: any} = {}

module.__index = module

local function makePanel(name, parent)
	local frame: Frame = Instance.new("Frame")

	frame.Name = name
	frame.BackgroundColor3 = color3
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.ZIndex = 1
	frame.Size = UDim2.new(0, 0, 0, 0)
	frame.Position = UDim2.new(0, 0, 0, 0)
	frame.Parent = parent

	return frame
end
local function isTargetVisible(p3)
	local v21 = p3

	while v21 do
		if not v21:IsA("GuiObject") then
			if v21:IsA("ScreenGui") and not v21.Enabled then
				return false
			end
		elseif not v21.Visible then
			return false
		end

		v21 = v21.Parent
	end

	return true
end
local function isInMatchFlow()
	if LocalPlayer:GetAttribute("MatchId") == nil then
		if LocalPlayer:GetAttribute("VotingPhase") == true then
			return true
		end

		return false
	end

	return true
end
function module.new()
	local tutorialSpotlight: ScreenGui = Instance.new("ScreenGui")

	tutorialSpotlight.Name = "TutorialSpotlight"
	tutorialSpotlight.DisplayOrder = 50
	tutorialSpotlight.ScreenInsets = Enum.ScreenInsets.None
	tutorialSpotlight.ResetOnSpawn = false
	tutorialSpotlight.Enabled = not (if LocalPlayer:GetAttribute("MatchId") == nil then LocalPlayer:GetAttribute("VotingPhase") == true else true)
	tutorialSpotlight.Parent = playerGui

	local hole: Frame = Instance.new("Frame")

	hole.Name = "Hole"
	hole.BackgroundTransparency = 1
	hole.BorderSizePixel = 0
	hole.ZIndex = 2
	hole.Parent = tutorialSpotlight

	local uiCorner: UICorner = Instance.new("UICorner")

	uiCorner.CornerRadius = UDim.new(0, 8)
	uiCorner.Parent = hole

	local uiStroke: UIStroke = Instance.new("UIStroke")

	uiStroke.Color = color32
	uiStroke.Thickness = 3
	uiStroke.Transparency = 1
	uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	uiStroke.Parent = hole

	local originRef: Frame = Instance.new("Frame")

	originRef.Name = "OriginRef"
	originRef.BackgroundTransparency = 1
	originRef.BorderSizePixel = 0
	originRef.Size = UDim2.new(0, 0, 0, 0)
	originRef.Position = UDim2.new(0, 0, 0, 0)
	originRef.ZIndex = 0
	originRef.Parent = tutorialSpotlight

	local v27 = makePanel("Top", tutorialSpotlight)
	local v28 = makePanel("Bottom", tutorialSpotlight)
	local v29 = makePanel("Left", tutorialSpotlight)
	local v30 = makePanel("Right", tutorialSpotlight)
	local object = setmetatable({
		trackConn = nil,
		matchConn = nil,
		voteConn = nil,
		currentTarget = nil,
		destroyed = false,
		overlayAlpha = 0,
		panelsHidden = false,
		suppressFade = false,
		gui = tutorialSpotlight,
		top = v27,
		bottom = v28,
		left = v29,
		right = v30,
		hole = hole,
		origin = originRef,
		stroke = uiStroke
	}, module)

	local function updateVisibility()
		if object.destroyed then
			return
		end

		object.gui.Enabled = not (if LocalPlayer:GetAttribute("MatchId") == nil then LocalPlayer:GetAttribute("VotingPhase") == true else true)
	end

	object.matchConn = LocalPlayer:GetAttributeChangedSignal("MatchId"):Connect(updateVisibility)
	object.voteConn = LocalPlayer:GetAttributeChangedSignal("VotingPhase"):Connect(updateVisibility)

	return object
end
local function getAbsoluteRect(p4, p5)
	local absolutePosition = p5.AbsolutePosition
	local absoluteSize = p5.AbsoluteSize
	local v37 = p4.origin.AbsolutePosition

	return absolutePosition.X - v37.X, absolutePosition.Y - v37.Y, absoluteSize.X, absoluteSize.Y
end
local function computeHoleRect(p6, p7, p8, p9)
	local absolutePosition = p7.AbsolutePosition
	local absoluteSize = p7.AbsoluteSize
	local v44 = p6.origin.AbsolutePosition
	local n1 = absolutePosition.Y - v44.Y
	local absoluteSizeX = absoluteSize.X
	local absoluteSizeY = absoluteSize.Y
	local v48 = math.max(0, absolutePosition.X - v44.X - 10)
	local rounded = math.round(v48)
	local v50 = math.max(0, n1 - 10)
	local rounded2 = math.round(v50)

	v50 = math.min(p8 - rounded, absoluteSizeX + 20)

	local rounded3 = math.round(v50)

	v50 = math.min(p9 - rounded2, absoluteSizeY + 20)

	local rounded4 = math.round(v50)

	return rounded, rounded2, rounded3, rounded4
end
local function setPanelLayout(p10, p11, p12, p13, p14, p15, p16)
	local rounded = math.round(p15)
	local rounded5 = math.round(p16)

	p10.top.Position = UDim2.new(0, 0, 0, 0)
	p10.top.Size = UDim2.new(0, rounded, 0, p12)
	p10.bottom.Position = UDim2.new(0, 0, 0, p12 + p14)

	local bottom = p10.bottom
	local uDim2New = UDim2.new
	local v65 = math.max(0, rounded5 - p12 - p14)

	bottom.Size = uDim2New(0, rounded, 0, v65)
	p10.left.Position = UDim2.new(0, 0, 0, p12)
	p10.left.Size = UDim2.new(0, p11, 0, p14)
	p10.right.Position = UDim2.new(0, p11 + p13, 0, p12)

	local right = p10.right
	local v67 = UDim2.new
	local v68 = math.max(0, rounded - p11 - p13)

	right.Size = v67(0, v68, 0, p14)
	p10.hole.Position = UDim2.new(0, p11, 0, p12)
	p10.hole.Size = UDim2.new(0, p13, 0, p14)
end
local function tweenPanelLayout(p17, p18, p19, p20, p21, p22, p23)
	local rounded = math.round(p22)
	local rounded6 = math.round(p23)
	local top = p17.top
	local uDim2 = UDim2.new(0, rounded, 0, p19)
	local bottom = p17.bottom
	local uDim22 = UDim2.new(0, 0, 0, p19 + p21)
	local uDim2New = UDim2.new
	local v83 = math.max(0, rounded6 - p19 - p21)
	local v84 = uDim2New(0, rounded, 0, v83)
	local left = p17.left
	local uDim23 = UDim2.new(0, 0, 0, p19)
	local uDim24 = UDim2.new(0, p18, 0, p21)
	local right = p17.right
	local uDim25 = UDim2.new(0, p18 + p20, 0, p19)
	local v90 = UDim2.new

	v83 = math.max(0, rounded - p18 - p20)

	local v91 = v90(0, v83, 0, p21)
	local hole = p17.hole
	local uDim26 = UDim2.new(0, p18, 0, p19)
	local uDim27 = UDim2.new(0, p20, 0, p21)

	for _, v in ipairs({
		{ obj = top, pos = UDim2.new(0, 0, 0, 0), size = uDim2 },
		{ obj = bottom, pos = uDim22, size = v84 },
		{ obj = left, pos = uDim23, size = uDim24 },
		{ obj = right, pos = uDim25, size = v91 },
		{ obj = hole, pos = uDim26, size = uDim27 }
	}) do
		tweenService:Create(v.obj, tweenInfo, { Position = v.pos, Size = v.size }):Play()
	end
end
local function setOverlayTransparency(p24, backgroundTransparency)
	for _, v in ipairs({ p24.top, p24.bottom, p24.left, p24.right }) do
		v.BackgroundTransparency = backgroundTransparency
	end
end
function module.pointAt(p26, p27, p28)
	if p26.destroyed then
		return
	end

	local u104: boolean = p26.currentTarget == nil

	p26.currentTarget = p27

	if p26.trackConn then
		p26.trackConn:Disconnect()
		p26.trackConn = nil
	end

	local absoluteSize = p26.gui.AbsoluteSize

	if u104 or p28 then
		local absoluteSizeX = absoluteSize.X
		local absoluteSizeY = absoluteSize.Y

		if absoluteSizeX > 0 and absoluteSizeY > 0 then
			local absolutePosition = p27.AbsolutePosition
			local v109 = p27.AbsoluteSize
			local v110 = p26.origin.AbsolutePosition
			local n1 = absolutePosition.Y - v110.Y
			local x = v109.X
			local y = v109.Y
			local v114 = math.max(0, absolutePosition.X - v110.X - 10)
			local rounded = math.round(v114)
			local v116 = math.max(0, n1 - 10)
			local rounded7 = math.round(v116)

			v116 = math.min(absoluteSizeX - rounded, x + 20)

			local rounded8 = math.round(v116)

			v116 = math.min(absoluteSizeY - rounded7, y + 20)

			local rounded9 = math.round(v116)

			setPanelLayout(p26, rounded, rounded7, rounded8, rounded9, absoluteSizeX, absoluteSizeY)
		end
	end

	p26.trackConn = runService.Heartbeat:Connect(function()
		if not not p26.destroyed or not p27 or not p27.Parent then
			return
		end

		absoluteSize = p26.gui.AbsoluteSize

		local absoluteSizeX = absoluteSize.X
		local absoluteSizeY = absoluteSize.Y

		if absoluteSizeX <= 0 or absoluteSizeY <= 0 then
			return
		end

		local v150 = isTargetVisible(p27)

		if not v150 and not p26.panelsHidden and not p26.suppressFade then
			p26.panelsHidden = true

			local tweenInfo2 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

			for _, v in ipairs({ p26.top, p26.bottom, p26.left, p26.right }) do
				tweenService:Create(v, tweenInfo2, { BackgroundTransparency = 1 }):Play()
			end

			tweenService:Create(p26.stroke, tweenInfo2, { Transparency = 1 }):Play()

			return
		end

		if v150 and p26.panelsHidden then
			p26.panelsHidden = false

			local tweenInfo3 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

			for _, v in ipairs({ p26.top, p26.bottom, p26.left, p26.right }) do
				tweenService:Create(v, tweenInfo3, { BackgroundTransparency = 0.375 }):Play()
			end

			tweenService:Create(p26.stroke, tweenInfo3, { Transparency = 0 }):Play()
		end

		if p26.panelsHidden then
			return
		end

		local v157 = p27
		local absolutePosition = v157.AbsolutePosition
		local absoluteSize2 = v157.AbsoluteSize
		local v160 = p26.origin.AbsolutePosition
		local n1 = absolutePosition.Y - v160.Y
		local x = absoluteSize2.X
		local y = absoluteSize2.Y
		local v164 = math.max(0, absolutePosition.X - v160.X - 10)
		local rounded = math.round(v164)
		local v166 = math.max(0, n1 - 10)
		local rounded10 = math.round(v166)

		v166 = math.min(absoluteSizeX - rounded, x + 20)

		local rounded11 = math.round(v166)

		v166 = math.min(absoluteSizeY - rounded10, y + 20)

		local rounded12 = math.round(v166)

		setPanelLayout(p26, rounded, rounded10, rounded11, rounded12, absoluteSizeX, absoluteSizeY)
	end)

	if not u104 and not p28 then
		local v120 = absoluteSize.X
		local v121 = absoluteSize.Y

		if v120 > 0 and v121 > 0 then
			local v122 = p27.AbsolutePosition
			local v123 = p27.AbsoluteSize
			local v124 = p26.origin.AbsolutePosition
			local n2 = v122.Y - v124.Y
			local v126 = v123.X
			local v127 = v123.Y
			local v128 = math.max(0, v122.X - v124.X - 10)
			local rounded = math.round(v128)
			local v130 = math.max(0, n2 - 10)
			local rounded13 = math.round(v130)

			v130 = math.min(v120 - rounded, v126 + 20)

			local rounded14 = math.round(v130)

			v130 = math.min(v121 - rounded13, v127 + 20)

			local rounded15 = math.round(v130)

			tweenPanelLayout(p26, rounded, rounded13, rounded14, rounded15, v120, v121)
		end

		if p26.trackConn then
			p26.trackConn:Disconnect()
			p26.trackConn = nil
		end

		task.delay(0.3, function()
			if not p26.destroyed and p26.currentTarget == p27 then
				p26.trackConn = runService.Heartbeat:Connect(function()
					if not not p26.destroyed or not p27 or not p27.Parent then
						return
					end

					absoluteSize = p26.gui.AbsoluteSize

					local absoluteSizeX = absoluteSize.X
					local absoluteSizeY = absoluteSize.Y

					if absoluteSizeX <= 0 or absoluteSizeY <= 0 then
						return
					end

					local v172 = isTargetVisible(p27)

					if not v172 and not p26.panelsHidden and not p26.suppressFade then
						p26.panelsHidden = true

						local tweenInfo4 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

						for _, v in ipairs({ p26.top, p26.bottom, p26.left, p26.right }) do
							tweenService:Create(v, tweenInfo4, { BackgroundTransparency = 1 }):Play()
						end

						tweenService:Create(p26.stroke, tweenInfo4, { Transparency = 1 }):Play()

						return
					end

					if v172 and p26.panelsHidden then
						p26.panelsHidden = false

						local tweenInfo5 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

						for _, v in ipairs({ p26.top, p26.bottom, p26.left, p26.right }) do
							tweenService:Create(v, tweenInfo5, { BackgroundTransparency = 0.375 }):Play()
						end

						tweenService:Create(p26.stroke, tweenInfo5, { Transparency = 0 }):Play()
					end

					if p26.panelsHidden then
						return
					end

					local v179 = p27
					local absolutePosition = v179.AbsolutePosition
					local absoluteSize2 = v179.AbsoluteSize
					local v182 = p26.origin.AbsolutePosition
					local n1 = absolutePosition.Y - v182.Y
					local x = absoluteSize2.X
					local y = absoluteSize2.Y
					local v186 = math.max(0, absolutePosition.X - v182.X - 10)
					local rounded = math.round(v186)
					local v188 = math.max(0, n1 - 10)
					local rounded16 = math.round(v188)

					v188 = math.min(absoluteSizeX - rounded, x + 20)

					local rounded17 = math.round(v188)

					v188 = math.min(absoluteSizeY - rounded16, y + 20)

					local rounded18 = math.round(v188)

					setPanelLayout(p26, rounded, rounded16, rounded17, rounded18, absoluteSizeX, absoluteSizeY)
				end)

				return
			end
		end)
	end
end
function module.setSuppressFade(p29, p30)
	p29.suppressFade = p30
end
function module.fadeIn(p31, p32)
	if p31.destroyed then
		return
	end

	local tweenInfo6 = TweenInfo.new(p32 or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	p31.overlayAlpha = 0.375

	for _, v in ipairs({ p31.top, p31.bottom, p31.left, p31.right }) do
		tweenService:Create(v, tweenInfo6, { BackgroundTransparency = 0.375 }):Play()
	end

	tweenService:Create(p31.stroke, tweenInfo6, { Transparency = 0 }):Play()
end
function module.fadeOut(p33, p34)
	if p33.destroyed then
		return
	end

	local v143 = p34 or 0.3
	local tweenInfo7 = TweenInfo.new(v143, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

	for _, v in ipairs({ p33.top, p33.bottom, p33.left, p33.right }) do
		tweenService:Create(v, tweenInfo7, { BackgroundTransparency = 1 }):Play()
	end

	tweenService:Create(p33.stroke, tweenInfo7, { Transparency = 1 }):Play()
	task.delay(v143, function()
		p33:destroy()
	end)
end
function module.destroy(p35)
	if p35.destroyed then
		return
	end

	p35.destroyed = true

	if p35.trackConn then
		p35.trackConn:Disconnect()
		p35.trackConn = nil
	end

	if p35.matchConn then
		p35.matchConn:Disconnect()
		p35.matchConn = nil
	end

	if p35.voteConn then
		p35.voteConn:Disconnect()
		p35.voteConn = nil
	end

	p35.gui:Destroy()
end

return module
