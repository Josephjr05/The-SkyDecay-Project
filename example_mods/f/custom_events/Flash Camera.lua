function onCreatePost()
		makeLuaSprite('flash', '', 0, 0);
		makeGraphic('flash', 1, 1, 'ffffff')
		scaleObject('flash', screenWidth * 1.1, screenHeight * 1.1)
		setObjectCamera('flash', 'other')
		addLuaSprite('flash', true);
		setProperty('flash.alpha', 0)
end

function onEvent(n, v1, v2)
	if n == 'Flash Camera' then
		setProperty('flash.alpha', 1)
		doTweenAlpha('flTw', 'flash', 0, 0.8, 'linear')
	end
end
