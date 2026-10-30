-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local lighting: Lighting = game:GetService("Lighting")
local t1: {[any]: any} = {
	"Ambient",
	"OutdoorAmbient",
	"Brightness",
	"ClockTime",
	"ExposureCompensation",
	"EnvironmentDiffuseScale",
	"EnvironmentSpecularScale",
	"GeographicLatitude",
	"ColorShift_Bottom",
	"ColorShift_Top"
}
local u3 = nil
local t2: {[any]: any} = {}
local u5 = nil
local t3: {[any]: any} = {}
local u7: boolean = false
local u8: boolean = false
local u9 = nil

local function refreshClock()
	if u9 == nil then
		return
	end

	if u7 and u8 then
		lighting.ClockTime = 0

		return
	end

	lighting.ClockTime = u9
end
local function disconnectAll()
	for _, v in ipairs(t2) do
		pcall(function()
			v:Disconnect()
		end)
	end

	table.clear(t2)
	u5 = nil
end
local function isWhitelistedProp(p1)
	for _, v in ipairs(t1) do
		if v == p1 then
			return true
		end
	end

	return false
end
local function childKey(p2)
	return p2.ClassName .. "\000" .. p2.Name
end
local function removeMapChildrenOnly()
	for _, v in ipairs(t3) do
		if v and v.Parent == lighting then
			v:Destroy()
		end
	end

	table.clear(t3)

	for _, v in ipairs(lighting:GetChildren()) do
		if v:GetAttribute("__LightingFromMap") == true then
			v:Destroy()
		end
	end
end

local t4: {[any]: any} = {
	Sky = true,
	Atmosphere = true,
	BloomEffect = true,
	ColorCorrectionEffect = true,
	DepthOfFieldEffect = true,
	SunRaysEffect = true
}
local color3 = Color3.fromRGB(134, 121, 118)
local color32 = Color3.fromRGB(70, 70, 70)
local color33 = Color3.fromRGB(0, 0, 0)
local color34 = Color3.fromRGB(0, 0, 0)
local color35 = Color3.fromRGB(255, 255, 255)
local color36 = Color3.fromRGB(199, 199, 199)
local color37 = Color3.fromRGB(106, 112, 125)
local t5: {[any]: any} = {
	Brightness = 3,
	ClockTime = 14.5,
	EnvironmentDiffuseScale = 1,
	EnvironmentSpecularScale = 0.1,
	GeographicLatitude = 0,
	ExposureCompensation = 0,
	Ambient = color3,
	OutdoorAmbient = color32,
	ColorShift_Bottom = color33,
	ColorShift_Top = color34
}
local t6: {[any]: any} = {
	Brightness = 0,
	Contrast = 0.1,
	Saturation = 0.2,
	TintColor = color35
}
local t7: {[any]: any} = {
	Density = 0.3,
	Offset = 0.25,
	Glare = 0,
	Haze = 0,
	Color = color36,
	Decay = color37
}

local function applyMapBaseDefaults()
	for k, v in pairs(t5) do
		if k == "ClockTime" then
			u9 = v

			if u9 ~= nil then
				if u7 and u8 then
					lighting.ClockTime = 0
				else
					lighting.ClockTime = u9
				end
			end
		else
			lighting[k] = v
		end
	end

	local baseColorCorrection: Instance = lighting:FindFirstChild("BaseColorCorrection")

	if baseColorCorrection then
		for k, v in pairs(t6) do
			baseColorCorrection[k] = v
		end
	end

	local atmosphere: Instance = lighting:FindFirstChildOfClass("Atmosphere")

	if atmosphere then
		for k, v in pairs(t7) do
			atmosphere[k] = v
		end
	end
end
local function ensureBaselineChildrenExist()
	local v54 = u3

	if not v54 then
		return
	end

	local t10: {[any]: any} = {}

	for _, v in ipairs(v54.children) do
		local className = v.clone.ClassName

		if t4[className] then
			t10[className] = true
		end
	end

	local t11: {[any]: any} = {}

	for _, v in ipairs(lighting:GetChildren()) do
		local vClassName = v.ClassName

		t11[vClassName] = t11[vClassName] or {}
		table.insert(t11[vClassName], v)
	end

	for k, _ in pairs(t4) do
		local v65 = t11[k]

		if v65 and #v65 > 0 then
			local u66: boolean = false

			for _, v in ipairs(v65) do
				if v:GetAttribute("__LightingBaseline") == true then
					u66 = true

					break
				end
			end

			if u66 then
				for _, v in ipairs(v65) do
					if v:GetAttribute("__LightingBaseline") ~= true then
						v:Destroy()
					end
				end
			elseif t10[k] then
				for _, v in ipairs(v65) do
					v:Destroy()
				end
			else
				for i = 2, #v65 do
					v65[i]:Destroy()
				end
			end
		end
	end

	t11 = {}

	for _, v in ipairs(lighting:GetChildren()) do
		if v:GetAttribute("__LightingBaseline") == true then
			local s1: string = v.ClassName .. "\000" .. v.Name

			t11[s1] = (t11[s1] or 0) + 1
		end
	end

	local t12: {[any]: any} = {}

	for _, v in ipairs(v54.children) do
		t12[v.key] = (t12[v.key] or 0) + 1
	end

	for _, v in ipairs(v54.children) do
		local v82 = v.clone.ClassName

		if t4[v82] then
			local children = lighting:GetChildren()
			local u84: boolean = false

			for _, iterValue in ipairs(children) do
				if v82 == iterValue.ClassName then
					u84 = true

					break
				end
			end

			if u84 then
				continue
			end
		end

		local vKey = v.key
		local v88 = t11[vKey] or 0

		if v88 < (t12[vKey] or 0) then
			local clone = v.clone:Clone()

			pcall(function()
				clone:SetAttribute("__LightingBaseline", true)
			end)
			clone.Parent = lighting
			t11[vKey] = v88 + 1
		end
	end
