-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")
local notePages = require(script.Parent:WaitForChild("NotePages"))
local module: {[any]: any} = {
	DEFAULT_FILL = table.freeze({
		Flow = 1.5,
		LeftPage = 0.44,
		RightPage = 0.3,
		StartX = 0.06,
		StartY = 1.25,
		Clip = false
	})
}

module.FILL = {
	Flow = module.DEFAULT_FILL.Flow,
	LeftPage = module.DEFAULT_FILL.LeftPage,
	RightPage = module.DEFAULT_FILL.RightPage,
	StartX = module.DEFAULT_FILL.StartX,
	StartY = module.DEFAULT_FILL.StartY,
	Clip = module.DEFAULT_FILL.Clip
}

local function writePart(p1)
	if not p1 then
		return nil
	end

	for _, v in ipairs(p1:GetChildren()) do
		if v.Name == "Write" and v:IsA("BasePart") then
			return v
		end
	end

	return nil
end
local function pageBox(p2, p3)
	if not p2 or not p3 then
		return nil, nil
	end

	if p3.SizingMode == Enum.SurfaceGuiSizingMode.FixedSize then
		local canvasSize = p3.CanvasSize

		if canvasSize.X > 0 and canvasSize.Y > 0 then
			return canvasSize.X, canvasSize.Y
		end

		return nil, nil
	end

	local v18 = p2.Size
	local face = p3.Face
	local v20
	local v21

	if face == Enum.NormalId.Front or face == Enum.NormalId.Back then
		v20 = v18.X
		v21 = v18.Y
	elseif face == Enum.NormalId.Left or face == Enum.NormalId.Right then
		v20 = v18.Z
		v21 = v18.Y
	else
		v20 = v18.X
		v21 = v18.Z
	end

	local pixelsPerStud = p3.PixelsPerStud

	if pixelsPerStud <= 0 then
		return nil, nil
	end

	return v20 * pixelsPerStud, v21 * pixelsPerStud
end
local function applyClip(p4, parent, p6)
	if not parent then
		return
	end

	local pageClip = parent:FindFirstChild("PageClip")

	if not p6 then
		if pageClip then
			if pageClip == p4.Parent then
				p4.Parent = parent
			end

			pageClip:Destroy()
		end

		return
	end

	if not pageClip then
		local pageClip2: Frame = Instance.new("Frame")

		pageClip2.Name = "PageClip"
		pageClip2.BackgroundTransparency = 1
		pageClip2.BorderSizePixel = 0
		pageClip2.Size = UDim2.fromScale(1, 1)
		pageClip2.Position = UDim2.fromScale(0, 0)
		pageClip2.ClipsDescendants = true
		pageClip2.Parent = parent
		pageClip = pageClip2
	end

	if pageClip ~= p4.Parent then
		p4.Parent = pageClip
	end
end
local function fitLabel(p7, p8, p9, p10)
	if p7:GetAttribute("NotePageFitted") then
		return
	end

	local v32, v33 = pageBox(p8, p9)

	if v32 and v33 and not (v32 <= 0) and not (v33 <= 0) then
		applyClip(p7, p9, module.FILL.Clip == true)

		local u34: boolean = math.abs((p7.Rotation % 180 + 180) % 180 - 90) < 45
		local n1 = (if u34 then v33 else v32) * module.FILL.Flow
		local n2 = (if u34 then v32 else v33) * (module.FILL[p10] or module.DEFAULT_FILL.RightPage)
		local textSize = p7.TextSize
		local v38 = math.max(p7.LineHeight, 0.01)
		local n3 = textSize * v38

		if n3 > 0 then
			local floored = math.floor(n2 / n3 + 0.5)

			n2 = math.max(1, floored) * n3
		end

		n3 = math.rad(p7.Rotation)

		local cosine = math.cos(n3)
		local sine = math.sin(n3)
		local sine2 = math.sin(n3)
		local cosine2 = math.cos(n3)
		local n4 = (module.FILL.StartX or 0.5) * v32 + n1 / 2 * cosine + n2 / 2 * -sine2
		local n5 = (module.FILL.StartY or 0.5) * v33 + n1 / 2 * sine + n2 / 2 * cosine2

		p7.Size = UDim2.fromScale(n1 / v32, n2 / v33)
		p7.AnchorPoint = Vector2.new(0.5, 0.5)
		p7.Position = UDim2.fromScale(n4 / v32, n5 / v33)
		p7.TextWrapped = true
		p7:SetAttribute("NotePageFitted", true)

		return
	end
