-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local util = require(script.Shared:WaitForChild("Util"))

if runService:IsServer() == false then
	error("Cmdr server module is somehow running on a client!")
end

local object = setmetatable({
	ReplicatedRoot = nil,
	RemoteFunction = nil,
	RemoteEvent = nil,
	Util = util,
	DefaultCommandsFolder = script.BuiltInCommands
}, {
	__index = function(p1, p2)
		local v6 = p1.Registry[p2]

		if v6 and type(v6) == "function" then
			return function(_, ...)
				return v6(p1.Registry, ...)
			end
		end
	end
})

object.Registry = require(script.Shared.Registry)(object)
object.Dispatcher = require(script.Shared.Dispatcher)(object)
require(script.Initialize)(object)

function object.RemoteFunction.OnServerInvoke(p4, p5, p6)
	if #p5 > 100000 then
		return "Input too long"
	end

	return object.Dispatcher:EvaluateAndRun(p5, p4, p6)
end

return object
