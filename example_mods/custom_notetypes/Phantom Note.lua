local healthDrop = 0;
local FUCKYOU = 0;

function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Phantom Note' then --Check if the note on the chart is a Bullet Note
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'PHANTOMNOTE_assets');

			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Doesn't let Dad/Opponent notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true);
			end
		end
	end
end

function onCreatePost()
end

function onUpdate()
    setProperty('health', getProperty('health') - healthDrop); 
end

function onUpdatePost()
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'Phantom Note' then
		healthDrop = healthDrop + 0.00025;
		if healthDrop == 0.00025 then
			runTimer('BITCHLMAO', 0.1 , 1);
		else 
			FUCKYOU = 0;
		end
    end
end


function onTimerCompleted(tag, loops, loopsLeft)
	-- A loop from a timer you called has been completed, value "tag" is it's tag
	-- loops = how many loops it will have done when it ends completely
	-- loopsLeft = how many are remaining
	if tag == 'BITCHLMAO' then
		FUCKYOU = FUCKYOU + 1;
		if FUCKYOU >= 100 then
			healthDrop = 0;
		end
	end
end

