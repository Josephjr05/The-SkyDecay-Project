function onEvent(name, value1, value2)
if name == 'animatedbgchange' then
   äniName = "F" + curBeat;
    makeAnimatedLuaSprite( value1, value2, 0, 0);
	addAnimationByPrefix(value1, aniName, value2);	
    addLuaSprite(value1, false);
	objectPlayAnimation(value1, aniName, true);
    
    
    end
	end
