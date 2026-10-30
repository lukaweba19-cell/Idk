-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local utility = require(script.Parent.Parent.Utility)
local default = require(script.Default)

local module: {[any]: any} = {
	getThemeValue = function(p1, p2, p3, _)
		if p1 then
			for _, v in pairs(p1) do
				local v10, v11, v12 = unpack(v)

				if p2 == v10 and p3 == v11 then
					return v12
				end
			end

			return nil
		end

		return nil
	end,
	getInstanceValue = function(p5, p6)
		local ok, result = pcall(function()
			return p5[p6]
		end)

		if not ok then
			result = p5:GetAttribute(p6)
		end

		return result
	end,
	getRealInstance = function(p7)
		if not p7:GetAttribute("IsAClippedClone") then
			return
		end

		local originalInstance = p7:FindFirstChild("OriginalInstance")

		if not originalInstance then
			return
		end

		return originalInstance.Value
	end,
	getClippedClone = function(p8)
		if not p8:GetAttribute("HasAClippedClone") then
			return
		end

		local clippedClone = p8:FindFirstChild("ClippedClone")

		if not clippedClone then
			return
		end

		return clippedClone.Value
	end
}

function module.refresh(p9, p10, p11)
	if p11 then
		local v24 = p9:getStateGroup()
		local v25 = module.getThemeValue(v24, p10.Name, p11) or module.getInstanceValue(p10, p11)

		module.apply(p9, p10, p11, v25, true)

		return
	end

	local v26 = p9:getStateGroup()

	if not v26 then
		return
	end

	local t2: {[any]: any} = { [p10.Name] = p10 }

	for _, v in pairs(p10:GetDescendants()) do
		local collective = v:GetAttribute("Collective")

		if collective then
			t2[collective] = v
		end

		t2[v.Name] = v
	end

	for _, v in pairs(v26) do
		local v33, v34, v35 = unpack(v)
		local v36 = t2[v33]

		if v36 then
			module.apply(p9, v36.Name, v34, v35, true)
		end
	end
end
function module.apply(p12, p13, p14, p15, p16)
	if p12.isDestroyed then
		return
	end

	local v42 = p13
	local t3

	if typeof(p13) == "Instance" then
		t3 = { p13 }
		v42 = p13.Name
	else
		t3 = p12:getInstanceOrCollective(p13)
	end

	local v45 = p12.customBehaviours[v42 .. "-" .. p14]

	for _, v in pairs(t3) do
		local v48 = module.getClippedClone(v)

		if v48 then
			table.insert(t3, v48)
		end
	end

	for _, v in pairs(t3) do
		if (p14 ~= "Position" or not module.getClippedClone(v)) and (p14 ~= "Size" or not module.getRealInstance(v)) and (p16 or p15 ~= module.getInstanceValue(v, p14)) then
			if v45 then
				local v51 = v45(p15, v, p14)

				if v51 ~= nil then
					p15 = v51
				end
			end

			if not pcall(function()
				v[p14] = p15
			end) then
				v:SetAttribute(p14, p15)
			end
		end
	end
end
function module.getModifications(p17: {[any]: any})
	if typeof(p17[1]) ~= "table" then
		p17 = { p17 }
	end

	return p17
end
function module.merge(p18, p19, p20)
	local v56, v57, v58, v59 = table.unpack(p19)
	local v60, v61, v62, v63 = table.unpack(p18)

	if v56 == v60 and v57 == v61 and module.statesMatch(v59, v63) then
		p18[3] = v58

		if p20 then
			p20(p18)
		end

		return true
	end

	return false
