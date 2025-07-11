local beattime = getPropertyFromClass('backend.Conductor', 'crochet') 
local shadergo = false
function onCreate()
    precacheImage("TrashAlley/M4N4G3R5/wall-KillerBot")
    precacheImage("TrashAlley/M4N4G3R5/wall-Red")
    precacheImage("TrashAlley/M4N4G3R5/wall-Blue")
    precacheImage("TrashAlley/M4N4G3R5/tvFront-Killer")
    precacheImage("TrashAlley/M4N4G3R5/tvFront-Red")
    precacheImage("TrashAlley/M4N4G3R5/tvFront-Blue")


    makeAnimatedLuaSprite('tvStaticLeft', 'trashAlley/K1LL3R/tv_static_assets', 0, 300)
    addLuaSprite('tvStaticLeft', false)
    addAnimationByIndices('tvStaticLeft', 'static', 'static anim', '0, 2', 24, true)
    setProperty('tvStaticLeft.visible', true)
    scaleObject('tvStaticLeft', 1, 1)

    makeAnimatedLuaSprite('tvStaticRight', 'trashAlley/K1LL3R/tv_static_assets', 1400, 400)
    addLuaSprite('tvStaticRight', false)
    addAnimationByIndices('tvStaticRight', 'static', 'static anim', '1, 3', 24, true)
    setProperty('tvStaticRight.visible', true)
    scaleObject('tvStaticRight', 1, 1)

    makeLuaSprite('warningScreen', 'trashAlley/K1LL3R/screen_danger', 100, 440)
    addLuaSprite('warningScreen', false)
    setProperty('warningScreen.alpha', 0)
    setProperty('warningScreen.angle', 0.5)

    makeLuaSprite('blueScreen', 'trashAlley/BLU3/blue_screens', 100, 450)
    addLuaSprite('blueScreen', false)
    setProperty('blueScreen.alpha', 0)

    makeAnimatedLuaSprite('lightOverlay', 'trashAlley/M4N4G3R5/gradientManager', 0, 0)
    addLuaSprite('lightOverlay', true)
    addAnimationByPrefix('lightOverlay', 'Killer', 'overlay-Killer', 1, true)
    addAnimationByPrefix('lightOverlay', 'Blue', 'overlay--Blue', 1, true)
    addAnimationByPrefix('lightOverlay', 'Red', 'overlay-Red', 1, true)
    addAnimationByPrefix('lightOverlay', 'Normal', 'overlay-Normal', 1, true)
    setObjectCamera("lightOverlay", 'hud')
    setProperty('lightOverlay.alpha', 1)
    setBlendMode('lightOverlay', 'add');
    scaleObject('lightOverlay', 1, 1)

    playAnim("lightOverlay", "Killer", true)

    makeAnimatedLuaSprite('tvLights', 'trashAlley/K1LL3R/tv_lights_assets', -70, 50)
    addLuaSprite('tvLights', true)
    addAnimationByPrefix('tvLights', 'Killer', 'tv lights animated', 24, true)
    addAnimationByPrefix('tvLights', 'Blue', 'blue', 24, true)
    addAnimationByPrefix('tvLights', 'Red', 'red', 24, true)
    addAnimationByPrefix('tvLights', 'Normal', 'tv lights animated', 24, true)
    setProperty('tvLights.alpha', 1)
    setBlendMode('tvLights', 'add');
    -- scaleObject('tvLights', 2, 2, false)

    makeLuaSprite('wall-KillerBot', 'TrashAlley/M4N4G3R5/wall-KillerBot', -500, -200)
    addLuaSprite('wall-KillerBot', false)

    makeLuaSprite('wall-Red', 'TrashAlley/M4N4G3R5/wall-Red', -500, -200)
    addLuaSprite('wall-Red', false)

    makeLuaSprite('wall-Blue', 'TrashAlley/M4N4G3R5/wall-Blue', -500, -200)
    addLuaSprite('wall-Blue', false)

    makeAnimatedLuaSprite('gfspeaker', 'characters/speaker_assets', 600, 300)
    addAnimationByPrefix('gfspeaker', 'bumpBox', 'bumpBox', 24, false)
    addLuaSprite('gfspeaker', false)

    makeLuaSprite('tvFront-Killer', 'TrashAlley/M4N4G3R5/tvFront-Killer', -150, 650)
    addLuaSprite('tvFront-Killer', true)

    makeLuaSprite('tvFront-Red', 'TrashAlley/M4N4G3R5/tvFront-Red', -150, 650)
    addLuaSprite('tvFront-Red', true)

    makeLuaSprite('tvFront-Blue', 'TrashAlley/M4N4G3R5/tvFront-Blue', -150, 650)
    addLuaSprite('tvFront-Blue', true)

    setProperty("boyfriend.visible", false)
    setProperty("wall-Red.visible", false)
    setProperty("wall-Blue.visible", false)
    setProperty("tvFront-Blue.visible", false)
    setProperty("tvFront-Red.visible", false)
    setProperty("wall-KillerBot.visible", true)
end

function onSongStart()
    setProperty("boyfriend.visible", false)
end

function onCreatePost()
    setSpriteShader('boyfriend', 'adjustColor')
    setSpriteShader('dad', 'adjustColor')
    setSpriteShader('gf', 'adjustColor')
    setSpriteShader('gfspeaker', 'adjustColor')

    setShaderFloat('boyfriend', 'hue',  -17)
    setShaderFloat('boyfriend', 'saturation', -10)
    setShaderFloat('boyfriend', 'contrast', 0)
    setShaderFloat('boyfriend', 'brightness', -15)

    setShaderFloat('dad', 'hue',  -20)
    setShaderFloat('dad', 'saturation', -30)
    setShaderFloat('dad', 'contrast', 20)
    setShaderFloat('dad', 'brightness', -20)

    setShaderFloat('gf', 'hue', -15)
    setShaderFloat('gf', 'saturation', -30)
    setShaderFloat('gf', 'contrast', 0)
    setShaderFloat('gf', 'brightness',-10)

    setShaderFloat('gfspeaker', 'hue', -15)
    setShaderFloat('gfspeaker', 'saturation', -30)
    setShaderFloat('gfspeaker', 'contrast', 0)
    setShaderFloat('gfspeaker', 'brightness',-10)
end
function onBeatHit()
    playAnim("gfspeaker", "bumpBox", true)
end