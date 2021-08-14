--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]
-- update 2
PlayerPotThrowState = Class{__includes = BaseState}

function PlayerPotThrowState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    self.player:changeAnimation('pot-throw-' .. self.player.direction)
end

function PlayerPotThrowState:enter(params)

    self.player.currentAnimation:refresh()

    Timer.after(0.15,function()
        params.pot:initThrow(self.player.direction)
    end)

    Timer.after(0.3,function()
        self.player:changeState('idle')
    end)
end

function PlayerPotThrowState:update(dt)
    
end

function PlayerPotThrowState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))
end