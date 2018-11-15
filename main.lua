local sti = require "sti/sti"
local bump = require "bump.lua/bump"
local map
local world
local objects = {}

function love.load()
	-- Grab window size
	windowWidth  = love.graphics.getWidth()
	windowHeight = love.graphics.getHeight()

	-- Set world meter size (in pixels)
	love.physics.setMeter(70)

	-- Load a map exported to Lua from Tiled
	map = sti("testTest1.lua",{ "bump" })

	-- Prepare physics world with horizontal and vertical gravity
	world = love.physics.newWorld(0, 0, true)
  world:setCallbacks(beginContact, endContact, preSolve, postSolve)


	-- Prepare collision objects
	map:bump_init(world)

	-- Create a Custom Layer
	local layer = map:addCustomLayer("Sprites", 3)

  local player
  for k, object in pairs(map.objects) do
      if object.name == "Player" then
          player = object
          break
      end
  end

  objects.player = {}
  objects.player.body = love.physics.newBody(world, player.x, player.y, "dynamic")
  objects.player.shape = love.physics.newRectangleShape(72, 72)
  objects.player.fixture = love.physics.newFixture(objects.player.body, objects.player.shape)

  local sprite = love.graphics.newImage("assets/player/p1_stand.png")
  layer.player = {
      sprite = sprite,
      x      = player.x,
      y      = player.y,
      ox     = sprite:getWidth() / 2,
      oy     = sprite:getHeight() / 1.35
  }

  layer.update = function(self, dt)
      -- 96 pixels per second
      local speed = 140

      -- Move player up
      if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
          self.player.y = self.player.y - speed * dt
      end

      -- Move player down
      if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
          self.player.y = self.player.y + speed * dt
      end

      -- Move player left
      if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
          self.player.x = self.player.x - speed * dt
      end

      -- Move player right
      if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
          self.player.x = self.player.x + speed * dt
      end
  end

  -- Draw player
layer.draw = function(self)
    love.graphics.draw(
        self.player.sprite,
        math.floor(self.player.x),
        math.floor(self.player.y),
        0,
        1,
        1,
        self.player.ox,
        self.player.oy
    )

    -- Temporarily draw a point at our location so we know
    -- that our sprite is offset properly
    love.graphics.setPointSize(5)
    love.graphics.points(math.floor(self.player.x), math.floor(self.player.y))
end
map:removeLayer("System")
	-- Add data to Custom Layer
--	local spriteLayer = map.layers["Sprite Layer"]
--	spriteLayer.sprites = {
--		player = {
--			image = love.graphics.newImage("assets/player/p1_stand.png"),
---			x = 140,
--			y = 140,
--			r = 0,
--		}
--	}

	-- Update callback for Custom Layer
--	function spriteLayer:update(dt)
--		for _, sprite in pairs(self.sprites) do
--			-- sprite.r = sprite.r + math.rad(90 * dt)
--		end
--	end

	-- Draw callback for Custom Layer
--	function spriteLayer:draw()
--		for _, sprite in pairs(self.sprites) do
--			local x = math.floor(sprite.x)
--			local y = math.floor(sprite.y)
--			local r = sprite.r
--			love.graphics.draw(sprite.image, x, y, r)
--		end
--	end
end

function love.update(dt)
world:update(dt)
	map:update(dt)
end

function love.draw()
  local player = map.layers["Sprites"].player
  local tx = math.floor(player.x - love.graphics.getWidth() / 2)
  local ty = math.floor(player.y - love.graphics.getHeight() / 2)
  love.graphics.translate(-tx, -ty)


	-- Draw the map and all objects within
	love.graphics.setColor(255, 255, 255)
	map:draw()

	-- Draw Collision Map (useful for debugging)
	love.graphics.setColor(255, 0, 0)
	map:box2d_draw(tx, ty)

	-- Please note that map:draw, map:box2d_draw, and map:bump_draw take
	-- translate and scale arguments (tx, ty, sx, sy) for when you want to
	-- grow, shrink, or reposition your map on screen.
end

function beginContact(a, b, coll)
--text = text.."\n"..a:getUserData().." colliding with "..b:getUserData().." with a vector normal of: "..x..", "..y
  print(a:getUserData())
    --if(a:isSensor() and a:getUserData().properties) then
    --    if(a:getUserData().properties.type == 'dialog' and b:getUserData():type() == 'player') then
    --        mainDialog:startScript(a:getUserData().properties.script)
    --        a:destroy()
    --    end
    --end

    --if(a:isSensor() and a:getUserData().type) then
    --    if(a:getUserData():type() == "collectable" and b:getUserData():type() == 'player') then
    --        a:getUserData():collect()
    --        a:destroy()
    --        score = score + 20
    --    end
    --end
end

function endContact(a, b, coll)
end

function preSolve(a, b, coll)
end

function postSolve(a, b, coll, normalimpulse, tangentimpulse)
end
