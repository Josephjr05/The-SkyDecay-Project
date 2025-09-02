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

    makeAnimatedLuaSprite('transition', 'transition', -300, -100);
    addAnimationByPrefix('transition', 'trans', 'idle', 24, true);
    setProperty('transition.alpha', 0, 0)
	setScrollFactor('transition', 0, 0);  

    makeLuaSprite('BOverlay', 'Black-Overlay', 0, 0); -- Rowan make sure you change the path to the image
    setLuaSpriteScrollFactor('BOverlay', 1, 1);
	scaleObject('BOverlay', 1, 1);
	setObjectCamera('BOverlay', 'camOther');
	setProperty('BOverlay.alpha', 0);
    screenCenter('BOverlay', 'x', 'y')

    makeLuaSprite('BgD', 'BG-Dark2', 449, -164); -- Rowan make sure you change the path to the image
    setLuaSpriteScrollFactor('BgD', 1, 1);
	scaleObject('BgD', 0.95, 0.95);
	setProperty('BgD.alpha', 0);

    makeLuaSprite('BgL', 'BG-Dark', 449, -164); -- Rowan make sure you change the path to the image
    setLuaSpriteScrollFactor('BgL', 1, 1);
	scaleObject('BgL', 0.95, 0.95);
	setProperty('BgL.alpha', 0);

    
	addLuaSprite('arboles',false)
    addLuaSprite('fondo',false)
    addLuaSprite('BgL',false)
    addLuaSprite('BgD',false)
    addLuaSprite('Snow-Storm', true);
    addLuaSprite('BOverlay', true);
    addLuaSprite('transition', true);
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
        if curStep == 1276 then
            setProperty('transition.alpha', 1);
            objectPlayAnimation('transition', 'trans', true)
    end
        if curStep == 1284 then
            setProperty('transition.alpha', 0)
            setProperty('Snow-Storm.alpha', 0)
            removeLuaSprite('BOverlay', true)
            setProperty('arboles.alpha', 0)
            setProperty('fondo.alpha', 0)
            setProperty('BgL.alpha', 1)
            setProperty('BgD.alpha', 1)
            setCamOffset(200, -300, false)
            setCamOffset(-190, -100, true)

             
    end
    if curStep == 1408 then
        doTweenAlpha('BgD','BgD', 0, 0.3)
    end  
    if curStep == 1534 then
        setProperty('transition.alpha', 1)
        objectPlayAnimation('transition', 'trans', true)
    end
    if curStep == 1542 then
        removeLuaSprite('transition', true)
        removeLuaSprite('BgL', true)
        setProperty('Snow-Storm.alpha', 1)
        setProperty('arboles.alpha', 1)
        setProperty('fondo.alpha', 1)
        setCamOffset(250, -300, false)
            setCamOffset(-300, -150, true)    
    end     
end    
    function setCamOffset(x, y, isPlayer)
    -- isPlayer: true = boyfriend (player), false = dad (opponent)
    if isPlayer then
        setProperty('boyfriendCameraOffset[0]', x)
        setProperty('boyfriendCameraOffset[1]', y)
    else
        setProperty('opponentCameraOffset[0]', x)
        setProperty('opponentCameraOffset[1]', y)
    end
end