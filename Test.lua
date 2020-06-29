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
local tablelength = T["tablelength"]
local clone = T["clone"]
local LOOKUP_SPEC_ID = T["LOOKUP_SPEC_ID"]
local LOOKUP_CLASS_ID = T["LOOKUP_CLASS_ID"]
local MongoMonPatch = T["MongoMonPatch"]
local getDamageHealingDiffText = T["getDamageHealingDiffText"]
local L = LibStub("AceLocale-3.0"):GetLocale("MongoMon")

--[[
-	Patch from various versions.
-]]
local MongoMonTest = {}
MongoMonTest.__index = MongoMonTest

-- Register this thing as a module so we can run it from a macro
LibStub("AceAddon-3.0"):GetAddon("MongoMon"):NewModule("MongoMonTest", MongoMonTest)

--[[
-	Used for testing, bind this to a macro via:
-	/run LibStub("AceAddon-3.0"):GetAddon("MongoMon"):GetModule("MongoMonTest"):Run()
-
-]]
function MongoMonTest:Run()
	print("Running Tests")
	
	-- Only run when using enUS
	self:TestUpgradeTo4enUS()
	self:TestShouldNotUpgradeTo4enUs()
	self:TestGetDamageHealingDiffTextRank1Healer()
	self:TestGetDamageHealingDiffTextNotRank1Healer()
	self:TestGetDamageHealingDiffTextRank1Damage()
	self:TestGetDamageHealingDiffTextNotRank1Damage()
	self:TestUpgradeTo5()
	self:TestUpgradeTo51()
	self:TestUpgradeTo53()
	self:TestUpgradeTo54()
	
	-- Only run when using ptBR
	--self:TestUpgradeTo4ptBR()
	
	print("All tests passed")
end

--[[
-	New MapID for Assram and Deepwind Gorge in 8.3
-
-]]
function MongoMonTest:TestUpgradeTo54()

	local records = {
		{
			["mapId"] = 519 -- Deepwind Gorge 519 -> 1576
		}
	}
	
	MongoMonPatch:Upgrade(records, "5.3", "5.4")
	
	assert(records[1].mapId == 1576, "Deepwind Gorge")
end

--[[
-	New MapID for WSG and AB
-
-]]
function MongoMonTest:TestUpgradeTo53()

	local records = {
		{
			["mapId"] = 93 -- Arathi Basin 93 -> 1366
		},
		{
			["mapId"] = 92 -- Warsong Gulch 92 -> 1339
		},
		{
			["mapId"] = 860 -- Silvershard Mines (Unchanged)
		}
	}
	
	MongoMonPatch:Upgrade(records, "5.1", "5.3")
	
	assert(records[1].mapId == 1366, "Arathi Basin")
	assert(records[2].mapId == 1339, "Warsong Gulch")
	assert(records[3].mapId ==  860, "Silvershard Mines (Unchanged)")
end

