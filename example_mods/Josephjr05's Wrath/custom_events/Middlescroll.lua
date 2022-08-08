function onEvent(name, value1, value2)
    if not middlescroll then
	    if value1 == '1' then
            setPropertyFromGroup('opponentStrums', 0, 'x', defaultOpponentStrumX0 - 10);
            setPropertyFromGroup('opponentStrums', 1, 'x', defaultOpponentStrumX1 + 30);
            setPropertyFromGroup('opponentStrums', 2, 'x', defaultOpponentStrumX2 + 600);
            setPropertyFromGroup('opponentStrums', 3, 'x', defaultOpponentStrumX3 + 640);
                setPropertyFromGroup('playerStrums', 0, 'x', defaultPlayerStrumX0 - 320);
                setPropertyFromGroup('playerStrums', 1, 'x', defaultPlayerStrumX1 - 320);
                setPropertyFromGroup('playerStrums', 2, 'x', defaultPlayerStrumX2 - 320);
                setPropertyFromGroup('playerStrums', 3, 'x', defaultPlayerStrumX3 - 320);
			end
        end

if value1 == '2' then
            setPropertyFromGroup('opponentStrums', 0, 'x', defaultOpponentStrumX0 + 320);
            setPropertyFromGroup('opponentStrums', 1, 'x', defaultOpponentStrumX1 + 320);
            setPropertyFromGroup('opponentStrums', 2, 'x', defaultOpponentStrumX2 + 320);
            setPropertyFromGroup('opponentStrums', 3, 'x', defaultOpponentStrumX3 + 320);
            setPropertyFromGroup('playerStrums', 0, 'x', defaultPlayerStrumX0 - 0);
            setPropertyFromGroup('playerStrums', 1, 'x', defaultPlayerStrumX1 - 0);
            setPropertyFromGroup('playerStrums', 2, 'x', defaultPlayerStrumX2 - 0);
            setPropertyFromGroup('playerStrums', 3, 'x', defaultPlayerStrumX3 - 0);
end

		if value1 == '0' then
            setPropertyFromGroup('opponentStrums', 0, 'x', defaultOpponentStrumX0 -0);
            setPropertyFromGroup('opponentStrums', 1, 'x', defaultOpponentStrumX1 -0);
            setPropertyFromGroup('opponentStrums', 2, 'x', defaultOpponentStrumX2 -0);
            setPropertyFromGroup('opponentStrums', 3, 'x', defaultOpponentStrumX3 -0);
            setPropertyFromGroup('playerStrums', 0, 'x', defaultPlayerStrumX0 - 0);
            setPropertyFromGroup('playerStrums', 1, 'x', defaultPlayerStrumX1 - 0);
            setPropertyFromGroup('playerStrums', 2, 'x', defaultPlayerStrumX2 - 0);
            setPropertyFromGroup('playerStrums', 3, 'x', defaultPlayerStrumX3 - 0);
		end
    end