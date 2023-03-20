function onCreatePost()
	--makeLuaSprite('vignette', 'vignette', 0, 0);
	--addLuaSprite('vignette', false);
	--setScrollFactor('vignette', 0, 0);
	--scaleObject('vignette', 0.334, 0.334);
	
	makeLuaText('scoreText', 'placeholder', getProperty('scoreTxt.width'), getProperty('scoreTxt.x'), getProperty('scoreTxt.y'))
	setProperty('scoreTxt.visible', false)
	setTextFont('scoreText', 'mousedrawn.otf')
	setTextColor('scoreText', 'CC6456')
	setTextBorder('scoreText', 3, '54251f')
	setTextSize('scoreText', 27)
	addLuaText('scoreText')
	setObjectCamera('scoreText', 'camOther')

	makeLuaSprite('hahadumb', 'hahadumb', 0, 0)

	setProperty('camHUD.visible', false)
	normal = getProperty('boyfriend.y')
	yvel = 10
	jumpy = false
	setProperty('boyfriend.y', normal - 180)

	debugPrint(normal)

	makeAnimatedLuaSprite('jumper', 'characters/bfJumpy', getProperty('boyfriend.x'), getProperty('boyfriend.y'))
	addAnimationByPrefix('jumper', 'idle', 'idle', 24, true)
	addAnimationByPrefix('jumper', 'walk', 'walk', 24, true)
	addAnimationByPrefix('jumper', 'jump', 'jump', 12, false)
	addLuaSprite('jumper', true)
	setProperty('boyfriend.visible', false)
end
function onSongStart()
end
function onUpdatePost(elapsed)
	songPos = getSongPosition()
	local currentBeat = (songPos/5000)*(curBpm/60)
	setProperty('cpuControlled', true)
	--[[noteTweenX('fake1', 0, ((screenWidth / 2) - (157 / 2)) + (math.sin((songPos/500) + (4) * 2) * 100), 0.0000001)
	noteTweenX('fake2', 1, ((screenWidth / 2) - (157 / 2)) + (math.sin((songPos/500) + (5) * 2) * 100), 0.0000001)
	noteTweenX('fake3', 2, ((screenWidth / 2) - (157 / 2)) + (math.sin((songPos/500) + (6) * 2) * 100), 0.0000001)
	noteTweenX('fake4', 3, ((screenWidth / 2) - (157 / 2)) + (math.sin((songPos/5090) + (7) * 2) * 100), 0.0000001)
	noteTweenX('fake5', 4, ((screenWidth / 2) - (157 / 2)) + (math.cos((songPos*5) + (4) * 2) * 100), 0.0000001)
	noteTweenX('fake6', 5, ((screenWidth / 2) - (157 / 2)) + (math.sin((songPos*5) + (5) * 2) * 100), 0.0000001)
	noteTweenX('fake7', 6, ((screenWidth / 2) - (157 / 2)) + (math.sin((songPos*5) + (6) * 2) * 100), 0.0000001)
	noteTweenX('fake8', 7, ((screenWidth / 2) - (157 / 2)) + (math.cos((songPos*5) + (7) * 2) * 100), 0.0000001)
	]]
	yvel = (yvel - 1)

	if getProperty('boyfriend.y') >= normal then
		yvel = 0
		jumpy = false
		if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.UP') then
			yvel = 25
			jumpy = true
			objectPlayAnimation('jumper', 'jump', true)
		end
	end
	if getPropertyFromClass('flixel.FlxG', 'keys.pressed.LEFT') then
		if jumpy == false then
			objectPlayAnimation('jumper', 'walk', false)
		end
		setProperty('jumper.flipX', false)
		setProperty('boyfriend.x', getProperty('boyfriend.x') - 15)
	elseif getPropertyFromClass('flixel.FlxG', 'keys.pressed.RIGHT') then
		if jumpy == false then
		objectPlayAnimation('jumper', 'walk', false)
		end
		setProperty('jumper.flipX', true)
		setProperty('boyfriend.x', getProperty('boyfriend.x') + 15)
	else
		if jumpy == false then
		objectPlayAnimation('jumper', 'idle', false)
		end
	end

	setProperty('boyfriend.y', getProperty('boyfriend.y') - yvel)

	TheBfX = getProperty('boyfriend.x')
	TheBfY = getProperty('boyfriend.y')

	setProperty('jumper.x', TheBfX)
	setProperty('jumper.y', TheBfY)

	if getPropertyFromClass('flixel.FlxG', 'keys.pressed.DOWN') then
		setProperty('jumper.scale.x', 1.2)
		setProperty('jumper.scale.y', 0.8)
		setProperty('jumper.y', TheBfY + 40)
	else
		setProperty('jumper.scale.x', 1)
		setProperty('jumper.scale.y', 1)
	end	


	setTextString('scoreText', 'SCORE: ' ..getProperty('songScore'))
end

function opponentNoteHit()
	--triggerEvent('Screen Shake', '5, 0.09', '0.1, 0.01');
	health = getProperty('health')
	if health > 0.002 then
		setProperty('health', health - 0.0010);	
	end
end
