-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Sound)
game:GetService("TweenService")

local runService: RunService = game:GetService("RunService")
local debris = require(game.ReplicatedStorage.Util.Debris)
local balloon = game.ReplicatedStorage.FX.KillEffects.Balloon.Mesh.Balloon
local color3 = Color3.fromRGB(255, 50, 50)
local color32 = Color3.fromRGB(50, 150, 255)
local color33 = Color3.fromRGB(255, 220, 50)
local color34 = Color3.fromRGB(50, 255, 100)
local t1: {[any]: any} = { color3, color32, color33, color34, Color3.fromRGB(255, 100, 200) }

return function(player)
	local Character = player.Character

	if not Character then
		return
	end

	if (workspace.CurrentCamera.CFrame.Position - Character:GetPivot().Position).Magnitude > 1000 then
		return
	end

	local _fx_Balloon: Folder = Instance.new("Folder")

	_fx_Balloon.Name = "_FX_Balloon"
	_fx_Balloon.Parent = workspace.Bin
	Character.AncestryChanged:Once(function()
		if not Character:IsDescendantOf(game) then
			_fx_Balloon:Destroy()
		end
	end)
	debris:AddItem(_fx_Balloon, 10)

	local torso = Character:FindFirstChild("Torso")
	local foundChild = Character:FindFirstChild("Left Leg")
	local foundChild2 = Character:FindFirstChild("Right Leg")

	if not torso then
		return
	end

	local parent = foundChild or foundChild2 or torso
	local balloonRopeAtt: Attachment = Instance.new("Attachment")

	balloonRopeAtt.Name = "BalloonRopeAtt"
	balloonRopeAtt.Position = Vector3.new(0, 0.5, 0)
	balloonRopeAtt.Parent = parent

	local t2: {[any]: any} = {}

	for i = 1, 5 do
		local clone = balloon:Clone()

		clone.Name = "Balloon_" .. i
		clone.Anchored = true
		clone.CanCollide = false
		clone.Color = t1[(i - 1) % #t1 + 1]

		local n1: number = i / 5 * 3.141592653589793 * 2
		local n2 = math.cos(n1) * 1.2
		local n3 = math.sin(n1) * 1.2
		local parentPosition = parent.Position
		local vector3 = Vector3.new(n2, 7, n3)

		clone.CFrame = CFrame.new(parentPosition + vector3)
		clone.Parent = _fx_Balloon

		local attachment = clone:FindFirstChild("Attachment")

		if not attachment then
			attachment = Instance.new("Attachment")
			attachment.Position = Vector3.new(0, -1.17, 0)
			attachment.Parent = clone
		end

		local ropeConstraint: RopeConstraint = Instance.new("RopeConstraint")

		ropeConstraint.Attachment0 = attachment
		ropeConstraint.Attachment1 = balloonRopeAtt
		ropeConstraint.Length = (i - 1) * 0.3 + 6
		ropeConstraint.Visible = true
		ropeConstraint.Thickness = 0.06
		ropeConstraint.Color = BrickColor.new("Reddish brown")
		ropeConstraint.Parent = _fx_Balloon

		local vector32 = Vector3.new(n2, 7, n3)

		table.insert(t2, { part = clone, offset = vector32, index = i })
	end

	local timestamp = tick()
	local connection = nil

	connection = runService.RenderStepped:Connect(function()
		if not _fx_Balloon or not _fx_Balloon.Parent then
			connection:Disconnect()

			return
		end

		if not parent or not parent.Parent then
			connection:Disconnect()

			return
		end

		local n1 = tick() - timestamp

		if n1 > 8 then
			connection:Disconnect()

			return
		end

		local parentPosition = parent.Position

		for i, v in ipairs(t2) do
			local vPart = v.part

			if vPart and vPart.Parent then
				local sine = math.sin(n1 * 1.3 + i * 1.5)
				local cosine = math.cos(n1 * 0.9 + i * 1.1)
				local sine2 = math.sin(n1 * 2.5 + i * 0.8)

				vPart.CFrame = CFrame.new(parentPosition.X + v.offset.X + sine * 0.6, parentPosition.Y + v.offset.Y + sine2 * 0.2, parentPosition.Z + v.offset.Z + cosine * 0.6)
			end
		end
	end)
end
