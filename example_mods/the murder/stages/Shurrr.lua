function onCreatePost()
    setObjectOrder('shur', getObjectOrder('boyfriendGroup') - 1);
end

function onCreate()
    makeAnimatedLuaSprite('shur', 'shur-text', -386, -133);
    addAnimationByPrefix('shur', 'pop', 'shur-text idle', 1, true);
    setProperty('shur.alpha', 0, 0);
    scaleObject('shur', 0.7, 0.7);
	setScrollFactor('shur', 0, 0);
    setObjectCamera('shur', 'camGame');
    addLuaSprite('shur', true);
end
function onStepHit()
    if curStep == 1453 then
        setProperty('shur.alpha', 1);
        setProperty('gfGroup.alpha', 0);
        setProperty('dad.alpha', 0);
        objectPlayAnimation('shur', 'pop', true);
    end
end