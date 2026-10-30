-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
require(game.ReplicatedStorage.Effect)
require(game.ReplicatedStorage.Sound)

local tweenService: TweenService = game:GetService("TweenService")

require(game.ReplicatedStorage.Util.Misc)

local debris = require(game.ReplicatedStorage.Util.Debris)
local runService: RunService = game:GetService("RunService")
local haircut = game.ReplicatedStorage.FX.KillEffects.Haircut
local haircutMesh = haircut.Mesh
local haircutSounds = haircut.Sounds

local function makeTween(p1, p2, p3)
	return (tweenService:Create(p1, p2, p3))
end

return function(player)
	local Character = player.Character
	local p = workspace.CurrentCamera.CFrame.p
	local pivot = Character:GetPivot()

	if (p - pivot.Position).Magnitude < 1000 then
		local _fx_Haircut: Folder = Instance.new("Folder")

		_fx_Haircut.Name = "_FX_Haircut"
		_fx_Haircut.Parent = workspace.Bin
		Character.AncestryChanged:Once(function()
			if not Character:IsDescendantOf(game) then
				_fx_Haircut:Destroy()
			end
		end)
		debris:AddItem(_fx_Haircut, 7)

		local function createsfx(parent, p6)
			local clone = p6:Clone()

			clone.Parent = parent
			clone:Play()
			debris:AddItem(clone, 1)
		end

		local torso = Character:FindFirstChild("Torso")
		local clone = haircutMesh.Shaver:Clone()
		local clonePrimaryPart = clone.PrimaryPart

		for _, v in pairs(clone:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Anchored = false
				v.CanCollide = false
				v.Massless = true
			end
		end

		clonePrimaryPart.Anchored = true
		clone.Parent = _fx_Haircut
		debris:AddItem(clone, 3.8)

		local animationController = clone:FindFirstChildOfClass("AnimationController")
		local v23 = animationController and animationController:FindFirstChildOfClass("Animator")

		if not v23 then
			local animationController2: AnimationController = Instance.new("AnimationController")

			animationController2.Parent = clone
			v23 = Instance.new("Animator")
			v23.Parent = animationController2
		end

		local animationTrack = v23:LoadAnimation(haircut.Animation)
		local cFrame = CFrame.new(0, 5002.2, 0)

		local connection = runService.RenderStepped:Connect(function()
			if torso and torso.Parent then
				clonePrimaryPart.CFrame = CFrame.new(torso.Position) * cFrame
			end
		end)

		debris:AddItem(clone, 3.8)
		clone.Destroying:Connect(function()
			if connection then
				connection:Disconnect()
			end
		end)
		clone["Hair Clipper"].Sound:Play()

		local clone2 = haircutMesh.Part.spark:Clone()

		animationTrack:Play()
		wait(0.28)
		cFrame = CFrame.new(0, 2.2, 0)
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

		local v35 = clone["Hair Clipper"]
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.InOut, 0, false, 0)

		tweenService:Create(v35, tweenInfo, { Transparency = 1, Size = Vector3.new(0, 0, 0) }):Play()
		task.delay(3.8, function()
			if connection then
				connection:Disconnect()
			end
		end)
	end
end
