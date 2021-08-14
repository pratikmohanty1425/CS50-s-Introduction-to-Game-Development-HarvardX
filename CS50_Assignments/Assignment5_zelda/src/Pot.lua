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
    self.solid = true
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
    --update 3
    local collideWithWall = false 
    if self.state == 'flying' then
        if self.direction == 'left' then
            self.x = self.x - self.moveSpeed * dt 

            if self.x <= MAP_RENDER_OFFSET_X + TILE_SIZE then
                self.x = MAP_RENDER_OFFSET_X + TILE_SIZE
                collideWithWall = true
            end
        elseif self.direction == 'right' then
            self.x = self.x + self.moveSpeed * dt 

            if self.x + self.width >= VIRTUAL_WIDTH - TILE_SIZE * 2 then
                self.x = VIRTUAL_WIDTH - TILE_SIZE * 2 - self.width
                collideWithWall = true
            end
        elseif self.direction == 'up' then
            self.y = self.y - self.moveSpeed * dt 

            if self.y <= MAP_RENDER_OFFSET_Y + TILE_SIZE - self.height / 2 then
                self.y = MAP_RENDER_OFFSET_Y + TILE_SIZE - self.height / 2
                collideWithWall = true
            end
        elseif self.direction == 'down' then
            self.y = self.y + self.moveSpeed * dt 

            local bottomEdge = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE)
                + MAP_RENDER_OFFSET_Y - TILE_SIZE

            if self.y + self.height >= bottomEdge then
                self.y = bottomEdge - self.height
                collideWithWall = true
            end
        end

        self.distanceTraveled = self.distanceTraveled + self.moveSpeed * dt 
        if self.distanceTraveled >= TILE_SIZE * 4 or collideWithWall then
            self:initDestroy()
        end
    end

    if self.state == 'broken' then
        self.flashTimer = self.flashTimer + dt 
        self.flashDuration = self.flashDuration + dt 

        if self.flashDuration >= 1 then
            self.toRemove = true
        end
    end
end

function Pot:render(adjacentOffsetX, adjacentOffsetY)
    if self.state == 'broken' and self.flashTimer > 0.06 then
        self.flashTimer = 0
        love.graphics.setColor(1, 1, 1, 64/255)
    end
    
    GameObject.render(self, adjacentOffsetX, adjacentOffsetY)

    love.graphics.setColor(1, 1, 1, 1)
end