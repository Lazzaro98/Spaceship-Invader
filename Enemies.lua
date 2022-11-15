local Model = require("Model")
local Stars = classes.class()

local Enemy = require("Enemy")
local Enemies = classes.class()

function Enemies:init(params)
    self.numOfEnemies = params.numOfEnemies
    local enemiesArr = {}
    self.numOfActiveEnemies = 10

    for i = 1, self.numOfEnemies do
        local enemy = Enemy.new(Model.enemyParams)
        enemy.speed = math.random(100, 200)
        table.insert(enemiesArr, enemy)
    end

    for i = 1, self.numOfActiveEnemies do
        local enemy = enemiesArr[i]
        enemy:spawn()
    end

    self.enemiesArr = enemiesArr
    self.durationNewLevelNotif = 2
    self.newLevelNotif = true
    self.newLevelNotifTimer = 0
end

function Enemies:update(dt)
    -- notification that player has passed to a new level
    if self.newLevelNotif then
        self.newLevelNotifTimer = self.newLevelNotifTimer + dt
        if self.newLevelNotifTimer > self.durationNewLevelNotif then
            self.newLevelNotif = false
            self.newLevelNotifTimer = 0
        end
    end

    -- if all enemies are destroyed, spawn new enemies - new level
    if self:checkAllDead() then
        self:spawnNextLevel()
        self.newLevelNotif = true
    end

    for i=1, self.numOfEnemies do
        local enemy = self.enemiesArr[i]
            enemy:update(dt)
    end

    -- check shields and magnets
    self:checkShield()
    if Model.ship.magnet == true then
        self:checkMagnet()
    end
    
end

function Enemies:draw()
    -- drawing enemies
    for i=1, self.numOfEnemies do
        local enemy = self.enemiesArr[i]
            enemy:draw()
    end
    --drawin notification
    if self.newLevelNotif == true then
        love.graphics.print("You are at level " .. Model.level, Model.stage.stageWidth /2 - 50, Model.stage.stageHeight /2)
    end
end

-- when enemies pickups are collected
function Enemies:onCollectablePickUp(ship)
    for i=1, self.numOfEnemies do
        local enemy = self.enemiesArr[i]
        local collectable = enemy.collectable
        if collectable ~= nil then
            if enemy.alive == false and collectable.active==true then
                enemy:onCollectablePickUp(ship)
            end
        end
    end
end

-- check shields
function Enemies:checkShield()
    for i=1, self.numOfEnemies do
        local enemy = self.enemiesArr[i]
        if enemy.shield.activeShield then
            local shield = enemy.shield
            shield:onEnemyTouch(self)
        end
    end
end

--check magnets
function Enemies:checkMagnet()
    for i=1, self.numOfEnemies do
        local enemy = self.enemiesArr[i]
        local collectable = enemy.collectable
        if(collectable and collectable.active) then
            collectable:checkMagnet(self)
        end
    end
end

--check if all enemies are dead if all collectables dissapeared from the screen - it means we can pass to the next level
function Enemies:checkAllDead()
    local allDead = true
    for i=1, self.numOfEnemies do
        local enemy = self.enemiesArr[i]
        local collectable = enemy.collectable
        if (collectable and collectable.active) or enemy.alive then
            allDead = false
        end
    end
    return allDead
end

-- enemies get level up. This happens after a few rounds. This will make enemies stronger
function Enemies:LevelUp()
    for i=1, self.numOfEnemies do
        local enemy = self.enemiesArr[i]
        enemy.maxHp = enemy.maxHp + 1
    end
end

-- Go to next level
function Enemies:spawnNextLevel()
    self.numOfActiveEnemies = self.numOfActiveEnemies + 10
    Model.level = Model.level + 1
    if self.numOfActiveEnemies > self.numOfEnemies then
        self.numOfActiveEnemies = 10
        self:LevelUp()
    end
    for i=1, self.numOfActiveEnemies do
        self.enemiesArr[i]:spawn()
    end
end


return Enemies