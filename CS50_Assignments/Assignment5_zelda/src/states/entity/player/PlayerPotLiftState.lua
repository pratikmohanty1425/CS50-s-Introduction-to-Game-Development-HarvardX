--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]
-- update 2
PlayerPotLiftState = Class{__includes = BaseState}

function PlayerPotLiftState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon
    self.pot = nil

    self.player:changeAnimation('pot-lift-' .. self.player.direction)
end

function PlayerPotLiftState:enter(params)
    self.pot = params.pot

    self.player.currentAnimation:refresh()

    local potX, potY = self.player.x, self.player.y - self.pot.height / 2

    Timer.tween(0.3,{
        [self.pot] = { x = potX, y = potY}
    }):finish(function()
        self.player:changeState('pot-idle', {pot = self.pot})
    end)
end

function PlayerPotLiftState:update(dt)
    
end

function PlayerPotLiftState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))
end