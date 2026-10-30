-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local runService: RunService = game:GetService("RunService")
local object = setmetatable({}, { __mode = "k" })

local function numbers(p1)
	local t1: {[any]: any} = {}

	if typeof(p1) == "number" then
		table.insert(t1, p1)
	elseif typeof(p1) == "string" then
		for iterValue in p1:gmatch("[^,%s]+") do
			local numberValue: number? = tonumber(iterValue)

			if numberValue then
				table.insert(t1, numberValue)
			end
		end
	end

	table.sort(t1)

	return t1
end
local function windows(p2)
	local t2: {[any]: any} = {}

	if typeof(p2) == "string" then
		for iterFirst, iterSecond in p2:gmatch("([%d%.]+)%s*%-%s*([%d%.]+)") do
			local numberValue: number? = tonumber(iterFirst)
			local numberValue2: number? = tonumber(iterSecond)

			if numberValue and numberValue2 then
				table.insert(t2, { numberValue, numberValue2 })
			end
		end
	end

	return t2
end
local function suppressed()
	local LocalPlayer: Player = players.LocalPlayer

	if LocalPlayer and LocalPlayer:GetAttribute("DisableFPEffects") == true then
		local v18 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
		local CurrentCamera: Camera = workspace.CurrentCamera

		return v18 ~= nil and CurrentCamera ~= nil and (CurrentCamera.CFrame.Position - v18.Position).Magnitude < 1.5
	end

	return false
end

return {
	Play = function(p3, p4)
		if p3 and p4 and not suppressed() then
			local t3: {[any]: any} = {}
			local t4: {[any]: any} = {}

			for iterFirst, iterSecond in p3:GetDescendants() do
				if iterSecond:IsA("ParticleEmitter") then
					local v26 = numbers(iterSecond:GetAttribute("InspectAt"))

					if #v26 > 0 then
						table.insert(t3, { nextIdx = 1, e = iterSecond, times = v26 })
					end

					v26 = windows(iterSecond:GetAttribute("InspectWindow"))

					if #v26 > 0 then
						table.insert(t4, { e = iterSecond, spans = v26 })
					end
				end
			end

			if #t3 == 0 and #t4 == 0 then
				return
			end

			local n1 = (object[p3] or 0) + 1

			object[p3] = n1

			local connection = nil

			local function stop()
				if connection then
					connection:Disconnect()
					connection = nil
				end

				for key, value in t4 do
					value.e.Enabled = false
				end
			end

			connection = runService.Heartbeat:Connect(function()
				if object[p3] == n1 and p4.IsPlaying and p3.Parent then
					local timePosition = p4.TimePosition

					for key, value in t3 do
						while value.nextIdx <= #value.times and timePosition >= value.times[value.nextIdx] do
							local e = value.e
							local numberValue: number? = tonumber(value.e:GetAttribute("EmitCount"))

							e:Emit(numberValue or 10)
							value.nextIdx = value.nextIdx + 1
						end
					end

					for key2, value2 in t4 do
						local u39: boolean = false

						for iterFirst, iterSecond in value2.spans, nil, nil do
							if timePosition >= iterSecond[1] and timePosition < iterSecond[2] then
								u39 = true

								break
							end
						end

						if u39 ~= value2.e.Enabled then
							value2.e.Enabled = u39
						end
					end
				elseif object[p3] == n1 then
					if connection then
						connection:Disconnect()
						connection = nil
					end

					for key3, value3 in t4 do
						value3.e.Enabled = false
					end
				elseif connection then
					connection:Disconnect()
					connection = nil

					return
				end
			end)

			return
		end
	end
}
