function forceOpponentUpScroll()
    for i = 0,3 do
        setPropertyFromGroup('opponentStrums', i, 'downScroll', false)
        setPropertyFromGroup('opponentStrums', i, 'y', 50)
    end
    for i = 0, getProperty('notes.length')-1 do
        if getPropertyFromGroup('notes', i, 'mustPress') == false then
            setPropertyFromGroup('notes', i, 'downScroll', false)
        end
    end
    for i = 0, getProperty('unspawnNotes.length')-1 do
        if getPropertyFromGroup('unspawnNotes', i, 'mustPress') == false then
            setPropertyFromGroup('unspawnNotes', i, 'downScroll', false)
        end
    end
end

function onCreatePost()
    forceOpponentUpScroll()
end

function onUpdatePost()
    forceOpponentUpScroll()
end