bulb = require("bulb")
block = require("block")
robot = require("robot")
sides = require("sides")

function check(side)
  return block.get(side) == "minecraft:air"
end

while true do
  currentBlock = block.get()
  print(currentBlock)
  if check(sides.right) then
    robot.turnRight()
    robot.forward()
  else
      if check(sides.left) then
        robot.turnLeft()
        robot.forward()
      else
        if check(sides.forward) then
          robot.forward()
        else
          if check(sides.back) then
            robot.turnLeft()
            robot.turnLeft()
            robot.forward()
          end
        end
    end
  end
  if currentBlock == "minecraft:wool" then
    bulb.colorNumber(block.getColor())
  end
end
