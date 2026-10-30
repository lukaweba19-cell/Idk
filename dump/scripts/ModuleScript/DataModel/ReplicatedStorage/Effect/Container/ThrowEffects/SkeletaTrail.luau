-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local misc = require(game.ReplicatedStorage.Util.Misc)

local function attachVisual(parent)
	local skeletaClone: Instance = script:FindFirstChild("SkeletaClone")

	if not skeletaClone then
		warn("[SkeletaTrail] SkeletaClone is missing; the thrown knife will be invisible")

		return nil
	end

	local clone: Instance = skeletaClone:Clone()
	local knifeRoot: Instance = clone:FindFirstChild("KnifeRoot")

	if not knifeRoot or not knifeRoot:IsA("BasePart") then
		warn("[SkeletaTrail] SkeletaClone has no KnifeRoot part")
		clone:Destroy()

		return nil
	end

	local knifeRootCFrame = knifeRoot.CFrame
	local cFrame = parent.CFrame

	for _, v in ipairs(clone:GetDescendants()) do
		if v:IsA("BasePart") then
			local v11 = knifeRootCFrame:ToObjectSpace(v.CFrame)

			v.CFrame = cFrame * v11
			v.Anchored = false
			v.CanCollide = false
			v.CanQuery = false
			v.CanTouch = false
			v.Massless = true
		end
	end

	local thrownRootWeld: Weld = Instance.new("Weld")

	thrownRootWeld.Name = "ThrownRootWeld"
	thrownRootWeld.Part0 = parent
	thrownRootWeld.Part1 = knifeRoot
	thrownRootWeld.Parent = knifeRoot
	clone.Parent = parent

	return knifeRoot
end

return function(p2)
	local knife = p2.Knife

	knife:SetAttribute("SpinSpeedOverride", 7)

	local v15 = attachVisual(knife)

	task.spawn(function()
		task.wait(0.005)

		local trail = (v15 or knife):FindFirstChild("Trail")

		if trail then
			trail.Enabled = true
		end

		misc.EmitAll(knife)
	end)
end
