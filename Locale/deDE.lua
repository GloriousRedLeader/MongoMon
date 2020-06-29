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

-- localization file for German
local L = LibStub("AceLocale-3.0"):NewLocale("MongoMon", "deDE")

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
L["Subtitle"] = "Battleground Enhancer von Fuhrbolg"
L["Description"] = "Garantiert, um Ihren Schlachtfeld Erfahrung zu erhöhen um nicht weniger als 3% und nicht mehr als 6,25%, MongoMon ersetzt Einheit Rahmen Porträts mit etwas mehr für die absurd Klassen, wird zweifellos von Mundatmung, Tastatur-Drehen, Tasse Sippie Trink 47 Jahre olds gespielt werden entsprechende.|n|nNenemy Namensschilder werden erweitert, um die Tötung zählen - Death Note für Top Mongos, auf diese Weise wissen Sie, wer auf die Jagd nach und nach getötet. |n|n Sie kein Narr sein und spielen Sie die Ziele. NUnd für funsies Sie eine Radio-Sendung vom OKW erhalten, wenn Sie einen Todesstoß erhalten."
L["Console"] = "MongoMon by Fuhrbolg, version"
L["Console2"] = "No thanks to"
L["ConsoleStats"] = "Zeigt BG Statistik-Bildschirm."
L["ConsoleConfig"] = "Öffnet Addon Konfigurations-Panel."
L["ConsoleClear"] = "Säuberungen entsprechen Verlaufsdaten."
L["PurgedMatchData"] = "MongoMon: alle Spieldaten wurden gelöscht."
L["NoDataRecorded"] = "MongoMon: Noch keine aufgezeichneten Daten"
L["Wins"] = "Siege"
L["Losses"] = "Verluste"
L["KillDeathRatio"] = "k/d Verhältnis"
L["WinRate"] = "win rate"
L["Player"] = "Player"
L["Team"] = "Team"
L["PerGame"] = "pro Spiel"
L["Total"] = "Total"
L["Average"] = "Average"
L["AverageRank"] = "Average Rank"
L["Highest"] = "Höchste"
L["TeamContribution"] = "Team Beitrag"
L["Rank"] = "Platz #"
L["Deaths"] = "Todesfälle"
L["Kills"] = "Kills"
L["Damage"] = "Damage"
L["Healing"] = "Healing"
L["TouchToClose"] = "(touch zu schließen)"
L["RankTitle"] = "Kills"
L["TopDamageTitle"] = "Damage"
L["TopHealingTitle"] = "Healing"
L["NoDeathTitle"] = "Todesfälle"
L["ResultTeamKillDeath"] = "Ihr Team ging #KILLS# - #DEATHS#."
L["ResultEnemyTeamOutDamaged"] = "Der Feind outdamaged Ihr Team von #DAMAGE#%."
L["ResultEnemyTeamOutHealed"] = "Der Feind outhealed Ihr Team von #HEALING#%."
L["ResultPlayerTeamOutDamaged"] = "Ihr Team outdamaged den Feind durch #DAMAGE#%."
L["ResultPlayerTeamOutHealed"] = "Ihr Team outhealed das gegnerische Team von #HEALING#%."
L["ResultPlayerPercentTeamDamage"] = "Sie haben #DAMAGE#% Schaden Ihres Teams, und einen Anteil von #KILLS#% ihrer Tötung Schläge."
L["ResultPlayerPercentTeamHealing"] = "Sie haben #HEALING#% der Heilung Ihres Teams."
L["FlavorBestPlayerDamageTeam"] = "Sie haben mehr Schaden an, als das gesamte Team zusammen."
L["FlavorBestPlayerHealingTeam"] = "Du hast mehr Heilung als das gesamte Team zusammen."
L["FlavorBestPlayerKillsTeam"] = "Sie hatten mehr Kills als der Rest des Teams kombiniert."
L["FlavorBestPlayerDamageEnemy"] = "Sie haben mehr Schaden als die gesamte gegnerische Team kombiniert."
L["FlavorBestPlayerHealingEnemy"] = "Du hast mehr Heilung als die gesamte gegnerische Team kombiniert."
L["FlavorBestPlayerKillsEnemy"] = "Sie hatten mehr Kills als die gesamte gegnerische Team kombiniert."
L["FlavorGoodPlayerBadTeam"] = "Trotz Ihrer Mannschaft hat Sie ganz gut."
L["FlavorGoodPlayerBadTeam2"] = "Sie sind ein Ein-Mann Armee. Ich denke, man muss sein, wenn Ihr Team ist AFK ihre Sippie Tassen Nachfüllen."
L["FlavorGoodPlayer"] = "Deine Eltern müssen stolz sein, sind sehr stolz auf dich."
L["FlavorGoodPlayer2"] = "Ihre Leistung angemessen war. Jetzt die Sabber aus Ihrer Tastatur wischen und es wieder tun."
L["FlavorGoodPlayer3"] = "So ein Helm irl, große Sache tragen Sie bestraft heute viele noobs."
L["FlavorGoodPlayer4"] = "Möchten Sie ein gutes Gefühl über das, was Sie getan haben?"
L["FlavorGoodPlayer5"] = "Wer sagt, dass Rückzieher schlechte Form ist? Siehe, alles, was du durchgeführt."
L["FlavorGoodPlayer6"] = "Hat dein Papa lehren Sie das Spiel?"
L["FlavorBadPlayerGoodTeam"] = "Seien Sie nett und Chip in für den Chiropraktiker Ihr Team so dringend braucht."
L["FlavorBadPlayerBadTeam"] = "Gut Ihr Team sicherlich nicht helfen."
L["FlavorBadPlayer"] = "Stellen Sie eine Stadtwache für die nächste Klasse Trainer."
L["FlavorBadPlayer2"] = "Denken Sie kuschelig, weichen, flauschigen Dinge. "
L["FlavorBadPlayer3"] = "Warst du AFK?"
L["FlavorBadPlayer4"] = "TIPP: Drücken Sie Ihre Tasten"
L["FlavorBadPlayer5"] = "Viel Glück beim nächsten Mal."
L["FlavorBadPlayerNoDeaths"] = "Hey mindestens diddn't Sie sterben."
L["Ranked"] = "Platz"
L["Unranked"] = "nicht sortiert"
L["TopSpecs"] = "Top 3 Spezifikationen"
L["MostSeen"] = "Beliebt"
L["SendToChat"] = "Bitte senden Sie chatten"
L["SendToParty"] = "senden Party"
L["SendToGuild"] = "senden zu Gilde"
L["BGStats"] = "Schlachtfeld Statistiken"
L["ClassBreakdown"] = "Klassenstatistik"
L["Spell"] = "Attacke"
L["Date"] = "Datum"
L["Amount"] = "Menge"
L["Battleground"] = "Schlachtfeld"
L["NumKillingBlows"] = "Sie haben #COUNT# Töten Schläge"
L["KillingBlowTitle"] = "Top Killing Schlagangriffe"
L["MatchHistoryTitle"] = "Statistiken für die letzten #COUNT# Schlachtfeld"
L["KillHistoryTitle"] = "Killing Blows in der letzten #COUNT# Schlachtfeld"
L["ConsoleKills"] = "Zeigt die Todesgeschichte an."
L["KillingBlow"] = "Töten Schlag"
L["KillAuthor"] = "MongoMon: Fuhrbolg is in your battleground, /pet him at all costs."
L["MercMode"] = "Söldnermodus"
L["ConsoleCredits"] = "Loben Sie die verantwortlichen Kameraden."
L["CreditsText"] = "Fellow apparatchiks, let us recognize these comrades for their contributions towards the glorious class struggle, praise them"
L["PatchSuccess"] = "Upgraded MongoMon to version #TO_VERSION#. Enjoy."
L["PatchFailure"] = "Upgraded MongoMon to version #TO_VERSION#. Unfortunately your saved data was incompatible with this new version and had to be purged."
L["AheadBy"] = "voraus"
L["BehindLeader"] = "hinter dem Anführer"
L["SaveFailed"] = "MongoMon could not save match data"