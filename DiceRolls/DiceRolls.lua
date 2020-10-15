--[[
-- DiceRolls for tes3mp 0.7.0-alpha. created by inpv
-- players can roll one or more (up to a million) dice, 4 to a million sided, using the standard AdX RPG notation
-- under GPLv3

-- Installation:
Add a line:
DiceRolls = require("custom.DiceRolls") to customScripts.lua
]]

local DiceRolls = {}
local random_num_init


function DiceRolls.setSeed() -- sets the random seed
  math.randomseed(os.time())
end


function DiceRolls.getRandom(side) -- gets a random number in the range of the dice sides

  if random_num_init == nil then
    for i = 1, 100 do
      random_num = math.random(1, side)
    end
    return random_num
  end
end


function DiceRolls.getRollSum(diceNum, sideNum) -- gets the sum of all the dice rolled

  local sum = 0

  for i = 1, diceNum do
    roll = DiceRolls.getRandom(sideNum)
    sum = sum + roll
  end

  return sum
end


function DiceRolls.showRollMessage(eventStatus, pid, cmd) -- shows a message to all players in a player's cell

  local cellDescription = Players[pid].data.location.cell
  local playerName = Players[pid].accountName

  local diceNum = tonumber(cmd[2])
  local sideNum = tonumber(cmd[3])

  local function getDieName(diceNum)

    if tonumber(diceNum) == 1 then
      dieName = "die"
    else
      dieName = "dice"
    end
    return dieName
  end

  message = color.LightBlue .. playerName .. color.BlueViolet .. " rolled " .. color.Green .. diceNum .. " " .. color.BlueViolet .. sideNum .. "-sided " .. getDieName(diceNum) .. " for a total of " .. color.Yellow .. DiceRolls.getRollSum(diceNum, sideNum) .. color.BlueViolet .. ".\n" .. color.Default

  if logicHandler.IsCellLoaded(cellDescription) == true then
    for index, visitorPid in pairs(LoadedCells[cellDescription].visitors) do
      tes3mp.SendMessage(visitorPid, message, false)
    end
  end
end


function DiceRolls.ChatListener(pid, cmd) -- initiates the roll on command, also sanity checks

  local diceVal = tonumber(cmd[2])
  local sideVal = tonumber(cmd[3])

  if cmd[1] == "rd" and cmd[2] ~= nil and cmd[3] ~= nil and diceVal and sideVal then

    if cmd[1] == "rd" and diceVal < 0 or cmd[1] == "rd" and sideVal < 0 then
      message = "You can't roll dice with negative values!\n"
      tes3mp.SendMessage(pid, message, false)
    elseif cmd[1] == "rd" and diceVal == 0 then
      message = "You can't roll 0 dice!\n"
      tes3mp.SendMessage(pid, message, false)
    elseif cmd[1] == "rd" and sideVal < 4 then
      message = "A dice must have at least four sides!\n"
      tes3mp.SendMessage(pid, message, false)
    elseif cmd[1] == "rd" and diceVal > 1000000 or cmd[1] == "rd" and sideVal > 1000000 then
      message = "Not even the Dwemer could count that...\n"
      tes3mp.SendMessage(pid, message, false)
    else
      DiceRolls.showRollMessage(eventStatus, pid, cmd)
    end
  else
    message = "Invalid roll command.\nExample: /rd 3 6 (roll three six-sided dice).\n"
    tes3mp.SendMessage(pid, message, false)
  end
end


customCommandHooks.registerCommand("rd", DiceRolls.ChatListener)

customEventHooks.registerHandler("OnPlayerAuthentified", function(eventStatus, pid)
        if eventStatus.validCustomHandlers then
                DiceRolls.setSeed()
                tes3mp.LogMessage(enumerations.log.INFO, "[DiceRolls] Random seed initialized for " .. Players[pid].name)
        end
end)

return DiceRolls
