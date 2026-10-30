-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return function(p1, p2, p3, _)
	local ray = Ray.new(p1, p2)

	return workspace:FindPartOnRayWithWhitelist(ray, p3)
end
