-- Joseph's Cool Script for Row mod

function precacheStage() 
precacheImage('bg');
    precacheImage('Imagen');
	precacheImage('Texto');
            precacheImage('red');
               precacheImage('Bhud');
end
local flashMin = 0    -- normal brightness (alpha)
local flashMax = 1     -- how bright it flashes
local flashInTime = 0.05 -- how quickly it brightens
local flashOutTime = 2 -- how slowly it fades back

function onTweenCompleted(tag)
    if tag == 'glowFlashUp' then
        -- Then fade slowly back to normal
        doTweenAlpha('glowFlashDown', 'flash', flashMin, flashOutTime, 'quadOut')
    end
end
function onCreate()
    makeLuaSprite('flash', 'flash', -1945, -878)
    setLuaSpriteScrollFactor('flash', 1, 1)
    setProperty('flash.alpha', 0)
    addLuaSprite('flash')

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

	makeLuaSprite('Texto', 'title name', 500, 375); -- same here faggot, KILL YOURSELFR #LFFL F RLF L
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
        if curStep == 768 then -- also step nigger, FUCK YOU
                doTweenAlpha('saw', 'bg', 1, 0.50);
		doTweenAlpha('Portada', 'Imagen', 1, 0.50);
		doTweenAlpha('Titulo', 'Texto', 1, 0.50);
        doTweenAlpha('flash', 'flash', 1, 0.05, 'linear')

	end

    if curStep == 811 then
                doTweenAlpha('saw', 'bg', 0, 0.50);
		doTweenAlpha('Portada', 'Imagen', 0, 0.50);
		doTweenAlpha('Titulo', 'Texto', 0, 0.50);
	end
    if curStep == 2815 then -- also step nigger, FUCK YOU
                doTweenAlpha('red', 'red', 1, 0.10);
                doTweenAlpha('hud', 'Bhud', 0.8, .50);
        end
    if curStep == 3196 then -- also step nigger, FUCK YOU
                doTweenAlpha('red', 'red', 0, 0.10);
                doTweenAlpha('hud', 'Bhud', 0, 0.10);
        end
    
end