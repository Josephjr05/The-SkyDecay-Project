function onCreate()
    makeLuaSprite('arboles', 'arboles', 215,-362)
    setLuaSpriteScrollFactor('arboles', 1, 1)
    scaleObject('arboles', 1.06, 1.15)

    makeLuaSprite('fondo', 'fondo', 377, 449)
    setLuaSpriteScrollFactor('fondo', 1, 1)
    scaleObject('fondo', 1, 0.95)

    makeAnimatedLuaSprite('Snow-Storm', 'Snow-Storm', -300, -100);
    addAnimationByPrefix('Snow-Storm', 'tormenta', 'tormenta', 24, true);
	setScrollFactor('Snow-Storm', 0, 0);

    makeLuaSprite('BOverlay', 'Black-Overlay', 0, 0); -- Rowan make sure you change the path to the image
    setLuaSpriteScrollFactor('BOverlay', 1, 1);
	scaleObject('BOverlay', 1, 1);
	setObjectCamera('BOverlay', 'camOther');
	setProperty('BOverlay.alpha', 0);
    screenCenter('BOverlay', 'x', 'y')

    
	addLuaSprite('arboles',false)
    addLuaSprite('fondo',false)
    addLuaSprite('Snow-Storm', true);
    addLuaSprite('BOverlay', true);
    setObjectOrder('arboles', 0)
    setObjectOrder('gfGroup',1)
    setObjectOrder('fondo', 2)
    
end
    function onStartCountdown()
    triggerEvent('Play Animation', 'paps', 'GF')
end
    function onStepHit()
        if curStep == 1028 then
            doTweenAlpha('BOverlay', 'BOverlay', 0.7, 1);

        end
    end