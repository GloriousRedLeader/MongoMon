--[[
	Copyright (C) 2018  Fuhrbolg - Hyjal

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>

	Author's note: Under no circumstances should this Addon be used under any situation.
	It is dangerous and will cause significant harm to your computer. You have been warned.
--]]

--[[
 -	Import variables from other MongoMon source files here.
--]]
local ADDON_NAME, T = ...
local SPEC_ID_ICONS = T["SPEC_ID_ICONS"]
local CLASS_TOKEN_COLORS = T["CLASS_TOKEN_COLORS"]
local MAX_PLAYER_RANK = T["MAX_PLAYER_RANK"]
local MAX_NAMEPLATE_RANK = T["MAX_NAMEPLATE_RANK"]
local BG_MAP_IDS = T["BG_MAP_IDS"]
local SEND_TO_CHAT_COOLDOWN = T["SEND_TO_CHAT_COOLDOWN"]
local DEBUG_ENABLED = T["DEBUG_ENABLED"]
local MatchHistoryRecord = T["MatchHistoryRecord"]
local MatchHistoryService = T["MatchHistoryService"]
local TEXT_COLOR = T["TEXT_COLOR"]
local NO_CREDIT = T["NO_CREDIT"]
local spairs = T["spairs"]
local prettyNumber = T["prettyNumber"]
local tablelength = T["tablelength"]
local round = T["round"]
local strsplit = T["strsplit"]
local ScrollingTable = LibStub("ScrollingTable")
local L = LibStub("AceLocale-3.0"):GetLocale("MongoMon")

-- Applied to the background textures
local ALPHA_VALUE = 0.40

-- These are the two primary backgrounds for our scoreboard. The only difference is the border texture
-- which becomes more prominent when the player is in the top 5 killing blows. The gradient change 
-- occurs elsewhere and for different reasons.
local BACKDROP_RED = {
	bgFile = "Interface\\AddOns\\MongoMon\\Res\\RedAlphaBackground", 
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
	edgeSize = 30,
	insets = { left = 8, right = 8, top = 8, bottom = 8 }
}

local BACKDROP_GREEN = {
	bgFile = "Interface\\AddOns\\MongoMon\\Res\\GreenAlphaBackground", 
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
	edgeSize = 30,
	insets = { left = 8, right = 8, top = 8, bottom = 8 }
}

local BACKDROP_BAD = {
	bgFile = "Interface\\AddOns\\MongoMon\\Res\\BlackAlphaBackground", 
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	edgeSize = 30,
	insets = { left = 8, right = 8, top = 8, bottom = 8 }
}

--[[
 -	Wow UI frame creation. This contains the Personal scoreboard frame
 -	as well as the Match History UI panel that shows a detailed list of
 -	past BG matches as well as a summary of stats like win percentage
 -	and yoru overall derp rank.
--]]

-- So everything in this game that is event related must be part of a widget.
local mongoMonFrame = CreateFrame("FRAME", "MongoMonFrame")

-- Scoreboard frame that will display Kill - Death in BG's
local scoreFrame = CreateFrame("FRAME", "MongoMonScoreFrame")
scoreFrame:SetMovable(true)
scoreFrame:EnableMouse(true)
scoreFrame:RegisterForDrag("LeftButton")
scoreFrame:SetScript("OnDragStart", scoreFrame.StartMoving)
scoreFrame:SetScript("OnDragStop", scoreFrame.StopMovingOrSizing)
scoreFrame:SetPoint("CENTER")
scoreFrame:SetWidth(200)
scoreFrame:SetHeight(125)
scoreFrame:SetBackdrop(BACKDROP_BAD)
scoreFrame:SetScript("OnMouseUp", function(self, button) -- Toggle the actual bg scoreboard when you press this.
	LibStub("LibButtonGlow-1.0").ShowOverlayGlow(scoreFrame)
	LibStub("LibButtonGlow-1.0").HideOverlayGlow(scoreFrame)	
	TogglePVPScoreboardOrResults()
end)

-- Gradient background overlay, this makes the empty icons look better
scoreFrame.backgroundFrame = CreateFrame("FRAME", nil, scoreFrame)
scoreFrame.backgroundFrame:SetPoint("CENTER", scoreFrame, "CENTER", 0, 0)
scoreFrame.backgroundFrame:SetSize(185, 90)
scoreFrame.backgroundTexture = scoreFrame.backgroundFrame:CreateTexture()
scoreFrame.backgroundTexture:SetAlpha(0.15)
scoreFrame.backgroundTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\ScoreboardBackground")
scoreFrame.backgroundTexture:SetAllPoints()

-- Top row icon: Killing Blow rank
scoreFrame.rankFrame = CreateFrame("FRAME", nil, scoreFrame)
scoreFrame.rankFrame:SetPoint("TOPLEFT", scoreFrame, "TOPLEFT", 25, -12)
scoreFrame.rankFrame:SetSize(40, 40)
scoreFrame.rankTexture = scoreFrame.rankFrame:CreateTexture()
scoreFrame.rankTexture:SetAlpha(ALPHA_VALUE)
scoreFrame.rankTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\RankCrestGrayBackground")
scoreFrame.rankTexture:SetAllPoints()
scoreFrame.rankTitle = scoreFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
scoreFrame.rankTitle:SetPoint("TOPLEFT", scoreFrame.rankTexture, "BOTTOMLEFT", -10, 0) 
scoreFrame.rankTitle:SetSize(60, 20)
scoreFrame.rankTitle:SetText(L["RankTitle"])

-- Top row icon: Top Damage Icon
scoreFrame.topDamageFrame = CreateFrame("FRAME", nil, scoreFrame)
scoreFrame.topDamageFrame:SetPoint("TOP", scoreFrame, "TOP", 0, -12)
scoreFrame.topDamageFrame:SetSize(40, 40)
scoreFrame.topDamageTexture = scoreFrame.topDamageFrame:CreateTexture()
scoreFrame.topDamageTexture:SetAlpha(ALPHA_VALUE)
scoreFrame.topDamageTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\RankCrestGrayBackground")
scoreFrame.topDamageTexture:SetAllPoints()
scoreFrame.topDamageTitle = scoreFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
scoreFrame.topDamageTitle:SetPoint("TOPLEFT", scoreFrame.topDamageTexture, "BOTTOMLEFT", -10, 0)
scoreFrame.topDamageTitle:SetSize(60, 20)
scoreFrame.topDamageTitle:SetText(L["TopDamageTitle"])

-- Top row icon: No Death
scoreFrame.noDeathFrame = CreateFrame("FRAME", nil, scoreFrame)
scoreFrame.noDeathFrame:SetPoint("TOPRIGHT", scoreFrame, "TOPRIGHT", -25, -12)
scoreFrame.noDeathFrame:SetSize(40, 40)
scoreFrame.noDeathTexture = scoreFrame.noDeathFrame:CreateTexture()
scoreFrame.noDeathTexture:SetAlpha(ALPHA_VALUE)
scoreFrame.noDeathTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\RankCrestGrayBackground")
scoreFrame.noDeathTexture:SetAllPoints()
scoreFrame.noDeathTitle = scoreFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
scoreFrame.noDeathTitle:SetPoint("TOPLEFT", scoreFrame.noDeathTexture, "BOTTOMLEFT", -10, 0) 
scoreFrame.noDeathTitle:SetSize(60, 20)
scoreFrame.noDeathTitle:SetText(L["NoDeathTitle"])

-- Title 
scoreFrame.title = scoreFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightOutline")
scoreFrame.title:SetPoint("BOTTOM", scoreFrame, "TOP", 0, -5)
scoreFrame.title:SetText(L["Title"])

-- Kill - Death Fontstring
scoreFrame.killDeathFontString = scoreFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
scoreFrame.killDeathFontString:SetPoint("TOP", scoreFrame, 0, -70) 

-- Damage / healing fontstring
scoreFrame.damageHealingFontString = scoreFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
scoreFrame.damageHealingFontString:SetPoint("TOP", scoreFrame, 0, -85)

scoreFrame.damageHealingDiffFontString = scoreFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
scoreFrame.damageHealingDiffFontString:SetPoint("TOP", scoreFrame, 0, -100)

-- Kill player - spell indicator frame
scoreFrame.killFlashFrame = CreateFrame("FRAME", nil, scoreFrame)
scoreFrame.killFlashFrame:SetPoint("BOTTOMLEFT", scoreFrame, "TOPLEFT", 0, 15)
scoreFrame.killFlashFrame:SetSize(200, 40)

scoreFrame.killFlashFrame.titleFontString = scoreFrame.killFlashFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
scoreFrame.killFlashFrame.titleFontString:SetPoint("BOTTOM", scoreFrame.killFlashFrame, "TOP", 0, 0)
scoreFrame.killFlashFrame.titleFontString:SetText(L["KillingBlow"])

scoreFrame.killFlashFrame.spellIconFrame = CreateFrame("FRAME", nil, scoreFrame.killFlashFrame)
scoreFrame.killFlashFrame.spellIconFrame:SetPoint("TOPLEFT", scoreFrame.killFlashFrame, "TOPLEFT", 0, 0)
scoreFrame.killFlashFrame.spellIconFrame:SetSize(20, 20)

scoreFrame.killFlashFrame.spellIconTexture = scoreFrame.killFlashFrame.spellIconFrame:CreateTexture()
scoreFrame.killFlashFrame.spellIconTexture:SetTexture(GetSpellTexture("Mind Blast"))
scoreFrame.killFlashFrame.spellIconTexture:SetAllPoints()

scoreFrame.killFlashFrame.spellFontString = scoreFrame.killFlashFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightOutline")
scoreFrame.killFlashFrame.spellFontString:SetPoint("LEFT", scoreFrame.killFlashFrame.spellIconFrame, "RIGHT", 10, 0)
scoreFrame.killFlashFrame.spellFontString:SetText("192.5k Mind Blast")

scoreFrame.killFlashFrame.targetIconFrame = CreateFrame("FRAME", nil, scoreFrame.killFlashFrame)
scoreFrame.killFlashFrame.targetIconFrame:SetPoint("TOPLEFT", scoreFrame.killFlashFrame.spellIconFrame, "BOTTOMLEFT", 0, -5)
scoreFrame.killFlashFrame.targetIconFrame:SetSize(20, 20)

scoreFrame.killFlashFrame.targetIconTexture = scoreFrame.killFlashFrame.targetIconFrame:CreateTexture()
scoreFrame.killFlashFrame.targetIconTexture:SetTexture("Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES"); -- this is the image containing all class icons
scoreFrame.killFlashFrame.targetIconTexture:SetTexCoord(unpack(CLASS_ICON_TCOORDS["PRIEST"]));
scoreFrame.killFlashFrame.targetIconTexture:SetAllPoints()

scoreFrame.killFlashFrame.targetFontString = scoreFrame.killFlashFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightOutline")
scoreFrame.killFlashFrame.targetFontString:SetPoint("LEFT", scoreFrame.killFlashFrame.targetIconFrame, "RIGHT", 10, 0)
scoreFrame.killFlashFrame.targetFontString:SetText("Ponchoface - Skullcrusher")

scoreFrame.killFlashFrame.animationGroup = scoreFrame.killFlashFrame:CreateAnimationGroup() 

local animIn = scoreFrame.killFlashFrame.animationGroup:CreateAnimation("Alpha")
animIn:SetFromAlpha(0)
animIn:SetToAlpha(1)
animIn:SetDuration(2)
animIn:SetOrder(1)
animIn:SetSmoothing("OUT")

local animOut = scoreFrame.killFlashFrame.animationGroup:CreateAnimation("Alpha")
animOut:SetFromAlpha(1)
animOut:SetStartDelay(3)
animOut:SetToAlpha(0)
animOut:SetDuration(4)
animOut:SetOrder(2)
animOut:SetSmoothing("OUT")
animOut:SetScript("OnFinished", function(self) 
	scoreFrame.killFlashFrame:Hide()  
end)
scoreFrame.killFlashFrame:Hide()

--[[
 -	Kill History Statistics
 -
 -	This screen provides statistics over the span of multiple battlegrounds 
 -	regarding killing blows and victims.
--]]

local killHistoryFrame = CreateFrame("FRAME", "MongoMonKillHistoryFrame")
killHistoryFrame:SetFrameStrata("HIGH")
killHistoryFrame:SetPoint("CENTER", nil, "CENTER", 0, 0)
killHistoryFrame:SetWidth(830)
killHistoryFrame:SetHeight(685)
killHistoryFrame:SetBackdrop(BACKDROP_BAD)
killHistoryFrame:SetMovable(true)
killHistoryFrame:EnableMouse(true)
killHistoryFrame:RegisterForDrag("LeftButton")
killHistoryFrame:SetScript("OnDragStart", killHistoryFrame.StartMoving)
killHistoryFrame:SetScript("OnDragStop", killHistoryFrame.StopMovingOrSizing)
killHistoryFrame:SetScript("OnMouseUp", function(self, button)
	killHistoryFrame:Hide()
end)

