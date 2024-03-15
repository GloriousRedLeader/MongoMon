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
	MongoMon is an addon that has the following functionality:
	
		1) Updates UnitFrame portraits with a new portrait. All images are in .tga format
		and are located in the Res folder
		2) Plays a sound when player is awarded killing blow. Sound files are .mp3 format
		and are also located in the Res folder.
		3) Creates and displays a frame with a personalized scoreboard. This frame is draggable.
		If the player is ranked in the top 5 in killing blows a special icon will be displayed
		on the scoreboard.
		4) Nameplates will display Kill - Death score above players' names.
		5) Players ranked in the top 5 in killing blows will get a special icon above their
		nameplate as well.
		
	This addon uses the Ace3 framework. This is used to accomplish the following:
	
		1) Abstract persistent storage using AceDB.
		2) Generate the Options Interface page that is part of blizzard's UI.
		3) Interationalization support for multiple languages. All of these translation
		files are located in the Locale folder.
		4) Console support. This is trivial but meh, when in mexico.
		5) Im not sure if LibStub is part of the Ace3 framework but that is used to load
		libraries.
		6) LibNameplatesRegistry, again not sure if this part of Ace3. It is used to get
		access to player nameplates.
		7) LibButtonGlow, this library is used to make the scoreboard flash. Im way too
		fat and lazy to do that myself. The flash occurs after a killing blow.
		
	Known Issues:
	
		1) Responsiveness. The personalized scoreboard and nameplates update sporadically. 
		MongoMon hooks into COMBAT_LOG_EVENT_UNFILTERED and requests a battle ground score
		update when the sub event is UNIT_DIED. It also requests a battleground score
		when the player changes options and finally when out of combat which is
		the PLAYER_HEALTH_REGEN event.
		
		2) Spells that trigger killing blows needs attention. Ray of hope is hitting
		for 3.5 million damage. I am pretty sure that shouldn't count towards killing
		blows, perhaps a check to determine if the target is friendly or not would
		be sufficient.
		
	I photoshopped the majority of the images myself. They are all terrible. Except the
	one with the mad baby which is my nephew. Very cuddly. But also very, very mad
	at all times. The sounds are from Return to Castle Wolfenstein. Whats better than
	a nice german soldat praising you? Nothing. On that subject there is an excellent
	book written by Col. Hans Von Luck, who was a Panzer Commander in the Wehrmacht.
	True gentleman. And another book called "A Higher Call" about a Luftwaffe ace named
	Frans Stiegler. 
	
	Frans saw a banged up b17 flying low over the coast of France and instead of pwning
	it in his 109 he escorted it over German flak batteries so they wouldn't shoot it.
	The american b17 pilot charlie brown (heh) eventually made it back to england. In
	the early 2000's Charlie Brown posted an article in an aviation magazine talking
	about his strange encounter with the friendly Me109 pilot. Frans saw the article
	and they met in Florida.

	API GetSpecializationInfoForClassID		https://wow.gamepedia.com/API_GetSpecializationInfoForClassID
	API GetBattlefieldScore				https://wow.gamepedia.com/API_GetBattlefieldScore
	API GetInspectSpecialization			https://wow.gamepedia.com/API_GetInspectSpecialization
	MapID						http://wow.gamepedia.com/MapID
	SpecializationID				http://wowwiki.wikia.com/wiki/SpecializationID
	ClassId						https://wow.gamepedia.com/ClassId	
	API_FontInstance				http://wow.gamepedia.com/API_FontInstance_SetFontObject
	Saved variable locations 			http://wowwiki.wikia.com/wiki/Saving_variables_between_game_sessions
--]]

--[[
 -	Import variables from other MongoMon source files here.
--]]
local ADDON_NAME, T = ...
local MongoMonPatch = T["MongoMonPatch"]
local IMAGE_FILES_BY_SPEC_ID = T["IMAGE_FILES_BY_SPEC_ID"]
local LOOKUP_SPEC_ID = T["LOOKUP_SPEC_ID"]
local LOOKUP_CLASS_ID = T["LOOKUP_CLASS_ID"]
local HEALER_SPEC_IDS = T["HEALER_SPEC_IDS"]
local DEBUG_ENABLED = T["DEBUG_ENABLED"]
local BG_MAP_IDS = T["BG_MAP_IDS"]
local FILTER_MINE = T["FILTER_MINE"]
local MAX_PLAYER_RANK = T["MAX_PLAYER_RANK"]
local SOUND_FILES = T["SOUND_FILES"]
local ALPHA_VALUE = T["ALPHA_VALUE"]
local NO_CREDIT = T["NO_CREDIT"]
local displayMatchHistory = T["displayMatchHistory"]
local displayKillHistory = T["displayKillHistory"]
local addMongoMonToNameplate = T["addMongoMonToNameplate"]
local updateNameplate = T["updateNameplate"]
local updateScoreboard = T["updateScoreboard"]
local displayScoreboard = T["displayScoreboard"]
local updateAfterActionReport = T["updateAfterActionReport"]
local displayKillingBlow = T["displayKillingBlow"]
local displayCredits = T["displayCredits"]
local mongoMonFrame = T["mongoMonFrame"]
local scoreFrame = T["scoreFrame"]
local creditsFrame = T["creditsFrame"]
local afterActionFrame = T["afterActionFrame"]
local matchHistoryFrame = T["matchHistoryFrame"]
local killHistoryFrame = T["killHistoryFrame"]
local MatchHistoryRecord = T["MatchHistoryRecord"]
local MatchHistoryService = T["MatchHistoryService"]
local TEXT_COLOR = T["TEXT_COLOR"]
local spairs = T["spairs"]
local prettyNumber = T["prettyNumber"]
local tablelength = T["tablelength"]
local round = T["round"]
local strsplit = T["strsplit"]
local L = LibStub("AceLocale-3.0"):GetLocale("MongoMon")

