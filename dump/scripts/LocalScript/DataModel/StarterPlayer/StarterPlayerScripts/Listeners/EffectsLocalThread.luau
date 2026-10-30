-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
game.ReplicatedStorage:WaitForChild("Effect"):WaitForChild("Bindable").Event:Connect(function(p1, p2, p3, p4)
	if p1 == "spawn" then
		p1 = p2
		p2 = p3
		p3 = p4
	end

	if typeof(p1) == "function" then
		return p1()
	end

	if typeof(p1) == "Instance" and p1.ClassName ~= "ModuleScript" and typeof(p2) == "number" then
		task.delay(p2, function()
			p1:Destroy()
		end)

		return
	end

	local function v5(p5)
		p5()
	end

	if p2 and p2.__SilenceError then
		v5 = pcall
	end

	if typeof(require(p1)) == "function" then
		v5(function()
			require(p1)(p2, p3)
		end)
	else
		v5(function()
			require(p1).new(p2):Run()
		end)
	end
end)