killHistoryFrame.title = killHistoryFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightOutline")
killHistoryFrame.title:SetPoint("BOTTOM", killHistoryFrame, "TOP", 0, -5)
killHistoryFrame.title:SetText(L["TitleAndAuthor"])

killHistoryFrame.backgroundFrame = CreateFrame("FRAME", nil, killHistoryFrame)
killHistoryFrame.backgroundFrame:SetFrameLevel(0)
killHistoryFrame.backgroundFrame:SetPoint("CENTER", killHistoryFrame, "CENTER", 0, 0)
killHistoryFrame.backgroundFrame:SetSize(820, 675)
killHistoryFrame.backgroundTexture = killHistoryFrame.backgroundFrame:CreateTexture()
killHistoryFrame.backgroundTexture:SetAlpha(ALPHA_VALUE)
killHistoryFrame.backgroundTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\ScoreboardBackground")
killHistoryFrame.backgroundTexture:SetAllPoints()

killHistoryFrame.descriptionFontString = killHistoryFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
killHistoryFrame.descriptionFontString:SetPoint("TOP", killHistoryFrame, "TOP", 0, -15) 

killHistoryFrame.killingBlowSpellTitle = killHistoryFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
killHistoryFrame.killingBlowSpellTitle:SetPoint("TOP", killHistoryFrame.descriptionFontString, "BOTTOM", 0, -10) 
killHistoryFrame.killingBlowSpellTitle:SetText(L["KillingBlowTitle"])

killHistoryFrame.topKillingBlowSpellsFrame = CreateFrame("FRAME", nil, killHistoryFrame)
killHistoryFrame.topKillingBlowSpellsFrame:SetPoint("TOP", killHistoryFrame.killingBlowSpellTitle, "BOTTOM", 0, -5)
killHistoryFrame.topKillingBlowSpellsFrame:SetSize(750, 125)

killHistoryFrame.separatorFrame = CreateFrame("FRAME", nil, killHistoryFrame)
killHistoryFrame.separatorFrame:SetPoint("TOP", killHistoryFrame.topKillingBlowSpellsFrame, "BOTTOM", 0, -5)
killHistoryFrame.separatorFrame:SetSize(750, 5)
killHistoryFrame.separatorTexture = killHistoryFrame.separatorFrame:CreateTexture()
killHistoryFrame.separatorTexture:SetAlpha(ALPHA_VALUE)
killHistoryFrame.separatorTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\ScoreboardBackground")
killHistoryFrame.separatorTexture:SetAllPoints()

killHistoryFrame.playerSummaryFontString = killHistoryFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
killHistoryFrame.playerSummaryFontString:SetPoint("TOP", killHistoryFrame.separatorFrame, "BOTTOM", 0, -5) 

killHistoryFrame.scrollingFrameContainer = CreateFrame("FRAME", nil, killHistoryFrame)
killHistoryFrame.scrollingFrameContainer:SetPoint("TOP", killHistoryFrame.separatorFrame, "TOP", 0, -30)
killHistoryFrame.scrollingFrameContainer:SetSize(750, 450)

killHistoryFrame.footerFontString = killHistoryFrame:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
killHistoryFrame.footerFontString:SetPoint("BOTTOM", killHistoryFrame, "BOTTOM", 0, 11) 
killHistoryFrame.footerFontString:SetText(L["TouchToClose"])

--[[
 -	Manages sorting of certain column using ScrollingTable (ace plugin). The API for sorting
 -	is not very clear, the example is flat out wrong. But this seems to get the job done. We
 -	use it for hard to sort columns like date and amount.
 -
 -	@param ScrollingTable ref
 -	@param int cella
 -	@param int cellb
 -	@param int colindex
 -	@return boolean
--]]
local function scrollTableSort(ref, cella, cellb, colindex)
	local obja = ref:GetCell(cella, colindex)
	local objb = ref:GetCell(cellb, colindex)
	local sortorder = ref.cols[colindex].sort
	local valuea, valueb = 0, 0
	if obja then
		valuea = obja.args[1]
	end
	if objb then
		valueb = objb.args[1]
	end
	if sortorder == "asc" then
		return valuea < valueb
	else
		return valuea > valueb
	end
end

local cols = {
	{
		["name"] = L["Date"],
		["width"] = 150,
		["align"] = "LEFT",
		["defaultsort"] = "dsc",
		["comparesort"] = scrollTableSort
	},
	{
		["name"] = L["Player"],
		["width"] = 200,
		["align"] = "LEFT",
		["defaultsort"] = "dsc"
	},
	{
		["name"] = L["Spell"],
		["width"] = 150,
		["align"] = "LEFT",
		["defaultsort"] = "dsc"
	},
	{
		["name"] = L["Amount"],
		["width"] = 100,
		["align"] = "LEFT",
		["defaultsort"] = "dsc",
		["comparesort"] = scrollTableSort
	},
	{
		["name"] = L["Battleground"],
		["width"] = 125,
		["align"] = "LEFT",
		["defaultsort"] = "dsc"
	}
}

-- Author's note: I had to modify the ScrollingTable plugin so it will center the scrolling table on the
-- provided parent element. It uses the UIParent to position the table regardless of parent.
-- See: Libs\lib-st\Core.lua
killHistoryFrame.scrollingTable = ScrollingTable:CreateST(cols, 27, nil, nil, killHistoryFrame.scrollingFrameContainer)

--[[
 -	Match History Statistics
 -
 -	This screen provides statistics over the span of multiple battlegrounds.
--]]

local matchHistoryFrame = CreateFrame("FRAME", "MongoMonMatchHistoryFrame")
matchHistoryFrame:SetFrameStrata("HIGH")
matchHistoryFrame:SetPoint("CENTER", nil, "CENTER", 0, 0)
matchHistoryFrame:SetWidth(930)
matchHistoryFrame:SetHeight(685)
matchHistoryFrame:SetBackdrop(BACKDROP_BAD)
matchHistoryFrame:SetMovable(true)
matchHistoryFrame:EnableMouse(true)
matchHistoryFrame:RegisterForDrag("LeftButton")
matchHistoryFrame:SetScript("OnDragStart", matchHistoryFrame.StartMoving)
matchHistoryFrame:SetScript("OnDragStop", matchHistoryFrame.StopMovingOrSizing)
matchHistoryFrame:SetScript("OnMouseUp", function(self, button)
	matchHistoryFrame:Hide()
end)

matchHistoryFrame.title = matchHistoryFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightOutline")
matchHistoryFrame.title:SetPoint("BOTTOM", matchHistoryFrame, "TOP", 0, -5)
matchHistoryFrame.title:SetText(L["TitleAndAuthor"])

matchHistoryFrame.backgroundFrame = CreateFrame("FRAME", nil, matchHistoryFrame)
matchHistoryFrame.backgroundFrame:SetFrameLevel(0)
matchHistoryFrame.backgroundFrame:SetPoint("CENTER", matchHistoryFrame, "CENTER", 0, 0)
matchHistoryFrame.backgroundFrame:SetSize(920, 675)
matchHistoryFrame.backgroundTexture = matchHistoryFrame.backgroundFrame:CreateTexture()
matchHistoryFrame.backgroundTexture:SetAlpha(ALPHA_VALUE)
matchHistoryFrame.backgroundTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\ScoreboardBackground")
matchHistoryFrame.backgroundTexture:SetAllPoints()

matchHistoryFrame.descriptionFontString = matchHistoryFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
matchHistoryFrame.descriptionFontString:SetPoint("TOP", matchHistoryFrame, "TOP", 0, -15) 

matchHistoryFrame.teamSummaryTitleFontString = matchHistoryFrame:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
matchHistoryFrame.teamSummaryTitleFontString:SetPoint("TOP", matchHistoryFrame.descriptionFontString, "BOTTOM", -250, -5) 
matchHistoryFrame.teamSummaryTitleFontString:SetText("Wins vs. Losses")

matchHistoryFrame.teamSummaryFontString = matchHistoryFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
matchHistoryFrame.teamSummaryFontString:SetPoint("TOP", matchHistoryFrame.descriptionFontString, "BOTTOM", -250, -20) 

matchHistoryFrame.playerSummaryTitleFontString = matchHistoryFrame:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
matchHistoryFrame.playerSummaryTitleFontString:SetPoint("TOP", matchHistoryFrame.descriptionFontString, "BOTTOM", 0, -5) 
matchHistoryFrame.playerSummaryTitleFontString:SetText("Kills vs. Deaths")

matchHistoryFrame.playerSummaryFontString = matchHistoryFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
matchHistoryFrame.playerSummaryFontString:SetPoint("TOP", matchHistoryFrame.descriptionFontString, "BOTTOM", 0, -20) 

matchHistoryFrame.mercSummaryTitleFontString = matchHistoryFrame:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
matchHistoryFrame.mercSummaryTitleFontString:SetPoint("TOP", matchHistoryFrame.descriptionFontString, "BOTTOM", 250, -5) 
matchHistoryFrame.mercSummaryTitleFontString:SetText(L["MercMode"])

matchHistoryFrame.mercSummaryFontString = matchHistoryFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
matchHistoryFrame.mercSummaryFontString:SetPoint("TOP", matchHistoryFrame.descriptionFontString, "BOTTOM", 250, -20) 

matchHistoryFrame.separatorFrame = CreateFrame("FRAME", nil, matchHistoryFrame)
matchHistoryFrame.separatorFrame:SetPoint("TOP", matchHistoryFrame.playerSummaryFontString, "BOTTOM", 0, -5)
matchHistoryFrame.separatorFrame:SetSize(850, 5)
matchHistoryFrame.separatorTexture = matchHistoryFrame.separatorFrame:CreateTexture()
matchHistoryFrame.separatorTexture:SetAlpha(ALPHA_VALUE)
matchHistoryFrame.separatorTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\ScoreboardBackground")
matchHistoryFrame.separatorTexture:SetAllPoints()

matchHistoryFrame.footerFontString = matchHistoryFrame:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
matchHistoryFrame.footerFontString:SetPoint("BOTTOM", matchHistoryFrame, "BOTTOM", 0, 11) 
matchHistoryFrame.footerFontString:SetText(L["TouchToClose"])

-- Killing Blows
matchHistoryFrame.killsCrestFrame = CreateFrame("FRAME", nil, matchHistoryFrame)
matchHistoryFrame.killsCrestFrame:SetWidth(85)
matchHistoryFrame.killsCrestFrame:SetHeight(85)
matchHistoryFrame.killsCrestFrame:SetPoint("TOPLEFT", matchHistoryFrame.separatorFrame, "BOTTOMLEFT", 10, -5)

matchHistoryFrame.killsCrestTexture = matchHistoryFrame.killsCrestFrame:CreateTexture()
matchHistoryFrame.killsCrestTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\RankCrestGrayBackground")
matchHistoryFrame.killsCrestTexture:SetAllPoints()

matchHistoryFrame.killsCrestFrame.titleFontString = matchHistoryFrame.killsCrestFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
matchHistoryFrame.killsCrestFrame.titleFontString:SetPoint("TOP", matchHistoryFrame.killsCrestFrame, "BOTTOM", 0, 0) 
matchHistoryFrame.killsCrestFrame.titleFontString:SetJustifyH("CENTER")
matchHistoryFrame.killsCrestFrame.titleFontString:SetText(L["RankTitle"])

matchHistoryFrame.killsCrestFrame.summaryFontString = matchHistoryFrame.killsCrestFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
matchHistoryFrame.killsCrestFrame.summaryFontString:SetPoint("LEFT", matchHistoryFrame.killsCrestFrame, "RIGHT", 10, -10) 
matchHistoryFrame.killsCrestFrame.summaryFontString:SetJustifyH("LEFT")

-- Damage
matchHistoryFrame.topDamageCrestFrame = CreateFrame("FRAME", nil, matchHistoryFrame)
matchHistoryFrame.topDamageCrestFrame:SetWidth(85)
matchHistoryFrame.topDamageCrestFrame:SetHeight(85)
matchHistoryFrame.topDamageCrestFrame:SetPoint("TOP", matchHistoryFrame.killsCrestFrame, "BOTTOM", 0, -30)

matchHistoryFrame.topDamageCrestTexture = matchHistoryFrame.topDamageCrestFrame:CreateTexture()
matchHistoryFrame.topDamageCrestTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\RankCrestGrayBackground")
matchHistoryFrame.topDamageCrestTexture:SetAllPoints()