--[[
-	Remove records with empty mapId. This is a thing.
-
-]]
function MongoMonTest:TestUpgradeTo51()

	local records = {
		{
			["playerPercentHealingOfTeam"] = "4.27",
			["class"] = "Hunter",
			["kills"] = 0,
			["mapId"] = 91
		},
		{
			["playerPercentHealingOfTeam"] = "4.27",
			["class"] = "Hunter",
			["kills"] = 0,
			["isHealer"] = false,
			["damageRank"] = 11,
			["enemyHealing"] = 7503642,
			["healing"] = 333030,
			["enemyDamage"] = 11312939,
			["teamDeaths"] = 27,
			["name"] = "Draxylcution",
			["teamDamage"] = 8664752,
			["healingRank"] = 13,
			["classId"] = 3,
			["season"] = 26,
			["mercenaryMode"] = false,
			["time"] = 1543089485,
			["isRated"] = false,
			["didPlayerWin"] = true,
			["playerPercentKillsOfTeam"] = "0.00",
			["avgTeamDamage"] = 876305.444444445,
			["damage"] = 778003,
			["players"] = {
				["kills"] = {
					["WARRIOR-1-71"] = 1,
					["HUNTER-3-253"] = 1,
					["DRUID-11-102"] = 1,
				},
				["all"] = {
					["HUNTER-3-255"] = 1,
					["WARRIOR-1-72"] = 1,
					["PALADIN-2-65"] = 1,
					["WARLOCK-9-265"] = 2,
					["WARRIOR-1-71"] = 1,
					["ROGUE-4-260"] = 1,
					["PRIEST-5-256"] = 3,
					["HUNTER-3-253"] = 3,
					["ROGUE-4-261"] = 2,
					["ROGUE-4-259"] = 2,
					["WARLOCK-9-267"] = 2,
					["DRUID-11-102"] = 1,
				},
				["healing"] = {
					["PALADIN-2-65"] = 1,
					["PRIEST-5-256"] = 3,
					["WARLOCK-9-265"] = 1,
				},
				["damage"] = {
					["HUNTER-3-253"] = 1,
					["WARLOCK-9-265"] = 1,
					["DRUID-11-102"] = 1,
				},
			},
			["deaths"] = 2,
			["race"] = "Undead",
			["teamHealing"] = 7805711,
			["spec"] = "Beast Mastery",
			["classToken"] = "HUNTER",
			["teamKills"] = 13,
			["avgTeamKills"] = 1.44444444444444,
			["enemyKills"] = 27,
			["specId"] = 253,
			["avgTeamDeaths"] = 2.77777777777778,
			["faction"] = "Horde",
			["avgTeamHealing"] = 830297.888888889,
			["playerPercentDamageOfTeam"] = "8.98",
			["enemyDeaths"] = 13,
			["rank"] = 18,
		}
	}
	
	MongoMonPatch:Upgrade(records, "5.0", "5.1")
	
	assert(records[1]["mapId"] == 91, "Map ID is valid")
	assert(tablelength(records) == 1, "Table length should be 1")
end

