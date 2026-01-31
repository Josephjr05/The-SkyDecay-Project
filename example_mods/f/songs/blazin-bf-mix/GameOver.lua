GameOverActive = false
function onCreate()

end

function onTimerCompleted(tag)
    if tag == 'restartShit' then
		restartSong(false)
	end
end

function videoShit()
	if not videoCheck then
		makeLuaSprite('deathVoid', '', -1000, -1000)
		makeGraphic('deathVoid', 1, 1, '000000')
		scaleObject('deathVoid', screenWidth+10000, screenHeight+10000)
		addLuaSprite('deathVoid', true);
		setObjectCamera('deathVoid', 'CamOther')
		playSound('Mornin')
		startVideo('BlazinGameOver', false) 
		runTimer('restartShit',1.6)
		videoCheck = true;
		return Function_Stop;
	end
	return Function_Continue;
end


function onGameOver()
	videoShit()
	GameOverActive = true
    if GameOverActive then
		for notesLength = 0, getProperty('notes.length') - 1 do
			setPropertyFromGroup('notes', notesLength, 'active', false)
			setPropertyFromGroup('notes', notesLength, 'canBeHit', false)
		end
		for eventNotes = 0, getProperty('eventNotes.length') - 1 do
			removeFromGroup('eventNotes', eventNotes, false)
			removeFromGroup('eventNotes', eventNotes, false)
		end
        return Function_Stop
    end
    return Function_Continue;
end

function onUpdate()
	if GameOverActive then
		setPropertyFromClass('PlayState', 'instance.generatedMusic', false)
		setPropertyFromClass('PlayState', 'instance.vocals.volume', 0)
		setPropertyFromClass('flixel.FlxG', 'sound.music.volume', 0)

		setProperty('dad.animation.curAnim.frameRate', 0)
		setProperty('boyfriend.animation.curAnim.frameRate', 0)
	end
end