-- Joseph's Cool Script for Row mod
function onSongStart()
    startVideo('shucks-door', false, true, false, false)
    callMethod('videoCutscene.play')
end
function precacheStage() 
precacheImage('bg');
    precacheImage('Imagen');
	precacheImage('Texto');
            precacheImage('red');
end
               
local flashMin = 0.2    -- normal brightness (alpha)
local flashMax = 1     -- how bright it flashes
local flashInTime = 0.3 -- how quickly it brightens
local flashOutTime = 2 -- how slowly it fades back
local normalScale = 1.1   -- base size
local flashScale = 1.2    -- how large it gets at peak

function flashGlow()
    -- Brighten quickly
    doTweenAlpha('glowFlashUp', 'fah', flashMax, flashInTime, 'linear')
    doTweenX('fahScaleUpX', 'fah.scale', flashScale, flashInTime, 'linear')
    doTweenY('fahScaleUpY', 'fah.scale', flashScale, flashInTime, 'linear')
end

function onTweenCompleted(tag)
    if tag == 'glowFlashUp' then
        -- Then fade slowly back to normal
        doTweenAlpha('glowFlashDown', 'fah', flashMin, flashOutTime, 'quadOut')
    elseif tag == 'fahScaleUpX' then
        -- Return scale smoothly
        doTweenX('fahScaleDownX', 'fah.scale', normalScale, flashOutTime, 'quadOut')
    elseif tag == 'fahScaleUpY' then
        doTweenY('fahScaleDownY', 'fah.scale', normalScale, flashOutTime, 'quadOut')
    end
end

function onCreate()
    setProperty('gf.alpha', 1)
         setScrollFactor('gfGroup', 1, 1)
    makeLuaSprite('blackScreenn', 'nil', 0, 0)
    setObjectCamera('blackScreenn', 'camOther')
  setObjectOrder('blackScreenn', 1);
  makeGraphic('blackScreenn', screenWidth, screenHeight, '000000')
  addLuaSprite('blackScreenn', true)
  setProperty('blackScreenn.alpha', 1)

    setProperty('skipCountdown', true)
    


    makeLuaSprite('bg', 'Sawbg', 290, 50); -- Rowan make sure you change the path to the image
    setLuaSpriteScrollFactor('bg', 1, 1);
	scaleObject('bg', 0.18, 0.18);
	setObjectCamera('bg', 'camHUD');
	setProperty('bg.alpha', 0);

    makeLuaSprite('Imagen', 'title', 350, 125); -- Rowan make sure you change the path to the image
    setLuaSpriteScrollFactor('Imagen', 1, 1);
	scaleObject('Imagen', 0.5, 0.5);
	setObjectCamera('Imagen', 'camHUD');
	setProperty('Imagen.alpha', 0);

	makeLuaSprite('Texto', 'title name', 500, 375); -- 
	setLuaSpriteScrollFactor('Texto', 1, 1);
	scaleObject('Texto', 0.5, 0.5);
	setObjectCamera('Texto', 'camHUD');
	setProperty('Texto.alpha', 0);

    makeLuaSprite('red', 'RedVG', 0, 0); -- Rowan make sure you change the path to the image
    setLuaSpriteScrollFactor('red', 1, 1);
	scaleObject('red', 1, 1);
	setObjectCamera('red', 'camOther');
	setProperty('red.alpha', 0);

    addLuaSprite('bg', false);    
    addLuaSprite('Imagen', false);
    addLuaSprite('Texto', false);
    addLuaSprite('red', false); 
    
    
end
local flickerCount = 5     -- number of flickers
local flickerTime = 0.1    -- duration of each flicker up/down
local alphaMin = 0          -- final alpha after fade
local alphaMax = 1          -- starting flicker brightness

function fadingFlicker(object)
    for i = 1, flickerCount do
        local peak = alphaMax * ((flickerCount - i + 1)/flickerCount) -- decreasing peaks
        local tweenUp = object.."_flickerUp"..i
        local tweenDown = object.."_flickerDown"..i
        
        -- Tween up
        doTweenAlpha(tweenUp, object, peak, flickerTime, "linear")
        -- Tween down after flickerTime
        runTimer(tweenDown, flickerTime*i)
    end
    -- Final fade out
    runTimer("finalFade", flickerCount*flickerTime)
