local red = require("component").redstone
local net = require("internet")
local event = require("event")
local colors = require("colors")

local bulb = {}
local eventHandlers = {}
local running = true

bulb.address = "127.0.0.1" -- testing
bulb.port = 8899

commands = {
	color = string.char(0x20),
	off   = string.char(0x21),
	on    = string.char(0x22),
	bup   = string.char(0x23),
	bdown = string.char(0x24),
}

function sendData(data)
	if data == "" or data == nil then
		return nil, "sendData requires an argument"
	end

	-- commands are in the 3 byte format [cmd] [value] 0x55
	if string.len(data) > 2 then
		return nil, "commands need to be less than two bytes"
	end

	-- since most commands don't use the value byte, just set it to null
	-- e.g. turn on is 0x22 0x00 0x55
	if string.len(data) == 1 then
		data = data .. string.char(0x00)
	end

	-- and always add the 0x55 trailer, since it's either 2 bytes now, or was
	-- to begin with
	data = data .. string.char(0x55)

	print("sending" .. data)

	local con = net.open(bulb.address, bulb.port)
	con:write(data)
	con:close()
end

function bulb.color(color)
	color = tonumber(color)

	if color == "" or color == nil then
		return nil, "color requires an argument"
	end
	if color < 0 or color > 255 then
		return nil, "color must be between 0 and 255"
	end

	sendData(commands.color .. string.char(color))
end

function bulb.switchOff()
	sendData(commands.off)
end

function bulb.switchOn()
	sendData(commands.on)
end

function bulb.brightnessUp()
	sendData(commands.bup)
end

function bulb.brightnessDown()
	sendData(commands.bdown)
end


-- have this as an excersise
-- function bulb.switch(value)
-- 	if value then
-- 	else
-- 	end
-- end


function eventHandlers.key_up(address, char, code, playerName)
	if (char == string.byte("q")) then
		running = false
		print("Quitting")
	end
end

function eventHandlers.redstone_changed(_, address, side)
	for color, value in pairs(red.getBundledInput(2)) do
		print(colors[color], value)
	end

	if side > 0 then
		bulb.switchOn(value)
	else
		bulb.switchOff(value)
	end
end

--- ... expands to "soak up" a variable amount of extra arguments
function handleEvent(eventID, ...)
	local event = eventHandlers[eventID]

	if event then
		event(...)
	end
end

-- while running do
--   handleEvent(event.pull())
-- end

return bulb
