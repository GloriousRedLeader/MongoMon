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

-- localization file for French
local L = LibStub("AceLocale-3.0"):NewLocale("MongoMon", "frFR")

if not L then return end

-- Brought to you by google translate
L["EnablePortrait"] = "Activer portraits."
L["PortraitDescription"] = "Lorsque portraits de cadre unité ennemie permis seront remplacés par quelque chose de plus approprié pour la classe de l'ennemi."
L["EnableSound"] = "Activer sons."
L["SoundDescription"] = "Recevez quelques mots d'encouragement de l'AC quand vous obtenez un coup fatal."
L["EnableNameplates"] = "Activer plaques signalétiques."
L["NameplatesDescription"] = "Affiche tuent - pointage de mort sur les plaques signalétiques ennemies qui maintiennent un 5 - k / rapport 1 d. Aussi le joueur ennemi avec le plus de victimes dans le BG obtient une icône spéciale. De cette façon, vous savez qui est bon à PvP."
L["EnableScore"] = "Activer tableau de bord."
L["ScoreDescription"] = "Displays your Kill/Death ratio in BGs. Lets face it, ctrl + space is just too inconvenient."
L["EnableFlash"] = "Affiche votre ratio tués / Mort à BG. Lets face it, ctrl + espace est tout simplement trop gênant."
L["FlashDescription"] = "Lorsque vous recevez un meurtre souffler le cadre score clignote. Cela devient ennuyeux. Donc l'éteindre."
L["EnableRBG"] = "Activer les champs de bataille en notés"
L["RBGDescription"] = "Activer MongoMon en bataille cotés (non recommandé)."
L["Title"] = "MongoMon"
L["TitleAndAuthor"] = "MongoMon by Fuhrbolg"
L["Subtitle"] = "Battleground Enhancer par Fuhrbolg"
L["Description"] = "Garanti pour augmenter votre expérience de champ de bataille de pas moins de 3% et pas plus de 6,25%, MongoMon remplace portraits de châssis de l'unité avec quelque chose de plus approprié pour les classes absurdes qui sont sans aucun doute joué par respiration par la bouche, tournant du clavier, Sippie tasse potable olds 47 années .|n|nplaques Nenemy sont renforcées pour inclure Kill - pointage de mort pour le haut Mongos, de cette façon vous savez qui pour traquer et faire tuer par. Ne pas être un imbécile et de jouer les objectifs.|n|nEt pour funsies vous recevrez un message radio du haut commandement de la Wehrmacht lorsque vous recevez un coup de Killing."
L["Console"] = "MongoMon by Fuhrbolg, version"
L["Console2"] = "No thanks to"
L["EnableAAR"] = "Activer rendu après action."
L["AARDescription"] = "page Splash résumé montrant vos exploits BG après un match."
L["ConsoleStats"] = "BG écran des statistiques Affiche."
L["ConsoleConfig"] = "Ouvre Addon panneau de configuration."
L["ConsoleClear"] = "Purges correspondent à des données historiques."
L["PurgedMatchData"] = "MongoMon: supprimé toutes les données de match."
L["NoDataRecorded"] = "MongoMon: Pas encore de données enregistrées."
L["Wins"] = "Victoires"
L["Losses"] = "pertes"
L["KillDeathRatio"] = "k/d rapport"
L["WinRate"] = "taux gagnant"
L["Player"] = "Player"
L["Team"] = "Team"
L["PerGame"] = "par jeu"
L["Total"] = "Total"
L["Average"] = "Moyenne"
L["AverageRank"] = "Rank moyen"
L["Highest"] = "la plus élevée"
L["TeamContribution"] = "Contribution de l'équipe"
L["Rank"] = "Rank #"
L["Deaths"] = "Décès"
L["Kills"] = "Kills"
L["Dommages"] = "Dommages"
L["Healing"] = "Healing"
L["TouchToClose"] = "(touche pour fermer)"
L["RankTitle"] = "Kills"
L["TopDamageTitle"] = "Dommages"
L["TopHealingTitle"] = "Healing"
L["NoDeathTitle"] = "Décès"
L["ResultTeamKillDeath"] = "Votre équipe a #KILLS# - #DEATHS#."
L["ResultEnemyTeamOutDamaged"] = "L'ennemi outdamaged votre équipe en #DAMAGE#%."
L["ResultEnemyTeamOutHealed"] = "L'ennemi outhealed votre équipe en #HEALING#%."
L["ResultPlayerTeamOutDamaged"] = "Votre équipe outdamaged l'ennemi #DAMAGE#%."
L["ResultPlayerTeamOutHealed"] = "Votre équipe outhealed l'équipe adverse par #HEALING#%."
L["ResultPlayerPercentTeamDamage"] = "Vous ne #DAMAGE#% des dégâts de votre équipe, et représentait #KILLS#% de leurs coups à tuer."
L["ResultPlayerPercentTeamHealing"] = "Vous avez fait #HEALING#% de la guérison de votre équipe."
L["FlavorBestPlayerDamageTeam"] = "Vous avez fait plus de dégâts que toute votre équipe combinée."
L["FlavorBestPlayerHealingTeam"] = "Vous avez fait plus de guérison que l'ensemble de votre équipe combinée."
L["FlavorBestPlayerKillsTeam"] = "Vous avez eu plus de tués que le reste de votre équipe combinée."
L["FlavorBestPlayerDamageEnemy"] = "Vous avez fait plus de dégâts que toute l'équipe ennemie combinée."
L["FlavorBestPlayerHealingEnemy"] = "Vous avez fait une guérison plus que toute l'équipe ennemie combinée."
L["FlavorBestPlayerKillsEnemy"] = "Vous avez eu plus de tués que toute l'équipe ennemie combinée."
L["FlavorGoodPlayerBadTeam"] = "En dépit de votre équipe vous a fait très bien."
L["FlavorGoodPlayerBadTeam2"] = "Vous êtes une armée d'un homme. Je suppose que vous devez être quand votre équipe est AFK remplir leurs tasses de Sippie."
L["FlavorGoodPlayer"] = "Vos parents doivent être fiers sont très fiers de vous."
L["FlavorGoodPlayer2"] = "Votre performance était raisonnable. Maintenant, essuyer la bave de votre clavier et de le faire à nouveau."
L["FlavorGoodPlayer3"] = "Donc, vous portez un irl de barre, big deal Vous puni beaucoup de noobs aujourd'hui."
L["FlavorGoodPlayer4"] = "Vous sentez-vous bien dans ce que vous avez fait?"
L["FlavorGoodPlayer5"] = "Qui a dit backpedaling est mauvaise forme? Voici tout ce que vous avez accompli."
L["FlavorGoodPlayer6"] = "Est-ce que votre papa vous enseigner ce jeu?"
L["FlavorBadPlayerGoodTeam"] = "Soyez gentil et puce pour le chiropraticien votre équipe a désespérément besoin."
L["FlavorBadPlayerBadTeam"] = "Eh bien votre équipe n'a certainement pas aidé."
L["FlavorBadPlayer"] = "Demandez un garde de la ville pour le formateur de classe le plus proche."
L["FlavorBadPlayer2"] = "Pensez câlin, doux, moelleux choses."
L["FlavorBadPlayer3"] = "Avez-vous été AFK?"
L["FlavorBadPlayer4"] = "ASTUCE: Appuyez sur les boutons."
L["FlavorBadPlayer5"] = "Meilleure chance la prochaine fois."
L["FlavorBadPlayerNoDeaths"] = "Hey au moins vous diddn't mourir."
L["Ranked"] = "classé"
L["Unranked"] = "non classé"
L["TopSpecs"] = "Top 3 caractéristiques"
L["MostSeen"] = "populaire"
L["SendToChat"] = "envoyer à discuter"
L["SendToParty"] = "envoyer à la fête"
L["SendToGuild"] = "enviar al gremio"
L["BGStats"] = "Champ de bataille statistiques"
L["ClassBreakdown"] = "statistiques de classe"
L["Spell"] = "attaque"
L["Date"] = "Date"
L["Amount"] = "Montant"
L["Battleground"] = "Champ de bataille"
L["NumKillingBlows"] = "Vous avez #COUNT# Meurtre Blows"
L["KillingBlowTitle"] = "Top attaques Tuer Blow"
L["MatchHistoryTitle"] = "Stats for dernier #COUNT# Champ de bataille"
L["KillHistoryTitle"] = "Tuer coups dans le dernier #COUNT# Champ de bataille"
L["ConsoleKills"] = "Shows tuent l'histoire."
L["KillingBlow"] = "tuant coup"
L["KillAuthor"] = "MongoMon: Fuhrbolg is in your battleground, /pet him at all costs."
L["MercMode"] = "Mode mercenaire"
L["ConsoleCredits"] = "Louez les camarades responsables."
L["CreditsText"] = "Fellow apparatchiks, let us recognize these comrades for their contributions towards the glorious class struggle, praise them"
L["PatchSuccess"] = "Upgraded MongoMon to version #TO_VERSION#. Enjoy."
L["PatchFailure"] = "Upgraded MongoMon to version #TO_VERSION#. Unfortunately your saved data was incompatible with this new version and had to be purged."
L["EnableAARAutoSend"] = "Envoie automatiquement un rapport"
L["AARAutoSendDescription"] = "Trop paresseux pour appuyer sur le bouton? Nous vous avons couvert. Poster automatiquement après le rapport d'action pour discuter."
L["AheadBy"] = "avance de"
L["BehindLeader"] = "derrière le chef"
L["SaveFailed"] = "MongoMon could not save match data"