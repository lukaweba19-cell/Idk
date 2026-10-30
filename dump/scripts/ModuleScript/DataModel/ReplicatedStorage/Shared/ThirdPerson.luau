-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local module: {[any]: any} = {
	ATTRIBUTE = "ThirdPerson",
	Distance = 9,
	Height = 1.2,
	Shoulder = 2.6,
	MinDistance = 1.5,
	SurfacePad = 0.6
}

function module.IsEnabled()
	local LocalPlayer: Player = players.LocalPlayer

	return LocalPlayer ~= nil and LocalPlayer:GetAttribute(module.ATTRIBUTE) == true
end
function module.SetEnabled(p1)
	local LocalPlayer: Player = players.LocalPlayer

	if not LocalPlayer then
		return
	end

	LocalPlayer:SetAttribute(module.ATTRIBUTE, if p1 then true else nil)
end
function module.Toggle()
	local u8: boolean = not module.IsEnabled()

	module.SetEnabled(u8)

	return u8
end

local u3 = nil
local n1 = 0

function module.PublishEye(p2)
	u3 = p2
	n1 = os.clock()
end
function module.GetEye()
	if u3 == nil then
		return nil
	end

	if os.clock() - n1 > 0.25 then
		return nil
	end

	return u3
end

return module