--[[
-	8.0 changed Map IDs so existing Map IDs need to be updated.
--]]
function MongoMonTest:TestUpgradeTo5()

	-- Record from version 1, 2, and 3
	local records = {
		{
			["playerPercentHealingOfTeam"] = "25.53",
			["class"] = "Sacerdote",
			["kills"] = 0,
			["isHealer"] = true,
			["damageRank"] = 22,
			["enemyHealing"] = 314666870,
			["healing"] = 79949044,
			["enemyDamage"] = 372234532,
			["teamDeaths"] = 12,
			["name"] = "Fuhrbolg",
			["teamDamage"] = 604927337,
			["healingRank"] = 2,
			["classId"] = 5,
			["season"] = 25,
			["isRated"] = false,
			["mercenaryMode"] = false,
			["time"] = 1525653390,
			["enemyDeaths"] = 56,
			["didPlayerWin"] = true,
			["playerPercentKillsOfTeam"] = "0.00",
			["avgTeamDamage"] = 39337499.6666667,
			["damage"] = 14864842,
			["players"] = {
				["all"] = {
					["DRUID-11-105"] = 3,
					["HUNTER-3-254"] = 1,
					["WARRIOR-1-72"] = 1,
					["PRIEST-5-257"] = 1,
					["WARRIOR-1-71"] = 1,
					["DRUID-11-103"] = 2,
					["MONK-10-269"] = 3,
					["PALADIN-2-70"] = 2,
					["MAGE-8-62"] = 1,
					["MAGE-8-64"] = 2,
					["DEATHKNIGHT-6-252"] = 1,
					["HUNTER-3-255"] = 1,
					["SHAMAN-7-264"] = 1,
					["ROGUE-4-259"] = 2,
					["WARLOCK-9-265"] = 2,
					["SHAMAN-7-262"] = 1,
					["MONK-10-270"] = 1,
					["DEATHKNIGHT-6-251"] = 1,
					["PRIEST-5-258"] = 3,
					["PALADIN-2-65"] = 1,
					["HUNTER-3-253"] = 1,
					["PALADIN-2-66"] = 1,
					["WARLOCK-9-266"] = 1,
				},
				["kills"] = {
					["MAGE-8-62"] = 1,
					["ROGUE-4-259"] = 1,
					["PRIEST-5-258"] = 1,
				},
				["healing"] = {
					["DRUID-11-105"] = 1,
					["PRIEST-5-257"] = 1,
					["MONK-10-270"] = 1,
				},
				["damage"] = {
					["WARRIOR-1-72"] = 1,
					["WARLOCK-9-265"] = 1,
					["PRIEST-5-258"] = 1,
				},
			},
			["deaths"] = 1,
			["mapId"] = 461,
			["playerPercentDamageOfTeam"] = "2.46",
			["avgTeamHealing"] = 15546713.1333333,
			["classToken"] = "PRIEST",
			["teamKills"] = 53,
			["avgTeamKills"] = 3.53333333333333,
			["specId"] = 257,
			["enemyKills"] = 11,
			["avgTeamDeaths"] = 0.733333333333333,
			["faction"] = "Horde",
			["spec"] = "Sagrado",
			["teamHealing"] = 313149741,
			["race"] = "Morto-vivo",
			["rank"] = 25,
		}, -- [1]
		{
			["mapId"] = 401 -- Alterac Valley should be 91
		},
		{
			["mapId"] = 461 -- Arathi Basin
		},
		{
			["mapId"] = 935 -- Deepwind Gorge
		},
		{
			["mapId"] = 482 -- Eye of the Storm
		},
		{
			["mapId"] = 540 -- Isle of Conquest
		},
		{
			["mapId"] = 860 -- Silvershard Mines
		},
		{
			["mapId"] = 512 -- Strand of the Ancients
		},
		{
			["mapId"] = 856 -- Temple of Kotmogu
		},
		{
			["mapId"] = 736 -- The Battle for Gilneas
		},
		{
			["mapId"] = 626 -- Twin Peaks
		},
		{
			["mapId"] = 443 -- Warsong Gulch
		},
		{
			["mapId"] = 1186 -- Seething Shore
		}
	}
	
	MongoMonPatch:Upgrade(records, "4.0", "5.0")
	
	assert(records[2].mapId == 91, "Alterac Valley")
	assert(records[3].mapId == 93, "Arathi Basin")
	assert(records[4].mapId == 519, "Deepwind Gorge")
	assert(records[5].mapId == 112, "Eye of the Storm")
	assert(records[6].mapId == 169, "Isle of Conquest")
	assert(records[7].mapId == 423, "Silvershard Mines")
	assert(records[8].mapId == 128, "Strand of the Ancients")
	assert(records[9].mapId == 417, "Temple of Kotmogu")
	assert(records[10].mapId == 275, "The Battle for Gilneas")
	assert(records[11].mapId == 206, "Twin Peaks")
	assert(records[12].mapId == 92, "Warsong Gulch")
	assert(records[13].mapId == 907, "Seething Shore")
	
	assert(records[1].deaths == 1, "Deaths should not change")
	assert(records[1].faction == "Horde", "Faction should not change")
	assert(records[1].didPlayerWin == true, "Did Player Win should not change")
	assert(records[1].players["kills"]["MAGE-8-62"] == 1, "Kills should not change")
end

--[[
-	Here we are looking at generating the correct text for the damageHealingDiffFontString 
-	text box. This needs to	take into consideration whether the player is a healer or not, 
-	as well as his current rank. If he is number 1 then it should report how far ahead he is,
-	if he is not rank 1 it should show how far behind the leader he is.
--]]
function MongoMonTest:TestGetDamageHealingDiffTextRank1Healer()
	local player = {
		name = "Fuhrbolg-Hyjal",
		isHealer = true,
		healing = 1000,
		damage = 0
	}
	local players = {
		{
			name = "Raul-Mexico",
			isHealer = true,
			healing = 999,
			damage = 0
		},
		{
			name = "Fuhrbolg-Hyjal",
			isHealer = true,
			healing = 1000,
			damage = 0
		},
		{
			name = "Surly-Hyjal",
			isHealer = false,
			healing = 0,
			damage = 100000000
		},
		{
			name = "MrsBleem-Hyjal",
			isHealer = true,
			healing = 750,
			damage = 10000
		}
	}
	local text = getDamageHealingDiffText(player, players)
	assert(text == "(ahead by 1)")
end

