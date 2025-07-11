local NOOWARNING = false
local letend = false

function onCreatePost()
    luaDebugMode = true
    makeAnimatedLuaSprite('bfTransform', 'characters/BF/bf_transform', 1065, 345)
    addLuaSprite('bfTransform', false)
    addAnimationByPrefix('bfTransform', 'transition', 'bf transition', 24, false)
    setProperty('bfTransform.visible', true)
    scaleObject('bfTransform', 1, 1)
    setSpriteShader('bfTransform', 'adjustColor')
    setShaderFloat('bfTransform', 'hue', -17)
    setShaderFloat('bfTransform', 'saturation', -10)
    setShaderFloat('bfTransform', 'contrast', 0)
    setShaderFloat('bfTransform', 'brightness', -15)

    makeLuaSprite("omgblack", nil, 0, 0)
    makeGraphic("omgblack", 1280, 720, "0xFF000000")
    setObjectCamera("omgblack", 'hud')
    addLuaSprite("omgblack", false)
    scaleObject('omgblack', 2000, 2000, false)
    setProperty('omgblack.alpha', 0)
    setObjectOrder('omgblack', 0)

    makeLuaSprite("endb", nil, 0, 0)
    makeGraphic("endb", 1280, 720, "0xFF000000")
    setObjectCamera("endb", 'other')
    addLuaSprite("endb", true)
    scaleObject('endb', 2000, 2000, false)
    setProperty('endb.alpha', 0)
    setObjectOrder('endb', 5)

    setProperty('camFollow.x', 1300)
    setProperty('camFollow.y', 500)
    setProperty('isCameraOnForcedPos', true)
    callMethod('camGame.snapToTarget', {''})
    startTween('cameralol', 'camFollow', {
        x = 800,
        y = 300
    }, 5, {
        ease = 'expoInOut'
    })
end

function onCreate()
    doTweenZoom("cam", "camGame", 1.3, 0.01, "linear")
    -- setProperty("cameraSpeed", 100)
    --setProperty('skipCountdown', true)
end

function onSongStart()
    setProperty("cameraSpeed", 0.08)
    doTweenZoom("cam", "camGame", 0.8, 8, "cubeInOut")
end

function onStepHit()
    if curStep == 144 then
        cancelTween('cameralol')
        setProperty('isCameraOnForcedPos', false)
    end
    if NOOWARNING then
        if curStep % 10 == 0 then
            setProperty('tvLights.alpha', 1)
            doTweenAlpha('nomorescreen2', 'tvLights', 0, 0.5)
            doTweenAlpha('nomorescreen', 'warningScreen', 0, 0.5)
            setProperty('warningScreen.alpha', 1)
            --setBlendMode("tvLights", "ADD")
        end
    end
end

function onUpdate()
    --setBlendMode("tvLights", "ADD")
    if getProperty('bfTransform.animation.name') == 'transition' and getProperty('bfTransform.animation.finished') then
        setProperty("boyfriend.visible", true)
        setProperty("bfTransform.visible", false)
    end
end