end
local function resolve(p11, p12)
	if not p11 then
		return nil, nil, nil
	end

	local revolverRoot = p11:FindFirstChild("RevolverRoot")
	local v50 = revolverRoot and revolverRoot:FindFirstChild(p12)
	local v51 = writePart(v50)
	local surfaceGui = v51 and v51:FindFirstChildWhichIsA("SurfaceGui")
	local textLabel = surfaceGui and surfaceGui:FindFirstChildWhichIsA("TextLabel", true)

	if textLabel then
		fitLabel(textLabel, v51, surfaceGui, p12)
	end

	return v51, surfaceGui, textLabel
end
function module.Label(p13, p14)
	local v56, v57, v58 = resolve(p13, p14)

	return v58
end
function module.LabelBox(p15, p16)
	local v61, v62, v63 = resolve(p15, p16)

	if not v63 then
		return nil, 0, 0
	end

	local v64, v65 = pageBox(v61, v62)

	if v64 and v65 then
		return v63, v63.Size.X.Scale * v64 + v63.Size.X.Offset, v63.Size.Y.Scale * v65 + v63.Size.Y.Offset
	end

	return v63, 0, 0
end
function module.Refit(p17)
	for _, v in ipairs({ "LeftPage", "RightPage" }) do
		local v69 = module.Label(p17, v)

		if v69 then
			v69:SetAttribute("NotePageFitted", nil)
			module.Label(p17, v)
		end
	end
end
function module.IsNote(p18)
	local u71: boolean = true

	if module.Label(p18, "LeftPage") == nil then
		u71 = module.Label(p18, "RightPage") ~= nil
	end

	return u71
end

local t2: {[any]: any} = {}
local t3: {[any]: any} = {}

local function cancelTween(p19)
	local v73 = t3[p19]

	if v73 then
		v73:Cancel()
		t3[p19] = nil
	end
end
function module.SetLog(p20, text)
	local v76 = module.Label(p20, "LeftPage")

	if not v76 then
		return
	end

	local v77 = t3[v76]

	if v77 then
		v77:Cancel()
		t3[v76] = nil
	end

	v76.Text = text
	v76.TextTransparency = 0
end
function module.SetLogNames(p22, p23)
	local v80, v81, v82 = module.LabelBox(p22, "LeftPage")

	if not v80 then
		return
	end

	local n1 = (t2[v80] or 0) + 1

	t2[v80] = n1

	local v84 = table.clone(p23)

	task.spawn(function()
		local text = notePages.FitLog(v84, v80, v81, v82)

		if t2[v80] ~= n1 then
			return
		end

		if not v80.Parent then
			return
		end

		local v96 = v80
		local v97 = t3[v96]

		if v97 then
			v97:Cancel()
			t3[v96] = nil
		end

		v80.Text = text
		v80.TextTransparency = 0
	end)
end
function module.WriteRight(p24, text)
	local v87 = module.Label(p24, "RightPage")

	if not v87 then
		return
	end

	local v88 = t3[v87]

	if v88 then
		v88:Cancel()
		t3[v87] = nil
	end

	local n1 = (t2[v87] or 0) + 1

	t2[v87] = n1

	if text == "" then
		v87.Text = ""
		v87.TextTransparency = 0

		return
	end

	v87.Text = text
	v87.TextTransparency = 0
	task.delay(2, function()
		if t2[v87] ~= n1 then
			return
		end

		if not v87.Parent then
			return
		end

		local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
		local v99: Tween = tweenService:Create(v87, tweenInfo, { TextTransparency = 1 })

		t3[v87] = v99
		v99.Completed:Once(function()
			t3[v87] = nil

			if t2[v87] ~= n1 then
				return
			end

			if not v87.Parent then
				return
			end

			v87.Text = ""
			v87.TextTransparency = 0
		end)
		v99:Play()
	end)
end
function module.Blank(p26)
	for _, v in ipairs({ "LeftPage", "RightPage" }) do
		local v93 = module.Label(p26, v)

		if v93 then
			local v94 = t3[v93]

			if v94 then
				v94:Cancel()
				t3[v93] = nil
			end

			t2[v93] = (t2[v93] or 0) + 1
			v93.Text = ""
			v93.TextTransparency = 0
		end
	end
end

return module
