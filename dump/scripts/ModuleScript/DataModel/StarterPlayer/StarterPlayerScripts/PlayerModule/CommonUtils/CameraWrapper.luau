-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local connectionUtil = require(script.Parent.ConnectionUtil)
local module: {[any]: any} = {}

module.__index = module

function module.new()
	local CurrentCamera: Camera = game.Workspace.CurrentCamera
	local v4 = connectionUtil.new()

	return (setmetatable({
		_enabled = false,
		_camera = CurrentCamera,
		_callbacks = {},
		_connectionUtil = v4
	}, module))
end
function module._connectCallbacks(p1)
	p1._camera = game.Workspace.CurrentCamera

	if not p1._camera then
		return
	end

	for iterFirst, iterSecond in p1._callbacks, nil, nil do
		local _connectionUtil = p1._connectionUtil
		local v9 = p1._camera:GetPropertyChangedSignal(iterFirst)

		_connectionUtil:trackConnection(iterFirst, v9:Connect(iterSecond))
		iterSecond()
	end
end
function module.Enable(p2)
	if p2._enabled then
		return
	end

	p2._enabled = true
	p2._cameraChangedConnection = game.Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		p2:_connectCallbacks()
	end)
	p2:_connectCallbacks()
end
function module.Disable(p3)
	if not p3._enabled then
		return
	end

	p3._enabled = false

	if p3._cameraChangedConnection then
		p3._cameraChangedConnection:Disconnect()
		p3._cameraChangedConnection = nil
	end

	p3._connectionUtil:disconnectAll()
end
function module.Connect(p4, p5, p6)
	p4._callbacks[p5] = p6

	if not p4._camera then
		return
	end

	local _connectionUtil = p4._connectionUtil
	local v16 = p4._camera:GetPropertyChangedSignal(p5)

	_connectionUtil:trackConnection(p5, v16:Connect(p6))
end
function module.Disconnect(p7, p8)
	p7._connectionUtil:disconnect(p8)
	p7._callbacks[p8] = nil
end
function module.getCamera(p9)
	return p9._camera
end

return module
