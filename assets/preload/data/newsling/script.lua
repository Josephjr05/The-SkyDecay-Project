function onCountdownStarted()
    for i=0,3 do

        setPropertyFromGroup('opponentStrums', i, 'texture', 'cuajak/Kubaxon_Notes/Kubaxon_Notes')

    end

    for i = 0, getProperty('unspawnNotes.length')-1 do

        if not getPropertyFromGroup('unspawnNotes', i, 'mustPress') then

            setPropertyFromGroup('unspawnNotes', i, 'texture', 'cuajak/Kubaxon_Notes/Kubaxon_Notes');

        end

    end

end
