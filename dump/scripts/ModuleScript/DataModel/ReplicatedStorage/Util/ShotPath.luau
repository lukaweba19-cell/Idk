-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local shared = game.ReplicatedStorage:WaitForChild("Shared")
local destructibles = require(shared:WaitForChild("Destructibles"))

local function reflect(p1, p2)
	local v6 = p1:Dot(p2)

	return (p1 - 2 * v6 * p2).Unit
end

return {
	Build = function(p3, p4, p5, p6)
		local maxRange = p6.maxRange
		local floored = math.floor(p6.bounces)
		local v13 = math.max(0, floored)
		local v14 = p6.eps or 0.05
		local v15 = p6.maxBouncesCap or 8

		if v13 > v15 then
			v13 = v15
		end

		v15 = {}
		local t1: {[any]: any} = {}
		local v17 = p3
		local v18 = p4.Unit
		local v19 = v13

		while true do
			local v20 = p5(v17, v18, maxRange, v15)

			if not v20 then
				break
			end

			local instance = v20.Instance
			local v22 = instance and instance:IsA("BasePart") and instance or nil
			local v23 = v22 ~= nil and p6.isCharacterHit(v22) or false
			local t2: {[any]: any} = {
				from = v17,
				hitPos = v20.Position,
				hitNormal = v20.Normal,
				hitInstance = v22,
				isCharacterHit = v23
			}

			table.insert(t1, t2)

			if v23 then
				return t1, t2
			end

			v23 = destructibles.GetHitKind(instance)

			if v23 == "none" then
				if v19 <= 0 then
					return t1, t2
				end

				v19 -= 1

				local v25 = v18
				local normal = v20.Normal
				local v27 = v25:Dot(normal)

				v18 = (v25 - 2 * v27 * normal).Unit

				if instance then
					table.insert(v15, instance)
				end
			else
				destructibles.AddToIgnore(v15, instance, v23)
			end

			v17 = v20.Position + v18 * v14
		end

		local t3: {[any]: any} = {
			hitNormal = Vector3.new(0, 1, 0),
			hitInstance = nil,
			isCharacterHit = false,
			from = v17,
			hitPos = v17 + v18 * maxRange
		}

		table.insert(t1, t3)

		return t1, t3
	end
}
