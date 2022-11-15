local classes = require("classes")
local Enemy = classes.class()
local Model = require("Model")
local AssetsManager = require("AssetsManager")
local ExplosionCls = require("Explosion")
local CoinCls = require("Coin")
local HealthCls = require("Health")
local MagnetCls = require("Magnet")
local ShieldCls = require("Shield")
local FireAnglesCls = require("FireAngles")
local FireRateCls = require("FireRate")

-- definiton of an enemy


function Enemy:init(params)
    
   
    self.speed = params.speed
    self.asset = params.asset
    self.damage = params.damage
    self.w = self.asset:getWidth()
    self.h = self.asset:getHeight()
    self.x = math.random(self.w, Model.stage.stageWidth - self.w) 
    self.y = self.asset:getHeight()
    
    print("Enemy init! X and Y positions are:" .. self.x .. " " .. self.y)
    self:setRandomMovement()
    self.explosion = ExplosionCls.new( Model.explosionParams )
    --each enemy will have one of the following collectable
    self.coin = CoinCls.new()
    self.collectable = self.coin
    self.health = HealthCls.new()
    self.magnet = MagnetCls.new()
    self.shield = ShieldCls.new()
    self.fireRate = FireRateCls.new()
    self.fireAngles = FireAnglesCls.new()
    self.hp = 1
    self.maxHp = 1 -- maxHp will be changing as the player goes to higher levels - becomes harder to kill the enemy

    self.alive = false
end

function Enemy:update(dt)
    if self.alive then
       local move_x = 0
       local move_y = 0
        if self.left == true then
            move_x = move_x + -1
        end
        if self.right == true then
            move_x = move_x + 1
        end
        if self.up == true then
            move_y = move_y + -1
        end
        if self.down == true then
            move_y = move_y + 1
        end

        local newX = self.x + (move_x * self.speed * dt)
        local newY = self.y + (move_y * self.speed * dt)

        if( newX - self.w/2 > 0 and newX + self.w/2 < Model.stage.stageWidth ) then
            self.x = newX
        else
            self.left = not self.left
            self.right = not self.right
        end

        if( newY - self.h/2 > 0 and newY + self.h/2 < Model.stage.stageHeight ) then
            self.y = newY
        else
            self.up = not self.up
            self.down = not self.down
        end
    end
    self.explosion:update(dt)
    if self.collectable then
        self.collectable:update(dt)
    end
        --self.coin:update(dt)
    --self.health:update(dt)
    --self.explosion.x = self.x
    --self.explosion.y = self.y
end

function Enemy:draw()
    self.explosion:draw()
    if self.collectable then
        self.collectable:draw()
    end
   -- self.coin:draw()
    --self.health:draw()
    if self.alive then
        local newX = self.x - (self.w/2)
        local newY = self.y - (self.h/2)
        love.graphics.draw(self.asset, newX,newY )
    end
    
end

-- enemy can be moving in 8 directions
function Enemy:setRandomMovement()
    if(Model.enemyParams.horizontalMoving == true) then
        local direction = math.random(0,1)
        if(direction == 0) then
            self.left = true
        else
            self.right = true
        end
    end
    if(Model.enemyParams.verticalMoving == true) then
        local direction = math.random(0,1)
        if(direction == 0) then
            self.up = true
        else
            self.down = true
        end
    end
end

-- spawn the enemy
function Enemy:spawn()
    self.collectable = self.fireAngles
    local rand = math.random(1, 100)
   if rand < 80 then
        self.collectable = self.coin
    elseif rand < 85 then
        self.collectable = self.health
    elseif rand < 90 then
        self.collectable = self.magnet
    elseif rand < 93 then
        self.collectable = self.fireRate
    elseif rand < 95 then
        self.collectable = self.fireAngles
    else
        if self.shield.activeShield then
            self.collectable = self.coin
        else
            self.collectable = self.shield
        end
    end

    self.x = math.random(self.w, Model.stage.stageWidth - self.w) 
    self.y = self.asset:getHeight()
    self.alive = true
    self.hp = self.maxHp
    --self:setRandomMovement()
end

-- what happens when enemy gets hit
function Enemy:onHit(dmg, spawn_collectable)
    self.hp = self.hp - 1
    if self.hp <= 0 then
        self:destroy(spawn_collectable)
        self.hp = self.maxHp
    end
end


-- destroying the enemy
function Enemy:destroy(spawn_collectable)
    self:explode()
    self.alive = false
    if spawn_collectable then
        if self.collectable then
            self.collectable:spawn(self)
        end
    end
end

--check collision of Enemy with the obj
function Enemy:checkCollision(obj)
    if self.alive then
        local left = self.x - self.w/2
        local right = self.x + self.w/2
        local top = self.y - self.h/2
        local bottom = self.y + self.h/2

        if obj.x > left and obj.x < right and obj.y > top and obj.y < bottom then
            return true
        end
    end
    return false
end

--explosion
function Enemy:explode()
    self.explosion:onExplosion(self)
end

-- when spaceship collects the collectable of the killed enemy
function Enemy:onCollectablePickUp(ship)
    if self.collectable ~= nil then
        if self.collectable:checkCollision(ship) then
            ship:pickUp(self.collectable)
            self.collectable:onPickUp(ship)
        end
    end
end


return Enemy