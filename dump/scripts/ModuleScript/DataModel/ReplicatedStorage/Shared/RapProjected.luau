-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local shared: Instance = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local tradingPlazaGate = require(shared:WaitForChild("TradingPlazaGate"))

local module: {[any]: any} = {
	Enabled = function()
		return tradingPlazaGate.IsTradingPlaza()
	end,
	ICON = "rbxassetid://76153822341042",
	TEXT = "Possibly overvalued",
	COLOR = Color3.fromRGB(255, 214, 48)
}

function module.Is(p1)
	if not module.Enabled() then
		return false
	end

	local u5: boolean = false

	if typeof(p1) == "table" then
		u5 = true

		if p1.Projected ~= true then
			u5 = p1.RapProjected == true
		end
	end

	return u5
end
function module.SetTag(parent, p3, p4, p5, p6, p7)
	local projectedTag = parent:FindFirstChild("ProjectedTag")

	if not p3 then
		if projectedTag then
			projectedTag:Destroy()
		end

		return
	end

	local v13 = p6 or 0.3

	if projectedTag and projectedTag:IsA("ImageLabel") then
		projectedTag.Position = UDim2.new(p4, 0, p5, 0)
		projectedTag.Size = UDim2.new(v13, 0, v13, 0)

		return
	end

	local projectedTag: ImageLabel = Instance.new("ImageLabel")

	projectedTag.Name = "ProjectedTag"
	projectedTag.BackgroundTransparency = 1
	projectedTag.Image = module.ICON
	projectedTag.ScaleType = Enum.ScaleType.Fit
	projectedTag.AnchorPoint = Vector2.new(1, 0)
	projectedTag.Position = UDim2.new(p4, 0, p5, 0)
	projectedTag.Size = UDim2.new(v13, 0, v13, 0)
	projectedTag.ZIndex = p7 or parent.ZIndex + 3

	local uiAspectRatioConstraint: UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

	uiAspectRatioConstraint.AspectRatio = 1
	uiAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
	uiAspectRatioConstraint.Parent = projectedTag
	projectedTag.Parent = parent
end

return module
