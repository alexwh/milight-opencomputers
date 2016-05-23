local red = require("component").redstone
local net = require("internet")
local event = require("event")
local colors = require("colors")

local myEventHandlers = {}
local running = true

local con = net.open("192.168.0.100", 8899)

function myEventHandlers.key_up(address, char, code, playerName)

  if (char == string.byte("q")) then
    running = false
    print("Quitting")
  end

end

function myEventHandlers.redstone_changed(_, address, side)
  for color, value in pairs(red.getBundledInput(2)) do
    print(colors[color], value)
  end

  local brightness = 0x22;

  if side > 0 then
    brightness = 0x22
  else
    brightness = 0x21
  end

  local msg = string.char(brightness) .. string.char(0x00) .. string.char(0x55)
  print("Sending " .. msg .. " to lamp...")

  con:write(msg)

  con:flush()

end

function handleEvent(eventID, ...)

  local event = myEventHandlers[eventID]

  if (event) then
    event(...)
  end

end

if con then
  print("Connected")
end

while running do
  handleEvent(event.pull())
end
