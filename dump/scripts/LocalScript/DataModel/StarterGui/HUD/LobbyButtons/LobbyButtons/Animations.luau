-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")
local runService: RunService = game:GetService("RunService")
local scriptParent: Instance = script.Parent
local tweenInfo = TweenInfo.new(0.14, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo3 = TweenInfo.new(0.14, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenInfo4 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local tweenInfo5 = TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local vector2 = Vector2.new(0, -1)
local vector22 = Vector2.new(0, 2)
local t1: {[any]: any} = {}
local t2: {[any]: any} = {}
local t3: {[any]: any} = {}
local t4: {[any]: any} = {}

local function scaledUDim2(p1, p2)
	local uDim2New = UDim2.new
	local n1 = p1.X.Scale * p2
	local floored = math.floor(p1.X.Offset * p2)
	local n2 = p1.Y.Scale * p2
	local floored2 = math.floor(p1.Y.Offset * p2)

	return uDim2New(n1, floored, n2, floored2)
end
local function scaleY(p3, p4)
	local uDim2New = UDim2.new
	local scale = p3.X.Scale
	local offset = p3.X.Offset
	local n1 = p3.Y.Scale * p4
	local floored = math.floor(p3.Y.Offset * p4)

	return uDim2New(scale, offset, n1, floored)
end
local function cancelTween(p5)
	if p5 then
		p5:Cancel()
	end
end
local function tweenGuiSize(p6, p7, p8, p9, p10)
	local v48 = p9[p6]

	if not v48 then
		return
	end

	local v49 = v48[p10]

	if v49 then
		v49:Cancel()
	end

	v49 = tweenService:Create(p6, p7, { Size = p8 })
	v48[p10] = v49
	v49:Play()
end
local function tweenTextSize(p11, p12, p13)
	local v53 = t2[p11]

	if not v53 then
		return
	end

	local tw = v53.tw

	if tw then
		tw:Cancel()
	end

	local v55: Tween = tweenService:Create(v53.lbl, p12, { Size = p13 })

	v53.tw = v55
	v55:Play()
end
local function collectStrokeGradients(p14)
	for iterFirst, iterSecond in p14:GetDescendants() do
		if iterSecond:IsA("UIStroke") or iterSecond.Name == "DETAIL" then
			for iterFirst2, iterSecond2 in iterSecond:GetChildren() do
				if iterSecond2:IsA("UIGradient") then
					table.insert(t4, iterSecond2)
				end
			end
		end
	end
end
local function findShineGradient(p15)
	local foundChild = p15:FindFirstChild("ShineAnimate", true)

	if not foundChild then
		return nil
	end

	return (foundChild:FindFirstChildOfClass("UIGradient"))
end
local function findBtnTextLabel(p16)
	local foundChild = p16:FindFirstChild("TextLabel", true)

	if foundChild and foundChild:IsA("TextLabel") then
		return foundChild
	end

	return nil
end
local function playShine(p17)
	local v66 = t3[p17]

	if not v66 then
		return
	end

	local tw = v66.tw

	if tw then
		tw:Cancel()
	end

	v66.tw = nil
	v66.grad.Offset = vector2

	local v68: Tween = tweenService:Create(v66.grad, tweenInfo5, { Offset = vector22 })

	v66.tw = v68
	v68:Play()
	v68.Completed:Connect(function()
		if t3[p17] == v66 and v66.tw == v68 then
			v66.tw = nil

			return
		end
	end)
end
local function stopShine(p18)
	local v70 = t3[p18]

	if not v70 then
		return
	end

	local tw = v70.tw

	if tw then
		tw:Cancel()
	end

	v70.tw = nil
	v70.grad.Offset = vector2
end
local function hookBtn(p19)
	local v73 = p19.Size
	local uDim2New = UDim2.new
	local n1 = v73.X.Scale * 1.1
	local floored = math.floor(v73.X.Offset * 1.1)
	local n2 = v73.Y.Scale * 1.1
	local floored3 = math.floor(v73.Y.Offset * 1.1)
	local v79 = uDim2New(n1, floored, n2, floored3)

	t1[p19] = { tw = nil, baseSize = v73, hoverSize = v79 }

	local foundChild = p19:FindFirstChild("TextLabel", true)

	v79 = if foundChild and foundChild:IsA("TextLabel") then foundChild else nil

	if v79 then
		local v81 = v79.Size
		local v82 = UDim2.new
		local scale = v81.X.Scale
		local offset = v81.X.Offset
		local n3 = v81.Y.Scale * 1.2
		local floored4 = math.floor(v81.Y.Offset * 1.2)
		local uDim2 = v82(scale, offset, n3, floored4)

		t2[p19] = { tw = nil, lbl = v79, baseSize = v81, hoverSize = uDim2 }
	end

	collectStrokeGradients(p19)

	local foundChild2 = p19:FindFirstChild("ShineAnimate", true)

	v79 = if not foundChild2 then nil else foundChild2:FindFirstChildOfClass("UIGradient")

	if v79 then
		t3[p19] = { tw = nil, grad = v79 }
		v79.Offset = vector2
	end

	p19.MouseEnter:Connect(function()
		local v93 = t1[p19]

		if v93 then
			tweenGuiSize(p19, tweenInfo, v93.hoverSize, t1, "tw")
		end

		v93 = t2[p19]

		if v93 then
			tweenTextSize(p19, tweenInfo3, v93.hoverSize)
		end

		playShine(p19)
	end)
	p19.MouseLeave:Connect(function()
		local v94 = t1[p19]

		if v94 then
			tweenGuiSize(p19, tweenInfo2, v94.baseSize, t1, "tw")
		end

		v94 = t2[p19]

		if v94 then
			tweenTextSize(p19, tweenInfo4, v94.baseSize)
		end

		v94 = t3[p19]

		if not v94 then
			return
		end

		local tw = v94.tw

		if tw then
			tw:Cancel()
		end

		v94.tw = nil
		v94.grad.Offset = vector2
	end)
end

for iterFirst, iterSecond in scriptParent:GetDescendants() do
	if iterSecond:IsA("ImageButton") then
		hookBtn(iterSecond)
	end
end

runService.RenderStepped:Connect(function(deltaTime: number)
	for i = #t4, 1, -1 do
		local v91 = t4[i]

		if v91 and v91.Parent then
			local n1 = v91.Rotation + deltaTime * 75

			if n1 >= 360 then
				n1 -= 360
			end

			v91.Rotation = n1
		else
			table.remove(t4, i)
		end
	end
end)
