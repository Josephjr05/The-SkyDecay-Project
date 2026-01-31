function onCreate()
	makeAnimatedLuaSprite('sussyStatic', 'effects/Phase3Static', -500, -300)
	addAnimationByIndices('sussyStatic', 'e', 'Phase3Static instance', '0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38')
	scaleObject('sussyStatic', 19.2, 19.2)
	setObjectCamera('sussyStatic', 'hud')
	precacheImage('sussyStatic')
end

function onEvent(name, value1, value2)
	if name == 'trioStatic' then
		addLuaSprite('sussyStatic', false)
		objectPlayAnimation('sussyStatic', 'e', true)
		runTimer('delay', 1.61)
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'delay' then
		removeLuaSprite('sussyStatic', false)
	end
end