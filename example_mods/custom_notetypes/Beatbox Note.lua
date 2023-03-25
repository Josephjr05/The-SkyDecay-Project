function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Beatbox Note' then --Check if the note on the chart is a Beatbox Note
			setPropertyFromGroup('unspawnNotes', i, 'hitHealth', '0.036'); --Default value is: 0.023, health gained on hit
			setPropertyFromGroup('unspawnNotes', i, 'missHealth', '0.0485'); --Default value is: 0.0475, health lost on miss

			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Doesn't let Dad/Opponent notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', false); --Miss has no penalties
			end
		end
	end
end

local beatboxAnims = {"beatLEFT", "beatDOWN", "beatUP", "beatRIGHT"}
function goodNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'Beatbox Note' then
		characterPlayAnim('dad', beatboxAnims[direction + 1], false);
		characterPlayAnim('boyfriend', beatboxAnims[direction + 1], false);
		setProperty('boyfriend.specialAnim', true);
		setProperty('dad.specialAnim', true);
    end
end