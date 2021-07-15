PowerUp = Class{}

function PowerUp:init(p,x, y)
    self.dy = 40
    self.x = x
    self.y = y
    self.width = 16
    self.height = 16
    self.power = p
    self.isfalling = true
end

function PowerUp:update(dt)
    if self.y < VIRTUAL_HEIGHT then
        self.y = self.y + self.dy * dt
        self.x=self.x
    else
        self.isfalling=false
    end
end

function PowerUp:collides(target)
    
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other

    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    self.isfalling=false
    return true
end

function PowerUp:render()
    if self.isfalling then
        if self.power == nil then
            self.power = 3
        end
        love.graphics.draw(gTextures['main'],gFrames['powerups'][self.power],self.x , self.y)
    end
end
