function onCreate()
    makeAnimatedLuaSprite('sumky', 'exe/sunky/sunker', 250, 0);
    addAnimationByPrefix('sumky', 'brrr', 'sunker', 24, false);
    setObjectCamera('sumky', 'camHud')
    scaleObject('sumky', 5, 5);
    addLuaSprite('sumky', true);
    setProperty('sumky.alpha', 0);

    makeLuaSprite('loops', 'exe/sunky/cereal', -600, 50);
    setObjectCamera('loops', 'other');
    setObjectOrder('loops', getObjectOrder('blackbox')-2)		
    setProperty('loops.alpha', 0);
    addLuaSprite('loops', true);

    makeLuaSprite('dio', 'exe/sunky/Munch', 600, -650);
    setObjectCamera('dio', 'other');	
    setObjectOrder('dio', getObjectOrder('blackbox')-2)
    addLuaSprite('dio', true);	
end

function onEvent(name, value1, value2)
    if name == 'spawnsunker' then

        if value1 == 'sunker' then
    setProperty('sumky.alpha', 0.8);
    playAnim('sumky', 'brrr');	
    doTweenAngle('brr','sumky',360, 1,'circInout')

        elseif value1 == 'cereal' then
    setProperty('loops.alpha', 1);	
    doTweenX('go','loops',1350, 8,'linear')
    
        elseif value1 == 'munch' then
        setProperty('dio.alpha', 1);	
        doTweenY('omom','dio',1000, 8,'linear')
        end
    end
end

function onTweenCompleted(tag)
	if tag == 'brr' then
removeLuaSprite('sumky',true)
    end

if tag == 'go' then
    removeLuaSprite('loops',true)
    end

	if tag == 'omom' then
        setProperty('dio.alpha', 0);
        removeLuaSprite('dio',true)
        end
    end