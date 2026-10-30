-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local color3 = Color3.fromRGB(111, 118, 255)
local t1: {[any]: any} = {
	Branch_Chance = 0.3,
	Branch_ThicknessFactor = 1,
	Branch_ThicknessRandomness = 0.3,
	Segments = NumberRange.new(8, 13),
	Jaggedness = NumberRange.new(0.15, 0.25),
	Curvature = NumberRange.new(0.1, 0.15),
	CurveBreaks = NumberRange.new(1, 2),
	Thickness = NumberRange.new(3, 5),
	Color = color3,
	SpawnDur = NumberRange.new(0.07, 0.12),
	Lifetime = NumberRange.new(0.06, 0.09),
	FadeTime = NumberRange.new(0.1, 0.15),
	Branch_Amount = NumberRange.new(2, 4),
	Branch_Segments = NumberRange.new(2, 5),
	Branch_Span = NumberRange.new(3, 7),
	Branch_LengthFactor = NumberRange.new(0.2, 0.3)
}
local color32 = Color3.fromRGB(111, 118, 255)
local t2: {[any]: any} = {
	AnimationType = "Sway",
	Sway_MaxOffsetFactor = 0.08,
	Sway_FalloffPower = 0.7,
	Branch_ThicknessFactor = 1,
	Branch_ThicknessRandomness = 0.3,
	Segments = NumberRange.new(8, 13),
	Jaggedness = NumberRange.new(0.15, 0.25),
	Curvature = NumberRange.new(0.1, 0.15),
	CurveBreaks = NumberRange.new(1, 2),
	Thickness = NumberRange.new(3, 5),
	Color = color32,
	SpawnDur = NumberRange.new(0.15, 0.2),
	Lifetime = NumberRange.new(0.08, 0.12),
	FadeTime = NumberRange.new(0.2, 0.3),
	Sway_Grabs = NumberRange.new(2, 4),
	Branch_Amount = NumberRange.new(2, 5),
	Branch_Segments = NumberRange.new(4, 8),
	Branch_Span = NumberRange.new(3, 7),
	Branch_LengthFactor = NumberRange.new(0.2, 0.3)
}
local color33 = Color3.fromRGB(111, 118, 255)
local t3: {[any]: any} = {
	AnimationType = "Sway",
	Sway_MaxOffsetFactor = 0.04,
	Sway_FalloffPower = 0.7,
	Branch_ThicknessFactor = 0.5,
	Branch_ThicknessRandomness = 0.7,
	Segments = NumberRange.new(20, 35),
	Jaggedness = NumberRange.new(0.08, 0.12),
	Curvature = NumberRange.new(0.1, 0.17),
	CurveBreaks = NumberRange.new(2, 4),
	Thickness = NumberRange.new(2, 4),
	Color = color33,
	SpawnDur = NumberRange.new(0.06, 0.1),
	Lifetime = NumberRange.new(0.07, 0.1),
	FadeTime = NumberRange.new(0.12, 0.2),
	Sway_Grabs = NumberRange.new(3, 4),
	Branch_Amount = NumberRange.new(8, 13),
	Branch_Segments = NumberRange.new(12, 20),
	Branch_Span = NumberRange.new(7, 16),
	Branch_LengthFactor = NumberRange.new(0.2, 0.4)
}
local color34 = Color3.fromRGB(111, 118, 255)
local t4: {[any]: any} = {
	SpawnDur = 0,
	AnimationType = "Rebuild",
	RebuildType = "FocusLast",
	RebuildStrength = 2,
	Branch_ThicknessFactor = 0.5,
	Branch_ThicknessRandomness = 0.9,
	Segments = NumberRange.new(20, 35),
	Jaggedness = NumberRange.new(0.08, 0.12),
	Curvature = NumberRange.new(0.1, 0.17),
	CurveBreaks = NumberRange.new(2, 4),
	Thickness = NumberRange.new(2, 4),
	Color = color34,
	Lifetime = NumberRange.new(0.06, 0.08),
	FadeTime = NumberRange.new(0.1, 0.15),
	RebuildTimes = NumberRange.new(2, 3),
	Branch_Amount = NumberRange.new(8, 13),
	Branch_Segments = NumberRange.new(6, 15),
	Branch_Span = NumberRange.new(5, 14),
	Branch_LengthFactor = NumberRange.new(0.2, 0.45)
}
local color35 = Color3.fromRGB(111, 118, 255)
local t5: {[any]: any} = {
	Minimalistic = t1,
	Cartoony = t2,
	Realistic_1 = t3,
	Realistic_2 = t4,
	ThinZap = {
		SpawnDur = 0,
		AnimationType = "None",
		RebuildType = "Fair",
		RebuildStrength = 3,
		Branch_ThicknessFactor = 1,
		Branch_ThicknessRandomness = 0.2,
		Segments = NumberRange.new(20, 35),
		Jaggedness = NumberRange.new(0.08, 0.12),
		Curvature = NumberRange.new(0.1, 0.17),
		CurveBreaks = NumberRange.new(2, 4),
		Thickness = NumberRange.new(0.9, 1.3),
		Color = color35,
		Lifetime = NumberRange.new(0.03, 0.05),
		FadeTime = NumberRange.new(0.01),
		RebuildTimes = NumberRange.new(0, 1),
		Branch_Amount = NumberRange.new(8, 13),
		Branch_Segments = NumberRange.new(6, 15),
		Branch_Span = NumberRange.new(4, 14),
		Branch_LengthFactor = NumberRange.new(0.1, 0.3)
	}
}

return {
	Get = function(p1)
		return t5[p1]
	end
}
