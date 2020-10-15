# BookPickup
An option to pick up or read a book/note/scroll for players on tes3mp servers.<br>
Created by inpv for tes3mp 0.7.0-alpha.<br>
Under GPLv3<br>
## Description:<br>
Players can decide, whether they want to pick up or read a book/note/scroll instead of reading it by default.<br>
Supports custom books, notes and scrolls created by server scripts, i.e. `noteWritingPlus`.<br>
May not support mod-added content out of the box, but is customizable by adding book prefixes to a match list.<br>
Also has the option to blacklist items you don't want to be recognized as text.<br>
## Installation:<br>
1. Place the script into server/scripts/custom directory.<br>
2. Add a line: `BookPickup = require("custom.BookPickup")` in `server/scripts/customScripts.lua`<br>