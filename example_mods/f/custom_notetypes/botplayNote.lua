function onCreate()
	for i = 0, getProperty('unspawnNotes.length') - 1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'botplayNote' then
			setPropertyFromGroup('unspawnNotes', i, 'noMissAnimation', true);
			setPropertyFromGroup('unspawnNotes', i, 'ratingDisabled', true);
			setPropertyFromGroup('unspawnNotes', i, 'ratingMod', 0);


			setPropertyFromGroup('unspawnNotes', i, 'multAlpha', 0.5)
			if not botPlay then
			setPropertyFromGroup('unspawnNotes', i, 'blockHit', true);
			setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true)
			else
				setPropertyFromGroup('unspawnNotes', i, 'blockHit', false);
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', false)
			end
			setPropertyFromGroup('unspawnNotes', i, 'hitCausesMiss', false);
		end
	end
end


function onUpdatePost()
    for i = 0, getProperty('notes.length')-1 do
        d = getPropertyFromGroup('notes',i,'noteData')
        if getPropertyFromGroup('notes', i, 'noteType') == 'botplayNote' and getSongPosition() >= getPropertyFromGroup('notes', i, 'strumTime') and not botPlay then
            runHaxeCode('game.goodNoteHit(game.notes.members['..i..']);')
            runHaxeCode('game.playerStrums.members['..d..'].playAnim(\'static\', true);')
        end
    end
end

function getRating(name, ratingMod)
    for i = 0, getProperty('ratingsData.length')-1 do
        if getProperty('ratingsData['..i..'].name') == name and not botPlay then
            return not ratingMod and getProperty('ratingsData['..i..'].score') or getProperty('ratingsData['..i..'].ratingMod')
        end
    end
end

function goodNoteHit(i, d, t, s)
    if t == 'botplayNote' and not botPlay then
        addScore(-getRating(getProperty('notes.members['..i..'].rating'), false))
         setProperty('totalNotesHit', getProperty('totalNotesHit') - getRating(getProperty('notes.members['..i..'].rating'), true))
    end
end