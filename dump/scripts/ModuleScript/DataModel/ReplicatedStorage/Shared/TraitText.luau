-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")

local function band(p1, p2)
	return function(p3)
		local cosine = math.cos(p3 * 3.141592653589793 * 2)

		return p2:Lerp(p1, (cosine + 1) * 0.5)
	end
end

local color3 = Color3.fromRGB(255, 255, 255)
local color32 = Color3.fromRGB(65, 65, 65)
local color33 = Color3.fromRGB(65, 0, 0)
local color34 = Color3.fromRGB(165, 0, 0)
local color35 = Color3.fromRGB(0, 0, 0)
local color36 = Color3.fromRGB(130, 130, 130)
local color37 = Color3.fromRGB(0, 0, 0)
local color38 = Color3.fromRGB(65, 0, 0)

band = function(p10)
	local stringFormat = string.format
	local floored = math.floor(p10.R * 255 + 0.5)
	local floored2 = math.floor(p10.G * 255 + 0.5)
	local floored3 = math.floor(p10.B * 255 + 0.5)

	return stringFormat("#%02X%02X%02X", floored, floored2, floored3)
end

local function buildFrames(p11)
	local t2: {[any]: any} = {}

	for k, v in pairs(p11) do
		local s1: string = "[" .. k .. "]"
		local n1: number = #s1
		local v34 = table.create(40)

		for i = 0, 39 do
			local n2: number = i / 40
			local v37 = table.create(n1)

			for j = 1, n1 do
				local stringFormat = string.format
				local v40 = v(((j - 1) / n1 - n2) % 1)
				local v41 = string.format
				local floored = math.floor(v40.R * 255 + 0.5)
				local floored4 = math.floor(v40.G * 255 + 0.5)
				local floored5 = math.floor(v40.B * 255 + 0.5)
				local v45 = v41("#%02X%02X%02X", floored, floored4, floored5)

				v40 = string.sub(s1, j, j)
				v37[j] = stringFormat("<font color=\"%s\">%s</font>", v45, v40)
			end

			v34[i + 1] = table.concat(v37)
		end

		t2[s1] = v34
	end

	return t2
end

local v12 = buildFrames({
	NEGATIVE = function(p4)
		local cosine = math.cos(p4 * 3.141592653589793 * 2)

		return color32:Lerp(color3, (cosine + 1) * 0.5)
	end,
	CORRUPTED = function(p5)
		local cosine = math.cos(p5 * 3.141592653589793 * 2)

		return color34:Lerp(color33, (cosine + 1) * 0.5)
	end,
	OMEGA = function(p6)
		return Color3.fromHSV(p6 % 1, 1, 1)
	end
})

local v13 = buildFrames({
	NEGATIVE = function(p7)
		local cosine = math.cos(p7 * 3.141592653589793 * 2)

		return color36:Lerp(color35, (cosine + 1) * 0.5)
	end,
	CORRUPTED = function(p8)
		local cosine = math.cos(p8 * 3.141592653589793 * 2)

		return color38:Lerp(color37, (cosine + 1) * 0.5)
	end,
	OMEGA = function(p9)
		return Color3.fromHSV(p9 % 1, 1, 0.62)
	end
})

local t1: {[any]: any} = {}
local connection = nil
local n1 = -1

local function currentIndex()
	local v56 = os.clock()

	return math.floor(v56 % 2 / 2 * 40) % 40 + 1
end
local function escape(p12)
	return (p12:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end
local function onScreen(p13)
	local v59 = p13

	while v59 do
		if not v59:IsA("GuiObject") then
			if v59:IsA("LayerCollector") then
				return v59.Enabled
			end
		elseif not v59.Visible then
			return false
		end

		v59 = v59.Parent
	end

	return false
end
local function step()
	local v60 = os.clock()
	local n2 = math.floor(v60 % 2 / 2 * 40) % 40 + 1

	if n2 == n1 then
		return
	end

	n1 = n2

	local u62: boolean = false

	for k, v in pairs(t1) do
		if k.Parent == nil then
			t1[k] = nil
		else
			u62 = true

			if onScreen(k) then
				k.Text = v.prefix .. v.frames[n2] .. v.rest
			end
		end
	end

	if not u62 and connection then
		connection:Disconnect()
		connection = nil
	end
end

return {
	Bind = function(p14, p15, p16)
		local text = p15 or ""
		local v69, v70, v71 = string.match(text, "^(.-)(%[%u+%])(.*)$")
		local v72 = v70 ~= nil and (p16 and v13[v70] or v12[v70]) or nil

		if v72 and runService:IsClient() then
			local replacedText = v69:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
			local replacedText2 = v71:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
			local t3: {[any]: any} = { prefix = replacedText, tag = v70, rest = replacedText2, frames = v72 }

			t1[p14] = t3
			p14.RichText = true
			p14:SetAttribute("TraitTextManaged", true)

			local prefix = t3.prefix
			local v77 = os.clock()
			local floored = math.floor(v77 % 2 / 2 * 40)

			p14.Text = prefix .. v72[floored % 40 + 1] .. t3.rest

			if not connection then
				n1 = -1
				connection = runService.RenderStepped:Connect(step)

				return
			end
		else
			t1[p14] = nil

			if p14:GetAttribute("TraitTextManaged") then
				p14.RichText = false
				p14:SetAttribute("TraitTextManaged", nil)
			end

			p14.Text = text
		end
	end,
	Strip = function(p17)
		local v80 = p17 or ""
		local v81, v82, v83 = string.match(v80, "^(.-)(%[%u+%])%s*(.*)$")

		if v82 and v12[v82] then
			return v81 .. v83
		end

		return v80
	end,
	TagOf = function(p18)
		local v85, v86 = string.match(p18 or "", "^(.-)(%[%u+%])")

		if v86 and v12[v86] then
			return v86
		end

		return nil
	end
}
