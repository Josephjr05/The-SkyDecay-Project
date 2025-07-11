-- 300x150 icons recommended
local frame = 150 -- write half the width of your icon image
function onEvent(n,a,b)
  if n == 'Change Character' then

mal = getProperty('iconP1.animation.name')
mal2 = getProperty('iconP2.animation.name')
	makeAnimatedLuaSprite('simge1',nil, getProperty('iconP1.x'), getProperty('iconP1.y'))
	loadGraphic('simge1','icons/icon-'..mal, frame)
	addAnimation('simge1','icons/icon-'..mal, {0, 1}, 0, true)
	addAnimation('simge1','icons/icon-'..mal, {1, 0}, 0, true)
	setObjectCamera('simge1', 'hud')
	setObjectOrder('simge1', getObjectOrder('iconP1') + 1)

	addLuaSprite('simge1', true)

	makeAnimatedLuaSprite('simge2',nil, getProperty('iconP2.x'), getProperty('iconP2.y'))
	loadGraphic('simge2','icons/icon-'..mal2, frame)
	addAnimation('simge2','icons/icon-'..mal2, {0, 1}, 0, true)
	addAnimation('simge2','icons/icon-'..mal2, {1, 0}, 0, true)
	setObjectCamera('simge2', 'hud')
	setObjectOrder('simge2', getObjectOrder('iconP2') + 1)

	addLuaSprite('simge2', true)


end
end
    
function onSongStart()

mal = getProperty('iconP1.animation.name')
mal2 = getProperty('iconP2.animation.name')
	makeAnimatedLuaSprite('simge1',nil, getProperty('iconP1.x'), getProperty('iconP1.y'))
	loadGraphic('simge1','icons/icon-'..mal, frame)
	addAnimation('simge1','icons/icon-'..mal, {0, 1}, 0, true)
	addAnimation('simge1','icons/icon-'..mal, {1, 0}, 0, true)
	setObjectCamera('simge1', 'hud')
	setObjectOrder('simge1', getObjectOrder('iconP1') + 1)

	addLuaSprite('simge1', true)

	makeAnimatedLuaSprite('simge2',nil, getProperty('iconP2.x'), getProperty('iconP2.y'))
	loadGraphic('simge2','icons/icon-'..mal2, frame)
	addAnimation('simge2','icons/icon-'..mal2, {0, 1}, 0, true)
	addAnimation('simge2','icons/icon-'..mal2, {1, 0}, 0, true)
	setObjectCamera('simge2', 'hud')
	setObjectOrder('simge2', getObjectOrder('iconP2') + 1)

	addLuaSprite('simge2', true)

	setProperty('iconP1.alpha', 0)
	setProperty('iconP2.alpha', 0)
end
function onUpdate()
	setProperty('simge1.angle', getProperty('iconP1.angle'))
	setProperty('simge1.scale.x', getProperty('iconP1.scale.x'))
	setProperty('simge1.scale.y', getProperty('iconP1.scale.y'))
	setProperty('simge1.flipX', true)
        doTweenX('simge1', 'simge1', getProperty('iconP1.x'), 0.1, 'linear')
	setProperty('simge2.angle', getProperty('iconP2.angle'))
	setProperty('simge2.scale.x', getProperty('iconP2.scale.x'))
	setProperty('simge2.scale.y', getProperty('iconP2.scale.y'))
        doTweenX('simge2', 'simge2', getProperty('iconP2.x'), 0.1, 'linear')


	if getProperty('health') > 1.6 then
		setProperty('simge2.animation.curAnim.curFrame', '1')
end
	if getProperty('health') < 1.6 then
		setProperty('simge2.animation.curAnim.curFrame', '0')
end
	if getProperty('health') < 0.4 then
		setProperty('simge1.animation.curAnim.curFrame', '1')
end
	if getProperty('health') > 0.4 then
		setProperty('simge1.animation.curAnim.curFrame', '0')
end
end
