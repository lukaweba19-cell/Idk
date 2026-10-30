-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")
local playerGui: Instance = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local sound = require(replicatedStorage:WaitForChild("Sound"))

return {
	play = function(p1)
		local countdown: Instance = playerGui:WaitForChild("InMatchUI"):WaitForChild("Round"):WaitForChild("Countdown")
		local timerText: Instance = countdown:WaitForChild("TimerText")
		local v8 = timerText.TextSize

		if v8 < 10 then
			v8 = 68
		end

		countdown.Visible = true
		timerText.TextSize = v8

		local function shake(p2, p3)
			local countdownPosition = countdown.Position
			local timestamp = tick()

			while true do
				local timestamp2 = tick()

				if not (p2 > timestamp2 - timestamp) then
					break
				end

				local n1 = 1 - (tick() - timestamp) / p2
				local randomNumber = math.random()
				local randomNumber2 = math.random()

				countdown.Position = UDim2.new(countdownPosition.X.Scale + (randomNumber * 2 - 1) * p3 * n1, countdownPosition.X.Offset, countdownPosition.Y.Scale + (randomNumber2 * 2 - 1) * p3 * n1, countdownPosition.Y.Offset)
				task.wait()
			end

			countdown.Position = countdownPosition
		end

		for i = 3, 1, -1 do
			timerText.Text = tostring(i)
			timerText.TextSize = v8
			timerText.TextTransparency = 0
			countdown.ImageTransparency = 0

			local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

			tweenService:Create(countdown, tweenInfo, { ImageTransparency = 0.5 }):Play()

			local tweenInfo2 = TweenInfo.new(0.85, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

			tweenService:Create(timerText, tweenInfo2, { TextSize = 1 }):Play()
			pcall(function()
				sound:Play("Misc.TimerTick", workspace)
			end)
			task.wait(1)
		end

		timerText.Text = "GO!"
		timerText.TextSize = v8
		timerText.TextTransparency = 0
		countdown.ImageTransparency = 0

		local tweenInfo3 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		tweenService:Create(countdown, tweenInfo3, { ImageTransparency = 0.5 }):Play()
		pcall(function()
			sound:Play("Misc.CountdownGO", workspace)
			sound:Play("Misc.CountdownGOBass", workspace)
		end)
		task.spawn(function()
			shake(0.35, 0.015)
		end)
		task.wait(0.8)
		countdown.Visible = false
		timerText.TextSize = v8
		timerText.Text = "3"
		timerText.TextTransparency = 0
		countdown.ImageTransparency = 0

		if p1 then
			p1()
		end

		return nil
	end
}
