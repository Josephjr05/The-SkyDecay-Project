function onEvent(name)
	if name == 'Static' then
		makeAnimatedLuaSprite('static', 'Phase3Static', 0, 0);
		luaSpriteAddAnimationByPrefix('static', 'hello_there', 'Phase3Static instance 1' , 24, false)
		scaleLuaSprite('static', 4, 4)
		addLuaSprite('static', true)
		runTimer('staticpenis', 1.63);
		setObjectCamera('static', 'hud');
	end
end

function onTimerCompleted(tag, loops, loopsleft)
    if tag == 'staticpenis' then
		doTweenAlpha('remove', 'static', 0, 0.3, 'linear');
    end
end
    
function onTweenCompleted(tag)
    if tag == 'remove' then
		removeLuaSprite('static', true);
		cameraSetTarget('dad')
    end
end
