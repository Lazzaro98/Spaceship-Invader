local AssetsManager = require("AssetsManager")
local Model = {
    movement = {
        up = false,
        down = false,
        left = false,
        right = false,
        space = false
    },

    score = 0,
    level = 1,
    gameOver = false
}
Model.ship = {
    x = 0,
    y = 0,
    magnet = false
}
Model.shipParams = {
    assetName = "ship",
    speed = 500
}

Model.starsParams = {
    radius = 1,
    speed = 100,
    numStars = 200
}

Model.bulletParams = {
    assetName = "bullet",
    speed = 800
}

Model.bulletsParams = {
    numOfBullets = 100
}

Model.enemiesParams = {
    numOfEnemies = 30
}


Model.enemyParams = {
    assetName = "enemy",
    speed = 200,
    damage = 40,
    horizontalMoving = true,
    verticalMoving = true
}

Model.explosionParams = {
    assetName = "explosion",
    duration = 1
}

Model.coinParams = {
    assetName = "coin",
    speed = 200,
    points = 1,
    health = 0,
    duration = 0
}

Model.healthParams = {
    assetName = "health",
    speed = 200,
    points = 0,
    health = 20,
    duration = 0
}

Model.magnetParams = {
    assetName = "magnet",
    speed = 200,
    points = 0,
    health = 20,
    duration = 7
}

Model.shieldParams = {
    assetName = "shield",
    speed = 200,
    points = 0,
    health = 20,
    duration = 7
}

Model.fireRateParams = {
    assetName = "fireRate",
    speed = 200,
    points = 0,
    health = 0,
    duration = 0
}

Model.fireAnglesParams = {
    assetName = "fireAngles",
    speed = 200,
    points = 0,
    health = 0,
    duration = 0
}

Model.init = function()
    Model.stage = {
        stageHeight = love.graphics.getHeight(),
        stageWidth = love.graphics.getWidth()
    }
    
    --init assets dynamically
    Model.shipParams.asset = AssetsManager.sprites[Model.shipParams.assetName]
    Model.bulletParams.asset = AssetsManager.sprites[Model.bulletParams.assetName]
    Model.enemyParams.asset = AssetsManager.sprites[Model.enemyParams.assetName]
    Model.explosionParams.asset = AssetsManager.sprites[Model.explosionParams.assetName]
    Model.coinParams.asset = AssetsManager.sprites[Model.coinParams.assetName]
    Model.healthParams.asset = AssetsManager.sprites[Model.healthParams.assetName]
    Model.magnetParams.asset = AssetsManager.sprites[Model.magnetParams.assetName]
    Model.shieldParams.asset = AssetsManager.sprites[Model.shieldParams.assetName]
    Model.fireRateParams.asset = AssetsManager.sprites[Model.fireRateParams.assetName]
    Model.fireAnglesParams.asset = AssetsManager.sprites[Model.fireAnglesParams.assetName]
    
    --define enemies here

end


return Model