note = true

timer = 0.5

local bopStength = 28

local downToNega = 1

function onCreate()
	if getPropertyFromClass('Conductor', 'bpm') < 100 then
		timer = 0.5
	end
	if getPropertyFromClass('Conductor', 'bpm') > 100 and getPropertyFromClass('Conductor', 'bpm') < 155 then
		timer = 0.3
	end
	if getPropertyFromClass('Conductor', 'bpm') > 155 then
		timer = 0.15
	end
end

function directionProcessing(bopStength)
  return bopStength*downToNega
end

function onBeatHit()

	for i=3,0,-1 do
		opponentRelocatePos = getPropertyFromGroup('strumLineNotes', direction,'y')
		setPropertyFromGroup('strumLineNotes', i+0,'y',directionProcessing(bopStength)+opponentRelocatePos)
		noteTweenY('opponentBop'..i, i+0, opponentRelocatePos, 0.15,"circInOut")
	end
	
		if note then
			noteTweenAngle('A', 0, 50, timer, 'circOut')
			noteTweenAngle('B', 1, 50, timer, 'circOut')
			noteTweenAngle('C', 2, 50, timer, 'circOut')
			noteTweenAngle('D', 3, 50, timer, 'circOut')

			
		else
		
			noteTweenAngle('A', 0, -50, timer, 'circOut')
			noteTweenAngle('B', 1, -50, timer, 'circOut')
			noteTweenAngle('C', 2, -50, timer, 'circOut')
			noteTweenAngle('D', 3, -50, timer, 'circOut')

		end
	--end
end

function onTweenCompleted(tag)
	if tag == 'A' then
		if note then
		
			noteTweenAngle('AB', 0, -50, timer, 'circOut')
			noteTweenAngle('BB', 1, -50, timer, 'circOut')
			noteTweenAngle('CB', 2, -50, timer, 'circOut')
			noteTweenAngle('DB', 3, -50, timer, 'circOut')
		
		else
				noteTweenAngle('AB', 0, 50, timer, 'circOut')
				noteTweenAngle('BB', 1, 50, timer, 'circOut')
				noteTweenAngle('CB', 2, 50, timer, 'circOut')
				noteTweenAngle('DB', 3, 50, timer, 'circOut')

		end
			if note then
				note = false
			else
				note = true
			end

	end
end