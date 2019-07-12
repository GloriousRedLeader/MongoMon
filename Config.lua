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

--[[
 -	Library verification follows.
--]]
if not LibStub then
    error(ADDON_NAME, " requires LibStub")
    return
end

if not LibStub("AceAddon-3.0") then
    error(ADDON_NAME, " requires AceAddon-3.0")
    return
end

if not LibStub("AceGUI-3.0") then
    error(ADDON_NAME, " requires AceGUI-3.0")
    return
end

if not LibStub("AceLocale-3.0") then
    error(ADDON_NAME, " requires AceLocale-3.0")
    return
end

if not LibStub("CallbackHandler-1.0") then
    error(ADDON_NAME, " requires CallbackHandler-1.0")
    return
end

if not LibStub("LibNameplateRegistry-1.0") then
    error(ADDON_NAME, " requires LibNameplateRegistry-1.0")
    return
end

if not LibStub("LibButtonGlow-1.0") then
	error(ADDON_NAME, " requires LibButtonGlow-1.0")
	return
end

if not LibStub("AceConfig-3.0") then
	error(ADDON_NAME, " requires AceConfig-3.0")
	return
end

if not LibStub("AceDB-3.0") then
	error(ADDON_NAME, " requires AceDB-3.0")
	return
end

if not LibStub("AceConsole-3.0") then
	error(ADDON_NAME, " requires AceConsole-3.0")
	return
end

if not LibStub("LibGraph-2.0") then
	error(ADDON_NAME, " requires LibGraph-2.0")
	return
end

if not LibStub("ScrollingTable") then
	error(ADDON_NAME, " requires ScrollingTable")
	return
end

local L = LibStub("AceLocale-3.0"):GetLocale("MongoMon")

--[[
 -	This file contains global configuration variables that can be used
 -	elsewhere in the application that govern its behavior.
--]]

-- Only reward mongos whose rank is below this. We currently only have 5 portraits so.
local MAX_PLAYER_RANK = 5

-- Only display ranks from this value and below on nameplates. Too much clutter.
local MAX_NAMEPLATE_RANK = 3

-- Array of our sound files, played when target dies, praise be unto Hillary
local SOUND_FILES = {
	"Interface\\AddOns\\MongoMon\\Res\\Wunderbar.mp3",
	"Interface\\AddOns\\MongoMon\\Res\\GoodGame.mp3",
	"Interface\\AddOns\\MongoMon\\Res\\Sorry.mp3",
	"Interface\\AddOns\\MongoMon\\Res\\Excellent.mp3",
	"Interface\\AddOns\\MongoMon\\Res\\Jahahaha.mp3",
	"Interface\\AddOns\\MongoMon\\Res\\AufWiedersehen.mp3",
	"Interface\\AddOns\\MongoMon\\Res\\EnemyWeakened.mp3",
	"Interface\\AddOns\\MongoMon\\Res\\GreatShot.mp3",
	"Interface\\AddOns\\MongoMon\\Res\\JaWohl.mp3",
	"Interface\\AddOns\\MongoMon\\Res\\AllClear.mp3",
	"Interface\\AddOns\\MongoMon\\Res\\PathCleared.mp3",
	"Interface\\AddOns\\MongoMon\\Res\\Halo.mp3",
	"Interface\\AddOns\\MongoMon\\Res\\Nein.mp3",
	"Interface\\AddOns\\MongoMon\\Res\\JaWohl2.mp3",
	"Interface\\AddOns\\MongoMon\\Res\\Hehhe.mp3"
}

