﻿--[[
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

-- localization file for Taiwan
local L = LibStub("AceLocale-3.0"):NewLocale("MongoMon", "zhCN")

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
L["AARAutoSendDescription"] = "Check to enable. Too lazy to press the button? We got you covered. Automatically post After Action Report to chat."
L["AARChatLocation"] = "AAR Chat Location"
L["AARChatLocationDescription"] = "Send After Action Report briefs to this chat channel. Has no effect when the After Action Report is disabled. This is the target chat for both manual and when auto-send is enabled."

L["Title"] = "MongoMon"
L["TitleAndAuthor"] = "MongoMon by Fuhrbolg"
L["Subtitle"] = "战场增强了Fuhrbolg"
L["Description"] = "保证不少于3％，以增加你的战场经验和不超过6.25％，MongoMon替代单位幅人物肖像的东西更适合谁无疑正在扮演张口呼吸，键盘翻转，sippie杯饮酒47年年轻人的荒唐类。|n|n敌人的铭牌被增强，从而包括杀 - 死得分最高Mongos，这样，你知道是谁追捕并获得通过杀死。不要做一个傻瓜，发挥的目标。|n|n敌人的铭牌被增强，从而包括杀 - 死得分最高Mongos，这样，你知道是谁追捕并获得通过杀死。不要做一个傻瓜，发挥的目标。"
L["Console"] = "MongoMon by Fuhrbolg, version"
L["Console2"] = "No thanks to"
L["ConsoleStats"] = "BG顯示屏幕的統計數據。"
L["ConsoleConfig"] = "打開插件配置面板。"
L["ConsoleClear"] = "肅反符合歷史數據。"
L["PurgedMatchData"] = "MongoMon: 刪除了所有的比賽數據。"
L["NoDataRecorded"] = "MongoMon: 但沒有記錄的數據。"
L["Wins"] = "勝"
L["Losses"] = "損失"
L["KillDeathRatio"] = "k/d 比"
L["WinRate"] = "贏率"
L["Player"] = "播放機"
L["Team"] = "球隊"
L["PerGame"] = "每場比賽"
L["Total"] = "總"
L["Average"] = "平均"
L["AverageRank"] = "平均排名"
L["Highest"] = "最高"
L["TeamContribution"] = "球隊的貢獻"
L["Rank"] = "秩 #"
L["Deaths"] = "死亡"
L["Kills"] = "殺敵"
L["Damage"] = "損傷"
L["Healing"] = "復原"
L["TouchToClose"] = "(觸摸關閉)"
L["RankTitle"] = "殺敵"
L["TopDamageTitle"] = "損傷"
L["TopHealingTitle"] = "復原"
L["NoDeathTitle"] = "死亡"
L["ResultTeamKillDeath"] = "你的團隊去 #KILLS# - #DEATHS#."
L["ResultEnemyTeamOutDamaged"] = "敵出損害你的團隊 #DAMAGE#%."
L["ResultEnemyTeamOutHealed"] = "敵出醫治你的團隊 #HEALING#%."
L["ResultPlayerTeamOutDamaged"] = "你的球隊走出損壞敵人通過 #DAMAGE#%."
L["ResultPlayerTeamOutHealed"] = "你的球隊走出癒合敵隊 #HEALING#%."
L["ResultPlayerPercentTeamDamage"] = "你做 #DAMAGE#% 你的團隊的傷害，並佔 #KILLS#% 他們殺害的打擊。"
L["ResultPlayerPercentTeamHealing"] = "你做 #HEALING#% 你的團隊的癒合。"
L["FlavorBestPlayerDamageTeam"] = "你做更多的傷害比你的整個團隊結合起來。"
L["FlavorBestPlayerHealingTeam"] = "你做更多的癒合比你的整個團隊結合起來。"
L["FlavorBestPlayerKillsTeam"] = "你有比你的團隊組合的其餘部分更殺敵。"
L["FlavorBestPlayerDamageEnemy"] = "你們這樣做不是整個敵方隊伍的總和還要多的傷害."
L["FlavorBestPlayerHealingEnemy"] = "你們這樣做不是整個敵方隊伍的總和癒合。"
L["FlavorBestPlayerKillsEnemy"] = "你有比整個敵方隊伍的總和還多殺敵。"
L["FlavorGoodPlayerBadTeam"] = "儘管你的團隊，你做的相當不錯。"
L["FlavorGoodPlayerBadTeam2"] = "你是一個人的軍隊。我猜你一定要當你的團隊AFK加氣站他們sippie杯。"
L["FlavorGoodPlayer"] = "Your parents must be proud are very proud of you."
L["FlavorGoodPlayer2"] = "你的表現是合理的。現在擦口水把你的鍵盤和做一遍。"
L["FlavorGoodPlayer3"] = "所以，你穿在現實生活中的頭盔，大不了你今天很多的懲罰菜鳥。"
L["FlavorGoodPlayer4"] = "你感覺良好，你做了什麼？"
L["FlavorGoodPlayer5"] = "誰說倒退是壞的形式？看哪，你完成一切。"
L["FlavorGoodPlayer6"] = "難道你爸爸教你的那場比賽？"
L["FlavorBadPlayerGoodTeam"] = "是不錯，湊錢為你的團隊迫切需要的按摩師。"
L["FlavorBadPlayerBadTeam"] = "那麼你的球隊肯定沒有幫助。"
L["FlavorBadPlayer"] = "問一個城市後衛最近的職業訓練師。"
L["FlavorBadPlayer2"] = "想想可愛，柔軟，蓬鬆的東西。 "
L["FlavorBadPlayer3"] = "是你AFK？"
L["FlavorBadPlayer4"] = "提示：按你的按鈕。"
L["FlavorBadPlayer5"] = "下次運氣更好。"
L["FlavorBadPlayerNoDeaths"] = "嘿，至少你沒死。"
L["Ranked"] = "排名"
L["Unranked"] = "沒有排名"
L["TopSpecs"] = "前3個規格"
L["MostSeen"] = "流行"
L["SendToChat"] = "發送聊天"
L["SendToParty"] = "向甲方"
L["SendToGuild"] = "發送給公會"
L["BGStats"] = "戰場統計"
L["ClassBreakdown"] = "統計類"
L["Spell"] = "攻擊"
L["Date"] = "日期"
L["Amount"] = "量"
L["Battleground"] = "戰場"
L["NumKillingBlows"] = "你有#COUNT#殺"
L["KillingBlowTitle"] = "最高殺人攻擊"
L["MatchHistoryTitle"] = "最後＃個統計資料 #COUNT# 戰場"
L["KillHistoryTitle"] = "在最後 #COUNT# 戰場殺死"
L["ConsoleKills"] = "顯示殺死歷史"
L["KillingBlow"] = "殺人"
L["KillAuthor"] = "MongoMon: Fuhrbolg is in your battleground, /pet him at all costs."
L["MercMode"] = "僱傭模式"
L["ConsoleCredits"] = "赞美负责同志。"
L["CreditsText"] = "Fellow apparatchiks, let us recognize these comrades for their contributions towards the glorious class struggle, praise them"
L["PatchSuccess"] = "Upgraded MongoMon to version #TO_VERSION#. Enjoy."
L["PatchFailure"] = "Upgraded MongoMon to version #TO_VERSION#. Unfortunately your saved data was incompatible with this new version and had to be purged."
L["AheadBy"] = "领先"
L["BehindLeader"] = "在領導後面"
L["SaveFailed"] = "MongoMon could not save match data"