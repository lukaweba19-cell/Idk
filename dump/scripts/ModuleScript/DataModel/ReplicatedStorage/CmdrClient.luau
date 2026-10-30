-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local starterGui: StarterGui = game:GetService("StarterGui")
local LocalPlayer: Player = game:GetService("Players").LocalPlayer
local shared: Instance = script:WaitForChild("Shared")
local util = require(shared:WaitForChild("Util"))

if runService:IsClient() == false then
	error("Server scripts cannot require the client library. Please require the server library to use Cmdr in your own code.")
end

local cmdrFunction: Instance = script:WaitForChild("CmdrFunction")
local cmdrEvent: Instance = script:WaitForChild("CmdrEvent")

local object = setmetatable({
	Enabled = true,
	MashToEnable = false,
	ActivationUnlocksMouse = false,
	HideOnLostFocus = true,
	PlaceName = "Cmdr",
	ReplicatedRoot = script,
	RemoteFunction = cmdrFunction,
	RemoteEvent = cmdrEvent,
	ActivationKeys = { [Enum.KeyCode.F2] = true },
	Util = util,
	Events = {}
}, {
	__index = function(p1, p2)
		local v12 = p1.Dispatcher[p2]

		if v12 and type(v12) == "function" then
			return function(_, ...)
				return v12(p1.Dispatcher, ...)
			end
		end
	end
})

object.Registry = require(shared.Registry)(object)
object.Dispatcher = require(shared.Dispatcher)(object)
starterGui:WaitForChild("Cmdr")

local v9 = require(script.CmdrInterface)(object)

function object.SetActivationKeys(p4, p5)
	p4.ActivationKeys = util.MakeDictionary(p5)
end
function object.SetPlaceName(p6, placeName)
	p6.PlaceName = placeName
	v9.Window:UpdateLabel()
end
function object.SetEnabled(p8, enabled)
	p8.Enabled = enabled
end
function object.SetActivationUnlocksMouse(p10, activationUnlocksMouse)
	p10.ActivationUnlocksMouse = activationUnlocksMouse
end
function object.Show(p12)
	if not p12.Enabled then
		return
	end

	v9.Window:Show()
end
function object.Hide(_)
	v9.Window:Hide()
end
function object.Toggle(p14)
	if not p14.Enabled then
		return p14:Hide()
	end

	local window = v9.Window
	local v25 = v9.Window:IsVisible()

	window:SetVisible(not v25)
end
function object.SetMashToEnable(p15, mashToEnable)
	p15.MashToEnable = mashToEnable

	if mashToEnable then
		p15:SetEnabled(false)
	end
end
function object.SetHideOnLostFocus(p17, hideOnLostFocus)
	p17.HideOnLostFocus = hideOnLostFocus
end
function object.HandleEvent(p19, p20, p21)
	p19.Events[p20] = p21
end

if runService:IsServer() == false then
	object.Registry:RegisterTypesIn(script:WaitForChild("Types"))
	object.Registry:RegisterCommandsIn(script:WaitForChild("Commands"))
end

object.RemoteEvent.OnClientEvent:Connect(function(p22, ...)
	if object.Events[p22] then
		object.Events[p22](...)
	end
end)
require(script.DefaultEventHandlers)(object)

return object
