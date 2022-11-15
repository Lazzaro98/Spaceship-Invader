local classes = require("classes")
local Collectable = require("Collectable")
local FireRate = classes.class(Collectable)
local Model = require("Model")



function FireRate:init()
    Collectable.init(self, Model.fireRateParams)
end

--what happens when the player picks up the fireRate - it changes the weapon type
function FireRate:onPickUp(ship)
    self.active = false
    ship.bulletType = "triple_straight"
end

return FireRate