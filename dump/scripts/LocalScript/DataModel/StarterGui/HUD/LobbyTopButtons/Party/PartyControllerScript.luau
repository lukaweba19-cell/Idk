-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local shared: Instance = replicatedStorage:WaitForChild("Shared")

if require(shared:WaitForChild("TradingPlazaGate")).IsTradingPlaza() then
	script.Parent.Visible = false

	return
end

local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local partyView = require(replicatedStorageShared:WaitForChild("PartyView"))
local u5: boolean = replicatedStorage:GetAttribute("IsMatchServer") == true

partyView.mount(script.Parent, { hideInMatch = true, hideOnDuelPad = true, lockComposition = u5 })

local scriptParent: Instance = script.Parent
local playBtn: Instance = scriptParent.Parent:FindFirstChild("PlayBtn")

if not u5 and playBtn and playBtn:IsA("GuiObject") then
	local scriptParentPosition = scriptParent.Position
	local list: Instance = scriptParent:FindFirstChild("List")
	local uIListLayout = if list then list:FindFirstChildOfClass("UIListLayout") else nil
	local horizontalAlignment = if uIListLayout then uIListLayout.HorizontalAlignment else Enum.HorizontalAlignment.Left

	playBtn:GetPropertyChangedSignal("Visible"):Connect(function()
		if playBtn.Visible then
			scriptParent.Position = scriptParentPosition

			if uIListLayout then
				uIListLayout.HorizontalAlignment = horizontalAlignment

				return
			end
		else
			scriptParent.Position = UDim2.new(0.5, 0, scriptParentPosition.Y.Scale, scriptParentPosition.Y.Offset)

			if uIListLayout then
				uIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			end
		end
	end)

	if playBtn.Visible then
		scriptParent.Position = scriptParentPosition

		if uIListLayout then
			uIListLayout.HorizontalAlignment = horizontalAlignment

			return
		end
	else
		scriptParent.Position = UDim2.new(0.5, 0, scriptParentPosition.Y.Scale, scriptParentPosition.Y.Offset)

		if uIListLayout then
			uIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		end
	end

	return
end
