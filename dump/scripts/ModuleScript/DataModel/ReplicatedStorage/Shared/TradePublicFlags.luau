-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
return {
	MinTradeLevel = function()
		return tonumber(script:GetAttribute("MinTradeLevel")) or 10
	end,
	TradeHistoryPublic = function()
		return script:GetAttribute("TradeHistoryPublic") ~= false
	end,
	QuickChatEnabled = function()
		return script:GetAttribute("QuickChatEnabled") ~= false
	end,
	RapSummaryEnabled = function()
		return script:GetAttribute("RapSummaryEnabled") ~= false
	end,
	PlazaRapEnabled = function()
		return script:GetAttribute("PlazaRapEnabled") ~= false
	end,
	OnChanged = function(p1, p2)
		return script:GetAttributeChangedSignal(p1):Connect(p2)
	end,
	_Publish = function(p3, p4)
		script:SetAttribute(p3, p4)
	end
}
