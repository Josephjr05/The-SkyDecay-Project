sus = 360
line = 0.13
function onEvent(n, v1, v2)
	if n == 'speen' then
		setPropertyFromGroup('opponentStrums', 0, 'angle', 0)
		setPropertyFromGroup('opponentStrums', 1, 'angle', 0)
		setPropertyFromGroup('opponentStrums', 2, 'angle', 0)
		setPropertyFromGroup('opponentStrums', 3, 'angle', 0)
		setPropertyFromGroup('opponentStrums', 4, 'angle', 0)

		setPropertyFromGroup('playerStrums', 0, 'angle', 0)
		setPropertyFromGroup('playerStrums', 1, 'angle', 0)
		setPropertyFromGroup('playerStrums', 2, 'angle', 0)
		setPropertyFromGroup('playerStrums', 3, 'angle', 0)
		setPropertyFromGroup('playerStrums', 4, 'angle', 0)
		noteTweenAngle('A', 0, sus, line, 'circOut')
		noteTweenAngle('B', 1, sus, line, 'circOut')
		noteTweenAngle('C', 2, sus, line, 'circOut')
		noteTweenAngle('D', 3, sus, line, 'circOut')
		noteTweenAngle('E', 4, sus, line, 'circOut')

		noteTweenAngle('F', 5, sus, line, 'circOut')
		noteTweenAngle('J', 6, sus, line, 'circOut')
		noteTweenAngle('H', 7, sus, line, 'circOut')
		noteTweenAngle('I', 8, sus, line, 'circOut')
		end
end
