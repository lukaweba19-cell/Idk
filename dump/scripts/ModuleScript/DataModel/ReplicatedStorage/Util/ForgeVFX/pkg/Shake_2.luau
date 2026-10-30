-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
--!native
local runService: RunService = game:GetService("RunService")
local random = Random.new()
local n1: number = 0
local t1: {[any]: any} = {}

t1.__index = t1

function t1.new()
	local object = setmetatable({}, t1)

	object.Amplitude = 1
	object.Frequency = 1
	object.FadeInTime = 1
	object.FadeOutTime = 1
	object.SustainTime = 0
	object.Sustain = false
	object.PositionInfluence = Vector3.new(1, 1, 1)
	object.RotationInfluence = Vector3.new(1, 1, 1)
	object.TimeFunction = if runService:IsRunning() then time else os.clock
	object._timeOffset = random:NextNumber(-1000000, 1000000)
	object._startTime = 0
	object._running = false
	object._signalConnections = {}
	object._renderBindings = {}

	return object
end
function t1.InverseSquare(p1, p2: number)
	if p2 < 1 then
		p2 = 1
	end

	return p1 * (1 / (p2 * p2))
end
function t1.NextRenderName()
	n1 += 1

	return ("__shake_%.4i__"):format(n1)
end
function t1.Start(p3)
	p3._startTime = p3.TimeFunction()
	p3._running = true
end
function t1.Stop(p4)
	p4._running = false

	for iterFirst, iterSecond in p4._renderBindings, nil, nil do
		runService:UnbindFromRenderStep(iterSecond)
	end

	table.clear(p4._renderBindings)

	for iterFirst2, iterSecond2 in p4._signalConnections, nil, nil do
		iterSecond2:Disconnect()
	end

	table.clear(p4._signalConnections)
end
function t1.IsShaking(p5)
	return p5._running
end
function t1.StopSustain(p6)
	local v16 = p6.TimeFunction()

	p6.Sustain = false
	p6.SustainTime = v16 - p6._startTime - p6.FadeInTime
end
function t1.Update(p7)
	local u18: boolean = false
	local v19 = p7.TimeFunction()
	local n1 = v19 - p7._startTime
	local n2 = (v19 + p7._timeOffset) / p7.Frequency % 10000

	v19 = 1

	local n3 = 1

	if n1 < p7.FadeInTime then
		v19 = n1 / p7.FadeInTime
	end

	if not p7.Sustain and n1 > p7.FadeInTime + p7.SustainTime then
		if p7.FadeOutTime == 0 then
			u18 = true
		else
			n3 = 1 - (n1 - p7.FadeInTime - p7.SustainTime) / p7.FadeOutTime

			if not p7.Sustain and n1 >= p7.FadeInTime + p7.SustainTime + p7.FadeOutTime then
				u18 = true
			end
		end
	end

	local v23 = math.noise(n2, 0)
	local v24 = math.noise(0, n2)
	local v25 = math.noise(n2, n2)
	local n4 = Vector3.new(v23 / 2, v24 / 2, v25 / 2) * p7.Amplitude
	local v27 = math.min(v19, n3)

	n1 = n4 * v27

	if u18 then
		p7:Stop()
	end

	return p7.PositionInfluence * n1, p7.RotationInfluence * n1, u18
end
function t1.OnSignal(p8, p9, p10)
	local connection = p9:Connect(function()
		p10(p8:Update())
	end)

	table.insert(p8._signalConnections, connection)

	return connection
end
function t1.BindToRenderStep(p11, p12, p13, p14)
	runService:BindToRenderStep(p12, p13, function()
		p14(p11:Update())
	end)
	table.insert(p11._renderBindings, p12)
end
function t1.Clone(p15)
	local v37 = t1.new()

	for iterFirst, value in {
		"Amplitude",
		"Frequency",
		"FadeInTime",
		"FadeOutTime",
		"SustainTime",
		"Sustain",
		"PositionInfluence",
		"RotationInfluence",
		"TimeFunction"
	}, nil, nil do
		v37[value] = p15[value]
	end

	return v37
end
function t1.Destroy(p16)
	p16:Stop()
end

return {
	new = t1.new,
	InverseSquare = t1.InverseSquare,
	NextRenderName = t1.NextRenderName
}
