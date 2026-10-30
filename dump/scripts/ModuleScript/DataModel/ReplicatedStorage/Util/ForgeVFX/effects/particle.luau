-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local v1 = require("../mod/attributes")
local v2 = require("../mod/tween")

require("../types")

local v3 = require("../mod/utility")

return {
	emit = function(p1, p2, p3)
		if p1.Enabled then
			p1.Enabled = false
		end

		local v7 = v1.get(p1, "EmitDelay", 0)
		local v8 = v1.get(p1, "EmitCount", 1)
		local v9 = v1.get(p1, "EmitDuration", 0)
		local u10: boolean = v9 > 0

		task.wait(v7)

		if u10 then
			p2.Enabled = true
		end

		local v11 = v1.get(p1, "TimeScale_Duration", 0.1)
		local timeScale = v1.get(p1, "TimeScale_Start", p2.TimeScale, true)
		local v13 = v1.get(p1, "TimeScale_End", p2.TimeScale, true)
		local u14 = nil

		if timeScale ~= v13 then
			local fromParams = v2.fromParams
			local v16 = v1.get(p1, "TimeScale_Curve", v3.default_bezier)

			u14 = fromParams(v16, v11, function(p4, p5)
				local lerp = v3.lerp
				local v20 = math.clamp(p4, 0, 1)

				p2.TimeScale = lerp(timeScale, v13, v20)

				return p5
			end)
			table.insert(p3, u14)
		elseif timeScale ~= p2.TimeScale then
			p2.TimeScale = timeScale
		end

		v3.onCancel(p3, function()
			if u10 then
				p2.Enabled = false
			end

			p2:Clear()
		end)
		p2:Emit(v8)

		if u10 then
			task.wait(v9)
			p2.Enabled = false
		end

		v2.timer(p1.Lifetime.Max, function(p6, p7)
			if p1.TimeScale > 0 or p7 > 0 and u14 and u14.Connected then
				return p6 * p1.TimeScale
			end

			return nil
		end, u14, p3)
	end
}
