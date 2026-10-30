-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local textService: TextService = game:GetService("TextService")
local murderNoteCatalog = require(script.Parent:WaitForChild("MurderNoteCatalog"))
local module: {[any]: any} = { LOG_HEADER = "KILL LOG: ", STORE_CHAR_BUDGET = 1200, HARD_MAX = 50 }

function module.TrimLog(p1)
	local t4: {[any]: any} = {}
	local n1: number = #module.LOG_HEADER

	for i = #p1, 1, -1 do
		local v15 = p1[i]

		if typeof(v15) == "string" and v15 ~= "" then
			local n2: number = #v15 + (if #t4 > 0 then 2 else 0)

			if n1 + n2 > module.STORE_CHAR_BUDGET or #t4 >= module.HARD_MAX then
				break
			end

			n1 += n2
			table.insert(t4, 1, v15)
		end
	end

	return t4
end
function module.FormatLog(p2)
	local v18 = module.CollapseRuns(module.TrimLog(p2))

	if #v18 == 0 then
		return module.LOG_HEADER .. "(empty)"
	end

	local log_header = module.LOG_HEADER
	local v20 = table.concat(v18, ", ")

	return log_header .. v20
end

module.RUN_SUFFIX = " (x%d)"

function module.CollapseRuns(p3)
	local t5: {[any]: any} = {}
	local n1: number = 1

	while n1 <= #p3 do
		local v24 = p3[n1]
		local n2: number = n1

		while n2 < #p3 and v24 == p3[n2 + 1] do
			n2 += 1
		end

		local n3: number = n2 - n1 + 1
		local s1

		if n3 > 1 then
			local v28 = module.RUN_SUFFIX:format(n3)

			s1 = v24 .. v28
		else
			s1 = v24
		end

		t5[#t5 + 1] = s1
		n1 = n2 + 1
	end

	return t5
end

local t2: {[any]: any} = {}
local n1: number = 0

local function compose(p4, p5)
	local v31 = table.create(p5)

	for i = #p4 - p5 + 1, #p4 do
		v31[#v31 + 1] = p4[i]
	end

	local log_header = module.LOG_HEADER
	local v34 = table.concat(v31, ", ")

	return log_header .. v34
end
local function measure(p6, text)
	p6.Text = text

	local ok, result = pcall(function()
		return textService:GetTextBoundsAsync(p6)
	end)

	if ok and typeof(result) == "Vector2" then
		return result.Y
	end

	return nil
end
function module.FitLog(p8, p9, width, p11)
	local v43 = module.CollapseRuns(module.TrimLog(p8))

	if #v43 == 0 then
		return module.LOG_HEADER .. "(empty)"
	end

	local v44 = compose(v43, #v43)

	if width <= 0 or p11 <= 0 then
		return v44
	end

	local textSize = p9.TextSize
	local v46 = math.max(p9.LineHeight, 0.01)
	local n6 = textSize * v46

	if n6 <= 0 then
		return v44
	end

	local floored = math.floor(p11 / n6 + 0.001)
	local v49 = math.max(1, floored)
	local floored2 = math.floor(width)
	local text: string = tostring(p9.TextSize)
	local text2: string = tostring(p9.FontFace)
	local v53 = ("%s|%d|%d|%s|%s"):format(v44, floored2, v49, text, text2)
	local v54 = t2[v53]

	if v54 then
		return v54
	end

	local ok, result = pcall(Instance.new, "GetTextBoundsParams")

	if ok and typeof(result) == "Instance" then
		result.Font = p9.FontFace
		result.Size = p9.TextSize
		result.RichText = p9.RichText
		result.Width = width

		local n2: number = 1
		local n3: number = 1
		local n4 = #v43

		while n3 <= n4 do
			local n5: number = (n3 + n4) // 2

			result.Text = compose(v43, n5)

			local ok2, result2 = pcall(function()
				return textService:GetTextBoundsAsync(result)
			end)

			local v63 = if ok2 and typeof(result2) == "Vector2" then result2.Y else nil

			if v63 == nil then
				return v44
			end

			if v49 * n6 + 0.5 >= v63 then
				n2 = n5
				n3 = n5 + 1
			else
				n4 = n5 - 1
			end
		end

		n4 = compose(v43, n2)

		if n1 >= 64 then
			t2 = {}
			n1 = 0
		end

		t2[v53] = n4
		n1 += 1

		return n4
	end

	return v44
end

module.HIT_LINES = {
	"SO CLOSE!",
	"Almost had them.",
	"Not quite.",
	"Winged them...",
	"One more should do it.",
	"They got lucky.",
	"Nearly."
}
module.MISS_LINES = {
	"I need to train...",
	"A wasted page.",
	"Missed. Again.",
	"My hand slipped.",
	"Nothing to write.",
	"Embarrassing."
}
module.UNLOGGED_LINES = {
	"Just practice.",
	"I don't log beings without a soul.",
	"This one doesn't count.",
	"Not worth the ink.",
	"A name, but no soul.",
	"The page stays blank."
}
module.DECOY_LINES = {
	"...An imposter?",
	"It didn't have a soul.",
	"A name with nothing behind it.",
	"That wasn't real.",
	"The page refuses it.",
	"I've been deceived."
}

local random = Random.new()
local t3: {[any]: any} = {}

local function pick(list, p13)
	if #list == 0 then
		return ""
	end

	if #list == 1 then
		return list[1]
	end

	local v66 = nil

	for _ = 1, 6 do
		local v68 = random:NextInteger(1, #list)

		v66 = list[v68]

		if v66 ~= t3[p13] then
			break
		end
	end

	t3[p13] = v66

	return v66
end
function module.KillSentence(p14, p15)
	local v71 = typeof(p14) == "string" and p14 ~= "" and p14 or ""

	if v71 == "" then
		return ""
	end

	if typeof(p15) == "number" then
		local ok, result = pcall(function()
			return murderNoteCatalog.Pick(p15)
		end)

		if ok and typeof(result) == "table" and typeof(result.note) == "string" then
			return ("%s %s."):format(v71, result.note)
		end

		return v71
	end

	return v71
end
function module.RightPageText(p16, p17, p18)
	if p16 == "kill" then
		return module.KillSentence(p17, p18)
	end

	if p16 == "decoy" then
		return (pick(module.DECOY_LINES, "decoy"))
	end

	if p16 == "unlogged" then
		return (pick(module.UNLOGGED_LINES, "unlogged"))
	end

	if p16 == "hit" then
		return (pick(module.HIT_LINES, "hit"))
	end

	if p16 == "miss" then
		return (pick(module.MISS_LINES, "miss"))
	end

	return ""
end

module.WRITE_AT_FRACTION = 0.25
module.HOLD_SECONDS = 2
module.FADE_SECONDS = 1

function module.WriteDelay(p19)
	return (typeof(p19) == "number" and p19 > 0 and p19 or 2) * module.WRITE_AT_FRACTION
end

return module
