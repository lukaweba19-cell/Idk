-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local cameraShakeInstance = require(script.Parent.CameraShakeInstance)

local t1: {[any]: any} = {
	["Regular Explosion"] = function()
		local v3 = cameraShakeInstance.new(1.5, 10, 0, 0.5)

		v3.PositionInfluence = Vector3.new(0.7, 0.7, 0.7)
		v3.RotationInfluence = Vector3.new(1, 1, 1)

		return v3
	end,
	["Regular Explosion Smooth"] = function()
		local v4 = cameraShakeInstance.new(0.7, 10, 0, 0.7)

		v4.PositionInfluence = Vector3.new(0.45, 0.45, 0.45)
		v4.RotationInfluence = Vector3.new(0.5, 0.5, 0.5)

		return v4
	end,
	["Regular Explosion Super Smooth"] = function()
		local v5 = cameraShakeInstance.new(0.5, 15, 0, 0.2)

		v5.PositionInfluence = Vector3.new(0.2, 0.2, 0.2)
		v5.RotationInfluence = Vector3.new(0.2, 0.2, 0.2)

		return v5
	end,
	CombatBump = function()
		local v6 = cameraShakeInstance.new(2.5, 4, 0.1, 0.75)

		v6.PositionInfluence = Vector3.new(0.15, 0.15, 0.15)
		v6.RotationInfluence = Vector3.new(1, 1, 1)

		return v6
	end,
	Bump = function()
		local v7 = cameraShakeInstance.new(4, 6, 0.1, 0.4)

		v7.PositionInfluence = Vector3.new(0.15, 0.15, 0.15)
		v7.RotationInfluence = Vector3.new(1, 1, 1)

		return v7
	end,
	Bump2 = function()
		local v8 = cameraShakeInstance.new(2.5, 4, 0.1, 0.75)

		v8.PositionInfluence = Vector3.new(0.3, 0.3, 0.3)
		v8.RotationInfluence = Vector3.new(2, 2, 2)

		return v8
	end,
	Bump3 = function()
		local v9 = cameraShakeInstance.new(1, 2, 0.1, 0.75)

		v9.PositionInfluence = Vector3.new(0.3, 0.3, 0.3)
		v9.RotationInfluence = Vector3.new(2, 2, 2)

		return v9
	end,
	Bump4 = function()
		local v10 = cameraShakeInstance.new(3, 12, 0.6, 1)

		v10.PositionInfluence = Vector3.new(0.3, 0.3, 0.3)
		v10.RotationInfluence = Vector3.new(0.5, 0.5, 0.5)

		return v10
	end,
	Hit = function()
		local v11 = cameraShakeInstance.new(2.75, 12.5, 0.1, 0.5)

		v11.PositionInfluence = Vector3.new(0.15, 0.15, 0.15)
		v11.RotationInfluence = Vector3.new(1, 1, 1)

		return v11
	end,
	Clash = function()
		local v12 = cameraShakeInstance.new(6, 22, 0.1, 0.5)

		v12.PositionInfluence = Vector3.new(0.3, 0.3, 0.3)
		v12.RotationInfluence = Vector3.new(1, 1, 1)

		return v12
	end,
	Explosion = function()
		local v13 = cameraShakeInstance.new(5, 10, 0, 1.5)

		v13.PositionInfluence = Vector3.new(0.25, 0.25, 0.25)
		v13.RotationInfluence = Vector3.new(4, 1, 1)

		return v13
	end,
	Explosion2 = function()
		local v14 = cameraShakeInstance.new(3.5, 8, 0, 1.5)

		v14.PositionInfluence = Vector3.new(0.25, 0.25, 0.25)
		v14.RotationInfluence = Vector3.new(1, 1, 1)

		return v14
	end,
	Earthquake = function()
		local v15 = cameraShakeInstance.new(0.6, 3.5, 2, 10)

		v15.PositionInfluence = Vector3.new(0.25, 0.25, 0.25)
		v15.RotationInfluence = Vector3.new(1, 1, 4)

		return v15
	end,
	BadTrip = function()
		local v16 = cameraShakeInstance.new(10, 0.15, 5, 10)

		v16.PositionInfluence = Vector3.new(0, 0, 0.15)
		v16.RotationInfluence = Vector3.new(2, 1, 4)

		return v16
	end,
	HandheldCamera = function()
		local v17 = cameraShakeInstance.new(1, 0.25, 5, 10)

		v17.PositionInfluence = Vector3.new(0, 0, 0)
		v17.RotationInfluence = Vector3.new(1, 0.5, 0.5)

		return v17
	end,
	Vibration = function()
		local v18 = cameraShakeInstance.new(0.4, 20, 2, 2)

		v18.PositionInfluence = Vector3.new(0, 0.15, 0)
		v18.RotationInfluence = Vector3.new(1.25, 0, 4)

		return v18
	end,
	RoughDriving = function()
		local v19 = cameraShakeInstance.new(1, 2, 1, 1)

		v19.PositionInfluence = Vector3.new(0, 0, 0)
		v19.RotationInfluence = Vector3.new(1, 1, 1)

		return v19
	end,
	Fast = function()
		local v20 = cameraShakeInstance.new(0.5, 20, 0, 0.25)

		v20.PositionInfluence = Vector3.new(0.6, 0.6, 0.6)
		v20.RotationInfluence = Vector3.new(0.5, 0.5, 0.5)

		return v20
	end,
	["Fast Hard"] = function()
		local v21 = cameraShakeInstance.new(1.5, 20, 0, 0.15)

		v21.PositionInfluence = Vector3.new(1, 1, 1)
		v21.RotationInfluence = Vector3.new(0.5, 0.5, 0.5)

		return v21
	end,
	["Pilar Hard"] = function()
		local v22 = cameraShakeInstance.new(2, 20, 0, 0.2)

		v22.PositionInfluence = Vector3.new(1, 1, 1)
		v22.RotationInfluence = Vector3.new(0.5, 0.5, 0.5)

		return v22
	end,
	["Fast Smooth"] = function()
		local v23 = cameraShakeInstance.new(0.3, 20, 0, 0.12)

		v23.PositionInfluence = Vector3.new(1, 1, 1)
		v23.RotationInfluence = Vector3.new(0.5, 0.5, 0.5)

		return v23
	end
}

return (setmetatable({}, {
	__index = function(_, p2)
		local v26 = t1[p2]

		if type(v26) == "function" then
			return v26()
		end

		error("No preset found with index \"" .. p2 .. "\"")
	end
}))
