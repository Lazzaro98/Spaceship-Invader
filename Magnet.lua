local classes = require("classes")
local Collectable = require("Collectable")
local Magnet = classes.class(Collectable)
local Model = require("Model")



function Magnet:init(params)
    print("Magnet:init")
    Collectable.init(self, Model.magnetParams)
    print("Magnet:init passed")
    self.timer = 0
    --5 seconds
    self.duration = Model.magnetParams.duration
end

--what happens when the player picks up the magnet
function Magnet:onPickUp(ship)
    self.active = false
    Model.ship.magnet = true
end

function Magnet:update(dt)
    Collectable.update(self, dt)
    if Model.ship.magnet == true then
        self.timer = self.timer + dt
        if self.timer > self.duration then
            print("Magnet:timer > duration")
            Model.ship.magnet = false
            self.timer = 0
        end
    end
end



return Magnet