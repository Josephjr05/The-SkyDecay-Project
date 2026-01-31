function onCreate()
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'staticNote' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'staticNotes');
			setPropertyFromGroup('unspawnNotes', i, 'hitCausesMiss', false);

			makeAnimatedLuaSprite('hitstatic2', 'hitstatic', 0, 0)
			addAnimationByPrefix('hitstatic2','staticthing2','staticANIMATION',24,false)
			scaleObject('hitstatic2', 1, 1)
			setLuaSpriteScrollFactor('hitstatic2',0,0)
			setObjectCamera('hitstatic2', 'camother')
			
		end
	end
end

function noteMiss(id, noteData, noteType, isSustainNote)
	if noteType == 'staticNote' then
        playSound('hitStatic1')
		triggerEvent('Missed Static Note', 'amongUs', 'amongUs')
		objectPlayAnimation('hitstatic2','staticthing2',true)
		addLuaSprite('hitstatic2',true)
		runTimer('BITCHLMAO', 0.20 , 0.3);
	end

	function onTimerCompleted(tag, loops, loopsLeft)
		-- A loop from a timer you called has been completed, value "tag" is it's tag
		-- loops = how many loops it will have done when it ends completely
		-- loopsLeft = how many are remaining
		if tag == 'BITCHLMAO' then
			removeLuaSprite('hitstatic2',false)

			end
		end
	end