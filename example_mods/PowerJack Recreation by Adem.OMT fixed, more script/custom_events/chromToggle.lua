local chromFreq = 2
local chromAmount = 0.65
local enabled = false
local activated = false
function onCreatePost()
    initLuaShader('ChromaticAbberation')

    makeLuaSprite('chromGraphic')
    makeGraphic("chromShader", screenWidth, screenHeight)

    makeLuaSprite('chromX',nil,0,0)
end
function onUpdate()
    if enabled then
        setShaderFloat('chromGraphic', "amount", getProperty('chromX.x'))
        if not activated and chromAmount == 0 and getProperty('chromX.x') <= 0 then
            removeSpriteShader('chromGraphic')
            enabled = false
        end
    end
end
function onBeatHit()
    if activated and curBeat % chromFreq == 0 then
        setProperty('chromX.x',chromAmount)
        doTweenX('chromLol','chromX',0,0.45,'linear')
    end
end
function chromToggle(ye)
    if ye then
        if not activated then
            setSpriteShader("chromShader", 'chromGraphic')
            runHaxeCode(
                [[
                    var chromToggle = game.createRuntimeShader('ChromaticAbberation');

                    game.camGame.setFilters([new ShaderFilter(chromToggle)]);
                    game.getLuaObject('chromGraphic').shader = chromToggle;


                    return;
                ]]
            )
            activated = true
            enabled = true
        end
    else
        if activated then
            doTweenX('chromLol','chromX',0,0.45,'linear')
            activated = false
        end
    end
end
function onEvent(name,v1,v2)
    if name == 'chromToggle' then
        if v1 ~= ''  then
            chromAmount = tonumber(v1)
            chromFreq = tonumber(v2)
        end
        if value2 ~= '' then
            chromFreq = tonumber(v2)
        end
        if chromAmount ~= 0 and chromAmount ~= nil and chromFreq ~= nil and chromFreq ~= 0 then
            chromToggle(true)
            setProperty('chromX.x',chromAmount)
            doTweenX('chromLol','chromX',0,0.45,'linear')
        else
            chromToggle(false)
        end
    end
function onStepHit()
if curStep == 822 then
removeSpriteShader('chromGraphic')
end

end

local temp = onDestroy
    function onDestroy()
        runHaxeCode([[
            FlxG.signals.gameResized.remove(fixShaderCoordFix);
        ]])
        temp()
    end

end