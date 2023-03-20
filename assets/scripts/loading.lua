--by sloow

local scale = 0.8
local ldim = 'funkay' --put here your image name (the image must have a size of 1675 x 1083)
local loading = false

function onCreate()

    makeLuaSprite('ld', 'funkay', -50, -100) -- creating the image
    setObjectCamera('ld', 'other')
    scaleObject('ld', scale, scale)
    addLuaSprite('ld')
    runTimer('bye', 6)

end

function onStartCountdown() -- cotidoun

    if loading == false then
        return Function_Stop

    elseif loading == true then
        return Function_Continue    
    end

end

function onTimerCompleted(tag, loops, loopsLeft) -- penis

    if tag == 'bye' then
        loading = true
        startCountdown()
        doTweenAlpha('ldt', 'ld', 0, 0.6, 'linear')	
    end

end

function onTweenCompleted(tag) --this is for delete the loading screen
    
    if tag == 'ld' then
        removeLuaSprite('ld')
    end

end