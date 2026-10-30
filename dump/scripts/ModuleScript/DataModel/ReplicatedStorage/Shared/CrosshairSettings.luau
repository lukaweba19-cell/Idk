-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local function slider(p1, p2, p3)
	return { kind = "slider", default = p1, min = p2, max = p3 }
end

local color3 = Color3.fromRGB(255, 255, 255)
local color32 = Color3.fromRGB(255, 255, 255)
local color33 = Color3.fromRGB(0, 0, 0)
local module: {[any]: any} = {
	Defaults = {
		LineLength = { kind = "slider", default = 18, min = 6, max = 36 },
		LineWidth = { kind = "slider", default = 2, min = 1, max = 6 },
		LineDistance = { kind = "slider", default = 9, min = 0, max = 24 },
		LineTransparency = { kind = "slider", default = 0, min = 0, max = 100 },
		DotSize = { kind = "slider", default = 6, min = 0, max = 16 },
		DotTransparency = { kind = "slider", default = 0, min = 0, max = 100 },
		DotShadow = { kind = "slider", default = 95, min = 0, max = 100 },
		StrokeThickness = { kind = "slider", default = 2, min = 0, max = 6 },
		StrokeTransparency = { kind = "slider", default = 70, min = 0, max = 100 },
		CrosshairRotation = { kind = "slider", default = 0, min = 0, max = 90 },
		LineColor = { kind = "color", default = color3 },
		DotColor = { kind = "color", default = color32 },
		StrokeColor = { kind = "color", default = color33 },
		MagneticEnabled = { kind = "toggle", default = true, availability = "mobile" },
		StaticGunCrosshair = { kind = "toggle", default = false },
		ShowKnifeLines = { kind = "toggle", default = false }
	}
}

function module.newState()
	local t3: {[any]: any} = {}

	for k, v in pairs(module.Defaults) do
		t3[k] = v.default
	end

	return t3
end
function module.dotRestTransparencies(p4)
	local v17 = math.clamp((p4.DotTransparency or 0) / 100, 0, 1)
	local v18 = math.clamp((p4.DotShadow or 95) / 100, 0, 1)

	return v17, 1 - v18 * (1 - v17)
end
function module.applyDot(p5, p6)
	if not p5 then
		return
	end

	local v21 = math.max(p6.DotSize or 6, 0)

	p5.Size = UDim2.fromOffset(v21, v21)
	p5.BackgroundColor3 = p6.DotColor or Color3.new(1, 1, 1)

	local backgroundTransparency, transparency = module.dotRestTransparencies(p6)

	p5.BackgroundTransparency = backgroundTransparency

	local shadow = p5:FindFirstChild("Shadow")

	if shadow and shadow:IsA("UIShadow") then
		shadow.Transparency = transparency
	end
end

local u6 = nil
local bindableEvent = nil

function module.getActive()
	if not u6 then
		u6 = module.newState()
	end

	return u6
end
function module.changedSignal()
	if not bindableEvent then
		bindableEvent = Instance.new("BindableEvent")
	end

	return bindableEvent.Event
end
function module.notifyChanged()
	if bindableEvent then
		bindableEvent:Fire()
	end
end
local function fillState(p7, p8)
	local t4 = p8 or {}

	for iterKey in pairs(t4) do
		t4[iterKey] = nil
	end

	for k, v in pairs(module.Defaults) do
		t4[k] = p7 and p7[k] or v.default
	end

	return t4
end
function module.replaceActive(p9)
	fillState(p9, module.getActive())
	module.notifyChanged()
end
function module.encodeColor(p10)
	local floored = math.floor(p10.R * 255 + 0.5)
	local floored2 = math.floor(p10.G * 255 + 0.5)
	local floored3 = math.floor(p10.B * 255 + 0.5)

	return { floored, floored2, floored3 }
end
function module.decodeColor(list)
	if typeof(list) == "table" then
		local v37 = list[1]
		local v38 = list[2]
		local v39 = list[3]

		if typeof(v37) ~= "number" or typeof(v38) ~= "number" or typeof(v39) ~= "number" then
		elseif v37 == v37 and v38 == v38 and v39 == v39 then
			local color3FromRGB = Color3.fromRGB
			local floored = math.floor(v37)
			local v42 = math.clamp(floored, 0, 255)
			local floored4 = math.floor(v38)
			local v44 = math.clamp(floored4, 0, 255)
			local floored5 = math.floor(v39)
			local v46 = math.clamp(floored5, 0, 255)

			return color3FromRGB(v42, v44, v46)
		end

		return nil
	end

	return nil
end
function module.toWire(p12)
	local t5: {[any]: any} = {}

	for k, v in pairs(module.Defaults) do
		local v51 = p12[k] or v.default

		if v.kind == "color" then
			local encodeColor = module.encodeColor
			local typeName: string = typeof(v51)

			t5[k] = encodeColor(typeName == "Color3" and v51 or v.default)
		else
			t5[k] = v51
		end
	end

	return t5
end
function module.fromWire(p13)
	local t6: {[any]: any} = {}

	if typeof(p13) == "table" then
		for k, v in pairs(module.Defaults) do
			local v58 = p13[k]

			if v.kind == "color" then
				t6[k] = module.decodeColor(v58)
			elseif v.kind == "toggle" then
				if typeof(v58) == "boolean" then
					t6[k] = v58
				end
			elseif v.kind == "slider" and typeof(v58) == "number" and v58 == v58 then
				t6[k] = v58
			end
		end

		return t6
	end

	return t6
end
function module.stateFromWire(p14)
	return (fillState(module.fromWire(p14)))
end

local t2: {[any]: any} = {}

function module.setStyleFor(p15, p16)
	t2[p15] = module.stateFromWire(p16)
	module.notifyChanged()
end
function module.getStyleFor(p17)
	return t2[p17]
end
function module.clearStyleFor(p18)
	if t2[p18] ~= nil then
		t2[p18] = nil
		module.notifyChanged()
	end
end

return module
