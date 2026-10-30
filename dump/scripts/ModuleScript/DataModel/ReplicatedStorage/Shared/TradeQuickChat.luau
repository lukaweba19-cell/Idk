-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local color3 = Color3.fromRGB(60, 140, 255)
local color32 = Color3.fromRGB(80, 220, 110)
local color33 = Color3.fromRGB(255, 225, 60)
local color34 = Color3.fromRGB(235, 50, 50)
local t1: {[any]: any} = {
	{ Id = 1, Text = "Add more!", Category = "Offer" },
	{ Id = 2, Text = "Too much", Category = "Offer" },
	{ Id = 3, Text = "Almost!", Category = "Offer" },
	{ Id = 4, Text = "Fair?", Category = "Offer" },
	{ Id = 5, Text = "Deal!", Category = "Answer" },
	{ Id = 6, Text = "No", Category = "Answer" },
	{ Id = 7, Text = "Maybe", Category = "Answer", Retired = true },
	{ Id = 8, Text = "Wait", Category = "Answer" },
	{ Id = 9, Text = "Hi!", Category = "Social", Retired = true },
	{ Id = 10, Text = "Thanks!", Category = "Social" },
	{ Id = 11, Text = "Bye!", Category = "Social" },
	{ Id = 12, Text = "Good luck!", Category = "Social", Retired = true },
	{ Id = 13, Text = "😀", Category = "Emote", Retired = true },
	{ Id = 14, Text = "😢", Category = "Emote", Retired = true },
	{ Id = 15, Text = "I want", Category = "Offer", Want = true },
	{
		Id = 16,
		Text = "Sad",
		Category = "Emote",
		Image = "rbxassetid://91460247523478",
		BubbleColor = color3
	},
	{
		Id = 17,
		Text = "Meh",
		Category = "Emote",
		Image = "rbxassetid://126597034621906",
		BubbleColor = color32
	},
	{
		Id = 18,
		Text = "Happy",
		Category = "Emote",
		Image = "rbxassetid://114140179463788",
		BubbleColor = color33
	},
	{
		Id = 19,
		Text = "Angry",
		Category = "Emote",
		Image = "rbxassetid://128635345440461",
		BubbleColor = color34
	},
	{ Id = 20, Text = "OK", Category = "Answer" },
	{ Id = 21, Text = "Last offer", Category = "Offer" }
}
local module: {[any]: any} = {
	Categories = { "Offer", "Answer", "Social", "Emote" },
	Phrases = t1,
	WANT_ID = 15,
	BUCKET_MAX = 4,
	BUCKET_REGEN_SEC = 1.5,
	SESSION_MAX = 60,
	BUBBLE_SECONDS = 3.5
}
local t3: {[any]: any} = {}

for _, v in ipairs(t1) do
	t3[v.Id] = v
end

function module.Get(p1)
	if typeof(p1) == "number" and p1 == p1 then
		return t3[p1]
	end

	return nil
end
function module.IsSendable(p2)
	local v12 = module.Get(p2)

	return v12 ~= nil and v12.Retired ~= true
end
function module.IsWant(p3)
	local v14 = module.Get(p3)

	return v14 ~= nil and v14.Want == true
end
function module.InCategory(p4)
	local t4: {[any]: any} = {}

	for _, v in ipairs(t1) do
		if p4 == v.Category and v.Retired ~= true then
			table.insert(t4, v)
		end
	end

	return t4
end

return module
