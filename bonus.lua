bonusClass={}

bonusClass.new = function(x, y, bumpWorld, physicsWorld)
    local self = self or {}
    self.x = x + 32
    self.y = y + 32
    self.width = 64
    self.height = 64
    self.jumpCount = 0
    self.type = "bonus"
    self.visible = true
    self.sprite = love.graphics.newImage("assets/bonus/mustache01.png")
    self.body = love.physics.newBody(physicsWorld, self.x, self.y,"static")
    self.shape = love.physics.newRectangleShape(0,0,self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape, 0)

    self.body:setMass(0)
    self.fixture:setUserData(self)
    self.body:setPosition(self.x,self.y)

    return self
end
