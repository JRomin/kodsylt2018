local sti = require "sti/sti"
local bump = require "bump"
local map
local world
local objects = {}
require "player"
local enemies = {}
local player
local lovephysics

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
--  world:setCallbacks(beginContact, endContact, preSolve, postSolve)


	-- Prepare collision objects
	--map:bump_init(world)
  map:box2d_init(lovephysics)

	-- Create a Custom Layer
	--local layer = map:addCustomLayer("Sprites", 3)

  player = playerClass.new(0, 0, world, lovephysics)
  for k, object in pairs(map.objects) do
      if object.name == "Player" then
          --playerTemp = object
          print("Setup player!")
          print(object.id)
          player.x = object.x
          player.y = object.y
          break
      end
  end
  map:removeLayer("System")

end

function love.update(dt)
  --world:update(dt)
  local speed = 140
  if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
      --player.y = player.y - speed * dt
      --player:doJump()
      player.body:applyForce(400, 0)
      player.body:applyLinearImpulse(0,-300)
  end

  -- Move player down
  --if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
  --    player.y = player.y + speed * dt
  --end

  -- Move player left
  if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
      player.x = player.x - speed * dt

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
  player:update(dt)
	map:update(dt)
end

function love.draw()
  --local player = map.layers["Sprites"].player
  local tx = math.floor(player.x - love.graphics.getWidth() / 2)
  local ty = math.floor(player.y - love.graphics.getHeight() / 2)
  --love.graphics.translate(-tx, -ty)

	-- Draw the map and all objects within
	love.graphics.setColor(255, 255, 255)
	map:draw()

  love.graphics.draw(
      player.sprite,
      math.floor(player.x),
      math.floor(player.y),
      0,
      1,
      1--,
      --self.player.ox,
      --self.player.oy
  )

	love.graphics.setColor(255, 0, 0)
  love.graphics.print("Test 2", 50, 75)
end
