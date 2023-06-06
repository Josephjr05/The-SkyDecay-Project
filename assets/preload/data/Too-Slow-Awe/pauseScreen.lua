--Made by Gavman22
--Keep in mind this is very unoptimized
--Also press Escape if you want the normal pause screen
fakePaused = false
cSelected = false
rSelected = false
eSelected = false

canPause = true




function onGameOver()

canPause = false



end


function onPause()
	-- Called when you press Pause while not on a cutscene/etc
	-- return Function_Stop if you want to stop the player from pausing the game
	return Function_Stop;
end



function onCreate()
	luaDebugMode = true
	precacheSound('pauseSounds/pause')
	precacheSound('pauseSounds/pauseScrollMenu')
	precacheSound('pauseSounds/unpause')
	makeLuaSprite('funniblackbg', '', 0, 0)
	makeGraphic('funniblackbg', 1280, 720, '000000')
	addLuaSprite('funniblackbg', true)
	setObjectCamera('funniblackbg', 'camOther')
	setProperty('funniblackbg.alpha', 0.4)
	setProperty('funniblackbg.visible', false)
	makeLuaSprite('pauseRight', 'pauseScreen/pauseRight', 800, 0)
	addLuaSprite('pauseRight', true)
	setObjectCamera('pauseRight', 'camOther')
	makeLuaSprite('pauseLeft', 'pauseScreen/pauseLeft', -800, 0)
	addLuaSprite('pauseLeft', true)
	setObjectCamera('pauseLeft', 'camOther')
	makeLuaSprite('fakeTimeBar', '', -1007, 203)
	makeGraphic('fakeTimeBar', 390, 11, 'FF0000')
	addLuaSprite('fakeTimeBar', true)
	setObjectCamera('fakeTimeBar', 'camOther')
	makeLuaSprite('continue', 'pauseScreen/Continue', 800, 0)
	addLuaSprite('continue', true)
	setObjectCamera('continue', 'camOther')
	makeLuaSprite('restart', 'pauseScreen/Restart', 800, 0)
	addLuaSprite('restart', true)
	setObjectCamera('restart', 'camOther')
	makeLuaSprite('exist', 'pauseScreen/Exit', 800, 0)
	addLuaSprite('exist', true)
	setObjectCamera('exist', 'camOther')
end
function onCreatePost()
	makeAnimatedLuaSprite('pauseIcon', nil, -800, 140)
	loadGraphic('pauseIcon', 'icons/'..getProperty('boyfriend.healthIcon'), 150)
	addAnimation('pauseIcon', 'icon/'..getProperty('boyfriend.healthIcon'), {0, 1}, 0, true)
	setObjectCamera('pauseIcon', 'other')
	addLuaSprite('pauseIcon')
	setObjectOrder('pauseIcon', getObjectOrder('pauseLeft')+1)
	setProperty('pauseIcon.angle', 180)
