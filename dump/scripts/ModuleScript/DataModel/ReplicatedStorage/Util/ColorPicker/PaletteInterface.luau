-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local samples: Instance = script.Parent:WaitForChild("Samples")

local function hexToColor3(p1)
	local ok, result = pcall(function()
		return Color3.fromHex(p1)
	end)

	return ok and result
end

local module: {[any]: any} = {}

module.__index = module

function module.new(colorPicker, instance)
	local object = setmetatable({}, module)

	object.ColorPicker = colorPicker
	object.Instance = instance
	object.Colors = {}
	object:Init()

	return object
end
function module.GetColor(p4, p5)
	local v12 = p4.Colors[p5]

	return v12 and v12.color
end
function module.GetColor3(p6, p7)
	local v15 = p6.Colors[p7]
	local v16 = v15

	if v16 then
		local color = v15.color

		local ok, result = pcall(function()
			return Color3.fromHex(color)
		end)

		v16 = ok and result
	end

	return v16
end
function module.SetColor(p8, p9, p10)
	if typeof(p10) == "Color3" then
		p10 = p10:ToHex()
	end

	local v23 = p8.Colors[p9]

	if v23 then
		v23.color = p10
		v23.updateVisual()

		return
	end

	p8:AddColor(p10)
end
function module.GetColors(p11)
	local t2: {[any]: any} = {}

	for iterFirst, iterSecond in p11.Colors, nil, nil do
		t2[iterFirst] = iterSecond.color
	end

	return t2
end
function module.GetColors3(p12)
	local t3: {[any]: any} = {}

	for iterFirst, iterSecond in p12.Colors, nil, nil do
		local color = iterSecond.color

		local ok, result = pcall(function()
			return Color3.fromHex(color)
		end)

		t3[iterFirst] = ok and result
	end

	return t3
end
function module.SetColors(p13, p14)
	for iterFirst, iterSecond in p14 do
		local v39 = typeof(iterSecond) == "Color3" and iterSecond:ToHex() or iterSecond
		local v40 = p13.Colors[iterFirst]

		if v40 then
			v40.color = v39
			v40.updateVisual()
		else
			p13:AddColor(v39)
		end
	end
end
function module.AddColor(p15, p16)
	if #p15.Colors >= 32 then
		print("Palette limit")

		return
	end

	if typeof(p16) == "Color3" then
		p16 = p16:ToHex()
	end

	local clone: Instance = samples:WaitForChild("PaletteItemSample"):Clone()

	clone.Parent = p15.Instance:WaitForChild("List")
	clone.Visible = true

	local t4: {[any]: any} = { instance = clone, color = p16 }

	function t4.updateVisual()
		local clonePreview = clone.Preview
		local color = t4.color

		local ok, result = pcall(function()
			return Color3.fromHex(color)
		end)

		clonePreview.BackgroundColor3 = ok and result
		clone.Hex.Text = string.format("#%s", t4.color)
		clone.Index.Text = table.find(p15.Colors, t4) or ""
	end

	clone:WaitForChild("Delete"):WaitForChild("Button").MouseButton1Down:Connect(function()
		p15:RemoveColor(table.find(p15.Colors, t4))
	end)
	clone:WaitForChild("Button").MouseButton1Down:Connect(function()
		local colorPicker = p15.ColorPicker
		local color = t4.color

		local ok, result = pcall(function()
			return Color3.fromHex(color)
		end)

		colorPicker:SetColor(ok and result)
	end)
	table.insert(p15.Colors, t4)
	t4.updateVisual()
end
function module.RemoveColor(p17, p18)
	local v47 = p17.Colors[p18]

	if v47 then
		if v47.instance then
			v47.instance:Destroy()
		end

		table.remove(p17.Colors, p18)

		if p18 <= #p17.Colors then
			for i = p18, #p17.Colors do
				p17.Colors[i].updateVisual()
			end
		end
	end
end
function module.SetVisible(p19, p20)
	p19.Instance.Visible = p20
end
function module.Init(p21)
	p21.Instance:WaitForChild("Close").MouseButton1Down:Connect(function()
		p21.ColorPicker:SetPaletteVisible(false)
	end)
	p21.Instance:WaitForChild("Save").MouseButton1Down:Connect(function()
		p21:AddColor(p21.ColorPicker:GetColor())
	end)
end

return module
