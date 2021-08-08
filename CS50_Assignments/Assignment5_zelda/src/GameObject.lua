--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def, x, y)
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = def.solid

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states
    self.toRemove = false

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height
    self.scale = def.scale or 1

    -- default empty collision callback
    self.consumable = def.consumable or false
    self.onConsume = function() end
    self.onCollide = function() end
end

function GameObject:update(dt)

end

function GameObject:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    -- update 1
    local frame
    if self.states == nil then
        frame = self.frame
    else
        frame = self.states[self.state].frame
    end

    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][frame],
        math.floor(self.x + adjacentOffsetX), math.floor(self.y + adjacentOffsetY), 0, self.scale, self.scale)
end