-- http://wowwiki.wikia.com/wiki/SpecializationID
local IMAGE_FILES_BY_SPEC_ID = {
	[259] = "Interface\\AddOns\\MongoMon\\Res\\Broseph",		-- Rogue-Assassination
	[260] = "Interface\\AddOns\\MongoMon\\Res\\Broseph",		-- Rogue-Outlaw
	[261] = "Interface\\AddOns\\MongoMon\\Res\\Broseph",		-- Rogue-Subtlety
	[250] = "Interface\\AddOns\\MongoMon\\Res\\Emo",		-- Death Knight-Blood
	[251] = "Interface\\AddOns\\MongoMon\\Res\\Emo",		-- Death Knight-Frost
	[252] = "Interface\\AddOns\\MongoMon\\Res\\Emo",		-- Death Knight-Unholy
	[72] = "Interface\\AddOns\\MongoMon\\Res\\MadBaby",		-- Warrior-Fury
	[71] = "Interface\\AddOns\\MongoMon\\Res\\MadBaby",		-- Warrior-Arms
	[73] = "Interface\\AddOns\\MongoMon\\Res\\MadBaby",		-- Warrior-Protection
	[255] = "Interface\\AddOns\\MongoMon\\Res\\DerpFace",		-- Hunter-Survival
	[253] = "Interface\\AddOns\\MongoMon\\Res\\DerpFace",		-- Hunter-Beast Mastery
	[254] = "Interface\\AddOns\\MongoMon\\Res\\DerpFace",		-- Hunter-Marksmanship
	[258] = "Interface\\AddOns\\MongoMon\\Res\\Kitten",		-- Priest-Shadow
	[70] = "Interface\\AddOns\\MongoMon\\Res\\AngryGirl",		-- Paladin-Retribution
	[105] = "Interface\\AddOns\\MongoMon\\Res\\CatNerd",		-- Druid-Restoration
	[103] = "Interface\\AddOns\\MongoMon\\Res\\CatLady",		-- Druid-Feral
	[102] = "Interface\\AddOns\\MongoMon\\Res\\Hillary",		-- Druid-Balance
	[265] = "Interface\\AddOns\\MongoMon\\Res\\Impossibru",		-- Warlock-Affliction
	[266] = "Interface\\AddOns\\MongoMon\\Res\\Impossibru",		-- Warlock-Demonology
	[267] = "Interface\\AddOns\\MongoMon\\Res\\Impossibru",		-- Warlock-Destruction
	[577] = "Interface\\AddOns\\MongoMon\\Res\\WhiskeyTango",	-- Demon Hunter-Havoc
	[581] = "Interface\\AddOns\\MongoMon\\Res\\WhiskeyTango",	-- Demon Hunter-Vengeance
	[269] = "Interface\\AddOns\\MongoMon\\Res\\Terminator",		-- Monk-Windwalker
}

-- https://wow.gamepedia.com/API_GetInspectSpecialization { left, right, top, bottom }
local SPEC_ID_ICONS = {
	[250] = { 0, 1/9, 0, 1/5 },			-- Death Knight-Blood
	[251] = { 0, 1/9, 1/5, 2/5 },			-- Death Knight-Frost
	[252] = { 0, 1/9, 2/5, 3/5 },			-- Death Knight-Unholy
	[577] = { 0, 1/9, 3/5, 4/5 },			-- Demon Hunter-Havoc
	[581] = { 0, 1/9, 4/5, 5/5 },			-- Demon Hunter-Vengeance
	[102] = { 1/9, 2/9, 0, 1/5 },			-- Druid-Balance
	[103] = { 1/9, 2/9, 1/5, 2/5 },			-- Druid-Feral
	[104] = { 1/9, 2/9, 2/5, 3/5 },			-- Druid-Guardian
	[105] = { 1/9, 2/9, 3/5, 4/5 },			-- Druid-Restoration
	[253] = { 1/9, 2/9, 4/5, 5/5 },			-- Hunter-Beast Mastery
	[254] = { 2/9, 3/9, 0, 1/5 },			-- Hunter-Marksmanship
	[255] = { 2/9, 3/9, 1/5, 2/5 },			-- Hunter-Survival
	[62] = { 2/9, 3/9, 2/5, 3/5 },			-- Mage-Arcane
	[63] = { 2/9, 3/9, 3/5, 4/5 },			-- Mage-Fire
	[64] = { 2/9, 3/9, 4/5, 5/5 },			-- Mage-Frost
	[268] = { 3/9, 4/9, 0, 1/5 },			-- Monk-Brewmaster
	[270] = { 3/9, 4/9, 1/5, 2/5 },			-- Monk-Mistweaver
	[269] = { 3/9, 4/9, 2/5, 3/5 },			-- Monk-Windwalker
	[65] = { 3/9, 4/9, 3/5, 4/5 },			-- Paladin-Holy
	[66] = { 3/9, 4/9, 4/5, 5/5 },			-- Paladin-Protection
	[70] = { 4/9, 5/9, 0, 1/5 },			-- Paladin-Retribution
	[259] = { 4/9, 5/9, 1/5, 2/5 },			-- Rogue-Assassination
	[260] = { 4/9, 5/9, 2/5, 3/5 },			-- Rogue-Outlaw
	[261] = { 4/9, 5/9, 3/5, 4/5 },			-- Rogue-Subtlety
	[262] = { 4/9, 5/9, 4/5, 5/5 },			-- Shaman-Elemental
	[256] = { 5/9, 6/9, 0, 1/5 },			-- Priest-Discipline
	[263] = { 5/9, 6/9, 1/5, 2/5 },			-- Shaman-Enhancement
	[266] = { 5/9, 6/9, 2/5, 3/5 },			-- Warlock-Demonology
	[267] = { 5/9, 6/9, 3/5, 4/5 },			-- Warlock-Destruction
	[71] = { 5/9, 6/9, 4/5, 5/5 },			-- Warrior-Arms
	[257] = { 6/9, 7/9, 0, 1/5 },			-- Priest-Holy
	[264] = { 6/9, 7/9, 1/5, 2/5 },			-- Shaman-Restoration
	[72] = { 6/9, 7/9, 2/5, 3/5 }, 			-- Warrior-Fury
	[258] = { 7/9, 8/9, 0, 1/5 },			-- Priest-Shadow
	[265] = { 7/9, 8/9, 1/5, 2/5 },			-- Warlock-Affliction
	[73] = { 7/9, 8/9, 2/5, 3/5 }			-- Warrior-Protection
}

