function onEvent(n,v1,v2)

	if n == 'Flash Camera (redi)' then
	   makeLuaSprite('flashRed', '', 0, 0);
        makeGraphic('flashRed',1280,720,'ff0000')
	      addLuaSprite('flashRed', true);
	      setLuaSpriteScrollFactor('flashRed',0,0)
	      setProperty('flashRed.scale.x',2)
	      setProperty('flashRed.scale.y',2)
	      setProperty('flashRed.alpha',0)
		setProperty('flashRed.alpha',v1)
		doTweenAlpha('flTwRed','flashRed',0,v2,'linear')
		setObjectCamera('flashRed', 'other');
		setObjectOrder('flashRed', getObjectOrder('bartop') - 2)
	end
	
end