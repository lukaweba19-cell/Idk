-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local dataStoreService: DataStoreService = game:GetService("DataStoreService")
local t1: {[any]: any} = {}
local u3 = nil
local u4 = nil

task.spawn(function()
	local ok, result = pcall(function()
		local v15: DataStore = dataStoreService:GetDataStore("_package/eryn.io/Cmdr")

		v15:GetAsync("test_key")

		return v15
	end)

	u3 = ok
	u4 = result

	while #t1 > 0 do
		coroutine.resume(table.remove(t1, 1))
	end
end)

return function(p1, p2, p3)
	if u3 == nil then
		table.insert(t1, coroutine.running())
		coroutine.yield()
	end

	local u10: boolean = false
	local u11: boolean = true

	if p2:sub(1, 1) == "$" then
		p2 = p2:sub(2)
		u10 = true
	end

	if p2:sub(1, 1) == "." then
		p2 = p2:sub(2)
		u11 = false
	end

	if u11 and not u3 then
		return "# You must publish this place to the web to use saved keys."
	end

	local s1: string = if u10 then "global" else tostring(p1.Executor.UserId)
	local s2: string = "var_" .. s1

	if u11 then
		u4:SetAsync(s2 .. "_" .. p2, p3)

		if type(p3) == "table" then
			return table.concat(p3, ",") or ""
		end

		return p3
	end

	local v14 = p1:GetStore(s2)

	v14[p2] = p3

	if type(p3) == "table" then
		return table.concat(p3, ",") or ""
	end

	return p3
end
