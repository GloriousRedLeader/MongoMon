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
local CLASS_TOKEN_COLORS = T["CLASS_TOKEN_COLORS"]
local MAX_BG_HISTORY = T["MAX_BG_HISTORY"]
local BG_MAP_IDS = T["BG_MAP_IDS"]
local FACTIONS = T["FACTIONS"]
local spairs = T["spairs"]
local prettyNumber = T["prettyNumber"]
local tablelength = T["tablelength"]
local round = T["round"]
local strsplit = T["strsplit"]

--[[
 - 	This file houses all database functionality for battleground match 
 -	history so we can track character specific stats over the course
 -	of a player's career. It will contain the normal BG stats like
 -	killing blows, deaths, damage done, etc. We will be nice and summarize
 -	the player's rank over the course of many BGs.
 -
 -	Encapsulates our database layer. This API will provide the various
 -	save / retrieve operations needed to move data around.
 -
--]]
local MatchHistoryService = {}

--[[
 -	Sets up our database API.
--]]
function MatchHistoryService:Init(records)
	self.records = records
	return self
end

--[[
 -	Inserts a MatchHistoryRecord into our database and purges older
 -	records when the table exceeds our limit set in the configuration file.
 -
 -	@param MatchHistoryRecord
--]]
function MatchHistoryService:Save(matchHistoryRecord)
	table.insert(self.records, matchHistoryRecord)
	while table.getn(self.records) > MAX_BG_HISTORY do
		local record = table.remove(self.records, 1)
	end
end

--[[
 -	Getter API that returns table of all MatchHistoryRecords we've recorded.
 -
 -	@return table List of MatchHistoryRecords
--]]
function MatchHistoryService:GetAll()
	return self.records
end

--[[
 -	Purges all MatchHistoryRecords. Can be used by the Options panel to clear data.
--]]
function MatchHistoryService:DeleteAll()
	table.wipe(self.records)
end

--[[
-	Creates a string concatenation of a key used in saved player data categories like
-	top kills, top damage, etc. No localized text so its cross platform.
-
-	Current formula is <CLASS_TOKEN>-<CLASS_ID>-<SPEC_ID>
-	e.g.	WARRIOR-1-71		(Warrior, Arms)
-	e.g.	DEATHKNIGHT-6-252	(Death Knight, Unholy)
-
-	@param table
-	@return string
--]]
function MatchHistoryService:CreateKey(player)
	if player ~= nil then
		return player.classToken .. "-" .. tostring(player.classId) .. "-" .. tostring(player.specId)
	end
	return nil
end

--[[
-	Converts a key to its separate parts, return values are in this order:
-	classToken, classId, specId
-
-	@param string
-	@return multi
-]]
function MatchHistoryService:ParseKey(key)
	local data = strsplit("-", key)
	return data[1], tonumber(data[2]), tonumber(data[3])
end

--[[
 -	Returns a table of all killing blow victims across all battleground data, this is sorted
 -	by timestamp descending with most recent on top. The return value is a table of tables, which
 -	are killHistory records. These contain the following fields: playerName, amount, overkill, spellId
 -	spellName, battleground, time. The time field is a timestamp used for sorting.
 -
 -	This is data that is formatted for the Ace ScrollingTable plugin.
 -	https://www.wowace.com/addons/lib-st/pages/set-data/
 -
 -	@return table
--]]
function MatchHistoryService:GetKillingBlowData()
	local data = {}
	for _, record in pairs(self.records) do
		if record.killHistory then
			local battleground = C_Map.GetMapInfo(record.mapId).name
			for _, killingBlow in pairs(record.killHistory) do
				local classColors = CLASS_TOKEN_COLORS[killingBlow.classToken] and CLASS_TOKEN_COLORS[killingBlow.classToken] or { 1, 0, 0 }
				table.insert(data, {
					["cols"] = {
						{
							["value"] = function(z)
								return date('%Y-%m-%d %H:%M:%S', z)
							end,
							["args"] = { killingBlow.time }
						},
						{
							["value"] = killingBlow.playerName
						},
						{
							["value"] = GetSpellInfo(killingBlow.spellId)
						},
						{
							["value"] = function(t) 
								return prettyNumber(t)
							end,
							["args"] = { killingBlow.amount }
						},
						{
							["value"] = battleground
						}
					},
					["color"] = {
						["r"] = classColors[1],
						["g"] = classColors[2],
						["b"] = classColors[3],
						["a"] = 1
					}
				})
			end
		end
	end
	table.sort(data, function(a,b) return a["cols"][1].args[1] > b["cols"][1].args[1] end)
	return data
