-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")
local sound = require(game.ReplicatedStorage.Sound)
local debris = require(game.ReplicatedStorage.Util.Debris)
local color3 = Color3.fromRGB(215, 215, 215)
local color32 = Color3.fromRGB(255, 255, 255)
local color33 = Color3.fromRGB(100, 100, 105)
local t1: {[any]: any} = {
	Image = "rbxassetid://104350957239240",
	BeatPhase = 2.4,
	BeatStart = 0.62,
	BeatEnd = 0.16,
	BeatScale = 1.35,
	HeartStuds = 1.6,
	Offset = Vector3.new(0, 0.6, 0),
	MaxDistance = 30,
	FlatlineHold = 1.7,
	BinLifetime = 6,
	DimColor = color3,
	BeatColor = color32,
	DeadColor = color33
}

return function(player, _, _)
	local Character = player.Character
	local adornee = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")

	if not adornee then
		return
	end

	local _fx_MurderNote_HeartAttack: Folder = Instance.new("Folder")

	_fx_MurderNote_HeartAttack.Name = "_FX_MurderNote_HeartAttack"
	_fx_MurderNote_HeartAttack.Parent = workspace.Bin
	debris:AddItem(_fx_MurderNote_HeartAttack, t1.BinLifetime)

	local u14: boolean = true
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
		if not u14 then
			return
		end

		u14 = false
		stopTweens()

		if _fx_MurderNote_HeartAttack.Parent then
			_fx_MurderNote_HeartAttack:Destroy()
		end
	end

	Character.AncestryChanged:Once(function()
		if Character:IsDescendantOf(game) then
			return
		end

		if not u14 then
			return
		end

		u14 = false
		stopTweens()

		if _fx_MurderNote_HeartAttack.Parent then
			_fx_MurderNote_HeartAttack:Destroy()
		end
	end)
	_fx_MurderNote_HeartAttack.AncestryChanged:Once(function()
		if not _fx_MurderNote_HeartAttack:IsDescendantOf(game) then
			u14 = false
			stopTweens()
		end
	end)

	local uDim2 = UDim2.new(t1.HeartStuds, 0, t1.HeartStuds, 0)
	local uDim22 = UDim2.new(t1.HeartStuds * t1.BeatScale, 0, t1.HeartStuds * t1.BeatScale, 0)
	local heartAttackHeart: BillboardGui = Instance.new("BillboardGui")

	heartAttackHeart.Name = "HeartAttackHeart"
	heartAttackHeart.Adornee = adornee
	heartAttackHeart.Size = uDim2
	heartAttackHeart.StudsOffset = t1.Offset
	heartAttackHeart.AlwaysOnTop = true
	heartAttackHeart.MaxDistance = t1.MaxDistance
	heartAttackHeart.LightInfluence = 0
	heartAttackHeart.ResetOnSpawn = false

	local heart: ImageLabel = Instance.new("ImageLabel")

	heart.Name = "Heart"
	heart.BackgroundTransparency = 1
	heart.Size = UDim2.fromScale(1, 1)
	heart.Image = t1.Image
	heart.ImageColor3 = t1.DimColor
	heart.ScaleType = Enum.ScaleType.Fit
	heart.Parent = heartAttackHeart
	heartAttackHeart.Parent = _fx_MurderNote_HeartAttack
	task.spawn(function()
		local v24 = os.clock()

		while u14 and heartAttackHeart.Parent and adornee.Parent do
			local v25 = os.clock()
			local v26 = math.clamp((v25 - v24) / t1.BeatPhase, 0, 1)

			if v26 >= 1 then
				break
			end

			sound:Play("KillEffects.MurderNote.HeartBeat", adornee, 55, v26 * 0.45 + 1, 1, 0.04)

			local tweenInfo = TweenInfo.new(0.09, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local v28: Tween = tweenService:Create(heartAttackHeart, tweenInfo, { Size = uDim22 })

			table.insert(t2, v28)
			v28:Play()
			heart.ImageColor3 = t1.BeatColor
			task.wait(0.09)

			if not u14 or not heartAttackHeart.Parent then
				return
			end

			local tweenInfo2 = TweenInfo.new(0.13, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

			v28 = tweenService:Create(heartAttackHeart, tweenInfo2, { Size = uDim2 })
			table.insert(t2, v28)
			v28:Play()
			heart.ImageColor3 = t1.DimColor

			local taskWait = task.wait

			v25 = math.max(0.05, t1.BeatStart + (t1.BeatEnd - t1.BeatStart) * v26 - 0.09)
			taskWait(v25)
		end

		if not u14 or not heartAttackHeart.Parent then
			return
		end

		stopTweens()
		sound:Play("KillEffects.MurderNote.Flatline", adornee, 70, nil, 0.85, 0)

		local tweenInfo3 = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local uDim23 = UDim2.new(t1.HeartStuds * 0.82, 0, t1.HeartStuds * 0.82, 0)

		v24 = tweenService:Create(heartAttackHeart, tweenInfo3, { Size = uDim23 })

		local tweenInfo4 = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local v34: Tween = tweenService:Create(heart, tweenInfo4, { ImageColor3 = t1.DeadColor })

		table.insert(t2, v24)
		table.insert(t2, v34)
		v24:Play()
		v34:Play()
		debris:AddItem(heartAttackHeart, t1.FlatlineHold)
	end)
end
