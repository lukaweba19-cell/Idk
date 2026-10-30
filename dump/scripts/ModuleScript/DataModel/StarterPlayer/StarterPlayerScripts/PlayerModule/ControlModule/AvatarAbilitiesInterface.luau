-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local commonUtils: Instance = script.Parent.Parent:WaitForChild("CommonUtils")

if require(commonUtils:WaitForChild("FlagUtil")).getUserFlag("UserPlayerScriptsCanUseLCC") then
	local players: Players = game:GetService("Players")
	local abilityManagerActor = nil
	local humanoid = nil
	local bindableEvent: BindableEvent = Instance.new("BindableEvent")
	local connection = nil

	local function characterAdded(character)
		abilityManagerActor = character:FindFirstChild("AbilityManagerActor")
		humanoid = character:FindFirstChildOfClass("Humanoid")

		while not humanoid do
			character.ChildAdded:wait()
			humanoid = character:FindFirstChildOfClass("Humanoid")
		end

		bindableEvent:Fire()

		if connection then
			connection:Disconnect()
			connection = nil
		end

		connection = humanoid:GetPropertyChangedSignal("EvaluateStateMachine"):Connect(function()
			bindableEvent:Fire()
		end)
	end

	local LocalPlayer: Player = players.LocalPlayer

	LocalPlayer.CharacterAdded:Connect(characterAdded)

	if LocalPlayer.Character then
		characterAdded(LocalPlayer.Character)
	end

	return {
		isEnabled = function(_)
			local u11 = false

			if abilityManagerActor ~= nil then
				u11 = humanoid and not humanoid.EvaluateStateMachine
			end

			return u11
		end,
		GetEnabledChangedSignal = function(_)
			return bindableEvent.Event
		end
	}
end