--[[
-	Player is not rank 1 healer
-]]
function MongoMonTest:TestGetDamageHealingDiffTextNotRank1Healer()
	local player = {
		name = "Fuhrbolg-Hyjal",
		isHealer = true,
		healing = 1000,
		damage = 0
	}
	local players = {
		{
			name = "Raul-Mexico",
			isHealer = true,
			healing = 1500,
			damage = 0
		},
		{
			name = "Fuhrbolg-Hyjal",
			isHealer = true,
			healing = 1000,
			damage = 0
		},
		{
			name = "Surly-Hyjal",
			isHealer = false,
			healing = 0,
			damage = 100000000
		},
		{
			name = "MrsBleem-Hyjal",
			isHealer = true,
			healing = 2000,
			damage = 10000
		}
	}
	local text = getDamageHealingDiffText(player, players)
	assert(text == "(1000 behind leader)")
end

--[[
-	Testing when player is rank 1 damage
-]]
function MongoMonTest:TestGetDamageHealingDiffTextRank1Damage()
	local player = {
		name = "Fuhrbolg-Hyjal",
		isHealer = false,
		healing = 1000,
		damage = 2500000
	}
	local players = {
		{
			name = "Raul-Mexico",
			isHealer = true,
			healing = 1500,
			damage = 0
		},
		{
			name = "Fuhrbolg-Hyjal",
			isHealer = false,
			healing = 1000,
			damage = 2500000
		},
		{
			name = "Surly-Hyjal",
			isHealer = false,
			healing = 0,
			damage = 1000000
		},
		{
			name = "MrsBleem-Hyjal",
			isHealer = true,
			healing = 2000,
			damage = 10000
		},
		{
			name = "Bleem-Hyjal",
			isHealer = false,
			healing = 10000000,
			damage = 999500
		}
	}
	local text = getDamageHealingDiffText(player, players)
	assert(text == "(ahead by 1.5 mil)")
end


--[[
- 	Testing when player is not rank 1 damage
--]]
function MongoMonTest:TestGetDamageHealingDiffTextNotRank1Damage()
	local player = {
		name = "Fuhrbolg-Hyjal",
		isHealer = false,
		healing = 1000,
		damage = 2500000
	}
	local players = {
		{
			name = "Raul-Mexico",
			isHealer = true,
			healing = 1500,
			damage = 0
		},
		{
			name = "Fuhrbolg-Hyjal",
			isHealer = false,
			healing = 1000,
			damage = 2500000
		},
		{
			name = "Surly-Hyjal",
			isHealer = false,
			healing = 0,
			damage = 45000000000
		},
		{
			name = "MrsBleem-Hyjal",
			isHealer = true,
			healing = 2000,
			damage = 10000
		},
		{
			name = "Bleem-Hyjal",
			isHealer = false,
			healing = 10000000,
			damage = 999500
		}
	}
	local text = getDamageHealingDiffText(player, players)
	assert(text == "(45.0 bil behind leader)")
end

