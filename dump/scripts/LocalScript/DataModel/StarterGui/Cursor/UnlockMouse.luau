-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local userInputService: UserInputService = game:GetService("UserInputService")
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local toggleMatchLeaderboard: Instance = replicatedStorage:WaitForChild("Bindables"):WaitForChild("ToggleMatchLeaderboard")
local extensions: Instance = replicatedStorage:WaitForChild("Extensions")

require(extensions:WaitForChild("GamepadBindings"))

local replicatedStorageExtensions: Instance = replicatedStorage:WaitForChild("Extensions")
local inputMap = require(replicatedStorageExtensions:WaitForChild("InputMap"))
local LocalPlayer: Player = players.LocalPlayer

LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD")

local inMatchUI: Instance = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("InMatchUI")
local abilities: Instance = inMatchUI:WaitForChild("Abilities")
local centerDot = script.Parent.CenterDot
local u12: boolean = false

LocalPlayer:SetAttribute("MouseUnlocked", 0)

local function refresh()
	local u15: boolean = true

	if not ((LocalPlayer:GetAttribute("MouseUnlocked") or 0) > 0) then
		u15 = u12 or abilities.Visible == false
	end

	centerDot.Visible = not u15
end

inputMap.bind("Scoreboard", function(p1)
	if p1 ~= Enum.UserInputState.Begin then
		if u12 then
			u12 = false

			local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

			LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) - 1)
			toggleMatchLeaderboard:Fire(false)

			local u18: boolean = true

			if not ((LocalPlayer:GetAttribute("MouseUnlocked") or 0) > 0) then
				u18 = u12 or abilities.Visible == false
			end

			centerDot.Visible = not u18
		end
	elseif not u12 then
		u12 = true

		local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

		LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) + 1)
		toggleMatchLeaderboard:Fire(true)

		local u20: boolean = true

		if not ((LocalPlayer:GetAttribute("MouseUnlocked") or 0) > 0) then
			u20 = u12 or abilities.Visible == false
		end

		centerDot.Visible = not u20

		return
	end
end, { manual = true })
userInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean)
	if gameProcessedEvent then
		return
	end

	inputMap.handleInput("Scoreboard", input, Enum.UserInputState.Begin)
end)
userInputService.InputEnded:Connect(function(input: InputObject)
	inputMap.handleInput("Scoreboard", input, Enum.UserInputState.End)
end);
(function(matchStatusFrame, p6, p7)
	local u27 = nil

	matchStatusFrame.InputBegan:Connect(function(input)
		if u27 then
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			u27 = input
			p6()

			return
		end
	end)
	userInputService.InputEnded:Connect(function(input: InputObject)
		if input ~= u27 then
			return
		end

		u27 = nil
		p7()
	end)
	userInputService.InputChanged:Connect(function(input: InputObject)
		if input.UserInputState ~= Enum.UserInputState.Cancel then
			return
		end

		if input ~= u27 then
			return
		end

		u27 = nil
		p7()
	end)
end)(inMatchUI:WaitForChild("Round"):WaitForChild("MatchStatusFrame"), function()
	if not u12 then
		u12 = true

		local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

		LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) + 1)
		toggleMatchLeaderboard:Fire(true)

		local u29: boolean = true

		if not ((LocalPlayer:GetAttribute("MouseUnlocked") or 0) > 0) then
			u29 = u12 or abilities.Visible == false
		end

		centerDot.Visible = not u29
	end
end, function()
	if u12 then
		u12 = false

		local mouseUnlocked: any = LocalPlayer:GetAttribute("MouseUnlocked")

		LocalPlayer:SetAttribute("MouseUnlocked", (mouseUnlocked or 0) - 1)
		toggleMatchLeaderboard:Fire(false)

		local u31: boolean = true

		if not ((LocalPlayer:GetAttribute("MouseUnlocked") or 0) > 0) then
			u31 = u12 or abilities.Visible == false
		end

		centerDot.Visible = not u31
	end
end)
LocalPlayer:GetAttributeChangedSignal("MouseUnlocked"):Connect(refresh)
abilities:GetPropertyChangedSignal("Visible"):Connect(refresh)

local u14: boolean = true

if not ((LocalPlayer:GetAttribute("MouseUnlocked") or 0) > 0) then
	u14 = u12 or abilities.Visible == false
end

centerDot.Visible = not u14
