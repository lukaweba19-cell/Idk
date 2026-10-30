-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local color3 = Color3.fromRGB(255, 236, 150)
local color32 = Color3.fromRGB(184, 128, 20)
local color33 = Color3.fromRGB(240, 200, 90)

local function hex(p1)
	local stringFormat = string.format
	local floored = math.floor(p1.R * 255 + 0.5)
	local floored2 = math.floor(p1.G * 255 + 0.5)
	local floored3 = math.floor(p1.B * 255 + 0.5)

	return stringFormat("#%02X%02X%02X", floored, floored2, floored3)
end

local v6 = table.create(60)

for i = 0, 59 do
	local cosine = math.cos(i / 60 * 3.141592653589793 * 2)
	local v9 = color32:Lerp(color3, (cosine + 1) * 0.5)
	local stringFormat = string.format
	local floored = math.floor(v9.R * 255 + 0.5)
	local floored4 = math.floor(v9.G * 255 + 0.5)
	local floored5 = math.floor(v9.B * 255 + 0.5)

	v6[i + 1] = stringFormat("#%02X%02X%02X", floored, floored4, floored5)
end

local v14 = string.format
local floored6 = math.floor(color33.R * 255 + 0.5)
local floored7 = math.floor(color33.G * 255 + 0.5)
local floored8 = math.floor(color33.B * 255 + 0.5)
local s1: string = "<font color=\"" .. v14("#%02X%02X%02X", floored6, floored7, floored8) .. "\">"

hex = function(p2)
	return (p2:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local t1: {[any]: any} = {}
local t2: {[any]: any} = {}

local function build(p3)
	local t5: {[any]: any} = {}
	local t6: {[any]: any} = {}

	if pcall(function()
		for iterFirst, iterSecond in utf8.codes(p3) do
			table.insert(t6, iterSecond)

			local replacedText = utf8.char(iterSecond):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")

			table.insert(t5, replacedText)
		end
	end) and #t5 ~= 0 then
		local n1: number = #t5
		local v39 = table.create(60)

		for i = 0, 59 do
			local v41 = table.create(n1)

			for j = 1, n1 do
				if t6[j] == 57344 then
					v41[j] = t5[j]
				else
					local floored9 = math.floor(((j - 1) / n1 - i / 60) % 1 * 60)

					v41[j] = "<font color=\"" .. v6[floored9 % 60 + 1] .. "\">" .. t5[j] .. "</font>"
				end
			end

			v39[i + 1] = table.concat(v41)
		end

		return v39
	end

	return nil
end

local module: {[any]: any} = {
	framesFor = function(p4)
		local v45 = t1[p4]

		if v45 then
			return v45
		end

		v45 = build(p4)

		if not v45 then
			return nil
		end

		t1[p4] = v45
		table.insert(t2, p4)

		local v46 = #t2 > 24 and table.remove(t2, 1)

		if v46 then
			t1[v46] = nil
		end

		return v45
	end,
	static = function(p5, p6)
		local v49 = p6 or p5.Text

		p5.RichText = true
		p5:SetAttribute("GoldenTextManaged", true)

		local v50: string = s1
		local replacedText = v49:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")

		p5.Text = v50 .. replacedText .. "</font>"
	end
}

local t4: {[any]: any} = {}
local connection = nil
local n1 = -1

local function currentIndex()
	local v52 = os.clock()

	return math.floor(v52 % 2 / 2 * 60) % 60 + 1
end
local function onScreen(p7)
	local v54 = p7

	while v54 do
		if not v54:IsA("GuiObject") then
			if v54:IsA("LayerCollector") then
				return v54.Enabled
			end
		elseif not v54.Visible then
			return false
		end

		v54 = v54.Parent
	end

	return false
end
local function step()
	local v55 = os.clock()
	local n2 = math.floor(v55 % 2 / 2 * 60) % 60 + 1

	if n2 == n1 then
		return
	end

	n1 = n2

	local u57: boolean = false

	for k, v in pairs(t4) do
		if k.Parent == nil then
			t4[k] = nil
		else
			u57 = true

			if onScreen(k) then
				k.Text = v.frames[n2]
			end
		end
	end

	if not u57 and connection then
		connection:Disconnect()
		connection = nil
	end
end
function module.bind(p8, p9)
	local v62 = p9 or p8.Text
	local v63 = if runService:IsClient() then module.framesFor(v62) else nil

	if not v63 then
		module.static(p8, v62)

		return
	end

	t4[p8] = { plain = v62, frames = v63 }
	p8.RichText = true
	p8:SetAttribute("GoldenTextManaged", true)

	local v64 = os.clock()
	local floored10 = math.floor(v64 % 2 / 2 * 60)

	p8.Text = v63[floored10 % 60 + 1]

	if not connection then
		n1 = -1
		connection = runService.RenderStepped:Connect(step)
	end
end
function module.unbind(p10)
	local v67 = t4[p10]

	t4[p10] = nil

	if p10:GetAttribute("GoldenTextManaged") then
		p10.RichText = false
		p10:SetAttribute("GoldenTextManaged", nil)
	end

	if v67 and p10.Parent then
		p10.Text = v67.plain
	end
end

return module
