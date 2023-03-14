function onCountdownStarted()
    for i=0,3 do

        setPropertyFromGroup('opponentStrums', i, 'texture', 'Kubaxon_Notes')

    end

    for i = 0, getProperty('unspawnNotes.length')-1 do

        if not getPropertyFromGroup('unspawnNotes', i, 'mustPress') then

            setPropertyFromGroup('unspawnNotes', i, 'texture', 'Kubaxon_Notes');

        end

    end

end