matchHistoryFrame.topDamageCrestFrame.titleFontString = matchHistoryFrame.topDamageCrestFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
matchHistoryFrame.topDamageCrestFrame.titleFontString:SetPoint("TOP", matchHistoryFrame.topDamageCrestFrame, "BOTTOM", 0, 0) 
matchHistoryFrame.topDamageCrestFrame.titleFontString:SetJustifyH("CENTER")
matchHistoryFrame.topDamageCrestFrame.titleFontString:SetText(L["TopDamageTitle"])

matchHistoryFrame.topDamageCrestFrame.summaryFontString = matchHistoryFrame.topDamageCrestFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
matchHistoryFrame.topDamageCrestFrame.summaryFontString:SetPoint("LEFT", matchHistoryFrame.topDamageCrestFrame, "RIGHT", 10, -10) 
matchHistoryFrame.topDamageCrestFrame.summaryFontString:SetJustifyH("LEFT")

-- Healing
matchHistoryFrame.topHealingCrestFrame = CreateFrame("FRAME", nil, matchHistoryFrame)
matchHistoryFrame.topHealingCrestFrame:SetWidth(85)
matchHistoryFrame.topHealingCrestFrame:SetHeight(85)
matchHistoryFrame.topHealingCrestFrame:SetPoint("TOP", matchHistoryFrame.topDamageCrestFrame, "BOTTOM", 0, -30)

matchHistoryFrame.topHealingCrestTexture = matchHistoryFrame.topHealingCrestFrame:CreateTexture()
matchHistoryFrame.topHealingCrestTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\RankCrestGrayBackground")
matchHistoryFrame.topHealingCrestTexture:SetAllPoints()

matchHistoryFrame.topHealingCrestFrame.titleFontString = matchHistoryFrame.topHealingCrestFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
matchHistoryFrame.topHealingCrestFrame.titleFontString:SetPoint("TOP", matchHistoryFrame.topHealingCrestFrame, "BOTTOM", 0, 0) 
matchHistoryFrame.topHealingCrestFrame.titleFontString:SetJustifyH("CENTER")
matchHistoryFrame.topHealingCrestFrame.titleFontString:SetText(L["TopHealingTitle"])

matchHistoryFrame.topHealingCrestFrame.summaryFontString = matchHistoryFrame.topHealingCrestFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
matchHistoryFrame.topHealingCrestFrame.summaryFontString:SetPoint("LEFT", matchHistoryFrame.topHealingCrestFrame, "RIGHT", 10, -10) 
matchHistoryFrame.topHealingCrestFrame.summaryFontString:SetJustifyH("LEFT")

-- Deaths
matchHistoryFrame.noDeathCrestFrame = CreateFrame("FRAME", nil, matchHistoryFrame)
matchHistoryFrame.noDeathCrestFrame:SetWidth(85)
matchHistoryFrame.noDeathCrestFrame:SetHeight(85)
matchHistoryFrame.noDeathCrestFrame:SetPoint("TOP", matchHistoryFrame.topHealingCrestFrame, "BOTTOM", 0, -30)

matchHistoryFrame.noDeathCrestTexture = matchHistoryFrame.noDeathCrestFrame:CreateTexture()
matchHistoryFrame.noDeathCrestTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\RankCrestGrayBackground")
matchHistoryFrame.noDeathCrestTexture:SetAllPoints()

matchHistoryFrame.noDeathCrestFrame.titleFontString = matchHistoryFrame.noDeathCrestFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
matchHistoryFrame.noDeathCrestFrame.titleFontString:SetPoint("TOP", matchHistoryFrame.noDeathCrestFrame, "BOTTOM", 0, 0) 
matchHistoryFrame.noDeathCrestFrame.titleFontString:SetJustifyH("CENTER")
matchHistoryFrame.noDeathCrestFrame.titleFontString:SetText(L["NoDeathTitle"])

matchHistoryFrame.noDeathCrestFrame.summaryFontString = matchHistoryFrame.noDeathCrestFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
matchHistoryFrame.noDeathCrestFrame.summaryFontString:SetPoint("LEFT", matchHistoryFrame.noDeathCrestFrame, "RIGHT", 10, 0) 
matchHistoryFrame.noDeathCrestFrame.summaryFontString:SetJustifyH("LEFT")

-- Top Mongos: Kills (ranks 1 - 3)
matchHistoryFrame.topSpecKills = CreateFrame("FRAME", nil, matchHistoryFrame)
matchHistoryFrame.topSpecKills:SetWidth(175)
matchHistoryFrame.topSpecKills:SetHeight(100)
matchHistoryFrame.topSpecKills:SetPoint("LEFT", matchHistoryFrame.killsCrestFrame, "RIGHT", 540, -10)

matchHistoryFrame.topSpecKills.titleFontString = matchHistoryFrame.topSpecKills:CreateFontString(nil, "ARTWORK", "GameFontNormal")
matchHistoryFrame.topSpecKills.titleFontString:SetPoint("TOPLEFT", matchHistoryFrame.topSpecKills, "TOPLEFT", 0, 0) 
matchHistoryFrame.topSpecKills.titleFontString:SetJustifyH("CENTER")
matchHistoryFrame.topSpecKills.titleFontString:SetText(L["TopSpecs"] .. ": " .. L["Kills"])

-- Top Mongos: Most prevalent spec (ranks 1 - 3)
matchHistoryFrame.topSpecMostSeen = CreateFrame("FRAME", nil, matchHistoryFrame)
matchHistoryFrame.topSpecMostSeen:SetWidth(175)
matchHistoryFrame.topSpecMostSeen:SetHeight(100)
matchHistoryFrame.topSpecMostSeen:SetPoint("LEFT", matchHistoryFrame.noDeathCrestFrame, "RIGHT", 540, -10)

matchHistoryFrame.topSpecMostSeen.titleFontString = matchHistoryFrame.topSpecMostSeen:CreateFontString(nil, "ARTWORK", "GameFontNormal")
matchHistoryFrame.topSpecMostSeen.titleFontString:SetPoint("TOPLEFT", matchHistoryFrame.topSpecMostSeen, "TOPLEFT", 0, 0) 
matchHistoryFrame.topSpecMostSeen.titleFontString:SetJustifyH("CENTER")
matchHistoryFrame.topSpecMostSeen.titleFontString:SetText(L["TopSpecs"] .. ": " .. L["MostSeen"])

-- Top Mongos: Damage (ranks 1 - 3)
matchHistoryFrame.topSpecDamage = CreateFrame("FRAME", nil, matchHistoryFrame)
matchHistoryFrame.topSpecDamage:SetWidth(175)
matchHistoryFrame.topSpecDamage:SetHeight(100)
matchHistoryFrame.topSpecDamage:SetPoint("LEFT", matchHistoryFrame.topDamageCrestFrame, "RIGHT", 540, -10)

matchHistoryFrame.topSpecDamage.titleFontString = matchHistoryFrame.topSpecDamage:CreateFontString(nil, "ARTWORK", "GameFontNormal")
matchHistoryFrame.topSpecDamage.titleFontString:SetPoint("TOPLEFT", matchHistoryFrame.topSpecDamage, "TOPLEFT", 0, 0) 
matchHistoryFrame.topSpecDamage.titleFontString:SetJustifyH("CENTER")
matchHistoryFrame.topSpecDamage.titleFontString:SetText(L["TopSpecs"] .. ": " .. L["Damage"])

-- Top Mongos: Healing (ranks 1 - 3)
matchHistoryFrame.topSpecHealing = CreateFrame("FRAME", nil, matchHistoryFrame)
matchHistoryFrame.topSpecHealing:SetWidth(175)
matchHistoryFrame.topSpecHealing:SetHeight(100)
matchHistoryFrame.topSpecHealing:SetPoint("LEFT", matchHistoryFrame.topHealingCrestFrame, "RIGHT", 540, -10)

matchHistoryFrame.topSpecHealing.titleFontString = matchHistoryFrame.topSpecHealing:CreateFontString(nil, "ARTWORK", "GameFontNormal")
matchHistoryFrame.topSpecHealing.titleFontString:SetPoint("TOPLEFT", matchHistoryFrame.topSpecHealing, "TOPLEFT", 0, 0) 
matchHistoryFrame.topSpecHealing.titleFontString:SetJustifyH("CENTER")
matchHistoryFrame.topSpecHealing.titleFontString:SetText(L["TopSpecs"] .. ": " .. L["Healing"])

-- Battleground map stats
matchHistoryFrame.battlegroundStats = CreateFrame("FRAME", nil, matchHistoryFrame)
matchHistoryFrame.battlegroundStats:SetWidth(930)
matchHistoryFrame.battlegroundStats:SetHeight(100)
matchHistoryFrame.battlegroundStats:SetPoint("TOPLEFT", matchHistoryFrame.noDeathCrestFrame, "BOTTOMLEFT", -50, -30)

matchHistoryFrame.battlegroundStats.separatorFrame = CreateFrame("FRAME", nil, matchHistoryFrame.battlegroundStats)
matchHistoryFrame.battlegroundStats.separatorFrame:SetPoint("TOP", matchHistoryFrame.battlegroundStats, "TOP", 0, 0)
matchHistoryFrame.battlegroundStats.separatorFrame:SetSize(850, 5)

matchHistoryFrame.battlegroundStats.separatorTexture = matchHistoryFrame.battlegroundStats.separatorFrame:CreateTexture()
matchHistoryFrame.battlegroundStats.separatorTexture:SetAlpha(ALPHA_VALUE)
matchHistoryFrame.battlegroundStats.separatorTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\ScoreboardBackground")
matchHistoryFrame.battlegroundStats.separatorTexture:SetAllPoints()

-- Buttons to send personal report to Guild or Party chat
matchHistoryFrame.sendToPartyButton = CreateFrame("BUTTON", nil, matchHistoryFrame, "UIPanelButtonTemplate");
matchHistoryFrame.sendToPartyButton:SetPoint("TOPRIGHT",matchHistoryFrame.descriptionFontString, "TOPLEFT", -39, 4)
matchHistoryFrame.sendToPartyButton:RegisterForClicks("AnyUp")
matchHistoryFrame.sendToPartyButton:SetSize(150, 20)
matchHistoryFrame.sendToPartyButton:SetText(L["SendToParty"])

matchHistoryFrame.sendToGuildButton = CreateFrame("BUTTON", nil, matchHistoryFrame, "UIPanelButtonTemplate");
matchHistoryFrame.sendToGuildButton:SetPoint("TOPLEFT", matchHistoryFrame.descriptionFontString, "TOPRIGHT", 39, 4)
matchHistoryFrame.sendToGuildButton:RegisterForClicks("AnyUp")
matchHistoryFrame.sendToGuildButton:SetSize(150, 20)
matchHistoryFrame.sendToGuildButton:SetText(L["SendToGuild"])

--[[
 -	The After Action Report.
 -
 -	This section builds the UI banner that is displayed on the screen after a battleground that
 -	summarizes our hero's glorious BG achievements.
--]]

-- Primary container and background
local afterActionFrame = CreateFrame("FRAME", "MongoMonAfterActionFrame")
afterActionFrame:SetFrameStrata("HIGH") -- Appear above annoying junk
afterActionFrame:SetFrameLevel(10) -- Appear above annoying junk
afterActionFrame:SetPoint("TOP", nil, "TOP", 0, -20)
afterActionFrame:SetWidth(450)
afterActionFrame:SetHeight(260)
afterActionFrame:SetBackdrop(BACKDROP_GREEN)
afterActionFrame:SetMovable(true)
afterActionFrame:EnableMouse(true)
afterActionFrame:RegisterForDrag("LeftButton")
afterActionFrame:SetScript("OnDragStart", afterActionFrame.StartMoving)
afterActionFrame:SetScript("OnDragStop", afterActionFrame.StopMovingOrSizing)
afterActionFrame:SetScript("OnMouseUp", function(self, button)
	afterActionFrame:Hide()
end)

afterActionFrame.title = afterActionFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightOutline")
afterActionFrame.title:SetPoint("BOTTOM", afterActionFrame, "TOP", 0, -5)
afterActionFrame.title:SetText(L["TitleAndAuthor"])

afterActionFrame.backgroundFrame = CreateFrame("FRAME", nil, afterActionFrame)
afterActionFrame.backgroundFrame:SetFrameLevel(0)
afterActionFrame.backgroundFrame:SetPoint("CENTER", afterActionFrame, "CENTER", 0, 0)
afterActionFrame.backgroundFrame:SetSize(435, 240)
afterActionFrame.backgroundTexture = afterActionFrame.backgroundFrame:CreateTexture()
afterActionFrame.backgroundTexture:SetAlpha(0.55)
afterActionFrame.backgroundTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\ScoreboardBackground")
afterActionFrame.backgroundTexture:SetAllPoints()

