local classes = require("classes")
local Collectable = classes.class()
local Model = require("Model")

-- base class
-- all collectibles inherit from this class

function Collectable:init(params)
    self.asset = params.asset
    self.w = self.asset:getWidth()
    self.h = self.asset:getHeight()
    self.x = 0
    self.y = 0
    self.active = false
    self.points = params.points
    self.health = params.health
    self.speed = params.speed
    self.magnetized = false
end

function Collectable:spawn(obj)
    self.x = obj.x
    self.y = obj.y
    self.active = true
end

function Collectable:update(dt)
    if self.active then
        if self.magnetized then
            --get a sign from number
            local sign = function(x) return x>0 and 1 or x<0 and -1 or 0 end
            local newX = self.x + sign(Model.ship.x - self.x) * self.speed * dt
            local newY = self.y + sign(Model.ship.y - self.y) * self.speed * dt
            --if current x is different then newX

            if(self.x ~= newX) then 
                self.x = newX
            end
            if(self.y ~= newY) then 
                self.y = newY
            end
        else
            self.y = self.y + (self.speed * dt)
        end
    end
    if self.y > Model.stage.stageHeight then
        self.active = false
    end
end

function Collectable:draw()
    if self.active then
        local newX = self.x - (self.w/2)
        local newY = self.y - (self.h/2)
        love.graphics.draw(self.asset, newX,newY )
    end
end

function Collectable:checkCollision(obj)
    if self.active then
        local newX = self.x + self.w
        local newY = self.y + (self.h/2)
        if self.x + self.w > obj.x and self.x < obj.x + obj.w then
            if self.y + self.h > obj.y and  self.y < obj.y + obj.h then
                --self:onPickUp(obj)
                return true
            end
        end
    end
    return false
end


function Collectable:onPickUp(ship)
    self.active = false
    self.magnetized = false
end

function Collectable:checkMagnet(enemies)
    for i = 1, enemies.numOfEnemies do
        local collectable = enemies.enemiesArr[i].collectable
        if collectable ~= nil then
            if Model.ship.magnet then
                if collectable.active then
                    local dist = math.sqrt((Model.ship.x - collectable.x)^2 + (Model.ship.y - collectable.y)^2)
                    if(dist < 100) then
                        collectable.magnetized = true
                        collectable.speed = 500
                    else
                        collectable.magnetized = false
                        collectable.speed = 200
                    end
                end
            end
        end
    end
end

return Collectable