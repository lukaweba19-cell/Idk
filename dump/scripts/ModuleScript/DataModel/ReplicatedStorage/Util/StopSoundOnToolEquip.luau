-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	Bind = function(p1, p2, p3)
		if not p2 then
			return
		end

		if not p2.Parent then
			return
		end

		local connection = nil
		local connection2 = nil
		local u6: boolean = false

		local function cleanup()
			if u6 then
				return
			end

			u6 = true

			if connection then
				connection:Disconnect()
				connection = nil
			end

			if connection2 then
				connection2:Disconnect()
				connection2 = nil
			end

			if typeof(p1) == "table" and p1.Current then
				p1 = p1.Current
			end

			if p1 then
				if p1.FadeOut then
					p1:FadeOut(0.05)
				end

				p1 = nil
			end
		end

		connection = p2.ChildAdded:Connect(function(p4)
			if p4:IsA("Tool") and p4.Name ~= p3 then
				cleanup()
			end
		end)
		connection2 = p2.AncestryChanged:Connect(cleanup)

		return cleanup
	end
}
