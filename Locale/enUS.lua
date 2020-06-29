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

-- localization file for english/United States
local L = LibStub("AceLocale-3.0"):NewLocale("MongoMon", "enUS", true)

if not L then return end

-- Brought to you by google translate
L["EnablePortrait"] = "Portrait Frames"
L["PortraitDescription"] = "Check to enable. When enabled enemy unit frame portraits will be replaced with something more appropriate to the enemy's class."
L["EnableSound"] = "Sound Effects"
L["SoundDescription"] = "Check to enable. Receive a few words of encouragement from HQ when you get a killing blow."
L["EnableNameplateScore"] = "Nameplate Score"
L["NameplateScoreDescription"] = "Check to enable. Displays Kill - Death score on enemy nameplates who maintain a 5 - 1 k/d ratio."
L["EnableNameplateIcons"] = "Nameplate Icons"
L["NameplateIconsDescription"] = "Check to enable. The enemy player with the highest stats the BG gets special icons. This way you know who is good at PvP."
L["EnableScore"] = "Personal Scoreboard"
L["ScoreDescription"] = "Check to enable. Displays your Kill/Death ratio in BGs. Lets face it, ctrl + space is just too inconvenient."
L["EnableFlash"] = "Scoreboard Flash"
L["FlashDescription"] = "Check to enable. When you are awarded a killing blow the score frame will flash. This gets annoying. So turn it off."
L["EnableRBG"] = "Use in RBG's"
L["RBGDescription"] = "Check to enable. Enable MongoMon in Rated Battlegrounds (not recommended)."
L["EnableAAR"] = "After Action Report"
L["AARDescription"] = "Check to enable. Splash page summary showing your BG heroics after a match."
L["EnableAARAutoSend"] = "Auto send AAR to chat"
L["AARAutoSendDescription"] = "Check to enable. Too lazy to press the button? We got you covered. Automatically post After Action Report to chat. Has no effect when the After Action Report is disabled."
L["AARChatLocation"] = "AAR Chat Location"
L["AARChatLocationDescription"] = "Send After Action Report briefs to this chat channel. This is the target chat for both manual and when auto-send is enabled. Has no effect when the After Action Report is disabled."

