-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local v1 = require("../mod/attributes")
local v2 = require("../mod/lerp")
local v3 = require("../mod/tween")

require("../types")

local v4 = require("../mod/utility")
local random = Random.new()

return {
	emit = function(p1, p2, p3)
		local v9 = v4.getTarget(p1)

		if not v9 then
			return
		end

		local v10 = p1.Name
		local v11 = v1.get(p1, "EmitDelay", 0)
		local v12 = v1.get(p1, "ResetOnFinish", true)
		local v13 = v1.getRange(p1, "Duration", NumberRange.new(1, 1), NumberRange.new(0, math.huge))

		if v11 > 0 then
			task.wait(v11)
		end

		local v14 = v1.get(p1, "_END_VALUE", nil)
		local v15 = v1.get(p1, "_START_VALUE", nil)
		local u17

		if p3 then
			u17 = v1.get(v9, v10, nil)
		else
			local ok, result = pcall(function()
				return v9[v10]
			end)

			if not ok then
				return
			end

			u17 = result
		end

		if v15 then
			u17 = v15
		end

		local typeName: string = typeof(u17)
		local typeName2: string = typeof(v14)

		if typeName ~= typeName2 then
			return
		end

		local v22 = random:NextNumber(v13.Min, v13.Max)
		local v23 = v1.get(p1, "Speed_Start", 1)
		local v24 = v1.get(p1, "Speed_End", 1)
		local u25 = v23
		local u26 = nil

		if v23 ~= v24 then
			local fromParams = v3.fromParams
			local v28 = v1.get(p1, "Speed_Curve", v4.default_bezier)
			local v29 = v1.get(p1, "Speed_Duration", 0.1)

			u26 = fromParams(v28, v29, function(p4, p5)
				u25 = v4.lerp(v23, v24, p4)

				return p5
			end)
			table.insert(p2, u26)
		end

		local v30 = v2[typeName] or v2.Other
		local v31 = v3.fromParams
		local v32 = v1.get(p1, "Easing_Curve", v4.linear_bezier)

		table.insert(p2, v31(v32, v22, if p3 then function(p6, p7)
			v1.set(v9, v10, v30(u17, v14, p6))

			return p7 * u25
		end else function(p8, p9)
			v9[v10] = v30(u17, v14, p8)

			return p9 * u25
		end, u26, nil, nil, v4.RENDER_PRIORITY + p2.depth))

		if v12 then
			table.insert(p2, function()
				if p3 then
					v1.set(v9, v10, u17)

					return
				end

				v9[v10] = u17
			end)
		end

		v3.timer(v22, function(p10, p11)
			if u25 > 0 or p11 > 0 and u26 and u26.Connected then
				return p10 * u25
			end

			return nil
		end, u26, p2)
	end
}
