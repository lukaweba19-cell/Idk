-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local v1 = require("../mod/attributes")
local v2 = require("../mod/lerp")
local v3 = require("../mod/tween")

require("../types")

local v4 = require("../mod/utility")
local v5 = require("../obj/Bezier")
local random = Random.new()

local function getBezier(p1)
	local v10 = v3.bezier_cache[p1]

	if not v10 then
		local ok, result = pcall(function()
			return v4.deserializePath(p1)
		end)

		if not ok then
			return nil
		end

		v10 = v5.new(result, 0)
		v3.bezier_cache[p1] = v10

		return v10
	end

	return v10
end
local function sampleWeighted(p2)
	local v14 = random:NextNumber()

	return 1 - p2:getEase(v14).y
end

return {
	emit = function(p3, _, p5)
		local v18 = v4.getTarget(p3)

		if not v18 then
			return
		end

		local v19 = p3.Name
		local v20 = v1.get(p3, "_START_VALUE", nil)
		local v21 = v1.get(p3, "_END_VALUE", nil)

		if v20 == nil or v21 == nil then
			return
		end

		local typeName: string = typeof(v20)
		local typeName2: string = typeof(v21)

		if typeName ~= typeName2 then
			return
		end

		local v24 = v1.get(p3, "Weight_Curve", v4.linear_bezier)
		local v25 = getBezier(v24)

		if not v25 then
			return
		end

		local u27

		if p5 then
			u27 = v1.get(v18, v19, nil)
		else
			local ok, result = pcall(function()
				return v18[v19]
			end)

			if not ok then
				return
			end

			u27 = result
		end

		v24 = v2[typeName] or v2.Other

		local v30 = random:NextNumber()
		local v31 = v25:getEase(v30)

		v25 = v24(v20, v21, 1 - v31.y)
		v30 = v1.get(p3, "ResetOnFinish", true)

		if p5 then
			v1.set(v18, v19, v25)
		else
			v18[v19] = v25
		end

		if v30 then
			task.defer(function()
				if p5 then
					v1.set(v18, v19, u27)

					return
				end

				v18[v19] = u27
			end)
		end
	end
}
