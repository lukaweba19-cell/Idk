-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)
require(game.ReplicatedStorage.Sound)

local tweenService: TweenService = game:GetService("TweenService")

require(game.ReplicatedStorage.Util.Misc)

local haircut = game.ReplicatedStorage.FX.KillEffects.Haircut
local haircutMesh = haircut.Mesh
local haircutSounds = haircut.Sounds
local debris = require(game.ReplicatedStorage.Util.Debris)

local function makeTween(p1, p2, p3)
	return (tweenService:Create(p1, p2, p3))
end

return function(player)
	local Character = player.Character
	local p = workspace.CurrentCamera.CFrame.p
	local pivot = Character:GetPivot()

	if (p - pivot.Position).Magnitude < 1000 then
		local function createsfx(parent, p6)
			local clone = p6:Clone()

			clone.Parent = parent
			clone:Play()
			debris:AddItem(clone, 1)
		end

		local part: Part = Instance.new("Part")

		Character:FindFirstChild("HumanoidRootPart")
		part.CFrame = CFrame.new(Character.Torso.CFrame.p) * CFrame.new(0, 2.2, 0)

		local clone = haircutMesh.Shaver:Clone()
		local clonePrimaryPart = clone.PrimaryPart

		clonePrimaryPart.CFrame = part.CFrame * CFrame.new(0, 5000, 0)
		clone.Parent = workspace.CurrentCamera
		debris:AddItem(clone, 3.8)
		clone["Hair Clipper"].Sound:Play()

		local clone2 = haircutMesh.Part.spark:Clone()

		clone.Humanoid:LoadAnimation(haircut.Animation):Play()
		wait(0.28)
		clonePrimaryPart.CFrame = part.CFrame
		wait(0.1)
		clone["Hair Clipper"].trim:Play()

		for _, v in pairs(Character:GetChildren()) do
			if (v:IsA("Accessory") or v:IsA("Hat")) and v:FindFirstChild("Handle") then
				local vHandle = v.Handle
				local tweenInfo = TweenInfo.new(0.9, Enum.EasingStyle.Back, Enum.EasingDirection.InOut, 0, false, 0)

				tweenService:Create(vHandle, tweenInfo, { Transparency = 1, Size = Vector3.new(0, 0, 0) }):Play()
			end
		end

		wait(1.45)
		clone["Hair Clipper"].trim:Play()
		wait(1.5)

		local head = Character:FindFirstChild("Head")
		local clone3 = haircutSounds.Sound:Clone()

		clone3.Parent = head
		clone3:Play()
		debris:AddItem(clone3, 1)
		clone2.Parent = Character:FindFirstChild("Head")
		wait(0.1)
		clone2.flare:Emit(1)
		debris:AddItem(clone2, 1)

		local v25 = clone["Hair Clipper"]
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.InOut, 0, false, 0)

		tweenService:Create(v25, tweenInfo, { Transparency = 1, Size = Vector3.new(0, 0, 0) }):Play()
	end
end
