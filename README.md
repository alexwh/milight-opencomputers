# milight-opencomputers
An OpenComputers lua module for controlling Mi-Light brand bulbs (and
LimitlessLED, etc)

#Info
---
---
It includes modules for sending commands to the Mi-Light bulb and for using the
robots from the Minecraft OpenComputers mod to detect color from adjacent
blocks and relay to the bulb.


[OpenComputers Documentation](http://ocdoc.cil.li/)

#Installation
Your OpenComputers Robot/Drone/Computer needs an internet card with its module
installed.

`wget https://raw.githubusercontent.com/alexwh/milight-opencomputers/master/lib/bulb.lua /lib/bulb.lua`
`wget https://raw.githubusercontent.com/alexwh/milight-opencomputers/master/lib/block.lua /lib/block.lua`

Or, just copy the appropriate module files in the lib folder to your systems
/lib folder.


#Basic Usage
Here is a basic example of how the module works:
```.lua
-- OpenComputers module for selecting which face of a block to calculate
-- commands from e.g robot.detect()
side = require("sides")

-- module for interfacing with Mi-Light bulb
bulb = require("bulb")

-- module for detecting block characteristics with the geolyzer
block = require("block")

bulb.address = "192.168.x.x" -- Set the address of the Mi-Light bridge

-- changes the color of the bulb to color name based on a colormap table
bulb.color("green")

-- use a specific numerical value between 0-255
bulb.colorNumber(100)

-- get the block name
block.get() -- -> e.g. "minecraft:air"

-- gets the color of the block on the defined side (defaults to side.forward).
-- also converts the decimal given by minecraft to it's corresponding number on
-- the Mi-Light scale of 0-255
block.getColor() -- -> e.g. 120

-- combine the two to set the light color to the detected block color
bulb.colorNumber(block.getColor())
```

# Notes
* After syncing the bulb to the controller with the phone app, you must change
the transmission mode to TCP-Server in the controller webui settings (browse to
the IP, credentials are admin/admin). Be aware that the phone app only works
with UDP, and OpenComputers only works with TCP.
