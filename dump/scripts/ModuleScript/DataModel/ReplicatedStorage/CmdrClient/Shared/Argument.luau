-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local util = require(script.Parent.Util)

local function unescapeOperators(p1)
	for _, v in ipairs({ "%.", "%?", "%*", "%*%*" }) do
		p1 = p1:gsub("\\" .. v, v:gsub("%%", ""))
	end

	return p1
end

local module: {[any]: any} = {}

module.__index = module

function module.new(p2, p3, p4)
	local t2: {[any]: any} = {
		Type = nil,
		Prefix = "",
		TextSegmentInProgress = "",
		RawSegmentsAreAutocomplete = false,
		Command = p2,
		Name = p3.Name,
		Object = p3,
		Required = p3.Default == nil and p3.Optional ~= true,
		Executor = p2.Executor,
		RawValue = p4,
		RawSegments = {},
		TransformedValues = {}
	}

	if type(p3.Type) == "table" then
		t2.Type = p3.Type
	else
		local utilParsePrefixedUnionType = util.ParsePrefixedUnionType
		local v12 = p2.Cmdr.Registry:GetTypeName(p3.Type)
		local v13, rawValue, prefix = utilParsePrefixedUnionType(v12, p4)

		t2.Type = p2.Dispatcher.Registry:GetType(v13)
		t2.RawValue = rawValue
		t2.Prefix = prefix

		if t2.Type == nil then
			error(string.format("%s has an unregistered type %q", t2.Name or "<none>", v13 or "<none>"))
		end
	end

	setmetatable(t2, module)
	t2:Transform()

	return t2
end
function module.GetDefaultAutocomplete(p5)
	if p5.Type.Autocomplete then
		local v17, v18 = p5.Type.Autocomplete(p5:TransformSegment(""))

		return v17, v18 or {}
	end

	return {}
end
function module.Transform(p6)
	if #p6.TransformedValues == 0 then
		local v20 = p6.RawValue

		if p6.Type.ArgumentOperatorAliases then
			v20 = p6.Type.ArgumentOperatorAliases[v20] or v20
		end

		if v20 == "." and p6.Type.Default then
			v20 = p6.Type.Default(p6.Executor) or ""
			p6.RawSegmentsAreAutocomplete = true
		end

		if v20 == "?" and p6.Type.Autocomplete then
			local v21, v22 = p6:GetDefaultAutocomplete()

			if not v22.IsPartial and #v21 > 0 then
				local randomNumber = math.random(1, #v21)

				v20 = v21[randomNumber]
				p6.RawSegmentsAreAutocomplete = true
			end
		end

		if p6.Type.Listable and #p6.RawValue > 0 then
			local v24 = v20:match("^%?(%d+)$")

			if v24 then
				local numberValue: number? = tonumber(v24)

				if numberValue and numberValue > 0 then
					local t3: {[any]: any} = {}
					local v27, v28 = p6:GetDefaultAutocomplete()

					if not v28.IsPartial and #v27 > 0 then
						for _ = 1, math.min(numberValue, #v27) do
							table.insert(t3, table.remove(v27, math.random(1, #v27)))
						end

						v20 = table.concat(t3, ",")
						p6.RawSegmentsAreAutocomplete = true
					end
				end
			elseif v20 == "*" or v20 == "**" then
				local v30, v31 = p6:GetDefaultAutocomplete()

				if not v31.IsPartial and #v30 > 0 then
					if v20 == "**" and p6.Type.Default then
						local v32 = p6.Type.Default(p6.Executor)

						for i, v in ipairs(v30) do
							if v == (v32 or "") then
								table.remove(v30, i)
							end
						end
					end

					v20 = table.concat(v30, ",")
					p6.RawSegmentsAreAutocomplete = true
				end
			end

			local v35 = unescapeOperators(v20)

			v24 = util.SplitStringSimple(v35, ",")

			if #v24 == 0 then
				v24 = { "" }
			end

			if v35:sub(#v35, #v35) == "," then
				v24[#v24 + 1] = ""
			end

			for i, v in ipairs(v24) do
				p6.RawSegments[i] = v
				p6.TransformedValues[i] = { p6:TransformSegment(v) }
			end

			p6.TextSegmentInProgress = v24[#v24]

			return
		end

		local v38 = unescapeOperators(v20)

		p6.RawSegments[1] = unescapeOperators(v38)
		p6.TransformedValues[1] = { p6:TransformSegment(v38) }
		p6.TextSegmentInProgress = p6.RawValue

		return
	end
end
function module.TransformSegment(p7, p8)
	if p7.Type.Transform then
		return p7.Type.Transform(p8, p7.Executor)
	end

	return p8
end
function module.GetTransformedValue(p9, p10)
	return unpack(p9.TransformedValues[p10])
end
function module.Validate(p11, p12)
	if p11.RawValue == nil or #p11.RawValue == 0 and p11.Required == false then
		return true
	end

	if p11.Required and (p11.RawSegments[1] == nil or #p11.RawSegments[1] == 0) then
		return false, "This argument is required."
	end

	if not p11.Type.Validate and not p11.Type.ValidateOnce then
		return true
	end

	for i = 1, #p11.TransformedValues do
		if p11.Type.Validate then
			local v46, v47 = p11.Type.Validate(p11:GetTransformedValue(i))

			if not v46 then
				return v46, v47 or "Invalid value"
			end
		end

		if p12 and p11.Type.ValidateOnce then
			local v48, v49 = p11.Type.ValidateOnce(p11:GetTransformedValue(i))

			if v48 then
				continue
			end

			return v48, v49
		end
	end

	return true
end
function module.GetAutocomplete(p13)
	if p13.Type.Autocomplete then
		return p13.Type.Autocomplete(p13:GetTransformedValue(#p13.TransformedValues))
	end

	return {}
end
function module.ParseValue(p14, p15)
	if p14.Type.Parse then
		return p14.Type.Parse(p14:GetTransformedValue(p15))
	end

	return p14:GetTransformedValue(p15)
end
function module.GetValue(p16)
	if #p16.RawValue == 0 and not p16.Required and p16.Object.Default ~= nil then
		return p16.Object.Default
	end

	if not p16.Type.Listable then
		return p16:ParseValue(1)
	end

	local t4: {[any]: any} = {}

	for i = 1, #p16.TransformedValues do
		local v56 = p16:ParseValue(i)

		if type(v56) ~= "table" then
			error(("Listable types must return a table from Parse (%s)"):format(p16.Type.Name))
		end

		for _, v in pairs(v56) do
			t4[v] = true
		end
	end

	local t5: {[any]: any} = {}

	for iterKey in pairs(t4) do
		t5[#t5 + 1] = iterKey
	end

	return t5
end

return module
