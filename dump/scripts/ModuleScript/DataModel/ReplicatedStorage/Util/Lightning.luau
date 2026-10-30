-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local workspace: Workspace = game:GetService("Workspace")
local debris: Debris = game:GetService("Debris")
local helpers = require(script.helpers)
local presets = require(script.presets)
local helpersSafeUnit = helpers.SafeUnit
local helpersBuildPoints = helpers.BuildPoints
local helpersDrawBoltDynamic = helpers.DrawBoltDynamic
local helpersRandomPointInPart = helpers.RandomPointInPart
local helpersFindClosestPoint = helpers.FindClosestPoint
local helpersBranchMultiRejoin = helpers.BranchMultiRejoin
local helpersRegisterSwayAnimation = helpers.RegisterSwayAnimation
local helpersNumOrRange = helpers.NumOrRange
local helpersClampNumber = helpers.ClampNumber
local helpersToRange = helpers.ToRange

local function shallowClone(p1)
	local t4: {[any]: any} = {}

	for k, v in pairs(p1) do
		t4[k] = v
	end

	return t4
end
local function applyPatch(p2, p3)
	local t5: {[any]: any} = {}

	for k, v in pairs(p2) do
		t5[k] = v
	end

	if p3 then
		for k, v in pairs(p3) do
			t5[k] = v
		end
	end

	return t5
end
local function sanitizeStormParamsPatch(p4)
	local t6: {[any]: any} = {}

	if p4.SpawnRate ~= nil then
		t6.SpawnRate = helpersToRange(p4.SpawnRate, NumberRange.new(1, 1), 0.001)
	end

	if p4.AreaSize ~= nil then
		t6.AreaSize = typeof(p4.AreaSize) == "number" and math.clamp(p4.AreaSize, 0, 1) or 1
	end

	if p4.OnHit ~= nil and typeof(p4.OnHit) == "function" then
		t6.OnHit = p4.OnHit
	end

	if p4.StartVolume ~= nil and typeof(p4.StartVolume) == "Instance" and p4.StartVolume:IsA("BasePart") then
		t6.StartVolume = p4.StartVolume
	end

	if p4.EndVolume ~= nil and typeof(p4.EndVolume) == "Instance" and p4.EndVolume:IsA("BasePart") then
		t6.EndVolume = p4.EndVolume
	end

	return t6
end

local t1: {[any]: any} = {
	Segments = 15,
	Jaggedness = 0.1,
	Curvature = 0.15,
	CurveBreaks = 2,
	Thickness = 1,
	SpawnDur = 0.06,
	Lifetime = 0.1,
	FadeTime = 0.06,
	Branch_Amount = 5,
	Branch_ThicknessFactor = 0.55,
	Branch_ThicknessRandomness = 0,
	AnimationType = "None",
	Sway_MaxOffsetFactor = 0.12,
	Sway_FalloffPower = 1.6,
	RebuildType = "Fair",
	RebuildTimes = 0,
	RebuildStrength = 1,
	Raycast = true,
	RaycastParams = nil,
	FolderName = "LightningFX",
	Color = Color3.new(0.690196, 0.690196, 0.690196),
	Material = Enum.Material.Neon,
	Branch_Span = NumberRange.new(2, 4),
	Branch_Segments = NumberRange.new(4, 8),
	Branch_LengthFactor = NumberRange.new(0.2, 0.4),
	Sway_Grabs = NumberRange.new(2, 3),
	Parent = workspace
}