afterActionFrame.flavorFontString = afterActionFrame:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
afterActionFrame.flavorFontString:SetPoint("BOTTOM", afterActionFrame, "BOTTOM", 0, 50) 
afterActionFrame.flavorFontString:SetJustifyH("LEFT")
afterActionFrame.flavorFontString:SetWidth(380)

afterActionFrame.reportTeamFontString = afterActionFrame:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
afterActionFrame.reportTeamFontString:SetPoint("BOTTOM", afterActionFrame.flavorFontString, "TOP", 0, 10) 
afterActionFrame.reportTeamFontString:SetJustifyH("LEFT")
afterActionFrame.reportTeamFontString:SetWidth(380)

afterActionFrame.reportPlayerFontString = afterActionFrame:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
afterActionFrame.reportPlayerFontString:SetPoint("BOTTOM", afterActionFrame.reportTeamFontString, "TOP", 0, 10) 
afterActionFrame.reportPlayerFontString:SetJustifyH("LEFT")
afterActionFrame.reportPlayerFontString:SetWidth(380)

-- Top Killing Blows
afterActionFrame.killsCrestFrame = CreateFrame("FRAME", nil, afterActionFrame)
afterActionFrame.killsCrestFrame:SetWidth(85)
afterActionFrame.killsCrestFrame:SetHeight(85)
afterActionFrame.killsCrestFrame:SetPoint("TOPLEFT", afterActionFrame, "TOPLEFT", 50, -10)

afterActionFrame.killsCrestTexture = afterActionFrame.killsCrestFrame:CreateTexture()
afterActionFrame.killsCrestTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\RankCrestGrayBackground")
afterActionFrame.killsCrestTexture:SetAllPoints()

afterActionFrame.killsCrestFrame.fontString = afterActionFrame.killsCrestFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
afterActionFrame.killsCrestFrame.fontString:SetPoint("TOP", afterActionFrame.killsCrestFrame, "BOTTOM", 0, 0) 
afterActionFrame.killsCrestFrame.fontString:SetJustifyH("CENTER")

afterActionFrame.killsCrestFrame.subFontString = afterActionFrame.killsCrestFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
afterActionFrame.killsCrestFrame.subFontString:SetPoint("TOP", afterActionFrame.killsCrestFrame.fontString, "BOTTOM", 0, -3) 
afterActionFrame.killsCrestFrame.subFontString:SetJustifyH("CENTER")

-- Top Damage
afterActionFrame.topDamageCrestFrame = CreateFrame("FRAME", nil, afterActionFrame)
afterActionFrame.topDamageCrestFrame:SetWidth(85)
afterActionFrame.topDamageCrestFrame:SetHeight(85)
afterActionFrame.topDamageCrestFrame:SetPoint("TOP", afterActionFrame, "TOP", 0, -10)

afterActionFrame.topDamageCrestTexture = afterActionFrame.topDamageCrestFrame:CreateTexture()
afterActionFrame.topDamageCrestTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\RankCrestGrayBackground")
afterActionFrame.topDamageCrestTexture:SetAllPoints()

afterActionFrame.topDamageCrestFrame.fontString = afterActionFrame.topDamageCrestFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
afterActionFrame.topDamageCrestFrame.fontString:SetPoint("TOP", afterActionFrame.topDamageCrestFrame, "BOTTOM", 0, 0) 
afterActionFrame.topDamageCrestFrame.fontString:SetJustifyH("CENTER")

afterActionFrame.topDamageCrestFrame.subFontString = afterActionFrame.topDamageCrestFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
afterActionFrame.topDamageCrestFrame.subFontString:SetPoint("TOP", afterActionFrame.topDamageCrestFrame.fontString, "BOTTOM", 0, -3) 
afterActionFrame.topDamageCrestFrame.subFontString:SetJustifyH("CENTER")

-- No Deaths
afterActionFrame.noDeathCrestFrame = CreateFrame("FRAME", nil, afterActionFrame)
afterActionFrame.noDeathCrestFrame:SetWidth(85)
afterActionFrame.noDeathCrestFrame:SetHeight(85)
afterActionFrame.noDeathCrestFrame:SetPoint("TOPRIGHT", afterActionFrame, "TOPRIGHT", -50, -10)

afterActionFrame.noDeathCrestTexture = afterActionFrame.noDeathCrestFrame:CreateTexture()
afterActionFrame.noDeathCrestTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\RankCrestGrayBackground")
afterActionFrame.noDeathCrestTexture:SetAllPoints()

afterActionFrame.noDeathCrestFrame.fontString = afterActionFrame.noDeathCrestFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
afterActionFrame.noDeathCrestFrame.fontString:SetPoint("TOP", afterActionFrame.noDeathCrestFrame, "BOTTOM", 0, 0) 
afterActionFrame.noDeathCrestFrame.fontString:SetJustifyH("CENTER")

afterActionFrame.footerFontString = afterActionFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
afterActionFrame.footerFontString:SetPoint("BOTTOM", afterActionFrame, "BOTTOM", 0, 22) 
afterActionFrame.footerFontString:SetText(L["TouchToClose"])

afterActionFrame.footerFontString = afterActionFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
afterActionFrame.footerFontString:SetPoint("BOTTOMLEFT", afterActionFrame, "BOTTOMLEFT", 35, 22) 
afterActionFrame.footerFontString:SetText("/mm")

afterActionFrame.button = CreateFrame("BUTTON", nil, afterActionFrame, "UIPanelButtonTemplate");
afterActionFrame.button:SetPoint("BOTTOMRIGHT",afterActionFrame, "BOTTOMRIGHT", -15, 35)
afterActionFrame.button:RegisterForClicks("AnyUp")
afterActionFrame.button:SetSize(145, 25)
afterActionFrame.button:SetText(L["SendToChat"])
afterActionFrame.button:SetScript("OnClick", function(self) 
	if not self.lastReportTime or self.lastReportTime + SEND_TO_CHAT_COOLDOWN < time() then
		self.lastReportTime = time()
		local version = GetAddOnMetadata("MongoMon", "Version")
		local text = "[" .. L["Title"] .. " v" .. version .. "] " .. self:GetParent().reportTeamFontString:GetText()
		SendChatMessage(text, "INSTANCE_CHAT")
	end
end)

--[[
 -	The Credits Screen
 -
 --]]

-- Primary container and background
local creditsFrame = CreateFrame("FRAME", "MongoMonCreditsFrame")
creditsFrame:SetFrameStrata("HIGH") -- Appear above annoying junk
creditsFrame:SetFrameLevel(10) -- Appear above annoying junk
creditsFrame:SetPoint("TOP", nil, "TOP", 0, -20)
creditsFrame:SetWidth(310)
creditsFrame:SetHeight(160)
creditsFrame:SetBackdrop(BACKDROP_RED)
creditsFrame:SetMovable(true)
creditsFrame:EnableMouse(true)
creditsFrame:RegisterForDrag("LeftButton")
creditsFrame:SetScript("OnDragStart", creditsFrame.StartMoving)
creditsFrame:SetScript("OnDragStop", creditsFrame.StopMovingOrSizing)
creditsFrame:SetScript("OnMouseUp", function(self, button)
	creditsFrame:Hide()
	StopMusic()
end)

creditsFrame.title = creditsFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightOutline")
creditsFrame.title:SetPoint("BOTTOM", creditsFrame, "TOP", 0, -5)
creditsFrame.title:SetText(L["TitleAndAuthor"])

creditsFrame.backgroundFrame = CreateFrame("FRAME", nil, creditsFrame)
creditsFrame.backgroundFrame:SetFrameLevel(0)
creditsFrame.backgroundFrame:SetPoint("CENTER", creditsFrame, "CENTER", 0, 0)
creditsFrame.backgroundFrame:SetSize(300, 150)
creditsFrame.backgroundTexture = creditsFrame.backgroundFrame:CreateTexture()
creditsFrame.backgroundTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\Fuhr")
creditsFrame.backgroundTexture:SetAllPoints()

local creditNames = ""
for _, name in pairs(NO_CREDIT) do creditNames = creditNames .. "\n- " .. name end
creditsFrame.flavorFontString = creditsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
creditsFrame.flavorFontString:SetPoint("TOP", creditsFrame, "TOP", 0, -20) 
creditsFrame.flavorFontString:SetJustifyH("LEFT")
creditsFrame.flavorFontString:SetWidth(260)
creditsFrame.flavorFontString:SetText(L["CreditsText"] .. ": \n" .. creditNames)

creditsFrame.footerFontString = creditsFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
creditsFrame.footerFontString:SetPoint("BOTTOM", creditsFrame, "BOTTOM", 0, 10) 
creditsFrame.footerFontString:SetText(L["TouchToClose"])

--[[
-	Initializes and sets up the scoreboard. Default state is no golden
-	text, everything should be GameFontHilight which is the white text.
-	All textures are greyed out rank icon backgrounds, except for no
-	deaths.
-
-	@param boolean So we can set it to healing mode or damage mode
--]]
local function displayScoreboard(isHealer)
	if isHealer then
		scoreFrame.topDamageTitle:SetText(L["TopHealingTitle"])
		scoreFrame.damageHealingFontString:SetText("0 " .. L["Healing"])
	else
		scoreFrame.topDamageTitle:SetText(L["TopDamageTitle"])
		scoreFrame.damageHealingFontString:SetText("0 " .. L["Damage"])
	end
	scoreFrame:SetBackdrop(BACKDROP_BAD)
	
	scoreFrame.killDeathFontString:SetFontObject("GameFontHighlight")
	scoreFrame.killDeathFontString:SetText("0 - 0")

	scoreFrame.topDamageTexture:SetAlpha(ALPHA_VALUE)
	scoreFrame.topDamageTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\RankCrestGrayBackground")
	scoreFrame.topDamageTitle:SetFontObject("GameFontHighlightSmall")
	scoreFrame.damageHealingFontString:SetFontObject("GameFontHighlight")
	scoreFrame.damageHealingDiffFontString:SetFontObject("GameFontHighlightSmall")
	scoreFrame.damageHealingDiffFontString:SetText("")
	
	scoreFrame.rankTexture:SetAlpha(ALPHA_VALUE)
	scoreFrame.rankTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\RankCrestGrayBackground")
	scoreFrame.rankTitle:SetFontObject("GameFontHighlightSmall")
	scoreFrame.killDeathFontString:SetFontObject("GameFontHighlight")
	
	scoreFrame.noDeathTexture:SetAlpha(1)
	scoreFrame.noDeathTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\SippieCupRank")
	scoreFrame.noDeathTitle:SetFontObject("GameFontNormalSmall")
	
	scoreFrame:Show()
end

--[[
-	Generates text indicating player is either ahead of the 2nd rank player by x number
-	of healing or damage, or how far behind he is from the rank 1 player if he is not rank
-	number 1.
-
-	@param table player our hero
-	@param table players all other players
-	@return string
-]]
local function getDamageHealingDiffText(player, players)
	if not player or not players then return "" end
	
	local key = player.isHealer and "healing" or "damage"
	local diff = 0
	local ahead = false
	local i = 1
	
	for _, p in spairs(players, function(t,a,b) 
		return t[b][key] < t[a][key]
	end) do
		if i == 1 then
			if p.name == player.name then 
				-- Player is rank 1, therefore ahead, wait till next iteration to find out by how much
				ahead = true
			else
				-- Player is not rank 1, so we can get the leader (this p object) and quit
				diff = p[key] - player[key]
				break
			end
		elseif i == 2 then
			diff = player[key] - p[key]
		else
			break
		end
		i = i + 1		
	end
	if ahead then
		return "(" .. L["AheadBy"] .. " " .. prettyNumber(diff) .. ")"
	else
		return "(" .. prettyNumber(diff) .. " " .. L["BehindLeader"] .. ")"
	end
end

