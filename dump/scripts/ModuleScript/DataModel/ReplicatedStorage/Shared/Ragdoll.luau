-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return function(p1, p2)
	local humanoid = p1:FindFirstChild("Humanoid")
	local head = p1:FindFirstChild("Head")
	local foundChild = p1:FindFirstChild("Right Arm")
	local foundChild2 = p1:FindFirstChild("Right Leg")
	local foundChild3 = p1:FindFirstChild("Left Arm")
	local foundChild4 = p1:FindFirstChild("Left Leg")
	local torso = p1:FindFirstChild("Torso")

	p1:FindFirstChild("HumanoidRootPart")
	humanoid.BreakJointsOnDeath = false
	humanoid:ChangeState(Enum.HumanoidStateType.Physics)

	local torsoToHead1: Attachment = Instance.new("Attachment")

	torsoToHead1.Position = Vector3.new(0, -0.6, 0)
	torsoToHead1.Name = "TorsoToHead1"
	torsoToHead1.Parent = head

	local torsoToRightArm1: Attachment = Instance.new("Attachment")

	torsoToRightArm1.Position = Vector3.new(-0.5, 0.5, 0)
	torsoToRightArm1.Name = "TorsoToRightArm1"
	torsoToRightArm1.Parent = foundChild

	local torsoToRightLeg1: Attachment = Instance.new("Attachment")

	torsoToRightLeg1.Position = Vector3.new(0, 1, 0)
	torsoToRightLeg1.Name = "TorsoToRightLeg1"
	torsoToRightLeg1.Parent = foundChild2

	local torsoToLeftArm1: Attachment = Instance.new("Attachment")

	torsoToLeftArm1.Position = Vector3.new(0.5, 0.5, 0)
	torsoToLeftArm1.Name = "TorsoToLeftArm1"
	torsoToLeftArm1.Parent = foundChild3

	local torsoToLeftLeg1: Attachment = Instance.new("Attachment")

	torsoToLeftLeg1.Position = Vector3.new(0, 1, 0)
	torsoToLeftLeg1.Name = "TorsoToLeftLeg1"
	torsoToLeftLeg1.Parent = foundChild4

	local torsoToHead0: Attachment = Instance.new("Attachment")

	torsoToHead0.Position = Vector3.new(0, 1, 0)
	torsoToHead0.Name = "TorsoToHead0"
	torsoToHead0.Parent = torso

	local torsoToRightArm0: Attachment = Instance.new("Attachment")

	torsoToRightArm0.Position = Vector3.new(1, 0.5, 0)
	torsoToRightArm0.Name = "TorsoToRightArm0"
	torsoToRightArm0.Parent = torso

	local attachment: Attachment = Instance.new("Attachment")

	attachment.Position = Vector3.new(0.5, -1, 0)
	attachment.Name = "TorsoToRightArm0"
	attachment.Parent = torso

	local torsoToLeftArm0: Attachment = Instance.new("Attachment")

	torsoToLeftArm0.Position = Vector3.new(-1, 0.5, 0)
	torsoToLeftArm0.Name = "TorsoToLeftArm0"
	torsoToLeftArm0.Parent = torso

	local torsoToLeftLeg0: Attachment = Instance.new("Attachment")

	torsoToLeftLeg0.Position = Vector3.new(-0.5, -1, 0)
	torsoToLeftLeg0.Name = "TorsoToLeftLeg0"
	torsoToLeftLeg0.Parent = torso

	if not torso.Parent then
		return
	end

	local function CreateBallSocket(attachment0, attachment1, twistLowerAngle, twistUpperAngle)
		local ballSocketConstraint: BallSocketConstraint = Instance.new("BallSocketConstraint")

		ballSocketConstraint.Attachment0 = attachment0
		ballSocketConstraint.Attachment1 = attachment1
		ballSocketConstraint.LimitsEnabled = true
		ballSocketConstraint.TwistLimitsEnabled = true
		ballSocketConstraint.TwistLowerAngle = twistLowerAngle
		ballSocketConstraint.TwistUpperAngle = twistUpperAngle
		ballSocketConstraint.MaxFrictionTorque = 10
		ballSocketConstraint.Parent = torso
	end

	local ballSocketConstraint: BallSocketConstraint = Instance.new("BallSocketConstraint")

	ballSocketConstraint.Attachment0 = torsoToHead0
	ballSocketConstraint.Attachment1 = torsoToHead1
	ballSocketConstraint.LimitsEnabled = true
	ballSocketConstraint.TwistLimitsEnabled = true
	ballSocketConstraint.TwistLowerAngle = -45
	ballSocketConstraint.TwistUpperAngle = 45
	ballSocketConstraint.MaxFrictionTorque = 10
	ballSocketConstraint.Parent = torso

	local ballSocketConstraint2: BallSocketConstraint = Instance.new("BallSocketConstraint")

	ballSocketConstraint2.Attachment0 = torsoToRightArm0
	ballSocketConstraint2.Attachment1 = torsoToRightArm1
	ballSocketConstraint2.LimitsEnabled = true
	ballSocketConstraint2.TwistLimitsEnabled = true
	ballSocketConstraint2.TwistLowerAngle = 45
	ballSocketConstraint2.TwistUpperAngle = 0
	ballSocketConstraint2.MaxFrictionTorque = 10
	ballSocketConstraint2.Parent = torso

	local ballSocketConstraint3: BallSocketConstraint = Instance.new("BallSocketConstraint")

	ballSocketConstraint3.Attachment0 = torsoToLeftArm0
	ballSocketConstraint3.Attachment1 = torsoToLeftArm1
	ballSocketConstraint3.LimitsEnabled = true
	ballSocketConstraint3.TwistLimitsEnabled = true
	ballSocketConstraint3.TwistLowerAngle = 0
	ballSocketConstraint3.TwistUpperAngle = 45
	ballSocketConstraint3.MaxFrictionTorque = 10
	ballSocketConstraint3.Parent = torso

	local ballSocketConstraint4: BallSocketConstraint = Instance.new("BallSocketConstraint")

	ballSocketConstraint4.Attachment0 = attachment
	ballSocketConstraint4.Attachment1 = torsoToRightLeg1
	ballSocketConstraint4.LimitsEnabled = true
	ballSocketConstraint4.TwistLimitsEnabled = true
	ballSocketConstraint4.TwistLowerAngle = -45
	ballSocketConstraint4.TwistUpperAngle = 45
	ballSocketConstraint4.MaxFrictionTorque = 10
	ballSocketConstraint4.Parent = torso

	local ballSocketConstraint5: BallSocketConstraint = Instance.new("BallSocketConstraint")

	ballSocketConstraint5.Attachment0 = torsoToLeftLeg0
	ballSocketConstraint5.Attachment1 = torsoToLeftLeg1
	ballSocketConstraint5.LimitsEnabled = true
	ballSocketConstraint5.TwistLimitsEnabled = true
	ballSocketConstraint5.TwistLowerAngle = -45
	ballSocketConstraint5.TwistUpperAngle = 45
	ballSocketConstraint5.MaxFrictionTorque = 10
	ballSocketConstraint5.Parent = torso
	humanoid.AutoRotate = false

	local foundChild5 = torso:FindFirstChild("Left Hip")

	if foundChild5 then
		foundChild5.Enabled = false
	end

	local foundChild6 = torso:FindFirstChild("Left Shoulder")

	if foundChild6 then
		foundChild6.Enabled = false
	end

	local neck = torso:FindFirstChild("Neck")

	if neck then
		neck.Enabled = false
	end

	local foundChild7 = torso:FindFirstChild("Right Shoulder")

	if foundChild7 then
		foundChild7.Enabled = false
	end

	local foundChild8 = torso:FindFirstChild("Right Hip")

	if foundChild8 then
		foundChild8.Enabled = false
	end

	if p2 then
		local v31 = game.Players:GetPlayerFromCharacter(p1)

		if v31 then
			local applyVelocity = game.ReplicatedStorage.Remotes.ApplyVelocity
			local v33 = CFrame.lookAt(Vector3.new(0, 0, 0), p2)

			applyVelocity:FireClient(v31, torso, p2 * 0.95, v33.RightVector * -p2.Magnitude * 0.2)
		end

		if torso then
			task.spawn(function()
				for _ = 1, 9 do
					if not torso.Parent then
						break
					end

					torso.AssemblyLinearVelocity = p2 * 0.95
					torso.AssemblyAngularVelocity = CFrame.lookAt(Vector3.new(0, 0, 0), p2).RightVector * -p2.Magnitude * 0.2
					game:GetService("RunService").Stepped:Wait()
				end
			end)
		end
	end
end
