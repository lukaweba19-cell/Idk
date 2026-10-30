-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local color3 = Color3.fromRGB(0, 255, 0)
local color32 = Color3.fromRGB(255, 0, 0)
local t1: {[any]: any} = {}

local function lerpHue(p1, p2, p3)
	local v12, v13, v14 = p1:ToHSV()
	local v15, v16, v17 = p2:ToHSV()
	local n1 = v15 - v12

	if n1 > 0.5 then
		n1 -= 1
	elseif n1 < -0.5 then
		n1 += 1
	end

	return Color3.fromHSV((v12 + n1 * p3) % 1, v13 + (v16 - v13) * p3, v14 + (v17 - v14) * p3)
end
local function tint(p4, backgroundColor3)
	p4.BackgroundColor3 = backgroundColor3
end
local function resolve(p6)
	local container = p6:FindFirstChild("Container")
	local container1 = p6:FindFirstChild("Container1")
	local cooldownIndicatorPart1 = container and container:FindFirstChild("CooldownIndicatorPart1")
	local v25 = container1

	if v25 then
		v25 = container1:FindFirstChild("CooldownIndicatorPart2")
	end

	if cooldownIndicatorPart1 and v25 then
		local uiGradient = cooldownIndicatorPart1:FindFirstChildOfClass("UIGradient")
		local uiGradient2 = v25:FindFirstChildOfClass("UIGradient")

		if uiGradient and uiGradient2 then
			return {
				part1 = cooldownIndicatorPart1,
				part2 = v25,
				grad1 = uiGradient,
				grad2 = uiGradient2
			}
		end

		return nil
	end

	return nil
end
local function stop(p7, p8)
	local v30 = t1[p7]

	if not v30 then
		if p8 and p7 and p7.Parent then
			p7.Visible = false
		end

		return
	end

	t1[p7] = nil

	if v30.conn then
		v30.conn:Disconnect()
	end

	if p8 and p7.Parent then
		v30.grad1.Rotation = 0
		v30.grad2.Rotation = 0
		p7.Visible = false
	end
end

return {
	RadialStart = function(p9, p10, p11)
		if not p9 or typeof(p10) ~= "number" or p10 <= 0 then
			return
		end

		if t1[p9] then
			return
		end

		local v34 = resolve(p9)

		if not v34 then
			if p9.Parent then
				p9.Visible = false
			end

			return
		end

		local t2 = p11 or {}
		local backgroundColor3 = t2.startColor or color3
		local v37 = t2.endColor or color32
		local u38: boolean = t2.autoHide ~= false
		local onComplete = t2.onComplete
		local part1 = v34.part1
		local part2 = v34.part2
		local grad1 = v34.grad1
		local grad2 = v34.grad2

		p9.Visible = true
		part1.Visible = true
		part2.Visible = true
		grad1.Rotation = 0
		grad2.Rotation = 0
		part1.BackgroundColor3 = backgroundColor3
		part2.BackgroundColor3 = backgroundColor3

		local v44 = os.clock()
		local t3: {[any]: any} = { grad1 = grad1, grad2 = grad2 }

		t1[p9] = t3
		t3.conn = runService.RenderStepped:Connect(function()
			if not p9.Parent then
				local v50 = p9
				local v51 = t1[v50]

				if not v51 then
					return
				end

				t1[v50] = nil

				if v51.conn then
					v51.conn:Disconnect()
				end

				return
			end

			local v52 = os.clock()
			local v53 = math.clamp((v52 - v44) / p10, 0, 1)
			local backgroundColor4 = lerpHue(backgroundColor3, v37, v53 ^ 0.5)

			part1.BackgroundColor3 = backgroundColor4
			part2.BackgroundColor3 = backgroundColor4

			if v53 < 0.5 then
				grad1.Rotation = v53 * 360

				if not part1.Visible then
					part1.Visible = true
				end
			else
				if part1.Visible then
					part1.Visible = false
				end

				grad2.Rotation = (v53 - 0.5) * 360
			end

			if v53 >= 1 then
				grad1.Rotation = 180
				grad2.Rotation = 180
				part1.Visible = false

				local v55 = p9
				local v56 = t1[v55]

				if v56 then
					t1[v55] = nil

					if v56.conn then
						v56.conn:Disconnect()
					end
				end

				if u38 then
					p9.Visible = false
				end

				if type(onComplete) == "function" then
					task.spawn(onComplete, p9)
				end
			end
		end)
	end,
	CancelRadial = function(p12)
		if not p12 then
			return
		end

		local v47 = t1[p12]

		if v47 then
			t1[p12] = nil

			if v47.conn then
				v47.conn:Disconnect()
			end

			if p12.Parent then
				v47.grad1.Rotation = 0
				v47.grad2.Rotation = 0
				p12.Visible = false
			end
		elseif p12 and p12.Parent then
			p12.Visible = false

			return
		end
	end,
	IsRunning = function(p13)
		return t1[p13] ~= nil
	end,
	WaitUntilCompleted = function(p14)
		while p14 and t1[p14] do
			runService.RenderStepped:Wait()
		end
	end
}
