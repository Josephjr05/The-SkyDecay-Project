function onCreate()
	makeLuaSprite('credits', 'ivy', -360, 150);
	setScrollFactor('credits', 0.9, 1.6);
	scaleObject('credits', 0.6, 0.6);
	setObjectCamera('credits', 'other')
	addLuaSprite('credits', true);
     
end

function onStepHit()
	if curStep == 1 then
  	doTweenX('creditsTweenX', 'credits', 0, 0.9, 'cubeIn')
	end
	if curStep == 35 then
  	doTweenX('creditsTweenX', 'credits', -460, 1.6, 'cubeOut')
	end
	if curStep == 42 then
		setProperty('credits.visible', false);
	end
end