--[[
-	Handles all manipulation of personal MongoMon scoreboard.
-
-	Updates kill, damage/healing and death ranks in addition to 
-	kill vs. death and total damage/healing.
-
-	@param table player The actual player, not just any shmuck
-	@param table players The rest of the players in the BG to fetch highest damage/healing
- 	@param boolean isHealer, because value returned from GetBattleFieldScore is unreliable
--]]
local function updateScoreboard(player, players) 
	if player.isHealer then
		-- Update scoreboard for healing
		if player.healing == nil or player.healing == 0 then
			scoreFrame.damageHealingFontString:SetText("0 " .. L["Healing"])
		else
			scoreFrame.damageHealingFontString:SetText(prettyNumber(player.healing) .. " " .. L["Healing"] .. ", " .. L["Rank"] .. " " .. player.healingRank)
			scoreFrame.damageHealingDiffFontString:SetText(getDamageHealingDiffText(player, players))
		end			
	
		-- Special case for #1 - #5 Healing.
		if player.healingRank >= 1 and player.healingRank <= MAX_PLAYER_RANK and player.healing > 0 then
			scoreFrame.topDamageTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\WheelchairRank" .. player.healingRank)
			scoreFrame.topDamageTexture:SetAlpha(1)
			scoreFrame.topDamageTitle:SetFontObject("GameFontNormalSmall")
			scoreFrame.damageHealingFontString:SetFontObject("GameFontNormal")
			scoreFrame.damageHealingDiffFontString:SetFontObject("GameFontNormalSmall")
		else
			scoreFrame.topDamageTexture:SetAlpha(ALPHA_VALUE)
			scoreFrame.topDamageTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\RankCrestGrayBackground")
			scoreFrame.topDamageTitle:SetFontObject("GameFontHighlightSmall")
			scoreFrame.damageHealingFontString:SetFontObject("GameFontHighlight")
			scoreFrame.damageHealingDiffFontString:SetFontObject("GameFontHighlightSmall")
		end
		
		if player.healingRank == 1 and player.healing > 0 then
			scoreFrame:SetBackdrop(BACKDROP_GREEN)
		else
			scoreFrame:SetBackdrop(BACKDROP_BAD)
		end
	else
		-- Update scoreboard for damage
		if player.damage == nil or player.damage == 0 then
			scoreFrame.damageHealingFontString:SetText("0 " .. L["Damage"])
		else
			scoreFrame.damageHealingFontString:SetText(prettyNumber(player.damage).. " " .. L["Damage"] .. ", " .. L["Rank"] .. " " .. player.damageRank)
			scoreFrame.damageHealingDiffFontString:SetText(getDamageHealingDiffText(player, players))
		end					
	
		-- Special case for #1 - #5 Damage. 
		if player.damageRank >= 1 and player.damageRank <= MAX_PLAYER_RANK and player.damage > 0 then
			scoreFrame.topDamageTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\WheelchairRank" .. player.damageRank)
			scoreFrame.topDamageTexture:SetAlpha(1)
			scoreFrame.topDamageTitle:SetFontObject("GameFontNormalSmall")
			scoreFrame.damageHealingFontString:SetFontObject("GameFontNormal")
			scoreFrame.damageHealingDiffFontString:SetFontObject("GameFontNormalSmall")
		else
			scoreFrame.topDamageTexture:SetAlpha(ALPHA_VALUE)
			scoreFrame.topDamageTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\RankCrestGrayBackground")
			scoreFrame.topDamageTitle:SetFontObject("GameFontHighlightSmall")
			scoreFrame.damageHealingFontString:SetFontObject("GameFontHighlight")
			scoreFrame.damageHealingDiffFontString:SetFontObject("GameFontHighlightSmall")
		end
		
		-- Make the background red when player is top kills or top damage (player.rank is actually kills rank, poorly named yes)
		if player.damageRank == 1 or player.rank == 1 and player.damage > 0 then
			scoreFrame:SetBackdrop(BACKDROP_RED)
		else
			scoreFrame:SetBackdrop(BACKDROP_BAD)
		end
	end
	
	local rank = player.kills > 0 and L["Rank"] .. " " .. player.rank or ""
	scoreFrame.killDeathFontString:SetText(player.kills .. " - " .. player.deaths .. " " .. rank)

	if player.rank > 0 and player.rank <= MAX_PLAYER_RANK and player.kills > 0 then
		scoreFrame.rankTexture:SetAlpha(1)
		scoreFrame.rankTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\DerpRank" .. player.rank)
		scoreFrame.rankTitle:SetFontObject("GameFontNormalSmall")
		scoreFrame.killDeathFontString:SetFontObject("GameFontNormal")
	else
		scoreFrame.rankTexture:SetAlpha(ALPHA_VALUE)
		scoreFrame.rankTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\RankCrestGrayBackground")
		scoreFrame.rankTitle:SetFontObject("GameFontHighlightSmall")
		scoreFrame.killDeathFontString:SetFontObject("GameFontHighlight")
	end
	
	if player.deaths == 0 then
		scoreFrame.noDeathTexture:SetAlpha(1)
		scoreFrame.noDeathTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\SippieCupRank")
		scoreFrame.noDeathTitle:SetFontObject("GameFontNormalSmall")
	else
		scoreFrame.noDeathTexture:SetAlpha(ALPHA_VALUE)
		scoreFrame.noDeathTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\RankCrestGrayBackground")
		scoreFrame.noDeathTitle:SetFontObject("GameFontHighlightSmall")
	end
end

--[[
 -	This function will generate three blocks on the killing blow history
 -	frame which display the top 3 killing blow spells, the percentage they
 -	are used in getting a killing blow, the highest amount, and the number
 -	of kills gotten with that spell.
 -
 -	@param frame parent
--]]
local function createTopKillingBlowSpells(parent)
	parent.spellFrame1 = CreateFrame("FRAME", nil, parent)
	parent.spellFrame1:SetPoint("TOP", parent, "TOP", -150, -10)
	
	parent.spellFrame2 = CreateFrame("FRAME", nil, parent)
	parent.spellFrame2:SetPoint("TOP", parent, "TOP", 0, -10)
	
	parent.spellFrame3 = CreateFrame("FRAME", nil, parent)
	parent.spellFrame3:SetPoint("TOP", parent, "TOP", 150, -10)
	
	local frames = { parent.spellFrame1, parent.spellFrame2, parent.spellFrame3 }
	for key, frame in pairs(frames) do
		frame:SetBackdrop(BACKDROP_RED)
		frame:SetWidth(75)
		frame:SetHeight(75)
		
		frame.spellFrameTextureContainer = CreateFrame("FRAME", nil, frame)
		frame.spellFrameTextureContainer:SetPoint("CENTER", frame, "CENTER", 0, 0)
		frame.spellFrameTextureContainer:SetSize(60, 60)
		
		frame.spellFrameTexture = frame.spellFrameTextureContainer:CreateTexture()
		frame.spellFrameTexture:SetAllPoints()

		frame.titleFontString = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
		frame.titleFontString:SetPoint("TOP", frame, "BOTTOM", 0, 0) 
		frame.titleFontString:SetJustifyH("CENTER")
		frame.titleFontString:SetText("")

		frame.spellFontString = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		frame.spellFontString:SetPoint("TOP", frame.titleFontString, "BOTTOM", 0, -2) 
		frame.spellFontString:SetJustifyH("CENTER")
		frame.spellFontString:SetText("")		
	end
end

--[[
 -	Updates the top killing blows spell icons and values.
 -
 -	@parent Frame to be embedded in
 -	@param table spells
--]]
local function updateTopKillingBlowSpells(parent, spells)
	-- Hide just in case there arent all three top killing blow spells
	for _,i in pairs({1, 2, 3}) do
		local frame = parent["spellFrame" .. i]
		frame.spellFrameTexture:Hide()
		frame.titleFontString:Hide()
		frame.spellFontString:Hide()
	end
	
	for key, spell in pairs(spells) do
		local frame = parent["spellFrame" .. key]
		local texture = GetSpellTexture(spell.spellId)
		frame.spellFrameTexture:SetTexture(texture)
		frame.titleFontString:SetText("#" .. key .. " " .. GetSpellInfo(spell.spellId))
		frame.spellFontString:SetText(spell.num .. " (" .. round(spell.percent, 0) .. "%)\n" .. L["Highest"] .. " " .. prettyNumber(spell.highestAmount))
		frame.spellFontString:Show()
		frame.spellFrameTexture:Show()
		frame.titleFontString:Show()
	end
end

--[[
 -	Adds battleground stats to the MatchHistoryFrame. This is done programatically
 -	because there are numerous battlegrounds and doing it manually is too boring.
 -
 -	@param Frame parent
--]]
local function createBattlegroundStats(parent)
	local i = 0
	local width = 125
	local height = 50
	
	-- Build one entry for each BG map.
	for mapId, mapName in pairs(BG_MAP_IDS) do
		local offsetX = (i / 6 > 1 and  (i - 7) * width or (i * width)) + 50
		local offsetY = (i / 6 > 1 and -height - 15 or 0) - 10
		local frame = CreateFrame("FRAME", nil, parent)
		frame:SetPoint("TOPLEFT", parent, "TOPLEFT", offsetX, offsetY)
		frame:SetSize(width, height)
		
		frame.titleFontString = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
		frame.titleFontString:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0) 
		frame.titleFontString:SetJustifyH("LEFT")
		frame.titleFontString:SetText(mapName)
		
		frame.iconTextureContainer = CreateFrame("FRAME", nil, frame)
		frame.iconTextureContainer:SetPoint("TOPLEFT", frame.titleFontString, "BOTTOMLEFT", 0, -5)
		frame.iconTextureContainer:SetSize(35, 35)
		
		frame.iconTexture = frame.iconTextureContainer:CreateTexture()
		frame.iconTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\RankCrestGrayBackground")
		frame.iconTexture:SetAllPoints()

		frame.winLossFontString = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		frame.winLossFontString:SetPoint("TOPLEFT", frame.iconTextureContainer, "TOPRIGHT", 15, -3) 
		frame.winLossFontString:SetJustifyH("CENTER")
		frame.winLossFontString:SetText("0 - 0")
		
		frame.winRateFontString = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		frame.winRateFontString:SetPoint("TOPLEFT", frame.iconTextureContainer, "TOPRIGHT", 15, -20) 
		frame.winRateFontString:SetJustifyH("CENTER")
		frame.winRateFontString:SetText("")
		
		parent[mapName] = frame
		i = i + 1
	end
end

--[[
 -	Updates the battleground stats section of the match history report.
 -
 -	@param Frame parent UI elemetn
 -	@param table mapData
--]]
local function updateBattlegroundStats(parent, mapData)
	-- Reset all BG stats to default because they might no longer have data.
	for mapId, mapName in pairs(BG_MAP_IDS) do
		local frame = parent[mapName]
		frame.iconTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\RankCrestGrayBackground")
		frame.iconTexture:SetAlpha(ALPHA_VALUE)
		frame.winLossFontString:SetText("0 - 0")
		frame.winLossFontString:SetFontObject("GameFontDisableSmall")
		frame.winRateFontString:SetText("")
	end
	
	-- Populate all BG frames with fresh stats of power.
	for mapName, bgData in pairs(mapData) do
		local frame = parent[mapName]
		frame.iconTexture:SetAlpha(1)
		frame.winLossFontString:SetFontObject("GameFontHighlightSmall")
		if bgData.winRate >= 50 then
			frame.iconTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\RankCrestCheck")
		else
			frame.iconTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\RankCrestX")
		end
		frame.winLossFontString:SetText(bgData.wins .. " - " .. bgData.losses)
		frame.winRateFontString:SetText(round(bgData.winRate, 1) .. "%")
	end
end

--[[
 -	Adds top specs to a section of the after action report. There's a total of 12 of
 -	these so its just makes more sense to build them here.
 -
 -	@parent Frame to be embedded in
--]]
local function createTopSpecs(parent) 
	parent.specFrame1 = CreateFrame("FRAME", nil, parent)
	parent.specFrame1:SetPoint("TOP", parent, "TOP", -80, -20)
	
	parent.specFrame2 = CreateFrame("FRAME", nil, parent)
	parent.specFrame2:SetPoint("TOP", parent, "TOP", 0, -20)
	
	parent.specFrame3 = CreateFrame("FRAME", nil, parent)
	parent.specFrame3:SetPoint("TOP", parent, "TOP", 80, -20)
	
	local frames = { parent.specFrame1, parent.specFrame2, parent.specFrame3 }
	for key, frame in pairs(frames) do
		frame:SetBackdrop(BACKDROP_RED)
		frame:SetWidth(45)
		frame:SetHeight(45)
		
		frame.specFrameTextureContainer = CreateFrame("FRAME", nil, frame)
		frame.specFrameTextureContainer:SetPoint("CENTER", frame, "CENTER", 0, 0)
		frame.specFrameTextureContainer:SetSize(30, 30)
		
		frame.specFrameTexture = frame.specFrameTextureContainer:CreateTexture()
		frame.specFrameTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\GreenAlphaBackground")
		frame.specFrameTexture:SetAllPoints()

		frame.titleFontString = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
		frame.titleFontString:SetPoint("TOP", frame, "BOTTOM", 0, 0) 
		frame.titleFontString:SetJustifyH("CENTER")
		frame.titleFontString:SetText("")

		frame.classFontString = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
		frame.classFontString:SetPoint("TOP", frame.titleFontString, "BOTTOM", 0, -2) 
		frame.classFontString:SetJustifyH("CENTER")
		frame.classFontString:SetText("")		
	end
end

