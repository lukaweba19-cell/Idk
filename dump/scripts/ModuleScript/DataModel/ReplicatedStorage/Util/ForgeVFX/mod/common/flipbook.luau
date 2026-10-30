-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local runService: RunService = game:GetService("RunService")
local collectionService: CollectionService = game:GetService("CollectionService")

local module: {[any]: any} = {
	serialize = function(p1)
		local v5 = buffer.create(#p1 * 8)

		for iterFirst, iterSecond in p1 do
			buffer.writef64(v5, (iterFirst - 1) * 8, iterSecond)
		end

		return v5
	end,
	deserialize = function(p2)
		local v9 = typeof(p2) == "string" and buffer.fromstring(p2) or p2
		local t2: {[any]: any} = {}

		for i = 0, buffer.len(v9) / 8 - 1 do
			local v12 = buffer.readf64(v9, i * 8)

			table.insert(t2, v12)
		end

		return t2
	end,
	isLocalFlipbook = function(p3)
		if not runService:IsStudio() then
			return false
		end

		for iterFirst, iterSecond in collectionService:GetTags(p3) do
			if iterSecond:match("^_local_flipbook_") then
				return true
			end
		end

		return false
	end
}

function module.getTexturePrefix(p4)
	if module.isLocalFlipbook(p4) then
		return "rbxtemp://"
	end

	return "rbxassetid://"
end
function module.getFlipbookData(p5)
	if not p5:GetAttribute("FlipbookEnabled") then
		return nil
	end

	local flipbookTextures = p5:GetAttribute("FlipbookTextures")

	if not flipbookTextures then
		return nil
	end

	local v19 = module.deserialize(flipbookTextures)

	if #v19 == 0 then
		return nil
	end

	return v19
end
function module.getChangeDuration(p6)
	local v21 = p6.duration

	if p6.ref:GetAttribute("SyncDuration") then
		v21 = p6.effectDuration
	end

	return v21
end
function module.createUpdateCallback(p7)
	local v23 = module.getTexturePrefix(p7.ref)

	return function(p8, p9)
		local rounded = math.round(#p7.frames * p8)
		local v27 = math.max(rounded, 1)
		local setTexture = p7.setTexture
		local v29 = ("%*%*"):format(v23, p7.frames[v27])

		setTexture(v29)
		v29 = p7.getSpeed()

		return p9 * v29
	end
end

return module
