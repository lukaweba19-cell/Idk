-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local v1: boolean = game:GetService("RunService"):IsServer()
local t1: {[any]: any} = {}

local function segmentIntersectsSphere(p1, p2, p3, p4)
	local n1 = p2 - p1
	local n2 = p3 - p1
	local v11 = n1:Dot(n1)

	if v11 < 0.000001 then
		return p4 >= n2.Magnitude
	end

	local v12 = n2:Dot(n1)
	local v13 = math.clamp(v12 / v11, 0, 1)

	return p4 >= (p1 + n1 * v13 - p3).Magnitude
end

local module: {[any]: any} = {
	FADE_OUT_SECONDS = 0,
	IsBlocked = function(p5, p6)
		if v1 then
			local v16: number = workspace:GetServerTimeNow()

			for k, v in pairs(t1) do
				if v16 > v.expiresAt then
					t1[k] = nil
				else
					local vPos = v.pos
					local vRadius = v.radius
					local n1 = p6 - p5
					local n2 = vPos - p5
					local v23 = n1:Dot(n1)

					if if v23 < 0.000001 then vRadius >= n2.Magnitude else vRadius >= (p5 + n1 * math.clamp(n2:Dot(n1) / v23, 0, 1) - vPos).Magnitude then
						return true
					end
				end
			end

			return false
		end

		local bin: Instance = workspace:FindFirstChild("Bin")

		if not bin then
			return false
		end

		for iterFirst, iterSecond in bin:GetChildren() do
			if iterSecond:IsA("BasePart") and iterSecond:GetAttribute("BlocksVision") and (if n3:Dot(n3) < 0.000001 then iterSecond.Size.X * 0.5 >= (v28 - p5).Magnitude else iterSecond.Size.X * 0.5 >= (p5 + (p6 - p5) * math.clamp((v28 - p5):Dot(p6 - p5) / n3:Dot(n3), 0, 1) - iterSecond.Position).Magnitude) then
				return true
			end
		end

		return false
	end
}

function module.IsPointInSmoke(p7)
	return module.IsBlocked(p7, p7)
end
function module.Register(p8, p9, p10)
	if not v1 then
		return nil
	end

	local t3: {[any]: any} = {}
	local v34: number = workspace:GetServerTimeNow()

	t1[t3] = { pos = p8, radius = p9, expiresAt = v34 + p10 }

	return t3
end
function module.Unregister(p11)
	if not v1 then
		return
	end

	t1[p11] = nil
end
function module.ClearAll()
	if not v1 then
		return
	end

	table.clear(t1)
end

return module
