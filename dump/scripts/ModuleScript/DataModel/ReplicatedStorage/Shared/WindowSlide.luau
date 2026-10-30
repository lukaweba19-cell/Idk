-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local tweenService: TweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

local module: {[any]: any} = {
	TWEEN_OPEN = tweenInfo,
	TWEEN_CLOSE = tweenInfo2,
	closedPosFor = function(p1)
		return UDim2.new(p1.X.Scale, p1.X.Offset, p1.Y.Scale + 1, p1.Y.Offset)
	end
}

function module.slideIn(p2, p3, p4)
	p2.Position = p4
	p2.Visible = true

	local v9: Tween = tweenService:Create(p2, module.TWEEN_OPEN, { Position = p3 })

	v9:Play()

	return v9
end
function module.slideOut(p5, p6, p7)
	local v13: Tween = tweenService:Create(p5, module.TWEEN_CLOSE, { Position = p6 })

	v13:Play()

	if p7 then
		v13.Completed:Once(p7)
	end

	return v13
end

return module
