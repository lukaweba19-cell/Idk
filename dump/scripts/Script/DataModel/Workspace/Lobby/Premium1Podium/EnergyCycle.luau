-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
game:GetService("RunService")

local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer: Player = players.LocalPlayer
local scriptParent: Instance = script.Parent
local weapons: Instance = scriptParent:WaitForChild("Weapons")
local gun: Instance = weapons:WaitForChild("Gun")
local knife: Instance = weapons:WaitForChild("Knife")
local t1: {[any]: any} = {}

for _, v in ipairs(scriptParent:GetDescendants()) do
	if v.Name == "VFXPart" and v:IsA("BasePart") then
		table.insert(t1, v)
	end
end

if #t1 > 1 then
	warn(("[EnergyCycle] %d parts named VFXPart under this podium; using %s"):format(#t1, t1[1]:GetFullName()))
end

local v11 = t1[1]
local u12 = nil
local surfacePart: Instance = scriptParent:FindFirstChild("SurfacePart")
local surfaceGui: Instance = surfacePart and surfacePart:FindFirstChild("SurfaceGui")
local v15: Instance = surfaceGui

if v15 then
	v15 = surfaceGui:FindFirstChild("Title")
end

if v15 and v15:IsA("TextLabel") then
	u12 = v15
else
	warn("[EnergyCycle] SurfacePart.SurfaceGui.Title not found -- title colour will not follow the theme")
end

local u16 = nil
local u17 = nil
local animate: Instance = scriptParent:FindFirstChild("Animate")

if animate and animate:IsA("BasePart") then
	u16 = animate
	u17 = animate.Color
end

local revolvers: Instance = replicatedStorage:WaitForChild("Revolvers")
local knives: Instance = replicatedStorage:WaitForChild("Knives")
local t2: {[any]: any} = {}

local function subtreeSig(p1)
	local v52 = t2[p1]

	if v52 then
		return v52
	end

	v52 = {}

	for _, v in ipairs(p1:GetDescendants()) do
		table.insert(v52, v.ClassName .. ":" .. v.Name)
	end

	table.sort(v52)

	local className = p1.ClassName
	local v56 = p1.Name
	local v57 = table.concat(v52, ",")
	local s1: string = className .. ":" .. v56 .. "{" .. v57 .. "}"

	t2[p1] = s1

	return s1
end
local function pathOf(p2, p3)
	local t6: {[any]: any} = {}
	local v62 = p2

	while true do
		local v63 = v62 and v62 ~= p3 and v62.Parent

		if not v63 then
			break
		end

		local t7: {[any]: any} = {}

		for i, v in ipairs(v63:GetChildren()) do
			if v.Name == v62.Name and v.ClassName == v62.ClassName then
				table.insert(t7, { inst = v, index = i })
			end
		end

		local n1 = 1

		if #t7 > 1 then
			table.sort(t7, function(p4, p5)
				local v139 = subtreeSig(p4.inst)
				local v140 = subtreeSig(p5.inst)

				if v139 ~= v140 then
					return v139 < v140
				end

				return p4.index < p5.index
			end)

			for i, v in ipairs(t7) do
				if v62 == v.inst then
					n1 = i

					break
				end
			end
		end

		local className = v62.ClassName
		local v71 = v62.Name
		local text: string = tostring(n1)

		table.insert(t6, 1, className .. ":" .. v71 .. "#" .. text)
		v62 = v63
	end

	return table.concat(t6, "/")
end
local function keyFor(p6, p7)
	if p6:IsA("SurfaceAppearance") then
		local v75 = p6.Parent

		if not v75 then
			return nil
		end

		return pathOf(v75, p7) .. "/<SurfaceAppearance>"
	end

	if not p6:IsA("ParticleEmitter") and not p6:IsA("Beam") and not p6:IsA("Trail") and not p6:IsA("BasePart") and not p6:IsA("Light") then
		return nil
	end

	return pathOf(p6, p7)
end
local function indexOf(p8)
	local t8: {[any]: any} = {}

	for _, v in ipairs(p8:GetDescendants()) do
		local v80 = keyFor(v, p8)

		if v80 then
			t8[v80] = if v:IsA("SurfaceAppearance") and v.Parent then v.Parent else v
		end
	end

	return t8
end

local t3: {[any]: any} = {
	"Color",
	"ColorMap",
	"NormalMap",
	"MetalnessMap",
	"RoughnessMap",
	"AlphaMode"
}

local function applySurface(parent, p10)
	local surfaceAppearance = parent:FindFirstChildOfClass("SurfaceAppearance")

	if surfaceAppearance then
		local u84: boolean = true

		for _, v in ipairs(t3) do
			if surfaceAppearance[v] ~= p10[v] then
				u84 = false

				break
			end
		end

		if u84 then
			return
		end
	end

	local clone = p10:Clone()

	clone.Parent = parent

	if surfaceAppearance then
		surfaceAppearance:Destroy()
	end
end
local function paint(p11, p12)
	local n1: number = 0
	local n2: number = 0

	for k, v in pairs(p11) do
		local v94 = p12[k]

		if not v94 then
			n2 += 1
		elseif pcall(function()
			if k:find("/<SurfaceAppearance>", 1, true) then
				local surfaceAppearance = v94:FindFirstChildOfClass("SurfaceAppearance")

				if surfaceAppearance then
					applySurface(v, surfaceAppearance)

					return
				end
			else
				if v:IsA("ParticleEmitter") or v:IsA("Beam") or v:IsA("Trail") then
					v.Color = v94.Color

					return
				end

				if v:IsA("BasePart") or v:IsA("Light") then
					v.Color = v94.Color
				end
			end
		end) then
			n1 += 1
		else
			n2 += 1
		end
	end

	return n1, n2
end

local t4: {[any]: any} = {}

local function hueOf(p13)
	return (Color3.toHSV(p13))
end
local function reHue(p14, p15)
	local v98, v99, v100 = Color3.toHSV(p14)

	return Color3.fromHSV(p15, v99, v100)
end
local function reHueSequence(p16, p17)
	local t9: {[any]: any} = {}

	for _, v in ipairs(p16.Keypoints) do
		table.insert(t9, ColorSequenceKeypoint.new(v.Time, reHue(v.Value, p17)))
	end

	return ColorSequence.new(t9)
end

if v11 then
	for _, v in ipairs(v11:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			table.insert(t4, { emitter = v, seq = v.Color })
		end
	end
end

local function tintPodium(p18)
	local v107 = Color3.toHSV(p18)

	for _, v in ipairs(t4) do
		if v.emitter.Parent then
			v.emitter.Color = reHueSequence(v.seq, v107)
		end
	end

	if u12 then
		local v110, v111, v112 = Color3.toHSV(p18)

		if v110 > 0.6 and v110 < 0.8 then
			u12.TextColor3 = Color3.fromRGB(0, 179, 255)
		else
			local v113 = u12
			local color3FromHSV = Color3.fromHSV
			local v115 = math.max(v111, 0.85)

			v113.TextColor3 = color3FromHSV(v110, v115 * 0.85, v112)
		end
	end

	if u16 and u17 then
		local v116, v117, v118 = Color3.toHSV(u17)
		local v119 = u16
		local v120 = Color3.fromHSV
		local v121 = math.max(v117, 0.85)

		v119.Color = v120(v107, v121, v118)
	end
end

local v36 = indexOf(gun)
local v37 = indexOf(knife)
local t5: {[any]: any} = {}

for _, v in ipairs({
	{ name = "Blue", gun = "BlueEnergyBlaster", knife = "BlueEnergyBlade" },
	{
		name = "Green",
		gun = "GreenEnergyBlaster",
		knife = "GreenEnergyBlade"
	},
	{ name = "Red", gun = "RedEnergyBlaster", knife = "RedEnergyBlade" }
}) do
	local vgun: Instance = revolvers:FindFirstChild(v.gun)
	local vknife: Instance = knives:FindFirstChild(v.knife)

	if vgun and vknife then
		local foundChild: Instance = vgun:FindFirstChild("Handle", true)
		local surfaceAppearance: Instance = foundChild and foundChild:FindFirstChildOfClass("SurfaceAppearance")
		local v45 = surfaceAppearance and surfaceAppearance.Color

		if not v45 then
			v45 = Color3.new(1, 1, 1)
		end

		local vName = v.name
		local v47 = indexOf(vgun)
		local v48 = indexOf(vknife)

		table.insert(t5, { name = vName, gun = v47, knife = v48, colour = v45 })
	else
		warn(("[EnergyCycle] missing variant %s / %s -- theme skipped"):format(v.gun, v.knife))
	end
end

indexOf = function(p19)
	local t10: {[any]: any} = {}

	for _, v in ipairs(p19:GetDescendants()) do
		if v:IsA("SurfaceAppearance") and v.Parent then
			local ParentName = v.Parent.Name
			local rounded = math.round(v.Color.R * 255)
			local rounded2 = math.round(v.Color.G * 255)
			local rounded3 = math.round(v.Color.B * 255)
			local v130 = v.ColorMap:match("%d+$")

			table.insert(t10, ("%s=%d,%d,%d/%s"):format(ParentName, rounded, rounded2, rounded3, v130 or "?"))
		end
	end

	table.sort(t10)

	return table.concat(t10, "  ")
end

local function applyTheme(p20)
	local v132 = t5[p20]

	if not v132 then
		return
	end

	local v133, v134 = paint(v36, v132.gun)
	local v135, v136 = paint(v37, v132.knife)

	tintPodium(v132.colour)

	if v134 + v136 > 0 and p20 == 1 then
		warn(("[EnergyCycle] %d gun / %d knife instance(s) have no counterpart in the source skins"):format(v134, v136))
	end
end

if #t5 == 0 then
	warn("[EnergyCycle] no usable themes -- podium left as authored")

	return
end

applyTheme(1)

local n1: number = 1

task.spawn(function()
	while scriptParent.Parent do
		task.wait(4)

		if LocalPlayer:GetAttribute("InMatch") ~= true then
			n1 = n1 % #t5 + 1
			applyTheme(n1)
		end
	end
end)
