# DiceRolls
Simple <i>A</i>d<i>X</i> tabletop dice rolling system for tes3mp servers.<br>
Players can roll one or more (up to a million) dice, 4 to a million sided, using the standard <i>A</i>d<i>X</i> RPG notation.<br>
Created by inpv for 0.7.0-alpha.<br>
## Installation:<br>
1. Place the script into `server/scripts/custom` directory.<br>
2. Add a line `DiceRolls = require("custom.DiceRolls")` in `server/scripts/customScripts.lua`
## In-game commands:<br>
To roll dice, type in chat `/rd A X`, where A is the number of dice thrown, and X is the number of sides.<br>
For example, `/rd 3 6` rolls three six-sided dice.<br>
## TODO:<br>
C factor arithmetic<br>
Nonlinear dice pools
