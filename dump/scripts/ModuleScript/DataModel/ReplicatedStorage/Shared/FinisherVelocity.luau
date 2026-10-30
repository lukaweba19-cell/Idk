-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local murderNoteCatalog = require(game.ReplicatedStorage.Shared.MurderNoteCatalog)
local t1: {[any]: any} = {
	CatDrop = true,
	WhiteCatDrop = true,
	BatStorm = true,
	TimeStop = true,
	Crib = true,
	Eagle = true,
	Haircut = true,
	StarFall = true,
	Slap = true,
	SafeSmash = true,
	BoilingPot = true,
	Petrify = true,
	Fah = true,
	LightningStrike = true,
	BrainrotRNG = true,
	LoveBomb = true,
	WaterBalloons = true,
	WaterSpout = true,
	MurderNote = true,
	SteelBarrage = true,
	Damnation = true,
	Outbreak = true,
	PurpleOutbreak = true,
	Shedletsekkar = true,
	Cthulhu = true,
	Necrodeath = true,
	Pyrodeath = true,
	Soulscourge = true
}

return {
	Get = function(p1, p2)
		local v5 = Random.new():NextUnitVector()
		local n1 = (p2 or Vector3.new(0, 0, -1)) * 70 + v5 * 15

		if p1 == "KNOCKOUT" then
			return Vector3.new(0, 160, 0)
		end

		if p1 == "Balloon" then
			return Vector3.new(0, 80, 0)
		end

		if p1 == "Eruption" then
			return Vector3.new(0, 90, 0)
		end

		if t1[p1] then
			return n1.Unit * 7
		end

		return n1
	end,
	HasDelayedRagdoll = function(p3, p4, p5)
		if p3 == "Slap" then
			return true, 1.465, Vector3.new(-145, 70, 0), false
		end

		if p3 == "WaterSpout" then
			return true, 2.2, p4 and p4.LookVector * 28 + Vector3.new(0, 170, 0) or Vector3.new(0, 170, 28), true
		end

		if p3 == "MurderNote" then
			if typeof(p5) == "number" and murderNoteCatalog.Pick(p5).id == "CarHit" then
				local v10 = Random.new(p5 * 31 + 7):NextNumber(0, 6.283185307179586)
				local cosine = math.cos(v10)
				local sine = math.sin(v10)

				return true, 0.68, Vector3.new(cosine, 0, sine) * 95 + Vector3.new(0, 55, 0), true
			end

			return false
		end

		if p3 == "Bear" then
			return true, 1.167, p4 and p4.RightVector * 45 + p4.UpVector * 20 + p4.RightVector * 45 or Vector3.new(45, 20, 45), true
		end

		return false, nil, nil, false
	end,
	HasLimbExplosion = function(p6, p7)
		if p6 == "TimeStop" then
			return true, 1.25, 0.07
		end

		if p6 == "ChromaBlitz" then
			return true, 1.135, 0.03
		end

		if p6 == "Damnation" then
			return true, 1.77, 0.02, { linearSpeed = 85, upwardBoost = 45, angularRange = 45 }
		end

		if p6 == "MurderNote" then
			if typeof(p7) == "number" and murderNoteCatalog.Pick(p7).id == "Oof" then
				return true, 0.45, 0.05, { linearSpeed = 6, upwardBoost = 3, angularRange = 12 }
			end

			return false
		end

		return false, nil, nil
	end,
	PerformLimbExplosion = function(p8, p9)
		local t2 = p9 or {}
		local v18 = t2.delay or 0
		local v19 = t2.stagger or 0.07
		local v20 = t2.linearSpeed or 50
		local v21 = t2.upwardBoost or 30
		local v22 = t2.angularRange or 30
		local torso = p8:FindFirstChild("Torso")

		if not torso then
			return
		end

		task.delay(v18, function()
			for _, v in ipairs(p8:GetDescendants()) do
				if v:IsA("BallSocketConstraint") then
					v:Destroy()
				elseif v:IsA("BasePart") then
					pcall(function()
						v:SetNetworkOwner()
					end)
				end
			end

			for _, v in ipairs(p8:GetDescendants()) do
				if v:IsA("Attachment") and v.Name:find("TorsoTo") then
					v:Destroy()
				end
			end

			for i, v in ipairs({ "Head", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "Torso" }) do
				task.delay((i - 1) * v19, function()
					local v2 = p8:FindFirstChild(v)

					if v2 and v2:IsA("BasePart") then
						local n1 = v2.Position - torso.Position
						local u32

						if n1.Magnitude > 0.1 then
							u32 = n1.Unit
						else
							local randomNumber = math.random()
							local randomNumber2 = math.random()

							u32 = Vector3.new(randomNumber - 0.5, 1, randomNumber2 - 0.5).Unit
						end

						task.spawn(function()
							for _ = 1, 4 do
								local n1 = u32 * v20
								local vector3 = Vector3.new(0, v21, 0)

								v2.AssemblyLinearVelocity = n1 + vector3

								local randomNumber = math.random()
								local randomNumber3 = math.random()
								local randomNumber4 = math.random()

								v2.AssemblyAngularVelocity = Vector3.new(randomNumber * v22 - v22 / 2, randomNumber3 * v22 - v22 / 2, randomNumber4 * v22 - v22 / 2)
								task.wait()
							end
						end)
					end
				end)
			end
		end)
	end
}
