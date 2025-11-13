-- Sway animation for the light object
local swayTime = 0
local swaySpeed = 2.0  -- Speed of the sway (higher = faster)
local swayAmount = 8   -- Maximum angle in degrees (how far it sways)

function onCreatePost()
    -- Set the origin to the top center so it rotates from the top
    local lightWidth = getProperty('light.width')
    setProperty('light.origin.x', lightWidth / 2)  -- Center horizontally
    setProperty('light.origin.y', 0)  -- Top of the sprite
    local glowWidth = getProperty('glow.width')
    setProperty('glow.origin.x', glowWidth / 2)
    setProperty('glow.origin.y', 0) 
    local fahWidth = getProperty('fah.width')
    setProperty('fah.origin.x', fahWidth / 2)
    setProperty('fah.origin.y', 0) 

end
function onSectionHit()
    local isLeft = false
    local isRight = false
    -- 'mustHitSection' is true when it's BF's turn, false when it's Dad's turn
    if mustHitSection and curSection < 144 or curSection > 175 and isRight then
        -- BF's turn → change GF animation
        characterPlayAnim('gf', 'idle-right')
        isRight = true
        isLeft = false
    elseif not mustHitSection and curSection < 144 or curSection > 175 and isLeft then 
        -- Dad's turn → change GF animation
        characterPlayAnim('gf', 'idle-left')
        isLeft = true
        isRight = false
    end
end
function onUpdate(elapsed)
    -- Increment time for smooth animation
    swayTime = swayTime + elapsed * swaySpeed
    
    -- Calculate sway angle using sine wave for smooth pendulum motion (inverted)
    local swayAngle = -math.sin(swayTime) * swayAmount
    
    -- Apply the angle to the light object
    setProperty('light.angle', swayAngle)
    setProperty('glow.angle', swayAngle)
    setProperty('fah.angle', swayAngle)
end

