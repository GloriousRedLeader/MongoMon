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
local strsplit = T["strsplit"]
local LOOKUP_SPEC_ID = T["LOOKUP_SPEC_ID"]
local LOOKUP_CLASS_ID = T["LOOKUP_CLASS_ID"]
local MatchHistoryService = T["MatchHistoryService"]
local L = LibStub("AceLocale-3.0"):GetLocale("MongoMon")

--[[
-	Patch from various versions.
-]]
local MongoMonPatch = {}
MongoMonPatch.__index = MongoMonPatch

--[[
-	Checks if records in the database need to be upgraded.
-
-	@param table of MatchHistoryRecord
-	@param string fromVersionStr
-	@param string toVersionStr
-]]
function MongoMonPatch:Upgrade(records, fromVersionStr, toVersionStr)
	local fromVersion = fromVersionStr ~= nil and tonumber(fromVersionStr) or 0
	local toVersion = toVersionStr ~= nil and tonumber(toVersionStr) or 0

	-- Any version that has saved data before 4.0 (internationalization support)
	if tablelength(records) > 0 and fromVersion == 0 and toVersion >= 4.0 then
		local locale = GetLocale()
		local message = nil
		
		-- We can only reliably, and easily patch the enUS clients. Brazilian clients for some
		-- reason have a different localized className returned by GetBattleFieldScores and
		-- GetClassInfoByID / GetClassInfo. No idea how the addon is supposed to function
		-- if this is the case.
		if locale == "enUS" then
			local LOCAL_CLASS_TO_CLASS_TOKEN = {}
			for classIndex = 1, MAX_CLASSES do
				local class, classToken, _ = GetClassInfo(classIndex)
				LOCAL_CLASS_TO_CLASS_TOKEN[class] = classToken
			end
			
			for key, record in pairs(records) do
				-- Relabel Keys for history[x].players.all / kills / damage / healing
				if record.players ~= nil and tablelength(record.players) > 0 then
					if record.players.all ~= nil then self:PatchKey(record.players.all, LOCAL_CLASS_TO_CLASS_TOKEN) end
					if record.players.kills ~= nil then self:PatchKey(record.players.kills, LOCAL_CLASS_TO_CLASS_TOKEN) end
					if record.players.damage ~= nil then self:PatchKey(record.players.damage, LOCAL_CLASS_TO_CLASS_TOKEN) end
					if record.players.healing ~= nil then self:PatchKey(record.players.healing, LOCAL_CLASS_TO_CLASS_TOKEN) end
					
				end
				
				-- Add classToken to history[x].killHistory[y]
				-- Remove class from history[x].killHistory[y]
				if record.killHistory ~= nil and tablelength(record.killHistory) > 0 then
					for _, victim in pairs(record.killHistory) do
						if victim.class ~= nil then
							victim.classToken = LOCAL_CLASS_TO_CLASS_TOKEN[victim.class]
							victim["class"] = nil
						end
					end
				end
				
				-- Add mercenaryMode = false to history[x]	
				record.mercenaryMode = false
				
				-- Add classToken to history[x] (use class)
				record.classToken = LOCAL_CLASS_TO_CLASS_TOKEN[record.class]
				
				-- Add specId to history[x] (use spec and class)
				record.specId = LOOKUP_SPEC_ID[record.classToken][record.spec]
				
				-- Add classId to history[x] (use class)
				record.classId = LOOKUP_CLASS_ID[record.classToken]
			end
			
			message = string.gsub(L["PatchSuccess"], "#TO_VERSION#", toVersionStr)
		else
			message = string.gsub(L["PatchFailure"], "#TO_VERSION#", toVersionStr)
			for k, _ in pairs(records) do records[k] = nil end
		end
		print(message)
	end
	
	-- Any version before 5.0 (map id udpate)
	if tablelength(records) > 0 and fromVersion > 0 and fromVersion < 5.0 and toVersion == 5.0 then
		mapIdChanges = {
			[401] = 91,	-- Alterac Valley
			[461] = 93,	-- Arathi Basin
			[935] = 519,	-- Deepwind Gorge
			[482] = 112,	-- Eye of the Storm
			[540] = 169,	-- Isle of Conquest
			[860] = 423,	-- Silvershard Mines
			[512] = 128,	-- Strand of the Ancients
			[856] = 417,	-- Temple of Kotmogu
			[736] = 275,	-- The Battle for Gilneas
			[626] = 206,	-- Twin Peaks
			[443] = 92,	-- Warsong Gulch
			[1186] = 907	-- Seething Shore
		}
		for _, record in pairs(records) do
			if record.mapId ~= nil and mapIdChanges[record.mapId] ~= nil then
				record.mapId = mapIdChanges[record.mapId]
			end
		end
		message = string.gsub(L["PatchSuccess"], "#TO_VERSION#", toVersionStr)
		print(message)
	end
	
	-- Any version before 5.1 (nil mapId)
	if tablelength(records) > 0 and fromVersion > 0 and fromVersion < 5.1 and toVersion >= 5.1 then
		for k, record in pairs(records) do
			if record.mapId == nil then
				table.remove(records, k)
			end
		end
		message = string.gsub(L["PatchSuccess"], "#TO_VERSION#", toVersionStr)
		print(message)
	end
	
	-- Any version before 5.3 WSG and AB new MapIDs
	if tablelength(records) > 0 and fromVersion > 0 and fromVersion < 5.3 and toVersion >= 5.3 then
		mapIdChanges = {
			[93] = 1366,	-- Arathi Basin
			[92] = 1339	-- Warsong Gulch
		}
		for _, record in pairs(records) do
			if record.mapId ~= nil and mapIdChanges[record.mapId] ~= nil then
				record.mapId = mapIdChanges[record.mapId]
			end
		end
		message = string.gsub(L["PatchSuccess"], "#TO_VERSION#", toVersionStr)
		print(message)
	end
	
	-- Any version before 5.4: BG Map ID Update for WoW v8.3
	if tablelength(records) > 0 and fromVersion > 0 and fromVersion < 5.4 and toVersion >= 5.4 then
		mapIdChanges = {
			[519] = 1576	-- Deepwind Gorge
		}
		for _, record in pairs(records) do
			if record.mapId ~= nil and mapIdChanges[record.mapId] ~= nil then
				record.mapId = mapIdChanges[record.mapId]
			end
		end
		message = string.gsub(L["PatchSuccess"], "#TO_VERSION#", toVersionStr)
		print(message)
	end
	
end

--[[
-	Converts old keys of LocalClassName-LocalSpecName to
-	new convention of ClassToken-ClassID-SpecID
-
-	@param table of all, kills, damage, or healing
-	@param table Map of local class name to class tokens
-]]
function MongoMonPatch:PatchKey(category, localClassToClassToken)
	local buffer = {}
	for key, value in pairs(category) do
		local classAndSpec = strsplit("-", key)
		if classAndSpec[1] and classAndSpec[2] then
			local classToken = localClassToClassToken[classAndSpec[1]]
			local classId = LOOKUP_CLASS_ID[classToken]
			local specId = LOOKUP_SPEC_ID[classToken][classAndSpec[2]]
			local newKey = MatchHistoryService:CreateKey({ classToken = classToken, classId = classId, specId = specId })
			category[key] = nil
			buffer[newKey] = value
		end
	end
	for key, value in pairs(buffer) do
		category[key] = value
	end
end

--[[
 -	Export variables that may be used by other MongoMon source files.
--]]
T["MongoMonPatch"] = MongoMonPatch