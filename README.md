# milight-opencomputers
An OpenComputers lua module for controlling Mi-Light brand bulbs (and LimitlessLED, etc)

#Info
---
It includes modules for sending commands to the Mi-Light bulb and for using the robots from the Minecraft OpenComputers mod to detect color from adjacent blocks and relay to the bulb.


[OpenComputers Documentation](http://ocdoc.cil.li/)

#Installation
Your OpenComputers Robot/Drone/Computer needs an internet card with its module installed.

`wget https://raw.githubusercontent.com/alexwh/milight-opencomputers/master/lib/bulb.lua /lib/bulb.lua`

Or, just copy the appropriate module files in the lib folder to your systems /lib folder.


#Basic Usage
Here is a basic example of how the module works:
```.lua
side = require("sides") -- OpenComputers module for selecting which face of a block to calculate commands from e.g robot.detect()
-- options are (.front, .back, .left, .right, .top, .bottom)
bulb = require("bulb")
blockColor = require("blockColor")

bulb.address = "192.168.x.x" -- Set the address of the Mi-Light bridge

bulb.color("green") -- changes the color of the bulb to color name based on a colormap table
bulb.colorNumber(100) -- use a specific numerical value between 0-255

blockColor.get() -- gets the color of the block adjacent to the defined side (defaults to side.forward)
-- also converts the decimal given by minecraft to it's corresponding number on the Mi-Light scale of 0-255

bulb.colorNumber(blockColor.get()) -- takes a 0-255 number instead of a string to set color, use with blockColor.get()
```

# Notes
* After syncing the bulb to the controller with the phone app, you must change the transmission mode to TCP-Server in the controller webui settings (browse to the IP, credentials are admin/admin). Be aware that the phone app only works with UDP, and OpenComputers only works with TCP.
