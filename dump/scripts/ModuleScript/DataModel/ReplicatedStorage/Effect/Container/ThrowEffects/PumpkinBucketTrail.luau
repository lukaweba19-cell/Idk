-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local misc = require(game.ReplicatedStorage.Util.Misc)
local heldVariants = require(game.ReplicatedStorage.Shared.HeldVariants)

return function(p1)
	local knife = p1.Knife

	if not knife then
		return
	end

	local u5 = nil
	local v6 = heldVariants.FindRootForUser(p1.OwnerUserId)

	if v6 then
		u5 = heldVariants.Thrown(v6)
	end

	if not u5 or not knife:FindFirstChild(u5) then
		u5 = heldVariants.Pick(knife)
	end

	heldVariants.Show(knife, u5)
	knife:SetAttribute(heldVariants.ATTR_CURRENT, u5)
	knife:SetAttribute("SpinSpeedOverride", 7)
	task.spawn(function()
		task.wait(0.005)

		local v7 = u5 and knife:FindFirstChild(u5)

		if v7 then
			for _, v in ipairs(v7:GetDescendants()) do
				if v:IsA("Trail") then
					v.Enabled = true
				end
			end

			misc.EmitAll(v7)
		end
	end)
end
