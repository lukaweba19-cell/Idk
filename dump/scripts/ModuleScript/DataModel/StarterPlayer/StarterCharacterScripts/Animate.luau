-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return function()
	local scriptParent: Instance = script.Parent
	local torso: Instance = scriptParent:WaitForChild("Torso")
	local rightShoulder: Instance = torso:WaitForChild("Right Shoulder")
	local leftShoulder: Instance = torso:WaitForChild("Left Shoulder")
	local rightHip: Instance = torso:WaitForChild("Right Hip")
	local leftHip: Instance = torso:WaitForChild("Left Hip")

	torso:WaitForChild("Neck")

	local humanoid: Instance = scriptParent:WaitForChild("Humanoid")
	local s1: string = "Standing"

	local ok, result = pcall(function()
		return UserSettings():IsUserFeatureEnabled("UserAnimateScaleRun")
	end)

	local v11 = ok and result

	local function getRigScale()
		if v11 then
			return scriptParent:GetScale()
		end

		return 1
	end

	local s2 = ""
	local u14 = nil
	local u15 = nil
	local u16 = nil
	local n1 = 1
	local t1: {[any]: any} = {}
	local t2: {[any]: any} = { "dance1", "dance2", "dance3" }
	local t3: {[any]: any} = {
		wave = false,
		point = false,
		dance1 = true,
		dance2 = true,
		dance3 = true,
		laugh = false,
		cheer = false
	}

	function configureAnimationSet(name, p2)
		if t1[name] ~= nil then
			for _, v in pairs(t1[name].connections) do
				v:disconnect()
			end
		end

		t1[name] = {}
		t1[name].count = 0
		t1[name].totalWeight = 0
		t1[name].connections = {}

		local foundChild: Instance = script:FindFirstChild(name)

		if foundChild ~= nil then
			table.insert(t1[name].connections, foundChild.ChildAdded:connect(function(_)
				configureAnimationSet(name, p2)
			end))
			table.insert(t1[name].connections, foundChild.ChildRemoved:connect(function(_)
				configureAnimationSet(name, p2)
			end))

			local n1: number = 1

			for _, v in pairs(foundChild:GetChildren()) do
				if v:IsA("Animation") then
					table.insert(t1[name].connections, v.Changed:connect(function(_)
						configureAnimationSet(name, p2)
					end))
					t1[name][n1] = {}
					t1[name][n1].anim = v

					local weight = v:FindFirstChild("Weight")

					if weight == nil then
						t1[name][n1].weight = 1
					else
						t1[name][n1].weight = weight.Value
					end

					t1[name].count = t1[name].count + 1
					t1[name].totalWeight = t1[name].totalWeight + t1[name][n1].weight
					n1 += 1
				end
			end
		end

		if t1[name].count <= 0 then
			for k, v in pairs(p2) do
				t1[name][k] = {}
				t1[name][k].anim = Instance.new("Animation")
				t1[name][k].anim.Name = name
				t1[name][k].anim.AnimationId = v.id
				t1[name][k].weight = v.weight
				t1[name].count = t1[name].count + 1
				t1[name].totalWeight = t1[name].totalWeight + v.weight
			end
		end
	end

	local t4: {[any]: any} = {
		idle = {
			{ id = "http://www.roblox.com/asset/?id=180435571", weight = 9 },
			{ id = "http://www.roblox.com/asset/?id=180435792", weight = 1 }
		},
		walk = { { id = "http://www.roblox.com/asset/?id=180426354", weight = 10 } },
		run = { { id = "run.xml", weight = 10 } },
		jump = { { id = "http://www.roblox.com/asset/?id=125750702", weight = 10 } },
		fall = { { id = "http://www.roblox.com/asset/?id=180436148", weight = 10 } },
		climb = { { id = "http://www.roblox.com/asset/?id=180436334", weight = 10 } },
		sit = { { id = "http://www.roblox.com/asset/?id=178130996", weight = 10 } },
		toolnone = { { id = "http://www.roblox.com/asset/?id=182393478", weight = 10 } },
		toolslash = { { id = "http://www.roblox.com/asset/?id=129967390", weight = 10 } },
		toollunge = { { id = "http://www.roblox.com/asset/?id=129967478", weight = 10 } },
		wave = { { id = "http://www.roblox.com/asset/?id=128777973", weight = 10 } },
		point = { { id = "http://www.roblox.com/asset/?id=128853357", weight = 10 } },
		dance1 = {
			{ id = "http://www.roblox.com/asset/?id=182435998", weight = 10 },
			{ id = "http://www.roblox.com/asset/?id=182491037", weight = 10 },
			{ id = "http://www.roblox.com/asset/?id=182491065", weight = 10 }
		},
		dance2 = {
			{ id = "http://www.roblox.com/asset/?id=182436842", weight = 10 },
			{ id = "http://www.roblox.com/asset/?id=182491248", weight = 10 },
			{ id = "http://www.roblox.com/asset/?id=182491277", weight = 10 }
		},
		dance3 = {
			{ id = "http://www.roblox.com/asset/?id=182436935", weight = 10 },
			{ id = "http://www.roblox.com/asset/?id=182491368", weight = 10 },
			{ id = "http://www.roblox.com/asset/?id=182491423", weight = 10 }
		},
		laugh = { { id = "http://www.roblox.com/asset/?id=129423131", weight = 10 } },
		cheer = { { id = "http://www.roblox.com/asset/?id=129423030", weight = 10 } }
	}

	function scriptChildModified(p6)
		local v50 = t4[p6.Name]

		if v50 ~= nil then
			configureAnimationSet(p6.Name, v50)
		end
	end

	script.ChildAdded:connect(scriptChildModified)
	script.ChildRemoved:connect(scriptChildModified)

	local animator = if humanoid then humanoid:FindFirstChildOfClass("Animator") else nil

	if animator then
		local animationTracks = animator:GetPlayingAnimationTracks()

		for _, v in ipairs(animationTracks) do
			v:Stop(0)
			v:Destroy()
		end
	end

	for k, v in pairs(t4) do
		configureAnimationSet(k, v)
	end

	local s3 = "None"
	local n2 = 0
	local n3 = 0

	function stopAllAnimations()
		local v51: string = s2

		if t3[v51] ~= nil and t3[v51] == false then
			v51 = "idle"
		end

		s2 = ""
		u14 = nil

		if u16 ~= nil then
			u16:disconnect()
		end

		if u15 ~= nil then
			u15:Stop()
			u15:Destroy()
			u15 = nil
		end

		return v51
	end
	function setAnimationSpeed(p7)
		if p7 ~= n1 then
			n1 = p7
			u15:AdjustSpeed(n1)
		end
	end
	function keyFrameReachedFunc(p8)
		if p8 == "End" then
			local v54: string = s2

			if t3[v54] ~= nil and t3[v54] == false then
				v54 = "idle"
			end

			local v55 = n1

			playAnimation(v54, 0, humanoid)
			setAnimationSpeed(v55)
		end
	end
	function playAnimation(p9, p10, p11)
		local randomNumber = math.random(1, t1[p9].totalWeight)
		local n2: number = 1

		while randomNumber > t1[p9][n2].weight do
			randomNumber -= t1[p9][n2].weight
			n2 += 1
		end

		local anim = t1[p9][n2].anim

		if anim ~= u14 then
			if u15 ~= nil then
				u15:Stop(p10)
				u15:Destroy()
			end

			n1 = 1
			u15 = p11:LoadAnimation(anim)
			u15.Priority = Enum.AnimationPriority.Core
			u15:Play(p10)
			s2 = p9
			u14 = anim

			if u16 ~= nil then
				u16:disconnect()
			end

			u16 = u15.KeyframeReached:connect(keyFrameReachedFunc)
		end
	end

	local s4 = ""
	local u32 = nil
	local u33 = nil
	local u34 = nil

	function toolKeyFrameReachedFunc(p12)
		if p12 == "End" then
			playToolAnimation(s4, 0, humanoid)
		end
	end
	function playToolAnimation(p13, p14: number, p15, priority)
		local randomNumber = math.random(1, t1[p13].totalWeight)
		local n1: number = 1

		while randomNumber > t1[p13][n1].weight do
			randomNumber -= t1[p13][n1].weight
			n1 += 1
		end

		local anim = t1[p13][n1].anim

		if u33 ~= anim then
			if u32 ~= nil then
				u32:Stop()
				u32:Destroy()
				p14 = 0
			end

			u32 = p15:LoadAnimation(anim)

			if priority then
				u32.Priority = priority
			end

			u32:Play(p14)
			s4 = p13
			u33 = anim
			u34 = u32.KeyframeReached:connect(toolKeyFrameReachedFunc)
		end
	end
	function stopToolAnimations()
		local v70 = s4

		if u34 ~= nil then
			u34:disconnect()
		end

		s4 = ""
		u33 = nil

		if u32 ~= nil then
			u32:Stop()
			u32:Destroy()
			u32 = nil
		end

		return v70
	end
	function onRunning(p17)
		local v72 = if v11 then scriptParent:GetScale() else 1
		local n1 = p17 / v72

		if n1 > 0.01 then
			playAnimation("walk", 0.1, humanoid)

			if u14 and u14.AnimationId == "http://www.roblox.com/asset/?id=180426354" then
				setAnimationSpeed(n1 / 14.5)
			end

			s1 = "Running"
		elseif t3[s2] == nil then
			playAnimation("idle", 0.1, humanoid)
			s1 = "Standing"
		end
	end
	function onDied()
		s1 = "Dead"
	end
	function onJumping()
		playAnimation("jump", 0.1, humanoid)
		n3 = 0.3
		s1 = "Jumping"
	end
	function onClimbing(p18)
		local v75 = if v11 then scriptParent:GetScale() else 1

		playAnimation("climb", 0.1, humanoid)
		setAnimationSpeed(p18 / v75 / 12)
		s1 = "Climbing"
	end
	function onGettingUp()
		s1 = "GettingUp"
	end
	function onFreeFall()
		if n3 <= 0 then
			playAnimation("fall", 0.3, humanoid)
		end

		s1 = "FreeFall"
	end
	function onFallingDown()
		s1 = "FallingDown"
	end
	function onSeated()
		s1 = "Seated"
	end
	function onPlatformStanding()
		s1 = "PlatformStanding"
	end
	function onSwimming(p19)
		if p19 > 0 then
			s1 = "Running"

			return
		end

		s1 = "Standing"
	end
	function getTool()
		for _, v in ipairs(scriptParent:GetChildren()) do
			if v.className == "Tool" then
				return v
			end
		end

		return nil
	end
	function getToolAnim(p20)
		for _, v in ipairs(p20:GetChildren()) do
			if v.Name == "toolanim" and v.className == "StringValue" then
				return v
			end
		end

		return nil
	end
	function animateTool()
		if s3 == "None" then
			playToolAnimation("toolnone", 0.1, humanoid, Enum.AnimationPriority.Idle)
		elseif s3 == "Slash" then
			playToolAnimation("toolslash", 0, humanoid, Enum.AnimationPriority.Action)
		elseif s3 == "Lunge" then
			playToolAnimation("toollunge", 0, humanoid, Enum.AnimationPriority.Action)

			return
		end
	end
	function moveSit()
		rightShoulder.MaxVelocity = 0.15
		leftShoulder.MaxVelocity = 0.15
		rightShoulder:SetDesiredAngle(1.57)
		leftShoulder:SetDesiredAngle(-1.57)
		rightHip:SetDesiredAngle(1.57)
		leftHip:SetDesiredAngle(-1.57)
	end

	local n4 = 0

	function move(p21)
		local n1: number = 1
		local n5: number = 1
		local n6 = p21 - n4

		n4 = p21

		local u86 = false

		if n3 > 0 then
			n3 -= n6
		end

		if s1 == "FreeFall" and n3 <= 0 then
			playAnimation("fall", 0.3, humanoid)
		else
			if s1 == "Seated" then
				playAnimation("sit", 0.5, humanoid)

				return
			end

			if s1 == "Running" then
				playAnimation("walk", 0.1, humanoid)
			elseif s1 == "Dead" or s1 == "GettingUp" or s1 == "FallingDown" or s1 == "Seated" or s1 == "PlatformStanding" then
				stopAllAnimations()
				n1 = 0.1
				n5 = 1
				u86 = true
			end
		end

		if u86 then
			local sine = math.sin(p21 * n5)
			local n7 = n1 * sine

			rightShoulder:SetDesiredAngle(n7 + 0)
			leftShoulder:SetDesiredAngle(n7 - 0)
			rightHip:SetDesiredAngle(-n7)
			leftHip:SetDesiredAngle(-n7)
		end

		u86 = getTool()

		if u86 and u86:FindFirstChild("Handle") then
			local toolAnim = getToolAnim(u86)

			if toolAnim then
				s3 = toolAnim.Value
				toolAnim.Parent = nil
				n2 = p21 + 0.3
			end

			if p21 > n2 then
				n2 = 0
				s3 = "None"
			end

			animateTool()

			return
		end

		stopToolAnimations()
		s3 = "None"
		u33 = nil
		n2 = 0
	end

	humanoid.Died:connect(onDied)
	humanoid.Running:connect(onRunning)
	humanoid.Jumping:connect(onJumping)
	humanoid.Climbing:connect(onClimbing)
	humanoid.GettingUp:connect(onGettingUp)
	humanoid.FreeFalling:connect(onFreeFall)
	humanoid.FallingDown:connect(onFallingDown)
	humanoid.Seated:connect(onSeated)
	humanoid.PlatformStanding:connect(onPlatformStanding)
	humanoid.Swimming:connect(onSwimming)

	if game:GetService("Players").LocalPlayer then
		game:GetService("Players").LocalPlayer.Chatted:connect(function(p22)
			local s2 = ""

			if p22 == "/e dance" then
				local randomNumber = math.random(1, #t2)

				s2 = t2[randomNumber]
			elseif string.sub(p22, 1, 3) == "/e " then
				s2 = string.sub(p22, 4)
			elseif string.sub(p22, 1, 7) == "/emote " then
				s2 = string.sub(p22, 8)
			end

			if s1 == "Standing" and t3[s2] ~= nil then
				playAnimation(s2, 0.1, humanoid)
			end
		end)
	end

	script:WaitForChild("PlayEmote").OnInvoke = function(p23)
		if s1 ~= "Standing" then
			return
		end

		if t3[p23] == nil then
			return false
		end

		playAnimation(p23, 0.1, humanoid)

		return true, u15
	end

	playAnimation("idle", 0.1, humanoid)
	s1 = "Standing"

	while scriptParent.Parent ~= nil do
		local v36, v37 = wait(0.1)

		move(v37)
	end
end
