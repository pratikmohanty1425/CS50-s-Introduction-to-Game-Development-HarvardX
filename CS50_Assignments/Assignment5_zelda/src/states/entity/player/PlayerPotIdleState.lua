--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerPotIdleState = Class{__includes = EntityIdleState}

function PlayerPotLiftState:init(player, dungeon)
    EntityIdleState:init(player)
    self.player = player
    self.dungeon = dungeon
    self.pot = nil

    self.player:changeAnimation('pot-idle-' .. self.player.direction)

end

function PlayerPotIdleState:enter(params)
    self.entity.offsetY = 5
    self.entity.offsetX = 0
    self.pot = params.pot
end


function PlayerPotIdleState:update(dt)
    EntityIdleState:update(dt)

    self.pot.x = self.entity.x 
    self.pot.y = self.entity.y - self.pot.height / 2

    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('pot-walk', {pot = self.pot})
    end

    if love.keyboard.wasPressed('f') then 
        self.entity:changeState('pot-throw', {pot = self.pot})
    end
end
