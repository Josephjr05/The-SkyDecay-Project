
  

function onCreate()
     makeAnimatedLuaSprite('Snow-Storm', 'Snow-Storm', -300, -100);
      addAnimationByPrefix('Snow-Storm', 'tormenta', 'tormenta', 24, true);
	setScrollFactor('Snow-Storm', 0, 0);

    makeLuaSprite('BOverlay', 'Black-Overlay', 0, 0); -- Rowan make sure you change the path to the image
    setLuaSpriteScrollFactor('BOverlay', 1, 1);
	scaleObject('BOverlay', 1, 1);
	setObjectCamera('BOverlay', 'camOther');
	setProperty('BOverlay.alpha', 0);
    screenCenter('BOverlay', 'x', 'y')

	addLuaSprite('Snow-Storm', true);
    addLuaSprite('BOverlay', true);
 
    
end
    function onStartCountdown()
    triggerEvent('Play Animation', 'paps', 'GF')
end
    function onStepHit()
        if curStep == 1028 then
            doTweenAlpha('BOverlay', 'BOverlay', 0.7, 1);

        end
    end