-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local t1: {[any]: any} = {
	"LuaSourceContainer",
	"Tool",
	"Sound",
	"ParticleEmitter",
	"Beam",
	"Trail",
	"Light",
	"BillboardGui",
	"SurfaceGui",
	"Highlight",
	"ForceField",
	"Decal",
	"SurfaceAppearance",
	"Clothing",
	"ShirtGraphic",
	"BodyColors",
	"Humanoid",
	"AnimationController",
	"Animator",
	"ProximityPrompt",
	"ClickDetector",
	"Fire",
	"Smoke",
	"Sparkles",
	"Explosion",
	"Constraint",
	"BodyMover"
}

local function stripped(p1)
	for key, value in t1 do
		if p1:IsA(value) then
			return true
		end
	end

	return false
end

return {
	Build = function(p2, p3, p4)
		local archivable = p2.Archivable

		p2.Archivable = true

		local ok, result = pcall(function()
			return p2:Clone()
		end)

		p2.Archivable = archivable

		if ok and result then
			for iterFirst, iterSecond in result:GetChildren() do
				if iterSecond:IsA("Model") then
					iterSecond:Destroy()
				end
			end

			for iterFirst2, iterSecond2 in result:GetDescendants() do
				if iterSecond2.Parent then
					local v16: boolean = false
					local u17

					for key, value in t1 do
						if iterSecond2:IsA(value) then
							u17 = true
							v16 = true

							break
						end
					end

					if not v16 then
						u17 = false
					end

					if u17 then
						iterSecond2:Destroy()
					end
				end
			end

			for iterValue in result:GetAttributes() do
				result:SetAttribute(iterValue, nil)
			end

			local humanoidRootPart = result:FindFirstChild("HumanoidRootPart")

			if not humanoidRootPart or not humanoidRootPart:IsA("BasePart") then
				result:Destroy()

				return nil
			end

			local t2: {[any]: any} = {}

			for iterFirst3, iterSecond3 in result:GetDescendants() do
				if iterSecond3:IsA("BasePart") then
					local u25: boolean = iterSecond3 ~= humanoidRootPart and iterSecond3.Transparency < 0.95

					iterSecond3.Anchored = true
					iterSecond3.CanCollide = false
					iterSecond3.CanQuery = false
					iterSecond3:SetAttribute("NoCanQuery", true)
					iterSecond3.CanTouch = false
					iterSecond3.CastShadow = false
					iterSecond3.Massless = true
					iterSecond3.Material = Enum.Material.ForceField
					iterSecond3.Color = p3
					iterSecond3.LocalTransparencyModifier = 0
					iterSecond3.Transparency = if u25 then p4 else 1

					if iterSecond3:IsA("MeshPart") then
						iterSecond3.TextureID = ""
					end

					if u25 then
						table.insert(t2, iterSecond3)
					end
				elseif iterSecond3:IsA("SpecialMesh") then
					iterSecond3.TextureId = ""
				end
			end

			result.PrimaryPart = humanoidRootPart
			result.Name = "CheckpointHologram"

			return { model = result, parts = t2, base = p4 }
		end

		return nil
	end,
	SetFade = function(p5, p6)
		local n1 = 1 - p5.base
		local v29 = math.clamp(p6, 0, 1)

		for iterFirst, iterSecond in p5.parts, nil, nil do
			iterSecond.Transparency = 1 - n1 * v29
		end
	end
}
