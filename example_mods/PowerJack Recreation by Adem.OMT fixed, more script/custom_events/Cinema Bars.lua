local thing = {'Top', 'Bot'}
function onCreate()
    for i = 1, 2 do
        makeLuaSprite('bar' .. thing[i])
        makeGraphic('bar' .. thing[i], screenWidth, screenHeight, '000000')
        addLuaSprite('bar' .. thing[i], false)
        setObjectCamera('bar' .. thing[i], 'hud')
        setProperty('bar' .. thing[i] .. '.antialiasing', false)
        setProperty('bar' .. thing[i] .. '.y', false)
    end
    setProperty('barTop.y', getProperty('barTop.y') - (screenHeight / 1))
end

function onUpdate()
    --debugPrint(getProperty('barTop.y') + screenHeight .. ' ' .. getProperty('barBot.y') - screenHeight)
    setProperty('barBot.y', (getProperty('barTop.y') - (getProperty('barTop.y') * 2)))
    for i = 1, 2 do
        screenCenter('bar' .. thing[i], 'X')
        setProperty('bar' .. thing[i] .. '.width', screenWidth)
        setProperty('bar' .. thing[i] .. '.height', screenHeight)
    end
end

function onEvent(name, value1, value2)
    if name == 'Cinema Bars' then
        Ylevel = tonumber(value1)
        if Ylevel == nil then
            Ylevel = 150
        elseif Ylevel < 0 then
            Ylevel = 0
        elseif Ylevel > 360 then
            Ylevel = 360
        end

        tween = tostring(value2)
        if tween == '' then
            tween = 'sineOut'
        end

        doTweenY('moveBar', 'barTop', Ylevel - screenHeight, 1, tween)
    end
end