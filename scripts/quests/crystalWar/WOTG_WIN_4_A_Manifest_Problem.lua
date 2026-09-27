-----------------------------------
-- A Manifest Problem (WOTG Nation Quests - Windurst 4)
-----------------------------------
-- !addquest 7 28
-- 
-- 
-- 
-----------------------------------

-- By Zone / NPC or Event
    -- Fort Karugo-Narugo (S)
        -- Rotih Moalghett States
            -- Event 104 - Prog NA: Quest Not available
            -- Event 105 - Prog 0: Get Quest - Set Prog to 1
            -- event 107 - Prog 1: After getting quest
            -- Event 106, then 111 - Prog 2: Get KI, set Prog 3
            -- Event 108 - Prog 3: after getting KI
            -- Event 109 - Prog 3: after dying in benm and losing KI
            -- Event ??? - Quest Complete State
    -- Meriphataud Mountains [s] zone to Castle Oztroja (S)
        -- Iron Portcullis
            -- Event ??? - All Quest States other than Prog 1
            -- Event 104 - Prog 2: Event, set Prog to 3
            -- Event ??? - Quest Complete state
    -- Ghoyu's Reverie - BCNM
        -- Laa_Yaku_the_Austere
        -- LOTS of other Yagudo
        -- On death of all, WIN
        -- Set Quest prog to 4
    -- WINDURST_WATERS_S
        -- On Zone In - Prog 4 && prevZone == West Saruta S
        -- In Sequence play:
            -- Event 153
            -- Event 231
            -- Event 232
            -- Event 233
    -- Quest Complete
-- Get Reward




local quest = Quest:new(xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.KNOT_QUITE_THERE)

quest.reward =
{
    --item = xi.item.PLATINUM_BEASTCOIN,
}

quest.sections =
{
   
    {


        check = function(player, status, vars)
            return status == xi.questStatus.QUEST_AVAILABLE and
                player: hasCompletedQuestxi.questLog.CRYSTAL_WAR, xi.quest.id.crystalwar.KNOT_QUITE_THERE) and
                player:hasCompletedMission(xi.mission.log_id.wOTG, xi.mission.id.wotg.BACK_TO_THE_BEGINNING)
        end,

        [xi.zone.xi.zone. FORT_KARUGO_NARUGO_S] =
            ['Rotih_Moalghett'] = onTrigger = function(player, npc)
                if quest: getVar(player, 'Prog') == o then
                   return quest:progressEvent(105)
                    -- Start quest
                elseif quest: getVar(player,'Prog') == 1 then
                --after getting quest but no progress
                    return quest: progressEvent(107)
                elseif quest: getVar(player, 'Prog') = 2 then
                --after returning from Castle Oztroja (S)
                    return quest:progressEvent(106)
                elseif quest: getVar(player, 'Prog') == 3 and player: haskeyItem(xi.keyItem.FORT_KEY then
                    return quest:progressEvent(108)
                elseif quest: getVar(player, 'Prog') == 3 and not(player:hasKeyItem(xi.keyItem.FORT_KEY) then
                    return quest:progressEvent(109)
                elseif player: hasCompletedQuest(xi.questLog.CRYSTAL_WAR, xi. quest.id.crystalwar.A_MANIFEST_PROBLEM) then
                --state after quest?
                else
                -- default response
                end,
            end,

            onEventFinish =
            {
                [105] = function(player, csid, option, npc)
                -- start quest, set prog to 1
                   quest: begin(player) quest: setVar(player,'Prog', 1)
                end,
                -- No CS for state 107


                [107] = function(player, csid, option, nc)
                -- play 2 cs in a row.
                -- 107 is story
                -- 111 is story and gives KI
                --when both are finished, set prog to 3
                    return quest:progressEvent(111)
                end,
                [111] = function(player, csid, option, npc)
                    npcutil.givekeyItem(player, xi.keyltem.FORT_KEY)
                quest: setvar(player, 'Prog', 3)
                end,
                -- if player is on prog 3 and has key item
                [108] = function(player, csid, option, npc)
                end,
                -- if player is on prog 3 and does not have key item
                [109] = function(player, csid, option, npc)
                    npcutil.givekeyItem(player, xi.keyItem.FORT_KEY)
                end,
            },
        },
    },


    -- Old code bellow this point 

    -- Escort progression: Bulwark Gate (Sauromugue Champaign [S]) -> zone into
    -- Southern San d'Oria (S) from East Ronfaure (S) -> Door:House.
    {
        check = function(player, status, vars)
            return status == xi.questStatus.QUEST_ACCEPTED
        end,

        [xi.zone.WINDURST_WATERS_S] =
        {
            -- Reminder cutscene while the quest is active.
            ['Door_Acolyte_Hostel_down'] =
            {
                onTrigger = function(player, npc)
                    return quest:event(152)
                end,
            },
        },

        [xi.zone.SAUROMUGUE_CHAMPAIGN_S] =
        {
            ['Bulwark_Gate'] =
            {
                onTrigger = function(player, npc)
                    local prog = quest:getVar(player, 'Prog')

                    if prog == 0 then
                        return quest:progressEvent(105)
                    elseif prog == 1 then
                        -- Pre-trade reminder to hand over the 108-Knot Quipu.
                        return quest:event(107)
                    elseif prog == 2 then
                        -- Post-trade reminder to head to Southern San d'Oria.
                        return quest:event(108)
                    end
                end,

                onTrade = function(player, npc, trade)
                    if
                        quest:getVar(player, 'Prog') == 1 and
                        npcUtil.tradeHasExactly(trade, xi.item.ONE_HUNDRED_EIGHT_KNOT_QUIPU)
                    then
                        return quest:progressEvent(106)
                    end
                end,
            },

            onEventFinish =
            {
                [105] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 1)
                end,

                [106] = function(player, csid, option, npc)
                    player:confirmTrade()
                    quest:setVar(player, 'Prog', 2)
                end,
            },
        },

        [xi.zone.SOUTHERN_SAN_DORIA_S] =
        {
            ['_6eo'] =
            {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Prog') == 3 then
                        return quest:progressEvent(63)
                    end
                end,
            },

            -- Approach cutscene with Pattna-Ottna, only when arriving on foot from
            -- East Ronfaure (S). (Retail also suppresses it while mounted; not modeled here.)
            onZoneIn = function(player, prevZone)
                if
                    prevZone == xi.zone.EAST_RONFAURE_S and
                    quest:getVar(player, 'Prog') == 2
                then
                    return 62
                end
            end,

            onEventFinish =
            {
                [62] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 3)
                end,

                [63] = function(player, csid, option, npc)
                    quest:complete(player)
                end,
            },
        },
    },
}

return quest
