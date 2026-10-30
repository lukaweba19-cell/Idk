-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local t1: {[any]: any} = {}

game:GetService("ReplicatedStorage")

local runService: RunService = game:GetService("RunService")
local textService: TextService = game:GetService("TextService")
local montserratBold = Enum.Font.MontserratBold
local util = game.ReplicatedStorage:WaitForChild("Util")
local tween = require(util:WaitForChild("Tween"))
local CurrentCamera: Camera = workspace.CurrentCamera
local scriptElemental = script.Elemental
local t2: {[any]: any} = {}
local damageScreen: ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))

damageScreen.DisplayOrder = -100
damageScreen.ResetOnSpawn = false
damageScreen.Name = "DamageScreen"
runService:BindToRenderStep("DamageUI", Enum.RenderPriority.Camera.Value + 1000, function(p1)
	for k, v in pairs(t2) do
		v.time = v.time + p1

		local vObj = v.obj
		local n1 = v.anchor.Position + v.offset
		local vScale = v.scale
		local vTween = v.tween

		if vObj.mode == 2 or vObj.mode == 3 then
			local vector3 = Vector3.new(0, vScale * v.time * 1.33, 0)

			n1 += vector3
		end

		local v22 = math.clamp(1 - (CurrentCamera.CFrame.p - n1).magnitude / 2000 * 0.9, 0.75, 1)
		local n2 = Vector2.new(24, 30) * vScale * v22

		if v.time > v.lifetime then
			t2[k] = nil
			vObj:Destroy()
		else
			if not vObj.container.Parent then
				vObj.container.Parent = damageScreen
			end

			local v24, v25 = CurrentCamera:WorldToScreenPoint(n1)

			vObj.container.Visible = v25
			vObj.container.Position = UDim2.new(0, v24.x - n2.x * (if #vObj.numbers == 1 then 0 else #vObj.numbers / 3), 0, v24.y)

			if v.time > v.lifetime * 0.8 then
				local textTransparency = vTween(v.time - v.lifetime * 0.8, 0, 1, v.lifetime - v.lifetime * 0.8)
				local n3 = 0

				for i = 1, #vObj.numbers do
					local v29 = vObj.numbers[i]
					local v30 = v29[1]

					v29[2] = v29[2] + v29[3] * p1 * 315 * vScale

					local n4 = v29[2] * vScale * v22
					local v32 = i == (#vObj.numbers + 1) / 2 and n4.unit.x

					if not v32 then
						if i <= #vObj.numbers / 2 then
							v32 = -1
						else
							v32 = false

							if i > #vObj.numbers / 2 then
								v32 = 1
							end
						end
					end

					if vObj.mode == 2 then
						n4 = Vector2.new(0, 0)
						v32 = 0
					end

					local x = textService:GetTextSize(v29[4], n2.X, montserratBold, n2).X

					v30.TextTransparency = textTransparency
					v30.UIStroke.Transparency = textTransparency
					v30.Size = UDim2.new(0, x, 0, n2.y)
					v30.Position = UDim2.new(0, n3 + n4.x, 0, -n2.y / 2 + n4.y)
					v30.Rotation = v30.Rotation + v22 * 10 * v32
					n3 += x * 1.15
				end
			elseif not vObj.finished then
				local v34 = math.clamp(v.time, 0, v.lifetime * v.fadestart)
				local v35 = vTween(v34, 0, 1, v.lifetime * v.fadestart)

				v34 = (math.clamp(v.time, 0, v.lifetime * v.fadestart) / (v.lifetime * v.fadestart)) ^ 3.5

				local n5 = 0

				for i = 1, #vObj.numbers do
					local v38 = vObj.numbers[i]
					local v39 = v38[1]
					local v40 = textService:GetTextSize(v38[4], n2.X, montserratBold, n2).X

					v39.TextTransparency = 1 - v35
					v39.UIStroke.Transparency = 1 - v35
					v39.Size = UDim2.new(0, v40, 0, n2.y)

					local uDim2New = UDim2.new
					local n6 = -n2.y / 2
					local sine = math.sin(i * 3.141592653589793 / 4 + v35 * 3.141592653589793 * 2)

					v39.Position = uDim2New(0, n5, 0, n6 + sine * (60 * vScale * (1 - v35)))

					if vObj.mode == 2 then
						local uiGradient = v39.UIGradient
						local colorSequenceNew = ColorSequence.new

						uiGradient.Color = colorSequenceNew({
							ColorSequenceKeypoint.new(0, Color3.new(1, 1 - v34, 1 - v34)),
							ColorSequenceKeypoint.new(0.5, Color3.new(1, 1 - v34 * 0.85, 1 - v34 * 0.85)),
							ColorSequenceKeypoint.new(1, Color3.new(1, 1 - v34, 1 - v34))
						})
					end

					n5 += v40 * 1.15
				end

				if v35 >= 1 then
					vObj.finished = true
				end
			end
		end
	end
end)

local function v11(p2, p3, p4)
	local v49 = p4 or 1
	local imageLabel: ImageLabel = Instance.new("ImageLabel")

	imageLabel.BackgroundTransparency = 1
	imageLabel.ZIndex = -100
	imageLabel.Image = "rbxassetid://2071125857"
	imageLabel.ScaleType = "Crop"
	imageLabel.ImageRectSize = Vector2.new(24, 30)
	imageLabel.Size = UDim2.new(0, 24 * v49, 0, 30 * v49)
	imageLabel.ImageRectOffset = Vector2.new(24 * p2, (p3 or 0) * 28)

	return imageLabel
end
local function u12(text, p6, p7, _)
	local v55 = p7 or 1
	local v56 = p6 or 0
	local clone = script.TextLabel:Clone()

	clone.Text = text
	clone.Font = montserratBold
	clone.Size = UDim2.new(0, 24 * v55, 0, 30 * v55)

	if v56 == 1 then
		local cloneUiGradient = clone.UIGradient
		local colorSequenceNew = ColorSequence.new

		cloneUiGradient.Color = colorSequenceNew({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 0)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
		})
	elseif v56 == 2 then
		clone.UIGradient.Color = ColorSequence.new(Color3.new(1, 1, 1))
	elseif v56 == 3 then
		local uIGradient = clone.UIGradient
		local v61 = ColorSequence.new

		uIGradient.Color = v61({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 220, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 220, 255))
		})
	elseif v56 == 4 then
		local v62 = clone.UIGradient
		local v63 = ColorSequence.new

		v62.Color = v63({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 140, 0)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 190, 60)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 110, 0))
		})
	elseif v56 == 5 then
		local v64 = clone.UIGradient
		local v65 = ColorSequence.new

		v64.Color = v65({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 240, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 255))
		})
	end

	return clone
