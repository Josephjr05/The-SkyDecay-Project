-- Joseph's Cool Script for Row mod

function precacheStage() 
precacheImage('bg');
    precacheImage('Imagen');
	precacheImage('Texto');
            precacheImage('red');
               precacheImage('Bhud');
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

    makeLuaSprite('shud', 'bloody hud', 0, 0); -- Rowan make sure you change the path to the image
    setLuaSpriteScrollFactor('Bhud', 1, 1);
	scaleObject('Bhud', 0.7, 0.7);
	setObjectCamera('Bhud', 'camOther');
	setProperty('Bhud.alpha', 0);
        screenCenter('Bhud', 'x', 'y')

    addLuaSprite('bg', false);    
    addLuaSprite('Imagen', false);
    addLuaSprite('Texto', false);
    addLuaSprite('red', false); 
    addLuaSprite('Bhud', false);
    
end

function onStepHit()
        if curStep == 768 then -- 
                doTweenAlpha('saw', 'bg', 1, 0.50);
		doTweenAlpha('Portada', 'Imagen', 1, 0.50);
		doTweenAlpha('Titulo', 'Texto', 1, 0.50);
        flashGlow()

	end

    if curStep == 811 then
                doTweenAlpha('saw', 'bg', 0, 0.50);
		doTweenAlpha('Portada', 'Imagen', 0, 0.50);
		doTweenAlpha('Titulo', 'Texto', 0, 0.50);
	end
    if curStep == 1280 then
         flashGlow()
    end
    if curStep == 1552 then
        flashGlow()
   end
   if curStep == 2352 then
    setProperty('dad.idleSuffix', '-NOIDLE');
end
if curStep == 2552 then
    playAnimReverse('dad', 'over', 0.04)
end
   if curStep == 2560 then
    flashGlow()
end
    if curStep == 2815 then -- 
                doTweenAlpha('red', 'red', 1, 0.10);
                doTweenAlpha('hud', 'Bhud', 0.8, .50);
        end
    if curStep == 3196 then -- 
                doTweenAlpha('red', 'red', 0, 0.10);
                doTweenAlpha('hud', 'Bhud', 0, 0.10);
        end
    
end