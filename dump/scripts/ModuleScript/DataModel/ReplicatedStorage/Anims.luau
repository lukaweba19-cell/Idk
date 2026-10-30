-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local t1: {[any]: any} = {}
local t2: {[any]: any} = {}
local u3 = nil
local n1: number = 0

u3 = function()
	n1 += 1

	if n1 == 20 then
		n1 = 0

		local t5: {[any]: any} = {}

		for k, _ in pairs(t1) do
			if not k.Parent then
				t1[k] = nil
				t2[k] = nil
			end
		end
	end
end

local function getLocation(p1, p2)
	local foundChild = nil

	for iterValue in string.gmatch(p2, "([^.]+)") do
		foundChild = (foundChild or p1):FindFirstChild(iterValue)
	end

	return foundChild
end

local t3: {[any]: any} = {
	Knives = { "KnifeRig", "KnifeRig_L", "KnifeRig_R" },
	Revolvers = { "RevolverRig" }
}

local function getRigAnimator(p3, p4)
	local v21 = p4:match("^([^.]+)%.")

	if not v21 then
		return nil
	end

	local v22 = t3[v21]

	if not v22 then
		return nil
	end

	for _, v in ipairs(v22) do
		local v = p3:FindFirstChild(v)

		if v and v:IsA("Model") then
			local animationController = v:FindFirstChildWhichIsA("AnimationController")

			if animationController then
				local animator = animationController:FindFirstChildWhichIsA("Animator")

				if animator then
					return animator
				end
			end
		end
	end

	return nil
end
local function isTrackAlive(p5)
	local u29 = false

	if p5 ~= nil then
		u29 = pcall(function()
			return p5.IsPlaying
		end)
	end

	return u29
end
local function wrapDualTrack(p6, p7)
	local t6: {[any]: any} = {}

	setmetatable(t6, {
		__index = function(_, p9)
			if p9 == "Play" then
				return function(_, ...)
					p6:Play(...)

					local v75 = p7
					local u76 = false

					if v75 ~= nil then
						u76 = pcall(function()
							return v75.IsPlaying
						end)
					end

					if u76 then
						p7:Play(...)
					end
				end
			end

			if p9 == "Stop" then
				return function(_, ...)
					p6:Stop(...)

					local v78 = p7
					local u79 = false

					if v78 ~= nil then
						u79 = pcall(function()
							return v78.IsPlaying
						end)
					end

					if u79 then
						p7:Stop(...)
					end
				end
			end

			if p9 == "AdjustSpeed" then
				return function(_, ...)
					p6:AdjustSpeed(...)

					local v81 = p7
					local u82 = false

					if v81 ~= nil then
						u82 = pcall(function()
							return v81.IsPlaying
						end)
					end

					if u82 then
						p7:AdjustSpeed(...)
					end
				end
			end

			if p9 == "AdjustWeight" then
				return function(_, ...)
					p6:AdjustWeight(...)

					local v84 = p7
					local u85 = false

					if v84 ~= nil then
						u85 = pcall(function()
							return v84.IsPlaying
						end)
					end

					if u85 then
						p7:AdjustWeight(...)
					end
				end
			end

			if p9 == "GetMarkerReachedSignal" then
				return function(_, ...)
					return p6:GetMarkerReachedSignal(...)
				end
			end

			if p9 == "GetTimeOfKeyframe" then
				return function(_, ...)
					return p6:GetTimeOfKeyframe(...)
				end
			end

			return p6[p9]
		end,
		__newindex = function(_, p17, p18)
			if p17 == "Looped" or p17 == "Priority" or p17 == "TimePosition" or p17 == "Speed" then
				p6[p17] = p18

				local v66 = p7
				local u67 = false

				if v66 ~= nil then
					u67 = pcall(function()
						return v66.IsPlaying
					end)
				end

				if u67 then
					p7[p17] = p18

					return
				end
			else
				p6[p17] = p18
			end
		end
	})

	return t6
end

local t4: {[any]: any} = {}
local u11 = nil
u11 = {
	Preload = function(p19, p20)
		local t7: {[any]: any} = {}
		local v36 = game:GetService("RunService"):IsClient() and getLocation(p20 or script.Default, p19)

		if v36 then
			if v36:IsA("Animation") and not t4[v36] then
				t4[v36] = true
				table.insert(t7, v36)
			else
				for _, v in pairs(v36:GetDescendants()) do
					if v:IsA("Animation") and not t4[v] then
						t4[v] = true
						table.insert(t7, v)
					end
				end
			end
		end

		if #t7 > 0 then
			print("Preloading:", #t7)
			task.spawn(function()
				game:GetService("ContentProvider"):PreloadAsync(t7)
			end)
		end
	end,
	Get = function(p21, p22, p23)
		if not t1[p21] then
			t1[p21] = {}
		end

		u3()

		local v42 = t1[p21][p22]

		if v42 then
			return v42
		end

		local v43 = getLocation(p23 or script.Default, p22)

		if not v43 and p23 ~= script.Default then
			v43 = getLocation(script.Default, p22)
		end

		local v44 = v43 and (p21:FindFirstChild("Humanoid") or p21:FindFirstChild("AnimationController"))

		if v44 then
			if v44.ClassName == "Humanoid" and v44:FindFirstChild("Animator") then
				v44 = v44.Animator
			end

			local v45 = v44:LoadAnimation(v43)
			local v46 = getRigAnimator(p21, p22)

			if v46 then
				if not t2[p21] then
					t2[p21] = {}
				end

				local animationTrack = v46:LoadAnimation(v43)

				t2[p21][p22] = animationTrack
				v45 = wrapDualTrack(v45, animationTrack)
			end

			t1[p21][p22] = v45

			return v45
		end
	end,
	GetTrack = function(p24, p25, p26)
		local v51 = p24:FindFirstChild("Humanoid") or p24:FindFirstChild("AnimationController")

		if v51 then
			if v51.ClassName == "Humanoid" and v51:FindFirstChild("Animator") then
				v51 = v51.Animator
			end

			local v52 = u11.Get(p24, p25, p26)

			if v52 then
				for _, v in pairs(v51:GetPlayingAnimationTracks()) do
					if v.Animation.AnimationId == v52.Animation.AnimationId then
						return v
					end
				end

				return
			end

			return
		end
	end,
	Play = function(p27, p28, p29, ...)
		local v58 = u11.Get(p27, p28, p29)

		if v58 then
			v58:Play(...)

			return v58
		end
	end,
	new = function(p30, p31)
		if typeof(p30) == "table" then
			p30 = p30.Character
		end

		t1[p30] = {}
		t2[p30] = {}

		return {
			Get = function(_, p33)
				return u11.Get(p30, p33, p31)
			end,
			GetTrack = function(_, p35)
				return u11.GetTrack(p30, p35, p31)
			end,
			Play = function(_, p37, ...)
				return u11.Play(p30, p37, p31, ...)
			end
		}
	end
}

return u11