end
local function restoreBaselineProps()
	local v90 = u3

	if not v90 then
		return
	end

	for k, v in pairs(v90.props) do
		pcall(function()
			lighting[k] = v
		end)
	end
end
local function applyAttr(p3, p4)
	local v95, v96, v97 = ipairs(t1)
	local v98: boolean = false
	local u99

	for iterFirst, iterSecond in v95, v96, v97 do
		if iterSecond == p4 then
			u99 = true
			v98 = true

			break
		end
	end

	if not v98 then
		u99 = false
	end

	if not u99 then
		return
	end

	local attributeValue = p3:GetAttribute(p4)

	if attributeValue == nil then
		return
	end

	if p4 == "ClockTime" then
		u9 = attributeValue

		if u9 == nil then
			return
		end

		if u7 and u8 then
			lighting.ClockTime = 0

			return
		end

		lighting.ClockTime = u9

		return
	end

	pcall(function()
		lighting[p4] = attributeValue
	end)
end
local function destroyByClass(p5)
	for _, v in ipairs(lighting:GetChildren()) do
		if p5 == v.ClassName then
			v:Destroy()
		end
	end
end
local function applyChildrenFromFolder(p6)
	removeMapChildrenOnly()

	for _, v in ipairs(p6:GetChildren()) do
		if t4[v.ClassName] then
			destroyByClass(v.ClassName)
		end
	end

	for _, v in ipairs(p6:GetChildren()) do
		local clone = v:Clone()

		pcall(function()
			clone:SetAttribute("__LightingFromMap", true)
		end)
		clone.Parent = lighting
		table.insert(t3, clone)
	end
end
local function applyAll(p7)
	applyMapBaseDefaults()

	for k, _ in pairs(p7:GetAttributes()) do
		applyAttr(p7, k)
	end

	applyChildrenFromFolder(p7)
end

local module: {[any]: any} = {}

function module.ApplyFromMap(p8)
	task.spawn(function()
		local lightingSettings = p8:WaitForChild("LightingSettings", 30)

		if not p8.Parent then
			return
		end

		if not lightingSettings then
			return
		end

		if u5 and lightingSettings ~= u5 then
			module.Clear()
		end

		u5 = lightingSettings
		u8 = p8:GetAttribute("NighttimeOverride") == true
		applyAll(lightingSettings)
		table.insert(t2, lightingSettings.AttributeChanged:Connect(function(p9)
			if u5 ~= lightingSettings then
				return
			end

			applyAttr(lightingSettings, p9)
		end))
		table.insert(t2, lightingSettings.ChildAdded:Connect(function()
			if u5 ~= lightingSettings then
				return
			end

			applyChildrenFromFolder(lightingSettings)
		end))
		table.insert(t2, lightingSettings.ChildRemoved:Connect(function()
			if u5 ~= lightingSettings then
				return
			end

			applyChildrenFromFolder(lightingSettings)
		end))
	end)
end

local t9: {[any]: any} = {
	ColorCorrectionEffect = { "Brightness", "Contrast", "Saturation", "TintColor" },
	Atmosphere = { "Density", "Offset", "Color", "Decay", "Glare", "Haze" }
}

local function restoreBaselineChildProps()
	local v116 = u3

	if not v116 then
		return
	end

	for _, v in ipairs(v116.children) do
		local className = v.clone.ClassName
		local v120 = t9[className]

		if v120 and lighting:FindFirstChildOfClass(className) then
			for _, iterValue in ipairs(v120) do
				pcall(function()
					v135[iterValue] = v.clone[iterValue]
				end)
			end
		end
	end
end
function module.Clear()
	disconnectAll()
	u8 = false
	u9 = nil
	removeMapChildrenOnly()
	restoreBaselineProps()
	ensureBaselineChildrenExist()
	restoreBaselineChildProps()
end
function module.SetMaterialsOff(p10)
	u7 = p10 == true

	if u9 == nil then
		return
	end

	if u7 and u8 then
		lighting.ClockTime = 0

		return
	end

	lighting.ClockTime = u9
end;

(function()
	if u3 then
		return
	end

	local t13: {[any]: any} = {}

	for _, v in ipairs(t1) do
		local ok, result = pcall(function()
			return lighting[v]
		end)

		if ok then
			t13[v] = result
		end
	end

	local t14: {[any]: any} = {}

	for _, v in ipairs(lighting:GetChildren()) do
		if not v:IsA("BlurEffect") then
			pcall(function()
				v:SetAttribute("__LightingBaseline", true)
			end)

			local s1: string = v.ClassName .. "\000" .. v.Name
			local clone = v:Clone()

			table.insert(t14, { key = s1, clone = clone })
		end
	end

	u3 = { props = t13, children = t14 }
end)()

return module
