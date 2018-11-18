playerClass = {}

playerClass.new = function(x, y, bumpWorld, physicsWorld)
    local self = self or {}
    self.x = x
    self.y = y
    self.width = 66
    self.height = 92
    self.jump = false
    self.jumpDirection = 0
    self.jumpOffset = 0

    bumpWorld:add(self,self.x, self.y, self.width, self.height)

    self.health = 100
    self.sprite = love.graphics.newImage("assets/player/p1_stand.png")

    self.doJump = function()
        self.jump = true
        self.jumpDirection = -1
        self.jumpOffset = 0
    end

    self.update = function(self, dt)
      local speed = 140
      if self.jump then
        self.jumpOffset = self.jumpOffset + self.jumpDirection
        print(self.jumpOffset)
        self.y = self.y + (self.jumpDirection * speed * dt)
        if self.jumpOffset > 20 and self.jumpDirection == 1 then
          --self.jumpDirection = -1
          self.jump = false
        end
        if self.jumpOffset < -20 and self.jumpDirection == -1 then
          --self.jump = false
          self.jumpDirection = 1
        end
      end

    end

    return self
end