end

--[[
 -	Iterates through all match history records and tallies class popularity.
 -	Returns a table keyed on class name token (not localized, e.g. DEATHKNIGHT) whose value is a percentage. The total
 -	of all of the values is equal to 100.
 -
 -	@return table
--]]
function MatchHistoryService:GetClassBreakdownData()
	local data = {}
	local totalValues = 0
	for _, record in pairs(self.records) do
		if record.players and record.players["all"] then 
			for key, value in pairs(record.players["all"]) do
				local classToken, _, _ = self:ParseKey(key)
				local currentValue = data[classToken] and data[classToken] or 0
				data[classToken] = currentValue + value
				totalValues = totalValues + value
			end
		end
	end
	local multiplier = 100 / totalValues
	for key, value in pairs(data) do
		data[key] = data[key] * multiplier
	end
	return data
end

--[[
 -	Returns an average value of a numeric filed in a table of tables, using category as the
 -	indexed field of a table within the main table that we are concerned with.
 -	
 - 	@param string
 - 	@return number
--]]
function MatchHistoryService:GetAverage(category)
	local average = 0
	for _, record in pairs(self.records) do
		average = average + record[category]
	end
	return round(average / tablelength(self.records), 2)
end

--[[
 -	Simply adds up the number values mapped to the field specified by category in this table.
 -
 - 	@param string
 - 	@return number
--]]
function MatchHistoryService:GetTotal(category)
	local total = 0
	for _, record in pairs(self.records) do
		if type(record[category]) == "boolean" then
			if record[category] == true then
				total = total + 1
			end
		else
			total = total + record[category]
		end
	end
	return total
end

--[[
- 	A more open ended approach that allows custom search criteria.
-
-	@param function
-	@return number
-]]
function MatchHistoryService:GetTotalWithFunction(f1)
	local total = 0
	for _, record in pairs(self.records) do
		total = total + f1(record)
	end
	return total
end

--[[
 -	Iterate through all records and find the record key that has the highest numeric value.
 -	
 - 	@param string
 - 	@return number
--]]
function MatchHistoryService:GetHighestValue(category)
	local highest = 0
	for _, record in pairs(self.records) do
		local value = record[category]
		if value > highest then
			highest = value
		end
	end
	return highest
end

--[[
 -	Compares two numeric values identified by category1 and category2
 -	producing a ratio between the two values.
 -
 -	@param function f1 Returns first value from record
 -	@param function f2 Returns second value from record
 -	@return double
--]]
function MatchHistoryService:GetRatio(f1, f2)
	local val1 = 0
	local val2 = 0
	for _, record in pairs(self.records) do
		val1 = val1 + f1(record)
		val2 = val2 + f2(record)
	end
	if val2 == 0 then
		return 100
	end
	return val1 / (val1 + val2) * 100
end

--[[
 -	Returns an array of tables This is intended
 -	to be used by the chart functions for mapping data to a line graph.
 -
 -	Rankings can be either rank|damageRank|healingRank
 -	
 -	Example return table:
 -	{{0,5},{1,4},{2,5},{3,3}}	
 -
 -	@param string category
 -	@return table
--]]
function MatchHistoryService:GetTrendData(category)
	local sorted = {}
	local index = 0
	for _, record in spairs(self.records, function(t,a,b) 
		return t[b].time > t[a].time
	end) do
		local value = record[category]
		table.insert(sorted, { index, value } )
		index = index + 1
	end
	return sorted
end

--[[
 -	Returns an array of rankings based on the category provided sorted by
 -	battleground time. This is keyed on ranked or unranked and the value is
 -	a float percent.
 -
 -	Example return table:
 -
 -	["ranked"] = .75
 -	["unranked"] = .25
 -
 -	@param string category
 -	@return table
--]]
function MatchHistoryService:GetRankPercentBreakdownData(category)
	local sorted = { ["ranked"] = 0, ["unranked"] = 0 }
	local total = tablelength(self.records)
	local multiplier = 100 / tablelength(self.records)
	for _, record in spairs(self.records, function(t,a,b) 
		return t[b].time > t[a].time
	end) do
		local rank = record[category] > 5 and 0 or record[category]
		if record[category] > 5 then
			sorted["unranked"] = sorted["unranked"] + 1
		else
			sorted["ranked"] = sorted["ranked"] + 1
		end
	end
	for key, value in pairs(sorted) do
		sorted[key] = value * multiplier
	end
	return sorted
end

