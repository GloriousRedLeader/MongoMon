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

-- localization file for spanish/Spain
local L = LibStub("AceLocale-3.0"):NewLocale("MongoMon", "esES")

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
L["Subtitle"] = "Campo de batalla Enhancer por Fuhrbolg"
L["Description"] = "Garantizado para aumentar su experiencia de campo de batalla en no menos del 3% y no más del 6,25%, MongoMon reemplaza retratos bastidor de la unidad con algo más apropiado para las clases absurdas, que sin duda se están jugando por la respiración boca, inflexión teclado, beber taza Sippie niños de 47 años .|n|nplacas de identificación nEnemy se han mejorado para incluir la Mata - puntuación muerte para arriba Mongos, de esta manera usted sabe que para cazar y ser asesinado por. No seas tonto y jugar los objetivos.|n|nY para funsies usted recibirá un despacho de radio de alto mando de la Wehrmacht cuando te otorga un golpe letal."
L["Console"] = "MongoMon by Fuhrbolg, version"
L["Console2"] = "No thanks to"
L["ConsoleStats"] = "Muestra la pantalla de estadísticas BG."
L["ConsoleConfig"] = "Abre el panel de configuración Addon"
L["ConsoleClear"] = "purgas coincide con datos de la historia."
L["PurgedMatchData"] = "MongoMon: borrarán todos los datos de los partidos."
L["NoDataRecorded"] = "MongoMon: Sin datos aún grabadas."
L["Wins"] = "victorias"
L["Losses"] = "pérdidas"
L["KillDeathRatio"] = "relación D / k"
L["WinRate"] = "ganar velocidad"
L["Player"] = "Jugador"
L["Team"] = "Equipo"
L["PerGame"] = "por juego"
L["Total"] = "Total"
L["Average"] = "promedio"
L["AverageRank"] = "Rango promedio"
L["Highest"] = "más alta"
L["TeamContribution"] = "Contribución del equipo"
L["Rank"] = "Puesto #"
L["Deaths"] = "muerto"
L["Kills"] = "mata"
L["Damage"] = "daño"
L["Healing"] = "curativo"
L["TouchToClose"] = "(contacto de cierre)"
L["RankTitle"] = "mata"
L["TopDamageTitle"] = "daño"
L["TopHealingTitle"] = "curativo"
L["NoDeathTitle"] = "muerto"
L["ResultTeamKillDeath"] = "Su equipo fue #KILLS# - #DEATHS#."
L["ResultEnemyTeamOutDamaged"] = "El enemigo outdamaged su equipo por #DAMAGE#%."
L["ResultEnemyTeamOutHealed"] = "El enemigo outhealed su equipo por CURACIÓN #HEALING#%."
L["ResultPlayerTeamOutDamaged"] = "Su equipo outdamaged al enemigo #DAMAGE#%."
L["ResultPlayerTeamOutHealed"] = "Su equipo outhealed el equipo enemigo por #HEALING#%."
L["ResultPlayerPercentTeamDamage"] = "Usted no #DAMAGE#% del daño de su equipo, y representaron el #KILLS#% de sus golpes de matar."
L["ResultPlayerPercentTeamHealing"] = "Usted no  #HEALING#% de la curación de su equipo."
L["FlavorBestPlayerDamageTeam"] = "Usted hizo más daño que todo su equipo combinado."
L["FlavorBestPlayerHealingTeam"] = "Usted no sana más que todo su equipo combinado."
L["FlavorBestPlayerKillsTeam"] = "Usted tuvo más muertes que el resto de su equipo combinado."
L["FlavorBestPlayerDamageEnemy"] = "Usted hizo más daño que todo el equipo enemigo combinada."
L["FlavorBestPlayerHealingEnemy"] = "Usted no sana más que todo el equipo enemigo combinada."
L["FlavorBestPlayerKillsEnemy"] = "Usted tuvo más muertes que todo el equipo enemigo combinada."
L["FlavorGoodPlayerBadTeam"] = "A pesar de su equipo que lo hizo bastante bien."
L["FlavorGoodPlayerBadTeam2"] = "Usted es un ejército de un solo hombre. Yo supongo que tienes que ser cuando su equipo es AFK volver a llenar sus copas Sippie."
L["FlavorGoodPlayer"] = "Tus padres deben estar orgullosos están muy orgullosos de ti."
L["FlavorGoodPlayer2"] = "Su actuación fue razonable. Ahora limpie la baba de su teclado y hacerlo de nuevo."
L["FlavorGoodPlayer3"] = "Así que usted usa un timón de IRL, gran cosa Usted castigado muchos noobs hoy en día."
L["FlavorGoodPlayer4"] = "¿Se siente bien acerca de lo que has hecho?"
L["FlavorGoodPlayer5"] = "¿Quién dice que la marcha atrás es de mala educación? He aquí todo lo que has logrado."
L["FlavorGoodPlayer6"] = "¿Tu papá te enseñó ese juego?"
L["FlavorBadPlayerGoodTeam"] = "Hay que ser agradable y el chip por el quiropráctico su equipo por lo que necesita desesperadamente."
L["FlavorBadPlayerBadTeam"] = "Bueno a su equipo sin duda no ayuda."
L["FlavorBadPlayer"] = "Haz una guardia de la ciudad para el entrenador de clase más cercana."
L["FlavorBadPlayer2"] = "pensar, cosas, esponjosas de peluche. "
L["FlavorBadPlayer3"] = "¿Estaba usted AFK?"
L["FlavorBadPlayer4"] = "TIP: Pulse los botones"
L["FlavorBadPlayer5"] = "Mejor suerte la próxima vez."
L["FlavorBadPlayerNoDeaths"] = "Hey, al menos, que diddn't morir."
L["Ranked"] = "clasificado"
L["Unranked"] = "No clasificado"
L["TopSpecs"] = "Top 3 espec"
L["MostSeen"] = "popular"
L["SendToChat"] = "enviar a chatear"
L["SendToParty"] = "enviar a la fiesta"
L["SendToGuild"] = "enviar al gremio"
L["BGStats"] = "Campo de batalla estadística"
L["ClassBreakdown"] = "estadísticas de clase"
L["Spell"] = "ataque"
L["Date"] = "Fecha"
L["Amount"] = "Cantidad"
L["Battleground"] = "Campo de batalla"
L["NumKillingBlows"] = "Tienes #COUNT# matando a golpes"
L["KillingBlowTitle"] = "Top ataques golpe letal"
L["MatchHistoryTitle"] = "Las estadísticas de la última #COUNT# Campo de batalla"
L["KillHistoryTitle"] = "Matando a golpes en la última #COUNT# Campo de batalla"
L["ConsoleKills"] = "Espectáculos matan historia."
L["KillingBlow"] = "golpe mortal"
L["KillAuthor"] = "MongoMon: Fuhrbolg is in your battleground, /pet him at all costs."
L["MercMode"] = "Modo mercenario"
L["ConsoleCredits"] = "Elogie a los camaradas responsables."
L["CreditsText"] = "Fellow apparatchiks, let us recognize these comrades for their contributions towards the glorious class struggle, praise them"
L["PatchSuccess"] = "Upgraded MongoMon to version #TO_VERSION#. Enjoy."
L["PatchFailure"] = "Upgraded MongoMon to version #TO_VERSION#. Unfortunately your saved data was incompatible with this new version and had to be purged."
L["AheadBy"] = "adelante por"
L["BehindLeader"] = "detrás del líder"
L["SaveFailed"] = "MongoMon could not save match data"