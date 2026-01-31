local defaultNotePos = {};
local spin = true;
local arrowMoveX = 0;
local arrowMoveY = 0;

function onSongStart()
    for i = 0,7 do
        x = getPropertyFromGroup('strumLineNotes', i, 'x')

        y = getPropertyFromGroup('strumLineNotes', i, 'y')

        table.insert(defaultNotePos, {x,y})
      --  debugPrint("{" .. x .. "," .. y .. "}" .. " i:".. i)
    end
end

function onUpdate(elapsed)
    songPos = getPropertyFromClass('Conductor',  'songPosition');

    currentBeat = (songPos / 1000) * (bpm / 60)

    if  spin == true then
        for i = 0,7 do
            setPropertyFromGroup('strumLineNotes', i, 'x', defaultNotePos[i + 1][1] + arrowMoveX * math.sin((currentBeat + i*0.25) * math.pi))

            setPropertyFromGroup('strumLineNotes', i, 'y', defaultNotePos[i + 1][2] + arrowMoveY * math.cos((currentBeat + i*0.25) * math.pi))
        end
    end
end

function onEvent(name,value1,value2)
	if name == 'shakey arrows' then 
		
		if value1 == 'normal' then
			arrowMoveX = 0;
            arrowMoveY = 0;
		end
		if value1 == 'little' then
            arrowMoveX = 10;
            arrowMoveY = 10;
        end
            if value1 == 'medium' then
                arrowMoveX = 30;
                arrowMoveY = 30;
            end
                if value1 == 'large' then
                    arrowMoveX = 70;
                    arrowMoveY = 50;
		end
	end
end