end

local module: {[any]: any} = {}

module.__index = module

function module.new(p9, p10, p11, p12, p13, p14)
	runService.RenderStepped:Wait()

	local v72 = p12 or 0
	local n1 = 0
	local n2 = 0

	if typeof(p10) == "string" then
		p11 = p11 or 100
	elseif typeof(p10) == "number" then
		for _, v in pairs(t2) do
			if p9 == v.obj.anchor and v72 == v.obj.mode and v.time < v.lifetime * 0.75 then
				v.time = v.lifetime * 0.75
				n1 += v.obj.dmg
				n2 += v.obj.raw
			end
		end

		p10 = math.ceil(p10 * 1) + n1
		p11 = math.ceil(p11 * 1) + n2
	end

	n2 = 0.7

	local text: string = tostring(p10)

	if p14 or v72 == 1 then
		if typeof(p10) ~= "string" then
			text ..= "!"
		end

		n2 = 0.9
	elseif v72 == 3 then
		n2 = 0.95
	end

	local v78 = math.clamp(n2 + (p11 - 75) / 750, n2, n2 + 1)
	local v79 = math.clamp(CurrentCamera.ViewportSize.Magnitude / 1250, 1, 5)
	local n3 = v78 * v79
	local frame: Frame = Instance.new("Frame")

	frame.AnchorPoint = Vector2.new(0.5, 0)
	frame.BackgroundTransparency = 1
	frame.Size = UDim2.new(0, 1, 0, 1)
	v78 = {}

	for i = 1, #text do
		local substring = text:sub(i, i)
		local v84 = u12(substring, v72, n3, p13)

		v84.TextTransparency = 1
		v84.Parent = frame

		local n4 = math.random() - 0.5
		local vector2New = Vector2.new
		local randomNumber = math.random()
		local randomNumber2 = math.random()
		local v89 = vector2New(((i - n4) / (#text - n4) - 0.5) * 2 * (1.25 - randomNumber * 0.5), 1 - randomNumber2 * 2)

		if #text == 1 then
			local v90 = Vector2.new
			local randomNumber3 = math.random()
			local randomNumber4 = math.random()

			v89 = v90(1 - randomNumber3 * 2, 1 - randomNumber4 * 2)
		end

		table.insert(v78, { v84, Vector2.new(), v89, substring })
	end

	return (setmetatable({
		container = frame,
		numbers = v78,
		anchor = p9,
		dmg = p10,
		raw = p11,
		scale = n3,
		mode = v72
	}, module))
end
function module.ChangeAnchor(_, p16, p17)
	for _, v in pairs(t2) do
		if p16 == v.anchor then
			v.anchor = p17
		end
	end
end
function module.ChangeAnchorChildren(_, p19, p20)
	for iterFirst, iterSecond in p19:GetChildren() do
		for _, v in pairs(t2) do
			if iterSecond == v.anchor then
				v.anchor = p20:FindFirstChild(iterSecond.Name)
			end
		end
	end
end
function module.Display(p21, p22)
	local v107 = p22 or 2

	if p21.Added then
		return p21:Destroy()
	end

	local t4: {[any]: any} = {
		time = 0,
		lifetime = 1.5,
		fadestart = 0.25,
		obj = p21,
		tween = tween.ease.out.sine,
		anchor = p21.anchor,
		scale = p21.scale
	}
	local v109 = p21.mode == 2 and Vector3.new(0, v107, 0)

	if not v109 then
		local randomNumber = math.random()
		local randomNumber5 = math.random()
		local randomNumber6 = math.random()

		v109 = Vector3.new(randomNumber - 0.5, 0.5 + randomNumber5, randomNumber6 - 0.5) * v107
	end

	t4.offset = v109

	local randomNumber = math.random()
	local randomNumber7 = math.random()

	t4.dir = Vector3.new(randomNumber - 0.5, 1, randomNumber7 - 0.5) * 7 * p21.scale
	table.insert(t2, t4)
	p21.Added = true
end
function module.Destroy(p23)
	p23.container:Destroy()

	for k, v in pairs(t2) do
		if v.obj.container == p23.container then
			t2[k] = nil

			return
		end
	end
end

return module