-- Our addon Table
local MongoMon = {

	-- Our options database. Here we store all the flags for toggling sounds, nameplates, portraits, etc.
	db = {},
	
	-- MatchHistory service, database abstraction for storing / retrieving MatchHistoryRecords
	history = nil,

	-- All players in BG { "<PlayerName>-<ServerName>" = { "portrait" = "<PortraitIcon>", ... }, ...}
	players = {},
	
	-- Map of Nameplates, keyed on player name { "<PlayerName>-<ServerName>" = { "fontString" = "<FontString>", ... }, ...}
	plates = {},
	
	-- Map of player name, keyed on guid { "<GUID>" = "<PlayerName>", ... }
	guids = {},
	
	-- Ref to our particular player data structure
	player = nil,
	
	-- Boolean indicating we are in instanced PvP
	isInSupportedBg = false,
	
	-- Boolean, true if in an RBG
	isRatedBattleground = false,
	
	-- Player's faction name
	PLAYER_FACTION = "",
	
	-- Whether player queued using Mercenary Mode
	MERCENARY_MODE = false,
	
	-- Player's name
	PLAYER_NAME = "",
	
	-- Player GUID
	PLAYER_GUID = "",
	
	-- Talent spec, Restoration, Blood, etc.
	PLAYER_SPEC = "",
	
	-- Numeric talent spec id
	PLAYER_SPEC_ID = nil,
	
	-- Pet name fucking hunters
	PET_NAME = "",
	
	-- Flag indicating whether we should toggle total damage or total healing on personal scoreboard.
	IS_HEALER = false,
	
	-- Should only happen once at the end of the BG to display the after action report.
	AAR_DISPLAYED = false,
	
	-- [GUID] = killTime (from GetTime())
	RECENT_KILLS = setmetatable({}, { __mode = "kv" }),
	
	-- Completely unnecessary
	CHECK_AUTHOR = false
}

-- Inject Ace3 Framework support
LibStub("AceAddon-3.0"):NewAddon(MongoMon, "MongoMon", "LibNameplateRegistry-1.0", "AceConsole-3.0")

-- Slash command /mm opens the options interface and prints out the version.
MongoMon:RegisterChatCommand("mm", "ConsoleCommand")

--[[
 -	Options table follows. This defines the options that will be dispalyed on
 -	the Interface Options page within the Blizzard Addons menu.
--]]

-- Our AceDB default options
local defaults = {
	-- UI configuration options
	profile = {
		portraitEnabled = true,
		scoreEnabled = true,
		flashEnabled = true,
		soundEnabled = true,
		aarEnabled = true,
		rbgEnabled = false,
		aarAutoSendEnabled = false,
		nameplateScoreEnabled = true,
		nameplateIconsEnabled = true,
		aarChatLocation = "INSTANCE_CHAT"
	},
	-- Table of match history records. These are fed to the MatchHistoryService
	char = {
		history = {
		
		},
		version = nil
	}
}

