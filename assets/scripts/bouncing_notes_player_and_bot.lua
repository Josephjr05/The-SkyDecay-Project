local playerBop = true	

local bopStength = 28

local downToNega = 1

local relocatePosition = 571

note = true

timer = 0.5

function onCreatePost()
  playerRelocatePos = getPropertyFromGroup('strumLineNotes', direction,'y')
end

function directionProcessing(bopStength)

  return bopStength*downToNega
  
end

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


function onBeatHit()
	for i=3,0,-1 do
		opponentRelocatePos = getPropertyFromGroup('strumLineNotes', direction,'y')
		setPropertyFromGroup('strumLineNotes', i+0,'y',directionProcessing(bopStength)+opponentRelocatePos)
		noteTweenY('opponentBop'..i, i+0, opponentRelocatePos, 0.15,"circInOut")
	end
	
    for i = 1,4 do
          setPropertyFromGroup('strumLineNotes', i+3,'y',directionProcessing(bopStength)+playerRelocatePos)
          noteTweenY('playerBop'..i, i+3,playerRelocatePos, 0.15,"circInOut")
	end
	
		if note then
			noteTweenAngle('A', 0, 50, timer, 'circOut')
			noteTweenAngle('B', 1, 50, timer, 'circOut')
			noteTweenAngle('C', 2, 50, timer, 'circOut')
			noteTweenAngle('D', 3, 50, timer, 'circOut')

			noteTweenAngle('E', 4, 50, timer, 'circOut')
			noteTweenAngle('F', 5, 50, timer, 'circOut')
			noteTweenAngle('J', 6, 50, timer, 'circOut')
			noteTweenAngle('H', 7, 50, timer, 'circOut')
			
		else
		
			noteTweenAngle('A', 0, -50, timer, 'circOut')
			noteTweenAngle('B', 1, -50, timer, 'circOut')
			noteTweenAngle('C', 2, -50, timer, 'circOut')
			noteTweenAngle('D', 3, -50, timer, 'circOut')

			noteTweenAngle('E', 4, -50, timer, 'circOut')
			noteTweenAngle('F', 5, -50, timer, 'circOut')
			noteTweenAngle('J', 6, -50, timer, 'circOut')
			noteTweenAngle('H', 7, -50, timer, 'circOut')
		end
end

function onTweenCompleted(tag)
	if tag == 'A' then
		if note then
		
			noteTweenAngle('AB', 0, -50, timer, 'circOut')
			noteTweenAngle('BB', 1, -50, timer, 'circOut')
			noteTweenAngle('CB', 2, -50, timer, 'circOut')
			noteTweenAngle('DB', 3, -50, timer, 'circOut')

			noteTweenAngle('EB', 4, -50, timer, 'circOut')
			noteTweenAngle('FB', 5, -50, timer, 'circOut')
			noteTweenAngle('JB', 6, -50, timer, 'circOut')
			noteTweenAngle('HB', 7, -50, timer, 'circOut')
		
		else
				noteTweenAngle('AB', 0, 50, timer, 'circOut')
				noteTweenAngle('BB', 1, 50, timer, 'circOut')
				noteTweenAngle('CB', 2, 50, timer, 'circOut')
				noteTweenAngle('DB', 3, 50, timer, 'circOut')

				noteTweenAngle('EB', 4, 50, timer, 'circOut')
				noteTweenAngle('FB', 5, 50, timer, 'circOut')
				noteTweenAngle('JB', 6, 50, timer, 'circOut')
				noteTweenAngle('HB', 7, 50, timer, 'circOut')
		end
			if note then
				note = false
			else
				note = true
			end

	end
end