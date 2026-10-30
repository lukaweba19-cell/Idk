-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return function(p1, p2)
	local notice: Frame = Instance.new("Frame")

	notice.Name = "Notice"
	notice.ZIndex = 25
	notice.AutomaticSize = Enum.AutomaticSize.X
	notice.BorderColor3 = Color3.fromRGB(0, 0, 0)
	notice.BorderSizePixel = 0
	notice.BackgroundTransparency = 0.1
	notice.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	notice.Visible = false
	notice.Parent = p1.widget

	local uiCorner: UICorner = Instance.new("UICorner")

	uiCorner.CornerRadius = UDim.new(1, 0)
	uiCorner.Parent = notice

	local uiStroke: UIStroke = Instance.new("UIStroke")

	uiStroke.Parent = notice

	local noticeLabel: TextLabel = Instance.new("TextLabel")

	noticeLabel.Name = "NoticeLabel"
	noticeLabel.ZIndex = 26
	noticeLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	noticeLabel.AutomaticSize = Enum.AutomaticSize.X
	noticeLabel.Size = UDim2.new(1, 0, 1, 0)
	noticeLabel.BackgroundTransparency = 1
	noticeLabel.Position = UDim2.new(0.5, 0, 0.515, 0)
	noticeLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	noticeLabel.FontSize = Enum.FontSize.Size14
	noticeLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
	noticeLabel.Text = "1"
	noticeLabel.TextWrapped = true
	noticeLabel.TextWrap = true
	noticeLabel.Font = Enum.Font.Arial
	noticeLabel.Parent = notice

	local ParentParent: Instance = script.Parent.Parent
	local packages = ParentParent.Packages
	local janitor = require(packages.Janitor)
	local goodSignal = require(packages.GoodSignal)
	local utility = require(ParentParent.Utility)

	p1.noticeChanged:Connect(function(p3)
		if not p3 then
			return
		end

		local u13 = p3 > 99

		noticeLabel.Text = if u13 then "99+" else p3

		if u13 then
			noticeLabel.TextSize = 11
		end

		local u14: boolean = true

		if p3 < 1 then
			u14 = false
		end

		u13 = p2.getIconByUID(p1.parentIconUID)

		local u15: boolean = true

		if not (#p1.dropdownIcons > 0) then
			u15 = #p1.menuIcons > 0
		end

		if p1.isSelected and u15 or u13 and not u13.isSelected then
			u14 = false
		end

		utility.setVisible(notice, u14, "NoticeHandler")
	end)
	p1.noticeStarted:Connect(function(p4, p5)
		if not p4 then
			p4 = p1.deselected
		end

		local v18 = p2.getIconByUID(p1.parentIconUID)

		if v18 then
			v18:notify(p4)
		end

		local v19 = p1.janitor:add(janitor.new())
		local v20 = v19:add(goodSignal.new())

		v19:add(p1.endNotices:Connect(function()
			v20:Fire()
		end))
		v19:add(p4:Connect(function()
			v20:Fire()
		end))

		local u21 = p5 or utility.generateUID()

		p1.notices[u21] = { completeSignal = v20, clearNoticeEvent = p4 }

		local function updateNotice()
			p1.noticeChanged:Fire(p1.totalNotices)
		end

		p1.notified:Fire(u21)

		local v23 = p1

		v23.totalNotices = v23.totalNotices + 1
		p1.noticeChanged:Fire(p1.totalNotices)
		v20:Once(function()
			v19:destroy()

			local v24 = p1

			v24.totalNotices = v24.totalNotices - 1
			p1.notices[u21] = nil
			p1.noticeChanged:Fire(p1.totalNotices)
		end)
	end)
	notice:SetAttribute("ClipToJoinedParent", true)
	p1:clipOutside(notice)

	return notice
end
