-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local renderStepped = game:GetService("RunService").RenderStepped

return function(p1, p2, p3, p4)
	local v6 = p3 or 0.001
	local v7 = p4 or 0
	local timestamp = tick()
	local timestamp2 = tick()

	while true do
		local timestamp3 = tick()

		if not (p1 > timestamp3 - v7 - timestamp) then
			break
		end

		local timestamp4 = tick()
		local n1 = tick() - timestamp2

		timestamp2 = tick()

		local t1: {[any]: any} = { p2((timestamp4 - v7 - timestamp) / (if p1 == math.huge then 1 else p1), n1) }

		if select("#", unpack(t1)) > 0 then
			return unpack(t1)
		end

		if v6 <= 0 then
			renderStepped:wait()
		else
			wait(v6)
		end
	end

	local timestamp5 = tick()

	return p2(1, timestamp5 - timestamp2)
end