--[[
 -	Updates the top spec icons and values.
 -
 -	@parent Frame to be embedded in
 -	@param table players Contains three player objects with class, spec, and percent, number
 -	@param boolean Whether to display the percent value in the player object
--]]
local function updateTopSpecs(parent, players, showPercent)
	-- Hide just in case there arent all three top specs
	for _,i in pairs({1, 2, 3}) do
		local frame = parent["specFrame" .. i]
		frame.specFrameTexture:Hide()
		frame.titleFontString:Hide()
		frame.classFontString:Hide()
	end
	
	for key, player in pairs(players) do
		local frame = parent["specFrame" .. key]
		local _, spec = GetSpecializationInfoByID(player.specId)
		local class = GetClassInfo(player.classId)
		frame.specFrameTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\SpecIcons")
		frame.specFrameTexture:SetTexCoord(unpack(SPEC_ID_ICONS[player.specId]))
		if showPercent then
			frame.titleFontString:SetText("#" .. key .. " (" .. round(player.percent, 0) .. "%)")
		else
			frame.titleFontString:SetText("#" .. key)
		end
		frame.classFontString:SetText(class .. "\n" .. spec)
		frame.classFontString:Show()
		frame.specFrameTexture:Show()
		frame.titleFontString:Show()
	end
end

--[[
 -	Creates a Legend for a Pie chart since this isn't provided by
 -	LibGraph-2.0. So we will have to create a little frame. Provided
 -	is a table that contains a legend value and a color.
 -
 -	@param string name of Frame
 -	@param Frame parent frame
 -	@param string relativePosition from this frame to parent
 -	@param string parentPosition Position to parent
 -	@return Frame 
--]]
local function createPieLegendFrame(name, parent, relativePosition, parentPosition, values)
	local legendFrame = CreateFrame("FRAME", name, parent)
	legendFrame:SetWidth(100)
	legendFrame:SetHeight(25)
	legendFrame:SetPoint(relativePosition, parent, parentPosition, 0, 10)
	local lastFontString
	for key, color in pairs(values) do
		local fontString = legendFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
		if not lastFontString then
			fontString:SetPoint("LEFT", legendFrame, "LEFT", 0, 0) 
		else
			fontString:SetPoint("LEFT", lastFontString, "RIGHT", 3, 0) 
		end
		fontString:SetText(key)
		fontString:SetTextColor(color[1], color[2], color[3], 1)
		lastFontString = fontString
	end
end

--[[
 -	Builds the title for the line chart that displays under the chart
 -	Should just print some simple text.
 -
 -	@param string name of Frame
 -	@param Frame parent frame
 -	@param string relativePosition from this frame to parent
 -	@param string parentPosition Position to parent
 -	@param string categoryName will appear in Legend title
 -	@return Frame
--]]
local function createLineLegend(name, parent, relativePosition, parentPosition, categoryName)
	local legendFrame = CreateFrame("FRAME", name, parent)
	legendFrame:SetWidth(100)
	legendFrame:SetHeight(25)
	legendFrame:SetPoint(relativePosition, parent, parentPosition, 0, -3)
	
	local playerFontString = legendFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	playerFontString:SetPoint("LEFT", legendFrame, "LEFT", -25, 0) 
	playerFontString:SetTextColor(0, 1, 0, 1)
	playerFontString:SetText(L["Player"] .. " " .. categoryName)
	
	local teamFontString = legendFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	teamFontString:SetPoint("LEFT", playerFontString, "RIGHT", 10, 0) 
	teamFontString:SetTextColor(1, 1, 0, 1)
	teamFontString:SetText(L["Team"] .. " " .. categoryName)
	
	return legendFrame
end

--[[
 -	Builds the Pie chart used by the Kills, Damage, and Healing widgets.
 -
 -	@param Frame parent
 -	@param table values keyed on rank (int) whose value is a double. The values should add to 100.
 -	@param table colors Key is the key in data. Value is a color rgb table object.
 -	@param table legend Key is the text to be displayed, value is a color rgb table object.
 -	@return Frame
--]]
local function createPieChart(parent, values, colors, legend)
	-- Only create this travesty of justice once and reuse it.
	if not parent.pieChart then
		local Graph = LibStub("LibGraph-2.0")
		parent.pieChart = Graph:CreateGraphPieChart(nil, parent, "LEFT", "RIGHT", 370, -10, 100, 100)
		createPieLegendFrame(nil, parent.pieChart, "TOP", "BOTTOM", legend)	
	else
		parent.pieChart:ResetPie()
	end
	
	for rank, value in pairs (values) do
		parent.pieChart:AddPie(value, colors[rank])
	end
	
	return parent.pieChart
end

--[[
 -	Generates a Line chart using LibGraph-2.0. This accepts an array or table
 -	whatever the hell you call it that is keyed from a 0 based integer index,
 -	and whose value is a ranking 0 - 5, where 0 means unranked. 
 -
 -	The auto scale feature is a little wonky so we are going to set axis manually.
 -	Also we will scale all data to fit a y-axis of 1. This needs to happen or the
 -	chart library will get furious.
 -
 -	@param Frame parent
 -	@param table playerValues
 -	@param table teamValues
 -	@param string categoryName
 -	@return Frame
--]]
local function createLineChart(parent, playerValues, teamValues, categoryName)
	local scaledPlayer = {}
	local scaledTeam = {}
	local highest = 0
	
	-- Get highest value so we can scale
	for _, value in spairs(playerValues, function(t,a,b) 
			return t[b][2] < t[a][2]
		end) 
	do
		highest = value[2]
		break
	end
	for _, value in spairs(teamValues, function(t,a,b) 
			return t[b][2] < t[a][2]
		end) 
	do
		if value[2] > highest then
			highest = value[2]
		end
		break
	end
	
	for _, value in pairs(playerValues) do
		local scaledValue = { value[1], value[2] / highest }
		table.insert(scaledPlayer, { value[1], value[2] / highest })
	end
	
	for _, value in pairs(teamValues) do
		local scaledValue = { value[1], value[2] / highest }
		table.insert(scaledTeam, { value[1], value[2] / highest })
	end

	-- Apparently no way to delete frames, so we need to reuse them.
	if not parent.lineChart then
		local Graph = LibStub("LibGraph-2.0")
		parent.lineChart = Graph:CreateGraphLine("TestLineGraph", parent, "LEFT", "RIGHT", 170, -10, 150, 75)
		parent.lineChart:SetXAxis(0, tablelength(playerValues))
		parent.lineChart:SetYAxis(0, 1)
		parent.lineChart:SetGridColor({0.5,0.5,0.5,0.2})
		parent.lineChart:SetYLabels(false, false)
		parent.lineChart:SetAxisDrawing(true, true)
		parent.lineChart:SetAxisColor({1.0,1.0,1.0,1.0})
		createLineLegend(nil, parent.lineChart, "TOP", "BOTTOM", categoryName)
	else
		parent.lineChart:ResetData()
	end

	parent.lineChart:AddDataSeries(scaledPlayer, {0.0,1.0,0.0,0.8})
	parent.lineChart:AddDataSeries(scaledTeam, {1.0,1.0,0.0,0.8})
	return parent.lineChart
end

--[[
 -	Handler for button clicks on the Match History page that should send
 -	user data to chat, either Guild or Party. The data parameter is a pre
 -	parsed table of each line of text. The button stores a timestamp for
 -	the last time it was clicked to avoid spam.
 -
 -	@param button The button that was clicked.
 -	@param table data
 -	@param string chatType
--]]
local function sendPersonalStatsHandler(button, data, chatType)
	if not button.lastReportTime or button.lastReportTime + SEND_TO_CHAT_COOLDOWN < time() then
		button.lastReportTime = time()
		local version = GetAddOnMetadata("MongoMon", "Version")
		SendChatMessage("╔═════ " .. L["Title"] .. " v" .. version .. " " .. L["BGStats"] .. " ═════╗", chatType)
		for _, text in pairs(data) do
			SendChatMessage("   " .. text, chatType)
		end
		SendChatMessage("╚═════ " .. L["Title"] .. " v" .. version .. " " .. L["BGStats"] .. " ═════╝", chatType)
	end
end

--[[
-	Displays credits splash page of power.
-]]
local function displayCredits()
	creditsFrame:Show()
	PlayMusic("Interface\\AddOns\\MongoMon\\Res\\Soviet.mp3")
end

--[[
 -	Shows Killing blow history frame.
 -
 -	@param MatchHistoryService
--]]
local function displayKillHistory(history)
	local records = history:GetAll()
	
	if not records or tablelength(records) == 0 then 
		print(string.format("|c%s" .. L["NoDataRecorded"], TEXT_COLOR))
		return 
	end
	
	local kills = history:GetTotal("kills")
	if kills == 0 then
		print(string.format("|c%s" .. L["NoDataRecorded"], TEXT_COLOR))
		return 
	end
	
	local numKills = string.gsub(L["NumKillingBlows"], "#COUNT#", kills)
	killHistoryFrame.playerSummaryFontString:SetText(numKills)

	local historyTitle = string.gsub(L["KillHistoryTitle"], "#COUNT#", tablelength(records))
	killHistoryFrame.descriptionFontString:SetText(historyTitle)
	
	local spells = history:GetTopKillingBlowSpells()
	updateTopKillingBlowSpells(killHistoryFrame.topKillingBlowSpellsFrame, spells)
	
	local killHistory = history:GetKillingBlowData()
	killHistoryFrame.scrollingTable:SetData(killHistory)
	
	killHistoryFrame:Show()
end

