-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")
local sound = require(game.ReplicatedStorage.Sound)
local debris = require(game.ReplicatedStorage.Util.Debris)
local murderNote = game.ReplicatedStorage.FX.KillEffects.MurderNote
local cFrameIdentity = CFrame.identity
local color3 = Color3.fromRGB(168, 168, 172)
local t1: {[any]: any} = {
	AgeDuration = 2.9,
	TickStart = 0.42,
	TickEnd = 0.95,
	BeardStart = 0.12,
	BeardYoung = Vector3.new(0.35, 0.3, 0.28),
	BeardOld = Vector3.new(1, 1, 1),
	GrayStrength = 0.5,
	BinLifetime = 9,
	BeardNudge = cFrameIdentity,
	GrayColor = color3
}

return function(player, _, _)
	local Character = player.Character
	local v12 = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

	if not v12 then
		return
	end

	local part1 = Character:FindFirstChild("Head") or v12
	local _fx_MurderNote_OldAge: Folder = Instance.new("Folder")

	_fx_MurderNote_OldAge.Name = "_FX_MurderNote_OldAge"
	_fx_MurderNote_OldAge.Parent = workspace.Bin
	debris:AddItem(_fx_MurderNote_OldAge, t1.BinLifetime)

	local u15: boolean = true
	local t2: {[any]: any} = {}

	local function stopTweens()
		for key, value in t2 do
			pcall(function()
				value:Cancel()
			end)
		end

		table.clear(t2)
	end
	local function teardown()
		if not u15 then
			return
		end

		u15 = false
		stopTweens()

		if _fx_MurderNote_OldAge.Parent then
			_fx_MurderNote_OldAge:Destroy()
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
		stopTweens()

		if _fx_MurderNote_OldAge.Parent then
			_fx_MurderNote_OldAge:Destroy()
		end
	end)
	_fx_MurderNote_OldAge.AncestryChanged:Once(function()
		if not _fx_MurderNote_OldAge:IsDescendantOf(game) then
			u15 = false
			stopTweens()
		end
	end)

	local v19 = nil
	local clone = murderNote.Beard:Clone()
	local handle = clone:FindFirstChild("Handle")
	local specialMesh = handle and handle:FindFirstChildOfClass("SpecialMesh")

	if handle and specialMesh and part1:IsA("BasePart") then
		handle.Anchored = false
		handle.CanCollide = false
		handle.CanQuery = false
		handle.CanTouch = false
		handle.Massless = true

		local ok, result = pcall(function()
			return CFrame.fromMatrix(clone.AttachmentPos, clone.AttachmentRight, clone.AttachmentUp)
		end)

		if not ok then
			result = CFrame.new(0, 0.5, 0)
		end

		local part1CFrame = part1.CFrame
		local cFrame = CFrame.new(0, part1.Size.Y * 0.5, 0)
		local v27 = result:Inverse()

		handle.CFrame = part1CFrame * cFrame * v27 * t1.BeardNudge

		local weldConstraint: WeldConstraint = Instance.new("WeldConstraint")

		weldConstraint.Part0 = handle
		weldConstraint.Part1 = part1
		weldConstraint.Parent = handle
		v19 = specialMesh
		specialMesh:SetAttribute("FullScale", specialMesh.Scale)
		specialMesh.Scale = specialMesh.Scale * t1.BeardStart
		specialMesh.VertexColor = t1.BeardYoung
		handle.Parent = _fx_MurderNote_OldAge
		clone:Destroy()
	end

	local highlight: Highlight = Instance.new("Highlight")

	highlight.Adornee = Character
	highlight.FillColor = t1.GrayColor
	highlight.FillTransparency = 1
	highlight.OutlineTransparency = 1
	highlight.DepthMode = Enum.HighlightDepthMode.Occluded
	highlight.Parent = _fx_MurderNote_OldAge

	local tweenInfo = TweenInfo.new(t1.AgeDuration, Enum.EasingStyle.Linear)
	local v31: Tween = tweenService:Create(highlight, tweenInfo, { FillTransparency = 1 - t1.GrayStrength })

	table.insert(t2, v31)
	v31:Play()

	if v19 then
		local tweenInfo2 = TweenInfo.new(t1.AgeDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local fullScale = v19:GetAttribute("FullScale")
		local v34: Tween = tweenService:Create(v19, tweenInfo2, { Scale = fullScale, VertexColor = t1.BeardOld })

		table.insert(t2, v34)
		v34:Play()
	end

	task.spawn(function()
		local n1 = 0

		while u15 and v12.Parent and n1 < t1.AgeDuration do
			sound:Play("KillEffects.MurderNote.ClockTick", part1, 40, nil, 0.8, 0.03)

			local n2 = t1.TickStart + (t1.TickEnd - t1.TickStart) * (n1 / t1.AgeDuration)

			task.wait(n2)
			n1 += n2
		end

		if not u15 or not v12.Parent then
			return
		end

		sound:Play("KillEffects.MurderNote.OldManDeath", part1, 60, nil, 1, 0.03)
	end)
end
