function onEvent(n,v1,v2)

	if n == 'Flash Camera (n word)' then
	   makeLuaSprite('flashBlack', '', 0, 0);
        makeGraphic('flashBlack',1280,720,'000000')
	      addLuaSprite('flashBlack', true);
	      setLuaSpriteScrollFactor('flashBlack',0,0)
	      setProperty('flashBlack.scale.x',2)
	      setProperty('flashBlack.scale.y',2)
	      setProperty('flashBlack.alpha',0)
		setProperty('flashBlack.alpha',v1)
		doTweenAlpha('flTwBraki','flashBlack',0,v2,'linear')
		setObjectCamera('flashBlack', 'other');
		setObjectOrder('flashBlack', getObjectOrder('flashRed') - 4)
	end
end