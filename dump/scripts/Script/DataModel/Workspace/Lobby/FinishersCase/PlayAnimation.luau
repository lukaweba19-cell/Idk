-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Original SourceAssetId: https://assetdelivery.roblox.com/v1/asset/?id=6415231943

-- ! Source from the asset above; the game may have edited it since.

--[[
--made by zastrxzer :)

--WATCH THE TUTORIAL FOR HOW TO MAKE THIS WORK.
local h = script.Parent:WaitForChild("Humanoid")
local a = h:LoadAnimation(script:FindFirstChildOfClass("Animation"))
a.Looped = true
a:Play()
]]

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local animationTrack = script.Parent:WaitForChild("AnimationController").Animator:LoadAnimation(script:FindFirstChildOfClass("Animation"))

animationTrack.Looped = true
animationTrack:Play()
