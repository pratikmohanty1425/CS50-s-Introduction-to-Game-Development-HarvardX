--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:init(player, dungeon)
    EntityIdleState:init(player)
    self.entity = player
    self.dungeon = dungeon
end

function PlayerIdleState:enter(params)
    -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerIdleState:update(dt)
    EntityIdleState.update(self, dt)
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walk')
    end

    if love.keyboard.wasPressed('space') then
        self.entity:changeState('swing-sword')
    end

    -- update 2 
    -- check if player near to the pot

    local potToLift
    
    for k, object in pairs(self.dungeon.currentRoom.objects) do 
        if object.solid then
            if self.entity:collideWithSolid(object) and object.type == 'pot' then 
                potToLift = object
                potToLift:initLift()
                self.entity:changeState('pot-lift', {pot = potToLift})
                break
            end
        end
    end
end