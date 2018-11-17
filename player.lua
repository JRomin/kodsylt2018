playerClass = {}

playerClass.new = function(x, y, physicsWorld)
    local self = self or {}
    self.x = x
    self.y = y
    self.width = 66
    self.height = 92

    physicsWorld:add(self,self.x, self.y, self.width, self.height)

    self.health = 100
    self.sprite = love.graphics.newImage("assets/player/p1_stand.png")

    return self
end
