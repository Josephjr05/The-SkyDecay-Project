-- WARNING: USES PSYCH ENGINE 0.6.1 AND LATER

-- Author: TheLeerName
-- Description: script makes possible to edit timeTxt private variable for time bar, to do it just edit timeBar variable, timeTxt and timeBarBG will edit too!

local savebartype = 'Disabled'
function onCreate()
	luaDebugMode = true
	savebartype = getPropertyFromClass('ClientPrefs', 'timeBarType')
	setPropertyFromClass('ClientPrefs', 'timeBarType', 'Disabled')
end
function onCreatePost()
	setPropertyFromClass('ClientPrefs', 'timeBarType', savebartype)

	makeLuaSprite('timeBarBG', 'timeBar', 0, 0)
	setScrollFactor('timeBarBG', 0, 0)
	setProperty('timeBarBG.alpha', 0)
	addLuaSprite('timeBarBG')
	setObjectCamera('timeBarBG', 'camHUD')

	makeLuaText('timeTxt', '', 400, tonumber(getStaticProperty('PlayState.STRUM_X')) + (screenWidth / 2) - 248, 19);
	setTextSize('timeTxt', 32)
	setTextFont('timeTxt', 'vcr.ttf')
	setTextColor('timeTxt', 'ffffff')
	setTextAlignment('timeTxt', 'center')
	setTextBorder('timeTxt', 2, '000000')
	setScrollFactor('timeTxt', 0, 0)
	setProperty('timeTxt.alpha', 0)
	if getPropertyFromClass('ClientPrefs', 'downScroll') then
		setProperty('timeTxt.y', screenHeight - 44)
	end
	if getPropertyFromClass('ClientPrefs', 'timeBarType') == 'Song Name' then
		setProperty('timeTxt.text', getStaticProperty('PlayState.SONG.song'))
		setTextSize('timeTxt', 24)
		setProperty('timeTxt.y', getProperty('timeTxt.y') + 3)
	end
	addLuaText('timeTxt')
	setObjectCamera('timeTxt', 'camHUD')

	setProperty('timeBarBG.x', getProperty('timeTxt.x'))
	setProperty('timeBarBG.y', getProperty('timeTxt.y') + (getProperty('timeTxt.height') / 4))

	runHaxeCode("game.timeBar.setParent(null, 'songPercent');")

	if getPropertyFromClass('ClientPrefs', 'timeBarType') == 'Disabled' then
		setProperty('timeTxt.visible', false)
		setProperty('timeBar.visible', false)
		setProperty('timeBarBG.visible', false)
	else
		setProperty('timeBar.visible', true)
	end

	addHaxeLibrary('Math')
	addHaxeLibrary('Conductor')
	addHaxeLibrary('ClientPrefs')
	addHaxeLibrary('FlxStringUtil', 'flixel.util')
end
function onSongStart()
	doTweenAlpha('die1', 'timeTxt', 1, 0.5, 'circOut')
	doTweenAlpha('die2', 'timeBar', 1, 0.5, 'circOut')
	doTweenAlpha('die3', 'timeBarBG', 1, 0.5, 'circOut')
end

function onEndSong()
	--setPropertyFromClass('ClientPrefs', 'timeBarType', savebartype)
end

function getStaticProperty(variable)
	runHaxeCode([[ game.introSoundsSuffix = '' + ]]..variable..[[; ]])
	local dat = getProperty('introSoundsSuffix');
	runHaxeCode([[ game.introSoundsSuffix = ''; ]])
	return dat;
end
function setStaticProperty(variable, value)
	runHaxeCode(variable..' = '..value..';')
end

function onUpdatePost()
	--print(getProperty('timeBar.visible'))
	if not getProperty('startingSong') and not getProperty('paused') then
		setProperty('timeTxt.x', getProperty('timeBar.x') - 4)
		setProperty('timeTxt.y', getProperty('timeBar.y') - 4 - (getProperty('timeTxt.height') / 4))
		setProperty('timeTxt.alpha', getProperty('timeBar.alpha'))
		setProperty('timeTxt.visible', getProperty('timeBar.visible'))
		setProperty('timeTxt.angle', getProperty('timeBar.angle'))

		setProperty('timeBarBG.x', getProperty('timeBar.x') - 4)
		setProperty('timeBarBG.y', getProperty('timeBar.y') - 4)
		setProperty('timeBarBG.alpha', getProperty('timeBar.alpha'))
		setProperty('timeBarBG.visible', getProperty('timeBar.visible'))
		setProperty('timeBarBG.angle', getProperty('timeBar.angle'))

		if getPropertyFromClass('ClientPrefs', 'timeBarType') ~= 'Disabled' then
			runHaxeCode([[
				var curTime = Conductor.songPosition - ClientPrefs.noteOffset;
				if(curTime < 0) curTime = 0;
				var songPercent = (curTime / FlxG.sound.music.length);

				var songCalc = (FlxG.sound.music.length - curTime);
				if(ClientPrefs.timeBarType == 'Time Elapsed') songCalc = curTime;

				var secondsTotal = Math.floor(songCalc / 1000);
				if(secondsTotal < 0) secondsTotal = 0;

				if(ClientPrefs.timeBarType != 'Song Name')
					game.modchartTexts.get('timeTxt').text = FlxStringUtil.formatTime(secondsTotal, false);
				
				game.timeBar.value = songPercent;
			]])
		end
	end
end