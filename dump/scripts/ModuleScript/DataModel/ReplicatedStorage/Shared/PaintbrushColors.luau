-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local color3 = Color3.fromRGB(255, 35, 50)
local color32 = Color3.fromRGB(255, 135, 20)
local color33 = Color3.fromRGB(255, 220, 35)
local color34 = Color3.fromRGB(50, 220, 75)
local color35 = Color3.fromRGB(30, 125, 255)
local color36 = Color3.fromRGB(160, 60, 255)
local color37 = Color3.fromRGB(255, 70, 190)
local module: {[any]: any} = {
	ATTR = "PaintbrushColor",
	SKIN = "Paintbrush",
	TINT_ATTR = "PaintTint",
	THROW_ATTR = "PaintColor",
	FALLBACK = "Purple",
	COLORS = {
		{ Name = "Red", Color = color3 },
		{ Name = "Orange", Color = color32 },
		{ Name = "Yellow", Color = color33 },
		{ Name = "Green", Color = color34 },
		{ Name = "Blue", Color = color35 },
		{ Name = "Purple", Color = color36 },
		{ Name = "Pink", Color = color37 }
	}
}
local t2: {[any]: any} = {}

for iterFirst, iterSecond in module.COLORS, nil, nil do
	t2[iterSecond.Name] = iterSecond.Color
end

function module.ColorOf(p1)
	if typeof(p1) == "string" then
		return t2[p1]
	end

	return nil
end
function module.Current(p2)
	local v14 = if p2 then p2:GetAttribute(module.ATTR) else nil

	if typeof(v14) == "string" and t2[v14] then
		return v14
	end

	return nil
end
function module.Tint(p3, p4)
	local v17 = if p4 then t2[p4] else nil

	if p3 and v17 then
		for iterFirst, iterSecond in p3:GetDescendants() do
			if iterSecond:GetAttribute(module.TINT_ATTR) then
				if iterSecond:IsA("BasePart") then
					iterSecond.Color = v17
				elseif iterSecond:IsA("ParticleEmitter") or iterSecond:IsA("Trail") or iterSecond:IsA("Beam") then
					iterSecond.Color = ColorSequence.new(v17)
				end
			end
		end

		return
	end
end
function module.Roll(p5)
	local t3: {[any]: any} = {}

	for iterFirst, iterSecond in module.COLORS, nil, nil do
		if p5 ~= iterSecond.Name then
			table.insert(t3, iterSecond.Name)
		end
	end

	local randomNumber = math.random(1, #t3)

	return t3[randomNumber]
end

return module