--[[
 -	Shows the Match History screen. This will use LibgGraph-2.0 to build charts and
 -	various worthless UI elemetns.
 -
 -	@param MatchHistoryService
--]]
local function displayMatchHistory(history)
	local records = history:GetAll()
	local chatReportData = {}

	if not records or tablelength(records) == 0 then 
		print(string.format("|c%s" .. L["NoDataRecorded"], TEXT_COLOR))
		return 
	end
	
	local historyTitle = string.gsub(L["MatchHistoryTitle"], "#COUNT#", tablelength(records))
	matchHistoryFrame.descriptionFontString:SetText(historyTitle)
	
	local mercWins = history:GetTotalWithFunction(function(r) return (r.mercenaryMode and r.didPlayerWin) and 1 or 0 end)
	local mercLosses = history:GetTotalWithFunction(function(r) return (r.mercenaryMode and not r.didPlayerWin) and 1 or 0 end)
	local mercWinRate = round(history:GetRatio(
		function(r) return (r.mercenaryMode and r.didPlayerWin) and 1 or 0 end, 
		function(r) return (r.mercenaryMode and not r.didPlayerWin) and 1 or 0 end
	), 2)
	local mercSummary = mercWins .. " " .. L["Wins"] .. " - " .. mercLosses .. " " .. L["Losses"] .. " (" .. mercWinRate .. "% " .. L["WinRate"] .. ")"
	matchHistoryFrame.mercSummaryFontString:SetText(mercSummary)
	
	local teamWins = history:GetTotal("didPlayerWin")
	local teamLosses = tablelength(records) - teamWins
	local winRate = round(history:GetRatio(
		function(r) return r.didPlayerWin and 1 or 0 end, 
		function(r) return r.didPlayerWin and 0 or 1 end
	), 2)
	local teamSummary = teamWins .. " " .. L["Wins"] .. " - " .. teamLosses .. " " .. L["Losses"] .. " (" .. winRate .. "% " .. L["WinRate"] .. ")"
	tinsert(chatReportData, L["Wins"] .. " - " .. L["Losses"] .. ": " .. teamWins .. " - " .. teamLosses .. " (" .. winRate .. "%)")
	matchHistoryFrame.teamSummaryFontString:SetText(teamSummary)
	
	local playerKills = history:GetTotal("kills")
	local playerDeaths = history:GetTotal("deaths")
	local playerKillRatio = round(history:GetRatio(
		function(r) return r.kills end, 
		function(r) return r.deaths end		
	), 2)
	local playerSummary = playerKills .. " " .. L["Kills"] .. " - " .. playerDeaths .. " " .. L["Deaths"] .. " (" .. playerKillRatio .. "% " .. L["KillDeathRatio"] .. ")"
	tinsert(chatReportData, L["Kills"] .. " - " .. L["Deaths"] .. ": " .. playerKills .. " - " .. playerDeaths .. " (" .. playerKillRatio .. "%)")
	matchHistoryFrame.playerSummaryFontString:SetText(playerSummary)
	
	local pieChartLegend = { [L["Ranked"]] = {0.0,1.0,0.0}, [L["Unranked"]] = {1.0,0.0,0.0} }
	local pieChartColors = { ["ranked"] = {0.0,1.0,0.0}, ["unranked"] = {1.0,0.0,0.0} }
	
	local pieChartDataKills = history:GetRankPercentBreakdownData("rank")
	local lineChartDataPlayerKills = history:GetTrendData("kills")
	local lineChartDataAvgTeamKills = history:GetTrendData("avgTeamKills")
	createPieChart(matchHistoryFrame.killsCrestFrame, pieChartDataKills, pieChartColors, pieChartLegend)
	createLineChart(matchHistoryFrame.killsCrestFrame, lineChartDataPlayerKills, lineChartDataAvgTeamKills, L["Kills"])
	
	local lineChartDataDeaths = history:GetTrendData("deaths")
	local lineChartDataAvgTeamDeaths = history:GetTrendData("avgTeamDeaths")
	local pieChartDataClassBreakdown = history:GetClassBreakdownData()
	createPieChart(matchHistoryFrame.noDeathCrestFrame, pieChartDataClassBreakdown, CLASS_TOKEN_COLORS, { [L["ClassBreakdown"]] = { 1.0, 1.0, 1.0 } })
	createLineChart(matchHistoryFrame.noDeathCrestFrame, lineChartDataDeaths, lineChartDataAvgTeamDeaths, L["Deaths"])

	local pieChartDataDamage = history:GetRankPercentBreakdownData("damageRank")
	local lineChartDataDamage = history:GetTrendData("damage")
	local lineChartDataAvgTeamDamage = history:GetTrendData("avgTeamDamage")
	createPieChart(matchHistoryFrame.topDamageCrestFrame, pieChartDataDamage, pieChartColors, pieChartLegend)
	createLineChart(matchHistoryFrame.topDamageCrestFrame, lineChartDataDamage, lineChartDataAvgTeamDamage, L["Damage"])
	
	local pieChartDataHealing = history:GetRankPercentBreakdownData("healingRank")
	local lineChartDataHealing = history:GetTrendData("healing")
	local lineChartDataAvgTeamHealing = history:GetTrendData("avgTeamHealing")
	createPieChart(matchHistoryFrame.topHealingCrestFrame, pieChartDataHealing, pieChartColors, pieChartLegend)
	createLineChart(matchHistoryFrame.topHealingCrestFrame, lineChartDataHealing, lineChartDataAvgTeamHealing, L["Healing"])

	local totalKills = L["Total"] .. ": " .. prettyNumber(history:GetTotal("kills"))
	local averageKills = L["Average"] .. ": " .. prettyNumber(history:GetAverage("kills"))
	local highestKills = L["Highest"] .. ": " .. prettyNumber(history:GetHighestValue("kills"))
	local teamContributionKills = L["TeamContribution"] .. ": " .. prettyNumber(history:GetAverage("playerPercentKillsOfTeam")) .. "%"
	local averageRankKills = L["AverageRank"] .. ": " .. history:GetAverage("rank")
	tinsert(chatReportData, L["Kills"] .. " " .. averageKills .. " (" .. averageRankKills .. ")")
	matchHistoryFrame.killsCrestFrame.summaryFontString:SetText(totalKills .. "\n" .. averageKills .. "\n" .. highestKills .. "\n" .. teamContributionKills .. "\n" .. averageRankKills)
	
	local totalDeaths = L["Total"] .. ": " .. prettyNumber(history:GetTotal("deaths"))
	local averageDeaths = L["Average"] .. ": " .. prettyNumber(history:GetAverage("deaths"))
	local highestDeaths = L["Highest"] .. ": " .. prettyNumber(history:GetHighestValue("deaths"))
	tinsert(chatReportData, L["Deaths"] .. " " .. averageDeaths)
	matchHistoryFrame.noDeathCrestFrame.summaryFontString:SetText(totalDeaths .. "\n" .. averageDeaths .. "\n" .. highestDeaths)
	
	local totalDamage = L["Total"] .. ": " .. prettyNumber(history:GetTotal("damage"))
	local averageDamage = L["Average"] .. ": " .. prettyNumber(history:GetAverage("damage"))
	local highestDamage = L["Highest"] .. ": " .. prettyNumber(history:GetHighestValue("damage"))
	local teamContributionDamage = L["TeamContribution"] .. ": " .. prettyNumber(history:GetAverage("playerPercentDamageOfTeam")) .. "%"
	local averageRankDamage = L["AverageRank"] .. ": " .. history:GetAverage("damageRank")
	tinsert(chatReportData, L["Damage"] .. " " .. averageDamage .. " (" .. averageRankDamage .. ")")
	matchHistoryFrame.topDamageCrestFrame.summaryFontString:SetText(totalDamage .. "\n" .. averageDamage .. "\n" .. highestDamage .. "\n" .. teamContributionDamage .. "\n" .. averageRankDamage)
	
	local totalHealing = L["Total"] .. ": " .. prettyNumber(history:GetTotal("healing"))
	local averageHealing = L["Average"] .. ": " .. prettyNumber(history:GetAverage("healing"))
	local highestHealing = L["Highest"] .. ": " .. prettyNumber(history:GetHighestValue("healing"))
	local teamContributionHealing = L["TeamContribution"] .. ": " .. prettyNumber(history:GetAverage("playerPercentHealingOfTeam")) .. "%"
	local averageRankHealing = L["AverageRank"] .. ": " .. history:GetAverage("healingRank")
	tinsert(chatReportData, L["Healing"] .. " " .. averageHealing .. " (" .. averageRankHealing .. ")")
	matchHistoryFrame.topHealingCrestFrame.summaryFontString:SetText(totalHealing .. "\n" .. averageHealing .. "\n" .. highestHealing .. "\n" .. teamContributionHealing .. "\n" .. averageRankHealing)
	
	local killRank = math.floor(history:GetAverage("rank"))
	if killRank > 0 and killRank <= 5 then
		matchHistoryFrame.killsCrestTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\DerpRank" .. killRank)
		matchHistoryFrame.killsCrestFrame.summaryFontString:SetFontObject("GameFontNormalSmall")
	else
		matchHistoryFrame.killsCrestTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\RankCrestGrayBackground")
		matchHistoryFrame.killsCrestFrame.summaryFontString:SetFontObject("GameFontHighlightSmall")
	end

	if history:GetAverage("deaths") <= 1 then
		matchHistoryFrame.noDeathCrestTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\SippieCupRank")
		matchHistoryFrame.noDeathCrestFrame.summaryFontString:SetFontObject("GameFontNormalSmall")
	else
		matchHistoryFrame.noDeathCrestTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\RankCrestGrayBackground")
		matchHistoryFrame.noDeathCrestFrame.summaryFontString:SetFontObject("GameFontHighlightSmall")
	end
	
	local damageRank = math.floor(history:GetAverage("damageRank"))
	if damageRank > 0 and damageRank <= 5 then
		matchHistoryFrame.topDamageCrestTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\WheelchairRank" .. damageRank)
		matchHistoryFrame.topDamageCrestFrame.summaryFontString:SetFontObject("GameFontNormalSmall")
	else
		matchHistoryFrame.topDamageCrestTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\RankCrestGrayBackground")
		matchHistoryFrame.topDamageCrestFrame.summaryFontString:SetFontObject("GameFontHighlightSmall")
	end
	
	local healingRank = math.floor(history:GetAverage("healingRank"))
	if healingRank > 0 and healingRank <= 5 then
		matchHistoryFrame.topHealingCrestTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\WheelchairRank" .. healingRank)
		matchHistoryFrame.topHealingCrestFrame.summaryFontString:SetFontObject("GameFontNormalSmall")
	else
		matchHistoryFrame.topHealingCrestTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\RankCrestGrayBackground")
		matchHistoryFrame.topHealingCrestFrame.summaryFontString:SetFontObject("GameFontHighlightSmall")
	end
	
	local topSpecKills = history:GetTopSpecs("kills")
	updateTopSpecs(matchHistoryFrame.topSpecKills, topSpecKills, false)
	
	local topSpecDamage = history:GetTopSpecs("damage")
	updateTopSpecs(matchHistoryFrame.topSpecDamage, topSpecDamage, false)
	
	local topSpecHealing = history:GetTopSpecs("healing")
	updateTopSpecs(matchHistoryFrame.topSpecHealing, topSpecHealing, false)
	
	local topSpecMostSeen = history:GetTopSpecs("all")
	updateTopSpecs(matchHistoryFrame.topSpecMostSeen, topSpecMostSeen, true)
	
	local mapData = history:GetMapData()
	updateBattlegroundStats(matchHistoryFrame.battlegroundStats, mapData)
	
	-- Event handlers for send to party and send to guild buttons
	matchHistoryFrame.sendToPartyButton:SetScript("OnClick", function(self) 
		sendPersonalStatsHandler(self, chatReportData, "PARTY")
	end)
	matchHistoryFrame.sendToGuildButton:SetScript("OnClick", function(self) 
		sendPersonalStatsHandler(self, chatReportData, "GUILD")
	end)
	
	matchHistoryFrame:Show()
end

--[[
 -	Adds MongoMon UI elements to nameplates.
 -
 -	1) Kill - Death score
 -	2) Damage Rank
 -	3) Killing Blows Rank
 -
 -	@param table Player object
 -	@param Frame plateFrame
--]]
local function addMongoMonToNameplate(player, plateFrame)
	-- Create Fontstring for Kill - Death score
	local scoreFontString = plateFrame:CreateFontString()
	scoreFontString:SetFont(_G.NumberFont_Shadow_Small:GetFont(), 15, "THICKOUTLINE")
	if player.enemy then
		scoreFontString:SetTextColor(1, 0.1, 0.1, 0.75)
	else
		scoreFontString:SetTextColor(0, 1, 0, 1)
	end
	scoreFontString:SetPoint("CENTER", 0, 35)
	scoreFontString:SetText(player.kills .. " - " .. player.deaths)
	
	local rankTexture = plateFrame:CreateTexture()
	rankTexture:SetWidth(32)
	rankTexture:SetHeight(32)
	rankTexture:SetPoint("TOPLEFT", plateFrame, "TOPLEFT", 0, 25)
	rankTexture:Hide()

	if player.rank > 0 and player.rank <= MAX_NAMEPLATE_RANK and player.kills > 0 then
		rankTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\DerpRank" .. player.rank)
		rankTexture:Show()
	end

	-- Top Damage Texture	
	local topDamageFrame = CreateFrame("FRAME", nil, plateFrame)
	topDamageFrame:SetPoint("TOPRIGHT", plateFrame, "TOPRIGHT", -10, 25)
	topDamageFrame:SetWidth(34)
	topDamageFrame:SetHeight(34)
	
	-- Top Damage Texture
	topDamageFrame.topDamageTexture = topDamageFrame:CreateTexture()
	topDamageFrame.topDamageTexture:SetPoint("CENTER")
	topDamageFrame.topDamageTexture:SetAllPoints()
	topDamageFrame:Hide()
	topDamageFrame.topDamageTexture:Hide()
	
	if player.damage > 0 and (player.damageRank >= 1 and player.damageRank <= MAX_NAMEPLATE_RANK) then
		topDamageFrame:Show()
		topDamageFrame.topDamageTexture:Show()
		topDamageFrame.topDamageTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\WheelchairRank" .. player.damageRank)
	end	

	plateFrame.MM = {
		scoreFontString = scoreFontString,
		rankTexture = rankTexture,
		topDamageFrame = topDamageFrame
	}
end

--[[
 -	Updates an existing plateFrame provided by LibNameplateRegistry. We will determine if
 -	we should make any changes to the MongoMon elements:
 -	1) Kill - Death score
 -	2) Damage Rank
 -	3) Killing Blows Rank
 -
 -	@param table Player object
 -	@param Frame plateFrame
--]]
local function updateNameplate(player, plateFrame)
	if not player then return end
	if not plateFrame or not plateFrame.MM or not plateFrame.MM.topDamageFrame or not plateFrame.MM.rankTexture or not plateFrame.MM.scoreFontString then return end
	
	-- Player Kill / Death score
	plateFrame.MM.scoreFontString:Show()
	plateFrame.MM.scoreFontString:SetText(player.kills .. " - " .. player.deaths )
	
	-- Killing Blow Icon
	if player.rank > 0 and player.rank <= MAX_NAMEPLATE_RANK and player.kills > 0 then
		plateFrame.MM.rankTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\DerpRank" .. player.rank)
		plateFrame.MM.rankTexture:Show()
	else
		plateFrame.MM.rankTexture:Hide()
	end
	
	-- Top Damage Icon
	if player.damage > 0 and (player.damageRank >= 1 and player.damageRank <= MAX_NAMEPLATE_RANK) then
		plateFrame.MM.topDamageFrame:Show()
		plateFrame.MM.topDamageFrame.topDamageTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\WheelchairRank" .. player.damageRank)
		plateFrame.MM.topDamageFrame.topDamageTexture:Show()
	else
		plateFrame.MM.topDamageFrame.topDamageTexture:Hide()
		plateFrame.MM.topDamageFrame:Hide()
	end
end