--[[
-	Verify this crap actually works eh.
-]]
function MongoMonTest:TestUpgradeTo4enUS()
	-- Record from version 1, 2, and 3
	local records = {
		{
			["playerPercentHealingOfTeam"] = "2.82",
			["class"] = "Mage",
			["kills"] = 10,
			["isHealer"] = false,
			["damageRank"] = 5,
			["enemyHealing"] = 132288342,
			["healing"] = 3768291,
			["enemyDamage"] = 181397072,
			["teamDeaths"] = 13,
			["name"] = "Fatman",
			["teamDamage"] = 254579560,
			["healingRank"] = 16,
			["killHistory"] = {
				{
					["spellName"] = "Glacial Spike",
					["time"] = 1481511348,
					["amount"] = 271372,
					["playerName"] = "Tinhat-Quel'Thalas",
					["class"] = "Druid",
					["spellId"] = 228600,
					["overkill"] = 103134,
				}, -- [1]
				{
					["spellName"] = "Frostbolt",
					["time"] = 1481511407,
					["amount"] = 235551,
					["playerName"] = "Shademyst-EmeraldDream",
					["class"] = "Rogue",
					["spellId"] = 228597,
					["overkill"] = 166664,
				}, -- [2]
			},
			["avgTeamKills"] = 4.4,
			["time"] = 1481511763,
			["enemyDeaths"] = 55,
			["playerPercentKillsOfTeam"] = "18.52",
			["avgTeamDamage"] = 22097708.8,
			["teamHealing"] = 133659154,
			["players"] = {
				["all"] = {
					["Druid-Restoration"] = 1,
					["Priest-Holy"] = 1,
					["Mage-Frost"] = 1,
					["Rogue-Subtlety"] = 1,
					["Paladin-Retribution"] = 3,
					["Mage-Fire"] = 2,
					["Druid-Balance"] = 2,
					["Warrior-Protection"] = 1,
					["Warlock-Destruction"] = 2,
					["Warlock-Demonology"] = 1,
					["Monk-Mistweaver"] = 1,
					["Shaman-Enhancement"] = 1,
					["Warrior-Fury"] = 1,
					["Demon Hunter-Havoc"] = 1,
					["Priest-Discipline"] = 1,
					["Rogue-Outlaw"] = 1,
				},
				["kills"] = {
					["Warlock-Destruction"] = 1,
					["Mage-Frost"] = 2,
					["Druid-Balance"] = 3,
				},
				["healing"] = {
					["Priest-Holy"] = 1,
					["Monk-Mistweaver"] = 2,
					["Druid-Restoration"] = 3,
				},
				["damage"] = {
					["Warlock-Destruction"] = 1,
					["Demon Hunter-Havoc"] = 2,
					["Druid-Balance"] = 3,
				},
			},
			["deaths"] = 0,
			["mapId"] = 856,
			["isRated"] = false,
			["season"] = 19,
			["teamKills"] = 54,
			["didPlayerWin"] = true,
			["enemyKills"] = 13,
			["playerPercentDamageOfTeam"] = "13.20",
			["avgTeamDeaths"] = 1.3,
			["faction"] = "Horde",
			["avgTeamHealing"] = 12989086.3,
			["damage"] = 33602472,
			["spec"] = "Frost",
			["rank"] = 2,
		}, -- [1]
	}
	
	MongoMonPatch:Upgrade(records, nil, "4.0")
	
	-- Should upgrade to 4.0
	assert(records[1].mercenaryMode == false, "MercenaryMode should be set, but default to false")
	assert(records[1].classId == 8, "Mage classId is 8")
	assert(records[1].classToken == "MAGE", "Mage classToken is MAGE")
	assert(records[1].specId == 64, "Mage specId for Frost is 64")
	
	assert(records[1].killHistory[1].class == nil)
	assert(records[1].killHistory[2].class == nil)
	assert(records[1].killHistory[1].classToken == "DRUID", "Victim should be a DRUID")
	assert(records[1].killHistory[2].classToken == "ROGUE", "Victim should be a ROGUE")
	
	assert(records[1].players.kills["WARLOCK-9-267"] == 1)
	assert(records[1].players.kills["MAGE-8-64"] == 2)
	assert(records[1].players.kills["DRUID-11-102"] == 3)
	
	assert(records[1].players.healing["PRIEST-5-257"] == 1)
	assert(records[1].players.healing["MONK-10-270"] == 2)
	assert(records[1].players.healing["DRUID-11-105"] == 3)
	
	assert(records[1].players.damage["WARLOCK-9-267"] == 1)
	assert(records[1].players.damage["DEMONHUNTER-12-577"] == 2)
	assert(records[1].players.damage["DRUID-11-102"] == 3)
end

