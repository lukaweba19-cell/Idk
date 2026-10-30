-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local descendantsCountTracker = require(game.ReplicatedStorage.Util.DescendantsCountTracker)

game:GetService("RunService"):IsStudio()

local function v2(...)
end

return function(p1, p2, p3)
	local u6: boolean = false
	local randomNumber = math.random(1, 999999999)

	if p1:GetAttribute("ExpectedDescendants") then
		v2(randomNumber, p1:GetFullName())

		local v8 = descendantsCountTracker(p1)
		local expectedDescendantsNames = p1:GetAttribute("ExpectedDescendantsNames")

		if p3 and not expectedDescendantsNames then
			local n1 = 0

			while true do
				if p1:GetAttribute("ExpectedDescendantsNames") then
					break
				end

				local v11 = task.wait()

				n1 += v11

				if n1 > (p2 or 3) or not p1:GetAttribute("ExpectedDescendants") then
					v2("so much fail")

					break
				end

				v2(p1:GetAttribute("ExpectedDescendants"))
				v2(p1:GetAttribute("ExpectedDescendantsNames"))
			end

			expectedDescendantsNames = p1:GetAttribute("ExpectedDescendantsNames")
		end

		local connection = nil
		local t1

		if expectedDescendantsNames then
			local decodedJson: any = game:GetService("HttpService"):JSONDecode(expectedDescendantsNames)
			t1 = {}
			assert(t1, "bad serverDictionary")

			for _, v in pairs(decodedJson) do
				t1[v] = true
			end

			local v18 = p1:GetFullName()

			v2(randomNumber, v18, "Server:", t1)
			connection = p1:GetAttributeChangedSignal("ExpectedDescendantsNames"):Connect(function()
				local expectedDescendantsNames2 = p1:GetAttribute("ExpectedDescendantsNames")

				if decodedJson and expectedDescendantsNames2 then
					local decodedJson2: any = game:GetService("HttpService"):JSONDecode(expectedDescendantsNames2)
					t1 = {}

					for _, v in pairs(decodedJson2) do
						t1[v] = true
					end

					return
				end

				t1 = nil
			end)
		else
			t1 = {}
		end

		local v19 = os.clock()
		local u20: boolean = false

		while true do
			local expectedDescendants = p1:GetAttribute("ExpectedDescendants")

			if not expectedDescendants then
				break
			end

			local count = v8.count
			local u23: boolean = true

			if t1 then
				for iterKey in pairs(t1) do
					if not v8.dictionary[iterKey] then
						u23 = false

						break
					end
				end
			end

			if not u20 then
				local v25 = p1:GetFullName()

				v2(randomNumber, v25, "Client:", v8.dictionary)
			end

			if expectedDescendants <= count and u23 then
				u6 = true

				break
			end

			local v26 = os.clock()

			if p2 < v26 - v19 or not p1:IsDescendantOf(game) then
				break
			end

			u20 = true
			task.wait()
		end

		if u20 and _G.TestGame and (p1.Name ~= "Tree" or not (os.clock() - v19 < 0.1)) then
			local v27 = p1:GetFullName()
			local stringFormat = string.format
			local v29 = os.clock()
			local v30 = stringFormat("%.1f", v29 - v19)

			warn("Took longer than a step to WaitForExpectedDescendants:", v27, "~" .. v30 .. "s")
		end

		v8.Destroy()

		if connection then
			connection:Disconnect()
		end

		p1:SetAttribute("ExpectedDescendantsNames", nil)
		p1:SetAttribute("ExpectedDescendants", nil)

		return u6
	end

	return true
end