--[[
 -	Gets the approprivate flavor text for the After Action report.
 - 	Uses the provided MatchHistoryRecord to determine which one to use.
 -
 -	@param MatchHistoryRecord
 -	@return string
--]]
local function getFlavorText(record)
	if record.kills > record.teamKills then 
		return L["FlavorBestPlayerKillsTeam"]
	end 
	
	if record.damage > record.teamDamage then
		return L["FlavorBestPlayerDamageTeam"]
	end

	if record.healing > record.teamHealing then
		return L["FlavorBestPlayerHealingTeam"]
	end
	
	if record.kills > record.enemyKills then 
		return L["FlavorBestPlayerKillsEnemy"]
	end 
	
	if record.damage > record.enemyDamage then
		return L["FlavorBestPlayerDamageEnemy"]
	end

	if record.healing > record.enemyHealing then
		return L["FlavorBestPlayerHealingEnemy"]
	end
	
	-- Possible flavor text suggestions. Will be random depending on outcome of game and player
	-- performance.
	local flavor
	if (record.rank <= MAX_PLAYER_RANK or record.damageRank <= MAX_PLAYER_RANK or record.healingRank <= MAX_PLAYER_RANK) and record.deaths <= 2 then -- Good player
		flavor = { L["FlavorGoodPlayer"], L["FlavorGoodPlayer2"], L["FlavorGoodPlayer3"], L["FlavorGoodPlayer4"], L["FlavorGoodPlayer5"], L["FlavorGoodPlayer6"] }
		if not record.didPlayerWin then
			flavor = { L["FlavorGoodPlayerBadTeam"], L["FlavorGoodPlayerBadTeam2"] }
		end
	else -- Bad player
		flavor = { L["FlavorBadPlayer"], L["FlavorBadPlayer2"], L["FlavorBadPlayer3"], L["FlavorBadPlayer4"], L["FlavorBadPlayer5"] }
		if not record.didPlayerWin then
			table.insert(flavor, L["FlavorBadPlayerBadTeam"])
		else
			table.insert(flavor, L["FlavorBadPlayerGoodTeam"])
		end
		
		if record.deaths == 0 then
			table.insert(flavor, L["FlavorBadPlayerNoDeaths"])
		end
	end

	local index = math.random(1, table.getn(flavor))
	return flavor[index]
end

--[[
 -	Prepares the after action report. This screen will display the final icons for
 -	kills, damage/healing, and no deaths. It will also summarize briefly the player
 -	stats, performance of his team and some flavor text.
 - 
 -	Display killing blow rank
 -	Display damage rank
 -	Display no death
 -	Get total team damage
 -	Get total enemy damage
 -	Get player percentage damage of team
 -	Get percent team damage vs enemy
 -	Get percent team healing vs enemy 
 -
 -	Simply updates the AAR frame. If displayAar is true then we will also display it. This
 -	is governed by addon options. We can also elect to auto send to chat, if that is the case
 -	we will simulate the button click and remove the send to chat button.
  -
 -	@param MatchHistoryRecord
 -	@param boolean displayAar whether to display the report
 -	@param boolean aarAutoSend whether to auto send the report to chat
--]]
local function updateAfterActionReport(record, displayAar, aarAutoSend)
	if record ~= nil then
		scoreFrame:Hide()
		
		local teamVsEnemyDamage = ""
		local teamVsEnemyHealing = ""
		
		if record.enemyDamage > record.teamDamage then
			local damageDifference = string.format("%.2f", (record.enemyDamage - record.teamDamage) / record.teamDamage * 100)
			teamVsEnemyDamage = string.gsub(L["ResultEnemyTeamOutDamaged"], "#DAMAGE#", damageDifference)
		else
			local damageDifference = string.format("%.2f", (record.teamDamage - record.enemyDamage) / record.enemyDamage * 100)
			teamVsEnemyDamage = string.gsub(L["ResultPlayerTeamOutDamaged"], "#DAMAGE#", damageDifference)
		end
		
		if record.enemyHealing > record.teamHealing then
			local healingDifference = string.format("%.2f", (record.enemyHealing - record.teamHealing) / record.teamHealing * 100)
			teamVsEnemyHealing = string.gsub(L["ResultEnemyTeamOutHealed"], "#HEALING#", healingDifference)
		else
			local healingDifference = string.format("%.2f", (record.teamHealing - record.enemyHealing) / record.enemyHealing * 100)
			teamVsEnemyHealing = string.gsub(L["ResultPlayerTeamOutHealed"], "#HEALING#", healingDifference)
		end
		
		afterActionFrame.killsCrestFrame.subFontString:SetText(L["Rank"] .. " " .. record.rank)
		if record.isHealer then
			afterActionFrame.topDamageCrestFrame.subFontString:SetText(L["Rank"] .. " " .. record.healingRank)
		else
			afterActionFrame.topDamageCrestFrame.subFontString:SetText(L["Rank"] .. " " .. record.damageRank)
		end

		local playerReport =  string.gsub(L["ResultPlayerPercentTeamDamage"], "#DAMAGE#", record.playerPercentDamageOfTeam)
		playerReport = string.gsub(playerReport, "#KILLS#", record.playerPercentKillsOfTeam)
		playerReport = playerReport .. " "  .. string.gsub(L["ResultPlayerPercentTeamHealing"], "#HEALING#", record.playerPercentHealingOfTeam)
		afterActionFrame.reportPlayerFontString:SetText(playerReport)
		
		local teamReport = string.gsub(L["ResultTeamKillDeath"], "#KILLS#", record.teamKills)
		teamReport = string.gsub(teamReport, "#DEATHS#", record.teamDeaths)
		teamReport = teamReport .. " " .. teamVsEnemyDamage
		teamReport = teamReport .. " " .. teamVsEnemyHealing
		afterActionFrame.reportTeamFontString:SetText(teamReport)
		
		local flavor = getFlavorText(record)
		afterActionFrame.flavorFontString:SetText(flavor)
		
		if record.rank > 0 and record.rank <= MAX_PLAYER_RANK and record.kills > 0 then
			afterActionFrame.killsCrestTexture:SetAlpha(1)
			afterActionFrame.killsCrestTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\DerpRank" .. record.rank)
			afterActionFrame.killsCrestFrame.fontString:SetFontObject("GameFontNormalLarge")
			afterActionFrame.killsCrestFrame.subFontString:SetFontObject("GameFontNormalSmall")
		else
			afterActionFrame.killsCrestTexture:SetAlpha(ALPHA_VALUE)
			afterActionFrame.killsCrestTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\RankCrestGrayBackground")
			afterActionFrame.killsCrestFrame.fontString:SetFontObject("GameFontHighlightLarge")
			afterActionFrame.killsCrestFrame.subFontString:SetFontObject("GameFontHighlightSmall")
		end
		afterActionFrame.killsCrestFrame.fontString:SetText(record.kills .. " " .. L["Kills"])
		
		if record.isHealer then
			if record.healingRank >= 1 and record.healingRank <= MAX_PLAYER_RANK and record.healing > 0 then
				afterActionFrame.topDamageCrestTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\WheelchairRank" .. record.healingRank)
				afterActionFrame.topDamageCrestTexture:SetAlpha(1)
				afterActionFrame.topDamageCrestFrame.fontString:SetFontObject("GameFontNormalLarge")
				afterActionFrame.topDamageCrestFrame.subFontString:SetFontObject("GameFontNormalSmall")
			else 
				afterActionFrame.topDamageCrestTexture:SetAlpha(ALPHA_VALUE)
				afterActionFrame.topDamageCrestTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\RankCrestGrayBackground")
				afterActionFrame.topDamageCrestFrame.fontString:SetFontObject("GameFontHighlightLarge")
				afterActionFrame.topDamageCrestFrame.subFontString:SetFontObject("GameFontHighlightSmall")
			end	
			afterActionFrame.topDamageCrestFrame.fontString:SetText(prettyNumber(record.healing) .. " " .. L["Healing"])
		else
			if record.damageRank >= 1 and record.damageRank <= MAX_PLAYER_RANK and record.damage > 0 then
				afterActionFrame.topDamageCrestTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\WheelchairRank" .. record.damageRank)
				afterActionFrame.topDamageCrestTexture:SetAlpha(1)
				afterActionFrame.topDamageCrestFrame.fontString:SetFontObject("GameFontNormalLarge")
				afterActionFrame.topDamageCrestFrame.subFontString:SetFontObject("GameFontNormalSmall")
			else 
				afterActionFrame.topDamageCrestTexture:SetAlpha(ALPHA_VALUE)
				afterActionFrame.topDamageCrestTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\RankCrestGrayBackground")
				afterActionFrame.topDamageCrestFrame.fontString:SetFontObject("GameFontHighlightLarge")
				afterActionFrame.topDamageCrestFrame.subFontString:SetFontObject("GameFontHighlightSmall")
			end	
			afterActionFrame.topDamageCrestFrame.fontString:SetText(prettyNumber(record.damage) .. " " .. L["Damage"])
		end
		
		if record.deaths == 0 then
			afterActionFrame.noDeathCrestTexture:SetAlpha(1)
			afterActionFrame.noDeathCrestTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\SippieCupRank")
			afterActionFrame.noDeathCrestFrame.fontString:SetFontObject("GameFontNormalLarge")
		else
			afterActionFrame.noDeathCrestTexture:SetAlpha(ALPHA_VALUE)
			afterActionFrame.noDeathCrestTexture:SetTexture("Interface\\AddOns\\MongoMon\\Res\\RankCrestGrayBackground")
			afterActionFrame.noDeathCrestFrame.fontString:SetFontObject("GameFontHighlightLarge")
		end
		afterActionFrame.noDeathCrestFrame.fontString:SetText(record.deaths .. " " .. L["Deaths"])
	
		if displayAar then
			afterActionFrame:Show()
		end
		
		if aarAutoSend then
			afterActionFrame.button:Click()
			afterActionFrame.button:Hide()
		else
			afterActionFrame.button:Show()
		end
	end
end

--[[
 -	Flashes the temporary killing blow indicator popup that shows spell used, the
 -	amount, target's name, and the target's class.
 -
 -	@param string spellName
 -	@param int spellAmount
 -	@param string targetName
 -	@param string targetClass
--]]
local function displayKillingBlow(spellName, spellAmount, targetName, targetClass)
	if not targetClass or not spellName then return end
	local class = string.upper(string.gsub(targetClass, " ", ""))
	scoreFrame.killFlashFrame.targetIconTexture:SetTexCoord(unpack(CLASS_ICON_TCOORDS[class]))
	scoreFrame.killFlashFrame.spellIconTexture:SetTexture(GetSpellTexture(spellName))
	scoreFrame.killFlashFrame.spellFontString:SetText(prettyNumber(spellAmount) .. " " .. spellName)
	scoreFrame.killFlashFrame.targetFontString:SetText(targetName)
	scoreFrame.killFlashFrame:Show()
	scoreFrame.killFlashFrame.animationGroup:Stop()
	scoreFrame.killFlashFrame.animationGroup:Play()
end

-- Some initialization
createTopSpecs(matchHistoryFrame.topSpecKills)
createTopSpecs(matchHistoryFrame.topSpecMostSeen)
createTopSpecs(matchHistoryFrame.topSpecDamage)
createTopSpecs(matchHistoryFrame.topSpecHealing)
createBattlegroundStats(matchHistoryFrame.battlegroundStats)
createTopKillingBlowSpells(killHistoryFrame.topKillingBlowSpellsFrame)

if DEBUG_ENABLED then -- Debug testing
	local records = {
		
	}

	local history = MatchHistoryService:Init(records)
	displayKillHistory(history)
	displayMatchHistory(history)
	updateAfterActionReport(records[1], true, false)
end

--[[
 -	Export variables that may be used by other MongoMon source files.
--]]
T["ALPHA_VALUE"] = ALPHA_VALUE
T["BACKDROP_RED"] = BACKDROP_RED
T["BACKDROP_GREEN"] = BACKDROP_GREEN
T["BACKDROP_BAD"] = BACKDROP_BAD
T["displayMatchHistory"] = displayMatchHistory
T["addMongoMonToNameplate"] = addMongoMonToNameplate
T["updateNameplate"] = updateNameplate
T["updateAfterActionReport"] = updateAfterActionReport
T["mongoMonFrame"] = mongoMonFrame
T["scoreFrame"] = scoreFrame
T["afterActionFrame"] = afterActionFrame
T["creditsFrame"] = creditsFrame
T["matchHistoryFrame"] = matchHistoryFrame
T["killHistoryFrame"] = killHistoryFrame
T["displayKillHistory"] = displayKillHistory
T["displayKillingBlow"] = displayKillingBlow
T["displayCredits"] = displayCredits
T["updateScoreboard"] = updateScoreboard
T["displayScoreboard"] = displayScoreboard
T["getDamageHealingDiffText"] = getDamageHealingDiffText