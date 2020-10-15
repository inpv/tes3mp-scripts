-- antiMainQuest for tes3mp 0.7-prerelease. created by malic for JRP Roleplay
-- under GPLv3

-- modified by inpv for 0.7.0-alpha
-- makes the dwarven crank near the door to Dagoth Ur's facility unusable by the player

local antiMainQuest = {}
antiMainQuest.blockDagothUrDoor = true

table.insert(guiHelper.names, "antiMainQuest_dagothBlock")
guiHelper.ID = tableHelper.enum(guiHelper.names)

local function denyDagothUrAccess(eventStatus,pid,cellDescription,objects,players)
        for _, object in pairs(objects) do
                if antiMainQuest.blockDagothUrDoor == true then
                        if cellDescription == "2, 8" and object.refId == "ex_dwrv_crank_dagoth" then
                                tes3mp.CustomMessageBox(pid, guiHelper.ID.antiMainQuest_dagothBlock, "Horrid images fill your mind as you turn the crank. Your prior confidence is stolen from you as you yank your hand back. Whatever is in here, you are not ready for it.", "Close")
                                tes3mp.LogMessage(2,"[antiMainQuest] " .. Players[pid].name .. " was denied entry into Dagoth Ur through the entry door.")
                                return customEventHooks.makeEventStatus(false, nil)
                        end
                end
        end
end

customEventHooks.registerValidator("OnObjectActivate", denyDagothUrAccess)
