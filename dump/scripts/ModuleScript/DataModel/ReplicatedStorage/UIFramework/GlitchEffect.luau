-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local color3 = Color3.fromRGB(255, 0, 60)
local color32 = Color3.fromRGB(0, 255, 180)
local color33 = Color3.fromRGB(100, 0, 255)
local color34 = Color3.fromRGB(255, 255, 255)

local function randRange(list)
	local v11 = list[1]
	local n1 = list[2] - list[1]
	local randomNumber = math.random()

	return v11 + n1 * randomNumber
end
local function randInt(list)
	return math.random(list[1], list[2])
end
local function pick(p3)
	local randomNumber = math.random(1, #p3)

	return p3[randomNumber]
end

local t1: {[any]: any} = {
	Looped = true,
	Duration = 2,
	ChromaEnabled = true,
	ChromaOpacity = 0.15,
	ScanlinesEnabled = true,
	FlickerEnabled = true,
	JitterEnabled = true,
	BlocksEnabled = true,
	GlitchInterval = { 0.05, 0.15 },
	GlitchDuration = { 0.08, 0.15 },
	CooldownBetweenBursts = { 0.1, 0.75 },
	SliceCount = { 6, 12 },
	SliceHeight = { 0.65, 1.35 },
	SliceOffset = { -15, 15 },
	ChromaOffset = { -4, 4 },
	ScanlineCount = { 1, 3 },
	ScanlineOpacity = { 0.3, 0.7 },
	FlickerOpacity = { 0, 0.3 },
	JitterAmount = { -3, 3 },
	BlockCount = { 1, 4 },
	BlockSize = { 0.58, 0.43 },
	BlockImages = {
		"rbxassetid://13366636031",
		"rbxassetid://13366636031",
		"rbxassetid://13366636031"
	},
	BlockOpacity = { 0.3, 0.7 },
	BlockColors = { color3, color32, color33, color34, Color3.fromRGB(0, 200, 255) }
}

return {
	apply = function(p4, parent, p6)
		local t2: {[any]: any} = {}

		for k, v in pairs(t1) do
			t2[k] = v
		end

		if p6 then
			for k, v in pairs(p6) do
				t2[k] = v
			end
		end

		local v25 = p4:IsA("ImageLabel") or p4:IsA("ImageButton")
		local image = v25 and p4.Image or ""
		local imageColor3 = v25 and p4.ImageColor3 or Color3.new(1, 1, 1)
		local imageTransparency = v25 and p4.ImageTransparency or 0
		local scaleType = v25 and p4.ScaleType or Enum.ScaleType.Stretch
		local v30 = p4.Position

		parent.ClipsDescendants = true

		local glitchEffectContainer: Frame = Instance.new("Frame")

		glitchEffectContainer.Name = "GlitchEffectContainer"
		glitchEffectContainer.Size = UDim2.new(1, 0, 1, 0)
		glitchEffectContainer.Position = UDim2.new(0, 0, 0, 0)
		glitchEffectContainer.BackgroundTransparency = 1
		glitchEffectContainer.ClipsDescendants = true
		glitchEffectContainer.ZIndex = p4.ZIndex + 1
		glitchEffectContainer.Parent = parent

		local t3: {[any]: any} = {}

		if v25 then
			for i = 1, 8 do
				local imageLabel: ImageLabel = Instance.new("ImageLabel")

				imageLabel.Name = "GlitchSlice_" .. i
				imageLabel.BackgroundTransparency = 1
				imageLabel.Image = image
				imageLabel.ImageColor3 = imageColor3
				imageLabel.ImageTransparency = imageTransparency
				imageLabel.ScaleType = scaleType
				imageLabel.Visible = false
				imageLabel.ZIndex = p4.ZIndex + 2
				imageLabel.Parent = glitchEffectContainer
				table.insert(t3, imageLabel)
			end
		end

		local imageLabel = nil
		local clone = nil

		if t2.ChromaEnabled and v25 then
			imageLabel = Instance.new("ImageLabel")
			imageLabel.Name = "ChromaR"
			imageLabel.BackgroundTransparency = 1
			imageLabel.Image = image
			imageLabel.ImageColor3 = Color3.fromRGB(255, 0, 0)
			imageLabel.ImageTransparency = 1 - t2.ChromaOpacity
			imageLabel.ScaleType = scaleType
			imageLabel.Size = p4.Size
			imageLabel.Position = p4.Position
			imageLabel.AnchorPoint = p4.AnchorPoint
			imageLabel.Visible = false
			imageLabel.ZIndex = p4.ZIndex + 3
			imageLabel.Parent = parent
			clone = imageLabel:Clone()
			clone.Name = "ChromaB"
			clone.ImageColor3 = Color3.fromRGB(0, 100, 255)
			clone.Parent = parent
		end

		local t4: {[any]: any} = {}

		if t2.ScanlinesEnabled then
			for i = 1, 5 do
				local frame: Frame = Instance.new("Frame")

				frame.Name = "Scanline_" .. i
				frame.BackgroundColor3 = Color3.new(0, 0, 0)
				frame.BorderSizePixel = 0
				frame.Visible = false
				frame.ZIndex = p4.ZIndex + 4
				frame.Parent = glitchEffectContainer
				table.insert(t4, frame)
			end
		end

		local t5: {[any]: any} = {}

		if t2.BlocksEnabled then
			for i = 1, 6 do
				local imageLabel: ImageLabel = Instance.new("ImageLabel")

				imageLabel.Name = "GlitchBlock_" .. i
				imageLabel.BackgroundTransparency = 1
				imageLabel.Visible = false
				imageLabel.ZIndex = p4.ZIndex + 5
				imageLabel.ScaleType = Enum.ScaleType.Stretch
				imageLabel.Parent = glitchEffectContainer
				table.insert(t5, imageLabel)
			end
		end

		local u43: boolean = false
		local timestamp = tick()
		local cooldownBetweenBursts = t2.CooldownBetweenBursts
		local v46 = cooldownBetweenBursts[1]
		local n1 = cooldownBetweenBursts[2] - cooldownBetweenBursts[1]
		local randomNumber = math.random()
		local n2 = timestamp + (v46 + n1 * randomNumber)
		local n3 = 0
		local timestamp2 = tick()
		local u52: boolean = false

		local function hideAll()
			for _, v in ipairs(t3) do
				v.Visible = false
			end

			for _, v in ipairs(t5) do
				v.Visible = false
			end

			for _, v in ipairs(t4) do
				v.Visible = false
			end

			if imageLabel then
				imageLabel.Visible = false
			end

			if clone then
				clone.Visible = false
			end

			if v25 then
				p4.Position = v30
				p4.ImageTransparency = imageTransparency
			end
		end
		local function doGlitchFrame()
			local glitchEffectContainerAbsoluteSize: Vector2 = glitchEffectContainer.AbsoluteSize

			if v25 then
				local sliceCount = t2.SliceCount
				local randomNumber2 = math.random(sliceCount[1], sliceCount[2])

				for i, v in ipairs(t3) do
					if randomNumber2 >= i then
						local randomNumber3 = math.random()
						local sliceHeight = t2.SliceHeight
						local v70 = sliceHeight[1]
						local n1 = sliceHeight[2] - sliceHeight[1]
						local randomNumber4 = math.random()
						local sliceOffset = t2.SliceOffset
						local v74 = sliceOffset[1]
						local n2 = sliceOffset[2] - sliceOffset[1]
						local randomNumber5 = math.random()

						v.Image = image
						v.ImageColor3 = imageColor3
						v.ImageTransparency = imageTransparency
						v.Size = UDim2.new(1, 0, v70 + n1 * randomNumber4, 0)
						v.Position = UDim2.new(0, v74 + n2 * randomNumber5, randomNumber3, 0)
						v.Visible = true
					else
						v.Visible = false
					end
				end
			end

			if t2.ChromaEnabled and imageLabel and clone then
				local visible: boolean = math.random() > 0.3

				imageLabel.Visible = visible
				clone.Visible = visible

				if visible then
					local chromaOffset = t2.ChromaOffset
					local v79 = chromaOffset[1]
					local n3 = chromaOffset[2] - chromaOffset[1]
					local randomNumber6 = math.random()
					local v82 = t2.ChromaOffset
					local v83 = v82[1]
					local n4 = v82[2] - v82[1]
					local randomNumber7 = math.random()

					imageLabel.Position = UDim2.new(v30.X.Scale, v30.X.Offset + (v79 + n3 * randomNumber6), v30.Y.Scale, v30.Y.Offset)
					clone.Position = UDim2.new(v30.X.Scale, v30.X.Offset + (v83 + n4 * randomNumber7), v30.Y.Scale, v30.Y.Offset)
				end
			end

			if t2.ScanlinesEnabled then
				local scanlineCount = t2.ScanlineCount
				local randomNumber8 = math.random(scanlineCount[1], scanlineCount[2])

				for i, v in ipairs(t4) do
					if randomNumber8 >= i then
						v.Size = UDim2.new(1, 0, 0, math.random(1, 3))

						local uDim2New = UDim2.new
						local randomNumber9 = math.random()

						v.Position = uDim2New(0, 0, randomNumber9, 0)

						local scanlineOpacity = t2.ScanlineOpacity
						local v93 = scanlineOpacity[1]
						local n5 = scanlineOpacity[2] - scanlineOpacity[1]
						local randomNumber10 = math.random()

						v.BackgroundTransparency = 1 - (v93 + n5 * randomNumber10)
						v.Visible = true
					else
						v.Visible = false
					end
				end
			end

			if t2.FlickerEnabled and v25 then
				if math.random() > 0.5 then
					local flickerOpacity = t2.FlickerOpacity
					local v97 = flickerOpacity[1]
					local n6 = flickerOpacity[2] - flickerOpacity[1]
					local randomNumber11 = math.random()

					p4.ImageTransparency = imageTransparency + (v97 + n6 * randomNumber11)
				else
					p4.ImageTransparency = imageTransparency
				end
			end

			if t2.JitterEnabled then
				local jitterAmount = t2.JitterAmount
				local v101 = jitterAmount[1]
				local n7 = jitterAmount[2] - jitterAmount[1]
				local randomNumber12 = math.random()
				local v104 = t2.JitterAmount
				local v105 = v104[1]
				local n8 = v104[2] - v104[1]
				local randomNumber13 = math.random()

				p4.Position = UDim2.new(v30.X.Scale, v30.X.Offset + (v101 + n7 * randomNumber12), v30.Y.Scale, v30.Y.Offset + (v105 + n8 * randomNumber13))
			end

			if t2.BlocksEnabled then
				local blockCount = t2.BlockCount
				local randomNumber14 = math.random(blockCount[1], blockCount[2])

				for i, v in ipairs(t5) do
					if randomNumber14 >= i then
						local v112 = UDim2.new
						local blockSize = t2.BlockSize
						local v114 = blockSize[1]
						local n9 = blockSize[2] - blockSize[1]
						local randomNumber15 = math.random()
						local v117 = t2.BlockSize
						local v118 = v117[1]
						local n10 = v117[2] - v117[1]
						local randomNumber16 = math.random()

						v.Size = v112(v114 + n9 * randomNumber15, 0, v118 + n10 * randomNumber16, 0)

						local v121 = UDim2.new
						local randomNumber17 = math.random()
						local randomNumber18 = math.random()

						v.Position = v121(randomNumber17, 0, randomNumber18, 0)

						local blockOpacity = t2.BlockOpacity

						v114 = blockOpacity[1]
						v118 = blockOpacity[2] - blockOpacity[1]

						local randomNumber19 = math.random()

						v.ImageTransparency = 1 - (v114 + v118 * randomNumber19)

						if #t2.BlockImages > 0 then
							local blockImages = t2.BlockImages
							local randomNumber20 = math.random(1, #blockImages)

							v.Image = blockImages[randomNumber20]
						elseif v25 then
							v.Image = image
						end

						local blockColors = t2.BlockColors
						local randomNumber21 = math.random(1, #blockColors)

						v.ImageColor3 = blockColors[randomNumber21]
						v.Visible = true
					else
						v.Visible = false
					end
				end
			end
		end

		local t6: {[any]: any} = {}

		local connection = runService.Heartbeat:Connect(function(deltaTime: number)
			if u52 then
				return
			end

			if not parent.Parent then
				t6:Stop()

				return
			end

			if not t2.Looped and tick() - timestamp2 >= t2.Duration then
				t6:Stop()

				return
			end

			local timestamp3 = tick()

			if u43 then
				if timestamp3 >= n3 then
					if math.random() > 0.6 then
						local glitchDuration = t2.GlitchDuration
						local v133 = glitchDuration[1]
						local n1 = glitchDuration[2] - glitchDuration[1]
						local randomNumber22 = math.random()

						n3 = timestamp3 + (v133 + n1 * randomNumber22)

						return
					end

					u43 = false

					local cooldownBetweenBursts = t2.CooldownBetweenBursts
					local v137 = cooldownBetweenBursts[1]
					local n4 = cooldownBetweenBursts[2] - cooldownBetweenBursts[1]
					local randomNumber23 = math.random()

					n2 = timestamp3 + (v137 + n4 * randomNumber23)
					hideAll()

					return
				end

				doGlitchFrame()
			elseif timestamp3 >= n2 then
				u43 = true

				local v140 = t2.GlitchDuration
				local v141 = v140[1]
				local n5 = v140[2] - v140[1]
				local randomNumber24 = math.random()

				n3 = timestamp3 + (v141 + n5 * randomNumber24)

				return
			end
		end)

		function t6.Stop(_)
			if u52 then
				return
			end

			u52 = true
			connection:Disconnect()
			hideAll()
			glitchEffectContainer:Destroy()

			if imageLabel then
				imageLabel:Destroy()
			end

			if clone then
				clone:Destroy()
			end
		end

		return t6
	end
}
