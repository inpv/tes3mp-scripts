--[=====[
-- BookPickup for tes3mp 0.7.0-alpha
-- created by inpv

-- Description:
Players can decide, whether they want to pick up or read a book/note/scroll.
Supports custom books, notes and scrolls created by server scripts, i.e. noteWritingPlus
May not support mod-added content out of the box, but is customizable by adding book prefixes to a match list
Also has the option to blacklist items you don't want to be recognized as text
Under GPLv3

-- How it works:
When the player activates a readable item in OnObjectActivate, the item's uniqueIndex is recorded in a local script variable.
If the player chooses to pick up the item,
the object with that uniqueIndex is removed in OnGUIAction and a copy is placed by its refId to the player's inventory.

-- Installation:
1. Place the script into server/scripts/custom directory.
2. Add a line:
BookPickup = require("custom.BookPickup") in server/scripts/customScripts.lua
--]=====]


local BookPickup = {}
local bookUniqueIndex = ""
local itemMatchPrefixes = {"bk_", "sc_", "note", "scroll", "mr_book_", "T_Bk_", "book", "Book"} -- put your custom book prefixes here
local blacklistPrefixes = {"storage"} -- blacklist items you don't want to be recognized as text


local function showBookPickupMenu(eventStatus, pid)
  tes3mp.CustomMessageBox(pid, -1, "[Text]", "Pick up;Read;Cancel")
end


local function checkBlacklist(refId)
  for _, item in ipairs(blacklistPrefixes) do
    if (string.match(refId, item)) then
      return true
    end
  end
  return false
end


local function OnGUIAction(newStatus, pid, idGui, data)
  local cellDescription = tes3mp.GetCell(pid)

  if idGui == -1 then
    if tonumber(data) == 0 then -- pickup
      for uniqueIndex, object in pairs(LoadedCells[cellDescription].data.objectData) do
        if uniqueIndex == bookUniqueIndex then
          tes3mp.LogMessage(enumerations.log.INFO, "[BookPickup] Readable item picked up by " .. Players[pid].name)

          logicHandler.DeleteObjectForEveryone(cellDescription, bookUniqueIndex)
          LoadedCells[cellDescription].data.objectData[bookUniqueIndex] = nil
          LoadedCells[cellDescription]:Save()

          inventoryHelper.addItem(Players[pid].data.inventory, object.refId, 1, -1, -1, "")
          logicHandler.RunConsoleCommandOnPlayer(pid, 'PlaySound, "Book Open"', false)
          tes3mp.MessageBox(pid, -1, "You picked up a readable item.")

          tes3mp.ClearInventoryChanges(pid)
          tes3mp.SetInventoryChangesAction(pid, enumerations.inventory.ADD)
          tes3mp.AddItemChange(pid, object.refId, 1, -1, -1, "")
          tes3mp.SendInventoryChanges(pid)
        end
      end
    elseif tonumber(data) == 1 then -- read
      logicHandler.ActivateObjectForPlayer(pid, cellDescription, bookUniqueIndex)
    end
  end
end


local function OnObjectActivate(eventStatus, pid, cellDescription, objects, players)

  for _, object in pairs(objects) do
    --check if the object is a book/note/scroll
    for _, item in ipairs(itemMatchPrefixes) do
      if (string.match(object.refId, item)) and checkBlacklist(object.refId) == false then
        bookUniqueIndex = object.uniqueIndex
        tes3mp.LogMessage(enumerations.log.INFO, "[BookPickup] Item pickup menu activated by " .. Players[pid].name)
        showBookPickupMenu(eventStatus, pid)
        return customEventHooks.makeEventStatus(false, false)
      end
    end
  end
end


customEventHooks.registerValidator("OnGUIAction", OnGUIAction)
customEventHooks.registerValidator("OnObjectActivate", OnObjectActivate)

return BookPickup
