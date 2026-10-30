-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local v1 = require("./utility")

local module: {[any]: any} = {
	apply = function(p1, p2)
		if p1:IsA("ParticleEmitter") then
			p1.Size = v1.scaleNumberSequence(p1.Size, p2)
			p1.Speed = NumberRange.new(p1.Speed.Min * p2, p1.Speed.Max * p2)
			p1.Acceleration = p1.Acceleration * p2

			return
		end

		if p1:IsA("Beam") then
			v1.scaleAttribute(p1, p2, "Width0_Start")
			v1.scaleAttribute(p1, p2, "Width1_Start")
			v1.scaleAttribute(p1, p2, "Width0_End")
			v1.scaleAttribute(p1, p2, "Width1_End")
			v1.scaleAttribute(p1, p2, "CurveSize0_Start")
			v1.scaleAttribute(p1, p2, "CurveSize1_Start")
			v1.scaleAttribute(p1, p2, "CurveSize0_End")
			v1.scaleAttribute(p1, p2, "CurveSize1_End")
			v1.scaleAttribute(p1, p2, "Length_Scale_Start")
			v1.scaleAttribute(p1, p2, "Length_Scale_End")
			p1.Width0 = p1.Width0 * p2
			p1.Width1 = p1.Width1 * p2
			p1.CurveSize0 = p1.CurveSize0 * p2
			p1.CurveSize1 = p1.CurveSize1 * p2
			v1.scaleAttachmentDistance(p1.Attachment0, p1.Attachment1, p2)

			return
		end

		if p1:IsA("Trail") then
			v1.scaleAttachmentDistance(p1.Attachment0, p1.Attachment1, p2)

			return
		end

		if p1:IsA("Sound") then
			p1.RollOffMinDistance = p1.RollOffMinDistance * p2
			p1.RollOffMaxDistance = p1.RollOffMaxDistance * p2
			v1.scaleAttribute(p1, p2, "RollOff_Start")
			v1.scaleAttribute(p1, p2, "RollOff_End")

			return
		end

		if p1:IsA("Model") then
			if not v1.isMeshVFX(p1) then
				v1.scaleAttribute(p1, p2, "Scale_Start")
				v1.scaleAttribute(p1, p2, "Scale_End")

				return
			end

			local start = p1:FindFirstChild("Start")
			local v6 = p1:FindFirstChild("End")

			if start and v6 then
				start.Size = start.Size * p2
				v6.Size = v6.Size * p2

				local specialMesh = start:FindFirstChildOfClass("SpecialMesh")
				local specialMesh2 = v6:FindFirstChildOfClass("SpecialMesh")

				if specialMesh and specialMesh2 then
					specialMesh.Scale = specialMesh.Scale * p2
					specialMesh2.Scale = specialMesh2.Scale * p2

					return
				end
			end
		else
			if p1:IsA("Attachment") and p1:HasTag(v1.LIGHTNING_TAG) then
				v1.scaleAttribute(p1, p2, "OffsetScale")
				v1.scaleAttribute(p1, p2, "Width_Start")
				v1.scaleAttribute(p1, p2, "Width_End")

				return
			end

			if p1:IsA("BasePart") and p1.Parent and v1.findFirstClassWithTag(p1.Parent, "Attachment", v1.SHOCKWAVE_TAG) then
				v1.scaleAttribute(p1, p2, "Radius")
				v1.scaleAttribute(p1, p2, "Length")
				v1.scaleAttribute(p1, p2, "MinSize")
				v1.scaleAttribute(p1, p2, "MaxSize")

				if p1:GetAttribute("LinearMagnitude") then
					p1.Size = p1.Size * p2
					v1.scaleAttribute(p1, p2, "LinearMagnitude")
					v1.scaleAttribute(p1, p2, "AngularMagnitude")

					return
				end
			elseif p1:IsA("RayValue") and p1:HasTag(v1.SCREENSHAKE_TAG) then
				v1.scaleAttribute(p1, p2, "Falloff")
			end
		end
	end
}

function module.batch(p3, ...)
	for iterFirst, value in { ... }, nil, nil do
		module.apply(value, p3)

		for iterFirst2, iterSecond in value:GetDescendants() do
			module.apply(iterSecond, p3)
		end
	end
end

return module
