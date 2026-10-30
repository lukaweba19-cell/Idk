-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local v2 = require("./logger")
local v3 = require("./utility")
local v4 = require("../obj/Bezier")
local module: {[any]: any} = {
	bezier_cache = {}
}

function module.fromParams(p1, p2, p3, p4, p5, p6, p7)
	local u13 = module.bezier_cache[p1]

	if not u13 then
		local ok, result = pcall(function()
			return v3.deserializePath(p1)
		end)

		if not ok then
			local error = v2.error
			local v17 = ("failed to decode bezier path data with error: %*"):format(result)

			error(v17)
		end

		u13 = v4.new(result, 0)
		module.bezier_cache[p1] = u13
	end

	local n1 = 0
	local u19 = nil

	local function step(p8)
		if not p6 and n1 == 0 then
			local n3 = n1 + p8
			local v37 = math.max(p2, 0)

			n1 = math.clamp(n3, 0, v37)
		end

		local v38 = math.clamp(n1 / p2, 0, 1)
		local v39 = u13:getEase(v38)

		v38 = p3(1 - v39.y, p8, n1)

		if (v38 == nil or (if p2 == 0 then n1 > p2 else n1 >= p2)) and (not p4 or not p4.Connected) then
			u19()

			if p5 then
				p5(true)
			end
		elseif v38 then
			local n2 = n1 + v38
			local v41 = math.max(p2, 0.001)

			n1 = math.clamp(n2, 0, v41)
		end
	end

	local connection

	if not p7 then
		connection = runService.RenderStepped:Connect(step)
		u19 = function()
			connection:Disconnect()
		end

		return connection
	end

	connection = v3
	connection = connection.getRandomId
	connection = connection()
	runService:BindToRenderStep(connection, p7, step)

	local u22: boolean = true

	u19 = function()
		if not u22 then
			return
		end

		u22 = false
		runService:UnbindFromRenderStep(connection)
	end

	return u19
end
function module.timer(p9, p10, p11, p12, p13)
	local v28 = coroutine.running()
	local n1 = 0
	local u30 = nil

	local function step(p14)
		local v43 = p10(p14, n1)

		if (v43 == nil or (if p9 == 0 then n1 > p9 else n1 >= p9)) and (not p11 or not p11.Connected) then
			u30()
			task.spawn(v28)
		elseif v43 then
			local n2 = n1 + v43
			local v45 = math.max(p9, 0.001)

			n1 = math.clamp(n2, 0, v45)
		end
	end

	if not p13 then
		local connection = runService.RenderStepped:Connect(step)

		u30 = function()
			connection:Disconnect()
		end
	else
		local v33 = v3.getRandomId()

		runService:BindToRenderStep(v33, p13, step)

		local u34: boolean = true

		u30 = function()
			if not u34 then
				return
			end

			u34 = false
			runService:UnbindFromRenderStep(v33)
		end
	end

	if p12 then
		table.insert(p12, u30)
	end

	coroutine.yield()
end

return module