--[[
 -	Generates list of the top specs for a specific category including
 -	kills, damage, healing and all.
 -
 -	Returns a table with the following: class, spec, number, percent
 -
 -	@param string
 -	@return table
--]]
function MatchHistoryService:GetTopSpecs(category)
	-- Contains our top three classes
	local data = { }
	
	-- Tally up all the values of category keyed on class - spec
	local temp = {}
	local allSpecs = {}
	local totalSpecs = 0
	for _, record in pairs(self.records) do
		if record.players and record.players[category] then 
			-- Look for just this category
			for key, value in pairs(record.players[category]) do
				local currentValue = temp[key] and temp[key] or 0
				temp[key] = currentValue + value
			end
			
			-- Go through all of the players found to get a percentage breakdown
			for key, value in pairs(record.players["all"]) do
				local currentAllSpecsValue = allSpecs[key] and allSpecs[key] or 0
				allSpecs[key] = currentAllSpecsValue + value
				totalSpecs = totalSpecs + value
			end
		end

	end

	local i = 1
	for key, value in spairs(temp, function(t,a,b) 
		return t[b] < t[a]
	end) do
		local classToken, classId, specId = self:ParseKey(key)
		data[i] = {
			["classToken"] = classToken,
			["classId"] = classId,
			["specId"] = specId,
			["number"] = value,
			["percent"] = round((allSpecs[key] / totalSpecs) * 100, 1)
		}
		i = i + 1
		if i > 3 then break end
	end
	
	return data
end

--[[
 -	Iterates all match data and finds the top three most popular spells
 -	used for killing blows and returns a table for each. Each spell includes
 -	spellId, highestAmount, percent, num.
 -
 -	@return table
--]]
function MatchHistoryService:GetTopKillingBlowSpells()
	-- Contains our top three spells
	local data = { }
	local temp = {}
	local allSpells = {}
	local totalSpells = 0
	for _, record in pairs(self.records) do
		if record.killHistory then
			for _, spell in pairs(record.killHistory) do
				totalSpells = totalSpells + 1
				local currentValue = temp[spell.spellId] and temp[spell.spellId] or {
					num = 0,
					highestAmount = spell.amount,
					spellId = spell.spellId,
					percent = 0
				}
				currentValue.num = currentValue.num + 1
				if spell.amount > currentValue.highestAmount then
					currentValue.highestAmount = spell.amount
				end
				temp[spell.spellId] = currentValue
			end
		end
	end

	local i = 1
	for _, spell in spairs(temp, function(t,a,b) 
		return t[b].num < t[a].num
	end) do
		spell.percent = round((spell.num / totalSpells) * 100, 1)
		table.insert(data, spell)
		i = i + 1
		if i > 3 then break end
	end
	
	return data
end

--[[
 -	Builds a table with battleground map statistics including map id, map name (localized),
 -	and the player's win rate. It contains one entry for each battleground that the player
 -	has data for, otherwise those elements are missing.
 -
 -	The returned keys are: 
 -	1) mapId (int)
 -	2) mapName (string)
 -	3) winRate (float)
 -	4) wins (int)
 -	5) losses (int)
 -
 -	@return table
--]]
function MatchHistoryService:GetMapData()
	local data = {}
	for _, record in pairs(self.records) do
		local key = BG_MAP_IDS[record.mapId]
		if data[key] then
			if record.didPlayerWin then
				data[key].wins = data[key].wins + 1
			else
				data[key].losses = data[key].losses + 1
			end
			data[key].winRate = (data[key].wins / (data[key].wins + data[key].losses)) * 100
		else
			data[key] = {}
			data[key].wins = record.didPlayerWin and 1 or 0
			data[key].losses = record.didPlayerWin and 0 or 1
			data[key].mapName = key
			data[key].mapId = record.mapId
			data[key].winRate = (data[key].wins / (data[key].wins + data[key].losses)) * 100
		end
	end
	return data
end

--[[
 -	This class represents a single batle ground result. It contains all of the
 - 	player stats like damage, healing, killing blows, etc. in addition to some
 -	meta information like BG map, whether the player won, etc.
--]]
local MatchHistoryRecord = {}
MatchHistoryRecord.__index = MatchHistoryRecord