L["Title"] = "MongoMon"
L["TitleAndAuthor"] = "MongoMon by Fuhrbolg"
L["Subtitle"] = "Battleground Enhancer by Fuhrbolg"
L["Description"] = "Guaranteed to increase your Battleground experience by no less than 3% and no more than 6.25%, MongoMon replaces Unit Frame portraits with something more appropriate for the absurd classes who are undoubtedly being played by mouth breathing, keyboard turning, sippie cup drinking 47 year olds.|n|nEnemy nameplates are enhanced to include the Kill - Death score for top Mongos, this way you know who to hunt down and get killed by. Don't be a fool and play the objectives.|n|nAnd for funsies you will receive a radio dispatch from wehrmacht high command when you are awarded a Killing Blow."
L["Console"] = "MongoMon by Fuhrbolg, version"
L["Console2"] = "No thanks to"
L["ConsoleStats"] = "Displays BG statistics screen."
L["ConsoleConfig"] = "Opens Addon configuration panel."
L["ConsoleClear"] = "Purges match history data."
L["PurgedMatchData"] = "MongoMon: Deleted all match data."
L["NoDataRecorded"] = "MongoMon: No data recorded yet."
L["Wins"] = "Wins"
L["Losses"] = "Losses"
L["KillDeathRatio"] = "k/d ratio"
L["WinRate"] = "win rate"
L["Player"] = "Player"
L["Team"] = "Team"
L["PerGame"] = "per game"
L["Total"] = "Total"
L["Average"] = "Average"
L["AverageRank"] = "Average Rank"
L["Highest"] = "Highest"
L["TeamContribution"] = "Team Contribution"
L["Rank"] = "Rank #"
L["Deaths"] = "Deaths"
L["Kills"] = "Kills"
L["Damage"] = "Damage"
L["Healing"] = "Healing"
L["TouchToClose"] = "(touch to close)"
L["RankTitle"] = "Kills"
L["TopDamageTitle"] = "Damage"
L["TopHealingTitle"] = "Healing"
L["NoDeathTitle"] = "Deaths"
L["ResultTeamKillDeath"] = "Your team went #KILLS# - #DEATHS#."
L["ResultEnemyTeamOutDamaged"] = "The enemy outdamaged your team by #DAMAGE#%."
L["ResultEnemyTeamOutHealed"] = "The enemy outhealed your team by #HEALING#%."
L["ResultPlayerTeamOutDamaged"] = "Your team outdamaged the enemy by #DAMAGE#%."
L["ResultPlayerTeamOutHealed"] = "Your team outhealed the enemy team by #HEALING#%."
L["ResultPlayerPercentTeamDamage"] = "You did #DAMAGE#% of your team's damage, and accounted for #KILLS#% of their killing blows."
L["ResultPlayerPercentTeamHealing"] = "You did #HEALING#% of your team's healing."
L["FlavorBestPlayerDamageTeam"] = "You did more damage than your entire team combined."
L["FlavorBestPlayerHealingTeam"] = "You did more healing than your entire team combined."
L["FlavorBestPlayerKillsTeam"] = "You had more kills than the rest of your team combined."
L["FlavorBestPlayerDamageEnemy"] = "You did more damage than the entire enemy team combined."
L["FlavorBestPlayerHealingEnemy"] = "You did more healing than the entire enemy team combined."
L["FlavorBestPlayerKillsEnemy"] = "You had more kills than the entire enemy team combined."
L["FlavorGoodPlayerBadTeam"] = "Despite your team you did quite well."
L["FlavorGoodPlayerBadTeam2"] = "You are a one man army. I guess you have to be when your team is AFK refilling their sippie cups."
L["FlavorGoodPlayer"] = "Your parents must be proud very proud of you."
L["FlavorGoodPlayer2"] = "Your performance was reasonable. Now wipe the drool off your keyboard and do it again."
L["FlavorGoodPlayer3"] = "So you wear a helm irl, big deal You punished many noobs today."
L["FlavorGoodPlayer4"] = "Do you feel good about what you did?"
L["FlavorGoodPlayer5"] = "Who says backpedaling is bad form? Behold all that you accomplished."
L["FlavorGoodPlayer6"] = "Did your daddy teach you that game?"
L["FlavorBadPlayerGoodTeam"] = "Be nice and chip in for the chiropractor your team so desperately needs."
L["FlavorBadPlayerBadTeam"] = "Well your team certainly didn't help."
L["FlavorBadPlayer"] = "Ask a city guard for the nearest Class Trainer."
L["FlavorBadPlayer2"] = "Think about cuddly, soft, fluffy things. "
L["FlavorBadPlayer3"] = "Were you AFK?"
L["FlavorBadPlayer4"] = "TIP: Press your buttons."
L["FlavorBadPlayer5"] = "Better luck next time."
L["FlavorBadPlayerNoDeaths"] = "Hey at least you diddn't die."
L["Ranked"] = "Ranked"
L["Unranked"] = "Unranked"
L["TopSpecs"] = "Top 3 Specs"
L["MostSeen"] = "Most Seen"
L["SendToChat"] = "Send to chat"
L["SendToParty"] = "Send to party"
L["SendToGuild"] = "Send to guild"
L["BGStats"] = "Battleground Stats"
L["ClassBreakdown"] = "Class Breakdown"
L["Spell"] = "Spell"
L["Date"] = "Date"
L["Amount"] = "Amount"
L["Battleground"] = "Battleground"
L["NumKillingBlows"] = "You have #COUNT# Killing Blows"
L["KillingBlowTitle"] = "Top Killing Blow Spells"
L["MatchHistoryTitle"] = "Stats for last #COUNT# Battlegrounds"
L["KillHistoryTitle"] = "Killing Blows in last #COUNT# Battlegrounds"
L["ConsoleKills"] = "Shows kill history."
L["KillingBlow"] = "Killing Blow"
L["KillAuthor"] = "MongoMon: Fuhrbolg is in your battleground, /pet him at all costs."
L["MercMode"] = "Mercenary Mode"
L["ConsoleCredits"] = "Praise the comrades responsible."
L["CreditsText"] = "Fellow apparatchiks, let us recognize these comrades for their contributions towards the glorious class struggle, praise them"
L["PatchSuccess"] = "Upgraded MongoMon to version #TO_VERSION#. Enjoy."
L["PatchFailure"] = "Upgraded MongoMon to version #TO_VERSION#. Unfortunately your saved data was incompatible with this new version and had to be purged."

L["AheadBy"] = "ahead by"
L["BehindLeader"] = "behind leader"
L["SaveFailed"] = "MongoMon could not save match data"