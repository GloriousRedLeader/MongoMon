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

-- localization file for english/United States
local L = LibStub("AceLocale-3.0"):NewLocale("MongoMon", "ptBR")

if not L then return end

-- Brought to you by google Diablolock7
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
L["TitleAndAuthor"] = "MongoMon por Fuhrbolg"
L["Subtitle"] = "Potencializador de Campo de Batalha por Fuhrbolg"
L["Description"] = "Garantia de aumentar sua experiência no Campo de Batalha para não menos de 3% e não mais de 6.25%, MongoMon substitui os retratos dos quadros de unidades com algo mais apropriado para as classes absurdas que sem dúvida estão sendo jogadas por cotocos, cones e sem dedos. |n|nOs quadros de unidades são aprimorados para incluir o placar de Golpes Fatais - Mortes, desta forma, você sabe em qual inimigo focar para ser morto por ele. Não seja bobo e jogue objetivamente. |n|nVocê receberá um aviso via rádio do alto comando das Forças Armadas quando conseguir um golpe fatal (só pela zoeira)."
L["Console"] = "MongoMon por Fuhrbolg, versão"
L["Console2"] = "Sem agradecimentos para o"
L["ConsoleStats"] = "Mostra a tela de estatísticas da BG."
L["ConsoleConfig"] = "Abre o painel de configurações do addon."
L["ConsoleClear"] = "Apaga os dados das partidas."
L["PurgedMatchData"] = "MongoMon: Dados das partidas apagados."
L["NoDataRecorded"] = "MongoMon: Sem dados históricos ainda."
L["Wins"] = "Vitórias"
L["Losses"] = "Derrotas"
L["KillDeathRatio"] = "taxa GF/M"
L["WinRate"] = "Taxa de vitória"
L["Player"] = "Jogador"
L["Team"] = "Time"
L["PerGame"] = "por jogo"
L["Total"] = "Total"
L["Average"] = "Médio"
L["AverageRank"] = "Ranque médio"
L["Highest"] = "mais alto"
L["TeamContribution"] = "Contribuição para o time"
L["Rank"] = "Ranque #"
L["Deaths"] = "Mortes"
L["Kills"] = "Golpes fatais"
L["Damage"] = "Dano"
L["Healing"] = "Cura"
L["TouchToClose"] = "(Clique para fechar)"
L["RankTitle"] = "Golpes Fatais"
L["TopDamageTitle"] = "Dano"
L["TopHealingTitle"] = "Cura"
L["NoDeathTitle"] = "Mortes"
L["ResultTeamKillDeath"] = "Seu time tem #KILLS# - #DEATHS#."
L["ResultEnemyTeamOutDamaged"] = "O inimigo superou o dano do seu time em #DAMAGE#%."
L["ResultEnemyTeamOutHealed"] = "O inimigo superou a cura do seu time em #HEALING#%."
L["ResultPlayerTeamOutDamaged"] = "O seu time superou o dano do time inimigo em #DAMAGE#%."
L["ResultPlayerTeamOutHealed"] = "O seu time superou a cura do time inimigo em #HEALING#%."
L["ResultPlayerPercentTeamDamage"] = "Você realizou #DAMAGE#% do dano do seu time e, #KILLS#% dos golpes fatais."
L["ResultPlayerPercentTeamHealing"] = "Você realizou #HEALING#% da cura do seu time."
L["FlavorBestPlayerDamageTeam"] = "Você deu mais dano que o seu time inteiro junto."
L["FlavorBestPlayerHealingTeam"] = "Você curou mais que o seu time inteiro junto."
L["FlavorBestPlayerKillsTeam"] = "Você matou mais que o seu time inteiro junto."
L["FlavorBestPlayerDamageEnemy"] = "Você deu mais dano que todo o time inimigo junto."
L["FlavorBestPlayerHealingEnemy"] = "Você curou mais que todo o time inimigo junto."
L["FlavorBestPlayerKillsEnemy"] = "Você matou mais que todo o time inimigo junto."
L["FlavorGoodPlayerBadTeam"] = "Apesar do seu time, você foi muito bem."
L["FlavorGoodPlayerBadTeam2"] = "Você é um exército de um homem só. Acho que você tem ser quando o resto do seu time está dormindo."
L["FlavorGoodPlayer"] = "Seus pais devem estar muito orgulhosos de você."
L["FlavorGoodPlayer2"] = "Seu desempenho foi razoável. Agora limpe a baba do seu teclado e faça isto de novo."
L["FlavorGoodPlayer3"] = "Então você usa um capacete na vida real, grande coisa. Você castigou muitos noobs hoje."
L["FlavorGoodPlayer4"] = "Você se sente bem com o que você fez?"
L["FlavorGoodPlayer5"] = "Quem disse que não largar o osso é ruim? Olhe tudo que você já conquistou."
L["FlavorGoodPlayer6"] = "O seu pai te ensinou a jogar?"
L["FlavorBadPlayerGoodTeam"] = "Seja bacana e contribua para pagar o massagista. O seu time vai precisar."
L["FlavorBadPlayerBadTeam"] = "Bom, o seu time com certeza não ajudou."
L["FlavorBadPlayer"] = "Pergunte ao guarda da cidade o treinador de classe mais próximo."
L["FlavorBadPlayer2"] = "Pense sobre coisas fofas e macias."
L["FlavorBadPlayer3"] = "Você estava dormindo?"
L["FlavorBadPlayer4"] = "Dica: Aperte algum botão."
L["FlavorBadPlayer5"] = "Mais sorte da próxima vez."
L["FlavorBadPlayerNoDeaths"] = "Olha, pelo menos você não morreu."
L["Ranked"] = "Ranqueado"
L["Unranked"] = "Não Ranqueado"
L["TopSpecs"] = "Top 3 Especializações"
L["MostSeen"] = "Mais vistas"
L["SendToChat"] = "Mandar para o chat"
L["SendToParty"] = "Mandar para grupo"
L["SendToGuild"] = "Mandar para a guilda"
L["BGStats"] = "Estatísticas de Campo de Batalha"
L["ClassBreakdown"] = "Mau funcionamento de classe"
L["Spell"] = "Feitiço"
L["Date"] = "Data"
L["Amount"] = "Quantidade"
L["Battleground"] = "Campo de Batalha"
L["NumKillingBlows"] = "Você matou #COUNT# inimigos"
L["KillingBlowTitle"] = "Feitiço que mais matou inimigos"
L["MatchHistoryTitle"] = "Estatísticas para os últimos #COUNT# Campos de Batalha"
L["KillHistoryTitle"] = "Golpes fatais nos últimos #COUNT# Campos de Batalha"
L["ConsoleKills"] = "Mostrar histórico de inimigos mortos."
L["KillingBlow"] = "Golpes Fatais"
L["ConsoleCredits"] = "Elogie os camaradas responsáveis."
L["CreditsText"] = "Fellow apparatchiks, let us recognize these comrades for their contributions towards the glorious class struggle, praise them"
L["PatchSuccess"] = "Upgraded MongoMon to version #TO_VERSION#. Enjoy."
L["PatchFailure"] = "Upgraded MongoMon to version #TO_VERSION#. Unfortunately your saved data was incompatible with this new version and had to be purged."
L["AheadBy"] = "à frente por"
L["BehindLeader"] = "atrás do líder"
L["SaveFailed"] = "MongoMon could not save match data"