end

function onTimerCompleted(tag)
    if string.find(tag, "_flickerDown") then
        local object = string.gsub(tag, "_flickerDown%d+", "")
        local i = tonumber(string.match(tag, "%d+"))
        local peak = (flickerCount - i)/flickerCount
        doTweenAlpha(tag, object, peak, flickerTime, "linear")
    elseif tag == "finalFade" then
        doTweenAlpha("blackFadeOut", "blackScreenn", 0, flickerTime*2, "linear")
    end
end
function onStepHit()
        if curStep == 32 then
            setObjectCamera('blackScreenn', 'camGame');
            setObjectOrder('blackScreenn', 18);
            scaleObject('blackScreenn', screenWidth, screenHeight);
            setProperty('blackScreenn.x',-600)
            setProperty('blackScreenn.y', -400)
            setObjectOrder('boyfriendGroup', 19)
            setObjectOrder('dadGroup',19)
            

        end
        if curStep == 471 then
            setObjectOrder('boyfriendGroup', 11)
            setObjectOrder('dadGroup',11)
            fadingFlicker("blackScreenn")
        end
        if curStep == 814 then -- 
                doTweenAlpha('saw', 'bg', 1, 0.50);
		doTweenAlpha('Portada', 'Imagen', 1, 0.50);
		doTweenAlpha('Titulo', 'Texto', 1, 0.50);
        flashGlow()
        doTweenX('sprite3ScaleX', 'sprite3.scale', 2.4, 0.3, 'quadOut')
        doTweenY('sprite3ScaleY', 'sprite3.scale', 2.4, 0.3, 'quadOut')
	end

    if curStep == 846 then
                doTweenAlpha('saw', 'bg', 0, 0.50);
		doTweenAlpha('Portada', 'Imagen', 0, 0.50);
		doTweenAlpha('Titulo', 'Texto', 0, 0.50);
	end
    if curStep == 1326 then
         flashGlow()
    end
    if curStep == 1582 then
        flashGlow()
   end
   if curStep == 2094 then
    flashGlow()
end
if curStep == 2223 then
    flashGlow()
end
if curStep == 2478 then
    flashGlow()
end
   if curStep == 2815 then
    setProperty('dad.idleSuffix', '-NOIDLE');
end
if curStep == 3010 then
    playAnimReverse('dad', 'over', 0.04)
end
   if curStep == 3022 then
    flashGlow()
end
    if curStep == 3269 then -- 
                doTweenAlpha('red', 'red', 1, 0.10);
                flashGlow()
    end 
    if curStep == 3537 then
        setProperty('cameraSpeed', 999999999)
        setProperty('isCameraOnForcedPos', true)
    setProperty('camFollow.x', 100)
    setProperty('camFollow.y', 380)
    setProperty('defaultCamZoom', .6)
    removeLuaScript('scripts/cameraMovement')
    removeLuaScript('scripts/smoothCam')
end
if curStep == 3569 then
    setProperty('cameraSpeed', 999999999)
    setProperty('isCameraOnForcedPos', true)
setProperty('camFollow.x', 1620)
setProperty('camFollow.y', 800)
setProperty('defaultCamZoom', .7)
end
if curStep == 3598 then
    setProperty('cameraSpeed', 1.3)
    setProperty('isCameraOnForcedPos', false)
    triggerEvent('Camera Follow Pos', '', '') 
setProperty('defaultCamZoom', 0.55)
end
if curStep == 3631 then
    setProperty('cameraSpeed', 1.3)
    setProperty('isCameraOnForcedPos', true)
setProperty('camFollow.x', 400)
setProperty('camFollow.y', 500)
doTweenZoom('zoomTween', 'camGame', 0.8, 0.6, 'quadInOut')
end
    if curStep == 3737 then -- 
                doTweenAlpha('red', 'red', 0, 0.10);
                
        end
    
end