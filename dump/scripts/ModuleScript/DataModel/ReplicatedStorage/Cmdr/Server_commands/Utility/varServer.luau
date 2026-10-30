-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local dataStoreService: DataStoreService = game:GetService("DataStoreService")
local t1: {[any]: any} = {}
local u3 = nil
local u4 = nil

task.spawn(function()
	local ok, result = pcall(function()
		local v14: DataStore = dataStoreService:GetDataStore("_package/eryn.io/Cmdr")

		v14:GetAsync("test_key")

		return v14
	end)

	u3 = ok
	u4 = result

	while #t1 > 0 do
		coroutine.resume(table.remove(t1, 1))
	end
end)

return function(p1, p2)
	if u3 == nil then
		table.insert(t1, coroutine.running())
		coroutine.yield()
	end

	local u9: boolean = false
	local u10: boolean = true

	if p2:sub(1, 1) == "$" then
		p2 = p2:sub(2)
		u9 = true
	end

	if p2:sub(1, 1) == "." then
		p2 = p2:sub(2)
		u10 = false
	end

	if u10 and not u3 then
		return "# You must publish this place to the web to use saved keys."
	end

	local s1 = if u9 then "global" else tostring(p1.Executor.UserId)
	local s2: string = "var_" .. s1

	if u10 then
		local v13 = u4:GetAsync(s2 .. "_" .. p2) or ""

		if type(v13) == "table" then
			return table.concat(v13, ",") or ""
		end

		return v13
	end

	s1 = p1:GetStore(s2)[p2] or ""

	if type(s1) == "table" then
		return table.concat(s1, ",") or ""
	end

	return s1
end
