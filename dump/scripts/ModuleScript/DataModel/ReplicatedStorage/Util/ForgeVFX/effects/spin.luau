-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local v1 = require("../mod/attributes")
local v2 = require("../mod/tween")

require("../types")

local v3 = require("../mod/utility")

return {
	emit = function(p1, p2)
		if v3.isSpinModelStatic(p1) then
			return
		end

		local n1 = v1.get(p1, "SpinRotation", Vector3.new(0, 0, 0)) * v3.DEG_TO_RAD
		local v7 = v1.get(p1, "Scale_Start", 1)
		local v8 = v1.get(p1, "Scale_End", 1)
		local v9 = v1.get(p1, "EmitDelay", 0)
		local v10 = v1.get(p1, "ResetDelay", 0)
		local v11 = v1.get(p1, "ResetOnFinish", true)
		local v12 = v1.get(p1, "SyncPosition", false)
		local v13 = v1.get(p1, "SpinDuration", 0.5)
		local v14 = v1.get(p1, "SpinSpeed_Duration", 0.1)
		local v15 = v1.get(p1, "SpinSpeed_Start", 0)
		local v16 = v1.get(p1, "SpinSpeed_End", 1)
		local u17 = v15

		task.wait(v9)

		local u18 = nil

		if v15 ~= v16 then
			local fromParams = v2.fromParams
			local v20 = v1.get(p1, "SpinSpeed_Curve", v3.default_bezier)

			u18 = fromParams(v20, v14, function(p3, p4)
				u17 = v3.lerp(v15, v16, p3)

				return p4
			end)
			table.insert(p2, u18)
		end

		local pivot = p1:GetPivot()
		local v22 = p1:GetScale()

		if v7 ~= v8 then
			local v23 = v2.fromParams
			local v24 = v1.get(p1, "Scale_Curve", v3.default_bezier)

			table.insert(p2, v23(v24, v13, function(p5, p6)
				p1:ScaleTo(v3.lerp(v7, v8, p5))

				return p6
			end))
		else
			p1:ScaleTo(v7)
		end

		local v25 = p1:FindFirstAncestorOfClass("Attachment") or p1:FindFirstAncestorWhichIsA("BasePart")

		if v11 then
			table.insert(p2, function()
				local v31 = v25 and v3.getTransformedOriginExtents(v25) or pivot

				p1:PivotTo(v31)
				p1:ScaleTo(v22)
			end)
		end

		local n2 = n1 * v13

		v2.timer(v13 + v10, function(p7, p8)
			local v34 = math.clamp(p8 / v13, 0, 1)
			local n1 = n2 * v34
			local v36 = if v25 and v12 then v3.getTransformedOriginExtents(v25) else pivot
			local v37 = CFrame.fromOrientation(n1.x, n1.y, n1.z)

			p1:PivotTo(v36 * v37)

			if u17 > 0 or p8 > 0 and u18.Connected then
				return p7 * u17
			end

			return nil
		end, u18, p2, v3.RENDER_PRIORITY + p2.depth)
	end
}
