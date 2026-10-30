-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Sound)
game:GetService("TweenService")

local runService: RunService = game:GetService("RunService")
local mesh = game.ReplicatedStorage.FX.KillEffects.Meteor.Mesh

require(game.ReplicatedStorage.Util.Misc)

local debris = require(game.ReplicatedStorage.Util.Debris)
local rayCast = require(game.ReplicatedStorage.Util.RayCast)

return function(player)
	local Character = player.Character

	if not Character then
		return
	end

	if (workspace.CurrentCamera.CFrame.Position - Character:GetPivot().Position).Magnitude > 1000 then
		return
	end

	local _fx_Meteor: Folder = Instance.new("Folder")

	_fx_Meteor.Name = "_FX_Meteor"
	_fx_Meteor.Parent = workspace.Bin
	Character.AncestryChanged:Once(function()
		if not Character:IsDescendantOf(game) then
			_fx_Meteor:Destroy()
		end
	end)
	debris:AddItem(_fx_Meteor, 7)

	local v8 = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

	if not v8 then
		return
	end

	local clone = mesh.Meteor:Clone()

	clone.Parent = _fx_Meteor
	debris:AddItem(clone, 3)

	local foundChild = clone:FindFirstChild("AIM", true)
	local vectorValue = Vector3.new(0, 0, -1)

	if foundChild and foundChild.Position.Magnitude > 0.001 then
		vectorValue = foundChild.Position.Unit
	end

	local function cframeAimAt(p2, p3)
		local v22 = CFrame.lookAt(p2, p3)
		local v23 = CFrame.lookAt(Vector3.new(0, 0, 0), Vector3.new(-0, -0, -1)):ToObjectSpace(CFrame.lookAt(Vector3.new(0, 0, 0), vectorValue)):Inverse()

		return v22 * v23
	end

	local n1 = math.random() * 3.141592653589793 * 2
	local cosine = math.cos(n1)
	local sine = math.sin(n1)
	local vector3 = Vector3.new(cosine * 100, 100, sine * 100)

	clone.CFrame = cframeAimAt(v8.Position + vector3, v8.Position)

	local n2: number = 0
	local u18: boolean = false
	local connection = nil

	connection = runService.RenderStepped:Connect(function(deltaTime: number)
		n2 += deltaTime

		local v25 = math.min(n2 / 1, 1)
		local n1 = v8.Position + Vector3.new(0, -2, 0)
		local v27 = (n1 + vector3):Lerp(n1, v25 * v25)

		clone.CFrame = cframeAimAt(v27, n1)

		if v25 >= 1 then
			u18 = true
			connection:Disconnect()

			local v28, v29, v30 = rayCast(n1, Vector3.new(-0, -20, -0))

			if v28 then
				local clone2 = mesh.FloorPart:Clone()
				local cFrame = CFrame.new(v29, v29 + v30)
				local v33 = CFrame.Angles(1.5707963267948966, 0, 0)

				clone2.CFrame = cFrame * v33
				clone2.Parent = _fx_Meteor
				debris:AddItem(clone2, 5)
			end

			clone:Destroy()
		end
	end)
end
