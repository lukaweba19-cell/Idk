-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local players: Players = game:GetService("Players")
local sound = require(game.ReplicatedStorage.Sound)
local debris = require(game.ReplicatedStorage.Util.Debris)
local murderNote = game.ReplicatedStorage.FX.KillEffects.MurderNote
local t1: {[any]: any} = {
	HoldHeight = 0.5,
	SpawnDistance = 55,
	Speed = 85,
	OverrunDist = 45,
	FlingSpeed = 95,
	FlingUp = 55,
	BinLifetime = 6,
	CarFaceFlip = false
}

return function(player, _, p3)
	local Character = player.Character
	local v11 = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

	if not v11 then
		return
	end

	local _fx_MurderNote_CarHit: Folder = Instance.new("Folder")

	_fx_MurderNote_CarHit.Name = "_FX_MurderNote_CarHit"
	_fx_MurderNote_CarHit.Parent = workspace.Bin
	debris:AddItem(_fx_MurderNote_CarHit, 6)

	local v13: Player = players:GetPlayerFromCharacter(Character)
	local u14: boolean = true

	if v13 ~= nil then
		u14 = v13 == players.LocalPlayer
	end

	local u15: boolean = true
	local t2: {[any]: any} = {}
	local u17: boolean = false

	local function releaseTorso()
		if u17 and v11.Parent then
			v11.Anchored = false
		end

		u17 = false
	end
	local function cleanupHandles()
		for key, value in t2 do
			if value.Connected then
				value:Disconnect()
			end
		end

		table.clear(t2)
	end
	local function teardown()
		if not u15 then
			return
		end

		u15 = false

		for key, value in t2 do
			if value.Connected then
				value:Disconnect()
			end
		end

		table.clear(t2)

		if u17 and v11.Parent then
			v11.Anchored = false
		end

		u17 = false

		if _fx_MurderNote_CarHit.Parent then
			_fx_MurderNote_CarHit:Destroy()
		end
	end

	Character.AncestryChanged:Once(function()
		if Character:IsDescendantOf(game) then
			return
		end

		if not u15 then
			return
		end

		u15 = false

		for key, value in t2 do
			if value.Connected then
				value:Disconnect()
			end
		end

		table.clear(t2)

		if u17 and v11.Parent then
			v11.Anchored = false
		end

		u17 = false

		if _fx_MurderNote_CarHit.Parent then
			_fx_MurderNote_CarHit:Destroy()
		end
	end)
	_fx_MurderNote_CarHit.AncestryChanged:Once(function()
		if not _fx_MurderNote_CarHit:IsDescendantOf(game) then
			u15 = false

			for key, value in t2 do
				if value.Connected then
					value:Disconnect()
				end
			end

			table.clear(t2)

			if u17 and v11.Parent then
				v11.Anchored = false
			end

			u17 = false
		end
	end)

	local lookVector = v11.CFrame.LookVector
	local vector3 = Vector3.new(lookVector.X, 0, lookVector.Z)
	local n1 = v11.Position + Vector3.new(0, 0.5, 0)

	v11.Anchored = true
	u17 = true
	v11.CFrame = CFrame.lookAt(n1, n1 + (vector3.Magnitude > 0.05 and vector3.Unit or Vector3.new(0, 0, 1)))

	local v24 = p3:NextNumber(0, 6.283185307179586)
	local cosine = math.cos(v24)
	local sine = math.sin(v24)
	local vector32 = Vector3.new(cosine, 0, sine)
	local n2 = n1 - vector32 * 55 - Vector3.new(0, 0.5, 0)
	local clone = murderNote.Car:Clone()

	clone.Anchored = true
	clone.CanCollide = false
	clone.CanQuery = false
	clone.CanTouch = false
	clone.Massless = true
	clone.CollisionGroup = "Debris"
	clone.CFrame = CFrame.lookAt(n2, n2 + vector32)
	clone.Parent = _fx_MurderNote_CarHit
	debris:AddItem(clone, 2.1764705882352944)
	sound:Play("KillEffects.MurderNote.CarEngine", clone, 130, 1.1, 0.9, 0.05)

	local n3: number = 0
	local u31: boolean = false
	local connection = nil

	connection = runService.RenderStepped:Connect(function(deltaTime: number)
		if not u15 or not clone.Parent then
			connection:Disconnect()

			if u17 and v11.Parent then
				v11.Anchored = false
			end

			u17 = false

			return
		end

		n3 += 85 * deltaTime

		local n1 = n2 + vector32 * n3

		clone.CFrame = CFrame.lookAt(n1, n1 + vector32)

		if not u31 and n3 + clone.Size.Z * 0.5 >= 55 then
			u31 = true
			sound:Play("KillEffects.MurderNote.CarImpact", v11.Parent and v11 or clone, 130, nil, 1, 0.06)

			if v11.Parent then
				v11.Anchored = false
				u17 = false

				if u14 then
					v11.AssemblyLinearVelocity = vector32 * 95 + Vector3.new(0, 55, 0)

					local v43 = p3:NextNumber(-9, 9)
					local v44 = p3:NextNumber(-6, 6)

					v11.AssemblyAngularVelocity = Vector3.new(v43, v44, p3:NextNumber(-9, 9))
				end
			end
		end

		if n3 >= 100 then
			connection:Disconnect()
			clone:Destroy()
		end
	end)
	table.insert(t2, connection)
end
