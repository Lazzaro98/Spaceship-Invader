local classes = require("classes")
local Collectable = require("Collectable")
local Shield = classes.class(Collectable)
local Model = require("Model")



function Shield:init(params)
    Collectable.init(self, Model.shieldParams)
    self.activeShield = false
    self.shipToProtect = nil
    self.angle = 0
    self.rotate_angle = 1.57079633 --180 degrees
end

function Shield:update(dt)
    Collectable.update(self, dt)
    if self.activeShield then 
        local shipX = self.shipToProtect.x
        local shipY = self.shipToProtect.y

        local r = 50
        --calculate cos and sin of angle
        local cos = math.cos(self.angle)
        local sin = math.sin(self.angle)

        self.x = r * sin + shipX 
        self.y = r * cos + shipY

        self.angle = self.angle - 0.1
        self.rotate_angle = self.rotate_angle + 0.1
    end
end

function Shield:draw()
    Collectable.draw(self)
    if self.activeShield then
        local shieldX = self.x - self.w/2 + self.shipToProtect.w/2
        local shieldY = self.y - self.h/2 + self.shipToProtect.h/2 - 15
        love.graphics.draw(self.asset, self.x, self.y, self.rotate_angle)
    end
end


--what happens when player(ship) picks up the shield
function Shield:onPickUp(ship)
    self.active = false
    self.activeShield = true
    self.shipToProtect = ship
end

-- what happens if the shield touches enemy - both of them gets destroyed
function Shield:onEnemyTouch(enemies)
    for i = 1, enemies.numOfEnemies do
        local enemy = enemies.enemiesArr[i]
        if enemy.alive then
            if enemy:checkCollision(self) then
                enemies.enemiesArr[i]:destroy()
                self.activeShield = false
            end
        end
    end
end
return Shield