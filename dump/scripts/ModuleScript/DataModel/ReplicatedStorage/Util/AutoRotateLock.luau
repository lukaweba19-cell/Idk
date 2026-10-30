-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
game:GetService("RunService"):IsServer()

local function getCount(p1)
	local autoRotateLockCount = p1:GetAttribute("AutoRotateLockCount")

	if typeof(autoRotateLockCount) == "number" then
		return autoRotateLockCount
	end

	p1:SetAttribute("AutoRotateLockCount", 0)

	return 0
end
local function setCount(p2, p3: number)
	if p3 < 0 then
		p3 = 0
	end

	p2:SetAttribute("AutoRotateLockCount", p3)
end
local function applyState(p4)
	local autoRotateLockCount = p4:GetAttribute("AutoRotateLockCount")
	local n1

	if typeof(autoRotateLockCount) == "number" then
		n1 = autoRotateLockCount
	else
		p4:SetAttribute("AutoRotateLockCount", 0)
		n1 = 0
	end

	p4.AutoRotate = n1 == 0
end

local object = setmetatable({}, { __mode = "k" })

local function ensureWired(p5)
	if object[p5] then
		return
	end

	object[p5] = true

	local autoRotateLockCount = p5:GetAttribute("AutoRotateLockCount")

	if typeof(autoRotateLockCount) ~= "number" then
		p5:SetAttribute("AutoRotateLockCount", 0)
	end

	local autoRotateLockCount2 = p5:GetAttribute("AutoRotateLockCount")
	local n1

	if typeof(autoRotateLockCount2) == "number" then
		n1 = autoRotateLockCount2
	else
		p5:SetAttribute("AutoRotateLockCount", 0)
		n1 = 0
	end

	p5.AutoRotate = n1 == 0
	p5:GetAttributeChangedSignal("AutoRotateLockCount"):Connect(function()
		local v25 = p5
		local autoRotateLockCount3 = v25:GetAttribute("AutoRotateLockCount")
		local n1

		if typeof(autoRotateLockCount3) == "number" then
			n1 = autoRotateLockCount3
		else
			v25:SetAttribute("AutoRotateLockCount", 0)
			n1 = 0
		end

		v25.AutoRotate = n1 == 0
	end)
	p5.Destroying:Once(function()
		object[p5] = nil
	end)
end

return function(p6)
	ensureWired(p6)

	local autoRotateLockCount = p6:GetAttribute("AutoRotateLockCount")
	local n1

	if typeof(autoRotateLockCount) == "number" then
		n1 = autoRotateLockCount
	else
		p6:SetAttribute("AutoRotateLockCount", 0)
		n1 = 0
	end

	local n2 = n1 + 1

	if n2 < 0 then
		n2 = 0
	end

	p6:SetAttribute("AutoRotateLockCount", n2)

	local autoRotateLockCount4 = p6:GetAttribute("AutoRotateLockCount")
	local n3

	if typeof(autoRotateLockCount4) == "number" then
		n3 = autoRotateLockCount4
	else
		p6:SetAttribute("AutoRotateLockCount", 0)
		n3 = 0
	end

	p6.AutoRotate = n3 == 0

	local u23: boolean = false

	local t1: {[any]: any} = {
		Destroy = function(_)
			if u23 then
				return
			end

			u23 = true

			local v29 = p6
			local autoRotateLockCount5 = v29:GetAttribute("AutoRotateLockCount")
			local n1

			if typeof(autoRotateLockCount5) == "number" then
				n1 = autoRotateLockCount5
			else
				v29:SetAttribute("AutoRotateLockCount", 0)
				n1 = 0
			end

			local n2 = n1 - 1

			if n2 < 0 then
				n2 = 0
			end

			p6:SetAttribute("AutoRotateLockCount", n2)

			local v33 = p6
			local autoRotateLockCount6 = v33:GetAttribute("AutoRotateLockCount")
			local n3

			if typeof(autoRotateLockCount6) == "number" then
				n3 = autoRotateLockCount6
			else
				v33:SetAttribute("AutoRotateLockCount", 0)
				n3 = 0
			end

			v33.AutoRotate = n3 == 0
		end,
		Destroyed = false
	}

	setmetatable(t1, {
		__index = { Destroy = t1.Destroy, Destroyed = u23 }
	})

	return t1
end
