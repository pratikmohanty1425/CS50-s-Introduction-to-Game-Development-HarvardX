--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerPotWalkState = Class{__includes = EntityWalkState}

function PlayerPotWalkState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon
    self.pot = nil

    self.bumped = false
    
    self.player:changeAnimation('pot-walk-' .. self.player.direction)

end

function PlayerPotWalkState:enter(params)
    self.pot = params.pot
end


function PlayerPotWalkState:update(dt)
    EntityWalkState.update(self, dt)

    self.pot.x = self.entity.x 
    self.pot.y = self.entity.y - self.pot.height / 2

    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('pot-walk-left')
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('pot-walk-right')
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('pot-walk-up')
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('pot-walk-down')
    else
        self.entity:changeState('pot-idle', { pot = self.pot })
    end

    if love.keyboard.wasPressed('f') then 
        self.entity:changeState('pot-throw', {pot = self.pot})
    end
    
end