end
function module.modify(p21, p22, p23)
	task.spawn(function()
		p23 = p23 or utility.generateUID()
		p22 = module.getModifications(p22)

		for _, v in pairs(p22) do
			local v100, v101, v102, v103 = table.unpack(v)

			if v103 == nil then
				module.modify(p21, { v100, v101, v102, "Selected" }, p23)
				module.modify(p21, { v100, v101, v102, "Viewing" }, p23)
			end

			local v104 = utility.formatStateName(v103 or "Deselected")
			local v105 = p21:getStateGroup(v104)

			local function nowSetIt()
				if v104 == p21.activeState then
					module.apply(p21, v100, v101, v102)
				end
			end;

			(function()
				for _, iterValue in pairs(v105) do
					if module.merge(iterValue, v, function(p24)
						p24[5] = p23

						if v104 == p21.activeState then
							module.apply(p21, v100, v101, v102)
						end
					end) then
						return
					end
				end

				table.insert(v105, { v100, v101, v102, v104, p23 })

				if v104 == p21.activeState then
					module.apply(p21, v100, v101, v102)
				end
			end)()
		end
	end)

	return p23
end
function module.remove(p25, p26)
	for _, v in pairs(p25.appearance) do
		for i = #v, 1, -1 do
			if p26 == v[i][5] then
				table.remove(v, i)
			end
		end
	end

	module.rebuild(p25)
end
function module.removeWith(p27, p28, p29, p30)
	for k, v in pairs(p27.appearance) do
		if p30 == k or not p30 then
			for i = #v, 1, -1 do
				local v79 = v[i]

				if p28 == v79[1] and v79[2] == p29 then
					table.remove(v, i)
				end
			end
		end
	end

	module.rebuild(p27)
end
function module.change(p31)
	local v81 = p31:getStateGroup()

	for _, v in pairs(v81) do
		local v84, v85, v86 = unpack(v)

		module.apply(p31, v84, v85, v86)
	end
end
function module.set(p32, p33)
	local themesJanitor = p32.themesJanitor

	themesJanitor:clean()
	themesJanitor:add(p32.stateChanged:Connect(function()
		module.change(p32)
	end))

	if typeof(p33) == "Instance" and p33:IsA("ModuleScript") then
		p33 = require(p33)
	end

	p32.appliedTheme = p33
	module.rebuild(p32)
end
function module.statesMatch(p34, p35)
	local v92 = p34 and string.lower(p34)
	local v93 = p35 and string.lower(p35)
	local u94: boolean = true

	if v92 ~= v93 then
		u94 = not p34 or not p35
	end

	return u94
end
function module.rebuild(p36)
	local appliedTheme = p36.appliedTheme
	local t4: {[any]: any} = { "Deselected", "Selected", "Viewing" };

	(function()
		for _, v in pairs(t4) do
			local t5: {[any]: any} = {}

			local function updateDetails(p37, p38)
				if not p37 then
					return
				end

				for _, iterValue in pairs(p37) do
					local v124 = iterValue[5]

					if module.statesMatch(p38, iterValue[4]) then
						local s1: string = iterValue[1] .. "-" .. iterValue[2]
						local v126 = utility.copyTable(iterValue)

						v126[5] = v124
						t5[s1] = v126
					end
				end
			end

			if v == "Selected" then
				updateDetails(default, "Deselected")
			end

			updateDetails(default, "Empty")
			updateDetails(default, v)

			if appliedTheme ~= default then
				if v == "Selected" then
					updateDetails(appliedTheme, "Deselected")
				end

				updateDetails(default, "Empty")
				updateDetails(appliedTheme, v)
			end

			local t6: {[any]: any} = {}
			local v112 = p36.appearance[v]

			if v112 then
				for _, iterValue in pairs(v112) do
					local v115 = iterValue[5]

					if v115 ~= nil then
						table.insert(t6, { iterValue[1], iterValue[2], iterValue[3], v, v115 })
					end
				end
			end

			updateDetails(t6, v)
			v112 = {}

			for _, iterValue2 in pairs(t5) do
				table.insert(v112, iterValue2)
			end

			p36.appearance[v] = v112
		end

		module.change(p36)
	end)()
end

return module
