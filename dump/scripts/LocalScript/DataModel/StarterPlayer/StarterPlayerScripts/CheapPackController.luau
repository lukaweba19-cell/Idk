-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local marketplaceService: MarketplaceService = game:GetService("MarketplaceService")
local shared: Instance = replicatedStorage:WaitForChild("Shared")

if require(shared:WaitForChild("TradingPlazaGate")).IsTradingPlaza() then
	return
end

local LocalPlayer: Player = players.LocalPlayer
local replicatedStorageShared: Instance = replicatedStorage:WaitForChild("Shared")
local packCatalog = require(replicatedStorageShared:WaitForChild("PackCatalog"))
local remotes: Instance = replicatedStorage:WaitForChild("Remotes")
local packRequest: Instance = remotes:WaitForChild("PackRequest")
local packPush: Instance = remotes:WaitForChild("PackPush")
local currencyBuyRequest: Instance = remotes:WaitForChild("CurrencyBuyRequest")
local v12 = packCatalog.Get("CheapPack")
local v13 = packCatalog.Get("HallowsUpsell")

if v12 and v13 then
	local lobby: Instance = workspace:WaitForChild("Lobby")
	local cheapPack: Instance = lobby:WaitForChild("CheapPack", 30)

	if not cheapPack then
		warn("[CheapPackController] CheapPack model not found in Lobby")

		return
	end

	local foundChild: Instance = cheapPack:FindFirstChildWhichIsA("ProximityPrompt", true)

	if not foundChild then
		warn("[CheapPackController] No ProximityPrompt under CheapPack")

		return
	end

	local pivot = cheapPack:GetPivot()
	local hallowsUpsell: Instance = replicatedStorage:WaitForChild("HallowsUpsell", 30)

	if not hallowsUpsell then
		warn("[CheapPackController] ReplicatedStorage.HallowsUpsell template missing; upsell disabled")
	end

	local function applyPrice(p1, p2)
		task.spawn(function()
			for i = 1, 10 do
				local ok, result = pcall(function()
					return marketplaceService:GetProductInfo(buyProductId, Enum.InfoType.Product)
				end)

				if ok and result and typeof(result.PriceInRobux) == "number" then
					local foundChild2 = p1:FindFirstChildWhichIsA("BillboardGui", true)
					local title = foundChild2 and foundChild2:FindFirstChild("Title")

					if title and title:IsA("TextLabel") then
						local v96 = utf8.char(57346)
						local text: string = tostring(result.PriceInRobux)

						title.Text = v96 .. " " .. text
					end

					return
				end

				task.wait(i * 2)
			end

			warn("[CheapPackController] Could not fetch Robux price for " .. p2)
		end)
	end

	local buyProductId = v12.BuyProductId

	task.spawn(function()
		for i = 1, 10 do
			local ok, result = pcall(function()
				return marketplaceService:GetProductInfo(buyProductId, Enum.InfoType.Product)
			end)

			if ok and result and typeof(result.PriceInRobux) == "number" then
				local foundChild3: Instance = cheapPack:FindFirstChildWhichIsA("BillboardGui", true)
				local title: Instance = foundChild3 and foundChild3:FindFirstChild("Title")

				if title and title:IsA("TextLabel") then
					local v38 = utf8.char(57346)
					local text: string = tostring(result.PriceInRobux)

					title.Text = v38 .. " " .. text
				end

				return
			end

			task.wait(i * 2)
		end

		warn("[CheapPackController] Could not fetch Robux price for " .. buyProductId)
	end)

	local u21 = nil
	local u22 = nil

	local function ownsFromCount(p3, p4)
		local typeName: string = typeof(p4)
		local purchaseLimit = p3.PurchaseLimit

		return purchaseLimit > 0 and (if typeName == "number" then p4 else if p4 == true then 1 else 0) >= purchaseLimit
	end

	local u24: boolean = false

	foundChild.Enabled = false
	foundChild.Triggered:Connect(function(p5)
		if p5 ~= LocalPlayer then
			return
		end

		if u24 then
			return
		end

		currencyBuyRequest:FireServer(v12.BuyProductId)
	end)

	local function destroyCheap()
		if u24 then
			return
		end

		u24 = true

		if foundChild then
			foundChild.Enabled = false
		end

		if cheapPack then
			cheapPack:Destroy()
		end
	end

	local u26 = nil

	local function destroyExpensiveClone()
		local v45 = u26

		if v45 then
			u26 = nil
			v45:Destroy()
		end
	end
	local function ensureExpensiveClone()
		if u26 then
			return
		end

		if not hallowsUpsell then
			return
		end

		local clone: Instance = hallowsUpsell:Clone()
		local foundChild4: Instance = clone:FindFirstChildWhichIsA("ProximityPrompt", true)

		if foundChild4 then
			foundChild4.Enabled = true
			foundChild4.Triggered:Connect(function(p6)
				if p6 ~= LocalPlayer then
					return
				end

				if u26 ~= clone then
					return
				end

				currencyBuyRequest:FireServer(v13.BuyProductId)
			end)
		end

		clone:PivotTo(pivot)
		clone.Parent = lobby
		u26 = clone

		local buyProductId = v13.BuyProductId

		task.spawn(function()
			for i = 1, 10 do
				local ok, result = pcall(function()
					return marketplaceService:GetProductInfo(buyProductId, Enum.InfoType.Product)
				end)

				if ok and result and typeof(result.PriceInRobux) == "number" then
					local foundChild5: Instance = clone:FindFirstChildWhichIsA("BillboardGui", true)
					local title: Instance = foundChild5 and foundChild5:FindFirstChild("Title")

					if title and title:IsA("TextLabel") then
						local v104 = utf8.char(57346)
						local text: string = tostring(result.PriceInRobux)

						title.Text = v104 .. " " .. text
					end

					return
				end

				task.wait(i * 2)
			end

			warn("[CheapPackController] Could not fetch Robux price for " .. buyProductId)
		end)

		local foundChild6: Instance = clone:FindFirstChildWhichIsA("AnimationController", true)
		local playAnimation: Instance = clone:FindFirstChild("PlayAnimation")
		local animation: Instance = playAnimation and playAnimation:FindFirstChildOfClass("Animation")

		if foundChild6 and animation then
			local animationTrack = foundChild6:LoadAnimation(animation)

			animationTrack.Looped = true
			animationTrack:Play()
		end
	end
	local function applyState()
		if u22 == true then
			if not u24 then
				u24 = true

				if foundChild then
					foundChild.Enabled = false
				end

				if cheapPack then
					cheapPack:Destroy()
				end
			end

			local v53 = u26

			if v53 then
				u26 = nil
				v53:Destroy()

				return
			end
		elseif u21 == true then
			if not u24 then
				u24 = true

				if foundChild then
					foundChild.Enabled = false
				end

				if cheapPack then
					cheapPack:Destroy()
				end
			end

			if u22 == false then
				ensureExpensiveClone()

				return
			end
		elseif u21 == false then
			if not u24 then
				foundChild.Enabled = true
			end

			local v54 = u26

			if v54 then
				u26 = nil
				v54:Destroy()
			end
		end
	end
	local function ingestOwnedPacks(p7)
		if typeof(p7) == "table" then
			local cheapPack2 = p7.CheapPack
			local typeName: string = typeof(cheapPack2)
			local purchaseLimit = v12.PurchaseLimit

			u21 = purchaseLimit > 0 and (if typeName == "number" then cheapPack2 else if cheapPack2 == true then 1 else 0) >= purchaseLimit

			local hallowsUpsell = p7.HallowsUpsell
			local typeName2: string = typeof(hallowsUpsell)
			local v61 = v13.PurchaseLimit

			u22 = v61 > 0 and (if typeName2 == "number" then hallowsUpsell else if hallowsUpsell == true then 1 else 0) >= v61

			if u22 == true then
				if not u24 then
					u24 = true

					if foundChild then
						foundChild.Enabled = false
					end

					if cheapPack then
						cheapPack:Destroy()
					end
				end

				local v62 = u26

				if v62 then
					u26 = nil
					v62:Destroy()

					return
				end
			elseif u21 == true then
				if not u24 then
					u24 = true

					if foundChild then
						foundChild.Enabled = false
					end

					if cheapPack then
						cheapPack:Destroy()
					end
				end

				if u22 == false then
					ensureExpensiveClone()

					return
				end
			elseif u21 == false then
				if not u24 then
					foundChild.Enabled = true
				end

				local v63 = u26

				if v63 then
					u26 = nil
					v63:Destroy()
				end
			end

			return
		end
	end

	packPush.OnClientEvent:Connect(function(p8)
		if typeof(p8) == "table" then
			local ownedPacks = p8.OwnedPacks

			if typeof(ownedPacks) == "table" then
				local ownedPacksCheapPack = ownedPacks.CheapPack
				local typeName: string = typeof(ownedPacksCheapPack)
				local purchaseLimit = v12.PurchaseLimit

				u21 = purchaseLimit > 0 and (if typeName == "number" then ownedPacksCheapPack else if ownedPacksCheapPack == true then 1 else 0) >= purchaseLimit

				local ownedPacksHallowsUpsell = ownedPacks.HallowsUpsell
				local typeName3: string = typeof(ownedPacksHallowsUpsell)
				local v71 = v13.PurchaseLimit

				u22 = v71 > 0 and (if typeName3 == "number" then ownedPacksHallowsUpsell else if ownedPacksHallowsUpsell == true then 1 else 0) >= v71

				if u22 == true then
					if not u24 then
						u24 = true

						if foundChild then
							foundChild.Enabled = false
						end

						if cheapPack then
							cheapPack:Destroy()
						end
					end

					local v72 = u26

					if v72 then
						u26 = nil
						v72:Destroy()

						return
					end
				elseif u21 == true then
					if not u24 then
						u24 = true

						if foundChild then
							foundChild.Enabled = false
						end

						if cheapPack then
							cheapPack:Destroy()
						end
					end

					if u22 == false then
						ensureExpensiveClone()

						return
					end
				elseif u21 == false then
					if not u24 then
						foundChild.Enabled = true
					end

					local v73 = u26

					if v73 then
						u26 = nil
						v73:Destroy()
					end
				end

				return
			end

			return
		end
	end)
	LocalPlayer:GetAttributeChangedSignal("OwnsPack_CheapPack"):Connect(function()
		if LocalPlayer:GetAttribute("OwnsPack_CheapPack") == true then
			u21 = true

			if u22 == true then
				if not u24 then
					u24 = true

					if foundChild then
						foundChild.Enabled = false
					end

					if cheapPack then
						cheapPack:Destroy()
					end
				end

				local v74 = u26

				if v74 then
					u26 = nil
					v74:Destroy()

					return
				end
			elseif u21 == true then
				if not u24 then
					u24 = true

					if foundChild then
						foundChild.Enabled = false
					end

					if cheapPack then
						cheapPack:Destroy()
					end
				end

				if u22 == false then
					ensureExpensiveClone()

					return
				end
			elseif u21 == false then
				if not u24 then
					foundChild.Enabled = true
				end

				local v75 = u26

				if v75 then
					u26 = nil
					v75:Destroy()
				end
			end

			return
		end
	end)
	LocalPlayer:GetAttributeChangedSignal("OwnsPack_HallowsUpsell"):Connect(function()
		if LocalPlayer:GetAttribute("OwnsPack_HallowsUpsell") == true then
			u22 = true

			if u22 == true then
				if not u24 then
					u24 = true

					if foundChild then
						foundChild.Enabled = false
					end

					if cheapPack then
						cheapPack:Destroy()
					end
				end

				local v76 = u26

				if v76 then
					u26 = nil
					v76:Destroy()

					return
				end
			elseif u21 == true then
				if not u24 then
					u24 = true

					if foundChild then
						foundChild.Enabled = false
					end

					if cheapPack then
						cheapPack:Destroy()
					end
				end

				if u22 == false then
					ensureExpensiveClone()

					return
				end
			elseif u21 == false then
				if not u24 then
					foundChild.Enabled = true
				end

				local v77 = u26

				if v77 then
					u26 = nil
					v77:Destroy()
				end
			end

			return
		end
	end)
	task.spawn(function()
		if LocalPlayer:GetAttribute("DataReady") ~= true then
			LocalPlayer:GetAttributeChangedSignal("DataReady"):Wait()
		end

		if LocalPlayer:GetAttribute("OwnsPack_CheapPack") == true then
			u21 = true
		end

		if LocalPlayer:GetAttribute("OwnsPack_HallowsUpsell") == true then
			u22 = true
		end

		if u22 == true then
			if not u24 then
				u24 = true

				if foundChild then
					foundChild.Enabled = false
				end

				if cheapPack then
					cheapPack:Destroy()
				end
			end

			local v78 = u26

			if v78 then
				u26 = nil
				v78:Destroy()
			end
		elseif u21 == true then
			if not u24 then
				u24 = true

				if foundChild then
					foundChild.Enabled = false
				end

				if cheapPack then
					cheapPack:Destroy()
				end
			end

			if u22 == false then
				ensureExpensiveClone()
			end
		elseif u21 == false then
			if not u24 then
				foundChild.Enabled = true
			end

			local v79 = u26

			if v79 then
				u26 = nil
				v79:Destroy()
			end
		end

		local ok, result = pcall(function()
			return packRequest:InvokeServer("GetState")
		end)

		if ok and typeof(result) == "table" then
			local resultOwnedPacks = result.OwnedPacks

			if typeof(resultOwnedPacks) == "table" then
				local resultOwnedPacksCheapPack = resultOwnedPacks.CheapPack
				local typeName: string = typeof(resultOwnedPacksCheapPack)
				local purchaseLimit = v12.PurchaseLimit

				u21 = purchaseLimit > 0 and (if typeName == "number" then resultOwnedPacksCheapPack else if resultOwnedPacksCheapPack == true then 1 else 0) >= purchaseLimit

				local resultOwnedPacksHallowsUpsell = resultOwnedPacks.HallowsUpsell
				local typeName4: string = typeof(resultOwnedPacksHallowsUpsell)
				local v88 = v13.PurchaseLimit

				u22 = v88 > 0 and (if typeName4 == "number" then resultOwnedPacksHallowsUpsell else if resultOwnedPacksHallowsUpsell == true then 1 else 0) >= v88

				if u22 == true then
					if not u24 then
						u24 = true

						if foundChild then
							foundChild.Enabled = false
						end

						if cheapPack then
							cheapPack:Destroy()
						end
					end

					local v89 = u26

					if v89 then
						u26 = nil
						v89:Destroy()

						return
					end
				elseif u21 == true then
					if not u24 then
						u24 = true

						if foundChild then
							foundChild.Enabled = false
						end

						if cheapPack then
							cheapPack:Destroy()
						end
					end

					if u22 == false then
						ensureExpensiveClone()

						return
					end
				elseif u21 == false then
					if not u24 then
						foundChild.Enabled = true
					end

					local v90 = u26

					if v90 then
						u26 = nil
						v90:Destroy()
					end
				end

				return
			end

			return
		end
	end)

	return
end

warn("[CheapPackController] CheapPack/ExpensivePack not found in PackCatalog")
