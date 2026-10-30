-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local sound = require(game.ReplicatedStorage.Sound)
local misc = require(game.ReplicatedStorage.Util.Misc)
local debris = require(game.ReplicatedStorage.Util.Debris)
local tweenService: TweenService = game:GetService("TweenService")
local paintbrushColors = require(game.ReplicatedStorage.Shared.PaintbrushColors)
local random = Random.new()

local function pickColors(p1)
	local v10 = p1 and p1:GetAttribute(paintbrushColors.THROW_ATTR)
	local v11 = paintbrushColors.ColorOf(v10) or paintbrushColors.ColorOf(paintbrushColors.FALLBACK) or Color3.new(1, 1, 1)
	local v12 = v11:Lerp(Color3.new(1, 1, 1), 0.12)

	return { v11, v12, v11:Lerp(Color3.new(0, 0, 0), 0.15) }
end
local function stamp(p2, p3, p4, color3, p6)
	local clone = p2:Clone()

	clone.Size = Vector3.new(p4 * 0.25, 0.05, p4 * 0.25)

	local v19 = CFrame.Angles(0, p6, 0)

	clone.CFrame = p3 * CFrame.new(0, 0.03, 0) * v19

	for _, v in ipairs(clone:GetChildren()) do
		if v:IsA("Decal") then
			v.Color3 = color3
		end
	end

	clone.Parent = workspace.Bin

	local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local vector3 = Vector3.new(p4, 0.05, p4)

	tweenService:Create(clone, tweenInfo, { Size = vector3 }):Play()
	task.delay(2.5, function()
		if not clone.Parent then
			return
		end

		for _, v in ipairs(clone:GetChildren()) do
			if v:IsA("Decal") then
				local tweenInfo2 = TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

				tweenService:Create(v, tweenInfo2, { Transparency = 1 }):Play()
			end
		end
	end)
	debris:AddItem(clone, 3.9000000000000004)
end

return function(p7)
	local v25 = p7.CFrame

	if (workspace.CurrentCamera.CFrame.Position - v25.Position).Magnitude > 1000 + (p7.Scale or 1.75) * 10 then
		return
	end

	sound:Play("WallHit." .. script.Parent.Name, v25, nil, nil, nil, 0.15)

	local v26 = pickColors(p7.Knife)
	local clone = game.ReplicatedStorage.FX.WallHitFX.PaintbrushWallHit:Clone()

	clone.CFrame = v25

	local splat = clone:FindFirstChild("Splat")

	if splat then
		splat.Parent = nil
	end

	for _, v in ipairs(clone:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			local paintSlot = v:GetAttribute("PaintSlot")

			if paintSlot and v26[paintSlot] then
				v.Color = ColorSequence.new(v26[paintSlot])
			end
		elseif v:IsA("PointLight") then
			v.Color = v26[1]

			local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

			tweenService:Create(v, tweenInfo, { Brightness = 0 }):Play()
		end
	end

	clone.Parent = workspace.Bin
	misc.EmitAll(clone)
	debris:AddItem(clone, 2)

	if splat then
		local v33 = random:NextNumber(3.2, 3.9)

		stamp(splat, v25, v33, v26[1], random:NextNumber(0, 6.283185307179586))

		for i = 2, 3 do
			local v35 = random:NextNumber(0, 6.283185307179586)
			local cFrameNew = CFrame.new
			local cosine = math.cos(v35)
			local v38 = random:NextNumber(1.1, 1.7)
			local sine = math.sin(v35)
			local v40 = random:NextNumber(1.1, 1.7)
			local cFrame = cFrameNew(cosine * v38, i * 0.005, sine * v40)
			local v42 = random:NextNumber(1.1, 1.8)

			stamp(splat, v25 * cFrame, v42, v26[i], random:NextNumber(0, 6.283185307179586))
		end

		splat:Destroy()
	end
end