--[[
 -	Constructs a new MatchHistoryRecord instance from the
 -	player object provided. 
 -
 -	Usage: local record = MatchHistoryRecord.new(player)
 -
 - 	Note: This was copied from the Winning addon by Salovia
 - 	https://mods.curse.com/addons/wow/winning
 -
 -	@param table Our Player object
 -	@param table List of Player objects
 -	@return MatchHistoryRecord
--]]
MatchHistoryRecord.New = function(player, players)
	if not player or not players then return end
	
	-- Find total damage and healing for both teams. 
	local enemyDamage = 0
	local enemyHealing = 0
	local teamDamage = 0
	local teamHealing = 0
	local teamKills = 0
	local teamDeaths = 0
	local enemyKills = 0
	local enemyDeaths = 0
	
	local teamSize = 0
	local avgTeamKills = 0
	local avgTeamDeaths = 0
	local avgTeamDamage = 0
	local avgTeamHealing = 0
	
	for _, p in pairs(players) do	
		if p.enemy then
			enemyDamage = enemyDamage + p.damage
			enemyHealing = enemyHealing + p.healing
			enemyKills = enemyKills + p.kills
			enemyDeaths = enemyDeaths + p.deaths
		else
			teamDamage = teamDamage + p.damage
			teamHealing = teamHealing + p.healing
			teamKills = teamKills + p.kills
			teamDeaths = teamDeaths + p.deaths
			if player.GUID ~= p.GUID then
				teamSize = teamSize + 1
				avgTeamKills = avgTeamKills + p.kills
				avgTeamDamage = avgTeamDamage + p.damage
				avgTeamHealing = avgTeamHealing + p.healing
				avgTeamDeaths = avgTeamDeaths + p.deaths
			end
		end
	end
	
	-- NOTE: This is very important. In the unlikely event that a player reloads
	-- his UI after a BG match is over MongoMon will attempt to save the data (again).
	-- However, the GUID values for players will be null as they are scraped from the 
	-- combat log. So since every value is nil the teamSize will be 0. And the below
	-- calculations will result in nil values. We could avoid this by simply checking
	-- the player names, however duplicate stats would still be recorded. The end
	-- of battle ground event signal will fire again when the UI reloads. So we're
	-- leaving this strangeness here to handle that scenario. Another approach is
	-- to create a token for each battleground and check whether it exists in the database
	-- before saving. Too boring.
	if teamSize == 0 then return end	

	avgTeamKills = avgTeamKills / teamSize
	avgTeamDeaths = avgTeamDeaths / teamSize
	avgTeamDamage = avgTeamDamage / teamSize
	avgTeamHealing = avgTeamHealing / teamSize
	
	-- Compute player's percentage of team's output
	-- Author's note: I have been using my addon for 2 years and encountered a bug I'd never seen before.
	-- After a game playing mercenary mode (for alliance), our team registered 0 kills, so naturally I
	-- had 0 kills as well. The division below blew up with a division by zero error, resulting in a corrupt
	-- lua specific error value placed in the saved data. So this was probably happening for people all this
	-- time. Praise Hillary.
	local playerPercentDamageOfTeam = teamDamage > 0 and string.format("%.2f", player.damage / teamDamage * 100) or "0.0"
	local playerPercentHealingOfTeam = teamHealing > 0 and string.format("%.2f", player.healing / teamHealing * 100) or "0.0"
	local playerPercentKillsOfTeam = teamKills > 0 and string.format("%.2f", player.kills / teamKills * 100) or "0.0"
	
	-- Create our new and improved MatchHistoryRecord
	local self = {}
	setmetatable(self, MatchHistoryRecord)
	
	-- Add the main BG stats from the player object
	self.name = player.name
	self.kills = player.kills
	self.deaths = player.deaths
	self.damage = player.damage
	self.healing = player.healing
	self.class = player.class
	self.classId = player.classId
	self.classToken = player.classToken
	self.spec = player.spec
	self.specId = player.specId
	self.rank = player.rank
	self.damageRank = player.damageRank
	self.healingRank = player.healingRank
	self.faction = player.faction
	self.mercenaryMode = player.mercenaryMode
	self.race = player.race
	self.isHealer = player.isHealer
	self.killHistory = player.killHistory
	
	-- Add some extra values to our player object
	self.time = time()
	self.enemyDamage = enemyDamage
	self.enemyHealing = enemyHealing
	self.teamDamage = teamDamage
	self.teamHealing = teamHealing
	self.teamKills = teamKills
	self.teamDeaths = teamDeaths
	self.enemyKills = enemyKills
	self.enemyDeaths = enemyDeaths
	self.avgTeamKills = avgTeamKills
	self.avgTeamDeaths = avgTeamDeaths
	self.avgTeamDamage = avgTeamDamage
	self.avgTeamHealing = avgTeamHealing
	self.playerPercentDamageOfTeam = playerPercentDamageOfTeam
	self.playerPercentHealingOfTeam = playerPercentHealingOfTeam
	self.playerPercentKillsOfTeam = playerPercentKillsOfTeam
	self.players = MatchHistoryRecord:getBGPlayers(players)
	
	local battlefieldWinner = GetBattlefieldWinner() -- Returns 0 for horde 1 for alliance, nil for not over
	if battlefieldWinner ~= nil then
		self.didPlayerWin = FACTIONS[battlefieldWinner] == player.faction
	else
		self.didPlayerWin = false
	end
	
	self.mapId = C_Map.GetBestMapForUnit("player")
	self.season = GetCurrentArenaSeason()
	self.isRated = IsRatedBattleground()	
	
	-- Apparently mapId is not guaranteed and will corrupt data. This record will be lost.
	-- So we might as well be vigilant and assume all values should be verified.
	if self.mapId == nil then return end