-- Our AceDB options table. This creates the UI in the Addons options section automagically.
-- https://www.wowace.com/projects/ace3/pages/ace-config-3-0-options-tables
local options = {
	type = "group",
	name = "MongoMon",
	desc = L["Description"],
	handler = MongoMon,
	set = "OptionSetterHandler",
	get = "OptionGetterHandler",
	args = {
		optionsSubtitle = {
			order = 1,
			type = "header",
			name = L["Subtitle"]
		},
		optionsDescription = {
			order = 2,
			type = "description",
			name = L["Description"]
		},
		portraitTitle = {
			order = 3,
			type = "header",
			name = ""
		},
		portraitEnabled = {
			order = 4,
			type = "toggle",
			name = L["EnablePortrait"]
		},
		portraitDescription = {
			order = 5,
			type = "description",
			name = L["PortraitDescription"]
		},
		scoreEnabled = {
			order = 6,
			type = "toggle",
			name = L["EnableScore"]
		},
		scoreDescription = {
			order = 7,
			type = "description",
			name = L["ScoreDescription"]
		},
		nameplateScoreEnabled = {
			order = 8,
			type = "toggle",
			name = L["EnableNameplateScore"],
		},
		nameplatesScoreDescription = {
			order = 9,
			type = "description",
			name = L["NameplateScoreDescription"]
		},
		nameplateIconsEnabled = {
			order = 10,
			type = "toggle",
			name = L["EnableNameplateIcons"],
		},
		nameplatesIconsDescription = {
			order = 11,
			type = "description",
			name = L["NameplateIconsDescription"]
		},
		flashEnabled = {
			order = 12,
			type = "toggle",
			name = L["EnableFlash"]
		},
		flashDescription = {
			order = 13,
			type = "description",
			name = L["FlashDescription"]
		},
		soundEnabled = {
			order = 14,
			type = "toggle",
			name = L["EnableSound"]
		},
		soundDescription = {
			order = 15,
			type = "description",
			name = L["SoundDescription"]
		},
		aarEnabled = {
			order = 16,
			type = "toggle",
			name = L["EnableAAR"]
		},
		aarDescription = {
			order = 17,
			type = "description",
			name = L["AARDescription"]
		},
		aarAutoSendEnabled = {
			order = 18,
			type = "toggle",
			name = L["EnableAARAutoSend"]
		},
		aarAutoSendDescription = {
			order = 19,
			type = "description",
			name = L["AARAutoSendDescription"]
		},
		aarChatLocation = {
			order = 20,
			type = "select",
			style = "dropdown",
			values = {
				INSTANCE_CHAT = "Battleground",
				PARTY = "Party",
				GUILD = "Guild",
				RAID = "Raid"
			},
			name = L["AARChatLocation"]
		},
		aarChatLocationDescription = {
			order = 21,
			type = "description",
			name = L["AARChatLocationDescription"]
		},
		rbgEnabled = {
			order = 22,
			type = "toggle",
			name = L["EnableRBG"]
		},
		rbgDescription = {
			order = 23,
			type = "description",
			name = L["RBGDescription"]
		}
	}
}

--[[
 -	This is an event handler for the Ace3 framework. When the addon is first loaded
 -	it will fire. We are just going to use it to handle the loading of our 
 -	options database.
--]]
function MongoMon:OnInitialize() 
	-- Generate the database of stored values
	local database = LibStub("AceDB-3.0"):New("MongoMonDB", defaults, true)
	self.db = database.profile
	
	-- Patch saved data if breaking changes between versions, i.e. anything prior to 4.0
	MongoMonPatch:Upgrade(database.char.history, database.char.version, GetAddOnMetadata("MongoMon", "Version"))
	self.history = MatchHistoryService:Init(database.char.history)
	database.char.version = GetAddOnMetadata("MongoMon", "Version")
	
	-- Register the options. This library handles all of the magic.
	LibStub("AceConfig-3.0"):RegisterOptionsTable("MongoMon", options)
	
	-- Generate the Options Interface
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("MongoMon", "MongoMon")
end

