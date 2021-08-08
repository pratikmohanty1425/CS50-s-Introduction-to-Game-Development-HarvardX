--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Entity = Class{}

function Entity:init(def)

    -- in top-down games, there are four directions instead of two
    self.direction = 'down'

    self.animations = self:createAnimations(def.animations)

    -- dimensions
    self.x = def.x
    self.y = def.y
    self.width = def.width
    self.height = def.height

    -- drawing offsets for padded sprites
    self.offsetX = def.offsetX or 0
    self.offsetY = def.offsetY or 0

    self.walkSpeed = def.walkSpeed

    self.health = def.health

    -- flags for flashing the entity when hit
    self.invulnerable = false
    self.invulnerableDuration = 0
    self.invulnerableTimer = 0
    self.flashTimer = 0
    --self.heal = math.random(2)
    self.dead = false
    --self.carrying = false
end

function Entity:createAnimations(animations)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture or 'entities',
            frames = animationDef.frames,
            interval = animationDef.interval
        }
    end

    return animationsReturned
end

--[[
    AABB with some slight shrinkage of the box on the top side for perspective.
]]
function Entity:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function Entity:damage(dmg)
    self.health = self.health - dmg
end

function Entity:goInvulnerable(duration)
    self.invulnerable = true
    self.invulnerableDuration = duration
end

function Entity:changeState(name, params)
    self.stateMachine:change(name, params)
end

function Entity:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

function Entity:update(dt)
    if self.invulnerable then
        self.flashTimer = self.flashTimer + dt
        self.invulnerableTimer = self.invulnerableTimer + dt

        if self.invulnerableTimer > self.invulnerableDuration then
            self.invulnerable = false
            self.invulnerableTimer = 0
            self.invulnerableDuration = 0
            self.flashTimer = 0
        end
    end

    self.stateMachine:update(dt)

    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end
end

function Entity:processAI(params, dt)
    self.stateMachine:processAI(params, dt)
end

function Entity:render(adjacentOffsetX, adjacentOffsetY)
    -- draw sprite slightly transparent if invulnerable every 0.04 seconds
    if self.invulnerable and self.flashTimer > 0.06 then
        self.flashTimer = 0
        love.graphics.setColor(255/255, 255/255, 255/255, 64/255)
    end

    self.x, self.y = self.x + (adjacentOffsetX or 0), self.y + (adjacentOffsetY or 0)
    self.stateMachine:render()
    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
    self.x, self.y = self.x - (adjacentOffsetX or 0), self.y - (adjacentOffsetY or 0)
end

-- update 2
function Entity:collideWithSolid(object)
    local eY, eH
    local collides = false

    if self.type == 'player' then
        eY, eH = self.y + self.height / 2, self.height - self.height / 2
    else
        eY, eH = self.y,self.height
    end

    local entityCenterX = self.x + self.width / 2
    local entityCenterY = self.y + self.height / 2
    local objectCenterX = object.x + object.width / 2
    local objectCenterY = object.y + object.height / 2

    if self.direction == 'left' and entityCenterX > objectCenterX and (eY - object.height < object.y and object.y < eY + eH) then 
        if self.x <= object.x + object.width then
            self.x = object.x + object.width
            collides = true
        end
    elseif self.direction == 'right' and entityCenterX < objectCenterX and (eY - object.height < object.y and object.y < eY + eH) then 
        if self.x + self.width >= object.x then
            self.x = object.x - self.width
            collides = true
        end
    elseif self.direction == 'up' and entityCenterY < objectCenterY and (self.x - self.width < object.x and object.x < self.x + self.width) then 
        if self.y <= object.y + object.height - self.height / 2 then
            self.y = object.y + object.height - self.height / 2
            collides = true
        end
    elseif self.direction == 'down' and entityCenterY < objectCenterY and (self.x - self.width < object.x and object.x < self.x + self.width) then 
        if self.y + self.height >= object.y then
            self.y = object.y - self.height
            collides = true
        end
    end

    return collides
end