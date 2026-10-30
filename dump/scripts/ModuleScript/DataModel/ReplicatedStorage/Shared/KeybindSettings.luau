-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local extensions: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Extensions")
local gamepadBindings = require(extensions:WaitForChild("GamepadBindings"))
local module: {[any]: any} = {
	MAX_SLOTS = 2,
	Group = { Play = "Play", Spectate = "Spectate" },
	Order = {
		"Attack",
		"Aim",
		"Inspect",
		"EquipKnife",
		"EquipRevolver",
		"CastAbility1",
		"CastAbility2",
		"Crouch",
		"MoveForward",
		"MoveBackward",
		"MoveLeft",
		"MoveRight",
		"Jump",
		"Scoreboard",
		"ChangeAbilities",
		"Menu",
		"Ping",
		"Emote",
		"SpectatePrev",
		"SpectateNext"
	}
}

module.Defs = {
	Attack = {
		label = "Attack",
		category = "Combat",
		group = module.Group.Play,
		defaults = { "MouseButton1" },
		gamepad = gamepadBindings.Fire
	},
	Aim = {
		label = "Aim",
		category = "Combat",
		group = module.Group.Play,
		defaults = { "MouseButton2" },
		gamepad = gamepadBindings.ADS
	},
	Inspect = {
		label = "Inspect",
		category = "Combat",
		group = module.Group.Play,
		defaults = { "F" },
		gamepad = gamepadBindings.Inspect
	},
	EquipKnife = {
		label = "Equip Knife",
		category = "Combat",
		group = module.Group.Play,
		defaults = { "One" }
	},
	EquipRevolver = {
		label = "Equip Revolver",
		category = "Combat",
		group = module.Group.Play,
		defaults = { "Two" }
	},
	CastAbility1 = {
		label = "Ability 1",
		category = "Combat",
		group = module.Group.Play,
		defaults = { "Q" }
	},
	CastAbility2 = {
		label = "Ability 2",
		category = "Combat",
		group = module.Group.Play,
		defaults = { "E" }
	},
	Crouch = {
		label = "Crouch / Slide",
		category = "Movement",
		group = module.Group.Play,
		defaults = { "C", "LeftControl" },
		gamepad = gamepadBindings.Slide
	},
	MoveForward = {
		label = "Move Forward",
		category = "Movement",
		required = true,
		group = module.Group.Play,
		defaults = { "W", "Up" }
	},
	MoveBackward = {
		label = "Move Backward",
		category = "Movement",
		required = true,
		group = module.Group.Play,
		defaults = { "S", "Down" }
	},
	MoveLeft = {
		label = "Strafe Left",
		category = "Movement",
		required = true,
		group = module.Group.Play,
		defaults = { "A" }
	},
	MoveRight = {
		label = "Strafe Right",
		category = "Movement",
		required = true,
		group = module.Group.Play,
		defaults = { "D" }
	},
	Jump = {
		label = "Jump",
		category = "Movement",
		required = true,
		group = module.Group.Play,
		defaults = { "Space" }
	},
	Scoreboard = {
		label = "Scoreboard",
		category = "Interface",
		group = module.Group.Play,
		defaults = { "Tab" },
		gamepad = gamepadBindings.Scoreboard
	},
	ChangeAbilities = {
		label = "Change Abilities",
		category = "Interface",
		group = module.Group.Play,
		defaults = { "G" }
	},
	Menu = {
		label = "Menu / Back",
		category = "Interface",
		group = module.Group.Play,
		defaults = { "M" },
		gamepad = gamepadBindings.Menu
	},
	Ping = {
		label = "Ping",
		category = "Interface",
		group = module.Group.Play,
		defaults = { "MouseButton3" }
	},
	Emote = {
		label = "Emote Wheel",
		category = "Interface",
		group = module.Group.Play,
		defaults = { "B" },
		gamepad = gamepadBindings.EmoteWheel
	},
	SpectatePrev = {
		label = "Spectate Previous",
		category = "Spectate",
		group = module.Group.Spectate,
		defaults = { "Q" }
	},
	SpectateNext = {
		label = "Spectate Next",
		category = "Spectate",
		group = module.Group.Spectate,
		defaults = { "E" }
	}
}

local t2: {[any]: any} = { Unknown = true, Escape = true }
local t3: {[any]: any} = { "World", "Button", "DPad", "Thumbstick" }
local allowed: {[any]: any} = {}

