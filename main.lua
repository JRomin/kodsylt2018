local sti = require "sti/sti"
local bump = require "bump"
local map
local world
local objects = {}
require "player"
local enemies = {}
local player

function love.load()
	-- Grab window size
	windowWidth  = love.graphics.getWidth()
	windowHeight = love.graphics.getHeight()

	-- Set world meter size (in pixels)
	love.physics.setMeter(70)



  world = bump.newWorld(70)
	-- Load a map exported to Lua from Tiled
	map = sti("testTest1.lua",{ "bump" })

	-- Prepare physics world with horizontal and vertical gravity

--	world = love.physics.newWorld(0, 0, true)
--  world:setCallbacks(beginContact, endContact, preSolve, postSolve)


	-- Prepare collision objects
	map:bump_init(world)

	-- Create a Custom Layer
	local layer = map:addCustomLayer("Sprites", 3)

  --local playerTemp

  player = playerClass.new(0, 0, world)
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
  --player = playerClass.new(playerTemp.x, playerTemp.y, world)
  --objects.player = {}
  --objects.player = { name = "Player" , x = player.x, y = player.y}
  --objects.player.body = love.physics.newBody(world, player.x, player.y, "dynamic")
  --objects.player.shape = love.physics.newRectangleShape(70, 70)
  --objects.player.world = world
  --objects.player.fixture = love.physics.newFixture(objects.player.body, objects.player.shape, 1)
  --objects.player.fixture.setUserData(objects.player)

  --world:add(player,player.x, player.y, 66, 92)
  --print(world:check(objects.player))

map:removeLayer("System")

end

function love.update(dt)
  --world:update(dt)
  local speed = 140
  if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
      player.y = player.y - speed * dt
  end

  -- Move player down
  if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
      player.y = player.y + speed * dt
  end

  -- Move player left
  if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
      player.x = player.x - speed * dt

  end

  -- Move player right
  if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
      player.x = player.x + speed * dt
  end
  --world:update(objects.player, self.player.x, self.player.y )
  local actualX, actualY, cols, len = world:move(player, player.x, player.y)
  player.x, player.y = actualX, actualY
  ---- deal with the collisions
  for i=1,len do
    print('collided with ' .. tostring(cols[i].other))
  end


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

	-- Draw Collision Map (useful for debugging)
	love.graphics.setColor(255, 0, 0)
	--map:box2d_draw(tx, ty)
  --map:bump_draw(tx, ty, 1, 1)
--love.graphics.print(world, 50,50)
love.graphics.print("Test 2", 50, 75)
	-- Please note that map:draw, map:box2d_draw, and map:bump_draw take
	-- translate and scale arguments (tx, ty, sx, sy) for when you want to
	-- grow, shrink, or reposition your map on screen.
end
