-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local function warp(p1)
	return (p1 % 1 + 1) % 1
end
local function multiplyHue(p2, p3)
	return ((p2 + (p3 - 0.5) * 1) % 1 + 1) % 1
end
local function multiplyChannel(p4, p5)
	local n1 = p5 * 2 - 1

	if n1 >= 0 then
		return (math.clamp(p4 + (1 - p4) * n1, 0, 1))
	end

	local absoluteValue = math.abs(n1)

	return (math.clamp(p4 - p4 * absoluteValue, 0, 1))
end
local function normalizeColor(p6)
	local r = p6.R
	local g = p6.G
	local b = p6.B
	local v19 = math.max(1, r, g, b)

	return v19, Color3.new(r / v19, g / v19, b / v19)
end
local function multiplyRGB(p7, p8)
	return Color3.new(p7.R * p8, p7.G * p8, p7.B * p8)
end

local t1: {[any]: any} = {
	Single = {
		Color3 = { "Decal", "Texture" },
		Color = {
			"Part",
			"Union",
			"MeshPart",
			"SpotLight",
			"PointLight",
			"SurfaceLight",
			"SurfaceAppearance"
		}
	},
	Sequence = {
		Color = { "Beam", "Trail", "ParticleEmitter" }
	}
}

local function recolorObj(p9, p10, p11, p12)
	if not p12 and p9:IsA("BasePart") then
		return
	end

	local v26, v27, v28 = p10:ToHSV()

	for key, value in t1 do
		for iterFirst, iterSecond in value do
			if table.find(iterSecond, p9.ClassName) then
				local v33 = p9[iterFirst]

				if p11 == "multiply" then
					if typeof(v33) == "Color3" then
						local r = v33.R
						local g = v33.G
						local b = v33.B
						local v37 = math.max(1, r, g, b)
						local v38 = v37
						local color3 = Color3.new(r / v37, g / v37, b / v37)
						local v40, v41, v42 = color3:ToHSV()

						v37 = v27 * 2 - 1

						local v43 = if v37 >= 0 then math.clamp(v41 + (1 - v41) * v37, 0, 1) else math.clamp(v41 - v41 * math.abs(v37), 0, 1)

						v37 = v28 * 2 - 1

						local v44

						if v37 >= 0 then
							v44 = math.clamp(v42 + (1 - v42) * v37, 0, 1)
						else
							local absoluteValue = math.abs(v37)

							v44 = math.clamp(v42 - v42 * absoluteValue, 0, 1)
						end

						local color32 = Color3.fromHSV(((v40 + (v26 - 0.5) * 1) % 1 + 1) % 1, v43, v44)

						p9[iterFirst] = Color3.new(color32.R * v38, color32.G * v38, color32.B * v38)
					elseif typeof(v33) == "ColorSequence" then
						local t2: {[any]: any} = {}

						for iterFirst2, iterSecond2 in v33.Keypoints, nil, nil do
							local v50 = iterSecond2.Value
							local v51 = v50.R
							local v52 = v50.G
							local v53 = v50.B
							local v54 = math.max(1, v51, v52, v53)
							local color3 = Color3.new(v51 / v54, v52 / v54, v53 / v54)
							local v56, v57, v58 = color3:ToHSV()
							local n1 = v27 * 2 - 1

							v50 = if n1 >= 0 then math.clamp(v57 + (1 - v57) * n1, 0, 1) else math.clamp(v57 - v57 * math.abs(n1), 0, 1)
							n1 = v28 * 2 - 1

							local v60 = if n1 >= 0 then math.clamp(v58 + (1 - v58) * n1, 0, 1) else math.clamp(v58 - v58 * math.abs(n1), 0, 1)
							local colorSequenceKeypointNew = ColorSequenceKeypoint.new
							local time = iterSecond2.Time
							local color33 = Color3.fromHSV(((v56 + (v26 - 0.5) * 1) % 1 + 1) % 1, v50, v60)

							table.insert(t2, colorSequenceKeypointNew(time, multiplyRGB(color33, v54)))
						end

						p9[iterFirst] = ColorSequence.new(t2)
					end
				elseif typeof(v33) == "Color3" then
					local v64 = v33.R
					local v65 = v33.G
					local v66 = v33.B
					local v67 = math.max(1, v64, v65, v66)
					local v68 = v67

					Color3.new(v64 / v67, v65 / v67, v66 / v67)
					p9[iterFirst] = Color3.new(p10.R * v68, p10.G * v68, p10.B * v68)
				elseif typeof(v33) == "ColorSequence" then
					p9[iterFirst] = ColorSequence.new(p10)
				end
			end
		end
	end
end

return function(p13, p14, ...)
	for iterFirst, value in { ... }, nil, nil do
		recolorObj(value, p13, p14, true)

		for iterFirst2, iterSecond in value:GetDescendants() do
			recolorObj(iterSecond, p13, p14, false)
		end
	end
end
