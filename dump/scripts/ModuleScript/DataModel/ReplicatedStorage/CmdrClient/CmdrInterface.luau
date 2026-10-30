-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local LocalPlayer: Player = game:GetService("Players").LocalPlayer

return function(cmdr)
	local util = cmdr.Util
	local window = require(script:WaitForChild("Window"))

	window.Cmdr = cmdr

	local autoComplete = require(script:WaitForChild("AutoComplete"))(cmdr)

	window.AutoComplete = autoComplete

	function window.ProcessEntry(p2)
		local v7 = util.TrimString(p2)

		if #v7 == 0 then
			return
		end

		local v8 = window:GetLabel()

		window:AddLine(v8 .. " " .. v7, Color3.fromRGB(255, 223, 93))
		window:AddLine(cmdr.Dispatcher:EvaluateAndRun(v7, LocalPlayer, { IsHuman = true }))
	end
	function window.OnTextChanged(p3)
		local v10 = cmdr.Dispatcher:Evaluate(p3, LocalPlayer, true)
		local v11 = util.SplitString(p3)
		local v12 = table.remove(v11, 1)
		local u13: boolean = false

		if v10 then
			v11 = util.MashExcessArguments(v11, #v10.Object.Args)
			u13 = #v11 == #v10.Object.Args
		end

		local v14 = v12 and #v11 > 0

		if p3:sub(#p3, #p3):match("%s") and not u13 then
			v14 = true
			v11[#v11 + 1] = ""
		end

		if v10 and v14 then
			local v15, v16 = v10:Validate()

			window:SetIsValidInput(v15, ("Validation errors: %s"):format(v16 or ""))

			local t1: {[any]: any} = {}
			local v18 = v10:GetArgument(#v11)

			if v18 then
				local textSegmentInProgress = v18.TextSegmentInProgress
				local u20 = false

				if v18.RawSegmentsAreAutocomplete then
					for i, v in ipairs(v18.RawSegments) do
						t1[i] = { v, v }
					end
				else
					local v23, v24 = v18:GetAutocomplete()

					u20 = (v24 or {}).IsPartial or false

					for k, v in pairs(v23) do
						t1[k] = { textSegmentInProgress, v }
					end
				end

				local u27 = true

				if #textSegmentInProgress > 0 then
					local v28, v29 = v18:Validate()

					u27 = v28
					v16 = v29
				end

				if not u13 and u27 then
					window:HideInvalidState()
				end

				local u30 = u13

				if u30 then
					local v31 = p3:sub(#p3, #p3):match("%s")

					u30 = #p3 - #textSegmentInProgress + (if v31 then -1 else 0)
				end

				return autoComplete:Show(t1, {
					at = u30,
					prefix = #v18.RawSegments == 1 and v18.Prefix or "",
					isLast = #v10.Arguments == #v10.ArgumentDefinitions and #textSegmentInProgress > 0,
					numArgs = #v11,
					command = v10,
					arg = v18,
					name = v18.Name .. (if v18.Required then "" else "?"),
					type = v18.Type.DisplayName,
					description = u27 == false and v16 or v18.Object.Description,
					invalid = not u27,
					isPartial = u20
				})
			end
		elseif v12 and #v11 == 0 then
			window:SetIsValidInput(true)

			local v32 = cmdr.Registry:GetCommand(v12)
			local t2 = nil

			if v32 then
				t2 = {
					v32.Name,
					v32.Name,
					options = { name = v32.Name, description = v32.Description }
				}
				local v34 = v32.Args and v32.Args[1]

				if type(v34) == "function" then
					v34 = v34(v10)
				end

				if v34 and not v34.Optional and v34.Default == nil then
					window:SetIsValidInput(false, "This command has required arguments.")
					window:HideInvalidState()
				end
			else
				window:SetIsValidInput(false, ("%q is not a valid command name. Use the help command to see all available commands."):format(v12))
			end

			v32 = { t2 }

			for _, v in pairs(cmdr.Registry:GetCommandNames()) do
				local lowerText = v12:lower()
				local substring = v:lower():sub(1, #v12)

				if lowerText == substring and (t2 == nil or v12 ~= t2[1]) then
					local v39 = cmdr.Registry:GetCommand(v)

					v32[#v32 + 1] = {
						v12,
						v,
						options = { name = v39.Name, description = v39.Description }
					}
				end
			end

			return autoComplete:Show(v32)
		end

		window:SetIsValidInput(false, "Use the help command to see all available commands.")
		autoComplete:Hide()
	end

	window:UpdateLabel()
	window:UpdateWindowHeight()

	return { Window = window, AutoComplete = autoComplete }
end
