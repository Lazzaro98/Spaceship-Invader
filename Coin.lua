local classes = require("classes")
local Collectable = require("Collectable")
local Coin = classes.class(Collectable)
local Model = require("Model")



function Coin:init(params)
    Collectable.init(self, Model.coinParams)
end
return Coin