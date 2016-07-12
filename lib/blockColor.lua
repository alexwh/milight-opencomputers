side = require("sides")
geo = require("component").geolyzer
local blockColor = {}

-- rgbToHsv function from https://github.com/EmmanuelOga/columns/blob/master/utils/color.lua
--[[
 * Converts an RGB color value to HSV. Conversion formula
 * adapted from http://en.wikipedia.org/wiki/HSV_color_space.
 * Assumes r, g, and b are contained in the set [0, 255] and
 * returns h, s, and v in the set [0, 1].
 *
 * @param   Number  r       The red color value
 * @param   Number  g       The green color value
 * @param   Number  b       The blue color value
 * @return  Array           The HSV representation
]]
function rgbToHsv(r, g, b, a)
  r, g, b, a = r / 255, g / 255, b / 255, a / 255
  local max, min = math.max(r, g, b), math.min(r, g, b)
  local h, s, v
  v = max

  local d = max - min
  if max == 0 then s = 0 else s = d / max end

  if max == min then
    h = 0 -- achromatic
  else
    if max == r then
    h = (g - b) / d
    if g < b then h = h + 6 end
    elseif max == g then h = (b - r) / d + 2
    elseif max == b then h = (r - g) / d + 4
    end
    h = h / 6
  end

  return h, s, v, a
end

function blockColor.rgbToByte(rgb)
    -- this function takes an int and returns the milight shifted result as a
    -- single byte. example: rgbToByte(0xff00ff) -> 220, a purplish color

    -- bitwise mask out rgb bits and divide to account for extra place value on
    -- red and blue (4, and 2)
    red   = bit32.band(rgb, 0xff0000)/16^4
    blue  = bit32.band(rgb, 0x00ff00)/16^2
    green = bit32.band(rgb, 0x0000ff)

    h, s, v, _ = rgbToHsv(red, blue, green, 0) -- ignore alpha
    -- rgbToHsv returns the hsv result between 0 and 1, we need their normal values
    h = math.floor((h*360)+0.5) -- hue between 0 and 360
    s = math.floor((s*100)+0.5) -- sat between 0 and 100
    v = math.floor((v*100)+0.5) -- val between 0 and 100

    -- shift the h (hue) to match about what the milight spectrum is (0-255 and add 176)
    -- values from https://git.io/vKnxe
    color = (256 + 176 - math.floor(h / 360 * 255)) % 256
    return color
end

function blockColor.get(face)
    if not face then
      face = side.forward
    end
    geoColor = geo.analyze(face)["color"]

    return blockColor.rgbToByte(geoColor)
end

return blockColor