for _, v in ipairs(Enum.KeyCode:GetEnumItems()) do
	local vName = v.Name

	if not t2[vName] then
		local u10: boolean = true

		for _, iterValue in ipairs(t3) do
			local v13 = string.sub(vName, 1, #iterValue)

			if iterValue == v13 then
				u10 = false

				break
			end
		end

		if u10 then
			allowed[vName] = v
		end
	end
end

allowed.MouseButton1 = Enum.UserInputType.MouseButton1
allowed.MouseButton2 = Enum.UserInputType.MouseButton2
allowed.MouseButton3 = Enum.UserInputType.MouseButton3
module.ALLOWED = allowed

local t5: {[any]: any} = {
	"W",
	"A",
	"S",
	"D",
	"Space",
	"Up",
	"Left",
	"Down",
	"Right",
	"I",
	"J",
	"K",
	"L",
	"T",
	"Y",
	"H",
	"N",
	"B",
	"V",
	"X",
	"Z"
}

for _, v in ipairs(Enum.KeyCode:GetEnumItems()) do
	if allowed[v.Name] ~= nil then
		table.insert(t5, v.Name)
	end
end

module.MOUSE_TEMPLATE = { MouseButton1 = "LMB", MouseButton2 = "RMB" }
module.SHORT_NAMES = {
	LeftControl = "LCTRL",
	RightControl = "RCTRL",
	LeftShift = "LSHIFT",
	RightShift = "RSHIFT",
	LeftAlt = "LALT",
	RightAlt = "RALT",
	LeftSuper = "LSUPER",
	RightSuper = "RSUPER",
	Space = "SPACE",
	Tab = "TAB",
	Return = "ENTER",
	Backspace = "BKSP",
	CapsLock = "CAPS",
	Insert = "INS",
	Delete = "DEL",
	PageUp = "PGUP",
	PageDown = "PGDN",
	Up = "UP",
	Down = "DOWN",
	Left = "LEFT",
	Right = "RIGHT",
	MouseButton1 = "LMB",
	MouseButton2 = "RMB",
	MouseButton3 = "MMB",
	One = "1",
	Two = "2",
	Three = "3",
	Four = "4",
	Five = "5",
	Six = "6",
	Seven = "7",
	Eight = "8",
	Nine = "9",
	Zero = "0"
}

function module.isValid(p1)
	local u18: boolean = false

	if typeof(p1) == "string" then
		u18 = allowed[p1] ~= nil
	end

	return u18
end
function module.resolve(p2)
	if typeof(p2) == "string" then
		return allowed[p2]
	end

	return nil
end
function module.isRebindable(p3)
	local v21 = module.Defs[p3]

	return v21 ~= nil and not v21.disabled
end
function module.isRequired(p4)
	local v23 = module.Defs[p4]

	return v23 ~= nil and v23.required == true
end
function module.defaultsFor(p5)
	local v25 = module.Defs[p5]

	if not v25 then
		return {}
	end

	return table.clone(v25.defaults)
end
function module.newState()
	local t6: {[any]: any} = {}

	for _, v in ipairs(module.Order) do
		if module.isRebindable(v) then
			t6[v] = table.clone(module.Defs[v].defaults)
		end
	end

	return t6
end
function module.sanitize(p6)
	local v30 = module.newState()

	if typeof(p6) == "table" then
		for _, v in ipairs(module.Order) do
			if module.isRebindable(v) then
				local v33 = p6[v]

				if typeof(v33) == "table" then
					local t7: {[any]: any} = {}
					local t8: {[any]: any} = {}

					for _, iterValue in ipairs(v33) do
						if #t7 >= module.MAX_SLOTS then
							break
						end

						if module.isValid(iterValue) and not t8[iterValue] then
							t8[iterValue] = true
							table.insert(t7, iterValue)
						end
					end

					v30[v] = t7
				end
			end
		end

		local t9: {[any]: any} = {}

		for _, v in ipairs(module.Order) do
			local v41 = v30[v]

			if v41 then
				local group = module.Defs[v].group
				local t10 = t9[group]

				if not t10 then
					t10 = {}
					t9[group] = t10
				end

				local t11: {[any]: any} = {}

				for _, iterValue2 in ipairs(v41) do
					if not t10[iterValue2] then
						t10[iterValue2] = true
						table.insert(t11, iterValue2)
					end
				end

				v30[v] = t11
			end
		end

		for _, v in ipairs(module.Order) do
			local v49 = module.Defs[v]

			if v49 and v49.required and module.isRebindable(v) and #(v30[v] or {}) == 0 then
				local t12 = t9[v49.group]

				if not t12 then
					t12 = {}
					t9[v49.group] = t12
				end

				local v51 = nil

				for _, iterValue3 in ipairs(v49.defaults) do
					if not t12[iterValue3] then
						v51 = iterValue3

						break
					end
				end

				if not v51 then
					for _, iterValue4 in ipairs(v49.defaults) do
						local v56 = module.findConflict(v30, v, iterValue4)

						if v56 then
							local v57 = v30[v56]

							if not module.isRequired(v56) or not (#v57 <= 1) then
								for i = #v57, 1, -1 do
									if iterValue4 == v57[i] then
										table.remove(v57, i)
									end
								end

								v51 = iterValue4

								break
							end
						end
					end
				end

				if not v51 then
					for _, iterValue5 in ipairs(t5) do
						if not t12[iterValue5] then
							v51 = iterValue5

							break
						end
					end
				end

				if v51 then
					t12[v51] = true
					v30[v] = { v51 }
				end
			end
		end

		return v30
	end

	return v30
end
function module.findConflict(p7, p8, p9)
	local v64 = module.Defs[p8]

	if not v64 then
		return nil
	end

	for _, v in ipairs(module.Order) do
		if v ~= p8 and module.isRebindable(v) and module.Defs[v].group == v64.group then
			for _, iterValue in ipairs(p7[v] or {}) do
				if iterValue == p9 then
					return v
				end
			end
		end
	end

	return nil
end

return module
