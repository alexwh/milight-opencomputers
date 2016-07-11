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

-- the geolyzer returns a table containing a "color" element
function retrieveColor(analyze)
  for k, v in pairs(analyze) do
    if k == "color" then
      return v
    end
  end
end

function blockColor.get()
    geoColor = retrieveColor(geo.analyze(side.forward))

    -- bitwise mask out rgb bits and divide to account for extra place value on
    -- red and blue (4, and 2)
    red   = bit32.band(geoColor, 0xff0000)/16^4
    blue  = bit32.band(geoColor, 0x00ff00)/16^2
    green = bit32.band(geoColor, 0x0000ff)

    h, s, v, _ = rgbToHsv(red, blue, green, 0) -- ignore alpha
    -- h, s, and v are between 0 and 1 from the function, normalize them to their normal values
    h = math.floor((h*360)+0.5)
    s = math.floor((s*100)+0.5)
    v = math.floor((v*100)+0.5)

    -- shift the h (hue) to match about what the milight spectrum is (0-255 and add 176)
    -- values from https://git.io/vKnxe
    color = (256 + 176 - math.floor(h / 360 * 255)) % 256
    return color
end

return blockColor
