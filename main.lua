--this is how you require files in directories
package.path = package.path .. ";utils/?.lua;"
----------------------
--for debugging in zero brane, add breakpoints. be sure to activate "start debugging server" under "Project"
require("mobdebug").start()

--this is to make prints appear right away in zerobrane
io.stdout:setvbuf("no")

----INSTANTIARING A CLASS
local ShipCls = require("Ship")--import the class
local ship = nil

local StarsCls = require("Stars")
local stars = nil

local BulletsCls = require("Bullets")
local bullets = nil

local EnemiesCls = require("Enemies")
local enemies = nil

local AssetsManager = require("AssetsManager")
local Model = require("Model")


local LEFT_KEY = "left"
local RIGHT_KEY = "right"
local UP_KEY = "up"
local DOWN_KEY = "down"


function love.load()
    math.randomseed(os.time())
    print("love.load")
    AssetsManager.init()
    Model.init()
    stars = StarsCls.new( Model.starsParams)
    ship = ShipCls.new( Model.shipParams )
    bullets = BulletsCls.new( Model.bulletsParams )
    enemies = EnemiesCls.new( Model.enemiesParams )
end

function love.update(dt)
   -- print("update")
    if Model.gameOver==false then
        ship:update(dt)
        stars:update(dt)
        bullets:update(dt)
        enemies:update(dt)
        bullets:checkCollision(enemies)
        ship:onEmeniesCollisions(enemies)
        enemies:onCollectablePickUp(ship)
    end
end


function love.draw()
    stars:draw()
    ship:draw()
    bullets:draw()
    enemies:draw()
    if Model.gameOver ==true then 
        --red text color
        font = love.graphics.newFont(40)
        love.graphics.setFont(font)
        love.graphics.setColor( 255, 0, 0)
        love.graphics.print("Game Over!", Model.stage.stageWidth / 2 - 110, Model.stage.stageHeight / 2)
    end

end


function love.keypressed(key)
    print(key)
    if key == LEFT_KEY then
        Model.movement.left = true
    elseif key == RIGHT_KEY then
        Model.movement.right = true
    end
    
    if key == UP_KEY then
        Model.movement.up = true
    elseif key == DOWN_KEY then
        Model.movement.down = true
    end

    if key == "space" then
        bullets:shoot(ship)
    end
end

function love.keyreleased(key)
    if key == LEFT_KEY then
        Model.movement.left = false
    elseif key == RIGHT_KEY then
        Model.movement.right = false
    end
    
    if key == UP_KEY then
        Model.movement.up = false
    elseif key == DOWN_KEY then
        Model.movement.down = false
    end
end

--
--



