-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local textService: TextService = game:GetService("TextService")

local function transformInstanceSet(p3)
	local t3: {[any]: any} = {}

	for i = 1, #p3 do
		t3[i] = p3[i].Name
	end

	return t3, p3
end
local function charCode(p10)
	local utf8Char = utf8.char
	local numberValue: number? = tonumber(p10, 16)

	return utf8Char(numberValue)
end

local t1: {[any]: any} = { "&&", "||", ";" }

local module: {[any]: any} = {
	MakeDictionary = function(p1)
		local t4: {[any]: any} = {}

		for i = 1, #p1 do
			t4[p1[i]] = true
		end

		return t4
	end,
	DictionaryKeys = function(p2)
		local t5: {[any]: any} = {}

		for iterKey in pairs(p2) do
			table.insert(t5, iterKey)
		end

		return t5
	end,
	MakeFuzzyFinder = function(p4)
		local t6 = nil
		local t7 = {}

		if typeof(p4) == "Enum" then
			p4 = p4:GetEnumItems()
		end

		if typeof(p4) == "Instance" then
			local children = p4:GetChildren()
			local t8: {[any]: any} = {}

			for i = 1, #children do
				t8[i] = children[i].Name
			end

			t6 = t8
			t7 = children
		elseif typeof(p4) == "table" then
			if typeof(p4[1]) == "Instance" or typeof(p4[1]) == "EnumItem" or typeof(p4[1]) == "table" and typeof(p4[1].Name) == "string" then
				local t9: {[any]: any} = {}

				for i = 1, #p4 do
					t9[i] = p4[i].Name
				end

				t6 = t9
				t7 = p4
			elseif type(p4[1]) == "string" then
				t6 = p4
			elseif p4[1] == nil then
				t6 = {}
			else
				error("MakeFuzzyFinder only accepts tables of instances or strings.")
			end
		else
			error("MakeFuzzyFinder only accepts a table, Enum, or Instance.")
		end

		return function(p5, p6)
			local t23: {[any]: any} = {}

			for k, v in pairs(t6) do
				local v163 = t7 and t7[k] or v
				local lowerText = v:lower()
				local lowerText2 = p5:lower()

				if lowerText == lowerText2 then
					if p6 then
						return v163
					end

					table.insert(t23, 1, v163)
				elseif v:lower():find(p5:lower(), 1, true) then
					t23[#t23 + 1] = v163
				end
			end

			if p6 then
				return t23[1]
			end

			return t23
		end
	end,
	GetNames = function(p7)
		local t10: {[any]: any} = {}

		for i = 1, #p7 do
			t10[i] = p7[i].Name or tostring(p7[i])
		end

		return t10
	end,
	SplitStringSimple = function(p8, p9: string)
		if p9 == nil then
			p9 = "%s"
		end

		local t11: {[any]: any} = {}
		local n1: number = 1

		for iterValue in string.gmatch(p8, "([^" .. p9 .. "]+)") do
			t11[n1] = iterValue
			n1 += 1
		end

		return t11
	end,
	ParseEscapeSequences = function(p11)
		return p11:gsub("\\(.)", { t = "\t", n = "\n" }):gsub("\\u(%x%x%x%x)", charCode):gsub("\\x(%x%x)", charCode)
	end,
	EncodeEscapedOperator = function(p12, p13)
		local substring = p13:sub(1, 1)
		local replacedText = p13:gsub(".", "%%%1")

		return p12:gsub("(" .. "%" .. substring .. "+)(" .. replacedText .. ")", function(p14, p15)
			return (p14:sub(1, #p14 - 1) .. p15):gsub(".", function(p16)
				local stringFormat = string.format
				local v185 = string.byte(p16)

				return "\\u" .. stringFormat("%04x", v185, 16)
			end)
		end)
	end
}

function module.EncodeEscapedOperators(p17)
	for _, v in ipairs(t1) do
		p17 = module.EncodeEscapedOperator(p17, v)
	end

	return p17
end
local function encodeControlChars(p18)
	return (p18:gsub("\\\\", "___!CMDR_ESCAPE!___"):gsub("\\\"", "___!CMDR_QUOTE!___"):gsub("\\'", "___!CMDR_SQUOTE!___"):gsub("\\\n", "___!CMDR_NL!___"))
end
local function decodeControlChars(p19)
	return (p19:gsub("___!CMDR_ESCAPE!___", "\\"):gsub("___!CMDR_QUOTE!___", "\""):gsub("___!CMDR_NL!___", "\n"))
end
function module.SplitString(p20, p21)
	local v50 = p21 or math.huge
	local t12: {[any]: any} = {}
	local v52 = nil
	local v53 = nil

	for iterValue in p20:gsub("\\\\", "___!CMDR_ESCAPE!___"):gsub("\\\"", "___!CMDR_QUOTE!___"):gsub("\\'", "___!CMDR_SQUOTE!___"):gsub("\\\n", "___!CMDR_NL!___"):gmatch("[^ ]+") do
		local v55 = module.ParseEscapeSequences(iterValue)
		local v56 = v55:match("^(['\"])")
		local v57 = v55:match("(['\"])$")
		local v58 = v55:match("(\\*)['\"]$")

		if v56 and not v53 and not v57 then
			v52 = v55
			v53 = v56
		elseif v52 and v57 == v53 and #v58 % 2 == 0 then
			v55 = v52 .. " " .. v55
			v52 = nil
			v53 = nil
		elseif v52 then
			v52 = v52 .. " " .. v55
		end

		if not v52 then
			t12[#t12 + (if v50 < #t12 then 0 else 1)] = v55:gsub("^(['\"])", ""):gsub("(['\"])$", ""):gsub("___!CMDR_ESCAPE!___", "\\"):gsub("___!CMDR_QUOTE!___", "\""):gsub("___!CMDR_NL!___", "\n")
		end
	end

	if v52 then
		t12[#t12 + (if v50 < #t12 then 0 else 1)] = v52:gsub("___!CMDR_ESCAPE!___", "\\"):gsub("___!CMDR_QUOTE!___", "\""):gsub("___!CMDR_NL!___", "\n")
	end

	return t12
end
function module.MashExcessArguments(p22, p23)
	local t13: {[any]: any} = {}

	for i = 1, #p22 do
		if p23 < i then
			t13[p23] = ("%s %s"):format(t13[p23] or "", p22[i])
		else
			t13[i] = p22[i]
		end
	end

	return t13
end
function module.TrimString(p24)
	local v64, v65 = string.find(p24, "^%s*")

	if v65 == #p24 then
		return ""
	end

	return (string.match(p24, ".*%S", v65 + 1))
end
function module.GetTextSize(p25, p26, p27)
	local textSize = p26.TextSize
	local font = p26.Font
	local v71 = p27 or Vector2.new(p26.AbsoluteSize.X, 0)

	return textService:GetTextSize(p25, textSize, font, v71)
end
function module.MakeEnumType(p28, p29)
	local v74 = module.MakeFuzzyFinder(p29)

	return {
		Validate = function(p30)
			return v74(p30, true) ~= nil, ("Value %q is not a valid %s."):format(p30, p28)
		end,
		Autocomplete = function(p31)
			local v170 = v74(p31)

			return type(v170[1]) ~= "string" and module.GetNames(v170) or v170
		end,
		Parse = function(p32)
			return v74(p32, true)
		end
	}
end
function module.ParsePrefixedUnionType(p33, p34)
	local v77 = module.SplitStringSimple(p33)
	local t14: {[any]: any} = {}

	for i = 1, #v77, 2 do
		t14[#t14 + 1] = { prefix = v77[i - 1] or "", type = v77[i] }
	end

	table.sort(t14, function(p35, p36)
		return #p35.prefix > #p36.prefix
	end)

	for i = 1, #t14 do
		local v81 = t14[i]

		if p34:sub(1, #v81.prefix) == v81.prefix then
			local type = v81.type
			local substring = p34:sub(#v81.prefix + 1)

			return type, substring, v81.prefix
		end
	end
end
function module.MakeListableType(p37, p38)
	local t15: {[any]: any} = {
		Listable = true,
		Transform = p37.Transform,
		Validate = p37.Validate,
		ValidateOnce = p37.ValidateOnce,
		Autocomplete = p37.Autocomplete,
		Default = p37.Default,
		ArgumentOperatorAliases = p37.ArgumentOperatorAliases,
		Parse = function(...)
			return { p37.Parse(...) }
		end
	}

	if p38 then
		for k, v in pairs(p38) do
			t15[k] = v
		end
	end

	return t15
end
local function encodeCommandEscape(p39)
	return (p39:gsub("\\%$", "___!CMDR_DOLLAR!___"))
end
local function decodeCommandEscape(p40)
	return (p40:gsub("___!CMDR_DOLLAR!___", "$"))
end
function module.RunCommandString(p41, p42)
	local v93 = module.ParseEscapeSequences(p42)

	v93 = module.EncodeEscapedOperators(v93):split("&&")

	local s1: string = ""

	for i, v in ipairs(v93) do
		local replacedText = s1:gsub("%$", "\\x24"):gsub("%%", "%%%%")
		local v98 = s1:find("%s") and ("%q"):format(replacedText) or replacedText
		local replacedText2 = v:gsub("||", v98)

		v98 = module.RunEmbeddedCommands(p41, replacedText2)
		s1 = tostring(p41:EvaluateAndRun(v98))

		if i == #v93 then
			return s1
		end
	end
end
function module.RunEmbeddedCommands(p43, p44)
	local replacedText = p44:gsub("\\%$", "___!CMDR_DOLLAR!___")
	local t16: {[any]: any} = {}

	for iterValue in replacedText:gmatch("$(%b{})") do
		local u105: boolean = true
		local substring = iterValue:sub(2, #iterValue - 1)

		if substring:match("^{.+}$") then
			u105 = false
			substring = substring:sub(2, #substring - 1)
		end

		t16[iterValue] = module.RunCommandString(p43, substring)

		if u105 and (not not t16[iterValue]:find("%s") or t16[iterValue] == "") then
			t16[iterValue] = string.format("%q", t16[iterValue])
		end
	end

	return (replacedText:gsub("$(%b{})", t16):gsub("___!CMDR_DOLLAR!___", "$"))
end
function module.SubstituteArgs(p45, p46)
	local replacedText = p45:gsub("\\%$", "___!CMDR_DOLLAR!___")

	if type(p46) == "table" then
		for i = 1, #p46 do
			local text: string = tostring(i)

			p46[text] = p46[i]

			if p46[text]:find("%s") then
				p46[text] = string.format("%q", p46[text])
			end
		end
	end

	return (replacedText:gsub("($%d+)%b{}", "%1"):gsub("$(%w+)", p46):gsub("___!CMDR_DOLLAR!___", "$"))
end
function module.MakeAliasCommand(p47, p48)
	local name, v115 = unpack(p47:split("|"))
	local t17: {[any]: any} = {}
	local u117 = module.EncodeEscapedOperators(p48)
	local t18: {[any]: any} = {}

	for iterValue in u117:gmatch("$(%d+)") do
		if t18[iterValue] == nil then
			t18[iterValue] = true

			local v120 = ("$%*(%%b{})"):format(iterValue)
			local v121 = u117:match(v120)

			v120 = nil

			local v122 = nil
			local v123 = nil

			if v121 then
				local substring = v121:sub(2, #v121 - 1)
				local v125, v126, v127 = unpack(substring:split("|"))

				v120 = v125
				v122 = v126
				v123 = v127
			end

			local v128 = v120

			if v128 then
				v128 = not not v120:match("%?$")
			end

			local v129

			if v120 then
				v129 = v120:match("^%w+")
			else
				v129 = "string"
			end

			local v130 = v122 or ("Argument %*"):format(iterValue)

			table.insert(t17, { Type = v129, Name = v130, Description = v123 or "", Optional = v128 })
		end
	end

	local v131 = ("<Alias> %*"):format(v115 or u117)

	return {
		Group = "UserAlias",
		Name = name,
		Aliases = {},
		Description = v131,
		Args = t17,
		Run = function(p49)
			return module.RunCommandString(p49.Dispatcher, module.SubstituteArgs(u117, p49.RawArguments))
		end
	}
end
function module.MakeSequenceType(p50)
	local t19 = p50 or {}
	local u134: boolean = true

	if t19.Parse == nil then
		u134 = t19.Constructor ~= nil
	end

	assert(u134, "MakeSequenceType: Must provide one of: Constructor, Parse")
	t19.TransformEach = t19.TransformEach or function(...)
		return ...
	end
	t19.ValidateEach = t19.ValidateEach or function()
		return true
	end

	return {
		Prefixes = t19.Prefixes,
		Transform = function(p51)
			local map = module.Map
			local v177 = module.SplitPrioritizedDelimeter(p51, { ",", "%s" })

			return map(v177, function(p52)
				return t19.TransformEach(p52)
			end)
		end,
		Validate = function(p53)
			if t19.Length and #p53 > t19.Length then
				return false, ("Maximum of %d values allowed in sequence"):format(t19.Length)
			end

			for i = 1, t19.Length or #p53 do
				local v180, v181 = t19.ValidateEach(p53[i], i)

				if not v180 then
					return false, v181
				end
			end

			return true
		end,
		Parse = t19.Parse or function(p54)
			return t19.Constructor(unpack(p54))
		end
	}
end
function module.SplitPrioritizedDelimeter(p55, p56)
	for i, v in ipairs(p56) do
		if p55:find(v) or i == #p56 then
			return module.SplitStringSimple(p55, v)
		end
	end
end
function module.Map(p57, p58)
	local t20: {[any]: any} = {}

	for i, v in ipairs(p57) do
		t20[i] = p58(v, i)
	end

	return t20
end
function module.Each(p59, ...)
	local t21: {[any]: any} = {}

	for i, v in ipairs({ ... }) do
		t21[i] = p59(v)
	end

	return unpack(t21)
end
function module.EmulateTabstops(p60, p61)
	local n1 = 0
	local n2: number = #p60
	local v152 = table.create(n2)

	for i = 1, n2 do
		local v154 = string.sub(p60, i, i)

		if v154 == "\t" then
			local n3 = p61 - n1 % p61

			table.insert(v152, string.rep(" ", n3))
			n1 += n3
		else
			table.insert(v152, v154)

			if v154 == "\n" then
				n1 = 0
			elseif v154 ~= "\r" then
				n1 += 1
			end
		end
	end

	return table.concat(v152)
end
function module.Mutex()
	local t22: {[any]: any} = {}
	local u157: boolean = false

	return function()
		if u157 then
			table.insert(t22, coroutine.running())
			coroutine.yield()
		else
			u157 = true
		end

		return function()
			if #t22 > 0 then
				coroutine.resume(table.remove(t22, 1))

				return
			end

			u157 = false
		end
	end
end

return module