-- Class specific colors http://wowwiki.wikia.com/wiki/Class_colors
local CLASS_TOKEN_COLORS = {
	["DEATHKNIGHT"] = { 0.77, 0.12, 0.23 },
	["DEMONHUNTER"] = { 0.64, 0.19, 0.79 },
	["DRUID"] = { 1.0, 0.49, 0.04 },
	["HUNTER"] = { 0.67, 0.83, 0.45 },
	["MAGE"] = { 0.41, 0.80, 0.94 },
	["MONK"] = { 0.33, 0.54, 0.52 },
	["PALADIN"] = { 0.96, 0.55, 0.73 },
	["PRIEST"] = { 1.0, 1.0, 1.0 },
	["ROGUE"] = { 1.0, 0.96, 0.41 },
	["SHAMAN"] = { 0.0, 0.44, 0.87 },
	["WARLOCK"] = { 0.58, 0.51, 0.79 },
	["WARRIOR"] = { 0.78, 0.61, 0.43 }
}

-- Map whose key is classToken and value is ClassID.
local LOOKUP_CLASS_ID = {}

-- Multidimensional map whose first key is classToken and sub keys are 
-- localized spec names. The value returned is SpecializationID
local LOOKUP_SPEC_ID = {}

for classIndex = 1, MAX_CLASSES do
	local _, classToken, id = GetClassInfo(classIndex)
	local numTabs = GetNumSpecializationsForClassID(classIndex)
	LOOKUP_CLASS_ID[classToken] = id
	LOOKUP_SPEC_ID[classToken] = {}
	for i = 1, numTabs do
		local specId, name, _, _, _, _ = GetSpecializationInfoForClassID(classIndex, i)
		LOOKUP_SPEC_ID[classToken][name] = specId
	end
end

