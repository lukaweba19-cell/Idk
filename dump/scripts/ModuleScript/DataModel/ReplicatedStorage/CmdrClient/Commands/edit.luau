-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local players: Players = game:GetService("Players")
local color3 = Color3.fromRGB(17, 17, 17)
local color32 = Color3.fromRGB(17, 17, 17)
local code = Enum.Font.Code
local color33 = Color3.fromRGB(241, 241, 241)
local u6 = nil
local t1: {[any]: any} = {
	BackgroundTransparency = 0.05,
	BorderSizePixel = 20,
	ClearTextOnFocus = false,
	MultiLine = true,
	TextWrapped = true,
	TextSize = 18,
	TextXAlignment = "Left",
	TextYAlignment = "Top",
	AutoLocalize = false,
	PlaceholderText = "Right click to exit",
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = color3,
	BorderColor3 = color32,
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.new(0.5, 0, 0.4, 0),
	Font = code,
	TextColor3 = color33
}

return {
	Name = "edit",
	Description = "Edit text in a TextBox",
	Group = "DefaultUtil",
	Aliases = {},
	Args = {
		{
			Type = "string",
			Name = "Input text",
			Description = "The text you wish to edit",
			Default = ""
		},
		{
			Type = "string",
			Name = "Delimiter",
			Description = "The character that separates each line",
			Default = ","
		}
	},
	ClientRun = function(p1, p2, p3)
		u6 = u6 or p1.Cmdr.Util.Mutex()

		local v11 = u6()

		p1:Reply("Right-click on the text area to exit.", Color3.fromRGB(158, 158, 158))

		local cmdrEditBox: ScreenGui = Instance.new("ScreenGui")

		cmdrEditBox.Name = "CmdrEditBox"
		cmdrEditBox.ResetOnSpawn = false

		local textBox: TextBox = Instance.new("TextBox")

		for k, v in pairs(t1) do
			textBox[k] = v
		end

		textBox.Text = p2:gsub(p3, "\n")
		textBox.Parent = cmdrEditBox
		cmdrEditBox.Parent = players.LocalPlayer:WaitForChild("PlayerGui")

		local v16 = coroutine.running()

		textBox.InputBegan:Connect(function(input: InputObject)
			if input.UserInputType == Enum.UserInputType.MouseButton2 then
				coroutine.resume(v16, textBox.Text:gsub("\n", p3))
				cmdrEditBox:Destroy()
				v11()
			end
		end)

		return coroutine.yield()
	end
}
