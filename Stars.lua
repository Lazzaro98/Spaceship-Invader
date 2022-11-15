local Model = require("Model")
local Stars = classes.class()

function Stars:init(params)
    self.speed = params.speed
    self.radius = params.radius
    local numStars = params.numStars
    local stageWidth = Model.stage.stageWidth
    local stageHeight = Model.stage.stageHeight
    local starsArr = {}
    for i=1, numStars do
        local x = math.random() * stageWidth
        local y = math.random() * stageHeight
        local star = {x = x,y = y}
        table.insert(starsArr, star)
    end
    self.numStars = numStars
    self.starsArr = starsArr
    
end

function Stars:update(dt)
    for i=1, self.numStars do
        local star = self.starsArr[i]
        star.y = star.y + (self.speed * dt)
        if star.y > Model.stage.stageHeight then
            star.y = 0
        end
    end
end

function Stars:draw()
    love.graphics.setColor(1, 1, 1)
    local radius = self.radius
    local starsArr = self.starsArr
    local numStars = self.numStars
    for i=1, numStars do
        local star = starsArr[i]
        love.graphics.circle("fill", star.x, star.y, radius) -- Draw white circle with 100 segments.
    end
end

return Stars