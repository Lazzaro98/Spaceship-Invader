local classes = require("classes")
local Collectable = require("Collectable")
local FireAngles = classes.class(Collectable)
local Model = require("Model")


function FireAngles:init()
    Collectable.init(self, Model.fireAnglesParams)
end

-- what happens when the player picks up the fireAngles - it changes the weapon type
function FireAngles:onPickUp(ship)
    self.active = false
    ship.bulletType = "triple_angle"
end

return FireAngles