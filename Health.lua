local classes = require("classes")
local Collectable = require("Collectable")
local Health = classes.class(Collectable)
local Model = require("Model")



function Health:init(params)
    Collectable.init(self, Model.healthParams)
end
return Health