-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
game:GetService("Players")

local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local v2: boolean = game:GetService("RunService"):IsClient()

assert(v2, "HighlightPools is client-only -- requiring this from the server is a bug")

local util: Instance = replicatedStorage:WaitForChild("Util")
local highlightPool = require(util:WaitForChild("HighlightPool"))
local __HighlightPool = workspace:FindFirstChild("__HighlightPool")

if not __HighlightPool then
	__HighlightPool = Instance.new("Folder")
	__HighlightPool.Name = "__HighlightPool"
	__HighlightPool.Parent = workspace
end

return {
	Effect = highlightPool.new({ name = "EffectHL", size = 12, parent = __HighlightPool })
}
