--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]
-- update 2
Pot = Class{__includes = GameObject}

function Pot:init(def,x,y)
    GameObject.init(self,def,x,y)

    --properties of pot
    self.moveSpeed = 0
    self.direction = 'none'
    self.distanceTraveled = 0
    self.flashTimer = 0
    self.flashDuration = 0
end

function Pot:initLift()
    self.state = 'lifted'
    self.solid = false
end

function Pot:initThrow(direction)
    self.state = 'flying'
    self.solid = false
    self.moveSpeed = 100
    self.direction = direction
end

function Pot:initDestroy()
    self.state = 'broken'
    self.solid = false
    self.moveSpeed = 0
    --gSounds['break']:play()
end

function Pot:update(dt) 

end

function Pot:render(adjacentOffsetX, adjacentOffsetY)
    if self.state == 'broken' and self.flashTimer > 0.06 then
        self.flashTimer = 0
        love.graphics.setColor(1, 1, 1, 64/255)
    end
    
    GameObject.render(self, adjacentOffsetX, adjacentOffsetY)

    love.graphics.setColor(1, 1, 1, 1)
end