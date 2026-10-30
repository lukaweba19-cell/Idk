-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local t1: {[any]: any} = {}

t1.__index = t1

local function ease(p1, p2, p3)
	if p2 == Enum.PoseEasingStyle.Constant then
		return 0
	end

	if p2 ~= Enum.PoseEasingStyle.Cubic then
		return p1
	end

	if p3 == Enum.PoseEasingDirection.In then
		return p1 * p1 * p1
	end

	if p3 == Enum.PoseEasingDirection.Out then
		local n1 = 1 - p1

		return 1 - n1 * n1 * n1
	end

	if p1 < 0.5 then
		return p1 * 4 * p1 * p1
	end

	local n2 = p1 * -2 + 2

	return 1 - n2 * n2 * n2 / 2
end
local function buildJointMaps(p4)
	local t2: {[any]: any} = {}
	local t3: {[any]: any} = {}

	for _, v in ipairs(p4:GetDescendants()) do
		if v:IsA("Motor6D") and v.Part0 and v.Part1 then
			t2[v.Part0.Name .. "/" .. v.Part1.Name] = v

			if t3[v.Part1.Name] == nil then
				t3[v.Part1.Name] = v
			end
		end
	end

	return t2, t3
end
function t1.Load(p15, p16)
	p15:Stop()
	p15.clip = p16

	for iterKey in pairs(p16.tracks) do
		p15.saved[iterKey] = iterKey.Transform
	end
end
function t1.Sample(p17, p18, p19)
	local clip = p17.clip

	if not clip then
		return
	end

	for k, v in pairs(clip.tracks) do
		if not p19 or k.Name ~= "CameraBone" then
			local vKeys = v.keys
			local n1: number = #vKeys

			if n1 == 1 or p18 <= vKeys[1].t then
				k.Transform = vKeys[1].cf
			elseif p18 >= vKeys[n1].t then
				k.Transform = vKeys[n1].cf
			else
				local v25 = vKeys[1]
				local v26 = vKeys[n1]

				for i = 1, n1 - 1 do
					if p18 >= vKeys[i].t and p18 <= vKeys[i + 1].t then
						v25 = vKeys[i]
						v26 = vKeys[i + 1]

						break
					end
				end

				local n2 = v26.t - v25.t
				local cf = v25.cf
				local v30 = v26.cf
				local v31 = ease(if n2 > 0 then (p18 - v25.t) / n2 else 0, v26.style, v26.dir)

				k.Transform = cf:Lerp(v30, v31)
			end
		end
	end
end
function t1.GetCameraBoneCFrame(p20)
	local humanoidRootPart = p20.rig:FindFirstChild("HumanoidRootPart")
	local cameraBone = humanoidRootPart and humanoidRootPart:FindFirstChild("CameraBone")

	if not humanoidRootPart or not cameraBone or not cameraBone:IsA("Motor6D") then
		return nil
	end

	local n1 = humanoidRootPart.CFrame * cameraBone.C0 * cameraBone.Transform
	local v36 = cameraBone.C1:Inverse()

	return n1 * v36
end
function t1.Stop(p21)
	for k, v in pairs(p21.saved) do
		if k.Parent then
			k.Transform = v
		end
	end

	table.clear(p21.saved)
	p21.clip = nil
end

return {
	BuildClip = function(p5, p6)
		local v42, v43 = buildJointMaps(p6)
		local t4 = {}

		for _, v in ipairs(p5:GetChildren()) do
			if v:IsA("Keyframe") then
				table.insert(t4, v)
			end
		end

		table.sort(t4, function(p7, p8)
			return p7.Time < p8.Time
		end)

		local t5: {[any]: any} = {}
		local t6: {[any]: any} = {}

		local function collect(p9, p10, p11)
			for _, v in ipairs(p9:GetChildren()) do
				if v:IsA("Pose") then
					local v66 = nil

					if p10 then
						v66 = v42[p10 .. "/" .. v.Name]
					end

					if not v66 then
						v66 = v43[v.Name]
					end

					if v66 then
						local t8 = t5[v66]

						if not t8 then
							t8 = {
								motor = v66,
								keys = {}
							}
							t5[v66] = t8
						end

						table.insert(t8.keys, {
							t = p11,
							cf = v.CFrame,
							style = v.EasingStyle,
							dir = v.EasingDirection
						})
					elseif p10 ~= nil then
						t6[v.Name] = true
					end

					collect(v, v.Name, p11)
				end
			end
		end

		for _, v in ipairs(t4) do
			collect(v, nil, v.Time)
		end

		t4 = 0

		for _, v in pairs(t5) do
			table.sort(v.keys, function(p12, p13)
				return p12.t < p13.t
			end)

			local v54 = v.keys[#v.keys]

			if v54 and t4 < v54.t then
				t4 = v54.t
			end
		end

		local t7: {[any]: any} = {}

		for iterKey in pairs(t6) do
			table.insert(t7, iterKey)
		end

		table.sort(t7)

		return { name = p5.Name, tracks = t5, length = t4 }, t7
	end,
	New = function(p14)
		local object = setmetatable({}, t1)

		object.rig = p14
		object.clip = nil
		object.saved = {}

		return object
	end
}