local module: {[any]: any} = {
	StormParams = function(p5)
		local typeName: string = type(p5)

		assert(typeName == "table", "StormParams: expected table")

		return (sanitizeStormParamsPatch(p5))
	end,
	Config = function(p6)
		local v45: {[any]: any} = t1
		local t7 = p6 or {}
		local t8: {[any]: any} = {}

		if t7.Segments ~= nil then
			t8.Segments = helpersNumOrRange(t7.Segments, v45.Segments)
		end

		if t7.Jaggedness ~= nil then
			t8.Jaggedness = helpersNumOrRange(t7.Jaggedness, v45.Jaggedness)
		end

		if t7.Curvature ~= nil then
			t8.Curvature = helpersNumOrRange(t7.Curvature, v45.Curvature)
		end

		if t7.CurveBreaks ~= nil then
			t8.CurveBreaks = helpersNumOrRange(t7.CurveBreaks, v45.CurveBreaks)
		end

		if t7.Thickness ~= nil then
			t8.Thickness = helpersNumOrRange(t7.Thickness, v45.Thickness)
		end

		if t7.Color ~= nil then
			if typeof(t7.Color) == "Color3" then
				t8.Color = t7.Color
			elseif type(t7.Color) == "table" then
				local t9: {[any]: any} = {}

				for _, v in ipairs(t7.Color) do
					if typeof(v) == "Color3" then
						t9[#t9 + 1] = v
					end
				end

				t8.Color = #t9 > 0 and t9 or v45.Color
			else
				t8.Color = v45.Color
			end
		end

		if t7.Material ~= nil then
			t8.Material = typeof(t7.Material) == "EnumItem" and t7.Material or v45.Material
		end

		if t7.SpawnDur ~= nil then
			t8.SpawnDur = helpersNumOrRange(t7.SpawnDur, v45.SpawnDur)
		end

		if t7.Lifetime ~= nil then
			t8.Lifetime = helpersNumOrRange(t7.Lifetime, v45.Lifetime)
		end

		if t7.FadeTime ~= nil then
			t8.FadeTime = helpersNumOrRange(t7.FadeTime, v45.FadeTime)
		end

		if t7.Branch_Amount ~= nil then
			t8.Branch_Amount = helpersNumOrRange(t7.Branch_Amount, v45.Branch_Amount)
		end

		if t7.Branch_ThicknessFactor ~= nil then
			t8.Branch_ThicknessFactor = helpersClampNumber(t7.Branch_ThicknessFactor, v45.Branch_ThicknessFactor, 0)
		end

		if t7.Branch_ThicknessRandomness ~= nil then
			t8.Branch_ThicknessRandomness = helpersClampNumber(t7.Branch_ThicknessRandomness, v45.Branch_ThicknessRandomness, 0, 1)
		end

		if t7.Branch_Span ~= nil then
			t8.Branch_Span = helpersToRange(t7.Branch_Span, v45.Branch_Span, 2)
		end

		if t7.Branch_Segments ~= nil then
			t8.Branch_Segments = helpersToRange(t7.Branch_Segments, v45.Branch_Segments, 2)
		end

		if t7.Branch_LengthFactor ~= nil then
			t8.Branch_LengthFactor = helpersToRange(t7.Branch_LengthFactor, v45.Branch_LengthFactor, 0)
		end

		if t7.AnimationType ~= nil then
			local v51 = t7.AnimationType

			if v51 ~= "None" and v51 ~= "Sway" and v51 ~= "Rebuild" then
				v51 = v45.AnimationType
			end

			t8.AnimationType = v51
		end

		if t7.RebuildType ~= nil then
			local v52 = t7.RebuildType

			if v52 ~= "Fair" and v52 ~= "FocusLast" then
				v52 = v45.RebuildType
			end

			t8.RebuildType = v52
		end

		if t7.Sway_MaxOffsetFactor ~= nil then
			t8.Sway_MaxOffsetFactor = helpersClampNumber(t7.Sway_MaxOffsetFactor, v45.Sway_MaxOffsetFactor, 0)
		end

		if t7.Sway_FalloffPower ~= nil then
			t8.Sway_FalloffPower = helpersClampNumber(t7.Sway_FalloffPower, v45.Sway_FalloffPower, 0.01)
		end

		if t7.Sway_Grabs ~= nil then
			t8.Sway_Grabs = helpersNumOrRange(t7.Sway_Grabs, v45.Sway_Grabs)
		end

		if t7.RebuildTimes ~= nil then
			t8.RebuildTimes = helpersNumOrRange(t7.RebuildTimes, v45.RebuildTimes)
		end

		if t7.RebuildStrength ~= nil then
			t8.RebuildStrength = helpersClampNumber(t7.RebuildStrength, v45.RebuildStrength, 0)
		end

		if t7.Raycast ~= nil then
			t8.Raycast = typeof(t7.Raycast) == "boolean" and t7.Raycast or v45.Raycast
		end

		if t7.RaycastParams ~= nil then
			t8.RaycastParams = typeof(t7.RaycastParams) == "RaycastParams" and t7.RaycastParams or v45.RaycastParams
		end

		if t7.FolderName ~= nil then
			t8.FolderName = typeof(t7.FolderName) == "string" and t7.FolderName or v45.FolderName
		end

		if t7.Parent ~= nil then
			t8.Parent = typeof(t7.Parent) == "Instance" and t7.Parent or v45.Parent
		end

		return t8
	end
}

function module.UsePreset(p7, p8)
	local v55 = presets.Get(p7)
	local v56 = module.Config(v55)
	local t10: {[any]: any} = {}

	for k, v in pairs(t1) do
		t10[k] = v
	end

	if v56 then
		for k, v in pairs(v56) do
			t10[k] = v
		end
	end

	v56 = module.Config(p8)

	local t11: {[any]: any} = {}

	for k, v in pairs(t10) do
		t11[k] = v
	end

	if v56 then
		for k, v in pairs(v56) do
			t11[k] = v
		end
	end

	return t11
end

local t3: {[any]: any} = {}

t3.__index = t3

local function buildStormParamsFull(p9)
	local v68 = sanitizeStormParamsPatch(p9)

	assert(v68.StartVolume, "StormParams.StartVolume must be a BasePart")
	assert(v68.EndVolume, "StormParams.EndVolume must be a BasePart")

	return {
		SpawnRate = v68.SpawnRate or NumberRange.new(1, 1),
		StartVolume = v68.StartVolume,
		EndVolume = v68.EndVolume,
		AreaSize = v68.AreaSize or 1,
		OnHit = v68.OnHit
	}
end
function module.Storm(p10, p11)
	local v71 = module.Config(p11)
	local t12: {[any]: any} = {}

	for k, v in pairs(t1) do
		t12[k] = v
	end

	if v71 then
		for k, v in pairs(v71) do
			t12[k] = v
		end
	end

	return (setmetatable({ _running = false, Config = t12, _params = buildStormParamsFull(p10) }, t3))
end
function t3.SetConfig(p12, p13)
	local v79 = module.Config(p13)
	local config: {[any]: any} = {}

	for k, v in pairs(p12.Config) do
		config[k] = v
	end

	if v79 then
		for k, v in pairs(v79) do
			config[k] = v
		end
	end

	p12.Config = config
end
function t3.SetParams(p14, p15)
	if not p15 then
		return
	end

	local v87 = sanitizeStormParamsPatch(p15)
	local t14: {[any]: any} = {}

	for k, v in pairs(p14._params) do
		t14[k] = v
	end

	if v87 then
		for k, v in pairs(v87) do
			t14[k] = v
		end
	end

	p14._params = t14
end
local function pickEndPoint_ByClosestSegment(p16, p17, p18)
	local v96 = math.clamp(p18, 0, 1)
	local v97 = helpersRandomPointInPart(p16)
	local v98 = helpersFindClosestPoint(p16, p17)
	local n1

	if v96 <= 0 then
		n1 = 0
	else
		n1 = math.random() * v96
	end

	return v98:Lerp(v97, n1)
end
local function sampleRange(p19)
	local min = p19.Min
	local n1 = p19.Max - p19.Min
	local randomNumber = math.random()

	return min + n1 * randomNumber
end
function t3.Start(p20)
	if p20._running then
		return
	end

	p20._running = true
	task.spawn(function()
		while p20._running do
			local _params = p20._params
			local v203 = helpersRandomPointInPart(_params.StartVolume)
			local _paramsEndVolume = _params.EndVolume
			local v205 = math.clamp(_params.AreaSize or 1, 0, 1)
			local v206 = helpersRandomPointInPart(_paramsEndVolume)
			local v207 = helpersFindClosestPoint(_paramsEndVolume, v203)
			local n1

			if v205 <= 0 then
				n1 = 0
			else
				n1 = math.random() * v205
			end

			local v209 = v207:Lerp(v206, n1)

			p20:Strike(v203, v209)

			local _paramsSpawnRate = _params.SpawnRate
			local _paramsSpawnRateMin = _paramsSpawnRate.Min

			v207 = _paramsSpawnRate.Max - _paramsSpawnRate.Min

			local randomNumber = math.random()
			local v213 = math.max(_paramsSpawnRateMin + v207 * randomNumber, 0.001)

			task.wait(1 / v213)
		end
	end)
end
function t3.Stop(p21)
	p21._running = false
end
local function sampleNum(p22)
	if typeof(p22) == "number" then
		return p22
	end

	local min = p22.Min
	local n1 = p22.Max - p22.Min
	local randomNumber = math.random()

	return min + n1 * randomNumber
end
local function sampleInt(p23)
	local v112

	if typeof(p23) == "number" then
		v112 = p23
	else
		local min = p23.Min
		local n1 = p23.Max - p23.Min
		local randomNumber = math.random()

		v112 = min + n1 * randomNumber
	end

	return (math.floor(v112 + 0.5))
end
local function ResolveConfig(p24)
	local segments = p24.Segments
	local v117 = if typeof(segments) == "number" then segments else segments.Min + (segments.Max - segments.Min) * math.random()
	local floored = math.floor(v117 + 0.5)
	local t15: {[any]: any} = { Segments = math.max(2, floored) }
	local jaggedness = p24.Jaggedness

	t15.Jaggedness = if typeof(jaggedness) == "number" then jaggedness else jaggedness.Min + (jaggedness.Max - jaggedness.Min) * math.random()

	local curvature = p24.Curvature
	local v122 = if typeof(curvature) == "number" then curvature else curvature.Min + (curvature.Max - curvature.Min) * math.random()

	t15.Curvature = math.clamp(v122, 0, 1)

	local curveBreaks = p24.CurveBreaks
	local v124 = if typeof(curveBreaks) == "number" then curveBreaks else curveBreaks.Min + (curveBreaks.Max - curveBreaks.Min) * math.random()
	local floored2 = math.floor(v124 + 0.5)

	t15.CurveBreaks = math.max(0, floored2)

	local thickness = p24.Thickness
	local v127 = if typeof(thickness) == "number" then thickness else thickness.Min + (thickness.Max - thickness.Min) * math.random()

	t15.Thickness = math.max(0, v127)

	local v128 = p24.Color
	local v130

	if typeof(v128) == "Color3" then
		v130 = v128
	elseif type(v128) == "table" then
		local n1: number = #v128

		if n1 >= 1 then
			local randomNumber = math.random(1, n1)
			local v132 = v128[randomNumber]

			v130 = if typeof(v132) == "Color3" then v132 else t1.Color
		else
			v130 = t1.Color
		end
	else
		v130 = t1.Color
	end

	t15.Color = v130
	t15.Material = p24.Material

	local spawnDur = p24.SpawnDur
	local v134 = if typeof(spawnDur) == "number" then spawnDur else spawnDur.Min + (spawnDur.Max - spawnDur.Min) * math.random()

	t15.SpawnDur = math.max(0, v134)

	local lifetime = p24.Lifetime
	local v136 = if typeof(lifetime) == "number" then lifetime else lifetime.Min + (lifetime.Max - lifetime.Min) * math.random()

	t15.Lifetime = math.max(0, v136)

	local fadeTime = p24.FadeTime
	local v138 = if typeof(fadeTime) == "number" then fadeTime else fadeTime.Min + (fadeTime.Max - fadeTime.Min) * math.random()

	t15.FadeTime = math.max(0, v138)

	local branch_Amount = p24.Branch_Amount
	local v140 = if typeof(branch_Amount) == "number" then branch_Amount else branch_Amount.Min + (branch_Amount.Max - branch_Amount.Min) * math.random()
	local floored3 = math.floor(v140 + 0.5)

	t15.Branch_Amount = math.max(0, floored3)
	t15.Branch_ThicknessFactor = math.max(0, p24.Branch_ThicknessFactor)
	t15.Branch_ThicknessRandomness = math.clamp(p24.Branch_ThicknessRandomness, 0, 1)
	t15.Branch_Span = p24.Branch_Span
	t15.Branch_Segments = p24.Branch_Segments
	t15.Branch_LengthFactor = p24.Branch_LengthFactor
	t15.AnimationType = p24.AnimationType
	t15.Sway_MaxOffsetFactor = math.max(0, p24.Sway_MaxOffsetFactor)
	t15.Sway_FalloffPower = math.max(0.01, p24.Sway_FalloffPower)

	local sway_Grabs = p24.Sway_Grabs
	local v143 = if typeof(sway_Grabs) == "number" then sway_Grabs else sway_Grabs.Min + (sway_Grabs.Max - sway_Grabs.Min) * math.random()
	local floored4 = math.floor(v143 + 0.5)

	t15.Sway_Grabs = math.max(0, floored4)
	t15.RebuildType = p24.RebuildType

	local rebuildTimes = p24.RebuildTimes
	local v147

	if typeof(rebuildTimes) == "number" then
		v147 = rebuildTimes
	else
		local rebuildTimesMin = rebuildTimes.Min
		local n2 = rebuildTimes.Max - rebuildTimes.Min
		local randomNumber = math.random()

		v147 = rebuildTimesMin + n2 * randomNumber
	end

	local floored5 = math.floor(v147 + 0.5)

	t15.RebuildTimes = math.max(0, floored5)
	t15.RebuildStrength = math.max(0, p24.RebuildStrength)
	t15.Raycast = p24.Raycast
	t15.RaycastParams = p24.RaycastParams
	t15.FolderName = p24.FolderName
	t15.Parent = p24.Parent

	return t15
end
local function getFolder(p25)
	local parent = p25.Parent or workspace
	local foundChild = parent:FindFirstChild(p25.FolderName)

	if not foundChild then
		foundChild = Instance.new("Folder")
		foundChild.Name = p25.FolderName
		foundChild.Parent = parent
	end

	return foundChild
end
local function withHold(p26, lifetime)
	local v156 = table.clone(p26)

	v156.Lifetime = lifetime

	return v156
end
function t3.Strike(p28, p29, p30)
	local config = p28.Config
	local _params = p28._params
	local v162 = ResolveConfig(config)
	local u163 = nil

	if v162.Raycast then
		local n1 = p30 - p29
		local v165 = helpersSafeUnit(n1)

		u163 = workspace:Raycast(p29, v165 * (n1.Magnitude + 2000), v162.RaycastParams)

		if u163 then
			p30 = u163.Position
		end
	end

	local cFrame

	if u163 then
		local v168 = u163.Position
		local unit = u163.Normal.Unit
		local n2 = p30 - p29

		n2 = if n2.Magnitude < 0.000001 then Vector3.new(0, 0, -1) else n2.Unit

		local v170 = n2:Dot(unit)
		local n3 = n2 - unit * v170

		if n3.Magnitude < 0.000001 then
			local v172 = (Vector3.new(0, 0, -1)):Dot(unit)

			n3 = Vector3.new(0, 0, -1) - unit * v172

			if n3.Magnitude < 0.000001 then
				local v173 = (Vector3.new(1, 0, 0)):Dot(unit)

				n3 = Vector3.new(1, 0, 0) - unit * v173
			end
		end

		local cFrameFromMatrix = CFrame.fromMatrix
		local v175 = n3.Unit:Cross(unit)

		cFrame = cFrameFromMatrix(v168, v175.Unit, unit)
	else
		local n4 = p30 - p29

		if n4.Magnitude > 0 then
			cFrame = CFrame.lookAt(p30, p30 + n4.Unit)
		else
			cFrame = CFrame.new(p30)
		end
	end

	local parent = v162.Parent or workspace
	local foundChild = parent:FindFirstChild(v162.FolderName)

	if not foundChild then
		foundChild = Instance.new("Folder")
		foundChild.Name = v162.FolderName
		foundChild.Parent = parent
	end

	local strike: Folder = Instance.new("Folder")

	strike.Name = "Strike"
	strike.Parent = foundChild
	strike:SetAttribute("__LightningGen", 0)

	local v179 = math.max(v162.SpawnDur, 0)
	local v180 = math.max(v162.Lifetime, 0)
	local v181 = math.max(v162.FadeTime, 0)
	local n5 = v179 + v180 + v181

	debris:AddItem(strike, n5 + 1)

	local function clearStrikeFolder()
		for _, v in ipairs(strike:GetChildren()) do
			v:Destroy()
		end

		local __LightningGen: any = strike:GetAttribute("__LightningGen")

		strike:SetAttribute("__LightningGen", (__LightningGen or 0) + 1)
	end
	local function normalDrawer(p31, p32, p33, p34, p35)
		return helpersDrawBoltDynamic(p31, p32, p33, p34, p35)
	end

	v180 = function(p36)
		local v223 = ResolveConfig(config)
		local v224 = table.clone(p36)

		v224.Branch_Amount = v223.Branch_Amount
		v224.Branch_Span = v223.Branch_Span
		v224.Branch_Segments = v223.Branch_Segments
		v224.Branch_LengthFactor = v223.Branch_LengthFactor

		return v224
	end

	local v185 = helpersBuildPoints(p29, p30, v162.Segments, v162.Jaggedness, v162.Curvature, v162.CurveBreaks)
	local v186 = v162

	if v162.AnimationType == "Rebuild" and v162.RebuildType == "Fair" then
		v186 = table.clone(v162)
		v186.Lifetime = 0
	end

	local v187 = helpersDrawBoltDynamic(v185, strike, v186, v162.Thickness, nil)
	local v188 = ResolveConfig(config)
	local v189 = table.clone(v186)

	v189.Branch_Amount = v188.Branch_Amount
	v189.Branch_Span = v188.Branch_Span
	v189.Branch_Segments = v188.Branch_Segments
	v189.Branch_LengthFactor = v188.Branch_LengthFactor

	local v190 = helpersBranchMultiRejoin(v185, strike, v189, normalDrawer)
	local v191 = table.clone(v185)
	v186 = { {
		isBranch = false,
		pointsRef = v185,
		basePoints = v191,
		segRefs = v187,
		thicknessForOverlap = v162.Thickness
	} }

	for i = 1, #v190 do
		v186[#v186 + 1] = v190[i]
	end

	v190 = v162.AnimationType or "None"

	if v190 ~= "None" then
		if v190 == "Sway" then
			helpersRegisterSwayAnimation(v186, p29, p30, v162, n5, strike)
		elseif v190 == "Rebuild" then
			local v193 = math.max(0, v162.RebuildTimes)

			if v193 > 0 then
				local u194 = math.max(0.01, v162.Lifetime > 0 and v162.Lifetime / v193 or 0.01)

				local function nextInterval()
					local randomNumber = math.random()

					return (math.max(0.01, u194 * (1 + (randomNumber * 2 - 1) * 0.2)))
				end

				local v196 = math.max(0, v162.RebuildStrength)

				local function sampleBlend01()
					if v196 <= 0 then
						return 0
					end

					return 1 - math.random() ^ v196
				end

				local v198 = table.clone(v185)

				if (v162.RebuildType or "Fair") == "Fair" then
					task.spawn(function()
						local v226 = time()

						math.max(v162.SpawnDur, 0)

						local v227 = math.max(v162.Lifetime, 0)

						math.max(v162.FadeTime, 0)

						local v228 = table.clone(v162)

						v228.Lifetime = 0

						local n1: number = 0

						while n1 < v193 do
							local v230 = time()
							local n2 = v226 + v227 - v230

							if n2 <= 0 then
								break
							end

							local randomNumber = math.random()

							v230 = math.max(0.01, u194 * (1 + (randomNumber * 2 - 1) * 0.2))

							if v230 > n2 then
								v230 = n2
							end

							task.wait(v230)
							n1 += 1
							n2 = helpersBuildPoints(p29, p30, v162.Segments, v162.Jaggedness, v162.Curvature, v162.CurveBreaks)

							local n3

							if v196 <= 0 then
								n3 = 0
							else
								n3 = 1 - math.random() ^ v196
							end

							local v234 = table.create(#n2)

							for i = 1, #n2 do
								v234[i] = v198[i]:Lerp(n2[i], n3)
							end

							v234[1] = p29
							v234[#v234] = p30
							helpersDrawBoltDynamic(v234, strike, v228, v162.Thickness, nil)
							v230 = ResolveConfig(config)
							n2 = table.clone(v228)
							n2.Branch_Amount = v230.Branch_Amount
							n2.Branch_Span = v230.Branch_Span
							n2.Branch_Segments = v230.Branch_Segments
							n2.Branch_LengthFactor = v230.Branch_LengthFactor
							helpersBranchMultiRejoin(v234, strike, n2, normalDrawer)
						end
					end)
				else
					task.spawn(function()
						local n1: number = 0
						local lifetime = v162.Lifetime > 0 and v193 > 0 and v162.Lifetime / v193 or 0

						while n1 < v193 do
							local randomNumber = math.random()
							local v239 = math.max(0.01, u194 * (1 + (randomNumber * 2 - 1) * 0.2))

							task.wait(v239)
							n1 += 1

							local v240 = helpersBuildPoints(p29, p30, v162.Segments, v162.Jaggedness, v162.Curvature, v162.CurveBreaks)
							local n3

							if v196 <= 0 then
								n3 = 0
							else
								n3 = 1 - math.random() ^ v196
							end

							local v242 = table.create(#v240)

							for i = 1, #v240 do
								v242[i] = v198[i]:Lerp(v240[i], n3)
							end

							v242[1] = p29
							v242[#v242] = p30
							clearStrikeFolder()

							if n1 >= v193 then
								local v244 = table.clone(v162)

								v244.Lifetime = lifetime
								helpersDrawBoltDynamic(v242, strike, v244, v162.Thickness, nil)

								local v245 = ResolveConfig(config)
								local v246 = table.clone(v244)

								v246.Branch_Amount = v245.Branch_Amount
								v246.Branch_Span = v245.Branch_Span
								v246.Branch_Segments = v245.Branch_Segments
								v246.Branch_LengthFactor = v245.Branch_LengthFactor
								helpersBranchMultiRejoin(v242, strike, v246, normalDrawer)
							else
								local v247 = table.clone(v162)

								v247.Lifetime = v239
								v247.FadeTime = 0
								helpersDrawBoltDynamic(v242, strike, v247, v162.Thickness, nil)

								local v248 = ResolveConfig(config)
								local v249 = table.clone(v247)

								v249.Branch_Amount = v248.Branch_Amount
								v249.Branch_Span = v248.Branch_Span
								v249.Branch_Segments = v248.Branch_Segments
								v249.Branch_LengthFactor = v248.Branch_LengthFactor
								helpersBranchMultiRejoin(v242, strike, v249, normalDrawer)
							end
						end
					end)
				end
			end
		end
	end

	local _paramsOnHit = _params.OnHit

	if _paramsOnHit then
		local taskDelay = task.delay
		local v201 = math.max(v162.SpawnDur, 0)

		taskDelay(v201, function()
			_paramsOnHit(cFrame, u163)
		end)
	end
end

return module
