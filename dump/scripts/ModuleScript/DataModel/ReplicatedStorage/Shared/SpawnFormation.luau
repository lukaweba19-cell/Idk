-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local module: {[any]: any} = {
	GetOffsets = function(p1)
		if p1 <= 1 then
			return { CFrame.new(0, 0, 0) }
		end

		if p1 == 2 then
			return { CFrame.new(-2.5, 0, 0), CFrame.new(2.5, 0, 0) }
		end

		if p1 == 3 then
			return {
				CFrame.new(0, 0, -2.5),
				CFrame.new(-2.5, 0, 2.5),
				CFrame.new(2.5, 0, 2.5)
			}
		end

		return {
			CFrame.new(-2.5, 0, -2.5),
			CFrame.new(2.5, 0, -2.5),
			CFrame.new(-2.5, 0, 2.5),
			CFrame.new(2.5, 0, 2.5)
		}
	end
}

function module.GetSpawnCFrame(p2, p3, p4)
	local v6 = module.GetOffsets(p4)
	local v7 = math.clamp(p3, 1, #v6)
	local v8 = v6[v7] or CFrame.new(0, 0, 0)

	return p2 * v8 + Vector3.new(0, 3, 0)
end

return module