function onEvent(n, v1, v2)
    if n == '' then
        if v1 == 'me' and v2 == '1' then
            setProperty('camFollow.x', 900)
            setProperty('camFollow.y', 400)
            setProperty('defaultCamZoom', 0.75)
            setProperty('isCameraOnForcedPos', true)
        end
        if v1 == 'me' and v2 == '2' then
            setProperty('defaultCamZoom', 0.8)
            setProperty('isCameraOnForcedPos', false)
        end
        if v1 == 'aaa' and v2 == 'yes' then
            NOOWARNING = true
            playAnim("tvLights", "Red", true)
            setProperty('warningScreen.alpha', 1)
            playAnim("lightOverlay", "Red", true)
            setProperty("wall-Red.visible", true)
            setProperty("tvFront-Red.visible", true)
            setProperty('tvStaticRight.visible', false)
            setProperty('tvStaticLeft.visible', false)
            setProperty("wall-KillerBot.visible", false)

            setShaderFloat('boyfriend', 'hue', -17)
            setShaderFloat('boyfriend', 'saturation', -10)
            setShaderFloat('boyfriend', 'contrast', 20)
            setShaderFloat('boyfriend', 'brightness', -35)
        end
        if v1 == 'aaa' and v2 == 'no' then
            cancelTween('nomorescreen')
            cancelTween('nomorescreen2')
            NOOWARNING = false
            setProperty("tvFront-Red.visible", false)
            setProperty("wall-Red.visible", false)
            setProperty("wall-KillerBot.visible", true)
            playAnim("lightOverlay", "Killer", true)
            setProperty('tvStaticRight.visible', true)
            setProperty('tvStaticLeft.visible', true)
            playAnim("tvLights", "Killer", true)
            setProperty('warningScreen.alpha', 0)
            --setBlendMode("tvLights", "add")
            setProperty('tvLights.alpha', 1)

            setShaderFloat('boyfriend', 'hue', -17)
            setShaderFloat('boyfriend', 'saturation', -10)
            setShaderFloat('boyfriend', 'contrast', 0)
            setShaderFloat('boyfriend', 'brightness', -15)
        end
        if v1 == 'normall' then
            setProperty('blueScreen.alpha', 0)
            setProperty("tvFront-Killer.visible", true)
            playAnim("lightOverlay", "Killer", true)
            playAnim("tvLights", "Killer", true)
            setProperty('tvStaticRight.visible', true)
            setProperty('tvStaticLeft.visible', true)
        end
        if v1 == 'NOERROR' then
            setProperty('isCameraOnForcedPos', false)
            setProperty('blueScreen.alpha', 1)
            setProperty('tvStaticRight.visible', false)
            setProperty('tvStaticLeft.visible', false)
            setProperty('tvFront-Blue.visible', true)
            setProperty("tvFront-Killer.visible", false)
            setProperty("tvFront-Red.visible", false)
            playAnim("lightOverlay", "Blue", true)
            setProperty('wall-Blue.visible', true)
            setProperty("wall-Killer.visible", false)
            setProperty("wall-Red.visible", false)
            playAnim("tvLights", "Blue", true)
            setShaderFloat('boyfriend', 'hue', -20)
            setShaderFloat('boyfriend', 'saturation', -30)
            setShaderFloat('boyfriend', 'contrast', 20)
            setShaderFloat('boyfriend', 'brightness', -20)


        end
        if v1 == 'black' then
            doTweenAlpha('omgblackhud', 'omgblack', 1, 2.5, 'sineOut')
            doTweenAlpha('lightOverlay', 'lightOverlay', 0, 2.5, 'sineOut')
            doTweenAlpha('byeui', 'uiGroup', 0, 2.5, 'sineOut')

            for i = 0, 3 do
                noteTweenAlpha(i + 16, i, 0, 2.5, 'sineOut')
            end
        end
        if v1 == 'video' then
            makeVideoSprite("cutscene", "cutscene", 0.0, 0.0, "camHUD", false)
            scaleObject("cutscene", 1, 1)
            setObjectOrder("cutscene", 1)
        end
        if v1 == 'novideo' then
            setProperty("cutscene.visible", false)
            removeLuaSprite("cutscene", true)
            doTweenAlpha('byeblack', 'omgblack', 0, 2.5, 'sineOut')
            doTweenAlpha('lightOverlay', 'lightOverlay', 1, 2.5, 'sineOut')
            doTweenAlpha('heyu11', 'uiGroup', 1, 2.5, 'sineOut')

            for i = 0, 3 do
                noteTweenAlpha(i + 16, i, 1, 2.5, 'sineOut')
            end
        end
        if v1 == 'hello' and v2 == '1' then
            setProperty('camGame.zoom', 1.4)
            setProperty('defaultCamZoom', 1.4)
            setProperty('isCameraOnForcedPos', true)
            setProperty('camFollow.x', 1250)
            setProperty('camFollow.y', 450)
            callMethod('camGame.snapToTarget', {''})
        end
        if v1 == 'hello' and v2 == '2' then
            setProperty('camGame.zoom', 1.4)
            setProperty('defaultCamZoom', 1.4)
            setProperty('isCameraOnForcedPos', true)
            setProperty('camFollow.x', 550)
            setProperty('camFollow.y', 300)
            callMethod('camGame.snapToTarget', {''})
        end
        if v1 == 'hello' and v2 == 'qt' then
            setProperty('camGame.zoom', 1.4)
            setProperty('defaultCamZoom', 1.4)
            setProperty('isCameraOnForcedPos', true)
            setProperty('camFollow.x', 600)
            setProperty('camFollow.y', 580)
            callMethod('camGame.snapToTarget', {''})
        end
        if v1 == 'hello' and v2 == '3' then
            setProperty('camGame.zoom', 1.4)
            setProperty('defaultCamZoom', 1.4)
            setProperty('isCameraOnForcedPos', true)
            setProperty('camFollow.x', 930)
            setProperty('camFollow.y', 170)
            callMethod('camGame.snapToTarget', {''})
        end
        if v1 == 'hello' and v2 == 'end' then
            setProperty('defaultCamZoom', 0.8)
            setProperty('isCameraOnForcedPos', false)
        end
    end
end

function onEndSong()
    if not letend and not seenCutscene then
        startVideo("credits")
        letend = true
        return Function_Stop
    else
        return Function_Continue
end
end

