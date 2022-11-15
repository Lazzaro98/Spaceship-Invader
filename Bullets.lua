local Model = require("Model")
local Bullet = require("Bullet")
local Bullets = classes.class()
local classes = require("classes")


local index = 1

function Bullets:init(params)
    self.numOfBullets = params.numOfBullets
    local bulletsArr = {}

    for i = 1, self.numOfBullets do
        local bullet = Bullet.new(Model.bulletParams)
        table.insert(bulletsArr, bullet)
    end

    self.bulletsArr = bulletsArr
end

function Bullets:shoot(ship)
    --define the behaviour of all types of bullets here
    if ship.bulletType == "normal" then
        local bullet = self.bulletsArr[index]
        bullet:onFire(ship)
        index = index % self.numOfBullets + 1
    elseif ship.bulletType == "triple_straight" then
        local bullet1 = self.bulletsArr[index]
        index = index % self.numOfBullets + 1
        local bullet2 = self.bulletsArr[index]
        index = index % self.numOfBullets + 1
        local bullet3 = self.bulletsArr[index]
        index = index % self.numOfBullets + 1
        bullet1:onFire(ship)
        bullet2:onFirePos(ship.x + 15, ship.y)
        bullet3:onFirePos(ship.x - 15, ship.y)
    elseif ship.bulletType == "triple_angle" then
        local bullet1 = self.bulletsArr[index]
        index = index % self.numOfBullets + 1
        local bullet2 = self.bulletsArr[index]
        index = index % self.numOfBullets + 1
        local bullet3 = self.bulletsArr[index]
        index = index % self.numOfBullets + 1
        bullet1:onFire(ship)
        --45 degrees to radian
        bullet2:onFirePos(ship.x + 15, ship.y, math.pi/6)
        bullet3:onFirePos(ship.x - 15, ship.y, -math.pi/6)
    end
end

function Bullets:update(dt)
    for i=1, self.numOfBullets do
        local bullet = self.bulletsArr[i]
        bullet:update(dt)
    end
end

function Bullets:draw()
    for i=1, self.numOfBullets do
        local bullet = self.bulletsArr[i]
        bullet:draw()
    end
end

function Bullets:checkCollision(enemies)
    for i=1, self.numOfBullets do
        local bullet = self.bulletsArr[i]
        if bullet.shot then
            for j=1, enemies.numOfEnemies do
                local enemy = enemies.enemiesArr[j]
                if enemy.alive then
                    if bullet:checkCollision(enemy) then
                        bullet:onEnemyCollision(enemy)
                    end
                end
            end
        end
    end
end

return Bullets