--[[
 -	Callback when an option is set in the Interface Options menu.
 -	
 -	Use this to update our internal storage.
 -
 -	@param table info
 -	@param mixed value
--]]
function MongoMon:OptionSetterHandler(info, value)
	self.db[info[#info]] = value
	print("The " .. info[#info] .. " setting was set to: " .. tostring(value) )
	if self.isInSupportedBg then -- Re-initialize state if user changes settings during a battleground
		self:Initialize()
	end
end

--[[
 -	Callback when to get the value of an options item.
 -
 -	@param mixed info
 -	@return mixed
--]]
function MongoMon:OptionGetterHandler(info)
	return self.db[info[#info]]
end

--[[
 -	Prepares the Addon by registering the required events
 -	when a player enters a zone or logs into the game world.
 -	
 -	Has the reverse effect when player zones out of PvP by unregistering
 -	events.
 -	
 -	Note: We can include the UPDATE_WORLD_STATE event to queue the
 -	server for BG data if need be.
 -	
 -	TODO: Disable for arenas?
 -	isArena, isRegistered = IsActiveBattlefieldArena()
--]]
function MongoMon:Initialize()
	self.isInSupportedBg = self:IsSupportedBG()
	self.isRatedBattleground = C_PvP.IsRatedBattleground()

	-- Clears all refs
	table.wipe(self.players)
	table.wipe(self.guids)
	self.player = nil
	
	self.PLAYER_NAME = UnitName("player")
	self.PLAYER_GUID = UnitGUID("player")
	self.PET_NAME = UnitName("pet")
	self.AAR_DISPLAYED = false
	
	-- Adding support for mercenary mode. This should dump all data into the appropriate category.
	self.MERCENARY_MODE = UnitIsMercenary("player")
	if self.MERCENARY_MODE then
		if UnitFactionGroup("player") == "Alliance" then
			self.PLAYER_FACTION = "Horde"
		else 
			self.PLAYER_FACTION = "Alliance"
		end
	else
		self.PLAYER_FACTION = UnitFactionGroup("player")
	end
	
	creditsFrame:Hide()
	afterActionFrame:Hide()
	matchHistoryFrame:Hide()
	killHistoryFrame:Hide()
	scoreFrame:Hide()
		
	if self.isInSupportedBg and ((self.isRatedBattleground and self.db.rbgEnabled) or not self.isRatedBattleground) then 
		-- Register events
		mongoMonFrame:RegisterEvent("UPDATE_BATTLEFIELD_SCORE") 	-- Portraits, Nameplates
		mongoMonFrame:RegisterEvent("PLAYER_REGEN_ENABLED")		-- Portraits, Nameplates
		mongoMonFrame:RegisterEvent("PLAYER_TARGET_CHANGED")		-- Portraits
		mongoMonFrame:RegisterEvent("UNIT_PORTRAIT_UPDATE")		-- Portraits
		mongoMonFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")	-- Sounds, Guids, Killing Blows
		mongoMonFrame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")	-- End of match splash screen
		
		-- Lib Nameplate Registry callbacks
		self:LNR_RegisterCallback("LNR_ON_NEW_PLATE")			-- Nameplates
		self:LNR_RegisterCallback("LNR_ON_RECYCLE_PLATE")		-- Nameplates
		self:LNR_RegisterCallback("LNR_ON_TARGET_PLATE_ON_SCREEN")	-- Nameplates
		self:LNR_RegisterCallback("LNR_ERROR_FATAL_INCOMPATIBILITY")	-- Nameplates

		local currentSpec = GetSpecialization()
		self.PLAYER_SPEC = currentSpec and select(2, GetSpecializationInfo(currentSpec)) or nil
		self.PLAYER_SPEC_ID = currentSpec and select(1, GetSpecializationInfo(currentSpec)) or nil
		self.IS_HEALER = self:IsPlayerHealer(self.PLAYER_SPEC_ID)
		
		if self.db.scoreEnabled then
			displayScoreboard(self.IS_HEALER)
		end
	elseif DEBUG_ENABLED then
		scoreFrame:Show()
		scoreFrame.killDeathFontString:SetText("7 - 11")
		scoreFrame.damageHealingFontString:SetText("137.4 mil damage")
		scoreFrame.damageHealingDiffFontString:SetText("(24.1 mil behind leader)")
		scoreFrame:SetScript("OnMouseUp", function(self, button) -- Toggle the actual bg scoreboard when you press this.
			displayKillingBlow("Mind Blast", 345234, "Raul - Thunderhoof", "PRIEST")
			PlaySoundFile("Interface\\AddOns\\MongoMon\\Res\\Wunderbar.mp3", "master")
			LibStub("LibButtonGlow-1.0").ShowOverlayGlow(scoreFrame)
			LibStub("LibButtonGlow-1.0").HideOverlayGlow(scoreFrame)
		end)
		afterActionFrame.button:SetScript("OnClick", function(self) 
			if not self.lastReportTime or self.lastReportTime + SEND_TO_CHAT_COOLDOWN < time() then
				self.lastReportTime = time()
				local version = GetAddOnMetadata("MongoMon", "Version")
				local text = "Hooray"
				print(MongoMon.db.aarChatLocation)
				SendChatMessage(text, MongoMon.db.aarChatLocation)
			end
		end)
		--afterActionFrame:Show()
		--matchHistoryFrame:Show()
		--killHistoryFrame:Show()
	else 
		-- Events are no longer needed lets be nice and clean them up
		mongoMonFrame:UnregisterEvent("UPDATE_BATTLEFIELD_SCORE")
		mongoMonFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
		mongoMonFrame:UnregisterEvent("PLAYER_TARGET_CHANGED")
		mongoMonFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:LNR_UnregisterAllCallbacks()
		scoreFrame:Hide()
	end
end

--[[
-	Tells us whether the mapId of the current zone is in our list of BGs.
-	This prevents events like Brawls or new BGs from destroying our addon.
-
-	@return boolean
--]]
function MongoMon:IsSupportedBG()
	-- 8.0 Map API Change (no more need to SetMapToCurrentZone())
	local mapID = C_Map.GetBestMapForUnit("player") 

	-- A mapID of -1 (or nil) is a void area where player is transitioning between zones.
	-- We need to schedule the initialize function to be called again in x amount
	-- of seconds so we can try to find the current zone id to check against
	-- our supported list. After setting up the callback this method will immediately
	-- return false.
	if mapID == nil or mapID == -1 then 
		MongoMon:wait(2.0, MongoMon.Initialize, MongoMon)
	end
	
	if BG_MAP_IDS[mapID] ~= nil then
		return true
	else
		return false
	end
end

--[[
 -	Queries to check if the player is currently a healer so we can
 -	provide healing stats instead of damage stats in a BG.
 -
 -	@param number currentSpecId
 -	@return boolean
--]]
function MongoMon:IsPlayerHealer(currentSpecId)
	for _, specId in pairs(HEALER_SPEC_IDS) do
		if specId == currentSpecId then
			return true
		end
	end
	return false
end

--[[
 - 	Completely Hijacked from Choonster's KillingBlow_Enhanced addon. This is much better
 - 	than my original attempts at computing killing blows. This will play a sound and flash the BG
 - 	scoreboard window.
 -
 -	@param int timestamp
 -	@param string event
 -	@param unknown hideCaster
 -	@param string sourceGUID
 -	@param string sourceName
 -	@param int sourceFlags
 -	@param int sourceRaidFlags
 -	@param string destGUID
 -	@param string destName
 -	@param int destFlags
 -	@param int destRaidFlags
 -	@param ... args
--]]
function MongoMon:KillingBlowCheck(timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)
	if
		not destGUID or destGUID == "" or -- If there isn't a valid destination GUID
		(sourceGUID ~= self.PLAYER_GUID and bit.band(sourceFlags, FILTER_MINE) ~= FILTER_MINE) or -- Or the source unit isn't the player or something controlled by the player (the latter check was suggested by Caellian)
		(bit.band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= COMBATLOG_OBJECT_REACTION_HOSTILE) or -- Destination must be hostile
		not destGUID:find("^Player%-") -- Or we're in a PvP zone and the destination unit isn't a player
	then return end -- Return now

	local amount, overkill, spellId, spellName
	
	-- Here we are looking for overkill damage which is used in the block below to flash the scoreboard.
	-- Also, we are going to track killing blows stats for the player, so record that here.
	-- This includes victim, spell used, overkill and amount.
	if event:find("_DAMAGE", 1, true) and not event:find("_DURABILITY_DAMAGE", 1, true) then
		spellId, spellName, _, amount, overkill = ...
		if overkill ~= nil and overkill > 0 and spellId ~= nil and spellName ~= nil and amount ~= nil then
			if self.player ~= nil then
				if not self.player.killHistory then 

					self.player.killHistory = {}
				end
				local player = self.players[destName] and self.players[destName] or nil
				local classToken = (player ~= nil and player.classToken ~= nil) and player.classToken or nil

				if player and class then
					local victim = {
						spellId = spellId,
						amount = amount,
						overkill = overkill,
						spellName = spellName,
						playerName = destName,
						["time"] = time(),
						classToken = classToken
					}
					table.insert(self.player.killHistory, victim)

					if self.db.soundEnabled then
						local index = math.random(1, table.getn(SOUND_FILES))
						local soundFile = SOUND_FILES[index]
						PlaySoundFile(soundFile, "master")
					end
					self.RECENT_KILLS[destGUID] = GetTime() -- Deprecated but probably should not be
					
					-- This section will update the player's personal scoreboard for killing blows and deaths.
					if self.player ~= nil then
						-- This is stranger danger for sure. This value is temporary as it will get overwritten
						-- by the update battleground score function. But in the meantime it is possible to get 
						-- multiple kills in between updates. So, to keep the scoreboard and killing blow sounds
						-- and scoreboard flash all in sync we'll track player kills here as well.
						self.player.kills = self.player.kills + 1
						updateScoreboard(self.player, self.players)
						
						-- Highlight score frame
						if self.db.flashEnabled then
							displayKillingBlow(spellName, amount, destName, classToken)
							LibStub("LibButtonGlow-1.0").ShowOverlayGlow(scoreFrame)
							LibStub("LibButtonGlow-1.0").HideOverlayGlow(scoreFrame)
						end
					end
				end
			end
		end
	end
end

--[[
 -	Handles PLAYER_TARGET_CHANGED events.
--]]
function MongoMon:PlayerTargetChanged()
	if not self.db.portraitEnabled then return end	
	if not self.isInSupportedBg then return end

	if not UnitIsFriend("player", "target") then -- Is target hostile
		if not UnitIsDead("target") then -- Is unit alive

			local name = self:getTargetName()
			
			if not name then return end
			
			local portrait = (self.players[name] and self.players[name].portrait) and self.players[name].portrait or nil
			
			if portrait then -- If nil then it is not overpowered
				TargetFrame.portrait:SetTexture(portrait)
			end
		end
	end	
end

--[[
 -	This is a response from the server to our request battleground score
 -	API call. We are going to cache this data in the MongoMon table.
 -
 -	Here we will set or update our players array and do some calculation to
 -	that determines ranking in the BG and whether the players qualify for
 -	a special nameplate.
--]]
function MongoMon:UpdateBattlefieldScore()
	local numBgPlayers = GetNumBattlefieldScores()
	local originalPlayerKills = 0
	if self.player then
		originalPlayerKills = self.player.kills
	end
	for x = 1, numBgPlayers, 1 do 
		name, killingBlows, honorableKills, deaths, honorGained, faction, race, class, classToken, damageDone, healingDone, bgRating, ratingChange, preMatchMMR, mmrChange, talentSpec = GetBattlefieldScore(x)

		-- Around 6.0 blizzard started sending nil combatants into bgs, this is very rng based.
		-- Look around, you'll see the scoreboard has empty player names. GG.
		if name then 
			local player = self.players[name]
			
			if player then
				player.kills = killingBlows
				player.deaths = deaths
				player.damage = damageDone
				player.healing = healingDone
				player.GUID = self:GetGUIDByName(name) -- In case we don't have the GUID yet

				-- This is needed. Sometimes the class ID and spec below aren't set. Who knows.
				if player.specId == nil then
					player.specId = LOOKUP_SPEC_ID[classToken][talentSpec]
				end
				
				if player.classId == nil then
					player.classId = LOOKUP_CLASS_ID[classToken][talentSpec]
				end
			else
				faction = faction == 0 and "Horde" or "Alliance"
				local specId = LOOKUP_SPEC_ID[classToken][talentSpec]
				local classId = LOOKUP_CLASS_ID[classToken]
				player = {
					name = name,
					kills = killingBlows,
					deaths = deaths,
					damage = damageDone,
					healing = healingDone,
					class = class,
					classId = classId,
					classToken = classToken,
					spec = talentSpec,
					specId = specId,
					portrait = (IMAGE_FILES_BY_SPEC_ID and IMAGE_FILES_BY_SPEC_ID[specId]) and IMAGE_FILES_BY_SPEC_ID[specId] or nil,
					enemy = faction ~= self.PLAYER_FACTION,
					faction = faction,
					rank = 0,
					damageRank = 0,
					healingRank = 0,
					GUID = self:GetGUIDByName(name),
					isHealer = self:IsPlayerHealer(specId),
					race = race
				}				
			end
			
			-- Keyed as such: name-server
			self.players[name] = player 
			
			-- One time assignment of our player object to the global reference
			if not self.player and player.name == self.PLAYER_NAME then
				self.player = player
				self.player.mercenaryMode = self.MERCENARY_MODE
			end
			
			-- Completely unnecessary
			if self.player and not self.CHECK_AUTHOR then
				self:CheckAuthor(player)
			end
		end
	end
	
	-- Sorts BG scores by top kills and iterates in descending order
	local topRanks = 0 
	for _, player in spairs(self.players, function(t,a,b) 
			if t[b].kills == t[a].kills then return t[b].deaths > t[a].deaths -- Tie goes to player with less deaths
			else return t[b].kills < t[a].kills end
	end) do
		topRanks = topRanks + 1
		player.rank = topRanks
	end
	
	-- Sorts BG scores by healing done
	local healingRank = 0
	for _, player in spairs(self.players, function(t,a,b) 
			if t[b].healing == t[a].healing then return t[b].deaths > t[a].deaths -- Tie goes to player with less deaths
			else return t[b].healing < t[a].healing end
		end) 
	do
		healingRank = healingRank + 1
		player.healingRank = healingRank
	end
	
	-- Sorts BG scores by damage
	local damageRank = 0
	for _, player in spairs(self.players, function(t,a,b) 
			if t[b].damage == t[a].damage then return t[b].deaths > t[a].deaths -- Tie goes to player with less deaths
			else return t[b].damage < t[a].damage end
		end) 
	do
		damageRank = damageRank + 1
		player.damageRank = damageRank
		
	end
	
	-- Make all UI Updates to Nameplates and to player scoreboard
	for _, player in pairs(self.players) do

		-- Update nameplates for all players
		local plateFrame = self:GetPlateByGUID(player.GUID)
		updateNameplate(player, plateFrame, self.db.nameplateScoreEnabled, self.db.nameplateIconsEnabled)
		
		-- Update personal scoreboard
		if player.name == self.PLAYER_NAME then
			updateScoreboard(player, self.players)
		end		
	end
	
	-- Looking for end of BG events so we can display the after action report.
	local winningFaction = GetBattlefieldWinner()
	if winningFaction ~= nil and self.AAR_DISPLAYED == false then
		self.AAR_DISPLAYED = true
		local record = MatchHistoryRecord.New(self.player, self.players)
		if record == nil then
			print(string.format("|c%s" .. L["SaveFailed"] .. "|r", TEXT_COLOR))
		else
			self.history:Save(record)
			updateAfterActionReport(record, self.db.aarEnabled, self.db.aarAutoSendEnabled, self.db.aarChatLocation)
		end
	end
end

--[[ 
 -	Helper function to get the compelte target name.
 -	
 -	Gets the complete name of the currently selected target
 -	Returns: Name - Server
 -
 -	@return string
--]]
function MongoMon:getTargetName()
	local targetName, targetRealm = UnitName("target")
		
	-- So this is kind of crappy, players of the same realm will have a nil realm. 
	-- Check for realm and append to name for the love of stalin.
	if targetRealm then
		targetName = targetName .. "-" .. targetRealm
	end	
	
	return targetName
end

--[[
 -	Jesus christ this is a piece of shit. We need to listen to all the trash in the combat
 - 	log to get a handle on a player guid because fucking cocksucking GetBattlefieldScores 
 -	doesn't supply it. Fucking piece of shit.
 -
 -	@param string sourceName
 -	@param string sourceGUID
 -	@param int sourceFlags
 -	@param string destname
 -	@param string destGUID
 -	@param int destFlags
--]]
function MongoMon:CaptureGuids(sourceName, sourceGUID, sourceFlags, destName, destGUID, destFlags) 
	if not self.isInSupportedBg then return end
	
	if sourceGUID and sourceName and sourceGUID:find("^Player%-") and sourceFlags and bit.band(sourceFlags, 66888) then
		if not self.guids[sourceGUID] then
			self.guids[sourceGUID] = sourceName
		end
	end	
	
	if destGUID and destName and destFlags and bit.band(destFlags, 66888) then
		if destGUID ~= sourceGUID and destName ~= sourceName and destGUID:find("^Player%-") then
			if not self.guids[destGUID] then
				self.guids[destGUID] = destName
			end
		end
	end	
end

--[[
 -	Gets a player GUID by the player name. Player name is server-name.
 -	GUID is captured by sniffing through the combat log.
 -
 -	@param string name
 -	@return string
--]]
function MongoMon:GetGUIDByName(name)
	for playerGUID, playerName in pairs (self.guids) do
		if playerName == name then
			return playerGUID
		end
	end
	return nil
end

--[[
 -	Event handler for LibNameplateRegistry's LNR_ON_NEW_PLATE event.
 -	A new plate is in range. Let us do things.
 -	https://www.wowace.com/addons/libnameplateregistry-1-0/pages/api/
 -
 -	@param string eventName
 -	@param Frame plateFrame
 -	@param table plateData 
--]]
function MongoMon:LNR_ON_NEW_PLATE(eventname, plateFrame, plateData)
	if not plateFrame or not plateData or not plateData.GUID or not plateData.name or plateData.type ~= "PLAYER" or not self.isInSupportedBg then return end

	local name = self.guids[plateData.GUID]
	
	if not name then return end

	local player = self.players[name]
	
	if not player then -- Player not found
		return 
	elseif self.PLAYER_GUID == plateData.GUID then
		return	
	elseif  self.db.nameplateScoreEnabled or self.db.nameplateIconsEnabled then
		addMongoMonToNameplate(player, plateFrame, self.db.nameplateScoreEnabled, self.db.nameplateIconsEnabled)
	end
end

--[[
 -	Event handler for LibNameplateRegistry's LNR_ON_RECYCLE_PLATE event.
 -	
 -	I believe this means the player has gone out of range. Not sure if
 -	we care about that.
 -
 -	@param string eventName
 -	@param Frame plateFrame
 -	@param table plateData 
--]]
function MongoMon:LNR_ON_RECYCLE_PLATE(eventname, plateFrame, plateData)
	if plateFrame and plateFrame.MM then
		plateFrame.MM.scoreFontString:Hide()
		plateFrame.MM.rankTexture:Hide()
		plateFrame.MM.topDamageFrame:Hide()
		plateFrame.MM.topDamageFrame.topDamageTexture:Hide()
		plateFrame.MM = nil
	end
end

--[[
 - 	Not entirely sure about this one here.
 -	Perhaps one day we will need it.
 -
 -	@param string eventName
 -	@param Frame plateFrame
 -	@param table plateData
--]]
function MongoMon:LNR_ON_TARGET_PLATE_ON_SCREEN(eventname, plateFrame, plateData)
	-- TODO: ?
end

--[[
 -	Event handler for LibNameplateRegistry's LNR_ERROR_FATAL_INCOMPATIBILITY event.
 -	Make sure we are using a compatible version of LNR.
 -
 -	@param string eventName
 -	@param int errorCode
--]]
function MongoMon:LNR_ERROR_FATAL_INCOMPATIBILITY(eventname, icompatibilityType)
	print("There is a fatal error: " .. eventname .. " Error: " .. icompatibilityType)
end

--[[
 -	Event handler for LibNameplateRegistry's LNR_ERROR_FATAL_INCOMPATIBILITY event.
 -
 -	@param string eventName
 -	@param number errorCode
--]]
function MongoMon:LNR_ERROR_FATAL_INCOMPATIBILITY(eventname, icompatibilityType)
	-- Here you want to check if your add-on and LibNameplateRegistry are not
	-- outdated (old TOC). if they're both up to date then it means that
	-- another add-on author thinks his add-on is more important than yours. In
	-- this later case you can register LNR_ERROR_SETPARENT_ALERT and
	-- LNR_ERROR_SETSCRIPT_ALERT which will detect such behaviour and will give
	-- you the name of the incompatible add-on so you can inform your users properly
	-- about what's happening instead of just silently "not working".
	print(eventname, icompatibilityType)
end

--[[
 -	Completely unnecessary. Detects if Fuhrbolg is in the battle ground
 -	and is a member of the opposing faction so people know to kill him.
 -
 -	@param table player in battleground, potential author
 -	@param string faction either Horder or Alliance for player 
--]]
function MongoMon:CheckAuthor(player)
	if player.name == "Fuhrbolg-Hyjal" or (GetRealmName() == "Hyjal" and player.name == "Fuhrbolg") then
		local isAuthorSameFaction = self.PLAYER_FACTION == player.faction and true or false
		if not isAuthorSameFaction then
			print(string.format("|c%s" .. L["KillAuthor"], TEXT_COLOR))
			self.CHECK_AUTHOR = true
		end
	end
end

--[[
 - 	Command line response handler for the /mm command.
 - 	Displays version and opens Addon window options.
 -
 -	@param string input command 
--]]
function MongoMon:ConsoleCommand(input)
	if input == "stats" then
		displayMatchHistory(self.history)
	elseif input == "kills" then
		displayKillHistory(self.history)
	elseif input == "config" then
		InterfaceOptionsFrame_OpenToCategory(ADDON_NAME)	
		InterfaceOptionsFrame_OpenToCategory(ADDON_NAME)
	elseif input == "clear" then
		self.history:DeleteAll()
		print(L["PurgedMatchData"])
	elseif input == "no" then
		print(string.format("|c%syes", TEXT_COLOR))
	elseif input == "credits" then
		displayCredits()
	else
		print(" ")
		print(string.format("|c%s" .. L["Console"] .. " " .. GetAddOnMetadata("MongoMon", "Version"), TEXT_COLOR))
		print(" ")
		print(string.format("    |c%s/mm stats     |r" .. L["ConsoleStats"], TEXT_COLOR))
		print(string.format("    |c%s/mm kills      |r" .. L["ConsoleKills"], TEXT_COLOR))
		print(string.format("    |c%s/mm config   |r" .. L["ConsoleConfig"], TEXT_COLOR))
		print(string.format("    |c%s/mm clear     |r" .. L["ConsoleClear"], TEXT_COLOR))
		print(string.format("    |c%s/mm credits  |r" .. L["ConsoleCredits"], TEXT_COLOR))
		print(" ")
	end	
end

--[[
 -	Main Addon event listener.
 -
 -	A few notes on RequestBattlefieldScoreData:
 -	
 -	Polls the WoW server for Battleground data. The response is
 -	asynchronous in the form of an UPDATE_BATTLEFIELD_SCORE event.
 -	
 -	The same behavior can be achieved by hitting shift + spacebar to manually
 -	inspect the bg data. This was making me so mad.
 -	
 -	So now I understand why kunda (BattleGroundTargets) does what he does
 -	with the PLAYER_REGEN_ENABLED event. This signifies the player is out of
 -	combat and happens at a regular enough frequency to capture the bg score data.	
 -
 -	@param Frame self - Reference to the widget for which the script was run (frame)
 -	@param string event - Name of the event (string)
 -	@param ... Arguments specific to the event (list) 
--]]
local function EventHandler(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		-- In 8.0 the loadout is no longer provided. Need to query to get it.
		local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName, destFlags, destFlags2 = CombatLogGetCurrentEventInfo()
		MongoMon:CaptureGuids(sourceName, sourceGUID, sourceFlags, destName, destGUID, destFlags)	
		if eventType == "UNIT_DIED" or eventType == "PARTY_KILL" then
			RequestBattlefieldScoreData()		
		end
		MongoMon:KillingBlowCheck(CombatLogGetCurrentEventInfo())	
	elseif event == "PLAYER_TARGET_CHANGED" then
		MongoMon:PlayerTargetChanged()
		RequestBattlefieldScoreData() -- New
	elseif event == "UNIT_PORTRAIT_UPDATE" then
		MongoMon:PlayerTargetChanged()
	elseif event == "PLAYER_REGEN_ENABLED" then
		RequestBattlefieldScoreData()
	elseif event == "UPDATE_BATTLEFIELD_SCORE" then
		MongoMon:UpdateBattlefieldScore()
	elseif event == "PLAYER_ENTERING_WORLD" then
		MongoMon:Initialize()
		RequestBattlefieldScoreData()
	elseif event == "UPDATE_BATTLEFIELD_STATUS" then
		MongoMon:UpdateBattlefieldScore()
	end
end

--[[
 -	Main update function for any continuous operations that we may
 -	require. So far this just checks the AV blacklist option.
 -
 -	Note: This is no longer needed, just leaving it here in case one day
 -	we want to do stuff on the regular.
 -
 -	@param frame self
 -	@param int elapsed
--]]
local function onUpdate(self,elapsed)
	if self.totalTime == nil then self.totalTime = 0 end
	self.totalTime = self.totalTime + elapsed
	if self.totalTime >= 2 then
		self.totalTime = 0
	end
end

-- These are used by the wait function below
local waitTable = {};
local waitFrame = nil;

--[[
-	Generic delay function. We need this because we need access to current 
-	mapID immediately after zoning in to continue with addon initialization.
-	Sometimes it takes multiple attempts to set the map to the current zone
-	(mapID returns -1 which indicates limbo).
-
-	See: http://wowwiki.wikia.com/wiki/Wait
-
-	@param number
-	@param function
-	@param any	function parameters
--]]
function MongoMon:wait(delay, func, ...)
	if(type(delay)~="number" or type(func)~="function") then
		return false;
	end

	if(waitFrame == nil) then
		waitFrame = CreateFrame("Frame","WaitFrame", UIParent);
		waitFrame:SetScript("onUpdate",function (self,elapse)
			local count = #waitTable;
			local i = 1;
			while(i<=count) do
				local waitRecord = tremove(waitTable,i);
				local d = tremove(waitRecord,1);
				local f = tremove(waitRecord,1);
				local p = tremove(waitRecord,1);
				if(d>elapse) then
					tinsert(waitTable,i,{d-elapse,f,p});
					i = i + 1;
				else
					count = count - 1;
					f(unpack(p));
				end
			end
		end);
	end
	tinsert(waitTable,{delay,func,{...}});
	return true;
end

-- Always listening
mongoMonFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
mongoMonFrame:SetScript("OnEvent", EventHandler)
mongoMonFrame:SetScript("OnUpdate", onUpdate)