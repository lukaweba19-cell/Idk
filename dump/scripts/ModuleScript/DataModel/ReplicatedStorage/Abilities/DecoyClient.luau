-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local t1: {[any]: any} = {
	["rbxassetid://180435571"] = true,
	["rbxassetid://180435792"] = true,
	["rbxassetid://180426354"] = true,
	["rbxassetid://125750702"] = true,
	["rbxassetid://180436148"] = true,
	["rbxassetid://180436334"] = true,
	["rbxassetid://178130996"] = true,
	["http://www.roblox.com/asset/?id=180435571"] = true,
	["http://www.roblox.com/asset/?id=180435792"] = true,
	["http://www.roblox.com/asset/?id=180426354"] = true,
	["http://www.roblox.com/asset/?id=125750702"] = true,
	["http://www.roblox.com/asset/?id=180436148"] = true,
	["http://www.roblox.com/asset/?id=180436334"] = true,
	["http://www.roblox.com/asset/?id=178130996"] = true
}

local function snapshotAnims(p1)
	local t2: {[any]: any} = {}

	for iterFirst, iterSecond in p1:GetPlayingAnimationTracks() do
		if #t2 >= 8 then
			break
		end

		local animation = iterSecond.Animation

		if animation and animation:IsA("Animation") then
			local animationAnimationId = animation.AnimationId

			if typeof(animationAnimationId) == "string" and animationAnimationId ~= "" and not t1[animationAnimationId] then
				table.insert(t2, {
					AnimationId = animationAnimationId,
					TimePosition = iterSecond.TimePosition,
					Speed = iterSecond.Speed,
					Priority = iterSecond.Priority,
					Looped = iterSecond.Looped
				})
			end
		end
	end

	return t2
end

return {
	Cast = function(player)
		local Character = player.Character

		if not Character then
			return
		end

		local humanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

		if not humanoidRootPart then
			return
		end

		local humanoid = Character:FindFirstChildOfClass("Humanoid")
		local v13 = humanoid

		if v13 then
			v13 = humanoid:FindFirstChildOfClass("Animator")
		end

		local t3 = if v13 then snapshotAnims(v13) else {}

		return { CFrame = humanoidRootPart.CFrame, Anims = t3 }
	end
}
