-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local starterGui: StarterGui = game:GetService("StarterGui")
local collectionService: CollectionService = game:GetService("CollectionService")
local t1: {[any]: any} = {}
local t2: {[any]: any} = {}

local function removeFromList(p1, p2)
	local v10 = table.find(p1, p2)

	if v10 then
		table.remove(p1, v10)
	end
end

local t3: {[any]: any} = {
	Resolution = { is = "Vector2", default = Vector2.new(1280, 720) },
	ScaleRange = { is = "NumberRange", default = NumberRange.new(0, math.huge) }
}

local function update(p3)
	if p3:IsA("UIScale") and not p3:IsDescendantOf(starterGui) then
		local t4: {[any]: any} = {}

		for k, v in pairs(t3) do
			local attributeValue = p3:GetAttribute(k)

			if typeof(attributeValue) ~= v.is then
				attributeValue = v.default

				local v16 = p3:GetFullName()
				local v17 = ("no '%*' attribute found for %*, using '%*' instead"):format(k, v16, v.default)

				warn(v17)
			end

			t4[k] = attributeValue
		end

		if not p3.Parent then
			return
		end

		local v18 = p3.Parent:FindFirstAncestorWhichIsA("GuiBase2d")
		local v19
		local CurrentCamera

		if v18 and (not v18:IsA("ScreenGui") or not v18.IgnoreGuiInset and v18.ScreenInsets ~= Enum.ScreenInsets.None) then
			v19 = v18.AbsoluteSize
			CurrentCamera = v18
		else
			v19 = workspace.CurrentCamera.ViewportSize
			CurrentCamera = workspace.CurrentCamera
		end

		local t5 = t1[CurrentCamera]

		if not t5 then
			local u22 = nil
			local t6: {[any]: any} = {
				source = CurrentCamera,
				scales = {}
			}
			local v24 = CurrentCamera:IsA("Camera")

			t6.signal = CurrentCamera:GetPropertyChangedSignal(if v24 then "ViewportSize" else "AbsoluteSize"):Connect(function()
				for iterValue in u22.scales, nil, nil do
					update(iterValue)
				end
			end)
			u22 = t6
			t5 = u22
			t1[CurrentCamera] = t5
		end

		local t7 = t5.scales[p3]

		if not t7 then
			local t8: {[any]: any} = {
				listener = t5,
				signals = {},
				text_constraints = {}
			}

			t5.scales[p3] = t8
			t2[p3] = t8

			if v18 then
				local function setupCleanup(p4)
					local connection = nil

					connection = p4.AncestryChanged:Connect(function()
						if p4:IsDescendantOf(v18) then
							return
						end

						local signals = t8.signals
						local v52 = table.find(signals, connection)

						if v52 then
							table.remove(signals, v52)
						end

						local text_constraints = t8.text_constraints

						v52 = table.find(text_constraints, p4)

						if v52 then
							table.remove(text_constraints, v52)
						end
					end)
					table.insert(t8.signals, connection)
				end

				for iterFirst, iterSecond in v18:GetDescendants() do
					if iterSecond:IsA("UITextSizeConstraint") then
						table.insert(t8.text_constraints, iterSecond)
						iterSecond:SetAttribute("__uitools_reference_range", NumberRange.new(iterSecond.MinTextSize, iterSecond.MaxTextSize))

						local connection = nil

						connection = iterSecond.AncestryChanged:Connect(function()
							if iterSecond:IsDescendantOf(v18) then
								return
							end

							local signals = t8.signals
							local v46 = table.find(signals, connection)

							if v46 then
								table.remove(signals, v46)
							end

							local text_constraints = t8.text_constraints

							v46 = table.find(text_constraints, iterSecond)

							if v46 then
								table.remove(text_constraints, v46)
							end
						end)
						table.insert(t8.signals, connection)
					end
				end

				table.insert(t8.signals, v18.DescendantAdded:Connect(function(p5)
					if not p5:IsA("UITextSizeConstraint") then
						return
					end

					table.insert(t8.text_constraints, p5)

					local __uitools_reference_range = p5:GetAttribute("__uitools_reference_range")

					if typeof(__uitools_reference_range) == "NumberRange" then
						p5.MinTextSize = __uitools_reference_range.Min * p3.Scale
						p5.MaxTextSize = __uitools_reference_range.Max * p3.Scale
					end

					local connection = nil

					connection = p5.AncestryChanged:Connect(function()
						if p5:IsDescendantOf(v18) then
							return
						end

						local signals = t8.signals
						local v55 = table.find(signals, connection)

						if v55 then
							table.remove(signals, v55)
						end

						local text_constraints = t8.text_constraints

						v55 = table.find(text_constraints, p5)

						if v55 then
							table.remove(text_constraints, v55)
						end
					end)
					table.insert(t8.signals, connection)
				end))
			end

			t7 = t8
		end

		t5 = v19.Y < v19.X and v19.Y or v19.X

		local n1 = 1 / t4.Resolution.Y
		local v32 = math.clamp(1 / t4.Resolution.X * v19.X / (1 / t4.Resolution.Y * t5), 0, 1)

		p3.Scale = math.clamp(n1 * v32 * t5, t4.ScaleRange.Min, t4.ScaleRange.Max)

		if not plugin then
			for iterFirst2, iterSecond2 in t7.text_constraints, nil, nil do
				local __uitools_reference_range = iterSecond2:GetAttribute("__uitools_reference_range")

				if typeof(__uitools_reference_range) == "NumberRange" then
					iterSecond2.MinTextSize = __uitools_reference_range.Min * p3.Scale
					iterSecond2.MaxTextSize = __uitools_reference_range.Max * p3.Scale
				end
			end
		end

		return
	end
end;

(function()
	for iterFirst, iterSecond in collectionService:GetTagged("UIScaleRuntimeObject") do
		if iterSecond:IsA("UIScale") then
			update(iterSecond)
		end
	end
end)()
collectionService:GetInstanceAddedSignal("UIScaleRuntimeObject"):Connect(update)
collectionService:GetInstanceRemovedSignal("UIScaleRuntimeObject"):Connect(function(p6)
	if not p6:IsA("UIScale") then
		return
	end

	local v39 = t2[p6]

	if not v39 then
		return
	end

	p6.Scale = 1
	t2[p6] = nil

	if v39.signals then
		for iterFirst, iterSecond in v39.signals, nil, nil do
			iterSecond:Disconnect()
		end
	end

	v39.listener.scales[p6] = nil

	if next(v39.listener.scales) == nil then
		v39.listener.signal:Disconnect()
		t1[v39.listener.source] = nil
	end
end)
