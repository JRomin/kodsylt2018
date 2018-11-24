local sti = require "sti/sti"
local bump = require "bump"
local map
local world
local objects = {}
require "player"
require "bonus"
local enemies = {}
local player
local lovephysics
local bonuses = {}
local score = 0
local gameState = "playing"
local attempts = 0
local totalBonuses = 0
Camera = require "hump.camera"

function love.load()
	-- Grab window size
	windowWidth  = love.graphics.getWidth()
	windowHeight = love.graphics.getHeight()

	-- Set world meter size (in pixels)
	love.physics.setMeter(70)



  --world = bump.newWorld(70)
	-- Load a map exported to Lua from Tiled


	-- Prepare physics world with horizontal and vertical gravity


--  world:setCallbacks(beginContact, endContact, preSolve, postSolve)


	-- Prepare collision objects
	--map:bump_init(world)


	-- Create a Custom Layer
	--local layer = map:addCustomLayer("Sprites", 3)


  loadWorld()


  text       = ""   -- we'll use this to put info text on the screen later
  persisting = 0
  --topLeftX, topLeftY, bottomRightX, bottomRightY = player.fixture:getBoundingBox( 1 )
  --print("TL ("..topLeftX..","..topLeftY..") BR ("..bottomRightX..","..bottomRightY..")")
--print(player.fixture:getBoundingBox(1).topLeftX..","..player.fixture:getBoundingBox(1).topLeftX..",".. player.fixture:getBoundingBox(1).bottomRightX..", ".. player.fixture:getBoundingBox(1).bottomRightY)
end

function loadWorld()
  map = sti("testTest2.lua",{ "box2d" })
  if lovephysics then
    lovephysics:destroy()
  end
  lovephysics = love.physics.newWorld(0, 9.81 * 70, true)
  lovephysics:setCallbacks(beginContact, endContact, preSolve, postSolve)

  map:box2d_init(lovephysics)
  for k, object in pairs(map.objects) do
    --print (object.name)
      if object.name == "Player" then
          --playerTemp = object
          print("Setup player!")
          print(object.id)
          player = playerClass.new(object.x, object.y, world, lovephysics)
          camera = Camera(player.body:getX(), player.body:getY())
      end
      if object.name == "mustach" then
        bonuses[k]=bonusClass.new(object.x, object.y, world, lovephysics)
        totalBonuses = totalBonuses + 1
      end
      if object.name == "lava" then
        --print("Add lava: "..object.width.." "..object.height)
        lavaBody = love.physics.newBody(lovephysics, object.x + (object.width/2), object.y,"static")
        lavaShape = love.physics.newRectangleShape(0,0,object.width, object.height)
        lavaFixture = love.physics.newFixture(lavaBody, lavaShape, 0)
        lavaFixture:setUserData({ type="lava" })
      end
      if object.name == "exit" then
      exitBody = love.physics.newBody(lovephysics, object.x + (object.width/2), object.y,"static")
      exitShape = love.physics.newRectangleShape(0,0,object.width, object.height)
      exitFixture = love.physics.newFixture(exitBody, exitShape, 0)
      exitFixture:setUserData({ type="exit" })
      end
  end
  map:removeLayer("System")
end

function love.update(dt)
  if gameState == "playing" then

  if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
      player:doJump()
  end


  -- Move player left
  if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
      player.body:applyLinearImpulse(-10, 0)
  end

  -- Move player right
  if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
      player.body:applyLinearImpulse(10, 0)
  end


  lovephysics:update(dt)
	map:update(dt)
  player:update(dt)

  local dx,dy = player.body:getX() - camera.x, player.body:getY() - camera.y
  camera:move(dx/2, dy/2)

  if string.len(text) > 768 then    -- cleanup when 'text' gets too long
        text = ""
    end
  end
  if gameState == "gameover" then
    if love.keyboard.isDown("space") then
      gameState = "playing"
      score = 0
      totalBonuses = 0
      attempts = attempts + 1
      player:reset()
      player = {}
      bonuses = {}
      loadWorld()
    end
  end
  if gameState == "done" then
    if love.keyboard.isDown("space") then
      gameState = "playing"
      score = 0
      attempts = 0
      player:reset()
      player = {}
      bonuses = {}
      loadWorld()
    end
  end
end

function love.draw()
  love.graphics.setBackgroundColor( 0, 20, 250 )
  if gameState == "playing" then

  local showBoundingBoxes = false
  --local player = map.layers["Sprites"].player
  local tx = math.floor(player.body:getX() - love.graphics.getWidth() / 2)
  local ty = math.floor(player.body:getY() - love.graphics.getHeight() / 2)
  --love.graphics.translate(-tx, -ty)

camera:attach()
	-- Draw the map and all objects within
	love.graphics.setColor(255, 255, 255)
	map:draw(-tx, -ty)
  if showBoundingBoxes then
    map:box2d_draw()
  end

  for k, bonus in pairs(bonuses) do
    if bonus.visible then
      love.graphics.draw(
          bonus.sprite,
          bonus.body:getX(),
          bonus.body:getY(),
          0,
          1,
          1,
          bonus.width/2,
          bonus.height/2
      )
    end
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

  if showBoundingBoxes then
    topLeftX, topLeftY, bottomRightX, bottomRightY = player.fixture:getBoundingBox( 1 )
    love.graphics.rectangle("line", topLeftX, topLeftY, bottomRightX - topLeftX, bottomRightY - topLeftY)
  end

	love.graphics.setColor(0, 0, 0)
  love.graphics.print("Score "..score.." of "..(totalBonuses*100), tx+25, ty + 25)
  camera:detach()
  end
  if gameState == "gameover" then
  love.graphics.setColor(0, 0, 0)

  love.graphics.print("Gamover! your score was "..score,(love.graphics.getWidth() / 2)-100, love.graphics.getHeight() / 2)
  love.graphics.print("This was your "..(attempts+1).." attept at finding the exit",(love.graphics.getWidth() / 2)-100, love.graphics.getHeight() / 2 +20)
  love.graphics.print("Press spacebar to play again.",(love.graphics.getWidth() / 2)-100, love.graphics.getHeight() / 2 + 40)
  end
  if gameState == "done" then
  love.graphics.setColor(0, 0, 0)

  love.graphics.print("You found the exit! your score was "..score,(love.graphics.getWidth() / 2)-100, love.graphics.getHeight() / 2)
  love.graphics.print("You made it here on "..(attempts+1).." attepts",(love.graphics.getWidth() / 2)-100, love.graphics.getHeight() / 2 +20)
  love.graphics.print("Press spacebar to play again.",(love.graphics.getWidth() / 2)-100, love.graphics.getHeight() / 2 + 40)
  end
end

function beginContact(a, b, coll)
  x,y = coll:getNormal()
  --text = text.."\n"..a:getUserData().." colliding with "..b:getUserData().." with a vector normal of: "..x..", "..y
  --text = text .."\n Collition vector normal of: "..x..", "..y

  if not b:isSensor() and b:getUserData().type == "player" and y < 0 then
    player.landed()
  end
  if not b:isSensor() and b:getUserData().type == "bonus" then
    score = score + 100
    b:getUserData().visible = false
    b:destroy()
  end
  if not b:isSensor() and b:getUserData().type == "lava" then
--    print("You died!")
    gameState = "gameover"
    ---player.landed()
  end
  if not b:isSensor() and b:getUserData().type == "exit" then
    --print("You died!")
    gameState = "done"
  end
end

function endContact(a, b, coll)

end

function preSolve(a, b, coll)

end

function postSolve(a, b, coll, normalimpulse, tangentimpulse)

end
