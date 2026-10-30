-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local v1 = require("../mod/attributes")
local v2 = require("../mod/tween")

require("../types")

local v3 = require("../mod/utility")
local v4 = require("../mod/common/flipbook")
local v5 = require("../pkg/Promise")
local random = Random.new()

local function getLegacyWidths(p1, p2)
	local v10 = v1.get(p1, "Width0", p1.Width0, true)
	local v11 = v1.get(p1, "Width1", p1.Width1, true)
	local v12 = v1.get(p1, "StartWidth0", p1.Width0, true)
	local v13 = v1.get(p1, "StartWidth1", p1.Width1, true)

	return v10 * p2, v11 * p2, v12 * p2, v13 * p2
end

return {
	emit = function(p3, p4, p5, p6)
		local v18 = p5.effects.prepareEmitOnFinish(p4, p5)
		local v19, v20, v21, v22 = getLegacyWidths(p3, p6)
		local width0 = v1.get(p3, "Width0_Start", v21)
		local v24 = v1.get(p3, "Width0_End", v19)
		local width1 = v1.get(p3, "Width1_Start", v22)
		local v26 = v1.get(p3, "Width1_End", v20)
		local v27 = v1.get(p3, "CurveSize0_Start", p4.CurveSize0)
		local v28 = v1.get(p3, "CurveSize0_End", p4.CurveSize0)
		local v29 = v1.get(p3, "CurveSize1_Start", p4.CurveSize1)
		local v30 = v1.get(p3, "CurveSize1_End", p4.CurveSize1)
		local v31 = v1.get(p3, "EmitDelay", 0)
		local v32 = v1.get(p3, "Duration", 1, true)
		local v33 = v1.get(p3, "EndTransparencyScale", 1, true)
		local getRange = v1.getRange
		local numberRange = NumberRange.new(v32, v32)
		local v36 = getRange(p3, "EffectDuration", numberRange, NumberRange.new(0, math.huge))

		v32 = v1.get(p3, "Length_Scale_Start", NumberRange.new(1, 1))

		local v37 = v1.get(p3, "Length_Scale_End", NumberRange.new(1, 1))
		local v38 = v1.get(p3, "Length_Texture_Start", p3.TextureLength)
		local v39 = v1.get(p3, "Length_Texture_End", p3.TextureLength)
		local v40 = random:NextNumber(v36.Min, v36.Max)
		local v41 = random:NextNumber(v37.Min, v37.Max)
		local v42 = random:NextNumber(v32.Min, v32.Max)
		local v43 = v1.get(p3, "Transparency_Scale_Start", 1)
		local v44 = v1.get(p3, "Transparency_Scale_End", v33)
		local v45 = v1.get(p3, "Speed_Texture_Start", p3.TextureSpeed)
		local v46 = v1.get(p3, "Speed_Texture_End", p3.TextureSpeed)
		local v47 = v1.get(p3, "Speed_Start", 1)
		local v48 = v1.get(p3, "Speed_End", 1)
		local textureSpeed = p4.TextureSpeed

		task.wait(v31)
		p4.Enabled = true
		v31 = {}
		local n1 = 1
		local u51 = nil
		local v52 = p5.effects.emitNested(p4, p5.depth + 1, p5)

		table.insert(v31, v52.Finished)

		if v45 ~= v46 then
			local fromParams = v2.fromParams
			local v54 = v1.get(p3, "Speed_Texture_Curve", v3.default_bezier)

			fromParams(v54, v40, function(p7, p8)
				textureSpeed = v3.lerp(v45, v46, p7)
				p4.TextureSpeed = textureSpeed * n1

				return p8
			end)
		end

		if v47 ~= v48 then
			local v55 = v2.fromParams
			local v56 = v1.get(p3, "Speed_Curve", v3.default_bezier)
			local v57 = v1.get(p4, "Speed_Duration", 0.1)

			u51 = v55(v56, v57, function(p9, p10)
				n1 = v3.lerp(v47, v48, p9)
				p4.TextureSpeed = textureSpeed * n1

				return p10
			end)
			table.insert(p5, u51)
		end

		local keypoints = p3.Transparency.Keypoints
		local n2: number = #keypoints
		local v60 = table.create(n2)
		local v61 = table.create(n2)

		for iterFirst, iterSecond in keypoints do
			v61[iterFirst] = {
				time = iterSecond.Time,
				value = iterSecond.Value,
				envelope = iterSecond.Envelope
			}
		end

		local u64 = nil

		local function setTScale(p11)
			if u64 and math.abs(p11 - u64) < 0.001 then
				return
			end

			u64 = p11

			for iterFirst, iterSecond in v61 do
				local value = iterSecond.value

				v60[iterFirst] = NumberSequenceKeypoint.new(iterSecond.time, value + (p11 > 1 and 1 - value or -value) * (p11 > 1 and p11 - 1 or 1 - p11), iterSecond.envelope)
			end

			p4.Transparency = NumberSequence.new(v60)
		end

		local attachment0 = p4.Attachment0
		local attachment1 = p4.Attachment1
		local attachment0CFrame = attachment0 and attachment0.CFrame
		local attachment1CFrame = attachment1 and attachment1.CFrame

		local function setLengthScale(p12)
			if not attachment0CFrame or not attachment1CFrame then
				return
			end

			local n1 = (attachment1CFrame.Position - attachment0CFrame.Position) * 0.5
			local n2 = attachment0CFrame.Position + n1
			local n3 = n1 * p12

			attachment0.CFrame = CFrame.new(n2 - n3) * (attachment0CFrame - attachment0CFrame.Position)
			attachment1.CFrame = CFrame.new(n2 + n3) * (attachment1CFrame - attachment1CFrame.Position)
		end

		table.insert(p5, function()
			setLengthScale(1)
		end)

		if v43 ~= v44 then
			local v71 = v2.fromParams
			local v72 = v1.get(p3, "Transparency_Scale_Curve", v3.default_bezier)

			table.insert(p5, v71(v72, v40, function(p13, p14)
				setTScale(v3.lerp(v43, v44, p13))

				return p14 * n1
			end, u51))
		elseif v43 ~= 1 then
			setTScale(v43)
		end

		if v38 ~= v39 then
			local v73 = v2.fromParams
			local v74 = v1.get(p3, "Length_Texture_Curve", v3.default_bezier)

			table.insert(p5, v73(v74, v40, function(p15, p16)
				p4.TextureLength = v3.lerp(v38, v39, p15)

				return p16 * n1
			end, u51))
		end

		if v42 ~= v41 then
			local v75 = v2.fromParams
			local v76 = v1.get(p3, "Length_Scale_Curve", v3.default_bezier)

			table.insert(p5, v75(v76, v40, function(p17, p18)
				local v112 = v3.lerp(v42, v41, p17)

				setLengthScale(v112)

				return p18 * n1
			end, u51))
		elseif v38 ~= 1 then
			setLengthScale(v42)
		end

		if width0 ~= v24 then
			local v77 = v2.fromParams
			local v78 = v1.get(p3, "Width0_Curve", v3.default_bezier)

			table.insert(p5, v77(v78, v40, function(p19, p20)
				p4.Width0 = v3.lerp(width0, v24, p19)

				return p20 * n1
			end, u51))
		else
			p4.Width0 = width0
		end

		if width1 ~= v26 then
			local v79 = v2.fromParams
			local v80 = v1.get(p3, "Width1_Curve", v3.default_bezier)

			table.insert(p5, v79(v80, v40, function(p21, p22)
				p4.Width1 = v3.lerp(width1, v26, p21)

				return p22 * n1
			end, u51))
		else
			p4.Width1 = width1
		end

		if v27 ~= v28 then
			local v81 = v2.fromParams
			local v82 = v1.get(p3, "CurveSize0_Curve", v3.default_bezier)

			table.insert(p5, v81(v82, v40, function(p23, p24)
				p4.CurveSize0 = v3.lerp(v27, v28, p23)

				return p24 * n1
			end, u51))
		else
			p4.Width0 = width0
		end

		if v29 ~= v30 then
			local v83 = v2.fromParams
			local v84 = v1.get(p3, "CurveSize1_Curve", v3.default_bezier)

			table.insert(p5, v83(v84, v40, function(p25, p26)
				p4.CurveSize1 = v3.lerp(v29, v30, p25)

				return p26 * n1
			end, u51))
		else
			p4.Width1 = width1
		end

		local n3 = 0
		local v86 = v4.getFlipbookData(p3)

		if v86 then
			local t1: {[any]: any} = {
				ref = p3,
				frames = v86,
				speedTween = u51,
				effectDuration = v40,
				curve = v1.get(p3, "Flipbook_Change_Curve", v3.linear_bezier),
				duration = v1.get(p3, "Flipbook_Change_Duration", v40),
				getSpeed = function()
					return n1
				end,
				setTexture = function(texture)
					p4.Texture = texture
				end
			}

			n3 = v4.getChangeDuration(t1)

			local v88 = v2.fromParams
			local curve = t1.curve
			local v90 = v4.createUpdateCallback(t1)

			table.insert(p5, v88(curve, n3, v90, u51))
		end

		local timer = v2.timer
		local v92 = math.max(v40, n3)

		timer(v92, function(p28, p29)
			if n1 > 0 or p29 > 0 and u51 and u51.Connected then
				return p28 * n1
			end

			return nil
		end, u51, p5)

		if v18 then
			local v93 = p5.effects.emitOnFinish(v18, p4.Parent or workspace.Terrain, p5.depth + 1, p5)

			table.insert(v31, v93.Finished)
		end

		v5.all(v31):await()
	end
}
