-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local t1: {[any]: any} = {
	LOCAL_PLAYER = "LOCAL_PLAYER",
	ON_LOCAL_PLAYER = "ON_LOCAL_PLAYER",
	CHARACTER_ADDED = "CHARACTER_ADDED",
	ON_CHARACTER = "ON_CHARACTER",
	CHARACTER_CHILD_ADDED = "CHARACTER_CHILD_ADDED"
}

local module: {[any]: any} = {
	_connectionUtil = require(script.Parent:WaitForChild("ConnectionUtil")).new(),
	_boundEvents = {},
	getLocalPlayer = function()
		return players.LocalPlayer
	end
}

function module.onLocalPlayer(p1)
	local v5 = module.getLocalPlayer()

	if v5 then
		p1(v5)
	end

	local _connectionUtil = module._connectionUtil
	local v7: RBXScriptSignal = players:GetPropertyChangedSignal("LocalPlayer")

	_connectionUtil:trackConnection("LOCAL_PLAYER", v7:Connect(function()
		local v18 = module.getLocalPlayer()

		assert(v18)
		module._getOrCreateBoundEvent("LOCAL_PLAYER"):Fire(v18)
	end))

	return module._getOrCreateBoundEvent("LOCAL_PLAYER").Event:Connect(p1)
end
function module.getCharacter()
	local player = module.getLocalPlayer()

	if not player then
		return nil
	end

	return player.Character
end
function module.onCharacter(p2)
	module._connectionUtil:trackConnection("ON_LOCAL_PLAYER", module.onLocalPlayer(function(player)
		local v20 = module.getCharacter()

		if v20 then
			p2(v20)
		end

		module._connectionUtil:trackConnection("CHARACTER_ADDED", player.CharacterAdded:Connect(function(p4)
			assert(p4)
			module._getOrCreateBoundEvent("CHARACTER_ADDED"):Fire(p4)
		end))
	end))

	return module._getOrCreateBoundEvent("CHARACTER_ADDED").Event:Connect(p2)
end
function module.getChild(p5, p6)
	local v12 = module.getCharacter()

	if not v12 then
		return nil
	end

	local foundChild = v12:FindFirstChild(p5)

	if foundChild and foundChild:IsA(p6) then
		return foundChild
	end

	return nil
end
function module.onChild(p7, p8, p9)
	module._connectionUtil:trackConnection("ON_CHARACTER", module.onCharacter(function(p10)
		local v22 = module.getChild(p7, p8)

		if v22 then
			p9(v22)
		end

		module._connectionUtil:trackConnection("CHARACTER_CHILD_ADDED", p10.ChildAdded:Connect(function(p11)
			if p11.Name == p7 and p11:IsA(p8) then
				module._getOrCreateBoundEvent("CHARACTER_CHILD_ADDED" .. p7 .. p8):Fire(p11)
			end
		end))
	end))

	return module._getOrCreateBoundEvent("CHARACTER_CHILD_ADDED" .. p7 .. p8).Event:Connect(p9)
end
function module._getOrCreateBoundEvent(p12)
	if not module._boundEvents[p12] then
		module._boundEvents[p12] = Instance.new("BindableEvent")
	end

	return module._boundEvents[p12]
end

return module
