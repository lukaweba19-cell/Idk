-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local tradingPlazaGate = require(shared:WaitForChild("TradingPlazaGate"))

require(shared:WaitForChild("GameFlags"))

local tradePublicFlags = require(shared:WaitForChild("TradePublicFlags"))

if tradingPlazaGate.IsTradingPlaza() then
	return
end

if replicatedStorage:GetAttribute("IsMatchServer") == true then
	return
end

local screenWipe = require(shared:WaitForChild("ScreenWipe"))
local tradePortal: Instance = workspace:WaitForChild("Lobby"):FindFirstChild("TradePortal")
local tradeTeleportPart: Instance = tradePortal and tradePortal:FindFirstChild("TradeTeleportPart")

if not tradeTeleportPart or not tradeTeleportPart:IsA("BasePart") then
	return
end

local LocalPlayer: Player = players.LocalPlayer
local v10: Instance = tradePortal

if v10 then
	v10 = tradePortal:FindFirstChild("PortalModel")
end

local enabledPart: Instance = v10 and v10:FindFirstChild("EnabledPart")
local torus: Instance = v10 and v10:FindFirstChild("Torus")
local v13: Instance = torus and torus:FindFirstChild("Enabled")
local disabled: Instance = torus and torus:FindFirstChild("Disabled")
local v15: Instance = disabled

if v15 then
	v15 = disabled:FindFirstChild("BillboardGui")
end

local desc: Instance = v15 and v15:FindFirstChild("Desc", true)
local v17 = desc and desc:IsA("TextLabel") and desc.Text or "LEVEL 10"

local function setLockCopy(text)
	if desc and desc:IsA("TextLabel") and text ~= desc.Text then
		desc.Text = text
	end
end

if v10 then
	local function applyPortalVisual(enabled)
		if enabledPart and enabledPart:IsA("BasePart") then
			enabledPart.Transparency = if enabled then 0 else 1
		end

		if v13 then
			for _, v in ipairs(v13:GetChildren()) do
				if v:IsA("ParticleEmitter") then
					v.Enabled = enabled
				end
			end
		end

		if v15 and v15:IsA("BillboardGui") then
			v15.Enabled = not enabled
		end
	end
	local function refreshPortalVisual()
		local v32 = tradePublicFlags.MinTradeLevel()
		local numberValue: number? = tonumber(LocalPlayer:GetAttribute("Level"))
		local v34 = tradingPlazaGate.IsOpen()
		local u35: boolean = true

		if not (v32 <= 0) then
			u35 = v32 <= (numberValue or 1)
		end

		applyPortalVisual(v34 and u35)

		if not v34 then
			local v36 = tradingPlazaGate.SecondsUntilOpen()
			local text = ("Finalising trading updates!\nCome back in %d:%02d"):format(v36 // 60, v36 % 60)

			if desc and desc:IsA("TextLabel") and text ~= desc.Text then
				desc.Text = text

				return
			end
		else
			local v38 = v17

			if not u35 and desc and desc:IsA("TextLabel") and v38 ~= desc.Text then
				desc.Text = v38
			end
		end
	end

	task.spawn(function()
		while true do
			if tradingPlazaGate.IsOpen() then
				break
			end

			task.wait(1)
			refreshPortalVisual()
		end

		refreshPortalVisual()
	end)
	refreshPortalVisual()
	LocalPlayer:GetAttributeChangedSignal("Level"):Connect(refreshPortalVisual)
	tradePublicFlags.OnChanged("MinTradeLevel", refreshPortalVisual)
end

local bindables: Instance = replicatedStorage:WaitForChild("Bindables")
local plazaTeleport: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("PlazaTeleport")
local openPlazaServerList: Instance = bindables:WaitForChild("OpenPlazaServerList", 10)
local n1 = tradeTeleportPart.Size.Magnitude / 2 + 5
local u25: boolean = false
local n2: number = 0
local u27: boolean = false

setLockCopy = function()
	local Character: Model = LocalPlayer.Character
	local humanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart and humanoidRootPart:IsA("BasePart") then
		return humanoidRootPart
	end

	return nil
end
plazaTeleport.OnClientEvent:Connect(function(p3)
	if p3 == "failed" and u27 then
		u27 = false
		n2 += 1
		screenWipe.reveal(0.5)
		u25 = false
	end
end)
tradeTeleportPart.Touched:Connect(function(p4)
	if u25 then
		return
	end

	local Character: Model = LocalPlayer.Character

	if not Character or not p4:IsDescendantOf(Character) then
		return
	end

	local Character2: Model = LocalPlayer.Character
	local humanoidRootPart = Character2 and Character2:FindFirstChild("HumanoidRootPart")

	if not (if humanoidRootPart and humanoidRootPart:IsA("BasePart") then humanoidRootPart else nil) then
		return
	end

	u25 = true

	if not tradingPlazaGate.IsOpen() then
		if _G.Notify then
			_G.Notify({
				notifType = "FailNotification",
				errorMessage = "The Trading Plaza isn't open yet!"
			})
		end

		task.wait(2)
		u25 = false

		return
	end

	local v46 = tradePublicFlags.MinTradeLevel()

	if v46 > 0 and v46 > (tonumber(LocalPlayer:GetAttribute("Level")) or 1) then
		if _G.Notify then
			local _GNotify = _G.Notify
			local v48 = ("You must be Level %d to enter."):format(v46)

			_GNotify({ notifType = "FailNotification", errorMessage = v48 })
		end

		task.wait(2)
		u25 = false

		return
	end

	local plazaTeleportChoice: Instance = bindables:WaitForChild("PlazaTeleportChoice", 5)

	if not plazaTeleportChoice then
		u25 = false

		return
	end

	local plazaTeleportChoiceCancel: Instance = bindables:FindFirstChild("PlazaTeleportChoiceCancel")
	local u51: boolean = true

	if plazaTeleportChoiceCancel then
		task.spawn(function()
			while u51 do
				local Character3: Model = LocalPlayer.Character
				local humanoidRootPart = Character3 and Character3:FindFirstChild("HumanoidRootPart")
				local v56 = if humanoidRootPart and humanoidRootPart:IsA("BasePart") then humanoidRootPart else nil

				if not v56 or (v56.Position - tradeTeleportPart.Position).Magnitude > n1 then
					if not u51 then
						break
					end

					plazaTeleportChoiceCancel:Fire()

					return
				end

				task.wait(0.1)
			end
		end)
	end

	local v52 = plazaTeleportChoice:Invoke({ Header = "Trading Plaza", Body = "Teleport to the Trading Plaza?" })

	u51 = false

	if v52 == "servers" then
		if openPlazaServerList then
			openPlazaServerList:Fire()
		end

		task.wait(0.75)
		u25 = false

		return
	end

	if v52 == "teleport" then
		n2 += 1

		local v53: number = n2

		u27 = true
		screenWipe.cover(0.5, "Teleporting to Trading Plaza")
		plazaTeleport:FireServer()
		task.delay(12, function()
			if n2 ~= v53 then
				return
			end

			u27 = false
			screenWipe.reveal(0.5)
			u25 = false
		end)

		return
	end

	task.wait(0.75)
	u25 = false
end)
