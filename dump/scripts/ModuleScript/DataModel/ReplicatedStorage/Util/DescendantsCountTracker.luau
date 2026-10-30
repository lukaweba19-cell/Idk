-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return function(p1)
	local u2 = p1:GetDescendants()
	local n1: number = if u2 then #u2 else 0
	local t1 = {}

	if u2 then
		assert(t1, "bad dictionary")

		for _, v in pairs(u2) do
			if v:IsA("TouchTransmitter") then
				n1 -= 1
			else
				t1[v.Name] = (t1[v.Name] or 0) + 1
			end
		end
	end

	local t2 = {
		count = n1,
		dictionary = t3,
		Destroy = function()
			warn("destroy never initialized")
		end
	}

	local t3 = if t1 then t1 else {}

	t3 = function(p3)
		if p3:IsA("TouchTransmitter") then
			return
		end

		if not t1 then
			return
		end

		local v11 = t1[p3.Name]

		if v11 then
			if v11 <= 1 then
				t1[p3.Name] = nil
			else
				local v12: {[any]: any} = t1
				local v13 = p3.Name

				v12[v13] = v12[v13] - 1
			end
		end

		if t2 then
			local v14: {[any]: any} = t2

			v14.count = v14.count - 1
		end
	end

	local connection = p1.DescendantAdded:Connect(function(p2)
		if p2:IsA("TouchTransmitter") then
			return
		end

		if not t1 then
			return
		end

		t1[p2.Name] = (t1[p2.Name] or 0) + 1

		if t2 then
			local v16: {[any]: any} = t2

			v16.count = v16.count + 1
		end
	end)

	assert(t2, "bad tracker")

	function t2.Destroy()
		if connection then
			connection:Disconnect()
		end

		connection = nil
		u2 = nil
		t1 = nil
		t2 = nil
	end

	return t2
end
