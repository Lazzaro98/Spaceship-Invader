local classes = require("classes")
local Bullet = classes.class()
local Model = require("Model")

-- definiton of one bullet
-- player can shoot multiple bullets at once if they have more cannons activated
-- each bullet has a speed, direction, damage
-- bullets pool is in class Bullets. There will be the function shoot() which will be called by spaceship when it wants to shoot

function Bullet:init(params)
    self.speed = params.speed
    self.asset = params.asset
    self.w = self.asset:getWidth()
    self.h = self.asset:getHeight()
    self.shot = false
    self.y = 0
    self.x = 0
    self.angle = 0
end



function Bullet:update(dt)
    if self.shot then
        local sin = math.sin(self.angle)
        local cos = math.cos(self.angle)
        self.y = self.y - self.speed * dt * cos
        self.x = self.x + self.speed * dt * sin
    end
    if self.y < 0 or self.x < 0 or self.x > Model.stage.stageWidth then
        self.shot = false
    end
end

function Bullet:draw()
    if self.shot then
        local newX = self.x - (self.w/2)
        local newY = self.y - (self.h/2)
        love.graphics.draw(self.asset, newX,newY )
    end
end

function Bullet:onFire(ship, angle)
    self.angle = 0
    if angle ~= nil then
        self.angle = angle
    end
    self.shot = true
    self.x = ship.x
    self.y = ship.y
end

function Bullet:onFirePos(x , y, angle)
    self.angle = 0
    if angle ~= nil then
        self.angle = angle
    end
    self.shot = true
    self.x = x
    self.y = y
end


function Bullet:checkCollision(obj)
    if self.shot then
        if self.x > obj.x - obj.w/2 and self.x < obj.x + obj.w/2 then
            if self.y > obj.y - obj.h/2 and self.y < obj.y + obj.h/2 then
                self.shot = false
                return true
            end
        end
    end
    return false
end

function Bullet:onEnemyCollision(enemy)
    self.shot = false
    enemy:onHit(1, true)
end
return Bullet