local classes = require("classes")
local Ship = classes.class()
local Model = require("Model")
local ExplosionCls = require("Explosion")

function Ship:init(params)
    self.speed = params.speed
    self.asset = params.asset
    self.x = Model.stage.stageWidth / 2
    self.y = Model.stage.stageHeight / 2
    self.w = self.asset:getWidth()
    self.h = self.asset:getHeight()
    self.health = 100
    self.blink = false -- state in which we cannot get hit, because we just got hit by enemy. Cool down time is 1 second
    self.blinkTimer = 0
    self.blinkDuration = 2
    self.bulletType = "normal"
    self.lives = 3
    self.explosion = ExplosionCls.new( Model.explosionParams )
end

function Ship:update(dt)
    if self.blink == true then
        self.blinkTimer = self.blinkTimer + dt
        if self.blinkTimer > self.blinkDuration then
            self.blink = false
            self. blinkTimer = 0
        end
    end

    local left = Model.movement.left
    local right = Model.movement.right
    local up = Model.movement.up
    local down = Model.movement.down

    local x = 0
    local y = 0

    if left then
        x = x + -1
    end
    if right then
        x = x + 1
    end

    if up then
        y = y + -1
    end
    if down then
        y = y + 1
    end
    
    -- new position of the ship, if it does not violate screen bounds
    local newX = self.x + (x * self.speed * dt)
    local newY = self.y + (y * self.speed * dt)

    -- check bounds of screen for ship
    if( newX - self.w/2 > 0 and newX + self.w/2 < Model.stage.stageWidth ) then
        self.x = newX
        Model.ship.x = newX
    end
    if( newY - self.h/2 > 0 and newY + self.h/2 < Model.stage.stageHeight ) then
        self.y = newY
        Model.ship.y = newY
    end
    self.explosion:update(dt)
end

function Ship:draw()
    local newX = self.x - (self.w/2)
    local newY = self.y - (self.h/2)
    love.graphics.draw(self.asset, newX,newY )
    love.graphics.print("Lives:" .. self.lives .. " \nHP: " .. self.health .. "\nScore: ".. Model.score, 20, 20)
    self.explosion:draw()
end

-- check collision with object
function Ship:checkCollision(obj)
    if self.x > obj.x - obj.w/2 and self.x < obj.x + obj.w/2 then
        if self.y > obj.y - obj.h/2 and self.y < obj.y + obj.h/2 then
            return true
        end
    end
    return false
end

-- what happens if some of the enemies touch player
function Ship:onEmeniesCollisions(enemies)
    for i = 1, enemies.numOfEnemies do
        local enemy = enemies.enemiesArr[i]
        if enemy.alive and self.blink == false then
            if self:checkCollision(enemy) then
                self:onEnemyCollision(enemy)
            end
        end
    end
end

--what happens if an enemy tocuhes player
function Ship:onEnemyCollision(enemy)
    self.health = self.health - enemy.damage
    if self.health <= 0 then
        if self.lives > 0 then
            self.lives = self.lives - 1
            self.health = 100
            self.explosion:onExplosion(self)
            self.blink = true
        else
            Model.gameOver = true
        end
    end
    enemy:destroy(false)
end

--what happens when player picks up the collectible
function Ship:pickUp(collectable)
    Model.score = Model.score + collectable.points
    self.health = self.health + collectable.health
end

return Ship