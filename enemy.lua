enemyClass = {}

enemyClass.new = function(x, y, bumpWorld, physicsWorld)
    local self = self or {}
    self.x = x
    self.y = y
    self.width = 66
    self.height = 92
    self.jumpCount = 0
    self.type = "enemy"

    --bumpWorld:add(self,self.x, self.y, self.width, self.height)

    self.body = love.physics.newBody(physicsWorld, self.x, self.y,"dynamic")
    self.shape = love.physics.newRectangleShape(0,0,self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
    self.fixture:setFriction(1.0)
    self.fixture:setUserData(self)
    self.body:setPosition(self.x,self.y)
    self.body:setMass(1)

    self.health = 100
    self.sprite = love.graphics.newImage("assets/player/p1_stand.png")

    self.doJump = function()
      self.jumpCount = self.jumpCount + 1
      if self.jumpCount < 5 then
        self.body:applyLinearImpulse(0,-100)
      end
    end

    self.landed = function()
      self.jumpCount = 0
    end

    self.update = function(self, dt)
      local speed = 140


    end

    return self
end
