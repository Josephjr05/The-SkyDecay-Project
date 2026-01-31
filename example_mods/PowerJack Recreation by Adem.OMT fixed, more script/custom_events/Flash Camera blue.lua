function onEvent(n,v1,v2)


	if n == 'Flash Camera blue' then

	   makeLuaSprite('flash', '', 0, 0);
        makeGraphic('flash',1280,720,'0000ff')
	      addLuaSprite('flash', true);
	      setLuaSpriteScrollFactor('flash',0,0)
		  setObjectCamera("flash", 'other')
	      setProperty('flash.scale.x',2)
	      setProperty('flash.scale.y',2)
	      setProperty('flash.alpha',0)
		setProperty('flash.alpha',1)

		doTweenAlpha('flTw','flash',0,v1,'linear')
	end



end