function onEvent(n,v1,v2)


	if n == 'whitedick' then

	makeLuaSprite('flash', 'white', -700, -300);
	      addLuaSprite('flash', false);
	      setLuaSpriteScrollFactor('flash',0,0)
	      setProperty('flash.scale.x',20)
	      setProperty('flash.scale.y',20)
	      setProperty('flash.alpha',0)
		setProperty('flash.alpha',1)
		doTweenAlpha('flTw','flash',0,v1,'linear')
	end



end