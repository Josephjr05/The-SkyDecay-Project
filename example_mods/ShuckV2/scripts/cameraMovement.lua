local BfOfs = 50
local GfOfs = 50
local DadOfs = 50

local BfOfsX = 0
local BfOfsY = 0

local GfOfsX = 0
local GfOfsY = 0

local targetX = 0
local targetY = 0

local targetXMove = 0
local targetYMove = 0
local DadOfsX = 0
local DadOfsY = 0

local enableSystem = true

local currentTarget = ''
local currentSection = nil
local firstSection = false

--[[
    If you want to know the credits:
        i got a ideia of the Washo789's script, 
        the script is made by BF Myt.
]]--
function onCreatePost()
    setProperty('camFollowPos.x',getProperty('dadGroup.x') + (getProperty('boyfriendGroup.x') - getProperty('dadGroup.x')))
    setProperty('camFollowPos.y',getProperty('dadGroup.y'))
    if songName == 'Phantasm' then
        BfOfsX = 100
    elseif songName == 'Leak ma Balls' then
        enableSystem = false
    end
end
function onBeatHit()
    if curBeat % 4 == 0 and currentSection == nil then
        currentSection = ''
    end
end
function onUpdate()
    if enableSystem == true and getProperty('isCameraOnForcedPos') == false then
        if currentSection ~= nil then
            if gfSection ~= true then
                if mustHitSection == false  then
                    if currentSection ~= 'dad' then
                        currentTarget = 'dad'
                        currentSection = 'dad'
                    end
                else
                    if currentSection ~= 'boyfriend' then
                        currentTarget = 'boyfriend'
                        currentSection = 'boyfriend'
                    end
                end
            else
                if currentSection ~= 'gf' then
                    currentTarget = 'gf'
                    currentSection = 'gf'
                end
            end
        end
        targetXMove = 0
        targetYMove = 0
        if currentTarget == 'boyfriend' then
            local bfAnim = getProperty('boyfriend.animation.curAnim.name')
            targetX = getMidpointX('boyfriend') - 50 - getProperty('boyfriend.cameraPosition[0]') + getProperty('boyfriendCameraOffset[0]') + BfOfsX
            targetY = getMidpointY('boyfriend') - 100 + getProperty('boyfriend.cameraPosition[1]') + getProperty('boyfriendCameraOffset[1]') + BfOfsY
    
            if string.find(bfAnim,'singLEFT',0,true) ~= nil then
                targetXMove = -BfOfs
    
            elseif string.find(bfAnim,'singDOWN',0,true) ~= nil then
                targetYMove = BfOfs
    
            elseif string.find(bfAnim,'singRIGHT',0,true) ~= nil then
                targetXMove = BfOfs
    
            elseif string.find(bfAnim,'singUP',0,true) ~= nil then
                 targetYMove = -BfOfs
            end
    
        elseif currentTarget == 'dad' then
            local dadAnim = getProperty('dad.animation.curAnim.name')
            targetX = getMidpointX('dad') + 150 + getProperty('dad.cameraPosition[0]') + getProperty('opponentCameraOffset[0]') + DadOfsX
            targetY = getMidpointY('dad') - 100 + getProperty('dad.cameraPosition[1]') + getProperty('opponentCameraOffset[1]') + DadOfsY
    
            if string.find(dadAnim,'singLEFT',0,true) ~= nil then
                targetXMove = -DadOfs
    
            elseif string.find(dadAnim,'singDOWN',0,true) ~= nil then
                targetYMove = DadOfs
    
            elseif string.find(dadAnim,'singUP',0,true) ~= nil then
                targetYMove = -DadOfs
    
            elseif string.find(dadAnim,'singRIGHT',0,true) ~= nil then
                targetXMove = DadOfs
            end
        elseif currentTarget == 'gf' then
            local gfAnim = getProperty('gf.animation.curAnim.name')
            targetX = getMidpointX('gf') + getProperty('gf.cameraPosition[0]') + getProperty('girlfriendCameraOffset[0]') + GfOfsX
            targetY = getMidpointY('gf') + getProperty('gf.cameraPosition[1]') + getProperty('girlfriendCameraOffset[1]') + GfOfsY
            if string.find(gfAnim,'singLEFT',0,true) ~= nil then
                targetXMove = -GfOfs
    
            elseif string.find(gfAnim,'singDOWN',0,true) ~= nil then
                targetYMove = GfOfs
    
            elseif string.find(gfAnim,'singUP',0,true) ~= nil then
                targetYMove = -GfOfs
    
            elseif string.find(gfAnim,'singRIGHT',0,true) ~= nil then
                targetXMove = GfOfs
            end
        end
        setProperty('camFollow.x',targetX+targetXMove)
        setProperty('camFollow.y',targetY+targetYMove)
    end
end
function onMoveCamera(focus)
    if firstSection == false and enableSystem then
        currentTarget = focus
        firstSection = true
    end
end