# milight-opencomputers
An OpenComputers lua module for controlling Mi-Light brand bulbs (and LimitlessLED, etc)

#Info
---
---
It includes modules for sending commands to the Mi-Light bulb and for using the robots from the Minecraft OpenComputers mod to detect color from adjacent blocks and relay to the bulb.


OpenComputers Documentation - http://ocdoc.cil.li/

#Basic Usage
Here is a basic example of how the module works:
```.lua
side = require("sides") -- OpenComputers module for selecting which face of a block to calculate commands from e.g robot.detect()
-- options are (.front, .back, .left, .right, .top, .bottom)
bulb = require("bulb")
color = require("blockColor")

bulb.address = "192.168.x.x" -- Set the address of the Mi-Light bridge

bulb.color("green") -- changes the color of the bulb to color name based on a colormap table

color.get() -- gets the color of the block adjacent to the defined side (defualts to side.forward)
-- also converts the decimal given by minecraft to it's corresponding number on the Mi-Light scale of 0-255

bulb.colorNumber(color.get()) -- takes a 0-255 number instead of a string to set color, use with color.get()
```

# Notes
* You must first sync your bulbs with the bridge in UDP mode and then switch over to TCP mode, in order to be able to send commands via minecraft