--[[	
	if self.name == nil then return end
	if self.kills == nil then return end
	if self.deaths == nil then return end
	if self.damage == nil then return end
	if self.healing == nil then return end
	if self.class == nil then return end
	if self.classId == nil then return end
	if self.classToken == nil then return end
	if self.spec == nil then return end
	if self.specId == nil then return end
	if self.rank == nil then return end
	if self.damageRank == nil then return end
	if self.healingRank == nil then return end
	if self.faction == nil then return end
	if self.mercenaryMode == nil then return end
	if self.race == nil then return end
	if self.isHealer == nil then return end
	if self.killHistory == nil then return end -- can be nil
	if self.time == nil then return end
	if self.enemyDamage == nil then return end
	if self.enemyHealing == nil then return end
	if self.teamDamage == nil then return end
	if self.teamHealing == nil then return end
	if self.teamKills == nil then return end
	if self.teamDeaths == nil then return end
	if self.enemyKills == nil then return end
	if self.enemyDeaths == nil then return end
	if self.avgTeamKills == nil then return end
	if self.avgTeamDeaths == nil then return end
	if self.avgTeamDamage == nil then return end
	if self.avgTeamHealing == nil then return end
	if self.playerPercentDamageOfTeam == nil then return end
	if self.playerPercentHealingOfTeam == nil then return end
	if self.playerPercentKillsOfTeam == nil then return end
	if self.players == nil then return end
	if self.season == nil then return end
	if self.isRated == nil then return end
	if self.didPlayerWin == nil then return end
--]]

	return self
end

--[[
 -	Gets the top ranking mongos by class so we can add class comparisons. This list will be
 -	added to the result saved in the database. The return value is a table of tables, keyed on
 -	the three main categories. These will simply contain a string representing the class-spec.
 -	
 -	It will also contain a fourth category Most Played. Simply by the number of all specs found.
 -
 -	The returned elements are always sorted by number of values.
 -
 -	@param table 
 - 	@return table
--]]
function MatchHistoryRecord:getBGPlayers(players)
	local data = {
		["kills"] = {},
		["damage"] = {},
		["healing"] = {},
		["all"] = {}
	}
	
	-- Top Kills
	local i = 1
	for _, player in spairs(players, function(t,a,b) 
		return t[b].kills < t[a].kills
	end) do
		local key = MatchHistoryService:CreateKey(player)
		if key ~= nil then
			local currentValue = data["kills"][key] and data["kills"][key] or 0
			data["kills"][key] = currentValue + 1
			i = i + 1
			if tablelength(data["kills"]) == 3 then break end
		end
	end
	
	-- Top Damage
	i = 1
	for _, player in spairs(players, function(t,a,b) 
		return t[b].damage < t[a].damage
	end) do
		local key = MatchHistoryService:CreateKey(player)
		if key ~= nil then
			local currentValue = data["damage"][key] and data["damage"][key] or 0
			data["damage"][key] = currentValue + 1
			i = i + 1		
			if tablelength(data["damage"]) == 3 then break end
		end
	end
	
	-- Top Healing
	i = 1
	for _, player in spairs(players, function(t,a,b) 
		return t[b].healing < t[a].healing
	end) do
		local key = MatchHistoryService:CreateKey(player)
		if key ~= nil then
			local currentValue = data["healing"][key] and data["healing"][key] or 0
			data["healing"][key] = currentValue + 1
			i = i + 1
			if tablelength(data["healing"]) == 3 then break end
		end
	end
	
	-- Top All
	for _, player in pairs(players) do
		local key = MatchHistoryService:CreateKey(player)
		if key ~= nil then
			local currentValue = data["all"][key] and data["all"][key] or 0
			data["all"][key] = currentValue + 1	
		end
	end

	return data
end

--[[
 -	Export variables that may be used by other MongoMon source files.
--]]
T["MatchHistoryService"] = MatchHistoryService
T["MatchHistoryRecord"] = MatchHistoryRecord