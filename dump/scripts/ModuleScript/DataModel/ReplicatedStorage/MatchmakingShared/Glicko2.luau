-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local function g(p1)
	return 1 / math.sqrt(1 + p1 * 3 * p1 / 9.869604401089358)
end
local function E(p2, p3, p4)
	local squareRoot = math.sqrt(1 + p4 * 3 * p4 / 9.869604401089358)

	return 1 / (math.exp(-(1 / squareRoot) * (p2 - p3)) + 1)
end

return {
	update = function(p5, p6, p7)
		local scale = p7.scale
		local center = p7.center
		local tau = p7.tau
		local v14 = p7.epsilon or 0.000001
		local n1 = (p5.r - center) / scale
		local n2 = p5.rd / scale
		local vol = p5.vol

		if #p6 == 0 then
			local squareRoot = math.sqrt(n2 * n2 + vol * vol)
			local r = p5.r
			local v20 = math.clamp(squareRoot * scale, p7.minRd, p7.maxRd)

			return { r = r, rd = v20, vol = vol }
		end

		local n3 = 0
		local n4 = 0

		for _, v in ipairs(p6) do
			local n5 = (v.r - center) / scale
			local n6 = v.rd / scale
			local n7 = 1 / math.sqrt(1 + n6 * 3 * n6 / 9.869604401089358)
			local squareRoot = math.sqrt(1 + n6 * 3 * n6 / 9.869604401089358)
			local n8 = 1 / (math.exp(-(1 / squareRoot) * (n1 - n5)) + 1)

			n3 += n7 * n7 * n8 * (1 - n8)
			n4 += n7 * (v.score - n8)
		end

		local n9 = 1 / n3

		n3 = n9 * n4

		local n10 = n3 * n3
		local n11 = n2 * n2
		local v33 = math.log(vol * vol)

		local function f(p8)
			local v54 = math.exp(p8)
			local n1 = n11 + n9 + v54

			return v54 * (n10 - n11 - n9 - v54) / (n1 * 2 * n1) - (p8 - v33) / (tau * tau)
		end

		local v35 = v33
		local v37

		if n10 > n11 + n9 then
			v37 = math.log(n10 - n11 - n9)
		else
			local n12: number = 1

			while true do
				local n13 = v33 - n12 * tau
				local v39 = math.exp(n13)
				local n14 = n11 + n9 + v39

				if not (v39 * (n10 - n11 - n9 - v39) / (n14 * 2 * n14) - (n13 - v33) / (tau * tau) < 0) then
					v37 = v33 - n12 * tau

					break
				end

				n12 += 1
			end
		end

		local v41 = math.exp(v35)
		local n15 = n11 + n9 + v41
		local n16 = v41 * (n10 - n11 - n9 - v41) / (n15 * 2 * n15) - (v35 - v33) / (tau * tau)

		n15 = math.exp(v37)

		local n17 = n11 + n9 + n15
		local n18 = n15 * (n10 - n11 - n9 - n15) / (n17 * 2 * n17) - (v37 - v33) / (tau * tau)

		while true do
			local absoluteValue = math.abs(v37 - v35)

			if not (v14 < absoluteValue) then
				break
			end

			local n19 = v35 + (v35 - v37) * n16 / (n18 - n16)
			local v48 = math.exp(n19)
			local n20 = n11 + n9 + v48
			local n21 = v48 * (n10 - n11 - n9 - v48) / (n20 * 2 * n20) - (n19 - v33) / (tau * tau)

			if n21 * n18 <= 0 then
				v35 = v37
				n16 = n18
			else
				n16 /= 2
			end

			v37 = n19
			n18 = n21
		end

		n18 = math.exp(v35 / 2)

		local squareRoot2 = math.sqrt(n11 + n18 * n18)
		local n22 = 1 / math.sqrt(1 / (squareRoot2 * squareRoot2) + 1 / n9)

		n15 = math.clamp(n22 * scale, p7.minRd, p7.maxRd)

		return { r = (n1 + n22 * n22 * n4) * scale + center, rd = n15, vol = n18 }
	end
}
