local sti = require "sti/sti"
local bump = require "bump"
local map
local world
local objects = {}
require "player"
local enemies = {}
local player
local lovephysics
local bonuses = {}
Camera = require "hump.camera"

function love.load()
	-- Grab window size
	windowWidth  = love.graphics.getWidth()
	windowHeight = love.graphics.getHeight()

	-- Set world meter size (in pixels)
	love.physics.setMeter(70)



  --world = bump.newWorld(70)
	-- Load a map exported to Lua from Tiled
	map = sti("testTest1.lua",{ "box2d" })

	-- Prepare physics world with horizontal and vertical gravity

  lovephysics = love.physics.newWorld(0, 9.81 * 70, true)
  lovephysics:setCallbacks(beginContact, endContact, preSolve, postSolve)
--  world:setCallbacks(beginContact, endContact, preSolve, postSolve)


	-- Prepare collision objects
	--map:bump_init(world)
  map:box2d_init(lovephysics)

	-- Create a Custom Layer
	--local layer = map:addCustomLayer("Sprites", 3)


  for k, object in pairs(map.objects) do
    print (object.name)
      if object.name == "Player" then
          --playerTemp = object
          print("Setup player!")
          print(object.id)
          player = playerClass.new(object.x, object.y, world, lovephysics)
          camera = Camera(player.body:getX(), player.body:getY())
          --break
      end
      if object.name == "mustach" then
        print(object.x)
      end
  end
  map:removeLayer("System")

  text       = ""   -- we'll use this to put info text on the screen later
  persisting = 0
  --topLeftX, topLeftY, bottomRightX, bottomRightY = player.fixture:getBoundingBox( 1 )
  --print("TL ("..topLeftX..","..topLeftY..") BR ("..bottomRightX..","..bottomRightY..")")
--print(player.fixture:getBoundingBox(1).topLeftX..","..player.fixture:getBoundingBox(1).topLeftX..",".. player.fixture:getBoundingBox(1).bottomRightX..", ".. player.fixture:getBoundingBox(1).bottomRightY)
end

function love.update(dt)
  --world:update(dt)
  local speed = 140
  if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
      --player.y = player.y - speed * dt
      player:doJump()
      --player.body:applyForce(0, 200)
      --player.body:applyLinearImpulse(0,-100)
      --player.body:applyLinearImpulse(0, -10)
  end

  -- Move player down
  --if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
  --    player.y = player.y + speed * dt
  --end

  -- Move player left
  if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
      --player.x = player.x - speed * dt
      player.body:applyLinearImpulse(-10, 0)
  end

  -- Move player right
  if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
      --player.x = player.x + speed * dt
      player.body:applyLinearImpulse(10, 0)
  end
  --world:update(objects.player, self.player.x, self.player.y )
  --local actualX, actualY, cols, len = world:move(player, player.x, player.y)
  --player.x, player.y = actualX, actualY
  ------ deal with the collisions
  --for i=1,len do
  --  print('collided with ' .. tostring(cols[i].other))
  --  player.jump = false
  --end

  lovephysics:update(dt)
	map:update(dt)
  player:update(dt)

  local dx,dy = player.body:getX() - camera.x, player.body:getY() - camera.y
  camera:move(dx/2, dy/2)

  if string.len(text) > 768 then    -- cleanup when 'text' gets too long
        text = ""
    end


end

function love.draw()
  local showBoundingBoxes = true
  --local player = map.layers["Sprites"].player
  local tx = math.floor(player.body:getX() - love.graphics.getWidth() / 2)
  local ty = math.floor(player.body:getY() - love.graphics.getHeight() / 2)
  --love.graphics.translate(-tx, -ty)

camera:attach()
--local cx,cy = camera:position()
--local offset_x = (cx - love.graphics.getWidth()) / 2
--local offset_y = (cy - love.graphics.getHeight()) / 2
--local dx,dy = player.body:getX() - camera.x, player.body:getY() - camera.y
--print("X "..(tx).." Y "..(ty))
	-- Draw the map and all objects within
	love.graphics.setColor(255, 255, 255)
	map:draw(-tx, -ty)
  if showBoundingBoxes then
    map:box2d_draw()
  end

  love.graphics.draw(
      player.sprite,
      player.body:getX(),
      player.body:getY(),
      0,
      1,
      1,
      player.width/2,
      player.height/2
  )
  --love.graphics.rectangle("line", player.body:getX(), player.body:getY(), player.width, player.height)

  if showBoundingBoxes then
    topLeftX, topLeftY, bottomRightX, bottomRightY = player.fixture:getBoundingBox( 1 )
    love.graphics.rectangle("line", topLeftX, topLeftY, bottomRightX - topLeftX, bottomRightY - topLeftY)
  end

	love.graphics.setColor(255, 0, 0)
  love.graphics.print(text, 50, 75)
  camera:detach()
end

function beginContact(a, b, coll)
  x,y = coll:getNormal()
  --text = text.."\n"..a:getUserData().." colliding with "..b:getUserData().." with a vector normal of: "..x..", "..y
  text = text .."\n Collition vector normal of: "..x..", "..y
  --if not a:isSensor() then
    --print(a:getUserData().type)
  --end
  if not b:isSensor() and b:getUserData().type == "player" and y < 0 then
    player.landed()
    --print(b:getUserData().type)
  end
end

function endContact(a, b, coll)

end

function preSolve(a, b, coll)

end

function postSolve(a, b, coll, normalimpulse, tangentimpulse)

end
