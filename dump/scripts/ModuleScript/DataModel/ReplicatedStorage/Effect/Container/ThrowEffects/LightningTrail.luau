-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local misc = require(game.ReplicatedStorage.Util.Misc)
local lightning = require(game.ReplicatedStorage.Util.Lightning)
local color3 = Color3.fromRGB(137, 153, 255)
local v5 = lightning.Config({
	Branch_ThicknessFactor = 0.45,
	Branch_ThicknessRandomness = 0.3,
	AnimationType = "Sway",
	Sway_MaxOffsetFactor = 0.05,
	Sway_FalloffPower = 1.4,
	Raycast = false,
	FolderName = "LightningKnifeFX",
	Segments = NumberRange.new(6, 12),
	Jaggedness = NumberRange.new(0.06, 0.12),
	Curvature = NumberRange.new(0.04, 0.1),
	CurveBreaks = NumberRange.new(1, 2),
	Thickness = NumberRange.new(0.08, 0.18),
	Color = color3,
	Material = Enum.Material.Neon,
	SpawnDur = NumberRange.new(0.01, 0.03),
	Lifetime = NumberRange.new(0.08, 0.75),
	FadeTime = NumberRange.new(0.06, 0.12),
	Branch_Amount = NumberRange.new(1, 2),
	Branch_Span = NumberRange.new(1, 3),
	Branch_Segments = NumberRange.new(2, 4),
	Branch_LengthFactor = NumberRange.new(0.1, 0.25),
	Sway_Grabs = NumberRange.new(2, 4),
	Parent = workspace
})
local v6 = lightning.UsePreset("ThinZap", v5)

v6.Raycast = false
v6.AnimationType = "Sway"
v6.Sway_MaxOffsetFactor = 0.05
v6.Sway_FalloffPower = 1.4
v6.Sway_Grabs = NumberRange.new(2, 4)
v6.Lifetime = NumberRange.new(0.08, 0.15)
v6.FadeTime = NumberRange.new(0.06, 0.12)
v6.SpawnDur = NumberRange.new(0.01, 0.03)

local v7 = lightning.Storm({
	SpawnRate = NumberRange.new(1, 1),
	StartVolume = workspace.Terrain,
	EndVolume = workspace.Terrain
}, v6)

v7.Config.Raycast = true

local random = Random.new()

local function randomPerp(p1)
	local absoluteValue = math.abs(p1.Y)

	absoluteValue = p1:Cross(if absoluteValue < 0.9 then Vector3.new(0, 1, 0) else Vector3.new(1, 0, 0)).Unit

	local unit = p1:Cross(absoluteValue).Unit
	local v13 = random:NextNumber(0, 6.283185307179586)
	local cosine = math.cos(v13)
	local sine = math.sin(v13)

	return (absoluteValue * cosine + unit * sine).Unit
end

return function(p2)
	local knife = p2.Knife

	if not knife then
		return
	end

	local function u18()
		task.wait(0.005)

		if knife:FindFirstChild("Trail") then
			knife.Trail.Enabled = true
		end

		misc.EmitAll(knife)
	end

	task.spawn(u18)

	local knifePosition = knife.Position

	u18 = true

	local connection = nil

	connection = knife.AncestryChanged:Connect(function()
		if not knife:IsDescendantOf(workspace) then
			u18 = false

			if connection then
				connection:Disconnect()
			end
		end
	end)
	task.spawn(function()
		while true do
			if not u18 or not knife or not knife.Parent or not knife:IsDescendantOf(workspace) then
				break
			end

			local knifePosition2 = knife.Position
			local n1 = knifePosition2 - knifePosition
			local magnitude = n1.Magnitude
			local v24 = runService.Heartbeat:Wait()
			local v25 = math.max(v24, 0.004166666666666667)
			local n2 = magnitude / v25

			knifePosition = knifePosition2

			if not (n2 < 20) then
				local v27 = math.clamp((n2 - 40) / 160, 0, 1)
				local n3 = v27 * 3.5 + 1.5
				local n4 = v27 * 1 + 1
				local v30 = n1.Unit

				if v30 ~= v30 then
					v30 = knife.CFrame.LookVector
				end

				local v31 = randomPerp(v30)
				local v32 = random:NextNumber(0.3, n3 * 0.5)

				v32 = knifePosition2 + v30 * -n4 + v31 * v32

				local v33 = random:NextNumber(0.5, n3 * 0.4)
				local v34 = randomPerp(v30)
				local v35 = random:NextNumber(0.1, n3 * 0.3)
				local n5 = knifePosition2 + v30 * v33 + v34 * v35

				if workspace:Raycast(knifePosition2, Vector3.new(0, -12, 0)) ~= nil then
					v7.Config.Raycast = true
				else
					v7.Config.Raycast = false
				end

				v31 = n5 - v32

				if v31.Magnitude > 7 then
					n5 = v32 + v31.Unit * 7
				end

				v7:Strike(v32, n5)

				if random:NextNumber() < v27 * 0.3 + 0.35 then
					local v37 = randomPerp(v30)
					local v38 = random:NextNumber(0.2, n3 * 0.35)
					local v39 = random:NextNumber(0.5, n4 * 0.7)
					local v40 = random:NextNumber(0.3, n3 * 0.25)
					local v41 = randomPerp(v30)
					local v42 = random:NextNumber(0.1, 0.5)

					v7:Strike(knifePosition2 + v30 * -v39 + v37 * v38, knifePosition2 + v30 * v40 + v41 * v42)
				end

				task.wait(v27 * -0.15 + 0.18)
			end
		end

		u18 = false

		if connection then
			connection:Disconnect()
		end
	end)
end