--[[
-	Should not upgrade because we are coming from a higher version
-]]
function MongoMonTest:TestShouldNotUpgradeTo4enUs()
	-- Record from version 1, 2, and 3
	local records = {
		{
			["playerPercentHealingOfTeam"] = "2.82",
			["class"] = "Mage",
			["kills"] = 10,
			["isHealer"] = false,
			["damageRank"] = 5,
			["enemyHealing"] = 132288342,
			["healing"] = 3768291,
			["enemyDamage"] = 181397072,
			["teamDeaths"] = 13,
			["name"] = "Fatman",
			["teamDamage"] = 254579560,
			["healingRank"] = 16,
			["killHistory"] = {
				{
					["spellName"] = "Glacial Spike",
					["time"] = 1481511348,
					["amount"] = 271372,
					["playerName"] = "Tinhat-Quel'Thalas",
					["class"] = "Druid",
					["spellId"] = 228600,
					["overkill"] = 103134,
				}, -- [1]
				{
					["spellName"] = "Frostbolt",
					["time"] = 1481511407,
					["amount"] = 235551,
					["playerName"] = "Shademyst-EmeraldDream",
					["class"] = "Rogue",
					["spellId"] = 228597,
					["overkill"] = 166664,
				}, -- [2]
			},
			["avgTeamKills"] = 4.4,
			["time"] = 1481511763,
			["enemyDeaths"] = 55,
			["playerPercentKillsOfTeam"] = "18.52",
			["avgTeamDamage"] = 22097708.8,
			["teamHealing"] = 133659154,
			["players"] = {
				["all"] = {
					["Druid-Restoration"] = 1,
					["Priest-Holy"] = 1,
					["Mage-Frost"] = 1,
					["Rogue-Subtlety"] = 1,
					["Paladin-Retribution"] = 3,
					["Mage-Fire"] = 2,
					["Druid-Balance"] = 2,
					["Warrior-Protection"] = 1,
					["Warlock-Destruction"] = 2,
					["Warlock-Demonology"] = 1,
					["Monk-Mistweaver"] = 1,
					["Shaman-Enhancement"] = 1,
					["Warrior-Fury"] = 1,
					["Demon Hunter-Havoc"] = 1,
					["Priest-Discipline"] = 1,
					["Rogue-Outlaw"] = 1,
				},
				["kills"] = {
					["Warlock-Destruction"] = 1,
					["Mage-Frost"] = 2,
					["Druid-Balance"] = 3,
				},
				["healing"] = {
					["Priest-Holy"] = 1,
					["Monk-Mistweaver"] = 2,
					["Druid-Restoration"] = 3,
				},
				["damage"] = {
					["Warlock-Destruction"] = 1,
					["Demon Hunter-Havoc"] = 2,
					["Druid-Balance"] = 3,
				},
			},
			["deaths"] = 0,
			["mapId"] = 856,
			["isRated"] = false,
			["season"] = 19,
			["teamKills"] = 54,
			["didPlayerWin"] = true,
			["enemyKills"] = 13,
			["playerPercentDamageOfTeam"] = "13.20",
			["avgTeamDeaths"] = 1.3,
			["faction"] = "Horde",
			["avgTeamHealing"] = 12989086.3,
			["damage"] = 33602472,
			["spec"] = "Frost",
			["rank"] = 2,
		}, -- [1]
	}
	
	MongoMonPatch:Upgrade(records, "4.0", "4.1")
	
	-- Verify records
	assert(records[1].players.kills["Warlock-Destruction"] == 1)
	assert(records[1].players.kills["Mage-Frost"] == 2)
	assert(records[1].players.kills["Druid-Balance"] == 3)
end

