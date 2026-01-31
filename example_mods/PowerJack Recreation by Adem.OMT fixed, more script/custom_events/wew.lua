function onEvent(name, value1, value2)
	if name == 'wew' then
		makeLuaSprite('f', 'majinthing/'..value1,0, 0);
		screenCenter('f', 'xy')
		addLuaSprite('f', 'false');
		setObjectCamera('f', 'other');
		doTweenAlpha('f','f',0,0.4,'sineOut')
	end
end