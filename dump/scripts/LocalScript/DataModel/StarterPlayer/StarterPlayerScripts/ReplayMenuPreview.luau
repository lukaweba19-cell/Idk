-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local shared: Instance = replicatedStorage:WaitForChild("Shared")
local replayControlMenu = require(shared:WaitForChild("ReplayControlMenu"))
local replayMenuPreview: Instance = replicatedStorage:WaitForChild("Remotes"):WaitForChild("ReplayMenuPreview")
local LocalPlayer: Player = players.LocalPlayer
local u7 = nil
local u8 = nil

local function teardown()
	if u8 then
		pcall(function()
			u8:Destroy()
		end)
		u8 = nil
	end

	if u7 then
		pcall(function()
			u7:Destroy()
		end)
		u7 = nil
	end
end
local function open()
	teardown()

	local replayMenuPreview: ScreenGui = Instance.new("ScreenGui")

	replayMenuPreview.Name = "ReplayMenuPreview"
	replayMenuPreview.ResetOnSpawn = false
	replayMenuPreview.IgnoreGuiInset = true
	replayMenuPreview.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	replayMenuPreview.DisplayOrder = 50
	replayMenuPreview.Parent = LocalPlayer:WaitForChild("PlayerGui")
	u7 = replayMenuPreview
	u8 = replayControlMenu.new({
		inert = true,
		parent = replayMenuPreview,
		actions = {
			togglePlay = function()
			end,
			step = function(_)
			end,
			speed = function(_)
			end,
			round = function(_)
			end,
			player = function(_)
			end,
			cycleCam = function()
			end,
			toggleXRay = function()
			end,
			exit = function()
				teardown()
			end
		}
	})

	if not u8 then
		warn("[ReplayMenuPreview] clone failed -- HUD.SettingsWindow moved or was restyled")
		teardown()

		return
	end

	u8:SetState({
		playing = true,
		speed = 1,
		camera = "Third",
		xray = false,
		playerName = LocalPlayer.DisplayName
	})
	u8:Open()
end

replayMenuPreview.OnClientEvent:Connect(function(p5)
	if p5 == "close" then
		teardown()

		return
	end

	local ok, result = pcall(open)

	if not ok then
		local text: string = tostring(result)

		warn("[ReplayMenuPreview] failed: " .. text)
		teardown()
	end
end)
