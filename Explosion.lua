local classes = require("classes")
local Explosion = classes.class()
local Model = require("Model")

-- whenever enemy or ship is destroyed, an explosion is created

function Explosion:init(params)
    self.asset = params.asset
    self.w = self.asset:getWidth()
    self.h = self.asset:getHeight()
    self.x = 0
    self.y = 0
    self.active = false
    self.duration = params.duration
end

function Explosion:update(dt)
    if self.active then
        self.timer = self.timer - dt
        if self.timer < 0 then
            self.active = false
        end
    end
end

function Explosion:draw()
    
    if self.active then
        local newX = self.x - (self.w/2)
        local newY = self.y - (self.h/2)
        love.graphics.draw(self.asset, newX,newY )
    end
end

function Explosion:onExplosion(object)
    
    self.x = object.x
    self.y = object.y
    self.active = true

    self.timer = self.duration
end
return Explosion