-- Updated for 8.0. The fascists changed their API so we can no longer use GetMapNameByID.
-- Whats more is the Map IDs changed as well. Praise stalin. 
-- Use this to get current map id: C_Map.GetBestMapForUnit("player")
local BG_MAP_IDS = {
	[91] = C_Map.GetMapInfo(91).name,	-- Alterac Valley [OLD: 401]
	[93] = C_Map.GetMapInfo(93).name,	-- Arathi Basin - This obviously needs 3 Map IDs (93, 837, 844) [OLD: 461]
	[519] = C_Map.GetMapInfo(519).name,	-- Deepwind Gorge [OLD: 935] 
	[112] = C_Map.GetMapInfo(112).name,	-- Eye of the Storm - Two Map IDs (112, 397) [OLD: 482]
	[169] = C_Map.GetMapInfo(169).name,	-- Isle of Conquest [OLD: 540]
	[423] = C_Map.GetMapInfo(423).name,	-- Silvershard Mines [OLD: 860]
	[128] = C_Map.GetMapInfo(128).name,	-- Strand of the Ancients [OLD: 512]
	[417] = C_Map.GetMapInfo(417).name,	-- Temple of Kotmogu - Two Map IDs (417, 449) [OLD: 856]
	[275] = C_Map.GetMapInfo(275).name,	-- The Battle for Gilneas [OLD: 736]
	[206] = C_Map.GetMapInfo(206).name,	-- Twin Peaks [OLD: 626]
	[92] = C_Map.GetMapInfo(92).name,	-- Warsong Gulch - Two Map IDs (92, 859) [OLD: 443]
	[907] = C_Map.GetMapInfo(907).name,	-- Seething Shore [OLD: 1186]
	[1334] = C_Map.GetMapInfo(1334).name,	-- Wintergrasp "Epic" Battleground lol
	[1478] = C_Map.GetMapInfo(1478).name	-- Assram "Epic" Battleground lol
}

-- Needed to map the codes for the GetBattlefieldWinners API
-- Which is silly because the battlefield stats updates use the string representation
local FACTIONS = {
	[0] = "Horde",
	[1] = "Alliance"
}

-- Only store this many MatchHistoryRecord objects at any given time. Purge oldest record.
local MAX_BG_HISTORY = 50

-- Used to determine whether player is a Healer or DPS
local HEALER_SPECS = { "Discipline", "Holy", "Restoration", "Mistweaver" }

-- Used to determine whether player is a Healer or DPS
local HEALER_SPEC_IDS = { 105, 270, 65, 256, 257, 264 }

-- Matches any "unit" under the player's control, used by the COMBAT_LOG_UNFILTERED event handler to look for killing blows
-- borrowed from the KillingBlow_Enhanced addon. Muchos gracious.
local FILTER_MINE = bit.bor(COMBATLOG_OBJECT_AFFILIATION_MINE, COMBATLOG_OBJECT_REACTION_FRIENDLY, COMBATLOG_OBJECT_CONTROL_PLAYER)

-- Players can only send the after action report to chat once per this many seconds
local SEND_TO_CHAT_COOLDOWN = 60

-- Used for chat window special highlighting
local TEXT_COLOR = "00d606ad"

-- Eff em
local NO_CREDIT = { "Surly", "Bleem", "Mrs. Bleem", "Gajing", "Diablolock7", "Draomin" }

-- Should always be disabled.
local DEBUG_ENABLED = false

--[[
 -	Export variables that may be used by other MongoMon source files.
--]]
T["MAX_PLAYER_RANK"] = MAX_PLAYER_RANK
T["MAX_NAMEPLATE_RANK"] = MAX_NAMEPLATE_RANK
T["SOUND_FILES"] = SOUND_FILES
T["IMAGE_FILES"] = IMAGE_FILES
T["SPEC_ICONS"] = SPEC_ICONS
T["BG_MAP_IDS"] = BG_MAP_IDS
T["FACTIONS"] = FACTIONS
T["MAX_BG_HISTORY"] = MAX_BG_HISTORY
T["HEALER_SPECS"] = HEALER_SPECS
T["FILTER_MINE"] = FILTER_MINE
T["SEND_TO_CHAT_COOLDOWN"] = SEND_TO_CHAT_COOLDOWN
T["DEBUG_ENABLED"] = DEBUG_ENABLED
T["TEXT_COLOR"] = TEXT_COLOR
T["SPEC_ID_ICONS"] = SPEC_ID_ICONS
T["HEALER_SPEC_IDS"] = HEALER_SPEC_IDS
T["LOOKUP_SPEC_ID"] = LOOKUP_SPEC_ID
T["LOOKUP_CLASS_ID"] = LOOKUP_CLASS_ID
T["CLASS_TOKEN_COLORS"] = CLASS_TOKEN_COLORS
T["IMAGE_FILES_BY_SPEC_ID"] = IMAGE_FILES_BY_SPEC_ID
T["NO_CREDIT"] = NO_CREDIT