end
function onUpdatePost(elapsed)
	if keyJustPressed('accept') and fakePaused == false and not getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SPACE') and canPause then
		playSound('pauseSounds/pause', 0.8, 'pause')
		doTweenX('pauseRightTween', 'pauseRight', 0, 0.2, 'linear')
		doTweenX('pauseLeftTween', 'pauseLeft', 0, 0.2, 'linear')
		doTweenX('fakeTimeBarTween', 'fakeTimeBar', 207, 0.2, 'linear')
		doTweenX('pauseIconTween', 'pauseIcon', 65, 1, 'circInOut')
		doTweenAngle('pauseIconTweenAng', 'pauseIcon', 0, 1, 'circInOut')
		doTweenX('cTween', 'continue', 0, 0.2, 'linear')
		doTweenX('rTween', 'restart', 0, 0.2, 'linear')
		doTweenX('eTween', 'exist', 0, 0.2, 'linear')
		cSelected = true
		rSelected = false
		eSelected = false
		fakePaused = true
	elseif keyJustPressed('accept') and fakePaused == true and not getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SPACE') and canPause then
		plsHelp()
	end
	if cSelected == false then
		setProperty('continue.y', 0)
	end
	if cSelected == true then
		doTweenY('cTweenY', 'continue', -15, 0.07, 'circInOut')
	end
	if rSelected == false then
		setProperty('restart.y', 0)
	end
	if rSelected == true then
		doTweenY('rTweenY', 'restart', -15, 0.07, 'circInOut')
	end
	if eSelected == false then
		setProperty('exist.y', 0)
	end
	if eSelected == true then
		doTweenY('eTweenY', 'exist', -15, 0.07, 'circInOut')
	end
	if fakePaused == true then
		setProperty('funniblackbg.visible', true)
		setPropertyFromClass('Conductor', 'songPosition', getPropertyFromClass('Conductor', 'songPosition') - elapsed * 1000  ) -- it is counted by milliseconds, 1000 = 1 second
		setPropertyFromClass('flixel.FlxG', 'sound.music.time', getPropertyFromClass('Conductor', 'songPosition'))
		setProperty('vocals.time', getPropertyFromClass('Conductor', 'songPosition'))
		setPropertyFromClass('flixel.FlxG', 'sound.music.volume', 0)
		setProperty('vocals.volume', 0)
	elseif fakePaused == false and canPause then
		setProperty('funniblackbg.visible', false)
		setPropertyFromClass('flixel.FlxG', 'sound.music.volume', 1)
		
	end
	scaleObject('fakeTimeBar', 1 * getProperty("songPercent"), 1)
	damnIWannaDie()
	
end
function damnIWannaDie()
	if keyJustPressed('down') and fakePaused == true then
		if cSelected == true then
			cSelected = false
			rSelected = true
			playSound('pauseSounds/pauseScrollMenu', 0.3, 'pausescroll')
		elseif rSelected == true then
			rSelected = false
			eSelected = true
			playSound('pauseSounds/pauseScrollMenu', 0.3, 'pausescroll')
		elseif eSelected == true then
			eSelected = false
			cSelected = true
			playSound('pauseSounds/pauseScrollMenu', 0.3, 'pausescroll')
		end
	elseif keyJustPressed('up') and fakePaused == true then
		if cSelected == true then
			cSelected = false
			eSelected = true
			playSound('pauseSounds/pauseScrollMenu', 0.3, 'pausescroll')
		elseif rSelected == true then
			rSelected = false
			cSelected = true
			playSound('pauseSounds/pauseScrollMenu', 0.3, 'pausescroll')
		elseif eSelected == true then
			eSelected = false
			rSelected = true
			playSound('pauseSounds/pauseScrollMenu', 0.3, 'pausescroll')
		end
	end
end
function plsHelp()
	if cSelected == true then
		playSound('pauseSounds/unpause', 1, 'unpause')
		setProperty('vocals.volume', 1)
		setPropertyFromClass('flixel.FlxG', 'sound.music.volume', 1)
		doTweenX('pauseRightTween2', 'pauseRight', 800, 0.2, 'linear')
		doTweenX('pauseLeftTween2', 'pauseLeft', -800, 0.2, 'linear')
		doTweenX('fakeTimeBarTween2', 'fakeTimeBar', -800, 0.2, 'linear')
		doTweenX('cTween2', 'continue', 800, 0.2, 'linear')
		doTweenX('rTween', 'restart', 800, 0.2, 'linear')
		doTweenX('eTween', 'exist', 800, 0.2, 'linear')
		doTweenX('pauseIconTween', 'pauseIcon', -800, 1, 'circInOut')
		doTweenAngle('pauseIconTweenAng', 'pauseIcon', 180, 1, 'circInOut')
		cSelected = false
		rSelected = false
		eSelected = false
		fakePaused = false
	elseif rSelected == true then
		restartSong(true);
	elseif eSelected == true then
		exitSong(true)
	end
end