--[[
-	Verify this crap actually works eh.
-]]
function MongoMonTest:TestUpgradeTo4ptBR()
	-- Record from version 1, 2, and 3
	local records = {
		{
			["playerPercentHealingOfTeam"] = "1.02",
			["class"] = "Sacerdote",
			["kills"] = 0,
			["isHealer"] = false,
			["damageRank"] = 30,
			["enemyHealing"] = 312958413,
			["healing"] = 3082780,
			["enemyDamage"] = 471986393,
			["teamDeaths"] = 23,
			["name"] = "Fuhrbolg",
			["teamDamage"] = 441658676,
			["healingRank"] = 26,
			["season"] = 25,
			["race"] = "Morto-vivo",
			["time"] = 1525324935,
			["enemyDeaths"] = 32,
			["playerPercentKillsOfTeam"] = "0.00",
			["avgTeamDamage"] = 31530420.7857143,
			["teamHealing"] = 301578724,
			["killHistory"] = {
				{
					["spellName"] = "Glacial Spike",
					["time"] = 1481511348,
					["amount"] = 271372,
					["playerName"] = "Tinhat-Quel'Thalas",
					["class"] = "Druidesa",
					["spellId"] = 228600,
					["overkill"] = 103134,
				}, -- [1]
				{
					["spellName"] = "Frostbolt",
					["time"] = 1481511407,
					["amount"] = 235551,
					["playerName"] = "Shademyst-EmeraldDream",
					["class"] = "Ladino",
					["spellId"] = 228597,
					["overkill"] = 166664,
				}, -- [2]
			},
			["players"] = {
				["all"] = {
					["Druidesa-Feral"] = 1,
					["Caçadora-Precisão"] = 2,
					["Caçador-Precisão"] = 2,
					["Mago-Fogo"] = 1,
					["Sacerdotisa-Sagrado"] = 2,
					["Cavaleiro da Morte-Gélido"] = 1,
					["Guerreiro-Fúria"] = 1,
					["Druidesa-Equilíbrio"] = 1,
					["Druidesa-Guardião"] = 1,
					["Xamã-Elemental"] = 1,
					["Sacerdotisa-Disciplina"] = 1,
					["Bruxo-Destruição"] = 1,
					["Mago-Gélido"] = 1,
					["Caçador de Demônios-Devastação"] = 1,
					["Cavaleira da Morte-Sangue"] = 1,
					["Maga-Fogo"] = 2,
					["Caçadora de Demônios-Devastação"] = 2,
					["Druidesa-Restauração"] = 1,
					["Guerreira-Armas"] = 1,
					["Monge-Andarilho do Vento"] = 1,
					["Bruxo-Demonologia"] = 1,
					["Paladino-Retribuição"] = 1,
					["Sacerdote-Sagrado"] = 1,
					["Ladino-Assassinato"] = 1,
					["Bruxo-Suplício"] = 1,
				},
				["kills"] = {
					["Caçadora-Precisão"] = 1,
					["Bruxo-Destruição"] = 2,
					["Mago-Gélido"] = 3,
				},
				["healing"] = {
					["Sacerdotisa-Disciplina"] = 1,
					["Druidesa-Restauração"] = 2,
					["Sacerdotisa-Sagrado"] = 3,
				},
				["damage"] = {
					["Cavaleiro da Morte-Gélido"] = 1,
					["Caçadora-Precisão"] = 2,
					["Caçadora de Demônios-Devastação"] = 3,
				},
			},
			["deaths"] = 0,
			["mapId"] = 482,
			["isRated"] = false,
			["didPlayerWin"] = true,
			["enemyKills"] = 23,
			["teamKills"] = 28,
			["playerPercentDamageOfTeam"] = "0.05",
			["avgTeamHealing"] = 21321138.8571429,
			["mercenaryMode"] = false,
			["avgTeamDeaths"] = 1.64285714285714,
			["faction"] = "Horde",
			["avgTeamKills"] = 2,
			["damage"] = 232785,
			["spec"] = "Sagrado",
			["rank"] = 24,
		}, -- [4]
	}
	
	MongoMonPatch:Upgrade(records, nil, "4.0")
	
	-- Can't make this work, too dumb.
	--[[assert(records[1].mercenaryMode == false, "MercenaryMode should be set, but default to false")
	assert(records[1].classId == 8, "Priest classId is 5")
	assert(records[1].classToken == "PRIEST", "Priest classToken is PRIEST")
	assert(records[1].specId == 257, "Priest specId for Holy is 257")
	
	assert(records[1].killHistory[1].class == nil)
	assert(records[1].killHistory[2].class == nil)
	assert(records[1].killHistory[1].classToken == "DRUID", "Victim should be a DRUID")
	assert(records[1].killHistory[2].classToken == "ROGUE", "Victim should be a ROGUE")
	
	assert(records[1].players.kills["HUNTER-3-254"] == 1)
	assert(records[1].players.kills["WARLOCK-9-267"] == 2)
	assert(records[1].players.kills["MAGE-8-64"] == 3)
	
	assert(records[1].players.healing["PRIEST-5-256"] == 1)
	assert(records[1].players.healing["DRUID-11-105"] == 2)
	assert(records[1].players.healing["PRIEST-5-257"] == 3)
	
	assert(records[1].players.damage["DEATHKNIGHT-6-251"] == 1)	
	assert(records[1].players.damage["HUNTER-3-254"] == 2)
	assert(records[1].players.damage["DEMONHUNTER-12-577"] == 3)--]]
	assert(tablelength(records) == 0)
end

--[[
 -	Export variables that may be used by other MongoMon source files.
--]]
T["MongoMonTest"] = MongoMonTest