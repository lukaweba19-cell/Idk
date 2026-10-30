-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local teleportService: TeleportService = game:GetService("TeleportService")
local players: Players = game:GetService("Players")
local util = require(script.Parent.Util)
local command = require(script.Parent.Command)
local u6: boolean = false

local t1: {[any]: any} = {
	Cmdr = nil,
	Registry = nil,
	Evaluate = function(p1, p2, p3, p4, p5)
		if runService:IsClient() == true and p3 ~= players.LocalPlayer then
			error("Can't evaluate a command that isn't sent by the local player.")
		end

		local v13 = util.SplitString(p2)
		local v14 = table.remove(v13, 1)
		local v15 = p1.Registry:GetCommand(v14)

		if v15 then
			local v16 = util.MashExcessArguments(v13, #v15.Args)

			v16 = command.new({
				Dispatcher = p1,
				Text = p2,
				CommandObject = v15,
				Alias = v14,
				Executor = p3,
				Arguments = v16,
				Data = p5
			})

			local v17, v18 = v16:Parse(p4)

			if v17 then
				return v16
			end

			return false, v18
		end

		return false, ("%q is not a valid command name. Use the help command to see all available commands."):format((tostring(v14)))
	end,
	EvaluateAndRun = function(p6, p7, p8, p9)
		local t2 = p9 or {}

		if runService:IsClient() and t2.IsHuman then
			p6:PushHistory(p7)
		end

		local v24, v25 = p6:Evaluate(p7, p8 or players.LocalPlayer, nil, t2.Data)

		if not v24 then
			return v25
		end

		local v26, v27 = xpcall(function()
			local v56, v57 = v24:Validate(true)

			if not v56 then
				return v57
			end

			return v24:Run() or "Command executed."
		end, function(p10)
			local debugTraceback = debug.traceback
			local text: string = tostring(p10)

			return debugTraceback(text)
		end)

		if not v26 then
			local text: string = tostring(v27)

			warn(("Error occurred while evaluating command string %q\n%s"):format(p7, text))
		end

		return v26 and v27 or "An error occurred while running this command. Check the console for more information."
	end,
	Send = function(p11, p12, p13)
		if runService:IsClient() == false then
			error("Dispatcher:Send can only be called from the client.")
		end

		return p11.Cmdr.RemoteFunction:InvokeServer(p12, { Data = p13 })
	end,
	Run = function(p14, ...)
		if not players.LocalPlayer then
			error("Dispatcher:Run can only be called from the client.")
		end

		local t3: {[any]: any} = { ... }
		local v34 = t3[1]

		for i = 2, #t3 do
			local text: string = tostring(t3[i])

			v34 = v34 .. " " .. text
		end

		local v37, v38 = p14:Evaluate(v34, players.LocalPlayer)

		if not v37 then
			error(v38)
		end

		local v39, v40 = v37:Validate(true)

		if not v39 then
			error(v40)
		end

		return v37:Run()
	end,
	RunHooks = function(p15, p16, p17, ...)
		if not p15.Registry.Hooks[p16] then
			local v44 = ("Invalid hook name: %q"):format(p16)

			error(v44, 2)
		end

		if p16 == "BeforeRun" and #p15.Registry.Hooks[p16] == 0 and p17.Group ~= "DefaultUtil" and p17.Group ~= "UserAlias" and p17:HasImplementation() then
			if not runService:IsStudio() then
				return "Command blocked for security as no BeforeRun hook is configured."
			end

			if u6 == false then
				local v45: boolean = runService:IsServer()

				p17:Reply((if v45 then "<Server>" else "<Client>") .. " Commands will not run in-game if no BeforeRun hook is configured. Learn more: https://eryn.io/Cmdr/guide/Hooks.html", Color3.fromRGB(255, 228, 26))
				u6 = true
			end
		end

		for _, v in ipairs(p15.Registry.Hooks[p16]) do
			local v48 = v.callback(p17, ...)

			if v48 ~= nil then
				return (tostring(v48))
			end
		end
	end,
	PushHistory = function(p18, p19)
		local v51: boolean = runService:IsClient()

		assert(v51, "PushHistory may only be used from the client.")

		local v52 = p18:GetHistory()

		if util.TrimString(p19) == "" or p19 == v52[#v52] then
			return
		end

		v52[#v52 + 1] = p19
		teleportService:SetTeleportSetting("CmdrCommandHistory", v52)
	end,
	GetHistory = function(_)
		local v54: boolean = runService:IsClient()

		assert(v54, "GetHistory may only be used from the client.")

		return teleportService:GetTeleportSetting("CmdrCommandHistory") or {}
	end
}

return function(cmdr)
	t1.Cmdr = cmdr
	t1.Registry = cmdr.Registry

	return t1
end
