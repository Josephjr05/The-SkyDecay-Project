function onCreate()
    makeLuaSprite('thing')
    makeGraphic('thing', 1280, 720, '000000')
    setObjectCamera('thing', 'camOther')
    addLuaSprite('thing', true)
end

function onEvent(eventName, value1, value2)
    if eventName == 'Black Camera Fades' then
        doTweenAlpha('alphalol', 'thing', tonumber(value1), tonumber(value2), 'sineInOut')
    end
end