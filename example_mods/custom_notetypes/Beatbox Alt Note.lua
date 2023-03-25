function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Beatbox Alt Note' then --Check if the note on the chart is a Beatbox Alt Note
			setPropertyFromGroup('unspawnNotes', i, 'hitHealth', '0.036'); --Default value is: 0.023, health gained on hit
			setPropertyFromGroup('unspawnNotes', i, 'missHealth', '0.0485'); --Default value is: 0.0475, health lost on miss

			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Doesn't let Dad/Opponent notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', false); --Miss has no penalties
			end
		end
	end
end

local altbeatboxAnims = {"beatLEFT-alt", "beatDOWN-alt", "beatUP-alt", "beatRIGHT-alt"}
function goodNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'Beatbox Alt Note' then
		characterPlayAnim('dad', altbeatboxAnims[direction + 1], false);
		characterPlayAnim('boyfriend', altbeatboxAnims[direction + 1], false);
		setProperty('boyfriend.specialAnim', true);
		setProperty('dad.specialAnim', true);
    end
end