function onCreate()
	makeLuaSprite('limoSunset', 'stages/highway/limoSunset', -900, -300)
	setScrollFactor('limoSunset', 0.7, 0.8)

	makeAnimatedLuaSprite('limoRoad', 'stages/highway/limoRoad', -700, 340)
	setScrollFactor('limoRoad', 0.9, 0.9)
	addAnimationByPrefix('limoRoad', 'coolroad', 'COOLROAD')
	
	makeAnimatedLuaSprite('limoDrive', 'stages/highway/limoDrive', -300, 600)
	addAnimationByPrefix('limoDrive', 'limoStage', 'Limo stage')
	scaleObject('limoDrive', 1.1, 1.1)	

	limoY = 480 --i took this from a recreation of limo stage (sorry, i don't remember where i found it, but thanks for the one who did it)

	makeAnimatedLuaSprite('bgLimo', 'stages/highway/bgLimo', -130, limoY)
	addAnimationByPrefix('bgLimo', 'bglp', 'background limo pink')
	scaleObject('bgLimo', 1.1, 1.1)

	impX = 670 --sorry if the code sucks, i implemented my style so it's not a copy + paste
	makeAnimatedLuaSprite('limoDancer2', 'stages/highway/limoDancer', impX- 400, limoY- 385)
	addAnimationByIndices('limoDancer2', 'L', 'bg dancer sketch PINK', '0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14')
	addAnimationByIndices('limoDancer2', 'R', 'bg dancer sketch PINK', '15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29')

	makeAnimatedLuaSprite('limoDancer', 'stages/highway/limoDancer', impX, limoY- 385)
	addAnimationByIndices('limoDancer', 'L', 'bg dancer sketch PINK', '0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14')
	addAnimationByIndices('limoDancer', 'R', 'bg dancer sketch PINK', '15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29')

	makeAnimatedLuaSprite('limoDancer3', 'stages/highway/limoDancer', impX+ 400, limoY- 385)
	addAnimationByIndices('limoDancer3', 'L', 'bg dancer sketch PINK', '0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14')
	addAnimationByIndices('limoDancer3', 'R', 'bg dancer sketch PINK', '15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29')

	makeAnimatedLuaSprite('limoDancer4', 'stages/highway/limoDancer', impX+ 800, limoY- 385)
	addAnimationByIndices('limoDancer4', 'L', 'bg dancer sketch PINK', '0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14')
	addAnimationByIndices('limoDancer4', 'R', 'bg dancer sketch PINK', '15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29')

	addLuaSprite('limoSunset')
	addLuaSprite('limoRoad')
	addLuaSprite('bgLimo')
	addLuaSprite('limoDancer')
	addLuaSprite('limoDancer2')
	addLuaSprite('limoDancer3')
	addLuaSprite('limoDancer4')
	addLuaSprite('limoDrive')
end

function onsongStart()
	objectPlayAnimation('limoDancer', 'L', true)
end

function onBeatHit()
	leftDanced = (getProperty('limoDancer.animation.name') == 'L')
	rightDanced = (getProperty('limoDancer.animation.name') == 'R')

	if leftDanced then 
		objectPlayAnimation('limoDancer', 'R', true)
		objectPlayAnimation('limoDancer2', 'R', true)
		objectPlayAnimation('limoDancer3', 'R', true)
		objectPlayAnimation('limoDancer4', 'R', true)
	elseif rightDanced then
		objectPlayAnimation('limoDancer', 'L', true)
		objectPlayAnimation('limoDancer2', 'L', true)
		objectPlayAnimation('limoDancer3', 'L', true)
		objectPlayAnimation('limoDancer4', 'L', true)
	end
end --note: i hate you mommy mearest and you too bgLimo