-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")

local function opt(p1, p2)
	if p1 == nil then
		return p2
	end

	return p1
end
local function resolveGradient(p3)
	if not p3 then
		return nil
	end

	if p3:IsA("UIGradient") then
		return p3
	end

	return (p3:FindFirstChildWhichIsA("UIGradient", true))
end

local t1: {[any]: any} = {
	duration = 0.7,
	interval = 2.5,
	offsetStart = Vector2.new(-1.2, 0),
	offsetEnd = Vector2.new(1.2, 0),
	easingStyle = Enum.EasingStyle.Sine,
	easingDirection = Enum.EasingDirection.InOut
}

local module: {[any]: any} = {
	sweep = function(p4, p5)
		local v11 = if not p4 then nil else if p4:IsA("UIGradient") then p4 else p4:FindFirstChildWhichIsA("UIGradient", true)

		if not v11 then
			return nil
		end

		local t3 = p5 or {}
		local offsetStart = t3.offsetStart
		local offsetEnd = t3.offsetEnd
		local v15 = if offsetEnd == nil then t1.offsetEnd else offsetEnd
		local duration = t3.duration
		local v17 = if duration == nil then t1.duration else duration
		local easingStyle = t3.easingStyle
		local v19 = if easingStyle == nil then t1.easingStyle else easingStyle
		local easingDirection = t3.easingDirection
		local v21 = if easingDirection == nil then t1.easingDirection else easingDirection

		v11.Offset = if offsetStart == nil then t1.offsetStart else offsetStart

		local tweenInfo = TweenInfo.new(v17, v19, v21)

		v21 = tweenService:Create(v11, tweenInfo, { Offset = v15 })
		v21:Play()

		return v21
	end
}

function module.loop(p6, p7)
	local v25 = if not p6 then nil else if p6:IsA("UIGradient") then p6 else p6:FindFirstChildWhichIsA("UIGradient", true)
	local t4 = p7 or {}
	local interval = t4.interval
	local v28 = if interval == nil then t1.interval else interval
	local u29: boolean = true
	local u30 = nil

	local function stop()
		u29 = false

		if u30 then
			u30:Cancel()
			u30 = nil
		end
	end

	if not v25 then
		return stop
	end

	task.spawn(function()
		while u29 do
			if not v25.Parent or not v25:IsDescendantOf(game) then
				u29 = false

				return
			end

			local v35 = module.sweep(v25, t4)

			u30 = v35

			if v35 then
				v35.Completed:Wait()
			end

			u30 = nil

			if not u29 then
				break
			end

			if v28 > 0 then
				task.wait(v28)
			end
		end
	end)

	return stop
end
function module.hover(p8, p9)
	local connection = p8.MouseEnter:Connect(function()
		module.sweep(p8, p9)
	end)

	return function()
		connection:Disconnect()
	end
end

return module
